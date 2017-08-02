-- 将platformkf.portal_buyer_bind_service c_texnum和c_serviceid拷贝到dataserver.`portal_buyer_bind_service_copy`
DROP TABLE
IF EXISTS dataserver.`portal_buyer_bind_service_copy`;

CREATE TABLE
IF NOT EXISTS dataserver.`portal_buyer_bind_service_copy` (
	SELECT DISTINCT
		`c_texnum`,
		`c_serviceid`
	FROM
		platformkf.portal_buyer_bind_service
	WHERE
		(
			`c_texnum` != ''
			AND `c_texnum` IS NOT NULL
		)
	AND (
		`c_serviceid` != ''
		AND `c_serviceid` IS NOT NULL
	)
);

-- 将platformkf.portal_buyer_bind_service c_texnum和c_serviceid拷贝到dataserver.`portal_buyer_bind_service_copy`
DROP TABLE
IF EXISTS dataserver.`portal_buyer_bind_service_copy`;

CREATE TABLE
IF NOT EXISTS dataserver.`portal_buyer_bind_service_copy` LIKE platformkf.portal_buyer_bind_service;

INSERT INTO dataserver.`portal_buyer_bind_service_copy`
SELECT DISTINCT
*
FROM
	platformkf.`portal_buyer_bind_service`;