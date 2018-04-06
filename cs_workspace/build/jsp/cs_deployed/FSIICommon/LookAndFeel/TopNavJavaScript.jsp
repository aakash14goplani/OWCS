<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%
	//when site preview is enabled on a CM instance, disable caching.
	if (ics.LoadProperty("futuretense.ini;futuretense_xcel.ini"))
    {
		if(ftMessage.cm.equals(ics.GetProperty("cs.sitepreview")))
			ics.DisableFragmentCache();
	}
%>
	<satellite:link assembler="query" container="servlet" outstring="jsLink" pagename="FSIICommon/LookAndFeel/Util" />

<%-- Now that we have our current section, define the javascript function that 
     will set the style for the section page to be different.  Note that this 
     function must be executed onLoad.  Using unobtrusive javascript techniques,
     we can trigger the function without having to alter any xhtml! --%>
<script type="text/javascript" src='<%=ics.GetVar("jsLink")%>'></script>
<script type="text/javascript">
//<![CDATA[
	var menuparentid = 'LocaleList';
	var menuid = 'LocaleListChooser';

	window.onload = function ()
	{
		var myElement = $("TopNav-PageLink-<string:stream variable="cid"/>");	
		if (myElement) //#16144 prevention
			myElement.className = "topNavClass";
		<%-- [KGF 2008-08-xx]
			More onload actions for the locale form redesign. --%>
		var menuArea = $(menuparentid);
		var menu = $(menuid);
		if (menuArea && menu)
		{	//hook locale menu JS events (dependent functions defined below)
			menuArea.onmouseover =
				function(event)
				{
					//only reposition/show the menu if mouse is not moving from the menu itself
					if (isIntendedEventTarget(event, this, getAllChildren(this)))
					{
						posDivAtMouse(event, menuid, -4);
						showDiv(event, menuid, true);
					}
				};
			menuArea.onmouseout =
				function(event)
				{
					var ignored = [$(menuparentid)];
					ignored = ignored.concat(getAllChildren(ignored[0]));
					if (isIntendedEventTarget(event, this, ignored))
					{
						showDiv(event, menuid, false);
					}
				};
			menu.onmouseout =
				function(event)
				{
					//only hide the menu if mouse is not moving to element which shows it
					//(or any images within that element)
					//also, ignore mouseout events moving from menu to its children
					var ignored = [$(menuparentid)];
					ignored = ignored.concat(getAllChildren(ignored[0]));
					if (isIntendedEventTarget(event, null, ignored))
					{
						showDiv(event, menuid, false);
					}
				};
		}
	}
//]]>
</script>


</cs:ftcs>
