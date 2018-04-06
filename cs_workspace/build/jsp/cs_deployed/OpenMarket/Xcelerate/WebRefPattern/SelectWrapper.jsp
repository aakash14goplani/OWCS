<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/SelectWrapper
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="java.util.*"%>
<cs:ftcs>
<%
	List<LabelValueBean> wrapperListPerSite = new ArrayList<LabelValueBean>();
%>

<asset:list type="SiteEntry" list="wrapperList"  field1="cs_wrapper" value1="y" pubid='<%=ics.GetVar("publicationId")%>' excludevoided="true" order="name" />
<ics:if condition='<%=ics.GetList("wrapperList")!=null && ics.GetList("wrapperList").hasData()%>' >
 <ics:then>
	<ics:listloop listname='wrapperList'>	
		<ics:listget listname='wrapperList' fieldname='name' output='name' />
		<%
			if (StringUtils.isNotBlank(ics.GetVar("name")))
			{
				LabelValueBean labelValue = new LabelValueBean(ics.GetVar("name"), ics.GetVar("name"));
				wrapperListPerSite.add(labelValue);
			}
		%>
	</ics:listloop>
</ics:then>
</ics:if>
{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(wrapperListPerSite)%> }
</cs:ftcs>