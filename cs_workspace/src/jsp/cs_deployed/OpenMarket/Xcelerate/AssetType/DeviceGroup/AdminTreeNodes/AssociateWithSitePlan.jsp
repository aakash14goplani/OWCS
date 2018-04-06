<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/AdminTreeNodes/AssociateWithSitePlan
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
	<asset:get name="theCurrentAsset" field="active" output="_active" />
	<ics:if condition='<%="Y".equalsIgnoreCase(ics.GetVar("_active")) %>'>
	<ics:then>
		<!-- Searching if the suffix is associated -->
		<asset:get name="theCurrentAsset" field="id" output="_id" />
		<asset:get name="theCurrentAsset" field="devicegroupsuffix" output="_suffix" />
		<ics:setvar name="prefix:status_op" value="!="/>
		<ics:setvar name="prefix:status" value="VO"/>
		<ics:setvar name="prefix:devicegroupsuffix_op" value="="/>
		<ics:setvar name="prefix:devicegroupsuffix" value='<%=ics.GetVar("_suffix") %>'/>
		<asset:search type="DeviceGroup" prefix="prefix" list="dglist"/>
		<ics:listget listname="dglist" fieldname="id" output="_dgid"/>
		
		<!-- Adding the current device group to the site plan if its suffix is associated to site plans -->
		<asset:list type='SitePlan' list="splist" order="name, description desc" excludevoided="true" />
		<ics:listloop listname="splist">
			<ics:listget listname="splist" fieldname="devicegroups" output="_devicegroups"/>
			<ics:if condition='<%= null != ics.GetVar("_devicegroups") && ics.GetVar("_devicegroups").contains(ics.GetVar("_dgid")) && !ics.GetVar("_devicegroups").contains(ics.GetVar("_id")) %>'>
			<ics:then>
				<ics:listget listname="splist" fieldname="id" output="_spid"/>
				<asset:load name="sitePlanAsset" type="SitePlan" objectid='<%= ics.GetVar("_spid") %>' editable="true" />
				<asset:get name="sitePlanAsset" field="devicegroups" output="_devicegroups" />
				<asset:set name="sitePlanAsset" field="devicegroups" value='<%=ics.GetVar("_devicegroups") + ";" + ics.GetVar("_id") %>' />
				<asset:save name="sitePlanAsset" />
			</ics:then>
			</ics:if>
		</ics:listloop>
	</ics:then>
	</ics:if>
	
</cs:ftcs>