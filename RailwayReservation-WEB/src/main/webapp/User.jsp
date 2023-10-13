<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Page</title>
</head>
<body>
    <h1>Welcome, User!</h1>
    <h1>Add Ticket</h1>
        <form action="addTicket" method="post">
            <div style="float:left">
                <label for="ticketDetails">Ticket Details:</label>
                <input type="text" name="ticketDetails">
            </div>

            <br>
            <h1>Choice of trip</h1>
            <div style="float:left">
                <label for="choiceOfTrip">Choice of Trip:</label>
                <input type="text" name="choiceOfTrip">
            </div>
            <br>
            <h1>Add Passengers</h1>
            <div style="float:left">
                <label for="passengerDetails">Passenger Details:</label>
                <input type="text" id="AddPassenger" name="passengerDetails">
            </div>

            <br><br>
            <button type="submit" onclick="showPopup('Train Added Successfully!')">Submit</button>
        </form>
</body>
</html>