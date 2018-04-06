<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// FutureTense/Apps/AdminForms/SiteplanMgt/main 
//
// input
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %> 
<%@ page import="COM.FutureTense.Interfaces.ICS" %> 
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<cs:ftcs>

<ics:setvar name="AssetType" value="SitePlan" />
<ics:if condition='<%=!"true".equalsIgnoreCase(ics.GetVar("orderby")) %>'>
<ics:then>
	<ics:setvar name="orderby" value="name, description desc"/>
</ics:then>
</ics:if>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td>
			<span class="title-text"><xlat:stream key="dvin/UI/SitePlans"/></span>
		</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<asset:list type='<%=ics.GetVar("AssetType") %>' list="SitePlanList" order="name, description desc" excludevoided="true" pubid='<%=ics.GetVar("pubid") %>' />
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">
	<tr>
		<td></td>
		<td class="tile-dark" HEIGHT="1">
			<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
		<td >
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" >
				<tr>
					<td colspan="10" class="tile-highlight"  onmouseout="window.status='';return true">
						<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
					</td>
				</tr>
				<tr>
					<td class="tile-a" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/AdminForms/DeviceGroups"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-c" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="10" class="tile-dark">
						<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
					</td>
				</tr>

	   			<ics:setvar name="rowStyle" value="tile-row-normal"/>
				<ics:setvar name="separatorLine" value="0"/>
				<ics:if condition='<%=null != ics.GetList("SitePlanList") && ics.GetList("SitePlanList").hasData() %>'>
				<ics:then>																
					<ics:listloop listname="SitePlanList">
						<ics:setvar name="separatorLine" value="1"/>	
						<ics:listget listname="SitePlanList" fieldname="name" output="_name"/>
						<ics:listget listname="SitePlanList" fieldname="id" output="_id"/>
						<tr class='<%=ics.GetVar("rowStyle") %>' id='SitePlanList.id' name="deviceGroupRow" REPLACEALL='SitePlanList.id'>
							<td><BR /></td>
							<td NOWRAP="NOWRAP" ALIGN="LEFT" style = "padding-top : 5px;">										
								<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
								<xlat:lookup key="dvin/UI/Admin/EditThisAssetType" varname="_alt_"/>
								<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/SiteplanAdminForm" outstring="urlEdit">
									<satellite:parameter name="tool" value="SiteplanMgt"/>
									<satellite:parameter name="form" value="Modify"/>
									<satellite:parameter name="spid" value='<%=ics.GetVar("_id") %>'/>
									<satellite:parameter name="pubid" value='<%=ics.GetVar("pubid") %>'/>									  
								</satellite:link>
								<A HREF='<%=ics.GetVar("urlEdit") %>' >
									<img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/icon/iconEditContent.gif"%>' border="0" alt='<%=ics.GetVar("_XLAT_")%>' title='<%=ics.GetVar("_XLAT_")%>' />
								</A>
								
								<ics:if condition='<%=!MobilityUtils.DEFAULT_SITEPLAN_NAME.equalsIgnoreCase(ics.GetVar("_name")) %>' >
								<ics:then>
									<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/SiteplanAdminForm" outstring="deleteURL">
										<satellite:parameter name="tool" value="SiteplanMgt"/>
										<satellite:parameter name="form" value="Delete"/>
										<satellite:parameter name="spid" value='<%=ics.GetVar("_id") %>'/>
										<satellite:parameter name="pubid" value='<%=ics.GetVar("pubid") %>' />									  
									</satellite:link>
									<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
									<xlat:lookup key="dvin/UI/Admin/DeleteThisAssetType" varname="_alt_"/>
									<A HREF='<%=ics.GetVar("deleteURL") %>' >
										<img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/icon/iconDeleteContent.gif"%>' border="0" alt='<%=ics.GetVar("_XLAT_")%>' title='<%=ics.GetVar("_XLAT_")%>' />
									</A>
								</ics:then>
								</ics:if>
								

							</td>
							<td><BR /></td>
							<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
								<DIV class="small-text-inset">
									<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
				             		<A HREF='<%=ics.GetVar("urlEdit") %>' >
				             			<ics:listget listname="SitePlanList" fieldname="name" output="_name"/>
										<string:stream variable="_name"/>
				             		</A>
								</DIV>
							</td>
							<td><BR /></td>
							<td VALIGN="TOP" ALIGN="LEFT">
								<DIV class="small-text-inset">
									<ics:listget listname="SitePlanList" fieldname="description" output="_description"/>
									<string:stream variable="_description"/>
								</DIV>
							</td>
							<td><BR /></td>
							<td VALIGN="TOP" ALIGN="LEFT">
		                    	<DIV class="small-text-inset">
		                    		<ics:listget listname="SitePlanList" fieldname="devicegroups" output="_devicegroups"/>
		                    		<%
		                    			StringBuffer sb = new StringBuffer("");
		                    			String _deviceGroups = ics.GetVar("_devicegroups");
										if(_deviceGroups.length() > 0)
											_deviceGroups = _deviceGroups.replace(";", ",");
										else
											_deviceGroups = "'000'";	/*The Query expects a Decimal Value and it fails in DB2 if we just send ''*/
		                    		%>
		                    		<ics:sql sql='<%="SELECT name from DeviceGroup where id in (" + _deviceGroups + ")" %>' listname="_deviceGroupList" table="DeviceGroup" />
		                    		<ics:listloop listname="_deviceGroupList">
		                    			<ics:listget listname="_deviceGroupList" fieldname="name" output="deviceGroupName"/>
		                    			<%	sb.append(ics.GetVar("deviceGroupName")).append(",");%>
		                    		</ics:listloop>
		                    		<%
										if(sb.length() > 0) {
											String _sb = sb.substring(0, sb.length() - 1).toString();
									%>
											<string:stream value = "<%=_sb%>"/>
									<%
										}
									%>
								</DIV>
							</td>
							<td></td>
							<td><BR /></td>
						</tr>
						<ics:if condition='<%="tile-row-normal".equalsIgnoreCase(ics.GetVar("rowStyle")) %>'>
		            	<ics:then>
		            		<ics:setvar name="rowStyle" value="tile-row-highlight"/>
			            </ics:then>
			            <ics:else>
			            	<ics:setvar name="rowStyle" value="tile-row-normal"/>
			            </ics:else>
			            </ics:if>								            
					</ics:listloop>
				</ics:then>
				</ics:if>
			</table>
		</td>
		<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
	</tr>
	<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
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
<input TYPE="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/SiteplanAdminForm"/>
<input TYPE="hidden" name="tool" value="SiteplanMgt"/>
<input TYPE="hidden" name="form" value="Create"/>
<input type="hidden" name="pubid" value='<%=ics.GetVar("pubid")%>' />
<xlat:lookup key="dvin/UI/AddSitePlan" varname="_XLAT_" escape="true"/>
<div class="width-outer-70">
	<A onClick="document.forms[0].submit()" >
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
			<ics:argument name="buttonkey" value="dvin/UI/AddSitePlan"/>
		</ics:callelement>
	</A>
</div>

</cs:ftcs>