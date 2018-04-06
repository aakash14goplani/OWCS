<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><cs:ftcs><%
	String fieldData = ics.GetVar("fieldData");
	if(StringUtils.isEmpty(fieldData)) {
		String c = StringUtils.defaultString(ics.GetVar("c"));
		String cid = StringUtils.defaultString(ics.GetVar("cid"));
		String pname = StringUtils.defaultString(ics.GetVar("pname"));
		String templateArgs = StringUtils.defaultString(ics.GetVar("templateargs"));
		if("asset".equalsIgnoreCase(ics.GetVar("item"))) {
			fieldData = "<span id=\"_CSEMBEDTYPE_=inclusion&_PAGENAME_=" + pname + "&_ADDITIONALPARAMS_=" + templateArgs + "&_cid_="  + cid + "&_c_=" + c + "\"><i>[Asset Included(Id:"  + cid + ";Type:"  + c + ")]</i></span>";
		} else if ("link".equalsIgnoreCase(ics.GetVar("item"))) {
			fieldData = "<a href=\"_CSEMBEDTYPE_=internal&_WRAPPER_=" + StringUtils.defaultString(ics.GetVar("wrapper")) + "&_PAGENAME_=" + pname + "&_cid_="  + cid + "&_c_=" + c + "&_frag_=" + StringUtils.defaultString(ics.GetVar("linkanchor")) + "&_ADDITIONALPARAMS_=" + templateArgs + "\">" + StringUtils.defaultString(ics.GetVar("linktext")) + "</a>";
		}
	}
	request.setAttribute("fieldData", fieldData);
%></cs:ftcs>