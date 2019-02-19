package com.socket.interceptor;

import com.socket.domain.SshHostInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Class Name : LoginHandlerInterceptor.
 * Description : 登陆拦截
 * @author Created by zuo on 2017/12/25.
 */
public class SshLoginHandlerInterceptor implements HandlerInterceptor {
    private static Logger logger = LoggerFactory.getLogger(SshLoginHandlerInterceptor.class);

    @Value("${server.port}")
    String port;

    /**
     * 判断session中是否有user 进行登陆拦截
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws IOException {
        //判断session中是否有user
        SshHostInfo sshHostInfo = (SshHostInfo) request.getSession().getAttribute("sshHost");
        if (sshHostInfo != null) {
          return true;
        } else {
            logger.warn("从session中获取用户失败，超时退登！");
            // 跳转到登录页面
            response.sendRedirect("/sshController/index_ssh");
            return false;
        }

    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
