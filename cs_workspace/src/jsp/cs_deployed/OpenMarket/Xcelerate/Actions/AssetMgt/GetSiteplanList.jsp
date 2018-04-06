<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/GetSiteplanList
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
<cs:ftcs>

<%
	if (null == ics.GetVar("pubid"))
		ics.SetVar("pubid", ics.GetSSVar("pubid"));
%>
<asset:list type="SitePlan" excludevoided="true" list="SitePlanList" order="name, description desc" pubid='<%=ics.GetVar("pubid")%>' />
<% 
	StringBuffer SitePlanIdsList = new StringBuffer("");
	if(null == ics.GetVar("outputlistname"))
		ics.SetVar("outputlistname", "SitePlanList");
%>
<ics:listloop listname="SitePlanList">
	<ics:listget listname="SitePlanList" fieldname="id" output="sid" />
	<%
		SitePlanIdsList.append(ics.GetVar("sid") + ",");
	%>
</ics:listloop>
<%
	String tempStr = "''";
	if (SitePlanIdsList.length() > 0)
	{
		tempStr = SitePlanIdsList.substring(0, SitePlanIdsList.length() - 1);
%>
	<ics:sql listname='<%=ics.GetVar("outputlistname") %>' table="SitePlan,SitePlanTree" 
		sql='<%="select SitePlan.*, SitePlanTree.nrank from SitePlan, SitePlanTree where SitePlanTree.otype=\'SitePlan\' and SitePlanTree.oid=SitePlan.id and SitePlan.id in (" + tempStr + ") order by SitePlanTree.nrank "%>' />
<%
	}
%>
</cs:ftcs>