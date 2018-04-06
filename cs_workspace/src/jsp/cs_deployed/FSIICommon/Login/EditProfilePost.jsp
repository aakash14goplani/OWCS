<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
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
    <%-- This element sets the remaining data to call RemoteContentPost to modify the current user.
      While RemoteContentPost is *usually* used by XMLPost, doing so is not necessary.  The
      element is ideal for modifying individual asset fields such as through a form like this.
      In fact, the variables currently in-scope plus the variables defined below can be gathered
      up and posted to a remote Content Server installation (like the editorial environment) and
      then published back to this system once the user has been approved. --%>
    <%-- Create session variable to alert RemoteContentPost that a user is already logged on --%>
    <ics:setssvar name="AlreadyLoggedIn" value="true"/>

    <%-- Grab the visitor type from the reference list --%>
    <render:lookup key="VisitorType" varname="_ASSET_" ttype="CSElement"/>

    <%-- Publication info is passed into the CSElement --%>
    <ics:setvar name="publication" value='<%=ics.GetVar("site")%>'/>

    <%-- This is the edit version, so the action is update --%>
    <ics:setvar name="Action" value="update"/>

    <%-- The user's id is stored in session --%>
    <ics:setvar name="id" value='<%=ics.GetSSVar("VisitorID")%>'/>

    <%-- Look up the content definition type --%>
    <render:lookup key="VisitorDefName" match=":x" varname="_DEFINITION_" ttype="CSElement"/>

    <%-- Figure out the asset's name by querying the table.  We have ID but RemoteContentPost needs name --%>
    <asset:list type='<%=ics.GetVar("_ASSET_")%>' list="namelist">
        <asset:argument name="id" value='<%=ics.GetVar("id")%>'/>
    </asset:list>
    <ics:setvar name="_ITEMNAME_" value='<%=ics.GetList("namelist").getValue("name")%>'/>

    <%-- Call RemoteContentPost to update the data
         Hide the locale variable though RemoteContentPost does not get 
         confused. --%>
    <ics:setvar name="localedimid" value='<%=ics.GetVar("locale")%>'/>
    <ics:removevar name="locale" />
    <ics:callelement element="OpenMarket/Xcelerate/Actions/RemoteContentPost"/>
    <ics:setvar name="locale" value='<%=ics.GetVar("localedimid")%>' />
    <ics:removevar name="localedimid" />

    <%-- finally, update the visitor object --%>
    <ics:if condition='<%=ics.GetErrno() >= 0%>'>
        <ics:then>
            <render:lookup key="SetEngageUserInfo" match=":x" varname="SetEngageUserInfo" ttype="CSElement"/>
            <ics:if condition='<%=ics.GetVar("SetEngageUserInfo") != null%>'>
                <ics:then>
                    <render:callelement elementname='<%=ics.GetVar("SetEngageUserInfo")%>'>
                        <ics:argument name="VisitorUserName" value='<%= ics.GetSSVar("VisitorUserName") %>'/>
                        <ics:argument name="VisitorID" value='<%= ics.GetSSVar("VisitorID") %>'/>
                    </render:callelement>
                </ics:then>
            </ics:if>
        </ics:then>
        <ics:else>User modification failed, visitor object not updated.</ics:else>
    </ics:if>
</cs:ftcs>