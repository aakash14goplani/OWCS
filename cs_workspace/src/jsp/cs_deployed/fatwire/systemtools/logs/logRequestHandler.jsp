<%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.Action"
%><%@page import="java.util.Iterator"
%><%@page import="java.util.Map"
%><%@page import="java.util.HashMap"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.Log.Filter"
%><%@page import="java.util.Collection"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer.LogExecutor"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.SearchSpace.SearchResult"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.Log"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.SearchSpace"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.SearchSpace.SearchResults"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.Log.Line"
%><%@page import="com.fatwire.cs.systemtools.util.FileUtil"
%><%@page import="java.util.Date"
%><%@page import="java.util.Locale"
%><%@page import="java.util.GregorianCalendar"
%><%@page import="java.util.Calendar"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/logRequestHandler
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><cs:ftcs><%
Map<String, String> vals = new HashMap<String, String>();
if(!ics.UserIsMember("xceleditor"))
{
String pageName = Boolean.valueOf(ics.GetVar(UIConstants.VAR_ISLOGVIEWER)) ? 
"OpenMarket/Xcelerate/Actions/Security/TimeoutErrorPopup" :"OpenMarket/Xcelerate/Actions/Security/TimeoutError";
%>
<satellite:link assembler="query" pagename='<%=pageName%>' outstring="urltimeouterror">
 </satellite:link><%
	vals.put(UIConstants.X_UITIMEOUTTEST, ics.GetVar("urltimeouterror"));
}
if(!Boolean.valueOf(ics.GetVar(UIConstants.VAR_TIMEOUTTEST)))
{
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="fatwire/systemtools/logs/activate" /><%
	if(Boolean.valueOf(ics.GetVar("logOK")))
	{
		final String CS_IMAGEDIR = ics.GetVar("cs_imagedir");
	    final String CS_LOCALE = ics.GetSSVar("locale");
	    
		try
		{
		    String action = ics.GetVar(UIConstants.FORMACTION);
		    String strLite = ics.GetVar(UIConstants.VAR_LITE);
		    boolean lite = strLite == null ? true : Boolean.valueOf(strLite);
			// Try executing assuming light-weight log
			Log log = LogAnalyzer.execute(action, ics, lite);
			// If the log is heavy-weight, warn, then force if necessary
			if(log.isLite())
			{
			    // Log object is light, which means we did not fetch the complete result
			    // Only made sure its heavy-weight enough
	            %><xlat:lookup varname="heavylogs" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "HeavyLogs"%>'/><%
		        vals.put(UIConstants.X_CONFIRM, ics.GetVar("heavylogs"));
	   	    	vals.put(UIConstants.X_CONFIRM_Y_FN, "forceExecute");
	   	    	vals.put(UIConstants.X_CONFIRM_Y_ARGS, "{ \"formAction\": \"" + action + "\" }");
	        }
			else
			{
				LogExecutor op = LogExecutor.valueOf(action);
			 	Calendar cal = new GregorianCalendar(new Locale(CS_LOCALE));
			 	cal.setTime(new Date(log.getDate()));
%>
<table border="0" cellpadding="0" cellspacing="0">
   	<tr>
   		<td class="form-inset" >
   			<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "LogReadAt"%>'/>:&nbsp;<%= String.valueOf(cal.getTime())%>.
		</td>
	</tr>
</table><%
			    switch(op)
			    {
			    case EXPORT:
			        String blobId = log.getBlobId();
			        if (blobId == null)
			        {
		            %><xlat:lookup varname="trylater" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "TryExportLater"%>'/>
					<%
		            	vals.put(UIConstants.X_ERROR, ics.GetVar("trylater"));
		            	break;
			        }
			        else
			        {
			%><satellite:blob assembler="query" service='<%=ics.GetVar("empty")%>'
				blobtable="MungoBlobs"
				blobkey="id"
				blobwhere='<%=blobId%>'
				blobcol="urldata"
				csblobid='<%=ics.GetSSVar("csblobid")%>'
				outstring='<%=UIConstants.VAR_BLOBURL%>'
				blobnocache="true">
				<satellite:argument name="blobheadername1" value="content-type"/>
				<satellite:argument name="blobheadervalue1" value="application/octet-stream"/>
				<satellite:argument name="blobheadername2" value="Content-Disposition"/>
				<satellite:argument name="blobheadervalue2" value='<%= "attachment;filename=" + LogAnalyzer.MODULENAME + ".zip"%>'/>
				<satellite:argument name="blobheadername3" value="MDT-Type"/>
				<satellite:argument name="blobheadervalue3" value="abinary; charset=UTF-8"/>
			</satellite:blob><xlat:lookup varname="logssuccess" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "LogsSuccess"%>'/><%
						vals.put(UIConstants.X_MESSAGE, ics.GetVar("logssuccess"));
						vals.put(UIConstants.X_XLINK, ics.GetVar(UIConstants.VAR_BLOBURL));
					}
			        break;
			    case PREV:
			    case NEXT:
			    case FETCH:
		        	if (log.isEmpty())
		        	{
		        	   %><xlat:lookup varname="noitems" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "NoItems"%>'/><%
		        	   	vals.put(UIConstants.X_ALERT, ics.GetVar("noitems"));
		        	    break;
		        	}
		        	Integer line1 = log.firstKey();
		        	Integer line2 = log.lastKey();
		        	vals.put(LogAnalyzer.LINE1, String.valueOf(line1));
		        	vals.put(LogAnalyzer.LINE2, String.valueOf(line2));
		        	Collection<Filter> filters = log.filters();
		        	if (filters != null && filters.size() > 0)
		        	{
		        		final int COLS=5;
		        		Iterator<Filter> it = filters.iterator();
		           %><div id='<%= UIConstants.ELEM_FILTERS%>' class="form-inset">
		           <xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Filters"%>'/>:
		           <table border="0" cellpadding="0" cellspacing="0" width="100%"><%
		        		while(it.hasNext())
		        		{
		           	%><tr><%
		        			int c=0;
		        			while(c < COLS && it.hasNext())
		        			{
		        		    	Filter filter = it.next();
		        		    	c++;
		           		%><td align="left">
		           		<div class="form-inset"><input type="checkbox" name='<%= UIConstants.VAR_FILTER%>' value='<%= filter.getFilter()%>' onclick="" />&nbsp;<%= filter.getFilter()%></div>
		           		</td><%
		           			}
		           	%></tr><%
		           		}
		           %></table>
		           </div><%
		           	}
	           %><div id='<%= UIConstants.ELEM_PAGINATION_TOP%>' class="form-inset">
	           <table width="100%">
	           	<tr>
	           		<td align="left">
	           		<div class="form-inset"><a href="javascript:actions.<%= Action.PREV%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>"><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrowLeft.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>" border="0"/><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/></a></div>
	           		</td>
	           		<td align="center">
	           		<div class="form-inset"><a name="top" href="#bottom" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Bottom"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Bottom"%>'/></a></div>
	           		</td>
	           		<td align="right">
	           		<div class="form-inset"><a href="javascript:actions.<%= Action.NEXT%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrow.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>" border="0"/></a></div>
	           		</td>
	           	</tr>
	           </table>
	           </div>
	        <div id='<%= UIConstants.ELEM_LOG%>'>
			<%
		        	for (Line line : log.values())
		        	{%><pre style="padding: 0px; margin: 0px"><%= FileUtil.escapeHTML(line.toString())%></pre><%}
	        %></div>
	           <div id='<%= UIConstants.ELEM_PAGINATION_BTM%>' class="form-inset">
	           <table width="100%">
	           	<tr>
	           		<td align="left">
	           		<div class="form-inset"><a href="javascript:actions.<%= Action.PREV%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>"><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrowLeft.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>" border="0"/><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/></a></div>
	           		</td>
	           		<td align="center">
	           		<div class="form-inset"><a name="bottom" href="#top" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Top"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Top"%>'/></a></div>
	           		</td>
	           		<td align="right">
	           		<div class="form-inset"><a href="javascript:actions.<%= Action.NEXT%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrow.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>" border="0"/></a></div>
	           		</td>
	           	</tr>
	           </table>
	           </div><%
			        break;
			    case TAIL:
		        	if (log.isEmpty())
		        	{
		        	   %><xlat:lookup varname="noitems" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "NoItems"%>'/><%
		        	   	vals.put(UIConstants.X_ALERT, ics.GetVar("noitems"));
		        	    break;
		        	}
	           %><div id='<%= UIConstants.ELEM_LOG%>'>
				<%
		        	for (Line line : log.values())
		        	{%><pre style="padding: 0px; margin: 0px"><%= FileUtil.escapeHTML(line.toString())%></pre><%}
	        %></div><%
			        break;
			    case PREVSEARCH:
			    case NEXTSEARCH:
			        SearchResults results = ((SearchSpace) log).getResults();
			        if (results.isEmpty())
			        {
		            %><xlat:lookup varname="noitems" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "NoItems"%>'/><%
			   	    	vals.put(UIConstants.X_ALERT, ics.GetVar("noitems"));
			            break;
		        	}
			        int stLine = results.getLastLine() + 1;
		            String searchLines = ics.GetVar(LogAnalyzer.SEARCHLINE1) + LogAnalyzer.TOKEN_FLAGS + String.valueOf(stLine);
			        vals.put(LogAnalyzer.SEARCHLINE1, searchLines);
			        String [] searchLinesArr = searchLines.split(LogAnalyzer.TOKEN_FLAGS);
		    		boolean showPrevious = searchLinesArr.length > 2;
		    	%><div id='<%= UIConstants.ELEM_PAGINATION_TOP%>' class="form-inset">
		    <table width="100%">
		    	<tr>
		    		<td align="left"><%
		    		if (showPrevious)
		    		{%><div class="form-inset"><a href="javascript:actions.<%= Action.PREVSEARCH%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>"><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrowLeft.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>" border="0"/><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/></a></div>
		    		<%}
		    		else
		    		{%>&nbsp;<%}%></td>
		    		<td align="right">
		    		<div class="form-inset"><a href="javascript:actions.<%= Action.NEXTSEARCH%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrow.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>" border="0"/></a></div>
		    		</td>
		    	</tr>
		    </table>
		    </div>
			<div id='<%= UIConstants.ELEM_LOG%>'><%
					for (SearchResult result : results)
					{
					Log group = result.getResult();
					if (group != null && group.size() > 0)
					{
						for (Line line : group.values())
						{%><pre style="padding: 0px; margin: 0px;"><%= FileUtil.escapeHTML(line.toString())%></pre><%}
					}
					%><table width="100%">
		    		<tr>
		    			<td>
		    				<div class="form-inset">
		    				<a href="javascript:goToLog('<%= String.valueOf(group.firstKey() - 1)%>')"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "ViewLog"%>'/></a>
		    				</div>
		    			</td>
		    		</tr>
		    		</table><%
					}
			%></div>
		    <div id='<%= UIConstants.ELEM_PAGINATION_BTM%>' class="form-inset">
		    <table width="100%">
		    	<tr>
		    		<td align="left"><%
		    		if (showPrevious)
		    		{%><div class="form-inset"><a href="javascript:actions.<%= Action.PREVSEARCH%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>"><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrowLeft.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/>" border="0"/><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Previous"%>'/></a></div>
		    		<%}
		    		else
		    		{%>&nbsp;<%}%></td>
		    		<td align="right">
		    		<div class="form-inset"><a href="javascript:actions.<%= Action.NEXTSEARCH%>();" title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>"><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/><img src='<%= CS_IMAGEDIR%>/graphics/common/icon/doubleArrow.gif' alt="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Next"%>'/>" border="0"/></a></div>
		    		</td>
		    	</tr>
		    </table>
		    </div><%
		        	break;
			    }
			}
		}
		catch (Throwable e)
		{
			%><xlat:lookup varname="erroroccurred" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "ErrorOccurred"%>'/><%
	   		vals.put(UIConstants.X_ERROR, ics.GetVar("erroroccurred"));
			throw e;
		}
	}			
}
StringBuilder callbackVals = new StringBuilder("_CALLBACK_VALS_BEGIN_{");
boolean first = true;
for (String key : vals.keySet())
{
	String val = vals.get(key);
	if (first)
		first = false;
	else
		callbackVals.append(",");
	callbackVals.append("\"" + key + "\"" + ":" + "\"" + val + "\"");
}
callbackVals.append("}_CALLBACK_VALS_END_");
%><%=callbackVals.toString() %></cs:ftcs>