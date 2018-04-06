<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/PullDownQueryResults
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
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<%!
private void buildItem(StringBuilder jsonBuilder, String resultValue, String resultId, int resultCount) {
	if (resultCount != 0)
		jsonBuilder.append(",");

	jsonBuilder.append("{");
	
	if (null != resultId) 	
		jsonBuilder.append("\"assetid\":\"").append(resultId)
				   .append("\"" + ",");
				
	jsonBuilder.append("\"value\": \"").append(resultValue)
			   .append("\"}");
}
%>
<cs:ftcs>
<asset:load name="aQuery" type="Query" field="name" value='<%=ics.GetVar("queryAssetName")%>'/>

<ics:callelement element='OpenMarket/Xcelerate/AssetType/Query/ExecuteQuery'>		
	<ics:argument name="list" value='templist'/>
	<ics:argument name="assetname" value='aQuery'/>
	<ics:argument name="ResultLimit" value='<%=ics.GetVar("numberOfResults")%>'/>		
</ics:callelement>
<%
	StringBuilder jsonBuilder = new StringBuilder("");
	int resultCount = 0;
	String attribuType = ics.GetVar("attribType");
	String qryString = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("value"));
	String resultValue = "";
	String resultID = "";
	String keyString = "";

	if ("asset".equalsIgnoreCase(attribuType)) {
		jsonBuilder.append("{")
					.append("\"identifier\":\"assetid\"" + ",")
					.append("\"label\":\"value\"" + ",") 
					.append("\"items\": [");
	}
	else {
		jsonBuilder.append("{")
					.append("\"label\":\"value\"" + ",") 
					.append("\"items\": [");
	}
%>
<ics:if condition='<%=null != ics.GetList("templist")%>'>
<ics:then>
	<ics:if condition='<%=ics.GetList("templist").hasData()%>'>
	<ics:then>
		<ics:listloop listname="templist">
			<ics:if condition='<%="asset".equalsIgnoreCase(attribuType)%>'>
			<ics:then>
				<ics:listget listname="templist" fieldname="assetid" output="resultId" />
			</ics:then>
			</ics:if>			
			<ics:listget listname="templist" fieldname="value" output="resultValue" />
<%
				resultID = ics.GetVar("resultId");
				resultValue = ics.GetVar("resultValue");
				if ("date".equals(attribuType) && Utilities.goodString(resultValue)) {
					DateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date convDate = new Date();
					convDate = (Date) simpleFormat.parse(resultValue);
					resultValue = simpleFormat.format(convDate);
				}
				resultValue = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(resultValue);				
				/*
				 * To Be Written
				 *
				 *
				*/
				if (null == qryString || qryString.equalsIgnoreCase(resultValue) || qryString.equals(resultID) || "*".equals(qryString)) {
					buildItem(jsonBuilder, resultValue, resultID, resultCount);
					resultCount++;			
				}
				else if (qryString.endsWith("*")) {
					keyString = qryString.substring(0 , qryString.indexOf("*"));
					if (null != resultValue && 
						resultValue.toLowerCase()
								   .startsWith(keyString.toLowerCase()))
					{
						buildItem(jsonBuilder, resultValue, resultID, resultCount);
						resultCount++;
					}	
				}						
%>
		</ics:listloop>	
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>

<%
	jsonBuilder.append("]}");
	//System.out.println("jsonBuilder: " + jsonBuilder);
%>

<%=jsonBuilder.toString()%>

<ics:removevar name="list"/>
<ics:removevar name="ResultLimit"/>
<ics:removevar name="templist"/>
</cs:ftcs>