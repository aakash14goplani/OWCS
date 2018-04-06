<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="cart" uri="futuretense_cs/cart.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   java.util.StringTokenizer"
%><cs:ftcs><%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%-- Remove the items from the cart.  The items are identified by their row id. --%>
<commercecontext:getcurrentcart varname="theCart"/>
<%
String ids = ics.GetVar("rowid");
if (ids!=null)
{
    // CS uses a ';' as a delimiter for multiple valued input fields
    for (StringTokenizer st = new StringTokenizer(ids,";"); st.hasMoreTokens();)
    {%>
        <cart:deleteitem name="theCart" id='<%=st.nextToken()%>'/>
  <%}
}
%>
<commercecontext:setcurrentcart cart="theCart"/>
<%-- Reset any segments and promotions in effect, in case we have a cart-based discount --%>
<commercecontext:calculatesegments/>
<commercecontext:calculatepromotions/>
</cs:ftcs>