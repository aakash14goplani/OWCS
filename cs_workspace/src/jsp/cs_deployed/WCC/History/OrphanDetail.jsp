<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="oracle.stellent.ucm.poller.Constants,
                   oracle.stellent.ucm.poller.record.WccOrphanRecord,
                   oracle.wcs.util.WcsLocale,
                   com.fatwire.assetapi.data.AssetDataManager,
                   com.fatwire.assetapi.data.AssetDataManagerImpl,
                   com.fatwire.cs.core.db.PreparedStmt,
                   com.fatwire.cs.core.db.StatementParam,
                   com.fatwire.cs.core.search.data.ResultRow,
                   com.fatwire.services.SearchService,
                   com.fatwire.services.ServicesManager,
                   com.fatwire.system.Session,
                   com.fatwire.system.SessionFactory,
                   COM.FutureTense.Interfaces.IList,
                   java.util.ArrayList,
                   java.util.Collections,
                   java.util.List"%>
<cs:ftcs>
<%--
 
INPUT 
    
OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

    <%
        //Clean up.  Remove from table any assetids that are no longer "locked"

        //Search setup
        Session ses = SessionFactory.getSession();
        ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
        SearchService searchService =  servicesManager.getSearchService();
        AssetDataManager adm = new AssetDataManagerImpl(ics);

        //Find all the sites
        PreparedStmt stmt = new PreparedStmt ("SELECT name, id FROM Publication", Collections.singletonList ("Publication"));
        IList sqlSites = ics.SQL(stmt, null, false);

        List<Long> siteIds = new ArrayList<Long>();
        for (int sqlrow = 1; sqlrow <= sqlSites.numRows(); sqlrow++) {
            sqlSites.moveTo (sqlrow);
            siteIds.add (Long.parseLong (sqlSites.getValue ("id")));
        }

        //Find all the orphans
        stmt = new PreparedStmt (String.format("SELECT assetid FROM %s", Constants.OrphanTable), Collections.singletonList (Constants.OrphanTable));
        IList sqlOrphans = ics.SQL (stmt, null, false);

        for (int sqlrow = 1; sqlrow <= sqlOrphans.numRows(); sqlrow++) {
            sqlOrphans.moveTo(sqlrow);
            Long assetId = Long.parseLong (sqlOrphans.getValue ("assetid"));

            //loop through all sites and delete orphan rows when assetid is not on any sites
            boolean found = false;
            for (long siteId : siteIds) {
                List<ResultRow> searchResults = null;
                //SearchCriteria  searchCriteria = SearchUtil.buildSearchCriteria(request, siteId);
                searchResults = searchService.search(siteId, assetId.toString (), "EQUALS", null, "id", -1, null);
                if (searchResults != null && !searchResults.isEmpty ()) {
                    found = true;
                    //out.println (String.format("<p>orphan: %s still on site %s</p>", assetId, siteId));
                }
            }

            if (!found) {
                //out.println(String.format("<p>orphan: %s not on any site</p>", assetId));
                WccOrphanRecord.delete(ics, assetId);
            }
            found = false;

		}
    %>
 

    <%
    String cs_imagedir = ics.GetVar("cs_imagedir");
    WcsLocale wcsLocale = new WcsLocale(ics);

    ics.SetVar("wcc.pagination.pageSize", ics.GetVar("pageSize"));
    ics.SetVar("wcc.pagination.pageIndex", ics.GetVar("pageIndex"));
    ics.SetVar("wcc.pagination.sql.table", Constants.OrphanTable);
    ics.SetVar("wcc.pagination.sql.field", "ddocname");
    ics.SetVar("wcc.pagination.sql.order", "asc");
    ics.CallElement("WCC/History/PageFinder", null);
    
    int pageSize = Integer.parseInt(ics.GetVar("wcc.pagination.pageSize"));
    int pageIndex = Integer.parseInt(ics.GetVar("wcc.pagination.pageIndex"));
    
    int pageCount = 0, itemCount = 0, itemIndexBegin = 0, itemIndexEnd = 0;
    String ddocnameBegin = "\u0000", ddocnameEnd = "\uffff";
    
    if (pageIndex > 0) {
        pageCount = Integer.parseInt(ics.GetVar("wcc.pagination.pageCount"));;
        itemCount = Integer.parseInt(ics.GetVar("wcc.pagination.itemCount"));;
        itemIndexBegin = Integer.parseInt(ics.GetVar("wcc.pagination.itemIndexBegin"));;
        itemIndexEnd = Integer.parseInt(ics.GetVar("wcc.pagination.itemIndexEnd"));;
        ddocnameBegin = ics.GetVar("wcc.pagination.itemKeyBegin");
        ddocnameEnd = ics.GetVar("wcc.pagination.itemKeyEnd");
    }
    
    stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE ddocname BETWEEN ? AND ? ORDER BY ddocname ASC", Constants.OrphanTable), Collections.singletonList (Constants.OrphanTable));
    stmt.setElement (0, Constants.OrphanTable, "ddocname");
    stmt.setElement (1, Constants.OrphanTable, "ddocname");
    StatementParam param = stmt.newParam ();
    param.setString (0, ddocnameBegin);
    param.setString (1, ddocnameEnd);
    IList resultList = ics.SQL (stmt, param, false);

    int totalNum = resultList == null ? 0 : resultList.numRows();
    %>

        <table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
            <tr><td>
                <span class="title-text"><xlat:stream key="wcc/history/orphans/title"/></span></td></tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
        </table>

        <table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">
<%
if (pageIndex > 0 && pageCount > 1) {
%>
    <tr>
        <td colspan="3" align="right">
<%
    if (pageIndex > 1) {
%>
        <a href="ContentServer?pagename=WCC/OrphanDetail&pageSize=<%=pageSize%>&pageIndex=1">
            <img src="<%=cs_imagedir%>/graphics/common/icon/doubleArrowLeft.gif" height="12" width="15" border="0"/>
            <xlat:stream key="dvin/UI/First"/>
        </a>
        &nbsp;|
<%
    }

    if (pageIndex > 2) {
%>
        <a href="ContentServer?pagename=WCC/OrphanDetail&pageSize=<%=pageSize%>&pageIndex=<%=pageIndex - 1%>">
            <img src="<%=cs_imagedir%>/graphics/common/icon/leftArrow.gif" height="12" width="15" border="0"/>
            <xlat:stream key="dvin/UI/Previous"/>&nbsp;<%=pageSize%>
        </a>
        &nbsp;|
<%
    }

    {
        String label = wcsLocale.translates("dvin/UI/PageOf");
        int index = label.indexOf("Variables.displayPage");
        label = label.substring(0, index) + pageIndex + label.substring(index + "Variables.displayPage".length());
        index = label.indexOf("Variables.totalPages");
        label = label.substring(0, index) + pageCount + label.substring(index + "Variables.totalPages".length());
        
        out.print("&nbsp;" + label + "&nbsp;");
    }

    if (pageIndex < pageCount - 1) {
%>
        |&nbsp;
        <a href="ContentServer?pagename=WCC/OrphanDetail&pageSize=<%=pageSize%>&pageIndex=<%=pageIndex + 1%>">
            <xlat:stream key="dvin/Common/Next"/>&nbsp;<%=pageSize%>
            <img src="<%=cs_imagedir%>/graphics/common/icon/rightArrow.gif" height="12" width="15" border="0"/>
        </a>
<%
    }

    if (pageIndex < pageCount) {
%>
        |&nbsp;
        <a href="ContentServer?pagename=WCC/OrphanDetail&pageSize=<%=pageSize%>&pageIndex=<%=pageCount%>">
            <xlat:stream key="dvin/UI/Last"/>
            <img src="<%=cs_imagedir%>/graphics/common/icon/doubleArrow.gif" height="12" width="15" border="0"/>
        </a>
<%
    }
%>
        &nbsp;
        </td>
    </tr>
<%
}
%>
            <tr>
                <td></td>
                <td class="tile-dark" HEIGHT="1">
                    <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                <td></td>
            </tr>
            <tr>
                <td class="tile-dark" VALIGN="top" WIDTH="1"></td>
                <td>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
                        <tr>
                            <td colspan="7" class="tile-highlight">
                                <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                        </tr>
                        <tr>
                            <td class="tile-a" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                            <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                                <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/itemid"/></DIV></td>
                            <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                                <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/wcctoken"/></DIV></td>
                            <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                                <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/assetid"/></DIV></td>
                            <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                                <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/referenced"/></DIV></td>
                            <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                                <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/remark"/></DIV></td>
                            <td class="tile-c" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="7" class="tile-dark">
                                <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif ' /></td>
                        </tr>
    <%
    if (totalNum == 0) {
    %>
                        <tr class="tile-row-normal">
                            <td>&nbsp;</td>
                            <td colspan="6" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset">
                                    <xlat:stream key="wcc/progress/noactivity"></xlat:stream>
                                </DIV></td>
                        </tr>
    <%
    } else {
        for (int row = 1; row <= totalNum; row++) {

            resultList.moveTo(row);
            WccOrphanRecord orphanRecord = new WccOrphanRecord (ics,
                                                                resultList.getValue ("polldate"),
                                                                resultList.getValue("ddocname"),
                                                                resultList.getValue("assetid"),
                                                                resultList.getValue("wcctoken"),
                                                                resultList.getValue("progress"),
                                                                resultList.getValue ("assettype")
                                                                );

            if (row != 1) {
    %>
                        <tr>
                            <td colspan="7" class="light-line-color">
                                <img height="1" width="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                        </tr>
    <%
            }
    %>
                        <tr class='<%=row % 2 == 0 ? "tile-row-normal" : "tile-row-highlight"%>'>
                            <td>&nbsp;</td>
                            <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset"><%=orphanRecord.getDDocName ()%></DIV></td>
                            <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset"><%=orphanRecord.getWcctoken ()%></DIV></td>
                            <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset"><%=orphanRecord.getAssetType ()%>:<%=orphanRecord.getAssetid (false)%></DIV></td>
                            <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset">
                                    <asset:load name='oasset' type='<%=orphanRecord.getAssetType()%>' objectid='<%=orphanRecord.getAssetid(true)%>'/>
                                    <asset:referencedby  name="oasset" list="referers" embeddedreflist="refersintext"/>

                                    <ics:listloop listname="referers">
                                        <ics:listget listname="referers" fieldname="otype" output="rtype"/>
                                        <ics:listget listname="referers" fieldname="oid" output="rid"/>
                                        <asset:list type='<%=ics.GetVar("rtype")%>' list="rasset" field1="id" value1='<%=ics.GetVar("rid")%>'/>
                                        <ics:listloop listname="rasset">
                                            <ics:listget listname="rasset" fieldname="name"/>
                                        </ics:listloop>
                                        <br/>
                                    </ics:listloop>
                                </DIV></td>
                            <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                                <DIV class="small-text-inset" style="width: 400px; word-wrap: break-word; white-space: normal;"><%=orphanRecord.getI18nFullProgress (wcsLocale)%></DIV></td>
                            <td>&nbsp;</td>
                        </tr>
    <%
        }
    }
    %>
                    </table></td>
                <td class="tile-dark" VALIGN="top" WIDTH="1"></td>
            </tr>
            <tr>
                <td colspan="5" class="tile-dark" VALIGN="TOP" HEIGHT="1">
                    <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
            </tr>
            <tr>
                <td></td>
                <td background='<%=cs_imagedir%>/graphics/common/screen/shadow.gif'>
                    <IMG WIDTH="1" HEIGHT="5" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                <td></td>
            </tr>
<% if (pageIndex > 0) { %>
    <tr>
        <td colspan="3">
            <xlat:stream key="dvin/Common/Show"/>&nbsp;     
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=10">10</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=20">20</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=30">30</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=50">50</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=100">100</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=200">200</a>&nbsp;
            <a href="ContentServer?pagename=WCC/OrphanDetail&pageIndex=1&pageSize=300">300</a>&nbsp;
            <xlat:stream key="dvin/UI/itemsperpage"/>
        </td>
    </tr>
<% } %>
        </table>
</cs:ftcs>
