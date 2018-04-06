<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<cs:ftcs>

	<!-- OpenMarket/Xcelerate/AssetType/AdvCols/ContentForm1
	-
	- INPUT
	-
	- OUTPUT
	-
	-->
	
<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
<xlat:lookup key="UI/Forms/Options" varname="tabOptions"/>
<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

<!--If Marketing Studio (CS Engage) is not installed, then AdvColMode is List-->
<ics:callelement element="OpenMarket/Gator/Util/HasMarketStudio"/>
	

<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">

	<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
		<ics:argument name="tabContent" value='<%=ics.GetVar("tabContent")%>' />
		<ics:argument name="elementType" value="JSP" />
	</ics:callelement>

	<div dojoType="dijit.layout.ContentPane" id="tabContent" title="<%=ics.GetVar("tabContent")%>">

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


	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonName"/>
	</table>

	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" class="width-inner-100">
			
					<ics:if condition='<%="setformdefaults".equals(ics.GetVar("updatetype"))%>'>
						<ics:then>
							<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
								<ics:argument name="SpaceAbove" value="No"/>
							</ics:callelement>
						</ics:then>
					</ics:if>

					<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/CheckforQuotes">
						<ics:argument name="Prefix" value="AdvCols"/>
					</ics:callelement>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/UI/Subtype"/>:</td>
						<td></td>
						<td class="form-inset">
							<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/MakeSubtypeList">
								<ics:argument name="Prefix" value="AdvCols"/>
								<ics:argument name="fieldvalue" value='<%=ics.GetVar("ContentDetails:subtype")%>'/>
								<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
							</ics:callelement>
						</td>
					</tr>

					<xlat:lookup key="dvin/UI/Template" varname="label"/>
					
					<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowTemplatesIfAny">
						<ics:argument name="Prefix" value="AdvCols"/>
						<ics:argument name="label"  value='<%=ics.GetVar("label") + ":"%>'/>
						<ics:argument name="showDummy" value="true"/>						
					</ics:callelement>		
					
	                <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>              

					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/Mode"/>:</td>
						<td></td>
						<td class="form-inset">
							<div id="modePickerDiv" class="recModePicker">Mode Picker Goes Here!</div>
						</td>
					</tr>
					
					<!--Call start date and end date for site preview-->
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/AssetTypeStartEndDate">
						<ics:argument name="startDateFieldName" value="AdvCols:startdate"/>
						<ics:argument name="endDateFieldName"  value="AdvCols:enddate"/>
					</ics:callelement>
					<!--End site preview dates -->
					
					<ics:callelement element="OpenMarket/Xcelerate/AssetType/Dimension/ShowDimensionForm">
                        <ics:argument name="dimFormPrefix" value="AdvCols"/>
                        <ics:argument name="dimVarPrefix" value="ContentDetails"/>
                    </ics:callelement>

					<ics:if condition='<%=!"setformdefaults".equals(ics.GetVar("updatetype"))%>'>
						<ics:then>
							<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonCreatedModified"/>
						</ics:then>
					</ics:if>				
					
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
					
				</table>
			</td>
		</tr>
	</table>
	</div>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabOptions")%>">
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonName"/>
	</table>
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">
		
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/EditOptionsTab">
			<ics:argument name="DisplayOnly" value="false"/>
		</ics:callelement>
		
	</table>
	</div>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabDetail")%>">

	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonName"/>
	</table>
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">
	
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/EditDetailsTab">
		<ics:argument name="DisplayOnly" value="false"/>
	</ics:callelement>
		
	</table>
	
	<div style="display:none" id="listSaveDiv">Saved listData Goes Here!</div>
	
	</div>

</div>
</div>		
</cs:ftcs>
	

