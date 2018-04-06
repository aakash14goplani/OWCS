<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Search/SortableTable
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<script type="text/javascript">
function makeSortable(tbl) {
	//embeds sort functionality into the cells in the thead of a table element.
	
	function byId(id) {
		//document.getElementById wrapper (or no-op)
		return (typeof id == 'string' ? document.getElementById(id) : id);
	}
	
	tbl = byId(tbl);
	var
		thd = tbl.getElementsByTagName('thead')[0],
		tbd = tbl.getElementsByTagName('tbody')[0],
		currSort = {
			idx: 1, //default assumes table is initially sorted by 2nd col
			desc: false
		};
	
	if (!thd || !thd.rows.length) return; //no thead to hook click events for sort
	
	function sort(idx) {
		//sort the table using the given column (zero-based).
		
		var rows = [], i, numRows = tbd.rows.length;
		
		//firstly, establish prefs - if we're already sorting by this column,
		//reverse the sort order; otherwise sort ascending by default.
		if (currSort.idx === idx) {
			currSort.desc = !currSort.desc;
		} else {
			currSort.idx = idx;
			currSort.desc = false;
		}
		
		//get current rows into a (non-live!) array:
		for (i = 0; i < numRows; i++) {
			rows.push(tbd.rows[i]);
		}
		
		//now sort the rows according to prefs
		rows.sort(icCellSortFn);
		
		//re-append all rows to the tbody, in the new order.
		//(This will effectively re-arrange them, moving each one down)
		for (i = 0; i < numRows; i++) {
			tbd.appendChild(rows[i]);
		}
	}
	
	function icCellSortFn(a, b) {
		//case-insensitive sort function receiving 2 td nodes
		//for our purposes, we can use innerHTML - no need to worry about escaping
		var
			atxt = a.cells[currSort.idx].innerHTML.toLowerCase(),
			btxt = b.cells[currSort.idx].innerHTML.toLowerCase(),
			ret = (atxt > btxt ? 1 : (atxt < btxt ? -1 : 0));
		
		//return appropriate for ascending/descending based on preset preference
		return (currSort.desc ? -ret : ret);
	}
	
	thd.onclick = function(evt) {
		evt = evt || window.event;
		var
			tgt = evt.target || evt.srcElement,
			tdrx = /^t[dh]$/i, //for filtering to td/th tags
			clsrx = /\bsortable\b/i; //for filtering to sortable columns
		
		//search for td or th node within which the click occurred
		while (tgt && !tdrx.test(tgt.tagName)) {
			tgt = tgt.parentNode;
		}
		
		//sort by the given column (if it is sortable)
		if (tgt && clsrx.test(tgt.className)) sort(tgt.cellIndex);
	};
}
</script>

</cs:ftcs>
