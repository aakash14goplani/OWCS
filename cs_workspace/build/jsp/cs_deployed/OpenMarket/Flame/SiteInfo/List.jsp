<%@ page import="COM.FutureTense.Interfaces.IList,
                 COM.FutureTense.Interfaces.FTValList,
                 COM.FutureTense.Util.FStringBuffer,
                 com.fatwire.flame.portlets.SiteInfo,
                 com.fatwire.flame.portlets.FlamePortlet,
                 com.openmarket.xcelerate.interfaces.UserManagerFactory"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/SiteInfo/List
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
	<%
	ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
	String userid = UserManagerFactory.make(ics).getLoginUserID();
    String cs_imageDir = ics.GetVar("cs_imagedir");

    %><property:get param="xcelelem.manageuserpub" inifile="futuretense_xcel.ini" varname="propmanageuserpub"/><%
	String manageuserpub = ics.GetVar("propmanageuserpub");
	ics.RemoveVar("propmanageuserpub");

	FTValList args = new FTValList();
	args.setValString("upcommand", "GetPublications");
	args.setValString("qryprefix", "sites");
	args.setValString("username", userid);
	ics.CallElement(manageuserpub, args);
	IList sites = ics.GetList("sites");
	ics.RegisterList("sites", null);
	%>
    <link href="<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css" rel="stylesheet" type="text/css"/>
    
    <script>
	function <portlet:namespace/>_replaceTimeZoneOffset(objLink) {
		var curdate = new Date() ;
		var offset = curdate.getTimezoneOffset();
		var finaloffset = "";
		if (offset >= 0) {
			finaloffset = finaloffset+"-";
		} else {
			finaloffset = finaloffset+"+";
		}
		var x = parseInt(offset/600);
		finaloffset=finaloffset+x;
		offset=offset-(x*600);
		x=parseInt(offset/60);
		finaloffset=finaloffset+x;
		offset=offset-(x*60);
		finaloffset=finaloffset+":";
		x = parseInt(offset/10);
		finaloffset=finaloffset+x;
		offset =offset-(x*10);
		finaloffset=finaloffset+offset;
		objLink.href = objLink.href.replace(/TimeZoneOffsetValue/, escape(finaloffset));
		return true;
	}
	</script>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="tile-dark"><img align="left" hspace="0" vspace="0" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/><img hspace="0" vspace="0" align="right" src="<%=cs_imageDir%>/graphics/common/screen/whitedot.gif"/></td>
    </tr>
    <tr>
        <td>
            <table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="border-color:#333366;border-style:solid;border-width:0px 1px 1px 1px;">
            <tr><td colspan="3" class="tile-highlight">
                    <img align="left" width="1" height="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/>
                </td></tr>
            <tr class="section-header">
                <td nowrap><div><xlat:stream key="dvin/UI/SiteName"/>&nbsp;&nbsp;&nbsp;&nbsp;</div></td>
                <td><div><xlat:stream key="dvin/AT/Common/Description"/></div></td>
                <td class="tile-c"><div><xlat:stream key="dvin/UI/Security/AssignedRole"/></div></td>
            </tr>
            <tr>
                <td colspan="3" background="<%= cs_imageDir %>/graphics/common/screen/graydot.gif"><img height="1" width="1" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td>
            </tr>
    <%
	for (int i = 1; i <= sites.numRows(); i++) {
		sites.moveTo(i);
		String name = sites.getValue("name");
		String desc = sites.getValue("description");

		args.clear();
		args.setValString("upcommand",      "GetACLs");
		args.setValString("aclname",        "pubacls");
		args.setValString("forceACLFetch",  "true");
		args.setValString("username",       userid);
		args.setValString("publication",    name);
		ics.CallElement(manageuserpub, args);
		FStringBuffer acls = new FStringBuffer(ics.GetVar("pubacls"));
		acls.replaceAll(",", ", "); //add white-space to allow word wrap
		ics.RemoveVar("pubacls");
		%>
		<satellite:link assembler="query" portleturltype="action" outstring="urlSelectSite">
			<satellite:argument name="<%=FlamePortlet.ACTION%>" value='<%=SiteInfo.SELECT%>'/>
			<satellite:argument name="<%=SiteInfo.PUBID%>" value='<%=sites.getValue("pubid")%>'/>
			<satellite:argument name="<%=SiteInfo.TimeZoneOffset%>" value='TimeZoneOffsetValue'/>
		</satellite:link>
		<%
		String href = ics.GetVar("urlSelectSite");
		ics.RemoveVar("urlSelectSite");

		String rowclass = i % 2 == 0 ? "portlet-section-bodyalternate" : "portlet-section-alternate";
		%>
		<tr class="<%=rowclass%>">
			<td valign="top" align="left" nowrap><a href="<%=href%>" onClick="<portlet:namespace/>_replaceTimeZoneOffset(this)"><%=name%></a></td>
			<td valign="top" align="left" nowrap><%=desc%></td>
			<td valign="top" align="left"><%=acls%></td>
		</tr>
		<%
	}
	%>
        </table>
        </td>
    </tr>
    <tr>
        <td background="<%= cs_imageDir %>/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<%= cs_imageDir %>/graphics/common/screen/dotclear.gif"/></td><td></td>
    </tr>
    </table>
</cs:ftcs>