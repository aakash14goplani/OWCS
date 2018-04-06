<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>
{"statusList": [
	<c:forEach var="data" items="${statusList}" varStatus="status">
		{ "name": "${data.name}",
		  "assetId": {"id": ${data.permission.assetId.id}, "type": "${data.permission.assetId.type}"},
		  "granted": ${data.permission.granted},
		  "reason": "${data.permission.collectedMessage.reason}",
		  "errno": "${data.permission.collectedMessage.errno}",
		  "status": 
		  		<c:choose>
				<c:when test="${data.permission.granted}">
				"<xlat:stream key='UI/UC1/Layout/ReadyToBeDeleted'/>"
				</c:when>
				<c:otherwise>
				"<xlat:stream key='UI/UC1/Layout/CannotDeleteAsset'/>"
				</c:otherwise>
				</c:choose>,
			"message":
				<%-- FIXME: message for referenced assets has to come from SystemLocaleString + resolve id --%>
				<c:choose>
				<c:when test='${data.permission.collectedMessage.reason == "REFERENCED"}'>
				"<xlat:stream key='UI/UC1/Layout/AssetReferenceMessage1'/>'${data.name}'<xlat:stream key='UI/UC1/Layout/AssetReferenceMessage2'/><a href=\"#\" class=\"RefLink\" id='link:${data.permission.assetId.id}'><xlat:stream key='UI/UC1/Layout/ViewReferences'/></a>"
				</c:when>
				<c:otherwise>
				"${data.permission.collectedMessage.message}"
				</c:otherwise>
				</c:choose>
		}${status.last ? "" : ","}
	</c:forEach>
]}
</cs:ftcs>