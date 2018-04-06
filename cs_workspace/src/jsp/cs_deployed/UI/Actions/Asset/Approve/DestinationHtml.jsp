<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.beans.entity.DestinationBean"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
String assetId = request.getParameter("id");
String assetType = request.getParameter("type");

try {
	List<DestinationBean> result = GenericUtil.emptyIfNull((List<DestinationBean>) request.getAttribute("result"));
	if(result.size() > 0){
		for(DestinationBean destination : result) {
			%><div data-dojo-type="fw.dijit.UIMenuItem" data-dojo-props="onClick: function() {
				var documentId = fw.util.buildDocId({id: '<%= assetId %>', type: '<%= assetType %>'})
					, target = documentId.getId() ? documentId : 'active'
					;
				
				SitesApp.event(target, 'approve', {
					'destinationId': <%=destination.getId()%>,
					'destinationName': '<%=destination.getName()%>',
					'destinationType': '<%=destination.getType().getCode()%>'
				});
				
			}"><%=destination.getName()%></div><%
		}
	}
	else{%>
		<div data-dojo-type="fw.dijit.UIMenuItem">
		<xlat:stream key="UI/UC1/Layout/NoApprovalDestinations" escape="true"/>
		</div>
	<%}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>