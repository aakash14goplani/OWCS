<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="user" uri="futuretense_cs/user.tld" %>
<%//
// csdt/CSDTService
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

<%@page import="com.fatwire.csdt.service.valueobject.ServiceQueryValueObject"%>
<%@page import="com.fatwire.csdt.service.CSDTService"%>
<%@page import="com.fatwire.csdt.service.factory.CSDTServicefactory"%>
<%@page import="com.fatwire.csdt.service.impl.ExportService"%>
<%@page import="com.fatwire.csdt.service.util.CSDTServiceUtil, java.util.*, java.io.StringWriter, java.io.PrintWriter"%>
<cs:ftcs>
<%
	String userName = ics.GetVar("username");
	String password = ics.GetVar("password");
	
	if ( ( userName != null ) && ( userName.trim().length() > 0 ) 
			&& ( password != null ) && ( password.trim().length() > 0 ) ){
%>
		<user:login username='<%=userName %>' password='<%=password %>'/>
<% }

    if (ics.GetErrno() == 0)
    {
        FTValList updateVal = new FTValList();
        updateVal.setValString(ftMessage.verb, ftMessage.login);
        updateVal.setValString(ftMessage.username, userName);
        updateVal.setValString(ftMessage.password, password);
        updateVal.setValString(ftMessage.cstimeout, "-1");
        ics.CatalogManager(updateVal);

        boolean isMember = ics.UserIsMember("xceladmin");

        if (isMember)
        {
            List<String> errorList = new ArrayList<String>();
            ServiceQueryValueObject valueObject = new ServiceQueryValueObject();
            try
            {
                valueObject.setIds(ics.GetVar("resources"));
                valueObject.setFileName(ics.GetVar("filename"));
                valueObject.setDataStoreName(ics.GetVar("datastore"));
                valueObject.setIsDeps(!"false".equalsIgnoreCase(ics.GetVar("includeDeps")));
                valueObject.setIsRemote("true".equalsIgnoreCase(ics.GetVar("remote")));
                valueObject.setIsIdMapping(!"false".equalsIgnoreCase(ics.GetVar("idMapping")));
                String siteNames = ics.GetVar("fromSites");
                valueObject.setSourceSiteNames(siteNames);
                valueObject.setTargetSiteNames(ics.GetVar("toSites"));
                valueObject.setModifiedSince(ics.GetVar("modifiedSince"));
                valueObject.setDSKeys(ics.GetVar("dskeys"));
                valueObject.setServletResponse(response);
                String command = ics.GetVar("command");
                CSDTService service = null;
                service = CSDTServicefactory.getService(command);
                errorList = service.execute(ics, valueObject);
            }
            catch (Throwable t)
            {
                Throwable cause = t;
                Throwable tempCause = t.getCause();
                while (tempCause != null && cause != tempCause)
                {
                    cause = tempCause;
                    tempCause = tempCause.getCause();
                }

                StringWriter pw = new StringWriter();
                cause.printStackTrace(new PrintWriter(pw));
                String errorMsg = "EXCEPTION THROWN: " + cause.getMessage() + "\n" + pw.getBuffer().toString();
                errorList.add(errorMsg.replaceAll("\n", "<br/>"));
                ics.LogMsg(errorMsg);
            }

%><%=valueObject.getResponse()%><br/><%
    
            if (errorList.isEmpty())
            {%>
Success
<%
		} else {
			for ( String errorMsg : errorList ){
%>
<%=errorMsg %> 
<%				
			}
		}
	} else { 
%>
	Insufficient Privileges	
<%
	}
} else {
%>
Login Error: <%=ics.GetErrno() %>
<%
}

    FTValList list = new FTValList();
    list.setValString(ftMessage.verb, ftMessage.logout);
    list.setValString(ftMessage.killsession, ftMessage.truestr);
    ics.CatalogManager(list);
%>
</cs:ftcs>