<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" 
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld" 
%><%@ taglib prefix="cart" uri="futuretense_cs/cart.tld" 
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" 
%><%@ page import="COM.FutureTense.Interfaces.ICS,
                   COM.FutureTense.Interfaces.Utilities" 
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%-- This element relies on context-based data (session data).  We need to be very
     careful about page caching here, or else we could run into problems with
     the context data.
     
     On Satellite Server, the enclosing template is rendered as a separate 
     pagelet, so that means that there is no cached wrapper around this 
     particular page invocation.  That means our context data is safe.  However,
     while FirstSiteII is designed for use with Satellite Server, users can
     still run it directly through Content Server.  If this were to happen,
     we would run into a page caching problem as soon as we try to access the
     session variables.  
     
     Therefore, as a safety measure for users who are requesting this page
     through Content Server only, we need to forcibly disable caching of this
     page and all parent pages (but not nested pagelets).  This represents
     an acceptable use of the ics:disablecache tag.  Mis-use of this tag can
     lead to catastrophic performance problems.  Any page that was otherwise
     going to be cached until invocation of this tag will be served 
     single-threaded, meaning that it will be a performance bottleneck.  In this
     case, however, the page was never going to be cached anyway, so its use is 
     safe because Satellite Server is being used. --%>
<ics:disablecache recursive="false"/>

<%--
	This element calculates the discount for the product passed in.
	
	Before calculating the discount you need to find out the segments the current user belongs to,
	the promotions that are valid for the user. Get a list of these promotions. 
--%>
<commercecontext:calculatesegments/>
<commercecontext:calculatepromotions/>
<commercecontext:getpromotions listvarname="promotionlist"/>

<%--
	To calculate the discount one needs to add the item to the shopping cart. This automatically
	calculates the discount. We create a temporary cart and add the item to the cart. 
--%>
<cart:create name="tmpcart"/>
<cart:cleardiscounts name="tmpcart"/>
<cart:additem name="tmpcart" storeid="0" type='<%= ics.GetVar("c") %>' id='<%= ics.GetVar("cid") %>' quantity="1" price='<%= ics.GetVar("Price")%>'/>
<cart:getitems name="tmpcart" listvarname="cartlist"/>
<commercecontext:discounttempcart cart="tmpcart"/>
<cart:getitemtotal name="tmpcart" varname="carttotal"/>
<%-- Set variables for the discount and new total --%>
<cart:getitemdiscounttotal name="tmpcart" varname="discounttotal"/>
<cart:getpreliminarytotal name="tmpcart" varname="total" />
<%-- Retrieve the description of the discount and set it as a variable for the caller --%>
<cart:getitemdiscounts name="tmpcart" id="0" listvarname="discountttotal"/>
<ics:if condition='<%=ics.GetList("discountttotal") != null && ics.GetList("discountttotal").hasData()%>'>
<ics:then>
	<ics:listget listname="discountttotal" fieldname="description" output="discountdescription"/>
</ics:then>
</ics:if>
</cs:ftcs>