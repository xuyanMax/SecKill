<%--
  Created by IntelliJ IDEA.
  User: xu
  Date: 2018/10/8
  Time: 21:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css">
    <title>秒杀详情页</title>
    <%@include file="common/head.jsp"%>
</head>
<body>
    <div class="container">
        <div class="panel panel-default text-center">
            <div class="panel-heading"><h1>${seckill.name}</h1>
            </div>
            <div class="panel-body">
                <h2 class="text-danger text-center">
                    <%--显示timer图标--%>
                    <span class="glyphicon glyphicon-time"></span>
                    <%--显示倒计时--%>
                    <span class="glyphicon" id="seckill-box"></span>
                </h2>
            </div>
        </div>
    </div>
    <%--登录弹出层--%>
    <div class="modal fade" id="killPhoneModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title text-center">
                        <span class="glyphicon glyphicon-phone"></span>
                    </h3>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-xs-8 col-xs-offset-2">
                            <input type="text" name="killPhoneKey" id="killPhoneKey" class="form-control"
                            placeholder="手机号">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <%--验证信息--%>
                    <span class="glyphicon" id="killPhoneMessage"></span>
                    <button class="btn btn-success" id="killPhoneBtn" type="button">
                        <span class="glyphicon glyphicon-phone"></span>
                        提交
                    </button>
                </div>
            </div>
        </div>
    </div>

<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://cdn.bootcss.com/jquery/2.2.1/jquery.min.js"></script>

<!-- popper.min.js 用于弹窗、提示、下拉菜单 -->
<script src="https://cdn.bootcss.com/popper.js/1.12.5/umd/popper.min.js"></script>

<!-- 最新的 Bootstrap4 核心 JavaScript 文件 -->
<script src="https://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.countdown/2.2.0/jquery.countdown.js"></script>
<script src="/resource/script/seckill.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        //js的EL表达式传入参数
        seckill.details.init({
            seckillId : ${seckill.seckillId},
            startTime : ${seckill.startTime.time},//.time获得毫秒
            endTime : ${seckill.endTime.time}
        });
    });
</script>
</body>
</html>