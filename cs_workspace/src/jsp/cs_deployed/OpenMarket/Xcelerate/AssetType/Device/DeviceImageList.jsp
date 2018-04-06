<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/DeviceImageList
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

<asset:list type='<%=ics.GetVar("AssetType") %>' list="DeviceList" order="name, description desc" excludevoided="true" pubid='<%=ics.GetSSVar("pubid") %>' />

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td>
			<span class="title-text"><xlat:stream key="fatwire/admin/DeviceImages"/></span>
		</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30" >
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
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV>
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
				<ics:if condition='<%=null != ics.GetList("DeviceList") && ics.GetList("DeviceList").hasData() %>'>
				<ics:then>																
					<ics:listloop listname="DeviceList">
						<ics:setvar name="separatorLine" value="1"/>	
						<ics:listget listname="DeviceList" fieldname="name" output="_name"/>
						<ics:listget listname="DeviceList" fieldname="id" output="_id"/>
						<tr class='<%=ics.GetVar("rowStyle") %>'>
							<td><BR /></td>
							<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
								<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
									<ics:argument name="assettype" value='<%=ics.GetVar("AssetType") %>'/>
									<ics:argument name="assetid" value='<%=ics.GetVar("_id") %>'/>
									<ics:argument name="function" value="inspect"/>
									<ics:argument name="varname" value="urlInspectItem"/>
								</ics:callelement>
								<DIV class="small-text-inset">
									<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
				             		<A HREF='<%=ics.GetVar("urlInspectItem") %>' >
				             			<ics:listget listname="DeviceList" fieldname="name"/>
				             		</A>
								</DIV>
							</td>
							<td><BR /></td>
							<td VALIGN="TOP" ALIGN="LEFT">
								<DIV class="small-text-inset">
									<ics:listget listname="DeviceList" fieldname="description"/>
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
</cs:ftcs>