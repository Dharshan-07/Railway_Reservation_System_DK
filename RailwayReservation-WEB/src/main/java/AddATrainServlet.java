
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.*;
public class AddATrainServlet extends HttpServlet
{
	static Connection connection;
	static Statement statement;
	RequestDispatcher rd;
	public void service(HttpServletRequest req, HttpServletResponse resp)
	{
		String s = req.getParameter("trainName");
		try
		{
			initDb();
			addATrain(s);
			rd=req.getRequestDispatcher("/index.jsp");
			rd.include(req, resp);
		}
		catch(Exception e)
		{
			throw new RuntimeException(e);
		}


	}

	private static void addATrain(String s) throws Exception
	{
		String[] params = s.split(" ");
		String name = params[0];
		int noOfFirstAC = Integer.parseInt(params[1]);
		int noOfSecondAC = Integer.parseInt(params[2]);
		int noOfThirdAC = Integer.parseInt(params[3]);
		int noOfSleeper = Integer.parseInt(params[4]);
		int noOfGeneral = Integer.parseInt(params[5]);

		addTrainRow(name,noOfFirstAC,noOfSecondAC,noOfThirdAC,noOfSleeper,noOfGeneral);
		System.out.println("Train Added Successfully");
	}

	public static void addTrainRow(String name,int noOfFirstAC,int noOfSecondAC,int noOfThirdAC,int noOfSleeper,int noOfGeneral) throws Exception
	{
		ResultSet resultSet = statement.executeQuery("SELECT trainId FROM Trains ORDER BY trainId DESC LIMIT 1;");
		int trainId = 0;
		while(resultSet.next()){
			trainId = resultSet.getInt("trainID");
		}
		String sql = "INSERT INTO `Trains` VALUES (?,?,?,?,?,?,?)";
		PreparedStatement preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setInt(1,++trainId);
		preparedStatement.setString(2,name);
		preparedStatement.setInt(3,noOfFirstAC);
		preparedStatement.setInt(4,noOfSecondAC);
		preparedStatement.setInt(5,noOfThirdAC);
		preparedStatement.setInt(6,noOfSleeper);
		preparedStatement.setInt(7,noOfGeneral);
		int rowsAffected = preparedStatement.executeUpdate();
		System.out.println("rows affected "+rowsAffected);

	}

	public static void initDb() throws Exception
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Railway","root","");
		statement = connection.createStatement();
	}
}