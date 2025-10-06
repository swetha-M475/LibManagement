<%@ page import="javax.servlet.http.*" %>
<%
Cookie[] cookies = request.getCookies();
String savedEmail = null;
String savedPass = null;

if (cookies != null) {
    for (Cookie c : cookies) {
        if (c.getName().equals("userEmail")) {
            savedEmail = c.getValue();
        }
        if (c.getName().equals("userPass")) {
            savedPass = c.getValue();
        }
    }
}

if (savedEmail != null && savedPass != null) {
    response.sendRedirect("books.html");
} else {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            background: url('https://img.freepik.com/free-photo/still-life-books-versus-technology_23-2150062975.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
        }
        .login-box {
            width: 350px;
            padding: 20px;
            background: rgba(255,255,255,0.8);
            margin: 100px auto;
            border-radius: 10px;
            text-align: center;
        }
        input[type=text], input[type=password] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
        }
        input[type=submit] {
            background: #007bff;
            color: white;
            padding: 10px;
            border: none;
            width: 95%;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="login-box">
    <h2>Login</h2>
    <form action="validateLogin.jsp" method="post">
        <input type="text" name="email" placeholder="Email" required><br>
        <input type="password" name="password" placeholder="Password" required><br>
        <input type="submit" value="Login" id="login">
    </form>
</div>
</body>
</html>
<%
}
%>
