package com.socket.controller;

import ch.ethz.ssh2.SFTPException;
import com.alibaba.fastjson.JSON;
import com.socket.domain.SshHostInfo;
import com.socket.util.SftpClient;
import com.socket.util.SshUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/sshController")
public class SshController {

    /**
     * 登录SSH
     * @return
     */
    @RequestMapping(value="/index_ssh")
    public String indexSsh(){
        return "login_ssh";
    }

    /**
     * 登录验证
     * @param request
     * @return 验证成功放行，失败返回到登录界面
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/openSsh")
    @ResponseBody
    public String loginSsh(SshHostInfo sshHostInfo, HttpServletRequest request) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        HttpSession session=request.getSession();
        //验证登录
        boolean flag=SshUtil.validateConnect(sshHostInfo);
        if(flag){
            session.setAttribute("sshHost",sshHostInfo);
            return "true";
        }
        return "false";

    }


    /**
     * @return 返回model
     */
    @RequestMapping(value = "/openShell")
    public String openShell(Model model, HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        SshHostInfo sshHostInfo = (SshHostInfo) session.getAttribute("sshHost");
        String url=request.getRequestURL().toString();
        model.addAttribute("sshHostInfo",sshHostInfo);
        model.addAttribute("uri",url.substring(url.indexOf("://")+3,url.indexOf("/sshController")));
        return "/ssh/sshView";
    }

    /**
     * @return 返回model
     */
    @RequestMapping(value = "/openSftp")
    public String openSftp(Model model, HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();
        SshHostInfo sshHostInfo = (SshHostInfo) session.getAttribute("sshHost");
        model.addAttribute("sshHostInfo",sshHostInfo);
        return "/ssh/sftpView";
    }

    @RequestMapping(value = "downloadFile")
    public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session=request.getSession();
        String fileFileName=request.getParameter("fileFileName");
        SftpClient sftp = (SftpClient) session.getAttribute("sftp");
            response.setHeader("Content-Disposition","attachment;fileName="
                    + java.net.URLEncoder.encode(fileFileName, "UTF-8"));
        response.setCharacterEncoding("UTF-8");
        InputStream inputStream =null;
        OutputStream outputStream =null;
            try {
                inputStream = sftp.downloadFile(fileFileName);
                outputStream = response.getOutputStream();
                int b;
                while((b=inputStream.read())!= -1)
                {
                    outputStream.write(b);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }finally {
                inputStream.close();
                outputStream.close();

            }
    }

    /**
     * 执行命令
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/execCommand")
    @ResponseBody
    public String execCommand(HttpServletRequest request, @RequestParam Map<String,Object> map) throws Exception{
        Map<String,String> returnMap=new HashMap<>();
        HttpSession session=request.getSession();
        SshHostInfo user = (SshHostInfo) session.getAttribute("sshHost");
        if(user==null){
            returnMap.put("code","203");
            returnMap.put("massage","用户未登陆！");
        } else {
            //get the sftp client from session
            SftpClient sftp = (SftpClient) session.getAttribute("sftp");

            if (sftp != null && sftp.isConnected()) {

                try {

                    switch (String.valueOf(map.get("cmd"))) {
                        case "cd": sftp.changeDirectory(String.valueOf(map.get("cmdParam"))); break;
                        case "cds": sftp.cdsDirectory(String.valueOf(map.get("cmdParam"))); break;
                        case "rm": sftp.deleteFile(String.valueOf(map.get("cmdParam"))); break;
                        case "mkdir": sftp.mkDir(String.valueOf(map.get("cmdParam"))); break;
                        case "attr": sftp.setAttributes(String.valueOf(map.get("fileFileName")), Integer.valueOf(String.valueOf(map.get("permissions")), 8));break;
                    }

                    String json = JSON.toJSONString(sftp.ls());
                    json = new String(json.getBytes("GBK"), "UTF-8");
                    return json;
                } catch (SFTPException ex) {
                    returnMap.put("code","201");
                    returnMap.put("massage","权限不够，操作失败！");
                } catch (IOException e) {
                    e.printStackTrace();
                    returnMap.put("code","201");
                    returnMap.put("massage","文件上传异常");
                }

            } else {
                returnMap.put("code","201");
                returnMap.put("massage","服务器连接失败");
            }
        }
        return JSON.toJSONString(returnMap);
    }

    /**
     * 判断文件是否存在
     *
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/exist")
    @ResponseBody
    public String exist(HttpServletRequest request, @RequestParam Map<String,String> map) throws Exception {
        HttpSession session=request.getSession();
        SftpClient sftp = (SftpClient) session.getAttribute("sftp");
        boolean falg=sftp.exist(map.get("fileName"));
        return String.valueOf(falg);
    }


    /**
     * 上传文件
     *
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/upload")
    @ResponseBody
    public String upload(HttpServletRequest request, @RequestParam("file") MultipartFile myfile) throws Exception {
        Map<String, String> returnMap = new HashMap<>();
        HttpSession session = request.getSession();
        SshHostInfo user = (SshHostInfo) session.getAttribute("sshHost");
        if (user == null) {
            returnMap.put("code", "203");
            returnMap.put("massage", "用户未登陆！");
        } else {
            //get the sftp client from session
            SftpClient sftp = (SftpClient) session.getAttribute("sftp");

            if (sftp != null && sftp.isConnected()) {

                try {
                    sftp.uploadFile(myfile, myfile.getOriginalFilename(), session);
                    String json = JSON.toJSONString(sftp.ls());
                    json = new String(json.getBytes("GBK"), "UTF-8");
                    return json;
                } catch (SFTPException ex) {
                    returnMap.put("code", "201");
                    returnMap.put("massage", "权限不够，操作失败！");
                } catch (IOException e) {
                    e.printStackTrace();
                    returnMap.put("code", "201");
                    returnMap.put("massage", "文件上传异常");
                }

            } else {
                returnMap.put("code", "201");
                returnMap.put("massage", "服务器连接失败");
            }
        }
        return JSON.toJSONString(returnMap);
    }


    /**
     * 连接SFTP
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/connectSftp")
    @ResponseBody
    public String connectSftp(HttpServletRequest request, @RequestParam Map<String,Object> map) throws UnsupportedEncodingException {
        Map<String,String> returnMap=new HashMap<>();
        HttpSession session=request.getSession();
        SshHostInfo sshHostInfo = (SshHostInfo) session.getAttribute("sshHost");
        SftpClient sftp = (SftpClient) session.getAttribute("sftp");

        if (sshHostInfo == null) {
            returnMap.put("code","203");
            returnMap.put("massage","用户未登陆！");
        } else {
            //else have machine in session ,but it is put in when open shell terminal, so should create new sftp client
            if (sftp == null){
                sftp = new SftpClient(sshHostInfo);
            }
            if (sftp != null && !sftp.isConnected()) {
                returnMap.put("code","201");
                returnMap.put("massage","服务器连接失败！");
                session.removeAttribute("sftp");
            } else {
                try {
                    String json = JSON.toJSONString(sftp.ls());
                    json = new String(json.getBytes("GBK"), "UTF-8");
                    //put the sftp client into session
                    session.setAttribute("sftp", sftp);
                    return json;
                } catch (IOException e) {
                    e.printStackTrace();
                    returnMap.put("code","201");
                    returnMap.put("massage","服务器系统异常！");
                }
            }
        }
        return JSON.toJSONString(returnMap);
    }

    /**
     * 关闭连接
     * @return
     */
    @RequestMapping(value = "/stopConnection")
    public String stopConnection(HttpServletRequest request) {
        HttpSession session=request.getSession();
        session.removeAttribute("sshHost");
        return "redirect:/sshController/index_ssh";
    }

    //get upload percent state

    /**
     * 获取上传进度
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/uploadState")
    @ResponseBody
    public String uploadState(HttpServletRequest request) throws UnsupportedEncodingException {
        HttpSession session=request.getSession();
        String state = (String) session.getAttribute("progress");
        if (state != null) {
            if (state.indexOf("100") != -1) {
                session.removeAttribute("progress");
            }
        } else {
            Map<String,String> returnMap=new HashMap<>();
            returnMap.put("percent","0.00%");
            returnMap.put("num","0");
            return  JSON.toJSONString(returnMap);
        }
        return state;
    }
}
