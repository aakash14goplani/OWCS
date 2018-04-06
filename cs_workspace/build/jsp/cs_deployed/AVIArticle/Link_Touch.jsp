<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%-- AVIArticle/Link_Touch

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="article" type="AVIArticle" id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="article" listvarname="headline" attribute="headline" typename="ContentAttribute" />
<render:callelement elementname="avisports/AVIArticle/GetLink" scoped="global" />
<%String artcleURL = ics.GetVar("articleUrl")+"&pageId="+ics.GetVar("pageId");%>
<a href='<%=artcleURL%>'><ics:listget listname="headline" fieldname="value" /></a>

</cs:ftcs>