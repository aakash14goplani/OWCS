<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs>
<c:choose>
      <c:when test='${not empty cs_message}'>
		<div class="slotArgsMessage">${cs_message}</div>
		</c:when>
 <c:otherwise>

		<div dojoType="dijit.form.Form">
			<div class="slotPropertiesInfo slotPropertiesAdvancedTab">
				<!--  TODO case of a template without args -->
				<c:forEach var="templateArg" items="${templateArguments}">
					<div>
						<label class="ellipsis" title="${templateArg.description}">${templateArg.description}</label>
						<c:choose>
							<c:when test='${templateArg.hasLegalValues == true}'>
								<select name="${templateArg.name}" id="${templateArg.name}" dojoType="fw.dijit.UIFilteringSelect" required="${templateArg.isRequired}" onFocus="dojo.publish('fw/ui/slot/properties/onfocus')">
									<c:forEach var="entry" items="${templateArg.legalValues}">
										<option value="${entry.key}"><c:choose><c:when test="${entry.value==''}">${entry.key}</c:when><c:otherwise>${entry.value}</c:otherwise></c:choose></option>
									</c:forEach>
								</select>
							</c:when>
							<c:otherwise>
								<input type="text" name="${templateArg.name}" id="${templateArg.name}" dojoType="fw.dijit.UIInput" required="${templateArg.isRequired}" tooltipPosition="below" clearButton="true" onFocus="dojo.publish('fw/ui/slot/properties/onfocus')" />
							</c:otherwise>
						</c:choose>
					</div>
				</c:forEach>
			</div>
		</div>
</c:otherwise>
</c:choose>
</cs:ftcs>