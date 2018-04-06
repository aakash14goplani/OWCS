<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="cart" uri="futuretense_cs/cart.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<div id="CartDetailView">
<%-- This page relies on context-based data (session data).  We need to be very
     careful about page caching here, or else we could run into problems with
     the context data.
     
     On Satellite Server, the DetailView template is rendered as a separate 
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
	
<%-- load the page, display the title --%>
<asset:load name="page" type="Page" objectid='<%=ics.GetVar("cid")%>'/>
<asset:get name="page" field="description" output="description"/>
<h2><string:stream variable="description"/></h2>

<%-- Here we will calculate segments and calculate promotions
	 but only if the engage store schema is present --%>

<%-- Now get the current cart --%>
<commercecontext:discountcart/>
<commercecontext:getcurrentcart varname="theCart"/>

<%-- get the contents from the cart --%>
<cart:getitems name="theCart" listvarname="ItemList"/>
<ics:if condition='<%=ics.GetList("ItemList") != null && ics.GetList("ItemList").hasData()%>'>
<ics:then>
	<render:lookup varname="Link" key="Link" tid='<%=ics.GetVar("tid")%>' site='<%=ics.GetVar("site")%>'/>
	<render:lookup varname="Wrapper" key="Wrapper" tid='<%=ics.GetVar("tid")%>' match=":x" site='<%=ics.GetVar("site")%>'/>
	<render:lookup varname="Layout" key="Layout" tid='<%=ics.GetVar("tid")%>' site='<%=ics.GetVar("site")%>'/>
	<render:lookup key="ProductAttrType" varname="ProductAttrType" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
	<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" site='<%=ics.GetVar("site")%>' tid='<%=ics.GetVar("tid")%>'/>
	
	<render:gettemplateurlparameters outlist="args" args="c,cid,p" tname='<%=ics.GetVar("Layout")%>' wrapperpage='<%=ics.GetVar("Wrapper")%>' />
	<satellite:form method="post" id='CartForm' name='CheckoutForm'>
	<ics:listloop listname="args">
		<input type="hidden" name="<string:stream list="args" column="name"/>" value="<string:stream list="args" column="value"/>"/>
	</ics:listloop>
	<table id="ShoppingCartContents">
	<tr>
		<th id="ProductHeader">Product</th>
		<th id="UnitPriceHeader">Unit Price</th>
		<th id="QuantityHeader">Qty.</th>
		<th id="PriceHeader">Price</th>
		<th id="RemoveHeader">Remove</th>
	</tr>
	
	<ics:listloop listname="ItemList">
		<%-- Get the name of the product --%>
		<ics:listget listname="ItemList" fieldname="assettype" output="assettype"/>
		<ics:listget listname="ItemList" fieldname="assetid" output="assetid"/>
		<assetset:setasset name="ProductInCart" type='<%=ics.GetVar("assettype")%>' id='<%=ics.GetVar("assetid")%>' />
		<assetset:getattributevalues name="ProductInCart" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("NameAttrName")%>' listvarname="ProdNameList"/>
		<ics:listget listname="ProdNameList" fieldname="value" output="productName"/>
		<%-- Get the row id - used for modifying the cart --%>
		<ics:listget listname="ItemList" fieldname="rowid" output="rowid"/>
		
		<%-- Get the quantity of items --%>
		<ics:listget listname="ItemList" fieldname="quantity" output="quantity"/>

		<%-- Get the price --%>
		<ics:listget listname="ItemList" fieldname="price" output="price"/>

		<%-- Get the discounts for all the items in teh cart for the current row --%>
		<cart:getitemdiscounts name="theCart" id='<%=ics.GetVar("rowid")%>' listvarname="discountinfo"/>
		<ics:if condition='<%=ics.GetList("discountinfo") != null && ics.GetList("discountinfo").hasData()%>'>
		<ics:then>
			<ics:listget listname="discountinfo" fieldname="value" output="discountvalue"/>
			<ics:listget listname="discountinfo" fieldname="description" output="discountdescription"/>
		</ics:then>
		</ics:if>
		<%
			double unitPrice = Double.parseDouble(ics.GetVar("price"));
			double quantity = Double.parseDouble(ics.GetVar("quantity"));
			double finalUnitPrice = unitPrice;
			String sDiscount = ics.GetVar("discountvalue");
			ics.SetVar("discountvalue", ""); // we are in a loop so clean up for next iteration
			if (sDiscount!=null && sDiscount.length() > 0)
			{
				double discount = Double.parseDouble(sDiscount);
				finalUnitPrice = unitPrice - discount;
			}
			double totalPrice = finalUnitPrice * quantity;
		%>
		<currency:create name="currencyobj"/>
		<currency:getcurrency name="currencyobj" value='<%=Double.toString(unitPrice)%>' varname="formattedUnitPrice"/>
		<currency:getcurrency name="currencyobj" value='<%=(sDiscount!=null && sDiscount.length() > 0) ? sDiscount : "0" %>' varname="formattedDiscount"/>
		<currency:getcurrency name="currencyobj" value='<%=Double.toString(finalUnitPrice)%>' varname="formattedFinalUnitPrice"/>
		<currency:getcurrency name="currencyobj" value='<%=Double.toString(totalPrice)%>' varname="formattedTotalPrice"/>

		<tr>
			<td class="ProductNameInCart">
				<render:calltemplate tname='<%=ics.GetVar("Link")%>' c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>'
									 args="p,locale" context="" />
			</td>
			<td class="ProductPriceInCart">
				<ics:if condition='<%=sDiscount!=null && sDiscount.length() > 0%>'>
				<ics:then>
				    Regular price: $<string:stream variable="formattedUnitPrice"/>
					<div class="discountInfo">- <string:stream variable="discountdescription"/>: $<string:stream variable="formattedDiscount"/></div>
					<div class="discountedPrice">Your price: $<string:stream variable="formattedFinalUnitPrice"/></div>
				</ics:then>
				<ics:else>
					$<string:stream variable="formattedUnitPrice"/>
				</ics:else>
				</ics:if>
			</td>
			<td class="ProductQuantityInCart"><string:stream variable="quantity"/></td>
			<td class="ProductTotalInCart">$<string:stream variable="formattedTotalPrice"/></td>
			<td class="ProductDeleteButtonInCart"><input type="checkbox" name="rowid" value="<string:stream variable="rowid"/>"/></td>
		</tr>
	</ics:listloop>
	</table>
	<input type="submit" name="form-to-process" value="Checkout"/>
	<input type="submit" name="form-to-process" value="Remove Items"/>
	</satellite:form>
</ics:then>
<ics:else>
	<div id="EmptyCartMessage">Your cart is empty.</div>
</ics:else>
</ics:if>
	
</div>
</cs:ftcs>