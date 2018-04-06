<%@ page import="com.openmarket.xcelerate.interfaces.IUserManager" %>
<%@ page import="com.openmarket.xcelerate.interfaces.UserManagerFactory" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"%>
<%//
// OpenMarket/Xcelerate/Util/GetUsernameList
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs><%
    String[] IDlist= (request.getParameter("listusers")).split(";");
    IUserManager um = UserManagerFactory.make(ics);
    for ( int i=0; i<IDlist.length; i++)
    {
        if (i>0)
            out.println(",");
        out.print(um.getDisplayableUserName(IDlist[i]));
    }
%></cs:ftcs>