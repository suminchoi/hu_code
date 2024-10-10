<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Payments</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <!-- CryptoJS AES 암호화 라이브러리 추가 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/crypto-js.js"></script>
    <script>
        function encryptPaymentDetails() {
            // 카드 소유자 이름, 카드 번호, CVV, 유효 기간(월, 년) 정보를 가져옵니다.
            var cardholder = document.getElementById('cardholder').value;
            var cardnumber = document.getElementById('cardnumber').value;
            var cvv = document.getElementById('cvv').value;
            var expmonth = document.getElementById('expmonth').value;
            var expyear = document.getElementById('expyear').value;

            // 대칭키와 랜덤 초기화 벡터 생성
            var key = CryptoJS.enc.Utf8.parse('rookies-key12345'); // 대칭키
            var iv = CryptoJS.lib.WordArray.random(16); // 랜덤 초기화 벡터 생성
            
            // 카드 정보 암호화
            var encryptedCardholder = CryptoJS.AES.encrypt(cardholder, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC
            }).toString();
            var encryptedCardnumber = CryptoJS.AES.encrypt(cardnumber, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC
            }).toString();
            var encryptedCVV = CryptoJS.AES.encrypt(cvv, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC
            }).toString();
            var encryptedExpmonth = CryptoJS.AES.encrypt(expmonth, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC
            }).toString();
            var encryptedExpyear = CryptoJS.AES.encrypt(expyear, key, {
                iv: iv,
                mode: CryptoJS.mode.CBC
            }).toString();

            // 암호화된 값을 폼 필드에 설정
            document.getElementById('cardholder').value = encryptedCardholder;
            document.getElementById('cardnumber').value = encryptedCardnumber;
            document.getElementById('cvv').value = encryptedCVV;
            document.getElementById('expmonth').value = encryptedExpmonth;
            document.getElementById('expyear').value = encryptedExpyear;
        }
    </script>
</head>
<body style="background-color: #E6F9E6;">
<%
    /* Checking the user credentials */
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        return; // Ensure the page processing stops after redirect
    }

    String sAmount = request.getParameter("amount");
    double amount = 0;

    if (sAmount != null) {
        try {
            amount = Double.parseDouble(sAmount);
        } catch (NumberFormatException e) {
            // Handle the error gracefully
            out.println("<script>alert('Invalid amount format!');</script>");
        }
    }
%>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="row" style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
        <form action="./OrderServlet" method="post" class="col-md-6 col-md-offset-3"
              style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;" onsubmit="encryptPaymentDetails()">
            <div style="font-weight: bold;" class="text-center">
                <div class="form-group">
                    <img src="images/profile.jpg" alt="Payment Proceed" height="100px" />
                    <h2 style="color: green;">Credit Card Payment</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 form-group">
                    <label for="cardholder">Name of Card Holder</label>
                    <input type="text" placeholder="Enter Card Holder Name" name="cardholder" class="form-control" id="cardholder" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 form-group">
                    <label for="cardnumber">Enter Credit Card Number</label>
                    <input type="password" placeholder="4242-4242-4242-4242" name="cardnumber" class="form-control" id="cardnumber" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 form-group">
                    <label for="expmonth">Expiry Month</label>
                    <input type="number" placeholder="MM" name="expmonth" class="form-control" size="2" max="12" min="1" id="expmonth" required>
                </div>
                <div class="col-md-6 form-group">
                    <label for="expyear">Expiry Year</label>
                    <input type="number" placeholder="YYYY" class="form-control" size="4" id="expyear" name="expyear" required>
                </div>
            </div>
            <div class="row text-center">
                <div class="col-md-6 form-group">
                    <label for="cvv">Enter CVV</label>
                    <input type="password" placeholder="123" class="form-control" size="3" id="cvv" name="cvv" required>
                    <input type="hidden" name="amount" value="<%=amount%>">
                </div>
                <div class="col-md-6 form-group">
                    <label>&nbsp;</label>
                    <button type="submit" class="form-control btn btn-success">Pay : Rs <%=amount%></button>
                </div>
            </div>
        </form>
    </div>
</div>

<%@ include file="footer.html" %>
</body>
</html>
