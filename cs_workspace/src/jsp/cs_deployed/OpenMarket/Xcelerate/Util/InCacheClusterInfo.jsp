<%@ page import="net.sf.ehcache.*, net.sf.ehcache.distribution.*, java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<LINK href="cacheTool.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
	String[] rowColors = {"tile-row-normal", "tile-row-highlight"};

	String cacheName = (String)request.getSession().getAttribute("cachename");
	boolean onCS = true;
	
	if (!onCS)
	{
		//will not set it in session to interfere other browsers (FF browsers share the same session)
		cacheName = "ss-cache";
	}
	else
	{			
		if(null == cacheName)
		{	//default to cs-cache
			cacheName = "cs-cache";
			request.getSession().setAttribute("cachename", cacheName);
		}
	}   


    CacheManager cacheMgr = null;

    for(CacheManager mgr : CacheManager.ALL_CACHE_MANAGERS)
    {
        if(cacheName.equals(mgr.getName()))
        {
            cacheMgr = mgr;
            break;
        }
    }
    
    if(null == cacheMgr)
    {
        out.println("No cache Manager found. Please initialize the cache by editing an asset or requesting a cacheable page and then retry.");
        return;
    }

	Ehcache cache = cacheMgr.getCache("notifier");
	CacheManagerPeerProvider provider = cacheMgr.getCacheManagerPeerProvider("RMI");
	List remotePeerList = provider.listRemoteCachePeers(cache);
		
	if (remotePeerList.size() == 0)
	{
%>
		<table>
		<tr><td height="10px"></td></tr>
		<tr><td>There are no remote cluster members configured for the cache notifier. Please make sure the multicast address and port are correct in cs-cache.xml.</td></tr>
		</table>

<%	
		return;
	}
%>
	

<table border="0" bgcolor="#ffffff">
	<tr><td height="3px"></td></tr>
	<tr><td class="sub-title-text">Cluster Info</td></tr>
	<tr><td height="7px"></td></tr>
	<tr><td class="padded">Number of remote cluster peer = <b><%=remotePeerList.size()%></b></td></tr>
	<tr>
		<td>	
			<table cellspacing="0" cellpadding="0" border="1" style="border-top: solid thin;border-left: solid thin;border-right: solid thin;border-bottom: solid thin;">
				<thead>
					<td class="tile-a padded tableHeadBackground"><div class="new-table-title">Name</div></td>
					<td class="tile-b padded tableHeadBackground"><div class="new-table-title">Url</div></td>
					<td class="tile-b padded tableHeadBackground"><div class="new-table-title">Port</div></td>
					<td class="tile-b padded tableHeadBackground"><div class="new-table-title">Guid</div></td>
				</thead>
	
    <%
	
        for(int i = 0; i<remotePeerList.size(); i++)
        {
			CachePeer peer = (CachePeer) remotePeerList.get(i);
			String url = peer.getUrl();
			String urlbase = peer.getUrlBase();
			String name = peer.getName();
			String guid = peer.getGuid();
            %>
                <tr class="<%=rowColors[i%2]%>">
					<td class="padded text-align-center"><%=name%></td>
					<td class="padded text-align-center"><%=urlbase.substring(urlbase.indexOf("//")+2, urlbase.indexOf(":"))%></td>
					<td class="padded text-align-center"><%=urlbase.substring(urlbase.indexOf(":")+1)%></td>
					<td class="padded text-align-center"><%=guid%></td>
				</tr>
            <%
        }
		
    %>
	
			</table>
		</td>
	</tr>
</table>	
</body>
</html>



