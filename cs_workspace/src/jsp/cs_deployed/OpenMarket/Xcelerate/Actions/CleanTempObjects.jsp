<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
//This element deletes the old data from the TempObjects table. 
//OpenMarket/Xcelerate/Actions/CleanTempObjects
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<%
	Calendar calendar = new GregorianCalendar();
	//Default days to keep.
	int daysToKeep = 5;
	String dbType = ics.GetProperty("cs.dbtype", "futuretense.ini", true);
	if(ics.GetProperty("cs.TempObjectsDaysToKeep") != null){
		try{
		daysToKeep = Integer.parseInt((String)ics.GetProperty("cs.TempObjectsDaysToKeep"));
		} catch(Exception ex) {
			//Ignore the exception and go ahead with the default value.
		}
	}
	//Delete the data which is older then given number of days.
	calendar.add(Calendar.DATE,-daysToKeep);
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
	String date = dateFormat.format(calendar.getTime());
	//Generic query to select the older data
	String sql = "select * from TempObjects where createddate < CAST('" + date + "' AS DATE)";
	if(dbType.equals("DB2"))
	{
	   sql = "select * from TempObjects where createddate < CURRENT_TIMESTAMP - "+daysToKeep+" DAYS";
	}
	StringBuffer err = new StringBuffer(); 
	IList deletedData = ics.SQL("TempObjects", sql,null, -1, true, err);
	if(deletedData != null){
		for(int i=1; i <= deletedData.numRows(); i++){
			deletedData.moveTo(i);
			String delId = deletedData.getValue("id");
			%>
			<ics:catalogmanager>
				<ics:argument name="ftcmd" value="deleterow" />
		        <ics:argument name="tablename" value="TempObjects" />
		        <ics:argument name="id" value="<%=delId%>" />
		        <ics:argument name="Delete uploaded file(s)" value ="yes"/>
			</ics:catalogmanager>
			<%
		}
	}
	// invalidate the session as it is no more needed.
	session.invalidate();
%>

</cs:ftcs>