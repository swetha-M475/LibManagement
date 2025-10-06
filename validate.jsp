<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*" %>
<%@ include file="dbconnect.jsp" %>

<%
String field = request.getParameter("field");
String value = request.getParameter("value");

if ("name".equals(field)) {
    if (value == null || value.trim().equals("")) {
        out.print("<span style='color:red'>Name is required</span>");
    } else if (value.length() < 3) {
        out.print("<span style='color:red'>Name must be at least 3 characters</span>");
    } else {
        out.print("<span style='color:green'>Valid name</span>");
    }
} else if ("email".equals(field)) {
    if (value == null || !value.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
        out.print("<span style='color:red'>Invalid email format</span>");
    } else {
        PreparedStatement ps = conn.prepareStatement("SELECT email FROM users WHERE email=?");
        ps.setString(1, value);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            out.print("<span style='color:red'>Email already exists</span>");
        } else {
            Cookie emailCookie = new Cookie("email", value);
            emailCookie.setMaxAge(60*60*24); // 1 day
            response.addCookie(emailCookie);

            out.print("<span style='color:green'>Email available</span>");
        }
        rs.close();
        ps.close();
    }
} else if ("phone".equals(field)) {
    if (value == null || !value.matches("\\d{10}")) {
        out.print("<span style='color:red'>Phone must be 10 digits</span>");
    } else {
        out.print("<span style='color:green'>Valid phone</span>");
    }
} else if ("password".equals(field)) {
    if (value == null || value.length() < 6) {
        out.print("<span style='color:red'>Password must be at least 6 characters</span>");
    } else if (!value.matches(".*[A-Z].*")) {
        out.print("<span style='color:red'>Must include at least 1 uppercase letter</span>");
    } else if (!value.matches(".*[0-9].*")) {
        out.print("<span style='color:red'>Must include at least 1 number</span>");
    } else {
        out.print("<span style='color:green'>Strong password</span>");
    }
} else if ("cpassword".equals(field)) {
    String pwd = request.getParameter("password");
    if (pwd == null || !value.equals(pwd)) {
        out.print("<span style='color:red'>Passwords do not match</span>");
    } else {
        out.print("<span style='color:green'>Passwords match</span>");
    }
}

conn.close();
%>
