<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
        %><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
        %><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
        %><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
        %><%@ taglib prefix="dimensionset" uri="futuretense_cs/dimensionset.tld"
        %><cs:ftcs><%-- FSIICommon/Locale/ExecuteFilter --%>
    <%-- Record dependencies for the SiteEntry and the CSElement --%>
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

    <%-- This element is responsible for ensuring that given the users preferred
        locale and the locales enabled for this site (i.e. those that are
        enabled in the DimensionSet), that the proper translation of the asset
        that is passed into the URL is actually returned to the end user.

        This is simple to do:
        1. check to see if the user even specified a locale
        2. check to see if the locale is the same as the input asset.
        if not:
        3. load the dimension set
        4. pass the asset type and id, plus the preferred locale, into the
           dimension filter.  The filter will return the appropriate asset
           to render (or no id at all!)
        5. Re-set the c and cid params to correspond to the filtered value.
           This could mean removing the c and cid variables if no asset matches
           the filter.  Note that the behaviour of the filter is specified by
           its implementing java class, which is named in the DimensionSet.  This
           behaviour can be customized as needed by simply re-implementing the
           IDimensionFilter interface.
    --%>
    <%-- 1. make sure we are even dealing with a localized site --%>
    <ics:if condition='<%=ics.GetVar("locale") != null%>'>
        <ics:then>
            <%-- 2. check the locale of the current asset to see if it needs to be filtered
                    If the input asset does not even have a locale, then it is okay to render
                    it as it is an international or multilingual asset. --%>

            <asset:getlocale type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' prefix="asset:locale"/>
            <ics:if condition='<%=ics.GetVar("asset:locale:OBJECTID") == null || ics.GetVar("locale").equals(ics.GetVar("asset:locale:OBJECTID"))%>'>
                <ics:then>
                    <ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="debug"
                                msg='<%="About to filter and look up translation for asset "+ics.GetVar("c")+":"+ics.GetVar("cid")+" because it either doesnot have a locale associated with it or it is already in the requested locale"%>'/>

                </ics:then>
                <ics:else>
                    <%-- we have to filter this asset because it is in the wrong language.  --%>
                    <ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="debug"
                                msg='<%="About to filter and look up translation for asset "+ics.GetVar("c")+":"+ics.GetVar("cid")+" because it is in the wrong locale."%>'/>

                    <%-- 3. load the Dimension Set --%>
                    <render:lookup site='<%=ics.GetVar("site")%>' ttype="CSElement" tid='<%=ics.GetVar("eid")%>'
                                   key="GlobalDimSet" match=":x" varname="dimSetName"/>
                    <asset:load name="DimSet" type="DimensionSet" field="name" value='<%=ics.GetVar("dimSetName")%>'/>

                    <%-- 4. execute the filter --%>
                    <dimensionset:filtersingleasset name="DimSet" assettype='<%=ics.GetVar("c")%>'
                                                    assetid='<%=ics.GetVar("cid")%>' list="outList">
                        <dimensionset:asset assettype="Dimension" assetid='<%=ics.GetVar("locale")%>'/>
                    </dimensionset:filtersingleasset>

                    <%-- 5. re-set c and cid. Explicitly clear first in case nothing passes the filter.--%>
                    <ics:removevar name="c"/>
                    <ics:removevar name="cid"/>
                    <ics:listloop listname="outList" maxrows="1">
                        <ics:listget listname="outList" fieldname="assettype" output="c"/>
                        <ics:listget listname="outList" fieldname="assetid" output="cid"/>
                    </ics:listloop>

                    <ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="debug"
                                msg='<%="Filter complete.  Filter returned asset "+ics.GetVar("c")+":"+ics.GetVar("cid")+"."%>'/>

                </ics:else>
            </ics:if>
        </ics:then>
        <ics:else>
            <ics:logmsg name="com.fatwire.logging.cs.firstsite" severity="debug"
                        msg='<%="Do not need to filter or look up translation for asset "+ics.GetVar("c")+":"+ics.GetVar("cid")+" because no preferred locale was specified."%>'/>

        </ics:else>
    </ics:if>

</cs:ftcs>