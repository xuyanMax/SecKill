//存放主要交互逻辑js代码
// js 模块化
//seckill.detail.init(params)
var seckill={
    //封装秒杀相关的ajax的url
    URL: {

    },
    validatePhone : function(phone) {
        if (phone && phone.length == 11 && !isNaN(phone)) {
            return true;
        } else {
            return false;
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

        }
    }
};