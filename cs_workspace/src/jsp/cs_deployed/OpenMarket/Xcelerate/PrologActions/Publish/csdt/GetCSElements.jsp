<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// csdt/GetCSElements
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

<%@page import="java.util.ArrayList"%><cs:ftcs>

<%
	String pubId = request.getParameter("pubid");
	ArrayList<String> idList = new ArrayList<String>();
	String responseString = "";
%>
<ics:setvar name="assettype" value="CSElement"/>
<ics:setvar name="pubid" value='<%=pubId %>'/>

<ics:selectto listname="assetIdList" table="AssetPublication" what="assetid" where="assettype, pubid"/>
<ics:if condition='<%=ics.GetErrno() != -101%>'>
<ics:then>
  <ics:listloop listname="assetIdList">
     <ics:listget listname="assetIdList" fieldname="assetid" output="id"/>
	 <%
	 	idList.add(ics.GetVar("id"));
	 %>	   
  </ics:listloop>
</ics:then>
<ics:else>
  No records found.
</ics:else>
</ics:if>

<%
	for ( int count = 0; count < idList.size(); count ++ ){
%>
		<ics:setvar name="id" value='<%=idList.get(count) %>'/>
		<ics:selectto listname="rootElementList" table="CSELEment" what="rootelement" where="id"/>
		<ics:if condition='<%=ics.GetErrno() != -101 %>'>
		<ics:then>
			<ics:listloop listname="rootElementList">
     			<ics:listget listname="rootElementList" fieldname="rootelement" output="element"/>
	 			<%
	 				responseString += ics.GetVar("id") + ":" + ics.GetVar("element");
	 				if ( count < ( idList.size() - 1 ) )
	 					responseString += ",";
	 			%>	   
  			</ics:listloop>
		</ics:then>
		</ics:if>
<%		
	}
%>
<%=responseString %>
</cs:ftcs>