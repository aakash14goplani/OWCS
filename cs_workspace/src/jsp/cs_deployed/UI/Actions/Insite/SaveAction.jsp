<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@ page import="com.fatwire.composition.slots.SlotBean" 
%><%@ page import="com.fatwire.services.ui.beans.InsiteData"
%><%@ page import="com.fatwire.ui.util.InsiteUtil"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="org.apache.commons.logging.LogFactory" 
%><%@ page import="org.apache.commons.logging.Log" 
%><%@ page import="com.fatwire.services.beans.ServiceResponse"
%><%@ page import="com.fatwire.services.beans.ServiceResponse.Status"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@page import="org.codehaus.jackson.type.TypeReference"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.services.ui.beans.InsiteAttributeData"
%><%@page import="com.fatwire.services.ui.beans.InsiteBlobData"
%><%@page import="com.fatwire.services.beans.response.MessageCollectors.SaveAssetsMessageCollector"%>
<%@page import="com.fatwire.services.beans.response.MessageCollector"%>
<%!
private static Log log = LogFactory.getLog("com.fatwire.logging.cs");
%><cs:ftcs><%
ServiceResponse resp = new ServiceResponse();
resp.setStatus(Status.SUCCESS);
List<String> refreshKeys = new ArrayList<String>();
SaveAssetsMessageCollector collector = new SaveAssetsMessageCollector();
try {
	String slots = ics.GetVar("slots");
	String assets = ics.GetVar("assets");
	if (log.isDebugEnabled()){
		log.debug("saving insite changes:\nslots:\n" + slots + "\nassets:\n" + assets);
	}
	ObjectMapper mapper = new ObjectMapper();
	if (StringUtils.isNotBlank(slots)) {
		TypeReference<List<SlotBean>> typeRef =  new TypeReference<List<SlotBean>>(){};	
		List<SlotBean> slotBeans = mapper.readValue(slots, typeRef);
		resp = InsiteUtil.saveSlots(ics, slotBeans);
	}	
	if (resp.status() == Status.SUCCESS.status() && StringUtils.isNotBlank(assets)) {
		TypeReference<List<InsiteData>> typeRef =  new TypeReference<List<InsiteData>>(){};
		List<InsiteData> assetBeans = mapper.readValue(assets, typeRef);
		resp = InsiteUtil.saveInsiteData(ics, assetBeans , refreshKeys, collector);
	}
	
} catch(Exception e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
}
request.setAttribute("resp", resp);
request.setAttribute("refreshKeys", refreshKeys);
%></cs:ftcs>