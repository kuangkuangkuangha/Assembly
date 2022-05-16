### 第三章习题

P120 T4

```sql
create table S(
		sno int primary key,
  	sname char(10),
  	status int,
  	city char(10)
)

create table P(
		pno int primary key,
  	pname char(10),
  	color char(5),
  	weight int
)

create table J(
		jno int primary key,
  	jname char(10),
  	city char(10),
)

create table SPJ(
		sno int primary key,
  	pno int,
  	jno int,
  	qty int,
  		foreign key(pno) referrences P(pno),
  		foreign key(jno) referrences J(jno),
  		on delete cascade,
  		on update cascade
)
```

查询

```sql
select sno from SPJ where jno = j1
select sno from SPJ where jno = j1 and pno = p1
select SPJ.sno from SPJ, P where SPJ.pno = P.pno and color = '红'
select jno from J if not exist where(
			
)



```



### 四五章习题

grant all privileges on table 学生，班级 to U1 with grant option

grant select, update(家庭住址) on table 学生 to U1 

grant select on table 班级 to public

grant select, update on table 学生 to R1

grant R1 to U1 with admin option



grant select on table 职工，部门 to 王明

grant insert, delete on table 职工， 部门 to 李勇

grant select on table 职工 when user() = name to all

grant select， update（工资）on table 职工 to 刘星

grant alter table on table 工资，职工 to 张新

grant all privileges on table 职工，部门 to周平 with grant option

create view department_salary as 

select 部门.名称， max（工资），min（工资），avg（工资）from 职工，部门

where 职工.部门号 = 部门.部门号

group by 部门.部门号

grant select on department_salary to 杨兰



revoke  select on table  职工，部门  from 王明



```sql
create table emp(
		Empno int primary key
		name char(10),
		age  int check( age >=0 and age <= 60),
		position char(10),
		salary int, 
		Dno int,
    foreign key(dno) referrences depart(dno),
    	on delete cascade,
    	on update cascade
)

create table depart(
		Dno int primarykey,
		name char(10),
		manager char(10),
		tel char(11),
		
)
```

