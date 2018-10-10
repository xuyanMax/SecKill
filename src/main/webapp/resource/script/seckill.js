//存放主要交互逻辑js代码
// js 模块化
//seckill.detail.init(params)
var seckill={
    //封装秒杀相关的ajax的url
    URL: {
        now : function () {
            return '/seckill/time/now';
        },
        exposer : function (seckillId) {
            return '/seckill/'+seckillId+'/exposer';
        },
        execution : function (seckillId, md5) {
            return '/seckill/'+seckillId+'/'+md5+'/execution';
        }
    },
    handleSeckill : function(seckillId, node){
        console.log("handleSeckill="+seckillId)
        //获取秒杀地址，控制显示逻辑，执行秒杀
        node.hide()
            .html('<button class="btn btn-primary btn-lg" id="killBtn">开始秒杀</button>');
        $.post(seckill.URL.exposer(seckillId), {}, function (result) {
            //在回调函数中，执行交互
            if (result && result['success']) {
                var exposer = result['data'];
                if (exposer['exposed']) {
                    //开启秒杀
                    //获取秒杀地址
                    var md5 = exposer['md5'];
                    var killUrl = seckill.URL.execution(seckillId, md5);
                    console.log("killUrl="+killUrl);
                    //one 绑定一次点击事件,防止客户多次点击秒杀，减少服务器端压力
                    $('#killBtn').one('click', function () {//注册绑定事件
                        //执行秒杀请求操作
                        //1先禁用按钮
                        $(this).addClass('disable');//#killBtn
                        //2发送秒杀请求执行秒杀
                        $.post(killUrl, {}, function (result) {
                            if (result && result['success']) {
                                var killResult = result['data'];
                                var state = killResult['state'];
                                var stateInfo = killResult['stateInfo'];
                                //3 显示秒杀结果
                                node.html('<span class="label label-success">'+stateInfo+'</span>')
                            }
                        });
                    });
                    node.show();
                } else {
                    //未开启秒杀
                    console.log("为开启=");
                    var now = exposer['now'];
                    var start = exposer['startTime'];
                    var end = exposer['endTime'];
                    seckill.countdown(seckillId, now, start, end);

                }
            } else {
                    console.log('result:' + result['success']);
            }
        });
    },
    validatePhone : function(phone) {
        if (phone && phone.length == 11 && !isNaN(phone)) {
            return true;
        } else {
            return false;
        }
    },
    countdown : function(seckillId, nowTime, startTime, endTime) {
        var seckillBox = $('#seckill-box');
        //时间的判断
        if (nowTime > endTime) {
            //秒杀结束
            seckillBox.html('秒杀结束了');
        } else if (nowTime < startTime) {
            //秒杀未开始，计时事件绑定
            var killTime = new Date(startTime + 1000);// + 1s
            seckillBox.countdown(killTime, function(event){//event 回调函数
                //时间格式
               var format = event.strftime("秒杀倒计时: %D天 %H时 %M分 %S秒");
                seckillBox.html(format);
                //时间结束后回调时事件
            }).on('finish.countdown', function () {
                //获取秒杀地址，控制实现逻辑，执行秒杀
                seckill.handleSeckill(seckillId, seckillBox);

            });//jquery

         } else {
            //秒杀开始
            seckill.handleSeckill(seckillId, seckillBox);
        }

    },
    //详情初始页逻辑
    details:{
        //详情页初始化
        init : function (params) {
            //手机登录验证，计时交互
            //规划我们的交互流程
            //在cookie中查找手机号
            var killPhone = $.cookie("killPhone");
            var startTime = params['startTime'];
            var endTime = params['endTime'];
            var seckillId = params['seckillId'];

            //验证手机号
            if (!seckill.validatePhone(killPhone)) {
                //绑定phone
                //控制输出
                console.log(killPhone);
                console.log(!seckill.validatePhone());
                var killPhoneModal = $("#killPhoneModal");
                killPhoneModal.modal({

                    show:true,//显示弹出层
                    backdrop:'static',//禁止位置关闭
                    keyboard:false //关闭键盘事件

                });

                $("#killPhoneBtn").click(function(){
                    var inputPhone = $('#killPhoneKey').val();
                    console.log(inputPhone);
                    if (seckill.validatePhone(inputPhone)) {
                        //电话写入cookie
                        $.cookie('killPhone', inputPhone, {expires:7, path:'/seckill'});
                        //刷新页面
                        window.location.reload();
                    } else {
                        $('#killPhoneMessage').hide().html('<label class="label label-danger">手机号错误</label>').show(300);
                    }
                });
            }
            //已经登录
            //计时交互
            $.get(seckill.URL.now(), {}, function(result) {
                if (result && result['success']) {
                    var nowTime = result['data'];
                    console.log("nowtime="+nowTime);
                    console.log("seckillId="+seckillId);
                    //时间判断，计时服务
                    seckill.countdown(seckillId, nowTime, startTime, endTime);
                } else {
                    console.log('result:'+result);
                }
            });
        }
    }
};