<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%// 
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/customfilters
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
<%@ page import="COM.FutureTense.Util.ftMessage,COM.FutureTense.Util.ftUtil,COM.FutureTense.Mobility.Device.FilterEditor,java.util.List"%>
 
<cs:ftcs>
<script>
dojo.require("fw.ui.dijit.FlexibleDialog");
var filterNames = new Array();
var count = 0;
</script>
<style>
.fw .content.customFilterContent
{
	white-space: pre-wrap;
}
</style>

<xlat:lookup key="dvin/UI/MobilitySolution/Filters/showFilterXMLErrMsg" varname="showFilterXMLErrMsg" />
<%
String fieldid=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");

if(ics.GetVar("fieldvalue") != null)
{
  FilterEditor filterEditor = new FilterEditor(ics.GetVar("fieldvalue"));
  List filterList = filterEditor.getSortedFilterNames(ics.GetVar("fieldvalue"));
  if(filterList != null && filterList.size() > 0)
  {
    for(int i = 0;i<filterList.size(); i++)
     {
       String name = (String)filterList.get(i);
       if(!ftUtil.emptyString(name))
        {
         %>
			<script>
			filterNames[count++] = '<%=name%>';
			</script>
		  <%
		}
	  }
  }
}
%>

<script>
function showFilterXML()
{
var field = document.getElementById('filterXML');

if(!field.value || field.value.length == 0)
  {
   alert('<%=ics.GetVar("showFilterXMLErrMsg")%>');
   return;
   }  
 
 var textNode = document.createTextNode(field.value);
 var flexDialog = new fw.ui.dijit.FlexibleDialog({ showCloseButton: true });	
 flexDialog.set('content', textNode);
 flexDialog.set('height','400');
 flexDialog.startup();
 dojo.addClass(flexDialog.containerNode, "customFilterContent");
 flexDialog.show(); 
}

</script>

<div name="criteriaSection" class="capabilities-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding-top: 5px;padding-bottom: 5px;padding-left: 10px;padding-right: 10px;">
<%
if((ics.GetVar("fieldvalue") == null) || ftUtil.emptyString(ics.GetVar("fieldvalue")))
{
%>
	<span class="disabledText"><xlat:stream key="UI/Forms/NotApplicable"/></span>
<%
}
else
{
%>
<table>
<tr>
	<td>
	<%
	FilterEditor filterEditor = new FilterEditor(ics.GetVar("fieldvalue"));
		List filterList = filterEditor.getSortedFilterNames(ics.GetVar("fieldvalue"));
		if(filterList != null)
		{
				boolean isDeviceNamesExists = Utilities.goodString( ics.GetVar("ContentDetails:devicenamelist"));
				for(int i = 0;i<filterList.size(); i++)
				{
					String name = (String)filterList.get(i);
					if(!ftUtil.emptyString(name))
					{
						if(isDeviceNamesExists)
							out.write("<span class='disabledText'>");
						out.write(name);
						if(isDeviceNamesExists)
							out.write("</span>");
						out.write("<br>");
					}
				}
		}
		%>
	<xlat:lookup key="dvin/UI/MobilitySolution/Filters/showFilterXML" varname="showFilterXML" />
	<input type="hidden" name='<%=fieldid%>' id='<%=fieldid%>' value=''  />
	<input type="hidden" name='filterXML' id='filterXML' value='<%=ics.GetVar("fieldvalue")%>' />
	<A href='javascript:showFilterXML()'><%=ics.GetVar("showFilterXML")%></A> 
	</td>

	<td> 	
	
	 
	</td>
	  
</tr>
</table>
<%}%>


</div>

</cs:ftcs>