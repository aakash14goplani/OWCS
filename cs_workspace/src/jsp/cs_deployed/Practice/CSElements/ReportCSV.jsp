<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.io.File"%>
<%@page import="java.io.PrintWriter"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
	<satellite:link pagename="Practice/ExcelAfterSubmit" outstring="pageURL"></satellite:link>
	<form id="excelForm">
		<input type="submit" value="Export to CSV" onclick="excel();"/>
		<input type="hidden" name="pagename" value="Practice/ExcelAfterSubmit" />
	</form><%
		StringBuilder sb = new StringBuilder();
		sb.append("ID");sb.append(",");
		sb.append("NAME");sb.append(",");
		sb.append("TEMPLATE");sb.append(",");
		sb.append("UPDATED DATE");sb.append("\n");
	%><ics:sql table="AssetPublication" listname="resultList" sql="select * from AssetPublication" />
	<ics:if condition='<%=null != ics.GetList("resultList") && ics.GetList("resultList").hasData() %>'>
		<ics:then>
			<table id="tableContent" border="1">
				<tr>
					<th>ID</th>
					<th>NAME</th>
					<th>TEMPLATE</th>
					<th>UPDATED DATE</th>
				</tr>
				<ics:listloop listname="resultList">
					<tr>
						<td><ics:listget fieldname="id" listname="resultList"/></td>
						<td><ics:listget fieldname="pubid" listname="resultList"/></td>
						<td><ics:listget fieldname="assettype" listname="resultList"/></td>
						<td><ics:listget fieldname="assetid" listname="resultList"/></td>
					</tr><% 
					sb.append(ics.GetList("resultList").getValue("id") );sb.append(",");
					sb.append(ics.GetList("resultList").getValue("pubid") );sb.append(",");
					sb.append(ics.GetList("resultList").getValue("assettype") );sb.append(",");
					sb.append(ics.GetList("resultList").getValue("assetid") );sb.append("\n");
				%></ics:listloop>
			</table><% 
			try {
				Calendar cal = Calendar.getInstance();
				String currTime = new SimpleDateFormat("HH_mm_ss").format(cal.getTime());
				String currDate = new SimpleDateFormat("yyyy_MM_dd").format(new Date());
				String fileName = "BusinessPageOwnerReport_" + currTime + ".csv";
				String downloadPath = "C:\\Users\\aakash.goplani\\JSK12Workspace\\" + ics.GetVar("site") + "\\" + currDate + "\\";
				//String downloadPath = "C:\\Users\\aakash.goplani\\JSK12Workspace\\";
			
				out.println(sb.toString());
				PrintWriter pw = new PrintWriter(new File(fileName));
				pw.write(sb.toString());
		        pw.close();
		        out.println("done!");
			}
			catch (Exception e) {
				out.println("Exception Occured: " + e.getMessage() + ", " + e);
			}
		%></ics:then>
	</ics:if>	
	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script>
		/*function excel(){
			console.log("Event sucess");
			var tableData = document.getElementById("tableContent").outerHTML;
			var input = document.createElement("input");		
			input.setAttribute("type", "hidden");		
			input.setAttribute("name", "tableData");		
			input.setAttribute("value", tableData);
			document.getElementById("excelForm").appendChild(input);
		}*/
	</script>
</cs:ftcs>