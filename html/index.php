<!DOCTYPE html>
<html>
<head><title>My vagrant page</title></head>
<body>
<?php
//phpinfo();

$conn = new mysqli("127.0.0.1", "site_root", "", "siteDB");

if ($conn->connect_error) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    die();
}

$query = "SELECT id, username, email, created, updated FROM users";
$result = $conn->query($query);

if ($result->num_rows > 0) {
	while($row = $result->fetch_assoc()) {
		echo "id: " . $row["id"]. " - username: " . $row["username"]. " - email: " . $row["email"];
		echo " - created: " . $row["created"] . " - updated: " . $row["updated"] . "</br>";
	}
} else {
	echo "0 results";
}

$conn->close();
?>
</body>
</html>