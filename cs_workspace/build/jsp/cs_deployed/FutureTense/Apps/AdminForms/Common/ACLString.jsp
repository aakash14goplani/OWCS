<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="acl" uri="futuretense_cs/acl.tld" %>

<%//
// FutureTense/Apps/AdminForms/Common/ACLString
//
// INPUT
// userid - the IName for the user
//
// OUTPUT
// aclString - comma separated list of groups to which the user belongs
//%>
<%@ page import="java.util.*" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="com.openmarket.directory.*" %>
<cs:ftcs>

<dir:groupmemberships name='<%=ics.GetVar("userid")%>' list="groups"/>
<ics:getproperty name="cn" file="dir.ini" output="groupnameattr"/>
<%
	StringBuffer aclString = new StringBuffer();
	IList groupList = ics.GetList("groups");
	if ( (groupList != null) && (groupList.hasData()) )
	{
	boolean bDidOne = false;
	for (int i=0; groupList.moveToRow(IList.gotorow, i+1); i++)
	{
		ics.SetVar("groupname", groupList.getValue("NAME"));
%>
		<dir:getattrs list="groupatts" name='<%=ics.GetVar("groupname")%>' attrs='<%=ics.GetVar("groupnameattr")%>'/>
<%
		IList atts = ics.GetList("groupatts");
%>
		<acl:load name="exists" acl='<%=atts.getValue("VALUE")%>'/>
<%
		if (ics.GetObj("exists") != null)
		{
			if (bDidOne)
				aclString.append(", ");
			else
				bDidOne = true;

			aclString.append(atts.getValue("VALUE"));
		}
	}
	}
	ics.SetVar("aclString", aclString.toString());
%>

</cs:ftcs>
