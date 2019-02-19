package com.socket.config;

import com.socket.interceptor.HandshakeInterceptor;
import com.socket.interceptor.SshShellHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Configuration
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {
    @Bean
    public HandshakeInterceptor handshakeInterceptor(){ return new HandshakeInterceptor();  }
    @Bean
    public TextWebSocketHandler webSocketHandler(){
        return new SshShellHandler();
    }
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(webSocketHandler(), "/sockjs/socketServer").setAllowedOrigins("**/sockjs/socketServer/**").addInterceptors(handshakeInterceptor());
    }

}
