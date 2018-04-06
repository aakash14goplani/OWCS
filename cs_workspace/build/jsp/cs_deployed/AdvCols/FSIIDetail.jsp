<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="property" uri="futuretense_cs/property.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><%@ page import="at.onetoone.esa.tools.*"
%>
<cs:ftcs>

<%-- 
	Added for Analytics - Start 
	List of Variables needed for Analytics 
--%>
<property:get param="analytics.enabled" inifile="futuretense_xcel.ini" varname="analyticsEnabled"/>
<% 
	String analyticsEnabled = ics.GetVar("analyticsEnabled");
	//String sessionId = request.getSession().getId();
	String segmentnamelist = "";
	String segmentidlist = "";
	String articleidlist = "";
	String articlenamelist = "";
	String articletypelist = "";		
	String segmentname = "";
	String segmentid = "";
	String articlename = "";
	String articleid = "";
	String articletype = "";		
	int counter = 0;
	int articlecounter = 0;	
	int listsize = 0;	
%>
<%-- ##Added for Analytics - End##--%>

<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<%-- Load the recommendation, display the title and return "max" entries. --%>
<asset:load name='currentAsset' type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' />
<asset:get name='currentAsset' field='description' output='description'/>
<h3><string:stream variable='description'/></h3>
<asset:get name='currentAsset' field='name' output='reconame'/>
<commercecontext:getrecommendations collection='<%=ics.GetVar("reconame")%>' maxcount='<%=ics.GetVar("max")%>' listvarname="assetlist"/>
<ics:if condition='<%=ics.GetList("assetlist",false)!=null && ics.GetList("assetlist",false).hasData()%>'>
<ics:then>
	<div class="AdvColsDetail">
	<%-- 
		Added for Analytics - Start 
		Retrieve the segment list for analytics
	--%>
	<%	if( null !=analyticsEnabled && analyticsEnabled.equals("true" ) ){	%>
	<commercecontext:getsegments listvarname="segmentlist"/>
	<%int listsizeSeg = ics.GetList("segmentlist").numRows();%>
	<ics:if condition='<%= ics.GetList("segmentlist") != null && ics.GetList("segmentlist").hasData() %>'>
	<ics:then>
	<ics:listloop listname="segmentlist">
		<ics:listget listname="segmentlist" fieldname="assetid" output="segid"/>
			<asset:load name="thesegment" type="Segments" objectid='<%= ics.GetVar("segid") %>' />
			<asset:get name="thesegment" field="description" output="segmentname" />
			<%
			counter++;
			
			segmentname = ics.GetVar("segmentname");
			segmentname = segmentname.replaceAll(",","\\,");
			segmentnamelist = segmentnamelist + segmentname; 
			
			segmentid = ics.GetVar("segid");
			segmentid = segmentid.replaceAll(",","\\,");
			segmentidlist = segmentidlist + segmentid;
			if (counter != listsizeSeg){
				segmentnamelist = segmentnamelist + ",";
				segmentidlist = segmentidlist + ",";
			}%>
	</ics:listloop>
	</ics:then>
	</ics:if>
	<%
		if (counter == 0) {segmentidlist = "0"; segmentnamelist = "0";}
	%>
	
	<%-- TAG A: recommendation called --%> 
		<render:callelement elementname="Analytics/AddAnalyticsImgTag">
			<render:argument name="c" value='RecAsked'/>
			<render:argument name="cid" value='<%=ics.GetVar("cid")%>'/>
			<render:argument name="site" value='<%=ics.GetVar("site")%>'/>
			<render:argument name="pagename" value='<%=ics.GetVar("reconame")%>'/>
			<render:argument name="recid" value='<%=ics.GetVar("cid")%>'/>
			<render:argument name="segmentidlist" value='<%= segmentidlist %>'/>
			</render:callelement>						
			
	<%-- TAG A: recommendation called --%>
<% } %>


<%-- ##Added for Analytics - End## --%>

	<ics:if condition='<%="1".equals(ics.GetVar("max")) || ics.GetList("assetlist").numRows() == 1%>'>
	<ics:then> 
			<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
			<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>

			<%-- 
				##Added for Analytics - Start## 
				Get the asset name, id, and the type for Analytics Img tag
			--%>
			<%	if( null !=analyticsEnabled && analyticsEnabled.equalsIgnoreCase("true" ) ){	%>
				<asset:load name="theArticle" type='<%=ics.GetVar("assettype")%>' objectid='<%=ics.GetVar("assetid")%>'/>
				<asset:get name="theArticle" field="name" output="assetname"/>
				<%
					articlecounter++;
					articlenamelist = articlenamelist + ics.GetVar("assetname"); 
					articleidlist = articleidlist + ics.GetVar("assetid");
					articletypelist = articletypelist + ics.GetVar("assettype");
			 } %>
			<%-- ##Added for Analytics - End## --%>
			
			<render:lookup varname="Summary" key="Summary" />
			<render:calltemplate tname='<%=ics.GetVar("Summary")%>' c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>'
								 args="p,locale" context="">
				<%-- 
					##Added for Analytics - Start## 
					Pass the parameter 'recid' for Analytics engage report
				--%>
				<ics:if condition='<%="true".equalsIgnoreCase(ics.GetProperty("analytics.enabled", "futuretense_xcel.ini", true))%>'>
					<ics:then>			
						<render:argument name="recid" value='<%=ics.GetVar("cid")%>'/>
					</ics:then>
				</ics:if>			
				<%-- ##Added for Analytics - End## --%>
			</render:calltemplate>
	</ics:then>
	<ics:else>
		<ul>
		<%-- Mark the beginning of the list so that it can be manipulated with InSite Editor --%>
		<insite:slotlist slotname="RecommendationLink" parentid='<%=ics.GetVar("cid")%>' parenttype="AdvCols" parentfield="Manualrecs">
		<%-- 
			##Added for Analytics - Start## 
			Retrieve the number of assets in the recommendation
		--%>
		<%	if( null !=analyticsEnabled && analyticsEnabled.equalsIgnoreCase("true" ) ){	
			listsize = ics.GetList("assetlist").numRows();
		} %>
		<%-- ##Added for Analytics - End## --%>

			<%-- Add InSite control to add an item to the list --%>
			<ics:listloop listname="assetlist" maxrows='<%=ics.GetVar("max")%>'>
				<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
				<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>
			<%-- 
				##Added for Analytics - Start## 
				Retrieve the asset id, name, type for use in Analytics
			--%>
			<%	if( null !=analyticsEnabled && analyticsEnabled.equalsIgnoreCase("true" ) ){	%>

				<asset:load name="theArticle" type='<%=ics.GetVar("assettype")%>' objectid='<%=ics.GetVar("assetid")%>'/>
				<asset:get name="theArticle" field="name" output="assetname"/>
				<%
					articlecounter++;
					
					articlename = ics.GetVar("assetname"); 
					articlename = articlename.replaceAll(",","\\,");
					articlenamelist = articlenamelist + articlename;
					
					articleid = ics.GetVar("assetid");
					articleid = articleid.replaceAll(",","\\,");
					articleidlist = articleidlist + articleid;
					
					articletype = ics.GetVar("assettype");
					articletype = articletype.replaceAll(",","\\,");
					articletypelist = articletypelist + articletype;
		
					if (articlecounter != listsize){
						articlenamelist = articlenamelist + ",";
						articleidlist = articleidlist + ",";
						articletypelist = articletypelist + ",";
					}
			} %>
			<%-- ##Added for Analytics - End## --%>
				<li>
					<render:lookup varname="Summary" key="Summary" />
					<insite:calltemplate tname='<%=ics.GetVar("Summary")%>' c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>'
										 args="p,locale">
						<%-- ##Added for Analytics - Start## --%>
						<ics:if condition='<%="true".equalsIgnoreCase(ics.GetProperty("analytics.enabled", "futuretense_xcel.ini", true))%>'>
						<ics:then>
							<insite:argument name="recid" value='<%=ics.GetVar("cid")%>'/>
						</ics:then>
						</ics:if>
						<%-- ##Added for Analytics - End## --%>
					</insite:calltemplate>
				</li>
			</ics:listloop>
		</insite:slotlist>
		</ul>
	</ics:else>
	</ics:if>
	<%-- 
		##Added for Analytics - Start## 
		Encode the list of asset names, ids, and types to pass them to Analytics tag
	--%>
	<%	if( null !=analyticsEnabled && analyticsEnabled.equalsIgnoreCase("true" ) ){	
	
			articlenamelist = Base64.encodeBytes(articlenamelist.getBytes(), Base64.DONT_BREAK_LINES);
			articleidlist = Base64.encodeBytes(articleidlist.getBytes(), Base64.DONT_BREAK_LINES);
			articletypelist = Base64.encodeBytes(articletypelist.getBytes(), Base64.DONT_BREAK_LINES);
			articlenamelist += "=";
			articleidlist += "=";
			articletypelist += "=";
	%>
	<%-- TAG B: recommendation listed --%>
			<render:callelement elementname="Analytics/AddAnalyticsImgTag">
				<render:argument name="c" value='RecListed'/>
				<render:argument name="cid" value='<%=ics.GetVar("cid")%>'/>
				<render:argument name="site" value='<%=ics.GetVar("site")%>'/>
				<render:argument name="pagename" value='<%=ics.GetVar("reconame")%>'/>
                <render:argument name="recid" value='<%=ics.GetVar("recid")%>'/>
				<render:argument name="objlistid" value='<%= articleidlist %>' />
				<render:argument name="objlistname" value='<%= articlenamelist %>' />
				<render:argument name="objlisttype" value='<%= articletypelist %>' />
				<render:argument name="segmentidlist" value='<%= segmentidlist %>' />
				</render:callelement>
	<%-- TAG B: recommendation listed --%>
	<% } %>
	<%-- ##Added for Analytics - End## --%>
	</div>
</ics:then>
</ics:if>
</cs:ftcs>
