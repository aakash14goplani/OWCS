<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs>
{
"configElements": [
<c:forEach var="element" items="${configElements }" varStatus="status">
	"${element}"${status.last ? "" : "," }
</c:forEach>
]
}
</cs:ftcs>
