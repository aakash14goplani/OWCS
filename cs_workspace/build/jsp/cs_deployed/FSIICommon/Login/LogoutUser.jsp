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

    <%-- log the user out --%>
    <ics:removessvar name="VisitorUserName"/>
    <ics:removessvar name="VisitorID"/>

    <%-- log the user out of engage, if engage core is installed --%>
    <render:lookup site='<%=ics.GetVar("site")%>' match=":x" varname="LogoutUserEngage" key="LogoutUserEngage" ttype="CSElement" tid='<%=ics.GetVar("eid")%>'/>
    <ics:if condition='<%=ics.GetVar("LogoutUserEngage") != null %>'>
        <ics:then>
            <render:callelement elementname='<%=ics.GetVar( "LogoutUserEngage" ) %>'/>
        </ics:then>
    </ics:if>

</cs:ftcs>