<%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ui.beans.UIPreviewWrapperBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<asset:list type="SiteEntry" list="wrapperList"  field1="cs_wrapper" value1="y" pubid='<%=ics.GetSSVar("pubid") %>' excludevoided="true" order="name" />
<%
	// get the wrapper list from ics, iterate and build the ui bean
	List<UIPreviewWrapperBean> wList = new ArrayList<UIPreviewWrapperBean>();
	IList iList = ics.GetList("wrapperList");
	for (int i = iList.numRows(); i > 0; --i)
	{
		iList.moveTo(i);
		String name = iList.getValue("name");
		UIPreviewWrapperBean wrapperBean = new UIPreviewWrapperBean(name);
		wList.add(wrapperBean);	
	}
	request.setAttribute("wList", wList);
%>
</cs:ftcs>
