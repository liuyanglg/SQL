-- 创建六位代码和服务单位ID关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_serviceid` (
	`code` VARCHAR (16),
	`serviceid` VARCHAR (30)
);

-- 创建六位代码和服务单位ID关系缓存表，由于查询出可能会存在完全重复的记录，需要一张缓存表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid_temp`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_serviceid_temp` LIKE dataserver.`tb_code_serviceid`;

-- 将将税号转换为六位代码，然后放入缓存表
INSERT INTO dataserver.`tb_code_serviceid_temp` (`code`, `serviceid`)(
	SELECT
		tc.`code`,
		ts.`c_serviceid`
	FROM
		dataserver.`tb_cmp_card_audit` tc,
		platformkf.`portal_buyer_bind_service` ts
	WHERE
		tc.`code` IS NOT NULL
	AND tc.`code` != ''
	AND tc.`taxid` IS NOT NULL
	AND tc.`taxid` != ''
	AND ts.`c_texnum` IS NOT NULL
	AND ts.`c_texnum` != ''
	AND ts.`c_serviceid` IS NOT NULL
	AND ts.`c_serviceid` != ''
	AND tc.`taxid` = ts.`c_texnum`
);

-- 去除缓存表中重复数据，然后插入关系表
INSERT INTO dataserver.`tb_code_serviceid` SELECT DISTINCT
	*
FROM
	dataserver.`tb_code_serviceid_temp`;

-- 删除缓存表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid_temp`;

