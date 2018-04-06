<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@page import="org.codehaus.jackson.type.TypeReference"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.ui.beans.LabelValueBean"
%><cs:ftcs>
<%
try {
	String jsonData = request.getParameter("displayData");
	List<LabelValueBean> displayBns = null;
	if(StringUtils.isNotBlank(jsonData)) {
		displayBns = GenericUtil.emptyIfNull((List<LabelValueBean>) (new ObjectMapper().readValue(jsonData, new TypeReference<List<LabelValueBean>>(){})));	
	}
	if(displayBns.size() > 0){		
%>
	<div class="listViewTooltipContent">
		<div class="listViewTooltipLabel">
<%
	for(LabelValueBean bn : displayBns){
		if(bn.isVisible()){
			String label = bn.getLabel();
			String value = bn.getValue();
			if(value != null && !StringUtils.isEmpty(value)){	
%>
			<strong><%=label%></strong> : <%=value %>
			</br>			
<%
			}
		}
	}
%>	
		</div>
	</div>
<%
	}
}
catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>