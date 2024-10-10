<%@ page import="java.io.*, java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // 파라미터로부터 파일 ID와 경로 받기
    String fileId = request.getParameter("id"); // 게시판 다운로드용 ID 파라미터
    String filePath = request.getParameter("path"); // 상대 경로 다운로드용

    // 데이터베이스 연결 설정
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 다운로드할 파일 객체 선언
    File file = null;

    try {
        // 게시판 파일 다운로드 기능: id 파라미터가 있는 경우
        if (fileId != null) {
            // 데이터베이스 연결
            conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=utf8", "dbuser", "1234");

            // 파일 정보를 가져오는 SQL 쿼리
            String sql = "SELECT file_name, file_content FROM board WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fileId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String fileName = rs.getString("file_name");

                // 임시 파일 생성 및 저장
                file = File.createTempFile("temp", fileName);

                // 파일을 임시 저장소에 저장
                try (InputStream inputStream = rs.getBlob("file_content").getBinaryStream();
                     OutputStream outputStream = new FileOutputStream(file)) {

                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }
            }
        } 
        // 상대 경로 다운로드 기능: path 파라미터가 있는 경우
		else if (filePath != null) {
		    // 현재 웹 애플리케이션의 루트 경로를 기준으로 설정
		    String basePath = application.getRealPath("/");
		
		    // 전달받은 경로를 실제 경로로 변환
		    String targetFilePath = new File(basePath, filePath).getCanonicalPath();
		
		    // 파일 경로가 웹 애플리케이션의 루트 디렉토리 밖으로 벗어나지 않도록 제한
		    if (!targetFilePath.startsWith(basePath)) {
		        out.println("잘못된 경로 접근입니다.");
		        return;
		    }
		
		    // 허용된 파일 확장자 목록
		    String[] allowedExtensions = {".jpg", ".png", ".pdf", ".docx", ".xlsx"};
		    boolean isValidExtension = false;
		    for (String ext : allowedExtensions) {
		        if (filePath.endsWith(ext)) {
		            isValidExtension = true;
		            break;
		        }
		    }
		
		    if (!isValidExtension) {
		    	out.println("<script>alert('허용되지 않은 파일 형식입니다.'); history.back();</script>");
		        return;
		    }
		
		    file = new File(targetFilePath);
		}

        // 파일이 존재하고 디렉토리가 아닌 경우에만 다운로드 처리
        if (file != null && file.exists() && !file.isDirectory()) {
            String encodedFileName = java.net.URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");

            // MIME 타입을 설정하고 다운로드를 위한 헤더를 설정합니다.
            response.setContentType(getServletContext().getMimeType(file.getName()));
            response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

            // 파일을 읽어서 클라이언트로 전송
            try (InputStream fileInputStream = new FileInputStream(file);
                 OutputStream outputStream = response.getOutputStream()) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            } catch (IOException e) {
                e.printStackTrace();
                out.println("파일 다운로드 중 오류가 발생했습니다: " + e.getMessage());
            }
        } else {
            out.println("파일을 찾을 수 없습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("파일 다운로드 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
        // 자원 정리
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
        if (file != null && file.getName().startsWith("temp")) file.delete(); // 임시 파일 삭제
    }
%>
