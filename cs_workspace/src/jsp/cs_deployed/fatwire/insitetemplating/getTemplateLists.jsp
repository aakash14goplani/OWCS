<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%><%//
// fatwire/insitetemplating/getTemplateLists
//
// INPUT
//
// OUTPUT
//
%><%@ page import="com.openmarket.xcelerate.interfaces.*" 
%><cs:ftcs>
<xlat:lookup key="dvin/UI/Common/NotApplicableAbbrev" varname="_NA_"/>
<%
String startMenuId = ics.GetVar("startmenuid");
IStartMenu sm = StartMenuFactory.make(ics);
IStartMenuItem smi = sm.getMenuItem(startMenuId);
String assettype = smi.getAssetType();
if ( "SiteEntry".equals(assettype)) {%>
    <name><ics:getvar name="_NA_"/></name>
<%} else if ("CSElement".equals(assettype)){%>
    <name><ics:getvar name="_NA_"/></name>
<%} else {%>
    <asset:list list='templatelist' type='Template' excludevoided='true' pubid='<%=ics.GetVar("siteid")%>' />    
    <ics:if condition='<%= ics.GetErrno() == 0 %>' >
    <ics:then>
        <ics:listloop listname='templatelist'>
            <ics:listget listname='templatelist' fieldname='subtype' output="type"/>
            <%
            if ( ics.GetVar( "type" ) != null && ics.GetVar( "type" ).equals( assettype) )
            {
            %>

            <name><ics:listget listname='templatelist' fieldname='name'/></name>
            <%  
            }
            %>
        </ics:listloop> 
        <ics:listloop listname='templatelist'>
            <ics:listget listname='templatelist' fieldname='subtype' output="type"/>
            <%
            if ( ics.GetVar( "type" ) == null || ics.GetVar( "type" ).length() == 0 )
            {
            %>
            <ics:listget listname='templatelist' fieldname='name' output="name"/>
            <%
            String name = ics.GetVar( "name" );
            name = "/" + name;
            %>
            <name><%=name%></name>
            <%  
            }
            %>
        </ics:listloop> 
    </ics:then>
    <ics:else>
    -101
    </ics:else>
    </ics:if>
<%}%>
</cs:ftcs>
