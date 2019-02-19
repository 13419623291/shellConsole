package com.socket.interceptor;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import java.util.Map;

public class HandshakeInterceptor extends HttpSessionHandshakeInterceptor {

	@Override
	public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
                               Exception ex) {
		super.afterHandshake(request, response, wsHandler, ex);
	}

	@Override
	public boolean beforeHandshake(ServerHttpRequest arg0, ServerHttpResponse arg1, WebSocketHandler arg2,
                                   Map<String, Object> arg3) throws Exception {
		String cols = ((ServletServerHttpRequest) arg0).getServletRequest().getParameter("cols");
		String rows = ((ServletServerHttpRequest) arg0).getServletRequest().getParameter("rows");
		arg3.put("cols",cols);
		arg3.put("rows",rows);
		return super.beforeHandshake(arg0, arg1, arg2, arg3);
	}

}
