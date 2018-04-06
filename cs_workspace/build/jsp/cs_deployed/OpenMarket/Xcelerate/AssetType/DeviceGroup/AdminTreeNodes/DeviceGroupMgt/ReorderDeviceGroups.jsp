<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/AdminTreeNodes/DeviceGroupMgt/ReorderDeviceGroups
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
<%@ page import="COM.FutureTense.Util.ftUtil"%>
<%@ page import="org.apache.commons.logging.Log,org.apache.commons.logging.LogFactory,com.fatwire.mobility.util.MobilityUtils" %>

<cs:ftcs>

<%
Log log = LogFactory.getLog("com.fatwire.logging.cs.mobility");
%>

<ics:if condition='<%=(Utilities.goodString(ics.GetVar("order")))%>' >
	<ics:then>
	<%
	String orderStr = ics.GetVar("order"),deviceGroupId = null,priority = null;
	String ROW_DELIMITER = ",", COL_DELIMITER = ":";
	String[] groups = orderStr.split(ROW_DELIMITER);
	if(groups != null && groups.length > 0)	
	{
		int i = 0;
		ics.SetVar("reordering","true");
		for(;i<groups.length && (ics.GetErrno() == 0);i++)
			{
			  String group = groups[i];
			  String[] fields = group.split(COL_DELIMITER);			  
			  if(fields != null && fields.length > 0)
			       {				  
				     deviceGroupId = fields[0];
					 priority = fields[1];
					%>
					<asset:load name="currentDeviceGroup" type="DeviceGroup" objectid='<%=deviceGroupId%>' editable="true" />
					<asset:set name="currentDeviceGroup" field="priority" value='<%=priority%>' />
					<asset:save name="currentDeviceGroup" />
					<%
				   }
				}				
		
		if(i == groups.length && ics.GetErrno() == 0)
		{
			ics.RemoveVar("form");
			MobilityUtils.flushDeviceGroupCaches( ics );
			log.debug("********************** Device Groups re-prioritized successfully!!!!!");	
		}
		else
		{
			log.error("***********************Device Groups re-prioritization FAILED for DeviceGroup: "+deviceGroupId+" . Error no: "+ics.GetErrno()+" ***************");
		}
		%>
        <ics:callelement element="OpenMarket/Xcelerate/AssetType/DeviceGroup/AdminTreeNodes/DeviceGroupMgt/main"> 
		      <ics:argument name="tool" value="DeviceGroupMgt"/>
		      <ics:argument name="form" value="main"/>
		      <ics:argument name="reprioritized" value="success"/>
		</ics:callelement>
        <%
	}
	
	%>
	<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
	<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype") %>' >
		<ics:argument name="__TreeRefreshKeys__" value="Self:MobilityDeviceGroup"/>
	</ics:callelement>

	</ics:then>
</ics:if>


</cs:ftcs>