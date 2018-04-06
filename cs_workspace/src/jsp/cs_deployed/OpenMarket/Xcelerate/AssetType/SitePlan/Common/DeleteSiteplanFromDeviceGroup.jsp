<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Siteplan/Common/DeleteSiteplanFromDeviceGroup
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

<asset:list list="_DGList" type="DeviceGroup" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>' />

<ics:if condition='<%=null != ics.GetList("_DGList") && ics.GetList("_DGList").hasData()%>'>
<ics:then>
	<ics:listloop listname="_DGList">
		<ics:listget listname="_DGList" fieldname="id" output="_aid" />
		<asset:load name="newDGAsset" type="DeviceGroup" objectid='<%=ics.GetVar("_aid")%>' editable="true" />
		<asset:get name="newDGAsset" field="siteplans" output="siteplans" />

		<ics:if condition='<%=ics.GetVar("siteplans").contains("Siteplan:" + ics.GetVar("pubid") + ":" + ics.GetVar("siteplanid"))%>' >
		<ics:then>
			<hash:create name="myhash" />
			<%
				String siteplans = ics.GetVar("siteplans");
				String[] splist = siteplans.split(";");
				for (int j = 0; j < splist.length; j++)
				{
					if(!("SitePlan:" + ics.GetVar("pubid") + ":" + ics.GetVar("siteplanid")).equals(splist[j]))
					{
						%><hash:add name="myhash" value='<%=splist[j]%>' /><%
					}
				}
			%>
			<hash:tostring name="myhash" delim=";" varname="siteplans" />
			<asset:set name="newDGAsset" field="siteplans" value='<%=ics.GetVar("siteplans")%>' />
		</ics:then>
		</ics:if>
		
		<asset:save name="newDGAsset" />
	</ics:listloop>
</ics:then>
</ics:if>

</cs:ftcs>