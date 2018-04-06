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
<xlat:lookup key="dvin/UI/MobilitySolution/DeviceName/enterNewDeviceName" varname="enterNewDeviceName" />
<%
String fieldid=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");
String editMode = "editfront";
boolean isEdit = false;

String defaultNameMsg = ics.GetVar("enterNewDeviceName");

if(editMode.equalsIgnoreCase(ics.GetVar("updatetype")))
isEdit = true;

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
function isCustomFiltersEmpty()
{
	if(<%=isEdit%> == true)
	{
	  var uploaderTopNode = dojo.query('div[name="DeviceGroup:customfiltersNode_div"]')[0],
	  uploaderInputWidget = dijit.findWidgets(uploaderTopNode)[0];
	  
	  var existingXML = document.getElementById('filterXML');
	  return ( ( !uploaderInputWidget || !uploaderInputWidget.get('value') || new String(uploaderInputWidget.get('value')).length == 0 ) && (!existingXML || !existingXML.value || (new String(existingXML.value).length == 0) ) );
	}
	else
	{	
	  var uploaderTopNode = dojo.query('div[name="DeviceGroup:customfiltersNode_div"]')[0],
	  uploaderInputWidget = dijit.findWidgets(uploaderTopNode)[0];
	  return (!uploaderInputWidget || !uploaderInputWidget.get('value') || new String(uploaderInputWidget.get('value')).length == 0 );
	}

}
function criteriaFieldEnableDisable()
{
if(shouldDisableCriteriaFields() == true)
     doEnableDisableCriteriaFields(true);
	 else
 doEnableDisableCriteriaFields(false);
	 
}
 
function shouldDisableCriteriaFields()
{
var devicenames = dojo.query('input[name="devicename"]');
		if(devicenames && devicenames.length > 0)
		{
			var names="";
			for(var i = 0;i<devicenames.length;i++)
			{
				if(devicenames[i] && devicenames[i].value != '<%=defaultNameMsg%>' && devicenames[i].value.length>0)
				names=names+devicenames[i].value+FIELD_SEPARATOR;
			}
			if(names && names != "" && names.length > 0)
			  {
			   return true;
			  }
        }
return false;
}
function doEnableDisableCriteriaFields(disable)
{
  	var criteriaFields = new Array("criteria:useragent","minwidth","maxwidth","minheight","maxheight","filterListId","touchId","JSSupportId","dualOId","isTabletId","flashSupportId","DeviceGroup:customfilters_ID");
  	for(var i = 0 ; i< criteriaFields.length; i++){
  		if(dijit.byId(criteriaFields[i])){
  			dijit.byId(criteriaFields[i]).set('disabled', disable == true);
  		} else if(document.getElementById(criteriaFields[i])){
  			if(disable == true)
  				document.getElementById(criteriaFields[i]).setAttribute("disabled", true);
  			else
  				document.getElementById(criteriaFields[i]).removeAttribute("disabled");
  		}
  	}
}

function prepareCustomFiltersForSave()
{
var field = document.getElementById('<%=fieldid%>');
var filterXML = document.getElementById('filterXML');
if(field && filterXML)
   {
	   if(filterXML.value && filterXML.value.length > 0)
		{
		field.value=filterXML.value;
		}
else
	{
		if(field.value && field.value.length > 0)
		{
		//do nothing
		}
	}
  }
}

function removeFilter()
{
if(shouldDisableCriteriaFields())
return;

var xmlHiddenField = document.getElementById('filterXML');
	if(xmlHiddenField)
     {
      //confirmation dialogue, 
      xmlHiddenField.value=""
	  }

var selectBox = document.getElementById("filterListId");
if(selectBox)
selectBox.innerHTML="";

}

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

function loadSortedFilterNames()
{
  if(filterNames.length > 0)
    {
	var selectBox = document.getElementById("filterListId");
     for(var i = 0;i<filterNames.length;i++)
       {
         var option = document.createElement('option');
		 option.text = filterNames[i];
		 option.value = filterNames[i];
		 selectBox.options[i]=option;
       }
     if(document.getElementById("filterListDiv"))
     	document.getElementById("filterListDiv").setAttribute("class", "scrollable");
    }
}
</script>


<div name="criteriaSection" >
<%
if(!isEdit || (ics.GetVar("fieldvalue") == null) || ftUtil.emptyString(ics.GetVar("fieldvalue")))
{
%>
						<ics:callelement element="OpenMarket/AssetMaker/BuildEditUpload" >
							<ics:argument name="fieldname" value='<%=ics.GetVar("fieldname")%>' />
							<ics:argument name="fieldvalue" value='' />
						</ics:callelement>
<%
}
else
{
%>
<table align="left">
<tr>
	<td>
	<p align="left">
	<input type="hidden" name='<%=fieldid%>' id='<%=fieldid%>' value=''  />
	<input type="hidden" name='filterXML' id='filterXML' value='<%=ics.GetVar("fieldvalue")%>' />
	
	<ics:callelement element="OpenMarket/AssetMaker/BuildEditUpload" >
	<ics:argument name="fieldname" value='<%=ics.GetVar("fieldname")%>' />
	<ics:argument name="fieldvalue" value='' />
	</ics:callelement>
	<br/>
	<div id="filterListDiv" style="width: 268px">
	<select id='filterListId' size="9" style="width: 268px">
	</select>
	</div>
	
	<br/>
	<xlat:lookup key="dvin/UI/MobilitySolution/Filters/showFilterXML" varname="showFilterXML" />
	<xlat:lookup key="dvin/UI/MobilitySolution/Filters/removeFilterXML" varname="removeFilterXML" />
	<A href='javascript:showFilterXML()'><%=ics.GetVar("showFilterXML")%></A> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<div  dojoType='fw.ui.dijit.Button' title='<%=ics.GetVar("removeFilterXML")%>' label= '<%=ics.GetVar("removeFilterXML")%>' onClick="javascript:removeFilter()" ></div>
		
	</p>
	</td>

	<td> 	
	
	 
	</td>
	  
</tr>
</table>
<%}%>


</div>

</cs:ftcs>