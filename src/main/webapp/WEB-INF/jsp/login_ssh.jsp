<%--
  Created by IntelliJ IDEA.
  User: duyu
  Date: 2019/1/4
  Time: 15:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>登录</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body class="l-body" bgcolor="#F7F7F7">
<div class="contant">
    <div class="left">
        <div class="con-box">
            <img src="${pageContext.request.contextPath}/img/login-bg.png"/>
        </div>
    </div>
    <div class="right">
        <div class="con-box">
            <div class="login-w">
                <div class="login">
                    <div class="row">
                        <span class="title">服务器登陆<img class="weather" src="${pageContext.request.contextPath}/img/icon-weather-01.png" /></span>
                    </div>
                    <span id="error" style="color: red"></span>
                    <div class="input-g">
                        <p class="ip">
                            <input type="text" class="form-control" placeholder="IP地址" name="ip" id="ip">
                        </p>
                        <p class="port">
                            <input type="text" class="form-control" placeholder="端口" name="port" id="port">
                        </p>
                        <p class="account">
                            <input type="text" class="form-control" placeholder="用户名" name="username" id="username">
                        </p>
                        <p class="password">
                            <input type="password" class="form-control" maxlength="30" placeholder="密码" name="password" id="password">
                        </p>
                        <a class="log-ssh" id="login-button"  onclick="login('1')">Login SSH</a>
                        <a class="log-ftp" id="login-button"  onclick="login('2')">Login FTP</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js" type="text/javascript"></script>
<script type="text/javascript" color="0,0,255" opacity='0.7' zIndex="-2" count="99" src="${pageContext.request.contextPath}/js/canvas-nest.js"></script>
<script>

    setH();
    $(window).resize(function () {
        setH();
    })

    //高度调整
    function setH() {
        var $winH = $(window).height();
        console.log($winH)
        $('.left, .right').css('height', $winH);
        $('.left img').css('margin-top', ($winH - $('.left img').height()) / 2);
        $('.login-w').css('margin-top', ($winH - $('.right .login-w').height()) / 2);
    };

    function login(status){
        var jsonData='{"ip":"'+$("#ip").val()+'","port":"'+$("#port").val()+'","username":"'+$("#username").val()+'","password":"'+$("#password").val()+'"}';
        $.ajax({
            type: "POST",
            url:'${pageContext.request.contextPath}/sshController/openSsh',
            data: JSON.parse(jsonData),
            success: function (data) {
                debugger;
                if ('false' == data) {
                    $("#error").html("登录失败");
                } else {
                    if(status == '1'){
                        location.href ="${pageContext.request.contextPath}/sshController/openShell";
                    }else if(status == '2'){
                        location.href ="${pageContext.request.contextPath}/sshController/openSftp";
                    }else{
                        $("#error").html('登录失败');
                    }
                }
            }
        })
    };
</script>
</body>
</html>
