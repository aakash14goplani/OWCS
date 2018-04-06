<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld" 
%>
<cs:ftcs>
<%-- This is a utility element designed to look up a given user and create a
     list representing the user if successfully found.
	 
	 The only required parameter is username.  Typical usages of this element
	 are for logging in (in which case password must also be specified), and 
	 for loading a user for the purpose of modifying the user's profile. 
	 
	 It is obviously mean to be called only with a global scope.
	 
	 First, record the standard deps
--%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%-- Create the searchstate --%>
<searchstate:create name="theUserSS"/>
<render:lookup key="VisitorAttrType" varname="VisitorAttrType" ttype="CSElement" />
<render:lookup key="UserAttr" match=":x" varname="UserAttr" ttype="CSElement" />

<searchstate:addsimplestandardconstraint name="theUserSS" typename='<%=ics.GetVar("VisitorAttrType")%>' attribute='<%=ics.GetVar("UserAttr")%>' value='<%= ics.GetVar("username") %>'/>
<ics:if condition='<%= ics.GetVar("password")!=null %>' >
<ics:then>
    <render:lookup key="PasswordAttr" match=":x" varname="PasswordAttr" ttype="CSElement" />
    <searchstate:addsimplestandardconstraint name="theUserSS" typename='<%=ics.GetVar("VisitorAttrType")%>' attribute='<%=ics.GetVar("PasswordAttr")%>' value='<%= ics.GetVar("password") %>'/>
</ics:then>
</ics:if>

<%-- Create the assetset --%>
<render:lookup key="VisitorType" varname="VisitorType" ttype="CSElement" />
<assetset:setsearchedassets name="theUserAS" assettypes='<%=ics.GetVar("VisitorType")%>' constraint="theUserSS"/>
<%-- Retrieve the list of assets and set it into the variable specified --%>
<assetset:getassetlist name="theUserAS" listvarname='<%= ics.GetVar("listname") %>'/>
</cs:ftcs>