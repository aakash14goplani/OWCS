<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/devicenamelist
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

<xlat:lookup key="dvin/UI/MobilitySolution/DeviceName/enterNewDeviceName" varname="enterNewDeviceName" />
<xlat:lookup key="dvin/UI/MobilitySolution/DeviceName/addDeviceName" varname="addDeviceName" />
<xlat:lookup key="dvin/UI/MobilitySolution/DeviceName/showDevices" varname="showDevices" />
<xlat:lookup key="dvin/UI/Deletethisitem" varname="deleteThisItem" />
 
<xlat:lookup key="dvin/AdminForms/ShowCriteria" varname="ShowCriteria" />
<xlat:lookup key="dvin/AdminForms/HideCriteria" varname="HideCriteria" />
<string:encode variable="fieldvalue" varname="fieldvalue"/>
<%
String filedname=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");
String defaultNameMsg = ics.GetVar("enterNewDeviceName");

String editMode = "editfront";
boolean isEdit = false;
String btnMsg = ics.GetVar("addDeviceName");
if(editMode.equalsIgnoreCase(ics.GetVar("updatetype"))){
isEdit = true;
btnMsg = ics.GetVar("showDevices");
}
%>
<script>
var DIV_CLOSED = 1, DIV_OPEN = 2, CRITERIA_DIV_CLOSED = 1,CRITERIA_DIV_OPEN = 2;
var DIV_STATUS = DIV_CLOSED;
var isLoaded = false,rowNum = 0,FIELD_SEPARATOR=";";

var criteriaSectionsStatus = CRITERIA_DIV_OPEN;
function showHideCriteriaSections()
{
    var sections = dojo.query('div[name="criteriaSection"]'); 
	
    var action = "", imagePath = '<%=ics.GetVar("cs_imagedir")%>'+'/graphics/common/icon/';
	var arrowUpImg = 'drop-down-arrow-up.png',arrowDownImg = 'drop-down-arrow-down.png';
   if(criteriaSectionsStatus == CRITERIA_DIV_OPEN)
	{
		action = "hidden";
		criteriaSectionsStatus = CRITERIA_DIV_CLOSED;	
		document.getElementById("criteriaDividerId").src=imagePath + arrowDownImg;
		document.getElementById("criteriaDividerId").title = '<%=ics.GetVar("ShowCriteria")%>';
		document.getElementById("criteriaDividerId").alt = '<%=ics.GetVar("ShowCriteria")%>';
	}
    else if(criteriaSectionsStatus == CRITERIA_DIV_CLOSED)
	{
		action = "visible";
		criteriaSectionsStatus = CRITERIA_DIV_OPEN;	
		document.getElementById("criteriaDividerId").src=imagePath + arrowUpImg;
		document.getElementById("criteriaDividerId").title = '<%=ics.GetVar("HideCriteria")%>';
		document.getElementById("criteriaDividerId").alt = '<%=ics.GetVar("HideCriteria")%>';
		
	}
    if(sections && sections.length > 0)
	{
		for(var i = 0;i<sections.length;i++)
		{
		 if(sections[i])
		 sections[i].style.visibility=action;
		}
	}
}

function loadList() 
{
if(isLoaded == false)
  {
    createList();
    isLoaded = true;
   }
}


function createList()
{
var list  = new String( '<%=ics.GetVar("fieldvalue")%>');
var deviceNames  = list.split(FIELD_SEPARATOR);

if(deviceNames)
{
	var deviceNameCount = deviceNames.length;
	//If list of Device Names are already present then no need to show the empty textbox.
	 if(deviceNameCount > 1)
		deviceNameCount--; 
   for(var i = 0;i<deviceNameCount;i++)
		addRow(deviceNames[i]);
}
if(shouldDisableCriteriaFields() == true)
	showHideCriteriaSections();
}

function getDeleteIcon(rowid)
{
var _rowid = '"'+rowid+'"';
var removeanchor =  document.createElement('a');
removeanchor.setAttribute('href','javascript:deleteRow('+_rowid+')');
removeanchor.setAttribute("name","deleteRowIcon");
var icon = document.createElement("img");
icon.width="14";
icon.vspace = "5";
icon.align="top";
icon.height="14";
icon.border="0";
icon.alt='<%=ics.GetVar("deleteThisItem")%>';
icon.src='<%=request.getContextPath()%>'+'/Xcelerate/graphics/common/icon/iconDeleteContent.gif';
removeanchor.appendChild(icon);

return removeanchor;
}

function getAddRowIcon()
{	
var removeanchor =  document.createElement('a');
removeanchor.setAttribute('href','javascript:addRow()');
removeanchor.setAttribute('id','addRowId');
var icon = document.createElement("img");
icon.width="14";
icon.vspace = "5";
icon.align="top";
icon.height="14";
icon.border="0";
icon.style.paddingLeft="3px";
icon.alt='<%=ics.GetVar("addDeviceName")%>';
icon.src='<%=request.getContextPath()%>'+'/Xcelerate/graphics/common/icon/AddtoOnDemandQ.gif';
removeanchor.appendChild(icon);
return removeanchor;
}


function deviceNameLooseFocus(boxId)
{
if(isLoaded && boxId && document.getElementById(boxId) && document.getElementById(boxId).value == '')
{
	//Show the default text in grey
	document.getElementById(boxId).style.color = "rgb(170,170,170)";
	document.getElementById(boxId).value = '<%=defaultNameMsg%>';
}
}

function clearBox(boxId)
{
if(boxId && document.getElementById(boxId) && document.getElementById(boxId).value == '<%=defaultNameMsg%>')
{
	document.getElementById(boxId).style.color = "rgb(51,51,51)";
	document.getElementById(boxId).value = "";
}
}

function addRow(deviceName)
{
var list = document.getElementById("list");
var lastRow = document.getElementById("row"+rowNum);
rowNum++;
var newlistItem = document.createElement("div");
newlistItem.id="row"+rowNum;
newlistItem.style.marginBottom = "5px";
var inputTextBox = document.createElement("input");
inputTextBox.setAttribute("name","devicename");
inputTextBox.setAttribute("id","input"+rowNum);
inputTextBox.setAttribute("onClick",'clearBox('+"'"+inputTextBox.id+"'"+'),criteriaFieldEnableDisable()'); 
inputTextBox.setAttribute("onKeyDown",'clearBox('+"'"+inputTextBox.id+"'"+'),criteriaFieldEnableDisable()');
inputTextBox.setAttribute("onKeyUp",'criteriaFieldEnableDisable()');
inputTextBox.setAttribute("onBlur",'deviceNameLooseFocus('+"'"+inputTextBox.id+"'"+'),criteriaFieldEnableDisable()');
inputTextBox.className = "defaultFormStyle";
inputTextBox.style.fontSize = "12px";
inputTextBox.style.height = "18px";
inputTextBox.style.color = "rgb(51,51,51)";
inputTextBox.style.fontFamily = "Tahoma, Verdana, Geneva, sans-serif";
inputTextBox.style.paddingLeft = "3px";
if(deviceName)
    inputTextBox.setAttribute("value",deviceName);
else
{
	//Show the default text in grey
	inputTextBox.style.color = "rgb(170,170,170)";
	inputTextBox.setAttribute("value",'<%=defaultNameMsg%>');
}
newlistItem.appendChild(inputTextBox);
var delIcon = getDeleteIcon("row"+rowNum);
newlistItem.appendChild(delIcon);

var listOfDeviceNames  = new String( '<%=ics.GetVar("fieldvalue")%>');
var deviceNamesArr  = listOfDeviceNames.split(FIELD_SEPARATOR);

//If list of Device Names are present then the last row will have the Add Row icon, otherwise the last empty field will contain the Add Row icon.
if(!deviceName || rowNum>=deviceNamesArr.length-1)
{
var addElement = getAddRowIcon();
newlistItem.appendChild(addElement);
 
var addIcon = document.getElementById("addRowId");
if(lastRow && addIcon)
lastRow.removeChild(addIcon);
}

list.appendChild(newlistItem);

//Remove the delete icon if there is only one device name input box is present 
var deleteRowIcons = document.getElementsByName("deleteRowIcon");

if(deleteRowIcons && deleteRowIcons.length == 1)
{
	deleteRowIcons[0].style.display = 'none';
}
else
{
	deleteRowIcons[0].style.display = '';
}
}

function deleteRow(rowid)
{
//if this is only input box, don't delete it
var inputs = document.getElementsByName("devicename");
if(inputs && inputs.length == 1)
return;

var list = document.getElementById("list");
var currentItem = document.getElementById(rowid);
list.removeChild(currentItem);

//after deleting it, put the add row link to previous input box
var addIcon = getAddRowIcon();

if(!document.getElementById("addRowId")){
for(var i = rowNum;i>=0;i--)
if(document.getElementById("row"+i))
{
var previousItem = document.getElementById("row"+i);
previousItem.appendChild(addIcon);
rowNum = i;								//rownum stores the no. of the last row.
break;
}

}
criteriaFieldEnableDisable();
//Remove the delete icon if there is only one device name input box is present 
var deleteRowIcons = document.getElementsByName("deleteRowIcon");
if(deleteRowIcons && deleteRowIcons.length == 1)
{
	deleteRowIcons[0].style.display = 'none';
}
}

function prepareDeviceNamesForSave()
{
var field = document.getElementById('<%=filedname%>');
var deviceList = document.getElementById("list");
var devicenames = document.getElementsByName("devicename");
if(devicenames)
{
var names="";
for(var i = 0;i<devicenames.length;i++)
{

if(devicenames[i] && devicenames[i].value != '<%=defaultNameMsg%>' && devicenames[i].value.length>0)
names=names+devicenames[i].value+FIELD_SEPARATOR;
}

field.value=names;
}

}

</script>

<div style="border : 1px solid #d9d7d3; border-radius: 4px; padding:8px;">
    <div class="panelcontent"  style="align: left;" >
		<div id="devicelistid">
			<div id="list" style="padding-top:10px;"></div>
		</div>
	</div>
	<div style="font-size: 11px; align:left; padding-top:10px; line-height:15px;"><span>*</span> <xlat:stream key="dvin/UI/MobilitySolution/DeviceName/instruction" /></div>
</div>
<input type="hidden" id='<%=filedname%>' name='<%=filedname%>'>

</cs:ftcs>