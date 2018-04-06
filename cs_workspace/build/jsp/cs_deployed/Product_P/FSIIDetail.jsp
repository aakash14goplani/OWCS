<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<div id="Product_PDetail">
	<div id="ProductArea">
		<assetset:setasset name="ProductParentSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />
		<asset:getsubtype type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
		<render:lookup key="ProductAttrType" varname="ProductAttrType" />
		<%-- Next, render the information about the parent.
		     There are two ways of handling this - first, we could
		     dispatch to a subtype-specif template here, and each would render
		     the fields that belong to that subtype.  The second option is to
		     simply add some conditionals to load attributes based on the 
		     parent definition.  Because we are only rendering a very few fields,
		     dispatching to one of three subtemplates is more work than we
		     need to do. More elaborate definitions, however, would require
		     that a dispatch occur here.  If a dispatch is to happen here,
		     it should be noted that the referred entry must be looked up.  
		     A sample of this type of dispatch occurs in the Page Detail template.  --%>
		<render:lookup key="Manufacturer" varname="Manufacturer" match=":x" />
		<ics:if condition='<%=ics.GetVar("Manufacturer").equals(ics.GetVar("subtype"))%>'>
		<ics:then>
			<%-- We are rendering a product manufactuer. --%>
			<render:lookup key="ManufacturerName" varname="ManufacturerName" match=":x" />
			<render:lookup key="ManufacturerDesc" varname="ManufacturerDesc" match=":x" />
			<render:lookup key="ManufacturerLogo" varname="ManufacturerLogo" match=":x" />
			<assetset:getmultiplevalues name="ProductParentSet" prefix="pp" immediateonly="true" byasset="false">
				<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("ManufacturerName")%>'/>
				<assetset:sortlistentry attributetypename='<%=ics.GetVar("ProductAttrType")%>' attributename='<%=ics.GetVar("ManufacturerLogo")%>'/>
			</assetset:getmultiplevalues>
			<assetset:getattributevalues name="ProductParentSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("ManufacturerDesc")%>' listvarname="Desc"/>
			<div id="ManufacturerInfo">
				<ics:if condition='<%=ics.GetList("pp:"+ics.GetVar("ManufacturerLogo"))!= null && ics.GetList("pp:"+ics.GetVar("ManufacturerLogo")).hasData()%>'>
				<ics:then>
					<div id="ManufacturerImage">
						<render:lookup key="ImageType" varname="ImageType" />
						<render:lookup key="ImageDetail" varname="ImageDetail" />
						<render:calltemplate tname='<%=ics.GetVar("ImageDetail")%>' 
											 c='<%=ics.GetVar("ImageType")%>' cid='<%=ics.GetList("pp:"+ics.GetVar("ManufacturerLogo")).getValue("value")%>'
											 context="" args="p,locale" />
					</div>
				</ics:then>
				</ics:if>
				<ics:listget listname='<%="pp:"+ics.GetVar("ManufacturerName")%>' fieldname="value" output="ParentName"/>
				<h3><string:stream variable="ParentName"/></h3>
				<p><ics:listget listname="Desc" fieldname="value"/></p>
			</div>
		</ics:then>
		</ics:if>
		<render:lookup key="Category" varname="Category" match=":x" />
		<ics:if condition='<%=ics.GetVar("Category").equals(ics.GetVar("subtype"))%>'>
		<ics:then>
			<%-- We are rendering a product category. --%>
			<render:lookup key="CategoryName" varname="CategoryName" match=":x" />
			<render:lookup key="CategoryDesc" varname="CategoryDesc" match=":x" />
			<assetset:getattributevalues name="ProductParentSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("CategoryName")%>' listvarname="Name"/>
			<assetset:getattributevalues name="ProductParentSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("CategoryDesc")%>' listvarname="Desc"/>
			<div id="CategoryInfo">
				<ics:listget listname="Name" fieldname="value" output="ParentName"/>
				<h3><string:stream variable="ParentName"/></h3>
				<p><ics:listget listname="Desc" fieldname="value"/></p>
			</div>
		</ics:then>
		</ics:if>
		<render:lookup key="Subcategory" varname="Subcategory" match=":x" />
		<ics:if condition='<%=ics.GetVar("Subcategory").equals(ics.GetVar("subtype"))%>'>
		<ics:then>
			<%-- We are rendering a product subcategory. --%>
			<render:lookup key="SubcategoryName" varname="SubcategoryName" match=":x" />
			<render:lookup key="SubcategoryDesc" varname="SubcategoryDesc" match=":x" />
			<assetset:getattributevalues name="ProductParentSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("SubcategoryName")%>' listvarname="Name"/>
			<assetset:getattributevalues name="ProductParentSet" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("SubcategoryDesc")%>' listvarname="Desc"/>
			<div id="SubcategoryInfo">
				<ics:listget listname="Name" fieldname="value" output="ParentName"/>
				<h3><string:stream variable="ParentName"/></h3>
				<p><ics:listget listname="Desc" fieldname="value"/></p>
			</div>
		</ics:then>
		</ics:if>

		<%-- Now, display a list of all of the products that belong to this parent.  We could do 
		     this with a nested pagelet based on the parent, but the nested pagelet would vary as 
			 much as the parent would, so there is no benefit to doing this.  However, we will go 
			 ahead and render all of the product summaries using their own nested templates --%>
		<searchstate:create name="ProductSearch"/>
		<searchstate:addsimplestandardconstraint name="ProductSearch" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("subtype")+"Name"%>' value='<%= ics.GetVar("ParentName") %>'/>
		<render:lookup key="ProductType" varname="ProductType" />
		<assetset:setsearchedassets name="ProductListSet" constraint="ProductSearch" assettypes='<%=ics.GetVar("ProductType")%>'/>
		<listobject:create name="myList" columns="attributetypename,attributename,direction"/>
		<listobject:tolist name="myList" listvarname="listout" />
		<assetset:getassetlist name="ProductListSet" listvarname="ChildProducts" list="listout"/>
		<ics:if condition='<%= ics.GetList("ChildProducts") != null && ics.GetList("ChildProducts").hasData() %>'>
		<ics:then>
			<div id="ProductList">
			<ics:listloop listname="ChildProducts">
				<ics:listget listname="ChildProducts" fieldname="assetid" output="ProductID"/>
				<render:lookup key="Summary" varname="Summary" />
				<render:calltemplate tname='<%=ics.GetVar("Summary")%>' c='<%=ics.GetVar("ProductType")%>' cid='<%=ics.GetVar("ProductID")%>' 
									 args="p,locale" context="" />
			</ics:listloop>
			</div>
		</ics:then>
		</ics:if>
	</div>
	<%-- We still need to display the Item of the Week and Advertisement - so just call their container --%>
	<div id="PromoArea">
		<render:lookup varname="StandardSideNavView" key="StandardSideNavView" />
		<render:calltemplate tname='<%=ics.GetVar("StandardSideNavView")%>' c='Page' cid='<%=ics.GetVar("p")%>'
							 args="p,locale" context="" />
	</div>
</div>

</cs:ftcs>