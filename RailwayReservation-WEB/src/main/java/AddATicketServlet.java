
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.*;
public class AddATicketServlet extends HttpServlet
{
	static Connection connection;
	static Statement statement;
	static ResultSet resultSet;
	RequestDispatcher rd;
	static String TicketDetails = "";
	static String PassengerDetails = "";
	static int choiceOfTrip = 0;
	public void service(HttpServletRequest req, HttpServletResponse resp)
	{
		TicketDetails = req.getParameter("ticketDetails");
		PassengerDetails = req.getParameter("passengerDetails");
		choiceOfTrip = Integer.parseInt(req.getParameter("choiceOfTrip"));
		try
		{
			initDb();
			addATicket();
			rd=req.getRequestDispatcher("/index.jsp");
			rd.include(req, resp);
		}
		catch(Exception e)
		{
			throw new RuntimeException(e);
		}
	}

	private static void addATicket() throws Exception
	{
		String[] params = TicketDetails.split(" ");
		String from = params[0];
		String to = params[1];
		String dateString = params[2];
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate localDate = LocalDate.parse(dateString, formatter);
		java.sql.Date date = java.sql.Date.valueOf(localDate);

		//System.out.println("Enter the Type of coach \n1.FirstAC \n2.SecondAC \n3.ThirdAC \n4.Sleeper \n5.General");
		String coachType = params[3];

		resultSet = statement.executeQuery("SELECT DISTINCT T1.`tripId`\n"
			+ "FROM TripLocation AS T1\n"
			+ "JOIN Locations AS L1 ON T1.`locationId` = L1.`locationId` AND L1.`name` = " + "'"+from+"'"
			+ "WHERE T1.`order` < (\n"
			+ "  SELECT MAX(T2.`order`)\n"
			+ "  FROM TripLocation AS T2\n"
			+ "  JOIN Locations AS L2 ON T2.`locationId` = L2.`locationId` AND L2.`name` = " + "'"+to+"'"
			+ ");");

		System.out.println("Select the trip ");
		while(resultSet.next())
		{
			System.out.println(resultSet.getInt("tripId"));
		}
		int tripId = choiceOfTrip;
		addTicketRow(from,to,date,coachType,tripId);
		System.out.println("Ticket Added Successfully");
	}

	public static void addTicketRow(String from,String to, Date date,String coachType,int tripId) throws Exception
	{
		String[] params = PassengerDetails.split(" ");
		int x = 0;
		ResultSet resultSet = statement.executeQuery("SELECT ticketId FROM Tickets ORDER BY ticketId DESC LIMIT 1");
		int ticketId = 0;
		while(resultSet.next())
		{
			ticketId = resultSet.getInt("ticketId");
		}
		String sql = "INSERT INTO `Tickets` VALUES (?,?,?,?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,++ticketId);
		preparedStatement.setString(2,from);
		preparedStatement.setString(3,to);
		preparedStatement.setDate(4, date);
		preparedStatement.setString(5,coachType);
		preparedStatement.setInt(6,tripId);
		preparedStatement.executeUpdate();

		int noOfPassengers = Integer.parseInt(params[x++]);
		for(int i=0;i<noOfPassengers;i++)
		{
			System.out.println("Enter Passenger "+(i+1)+" Details");
			int passengerId = Integer.parseInt(params[x++]);
			String passengerName = params[x++];
			String gender = params[x++];
			int age = Integer.parseInt(params[x++]);
			addPassengerRow(passengerId,passengerName,gender,age,ticketId);
		}
	}

	public static void addPassengerRow(int passengerId,String passengerName,String gender,int age,int ticketId) throws Exception
	{
		String sql = "INSERT INTO `Passengers` VALUES (?,?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,passengerId);
		preparedStatement.setString(2,passengerName);
		preparedStatement.setString(3,gender);
		preparedStatement.setInt(4, age);
		preparedStatement.executeUpdate();
		System.out.println("passenger added successfully");

		ResultSet resultSet = statement.executeQuery("SELECT ticketPassengerId FROM TicketPassenger ORDER BY ticketPassengerId DESC LIMIT 1");
		int ticketPassengerId = 0;
		while(resultSet.next())
		{
			ticketPassengerId = resultSet.getInt("ticketPassengerId");
		}
		++ticketPassengerId;
		sql = "INSERT INTO `TicketPassenger` VALUES (?,?,?,?)";
		preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,ticketPassengerId);
		preparedStatement.setInt(2,ticketId);
		preparedStatement.setInt(3,passengerId);
		preparedStatement.setString(4,"Waiting for Status");
		preparedStatement.executeUpdate();

		int tripId = 0;
		String coachType = "";
		resultSet = statement.executeQuery("select tripId,coachType from\n"
			+ "Tickets as T inner join TicketPassenger as TP\n"
			+ "on T.`ticketId` = TP.`ticketId`;");
		while(resultSet.next()){
			tripId = resultSet.getInt("tripId");
			coachType = resultSet.getString("coachType");
		}
		int tripBerthId = 0;
		int tripCoachId = 0;
		resultSet = statement.executeQuery("SELECT TB.tripBerthId,TB.tripCoachId\n"
			+ "FROM TripBerth AS TB\n"
			+ "INNER JOIN TripCoach AS TC ON TC.tripCoachId = TB.tripCoachId\n"
			+ "WHERE TB.ticketPassengerId ="+0
			+ "  AND TC.coachType = '"+coachType+"'\n"
			+ "  AND TC.tripId = "+tripId+"\n"
			+ "LIMIT 1;");
		while(resultSet.next())
		{
			tripBerthId = resultSet.getInt("tripBerthId");
			tripCoachId = resultSet.getInt("tripCoachId");
		}
		preparedStatement = connection.prepareStatement("update TripBerth AS TB\n"
			+ "\t\tINNER JOIN TripCoach AS TC ON TC.tripCoachId = TB.tripCoachId\n"
			+ "\t\tset TB.ticketPassengerId = ?\n"
			+ "\t\tWHERE TB.ticketPassengerId = 0\n"
			+ "\t\t  AND TC.coachType = ?\n"
			+ "\t\t  AND TC.tripId = ?\n"
			+ "\t\t  AND TB.tripCoachId = ?\n"
			+ "\t\t  AND TB.tripBerthId = ?");

		preparedStatement.setInt(1,ticketPassengerId);
		preparedStatement.setString(2,coachType);
		preparedStatement.setInt(3,tripId);
		preparedStatement.setInt(4,tripCoachId);
		preparedStatement.setInt(5,tripBerthId);
		int rowsAffected = preparedStatement.executeUpdate();
		if(rowsAffected==0)
		{
			preparedStatement = connection.prepareStatement("UPDATE TicketPassenger SET status = 'RAC' WHERE ticketPassengerId = "+ticketPassengerId);
			preparedStatement.executeUpdate();
		}
		if(rowsAffected>0)
		{
			preparedStatement = connection.prepareStatement("update TicketPassenger set status = 'CONFIRMED' where ticketPassengerId = "+ticketPassengerId);
			preparedStatement.executeUpdate();
		}
	}
	public static void initDb() throws Exception
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway","root","");
		statement = connection.createStatement();
	}
}