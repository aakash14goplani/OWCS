<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
	<div class="checkInDialog">
		<h2><xlat:stream key="UI/UC1/Layout/Checkin"/></h2>
		<h3><xlat:stream key="UI/UC1/Layout/AddComment1"/></h3>
		<div class="messageArea">
			<textarea id="checkinComment" style="resize:none;width:350px;height:150px;"></textarea>
		</div>
		<div class="checkInCheckBox"><input type="checkbox" id="keepCheckedOut" /> <xlat:stream key="dvin/Common/KeepCheckedOut"/></div>
	</div>
</cs:ftcs>