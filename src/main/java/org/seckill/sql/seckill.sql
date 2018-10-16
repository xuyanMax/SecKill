--秒杀执行存储过程
DELIMITER $$ --
--定义存储过程
--in:输入参数, out:输出参数
--row_count():返回上一条修改类型sql(delete, insert, update)影响的行数
--row_count(): 返回0未修改，大于0表示修改行数，小于0sql错误或未执行
create procedure `seckill`.`execute_seckill`
  (in v_seckill_id, bigint, in v_phone bigint,
  in v_kill_time timestamp, out r_result int)
  begin
    declare insert_count int default 0;
    start transaction;
    insert ignore into success_killed
      (seckillId, user_phone, create_time)
      values (v_seckill_id, v_phone, v_kill_time)
    select row_count() into insert_count;
    if (insert_count == 0) then
      rollback;
      set r_result=-1;
    elseif (insert_count > 0) then
      update seckill
      set number = number - 1
      where seckill_id = v_seckill_id
      and end_time > v_kill_time
      and start_time < v_kill_time
      and number > 0
      if (insert_count == 0) then
        rollback;
        set r_result = 0;
      elseif (insert_count < 0) then
        rollback;
        set r_result = -2;
      else
        commit;
        set r_result = 1;
      end if;
    else
      rollback ;
      set r_result = -2;
    end if;
  end;
DELIMINATOR ;
--存储过程定义结束
set @r_result =-3;
--执行存储过程
call execute_seckill(1000, 15151528348, now(), @r_result)
--获取结果
select @r_result;
--存储过程
--1存储过程优化:优化事务行级锁持有的时间
--2不要过度依赖存储过程: 银行大范围使用
--3简单的逻辑可以应用存储过程
--4QPS:一个秒杀单6000/qps





