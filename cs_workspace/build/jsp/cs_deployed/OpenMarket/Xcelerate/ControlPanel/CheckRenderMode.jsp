<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/ControlPanel/CheckRenderMode
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
<cs:ftcs>
<script language="JavaScript">
function CheckContentWindow(value)
{
	
	// added this function to do the endswith functionality. 
  String.prototype.endsWith = function(suffix) {
    var startPos = this.length - suffix.length;
    if (startPos < 0) {
      return false;
    }
    return (this.lastIndexOf(suffix, startPos) == startPos);
  };
  
	<satellite:link outstring="stuburl"/>
	if(window.opener.location.href.endsWith("<%=ics.GetVar("stuburl") %>"))
	{
	   // do nothing fix for PR 13922
	   return;
	}
  else
  {
    var fixedUrl = null;
    var renderMode = "rendermode="+value;
    var url = window.opener.location.href;

    var i1 = url.indexOf('rendermode=');

    if (i1 == -1)  // no rendermode
    {
	    // and no query string
	    if(url.indexOf('?') == -1 )
	    {
       		// add rendermode as query string
	    	fixedUrl = url + "?" + renderMode; 
    	    }
	    else
    	    {
    	      // add rendermode as an argument
              fixedUrl = url + "&" + renderMode;
    	    } 
    }
    else {
        var i2 = url.indexOf('&', i1);
        if (i2 == -1) {
            if (renderMode != url.substring(i1)) {
				fixedUrl = url.substring(0, i1) + renderMode;
            }
        } else {
            if (renderMode != url.substring(i1, i2)) {
				fixedUrl = url.substring(0, i1) + renderMode + url.substring(i2);
            }
        }
    }

    if (fixedUrl) {
        window.opener.location=fixedUrl;
    }
    return;
  }
}
<%
	String username = ics.GetSSVar("username");
	String pubid = ics.GetSSVar("pubid");
	String rendermode = username != null && pubid != null ?
		"preview-"+username+"-"+pubid : "preview";
%>
CheckContentWindow("<%=rendermode%>");
</script>
</cs:ftcs>