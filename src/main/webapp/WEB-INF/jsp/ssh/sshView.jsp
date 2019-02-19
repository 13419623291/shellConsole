<%--
  Created by IntelliJ IDEA.
  User: duyu
  Date: 2019/1/4
  Time: 17:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${sshHostInfo.ip}的控制台</title>
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/xterm.min.css">
    <script src="${pageContext.request.contextPath}/js/xterm.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/attach.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/fit.js" type="text/javascript"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
        }

        .left {
            width: 89%;
            background: #fff;
            overflow: hidden;
        }

        .container {
            margin: 0;
            padding: 0;
            width: 100%;
            height: auto;
        }

        .right {
            width: 11%;
            background: #fff;
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
        }

        .right .container {
            position: relative;
            background: #fff;
        }

        .w-txt {
            margin: 0 10px 10px 15px;
        }

        .w-txt .title{
            height: 30px;
            line-height: 30px;
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }

        .txt-head {
            color: #000;
            font-size: 20px;
            height: 30px;
            line-height: 30px;
            padding-left: 48px;
            background: url('${pageContext.request.contextPath}/img/icon-shh.png') no-repeat 11px 1px;
            background-size: contain;
        }

        .txt-table{
            table-layout:fixed;
        }

        .txt-table td {
            width: 50%;
            padding: 20px 0 10px;
            font-size: 14px;
            word-break: break-all;
            vertical-align: top;
            border-bottom: 1px solid #eee;
        }

        .txt-table td.name {
            font-weight: bold;
            text-align:center;
            vertical-align:middle;
        }

        .txt-table td.txt {
        }

        .txt-table td a {
            width: 22px;
            height: 22px;
            display: inline-block;
            float: left;
            background-position: 0 0;
            background-repeat: no-repeat;
            background-size: cover;
            margin-right: 15px;
            margin-bottom: 10px;
        }

        .txt-table a.icon-loginFtp {
            background-image: url('${pageContext.request.contextPath}/img/icon-loginFtp.png');
        }

        .txt-table a.icon-close {
            background-image: url('${pageContext.request.contextPath}/img/icon-ope-close.png');
        }
    </style>
</head>
<body>
<%--<div class="wrapper">--%>
    <%--<div id="console" style="float: left;width: 90%"></div>--%>
    <%--<div id="info" style="float: right; width: 10%">--%>

    <%--</div>--%>
<%--</div>--%>
<div class="con">
    <div class="left">
        <div class="container">
            <div id="console"></div>
        </div>
    </div>
    <div class="right">
        <div class="txt-head">
            <span>SHH</span>
        </div>
        <div class="container">
            <div class="w-txt">
                <div class="title">会话详情</div>
                <table class="txt-table">
                    <tbody>
                    <tr>
                        <td class="name">连接ip</td>
                        <td class="txt">${sshHostInfo.ip}</td>
                    </tr>
                    <tr>
                        <td class="name">登录用户</td>
                        <td class="txt">${sshHostInfo.username}</td>
                    </tr>
                    <tr>
                        <td class="name">系统信息</td>
                        <td class="txt">${sshHostInfo.systemInfo}</td>
                    </tr>
                    <tr>
                        <td class="name">系统版本</td>
                        <td class="txt">${sshHostInfo.systemVer}</td>
                    </tr>
                    <tr>
                        <td class="name">计算机名</td>
                        <td class="txt">${sshHostInfo.hostname}</td>
                    </tr>
                    <tr>
                        <td class="name">开始时间</td>
                        <td class="txt" id="time">2019.3.6</td>
                    </tr>
                    <tr>
                        <td class="name">连接时间</td>
                        <td class="txt" id="ConnectionTime">0秒</td>
                    </tr>
                    <tr>
                        <td class="name">操作</td>
                        <td class="txt">
                            <a class="icon-loginFtp" title="登录到FTP" href="javascript: void(0);" id="loginFtp"></a>
                            <a class="icon-close" title="退出" href="${pageContext.request.contextPath}/sshController/stopConnection"></a>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script type="application/javascript">

    /*初始化高度*/
      restart();

      function restart() {
          $('.left').css('height', $(window).height() + 'px');
          $('.right').css('height', $(window).height() + 'px');
      }

      $(window).resize(function () {
          restart();
      });

      /*初始化时间开始*/
      //补0操作
      function getzf(num){
          if(parseInt(num) < 10){
              num = '0'+num;
          }
          return num;
      }
      var startDate=new Date();
      $("#time").html(startDate.getFullYear() + '-' + (getzf(startDate.getMonth() + 1)) + '-' + getzf(startDate.getDate()) + '  ' + getzf(startDate.getHours()) + ':' + getzf(startDate.getMinutes()) + ':' + getzf(startDate.getSeconds()));

    setInterval(function(){
        var time=new Date().getTime()-startDate.getTime();
        $("#ConnectionTime").html(formatSeconds(time/1000));
    },1000);
      function formatSeconds(value) {
          var secondTime = parseInt(value);// 秒
          var minuteTime = 0;// 分
          var hourTime = 0;// 小时
          if(secondTime > 60) {//如果秒数大于60，将秒数转换成整数
              //获取分钟，除以60取整数，得到整数分钟
              minuteTime = parseInt(secondTime / 60);
              //获取秒数，秒数取佘，得到整数秒数
              secondTime = parseInt(secondTime % 60);
              //如果分钟大于60，将分钟转换成小时
              if(minuteTime > 60) {
                  //获取小时，获取分钟除以60，得到整数小时
                  hourTime = parseInt(minuteTime / 60);
                  //获取小时后取佘的分，获取分钟除以60取佘的分
                  minuteTime = parseInt(minuteTime % 60);
              }
          }
          var result = "" + parseInt(secondTime) + "秒";

          if(minuteTime > 0) {
              result = "" + parseInt(minuteTime) + "分" + result;
          }
          if(hourTime > 0) {
              result = "" + parseInt(hourTime) + "小时" + result;
          }
          return result;
      }
      /*初始化时间结束*/

    $('#loginFtp').click(function () {
        location.href="/sshController/openSftp";
    });
        var $console = $('#console');
        debugger;
        var resizeTerminal = function (t, c, r) {
            $(".terminal").height($('#console').height());
            t.resize(c, r);
        };

        var getSize = function () {
            function getCharSize() {
                var span = $("<span>", { text: "qwertyuiopasdfghjklzxcvbnm" });
                $console.append(span);
                var lh = span.css("height");
                lh = lh.substr(0, lh.length - 2);
                var size = {
                    width: span.width() / 25,
                    height: span.height() - (lh / 3.5)
                };
                span.remove();
                return size;
            }

            function getwindowSize() {
                var body_height = $(window).height();
                var body_width = $(window).width() - $(".right").width();
                var terminal_height = body_height-26;
                return {
                    width: body_width,
                    height: terminal_height
                };
            }
            var charSize = getCharSize();
            var windowSize = getwindowSize();

            return {
                cols: Math.floor(windowSize.width / charSize.width),
                rows: Math.floor(windowSize.height / charSize.height) - 5
            };
        };

        window.WebSocket = window.WebSocket || window.MozWebSocket;
        var cols = getSize().cols;
        var rows = getSize().rows;
        var term = null;
        var socket = new WebSocket('ws://${uri}/sockjs/socketServer?cols=' + cols + '&rows=' + rows);

        Terminal.applyAddon(fit);
        Terminal.applyAddon(attach);

        socket.onopen = function () {
            term = new Terminal({
                termName: "xterm",
                cols: cols,
                rows: rows,
                useStyle: true,
                convertEol: true,
                screenKeys: true,
                cursorBlink: false,
                visualBell: true,
                colors: Terminal.xtermColors
            });

            console.log(term);

            term.attach(socket);
            term._initialized = true;

            term.open($console.get(0));
            term.fit();

            resizeTerminal(term, cols, rows);

            $(window).resize(function () {
                resizeTerminal(term, cols, rows);
            });
            window.term = term;
            window.socket = socket;
        };
        socket.onclose = function (e) {
            term.destroy();
            $.get('/sshController/stopConnection');
        };
        socket.onerror = function (e) {
            console.log("Socket error:", e);
        };
</script>
</body>
</html>
