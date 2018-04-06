<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<cs:ftcs>
    <ics:if condition='<%=ics.GetVar("seid")!=null%>'>
        <ics:then>
            <render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/>
        </ics:then>
    </ics:if>
    <ics:if condition='<%=ics.GetVar("eid")!=null%>'>
        <ics:then>
            <render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/>
        </ics:then>
    </ics:if>

    <%-- This element takes incoming ICS variables and creates the user
         based on that information.  If CS Engage is present (and the Engage Core
         module is installed) then it will also call an element that will
         create the visitor object.

         It requires the following input:
           - VisitorUserName
           - VisitorID
    --%>
    <ics:setssvar name="VisitorUserName" value='<%= ics.GetVar("VisitorUserName") %>'/>
    <ics:setssvar name="VisitorID" value='<%= ics.GetVar("VisitorID") %>'/>

    <%-- log the user into engage, if the engage core module is installed --%>
    <render:lookup match=":x" varname="LoginUserEngage" key="LoginUserEngage" ttype="CSElement" />
    <ics:if condition='<%=ics.GetVar("LoginUserEngage") != null %>'>
        <ics:then>
            <render:callelement elementname='<%=ics.GetVar( "LoginUserEngage" ) %>'>
                <render:argument name="VisitorUserName" value='<%= ics.GetVar("VisitorUserName") %>'/>
            </render:callelement>
        </ics:then>
    </ics:if>
</cs:ftcs>