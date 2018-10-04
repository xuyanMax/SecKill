CREATE DATABASE 'seckill';

use 'seckill';

CREATE TABLE `seckill` (
  `seckill_id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '商品库存id',
  `name` varchar(120) DEFAULT NULL COMMENT '库存名称',
  `start_time` timestamp NULL DEFAULT NULL COMMENT '秒杀开始时间',
  `end_time` timestamp NULL DEFAULT NULL COMMENT '秒杀结束时间',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `number` int(11) DEFAULT NULL COMMENT '库存数量',
  PRIMARY KEY (`seckill_id`),
  KEY `idx_end_time` (`end_time`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `success_killed` (
  `seckill_id` bigint(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '秒杀商品id',
  `user_phone` bigint(11) DEFAULT NULL COMMENT '用户手机',
  `state` tinyint(11) DEFAULT NULL COMMENT '状态标示: -1:无效 0:成功 1:已付款',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`seckill_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 连接数据库控制台
mysql -uroot -p

-- 为什手写sql
-- 记录每次上线的DDL修改
-- 上线v1.1
ALTER table seckill
DROP INDEX idx_create_time
ADD INDEX idx_c_s(start_time, create_time)