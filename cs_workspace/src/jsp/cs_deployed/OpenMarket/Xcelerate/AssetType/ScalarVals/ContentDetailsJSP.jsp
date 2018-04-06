<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>

<cs:ftcs>

	<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
	<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ActionsBar">
		<ics:argument name="Screen" value="Inspect"/>
		<ics:argument name="NoPreview" value="true"/>
	</ics:callelement>

<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">

	<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
		<ics:argument name="tabContent" value='<%=ics.GetVar("tabContent")%>' />
		<ics:argument name="elementType" value="JSP" />
	</ics:callelement>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabContent")%>"  selected="true">
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
	<!-- Segment page title with asset name -->
	
	<!-- ASSETTYPE.LIST LIST="ThisAsset" FIELD1="assettype" VALUE1="Variables.AssetType"-->
	<%
	{
		FTValList args = new FTValList();
		args.setValString("LIST", "ThisAsset");
		args.setValString("FIELD1", "assettype");
		args.setValString("VALUE1", ics.GetVar("AssetType"));
		ics.runTag("assettype.list", args);		
		
		IList theList = ics.GetList("ThisAsset"); 
		if (theList != null && theList.numRows() > 0)
		{
			theList.moveTo(0);
			ics.SetVar("ThisAssetDescription", (String) theList.getValue("description"));
		}
	}
	%>		
	
	<tr>
		<td>
			<span class="title-text"><string:stream variable="ThisAssetDescription"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
		</td>
	</tr>

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>
	
	<!-- Segment  inspection form -->
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
	
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
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/UI/Admin/Category"/>:</td>
					<td></td>
					<td class="form-inset"><%=ics.GetVar("ContentDetails:category")%></td>
				</tr>
							
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
					<td></td>
					<td class="form-inset"><string:stream variable="id"/></td>
				</tr>
				
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowStatusCode"/>
				</tr>

				<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/SiteContentDetails"/>
				
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/InspectAssetStartEndDate"/>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	
                <tr>
                   	<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Created"/>:</td>
                   	<td></td>
                   	<td class="form-inset">
              		<dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:createddate")%>' valuetype="jdbcdate"  varname="ContentDetails:createddate"/>
                   	<xlat:stream key="dvin/UI/ContentDetailscreateddatebycreatedby"/></td>
               	</tr>
	
                <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	
                <tr>
                   	<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Modified"/>:</td>
                   	<td></td>
                   	<td class="form-inset">
                    <dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:updateddate")%>' valuetype="jdbcdate"  varname="ContentDetails:updateddate"/>
                    <xlat:stream key="dvin/UI/ContentDetailsupdateddatebyupdatedby"/></td>
               	</tr>
	
			</table>
		</td>
	</tr>		
	</table>
	</div>
	
	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabDetail")%>">
	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
	
	<tr>
		<td>
			<span class="title-text"><string:stream variable="ThisAssetDescription"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
		</td>
	</tr>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>
	
	<!-- Segment  inspection form -->
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/Common/Type"/>:</td>
					<td></td>
					<td class="form-inset"><xlat:stream key='<%="dvin/AT/Common/Type-" + ics.GetVar("ContentDetails:type")%>' encode="true"/></td>
				</tr>
				
				<ics:if condition='<%="string".equals(ics.GetVar("ContentDetails:type"))%>'>
				<ics:then>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/Common/Length"/>:</td>
						<td></td>
						<td class="form-inset"><%=ics.GetVar("ContentDetails:length")%></td>
					</tr>
				</ics:then>
				</ics:if>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>

				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Nullallowed"/>:</td>
					<td></td>
					<td class="form-inset">
						<ics:if condition='<%="T".equals(ics.GetVar("ContentDetails:nullallowed"))%>'>
						<ics:then>
							<xlat:stream key="dvin/AT/Common/true" />						
						</ics:then>
						<ics:else>
							<xlat:stream key="dvin/AT/Common/false" />						
						</ics:else>
						</ics:if>
					</td>
				</tr>
				
				<ics:if condition='<%="F".equals(ics.GetVar("ContentDetails:nullallowed"))%>'>
				<ics:then>				
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Defaultvalue"/>:</td>
						<td></td>
						<td class="form-inset">
						<%
						{
							String svDefaultValue = ics.GetVar("ContentDetails:defaultval");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svDefaultValue = svDefaultValue.substring(0, Math.min(19, svDefaultValue.length()));	// truncate .s off end of date value
							ics.StreamText(svDefaultValue);
						}
						%>
						</td>
					</tr>
				</ics:then>
				</ics:if>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Constrainttype"/>:</td>
					<td></td>
					<td class="form-inset">
						<ics:if condition='<%="none".equals(ics.GetVar("ContentDetails:constrainttype"))%>'>
						<ics:then>
							<xlat:stream key="dvin/Common/lowercasenone" />
						</ics:then>
						</ics:if>
						<ics:if condition='<%="range".equals(ics.GetVar("ContentDetails:constrainttype"))%>'>
						<ics:then>
							<xlat:stream key="dvin/AT/SVals/range" />
						</ics:then>
						</ics:if>
						<ics:if condition='<%="enum".equals(ics.GetVar("ContentDetails:constrainttype"))%>'>
						<ics:then>
							<xlat:stream key="dvin/AT/SVals/enumeration" />
						</ics:then>
						</ics:if>
					</td>
				</tr>
				
				<ics:if condition='<%="range".equals(ics.GetVar("ContentDetails:constrainttype")) && !"string".equals(ics.GetVar("ContentDetails:type"))%>'>
				<ics:then>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Lowerrangevalue"/>:</td>
						<td></td>
						<td class="form-inset">
						<%
						{
							String svLowerRange = ics.GetVar("ContentDetails:lowerrange");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svLowerRange = svLowerRange.substring(0, Math.min(19, svLowerRange.length()));	// truncate .s off end of date value
							ics.StreamText(svLowerRange);
						}
						%>
						</td>
					</tr>
    
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Upperrangevalue"/>:</td>
						<td></td>
						<td class="form-inset">
						<%
						{
							String svUpperRange = ics.GetVar("ContentDetails:upperrange");
							if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
								svUpperRange = svUpperRange.substring(0, Math.min(19, svUpperRange.length()));	// truncate .s off end of date value
							ics.StreamText(svUpperRange);
						}
						%>
						</td>
					</tr>
				</ics:then>
				</ics:if>

				<ics:if condition='<%="enum".equals(ics.GetVar("ContentDetails:constrainttype"))%>'>
				<ics:then>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text"><xlat:stream key="dvin/AT/HFields/Legalvalues"/>:</td>
						<td></td>
						<td class="form-inset">
							<%
							{
								IList theList = ics.GetList("ContentDetails:Values");
								int nVals = theList.numRows();
								
								for (int val=0; val < nVals; val++)
								{
									theList.moveTo(val+1);
									if (val != 0)
										ics.StreamText("<br />");

									String svEnumValue = theList.getValue("value");
									if ("timestamp".equals(ics.GetVar("ContentDetails:type")))
										svEnumValue = svEnumValue.substring(0, Math.min(19, svEnumValue.length()));	// truncate .s off end of date value
									ics.StreamText(svEnumValue);
								}
							}%>
						</td>
	  				</tr>
	  			</ics:then>
	  			</ics:if>
  				
  				<%
  				{
  					FTValList args = new FTValList();
  					args.setValString("LISTVARNAME", "associations");
  					args.setValString("TYPE", ics.GetVar("AssetType"));
  					ics.runTag("assocnamedmanager.list", args);	
  					
  					IList assocList = ics.GetList("associations");

					if (assocList.numRows() > 0)
					{
  				%>
						<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/ShowAssociations">
							<ics:argument name="assetname" value="theCurrentAsset"/>
                               <ics:argument name="revision" value='<%=ics.GetVar("revision")%>'/>
                               <ics:argument name="revisionInspect" value='<%=ics.GetVar("revisionInspect")%>'/>
						</ics:callelement>
				<%
					}
				}
				%>
				
				<!-- Analyics Performance indicator -->
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/ShowAnalyticsKPI"/>
  				
			</table>
		</td>
	</tr>
	</table>
	</div>

</div>
</div>
</div>
</cs:ftcs>
