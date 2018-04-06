<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<%@ page import="com.openmarket.gator.nvobject.*"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>

<cs:ftcs>
	<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
	<xlat:lookup key="UI/Forms/Marketing" varname="tabMarketing"/>
	<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

	<assettype:load name='type' type='<%=ics.GetVar("AssetType")%>'/>
	<assettype:scatter name='type' prefix='AssetTypeObj'/>

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
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
		
	<!-- Segment page title with asset name -->

	  <ics:if condition='<%=!(ics.GetVar("updatetype")!=null && ics.GetVar("updatetype").equals("setformdefaults"))%>'>
      <ics:then>
          <td>
	          <span class="title-text"><string:stream variable="AssetTypeObj:description"/>&nbsp;:</span>&nbsp;
    	      <span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
          </td>
      </ics:then>
      <ics:else>
          <ics:if condition='<%=ics.GetVar("ContentDetails:name")!=null && ics.GetVar("ContentDetails:name").equals("")%>'>
          <ics:then>
              <td><span class="title-text"><string:stream variable="AssetTypeObj:description"/></span></td>
          </ics:then>
          <ics:else>
              <td><span class="title-text"><string:stream variable="AssetTypeObj:description"/>&nbsp;:</span>&nbsp;
              <span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
          </ics:else>
          </ics:if>
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
					<ics:argument name="Prefix" value="Segments"/>
				</ics:callelement>

				<!--Call start date and end date for site preview-->
	         	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/AssetTypeStartEndDate">
					<ics:argument name="startDateFieldName" value='Segments:startdate' />
					<ics:argument name="endDateFieldName"  value='Segments:enddate'/>
				</ics:callelement>
				<!--End site preview dates -->

			</table>
		</td>
	</tr>

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
	<tr>
		<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
	</tr>

	</table>
	</div>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabDetail")%>">
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">

    <td><span class="title-text"><xlat:stream key="dvin/AT/Segments/FilteringCriteria"/></span>
    	<span class="segFloatRight">
    	<a class="segToolsOn" style="cursor:pointer" id="segToolsToggle" onclick="segToolsToggle()"><xlat:stream key="dvin/AT/Segments/HideTools"/></a></span>
    </td>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="Yes"/>
	</ics:callelement>
	
	<tr><td>
		<div id="ruleSetDiv" class="segRuleSet">Rendered Ruleset Goes Here!</div>
		<input type="hidden" name="SegRuleSetMapHint" value="" />
	</td></tr>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
	<tr>
		<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
	</tr>
		
	</table>
	</div>

</div>
</div>
</div>
</cs:ftcs>
