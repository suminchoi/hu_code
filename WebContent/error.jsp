<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오류 발생</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #ffffff;
            font-family: Arial, sans-serif;
        }
        .error-container {
            text-align: center;
            background-color: #22e322;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #E6F9E6;
        }
        p {
            color: #E6F9E6;
        }
        a {
            text-decoration: none;
            color: #E6F9E6;
        }
    </style>
    <script>
        // 페이지 로드 시 alert을 표시
        window.onload = function() {
            alert("서버에서 오류가 발생했습니다. 다시 시도해 주세요.");
        }
    </script>
</head>
<body>
    <div class="error-container">
        <h1>문제가 발생했습니다!</h1>
        <p>죄송합니다. 서버에서 오류가 발생했습니다. 다시 시도해 주세요.</p>
        <p><a href="index.jsp">홈으로 돌아가기</a></p>
    </div>
</body>
</html>
