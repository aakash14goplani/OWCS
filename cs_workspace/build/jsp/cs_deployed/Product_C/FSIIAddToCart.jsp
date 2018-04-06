<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="cart" uri="futuretense_cs/cart.tld"
%><%@ taglib prefix="currency" uri="futuretense_cs/currency.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<%-- This template displays the form to add an entry to the shopping cart.
     It also contains the logic to actually process the form and add the 
	 entry to the cart.  If this operation were more complicated, it would
	 really make sense to break these tasks into elements.  However, as the
	 task is trivial, it is all done in one single element.  
	 
	 When the form is submitted, the variable "form-to-process" is always
	 present. --%>
	 
<%-- The add-to-cart form was posted, and this pagelet is uncached.  Therefore,
     all of the posted varibles present in the post request are available to this
	 page.
	 
	 We will use this information to give the user some confirmation that his
	 request to add an entry has been processed. --%>
<ics:if condition='<%="AddToCart".equals(ics.GetVar("form-to-process"))%>'>
<ics:then>
	<%-- Get the cart if it exists.  If no cart eists then this tag will initialize the new cart --%>
	<commercecontext:getcurrentcart varname="theCart"/>
	
	<%-- Add the item to the cart --%>
	<cart:additem 
		name="theCart" 
		storeid="0" 
		type='<%=ics.GetVar("product-type")%>' 
		id='<%=ics.GetVar("product-id")%>' 
		quantity='<%=ics.GetVar("product-quantity")%>' 
		price='<%=ics.GetVar("product-price")%>'
		/>
	
	<%-- Re-set the cart --%>
	<commercecontext:setcurrentcart cart="theCart"/>
	
	<%-- That's all there is to it. --%>
	<div id="ItemAddedSuccessfully">This item has been added to your cart.</div>
</ics:then>
</ics:if>

<assetset:setasset name="ProductSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<render:lookup key="PriceAttrName" match=":x" varname="PriceAttrName" />
<assetset:getattributevalues name="ProductSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("PriceAttrName")%>' listvarname="PriceList"/>
<%-- This check is paranoid since we already did it but better safe than sorry --%>
<ics:if condition='<%=ics.GetList("PriceList")!=null && ics.GetList("PriceList").hasData()%>'>
<ics:then>
	<ics:listget listname="PriceList" fieldname="value" output="Price"/>
	<div id="ProductPricing">
		<div id="ProductPrice">
			<currency:create name="currencyobj"/>
			<currency:getcurrency name="currencyobj" value='<%=ics.GetVar("Price")%>' varname="currencyvalue"/>
			<p>Price Per Unit: $<string:stream variable="currencyvalue"/></p>
		</div>
		<%-- Look up the discount data and render it if 
			 appropriate to do so.  (i.e. if the Engage 
			 Store Schema is installed) --%>
		<render:lookup varname="DiscountElement" key="DiscountElement" match=":x"/>

		<ics:if condition='<%=ics.GetVar( "DiscountElement" ) != null%>' >
		<ics:then>
			<render:callelement elementname='<%=ics.GetVar( "DiscountElement" )%>' scoped="global" >
				<render:argument name="c" value='<%=ics.GetVar("c")%>' />
				<render:argument name="cid" value='<%=ics.GetVar("cid")%>' />
				<render:argument name="Price" value='<%=ics.GetVar("Price")%>' />
			</render:callelement>
			<ics:if condition='<%= ics.GetVar("discounttotal") != null && ics.GetVar("discounttotal") != "0" %>'>
			<ics:then>
				<currency:getcurrency name="currencyobj" value='<%= ics.GetVar("discounttotal") %>' varname="discountvalue"/>
				<currency:getcurrency name="currencyobj" value='<%= ics.GetVar("total") %>' varname="totalvalue"/>
				<div id="ProductDiscount">		
					<p><string:stream variable="discountdescription"/>&nbsp;&nbsp;$<string:stream variable="discountvalue"/></p>
				</div>
				<div id="ProductFinalPrice">
					<%-- Final prices is rendered by the engage store schema --%>
					<p>Price $<string:stream variable="totalvalue"/></p>
				</div>
			</ics:then>
			</ics:if>
		</ics:then>
		<ics:else>
			<%-- No discount code present - just use the original price --%>
			<ics:setvar name="totalvalue" value='<%=ics.GetVar("currencyvalue")%>'/>
		</ics:else>
		</ics:if>
	</div>

	<div id="ProductCartControl">
		<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
		<render:lookup varname="LayoutVar" key="Layout" />
		<render:gettemplateurlparameters outlist="args" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
		<satellite:form method="post" id="AddToCartForm">
			<fieldset><legend>Content Server form processing fields</legend>
			<ics:listloop listname="args">
				<input type="hidden" name="<string:stream list="args" column="name"/>" value="<string:stream list="args" column="value"/>"/>
			</ics:listloop>
			<input id="FormToProcessField" type="hidden" name="form-to-process" value="AddToCart"/>
			<input id="ProductAssetType" type="hidden" name="product-type" value="<string:stream variable="c"/>"/>
			<input id="ProductID" type="hidden" name="product-id" value="<string:stream variable="cid"/>"/>
			
			<%-- Note there are a couple of options here.  First, we could just
				 pass the price in through a hidden field and hope that the user
				 does not hack the response and buy things for free.  The other option
				 which is more robust but is a little harder to follow is to
				 just look up the price on the cart processing page.  But we would
				 have to re-calculate the discount there.  For simplicity, we jsut
				 pass the field through a hidden param.  For security though, we 
				 should really look up the price and re-calculate the discount. --%>
			<input id="CartPriceField" type="hidden" name="product-price" value="<string:stream variable="Price"/>"/>
			</fieldset>
			<fieldset><legend>Add to cart fields</legend>
			<label title="Quantity" for="QuantityField">Qty. <input id="QuantityField" type="text" name="product-quantity" size="2" value="1"/></label>
			<input id="AddToCartButton" type="submit" name="Add to Cart" value="Add to Cart"/>
			</fieldset>
		</satellite:form>
	</div>
</ics:then>
</ics:if>

</cs:ftcs>