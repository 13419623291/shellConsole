package com.socket.util;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import com.socket.domain.SshHostInfo;
import org.springframework.web.socket.WebSocketSession;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

public class SshClient {
	
	private Connection conn;
	private Session sess;
	private InputStream in;
	private OutputStream out;
	private BufferedWriter inToShell;
	
	public boolean connect(SshHostInfo sshHostInfo,int cols,int rows) {
		try {
			conn = new Connection(sshHostInfo.getIp(), sshHostInfo.getPort());
			conn.connect();
			if (!conn.authenticateWithPassword(sshHostInfo.getUsername(), sshHostInfo.getPassword())) {
				return false;
			}
			sess = conn.openSession();
			System.out.println(cols+"==============="+rows);
			//TERM环境变量值,终端宽度(字符),终端高度(行),终端宽度(像素),终端高度(像素),
			sess.requestPTY("xterm", cols, rows,0,0, null);
			sess.startShell();
			in = sess.getStdout();
			out = sess.getStdin();
			inToShell = new BufferedWriter(new OutputStreamWriter(out, "UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	/**
	 * 写命令到服务
	 * @param text
	 * @throws IOException
	 */
	public void write(String text) throws IOException {
		if (inToShell != null) {
			//写命令到服务器
			inToShell.write(text);
			//刷到服务器上
			inToShell.flush();
		}
	}
	
	public void startShellOutPutTask(WebSocketSession session) {
		new ShellOutPutTask(session, in).start();
	}

	public void portForwarding(String ipPort) throws IOException{
		String [] ipPortArr=ipPort.split("-");
		String cmd="ssh -N -F -R "+Integer.valueOf(ipPortArr[3])+":"+ipPortArr[0]+":"+Integer.valueOf(ipPortArr[1])+" "+ipPortArr[2];
		System.out.println(cmd);
		sess.execCommand(cmd);
	}

	public void disconnect() {
		if (conn != null) {
			conn.close();
		}
		if (sess != null){
			sess.close();
	}
		conn = null;
		sess = null;
	}
}
