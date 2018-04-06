<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" %>
<%@ taglib prefix="vdm" uri="futuretense_cs/vdm.tld" %>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" %>

<cs:ftcs>
    <ics:if condition='<%=ics.GetVar("seid")!=null%>'>
        <ics:then>
            <render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/>
        </ics:then>
    </ics:if>

    <ics:if condition='<%=ics.GetVar("eid")!=null%>'>
        <ics:then>
            <render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/>
        </ics:then>
    </ics:if>

    <%-- Create the searchstate --%>
    <render:lookup key="VisitorType" varname="VisitorType" ttype="CSElement" />
    <render:lookup key="VisitorTypeDef" match=":x" varname="VisitorTypeDef" ttype="CSElement" />
    <render:lookup key="VisitorTypeAttr" varname="VisitorTypeAttr" ttype="CSElement" />
    <assetset:setasset name="theEngageUser" type='<%=ics.GetVar( "VisitorType" )%>' id='<%=ics.GetVar( "VisitorID" )%>'/>
    <asset:inspect list="attributeList" type='<%=ics.GetVar( "VisitorType" )%>' subtype='<%= ics.GetVar( "VisitorTypeDef" )%>'/>
    <ics:if condition='<%= ics.GetList("attributeList") != null && ics.GetList("attributeList").hasData() %>'>
        <ics:then>
            <%-- Hook up the newly registered user to the visitor object --%>
            <vdm:setalias key="SiteVisitor" value='<%= ics.GetVar( "VisitorUserName" ) %>'/>
            <%-- Add scalar values to the visitor object --%>
            <ics:listloop listname="attributeList">
                <ics:listget listname="attributeList" fieldname="name" output="attributeName"/>
                <ics:if condition='<%= ics.GetVar("attributeName").startsWith("Attribute_") %>'>
                    <ics:then>
                        <ics:setvar name="theAttribute" value='<%= ics.GetVar("attributeName").substring(10,ics.GetVar("attributeName").length()) %>'/>
                        <% String sAttrList = ics.GetVar("theAttribute") + "List";%>
                        <assetset:getattributevalues name="theEngageUser"
                                                     typename='<%=ics.GetVar( "VisitorTypeAttr" )%>'
                                                     attribute='<%= ics.GetVar("theAttribute") %>'
                                                     listvarname='<%= sAttrList %>'/>
                        <ics:if condition='<%=ics.GetList(sAttrList) != null && ics.GetList(sAttrList).hasData()%>'>
                            <ics:then>
                                <ics:listget listname='<%= sAttrList %>' fieldname="value" output='<%= ics.GetVar("theAttribute") %>'/>
                                <ics:setvar name="theAttribute" value='<%= ics.GetVar("attributeName").substring(10,ics.GetVar("attributeName").length()) %>'/>
                                <ics:if condition='<%= ics.GetVar("theAttribute") != null %>'>
                                    <ics:then>
                                        <%
                                            if (ics.GetVar(ics.GetVar("theAttribute")) == null)
                                            {
                                                ics.SetVar(ics.GetVar("theAttribute"), "DT");
                                            }
                                        %>
                                        <vdm:setscalar attribute='<%= ics.GetVar("theAttribute") %>' value='<%= ics.GetVar(ics.GetVar("theAttribute")) %>'/>
                                    </ics:then>
                                </ics:if>
                            </ics:then>
                            <ics:else>
                                <%
                                    if (ics.GetVar(ics.GetVar("theAttribute")) == null)
                                    {
                                        ics.SetVar(ics.GetVar("theAttribute"), "DT");
                                    }
                                %>
                                <vdm:setscalar attribute='<%= ics.GetVar("theAttribute") %>' value='<%= ics.GetVar(ics.GetVar("theAttribute")) %>'/>
                            </ics:else>
                        </ics:if>
                    </ics:then>
                </ics:if>
            </ics:listloop>
        </ics:then>
    </ics:if>

    <%-- calculate segments and promotions for the visitor based on the new visitor data --%>
    <commercecontext:calculatesegments/>
    <commercecontext:calculatepromotions/>
</cs:ftcs>

