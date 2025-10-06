<?php
include "dbconnect.php";  

$field = isset($_POST['field']) ? $_POST['field'] : '';
$value = isset($_POST['value']) ? $_POST['value'] : '';

if ($field === "name") {
    if (empty(trim($value))) {
        echo "Name is required";
    } elseif (strlen($value) < 3) {
        echo "Name must be at least 3 characters";
    } else {
        echo "";
    }
} elseif ($field === "email") {
    if (!preg_match("/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/", $value)) {
        echo "Invalid email format";
    } else {
        $stmt = $conn->prepare("SELECT email FROM users WHERE email=?");
        $stmt->bind_param("s", $value);
        $stmt->execute();
        $stmt->store_result();
        if ($stmt->num_rows > 0) {
            echo "Email already exists";
        } else {
            echo "Valid Email";
        }
        $stmt->close();
    }
} elseif ($field === "phone") {
    if (!preg_match("/^\d{10}$/", $value)) {
        echo "Phone must be 10 digits";
    } else {
        echo "";
    }
} elseif ($field === "password") {
    if (strlen($value) < 6) {
        echo "Password must be at least 6 characters";
    } elseif (!preg_match("/[A-Z]/", $value)) {
        echo "Must include at least 1 uppercase letter";
    } elseif (!preg_match("/[0-9]/", $value)) {
        echo "Must include at least 1 number";
    } else {
        echo "Strong password";
    }
} elseif ($field === "cpassword") {
    $pwd = isset($_POST['password']) ? $_POST['password'] : '';
    if ($value !== $pwd) {
        echo "Passwords do not match";
    } else {
        echo "Passwords match";
    }
}
?>
