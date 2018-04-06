<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Siteplan/SiteplanMgt/deletePrompt
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

<satellite:form assembler="query" method="post">

<xlat:lookup key="dvin/UI/deleteitemwarning" varname="deleteitemwarningMsg" />
	            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
	            <ics:argument name="msgtext" value="Variables.deleteitemwarningMsg" />
	            <ics:argument name="severity" value="warning" />
	            </ics:callelement>
<asset:load name="siteplanAsset" type="SitePlan" field="id" value='<%=ics.GetVar("spid")%>'  />
<asset:get name="siteplanAsset" field="name" output="name" />
		<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<span class="title-text">
						<xlat:stream key="dvin/UI/DeleteSitePlan" />: <string:stream value='<%=ics.GetVar("name")%>' />
					</span>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
		</table>

		
		<input TYPE="HIDDEN" name="id" value='<%=ics.GetVar("spid")%>'/>
		<table class="width-outer-50" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text"align="right" NOWRAP="true">
					<span class="alert-color">*</span> <xlat:stream key="dvin/Common/Name" />:
				</td>
				<td class="form-inset" align="left">
					<string:stream value='<%=ics.GetVar("name")%>'/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" align="right" NOWRAP="true">
					<xlat:stream key="dvin/Common/Description" />:
				</td>
				<td class="form-inset" align="left">
					<asset:get name="siteplanAsset" field="description" output="description" />
					<string:stream value='<%=ics.GetVar("description")%>'/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" align="right" VALIGN="TOP" NOWRAP="true">
					Device Groups:
				</td>
				<td class="form-inset" align="left">
					<ics:callelement element="OpenMarket/Xcelerate/AssetType/SitePlan/Common/DGList">
						<ics:argument name="formtype" value="modify" />
						<ics:argument name="viewonly" value="true" />
					</ics:callelement>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text" align="right" VALIGN="TOP" NOWRAP="true">
					Default:
				</td>
				<td class="form-inset" align="left">
					<asset:get name="siteplanAsset" field="defaultsiteplan" output="defaultsiteplan" />
					<ics:if condition='<%="true".equals(ics.GetVar("defaultsiteplan").trim())%>'>
					<ics:then>
						<xlat:stream key='dvin/Common/lcyes' />
					</ics:then>
					<ics:else>
						<xlat:stream key='dvin/Common/No' />
					</ics:else>
					</ics:if>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>	
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
			<tr>
				<td></td>
				<td>
					<input TYPE="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/SiteplanAdminForm"/>
					<input TYPE="hidden" name="tool" value="SiteplanMgt"/>
					<input TYPE="hidden" name="form" value="DoDelete"/>
					<input TYPE="hidden" name="siteplanid" value='<%=ics.GetVar("spid")%>'/>
					<input type="hidden" name="pubid" value='<%=ics.GetVar("pubid")%>' />	


			<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/SiteplanAdminForm" outstring="goToMainPage">
					<satellite:argument name="tool" value="SiteplanMgt"/>
				  <satellite:argument name="form" value="home"/>
				  <satellite:argument name="pubid" value='<%=ics.GetVar("pubid")%>'/>
			</satellite:link>
		
    		<A HREF='<%=ics.GetVar("goToMainPage")%>' >
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
			<ics:argument name="buttonkey" value="dvin/UI/Cancel"/>
			</ics:callelement>
			</A>
					
					
					<A onClick="document.forms[0].submit();" HREF="#">
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
							<ics:argument name="buttonkey" value="dvin/Common/Delete"/>
						</ics:callelement>
					</A>
				</td>
			</tr>
		</table>
	</satellite:form>

</cs:ftcs>