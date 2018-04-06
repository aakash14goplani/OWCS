<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ShowDeviceGroupAssociationMsg
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
<%@ page import="COM.FutureTense.Util.ftMessage,COM.FutureTense.Util.ftUtil" %>
<cs:ftcs>
<ics:if condition='<%=(!Utilities.goodString(ics.GetVar("DeviceGroup:active"))) || ("N".equalsIgnoreCase(ics.GetVar("DeviceGroup:active")))%>'>
<ics:then>
<ics:if condition='<%= "0".equalsIgnoreCase(ics.GetVar("errno"))%>'>
   <ics:then>
		<%StringBuffer sb = new StringBuffer();%>
		<xlat:lookup key="dvin/UI/SitePlan" varname="siteplanstr" />
		<xlat:lookup key="dvin/Common/Site" varname="sitestr" />
		<asset:list type="SitePlan" excludevoided="true" list="siteplanlist" />
		<ics:listloop listname="siteplanlist" >
		<ics:listget listname="siteplanlist" fieldname="devicegroups" output="associatedDeviceGroups" />
		<ics:if condition='<%=Utilities.goodString(ics.GetVar("associatedDeviceGroups"))%>'>
			<ics:then>
				<%
				String deviceGroups = ics.GetVar("associatedDeviceGroups");
				String[] groups = deviceGroups.split(";");
				for(String g : groups)
				{
					if(g.equals(ics.GetVar("id")))
					{
					%>
						<ics:listget listname="siteplanlist" fieldname="name" output="sitePlanName" />
						<ics:listget listname="siteplanlist" fieldname="id" output="sitePlanId" />
						<asset:sites type="SitePlan" objectid='<%=ics.GetVar("sitePlanId")%>' list="pubnamelist" />
						<ics:listget listname="pubnamelist" fieldname="name" output="sitename" />
						<%
						sb.append(ics.GetVar("sitestr")+" : "+ics.GetVar("sitename")+",  "+ics.GetVar("siteplanstr")+" : "+ics.GetVar("sitePlanName")+"<BR/>");
					}
				}
				%>
			</ics:then>
		</ics:if>
		</ics:listloop>
		
		<!-- If the Device Group is associated with Site Plans, errno and the associated siteplan names are set -->
		<ics:if condition='<%=Utilities.goodString(sb.toString())%>'>
		<ics:then>
			<ics:setvar name="errno" value='<%= String.valueOf(ftErrors.sitePlanDependencyErr)%>' />
			<ics:setvar name="dependencyMsg" value='<%= sb.toString()%>' />
		</ics:then>
		</ics:if>
				
   </ics:then>              
</ics:if>
</ics:then>
</ics:if>
</cs:ftcs>