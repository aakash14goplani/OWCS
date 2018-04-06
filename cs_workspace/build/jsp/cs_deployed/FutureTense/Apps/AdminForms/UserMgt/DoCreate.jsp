<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>

<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="com.openmarket.directory.*"%>

<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<string:encode variable="username" varname="username"/>
<string:encode variable="useracl" varname="useracl"/>
<HTML>
<HEAD><TITLE>Add User</TITLE></HEAD>
<BODY>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/CSAdminForms/AddingUser"/> <ics:getvar name="username"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<div class="width-outer-70">  
<xlat:lookup key="dvin/Common/Success" varname="_xlat_success"/>
<xlat:lookup key="dvin/Common/Error" varname="_xlat_error"/>       
<ics:clearerrno/>

<!-- 

Load the names of the user attributes

-->

	<!-- username and password attribute names are in dir.ini -->
	<ics:getproperty name='<%=DirProperties.attrUsername%>' file="dir.ini" output="loginnameattr"/>
	<ics:getproperty name='<%=DirProperties.attrPassword%>' file="dir.ini" output="passwordattr"/>

<!--

Search if user already exists 

-->
	<!-- get the naming scheme's base name for users -->
	<ics:getproperty name='<%=DirProperties.peopleParent%>' file="dir.ini" output="namebase"/>
	<dir:search list="ResultsList" operator="and" context='<%=ics.GetVar("namebase")%>'>
		<dir:argument name='<%=ics.GetVar("loginnameattr")%>' value='<%=ics.GetVar("username")%>'/>
	</dir:search>
<ics:listget listname="ResultsList" fieldname="#numRows" output="numRows"/>
<% 
String severity="info";
int rows =Integer.parseInt(ics.GetVar("numRows"));
if( 0 == rows )
{
%>

<!--

Create a new "name" for the user

-->



	<!-- create a new child name from the user's base name -->
	<name:makechild context='<%=ics.GetVar("namebase")%>' output="newname">
		<name:argument name='<%=ics.GetVar("loginnameattr")%>' value='<%=ics.GetVar("username")%>'/>
	</name:makechild>


<!--

Create the user using the new name

-->

	<!-- get the property for required user attributes -->
	<ics:getproperty name="requiredPeopleAttrs" file="dir.ini" output="requiredPeopleAttrs"/>

	<!-- create the user -->
	<dir:create name='<%=ics.GetVar("newname")%>' defaults='<%=ics.GetProperty("defaultPeopleAttrs", "dir.ini", true)%>'>
		<!-- set the login name attribute to the loginid passed into this element -->
		<dir:argument name='<%=ics.GetVar("loginnameattr")%>' value='<%=ics.GetVar("username")%>'/>
		<!-- set the user's password attribute to the loginpassword passed into this element -->
		<dir:argument name='<%=ics.GetVar("passwordattr")%>' value='<%=ics.GetVar("password")%>'/>

		<!-- fill in the required user attribute values sent from Create -->
<%
		String requiredPeopleAttrs= ics.GetVar("requiredPeopleAttrs");
            StringTokenizer attpairs = new StringTokenizer(requiredPeopleAttrs, "&");
		while (attpairs.hasMoreTokens())
		{
			String attpair = attpairs.nextToken();
			StringTokenizer attvalues = new StringTokenizer(attpair, "=");
			String attName = null;
			try
			{
				attName = java.net.URLDecoder.decode(attvalues.nextToken());
			}
			catch (Exception e) {}
        
			if (attName != null)
			{
%>
				<dir:argument name="<%=attName%>" value="<%=(String)ics.GetVar(attName)%>"/>
<%
			}
		}
%>
	</dir:create>

<% 
int errno = ics.GetErrno(); 
String msgtext="";

if(errno == 0){
	msgtext = ics.GetVar("_xlat_success") ;
}else{
	msgtext = ics.GetVar("_xlat_error")  + errno ;
	severity = "error";
}%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
	<ics:argument name="msgtext" value='<%=msgtext%>'/>
	<ics:argument name="severity" value='<%=severity%>'/>
</ics:callelement>

<!--

If the user create succeeded, assign the user to the ACLs passed in

-->

<%
if (errno >= 0)
{
	String nextACL = null;
	Enumeration enumeration = new StringTokenizer(ics.GetVar("useracl"), ",");
	while (enumeration.hasMoreElements())
	{
		nextACL = (String)enumeration.nextElement();
		StringBuilder build = new StringBuilder();
		severity = "info";
%>
<ics:setvar name="aclName" value='<%="<b>"+nextACL+"</b>"%>'/>
<xlat:lookup key="dvin/UI/CSAdminForms/Assigning"  varname="_xlat_assigning" encode="false"/>
<%
		build.append(ics.GetVar("_xlat_assigning"));
		build.append("<br/>");
%>
<ics:clearerrno/>

<name:makechild context="<%=DirProperties.getRequiredProperty(ics, DirProperties.groupParent)%>" output="groupid">
	<dir:argument name="<%=DirProperties.getRequiredProperty(ics, DirProperties.attrCn)%>" value="<%=nextACL%>"/>
</name:makechild>

<dir:addgroupmember name='<%=ics.GetVar("groupid")%>' member='<%=ics.GetVar("newname")%>'/>
<%
		int errorno = ics.GetErrno(); 
        if(errorno == 0){
			build.append(ics.GetVar("_xlat_success") );
			severity = "info";
		}else{
			build.append( ics.GetVar("_xlat_error")  + errorno );
			severity = "error";
        }%>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=build.toString()%>'/>
			<ics:argument name="severity" value='<%=severity%>'/>
		</ics:callelement>
<%
	}	// while (enumeration.hasMoreElements())
}// if (errno >= 0)
}
else
{
%><xlat:lookup key="dvin/AdminForms/UserAlreadyExists" varname="_xlat_user"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("_xlat_user")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%
} 
%>
<div>
</BODY>
</HTML>

</cs:ftcs>

