package org.seckill.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.seckill.dto.Exposer;
import org.seckill.dto.SeckillExecution;
import org.seckill.entity.Seckill;
import org.seckill.exception.RepeatKillException;
import org.seckill.exception.SeckillCloseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

import static org.junit.Assert.*;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring/spring-dao.xml",
                       "classpath:spring/spring-service.xml"})
public class SeckillServiceTest {
    private Logger logger = LoggerFactory.getLogger(SeckillServiceTest.class);
    @Autowired
    private SeckillService seckillService;
    @Test
    public void getSeckillList() {
        List<Seckill> list = seckillService.getSeckillList();
        logger.info("list={}", list);
    }

    @Test
    public void getById() {
        long id = 1000;
        Seckill seckill = seckillService.getById(id);
        logger.info("secKill={}", seckill);
    }

    @Test
    public void exportSeckillUrl() {
        long id = 3000;
        Exposer exposer = seckillService.exportSeckillUrl(id);
        logger.info("exposer={}", exposer);
    }

    @Test
    public void executeSeckill() {
        long id = 1000;
        long phone = 15151528348L;
        String md5 = "6b18b33cf6083a1bb57596c8155066ff";

        try{
            SeckillExecution seckillExecution = seckillService.executeSeckill(id, phone, md5);
            logger.info("result={}", seckillExecution);
        } catch (SeckillCloseException e1) {
            logger.error(e1.getMessage(), e1);
        } catch (RepeatKillException e2) {
            logger.error(e2.getMessage(), e2);
        }
    }
    //集成测试代码完整逻辑
    @Test
    public void testSeckillLogic(){
        long id = 2000;
        Exposer exposer = seckillService.exportSeckillUrl(id);
        if (exposer.isExposed()) {
            logger.info("exposer={}", exposer);
            long phone = 15151528348L;
            String md5 = exposer.getMd5();
            try{
                SeckillExecution seckillExecution = seckillService.executeSeckill(id, phone, md5);
                logger.info("result={}", seckillExecution);
            } catch (SeckillCloseException e1) {
                logger.error(e1.getMessage(), e1);
            } catch (RepeatKillException e2) {
                logger.error(e2.getMessage(), e2);
            }
        } else {
            //秒杀未开启
            logger.warn("exposer={}", exposer);
        }
    }
}