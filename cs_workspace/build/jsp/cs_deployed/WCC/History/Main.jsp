<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*,
                   com.fatwire.cs.core.db.PreparedStmt,
                   com.fatwire.cs.core.db.StatementParam,
                   oracle.stellent.ucm.poller.*,
                   oracle.stellent.ucm.poller.record.*,
                   oracle.wcs.util.*,
                   java.text.*,
                   java.util.*"
%>
<cs:ftcs><%--

INPUT  
 
OUTPUT

--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
    //detect if we have been submitted unto ourselves, and redirect if needed
    String action = ics.GetVar("action");
    if (action != null && (action = action.trim()).length() > 0) {
        if (action.equals("deletePolling")) {
            ics.CallElement("WCC/History/DeleteHistory", null);
        }
    }
    
    String cs_imagedir = ics.GetVar("cs_imagedir");
    
    WcsLocale wcsLocale = new WcsLocale(ics);
    Locale sessionLocale = wcsLocale.getSessionLocale();
    TimeZone sessionTimeZone = wcsLocale.getSessionTimeZone();

    DateFormat shortDateFmt = DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.MEDIUM, sessionLocale);
    shortDateFmt.setTimeZone(sessionTimeZone);

    DateFormat longDateFmt = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, sessionLocale);
    longDateFmt.setTimeZone(sessionTimeZone);

    ics.SetVar("wcc.pagination.pageSize", ics.GetVar("pageSize"));
    ics.SetVar("wcc.pagination.pageIndex", ics.GetVar("pageIndex"));
    ics.SetVar("wcc.pagination.sql.table", Constants.PollerTable);
    ics.SetVar("wcc.pagination.sql.field", "polldate");
    ics.SetVar("wcc.pagination.sql.order", "desc");
    ics.CallElement("WCC/History/PageFinder", null);
    
    int pageSize = Integer.parseInt(ics.GetVar("wcc.pagination.pageSize"));
    int pageIndex = Integer.parseInt(ics.GetVar("wcc.pagination.pageIndex"));
    
    int pageCount = 0, itemCount = 0, itemIndexBegin = 0, itemIndexEnd = 0;
    String polldateBegin = "0", polldateEnd = "9";
    
    if (pageIndex > 0) {
        pageCount = Integer.parseInt(ics.GetVar("wcc.pagination.pageCount"));;
        itemCount = Integer.parseInt(ics.GetVar("wcc.pagination.itemCount"));;
        itemIndexBegin = Integer.parseInt(ics.GetVar("wcc.pagination.itemIndexBegin"));;
        itemIndexEnd = Integer.parseInt(ics.GetVar("wcc.pagination.itemIndexEnd"));;
        polldateBegin = ics.GetVar("wcc.pagination.itemKeyBegin");
        polldateEnd = ics.GetVar("wcc.pagination.itemKeyEnd");
    }
    
    //Select events from poller table
    PreparedStmt stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE polldate BETWEEN ? AND ? ORDER BY polldate DESC", Constants.PollerTable), Collections.singletonList (Constants.PollerTable));
    stmt.setElement (0, Constants.PollerTable, "polldate");
    stmt.setElement (1, Constants.PollerTable, "polldate");
    StatementParam param = stmt.newParam ();
    param.setString (0, polldateEnd);
    param.setString (1, polldateBegin);
    IList resultList = ics.SQL (stmt, param, false);

    int totalNum = resultList == null ? 0 : resultList.numRows();

    ArrayList<WccPollerRecord> pollerRecList = null;

    if (totalNum > 0) {
    	pollerRecList = new ArrayList<WccPollerRecord> (totalNum);

        for (int i = 1; i <= totalNum; i++) {
            resultList.moveTo (i);

            WccPollerRecord pollerRecord = new WccPollerRecord(ics,
                                                               resultList.getValue("polldate"),
                                                               resultList.getValue("launcher"),
                                                               resultList.getValue("state"),
                                                               resultList.getValue("batch"),
                                                               resultList.getValue("success"),
                                                               resultList.getValue("miss"),
                                                               resultList.getValue("error"),
                                                               resultList.getValue("wcctoken"),
                                                               resultList.getValue("progress"));
            pollerRecList.add(pollerRecord);
        }
%>

        <script type="text/javascript">
            multiplePage = <%=pageCount > 1%>;
            deleteAllPages = false;
            globalTag = new DeleteTag('delete-all');
            singleTags = new Array();
<%          for (int i = 0; i < pollerRecList.size(); i++) { %>
            singleTags.push(new DeleteTag('delete-<%=i%>', '<%=pollerRecList.get(i).getPollDate().getDatabaseFormat ()%>'));
<%          } %>

            function DeleteTag (checkId, polldate) {
                this.checked = false;
                this.checkId = checkId;
                this.polldate = polldate;
            }

            function onSingleCheckChanged (checkIndex) {
                singleTags[checkIndex].checked = dojo.byId (singleTags[checkIndex].checkId).checked;

                globalTag.checked = allSingleChecked ();
                dojo.byId (globalTag.checkId).checked = globalTag.checked;
				updateCheckboxMsg();

                deleteAllPages = false;
            }

            function allSingleChecked () {
                for (var i = 0; i < singleTags.length; i++) {
                    if (!singleTags[i].checked) {
                        return false;
                    }
                }
                return true;
            }

			
			function updateCheckboxMsg() {
				if (!multiplePage) return;
				dojo.html.set('wcc-history-checked-page-msg', 
				  '<xlat:stream key="wcc/history/message/CheckedEntries"/>' //{0} entries on this page are selected. {1}
					.replace('{0}', '<span style="font-weight:bold;"><%=totalNum%></span>')
					.replace('{1}', '<a id="wcc-history-check-all" href="#">{0}</a>'
					  .replace('{0}', '<xlat:stream key="wcc/history/message/CheckAllEntries"/>' //Select all {0} entries?
					    .replace('{0}', '<span style="font-weight:bold;"><%=itemCount%></span>')))
				);
				dojo.html.set('wcc-history-checked-all-msg', 
				  '<xlat:stream key="wcc/history/message/AllEntriesChecked"/>' //All {0} entries are selected.
					.replace('{0}', '<span id="wcc-history-total-count-all" style="font-weight:bold;"><%=itemCount%></span>')
				);
				dojo.style('wcc-history-checked-all-msg', {'display': 'none'});
				dojo.style('wcc-history-checked-page-msg', {'display': 'inline'});
				dojo.style('wcc-history-checked-msg', {'display': globalTag.checked ? 'table-cell' : 'none'});
			}

            function onGlobalCheckChanged () {
                globalTag.checked = dojo.byId (globalTag.checkId).checked;

                for (var i = 0; i < singleTags.length; i++) {
                    singleTags[i].checked = globalTag.checked;
                    dojo.byId (singleTags[i].checkId).checked = globalTag.checked;
                }
                
                deleteAllPages = false;
				updateCheckboxMsg(globalTag.checked);
            }
			
            function submitDeleteForm () {
                var count = 0;
                for (var i = 0; i < singleTags.length; i++) {
                    if (singleTags[i].checked) {
                        count++;
                    }
                }
                if (count == 0) {
                    alert ('<xlat:stream key="wcc/history/validation/selectone" escape="true" encode="false"/>');
                    return;
                }

                var reqForm = dojo.create ("form", {
                    action:"ContentServer",
                    method:"post"
                }, document.AppForm, "after");

                dojo.create ("input", {
                    type:"hidden",
                    name:"_authkey_",
                    value:"<%=session.getAttribute("_authkey_")%>"
                }, reqForm);

                dojo.create ("input", {
                    type:"hidden",
                    name:"pagename",
                    value:"WCC/History"
                }, reqForm);

                dojo.create ("input", {
                    type:"hidden",
                    name:"action",
                    value:"deletePolling"
                }, reqForm);

                if (globalTag.checked) {
                	
                	var range = "0000;9999";
               	    if (!multiplePage || !deleteAllPages) {
               	    	range = singleTags[singleTags.length - 1].polldate + ";" + singleTags[0].polldate;
                	}
                    
                    dojo.create ("input", {
                        type:"hidden",
                        name:"delete.fragment",
                        value:range
                    }, reqForm);
                    
                } else {

                    var count = 0;
                    for (var i = 0; i < singleTags.length; i++) {
                        var singleTag = singleTags[i];
                        if (!singleTag.checked) {
                            continue;
                        }

                        dojo.create ("input", {
                            type:"hidden",
                            name:"delete.single." + count,
                            value:singleTag.polldate
                        }, reqForm);

                        count++;
                    }
                    dojo.create ("input", {
                        type:"hidden",
                        name:"delete.count",
                        value:count
                    }, reqForm);
                }

                reqForm.submit ();
            }

            dojo.addOnLoad (function () {
                var parentTag;
                var inputTag;

				dojo.connect(dojo.byId('wcc-history-checked-page-msg'), 'onclick', function(evt) {
					var trgt = evt.target;
					if ((trgt && trgt.tagName.toLowerCase() === 'a')
					  || (trgt.parentNode && trgt.parentNode.tagName.toLowerCase() === 'a')) {
						deleteAllPages = true;
						dojo.style('wcc-history-checked-all-msg', {'display': 'inline'});
						dojo.style('wcc-history-checked-page-msg', {'display': 'none'});
					}
					return dojo.stopEvent(evt);
				});
				
                parentTag = dojo.byId ("delete-link");
                inputTag = new fw.ui.dijit.Button (
                        {   label:'<xlat:stream key="dvin/Common/Delete" escape="true" encode="false"/>',
                        	title:'<xlat:stream key="wcc/history/message/deletechecked" escape="true" encode="false"/>'
                        }).placeAt (parentTag);
            });
        </script>

<%
    } // if (totalNum > 0)
%>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
    <tr>
    	<td><span class="title-text"><xlat:stream key="wcc/progress/past/title"/></span></td>
    </tr>
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
        <a href="ContentServer?pagename=WCC/History&pageSize=<%=pageSize%>&pageIndex=1">
            <img src="<%=cs_imagedir%>/graphics/common/icon/doubleArrowLeft.gif" height="12" width="15" border="0"/>
            <xlat:stream key="dvin/UI/First"/>
        </a>
        &nbsp;|
<%
    }

    if (pageIndex > 2) {
%>
        <a href="ContentServer?pagename=WCC/History&pageSize=<%=pageSize%>&pageIndex=<%=pageIndex - 1%>">
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
        <a href="ContentServer?pagename=WCC/History&pageSize=<%=pageSize%>&pageIndex=<%=pageIndex + 1%>">
            <xlat:stream key="dvin/Common/Next"/>&nbsp;<%=pageSize%>
            <img src="<%=cs_imagedir%>/graphics/common/icon/rightArrow.gif" height="12" width="15" border="0"/>
        </a>
<%
    }

    if (pageIndex < pageCount) {
%>
        |&nbsp;
        <a href="ContentServer?pagename=WCC/History&pageSize=<%=pageSize%>&pageIndex=<%=pageCount%>">
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
                    <td colspan="19" class="tile-highlight">
                        <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                </tr>
                <tr>
                    <td class="tile-a" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/timestamp"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/launcher"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/state"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/batchsize"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/successful"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/history/col/state/miss"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>
                        <DIV class="new-table-title"><xlat:stream key="wcc/progress/col/error"/></DIV></td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
                    <td class="tile-b" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>

<% if (totalNum > 0) { %>
                        <DIV class="new-table-title"><input id='delete-all' type='checkbox' onclick='onGlobalCheckChanged()'/>
                            <xlat:stream key="dvin/Common/All"/>
                        </DIV>
<% } %>
                    </td>
                    <td class="tile-c" background='<%=cs_imagedir%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="19" class="tile-dark">
                        <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif ' /></td>
                </tr>
                <tr>
                    <td id="wcc-history-checked-msg" colspan="19" class="MessageBox" style="display:none;text-align:center;background-color:#EDFEE3;border-bottom:solid 1px gray">
                        <span id="wcc-history-checked-page-msg" class="messageWrapper"></span>
                        <span id="wcc-history-checked-all-msg" class="messageWrapper" style="display:none;"></span></td>
                </tr>

<% if (totalNum == 0) { %>
                <tr class="tile-row-normal">
                    <td></td>
                    <td colspan="18" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset">
                            <xlat:stream key="wcc/progress/noactivity"/>
                        </DIV></td>
                </tr>
<%
} else {
    String inspectAlt = wcsLocale.translates("dvin/Common/InspectThisItem");
    for (int i = 0; i < pollerRecList.size(); i++) {
        WccPollerRecord pollerRecord = pollerRecList.get(i);
        PollDate pollDate = pollerRecord.getPollDate ();

        String errorColorCnt = pollerRecord.getError () > 0 ? "color:red" : "";
        String errorColor = pollerRecord.hasError () ? "color:red" : "";
        
        String shortDateStr = pollDate.getFormattedDate (shortDateFmt);
        String longDateStr = pollDate.getFormattedDate (longDateFmt);

        if (i != 0) {
%>
                <tr>
                    <td colspan="19" class="light-line-color">
                        <img height="1" width="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
                </tr>
<%      } //row != 0 %>

                <tr class='<%=i % 2 == 0 ? "tile-row-normal" : "tile-row-highlight"%>'>
                    <td></td>
                    <td VALIGN="bottom">
<%
		if (pollerRecord.getBatch () == 0L) {
%>		                    
						&nbsp;
<%
		} else {
%>						
                        <a title="<%=inspectAlt%>" href="ContentServer?pagename=WCC/HistoryDetail&backpage=WCC/History&polldate=<%=pollDate.getDatabaseFormat ()%>&screendate=<%=longDateStr%>">
                            <img height="14" width="14" hspace="2" vspace="4" src="<%=cs_imagedir%>/graphics/common/icon/iconInspectContent.gif"  border="0"/>
                        </a></td>
<%
		}
%>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV title="<%=longDateStr%>" class="small-text-inset"><%=shortDateStr%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset"><%=pollerRecord.getI18nLauncher (wcsLocale)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset" style="<%=errorColor%>"><%=pollerRecord.getState ().getI18nName (wcsLocale)%></DIV></td>
                    <td></td>
<%
        if (pollerRecord.getState ().isDone () && pollerRecord.getBatch () == 0L) {
            String message = "";
            if (pollerRecord.getState () == WccEnum.Reset) {
                message = wcsLocale.translates("wcc/pdb/poller/tokenreset");
            } else if (pollerRecord.getState () == WccEnum.Finished) {
                message = wcsLocale.translates("wcc/pdb/poller/noupdates");
            }
%>
                    <td colspan="7" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset"><%=message%></DIV></td>
<%
        } else {
%>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset"><%=pollerRecord.getBatch ()%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset"><%=pollerRecord.getSuccess (false)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset"><%=pollerRecord.getMiss (false)%></DIV></td>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset" style="<%=errorColorCnt%>"><%=pollerRecord.getError (false)%></DIV></td>
<%
        }
%>
                    <td></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                        <DIV class="small-text-inset">
                            <input id='delete-<%=i%>' type='checkbox' onclick='onSingleCheckChanged(<%=i%>)'/>
                        </DIV></td>
                    <td></td>
                </tr>
<% if (pollerRecord.hasProgress () && pollerRecord.hasError ()) { %>
                <tr class='<%=i % 2 == 0 ? "tile-row-normal" : "tile-row-highlight"%>'>
                    <td colspan="9"></td>
                    <td colspan="12" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV class="small-text-inset" style="<%=errorColor%>"><%=pollerRecord.getI18nFullProgress (wcsLocale)%></DIV></td>
                </tr>
<% } %>

<%
        } //for loop
    } //else
%>
            </table></td>
        <td class="tile-dark" VALIGN="top" WIDTH="1"></td>
    </tr>
    <tr>
        <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1">
            <IMG WIDTH="1" HEIGHT="1" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
    </tr>
    <tr>
        <td></td>
        <td background='<%=cs_imagedir%>/graphics/common/screen/shadow.gif'>
            <IMG WIDTH="1" HEIGHT="5" src='<%=cs_imagedir%>/graphics/common/screen/dotclear.gif' /></td>
        <td></td>
    </tr>

<% if (totalNum > 0) { %>
    <tr>
        <td colspan="3" align="right">
            <a id="delete-link" href="javascript:void(0)" onclick="submitDeleteForm();"></a></td>
    </tr>
<% } %>

<% if (pageIndex > 0) { %>
    <tr>
        <td colspan="3">
			<xlat:stream key="dvin/Common/Show"/>&nbsp;     
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=10">10</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=20">20</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=30">30</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=50">50</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=100">100</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=200">200</a>&nbsp;
			<a href="ContentServer?pagename=WCC/History&pageIndex=1&pageSize=300">300</a>&nbsp;
			<xlat:stream key="dvin/UI/itemsperpage"/>
        </td>
    </tr>
<% } %>

</table>

</cs:ftcs>
