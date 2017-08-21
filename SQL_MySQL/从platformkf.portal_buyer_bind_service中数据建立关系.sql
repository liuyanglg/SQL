#1  创建关系表tb_code_serviceid

#1.1
# 创建维护表(dataserver.`tb_cmp_card` )中六位代码(code)和(platformkf.`portal_buyer_bind_service`)中服务单位ID(serviceid)关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_serviceid` (
  `code`      VARCHAR(16),
  `serviceid` VARCHAR(30),
  KEY `code_index` (`code`) USING BTREE
);

#1.2
# 以税号为内连接的连接条件
# 以表platformkf.`portal_buyer_bind_service`建立关联关系，分3种情况
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

#2   创建关系表tb_code_taxid_serviceid

#2.1
# 创建审核表(dataserver.`tb_cmp_card_audit` )中六位代码(code)、税号(taxid)和(platformkf.`portal_buyer_bind_service`)中服务单位ID(serviceid)关系表
DROP TABLE
IF EXISTS dataserver.`tb_code_taxid_serviceid`;

CREATE TABLE
IF NOT EXISTS dataserver.`tb_code_taxid_serviceid` (
  `code`      VARCHAR(16),
  `taxid`     VARCHAR(30),
  `serviceid` VARCHAR(30),
  KEY `serviceid_index` (`serviceid`) USING BTREE
);

#2.2
# 以税号为内连接的连接条件
# 以表platformkf.`portal_buyer_bind_service`建立关联关系，分3种情况

#2.2.1
# 审核表code不为空,taixd为空
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`) (
  SELECT DISTINCT
    T_A.`code`,
    T_A.`taxid`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card_audit` T_A
    JOIN dataserver.`tb_cmp_card` T_M ON T_A.`code` = T_M.`code`
    JOIN platformkf.`portal_buyer_bind_service` T_BS ON T_M.`taxid` = T_BS.`c_texnum`
  WHERE
    T_A.`code` IS NOT NULL
    AND T_A.`code` != ''
    AND T_A.`taxid` IS NULL
    AND T_M.`taxid` IS NOT NULL
    AND T_BS.`c_serviceid` IS NOT NULL
    AND T_BS.`c_serviceid` != ''
);

#2.2.2
# 审核表code不为空,taixd不为空
INSERT INTO dataserver.`tb_code_taxid_serviceid` (`code`, `taxid`, `serviceid`) (
  SELECT DISTINCT
    T_A.`code`,
    T_A.`taxid`,
    T_BS.`c_serviceid`
  FROM
    dataserver.`tb_cmp_card_audit` T_A
    JOIN dataserver.`tb_cmp_card` T_M ON T_A.`code` = T_M.`code`
    JOIN platformkf.`portal_buyer_bind_service` T_BS ON T_M.`taxid` = T_BS.`c_texnum`
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

#2.2.3
# 审核表code为空,taixd不为空
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