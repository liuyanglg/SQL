-- 创建用户
create user 'develop'@'localhost' identified by 'develop';
flush privileges;
-- 查看用户权限
show grants for 'develop'@'localhost';
-- 使用update指令，注意这里的password需要进行加密
use mysql;
update user set password = password('123456') where user = 'develop';
flush privileges;
---- -----------------或者------------------
set password for superboy@'localhost'= password('123456');
flush privileges;
-- 删除用户
use mysql;
delete from user where user='develop' and host='localhost' ;
flush privileges;
-- 赋予部分权限
use ssm-project;
grant select,delete,update,insert on `ssm-project`.* to 'develop'@'localhost' identified by 'root';
flush privileges;
-- 撤销update权限
revoke update on ssm-project.* from 'develop'@'localhost';
-- 撤销所有权限
revoke all on ssm-project.* from 'develop'@'localhost';