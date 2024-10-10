<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시판</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="css/ganjibutton.css">
    <link rel="stylesheet" href="css/changes.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

        body {
            font-family: 'Roboto', sans-serif;
            color: #000;
            background-color: #C1E1C1; /* 초록색 파스텔톤 배경 */
        }

        .header-image {
            position: absolute;
            top: 0px;
            left: 0px; /* 로고를 화면 왼쪽으로 이동 */
            width: 150px;
            transition: transform 0.6s;
            transform-style: preserve-3d;
        }

        .header-image:hover {
            transform: rotateY(180deg);
        }

        .title-section {
            text-align: center;
            font-size: 3rem;
            font-weight: bold;
            margin-top: 20px;
            color: #000; /* 검은색으로 변경 */
            cursor: pointer;
        }

        .search-section {
            display: flex;
            align-items: center;
            padding: 10px;
            background-color: rgba(255, 255, 255, 0.8);
            border: 2px solid #333;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 20px;
            width: fit-content;
            gap: 10px;
            margin-left: 150px;
        }

        .search-inputs {
            display: flex;
            flex-grow: 1;
            gap: 10px;
        }

        .search-section .form-control,
        .search-section select {
            border-radius: 5px;
            border: 1px solid #ccc;
            padding: 8px;
            background-color: #fff;
            color: #000;
        }

        .btn {
            border: none;
            text-align: center;
            cursor: pointer;
            text-transform: uppercase;
            outline: none;
            overflow: hidden;
            position: relative;
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            background-color: #222;
            padding: 17px 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            transition: background-color 0.3s ease;
            border-radius: 5px;
        }

        .btn:hover {
            background-color: #555; /* 버튼 색상 변화를 부드럽게 */
        }

        .btn-search, .btn-write {
            margin-left: 0px;
        }

        .btn-main {
            padding: 17px 30px;
            margin-left: 10px;
        }

        .action-buttons {
            margin-bottom: 20px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            color: #333;
            padding: 10px 15px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 5px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .pagination a:hover {
            background-color: #ddd;
        }

        .pagination .active {
            background-color: #333;
            color: #fff;
            border: 1px solid #333;
        }

        .board-table {
            border: 2px solid #000;
            border-collapse: collapse;
            font-family: 'Roboto', sans-serif; /* 게시판 목록 글씨체 통일 */
        }

        .board-table th, .board-table td {
            border: 1px solid #000 !important;
            padding: 8px;
            text-align: center;
            background-clip: padding-box;
        }
    </style>
    <script>
        function searchPosts() {
            const keyword = document.querySelector('input[name="searchKeyword"]').value;
            const type = document.querySelector('select[name="searchType"]').value;
            const startDate = document.querySelector('input[name="startDate"]').value;
            const endDate = document.querySelector('input[name="endDate"]').value;

            const queryParams = new URLSearchParams({
                searchKeyword: keyword,
                searchType: type,
                startDate: startDate,
                endDate: endDate
            });

            window.location.href = `boardList.jsp?${queryParams.toString()}`;
        }

        function goToBoard() {
            window.location.href = "boardList.jsp";
        }
    </script>
</head>
<body>
    <img src="images/Shopping_Cart_Logo.png" alt="Shopping Cart 로고" class="header-image">

    <div class="title-section" onclick="goToBoard()">
        게시판
    </div>

    <div class="container mt-4 board-content">
        <form class="search-section" method="get" action="boardList.jsp">
            <div class="search-inputs">
                <input type="search" name="searchKeyword" placeholder="검색어 입력" class="form-control">
                <select name="searchType" class="form-control">
                    <option value="title">제목</option>
                    <option value="author">작성자</option>
                </select>
                <input type="date" name="startDate" class="form-control" placeholder="시작 날짜">
                <input type="date" name="endDate" class="form-control" placeholder="종료 날짜">
            </div>
            <button type="submit" class="btn btn-search"><span>검색</span></button>
            <a href="userHome.jsp" class="btn btn-main"><span>메인 홈</span></a>
        </form>

        <div class="action-buttons">
            <a href="boardWrite.jsp" class="btn btn-write"><span>글쓰기</span></a>
        </div>

        <%
		    int pageSize = 10;
		    int pageNumber = 1;
		    if (request.getParameter("page") != null) {
		        pageNumber = Integer.parseInt(request.getParameter("page"));
		    }
		    int startRow = (pageNumber - 1) * pageSize;
		
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		
		    String searchKeyword = request.getParameter("searchKeyword");
		    String searchType = request.getParameter("searchType");
		    String startDate = request.getParameter("startDate");
		    String endDate = request.getParameter("endDate");
		
		    String sql = "SELECT * FROM board WHERE 1=1";
		
		    List<Object> params = new ArrayList<>();
		
		    if (searchKeyword != null && !searchKeyword.isEmpty()) {
		        sql += " AND " + searchType + " LIKE ?";
		        params.add("%" + searchKeyword + "%");
		    }
		
		    if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
		        sql += " AND created_at BETWEEN ? AND ?";
		        params.add(startDate);
		        params.add(endDate);
		    }
		
		    sql += " ORDER BY created_at DESC LIMIT ?, ?";
		    params.add(startRow);
		    params.add(pageSize);
		
		    try {
		    	
		    	Class.forName("com.mysql.cj.jdbc.Driver");
		    	
		        conn = DriverManager.getConnection("jdbc:mysql://18.183.202.201:3306/shopping-cart?useUnicode=true&characterEncoding=utf8", "dbuser", "1234");
		        pstmt = conn.prepareStatement(sql);
		
		        // 파라미터 설정
		        for (int i = 0; i < params.size(); i++) {
		            pstmt.setObject(i + 1, params.get(i));
		        }
		
		        rs = pstmt.executeQuery();
		%>
		        <table class="table table-striped board-table">
		            <thead>
		                <tr>
		                    <th>번호</th>
		                    <th>제목</th>
		                    <th>작성자</th>
		                    <th>작성일</th>
		                    <th>파일</th>
		                </tr>
		            </thead>
		            <tbody>
		                <%
		                while (rs.next()) {
		                    String fileName = rs.getString("file_name");
		                    %>
		                    <tr>
		                        <td><%= rs.getInt("id") %></td>
		                        <td><a href="boardDetail.jsp?id=<%= rs.getInt("id") %>"><%= rs.getString("title") %></a></td>
		                        <td><%= rs.getString("author") %></td>
		                        <td><%= rs.getTimestamp("created_at") %></td>
		                        <td><%= fileName != null ? fileName : "없음" %></td>
		                    </tr>
		                    <%
		                }
		                %>
		            </tbody>
		        </table>
		
		        <div class="pagination">
		            <%
		            String countSql = "SELECT COUNT(*) AS total FROM board WHERE 1=1";
		            List<Object> countParams = new ArrayList<>();
		
		            if (searchKeyword != null && !searchKeyword.isEmpty()) {
		                countSql += " AND " + searchType + " LIKE ?";
		                countParams.add("%" + searchKeyword + "%");
		            }
		            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
		                countSql += " AND created_at BETWEEN ? AND ?";
		                countParams.add(startDate);
		                countParams.add(endDate);
		            }
		
		            PreparedStatement countPstmt = conn.prepareStatement(countSql);
		            for (int i = 0; i < countParams.size(); i++) {
		                countPstmt.setObject(i + 1, countParams.get(i));
		            }
		
		            ResultSet countRs = countPstmt.executeQuery();
		            countRs.next();
		            int totalPosts = countRs.getInt("total");
		
		            int totalPages = (int) Math.ceil(totalPosts / (double) pageSize);
		
		            for (int i = 1; i <= totalPages; i++) {
		                if (i == pageNumber) {
		                    %>
		                    <a href="#" class="active"><%= i %></a>
		                    <%
		                } else {
		                    %>
		                    <a href="boardList.jsp?page=<%= i %>"><%= i %></a>
		                    <%
		                }
		            }
		            countRs.close();
		            countPstmt.close();
		            %>
		        </div>
		
		<%
		    } catch (ClassNotFoundException e) {
		        e.printStackTrace();
		        out.println("MySQL JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage());
		    } catch (SQLException e) {
		        e.printStackTrace();
		        out.println("데이터베이스 연결 오류: " + e.getMessage());
		    }
		    
		    finally {
		        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
		        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
		        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
		    }
%>

    </div>
</body>
</html>
