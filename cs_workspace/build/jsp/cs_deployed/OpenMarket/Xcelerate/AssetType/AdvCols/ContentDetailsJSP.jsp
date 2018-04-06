<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/AdvCols/ContentDetails
--
-- INPUT
--
-- OUTPUT
--
-->
	<script type="text/javascript">
		var isEditMode=false;
		var isContributorMode = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
	</script>

	<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
	<xlat:lookup key="UI/Forms/Options" varname="tabOptions"/>	
	<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

	<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/ConvertHintString"/>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ActionsBar">
		<ics:argument name="Screen" value="Inspect"/>
	</ics:callelement>

<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">

	<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
		<ics:argument name="tabContent" value='<%=ics.GetVar("tabContent")%>' />
		<ics:argument name="elementType" value="JSP" />
	</ics:callelement>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabContent")%>"  selected="true">
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
	
		<!-- page title w/ asset name -->
		<!-- <assettype.list LIST="ThisAsset" FIELD1="assettype" VALUE1="Variables.AssetType"/> -->
		
		<tr>
			<td>
			<span class="title-text"><string:stream value="Recommendation"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
			</td>
		</tr>
		
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
			<ics:argument name="SpaceBelow" value="No"/>
		</ics:callelement>

		<!-- attribute inspection form -->
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" class="width-inner-100">
	
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:</td>
					<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
					<td class="form-inset"><string:stream variable="ContentDetails:name"/></td>
				</tr>
	
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Description"/>:</td>
					<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
					<td class="form-inset"><string:stream variable="ContentDetails:description"/></td>
				</tr>
				
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>

				<!--Need to put subtypes (Category) here-->
				
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/UI/Subtype"/>:</td>
					<td></td>
					<td class="form-inset">
						<ics:if condition='<%="".equals(ics.GetVar("ContentDetails:subtype"))%>'>
						<ics:then>
							<xlat:stream key="dvin/UI/Util/Standardnosubtype"/>
						</ics:then>
						<ics:else>
							<string:stream variable="ContentDetails:subtype"/>
						</ics:else>
						</ics:if>
					</td>
				</tr>
	
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowTemplateDetailsIfAny">
					<!--also depends on Variables.AssetType-->
					<ics:argument name='template' value='<%=ics.GetVar("ContentDetails:template")%>'/>
				</ics:callelement>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
	            <tr>
	        		<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/Mode"/>:</td>
					<td></td>
					<td class="form-inset">
		                <ics:if condition='<%=ics.GetVar("AdvColMode") == null%>'>
		            		<ics:then>
		            			<!--If the type is static lists then go ahead and set AdvColMode to List 
		            			otherwise this could be an old segment and we need to set it to Rec-->
				                <ics:if condition='<%=ics.GetVar("advcoltype") != null%>'>
		            				<ics:then>
				                        <ics:if condition='<%="assetlocal".equals(ics.GetVar("advcoltype")) || "sql".equals(ics.GetVar("advcoltype")) || "element".equals(ics.GetVar("advcoltype"))%>'>
		            						<ics:then>
		            							<xlat:stream key="dvin/AT/AdvCols/List"/>
		            						</ics:then>
		            						<ics:else>
		            							<xlat:stream key="dvin/AT/AdvCols/Rec"/>
		            						</ics:else>
		            					</ics:if>
		            				</ics:then>
		            				<ics:else>
		            					<!--List is the basic default-->
		            					<xlat:stream key="dvin/AT/AdvCols/List"/>
		            				</ics:else>
		            			</ics:if>
		            		</ics:then>
		                    <ics:else>
		                        <ics:if condition='<%="List".equals(ics.GetVar("AdvColMode"))%>'>
		                            <ics:then>
		                                <xlat:stream key="dvin/AT/AdvCols/List"/>
		                            </ics:then>
		                            <ics:else>
		                                <xlat:stream key="dvin/AT/AdvCols/Rec"/>
		                            </ics:else>
		                        </ics:if>
		                    </ics:else>
	            		</ics:if>
	            	</td>
				</tr>
			
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/InspectAssetStartEndDate"/>
														
		    	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Dimension/ShowDimensionDetails"/>
		    	
	            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<tr>
					<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowStatusCode"/>
				</tr>			  	
				
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
					<td></td>
					<td class="form-inset"><string:stream variable="id"/></td>
				</tr>
			
				<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonCreatedModified"/>
	
			</table><!--end of body--></td>
		</tr>
	
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
	
		<tr>
			<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
		</tr>
	</table>
	</div>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabOptions")%>">
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
		<tr>
			<td>
			<span class="title-text"><string:stream value="Recommendation"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
			</td>
		</tr>
		
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
			<ics:argument name="SpaceBelow" value="No"/>
		</ics:callelement>
	
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" class="width-inner-100">
	
				<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonOptions">
					<ics:argument name="ShowButton" value="false"/>
				</ics:callelement>
				
				<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonSelection">
					<ics:argument name="ShowButton" value="false"/>
				</ics:callelement>
				
				<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/GetOrdering">
					<ics:argument name="ShowButton" value="false"/>
					<ics:argument name="HiddenOnly" value="false"/>
				</ics:callelement>
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
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
		<tr>
			<td>
			<span class="title-text"><string:stream value="Recommendation"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
			</td>
		</tr>
		
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
			<ics:argument name="SpaceBelow" value="No"/>
		</ics:callelement>

		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" class="width-inner-100">
				
                <ics:if condition='<%=!"List".equals(ics.GetVar("AdvColMode"))%>'>
                	<ics:then>
 						<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonType">
							<ics:argument name="ShowButton" value="false"/>
						</ics:callelement>
                    </ics:then>
                    <ics:else>
						<tr>
							<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/Mode"/>:</td>
							<td></td>
							<td valign="top" align="left"><xlat:stream key="dvin/AT/AdvCols/List"/></td>
						</tr>
                    </ics:else>
                </ics:if>
                 
				<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/CommonTypeDetails">
					<ics:argument name="ShowButton" value="false"/>
					<ics:argument name="HiddenOnly" value="false"/>
				</ics:callelement>
				
				</table>
			</td>
		</tr>

		<tr>
			<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
		</tr>
	</table>
	</div>

</div>
</div>
</div>

</cs:ftcs>
