<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/sso/validateMultiticket
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.ObjectOutputStream" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="com.fatwire.wem.sso.cas.cache.MultiTicketStorage"%>
<%@ page import="com.fatwire.wem.sso.cas.cache.MultiTicketStorage.AssertionHolder"%>

<cs:ftcs>

<!-- user code here -->
<%
final String MULTITICKET_PARAM = "multiticket";
final String STREAM_MARKER_START = "Assertion:";
final String STREAM_MARKER_END = "EndAssertion.";
MultiTicketStorage mtStorage = MultiTicketStorage.getInstance();

// obtain the multiticket from the request
final String multiticket = request.getParameter(MULTITICKET_PARAM);

if(multiticket == null)
{
   // missing multiticket parameter
   response.sendError(400, "Missing multiticket parameter");
}
else 
{
    // Check if the multiticket is cached.
    AssertionHolder assertionHolder = mtStorage.get(multiticket);
    
    if(assertionHolder!=null)
    {
   		// convert object to bytes
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(baos);
        oos.writeObject(assertionHolder);
        
        // encode and write to out stream
        Base64 base64Decoder = new Base64(-1);
		String encodedAssertion = base64Decoder.encodeToString(baos.toByteArray());
		
		// adding markers
        ics.StreamText(STREAM_MARKER_START+encodedAssertion+STREAM_MARKER_END);
    }
    else
    {
    	 response.sendError(500, "No assertion found.");
    }
}
%>
</cs:ftcs>