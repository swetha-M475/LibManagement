<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%
String book = request.getParameter("book");
Cookie[] cookies = request.getCookies();
String email = null;
for (Cookie c : cookies) {
    if (c.getName().equals("email")) {
        email = c.getValue();
        break;
    }
}

if (book != null && email != null) {
    String url = "jdbc:mysql://localhost:3306/lib";
    String user = "root";
    String pass = "swetha@2005";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, pass);

    PreparedStatement ps = con.prepareStatement(
        "DELETE FROM orders WHERE user_email=? AND book_name=? AND address IS NULL"
    );
    ps.setString(1, email);
    ps.setString(2, book);
    ps.executeUpdate();
    con.close();
}
%>
