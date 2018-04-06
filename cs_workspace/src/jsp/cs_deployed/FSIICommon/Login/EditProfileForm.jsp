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

<%-- This element displays the user's profile form so that it can be edited.
     It relies on session data to retrieve the current user's profile. --%>
	 
<%-- Create an assetset containing the current user only --%>
<render:lookup key="VisitorType" varname="VisitorType" ttype="CSElement"/>
<assetset:setasset name="visitor" type='<%=ics.GetVar("VisitorType")%>' id='<%=ics.GetSSVar( "VisitorID" )%>' />

<%-- Get all of the important attributes out of the assetset and read the data.

     First, look up all of the attribute names.  We have to look them up because
	 if the Visitor asset type is copied or shared, some attribute names will change.
	 By looking it up in the CSElement's Map table, there is no danger that 
	 an attribute's name change will break the template. --%>

<render:lookup key="VisitorAttrType" varname="VisitorAttrType" ttype="CSElement"/>
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
<assetset:getmultiplevalues name="visitor" prefix="vis" immediateonly="true" byasset="false">
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("UsernameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("PasswordAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("FirstNameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("LastNameAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("AgeAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("GenderAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("MaritalStatusAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("NumKidsHomeAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("NumCarsAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("MedianIncomeAttrName")%>'/>
	<assetset:sortlistentry attributetypename='<%=ics.GetVar("VisitorAttrType")%>' attributename='<%=ics.GetVar("OwnOrRentAttrName")%>'/>
</assetset:getmultiplevalues>

<%-- Now extract the relevant variables from the list so we can use them easily --%>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("UsernameAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("UsernameAttrName")%>' fieldname="value" output='<%=ics.GetVar("UsernameAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("PasswordAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("PasswordAttrName")%>' fieldname="value" output='<%=ics.GetVar("PasswordAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("FirstNameAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("FirstNameAttrName")%>' fieldname="value" output='<%=ics.GetVar("FirstNameAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("LastNameAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("LastNameAttrName")%>' fieldname="value" output='<%=ics.GetVar("LastNameAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("AgeAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("AgeAttrName")%>' fieldname="value" output='<%=ics.GetVar("AgeAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("GenderAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("GenderAttrName")%>' fieldname="value" output='<%=ics.GetVar("GenderAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("MaritalStatusAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("MaritalStatusAttrName")%>' fieldname="value" output='<%=ics.GetVar("MaritalStatusAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("NumKidsHomeAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("NumKidsHomeAttrName")%>' fieldname="value" output='<%=ics.GetVar("NumKidsHomeAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("NumCarsAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("NumCarsAttrName")%>' fieldname="value" output='<%=ics.GetVar("NumCarsAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("MedianIncomeAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("MedianIncomeAttrName")%>' fieldname="value" output='<%=ics.GetVar("MedianIncomeAttrName")%>'/></ics:then></ics:if>
<ics:if condition='<%=ics.GetList("vis:"+ics.GetVar("OwnOrRentAttrName")) != null%>'><ics:then><ics:listget listname='<%="vis:"+ics.GetVar("OwnOrRentAttrName")%>' fieldname="value" output='<%=ics.GetVar("OwnOrRentAttrName")%>'/></ics:then></ics:if>

<%-- Now call the form which expects variables to be already in the scope --%>
<render:lookup key="UserProfileForm" varname="UserProfileForm" match=":x" ttype="CSElement"/>
<render:callelement elementname='<%=ics.GetVar("UserProfileForm")%>' scoped="global">
	<render:argument name="form-to-process" value="EditProfilePost"/>
</render:callelement>

</cs:ftcs>

