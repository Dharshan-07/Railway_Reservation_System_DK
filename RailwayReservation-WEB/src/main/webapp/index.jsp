<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
</head>
<body>
<h2>WELCOME TO RAILWAY RESERVATION SYSTEM!</h2>
    <h2>Login</h2>
    <form action="javascript:void(0);" onsubmit="redirectBasedOnRole()">
        <label for="role">Select your role:</label><br>
        <input type="radio" name="role" value="admin"> Admin<br>
        <input type="radio" name="role" value="user"> User<br><br>
        <input type="submit" value="Login">
    </form>

    <script>
        function redirectBasedOnRole() {
            const role = document.querySelector('input[name="role"]:checked').value;
            if (role === "admin") {
                window.location.href = "Admin.jsp";
            } else if (role === "user") {
                window.location.href = "User.jsp";
            }
        }
    </script>
</body>
</html>