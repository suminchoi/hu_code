<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
   pageEncoding="ISO-8859-1"%>
<%@ page
   import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>User Profile</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
   href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
   src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
   href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color: #E6F9E6;">

   <%
   // 세션에서 사용자 이름과 비밀번호를 가져오기
   String userName = (String) session.getAttribute("username");
   String password = (String) session.getAttribute("password");

   // 사용자가 로그인하지 않은 경우 로그인 페이지로 리다이렉트
   if (userName == null || password == null) {
      response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
      return; // 로그인 페이지로 리다이렉트 후 처리 종료
   }

   String inputPassword = request.getParameter("inputPassword");
   boolean isPasswordCorrect = (inputPassword != null && inputPassword.equals(password));

   // 사용자의 정보를 가져오기 위한 UserService 객체 생성
   UserService dao = new UserServiceImpl();
   UserBean user = dao.getUserDetails(userName, password);
   if (user == null) {
      user = new UserBean("Test User", 98765498765L, "test@gmail.com", "ABC colony, Patna, bihar", 87659, "lksdjf");
   }
   %>

   <jsp:include page="header.jsp" />

   <div class="container bg-secondary">
      <div class="row">
         <div class="col">
            <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
               <ol class="breadcrumb mb-0">
                  <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                  <li class="breadcrumb-item active" aria-current="page">User Profile</li>
               </ol>
            </nav>
         </div>
      </div>

      <div class="row">
         <div class="col-lg-4">
            <div class="card mb-4">
               <div class="card-body text-center">
                  <img src="images/profile.jpg" class="rounded-circle img-fluid"
                     style="width: 150px;">
                  <h5 class="my-3">
                     User
                     <%= user.getName() %>
                     Profile
                  </h5>
               </div>
            </div>
         </div>
         <div class="col-lg-8">
            <div class="card mb-4">
               <div class="card-body">
                  <% if (isPasswordCorrect) { %>
                  <h5 style="font-size: 2rem;">Your Profile Details</h5>
                  <div class="row">
                     <div class="col-sm-3">
                        <p class="mb-0">Full Name</p>
                     </div>
                     <div class="col-sm-9">
                        <p class="text-muted mb-0"><%=user.getName()%></p>
                     </div>
                  </div>
                  <hr>
                  <div class="row">
                     <div class="col-sm-3">
                        <p class="mb-0">Email</p>
                     </div>
                     <div class="col-sm-9">
                        <p class="text-muted mb-0"><%=user.getEmail()%>
                        </p>
                     </div>
                  </div>
                  <hr>
                  <div class="row">
                     <div class="col-sm-3">
                        <p class="mb-0">Phone</p>
                     </div>
                     <div class="col-sm-9">
                        <p class="text-muted mb-0"><%=user.getMobile()%>
                        </p>
                     </div>
                  </div>
                  <hr>
                  <div class="row">
                     <div class="col-sm-3">
                        <p class="mb-0">Address</p>
                     </div>
                     <div class="col-sm-9">
                        <p class="text-muted mb-0"><%=user.getAddress()%>
                        </p>
                     </div>
                  </div>
                  <hr>
                  <div class="row">
                     <div class="col-sm-3">
                        <p class="mb-0">PinCode</p>
                     </div>
                     <div class="col-sm-9">
                        <p class="text-muted mb-0"><%=user.getPinCode()%>
                        </p>
                     </div>
                  <% } else { %>
                  <form action="userProfile.jsp" method="post" class="form-inline">
    <div class="form-group mb-2">
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" class="form-control" id="inputPassword" name="inputPassword" placeholder="Enter Password" required>
    </div>
    <!-- 버튼 스타일 수정 -->
    <button type="submit" class="btn btn-custom mb-2">Please enter your password.</button>
</form>
                 <style>
    .btn-custom {
        background-color: #90EE90; /* 연두색 */
        color: white; /* 텍스트 색상 */
        border: none; /* 테두리 없애기 */
        padding: 10px 20px; /* 버튼 패딩 */
        border-radius: 5px; /* 둥근 모서리 */
        font-weight: bold; /* 텍스트 굵게 */
        cursor: pointer;
    }

    .btn-custom:hover {
        background-color: #76C76C; /* 버튼 호버 시 더 짙은 연두색 */
    }
</style>
                 
                  <% } %>
               </div>
            </div>
         </div>
      </div>
   </div>

   <br><br><br>
   <%@ include file="footer.html" %>

</body>
</html>
