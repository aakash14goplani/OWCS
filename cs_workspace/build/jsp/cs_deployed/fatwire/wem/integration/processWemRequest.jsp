<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%//
// fatwire/wem/integration/processWemRequest
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

<script>
 function getClientOffset() {
				var curdate = new Date() ;
				var offset = curdate.getTimezoneOffset();
				var finaloffset = "";
				if (offset >= 0) {
					finaloffset = finaloffset+"-";
				} else {
					finaloffset = finaloffset+"+";
				}
				var newoffset=offset;
				var lstr=newoffset.length;
				newoffset=newoffset+'';
				if (newoffset.indexOf("-")>=0)
				offset=newoffset.substring(1,lstr);
				var x = parseInt(offset/600);
				finaloffset=finaloffset+x;
				offset=offset-(x*600);
				x=parseInt(offset/60);
				finaloffset=finaloffset+x;
				offset=offset-(x*60);
				finaloffset=finaloffset+":";
				x = parseInt(offset/10);
				finaloffset=finaloffset+x;
				offset =offset-(x*10);
				finaloffset=finaloffset+offset;				
				return finaloffset;
			}
			var offset = getClientOffset();
</script>

<%
	String csapplication  = ics.GetVar("application");
%>
	<ics:callelement element='OpenMarket/Xcelerate/Util/validateFields'>
	    <ics:argument name = "columnvalue" value ='<%=csapplication%>'/>
	    <ics:argument name = "type" value ="String"/>
	</ics:callelement>
	<ics:if condition='<%="true".equals(ics.GetVar("validatedstatus"))%>'>
	<ics:then>	
	<satellite:link assembler="query" pagename="fatwire/wem/integration/launchApplication" outstring="launchApplication">
    </satellite:link>
	<property:get param="ft.cgipath" inifile="futuretense.ini" varname="path"/>
	<script type="text/javascript">	
		// Get Singlton Wemcontext handle 
		var wemContext = top.WemContext.getInstance();
		var pubName = wemContext.getSiteName();
		if(pubName)
		{
			var url= '<%=ics.GetVar("launchApplication")%>&pubName='+pubName+'&application=<%=csapplication%>';
			if(offset)
			{
				url = url+'&clientTimezoneOffset='+offset;
				if(offset[0]=='+')                      // + gets lost when sent as part of url, hence sending separately as string 'plus'
				url=url+'&tzsign=plus';
			}
			location.href= url;
		}		
	</script>
	</ics:then>
	</ics:if>
	

</cs:ftcs>