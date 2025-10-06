<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/lib", "root", "swetha@2005");
    } catch (Exception e) {
        out.println("Database connection error: " + e.getMessage());
    }
%>
