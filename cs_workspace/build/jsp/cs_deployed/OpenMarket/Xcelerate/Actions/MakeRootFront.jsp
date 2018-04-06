<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%
    //
// OpenMarket/Xcelerate/Actions/MakeRootFront
//
// INPUT
//
// OUTPUT
//
%>
<%@ page
        import="com.openmarket.xcelerate.asset.AssetIdImpl,java.util.HashMap" %>
<cs:ftcs>

<string:encode variable="doproceed" varname="doproceed"/>
<string:encode variable="AssetType" varname="AssetType"/>
<string:encode variable="id" varname="id"/>

    <ics:if condition='<%="true".equals(ics.GetVar("doproceed"))%>'>
        <ics:then>
            <%-- now actually fire the operation --%>
            <%
                // Use the service to change the root translation asset
                HashMap<String, Object> hmParam = new HashMap<String, Object>();
                hmParam.put("assetID", new AssetIdImpl(ics.GetVar("MakeRootType"), Long.parseLong(ics.GetVar("MakeRootID"))));
                request.setAttribute("parameterMap", hmParam);
            %>
            <ics:callelement element="OpenMarket/Xcelerate/Actions/setDimensionRoot"/>
            <%-- handle an unexpected failure firing the actual operation --%>
            <ics:if condition='<%=ics.GetErrno() < 0%>'>
                <ics:then>
                    <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                        <ics:argument name="elem" value='CantMakeRootUnknownReason'/>
                        <ics:argument name="severity" value="error"/>
                        <ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
                        <ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
                    </ics:callelement>
                </ics:then>
            </ics:if>
        </ics:then>
        <ics:else>
            <%-- our pre-checks have failed!  display an error message --%>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
                <ics:argument name="elem" value='<%=ics.GetVar("doproceed")%>'/>
                <ics:argument name="severity" value="error"/>
                <ics:argument name="assettype" value='<%=ics.GetVar("AssetType")%>'/>
                <ics:argument name="id" value='<%=ics.GetVar("id")%>'/>
            </ics:callelement>
        </ics:else>
    </ics:if>

    <%-- either way, take the user back to the main content details screen --%>
    <ics:callelement element="OpenMarket/Xcelerate/Actions/ContentDetailsFront">
        <ics:argument name='assettype' value='<%=ics.GetVar("AssetType")%>'/>
        <ics:argument name='id' value='<%=ics.GetVar("rootId")%>'/>
        <ics:argument name='errorAlreadyDisplayed' value='true'/>
    </ics:callelement>

</cs:ftcs>