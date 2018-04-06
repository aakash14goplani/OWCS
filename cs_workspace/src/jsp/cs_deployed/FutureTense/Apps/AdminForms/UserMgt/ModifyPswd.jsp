<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// FutureTense/Apps/AdminForms/UserMgt/ModifyPswd
// This element is used to modify the current logged in user password
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
<%
	String userPass = ics.GetVar("password");
	String oldPass = ics.GetVar("oldpassword");
	if (Utilities.goodString(userPass))
	{
		boolean oldPasswordChecksOut = true;
		AccessEngineWrapper accessEngine = Factory.getAccessEngine(ics);
		oldPasswordChecksOut = accessEngine.checkUser(ics.GetVar("username"), oldPass);
		if (oldPasswordChecksOut) {
%>
			<xlat:stream key="dvin/UI/CSAdminForms/Resettingpassword" encode="false"/>
			<ics:clearerrno/>
			<dir:replaceattrs name='<%=ics.GetVar("userid")%>'>
				<dir:argument name='<%=ics.GetVar("passwordattr")%>' value='<%=userPass%>'/>
			</dir:replaceattrs>
			<% int errno = ics.GetErrno(); %>
			<xlat:lookup key="dvin/Common/Success" varname="_xlat_success"/>
			<xlat:lookup key="dvin/Common/Error" varname="_xlat_error"/>         
			
			<%= errno == 0 ? (String)ics.GetVar("_xlat_success") : (String)ics.GetVar("_xlat_error")  + errno %>
<%
		}
		else {
%>
			<xlat:lookup key="dvin/Common/Error" varname="_xlat_error"/>
			<xlat:lookup key="fatwire/admin/error/user/OldPwdNotMatching" varname="_old_pswd_dint_match_"/>
			<%= (String)ics.GetVar("_xlat_error") + " : " + (String)ics.GetVar("_old_pswd_dint_match_") %>
<%
		}
	}
%>

</cs:ftcs>
