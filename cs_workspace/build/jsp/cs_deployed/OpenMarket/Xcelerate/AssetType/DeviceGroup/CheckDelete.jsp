<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/CheckDelete
//
// This element checks if ANY siteplan in ANY site refers to this DeviceGroup.
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
<!-- Find out all the siteplans which refer to this DeviceGroup -->
<%
StringBuffer sb = new StringBuffer();
%>
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

<ics:if condition='<%=Utilities.goodString(sb.toString())%>'>
<ics:then>
	<xlat:lookup key="fatwire/admin/errors/DeviceGroupDeleteErrorMsgSitePlanDep" varname="dependencyErrorMsg" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("dependencyErrorMsg") + "<br><br>" + sb.toString()%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
	<ics:setvar name="cannotdelete" value="true" />			
	<ics:setvar name="errorhandled" value="true" />			
</ics:then>
</ics:if>

</cs:ftcs>