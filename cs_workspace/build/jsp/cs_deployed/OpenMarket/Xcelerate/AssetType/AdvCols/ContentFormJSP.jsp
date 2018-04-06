<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/AdvCols/ContentForm
--
--	Form for creating/editing  AdvCols
-- INPUT
--			ContentDetails: result of a scatter
-- OUTPUT
--
-- HISTORY 
   [2007-09-17 KG]
   * added XSS scripting fixes (adapted from 6.3 fixes); search for isCleanString
   * changed definitions of 'obj' to just forms[0] (not .elements[0])
   [2007-10-25 KG]
   * cleaned up code in findItem and removeItem functions.
   * removed possibility for an infinite loop in findItem (if key was not found)
   * [#16157] fixed tpyo in removeItem (lowercase r) function, which was causing
     all items before the selected item in the list to be removed, along with the
     selected item.
-->

<ics:if condition='<%="standard".equals(ics.GetVar("cs_environment"))%>'>
<ics:then>
	<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/EditFront" outstring="editBaseURL">
		<satellite:argument name="cs_environment" value='addref'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	</satellite:link>
</ics:then>
<ics:else>
	<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/EditFront" outstring="editBaseURL">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	</satellite:link>
</ics:else>
</ics:if>

<ics:callelement element="OpenMarket/Xcelerate/Scripts/FormatDate" />
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS" />

<asset:getassettype name='<%=ics.GetVar("assetname")%>' outname="at"/>
<assettype:get name="at" field="description" output="at:description"/>

<script type="text/javascript">
	var isEditMode=true;
	var isContributorMode = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
</script>

<script type="text/javascript">
var obj = document.forms[0];
function submitForm()
{
	saveListData();	
	return checkfields();
}

function SetCancelFlag () {
	if(confirm("<xlat:stream key="dvin/Common/CancelClicked" escape="true" encode="false"/>"))
	{
		obj.elements['upcommand'].value="cancel";
		obj.submit();
		return false;
	}
}

function getAssetName()
{
	return obj.elements['AdvCols:name'].value;
}

function checkfields()
{ 
	var nameVal = obj.elements['AdvCols:name'].value;
    if (dojo.trim(nameVal).length == 0)
	{
		alert('<xlat:stream key="dvin/Assetmaker/SpecifyUniqueName" escape="true" encode="false"/>');
		obj.elements['AdvCols:name'].focus();
		return false;
	}
	
	var isclean = isCleanString(obj.elements['AdvCols:name'].value);
	if (!isclean) {
		alert('<xlat:stream key="dvin/FlexibleAssets/Attributes/ApostropheNotAllowed" escape="true" encode="false"/>');
		obj.elements['AdvCols:name'].focus();
		return false;
	}
	
	obj.elements['saverule'].value="true";	

	if(!checkStartEndDateValidity()){return false;}
	obj.submit();
	return false;
}
</script>

<input type="hidden" name="AdvColsNextStep" value=""/>
<input type="hidden" name="saverule" value="false"/>
<input type="hidden" name="upcommand" value="submit"/>

<ics:setvar name="useSelAll" value="false"/>
<ics:setvar name="AdvColsNextStep" value="ContentFormName"/>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

<!-- form buttons -->
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBar">
	<ics:argument name="doNotShowSaveButton" value="false"/>
	<ics:argument name="submitScript" value="submitForm"/>		
</ics:callelement>
	
<!-- Always gather what may have been posted from before, generate appropriate hiddens, etc. -->
<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/ContentFormSetVar"/>

<!-- Load data for this specific Recommendation and some general supporting material -->
<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/ContentFormLoadData"/>

<!-- Load Javascript to Render (and support Edit and Save) of the Recommendation data -->
<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/ContentFormJavascript"/>

<!-- Dispatch to the appropriate place for the actual form elements -->
<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/ContentForm1"/> 

</div>
</cs:ftcs>
