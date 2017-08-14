-- 与platformkf.`portal_buyer_bind_service`的税号、服务单位ID建立关联关系
-- 创建维护表六位代码和服务单位ID关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_serviceid` (
  `code`      VARCHAR(16),
  `serviceid` VARCHAR(30)
);

-- 将税号转换为六位代码，然后插入到新建表
INSERT INTO dataserver.`tb_code_serviceid` (`code`, `serviceid`) (
  SELECT
    T_M.`code`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card` T_M
    JOIN platformkf.`portal_buyer_bind_service` T_BS ON T_M.`taxid` = T_BS.`c_texnum`
  WHERE
    T_BS.`c_serviceid` IS NOT NULL
    AND T_BS.`c_serviceid` != ''
    AND T_M.`taxid` IS NOT NULL
    AND T_M.`taxid` != ''
);

-- 创建审核表六位代码、税号和服务单位ID关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_taxid_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_taxid_serviceid` (
  `code`      VARCHAR(16),
  `taxid`     VARCHAR(30),
  `serviceid` VARCHAR(30)
);

-- 将查询到的数据插入到新建的表当中
-- 如果审核表code不为空,taixd为空，则根据审核表code查询维护表taxid，再根据taxid查询serviceid
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`) (
  SELECT DISTINCT
    T_A.`code`,
    T_A.`taxid`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card_audit` T_A
    JOIN dataserver.`tb_cmp_card` T_M ON T_A.`code` = T_M.`code`
    JOIN platformkf.portal_buyer_bind_service T_BS ON T_M.`taxid` = T_BS.`c_texnum`
  WHERE
    T_A.`code` IS NOT NULL
    AND T_A.`code` != ''
    AND T_A.`taxid` IS NULL
    AND T_M.`taxid` IS NOT NULL
    AND T_BS.`c_serviceid` IS NOT NULL
    AND T_BS.`c_serviceid` != ''
);

-- 如果审核表code不为空，taxid也不为空，则根据审核表code查询维护表taxid，再根据taxid查询serviceid
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`) (
  SELECT DISTINCT
    T_A.`code`,
    T_A.`taxid`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card_audit` T_A
    JOIN dataserver.`tb_cmp_card` T_M ON T_A.`code` = T_M.`code`
    JOIN platformkf.portal_buyer_bind_service T_BS ON T_M.`taxid` = T_BS.`c_texnum`
  WHERE
    T_A.`code` IS NOT NULL
    AND T_A.`code` != ''
    AND T_A.`taxid` IS NOT NULL
    AND T_A.`taxid` != ''
    AND T_M.`taxid` IS NOT NULL
    AND T_M.`taxid` != ''
    AND T_BS.`c_serviceid` IS NOT NULL
    AND T_BS.`c_serviceid` != ''
);

-- 如果审核表code为空，taxid不为空，则根据审核表taxid直接查询serviceid，以下是taxid为空的情况
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`) (
  SELECT DISTINCT
    T_A.`code`,
    T_A.`taxid`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card_audit` T_A
    JOIN platformkf.`portal_buyer_bind_service` T_BS ON T_A.`taxid` = T_BS.`c_texnum`
  WHERE
    T_A.`code` IS NULL
    AND T_A.`taxid` IS NOT NULL
    AND T_A.`taxid` != ''
    AND T_BS.`c_serviceid` IS NOT NULL
    AND T_BS.`c_serviceid` != ''
);