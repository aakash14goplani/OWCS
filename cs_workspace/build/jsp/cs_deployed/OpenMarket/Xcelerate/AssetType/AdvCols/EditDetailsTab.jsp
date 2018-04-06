<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<cs:ftcs>
	<tr id="typePickerRow">
		<td id="typePickerLabel" class="form-label-text"><xlat:stream key="dvin/AT/AdvCols/Type"/>:</td>
		<td></td>
		<td class="form-inset">
			<div id="typePickerDiv" class="recTypePicker">Type Picker Goes Here!</div>
		</td>
	</tr>

	<tr>
		<td class="form-label-text">&nbsp;</td>
		<td></td>
		<td class="form-inset">
		<div class="recDetailDiv" class="recDetail">
			<div id="listDataDiv" class="recListData">Rendered listData Goes Here!</div>
		</div>
		</td>
	</tr>

</cs:ftcs>