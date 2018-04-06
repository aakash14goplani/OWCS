<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Search/Event
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
<%@ page import="com.fatwire.search.util.AssetQueueIndexSourceUtil" %>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urltimeouterror">
</satellite:link>
<%
    boolean user = ics.UserIsMember( "SiteGod,xceladmin" );
    if ( !user )
    {
%>
        <script LANGUAGE="JavaScript">
            parent.parent.location='<%=ics.GetVar("urltimeouterror")%>';
        </script>
<%
        ics.ThrowException();
    }
%>      
<html>
<body>
<%

    String imgdir = ics.GetProperty( "xcelerate.imageurl", "futuretense_xcel.ini", true);

%>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Search/SearchEnableIndexing"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<P/>
 	
 <table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-50">
	<tr>
	  <td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tr>
				<td colspan="3">																  
					<DIV class="form-label-inset">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<xlat:stream key="dvin/UI/Search/SearchEventScreenDescription" encode="false"/>
							</td>
						</tr>
						</table>
					</DIV>
				</td>
			</tr>
		</table>
	  </td>
	</tr>
</table>

<div class="width-outer-70">	
<table>
    <tr><td>
<%
   // ICS ics = null;
    String toEnable = ics.GetVar( "toEnable");
    if ( null != toEnable )
    {
        if ( "true".equals( toEnable ))
        {
            ics.EnableEvent( "SearchIndexEvent" );
        }
        else
        {
            ics.DisableEvent( "SearchIndexEvent" );   
        }
    }

    IList eventList = ics.ReadEvent("SearchIndexEvent", "eventList");
    if (null != eventList && eventList.hasData())
    {
        String enabled = eventList.getValue( "enabled" );
        if ( "true".equals( enabled))
        {
%>
    <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Search/EnableEvent" outstring="EnableURL">
        <satellite:argument name="toEnable" value="false"/>
    </satellite:link>
    <xlat:lookup  key="dvin/UI/Admin/DisableSearchEngine" varname="_XLAT_" encode="false"/>
    <%
        String _XLAT_ = ics.GetVar(  "_XLAT_" );
    %>
    <a href='<%=ics.GetVar("EnableURL")%>' onmouseover='window.status="<%=_XLAT_%>";return true;' onmouseout='windowstatus=""; return true;'>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/StopSearchEngine"/></ics:callelement>
    </a>
<%
        }
        else
        {
%>
    <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Search/EnableEvent" outstring="EnableURL">
        <satellite:argument name="toEnable" value="true"/>
    </satellite:link>
    <xlat:lookup  key="dvin/UI/Admin/EnableSearchEngine" varname="_XLAT_" encode="false"/>
    <%
        String _XLAT_ = ics.GetVar( "_XLAT_");
    %>
    <a href='<%=ics.GetVar("EnableURL")%>' onmouseover='window.status="<%=_XLAT_%>";return true;' onmouseout='windowstatus=""; return true;'>
        <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/StartSearchEngine"/></ics:callelement>
    </a>    
<%
        }
    }
%>
    </td></tr>
</table>
</div>
</body>
</html>

</cs:ftcs>