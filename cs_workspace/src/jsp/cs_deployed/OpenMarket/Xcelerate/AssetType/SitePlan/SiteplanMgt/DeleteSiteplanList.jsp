<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// FutureTense/Apps/AdminForms/SiteplanMgt/ModifyUserlist
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

<ics:setvar name="doesmatch" value="true" />
<ics:setvar name="isSearchListAvailable" value="false" />
<ics:if condition='<%=null != ics.GetVar("key")%>'>
<ics:then>
	<ics:setvar name="prefix:status_op" value="!="/>
	<ics:setvar name="prefix:status" value="VO"/>
	<ics:setvar name="prefix:name_op" value="like"/>
	<ics:setvar name="prefix:name" value='<%=ics.GetVar("key")%>'/>
	<asset:search type="SitePlan" prefix="prefix" list="siteplanlist"/>
	<ics:if condition='<%=null != ics.GetList("siteplanlist") && ics.GetList("siteplanlist").hasData()%>'>
	<ics:then>
		<ics:setvar name="isSearchListAvailable" value="true" />
	</ics:then>
	<ics:else>
		<ics:setvar name="doesmatch" value="false" />
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>

<ics:if condition='<%="true"!=ics.GetVar("doesmatch")%>'>
<ics:then>
	<div class="width-outer-70"> 
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value="Siteplan name does not match"/>
			<ics:argument name="severity" value="info"/>
		</ics:callelement>
		
		<ics:callelement element="OpenMarket/Xcelerate/Admin/SiteplanAdminForm">
			<ics:argument name="tool" value="SiteplanMgt"/>
			<ics:argument name="form" value="Main"/>
			<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
		</ics:callelement>
	</div>
</ics:then>
<ics:else>
	<ics:if condition='<%=!"true".equals(ics.GetVar("isSearchListAvailable"))%>'>
	<ics:then>
		<asset:list list="siteplanlist" type="SitePlan" excludevoided="true" pubid='<%=ics.GetVar("pubid")%>' order="name, description desc"/>
		<ics:if condition='<%=null != ics.GetList("siteplanlist") && ics.GetList("siteplanlist").hasData()%>'>
		<ics:then>
			<ics:setvar name="isSearchListAvailable" value="true" />
		</ics:then>
		</ics:if>
	</ics:then>
	</ics:if>
	<ics:if condition='<%="true".equals(ics.GetVar("isSearchListAvailable"))%>'>
	<ics:then>
		<satellite:form assembler="query" method="post">
			<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
						<span class="title-text"><xlat:stream key="dvin/UI/DeleteSitePlan" /></span>
					</td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
			</table>
			
			<table class="width-outer-70" bgcolor="#FFFFFF" BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<tr>
					<td colspan="2" height="5"></td>
				</tr>
				<tr>
					<td  class="form-label-inset"  nowrap="true" colspan="2">
						Select the Siteplan to delete
					</td>
				</tr> 
				<tr>
					<td>
						<table  BORDER="0" CELLSPACING="0" CELLPADDING="0">
							<tr>
								<td></td>
								<td class="tile-dark" height="1">
									<IMG WIDTH="1" height="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /> 
								</td>
								<td></td>
							</tr>
							<tr>
								<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
								<td> 
									<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
										<tr>
											<td colspan="13" class="tile-highlight">
												<IMG WIDTH="1" height="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /> 
											</td>
										</tr>
										<tr>
											<td class="tile-a" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>' nowrap="true">
												<DIV class="new-table-title">Delete ?</DIV>
											</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
												<DIV class="new-table-title">Name</DIV>
											</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
												<DIV class="new-table-title">Description</DIV>
											</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
												<DIV class="new-table-title">Device Groups</DIV>
											</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
											<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
												<DIV class="new-table-title">Default</DIV>
											</td>
											<td class="tile-c" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
										</tr>	
										<ics:setvar name="rowStyle" value="tile-row-normal"/>
										<ics:setvar name="separatorLine" value="0"/>
										<ics:listloop listname="siteplanlist">
											<ics:setvar name="separatorLine" value="1"/>
											<tr class='<%=ics.GetVar("rowStyle")%>'>
												<td><br/></td>
												<td align="LEFT" class="small-text-inset" style="vertical-align: middle;" nowrap="nowrap">
													<ics:listget listname="siteplanlist" fieldname="id" output="id" />
													<ics:listget listname="siteplanlist" fieldname="defaultsiteplan" output="defaultsiteplan" />
													<ics:if condition='<%="false".equals(ics.GetVar("defaultsiteplan"))%>' >
													<ics:then>
														<INPUT TYPE="radio" NAME="siteplanid" VALUE='<%=ics.GetVar("id")%>'/>
													</ics:then>
													</ics:if>
													
												</td>
												<td><br/></td>
												<td align="LEFT" class="small-text-inset" style="vertical-align: middle;" nowrap="nowrap">
													<ics:listget listname="siteplanlist" fieldname="name" output="name" />
													<string:stream value='<%=ics.GetVar("name")%>'/>
												</td>
												<td><br/></td>
												<td align="LEFT" class="small-text-inset" style="vertical-align: middle;">
													<ics:listget listname="siteplanlist" fieldname="description" output="description" />
													<string:stream value='<%=ics.GetVar("description")%>'/>
												</td>
												<td><br/></td>
												<td align="LEFT" class="small-text-inset" style="white-space: normal;">
													<ics:listget listname="siteplanlist" fieldname="id" output="sid" />
													<asset:list list="devGrpList" type="DeviceGroup" excludevoided="true" order="name, description desc">
														<asset:argument name="siteplans" value='<%="SitePlan:" + ics.GetVar("pubid") + ":" + ics.GetVar("sid")%>' />
													</asset:list>
													<ics:if condition='<%=null != ics.GetList("devGrpList") && ics.GetList("devGrpList").hasData()%>'>
													<ics:then>
														<ics:listloop listname="devGrpList" >
															<ics:listget listname="devGrpList" fieldname="name" />,
														</ics:listloop>
													</ics:then>
													</ics:if>
												</td>
												<td><br/></td>
												<td align="LEFT" class="small-text-inset" style="vertical-align: middle;">
													<string:stream value='<%=ics.GetVar("defaultsiteplan")%>'/>
												</td>
												<td><br/></td>
											</tr>
											<ics:if condition='<%="tile-row-normal".equals(ics.GetVar("rowStyle"))%>'>
												<ics:then>
													<ics:setvar name="rowStyle" value="tile-row-highlight"/>
												</ics:then>
												<ics:else>
													<ics:setvar name="rowStyle" value="tile-row-normal"/>
												</ics:else>
											</ics:if>
										</ics:listloop>
									</table>
								</td>
								<td class="tile-dark" VALIGN="top" WIDTH="1"><br/></td>
							</tr>
							<tr>
								<td colspan="3" class="tile-dark" VALIGN="TOP" height="1">
									<IMG WIDTH="1" height="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /> 
								</td>
							</tr>
							<tr>
								<td></td>
								<td background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/shadow.gif"%>'>
									<IMG WIDTH="1" height="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /> 
								</td>
								<td></td>
							</tr>
						</table> 
					</td>
				</tr>
				<tr>
					<td COLSPAN="3" HEIGHT="5"></td>
				</tr>
				<tr>
					<td align="left" VALIGN="TOP" colspan="3">
						<INPUT TYPE="hidden" NAME="pagename" VALUE="OpenMarket/Xcelerate/Admin/SiteplanAdminForm"/>
						<INPUT TYPE="hidden" NAME="tool" VALUE="SiteplanMgt"/>
						<INPUT TYPE="hidden" NAME="form" VALUE="DoDelete"/>
						<input type="hidden" name="pubid" value='<%=ics.GetVar("pubid")%>' />
						<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_"/>
						<A onClick="if(isSelectedForDelete(document.forms[0])){document.forms[0].submit();}" HREF="#" onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._XLAT_">
							<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
								<ics:argument name="buttonkey" value="dvin/Common/Delete"/>
							</ics:callelement>
						</A>        				
					</td>
				</tr>
			</table>
		</satellite:form>
	</ics:then>
	<ics:else>
		<div class="width-outer-70">
			<div class="width-outer-70"> 
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
					<ics:argument name="msgtext" value="Siteplan name does not match"/>
					<ics:argument name="severity" value="info"/>
				</ics:callelement>
				
				<ics:callelement element="OpenMarket/Xcelerate/Admin/SiteplanAdminForm">
					<ics:argument name="tool" value="SiteplanMgt"/>
					<ics:argument name="form" value="Main"/>
					<ics:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
				</ics:callelement>
			</div>
		</div>
	</ics:else>
	</ics:if>
</ics:else>
</ics:if>

</cs:ftcs>