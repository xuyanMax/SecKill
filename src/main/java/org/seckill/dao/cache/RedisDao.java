package org.seckill.dao.cache;

import com.dyuproject.protostuff.LinkedBuffer;
import com.dyuproject.protostuff.ProtobufIOUtil;
import com.dyuproject.protostuff.ProtostuffIOUtil;
import com.dyuproject.protostuff.runtime.RuntimeSchema;
import org.seckill.entity.Seckill;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

public class RedisDao {
    private static Logger logger = LoggerFactory.getLogger(RedisDao.class);

    private JedisPool jedisPool;

    public RedisDao(String ip, int port) {
        this.jedisPool = new JedisPool(ip, port);
    }

    public RuntimeSchema<Seckill> schema = RuntimeSchema.createFrom(Seckill.class);//Seckill.class获取类的字节码

    public Seckill getSeckill(long seckillId) {
        try{
            Jedis jedis = jedisPool.getResource();
            try {
                String key = "seckill:"+seckillId;
                //并没有实现内部序列化
                // get->byte[]二进制数组->反序列化->Object(seckill)
                // 采用自定义序列化
                byte[] bytes = jedis.get(key.getBytes());
                //不为空，则从缓存中获取到
                if (bytes != null) {
                    Seckill seckill = schema.newMessage();
                    ProtobufIOUtil.mergeFrom(bytes, seckill, schema);//讲bytes按照schema，注入到空的seckill
                    return seckill;
                }

            } finally {
                jedis.close();
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return null;
    }

    public String putSeckill(Seckill seckill) {
        // set Object(Seckill) -> 序列化 -byte[]
        try {
            Jedis jedis = jedisPool.getResource();
            String key = "seckill:"+seckill.getSeckillId();
            //超时缓存
            int timeout = 60 * 60;
            byte[] bytes = ProtostuffIOUtil.toByteArray(seckill, schema, LinkedBuffer.allocate(LinkedBuffer.DEFAULT_BUFFER_SIZE));

            String result = jedis.setex(key.getBytes(), timeout, bytes);
            return result;
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return null;
    }
}
