<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/ShowAttributesCDHelper
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
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<cs:ftcs>
<%
String action = ics.GetVar("action");
if("create".equals(action)){
	List<String> attrValList = new ArrayList<String>();
	ics.SetObj("attrValList",attrValList);
}
if("add".equals(action)){
	String Value = ics.GetVar("attrval");
	List<String> attrValList = (List<String>)ics.GetObj("attrValList");
	attrValList.add(Value);
}
if("display".equals(action)){
	List<String> attrValList = (List<String>)ics.GetObj("attrValList");
	if(attrValList != null){
		if(attrValList.size() == 1){
		%>
			<string:stream value='<%=attrValList.get(0)%>'/>
		<%} else {
		%>
		<table>
		<%	
			for(int i=0;i<attrValList.size();i++){
			String attrvalue = attrValList.get(i);
			if(attrvalue.length() > 30){
				attrvalue = attrvalue.substring(0,30) + "...";
			}
			%>
				<tr><td>
				<div class="mulValTFieldDisplay" title="<string:stream value='<%=attrValList.get(i)%>'/>"><string:stream value='<%=attrvalue%>'/></div>
				</td></tr>
				<%if(i != attrValList.size() -1 ){%>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
				<%}
			}
		%>
		</table>
		<%
		}
		//Remove the object from the ics
		ics.SetObj("attrValList",null);
	} else {
	%>
		<span class="disabledText"><xlat:stream key='UI/Forms/NotAvailable' encode="false" escape="true"/></span>
	<%
	}
}%>
</cs:ftcs>