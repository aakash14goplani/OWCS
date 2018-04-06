<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/Common/Script/Popup
//
// INPUT
//
// OUTPUT
//%>

<cs:ftcs>

<script>

function <portlet:namespace/>_csPopup(url, target)
{
    var win = window.open(url, target, "directories=no,scrollbars=yes,resizable=yes,location=no,menubar=no,toolbar=no,status=yes,top=20,width=650,height=680,left=300");
    win.focus();
}

if (!window.fatwire_refresh)
{
	window.fatwire_refresh = new Function("window.location = \"<portlet:renderURL/>\";window.focus();");
}
</script>

</cs:ftcs>