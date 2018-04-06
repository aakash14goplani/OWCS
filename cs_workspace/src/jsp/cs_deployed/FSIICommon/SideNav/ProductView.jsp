<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld" %>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<cs:ftcs>
    <ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
    <ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
    <%-- This template displays the section-specific nav bar for use on all pages whose category is Product.  --%>
    <div id="ProductCategoryList">
       <%-- Get a list of categories for all products

            There are two ways of doing this:
            1) Get a list of categories by searching on the parent
               asset type.  This will return a list of all categories
               in the system.  The problem is it returns categories
               with no products.
            2) Get a list of categories by searching the product
               asset type.  This only retrieves categories with
               actual products.
            We recommend the second method.

            Begin by creating a searchstate with no constraints, but create an assetset using this wide-open constraint
            that only retrieves assets of the type "Product".
            --%>
        <render:lookup key="Filter" varname="FilterElement" ttype="CSElement" match=":x"/>
        <render:lookup key="ProductType" varname="ProductType" ttype="CSElement"/>
        <render:lookup key="ProductParentType" varname="ProductParentType" ttype="CSElement"/>
        <render:lookup key="ProductAttrType" varname="ProductAttrType" ttype="CSElement"/>
        <render:lookup key="CategoryAttrName" varname="CategoryAttrName" ttype="CSElement" match=":x"/>
        <render:lookup key="Link" varname="Link" ttype="CSElement"/>
        <searchstate:create name="CategorySearch"/>
        <assetset:setsearchedassets name="ProductCategorySet" constraint="CategorySearch" assettypes='<%=ics.GetVar("ProductType")%>'/>
        <%-- Next, retrieve all of the different categories that exist among matching assets in the searchstate.

            We are only retrieving one attribute so there is no need to use getmultiplevalues --%>
        <assetset:getattributevalues name="ProductCategorySet" attribute='<%=ics.GetVar("CategoryAttrName")%>' typename='<%=ics.GetVar("ProductAttrType")%>'
                                     listvarname="ProductCategoryList" ordering="ascending"/>
        <ics:if condition='<%=ics.GetList("ProductCategoryList") != null && ics.GetList("ProductCategoryList").hasData()%>'>
            <ics:then>
                <h4>Categories</h4>
                <ul>
                    <%
                        // Keep track of what was already rendered
                        List<String> renderedCategories = new ArrayList<String>();
                    %>
                    <%-- Now loop through all of the categories that we retrieved --%>
                    <ics:listloop listname="ProductCategoryList">
                        <ics:listget listname="ProductCategoryList" fieldname="value" output="currentCategory"/>

                        <%-- Further constrain our searchstate by adding a category filter.  This creates
                             a search state that contains all the Product assets in the category specified. --%>
                        <searchstate:addsimplestandardconstraint name="CategorySearch" typename='<%=ics.GetVar("ProductAttrType")%>' attribute='<%=ics.GetVar("CategoryAttrName")%>'
                                                                 value='<%= ics.GetVar("currentCategory") %>' immediateonly="true"/>

                        <%-- We need to get the Category ID.  Since this is stored along with the category (and the search above
                             was only on product, not category) we need to use the category name to search on product parents
                             for the specific category and get its id.  In order to prevent accidental retrieval of all product
                             parents that have inherited this value (namely, the subcategories), we need to specify immeidateonly
                             to true when we retrieve our list.  --%>
                        <assetset:setsearchedassets name="CategorySet" constraint="CategorySearch" assettypes='<%=ics.GetVar("ProductParentType")%>'/>
                        <assetset:getassetlist name="CategorySet" immediateonly='true' listvarname="CategoryList"/>

                        <%-- If the data is not corrupt, then we will always get a list back.  Corrupt data will
                             cause this part code to throw a NullPointerException though.  Take care to not
                             corrupt your data!

                             Deleting a category though is something that can be done from time to time, so to
                             be safe, check to make sure the list actually exists. --%>
                        <ics:if condition='<%= ics.GetList("CategoryList") != null && ics.GetList("CategoryList").hasData() %>'>
                            <ics:then>
                                <ics:listget listname="CategoryList" fieldname="assetid" output="CategoryId"/>
                                <ics:setvar name="c" value='<%=ics.GetVar("ProductParentType")%>'/>
                                <ics:setvar name="cid" value='<%=ics.GetVar("CategoryId")%>'/>
                                <render:callelement elementname='<%=ics.GetVar("FilterElement")%>' scoped="global"/>
                                <ics:if condition='<%=!renderedCategories.contains(ics.GetVar("cid"))%>'>
                                    <ics:then>
                                        <%-- We now construct a link to the detail page for the category (which is a product parent (Product_P) asset type) --%>
                                        <li>
                                            <%
                                                // flag as rendered
                                                renderedCategories.add(ics.GetVar("cid"));
                                            %>
                                            <render:calltemplate context="" tname='<%=ics.GetVar("Link")%>' args="c,cid,p,locale" />

                                            <%-- Now render the subcategory.

                                                 The name of the category for which we need to get the list of sub categories is
                                                 already represented by the existing searchstate.  However, it is currently set
                                                 to exclude assets that inherited the category value.  We need to alter that
                                                 constraint to force it to include assets that inherited the category value in
                                                 order to get the subcategories.
                                                 --%>
                                            <searchstate:addsimplestandardconstraint name="CategorySearch" typename='<%=ics.GetVar("ProductAttrType")%>'
                                                                                     attribute='<%=ics.GetVar("CategoryAttrName")%>' value='<%= ics.GetVar("currentCategory") %>'
                                                                                     immediateonly="false"/>
                                            <%-- There are two ways to get the list of subcategories under each category.

                                                 1. Get a list of SubCategories by searching the Product_P asset type. This
                                                    will return a list of all SubCategories for the specific Category. The
                                                    problem with this approach is that it will return SubCategories that
                                                    don't have any products.

                                                 2. Get a list of SubCategories by searching the Product_C asset type
                                                    This will only get those SubCategories that have products. This list
                                                    will not contain SubCategories that don't have any products.

                                                 We recommend using option 1 since a product can belong to multiple sub categories
                                                 --%>
                                            <render:lookup key="SubCategoryAttrName" varname="SubCategoryAttrName" ttype="CSElement" match=":x"/>
                                            <assetset:setsearchedassets name="SubCategorySet" constraint="CategorySearch" assettypes='<%=ics.GetVar("ProductParentType")%>'/>
                                            <%-- Now retrieve the subcategory name from the set that contains this category.
                                                                    This will give us a list of all the subcategories under the current category. --%>
                                            <assetset:getattributevalues name="SubCategorySet" attribute='<%=ics.GetVar("SubCategoryAttrName")%>'
                                                                         typename='<%=ics.GetVar("ProductAttrType")%>' listvarname="ProductSubcategoryList" ordering="ascending"/>
                                            <ics:if condition='<%= ics.GetList("ProductSubcategoryList") != null && ics.GetList("ProductSubcategoryList").hasData() %>'>
                                                <ics:then>
                                                    <ul>
                                                        <%
                                                            // Keep track of what was already rendered
                                                            List<String> renderedSubCategories = new ArrayList<String>();
                                                        %>
                                                        <%-- Loop through all subcategories.  We will display each one with a link --%>
                                                        <ics:listloop listname="ProductSubcategoryList">
                                                            <ics:listget listname="ProductSubcategoryList" fieldname="value" output='CurrentSubCategory'/>
                                                            <%-- Look up the subcateogry id --%>
                                                            <searchstate:create name="SubcategoryIDSearch"/>
                                                            <searchstate:addsimplestandardconstraint name="SubcategoryIDSearch" typename='<%=ics.GetVar("ProductAttrType")%>'
                                                                                                     attribute='<%=ics.GetVar("SubCategoryAttrName")%>'
                                                                                                     value='<%= ics.GetVar("CurrentSubCategory") %>'/>
                                                            <assetset:setsearchedassets name="SubcategoryIDSet" constraint="SubcategoryIDSearch"
                                                                                        assettypes='<%=ics.GetVar("ProductParentType")%>'/>
                                                            <listobject:create name="myList" columns="attributetypename,attributename,direction"/>
                                                            <listobject:tolist name="myList" listvarname="listout"/>
                                                            <assetset:getassetlist name="SubcategoryIDSet" immediateonly="true" listvarname="SubcategoryData" list="listout"/>
                                                            <%-- The returned list should always exist, unless someone has deleted a subcategory and data managed
                                                                 to get corrupted somehow.  So, to be sure, check to make sure that data has been returned --%>
                                                            <ics:if condition='<%= ics.GetList("SubcategoryData") != null && ics.GetList("SubcategoryData").hasData() %>'>
                                                                <ics:then>
                                                                    <ics:listget listname="SubcategoryData" fieldname="assetid" output="SubcategoryId"/>
                                                                    <ics:setvar name="c" value='<%=ics.GetVar("ProductParentType")%>'/>
                                                                    <ics:setvar name="cid" value='<%=ics.GetVar("SubcategoryId")%>'/>
                                                                    <render:callelement elementname='<%=ics.GetVar("FilterElement")%>' scoped="global"/>
                                                                    <ics:if condition='<%=!renderedSubCategories.contains(ics.GetVar("cid"))%>'>
                                                                        <ics:then>
                                                                            <li>
                                                                                <%
                                                                                    // flag as rendered
                                                                                    renderedSubCategories.add(ics.GetVar("cid"));
                                                                                %>
                                                                                <%-- using the id, call the link template --%>
                                                                                <render:calltemplate context="" tname='<%=ics.GetVar("Link")%>' args="c,cid,p,locale" ttype="CSElement" />
                                                                            </li>
                                                                        </ics:then>
                                                                    </ics:if>
                                                                </ics:then>
                                                            </ics:if>
                                                            <%-- Remove the constraint on the search state we used to get the id of the subcategory --%>
                                                            <searchstate:deleteconstraint name="SubcategoryIDSearch" attribute='<%=ics.GetVar("SubCategoryAttrName")%>'/>
                                                        </ics:listloop>
                                                    </ul>
                                                </ics:then>
                                            </ics:if>
                                        </li>
                                    </ics:then>
                                </ics:if>

                            </ics:then>
                        </ics:if>
                        <%-- Remove the category name attribute from the search state so that the next loop iteration
                             can set the new category name for its own purposes. --%>
                        <searchstate:deleteconstraint name="CategorySearch" attribute='<%=ics.GetVar("CategoryAttrName")%>'/>
                    </ics:listloop>
                </ul>
            </ics:then>
        </ics:if>
    </div>

    <div id="ManufacturerList">
        <%--
             Get a list of manufacturers for all products.

             There are two ways to do this.

             1. Get a list of manufacturers by searching the Product_P asset type. This
                will return a list of all manufacturers in the system. The issue with this approach is
                that it will return manufacturers that don't have any products.

             2. Get a list of manufacturers by searching the Product_C asset type
                This will only get those manufacturers that have products. This list will
                not contain manufacturers that don't have any products.

                We recommend using option 2
             --%>
        <render:lookup key="ProductType" varname="ProductType" ttype="CSElement"/>
        <render:lookup key="ProductParentType" varname="ProductParentType" ttype="CSElement"/>
        <render:lookup key="ProductAttrType" varname="ProductAttrType" ttype="CSElement"/>
        <render:lookup key="ManufacturerAttrName" varname="ManufacturerAttrName" ttype="CSElement" match=":x"/>
        <render:lookup key="Link" varname="Link" ttype="CSElement"/>
        <searchstate:create name="ManufacturerSearch"/>
        <assetset:setsearchedassets name="ManufacturerSet" constraint="ManufacturerSearch" assettypes='<%=ics.GetVar("ProductType")%>'/>
        <assetset:getattributevalues name="ManufacturerSet" attribute='<%=ics.GetVar("ManufacturerAttrName")%>' typename='<%=ics.GetVar("ProductAttrType")%>'
                                     listvarname="ProductManufacturerList" ordering="ascending"/>
        <ics:if condition='<%= ics.GetList("ProductManufacturerList") != null && ics.GetList("ProductManufacturerList").hasData() %>'>
            <ics:then>
                <h4>Manufacturers</h4>
                <ul>
                    <%
                        // Keep track of what was already rendered
                        List<String> renderedManufacturers = new ArrayList<String>();
                    %>
                    <ics:listloop listname="ProductManufacturerList">
                        <ics:listget listname="ProductManufacturerList" fieldname="value" output="currentManufacturerName"/>

                        <%-- We need to figure out the id of the manufacturer.  This is stored in the Product_P
                             asset type so we need to look it up.

                             Add the manufacturer name to the constraint and refine the assetset to only include
                             assets whose manufacturer matches --%>
                        <searchstate:addsimplestandardconstraint name="ManufacturerSearch" typename='<%=ics.GetVar("ProductAttrType")%>'
                                                                 attribute='<%=ics.GetVar("ManufacturerAttrName")%>' value='<%=ics.GetVar("currentManufacturerName")%>'/>

                        <%-- We are replacing the old manufacurerset with this new one.  That's fine though because
                             we have already retrieved the list from the first version of the set --%>
                        <assetset:setsearchedassets name="ManufacturerSet" constraint="ManufacturerSearch" assettypes='<%=ics.GetVar("ProductParentType")%>'/>

                        <%-- To get the id of a flex asset you need to create a list object and use the
                             assetset:getassetlist tag to create an asset list that will have the id field. --%>
                        <listobject:create name="myList" columns="attributetypename,attributename,direction"/>
                        <listobject:tolist name="myList" listvarname="listout"/>
                        <assetset:getassetlist name="ManufacturerSet" immediateonly="true" listvarname="ManufacturerList" list="listout"/>
                        <ics:if condition='<%= ics.GetList("ManufacturerList") != null && ics.GetList("ManufacturerList").hasData() %>'>
                            <ics:then>
                                <ics:listget listname="ManufacturerList" fieldname="assetid" output="ManufacturerId"/>
                                <render:lookup key="Link" varname="Link" ttype="CSElement"/>
                                <ics:setvar name="c" value='<%=ics.GetVar("ProductParentType")%>'/>
                                <ics:setvar name="cid" value='<%=ics.GetVar("ManufacturerId")%>'/>
                                <render:callelement elementname='<%=ics.GetVar("FilterElement")%>' scoped="global"/>
                                <ics:if condition='<%=!renderedManufacturers.contains(ics.GetVar("cid"))%>'>
                                    <ics:then>
                                        <li>
                                            <%
                                                // flag as rendered
                                                renderedManufacturers.add(ics.GetVar("cid"));
                                            %>
                                            <%-- Render the link using the Link template --%>
                                            <render:calltemplate context="" tname='<%=ics.GetVar("Link")%>' args="c,cid,p,locale" ttype="CSElement" />
                                        </li>
                                    </ics:then>
                                </ics:if>
                            </ics:then>
                        </ics:if>
                        <%-- Remove the current manufacturer name from the search state so the next iteration through the
                             loop can set the next manufacturer name. --%>
                        <searchstate:deleteconstraint name="ManufacturerSearch" attribute='<%=ics.GetVar("ManufacturerAttrName")%>'/>
                    </ics:listloop>
                </ul>
            </ics:then>
        </ics:if>
    </div>

</cs:ftcs>