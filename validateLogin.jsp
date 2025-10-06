<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%
String email = request.getParameter("email");
String password = request.getParameter("password");

String url = "jdbc:mysql://localhost:3306/lib";
String user = "root";
String dbPassword = "swetha@2005";

Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(url, user, dbPassword);

PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
ps.setString(1, email);
ps.setString(2, password);
ResultSet rs = ps.executeQuery();

if (rs.next()) {
    response.sendRedirect("books.html");
} else {
    out.println("<h3>Invalid credentials! <a href='login.jsp'>Try again</a></h3>");
}
con.close();
%>
