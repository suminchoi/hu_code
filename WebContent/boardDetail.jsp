<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세 보기</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/ganjibutton.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap'); /* 폰트 설정 */

        body {
            margin: 0;
            height: 100vh;
            background-image: linear-gradient(to top, #e0f7fa, #b2ebf2);
            background-repeat: no-repeat;
            background-size: cover;
            background-attachment: fixed;
            font-family: 'Roboto', sans-serif; /* 폰트 변경 */
        }
        .board-detail-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            position: relative;
        }
        .content-box {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .comment-form {
            background-color: #e0f2f1;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            margin-top: 30px;
        }
        .comment-box {
            background-color: #e8f5e9;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 10px;
        }
        .content-box h5, .comment-form h5 {
            margin-bottom: 10px;
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }
        .content-box p, .comment-box p {
            margin: 0;
            padding: 5px 0;
            line-height: 1.6;
        }
        .btn-container {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-container .btn {
            padding: 10px 50px;
            font-size: 1rem;
        }
        .sk-logo {
            position: absolute;
            top: 0; /* 맨 위로 */
            left: 0; /* 왼쪽으로 */
            width: 100px;
            height: auto;
        }
    </style>
</head>
<body>
    <!-- 카트 로고 이미지 추가 -->
    <img src="images/Shopping_Cart_Logo.png" alt="Shopping Cart 로고" class="sk-logo">
    
    <div class="container board-detail-container">
        <%
            String loggedInUser = null;

            // 로그인된 사용자 확인
            if (session != null) {
                loggedInUser = (String) session.getAttribute("username");
            }

            if (loggedInUser == null) {
                out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
                return;
            }

            String idParam = request.getParameter("id");
            int id = 0;

            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                out.println("올바르지 않은 ID 값입니다.");
                return;
            }

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // 데이터베이스 연결
                conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=UTF-8", "dbuser", "1234");
                // PreparedStatement를 사용하여 안전하게 SQL 실행
                String sql = "SELECT * FROM board WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String fileName = rs.getString("file_name");
                    String postAuthor = rs.getString("author");

                    // 게시글 작성자와 로그인한 사용자가 일치하지 않을 경우 접근 차단
                    if (!loggedInUser.equals(postAuthor)) {
                        out.println("<script>alert('해당 게시글에 접근할 권한이 없습니다.'); history.back();</script>");
                        return;
                    }
        %>
        <!-- 제목 박스 -->
        <div class="content-box">
            <h5>제목</h5>
            <p><%= escapeHtml(rs.getString("title")) %></p>
        </div>

        <!-- 작성자 박스 -->
        <div class="content-box">
            <h5>작성자</h5>
            <p><%= escapeHtml(postAuthor) %></p>
        </div>

        <!-- 작성일 박스 -->
        <div class="content-box">
            <h5>작성일</h5>
            <p><%= rs.getTimestamp("created_at") %></p>
        </div>

        <!-- 게시글 내용 박스 -->
        <div class="content-box">
            <h5>내용</h5>
            <p><%= escapeHtml(rs.getString("content")) %></p>
        </div>

        <!-- 첨부 파일 박스 -->
        <div class="content-box">
            <h5>첨부 파일</h5>
            <% if (fileName != null && !fileName.trim().isEmpty()) { %>
                <p><a href="fileDownload.jsp?id=<%= rs.getInt("id") %>"><%= escapeHtml(fileName) %></a></p>
            <% } else { %>
                <p>없음</p>
            <% } %>
        </div>

        <!-- 버튼 섹션 -->
        <div class="btn-container">
            <% if (loggedInUser != null && loggedInUser.equals(postAuthor)) { %>
                <a href="boardDelete.jsp?id=<%= rs.getInt("id") %>" class="btn btn-danger ganjibutton">삭제</a>
            <% } %>
            <a href="boardList.jsp" class="btn btn-secondary ganjibutton">목록으로</a>
        </div>

        <!-- 댓글 작성 폼 -->
        <div class="comment-form">
            <h5>댓글 작성</h5>
            <form action="commentWrite.jsp" method="post">
                <input type="hidden" name="board_id" value="<%= id %>">
                <div class="form-group">
                    <label for="commentAuthor">작성자</label>
                    <input type="text" class="form-control" id="commentAuthor" name="author" required>
                </div>
                <div class="form-group">
                    <label for="commentContent">댓글 내용</label>
                    <textarea class="form-control" id="commentContent" name="content" rows="3" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">댓글 작성</button>
            </form>
        </div>

        <!-- 댓글 목록 -->
        <div class="content-box">
            <h5>댓글</h5>
            <%
    pstmt = conn.prepareStatement("SELECT * FROM comments WHERE board_id = ? ORDER BY created_at DESC");
    pstmt.setInt(1, id);
    ResultSet commentRs = pstmt.executeQuery();
    while (commentRs.next()) {
%>
    <div class="comment-box">
        <!-- 댓글 작성자 -->
        <p>작성자 : <strong><%= escapeHtml(commentRs.getString("author")) %></strong></p>
        <!-- 댓글 내용 -->
        <p>댓글 내용 : <%= escapeHtml(commentRs.getString("content")) %></p>
        <!-- 작성 날짜 -->
        <p style="font-size: 0.8rem; color: gray; margin-left: 20px;">(<%= commentRs.getTimestamp("created_at") %>)</p>
    </div>
<%
    }
    commentRs.close();
%>
        </div>
        <%
            } else {
                out.println("게시글을 찾을 수 없습니다.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("데이터베이스 오류가 발생했습니다: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
        %>
        
        <%! 
        String escapeHtml(String str) {
            if (str == null) return null;
            return str.replace("&", "&amp;")
                      .replace("<", "&lt;")
                      .replace(">", "&gt;")
                      .replace("\"", "&quot;")
                      .replace("'", "&#x27;");
        }
        %>
    </div>
</body>
</html>
