<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/ListAvailableAssetType
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
<%@ page import="COM.FutureTense.Util.ftMessage,com.openmarket.xcelerate.asset.BulkAsset"%>
<cs:ftcs>

<%
	StringBuffer sb = new StringBuffer("Select * from AssetType");
	StringBuffer filterAT = new StringBuffer("");
	if (null == ics.GetVar("ignoreslots"))
		filterAT.append("'Slots',");
	if (!"true".equalsIgnoreCase(ics.GetVar("showSitePlan")))
		filterAT.append("'SitePlan',");
	if (!"true".equalsIgnoreCase(ics.GetVar("showWebRoot")))
		filterAT.append("'WebRoot',");
	
	if(filterAT.length() > 0)
		sb.append(" ").append("where assettype not in (" + filterAT.substring(0, filterAT.length() - 1) + ")");
	
	String sql = sb.append(" ").append("order by assettype").toString();
%>
<ics:sql sql='<%=sql%>' listname='<%=ics.GetVar("listname")%>' table='AssetType' />
</cs:ftcs>