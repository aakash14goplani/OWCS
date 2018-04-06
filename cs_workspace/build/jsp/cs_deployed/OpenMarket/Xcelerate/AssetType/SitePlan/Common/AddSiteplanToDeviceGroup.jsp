<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Siteplan/Common/AddSiteplanToDeviceGroup
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
	String DGList = ics.GetVar("DGList");
	String[] deviceGroupList = DGList.split(";");
	if(deviceGroupList.length > 0)
	{
		for(int i = 0; i < deviceGroupList.length; i++)
		{
			%>
				<asset:load name="newDGAsset" type="DeviceGroup" objectid='<%=deviceGroupList[i]%>' editable="true" />
				<asset:get name="newDGAsset" field="siteplans" output="siteplans" />
				<hash:create name="myhash" />
				<hash:add name="myhash" value='<%="SitePlan:" + ics.GetVar("pubid") + ":" + ics.GetVar("id")%>' />
				<%
					String siteplans = ics.GetVar("siteplans");
					String[] splist = siteplans.split(";");
					for (int j = 0; j < splist.length; j++)
					{
						if(!"".equals(splist[j]))
						{
							%><hash:add name="myhash" value='<%=splist[j]%>' /><%
						}
					}
				%>
				<hash:tostring name="myhash" delim=";" varname="siteplans" />
				<asset:set name="newDGAsset" field="siteplans" value='<%=ics.GetVar("siteplans")%>' />
				<asset:save name="newDGAsset" />
			<%
		}
	}
%>



</cs:ftcs>