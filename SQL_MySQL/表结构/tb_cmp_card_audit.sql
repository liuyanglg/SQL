/*
Navicat MySQL Data Transfer

Source Server         : MySQL-Dev
Source Server Version : 50627
Source Host           : 192.168.210.33:3306
Source Database       : dataserver

Target Server Type    : MYSQL
Target Server Version : 50627
File Encoding         : 65001

Date: 2017-08-07 17:58:48
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tb_cmp_card_audit
-- ----------------------------
DROP TABLE IF EXISTS `tb_cmp_card_audit`;
CREATE TABLE `tb_cmp_card_audit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(16) DEFAULT NULL COMMENT '六位代码',
  `taxid` varchar(30) DEFAULT NULL COMMENT '公司税号，纳税人识别号',
  `name` varchar(200) DEFAULT NULL COMMENT '公司名称',
  `address` varchar(200) DEFAULT NULL COMMENT '注册地址',
  `telephone` varchar(30) DEFAULT NULL COMMENT '联系电话',
  `bank` varchar(200) DEFAULT NULL COMMENT '开户银行',
  `account` varchar(50) DEFAULT NULL COMMENT '银行账户',
  `source` int(11) NOT NULL COMMENT '更新操作来源：\n0-未知\n10-防伪开票软件\n11-防伪开票软件(百旺)\n20-CRM\n30-诺诺网\n31-微信H5\n40-用户中心\n99-ADMIN',
  `type` int(11) NOT NULL COMMENT '0-企业，1-个体工商户',
  `createtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `note` varchar(200) DEFAULT NULL COMMENT '备注，可以加入一些信息，供审核人员参考',
  `cert` int(2) DEFAULT NULL COMMENT '认证状态：0-未认证；1-已认证',
  `status` smallint(2) NOT NULL DEFAULT '0' COMMENT '审核状态，0：未审核，1：审核通过，-1：审核不通过',
  `auditor` varchar(16) DEFAULT NULL COMMENT '审核人，对应tb_admin_operator表的realName字段',
  `auditTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '审核时间',
  PRIMARY KEY (`id`),
  KEY `code_UNIQUE` (`code`),
  KEY `seq_taxid` (`taxid`) USING BTREE,
  KEY `seq_createtime` (`createtime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10158 DEFAULT CHARSET=utf8 COMMENT='企业名片信息变更审核表\r\n\r\n\r\n开票服务-企业信息：\r\n• 税号（唯一索引）\r\n• 名称 (not null) \r\n• 注册地址(null)\r\n• 注册电话(null)\r\n• 开户银行(null)\r\n• 银行账户(null)\r\n• 六位代码（唯一索引）';
