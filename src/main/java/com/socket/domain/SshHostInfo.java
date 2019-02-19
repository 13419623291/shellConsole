package com.socket.domain;

import java.io.Serializable;

public class SshHostInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    private String ip;
    private int port;
    private String username;
    private String password;
    private String systemVer;//版本
    private String hostname;//计算机名
    private String systemInfo;//系统信息

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSystemVer() {
        return systemVer;
    }

    public void setSystemVer(String systemVer) {
        this.systemVer = systemVer;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public String getSystemInfo() {
        return systemInfo;
    }

    public void setSystemInfo(String systemInfo) {
        this.systemInfo = systemInfo;
    }
}
