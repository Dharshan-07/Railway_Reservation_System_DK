<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Train</title>
    <script>
            function showPopup(message) {
                alert(message); // Display an alert popup with the specified message
            }
    </script>
</head>
<body>
 <h1>Welcome, Admin!</h1>
    <h1>Add Train</h1>
    <form action="addTrain" method="post">
        <div style="float:left">
            <label for="trainName">Train Name:</label>
            <input type="text" id="AddTrain" name="trainName">
        </div>
    <input type="submit" value="Add" onclick="showPopup('Train Added Successfully!')">
    </form>
    <br>
    <h1>Add Trip</h1>
    <form action="addTrip" method="post">
        <div style="float:left">
            <label for="tripDetails">Trip Name:</label>
            <input type="text" id="AddTrip" name="tripDetails">
        </div>
         <input type="submit" value="Add" onclick="showPopup('Trip Added Successfully!')">
     </form>
     <button action="index.jsp">Go Back</button>
</body>
</html>