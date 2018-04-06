<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/DeviceGroup
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

<ics:if condition='<%="front".equals(ics.GetVar("pagetype"))%>'>
<ics:then>
	
	<script>
		function getSelectedDeviceGroups()
		{
			var i=0;
			var obj = document.forms[0];
			for (i=0; i < obj.elements.length;i++)
			{
				if (obj.elements[i].name=="DGCheckBox")
				{
					if (obj.elements[i].checked==true)
						return true;
				}
			}
			alert("Please select at least one Device group");
			return false;
		}

		function submitDeviceGroupsForm()
		{
			if(getSelectedDeviceGroups())
			{
				if('<%=ics.GetVar("formtype")%>' == "disable")
				{
					var result = confirm("Disabling Device groups will remove the associations with siteplan.\nAre you sure you want to delete ?");
					if(result == true)
						document.forms[0].submit();
					else
						return false;
				}
				else
					document.forms[0].submit();
			}
		}
	</script>

	<ics:setvar name="id" value='<%=ics.GetVar("pubid")%>' />
	<ics:selectto table='Publication' what="name,description" where="id" listname="PublicationList"/>
	<table cellspacing="0" cellpadding="0" border="0" class="width-outer-70">
		<tr>
			<td class="title-text">
				<ics:if condition='<%="enable".equals(ics.GetVar("formtype"))%>'>
				<ics:then>
					<xlat:stream key="dvin/UI/Mobility/EnableDeviceGroups"/>
				</ics:then>
				<ics:else>
					<xlat:stream key="dvin/UI/Mobility/DisableDeviceGroups"/>
				</ics:else>
				</ics:if>: <ics:listget listname="PublicationList" fieldname="name" />
			</td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>

	<!-- Display the publication details -->
	<table class="width-outer-50" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text">
							<xlat:stream key="dvin/AT/Common/Name"/>:
						</td>
						<td class="form-inset">
							<ics:listget listname="PublicationList" fieldname="name" />
						</td>
					</tr>
					
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text">
							<xlat:stream key="dvin/AT/Common/Description"/>:
						</td>
						<td class="form-inset">
							<ics:listget listname="PublicationList" fieldname="description" />
						</td>
					</tr>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text">
							<xlat:stream key="dvin/UI/Admin/PublicationID"/>:
						</td>
						<td class="form-inset">
							<%=ics.GetVar("pubid")%>
						</td>
					</tr>			

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
					<tr>
						<td class="form-label-text">
							<ics:if condition='<%="enable".equals(ics.GetVar("formtype"))%>'>
							<ics:then>
								<xlat:stream key="dvin/UI/Mobility/EnableDeviceGroups"/>
							</ics:then>
							<ics:else>
								<xlat:stream key="dvin/UI/Mobility/DisableDeviceGroups"/>
							</ics:else>
							</ics:if>:
						</td>
						<td class="form-inset">
							<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-inner-100">
							<tr>
								<td></td>
								<td class="tile-dark" HEIGHT="1">
									<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
								</td>
								<td></td>
							</tr>
							<tr>
								<td class="tile-dark" WIDTH="1">
									<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
								</td>
								<td>
									<table  class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
									<tr>
										<td colspan="7" class="tile-highlight">
											<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
										</td>
									</tr>
									<tr>
										<td class="tile-a" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
										<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
										<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
										<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
											<DIV class="new-table-title"><xlat:stream key="dvin/AT/Common/Name"/></DIV>
										</td>
										<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
										<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
											<DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV>
										</td>
										<td class="tile-c" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
									</tr>
									<tr>
										<td colspan="7" class="tile-dark">
											<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
										</td>
									</tr>
									<!-- Loop over all search results. -->
									<ics:setvar name="rowStyle" value="tile-row-normal"/>
									<ics:setvar name="separatorLine" value="0"/>
									
									<asset:list type="DeviceGroup" order="name" list="DGList" excludevoided="true">
										<asset:argument name="category" value="m" />
										<asset:argument name="active" value="Y" />
									</asset:list>
									
									<ics:if condition='<%=null != ics.GetList("DGList") && ics.GetList("DGList").hasData()%>'>
									<ics:then>
										<ics:listloop listname="DGList">
											<ics:listget listname="DGList" fieldname="id" output="_id"/>
											<asset:load name="myAsset" type="DeviceGroup" objectid='<%=ics.GetVar("_id")%>' flushonvoid="true"/>
											<asset:sites name="myAsset" list="sites"/>
											<ics:if condition='<%=null != ics.GetList("sites") && ics.GetList("sites").hasData()%>'>
											<ics:then>
												<ics:setvar name="isEnabled" value="false" />
												<ics:listloop listname="sites">
													<ics:listget listname="sites" fieldname="id" output="siteid"/>
													<ics:if condition='<%=ics.GetVar("pubid").equals(ics.GetVar("siteid"))%>'>
													<ics:then>
														<ics:setvar name="isEnabled" value="true" />
													</ics:then>
													</ics:if>
												</ics:listloop>
												<ics:if condition='<%="enable".equals(ics.GetVar("formtype")) && "false".equals(ics.GetVar("isEnabled")) || "disable".equals(ics.GetVar("formtype")) && "true".equals(ics.GetVar("isEnabled"))%>'>
												<ics:then>
													<ics:setvar name="separatorLine" value="1"/>
													<tr class='<%=ics.GetVar("rowStyle")%>'>
														<td><BR /></td>
														<td style="vertical-align:middle;text-align:center;">
															<INPUT TYPE="Checkbox" NAME="DGCheckBox" VALUE='<%=ics.GetVar("_id")%>'/>
														</td>
														<td><BR /></td>
														<td NOWRAP="NOWRAP" ALIGN="LEFT">
															<DIV class="small-text-inset">
															<xlat:lookup key="dvin/UI/Admin/InspectThisAssetType" varname="_XLAT_" escape="true"/>
															<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/ContentDetailsFront" outstring="urlassettypefront">
																<satellite:parameter name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
																<satellite:parameter name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
																<satellite:parameter name="function" value="inspect"/>
																<satellite:parameter name="AssetType" value="DeviceGroup"/>
																<satellite:parameter name="id" value='<%=ics.GetVar("_id")%>'/>
															</satellite:link>
															<A HREF='<%=ics.GetVar("urlassettypefront")%>' onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true" >
																<ics:listget listname="DGList" fieldname="name"/>
															</A>
															</DIV>
														</td>
														<td><BR /></td>
														<td ALIGN="LEFT">
															<DIV class="small-text-inset">
																<ics:listget listname="DGList" fieldname="description"/>
															</DIV>
														</td>
														<td><BR /></td>
													</tr>
													<ics:if condition='<%="tile-row-normal".equals(ics.GetVar("rowStyle"))%>'>
													<ics:then>
														<ics:setvar name="rowStyle" value="tile-row-highlight"/>
													</ics:then>
													<ics:else>
														<ics:setvar name="rowStyle" value="tile-row-normal"/>
													</ics:else>
													</ics:if>
												</ics:then>
												</ics:if>
											</ics:then>
											</ics:if>
													
										</ics:listloop>
									</ics:then>
									</ics:if>
									</table>
								</td>
								<td class="tile-dark" WIDTH="1">
									<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
								</td>
							</tr>
							<tr>
								<td colspan="3" class="tile-dark" HEIGHT="1">
									<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
								</td>
							</tr>
							<tr>
								<td></td>
								<td background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/shadow.gif"%>'>
									<IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
								</td>
								<td></td>
							</tr>
							</table>
						</td>
					</tr>
					
					<ics:if condition='<%="enable".equals(ics.GetVar("formtype"))%>'>
					<ics:then>
						<ics:setvar name="buttonName" value="EnableDeviceGroups"/>
						<xlat:lookup key="dvin/UI/Admin/EnableSelectedAssetTypesforsite" varname="_XLAT_" escape="true"/>
						<!-- our next step is to get the list of available start menu items for the selected asset types -->
						<ics:setvar name="action" value="asksmi"/>
						<!-- set what kind of start menu items are we looking for -->
					</ics:then>
					<ics:else>
						<ics:setvar name="buttonName" value="DisableDeviceGroups"/>
						<xlat:lookup key="dvin/UI/Admin/DisableSelectedAssetTypesforsite" varname="_XLAT_" escape="true"/>
					</ics:else>
					</ics:if>

					<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="OpenMarket/Xcelerate/Admin/DeviceGroupPost"/>
					<INPUT TYPE="HIDDEN" NAME="formtype" VALUE='<%=ics.GetVar("formtype")%>' />
					<INPUT TYPE="HIDDEN" NAME="pubid" VALUE='<%=ics.GetVar("pubid")%>'/>
					<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
					<xlat:lookup key="dvin/UI/Cancel" varname="_alt_"/>
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/SiteFront" outstring="urlsitefront">
						<satellite:parameter name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:parameter name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:parameter name="action" value="details"/>
						<satellite:parameter name="pubid" value='<%=ics.GetVar("pubid")%>'/>
					</satellite:link>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
					<TR>
						<TD class="form-label-text"></TD>
						<TD class="form-inset">
							<A HREF="Variables.urlsitefront" onmouseover="window.status='Variables._status_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._status_,Variables.urlsitefront">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
									<ics:argument name="buttonkey" value="UI/Forms/Cancel"/>
								</ics:callelement>
							</A>
							<xlat:lookup key="dvin/UI/Mobility/DisableDeviceGroups" varname="_ALT_"/>
							<A HREF="javascript:void(0);" onclick="return submitDeviceGroupsForm();" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
									<ics:argument name="buttonkey" value='<%="dvin/UI/Mobility/" + ics.GetVar("buttonName")%>'/>
								</ics:callelement>
							</A>
						</TD>
					</TR>
				</table>
			</td>
		</tr>
	</table>
</ics:then>
<ics:else>
	<ics:if condition='<%="post".equals(ics.GetVar("pagetype"))%>'>
	<ics:then>
		<%
		if(null != ics.GetVar("DGCheckBox"))
		{
			String[] DGIds = ics.GetVar("DGCheckBox").split(";");
			for(int i = 0; i < DGIds.length; i++)
			{
			%>
				<ics:if condition='<%="enable".equals(ics.GetVar("formtype"))%>'>
				<ics:then>
					<asset:load name="myAsset" type="DeviceGroup" objectid='<%=DGIds[i]%>' editable="true"/>
					<asset:addsite name="myAsset" pubid='<%=ics.GetVar("pubid")%>' />
					<asset:save name="myAsset" />
				</ics:then>
				<ics:else>
					<ics:if condition='<%="disable".equals(ics.GetVar("formtype"))%>'>
					<ics:then>
						<asset:load name="myAsset" type="DeviceGroup" objectid='<%=DGIds[i]%>' editable="true"/>
						<asset:removesite name="myAsset" pubid='<%=ics.GetVar("pubid")%>' />
						<asset:get name="myAsset" field="siteplans" output="siteplans" />
						<ics:if condition='<%=ics.GetVar("siteplans").contains("Siteplan:" + ics.GetVar("pubid"))%>' >
						<ics:then>
							<hash:create name="myhash" />
							<%
								String siteplans = ics.GetVar("siteplans");
								String[] splist = siteplans.split(";");
								for (int j = 0; j < splist.length; j++)
								{
									if(!(splist[j].contains(ics.GetVar("pubid"))))
									{
										%><hash:add name="myhash" value='<%=splist[j]%>' /><%
									}
								}
							%>
							<hash:tostring name="myhash" delim=";" varname="siteplans" />
							<asset:set name="myAsset" field="siteplans" value='<%=ics.GetVar("siteplans")%>' />
						</ics:then>
						</ics:if>
						<asset:save name="myAsset" />
					</ics:then>
					</ics:if>
				</ics:else>
				</ics:if>
				<ics:if condition='<%=ics.GetErrno()!=0%>' >
				<ics:then>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
						<ics:argument name="severity" value="error"/>
						<ics:argument name="msgtext" value="Error Generated during Enabling / Disabling Device group"/>
					</ics:callelement>
				</ics:then>
				<ics:else>
					<ics:if condition='<%="enable".equalsIgnoreCase(ics.GetVar("formtype")) %>'>
					<ics:then>
						<xlat:lookup key="dvin/UI/MobilitySolution/DeviceGroup/DeviceGroupsEnabled" varname="_XLAT_" />
					</ics:then>
					<ics:else>
						<xlat:lookup key="dvin/UI/MobilitySolution/DeviceGroup/DeviceGroupsDisabled" varname="_XLAT_" />
					</ics:else>
					</ics:if>
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
						<ics:argument name="severity" value="info"/>
						<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_")%>'/>
					</ics:callelement>
				</ics:else>
				</ics:if>
			<%
			}
			%>
				<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub">
					<ics:argument name="upcommand" value="IsAssetTypeEnabled"/>
					<ics:argument name="assettype" value="DeviceGroup" />
					<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
				</ics:callelement>
				<ics:if condition='<%="false".equals(ics.GetVar("IsAuthorized")) && "enable".equals(ics.GetVar("formtype"))%>'>
				<ics:then>
					<setvar name="errno" value="0"/>
					<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub">
						<ics:argument name="upcommand" value="EnableAssetType"/>
						<ics:argument name="assettype" value="DeviceGroup"/>
						<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
					</ics:callelement>
					<ics:callelement element="OpenMarket/Xcelerate/Admin/AutoCreateStartmenuItems">
						<ics:argument name="assettype" value="DeviceGroup"/>
						<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
					</ics:callelement>
				</ics:then>
				<ics:else>
					<ics:if condition='<%="true".equals(ics.GetVar("IsAuthorized")) && "disable".equals(ics.GetVar("formtype"))%>'>
					<ics:then>
						<asset:list list="DGList" type="DeviceGroup" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>' order="name, description desc"/>
						<ics:if condition='<%=0 == ics.GetList("DGList").numRows()%>'>
						<ics:then>
							<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub">
								<ics:argument name="upcommand" value="DisableAssetType"/>
								<ics:argument name="assettype" value="DeviceGroup"/>
								<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
							</ics:callelement>
						</ics:then>
						</ics:if>
					</ics:then>
					</ics:if>
				</ics:else>
				</ics:if>
			<%
		}
		%>
	</ics:then>
	</ics:if>
</ics:else>
</ics:if>

</cs:ftcs>