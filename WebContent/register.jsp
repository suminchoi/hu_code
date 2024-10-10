<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
	<script>
	    function validateForm() {
	        // csm_이름 검증: 최대 15자, 영문자만 허용
	        var name = document.getElementById("username").value;
	        var namePattern = /^[a-zA-Z]{1,15}$/;
	        if (!namePattern.test(name)) {
	            alert("check your name");
	            return false;
	        }
	
	     	// csm_이메일 검증: 최대 20자
	        var email = document.getElementById("email").value;
	        if (email.length > 20) {
	            alert("check your email!");
	            return false;
	        }
	        
	     	// csm_주소 검증: 최대 50자
			var address = document.getElementById("address").value;
			var addressPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9\s]{1,50}$/;
			
			if (!addressPattern.test(address)) {
			    alert("Address must contain both letters and numbers, and be no longer than 50 characters.");
			    return false;
			}

	
	        // csm_전화번호 검증: 최대 10자리 숫자
	        var phone = document.getElementById("mobile").value;
	        var phonePattern = /^\d{10,12}$/; // 10~12자리 숫자만 허용
	        if (!phonePattern.test(phone)) {
	            alert("check your mobile");
	            return false;
	        }
	
	        // csm_우편번호 검증: 최대 5자리 숫자
	        var pin = document.getElementById("pincode").value;
	        var pinPattern = /^\d{1,5}$/; // 최대 5자리 숫자
	        if (!pinPattern.test(pin)) {
	            alert("check your pin");
	            return false;
	        }
	
	     	// csm_비밀번호 검증: 최소 8자, 최대 20자, 대/소문자, 숫자, 특수문자 필수 포함
			var password = document.getElementById("password").value;
			var confirmPassword = document.getElementById("confirmPassword").value;
			
			// 대문자, 소문자, 숫자, 특수문자 검증을 개별적으로 수행
			var upperCasePattern = /[A-Z]/;
			var lowerCasePattern = /[a-z]/;
			var numberPattern = /\d/;
			var specialCharPattern = /[!@#$%^&*(),.?":{}|]/; // < > 는 제외
			
			// 비밀번호 길이 검증 (8~20자)
			if (password.length < 8 || password.length > 20) {
			    alert("Password must be between 8 and 20 characters long.");
			    return false;
			}
			
			// 대문자 검증
			if (!upperCasePattern.test(password)) {
			    alert("Password must include at least one uppercase letter.");
			    return false;
			}
			
			// 소문자 검증
			if (!lowerCasePattern.test(password)) {
			    alert("Password must include at least one lowercase letter.");
			    return false;
			}
			
			// 숫자 검증
			if (!numberPattern.test(password)) {
			    alert("Password must include at least one number.");
			    return false;
			}
			
			// 특수문자 검증 (특수문자는 < > 제외)
			if (!specialCharPattern.test(password)) {
			    alert("Password must include at least one special character (excluding < and >).");
			    return false;
			}
			
			// 비밀번호 확인 일치 검증
			if (password !== confirmPassword) {
			    alert("Passwords do not match.");
			    return false;
			}

	
	     	// csm_비밀번호 일치 검증
	        if (password !== confirmPassword) {
	            alert("check your password2!.");
	            return false;
	        }
	
	        // All validations passed
	        return true;
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
            <form action="./RegisterSrv" method="post" class="col-md-6 col-md-offset-3"
                style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;"
                onsubmit="return validateForm();"> <!-- 유효성 검사 추가 -->

                <div style="font-weight: bold;" class="text-center">
                    <h2 style="color: green;">Registration Form</h2>
                    <% if (message != null) { %>
                        <p style="color: blue;"><%= message %></p>
                    <% } %>
                </div>

                <div class="row">
                    <div class="col-md-6 form-group">
                        <label for="username">Name</label>
                        <input type="text" name="username" class="form-control" id="username" required>
                    </div>
                    <div class="col-md-6 form-group">
                        <label for="email">Email</label>
                        <input type="email" name="email" class="form-control" id="email" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea name="address" class="form-control" id="address" required></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 form-group">
                        <label for="mobile">Mobile</label>
                        <input type="number" name="mobile" class="form-control" id="mobile" required>
                    </div>
                    <div class="col-md-6 form-group">
                        <label for="pincode">Pin Code</label>
                        <input type="number" name="pincode" class="form-control" id="pincode" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 form-group">
                        <label for="password">Password</label>
                        <input type="password" name="password" class="form-control" id="password" required>
                    </div>
                    <div class="col-md-6 form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" required>
                    </div>
                </div>

                <div class="row text-center">
                    <div class="col-md-6" style="margin-bottom: 2px;">
                        <button type="reset" class="btn btn-danger">Reset</button>
                    </div>
                    <div class="col-md-6">
                        <button type="submit" class="btn btn-success">Register</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="footer.html" %>
</body>
</html>
