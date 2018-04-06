<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/OrderSiteplanTile
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

<ics:if condition='<%="false".equals(ics.GetVar("editrank"))%>'>
<ics:then>
    <xlat:lookup key="dvin/UI/Admin/ModificationSuccessfulE" varname="successMsg" />
    <div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("successMsg")%>'/>
			<ics:argument name="severity" value="info" />
		</ics:callelement>
	</div>
</ics:then>
</ics:if>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
<tr><td>
	<span class="title-text"><xlat:stream key="dvin/UI/MobilitySolution/Siteplan/OrderSiteplan"/></span>
	<div class="width-outer-30" style="font-size: 12px; white-space: nowrap; margin: 0"><xlat:stream key="fatwire/admin/ReorderInstructionMsg" /></div>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<script language="JavaScript">
	function getAvatarNodes(item, hint) {
		if (hint == "avatar") {
			var avatarDiv = document.createElement("div");
			avatarDiv.innerHTML = item;
			avatarDiv.innerHTML = dojo.query('div', avatarDiv)[0].innerHTML;
			return {node: avatarDiv, data: item, type: null};
		}
	}
</script>

<script language="JavaScript">
    function saveRanks(form)
    {
		var rows = dojo.query('tr[name="siteplanrow"]'); 
		for(var i = 0; i < rows.length; i++) {
			var rankField = document.createElement("input");
			rankField.setAttribute("name",rows[i].id);
			rankField.setAttribute("value",i+1);
			rankField.setAttribute("type","hidden");
			form.appendChild(rankField);
		}
		form.submit();  
    }

</script>

<style>
	table.reorder-site-plans .dojoDndItemAfter td {
		border-bottom: 1px solid gray;
	}

	table.reorder-site-plans .dojoDndItemBefore td {
		border-top: 1px solid gray;
	}
</style>

<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="reorder-site-plans width-outer-50" >
	<tr>
		<td></td>
		<td class="tile-dark" VALIGN="TOP" HEIGHT="1">
			<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' />
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /><BR /></td>
		<td>
			<xlat:lookup key="fatwire/admin/ReorderInstructionMsg" varname="dragDropToolTip" />
			<table width="100%" alt='<%=ics.GetVar("dragDropToolTip")%>' title='<%=ics.GetVar("dragDropToolTip")%>' cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" data-dojo-type="dojo.dnd.Source" data-dojo-props="copyState: function() { return false;}, creator: getAvatarNodes">
				<script LANGUAGE="JavaScript" type="dojo/connect" event="onDrop" args="">
			       this.onDropEvent();
			    </script>
				<script LANGUAGE="JavaScript" type="dojo/connect" event="onDndStart" args="">
					this.tableNodeAlt = dojo.attr(this.node, 'alt');
					dojo.attr(this.node, 'alt', '');
					dojo.attr(this.node, 'title', '');
			    </script>
				<script LANGUAGE="JavaScript" type="dojo/connect" event="onDndDrop" args="">
					dojo.attr(this.node, 'alt', this.tableNodeAlt);
					dojo.attr(this.node, 'title', this.tableNodeAlt);
				</script>
			    <script type='dojo/method' event='onDropEvent'>
			    	if ( dojo.byId("reorderdiv") )
    				dojo.byId("reorderdiv").style.display="";
               </script>

				<tr>
					<td colspan="10"  class="tile-highlight" onmouseout="window.status='';return true">
						<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' />
					</td>
				</tr>
				<tr>
					<td class="tile-a" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/Common/Description"/></DIV>
					</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>
						<DIV class="new-table-title"><xlat:stream key="dvin/AdminForms/DeviceGroups" /></DIV>
					</td>
					<td class="tile-c" background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>'>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="10"  class="tile-dark">
						<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' />
					</td>
				</tr>
				<ics:setvar name="rowStyle" value="tile-row-normal"/>
				<ics:setvar name="separatorLine" value="0"/>
				
				<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/GetSiteplanList" >
					<ics:argument name="outputlistname" value="SitePlanList"/>
				</ics:callelement>

				<ics:if condition='<%=null != ics.GetList("SitePlanList") && ics.GetList("SitePlanList").hasData()%>'>
				<ics:then>
					<ics:listloop listname="SitePlanList">
						<ics:setvar name="separatorLine" value="1"/>
						<ics:listget listname="SitePlanList" fieldname="id" output="sid" />
						<tr class='<%=ics.GetVar("rowStyle")%> dojoDndItem' id='<%="Rank-" + ics.GetVar("sid")%>' name="siteplanrow">
							<td><BR /></td>
							<td><BR /></td>
							<ics:sql sql='<%="select nrank from SitePlanTree where otype=\'SitePlan\' and oid=\'" + ics.GetVar("sid") + "\'"%>' listname="slist" table="SitePlanTree" />
							<ics:if condition='<%="true".equals(ics.GetVar("editrank"))%>'>
							<ics:then>
								<td VALIGN="MIDDLE" NOWRAP="NOWRAP" ALIGN="LEFT">
									<ics:listget listname="SitePlanList" fieldname="nrank" output="nrank" />
								</td>
							</ics:then>
							<ics:else>
								<td VALIGN="MIDDLE" NOWRAP="NOWRAP" ALIGN="LEFT">
								</td>
							</ics:else>
							</ics:if>
							
							<td><BR /></td>
							<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
								<DIV class="small-text-inset">
									<ics:listget listname="SitePlanList" fieldname="name" output="_name"/>
									<string:stream variable="_name"/>
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
							<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
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
					</ics:listloop>
				</ics:then>
				</ics:if>
			</table>
		</td>
		<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' /><BR /></td>
	</tr>
	<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
			<IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' />
		</td>
	</tr>
	<tr>
		<td></td>
		<td background='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/shadow.gif"%>'>
			<IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>' />
		</td>
		<td></td>
	</tr>
</table>

<xlat:lookup key="dvin/TreeApplet/Commands/OrderSiteplan" encode="false" varname="_ordersiteplan_"/>
<satellite:link assembler="query" pagename="OpenMarket/Gator/UIFramework/TreeOpURL" outstring="goToMainPage">
	<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="p0_" value="ROOT"/>
	<satellite:argument name="op" value='<%=ics.GetVar("_ordersiteplan_")%>'/>
	<satellite:argument name="pubid" value='<%=ics.GetSSVar("pubid")%>'/>
	<satellite:argument name="AssetType" value="Page"/>
</satellite:link>
	
<div class="width-outer-70">
	<div style="float: left;display:none"  id="reorderdiv">
		<A HREF="javascript:saveRanks(document.forms[0])"  onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._XLAT_">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
				<ics:argument name="buttonkey" value="UI/Forms/Save"/>
			</ics:callelement>
		</A>
		<A HREF='<%=ics.GetVar("goToMainPage")%>' onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._XLAT_">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
				<ics:argument name="buttonkey" value="UI/Forms/Cancel"/>
			</ics:callelement>
		</A>
	</div>
</div>

</cs:ftcs>