<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
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
<cs:ftcs>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td>
			<span class="title-text">Siteplan</span>
		</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<satellite:form assembler="query" method="post">

<table class="width-outer-30" border="0"  cellpadding="0" cellspacing="0">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<tr>
		<td class="form-label-text" valign="BASELINE">
			Enter Siteplan Name
		</td>
		<td class="form-inset">
            <ics:if condition='<%="false".equals(ics.GetSSVar("userkey"))%>'>
                 <ics:then>
        			<input TYPE="text" size="32" name="key" value=""/>
                 </ics:then>
                 <ics:else>
           			<input TYPE="text" size="32" name="key" value=""/>
        		</ics:else>
            </ics:if>
		</td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<tr>
		<td class="form-label-text">
			<xlat:stream key="dvin/AdminForms/SelectOperation"/>
		</td>
		<td class="form-inset">
			<table width="100%">
				<tr>
					<td class="form-inset" align="left">
						<input TYPE="radio" style="margin-left:0px" name="form" value="ModifySiteplanList" checked="true"/>
					</td>
					<td align="left" valign="TOP" class="form-inset">
						Modify Siteplan
					</td>
				</tr>
				<tr>
					<td class="form-inset" align="left" valign="TOP">
						<input TYPE="radio" style="margin-left:0px" name="form" value="Create"/>
					</td>
					<td class="form-inset" align="left" valign="TOP">
						Add Siteplan
					</td>
				</tr>
				<tr>
					<td class="form-inset" align="left">
						<input TYPE="radio" style="margin-left:0px" name="form" value="DeleteSiteplanList"/>
					</td>
					<td class="form-inset" align="left" valign="TOP">
						Delete Siteplan
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="form-label-text"></td>
		<td class="form-inset">
			<input TYPE="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/SiteplanAdminForm"/>
			<input TYPE="hidden" name="tool" value="SiteplanMgt"/>
			<input type="hidden" name="pubid" value='<%=ics.GetVar("pubid")%>' />
			<xlat:lookup key="dvin/AT/Common/OK" varname="_XLAT_"/>
			<A onClick='if(canSubmit(document.forms[0])){document.forms[0].submit();}' HREF="#" onmouseover="window.status='Variables._XLAT_';return true;" onmouseout="window.status='';return true;" REPLACEALL="Variables._XLAT_">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
					<ics:argument name="buttonkey" value="dvin/AT/Common/OK"/>
				</ics:callelement>
			</A>
		</td>
	</tr>
</table>
</satellite:form>

</cs:ftcs>