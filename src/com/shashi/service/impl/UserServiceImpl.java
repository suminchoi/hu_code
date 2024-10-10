package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.shashi.beans.UserBean;
import com.shashi.constants.IUserConstants;
import com.shashi.service.UserService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.MailMessage;

public class UserServiceImpl implements UserService {

   @Override
   public String registerUser(String userName, Long mobileNo, String emailId, String address, int pinCode,
         String password) {

      UserBean user = new UserBean(userName, mobileNo, emailId, address, pinCode, password);

      String status = registerUser(user);

      return status;
   }

   @Override
   public String registerUser(UserBean user) {

      String status = "User Registration Failed!";

      boolean isRegtd = isRegistered(user.getEmail());

      if (isRegtd) {
         status = "Email Id Already Registered!";
         return status;
      }
      // csm_금지된 사용자명 리스트
      String[] restrictedUserNames = {
      "admin", "root", "administrator", "superuser", "sysadmin", "manager",
      "supervisor", "user", "support", "guest", "user1", "user2", "test",
      "temp", "demo", "default", "server", "localhost", "system", "machine",
      "pc", "workstation"
      };
      
      String userName = user.getName();
      
      // 사용자명 검증 (금지된 이름 체크)
      for (String restrictedName : restrictedUserNames) {
      if (userName.equalsIgnoreCase(restrictedName)) {
      status = "Username '" + restrictedName + "' is not allowed.";
      return status;
      }
      }
      
      // csm_비밀번호 검증 로직
      String password = user.getPassword();
      
      // 비밀번호 길이 검증 (8~20자)
      if (password.length() < 8 || password.length() > 20) {
          status = "Password must be between 8 and 20 characters long.";
          return status;
      }
      // 대문자 검증	
      if (!password.matches(".*[A-Z].*")) {
          status = "Password must include at least one uppercase letter.";
          return status;
      }
      // 소문자 검증
      if (!password.matches(".*[a-z].*")) {
          status = "Password must include at least one lowercase letter.";
          return status;
      }
      // 숫자 검증
      if (!password.matches(".*\\d.*")) {
          status = "Password must include at least one number.";
          return status;
      }
      // 특수문자 검증 (특수문자는 < > 제외)
      if (!password.matches(".*[!@#$%^&*(),.?\":{}|].*")) {
          status = "Password must include at least one special character (excluding < and >).";
          return status;
      }
      Connection conn = DBUtil.provideConnection();
      PreparedStatement ps = null;
      if (conn != null) {
         System.out.println("Connected Successfully!");
      }

      try {

         ps = conn.prepareStatement("insert into " + IUserConstants.TABLE_USER + " values(?,?,?,?,?,?)");

         ps.setString(1, user.getEmail());
         ps.setString(2, user.getName());
         ps.setLong(3, user.getMobile());
         ps.setString(4, user.getAddress());
         ps.setInt(5, user.getPinCode());
         ps.setString(6, user.getPassword());

         int k = ps.executeUpdate();

         if (k > 0) {
            status = "User Registered Successfully!";
            MailMessage.registrationSuccess(user.getEmail(), user.getName().split(" ")[0]);
         }

      } catch (SQLException e) {
         status = "Error: " + e.getMessage();
         e.printStackTrace();
      }

      DBUtil.closeConnection(ps);
      DBUtil.closeConnection(ps);

      return status;
   }

   @Override
   public boolean isRegistered(String emailId) {
      boolean flag = false;

      Connection con = DBUtil.provideConnection();

      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
         ps = con.prepareStatement("select * from user where email=?");

         ps.setString(1, emailId);

         rs = ps.executeQuery();

         if (rs.next())
            flag = true;

      } catch (SQLException e) {
         // TODO Auto-generated catch block
         e.printStackTrace();
      }

      DBUtil.closeConnection(con);
      DBUtil.closeConnection(ps);
      DBUtil.closeConnection(rs);

      return flag;
   }

   @Override
   public String isValidCredential(String emailId, String password) {
       String status = "Login Denied! Incorrect Username or Password";

       Connection con = DBUtil.provideConnection();
       PreparedStatement ps = null;
       ResultSet rs = null;

       try {
           ps = con.prepareStatement("SELECT * FROM user WHERE email=? AND password=?");
           ps.setString(1, emailId);
           ps.setString(2, password);
           rs = ps.executeQuery();

           if (rs.next()) {
               status = "valid"; // 로그인 성공
           }
       } catch (SQLException e) {
           status = "Error: " + e.getMessage();
           e.printStackTrace();
       } finally {
           DBUtil.closeConnection(con);
           DBUtil.closeConnection(ps);
           DBUtil.closeConnection(rs);
       }
       return status;
   }

   @Override
   public UserBean getUserDetails(String emailId, String password) {

      UserBean user = null;

      Connection con = DBUtil.provideConnection();

      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
         ps = con.prepareStatement("select * from user where email=? and password=?");
         ps.setString(1, emailId);
         ps.setString(2, password);
         rs = ps.executeQuery();

         if (rs.next()) {
            user = new UserBean();
            user.setName(rs.getString("name"));
            user.setMobile(rs.getLong("mobile"));
            user.setEmail(rs.getString("email"));
            user.setAddress(rs.getString("address"));
            user.setPinCode(rs.getInt("pincode"));
            user.setPassword(rs.getString("password"));

            return user;
         }

      } catch (SQLException e) {
         e.printStackTrace();
      }

      DBUtil.closeConnection(con);
      DBUtil.closeConnection(ps);
      DBUtil.closeConnection(rs);

      return user;
   }

   @Override
   public String getFName(String emailId) {
      String fname = "";

      Connection con = DBUtil.provideConnection();

      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
         ps = con.prepareStatement("select name from user where email=?");
         ps.setString(1, emailId);

         rs = ps.executeQuery();

         if (rs.next()) {
            fname = rs.getString(1);

            fname = fname.split(" ")[0];

         }

      } catch (SQLException e) {

         e.printStackTrace();
      }

      return fname;
   }

   @Override
   public String getUserAddr(String userId) {
      String userAddr = "";

      Connection con = DBUtil.provideConnection();
      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
         ps = con.prepareStatement("select address from user where email=?");

         ps.setString(1, userId);

         rs = ps.executeQuery();

         if (rs.next())
            userAddr = rs.getString(1);

      } catch (SQLException e) {

         e.printStackTrace();
      }

      return userAddr;
   }

}
