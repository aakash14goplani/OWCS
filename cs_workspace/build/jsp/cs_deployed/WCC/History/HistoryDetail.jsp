<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%><%@ taglib
	prefix="ics" uri="futuretense_cs/ics.tld"%><%@ taglib prefix="render"
	uri="futuretense_cs/render.tld"%><%@ taglib prefix="xlat"
	uri="futuretense_cs/xlat.tld"%><%@ page
	import="COM.FutureTense.Interfaces.*,
	        com.fatwire.cs.core.db.PreparedStmt,
	        com.fatwire.cs.core.db.StatementParam,
	        oracle.stellent.ucm.poller.record.*,
	        oracle.stellent.ucm.poller.*,
	        oracle.wcs.util.*,java.util.*"%>
<cs:ftcs><%--

INPUT  

OUTPUT

--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<style type="text/css">
.hidden {
	display: none;
}

.unhidden {
	display: block;
}

.collapse {
	background:
		url('<%=ics.GetVar("cgipath")%>js/fw/images/AutoHideTopBar/open.png')
		no-repeat scroll 0 0;
	cursor: pointer;
	height: 11px;
	position: absolute;
	right: 3px;
	top: 17px;
	width: 11px;
}
</style>

	<script type="text/javascript">
		function toggleremark() {
			for ( var i = 0; rclass = dojo.query('.remark')[i]; i++) {
				toggleClass(rclass, "unhidden", "hidden");
			}
		}

		function hasClass(ele, cls) {
			return ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
		}

		function addClass(ele, cls) {
			if (!this.hasClass(ele, cls))
				ele.className += " " + cls;
		}

		function removeClass(ele, cls) {
			if (hasClass(ele, cls)) {
				var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
				ele.className = ele.className.replace(reg, ' ');
			}
		}

		function replaceClass(ele, oldClass, newClass) {
			if (hasClass(ele, oldClass)) {
				removeClass(ele, oldClass);
				addClass(ele, newClass);
			}
			return;
		}

		function toggleClass(ele, cls1, cls2) {
			if (hasClass(ele, cls1)) {
				replaceClass(ele, cls1, cls2);
			} else if (hasClass(ele, cls2)) {
				replaceClass(ele, cls2, cls1);
			} else {
				addClass(ele, cls1);
			}
		}

		dojo.addOnLoad(function() {
			var parentTag;
			var inputTag;
			var alt;

			parentTag = dojo.byId("back-link");
			alt = '<xlat:stream key="dvin/UI/Back"></xlat:stream>';
			inputTag = new fw.ui.dijit.Button({
				label : alt,
				title : alt
			}).placeAt(parentTag);
		});
	</script>

	<%
		WcsLocale wcsLocale = new WcsLocale(ics);

		String dbPollDate = ics.GetVar("polldate").replace(' ', '+');
		String screenDate = ics.GetVar("screendate");

        PreparedStmt stmt = new PreparedStmt (String.format ("SELECT * FROM %s WHERE polldate = ? ORDER BY wcctoken", Constants.BatchTable), Collections.singletonList (Constants.BatchTable));
        stmt.setElement (0, Constants.BatchTable, "polldate");
        StatementParam param = stmt.newParam ();
        param.setString (0, dbPollDate);
        IList resultList = ics.SQL (stmt, param, false);

		int totalNum = resultList == null ? 0 : resultList.numRows();
	%>

	<table class="width-outer-70" cellspacing="0" cellpadding="0"
		border="0">
		<tr>
			<td><span class="title-text"><xlat:stream
						key="wcc/progress/past/title"></xlat:stream> - <%=screenDate%></span></td>
		</tr>
		<ics:callelement
			element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar" />
	</table>

	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">
		<tr>
			<td></td>
			<td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1"
				src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			<td></td>
		</tr>
		<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1"></td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0"
					bgcolor="#ffffff">
					<tr>
						<td colspan="10" class="tile-highlight"><IMG WIDTH="1"
							HEIGHT="1"
							src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
					</tr>
					<tr>
						<td class="tile-a"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title">
								<xlat:stream key="wcc/progress/col/itemid"></xlat:stream>
							</DIV></td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title">
								<xlat:stream key="wcc/progress/col/assetid"></xlat:stream>
							</DIV></td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title">
								<xlat:stream key="wcc/progress/col/status"></xlat:stream>
							</DIV></td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;</td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title remark unhidden">
								<xlat:stream key="wcc/progress/col/remark"></xlat:stream>
								<a href="javascript:toggleremark();"> <img style="border:none;vertical-align:top"
									title='<xlat:stream key="wcc/progress/col/progress/hovertip"></xlat:stream>'
									src='<%=ics.GetVar("cgipath")%>js/fw/images/ui/tree/treeExpand.png'></a></DIV></td>
						<td class="tile-b"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>
							<DIV class="new-table-title remark hidden">
								<xlat:stream key="wcc/progress/col/remark"></xlat:stream>
								<a href="javascript:toggleremark();"> <img style="border:none;vertical-align:top"
									title='<xlat:stream key="wcc/progress/col/remark/hovertip"></xlat:stream>'
									src='<%=ics.GetVar("cgipath")%>js/fw/images/ui/tree/treeCollapse.png'></a></DIV></td>
						<td class="tile-c"
							background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="10" class="tile-dark"><IMG WIDTH="1" HEIGHT="1"
							src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif ' /></td>
					</tr>
					<%
						if (totalNum == 0) {
					%>
					<tr class="tile-row-normal">
						<td>&nbsp;</td>
						<td colspan="10" VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
							<DIV class="small-text-inset">
								<xlat:stream key="wcc/progress/noactivity"></xlat:stream>
							</DIV></td>
					</tr>
					<%
						} else {
								for (int row = 1; row <= totalNum; row++) {
									resultList.moveTo(row);
									WccBatchRecord batchRecord = new WccBatchRecord(ics,
											resultList.getValue("polldate"),
											resultList.getValue("ddocname"),
											resultList.getValue("status"),
											resultList.getValue("wcctoken"),
											resultList.getValue("assetid"),
											resultList.getValue("remark"),
											resultList.getValue("progress"));

									String errorColor = batchRecord.hasError()
											? "color:red"
											: "";

									if (row != 1) {
					%>
					<tr>
						<td colspan="10" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
					</tr>
					<%
						}
					%>
					<tr
						class='<%=row % 2 == 0
								? "tile-row-normal"
								: "tile-row-highlight"%>'>
						<td></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV
								class="small-text-inset"><%=batchRecord.getDDocName()%></DIV></td>
						<td></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV
								class="small-text-inset"><%=batchRecord.getAssetid(false)%></DIV></td>
						<td></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV
								class="small-text-inset" style="<%=errorColor%>">
								&nbsp;<%=batchRecord.getStatus()
								.getI18nName(wcsLocale)%>&nbsp;
							</DIV></td>
						<td></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV
								class="small-text-inset remark unhidden"
								style="width: 400px; word-wrap: break-word; white-space: normal;"><%=batchRecord.getI18nRemark(wcsLocale)%></DIV></td>
						<td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT"><DIV
								class="small-text-inset remark hidden"
								style="width: 400px; word-wrap: break-word; white-space: normal;"><%=batchRecord.getI18nFullProgress(wcsLocale)%></DIV></td>
						<td></td>
					</tr>
					<%
						}
							}
					%>
				</table></td>
			<td class="tile-dark" VALIGN="top" WIDTH="1"></td>
		</tr>
		<tr>
			<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG
				WIDTH="1" HEIGHT="1"
				src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
		</tr>
		<tr>
			<td></td>
			<td
				background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'>
				<IMG WIDTH="1" HEIGHT="5"
				src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
			<td></td>
		</tr>
	</table>

	<div class="width-outer-70">
		<A id="back-link" href="ContentServer?pagename=<%=ics.GetVar("backpage")%>"></A>
	</div>

</cs:ftcs>
