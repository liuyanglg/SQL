-- �����û�
create user 'develop'@'localhost' identified by 'develop';
flush privileges;
-- �鿴�û�Ȩ��
show grants for 'develop'@'localhost';
-- ʹ��updateָ�ע�������password��Ҫ���м���
use mysql;
update user set password = password('123456') where user = 'develop';
flush privileges;
---- -----------------����------------------
set password for superboy@'localhost'= password('123456');
flush privileges;
-- ɾ���û�
use mysql;
delete from user where user='develop' and host='localhost' ;
flush privileges;
-- ���貿��Ȩ��
use ssm-project;
grant select,delete,update,insert on `ssm-project`.* to 'develop'@'localhost' identified by 'root';
flush privileges;
-- ����updateȨ��
revoke update on ssm-project.* from 'develop'@'localhost';
-- ��������Ȩ��
revoke all on ssm-project.* from 'develop'@'localhost';