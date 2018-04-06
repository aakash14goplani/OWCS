<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld" 
%><%@ taglib prefix="publication" uri="futuretense_cs/publication.tld" 
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" 
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>'   c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>'   c="CSElement"/></ics:then></ics:if>

<%-- This element looks up the attribute names for the visitor, then calls
     the shared user profile form.  No values will be specified so the form
	 will be blank. --%>
	 
<render:lookup key="UsernameAttr" match=":x" varname="UsernameAttrName" ttype="CSElement"/>
<render:lookup key="PasswordAttr" match=":x" varname="PasswordAttrName" ttype="CSElement"/>
<render:lookup key="FirstNameAttr" match=":x" varname="FirstNameAttrName" ttype="CSElement"/>
<render:lookup key="LastNameAttr" match=":x" varname="LastNameAttrName" ttype="CSElement"/>
<render:lookup key="AgeAttr" match=":x" varname="AgeAttrName" ttype="CSElement"/>
<render:lookup key="GenderAttr" match=":x" varname="GenderAttrName" ttype="CSElement"/>
<render:lookup key="MaritalStatusAttr" match=":x" varname="MaritalStatusAttrName" ttype="CSElement"/>
<render:lookup key="NumKidsHomeAttr" match=":x" varname="NumKidsHomeAttrName" ttype="CSElement"/>
<render:lookup key="NumCarsAttr" match=":x" varname="NumCarsAttrName" ttype="CSElement"/>
<render:lookup key="MedianIncomeAttr" match=":x" varname="MedianIncomeAttrName" ttype="CSElement"/>
<render:lookup key="OwnOrRentAttr" match=":x" varname="OwnOrRentAttrName" ttype="CSElement"/>

<%-- Now call the form which expects variables to be already in the scope --%>
<p>Complete the form below to register.  You will be notified when your account has been activated.</p>
<render:lookup key="UserProfileForm" varname="UserProfileForm" match=":x" ttype="CSElement"/>
<render:callelement elementname='<%=ics.GetVar("UserProfileForm")%>' scoped="global">
	<render:argument name="form-to-process" value="RegisterPost"/>
</render:callelement>
</cs:ftcs>