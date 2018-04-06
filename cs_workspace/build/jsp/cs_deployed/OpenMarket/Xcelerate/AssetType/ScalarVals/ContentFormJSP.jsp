<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>

<cs:ftcs>
<!-- OpenMarket/Xcelerate/AssetType/ScalarVals/ContentForm
--
-	Form for creating/editing  ScalarVals
-- INPUT
--			ContentDetails: result of a scatter
-- OUTPUT
--
-- HISTORY 
-->

<ics:callelement element="OpenMarket/Xcelerate/Scripts/FormatDate" />
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS" />

<asset:getassettype name='<%=ics.GetVar("assetname")%>' outname="at"/>
<assettype:get name="at" field="description" output="at:description"/>

<ics:callelement element="OpenMarket/Gator/Scripts/ValidateFieldsJSP"/>

<!-- Load Javascript to Render (and support Edit and Save of) the ScalarVals data -->
<ics:callelement element="OpenMarket/Xcelerate/AssetType/ScalarVals/ContentFormJavascript"/>

<assettype:load name='type' type='<%=ics.GetVar("AssetType")%>'/>
<assettype:scatter name='type' prefix='AssetTypeObj'/>

<script type="text/javascript">
var obj = document.forms[0];

function submitForm()
{
	svCaptureData();	
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
	return obj.elements['ScalarVals:name'].value;
}

function checkfields()
{
	var nameVal = obj.elements['ScalarVals:name'].value;
    if (dojo.trim(nameVal).length == 0)
	{   
		alert('<xlat:stream key="dvin/Assetmaker/SpecifyUniqueName" escape="true" encode="false"/>');
		obj.elements['ScalarVals:name'].focus();
		return false;
	}
	
	if (!isCleanString(obj.elements['ScalarVals:name'].value, '<">\'', true)) 
	{
		alert('<xlat:stream key="dvin/AT/Common/Apostrophenotallowedinname" escape="true" encode="false"/>');
		obj.elements['ScalarVals:name'].focus();
		return false;
	}

	if (obj.elements['ScalarVals:description'].value=="")
	{                                                    
		alert('<xlat:stream key="dvin/AT/HFields/MustspecDESCRIPTION" escape="true" encode="false"/>');
		obj.elements['ScalarVals:description'].focus();
		return false;
	}
	
	if (!isCleanString(obj.elements['ScalarVals:description'].value, '\'', true)) 
	{ 
		alert('<xlat:stream key="dvin/AT/HVals/ApostropheNotAllowedinDESCRIPTION" escape="true" encode="false"/>');
  		obj.elements['ScalarVals:description'].focus();
		return false;
	}
	
	if (obj.elements['ScalarVals:category'].value=="")
	{                                                    
		alert('<xlat:stream key="dvin/AT/HVals/MustspecCATEGORY" escape="true" encode="false"/>');
		obj.elements['ScalarVals:category'].focus();
		return false;
	}

	if (!isCleanString(obj.elements['ScalarVals:category'].value, '\'', true)) 
  	{ 
		obj.elements['ScalarVals:category'].focus();
		alert('<xlat:stream key="dvin/AT/HVals/ApostropheNotAllowedinCATEGORY" escape="true" encode="false"/>');
		return false;
	}
	
	if(!checkStartEndDateValidity()) 
		return false;
	
	if (!checkAttributeFields("ScalarVals:type",	"ScalarVals:constrainttype", "ScalarVals:length", 
							 "ScalarVals:lowerrange", "ScalarVals:upperrange", 
							 "ScalarVals:nullallowed", "ScalarVals:defaultval", 
							 "ScalarVals:sMyEnumValues"))
		return false;
	
	obj.submit();	// Do the Save
	
	return false;	// I don't understand why we return a value from this function.
					// I especially don't see why we return false here... 
					// but everyone does it...
}

var thisPage = '<%=ics.GetVar("ThisPage")%>'; 

</script>

	<input type="hidden" name="upcommand" value="submit"/>

	<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
	<xlat:lookup key="UI/Forms/Marketing" varname="tabMarketing"/>
	<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

<% 
	String spacerImagePath = ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"; 
%>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

	<!-- form buttons -->
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBar">
		<ics:argument name="doNotShowSaveButton" value="false"/>
		<ics:argument name="submitScript" value="submitForm"/>		
	</ics:callelement>

<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">

	<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
		<ics:argument name="tabContent" value='<%=ics.GetVar("tabContent")%>' />
		<ics:argument name="elementType" value="JSP" />
	</ics:callelement>

	<div dojoType="dijit.layout.ContentPane" id ="tabContent" title="<%=ics.GetVar("tabContent")%>">

	<script>
			// based on OpenMarket/Gator/Scripts/SetDirtyState
			dojo.addOnLoad(function(){
				
			var isUcForm = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
			var connectChangeEvents = function(){
				var widgets = dijit.findWidgets(dojo.byId("tabContent"));				
				dojo.forEach(widgets, function(eachWidget){
					var handleChange = dojo.connect(eachWidget, "onChange", function(){					
						setTabDirty();
						dojo.disconnect(handleChange);
					});
				})		
			};
			if(isUcForm) {
				setTimeout(function(){connectChangeEvents();}, 0);
			}	
		});
	</script>

	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
		
	<!-- Page title with asset name -->

    <ics:if condition='<%=ics.GetVar("ContentDetails:name")==null || ics.GetVar("ContentDetails:name").equals("")%>'>
    <ics:then>
        <td><span class="title-text"><string:stream variable="AssetTypeObj:description"/></span></td>
    </ics:then>
    <ics:else>
        <td><span class="title-text"><string:stream variable="AssetTypeObj:description"/>&nbsp;:</span>&nbsp;
        <span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
    </ics:else>
    </ics:if>
		
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>

	<!-- Segment  inspection form -->
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">

				<ics:if condition='<%="setformdefaults".equals(ics.GetVar("updatetype"))%>'>
					<ics:then>
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
							<ics:argument name="SpaceAbove" value="No"/>
						</ics:callelement>
					</ics:then>
				</ics:if>

				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/CheckforQuotes">
					<ics:argument name="Prefix" value="ScalarVals"/>
					<ics:argument name="DesReq" value="yes"/>					
				</ics:callelement>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
				<tr>
					<td class="form-label-text"><span class="alert-color">*</span><xlat:stream key="dvin/UI/Admin/Category"/>:</td>
					<td></td>
					<td class="form-inset">
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" value="ScalarVals:category"/>
							<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:category")%>'/>
							<ics:argument name="inputSize" value="32"/>
							<ics:argument name="inputMaxlength" value="128"/>
						</ics:callelement>
	 				</td>
				</tr>

				<!--Call start date and end date for site preview-->
	         	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/AssetTypeStartEndDate">
					<ics:argument name="startDateFieldName" value='ScalarVals:startdate' />
					<ics:argument name="endDateFieldName"  value='ScalarVals:enddate'/>
				</ics:callelement>
				<!--End site preview dates -->

			</table>
		</td>
	</tr>
	</table>
	</div>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabDetail")%>">
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">

    <ics:if condition='<%=ics.GetVar("ContentDetails:name")==null || ics.GetVar("ContentDetails:name").equals("")%>'>
    <ics:then>
        <td><span class="title-text"><string:stream variable="AssetTypeObj:description"/></span></td>
	</ics:then>
    <ics:else>
    	<td><span class="title-text"><string:stream variable="AssetTypeObj:description"/>&nbsp;:</span>&nbsp;
        <span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
    </ics:else>
    </ics:if>

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>

	<!-- Detail form -->
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>

				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/Common/Type"/>:</td>
					<td></td>
					<td class="form-inset">
						<!--Get the localized names of the types-->
						<xlat:lookup key="dvin/AT/Common/Type-int" varname="_Type_int"/>
						<xlat:lookup key="dvin/AT/Common/Type-string" varname="_Type_string"/>
						<xlat:lookup key="dvin/AT/Common/Type-boolean" varname="_Type_boolean"/>
						<xlat:lookup key="dvin/AT/Common/Type-short" varname="_Type_short"/>
						<xlat:lookup key="dvin/AT/Common/Type-long" varname="_Type_long"/>
						<xlat:lookup key="dvin/AT/Common/Type-double" varname="_Type_double"/>
						<xlat:lookup key="dvin/AT/Common/Type-timestamp" varname="_Type_timestamp"/>
						<xlat:lookup key="dvin/AT/Common/Type-blob" varname="_Type_blob"/>
						<xlat:lookup key="dvin/AT/Common/Type-money" varname="_Type_money"/>
						
						<select name="ScalarVals:type" size="1" dojoType="fw.dijit.UISimpleSelect" showErrors="false" clearButton="false" onChange="onChangeType">   
							<option value="int" <%="int".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_int")%></option>
							<option value="string" <%="string".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_string")%></option>
							<option value="boolean" <%="boolean".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_boolean")%></option>
							<option value="short" <%="short".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_short")%></option>
							<option value="long" <%="long".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_long")%></option>
							<option value="double" <%="double".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_double")%></option>
							<option value="timestamp" <%="timestamp".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_timestamp")%></option>
							<option value="blob" <%="blob".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_blob")%></option>
							<option value="money" <%="money".equals(ics.GetVar("ContentDetails:type"))? "selected" : ""%>><%=ics.GetVar("_Type_money")%></option>
						</select>
					</td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<!-- Length -->
				<tr class="svLengthGroup">
					<td class="form-label-text"><xlat:stream key="dvin/Common/Length"/>:</td>
					<td></td>
					<td class="form-inset">
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" value="ScalarVals:length"/>
							<ics:argument name="inputValue" value='<%=ics.GetVar("ContentDetails:length")%>'/>
							<ics:argument name="inputSize" value="4"/>
							<ics:argument name="inputMaxlength" value="4"/>
						</ics:callelement>
					</td>
				</tr>
				<tr class="svLengthGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<!-- Null Allowed -->
				<tr class="svNullAllowedGroup">
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Nullallowed"/>:</td>
					<td></td>
					<td class="form-inset">
						<select name="ScalarVals:nullallowed" size="1" dojoType="fw.dijit.UISimpleSelect" showErrors="false" clearButton="false" onChange="onChangeDefaultAllowed">
							<option value="T" <%="T".equals(ics.GetVar("ContentDetails:nullallowed")) ? "selected" : ""%>><xlat:stream key="dvin/AT/Common/true" /></option>
							<option value="F" <%="F".equals(ics.GetVar("ContentDetails:nullallowed")) ? "selected" : ""%>><xlat:stream key="dvin/AT/Common/false" /></option>
						</select>
					</td>
				</tr>
				<tr class="svNullAllowedGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<!--  Default Value Group-->
				<tr class="svDefaultValueGroup">
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Defaultnullnotallowed"/>:</td>
					<td></td>
					<td class="form-inset">
						<%					
							String svDefaultValue = ics.GetVar("ContentDetails:defaultval");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svDefaultValue = svDefaultValue.substring(0, Math.min(19, svDefaultValue.length()));	// truncate .s off end of date value
						%>
						<string:encode value='<%=svDefaultValue%>' varname='escDefaultValue'/> 
						<span class="svDefaultValueTextbox">
							<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
								<ics:argument name="inputName" value="ScalarVals:defaultval"/>
								<ics:argument name="inputValue" value='<%=ics.GetVar("escDefaultValue")%>'/>
								<ics:argument name="inputSize" value="32"/>
								<ics:argument name="inputMaxlength" value="255"/>
							</ics:callelement>
						</span>
						<span class="svDefaultValuePicker">
							<select size="1" dojoType="fw.dijit.UISimpleSelect" showErrors="false" clearButton="false" onChange="onChangeDefaultValuePicker">
								<option value="true" <%="true".equals(svDefaultValue) ? "selected" : "" %>><xlat:stream key="dvin/AT/Common/true" /></option>
								<option value="false" <%="false".equals(svDefaultValue) ? "selected" : "" %>><xlat:stream key="dvin/AT/Common/false" /></option>
							</select>
						</span>												
					</td>
				</tr>
				<tr class="svDefaultValueGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<!-- Constraint Type -->	
		    	<tr class="svConstraintTypeGroup">
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Constrainttype"/>:</td>
					<td></td>
					<td class="form-inset">
						<select name="ScalarVals:constrainttype" size="1" dojoType="fw.dijit.UISimpleSelect" showErrors="false" clearButton="false" onChange="onChangeConstraint">
							<option value="none" <%="none".equals(ics.GetVar("ContentDetails:constrainttype")) ? "selected" : ""%>><xlat:stream key="dvin/Common/lowercasenone" /></option>
							<option value="range" <%="range".equals(ics.GetVar("ContentDetails:constrainttype")) ? "selected" : ""%>><xlat:stream key="dvin/AT/SVals/range" /></option>
							<option value="enum" <%="enum".equals(ics.GetVar("ContentDetails:constrainttype")) ? "selected" : ""%>><xlat:stream key="dvin/AT/SVals/enumeration" /></option>
						</select>
					</td>
				</tr>
				<tr class="svConstraintTypeGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>

				<!--  Range -->				
				<tr class="svRangeGroup">
					<td></td>
					<td></td>
					<td class="form-label-inset"><xlat:stream key="dvin/AT/HFields/RangeConstraints"/> </td>
				</tr>
				<tr class="svRangeGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>

				<tr class="svRangeGroup" style="display:none">
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Lowerrangelimit"/>:</td>
					<td></td>
					<td class="form-inset">
						<%					
							String svLowerRange = ics.GetVar("ContentDetails:lowerrange");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svLowerRange = svLowerRange.substring(0, Math.min(19, svLowerRange.length()));	// truncate .s off end of date value
						%>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" value="ScalarVals:lowerrange"/>
							<ics:argument name="inputValue" value='<%=svLowerRange%>'/>
							<ics:argument name="inputSize" value="32"/>
							<ics:argument name="inputMaxlength" value="32"/>
						</ics:callelement>
 					</td>
				</tr>
				<tr class="svRangeGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<tr class="svRangeGroup">
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Upperrangelimit"/>:</td>
					<td></td>
					<td class="form-inset">
						<%					
							String svUpperRange = ics.GetVar("ContentDetails:upperrange");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svUpperRange = svUpperRange.substring(0, Math.min(19, svUpperRange.length()));	// truncate .s off end of date value
						%>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
							<ics:argument name="inputName" value="ScalarVals:upperrange"/>
							<ics:argument name="inputValue" value='<%=svUpperRange%>'/>
							<ics:argument name="inputSize" value="32"/>
							<ics:argument name="inputMaxlength" value="32"/>
						</ics:callelement>
 					</td>
				</tr>
				<tr class="svRangeGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<!--  Enumeration -->
				<tr class="svEnumGroup">
					<td></td>
					<td></td>
					<td class="form-label-inset"><xlat:stream key="dvin/AT/HFields/EnumerationConstraints"/></td>
				</tr>
				<tr class="svEnumGroup"><td colspan="3"><img height="20" width="1" src='<%=spacerImagePath%>'/></td></tr>
				
				<tr class="svEnumGroup">
					<td class="form-label-text">
						<xlat:stream key="dvin/AT/HFields/Addenumeratedvalue"/>: <xlat:lookup key="dvin/AT/HFields/Addthisenumeratedvalue" varname="_thisvalue_" escape="true"/>				
					</td>
					<td></td>
					<td class="form-inset">	
						<table><tr><td>
							<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
								<ics:argument name="inputName" value="ScalarVals:myEnumValue"/>
								<ics:argument name="inputValue" value=""/>
								<ics:argument name="inputSize" value="32"/>
								<ics:argument name="inputMaxlength" value="255"/>
							</ics:callelement>
						</td><td style="padding-top:4px;">
							<a href="javascript:void(0)" onclick="svAddEnumValue()" onmouseover="window.status='<%=ics.GetVar("_thisvalue_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Add"/></ics:callelement></a>
						</td></tr></table>
					</td>
				</tr>
				
				<tr class="svEnumGroup">
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Legalvalues"/>:</td>
					<td></td>
					<td class="form-inset">
						<table><tr><td>
							<select name="ScalarVals:sMyEnumValues" size="4" multiple="yes" width="32em">
							<%
							{
								IList theList = ics.GetList("ContentDetails:Values");
								int nVals = theList.numRows();
								
								for (int val=0; val < nVals; val++)
								{
									theList.moveTo(val+1);
									
									String svEnumValue = theList.getValue("value");
									if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
										svEnumValue = svEnumValue.substring(0, Math.min(19, svEnumValue.length()));	// truncate .s off end of date value
							
							%>
									<string:encode value='<%=svEnumValue%>' varname='escEnumValue'/> 
									<option value='<%=svEnumValue%>'><%=ics.GetVar("escEnumValue")%></option>
							<%
								}
							}
							%>
							</select>
							
						</td><td style="padding-top:4px;">
							<xlat:lookup key="dvin/AT/HFields/Removethisenumeratedvalue" varname="_thisvalue_" escape="true"/>
							<a href="javascript:void(0)"  onClick="svRemoveEnumValues()" onmouseover="window.status='<%=ics.GetVar("_thisvalue_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement></a>
						</td></tr></table>
					</td>
				</tr>
				<!-- End -->
				
			</table>
		</td>
	</tr>
	</table>

	<!-- Hidden ones -->
	<input type="hidden" name="ScalarVals:attrname"	value='<%=ics.GetVar("ContentDetails:attrname")%>'/>

	</div>

</div>
</div>
</div>
</cs:ftcs>
