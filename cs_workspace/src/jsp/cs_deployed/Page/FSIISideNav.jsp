<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="java.util.*,java.text.*"
%><%!
	public boolean checkDate(String givenDate)
	{
		try
		{			
			SimpleDateFormat sformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date dt = sformat.parse(givenDate);
			Calendar cal = Calendar.getInstance();
			cal.setTime(dt);
			// TODO what is this???
			if((cal.get(Calendar.MONTH) == Calendar.OCTOBER || cal.get(Calendar.MONTH) == Calendar.DECEMBER) && 
				(cal.get(Calendar.YEAR) == 2009))
				return true;
			else
				return false;
		}
		catch(ParseException e)
		{
			return false;
		}
	}
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<%-- Pages with different "subtype" identifiers are viewed in different ways.  
     So this template just dispatches requests to the appropriate view.  We load
     the page, figure out its subtype, and then dispatch to the corresponding
     view template. --%>
<asset:load name="page" type='Page' objectid='<%=ics.GetVar("cid")%>'/>
<asset:get name="page" field="subtype"/>
<%
	/*
		Check if the date selected in the insite screen is available and if it is available check if it is contained within the 
		October to December months. We do this because we choose to implement Site View containing an October Site and a 
		December Site. If the date selected is either in the month of October or in the month of December, then we show the
		"Categories" in the side nav in the home page instead of the regular "Item of the week". Note that we employ this method as
		an example of displaying different pagelets under different conditions based on the date.
	*/
	// TODO: why do we have date-based preview outside of the SiteView module??
	if(ics.GetSSVar("__insiteDate") != null && checkDate(ics.GetSSVar("__insiteDate")))
	{
		ics.SetVar("subtype","Product");
	}
%>
<%-- Call the template.  Only the nested View will be cached. --%>
<render:lookup varname="SideNavViewVar" key='<%=ics.GetVar("subtype")+"SideNavView"%>' />
<render:calltemplate tname='<%=ics.GetVar("SideNavViewVar")%>' args="c,cid,p,locale" style='embedded' context="" />
</cs:ftcs>