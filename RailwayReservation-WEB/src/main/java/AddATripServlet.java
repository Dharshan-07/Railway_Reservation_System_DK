
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.*;
public class AddATripServlet extends HttpServlet
{
	static Connection connection;
	static Statement statement;
	RequestDispatcher rd;
	public void service(HttpServletRequest req, HttpServletResponse resp)
	{
		String s = req.getParameter("tripDetails");
		try
		{
			initDb();
			addATrip(s);
			rd=req.getRequestDispatcher("/index.jsp");
			rd.include(req, resp);
		}
		catch(Exception e)
		{
			throw new RuntimeException(e);
		}
	}

	private static void addATrip(String s) throws Exception
	{
		String[] params = s.split(" ");
		String dateString = params[0];
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate localDate = LocalDate.parse(dateString, formatter);
		Date date = Date.valueOf(localDate);
		int trainId = Integer.parseInt(params[1]);
		List<String> locations = parseCSVStringToList(params[2]);
		addTripRow(date,trainId,locations);
		System.out.println("Trip added successfully");
	}

	private static void initTripCoaches(int trainId,int tripId) throws Exception
	{
		ResultSet resultSet = statement.executeQuery("SELECT * FROM Trains where trainId = \""+trainId+"\"");
		int fac,sac,tac,sle,gen;
		fac=sac=tac=sle=gen=0;
		while(resultSet.next()){
			fac = resultSet.getInt("noOfFirstAC");
			sac = resultSet.getInt("noOfSecondAC");
			tac = resultSet.getInt("noOfThirdAC");
			sle = resultSet.getInt("noOfSleeper");
			gen = resultSet.getInt("noOfGeneral");
		}
		for(int i=0 ; i<fac ;i++){ addTripCoachRow(tripId,"FIRSTAC");}
		for(int i=0 ; i<sac ;i++){ addTripCoachRow(tripId,"SECONDAC");}
		for(int i=0 ; i<tac ;i++){ addTripCoachRow(tripId,"THIRDAC");}
		for(int i=0 ; i<sle ;i++){ addTripCoachRow(tripId,"SLEEPER");}
		for(int i=0 ; i<gen ;i++){ addTripCoachRow(tripId,"GENERAL");}
	}

	private static void addTripCoachRow(int tripId, String coachType) throws Exception
	{
		ResultSet resultSet = statement.executeQuery("SELECT tripCoachId FROM TripCoach ORDER BY tripCoachId DESC LIMIT 1;");
		int tripCoachId = 0;
		while(resultSet.next()){
			tripCoachId = resultSet.getInt("tripCoachId");
		}
		tripCoachId++;

		String sql = "INSERT INTO `TripCoach` VALUES (?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,tripCoachId);
		preparedStatement.setInt(2,tripId);
		preparedStatement.setString(3,coachType);
		preparedStatement.executeUpdate();

		resultSet = statement.executeQuery("SELECT berths,noOfRac FROM CoachTypes WHERE coachType =\""+coachType+"\"");
		int noOfBerths = 0;
		int noOfRac = 0;
		while(resultSet.next()){
			noOfBerths = resultSet.getInt("berths");
			noOfRac = resultSet.getInt("noOfRac");
		}
		int noOfUpperBerths,noOfMiddleBerths,noOfLowerBerths,noOfSideupperBerths;
		noOfUpperBerths = noOfMiddleBerths = noOfLowerBerths = (noOfBerths+noOfRac/2)/8 * 2;
		noOfSideupperBerths = (noOfBerths+noOfRac/2)/8;
		int x=0;
		for(int i=0 ; i<noOfUpperBerths ; i++,x++) {addTripBerthRow(x+1,tripCoachId,"UPPER");}
		for(int i=0 ; i<noOfMiddleBerths ; i++,x++) {addTripBerthRow(x+1,tripCoachId,"MIDDLE");}
		for(int i=0 ; i<noOfSideupperBerths ; i++,x++) {addTripBerthRow(x+1,tripCoachId,"SIDEUPPER");}
		for(int i=0 ; i<noOfLowerBerths ; i++,x++) {addTripBerthRow(x+1,tripCoachId,"LOWER");}
	}

	private static void addTripBerthRow(int i, int tripCoachId,String berthType) throws Exception
	{
		String sql = "INSERT INTO `TripBerth` VALUES (?,?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,i);
		preparedStatement.setInt(2,tripCoachId);
		preparedStatement.setInt(3,0);
		preparedStatement.setString(4,berthType);
		preparedStatement.executeUpdate();
	}

	public static void addTripRow(Date date,int trainId,List<String> locations) throws Exception
	{
		ResultSet resultSet = statement.executeQuery("SELECT tripID FROM Trips ORDER BY tripID DESC LIMIT 1;");
		int tripId = 0;
		while(resultSet.next()){
			tripId = resultSet.getInt("tripId");
		}
		tripId++;

		String sql = "INSERT INTO `Trips` VALUES (?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,tripId);
		preparedStatement.setDate(2,date);
		preparedStatement.setInt(3,trainId);
		int rowsAffected = preparedStatement.executeUpdate();
		System.out.println("rows affected "+rowsAffected);

		for(int i=1 ; i<=locations.size() ; i++){
			resultSet = statement.executeQuery("Select locationId from Locations where name =\""+locations.get(i-1)+"\"");
			while(resultSet.next()){
				sql = "INSERT INTO `TripLocation` VALUES (?,?,?)";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setInt(1,tripId);
				preparedStatement.setInt(2,resultSet.getInt("locationId"));
				preparedStatement.setInt(3,i);
				preparedStatement.executeUpdate();
			}
		}
		initTripCoaches(trainId,tripId);
	}

	public static void initDb() throws Exception
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway","root","");
		statement = connection.createStatement();
	}

	public static List<String> parseCSVStringToList(String s)
	{
		String[] routes = s.split(",");
		return Arrays.asList(routes);
	}
}