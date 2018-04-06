<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Siteplan/Common/DGList
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
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Collections"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="org.codehaus.jackson.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%!
	private static final String _getDisplayDeviceGroupSuffix (ICS ics, String suffix) {
		return Utilities.goodString(suffix) ? suffix : ics.getLocaleString("fatwire/admin/mobility/NoSuffix", ics.GetSSVar("locale"));
	}
%>
<cs:ftcs>

<%-- We can refactor this code by removing the IList DGList and rely on listOfAllDeviceGroups (DeviceGroupBean) --%>
<asset:list list="SPList" type="SitePlan" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>' />

<%
	List<DeviceGroupBean> alDeviceGroupBean = new ArrayList<DeviceGroupBean>();
	// Suffixes associated to other siteplans
	List<String> unassociatedSuffixes = new ArrayList<String>();
	// Suffixes associated to current siteplan
	List<String> associatedSuffixes = new ArrayList<String>();
	// Suffixes not associated to any siteplan
	List<String> freeSuffixes = new ArrayList<String>();
	
	List<String> associatedDeviceGroupIds = new ArrayList<String>();
	List<String> unassociatedDeviceGroupIds = new ArrayList<String>();
	List<String> freeDeviceGroupIds = new ArrayList<String>();
	
	List<DeviceGroupBean> listOfAllDeviceGroups = MobilityUtils.getDeviceGroups(ics);
%>
<input type='hidden' id="deviceGroupList" value='' />

<script>
	// Setting input value direcly cannot handle single quotes
	dojo.addOnLoad(function() {
		dojo.byId('deviceGroupList').setAttribute("value", dojo.toJson(<%= new ObjectMapper().writeValueAsString(listOfAllDeviceGroups) %>));
	});
</script>

<ics:listloop listname="SPList">
	<ics:listget listname="SPList" fieldname="id" output="id" />
	<%
		alDeviceGroupBean = MobilityUtils.getDeviceGroupsForSiteplan(ics, Long.parseLong(ics.GetVar("id")));
		if(ics.GetVar("id").equalsIgnoreCase(ics.GetVar("spid"))) 
		{
			for(int i = 0; i < alDeviceGroupBean.size(); i++)
			{
				if (!associatedSuffixes.contains(alDeviceGroupBean.get(i).getDeviceGroupSuffix()))
					associatedSuffixes.add(alDeviceGroupBean.get(i).getDeviceGroupSuffix());
				associatedDeviceGroupIds.add(String.valueOf(alDeviceGroupBean.get(i).getId()));
			}
		}
		else 
		{
			for(int i = 0; i < alDeviceGroupBean.size(); i++)
			{
				if (!unassociatedSuffixes.contains(alDeviceGroupBean.get(i).getDeviceGroupSuffix()))
					unassociatedSuffixes.add(alDeviceGroupBean.get(i).getDeviceGroupSuffix());
				unassociatedDeviceGroupIds.add(String.valueOf(alDeviceGroupBean.get(i).getId()));
			}
		}
	%>
</ics:listloop>

<asset:list list="DGList" type="DeviceGroup" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>' order="name, description desc" field1="active" value1="Y"/>
<!-- Check for free device group suffixes -->
<%
	IList deviceGroupList = ics.GetList("DGList");
	boolean availableDeviceGroupSuffixes = false;
	for (int i = 1; i <= deviceGroupList.numRows(); i++)
	{
		deviceGroupList.moveTo(i);
		if (!unassociatedSuffixes.contains(deviceGroupList.getValue("devicegroupsuffix")) && !associatedSuffixes.contains(deviceGroupList.getValue("devicegroupsuffix")))
		{
			if (!freeSuffixes.contains(deviceGroupList.getValue("devicegroupsuffix")))
				freeSuffixes.add(deviceGroupList.getValue("devicegroupsuffix"));
			freeDeviceGroupIds.add(deviceGroupList.getValue("id"));
		}
	}
	
	// valid suffixes are free suffixes + associated suffixes
	List<String> validSuffixes = new ArrayList<String>();	
	validSuffixes.addAll(freeSuffixes);	
	validSuffixes.addAll(associatedSuffixes);
	Collections.sort(freeSuffixes);
	Collections.sort(associatedSuffixes);
	Collections.sort(validSuffixes);
%>

<ics:if condition='<%=null != ics.GetList("DGList") && ics.GetList("DGList").hasData()%>'>
<ics:then>
	<td class="form-label-text" align="right" VALIGN="TOP" NOWRAP="true">
		<xlat:stream key="fatwire/admin/Suffix"/>:
	</td>
	<td class="form-inset" align="left">
	<%
		deviceGroupList = ics.GetList("DGList");
		if("new".equals(ics.GetVar("formtype")))
		{
			if(freeSuffixes.size() == 0)
			{
				%><xlat:stream key="fatwire/admin/mobility/NoSuffixToAssociate" /><%
			}
			else
			{
				%><SELECT id="SuffixList" NAME="SuffixList" onChange="onSuffixSelect()" SIZE="10" style="width: 215px;" MULTIPLE><%
				for (int i = 0; i < freeSuffixes.size(); i++)
				{
					%><OPTION VALUE='<%=freeSuffixes.get(i)%>'><string:stream value='<%=_getDisplayDeviceGroupSuffix(ics, freeSuffixes.get(i))%>'/></OPTION><%
				}
				%></SELECT><%
			}
		}
		else if("modify".equals(ics.GetVar("formtype")))
		{
			if(validSuffixes.size() == 0)
			{
				%><xlat:stream key="fatwire/admin/mobility/NoSuffixToAssociate" /><%
			}
			else
			{
				%><SELECT id="SuffixList" NAME="SuffixList" onChange="onSuffixSelect()" SIZE="10" style="width: 215px;" MULTIPLE><%
				for (int i = 0; i < validSuffixes.size(); i++)
				{
					if(associatedSuffixes.contains(validSuffixes.get(i)))
					{
						%><OPTION VALUE='<%=validSuffixes.get(i)%>' selected><string:stream value='<%=_getDisplayDeviceGroupSuffix(ics, validSuffixes.get(i))%>'/></OPTION><%
					}
					else
					{
						%><OPTION VALUE='<%=validSuffixes.get(i)%>'><string:stream value='<%=_getDisplayDeviceGroupSuffix(ics, validSuffixes.get(i))%>'/></OPTION><%
					}
				}
				%></SELECT><%
			}
		}
		else if("delete".equals(ics.GetVar("formtype")))
		{
			if(associatedSuffixes.size() == 0)
			{
				%><xlat:stream key="fatwire/admin/mobility/NoSuffixAssociated" /><%
			}
			else
			{
				%><SELECT NAME="SuffixList" SIZE="10" style="width: 215px;" MULTIPLE><%
				for (int i = 0; i < associatedSuffixes.size(); i++)
				{
					%><OPTION VALUE='<%=associatedSuffixes.get(i)%>' disabled><string:stream value='<%=_getDisplayDeviceGroupSuffix(ics, associatedSuffixes.get(i))%>'/></OPTION><%
				}
				%></SELECT><%
			}
		}
	%>
	</td>
	<td class="form-label-text" align="right" VALIGN="TOP" NOWRAP="true">
		<xlat:stream key="fatwire/admin/mobility/AssociatedDeviceGroups"/>:
	</td>
	<td class="form-inset" align="left">
	<%
		deviceGroupList = ics.GetList("DGList");
		if("new".equals(ics.GetVar("formtype")))
		{
			if(freeSuffixes.size() == 0)
			{
				%><xlat:stream key="dvin/UI/MobilitySolution/NoDeviceGroupsToAssociate" /><%
			}
			else
			{
				%><SELECT id="DGList" NAME="DGList" SIZE="10" style="width: 215px;background-color:lightgrey" MULTIPLE></SELECT><%
			}
		}
		else if("modify".equals(ics.GetVar("formtype")))
		{
			if(validSuffixes.size() == 0)
			{
				%><xlat:stream key="dvin/UI/MobilitySolution/NoDeviceGroupsToAssociate" /><%
			}
			else
			{
				%><SELECT id="DGList" NAME="DGList" SIZE="10" style="width: 215px;background-color:lightgrey" MULTIPLE><%
				for (int i = 1; i <= deviceGroupList.numRows(); i++)
				{
					deviceGroupList.moveTo(i);
					if(associatedDeviceGroupIds.contains(deviceGroupList.getValue("id")))
					{
						%><OPTION style="color:black" VALUE="<%=deviceGroupList.getValue("id")%>" disabled><string:stream value = '<%=deviceGroupList.getValue("name")%>'/></OPTION><%
					}
				}
				%></SELECT><%
			}
		}
		else if("delete".equals(ics.GetVar("formtype")))
		{
			if(associatedSuffixes.size() == 0)
			{
				%><xlat:stream key="dvin/UI/MobilitySolution/NoDeviceGroupsAssociated" /><%
			}
			else
			{
				%><SELECT id="DGList" NAME="DGList" SIZE="10" style="width: 215px;background-color:lightgrey" MULTIPLE><%
				for (int i = 1; i <= deviceGroupList.numRows(); i++)
				{
					deviceGroupList.moveTo(i);
					if(associatedDeviceGroupIds.contains(deviceGroupList.getValue("id")))
					{
						%><OPTION style="color:black" VALUE="<%=deviceGroupList.getValue("id")%>" disabled><string:stream value = '<%=deviceGroupList.getValue("name")%>'/></OPTION><%
					}
				}
				%></SELECT><%
			}
		}
	%>
	</td>
</ics:then>
<ics:else>
	<xlat:stream key="dvin/UI/MobilitySolution/NoDeviceGroupsToAssociate" />
</ics:else>
</ics:if>

</cs:ftcs>