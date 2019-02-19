package com.socket.interceptor;

import com.socket.domain.SshHostInfo;
import com.socket.util.ExpiryMap;
import com.socket.util.SshClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class SshShellHandler extends TextWebSocketHandler {
    private static Logger logger = LoggerFactory.getLogger(SshShellHandler.class);
    //WebSocketSession 连接信息
    public static final ExpiryMap<String, Map<String,Object>> userSocketSessionMap;
    private SshClient sshClient = null;
    static {
        userSocketSessionMap = new ExpiryMap<String,Map<String,Object>>();
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        super.handleTextMessage(session, handleMessage(message));
        //处理连接
        String sessionHttpId= (String)session.getAttributes().get("HTTP.SESSION.ID");
        SshClient sshClient=(SshClient)userSocketSessionMap.get(sessionHttpId).get("sshClient");
        try {
            //当客户端不为空的情况
            if (sshClient != null) {

                if (Arrays.equals("exit".getBytes(), message.asBytes())) {

                    if (sshClient != null) {
                        sshClient.disconnect();
                    }

                    session.close();
                    return ;
                }
                if(new String(message.asBytes(),"UTF-8").indexOf("远程端口转发")>-1){
                    sshClient.portForwarding(new String(message.asBytes(),"UTF-8").replaceAll("远程端口转发",""));
                    session.sendMessage(new TextMessage("远程端口转发成功"));
                }else{
                    sshClient.startShellOutPutTask(session);
                    sshClient.write(new String(message.asBytes(), "UTF-8"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.sendMessage(new TextMessage("An error occured, websocket is closed."));
            session.close();
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        super.afterConnectionClosed(session, status);
        String sessionHttpId= (String)session.getAttributes().get("HTTP.SESSION.ID");
        SshClient sshClient=(SshClient)userSocketSessionMap.get(sessionHttpId).get("sshClient");
        //关闭连接
        if (sshClient != null) {
            sshClient.disconnect();
        }
        userSocketSessionMap.remove(sessionHttpId);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        super.afterConnectionEstablished(session);
        String sessionHttpId= (String)session.getAttributes().get("HTTP.SESSION.ID");
        //update current in using machine
        if (session.getAttributes().get("sshHost")!=null && session.getAttributes().get("sshHost")!="") {
            SshHostInfo sshHostInfo = (SshHostInfo) session.getAttributes().get("sshHost");
            //添加到集合中
            logger.info("connect");

            //连接机器
            sshConnect(session, sshHostInfo,sessionHttpId);
        }
    }

    /**
     * 连接服务端
     * @param session
     * @param sshHostInfo
     */
    private void sshConnect(WebSocketSession session, SshHostInfo sshHostInfo,String sessionHttpId) {
        sshClient = new SshClient();
        String cols = String.valueOf(session.getAttributes().get("cols"));
        String rows = String.valueOf(session.getAttributes().get("rows"));
        try {
            session.sendMessage(new TextMessage("Try to connect...\r"));

            //连接服务器
            if (sshClient.connect(sshHostInfo,Integer.valueOf(cols),Integer.valueOf(rows))) {
                //开启线程，用于写数据到服务器上的
                sshClient.startShellOutPutTask(session);
                Map<String,Object> map=new HashMap<>();
                map.put("session",session);
                map.put("sshClient",sshClient);
                userSocketSessionMap.put(sessionHttpId, map,1000*60*60*12);
            }else {
                //取消连接
                sshClient.disconnect();
                session.sendMessage(new TextMessage("Connect failed, please confirm the username or password try agin."));
                session.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private TextMessage handleMessage(TextMessage message){
        if(new String(message.asBytes()).indexOf("远程端口转发：")>-1){
            return null;
        }
        return message;
    }
}
