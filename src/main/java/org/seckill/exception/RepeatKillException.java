package org.seckill.exception;

/**
 * 重复秒杀异常(运行期异常)
 *
 */
public class RepeatKillException extends SeckillException{

    public RepeatKillException(String msg) {
        super(msg);
    }

    public RepeatKillException(String message, Throwable cause) {
        super(message, cause);
    }
}
