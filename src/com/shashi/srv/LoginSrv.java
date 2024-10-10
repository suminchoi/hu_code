package com.shashi.srv;

import java.io.IOException;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Base64;
import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String SECRET_KEY = "rookies-key12345"; // 대칭키, 클라이언트와 동일하게 설정

    // AES 복호화 메소드
    private String decrypt(String encryptedData) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(SECRET_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        
        byte[] decodedData = Base64.getDecoder().decode(encryptedData);
        byte[] decryptedData = cipher.doFinal(decodedData);
        return new String(decryptedData).trim();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String encryptedUserName = request.getParameter("username");
        String encryptedPassword = request.getParameter("password");
        String userType = request.getParameter("usertype");
        response.setContentType("text/html");

        String userName = null;
        String password = null;
        
        try {
            // 암호화된 값 복호화
            userName = decrypt(encryptedUserName);
            password = decrypt(encryptedPassword);
        } catch (Exception e) {
            e.printStackTrace();
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Decryption Failed");
            rd.forward(request, response);
            return;
        }

        String status;

        if ("admin".equals(userType)) {
            // Admin Login
            if ("rookies20@gmail.com".equals(userName) && "godrookies20".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", userName);
                session.setAttribute("password", password);
                session.setAttribute("usertype", userType);
                RequestDispatcher rd = request.getRequestDispatcher("rookiesViewProduct.jsp");
                rd.forward(request, response);
                return;
            } else {
                status = "Login Denied! Invalid Admin Username or Password.";
            }
        } else {
            // Customer Login
            UserServiceImpl udao = new UserServiceImpl();
            status = udao.isValidCredential(userName, password);
            if ("valid".equalsIgnoreCase(status)) {
                UserBean user = udao.getUserDetails(userName, password);
                HttpSession existingSession = request.getSession(false);
                if (existingSession != null) {
			        existingSession.invalidate();
			    }
                
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("userdata", user);
                newSession.setAttribute("username", userName);
                newSession.setAttribute("password", password);
                newSession.setAttribute("usertype", userType);
                RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");
                rd.forward(request, response);
                return;
            } else {
                status = "Login Denied! Invalid Username or Password.";
            }
        }

        RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}