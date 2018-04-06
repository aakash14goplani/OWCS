<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %><%@
	taglib prefix="ics" uri="futuretense_cs/ics.tld" %><%@
	taglib prefix="asset" uri="futuretense_cs/asset.tld" %><%@
	taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %><%@
	taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %><%@
	page import="java.util.*" %><%@
	page import="java.text.*" %><%@
	page import="COM.FutureTense.Interfaces.*" %><%@
	page import="COM.FutureTense.Util.ftMessage" %><%@
	page import="COM.FutureTense.Util.ftErrors" %><%@
	page import="com.openmarket.xcelerate.util.TimePatternInfo"%><%

/*	OpenMarket/Xcelerate/Admin/Util/EventFront.jsp

*/

%><cs:ftcs>
<%!
    static final String[] days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
    static final String[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
%>
<%
    String sEventTime = ics.GetVar("eventtime");
	TimePatternInfo.getTimeFormat(ics, ics.GetSSVar("locale"));
	String preferHour = ics.GetVar("preferHour");
%>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/prototabs.js"></script>
<script type="text/javascript">
	//often-used localestrings:
	var xlatAll = '<xlat:stream key="dvin/Common/All"/>';
	var xlatAny = '<xlat:stream key="dvin/Common/Any"/>';
	
	//arrays used for string representations:
	var days = new Array();
<% for (int i = 0; i < 7; i++) { %>
	days[<%=i%>] = '<xlat:stream key='<%="dvin/AT/Common/" + days[i]%>' encode="false" escape="true"/>';
<% } %>
	var months = new Array();
<% for (int i = 0; i < 12; i++) { %>
	months[<%=i%>] = '<xlat:stream key='<%="dvin/AT/Common/" + months[i]%>' encode="false" escape="true"/>';
<% } %>
	//initialize value arrays:
	var domvals = new Array(); // for date-of-month values (0-30)
	for (var i = 0; i < 31; i++) domvals[i] = false;
	var dowvals = new Array(); // for day-of-week values (0-6)
	for (var i = 0; i < 7; i++) dowvals[i] = false;
	var moyvals = new Array(); // for month-of-year values (0-11)
	for (var i = 0; i < 12; i++) moyvals[i] = false;
	var hrvals = new Array(); // for hour values (0-23)
	for (var i = 0; i < 24; i++) hrvals[i] = false;
	var minvals = new Array(); // for minute values (5-minute steps)
	for (var i = 0; i < 12; i++) minvals[i] = false;

	/* UI COMPONENT FUNCTIONS - event handlers, etc. */

	//flag for mousedrag - null if not dragging.
	//set to true when dragging to select values.
	//set to false when dragging to deselect values.
	var drag = null;

	function initEventHandlers()
	{ //initializes event handlers for custom select fields
		var ids = ['dowfields', 'domfields', 'moyfields', 'hrfields', 'minfields'];
		for (var i = 0; i < ids.length; i++)
		{
			if (!$(ids[i]))
				continue;
			var tds = $(ids[i]).getElementsByTagName('td');
			for (var j = 0; j < tds.length; j++) {
				if (!tds[j].id /*|| !tds[j].innerHTML || tds[j].innerHTML == '&nbsp;'*/)
					continue;
				tds[j].onmousedown = fieldClick;
				tds[j].onmousemove = fieldHover;
			}
		}
		document.onmouseup = fieldRelease; //pick this up anywhere on-screen
		//for enabled/disabled radiobuttons
		if (!$('eventenabled'))
			return;
		var rbs = $('eventenabled').getElementsByTagName('input');
		for (var i = 0; i < rbs.length; i++) {
			if (rbs[i].type != 'radio')
				continue;
			rbs[i].onclick = updateEvent;
		}
	}

	function fieldClick(e)
	{ //onmousedown handler for custom select fields
		if (!e) e = window.event;
		if (!e) return;
		var target = (e.target ? e.target : e.srcElement);
		var m = target.id.match(/^([a-z]+)(\d+)$/);
		if (!m || m.length < 3)
			return;
		drag = togglefield(m[1], parseInt(m[2]));
	}
	
	function fieldRelease(e)
	{ //onmouseup handler
		drag = null;
	}
	
	function fieldHover(e)
	{ //onmousemove handler for custom select fields
		if (drag == null)
			return; //nothing to worry about
		if (!e)
			e = window.event;
		if (!e)
			return;
		var target = (e.target ? e.target : e.srcElement);
		//parse array and index from target id
		var m = target.id.match(/^([a-z]+)(\d+)$/);
		if (!m || m.length < 3)
			return; //match failed
		togglefield(m[1], parseInt(m[2]), drag);
		clearSelection();
	}
	
	//selectAll: [de]selects all fields in the desired set.
	//pre should be 'dow', 'dom', or 'moy'.
	//val should be true to select all, or false to select none.
	function selectAll(pre, val)
	{
		if (!$(pre + 'fields'))
			return false;
		var tds = $(pre + 'fields').getElementsByTagName('td');
		for (var i = 0; i < tds.length; i++)
		{
			if (!tds[i].id)
				continue;
			var m = tds[i].id.match(new RegExp('^' + pre + '(\\d+)$'));
			if (!m || m.length < 2)
				continue;
			togglefield(pre, parseInt(m[1]), val);
		}
		return false;
	}
	
	function updateEvent()
	{ //updates UI visual elements based on event enabled state.
		var f = document.forms[0];
		if (!f || !f.elements['enabled'] || f.elements['enabled'].length != 2)
			return false;
		if (f.elements['enabled'][0].checked) { //enabled
/* doesnt work very well
			if ($('eventenabled'))
				$('eventenabled').style['backgroundColor'] = '#dce4ec';
*/
			if ($('eventdetail'))
				$('eventdetail').style['color'] = '';
		} else { //disabled
/*
			if ($('eventenabled'))
				$('eventenabled').style['backgroundColor'] = '';
*/
			if ($('eventdetail'))
				$('eventdetail').style['color'] = '#b3b3b3';
		}
	}
	
	/* UI COMPONENT FUNCTIONS - utility functions */
	
	//togglefield: toggles the field indicated by arr/index.
	//arr should be 'dow', 'dom', 'moy', 'hr', or 'min'.
	//value is optional; if provided, will only toggle if the
	//current state of the field is not already the one given.
	function togglefield(arr, index, value)
	{
		var a = eval(arr + 'vals'); // array being referred to
		if (!a) return null;
		if (typeof(value) != 'undefined' && a[index] == value)
			return value;
		//update array index:
		var retval = a[index] = !a[index];
		//update field in UI:
		$(arr + index).className =
			(retval ? 'sel' : '');
		//update text pertaining to updated field:
		updateStr(arr);
		return retval;
	}
	
	//updateStr: updates text displayed above form fields.
	//arr should be one of 'dow', 'dom', 'moy', 'hr', or 'min',
	//corresponding to one of the 5 displayed fields.
	//If arr is not provided, all 5 will be updated.
	function updateStr(arr)
	{
		//variables used for temporary storage:
		var tmparr;
		var str = ''; //used for temporary storage
		if (!arr || arr == 'dow')
		{
			tmparr = condense(dowvals);
			if (tmparr.length == 0 || tmparr.length == dowvals.length)
				str = xlatAll;
			else
			{
				str = simplode(tmparr);
				str = str.replace(/(\d+)/g, function(d) { return days[d]; });
			}
			$('dowstr').innerHTML = str;
		}
		if (!arr || arr == 'dom')
		{
			tmparr = condense(domvals);
			if (tmparr.length == 0 || tmparr.length == domvals.length)
				str = xlatAll;
			else
				str = simplode(tmparr, 1) + ' <xlat:stream key="dvin/UI/Util/ofeachmonth" encode="false" escape="true"/>';
			$('domstr').innerHTML = str;
		}
		if (!arr || arr == 'dow' || arr == 'dom')
		{ //extra processing for "Any" vs. "All"
			var domstr = $('domstr').innerHTML;
			var dowstr = $('dowstr').innerHTML;
			//to make things simpler, set any "All"s to "Any"s first
			if (dowstr == xlatAll)
				dowstr = xlatAny;
			if (domstr == xlatAll)
				domstr = xlatAny;
			if (dowstr == xlatAny && domstr == xlatAny)
			{
				dowstr = xlatAll;
				domstr = xlatAll;
			}
			$('dowstr').innerHTML = dowstr;
			$('domstr').innerHTML = domstr;
		}
		if (!arr || arr == 'moy')
		{
			tmparr = condense(moyvals);
			if (tmparr.length == 0 || tmparr.length == moyvals.length)
				str = '<xlat:stream key="dvin/UI/Util/Monthly" encode="false" escape="true"/>';
			else
			{
				str = simplode(tmparr);
				str = str.replace(/(\d+)/g, function(m) { return months[m]; });
			}
			$('moystr').innerHTML = str;
		}
		if (!arr || arr == 'hr')
		{
			tmparr = condense(hrvals);
			if (tmparr.length == 0 || tmparr.length == hrvals.length)
				str = xlatAll;
			else
			{
				if (n = getInterval(tmparr, 0, 24))
				{
					str = '<xlat:stream key="dvin/UI/Util/Every" encode="false" escape="true"/> ';
					str += n + ' <xlat:stream key="dvin/UI/Util/Hours" encode="false" escape="true"/>';
				}
				else
				{
/* not-so-old impl
					str = '';
					for (var i = 0; i < 24; i += 12)
					{ //process AM and PM separately for improved brevity
						tmparr = condense(hrvals.slice(i, i+12));
						if (tmparr.length > 0)
						{
							var ap = (i == 0 ? '<xlat:stream key="dvin/AT/Common/AM" encode="false" escape="true"/>'
								: '<xlat:stream key="dvin/AT/Common/PM" encode="false" escape="true"/>');
							var tmpstr = simplode(tmparr);
							tmpstr = tmpstr.replace(/^0/, '12');
							tmpstr = tmpstr.replace(/(\d+)/g, '$1' + ap);
							if (str)
								str += ', ';
							str += tmpstr;
						}
					}
*/
					var xlatAM = '<xlat:stream key="dvin/AT/Common/AMSpecial" encode="false" escape="true"/>';
					var xlatPM = '<xlat:stream key="dvin/AT/Common/PMSpecial" encode="false" escape="true"/>';
					str = simplode(tmparr);
					if (<%=preferHour%> == 12)
					{
						str = str.replace(/(\d+)/g,
							function(h) { return (h % 12 ? h % 12 : 12) + (h / 12 < 1 ? xlatAM : xlatPM); });
					}
				}
			}
			$('hrstr').innerHTML = str;
		}
		if (!arr || arr == 'min')
		{
			tmparr = condense(minvals);
			if (tmparr.length == 0) //skip all processing, already know
			{
				str = '<xlat:stream key="dvin/UI/Util/Every" encode="false" escape="true"/> ';
				str += 5 + ' <xlat:stream key="dvin/UI/Util/Minutes" encode="false" escape="true"/>';
			}
			else
			{
				if (n = getInterval(tmparr, 0, 12))
				{
					str = '<xlat:stream key="dvin/UI/Util/Every" encode="false" escape="true"/> ';
					str += n*5 + ' <xlat:stream key="dvin/UI/Util/Minutes" encode="false" escape="true"/>';
				}
				else
				{
					str = '<xlat:stream key="dvin/AT/Common/at" encode="false" escape="true"/> ';
					for (var i = 0; i < tmparr.length; i++)
					{
						var curr = tmparr[i] * 5;
						if (curr < 10) curr = '0' + curr;
						str += ':' + curr + ', ';
					}
					str = str.substr(0, str.length - 2); //ditch trailing ', '
				}
			}
			str += ' <xlat:stream key="dvin/UI/Util/ofeachhour" encode="false" escape="true"/>';
			$('minstr').innerHTML = str;
		}
	}
	
	//condense: given an array of booleans, returns a smaller array
	//containing values mapping to those indices in the original array
	//whose values evaluated true.
	//Used in human-readable string creation before calling simplode.
	function condense(arr)
	{
		var newarr = new Array();
		if (!arr || !arr.length)
			return newarr;
		for (var i = 0; i < arr.length; i++)
		{
			if (arr[i])
				newarr.push(i);
		}
		return newarr;
	}
	
	//simplode: smart implode (or simple-to-read implode, pick your favorite)
	//works mostly like implode, but will do a couple of nice things to make
	//the resulting string more human-readable.
	//Note that this function expects a condensed array (see condense above).
	function simplode(arr, offset, factor)
	{
		var retstr = '';
		if (!arr || !arr.length)
			return retstr;
		if (!offset || offset < 0)
			offset = 0;
		if (!factor || factor < 1)
			factor = 1;
		//variables for range detection
		var prev = arr[0] * factor + offset; //initialize to first item
		var rangestart = -1; //safe, unobtrusive default
		retstr += prev; //always add first item.
		for (var i = 1; i < arr.length; i++)
		{
			var curr = arr[i] * factor + offset;
			//consecutive range checking
			if (curr - 1 == prev)
			{
				if (rangestart < 0)
					rangestart = prev;
			}
			else
			{
				if (rangestart < 0)
					retstr += ', ' + curr;
				else
				{
					retstr += '-' + prev + ', ' + curr;
					rangestart = -1;
				}
			}
			
			prev = curr;
		}
		if (rangestart >= 0) //still have a range to finish printing
			retstr += '-' + prev;
		return retstr;
	}
	
	//getInterval: given a strictly-increasing array of integers and a
    //min (inclusive) and max (exclusive), judges whether the array's
	//contents are cyclic within the given range.
	//Returns the cycle's interval if so, otherwise returns 0.
	//Note that currently getInterval will only work on divisible ranges
	//(i.e. this is not feasible for use with dow/dom).
	function getInterval(arr, min, max)
	{
		// if we ever want dom/dow to work with this, remove mod check
		if (!arr.length || arr.length < 2 || (max - min) % arr.length != 0)
			return 0; //cannot be cyclic
		var factor = (max - min) / arr.length;
		var offset = arr[0];
		if (offset >= factor)
			return 0; //that can't work very well, now can it.
		for (var i = 1; i < arr.length; i++)
		{
			if (arr[i] != i * factor + offset)
				return 0;
		}
		// if we haven't returned by now, we've got a cycle.
		return factor;
	}
	
	function clearSelection()
	{ //cross-browser text selection clearing
		if (document.selection)
			document.selection.empty();
		else if (window.getSelection)
			window.getSelection().removeAllRanges();
	}
	
	/* FORM DATA FUNCTIONS - for initialization and submission */
	
	//preSave - constructs the internal representation to be stored in the DB
	//(do we want to warn if nothing is tweaked? i.e. event will run every 5 mins)
    function preSave()
    {
		var timestr = '';
		timestr += implode(hrvals) + ':';
		timestr += implode(minvals, 0, 5) + ':0 ';
		timestr += implode(dowvals) + '/';
		timestr += implode(domvals, 1) + '/';
		timestr += implode(moyvals, 1);
        document.forms[0].elements["time"].value = timestr;
        return true;
    } // end function preSave()

	//prePopulate - populates form based on recalled publish event string.
	//(This also initializes the tabs and decides which tab to show first.)
    function prePopulate(eventTime)
    {
		var deftab = '_dow';
		if (eventTime)
		{ //reverse the preSave process - fill fields from string
			var m = eventTime.match(/^(.+):(.+):.+ (.+)\/(.+)\/(.+)$/);
			if (m && m.length == 6)
			{
				//create arrays to enable iterative approach
				var names = ['hr', 'min', 'dow', 'dom', 'moy'];
				var factors = [1, 5, 1, 1, 1];
				var offsets = [0, 0, 0, 1, 1];
				for (var i = 0; i < 5; i++)
				{
					var a = eval(names[i] + 'vals');
					explode(a, m[i+1], offsets[i], factors[i]);
					//model is now up to date; update view
					for (var j = 0; j < a.length; j++)
					{
						if (a[j])
							$(names[i] + j).className = 'sel';
					}
				}
				if (m[3] == '*')
				{ //find an interesting tab to show first
					if (m[4] != '*')
						deftab = '_dom';
					else if (m[5] != '*')
						deftab = '_moy';
				}
			}
		}
		updateStr(); //update all human-readable representations
		updateEvent(); //update visual effects based on enabled state
		var pt = new ProtoTabs('eventtabs', {defaultPanel:deftab});
    } // end function prePopulate()
	
	/* FORM DATA FUNCTIONS - utility functions */
	
	//implode: takes an array and returns a comma-delimited string
	//containing the indices of the array whose values are not false.
	//Special case: if either all or none of the array elements
	//evaluate to true, then returns '*'.
	//If offset is specified and positive, the values of the indices
	//are offset by this value before being appended to the string.
	//If factor is specified, the values of the indices are multiplied
	//by this value before being appended to the string.
	//(Used for the minutes field of the schedule string)
	function implode(arr, offset, factor)
	{
		var allset = true;
		var retstr = '';
		if (!arr || !arr.length)
			return retstr;
		if (!offset || offset < 0)
			offset = 0;
		if (!factor || factor < 1)
			factor = 1;
		for (var i = 0; i < arr.length; i++)
		{
			if (arr[i])
				retstr += ',' + (offset + i * factor);
			else
				allset = false;
		}
		if (allset || retstr.length == 0)
		{
			if (factor == 1)
				retstr = '*';
			else
			{ //return all values comma-delimited instead of *
				if (retstr.length == 0)
				{ //if string is blank, construct it now
					for (var i = 0; i < arr.length; i++)
					{
						retstr += ',' + (offset + i * factor);
					}
				}
				retstr = retstr.substr(1);
			}
		}
		else
			retstr = retstr.substr(1);
		return retstr;
	}
	
	//explode: effectively the opposite of implode.
	//This includes the effect of offset and factor -
	//they effectively subtract and divide respectively.
	//Returns true on success or false on failure (i.e. NaN).
	//The arr parameter passed in should already be the
	//desired length, but its elements will be modified based on
	//the contents of str.
	//If str is not a comma-delimited list of numbers,
	//this function does nothing and returns false.  This includes
	//the case where str is '*'; since all our arrays are predefined
	//to all false, this is fine for its intended use.
	function explode(arr, str, offset, factor)
	{
		if (!arr || !str)
			return false;
		if (!offset || offset < 0)
			offset = 0;
		if (!factor || factor < 1)
			factor = 1;
		var strarr = str.split(',');
		if (!arr.length || arr.length == strarr.length)
			return true; //leave arr as all false values
		for (var i = 0; i < strarr.length; i++) {
			var n = parseInt(strarr[i], 10);
			if (isNaN(n) || n % factor != 0) //invalid!
				return false;
			arr[n / factor - offset] = true;
		}
	}

</script>
<div class="sectionhead">
 <span class="sectionname"><xlat:stream key="dvin/UI/Admin/RecurrencePattern"/></span>
</div>
<%-- The div hierarchy used here is adopted from the publishing console. --%>
<div class="tabs6 width">
 <div class="minwidth">
  <div class="container">
   <ul id="eventtabs" style="padding-top: 0">
    <li><a href="#_dow" style="text-decoration:none;width:auto;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/Util/Daysoftheweek"/>&nbsp;&nbsp;&nbsp;</span></a></li>
    <li><a href="#_dom" style="text-decoration:none;width:auto;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/Util/Daysofthemonth"/>&nbsp;&nbsp;&nbsp;</span></a></li>
    <li><a href="#_moy" style="text-decoration:none;width:auto;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/Util/Months"/>&nbsp;&nbsp;&nbsp;</span></a></li>
   </ul>
  </div>
 </div>
</div>
<div class="sectionbody">
 <div class="sectionbox">
  <div class="content" style="border-right: none">
  <xlat:lookup key="dvin/Common/Select" varname="_xlat_Select"/>
  <xlat:lookup key="dvin/Common/All" varname="_xlat_All"/>
  <xlat:lookup key="dvin/Common/None" varname="_xlat_None"/>
  <div id="_dow">
   <div class="selectall"><ics:getvar name="_xlat_Select"/>:
    <a href="#" onclick="return selectAll('dow', true);"><ics:getvar name="_xlat_All"/></a> |
    <a href="#" onclick="return selectAll('dow', false);"><ics:getvar name="_xlat_None"/></a>
   </div><p></p>
   <table class="timefields" id="dowfields" cellspacing="0" cellpadding="0">
    <tr>
<% for (int i = 0; i < 7; i++) { %>
     <td id='dow<%=i%>'><xlat:stream key='<%="dvin/AT/Common/" + days[i]%>'/></td>
<% } %>
    </tr>
   </table>
  </div>
  <div id="_dom">
   <div class="selectall"><ics:getvar name="_xlat_Select"/>:
    <a href="#" onclick="return selectAll('dom', true);"><ics:getvar name="_xlat_All"/></a> |
    <a href="#" onclick="return selectAll('dom', false);"><ics:getvar name="_xlat_None"/></a>
   </div><p></p>
   <table class="timefields" id="domfields" cellspacing="0" cellpadding="0">
    <tr>
<% for (int i = 0; i < 15; i++) { %>
     <td id='dom<%=i%>'><%=i+1%></td>
<% } %>
     <td class="invis">&nbsp;</td>
    </tr>
    <tr>
<% for (int i = 15; i < 31; i++) { %>
     <td id='dom<%=i%>'><%=i+1%></td>
<% } %>
    </tr>
   </table>
  </div>
  <div id="_moy">
   <div class="selectall"><ics:getvar name="_xlat_Select"/>:
    <a href="#" onclick="return selectAll('moy', true);"><ics:getvar name="_xlat_All"/></a> |
    <a href="#" onclick="return selectAll('moy', false);"><ics:getvar name="_xlat_None"/></a>
   </div><p></p>
   <table class="timefields" id="moyfields" cellspacing="0" cellpadding="0">
    <tr>
<% for (int i = 0; i < 6; i++) { %>
     <td id='moy<%=i%>'><xlat:stream key='<%="dvin/AT/Common/" + months[i]%>'/></td>
<% } %>
    </tr>
    <tr>
<% for (int i = 6; i < 12; i++) { %>
     <td id='moy<%=i%>'><xlat:stream key='<%="dvin/AT/Common/" + months[i]%>'/></td>
<% } %>
    </tr>
   </table>
  </div>
  </div>
  <div class="feedback" style="border-left: 1px solid #b3b3b3">
   <strong><xlat:stream key="dvin/UI/Util/Information"/>:</strong>
   <p style="margin-bottom: 1em"><xlat:stream key="dvin/UI/Admin/Eventwillrunondays" encode="false"/></p>
  </div>
  <br clear="all" />
 </div>
 <div class="sectionshadow"></div>
</div>
<p></p>
<div class="sectionhead">
 <span class="sectionname"><xlat:stream key="dvin/UI/Admin/TimesofRecurrence"/></span>
</div>
<div class="sectionbody">
 <div class="sectionbox">
  <div class="content">
   <div style="float: left" id="hrfields">
    <strong><xlat:stream key="dvin/UI/Util/Hours"/></strong>
	<% if (preferHour == "12") {%>
		<p>
		<table class="timefields" cellspacing="0" cellpadding="0" style="float: left">
		 <tr>
		  <td id="hr0">12</td>
	<% for (int i = 1; i < 12; i++) { %>
		  <td id='hr<%=i%>'><%=i%></td>
	<% } %>
		 </tr>
		</table>
		<strong style="position: relative; top: 3px;">&nbsp;<xlat:stream key="dvin/AT/Common/AM"/></strong>
		</p><p>
		<table class="timefields" cellspacing="0" cellpadding="0" style="float: left; clear: both;">
		 <tr>
		  <td id="hr12">12</td>
	<% for (int i = 13; i < 24; i++) { %>
		  <td id='hr<%=i%>'><%=i-12%></td>
	<% } %>
		 </tr>
		</table>
		<strong style="position: relative; top: 12px;">&nbsp;<xlat:stream key="dvin/AT/Common/PM"/></strong></p>
	<% } else { %>
		<p>
		<table class="timefields" cellspacing="0" cellpadding="0" style="float: left">
		 <tr>
		  <td id="hr0">0</td>
	<% for (int i = 1; i < 12; i++) { %>
		  <td id='hr<%=i%>'><%=i%></td>
	<% } %>
		 </tr>
		</table>
		<strong style="position: relative; top: 3px;">&nbsp;</strong>
		</p><p>
		<table class="timefields" cellspacing="0" cellpadding="0" style="float: left; clear: both;">
		 <tr>
		  <td id="hr12">12</td>
	<% for (int i = 13; i < 24; i++) { %>
		  <td id='hr<%=i%>'><%=i%></td>
	<% } %>
		 </tr>
		</table>
		<strong style="position: relative; top: 12px;">&nbsp;</strong></p>
	<% } %>
   </div>
   <div style="float: left; padding-left: 20px;">
    <strong><xlat:stream key="dvin/UI/Util/Minutes"/></strong>
    <p>
    <table class="timefields" id="minfields" cellspacing="0" cellpadding="0">
<% for (int i = 0; i < 4; i++) { %>
     <tr>
<%   for (int j = 0; j < 3; j++) { %>
      <td id='min<%=i*3 + j%>'><%=i*15 + j*5%></td>
<%   } %>
     </tr>
<% } %>
    </table></p>
   </div>
  </div>
  <div class="feedback"><strong><xlat:stream key="dvin/UI/Util/Information"/>:</strong>
   <p><xlat:stream key="dvin/UI/Admin/Eventwillrunattimes"/></p>
  </div>
  <br clear="all" />
 </div>
 <div class="sectionshadow"></div>
</div>
<input type="hidden" name="time" value=""/>
<script type="text/javascript">
	// Prepopulate the form and set up event handlers
	var eventTime = '<%=sEventTime == null ? "":sEventTime%>';
	prePopulate(eventTime);
	initEventHandlers();
</script>
</cs:ftcs>
