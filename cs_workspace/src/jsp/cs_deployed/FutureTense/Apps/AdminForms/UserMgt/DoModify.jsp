<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// FutureTense/Apps/AdminForms/UserMgt/DoModify
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.*" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.CS.Factory" %>
<%@ page import="COM.FutureTense.Access.AccessEngineWrapper" %>
<cs:ftcs>

<ics:getproperty name="groupparent" file="dir.ini" output="groupparentattr"/>
<ics:getproperty name="cn" file="dir.ini" output="groupnameattr"/>
<ics:getproperty name="password" file="dir.ini" output="passwordattr"/>
<string:encode variable="acl" varname="acl"/>
<string:encode variable="oldacls" varname="oldacls"/>
<string:encode variable="username" varname="username"/>
<%
	StringTokenizer tokenizer = null;
	Map<String, String> newACLs = new HashMap<String, String>();
	String sACLs = ics.GetVar("acl");
	if (sACLs != null)
	{
		tokenizer = new StringTokenizer(sACLs, ",");
		while (tokenizer.hasMoreElements())
		{
			String nextACL = tokenizer.nextToken();
			nextACL = nextACL.trim();
			newACLs.put(nextACL, nextACL);
		}
	}

	Map<String, String> oldACLs = new HashMap<String, String>();
	sACLs = ics.GetVar("oldacls");
	if (sACLs != null)
	{
		tokenizer = new StringTokenizer(sACLs, ",");
		while (tokenizer.hasMoreElements())
		{
			String nextACL = tokenizer.nextToken();
			nextACL = nextACL.trim();
			oldACLs.put(nextACL, nextACL);
		}
	}

	List<String> toDelete = new ArrayList<String>();
	List<String> toAdd = new ArrayList<String>();

	for (Iterator i = newACLs.keySet().iterator(); i.hasNext();)
	{
		String newACL = (String)i.next();
		if (oldACLs.get(newACL) == null)
			toAdd.add(newACL);
	}
	for (Iterator i = oldACLs.keySet().iterator(); i.hasNext();)
	{
		String oldACL = (String)i.next();
		if (newACLs.get(oldACL) == null)
			toDelete.add(oldACL);
	}
	String severity = "info";
%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
		<tr><td>
			<span class="title-text"><xlat:stream key="dvin/UI/CSAdminForms/ModifyingACLs"/></span>
		</td></tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<div class="width-outer-70">
	<xlat:lookup key="dvin/Common/Success" varname="_xlat_success"/>
    <xlat:lookup key="dvin/Common/Error" varname="_xlat_error"/>
	<%
	boolean bDidOne=false;
	for (Iterator i = toDelete.iterator(); i.hasNext(); bDidOne=true)
	{
		String nextACL = (String) i.next();
		StringBuilder build = new StringBuilder();
		severity = "info";
%>
		<ics:setvar name="aclName" value='<%="<b>"+nextACL+"</b>"%>'/>
		<xlat:lookup key="dvin/UI/CSAdminForms/Removing" varname="_xlat_removing" encode="false"/> 
<%		
		build.append(ics.GetVar("_xlat_removing"));
		build.append("<br/>");
%>		
		<ics:clearerrno/>
		<name:makechild context='<%=ics.GetVar("groupparentattr")%>' output="groupid">
			<name:argument name='<%=ics.GetVar("groupnameattr")%>' value='<%=nextACL%>'/>
		</name:makechild>
		<dir:removegroupmember name='<%=ics.GetVar("groupid")%>' member='<%=ics.GetVar("userid")%>'/>
		<% 
		int errno = ics.GetErrno(); 
        if(errno == 0){
			build.append(ics.GetVar("_xlat_success") );
		}else{
			build.append( ics.GetVar("_xlat_error")  + errno );
			severity = "error";
        }%>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=build.toString()%>'/>
			<ics:argument name="severity" value='<%=severity%>'/>
		</ics:callelement>
	<%}
	for (Iterator i = toAdd.iterator(); i.hasNext();)
	{
		String nextACL = (String) i.next();
		StringBuilder build = new StringBuilder();
		severity = "info";		
%>
		<ics:setvar name="aclName" value='<%="<b>"+nextACL+"</b>"%>'/>
		<xlat:lookup key="dvin/UI/CSAdminForms/Assigning" varname="_xlat_assigning"  encode="false"/> 
<%
		build.append(ics.GetVar("_xlat_assigning"));
		build.append("<br/>");
%>		<ics:clearerrno/>
		<name:makechild context='<%=ics.GetVar("groupparentattr")%>' output="groupid">
			<name:argument name='<%=ics.GetVar("groupnameattr")%>' value='<%=nextACL%>'/>
		</name:makechild>
		<dir:addgroupmember name='<%=ics.GetVar("groupid")%>' member='<%=ics.GetVar("userid")%>'/>
		<% 
		int errno = ics.GetErrno(); 
        if(errno == 0){
			build.append(ics.GetVar("_xlat_success") );
		}else{
			build.append( ics.GetVar("_xlat_error")  + errno );
			severity = "error";
        }%>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=build.toString()%>'/>
			<ics:argument name="severity" value='<%=severity%>'/>
		</ics:callelement>
<%
	}
%>
	<xlat:lookup key="dvin/Common/Success" varname="_xlat_done"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("_xlat_done")%>'/>
		<ics:argument name="severity" value="info"/>
	</ics:callelement>
<%
	String userPass = ics.GetVar("password");
	if (Utilities.goodString(userPass))
	{
%>
		<xlat:lookup key="dvin/UI/CSAdminForms/Resettingpassword" varname="_xlat_resettingpwd" encode="false"/>
<%	
		StringBuilder build = new StringBuilder();
		severity = "info";
%>	
			<ics:clearerrno/>
			<dir:replaceattrs name='<%=ics.GetVar("userid")%>'>
				<dir:argument name='<%=ics.GetVar("passwordattr")%>' value='<%=userPass%>'/>
			</dir:replaceattrs>
			<% 
			build.append(ics.GetVar("_xlat_resettingpwd"));
			int errno = ics.GetErrno(); 
			if(errno == 0){
				build.append(ics.GetVar("_xlat_success") );
			}else{
				build.append( ics.GetVar("_xlat_error")  + errno );
				severity = "error";
			}%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=build.toString()%>'/>
				<ics:argument name="severity" value='<%=severity%>'/>
			</ics:callelement>
<%}%>
</cs:ftcs>
