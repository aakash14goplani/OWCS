<%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ui.beans.UIPreviewSegmentBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<asset:list type="Segments" list="segmentList" pubid='<%=ics.GetSSVar("pubid") %>' excludevoided="true" order="name" />
<%
	// get the wrapper list from ics, iterate and build the ui bean
	List<UIPreviewSegmentBean> sList = new ArrayList<UIPreviewSegmentBean>();
	IList iList = ics.GetList("segmentList");
	for (int i = iList.numRows(); i > 0; --i)
	{
		iList.moveTo(i);
		String name = iList.getValue("name");
		UIPreviewSegmentBean segmentBean = new UIPreviewSegmentBean(name);
		sList.add(segmentBean);	
	}
	request.setAttribute("sList", sList);
%>
</cs:ftcs>
