<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*" %>
<%@ include file="dbconnect.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String cpassword = request.getParameter("cpassword");

    if (!password.equals(cpassword)) {
        out.print("Passwords do not match");
    } else {
        try {
            String regNum = "REG" + new Random().nextInt(1000000);

            String sql = "INSERT INTO users(name, email, phone, password, regnum) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, password);
            ps.setString(5, regNum);

            int result = ps.executeUpdate();

            if (result > 0) {
                out.print("SUCCESS"); 
            } else {
                out.print("Error saving data");
            }

            ps.close();
            conn.close();
        } catch (Exception e) {
            out.print("Database Error: " + e.getMessage());
        }
    }
%>
