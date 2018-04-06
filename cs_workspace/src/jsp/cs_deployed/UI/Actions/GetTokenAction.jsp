<%@page import="com.fatwire.ui.util.InsiteUtil"
%><%@page import="com.fatwire.services.ui.beans.UITokenBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%	
	try
	{
		UITokenBean tokenBean = new UITokenBean();
		tokenBean.setToken(InsiteUtil.getUploadToken(ics));
		tokenBean.setSessionid(session.getId());
		request.setAttribute("tokenBean", tokenBean);		
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>