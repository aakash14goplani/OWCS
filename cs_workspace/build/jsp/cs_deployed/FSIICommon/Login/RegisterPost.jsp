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
    <%-- This element sets the remaining data to call RemoteContentPost to add the new user.
      While RemoteContentPost is *usually* used by XMLPost, doing so is not necessary.  The
      element is ideal for adding individual assets through a form like this.
      In fact, the variables currently in-scope plus the variables defined below can be gathered
      up and posted to a remote Content Server installation (like the editorial environment) and
      then published back to this system once the user has been approved. --%>

    <%-- Look up the userid the user specified - it better not already exist! --%>
    <render:lookup key="FindUser" match=":x" varname="FindUserCSElement" ttype="CSElement"/>
    <%-- We call with local scope because we don't want variable leakage, but we do want
      the list to be set.  However, lists aren't in the variable pool.... --%>
    <render:lookup key="UsernameAttr" match=":x" varname="UsernameAttrName" ttype="CSElement"/>
    <render:callelement scoped="local" elementname='<%=ics.GetVar("FindUserCSElement")%>'>
        <render:argument name="listname" value="theUserList"/>
        <render:argument name="username" value='<%= ics.GetVar(ics.GetVar("UsernameAttrName")) %>'/>
    </render:callelement>

    <ics:if condition='<%= ics.GetList("theUserList") != null && ics.GetList("theUserList").hasData() %>'>
        <ics:then>
            <p>A user with that username already exists. Please choose another name.</p>
            <%-- Set the variable for the form to render back to the register form so the user can re-try --%>
            <render:packargs outstr="packedargs" packedargs='<%=ics.GetVar("packedargs")%>'>
                <render:argument name="form-to-render" value="RegisterForm"/>
            </render:packargs>
        </ics:then>
        <ics:else>

            <%-- Create session variable to alert RemoteContentPost that a user is already logged on --%>
            <ics:setssvar name="AlreadyLoggedIn" value="true"/>

            <%-- Grab the visitor type from the reference list --%>
            <render:lookup key="VisitorType" varname="_ASSET_" ttype="CSElement"/>

            <%-- Publication info is passed into the CSElement --%>
            <ics:setvar name="publication" value='<%=ics.GetVar("site")%>'/>

            <%-- This is the edit version, so the action is update --%>
            <ics:setvar name="Action" value="addrow"/>

            <%-- Look up the content definition type --%>
            <render:lookup key="VisitorDefName" match=":x" varname="_DEFINITION_" ttype="CSElement"/>

            <%-- Automatically invent the name based on the user's input --%>
            <render:lookup key="FirstNameAttr" match=":x" varname="FirstNameAttrName" ttype="CSElement"/>
            <render:lookup key="LastNameAttr" match=":x" varname="LastNameAttrName" ttype="CSElement"/>
            <ics:setvar name="_ITEMNAME_" value='<%=ics.GetVar(ics.GetVar("LastNameAttrName")) + ", " + ics.GetVar(ics.GetVar("FirstNameAttrName"))%>'/>

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
                                <ics:argument name="VisitorID" value='<%= ics.GetVar("id") %>'/>
                                <ics:argument name="VisitorUserName" value='<%= ics.GetVar(ics.GetVar("UsernameAttrName")) %>'/>
                            </render:callelement>
                        </ics:then>
                    </ics:if>
                </ics:then>
                <ics:else>User registration failed, visitor object not updated.</ics:else>
            </ics:if>
        </ics:else>
    </ics:if>
</cs:ftcs>