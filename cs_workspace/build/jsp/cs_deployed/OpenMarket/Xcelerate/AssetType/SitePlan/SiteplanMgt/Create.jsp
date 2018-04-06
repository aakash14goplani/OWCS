<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// FutureTense/Apps/AdminForms/SiteplanMgt/Create
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
<cs:ftcs>

<ics:if condition='<%=null != ics.GetVar("key")%>'>
<ics:then>
	<ics:setssvar name="userkey" value='<%=ics.GetVar("key")%>'/>
</ics:then>
<ics:else>
	<ics:setvar name="key" value=""/>
</ics:else>
</ics:if>
<satellite:form assembler="query" method="post">
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td>
				<span class="title-text">
					<xlat:stream key="dvin/UI/AddSitePlan" />
				</span>
			</td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	
	<table class="width-outer-50" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="0">
	    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	    <tr>
	        <td class="form-label-text"align="right" NOWRAP="true">
	           	<span class="alert-color">*</span> <xlat:stream key="dvin/Common/Name" />:
	        </td>
	        <td class="form-inset" align="left">
				<input TYPE="text" name="name" size="32" maxlength="64" value='<%=ics.GetVar("key")%>' style="width: 210px;"/>
	    	</td>
	    	<td></td>
			<td></td>
	    </tr>
	    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
	        <td class="form-label-text" align="right" NOWRAP="true">
				<xlat:stream key="dvin/Common/Description" />:
	        </td>
	        <td class="form-inset" align="left">
	            <input TYPE="text" name="description" size="32" maxlength="128" value="" style="width: 210px;"/>
			</td>
			<td></td>
			<td></td>
	    </tr>
	    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
            <ics:callelement element="OpenMarket/Xcelerate/AssetType/SitePlan/Common/DGList">
				<ics:argument name="formtype" value="new" />
			</ics:callelement>
	    </tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
		<tr>
	        <td></td>
			<td>
				<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/SiteplanAdminForm" outstring="goToMainPage">
					<satellite:argument name="tool" value="SiteplanMgt"/>
					 <satellite:argument name="form" value="Home"/>
					 <satellite:argument name="pubid" value='<%=ics.GetVar("pubid")%>' />
				</satellite:link>				
				<xlat:lookup key="dvin/UI/Cancel" varname="_XLAT_" />
				<A HREF='<%=ics.GetVar("goToMainPage")%>' class="button-anchor">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
						<ics:argument name="buttonkey" value="dvin/UI/Cancel"/>
					</ics:callelement>
				</A>
					
				<input TYPE="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/SiteplanAdminForm"/>
				<input TYPE="hidden" name="tool" value="SiteplanMgt"/>
				<input type="hidden" name="pubid" value='<%=ics.GetVar("pubid")%>' />
		   		<input TYPE="hidden" name="form" value="DoCreate"/>
				<xlat:lookup key="dvin/UI/CSAdminForms/Add" varname="_XLAT_"/>
		   		<A onclick="if(chkMandatoryFields(document.forms[0])){document.forms[0].submit();}" HREF="#" onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._XLAT_" class="button-anchor">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
						<ics:argument name="buttonkey" value="dvin/UI/CSAdminForms/Add"/>
					</ics:callelement>
				</A>
	        </td>
	    </tr>
	</table>
</satellite:form>

</cs:ftcs>