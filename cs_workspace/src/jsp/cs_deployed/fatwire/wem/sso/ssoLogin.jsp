<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/sso/ssoLogin
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.fatwire.security.common.EncodedParameterMap" %>
<cs:ftcs>
<%
FTValList list = new FTValList();
list.setValString(ftMessage.verb, ftMessage.login);
Map<String,String> input = EncodedParameterMap.decode(ics.GetVar("payload")); 
list.setValString(ftMessage.username, input.get("username"));
list.setValString(ftMessage.password, input.get("password"));
ics.CatalogManager(list);
Map<String, String> map = new HashMap<String, String>();
	if (ics.GetErrno() == 0)
        {
		   map.put("status" , "success");
		   map.put(ftMessage.curUserID , ics.GetSSVar(ftMessage.curUserID));
		   map.put(ftMessage.curUserACL, ics.GetSSVar(ftMessage.curUserACL)); 
		   String cstimeout = ics.GetProperty("cs.timeout","futuretense.ini",false);
		   map.put("cstimeout", cstimeout);
		} else
		{
			map.put("status" , "failed");
		}
out.print(EncodedParameterMap.encode(map));
%>
</cs:ftcs>