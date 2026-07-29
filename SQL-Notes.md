# SQL 学习笔记：语法、思路与母题

这份笔记不只记录“某个函数怎么写”，更重要的是建立从题目描述到 SQL 结构的转换框架。

---

# 一、SQL 母题：先判断题目属于哪一种结构

拿到题目时，先问四个问题：

1. **最终一行代表什么对象？** 是一条原始记录、一个用户、一个部门、一个日期，还是一个“用户 × 商品”的组合？
2. **是否需要压缩行数？** 如果需要，通常是 `GROUP BY`；如果不需要但要组内计算，通常是窗口函数。
3. **答案依赖当前行、同组其他行，还是另一张表？** 这决定使用筛选、关联子查询、窗口函数或 `JOIN`。
4. **题目要的是数量、完整记录、名次、缺失组合，还是“全部满足”？** 这决定聚合、组内取代表行、排名、完整空间或全集覆盖。

## 1. 原始记录筛选

**问题本质：** 从现有行中保留满足条件的行，不改变一行所代表的对象。

常见信号：

- 大于、小于、介于；
- 属于若干类别；
- 文本以某内容开头、结尾或符合某种格式；
- 日期位于某个范围；
- 字段是否为 `NULL`。

常用工具：

```sql
WHERE
AND / OR
BETWEEN
IN
LIKE
REGEXP_LIKE
IS NULL / IS NOT NULL
```

---

## 2. 关系匹配

**问题本质：** 当前答案需要把两个对象之间的关系接起来。

常见信号：

- 员工属于哪个部门；
- 客户对应哪些订单；
- 员工对应经理；
- 开始记录对应结束记录；
- 当前区间匹配落入其中的交易记录。

常用工具：

```sql
INNER JOIN
LEFT JOIN
SELF JOIN
非等值 JOIN
ON
```

判断重点：

- 左表是否必须全部保留？若是，考虑 `LEFT JOIN`；
- 连接条件是身份相等、时间区间，还是顺序关系？
- 条件属于“如何匹配”时放在 `ON`，属于“连接后保留哪些结果”时放在 `WHERE`。

---

## 3. 分组汇总

**问题本质：** 多行压缩成一行，最终一行代表一个组。

常见信号：

- 每个用户、部门、日期、产品；
- 数量、总和、平均值、最大值、最小值；
- 不同对象的数量。

常用工具：

```sql
GROUP BY
COUNT
SUM
AVG
MIN
MAX
COUNT(DISTINCT column)
HAVING
```

核心问题：

> 最终每一行代表什么组？

`SELECT` 中的非聚合字段，通常都应当出现在 `GROUP BY` 中。

---

## 4. 存在与反存在

**问题本质：** 对当前对象，检查是否能够找到另一条满足条件的记录。

常见信号：

- 至少存在一条；
- 曾经发生过；
- 找得到另一个相同值的对象；
- 从未发生；
- 不存在重复位置或冲突记录。

常用工具：

```sql
EXISTS
NOT EXISTS
```

模板：

```sql
SELECT *
FROM table_a AS a
WHERE EXISTS (
    SELECT 1
    FROM table_b AS b
    WHERE b.key = a.key
      AND other_condition
);
```

`EXISTS` 只关心内部查询是否返回至少一行，因此通常写 `SELECT 1`。

---

## 5. 组内特殊记录

**问题本质：** 每组不只需要一个统计值，而是需要“那一条完整记录”。

常见信号：

- 每个产品第一次销售记录；
- 每个用户最新一次状态；
- 每个邮箱保留最小 `id`；
- 每组最大值对应的完整行。

常用方法：

### 方法 A：聚合后回表或多列匹配

```sql
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year)
    FROM Sales
    GROUP BY product_id
)
```

### 方法 B：窗口函数编号

```sql
SELECT *
FROM (
    SELECT
        t.*,
        ROW_NUMBER() OVER (
            PARTITION BY group_key
            ORDER BY sort_key
        ) AS rn
    FROM table_name AS t
) AS ranked
WHERE rn = 1;
```

### 方法 C：关联子查询 + 排序 + `LIMIT 1`

适合按外层每个对象寻找最近一条历史记录。

---

## 6. 跨行比较与顺序关系

**问题本质：** 当前行的答案取决于前一行、后一行、较早记录或同一顺序之前的多行。

常见信号：

- 比前一天更高；
- 连续登录；
- 截至当前的累计值；
- 当前记录与上一条记录比较；
- 找出断点、连续区间。

常用工具：

```sql
SELF JOIN
DATEDIFF
DATE_ADD
非等值 JOIN
LAG / LEAD
SUM(...) OVER (... ORDER BY ...)
```

---

## 7. 排名与组内 Top N

**问题本质：** 按某种顺序给记录或不同数值分配名次，再取指定名次。

常见信号：

- 第二高；
- 前三名；
- 每个部门工资最高的三档；
- 每组第一条记录。

常用工具：

```sql
ORDER BY ... LIMIT ... OFFSET ...
ROW_NUMBER()
RANK()
DENSE_RANK()
```

选择原则：

- 每行必须获得唯一顺序：`ROW_NUMBER()`；
- 并列后跳号：`RANK()`；
- 并列后不跳号：`DENSE_RANK()`。

---

## 8. 完整空间构造与缺失检测

**问题本质：** 原表只记录“发生过的事实”，但题目要求展示所有理论上可能的组合，包括没有发生的组合。

常见信号：

- 所有学生 × 所有科目；
- 每个用户在每个月都要出现；
- 没有订单也必须显示 0；
- 找出缺失组合。

常用结构：

```sql
CROSS JOIN
LEFT JOIN
COUNT(right_table.id)
IS NULL
COALESCE / IFNULL
```

典型流程：

```text
先用 CROSS JOIN 生成完整组合
→ LEFT JOIN 实际记录
→ 聚合计数或筛选 NULL
```

---

## 9. 全集覆盖

**问题本质：** 判断某个对象是否覆盖了全集中的每一种元素。

常见信号：

- 买过所有产品；
- 修完全部必修课；
- 满足所有条件；
- 不存在任何未覆盖元素。

常用方法：

### 方法 A：不同值数量等于全集数量

```sql
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (
    SELECT COUNT(*)
    FROM Product
);
```

### 方法 B：双重 `NOT EXISTS`

逻辑是：不存在任何一个全集元素，是当前对象没有覆盖的。

---

# 二、复合母题

## 1. 连续区间（Islands and Gaps）

```text
跨行比较 / 前后关系
+ 识别断点
+ 分组汇总
```

先判断当前行是否与上一行连续，再把连续记录归入同一组，最后求每组起点、终点或长度。

## 2. 去重

```text
组内特殊记录
或
组内排名 + 筛选 / 删除
```

保留规则可能是最小 `id`、最大时间、优先级最高的状态等。

## 3. 时间匹配与有效期匹配

```text
关系匹配
+ 时间范围筛选
+ 组内取最近 / 最新记录
```

例如：为每次交易匹配当时生效的价格，或寻找目标日期之前最近一次价格。

## 4. 行列转换

```text
分组汇总
+ 条件聚合
```

```sql
SUM(CASE WHEN category = 'A' THEN amount ELSE 0 END)
```

把原本位于多行中的类别转换为多列结果。

## 5. 层级关系

```text
关系匹配
+ SELF JOIN
```

单层经理关系可用自连接；多层组织树通常需要递归 CTE，这是后续进阶内容。

## 6. 累计值

```text
跨行顺序关系
+ 聚合
```

可以使用非等值自连接，也可以使用窗口累计：

```sql
SUM(amount) OVER (
    ORDER BY event_time
)
```

## 7. 缺失记录

```text
完整空间构造
+ LEFT JOIN
+ 反存在 / NULL 检测
```

---

# 三、SQL 查询的标准书写顺序

```sql
SELECT
FROM
JOIN
ON
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
OFFSET;
```

完整骨架：

```sql
SELECT column_1, aggregate_function(column_2)
FROM table_a
JOIN table_b
    ON join_condition
WHERE row_condition
GROUP BY column_1
HAVING group_condition
ORDER BY column_1
LIMIT number
OFFSET number;
```

大致逻辑执行顺序：

```text
FROM
JOIN
ON
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT
OFFSET
```

因此，`SELECT` 中刚创建的窗口函数别名，通常不能直接在同一层的 `WHERE` 中使用。

---

# 四、SELECT 与常用表达式

## 1. 基本选择、去重与别名

```sql
SELECT *
FROM Movies;

SELECT title, year
FROM Movies;

SELECT DISTINCT country
FROM Movies;

SELECT title AS movie_title
FROM Movies;
```

`DISTINCT` 对所有被选择字段的组合去重：

```sql
SELECT DISTINCT building_name, role
FROM Employees;
```

## 2. SELECT 可以不写 FROM

MySQL 可以直接输出固定值或表达式：

```sql
SELECT 100;
SELECT 10 + 20 AS result;
SELECT NULL AS missing_value;
```

这在“外层只负责包装一个标量子查询”时很有用：

```sql
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```

内层找不到结果时，标量子查询变成 `NULL`，外层仍然返回一行。

## 3. 数学与聚合

```sql
ROUND(number, decimal_places)
COUNT(*)
COUNT(column)
COUNT(DISTINCT column)
MIN(column)
MAX(column)
AVG(column)
SUM(column)
```

区别：

```text
COUNT(*)                   所有行
COUNT(column)              column 非 NULL 的行
COUNT(DISTINCT column)     不同且非 NULL 的值
```

## 4. CASE WHEN 与条件聚合

```sql
CASE
    WHEN condition THEN result
    ELSE other_result
END
```

条件计数：

```sql
SUM(
    CASE
        WHEN state = 'approved' THEN 1
        ELSE 0
    END
)
```

或：

```sql
COUNT(
    CASE
        WHEN state = 'approved' THEN 1
    END
)
```

## 5. NULL 替换

```sql
IFNULL(value, replacement)
COALESCE(value_1, value_2, value_3)
```

`IFNULL` 只能替换已经存在的一行中的 `NULL`，不能把“零行结果”变成一行。零行转 `NULL` 可以利用外层标量 `SELECT`。

---

# 五、字符串处理

## 1. 大小写转换

```sql
UPPER(text)
LOWER(text)
```

## 2. 从左侧截取

```sql
LEFT(text, length)
```

例如：

```sql
LEFT(name, 1)
```

表示取第一个字符。

## 3. 截取子字符串

```sql
SUBSTRING(text, start_position)
SUBSTRING(text, start_position, length)
```

MySQL 的字符位置从 `1` 开始。

```sql
SUBSTRING('aLiCe', 2)       -- LiCe
SUBSTRING('abcdef', 2, 3)   -- bcd
```

## 4. 拼接字符串

```sql
CONCAT(value_1, value_2, ...)
```

首字母大写、其余小写：

```sql
CONCAT(
    UPPER(LEFT(name, 1)),
    LOWER(SUBSTRING(name, 2))
)
```

## 5. LIKE

```sql
LIKE 'Toy%'
LIKE '%Toy'
LIKE '%Toy%'
LIKE 'AN_'
```

```text
%    任意数量字符
_    恰好一个字符
```

注意词边界。例如字段中多个代码以空格分隔：

```sql
WHERE conditions LIKE 'DIAB1%'
   OR conditions LIKE '% DIAB1%'
```

空格用于保证 `DIAB1` 位于某个独立代码的开头，而不是其他字符串内部。

## 6. GROUP_CONCAT：将组内多行拼成一行

```sql
GROUP_CONCAT(
    DISTINCT product
    ORDER BY product
    SEPARATOR ','
)
```

作用：

```text
去重
→ 组内排序
→ 使用指定分隔符拼接
```

完整例子：

```sql
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(
        DISTINCT product
        ORDER BY product
        SEPARATOR ','
    ) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;
```

## 7. REGEXP_LIKE：按完整格式检查字符串

基本结构：

```sql
REGEXP_LIKE(column, 'pattern', 'match_type')
```

合法邮箱示例：

```sql
WHERE REGEXP_LIKE(
    mail,
    '^[A-Za-z][A-Za-z0-9_.-]*@leetcode[.]com$',
    'c'
)
```

正则符号：

```text
^                  字符串开头
$                  字符串结尾
[A-Za-z]           一个英文字母
[A-Za-z0-9_.-]     一个允许字符
*                  前一规则出现零次或多次
[.]                真正的句号
.                  任意一个字符
```

匹配模式：

```text
'c'    区分大小写
'i'    不区分大小写
```

`$` 很重要。没有 `$` 时，`abc@leetcode.comXYZ` 也可能被前半段匹配。

---

# 六、FROM、子查询与派生表

## 1. 表别名与歧义

```sql
FROM Employee AS e
JOIN Department AS d
    ON e.department_id = d.id
```

多表存在同名字段时，应写：

```sql
e.name
d.name
```

## 2. FROM 中的子查询

```sql
SELECT ...
FROM (
    SELECT ...
) AS temporary_table;
```

MySQL 中，`FROM` 后的子查询必须设置表别名。

派生表的作用：

- 把聚合、窗口函数或复杂计算的结果变成一张临时表；
- 外层继续筛选、连接或再次聚合；
- 某些 `DELETE` 场景中隔离目标表与读取结果。

---

# 七、窗口函数

基本结构：

```sql
window_function() OVER (
    PARTITION BY group_column
    ORDER BY sort_column
)
```

`PARTITION BY` 不减少行数；`GROUP BY` 会把多行压缩为一行。

## 1. ROW_NUMBER、RANK、DENSE_RANK

假设排序值为：

```text
100
100
80
70
```

结果：

```text
ROW_NUMBER     1, 2, 3, 4
RANK           1, 1, 3, 4
DENSE_RANK     1, 1, 2, 3
```

每组保留一条记录，通常优先使用：

```sql
ROW_NUMBER() OVER (
    PARTITION BY email
    ORDER BY id
)
```

取工资前三个不同档位，使用：

```sql
DENSE_RANK() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)
```

## 2. 为什么窗口函数需要外层筛选

错误结构：

```sql
SELECT
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employee
WHERE salary_rank <= 3;
```

`WHERE` 执行时别名尚未产生。

正确结构：

```sql
SELECT *
FROM (
    SELECT
        e.*,
        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS salary_rank
    FROM Employee AS e
) AS ranked
WHERE salary_rank <= 3;
```

---

# 八、DELETE 与去重

基本结构：

```sql
DELETE FROM table_name
WHERE condition;
```

删除前应先使用相同条件执行 `SELECT` 验证目标行。

## 删除重复记录并保留最小 id

计算逻辑：

```text
按 email 分组
→ 每组找最小 id
→ 删除不在保留名单中的 id
```

MySQL 写法：

```sql
DELETE FROM Person
WHERE id NOT IN (
    SELECT id
    FROM (
        SELECT MIN(id) AS id
        FROM Person
        GROUP BY email
    ) AS keep_rows
);
```

三层作用：

```text
最内层：计算每组要保留的 id
中间层：把结果包装成派生表，隔离目标表
最外层：执行删除
```

中间层没有增加新的业务计算，主要用于避免 MySQL 直接从正在修改的目标表中读取删除依据时产生限制。

---

# 九、日期与时间

```sql
DATE_FORMAT(date_column, '%Y-%m')
DATEDIFF(date_1, date_2)
DATE_ADD(date_value, INTERVAL 1 DAY)
```

寻找目标日期之前最近一条记录：

```sql
SELECT new_price
FROM Products
WHERE product_id = 1
  AND change_date <= '2019-08-16'
ORDER BY change_date DESC
LIMIT 1;
```

---

# 十、JOIN

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL JOIN
CROSS JOIN
SELF JOIN
```

MySQL 不原生支持 `FULL JOIN`。

`LEFT JOIN` 中统计右表实际匹配数量时，通常使用：

```sql
COUNT(right_table.primary_key)
```

不要轻易使用 `COUNT(*)`，因为即使右表未匹配，左连接仍会保留一行。

---

# 十一、GROUP BY 与 HAVING

```sql
SELECT
    group_column,
    COUNT(*) AS row_count
FROM table_name
WHERE row_condition
GROUP BY group_column
HAVING COUNT(*) > 1;
```

```text
WHERE     筛选分组前的原始行
HAVING    筛选分组后的结果
```

分组对象应优先使用唯一标识：

```sql
GROUP BY manager.employee_id, manager.name
```

而不是只使用可能重名的 `name`。

---

# 十二、排序、LIMIT 与 OFFSET

```sql
ORDER BY column ASC
ORDER BY column DESC
LIMIT number
OFFSET number
```

第二高的不同工资：

```sql
SELECT (
    SELECT DISTINCT salary
    FROM Employee
    ORDER BY salary DESC
    LIMIT 1 OFFSET 1
) AS SecondHighestSalary;
```

这里必须按 `salary` 排序，而不是按 `id` 排序。

---

# 十三、UNION 与 UNION ALL

```sql
SELECT ...
UNION ALL
SELECT ...;
```

```text
UNION       合并并去重
UNION ALL   合并并保留重复行
```

多条查询必须返回相同数量、相同顺序且类型兼容的字段。

---

# 十四、INSERT、UPDATE、DELETE

## INSERT

```sql
INSERT INTO table_name
    (column_1, column_2)
VALUES
    (value_1, value_2);
```

## UPDATE

```sql
UPDATE table_name
SET column_1 = value_1,
    column_2 = value_2
WHERE condition;
```

## DELETE

```sql
DELETE FROM table_name
WHERE condition;
```

`UPDATE` 和 `DELETE` 没有 `WHERE` 时会影响全部行。

---

# 十五、创建与修改表结构

这些语句修改的是表的结构，而不是表中的某一行数据。

## 1. CREATE TABLE

```sql
CREATE TABLE IF NOT EXISTS table_name (
    column_1 DataType Constraint DEFAULT default_value,
    column_2 DataType Constraint DEFAULT default_value
);
```

例子：

```sql
CREATE TABLE IF NOT EXISTS Users (
    user_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(200) UNIQUE,
    balance DECIMAL(10, 2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME
);
```

常见数据类型：

```text
INTEGER                 整数
BOOLEAN                 真 / 假
FLOAT / DOUBLE / REAL   浮点数
DECIMAL(p, s)           精确小数，金额常用
CHAR(n)                 固定长度字符串
VARCHAR(n)              可变长度字符串
TEXT                    长文本
DATE                    日期
DATETIME                日期与时间
```

常见约束：

```text
PRIMARY KEY
NOT NULL
UNIQUE
DEFAULT
```

## 2. ALTER TABLE

增加列：

```sql
ALTER TABLE Database
ADD Description TEXT;
```

删除列：

```sql
ALTER TABLE Database
DROP COLUMN Description;
```

修改表名：

```sql
ALTER TABLE Database
RENAME TO Databases;
```

不同数据库对 `ALTER TABLE` 的支持存在差异。

## 3. DROP TABLE

```sql
DROP TABLE IF EXISTS Databases;
```

`DROP TABLE` 删除整张表，包括表结构和其中的数据；它与 `DELETE FROM` 只删除行不同。

```text
DELETE FROM table    删除表中的行，表仍存在
DROP TABLE table     删除整张表
```

---

# 十六、做题时的最终检查清单

提交前检查：

1. 最终一行代表的对象是否正确？
2. 是否需要 `DISTINCT`，以及去重的是单列还是字段组合？
3. `COUNT(*)`、`COUNT(column)`、`COUNT(DISTINCT column)` 是否选对？
4. 外连接条件应放在 `ON` 还是 `WHERE`？
5. 是否按真正的目标字段排序，而不是按 `id` 误排序？
6. 组内取特殊记录时，是否返回了完整记录？
7. 窗口函数别名是否需要外层查询筛选？
8. 字符串格式是否同时限定了开头 `^` 和结尾 `$`？
9. 没有结果时，题目要求零行、`NULL` 还是默认值？
10. `UPDATE` / `DELETE` 是否遗漏了 `WHERE`？
