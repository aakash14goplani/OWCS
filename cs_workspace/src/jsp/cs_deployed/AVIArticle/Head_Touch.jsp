<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%-- AVIArticle/Head_Touch

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<link type="text/css" rel="stylesheet" href="avisports/css/all.css"/>
<link type="text/css" rel="stylesheet" href="avisports/css/form.css"/>
<insite:ifedit>
<style>
.fw .aviHome2TopArticle .emptyIndicator {height: 40px !important;}
.fw .aviHome2Banner .emptyIndicator, .fw .aviHomeBanner .emptyIndicator {height: 300px !important;}
.fw .aviHomeDetailImage .emptyIndicator {height: 170px !important;}
.fw .aviArticleCategory {float:left; width: 130px !important; margin: 0}
.fw .aviArticleCategory .emptyIndicator {height: 15px !important; width: 130px !important; float: left}
.fw .aviSectionBanner .emptyIndicator {height: 216px !important;}
.fw .aviHomeTopStories {width: 390px; height: 90px !important;}
</style>
</insite:ifedit>
<assetset:setasset name="article" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="article" attribute="headline" listvarname="headline" typename="ContentAttribute" />
<assetset:getattributevalues name="article" attribute="subheadline" listvarname="subheadline" typename="ContentAttribute" />
<title><ics:listget listname="headline" fieldname="value" /></title>
<meta name="description" content='<ics:listget listname="subheadline" fieldname="value" />' />

</cs:ftcs>