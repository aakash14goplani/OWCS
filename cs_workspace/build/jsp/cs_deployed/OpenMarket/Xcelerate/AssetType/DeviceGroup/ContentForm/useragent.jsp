<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/useragent
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
String fieldname=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");
%>
<script>
function isUserAgentEmpty()
{
var temp = dojo.string.trim( document.getElementById('criteria:useragent').value );
 return (new String(temp).length == 0);
}
function prepareUserAgentForSave()
{
	var field = document.getElementById('<%=fieldname%>');
	var value=dojo.byId('criteria:useragent').value;
	field.value=value;
}
</script>

<div name="criteriaSection" style="border : 1px solid #d9d7d3;border-radius: 4px;">
    <div >
      <p align="LEFT" style="padding-left: 8px;">
         <textarea id='criteria:useragent' style="resize:none; width:400px; height:57px; font-size: 12px; font-family: Tahoma, Verdana, Geneva, sans-serif; color : rgb(51,51,51); padding-left : 5px"><%=ics.GetVar("fieldvalue")%></textarea>
      </p>
  	
    </div>
    <div style="font-size: 11px; margin-bottom: 6px;align:left;margin-left:8px; line-height:15px;"><span>*</span> <xlat:stream key="dvin/UI/MobilitySolution/UserAgent/instruction" /></div>
	
</div>
<input type="hidden" id='<%=fieldname%>' name='<%=fieldname%>'>
</cs:ftcs>