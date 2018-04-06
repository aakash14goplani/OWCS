<%@page import="com.fatwire.services.beans.asset.basic.template.TemplateBean.Type"%>
<%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.*"
%><%@ page import="com.fatwire.services.beans.asset.basic.template.TemplateBean"
%><%@ page import="com.fatwire.services.beans.asset.basic.template.TemplatesBean"
%><%@ page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ page import="com.fatwire.services.beans.entity.SiteBean"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try{
	//get service locator (singleton)
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );	

	//get template service
	TemplateService tmplDataService = servicesManager.getTemplateService();
	
	//initialize start/count (attempt to grab GET params)
	int start = NumberUtils.toInt(ics.GetVar("start"), 0);
	int count = NumberUtils.toInt(ics.GetVar("count"), -1);
	String ttypesStr = ics.GetVar("ttype");
	String nameRegExp = ics.GetVar("regexp");
	List<TemplateBean.Type> templateTypes= null;
	if (StringUtils.isNotBlank(ttypesStr)) {
		String[] ttypesArr = ttypesStr.split(";");
		templateTypes= new ArrayList<TemplateBean.Type>();
		for (int i=0;i<ttypesArr.length;i++)
		{	
			Type type = TemplateBean.Type.toEnum(ttypesArr[i]);
			if(type != null)
			{
				templateTypes.add(type);
			}
		}	
	}
	TemplatesBean templatesBean=tmplDataService.fetchTemplates(NumberUtils.toLong(ics.GetSSVar("pubid"), -1L), new TypeBean(ics.GetVar("assettype"), ics.GetVar("assetsubtype")), templateTypes, nameRegExp, start, count, request.getParameter("deviceSuffix"));
	request.setAttribute("templatesBean", templatesBean);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>
