<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/GetExcludedAttributes
//
// INPUT
//
// OUTPUT
//%>
<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<cs:ftcs>
<%
	List<String> excludedAttrList = Arrays.asList("filename", "path", "urlexternaldocxml", "urlexternaldoc", "externaldoctype", "urlexternaldocxml", "renderid", "fw_uid","Dimension", "Dimension-parent", "Publist", "SegRating", "Webreference", "Relationships");
	ics.SetObj("excludedAttrList", excludedAttrList);
%>
</cs:ftcs>