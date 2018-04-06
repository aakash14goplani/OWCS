<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// OpenMarket/Gator/UIFramework/TreeAppletParamsCookie
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<%
String sessid = session.getId();
String param = null;
Cookie[] cookies = request.getCookies();
for(int i = 0; i < cookies.length; i++) {
    Cookie c = cookies[i];
    //Some app servers append extra values to session.getId() which are not part of cookie value.
    if (sessid.contains(c.getValue())) {
        if (param==null)
        {
            param=c.getName()+"="+c.getValue();
        }
        else
        {
            param += ";"+c.getName()+"="+c.getValue();
        }
    }
}
%>
<PARAM NAME="Cookie" VALUE='<%=param%>'/>
</cs:ftcs>