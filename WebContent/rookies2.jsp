<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <!-- CryptoJS AES 암호화 라이브러리 추가 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.js"></script>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script> <!-- 리캡챠 라이브러리 로드 -->
    
    <script>
        function encryptCredentials() {
            var username = document.getElementById('username').value;
            var password = document.getElementById('password').value;
            var key = CryptoJS.enc.Utf8.parse('rookies-key12345'); // 대칭키, 서버와 동일하게 설정
            var encryptedUsername = CryptoJS.AES.encrypt(username, key, { mode: CryptoJS.mode.ECB }).toString();
            var encryptedPassword = CryptoJS.AES.encrypt(password, key, { mode: CryptoJS.mode.ECB }).toString();
            
            document.getElementById('username').value = encryptedUsername;
            document.getElementById('password').value = encryptedPassword;
        }
    </script>
    
     <script>
        function validateRecaptcha() {
            var response = document.querySelector('.g-recaptcha-response').value;
            if (response.length == 0) {
                alert("Please check your recaptcha.");
                return false;
            }
            return true;
        }

        function validateForm() {
            var username = document.getElementById("username").value;
            if (username.length > 15) {
                alert("Username cannot exceed 15 characters.");
                return false; 
            }

            var password = document.getElementById("password").value;
            var passwordPattern = /^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,20}$/;
            if (!passwordPattern.test(password)) {
                alert("Password must be between 8 and 20 characters and include at least one special character.");
                return false;
            }

            return validateRecaptcha();
        }
    </script> 
    
</head>
<body style="background-color: #E6F9E6;">

    <%@ include file="header.jsp" %>

    <%
        String message = request.getParameter("message");
    %>

    <div class="container">
        <div class="row" style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
            <form action="./LoginSrv" method="post" class="col-md-4 col-md-offset-4 col-sm-8 col-sm-offset-2"
                style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;" onsubmit="encryptCredentials()">
                <div style="font-weight: bold;" class="text-center">
                    <h2 style="color: green;">Login Form</h2>
                    <% if (message != null) { %>
                        <p style="color: blue;"><%= message %></p>
                    <% } %>
                </div>
                <div class="row">
                    <div class="col-md-12 form-group">
                        <label for="username">Username</label>
                        <input type="text" placeholder="Enter Username" name="username" class="form-control" id="username" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 form-group">
                        <label for="password">Password</label>
                        <input type="password" placeholder="Enter Password" name="password" class="form-control" id="password" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 form-group">
                        <label for="userrole">Login As</label>
                        <p id="userrole" class="form-control">ADMIN</p>
						<input type="hidden" name="usertype" value="admin">
                    </div>
                </div>
                <div class="g-recaptcha" data-sitekey="6LdbQVMqAAAAADYYVCPY80yQ5Kt-Q8hqiBUy8ubR"></div> <!--리캡챠 -->
                <div class="row">
                    <div class="col-md-12 text-center">
                        <button type="submit" class="btn btn-success">Login</button>
                    </div>
                </div>
                <!-- 비밀번호 찾기 링크 추가 -->
                <div class="row">
                    <div class="col-md-12 text-center">
                        <a href="searchpasswd.jsp" class="btn btn-link">Forgot Password?</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.html" />

</body>
</html>
