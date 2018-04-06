<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%
// OpenMarket/Xcelerate/UIFramework/UpdateUITree
%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<cs:ftcs>
<script type="text/javascript">
	dojo.addOnLoad(
		function(){
			var refreshKeys = '<%=ics.GetVar("refreshKeys")%>';
			parent.dojo.publish('/fw/ui/tree/refresh', [{"refreshKeys":refreshKeys}]);
		}
	);
</script>
</cs:ftcs>