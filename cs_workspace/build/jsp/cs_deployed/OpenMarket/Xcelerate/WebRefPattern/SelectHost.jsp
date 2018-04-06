<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/SelectHost
//
// INPUT
//
// OUTPUT
//%>
<%@page import="java.util.*"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.fatwire.assetapi.data.BlobObject"%>
<%@page import="com.fatwire.assetapi.query.Query"%>
<%@page import="com.fatwire.assetapi.data.AssetData"%>
<%@page import="com.fatwire.assetapi.query.SimpleQuery"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManagerImpl"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManager"%>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<cs:ftcs>
<%
	List<LabelValueBean> hostList = new ArrayList<LabelValueBean>();	
	AssetDataManager adm = new AssetDataManagerImpl(ics);
	Query query = new SimpleQuery("WebRoot", null);
	query.getProperties().setIsImmediateOnly(true);	
	query.getProperties().setReadAll(true);
	query.getProperties().setIsBasicSearch(true);
	Iterable<AssetData> data = adm.read(query);
	Map<String,String> hostnameMap = new HashMap<String,String>();
	Iterator<AssetData> iterator =   data.iterator();
	while (data != null && iterator.hasNext()) {
		AssetData assetdata = iterator.next();
		BlobObject current = (BlobObject)assetdata.getAttributeData("publication", false).getData();
		if(current != null)
		{
			InputStream is = current.getBinaryStream();
			if(is != null) {
				byte[] blob = new byte[ is.available() ];
				is.read( blob );
				String virtualWebRootsString =new String( blob );
				String[] publicationString = virtualWebRootsString.split(",");			
				List<String> publication = Arrays.asList(publicationString);
				if(publication.contains(ics.GetVar("publicationId")) || publication.contains("0"))
				{
					String hostName = (String) assetdata.getAttributeData("name", true).getData();
					String webRoot = (String) assetdata.getAttributeData("rooturl", false).getData();
					hostnameMap.put(hostName,webRoot);
				}
			}
		}
	}
%>
<ics:if condition='<%=hostnameMap.size() >0 %>' >
<ics:then>
	<%
		for (Map.Entry<String, String> entry : hostnameMap.entrySet()) 
		{
			String name = entry.getKey();
			String webroot = entry.getValue();
			if (StringUtils.isNotBlank(name))
			{
				LabelValueBean labelValue = new LabelValueBean(webroot, name);
				hostList.add(labelValue);
			}
		} 
	%>
</ics:then>
</ics:if>
{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(hostList)%> }
</cs:ftcs>