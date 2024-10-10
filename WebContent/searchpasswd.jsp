<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<title>Find Password</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #E6F9E6;">
    <%@ include file="header.jsp" %>
    <%
        String message = request.getParameter("message");
    %>
    <div class="container">
        <div class="row" style="margin-top: 5px; margin-left: 2px; margin-right: 2px;">
            <form action="./SearchPasswdSrv" method="post" class="col-md-6 col-md-offset-3"
                style="border: 2px solid black; border-radius: 10px; background-color: #FFE5CC; padding: 10px;">
                <div style="font-weight: bold;" class="text-center">
                    <h2 style="color: green;">Find Your Password</h2>
                    <% if (message != null) { %>
                    <p style="color: red;"><%= message %></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="username">Name</label>
                    <input type="text" name="username" class="form-control" id="username" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" name="email" class="form-control" id="email" required>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-success">Find Password</button>
                </div>
            </form>
        </div>
    </div>
    <%@ include file="footer.html" %>
</body>
</html>
