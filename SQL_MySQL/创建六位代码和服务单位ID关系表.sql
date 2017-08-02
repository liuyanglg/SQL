-- 创建维护表六位代码和服务单位ID关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_serviceid` (
	`code` VARCHAR (16),
	`serviceid` VARCHAR (30)
);

-- 将税号转换为六位代码，然后插入到新建表
INSERT INTO dataserver.`tb_code_serviceid` (`code`, `serviceid`)(
	SELECT
		maintain.`code`,
		bind_service.`c_serviceid`
	FROM
		dataserver.`tb_cmp_card_audit` maintain
	JOIN platformkf.`portal_buyer_bind_service` bind_service ON (
		maintain.`taxid` = bind_service.`c_texnum`
		AND (
			maintain.`code` IS NOT NULL
			AND maintain.`code` != ''
		)
		AND (
			maintain.`taxid` IS NOT NULL
			AND maintain.`taxid` != ''
		)
		AND (
			bind_service.`c_serviceid` IS NOT NULL
			AND bind_service.`c_serviceid` != ''
		)
	)
);

