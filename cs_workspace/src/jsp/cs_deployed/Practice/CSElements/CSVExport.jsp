<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="java.util.Date, org.apache.commons.lang.StringEscapeUtils, java.io.PrintWriter, java.io.File, java.util.Calendar, java.text.SimpleDateFormat, COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
	<satellite:link pagename="Practice/csvexport" outstring="elementURL" />
	<a id="exportExcel" href='<%=ics.GetVar("elementURL")%>&export=true'><button> EXPORT TO CSV </button></a>
	<div id="results"></div><br/><%	
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd_HH_mm_ss");
    String date = sdf.format(cal.getTime());
	String fileName = "Report_" + date + ".csv";
	String downloadPath = "../Reports/" + ics.GetVar("site") + "/" + date.substring(0, date.indexOf("_")) + "/";
	StringBuffer sb = new StringBuffer();
	sb.append("Web Reference URL" + "\t");sb.append(",");
	sb.append("Asset Id" + "\t");sb.append(",");
	sb.append("Asset Type" + "\t");sb.append(",");
	sb.append("Field" + "\t");sb.append(",");
	sb.append("Field Value" + "\t");sb.append(",");
	sb.append("Template" + "\t");sb.append(",");
	sb.append("Parameters" + "\t");sb.append(",");
	sb.append("Modified Date" + "\t");sb.append(",");
	sb.append("Vanity URL" + "\t");sb.append("\n");
	%><ics:sql table="Practice_C" listname="listResult" sql="select * from webreferences"/>
	<ics:if condition='<%=null != ics.GetList("listResult") && ics.GetList("listResult").hasData() %>'>
		<ics:then>
			<table id="tableContent" border="1">
				<tr>
					<th>Web Reference URL</th>
					<th>Asset Id</th>
					<th>Asset Type</th>
					<th>Field</th>
					<th>Field Value</th>
					<th>Template</th>
					<th>Parameters</th>
					<th>Modified Date</th>
					<th>Vanity URL</th>
				</tr>
				<ics:listloop listname="listResult">
					<ics:listget fieldname="template" listname="listResult" output="templateName"/>
					<ics:listget fieldname="assetid" listname="listResult" output="assetId"/>
					<ics:listget fieldname="assettype" listname="listResult" output="assetType"/>
					<ics:listget fieldname="webreferenceurl" listname="listResult" output="webReferenceUrl"/>
					<ics:listget fieldname="field" listname="listResult" output="Field"/>
					<ics:listget fieldname="fieldvalue" listname="listResult" output="fieldValue"/>
					<ics:listget fieldname="params" listname="listResult" output="parameter"/>
					<ics:listget fieldname="modifieddate" listname="listResult" output="modifiedDate"/>
					<ics:if condition='<%=Utilities.goodString(ics.GetVar("templateName")) %>'>
						<ics:then>
							<render:gettemplateurl tname='<%=ics.GetVar("templateName")%>' outstr="vanityURL" ttype="CSElement"
							cid='<%=ics.GetVar("assetId")%>' c='<%=ics.GetVar("assetType")%>' tid='<%=ics.GetVar("eid")%>' />
							<ics:setvar name="vanity_url" value='<%=ics.GetVar("vanityURL")%>'/>
						</ics:then>
						<ics:else>
							<ics:setvar name="vanity_url" value=""/>
						</ics:else>
					</ics:if><%
					String newDateFormat = "";
					if(ics.GetVar("modifiedDate").contains("UTC") ){
						Date dt = new Date(ics.GetVar("modifiedDate"));
					    newDateFormat = new SimpleDateFormat("yyyy/MM/dd").format(dt); 
					} else {
						Date dt = new Date(ics.GetVar("modifiedDate").split(" ")[0].replaceAll("-", "/"));
					    newDateFormat = new SimpleDateFormat("yyyy/MM/dd").format(dt);
					}
					sb.append("\"" + ics.GetVar("webReferenceUrl") + "\"");sb.append(",");
					sb.append(ics.GetVar("assetId") + "\t");sb.append(",");
					sb.append(ics.GetVar("assetType"));sb.append(",");
					sb.append(ics.GetVar("Field"));sb.append(",");
					sb.append(ics.GetVar("fieldValue"));sb.append(",");
					sb.append(ics.GetVar("templateName"));sb.append(",");
					sb.append(ics.GetVar("parameter"));sb.append(",");
					sb.append(newDateFormat + "\t");sb.append(",");
					sb.append(ics.GetVar("vanity_url"));sb.append("\n");
					%><tr>
						<td><ics:getvar name="webReferenceUrl"/></td>
						<td><ics:getvar name="assetId"/></td>
						<td><ics:getvar name="assetType"/></td>
						<td><ics:getvar name="Field"/></td>
						<td><ics:getvar name="fieldValue"/></td>
						<td><ics:getvar name="templateName"/></td>
						<td><ics:getvar name="parameter"/></td>
						<td><%=newDateFormat%></td>
						<td><ics:getvar name="vanity_url"/></td>
					</tr>
					<ics:removevar name="vanityURL"/>
					<ics:removevar name="vanity_url"/>
					<ics:removevar name="templateName"/>
					<ics:removevar name="assetId"/>
					<ics:removevar name="assetType"/>
					<ics:removevar name="webReferenceUrl"/>
					<ics:removevar name="templateName"/>
					<ics:removevar name="Field"/>
					<ics:removevar name="fieldValue"/>
					<ics:removevar name="parameter"/>
					<ics:removevar name="modifiedDate"/>
				</ics:listloop>
			</table><%
			String temp = StringEscapeUtils.escapeJavaScript(sb.toString().replaceAll("[^\\x00-\\x7F]", " "));
			try {
				if( Utilities.goodString(ics.GetVar("export")) && "true".equals(ics.GetVar("export")) ) {
					File file = new File(downloadPath + fileName);
					file.getParentFile().mkdirs();
					PrintWriter writer = new PrintWriter(file, "UTF-8");
					writer.write(sb.toString().replaceAll("[^\\x00-\\x7F]", " "));				
					writer.close();
					if(file.exists() && file.length() > 0){
						%><script>
				        	document.getElementById("exportExcel").style.display = 'none';
					        document.getElementById("results").innerHTML = '<b>File export to server successful!</b><br/> <button id="initiateDownload">Download CSV file</button>';
				        </script><%
			        }
			        else{
			        	%><script>
				        	document.getElementById("exportExcel").style.display = 'none';
					        document.getElementById("results").innerHTML = '<b>File export to server failed!</b>';
				        </script><%
			        }
				}
			}
			catch(Exception e) {
				out.println("Exception Occured: " + e.getMessage() + " : " + e);
				%><script>
			        var errorMessage = "<b>Error: </b>" + "<%=e.getMessage()%>";
			        document.getElementById("results").innerHTML = errorMessage;
	        	</script><%
			}
			%><script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
			<script>
				$(document).ready(function() {
					$("#initiateDownload").on("click", function(event) {
				    	var ua = window.navigator.userAgent;
				        var msie = ua.indexOf("MSIE ");
				        var csv = '<%=temp%>';				
				        if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
				            var blob = new Blob([decodeURIComponent(csv)], {type: "text/csv;charset=utf-8"});
				           	window.navigator.msSaveBlob(blob, "<%=fileName%>");
				        } else {
				            var link = document.createElement("a");
							var blob = new Blob([csv], { type: "text/csv;charset=utf-8" });
				            var url = URL.createObjectURL(blob);
				            link.href = url;
				            link.setAttribute("download", ("<%=fileName%>"));
				            document.body.appendChild(link);
				            link.click(); 
				        }
					});
				});
			</script>
		</ics:then>
	</ics:if>
</cs:ftcs>