package org.seckill.enums;

import org.seckill.entity.Seckill;

/**
 * 试用枚举表示常量数据字典
 */
public enum SeckillStateEnum {
    //设计常量
    SUCCESS(1, "秒杀成功"),
    END(0, "秒杀结束"),
    REPEAT_KILL(-1, "秒杀结束"),
    INNER_ERROR(-2, "系统异常"),
    DATA_REWRITE(-3, "数据篡改")
    ;
    private int state;
    private String stateInfo;

    SeckillStateEnum(int state, String stateInfo) {
        this.state = state;
        this.stateInfo = stateInfo;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public void setStateInfo(String stateInfo) {
        this.stateInfo = stateInfo;
    }

    public static SeckillStateEnum stateOf (int index){
        for (SeckillStateEnum state:values()) {
            if (state.getState() == index) {
                return state;
            }
        }
        return null;
    }
}
