<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*" %>
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
    out.println("<h3>Please <a name='lgnfail' href='login.jsp'>login</a> first.</h3>");
    return;
}

String url = "jdbc:mysql://localhost:3306/lib";
String user = "root";
String pass = "swetha@2005";
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(url, user, pass);

// Search filter
String queryParam = request.getParameter("search");
String searchQuery = "";
if(queryParam != null && !queryParam.trim().isEmpty()){
    searchQuery = " AND book_name LIKE '%" + queryParam + "%'";
}

PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM orders WHERE user_email=? AND address IS NULL" + searchQuery
);
ps.setString(1, email);
ResultSet rs = ps.executeQuery();

double total = 0;
%>
<!DOCTYPE html>
<html>
<head>
<title>Your Cart</title>
<style>
body { font-family: Arial; background: url('https://img.freepik.com/free-photo/still-life-books-versus-technology_23-2150062975.jpg') no-repeat center center fixed;  background-size: cover; padding:20px; }
.container { max-width: 900px; margin: auto; background:#fff; padding:30px; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.1); }
h2 { text-align:center; margin-bottom:20px; color:#2ecc71; }
table { width:100%; border-collapse: collapse; margin-bottom:20px; }
th, td { border:1px solid #ddd; padding:12px; text-align:center; }
th { background:#3498db; color:white; }
.remove-btn { color:white; background:#3498db; padding:5px 12px; border:none; border-radius:5px; cursor:pointer; }
.qty { width:50px; text-align:center; padding:5px; border-radius:5px; border:1px solid #ccc; }
textarea { width:100%; height:80px; padding:10px; border-radius:5px; border:1px solid #ccc; margin-bottom:15px; }
.place-order-btn { width:100%; padding:12px; background:#3498db; color:white; border:none; border-radius:8px; font-size:16px; cursor:pointer; }
#search { width:100%; padding:10px; margin-bottom:20px; border-radius:5px; border:1px solid #ccc; }
.total { text-align:right; font-size:18px; font-weight:bold; margin-bottom:20px; }
</style>
</head>
<body>
<div class="container">
<h2>Your Cart</h2>
<input type="text" id="search" placeholder="Search in cart..." onkeyup="searchCart()">

<table id="cartTable">
<tr><th>Book Name</th><th>Price</th><th>Quantity</th><th>Action</th></tr>
<%
while(rs.next()) {
    String bookName = rs.getString("book_name");
    double price = rs.getDouble("total_price");
    int qty = rs.getInt("quantity");
    total += price * qty;
%>
<tr>
    <td><%=bookName%></td>
    <td>Rs <span class="price"><%=price%></span></td>
    <td><input type="number" min="1" value="<%=qty%>" class="qty" data-book="<%=bookName%>" onchange="updateQty(this)"></td>
    <td><button class="remove-btn" onclick="removeBook('<%=bookName%>')">Remove</button></td>
</tr>
<%
}
%>
</table>

<div class="total" id="total">Total: Rs <%=total%></div>
<textarea id="address" placeholder="Enter your delivery address"></textarea>
<button class="place-order-btn" onclick="placeOrder()">Place Order</button>
</div>

<script>

function removeBook(book) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "removeBook.jsp?book=" + encodeURIComponent(book), true);
    xhr.onreadystatechange = function() {
        if(xhr.readyState === 4 && xhr.status === 200){
            location.reload();
        }
    };
    xhr.send();
}


function updateQty(el) {
    var qty = parseInt(el.value);
    if(isNaN(qty) || qty < 1){ qty = 1; el.value = 1; }

    var book = el.getAttribute('data-book');

   
    recalcTotal();

   
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "updateQty.jsp?book=" + encodeURIComponent(book) + "&qty=" + qty, true);
    xhr.onreadystatechange = function(){
        if(xhr.readyState === 4 && xhr.status === 200){
            
        }
    };
    xhr.send();
}


function recalcTotal(){
    var rows = document.querySelectorAll("#cartTable tr");
    var total = 0;
    for(var i=1;i<rows.length;i++){
        var price = parseFloat(rows[i].querySelector(".price").innerText);
        var qty = parseInt(rows[i].querySelector(".qty").value);
        total += price * qty;
    }
    document.getElementById("total").innerText = "Total: Rs " + total;
}


function searchCart() {
    var query = document.getElementById("search").value;
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "cart.jsp?search=" + encodeURIComponent(query), true);
    xhr.onreadystatechange = function() {
        if(xhr.readyState === 4 && xhr.status === 200){
            var parser = new DOMParser();
            var doc = parser.parseFromString(xhr.responseText, 'text/html');
            var newTable = doc.querySelector("#cartTable").innerHTML;
            document.querySelector("#cartTable").innerHTML = newTable;
            recalcTotal();
        }
    };
    xhr.send();
}


function placeOrder() {
    var address = document.getElementById('address').value.trim();
    if(address === '') { 
        alert('Please enter an address!'); 
        return; 
    }

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "updateCartAddress.jsp?address=" + encodeURIComponent(address), true);
    xhr.onreadystatechange = function() {
        if(xhr.readyState === 4){
            if(xhr.status === 200){
                if(xhr.responseText.trim() === "success"){
                    alert('Order placed successfully!');
                    window.location.href = 'books.html';
                } else {
                    alert('Failed to place order. Please try again.');
                }
            } else {
                alert('Server error: ' + xhr.status);
            }
        }
    };
    xhr.send();
}

</script>
</body>
</html>
<%
con.close();
%>
