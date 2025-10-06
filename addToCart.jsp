<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%
String book = request.getParameter("book");
String priceStr = request.getParameter("price");
double price = Double.parseDouble(priceStr);


String email = null;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if (c.getName().equals("email")) {
            email = c.getValue();
            break;
        }
    }
}

if (email != null && book != null) {
    String url = "jdbc:mysql://localhost:3306/lib";
    String user = "root";
    String pass = "swetha@2005";

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(url, user, pass);

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO orders (user_email, book_name, quantity, total_price) VALUES (?, ?, ?, ?)"
    );
    ps.setString(1, email);
    ps.setString(2, book);
    ps.setInt(3, 1);
    ps.setDouble(4, price);
    ps.executeUpdate();
    con.close();
}
%>
