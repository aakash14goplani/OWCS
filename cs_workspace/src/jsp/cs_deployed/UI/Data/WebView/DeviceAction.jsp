<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// UI/Data/WebView/DeviceAction
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

<ics:selectto table="Skins" listname="skinslist" />
<ics:if condition='<%=null!= ics.GetList("skinslist")  && ics.GetList("skinslist").hasData()%>'>
<ics:then>
	<%
		IList skinList = ics.GetList("skinslist");
		StringBuffer skinsJson = new StringBuffer("");
		if (null != skinList) 
		{
			boolean first = true;
			for (int i = 1; i <= skinList.numRows(); i++)
			{
				skinList.moveTo(i);
				if (first) 
					first = false;
				else 
					skinsJson.append(",");

				skinsJson.append("{")
							.append("name: '").append(skinList.getValue("name")).append("',")
							.append("device: '").append(skinList.getValue("id")).append("',")
							.append("suffix: '").append(skinList.getValue("name")).append("',")
							.append("description: '").append(skinList.getValue("description")).append("',")
							.append("doctype: '").append("insite").append("',")
						 .append("}");
			}
		}
		
		request.setAttribute("skinsJson", skinsJson.toString());
	%>
</ics:then>
</ics:if>
</cs:ftcs>