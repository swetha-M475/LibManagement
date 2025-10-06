<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%
Cookie[] cookies = request.getCookies();
String email = null;
if (cookies != null) {
    for (Cookie c : cookies) {
        if (c.getName().equals("email")) {
            email = c.getValue();
            break;
        }
    }
}

if (email == null) {
    out.println("Please login first");
    return;
}

String address = request.getParameter("address");
if(address == null || address.trim().isEmpty()){
    out.println("Address missing");
    return;
}

String url = "jdbc:mysql://localhost:3306/lib";
String user = "root";
String pass = "swetha@2005";

Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(url, user, pass);

PreparedStatement ps = con.prepareStatement(
    "UPDATE orders SET address=? WHERE user_email=? AND address IS NULL"
);
ps.setString(1, address);
ps.setString(2, email);
int updated = ps.executeUpdate();
if(updated > 0){
    out.println("success");
}else{
    out.println("no rows updated");
}

con.close();
%>
