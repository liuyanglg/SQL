-- 将platformkf.portal_buyer_bind_service c_texnum和c_serviceid拷贝到dataserver.`portal_buyer_bind_service_copy`
DROP TABLE
IF EXISTS dataserver.`portal_buyer_bind_service_copy`;

CREATE TABLE
IF NOT EXISTS dataserver.`portal_buyer_bind_service_copy` LIKE platformkf.portal_buyer_bind_service;

INSERT INTO dataserver.`portal_buyer_bind_service_copy`
SELECT 
*
FROM
	platformkf.`portal_buyer_bind_service`;
use dataserver;
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
	JOIN dataserver.`portal_buyer_bind_service_copy` bind_service ON (
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

-- 创建审核表六位代码、税号和服务单位ID关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_taxid_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_taxid_serviceid` (
	`code` VARCHAR (16),
	`taxid` VARCHAR (30),
	`serviceid` VARCHAR (30)
);

-- 将查询到的数据插入到新建的表当中
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`)(
	SELECT
		*
	FROM
		(
			-- 如果审核表code不为空，则根据审核表code查询维护表taxid，再根据taxid查询serviceid
			-- 如果审核表code为空，则根据审核表taxid直接查询serviceid
			SELECT DISTINCT
				audit.`code`,
				maintain.`taxid`,
				bind_service.`c_serviceid`
			FROM
				dataserver.`tb_cmp_card_audit` audit
			JOIN dataserver.`tb_cmp_card` maintain ON (
				audit.`code` = maintain.`code`
				AND (
					audit.`code` != ''
					AND audit.`code` IS NOT NULL
				)
				AND (
					maintain.`taxid` != ''
					AND maintain.`taxid` IS NOT NULL
				)
			)
			JOIN dataserver.portal_buyer_bind_service_copy bind_service ON (
				maintain.`taxid` = bind_service.`c_texnum`
				AND (
					bind_service.`c_serviceid` != ''
					AND bind_service.`c_serviceid` IS NOT NULL
				)
			)
			UNION ALL
				SELECT DISTINCT
					audit.`code`,
					audit.`taxid`,
					bind_service.`c_serviceid`
				FROM
					dataserver.`tb_cmp_card_audit` audit
				JOIN dataserver.`portal_buyer_bind_service_copy` bind_service ON (
					audit.`taxid` = bind_service.`c_texnum`
					AND (
						audit.`code` IS NULL
						OR audit.`code` = ''
					)
					AND (
						audit.`taxid` IS NOT NULL
						AND audit.`taxid` != ''
					)
					AND (
						bind_service.`c_serviceid` IS NOT NULL
						AND bind_service.`c_serviceid` != ''
					)
				)
		) AS code_taxid_serviceid
);

-- 将复制的portal_buyer_bind_service_copy表删除
DROP TABLE
IF EXISTS dataserver.`portal_buyer_bind_service_copy`;