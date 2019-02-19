<%--
  Created by IntelliJ IDEA.
  User: duyu
  Date: 2019/1/18
  Time: 17:20
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
    <script src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js"></script>
    <%--<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">--%>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
    <!--[if lt IE 9]>
    <script src="http://apps.bdimg.com/libs/html5shiv/3.7/html5shiv.min.js"></script>
    <script src="http://apps.bdimg.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <title>${sshHostInfo.ip}FTP</title>
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
            background: url('${pageContext.request.contextPath}/img/icon-ftp.png') no-repeat 11px 1px;
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

        .up-w{
            display: inline-block;
            width: 22px;
            height: 22px;
            float: left;
            margin-right: 15px;
            margin-bottom: 10px;
            background-position: 0 0;
            background-repeat: no-repeat;
            background-size: cover;
            background-image: url('${pageContext.request.contextPath}/img/icon-ope-up.png');
        }

        .up-w label{
            width: 22px;
            height: 22px;
            display: inline-block;
            cursor: pointer;
        }

        .up-w input{
            display: none;
        }

        .txt-table a.icon-show {
            background-image: url('${pageContext.request.contextPath}/img/icon-ope-show.png');
        }

        .txt-table a.icon-loginSsh {
            background-image: url('${pageContext.request.contextPath}/img/icon-loginSsh.png');
        }

        .txt-table a.icon-close {
            background-image: url('${pageContext.request.contextPath}/img/icon-ope-close.png');
        }
    </style>
</head>
<body>
<%--提示--%>
<div class="modal fade" id="msgModal" tabindex="-1" role="dialog"
     aria-labelledby="msgModalLabel" data-backdrop="static">
    <div class="modal-dialog">
        <div id="message" style="text-align: center"></div>
    </div>
</div>
<%--删除--%>
<div class="modal fade" id="removeModal" tabindex="-1" role="dialog"
     aria-labelledby="removeModalLabel" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="removeModalLabel">删除</h4>
            </div>
            <div class="modal-body">确定删除这个文件？</div>
            <div class="modal-footer">
                <button id="subRemove" type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<%--上传历史--%>
<div class="modal fade" id="uploadHistory" tabindex="-1" role="dialog"
     aria-labelledby="uploadHistoryLabel" aria-hidden="true" data-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-hidden="true">&times;</button>
                <h4 class="modal-title">上传历史</h4>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                <table class="table table-condensed text-nowrap" id="historyTable">
                    <thead>
                    <tr>
                        <th>目标路径</th>
                        <th>文 件 名</th>
                        <th>文件类型</th>
                        <th>文件大小</th>
                        <th>上传进度</th>
                        <th>上传结果</th>
                        <th>开始时间</th>
                        <th>结束时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<div class="con">
    <div class="left">
        <div class="container" style="padding-left: 15px;">
            <div style="width: 100%;">
                <div style="height: 50px;line-height: 50px;">
                    <input type="hidden" id="currentCatalog"/>
                    <label class="panel-title pull-left" style="margin-top:5px" id="catalog"></label>
                </div>
                <div class="w-table" style="padding:0;overflow-y:scroll;width: 100%;">
                    <table class="table table-striped  table-responsive table-hover">
                        <thead>
                        <tr>
                            <th>文件名称</th>
                            <th>文件大小</th>
                            <th>创建时间</th>
                            <th>属性</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="file-list">
                        </tbody>
                    </table>
                </div>
                <div class="progress progress-striped active" style="margin-bottom:10px">
                    <div class="progress-bar progress-bar-info" role="progressbar"
                         aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
                         style="width: 0%;">
                        <span id="percent">00.00%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="right">
        <div class="txt-head">
            <span>FTP</span>
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
                        <td class="name">操   作</td>
                        <td class="txt">
                            <div class="up-w">
                                <label class="sel-upimg" title="上传文件" for="file"></label>
                                <input type="file" name="file" id="file" onchange="uploadFile()" accept="image/png,image/jpeg,image/gif">
                            </div>
                            <a class="icon-show" title="查看上传历史" href="javascript: void(0);" data-toggle="modal" data-target="#uploadHistory"></a>
                            <a class="icon-loginSsh" title="登录到SSH" href="javascript: void(0);" id="loginToSsh" onclick="loginSsh()"></a>
                            <a class="icon-close" title="退出" href="${pageContext.request.contextPath}/sshController/stopConnection"></a>
                        </td>
                    </tr>
                    <tr>
                        <td class="name">上传文件名</td>
                        <td class="txt" id="ftpName"></td>
                    </tr>
                    <tr>
                        <td class="name">上传进度</td>
                        <td class="txt" id="state">0.00%</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/sftp.js"></script>
<script type="application/javascript">
    /*初始化高度*/
    restart();

    function restart() {
        $('.w-table').css('height', $(window).height()-90 + 'px');
        $('.right').css('height', $(window).height() + 'px');
    }

    $(window).resize(function () {
        restart();
    });

    /*初始化时间开始*/
    var startDate=new Date();
    $("#time").html(dateFormate(startDate.getTime()));

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
</script>
</html>
