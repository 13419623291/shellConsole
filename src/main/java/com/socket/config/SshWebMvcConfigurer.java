package com.socket.config;

import com.socket.interceptor.SshLoginHandlerInterceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import javax.servlet.MultipartConfigElement;

/**
 * Class Name : WebMvcConfigurer.
 * Description : 配置类，添加并注册自定义拦截器.
 * Created by Jhony Zhang on 2016-05-03.
 */
@Configuration
@Import(WebSocketConfig.class)
public class SshWebMvcConfigurer extends WebMvcConfigurerAdapter {

    /**
     * logback日志
     */
    private static final Logger LOGGER = LoggerFactory.getLogger(SshWebMvcConfigurer.class);

    @Bean
    public SshLoginHandlerInterceptor loginHandlerInterceptor() {
        return new SshLoginHandlerInterceptor();
    }

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        //单个文件最大
        factory.setMaxFileSize("800MB"); //KB,MB
        /// 设置总上传数据总大小
        factory.setMaxRequestSize("1000MB");
        return factory.createMultipartConfig();
    }
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginHandlerInterceptor()).addPathPatterns("/sshController/openShell","/sshController/execCommand","/sshController/connectSftp","/sshController/stopConnection","/sshController/uploadState","/sshController/downloadFile","/sshController/openSftp");
        super.addInterceptors(registry);
    }


}
