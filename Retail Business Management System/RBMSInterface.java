// usage:  1. compile: javac -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar RBMSInterface.java
//         2. execute: java -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar RBMSInterface.java

// Illustrating ref cursor for a function without a parameter
import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;
import java.util.Scanner;
import java.util.*;

public class RBMSInterface{

   public static void main (String args []) throws SQLException {
    try
	{
	//Connecting to Oracle server.
	OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
    Scanner s = new Scanner(System.in);
    System.out.println("Enter your sqlplus account username:");
    String username = s.nextLine();
    System.out.println("Enter your sqlplus account passowrd:");
    String password = s.nextLine();
	ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
	Connection conn = ds.getConnection(username,password);
    System.out.println("Connection Successful...");
	//We are designign a menu based interactive interface for the user in order to integrate all requested procedures.
	while(true){
		System.out.println("Enter a choice number from the menu: ");
		System.out.println("1.Show all tables\n2.Add new employee\n3.Monthly Sale Activities\n4.Make a purchase\n5.exit\n");
		int choice = s.nextInt();
    switch(choice){
		case 1:
			  display_all(conn);
			  break;
		case 2:
			  add_employee(conn);break;
	    case 3:
			  monthly_sale_activities(conn);break;
		case 4:
			  add_purchase(conn);break;
	    case 5:
			   conn.close();
			   System.exit(1);
	    default:
			   System.out.println("Invalid Choice: "+choice+"enter a valid choice"); break;
			   
	}//end switch
    }//end whie loop
	}
    catch (SQLException ex) { 
		System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());
        error_handler(ex.getMessage());
	}
    catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n"+ e.getMessage());
	System.out.println(e.getMessage());
	}
  }//main method

  //This method is to insert a new record into the employee table.
  public static void add_employee(Connection conn) throws SQLException{
	Scanner s = new Scanner(System.in);
	System.out.println("Enter details of the new employee to be added...");
	System.out.println("Enter employee id:");
	String e_id = s.nextLine();
	System.out.println("Enter employee name:");
	String e_name = s.nextLine();
	System.out.println("Enter employee phone number:");
	String e_telephone = s.nextLine();
	System.out.println("Enter employee email:");
	String e_email = s.nextLine();
	PreparedStatement insert = conn.prepareStatement("{call prj2.add_employee(?,?,?,?)}");//prepare a call to the add employee procedure
	insert.setString(1,e_id);
	insert.setString(2,e_name);
	insert.setString(3,e_telephone);//set the in parameters of the procedure
	insert.setString(4,e_email);
	insert.executeQuery();
	insert.close();
    //Retrieve the inserted data
	Statement stmt = conn.createStatement ();
    String emp_select_query = "select * from employees where eid = ?";
    PreparedStatement select = conn.prepareStatement(emp_select_query);
    select.setString(1,e_id);
	ResultSet rs = select.executeQuery();
	// conn.close();
	System.out.println("Newly inserted data by retrieving it from the employees table:");
	display_data(rs);
	rs = stmt.executeQuery("select * from logs order by op_time desc");
	display_data(rs);
  }
   //This method is used to display records of all the tables
   public static void display_all(Connection conn) throws SQLException{
    CallableStatement cs = conn.prepareCall("begin ? := prj2.display_employees; end;");
	render_data(cs);
	cs = conn.prepareCall("begin ? := prj2.display_customers; end;");
	render_data(cs);
	cs = conn.prepareCall("begin ? := prj2.display_products; end;");
	render_data(cs);
	cs = conn.prepareCall("begin ? := prj2.display_prd_discnts; end;");
	render_data(cs);
	 cs = conn.prepareCall("begin ? := prj2.display_purchases; end;");
	render_data(cs);
	cs = conn.prepareCall("begin ? := prj2.display_logs; end;");
	render_data(cs);
	//close the connection
	cs.close();
	//conn.close();
   }
   public static void render_data(CallableStatement cs) throws SQLException{
     cs.registerOutParameter(1, OracleTypes.CURSOR);

	// execute and retrieve the result set
	cs.execute();
	ResultSet rs = (ResultSet)cs.getObject(1);
	display_data(rs);
   }

   //The below utility method is to display table contents.
   public static void display_data(ResultSet rs) throws SQLException{
     ResultSetMetaData rsmd = (ResultSetMetaData)rs.getMetaData();
	int columnCount = rsmd.getColumnCount();
	// print the results
	for(int i=1; i<=columnCount; i++){
		System.out.print(rsmd.getColumnName(i)+"\t\t");
	}
	System.out.println("\r\n----------------------------------------------------------------------");
	while (rs.next()) {
        for(int i =1; i<=columnCount; i++){
		System.out.print(rs.getString(i)+"\t\t");
		}
		System.out.println("\n");
	}
   }
   //This method is to make a new purchase based on the inputs received from the user.
   public static void add_purchase(Connection conn) throws SQLException
   {
	Scanner s = new Scanner(System.in);
	System.out.println("Enter employee id:");
	String e_id = s.nextLine();
	System.out.println("Enter product id:");
	String p_id = s.nextLine();
	System.out.println("Enter customer id:");
	String c_id = s.nextLine();
	System.out.println("Enter purchase quantity:");
	String pur_qty = s.nextLine();
	System.out.println("Enter Unit price of the purchase:");
	String unit_price = s.nextLine();
	PreparedStatement insert = conn.prepareStatement("{call prj2.add_purchase(?,?,?,?,?)}");
	insert.setString(1,e_id);
	insert.setString(2,p_id);
	insert.setString(3,c_id);
	insert.setString(4,pur_qty);
	insert.setString(5,unit_price);
	insert.executeQuery();
    display_buffer_lines(conn);
	insert.close();
  }
  //The below method is to print the monthly sale activities of the employee
  public static void monthly_sale_activities(Connection conn) throws SQLException{
	System.out.println("Enter the employee id: ");
	Scanner s = new Scanner(System.in);
	String e_id = s.nextLine();
	CallableStatement cs = conn.prepareCall("begin ? := prj2.monthly_sale_activities(?); end;");
	cs.registerOutParameter(1, OracleTypes.CURSOR);
    cs.setString(2,e_id);
	// execute and retrieve the result set
	cs.execute();
	ResultSet rs = (ResultSet)cs.getObject(1);
	ResultSet rs1 = rs;
	if(rs.isBeforeFirst()){
	display_buffer_lines(conn);
	display_data(rs);
	}else{
		System.out.println("No data found for employee with eid: "+e_id+"\n");
	}
  }
  //The below method is the utility method to display the sqplplus buffer output contents in the terminal.
  public static void display_buffer_lines(Connection conn) throws SQLException{
    String getOutput = "{ call dbms_output.get_lines(?,?) }";
	CallableStatement getOutputCallable = conn.prepareCall(getOutput);
	getOutputCallable.registerOutParameter(1, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
	getOutputCallable.registerOutParameter(2, Types.INTEGER);
	getOutputCallable.execute();
	Array array = getOutputCallable.getArray(1);
	if (array != null) {	
    Object[] values = (Object[])array.getArray();
    for (int i = 0; i < values.length; i++) {
        String line = (String)values[i];
		if(null != line)
        	System.out.println(line);
    }
	}
  }

  public static void error_handler(String error_msg){
	if(error_msg.contains("ORA-00001")){
		System.out.println("SQL violation... data already present in the database. Please enter data with a different id");
	}
	else if(error_msg.contains("ORA-02291")){
		System.out.println("Enter valid combination of eid pid cid to make a purchase.");
	}
  }
}

