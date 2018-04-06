<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%//
// FutureTense/Apps/AdminForms/UserMgt/DoModifyAtts
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.*" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="com.openmarket.directory.*" %>
<cs:ftcs>

<%
ArrayList toDelete = new ArrayList();
%>

<dir:replaceattrs name='<%=ics.GetVar("idkey")%>'>
<%
	String attNames = ics.GetVar("attNames");
	if (attNames != null)
	{
		for (StringTokenizer atttokens = new StringTokenizer(attNames, ";"); atttokens.hasMoreTokens();)
		{
			String nextAttName = atttokens.nextToken();
			String nextAtts = ics.GetVar(nextAttName);
			int i=0;
			if (nextAtts != null)
			{
				for (StringTokenizer valtokens = new StringTokenizer(nextAtts, ";"); valtokens.hasMoreTokens(); i++)
				{
					String nextAttValue = valtokens.nextToken();
%>
					<dir:argument name='<%=nextAttName%>' value='<%=nextAttValue%>'/>
<%
				}
			}
			if (i == 0)
			{
				toDelete.add(nextAttName);
			}
		}
	}
%>
</dir:replaceattrs>

<%
if (!toDelete.isEmpty())
{
%>

	<dir:removeattrs name='<%=ics.GetVar("idkey")%>'>
<%
	for (Iterator i = toDelete.iterator(); i.hasNext();)
	{
		String deleteAtt = (String) i.next();
		String deleteAttValue = ics.GetVar(deleteAtt + "orig");
		for (StringTokenizer atttokens = new StringTokenizer(deleteAttValue, ";"); atttokens.hasMoreTokens();)
		{
%>
			<dir:argument name='<%=deleteAtt%>' value='<%=atttokens.nextToken()%>'/>
<%
		}
	}
%>
	</dir:removeattrs>
<%
}
%>

<%
if (ics.GetVar("newAtt")!=null)
{
%>
	<dir:addattrs name='<%=ics.GetVar("idkey")%>'>
		<dir:argument name='<%=ics.GetVar("newAtt")%>' value='<%=ics.GetVar("newAttValue")%>'/>
	</dir:addattrs>
<%
}
%>

<ics:callelement element="FutureTense/Apps/AdminForms/UserMgt/ModifyAtts"/>

</cs:ftcs>
