package com.socket.util;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;
import com.socket.domain.SshHostInfo;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

public class SshUtil {

    private static Logger logger = LoggerFactory.getLogger(SshUtil.class);

    public static boolean validateConnect(SshHostInfo sshHostInfo) {

        // 建立连接
        Connection connection = new Connection(sshHostInfo.getIp(), sshHostInfo.getPort());
        Session sess = null;
        boolean isAuthenticated = false;
        try {
            // 连接上
            connection.connect();
            // 这句非常重要，开启远程的客户端
            // 进行校验
            isAuthenticated = connection.authenticateWithPassword(
                    sshHostInfo.getUsername(), sshHostInfo.getPassword());
            sess = connection.openSession();
            sess.requestPTY("vt100", 80, 24, 640, 480, null);
            if (isAuthenticated) {
                String cmd = cmd(sess, "head -n 1 /etc/issue\nhostname\nuname -a");
                String[] cmdArray = cmd.split("\\r\\n");
                sshHostInfo.setSystemVer(cmdArray[0]);
                sshHostInfo.setHostname(cmdArray[1]);
                sshHostInfo.setSystemInfo(cmdArray[2]);
            }
            return isAuthenticated;
        } catch (Exception e) {
            logger.error(e.getMessage());
            return false;
        } finally {
            connection.close();
            if (isAuthenticated) {
                sess.close();
            }
        }
    }

    private static String cmd(Session sess,String cmd) throws IOException {
        StringBuilder sb = new StringBuilder(256);
        InputStream stdout =null;
        BufferedReader br =null;
        try {
            sess.execCommand(cmd);
            stdout = new StreamGobbler(sess.getStdout());
            br = new BufferedReader(
                    new InputStreamReader(stdout));
            char[] arr = new char[512];
            int read;
            while (true) {
                // 将结果流中的数据读入字符数组
                read = br.read(arr, 0, arr.length);
                // 将结果拼装进StringBuilder
                sb.append(new String(arr, 0, read));
            }
        }catch (Exception ex){
            ex.getMessage();
        }finally {
            stdout.close();
            br.close();
        }
        return sb.toString();
    }
}
