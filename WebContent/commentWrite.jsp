<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%

   request.setCharacterEncoding("UTF-8");
    // 댓글 작성 폼에서 전달된 파라미터 수집
    String boardId = request.getParameter("board_id");
    String author = request.getParameter("author");
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 데이터베이스 연결 - UTF-8 인코딩 설정 추가
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=UTF-8", "dbuser", "1234");

        // 댓글 삽입 쿼리
        String query = "INSERT INTO comments (board_id, author, content) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, Integer.parseInt(boardId));
        pstmt.setString(2, author);
        pstmt.setString(3, content);
        pstmt.executeUpdate();

        // 댓글 작성 후 게시글 상세 페이지로 리다이렉트
        response.sendRedirect("boardDetail.jsp?id=" + boardId);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
