<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 세션에서 로그인된 사용자 이름을 가져옴
    String loggedInUser = null;

    if (session != null) {
        loggedInUser = (String) session.getAttribute("username");
    }

    // 로그인된 사용자가 없으면 삭제 불가
    if (loggedInUser == null) {
        out.println("로그인이 필요합니다.");
        return;
    }

    // 삭제할 게시글의 ID를 가져옴
    String idParam = request.getParameter("id");
    int id = 0;

    // ID 값이 잘못된 경우를 대비하여 예외 처리
    try {
        if (idParam != null) {
            id = Integer.parseInt(idParam);
        } else {
            out.println("유효하지 않은 게시글 ID입니다.");
            return;
        }
    } catch (NumberFormatException e) {
        out.println("유효하지 않은 형식의 ID입니다.");
        return;
    }

    // 데이터베이스 연결 및 게시글 작성자 확인, 삭제 로직
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=utf8", "dbuser", "1234");

        // 게시글 작성자 확인 쿼리
        String checkAuthorSql = "SELECT author FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(checkAuthorSql);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String postAuthor = rs.getString("author");

            // 로그인된 사용자가 게시글 작성자가 아닌 경우 삭제 불가
            if (!loggedInUser.equals(postAuthor)) {
            	out.println("<script>alert('다른 사용자의 게시글은 삭제할 수 없습니다.'); history.back();</script>");
                return;
            }
        } else {
            out.println("삭제할 게시글이 존재하지 않습니다.");
            return;
        }

        // 게시글 삭제 쿼리 실행
        String deleteSql = "DELETE FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, id);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            // 삭제 성공 시 목록으로 리다이렉트
            response.sendRedirect("boardList.jsp");
        } else {
            out.println("게시글 삭제에 실패했습니다.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("게시글 삭제 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
        // 자원 정리
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
