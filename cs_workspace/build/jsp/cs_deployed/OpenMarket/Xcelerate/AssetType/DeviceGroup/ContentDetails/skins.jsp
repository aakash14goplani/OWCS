<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentDetails/skins
// Get the skin associated with the devicegroups
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
<!-- Get a list of skins whose ownerid  = 'id' of curent device group and whose enabled='Y' -->	
<asset:list type="Device" list="skinlist" order="name" excludevoided="true" field1="enabled" value1="Y" field2="ownerid" value2='<%=ics.GetVar("id")%>' /> 
<ics:if condition='<%=ics.GetErrno() == 0%>'>
<ics:then>
  <ics:listloop listname="skinlist">
           <ics:listget listname="skinlist" fieldname="name" output="skinname" />
			<string:stream value='<%=ics.GetVar("skinname")%>' />
			<br/>
   </ics:listloop>
</ics:then>
<ics:else>
<xlat:stream key="dvin/UI/MobilitySolution/NoSkinAssociated" />
<ics:setvar name="noskins" value="true" />
</ics:else>
</ics:if>

			

</cs:ftcs>