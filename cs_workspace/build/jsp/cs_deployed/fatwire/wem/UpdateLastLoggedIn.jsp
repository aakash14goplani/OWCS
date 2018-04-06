<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/UpdateLastLoggedIn
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
<%@ page import="com.fatwire.assetapi.site.UserLoggedInInfo"%>
<%@ page import="com.fatwire.assetapi.site.User"%>
<%@ page import="com.fatwire.assetapi.site.UserImpl"%>
<%@ page import="java.sql.Timestamp"%>

<cs:ftcs>
<%
String username = ics.GetSSVar("username");
if(username != null){
	UserLoggedInInfo loggedInInfo = new UserLoggedInInfo(ics);
	User user = new UserImpl();
	user.setName(username);
	loggedInInfo.populateLastLoggedInDetails(user);
	if(user.getLastLoggedIn() != null){
		loggedInInfo.updateLastLoggedIn(user);
	} else {
		loggedInInfo.addlastLoggedIn(user);
	}
	//Retrieve the last logged in timestamp
	loggedInInfo.populateLastLoggedInDetails(user);
	Timestamp lastloggedin = user.getLastLoggedIn();
	out.write("{'user':'" + username + "','lastloggedin':'" + lastloggedin + "'}");
}
%>
</cs:ftcs>