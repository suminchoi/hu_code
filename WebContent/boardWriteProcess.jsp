<%@ page import="java.io.*, java.sql.*, javax.servlet.http.*, javax.servlet.annotation.MultipartConfig" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<%
   String[] allowedExtensions = {".jpg", ".png", ".pdf", ".jpeg", ".gif"};
   String[] allowedMimeTypes = {"image/jpeg", "image/png", "application/pdf", "image/gif"};
   
   boolean isValidExtension = false;
   boolean isValidMimeType = false;
   request.setCharacterEncoding("UTF-8"); // 인코딩 설정 추가

   // 폼 데이터 가져오기
   String title = request.getParameter("title");
   String content = request.getParameter("content");
   String author = request.getParameter("author");

   // 기본값 설정
   if (title == null || title.trim().isEmpty()) {
       title = "Untitled";
   }
   if (content == null) {
       content = "";
   }
   if (author == null) {
       author = "Anonymous";
   }
   
   // HTML 인코딩을 통해 XSS 방지
   title = StringEscapeUtils.escapeHtml4(title);
   content = StringEscapeUtils.escapeHtml4(content);
   author = StringEscapeUtils.escapeHtml4(author);

   // 파일 업로드 처리
   Part filePart = request.getPart("uploadFile");
   String fileName = "";
   long fileSize = 0;
   InputStream fileContent = null;

   if (filePart != null && filePart.getSize() > 0) {
       fileName = filePart.getSubmittedFileName();
       String mimeType = filePart.getContentType();
   
       // 확장자 검사
       for (String ext : allowedExtensions) {
           if (fileName.toLowerCase().endsWith(ext)) {
               isValidExtension = true;
               break;
           }
       }
   
       // MIME 타입 검사
       for (String type : allowedMimeTypes) {
           if (mimeType.equalsIgnoreCase(type)) {
               isValidMimeType = true;
               break;
           }
       }
   
       // 확장자 또는 MIME 타입이 유효하지 않으면 에러 메시지 출력 및 업로드 중단
       if (!isValidExtension || !isValidMimeType) {
    	   out.println("<script>alert('허용되지 않은 파일 형식입니다.'); history.back();</script>");
           return;
       }
   
       fileSize = filePart.getSize();
       fileContent = filePart.getInputStream();
   }

   // 대용량 텍스트 처리 (제목 및 내용의 크기 제한 제거)
   if (title.length() > 50000 || content.length() > 1000000) {
       out.println("Warning: You are entering large data that might cause issues.");
   }

   // 데이터베이스에 저장
   try (Connection conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=utf8", "dbuser", "1234")) {
       String sql = "INSERT INTO board (title, author, content, file_name, file_size, file_content) VALUES (?, ?, ?, ?, ?, ?)";
       try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
           pstmt.setString(1, title);
           pstmt.setString(2, author);
           pstmt.setString(3, content);
           pstmt.setString(4, fileName);
           pstmt.setLong(5, fileSize);

           // 파일을 BLOB으로 저장
           if (fileContent != null) {
               pstmt.setBlob(6, fileContent);
           } else {
               pstmt.setNull(6, java.sql.Types.BLOB);
           }

           pstmt.executeUpdate(); // 데이터베이스에 저장
       }
   } catch (Exception e) {
       e.printStackTrace();
       out.println("게시글 저장 중 오류가 발생했습니다.");
   }

   // 게시글 목록 페이지로 리다이렉트
   response.sendRedirect("boardList.jsp");
%>
