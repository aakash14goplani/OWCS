<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<cs:ftcs>
		<tr>
			<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/Options"/>:</td>
			<td></td>
			<td class="form-inset">
				<div id="optionsDiv" class="recOptions">Options Display Goes Here!!</div>
			</td>
		</tr>

		<tr id="selectionRow">
			<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/SelectionCriteria"/>:</td>
			<td></td>
			<td class="form-inset">
				<div id="selectionDiv" class="recSelection">Selection Display Goes Here!</div>
			</td>
		</tr>

		<tr id="sortorderRow">
			<td class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/SortCriteria"/>:</td>
			<td></td>
			<td class="form-inset">
				<div id="sortorderDiv" class="recSortOrder">Sort Display Goes Here!</div>
			</td>
		</tr>
</cs:ftcs>