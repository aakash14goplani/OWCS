<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternEvaluate
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.*"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencePatternBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="org.codehaus.jackson.type.TypeReference"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetPatternUtil"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesManager"%>
<%@page import="com.fatwire.assetapi.data.BlobObject"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<cs:ftcs>
<%
	String patternJson = request.getParameter("patterns");
	List<WebReferencePatternBean> patterns = null;
	String urlPattern = null;
	String assetType = null;
	String blobHeaders = "";
	String blobField = "";
	if (StringUtils.isNotBlank(patternJson)) {
		try {
			patterns = new ObjectMapper().readValue(patternJson, new TypeReference<List<WebReferencePatternBean>>() {});
		} catch (Exception e) {
			 _log.error("pattern json is invalid " + e.getMessage());
		}
	}
	if (patterns!= null && patterns.size() == 1) {
		for (WebReferencePatternBean pattern : patterns) 
		{
			urlPattern = pattern.getPattern();
			assetType = pattern.getAssettype();
			blobHeaders = pattern.getParams();
			blobField = pattern.getField();
		}
	}
	AssetPatternUtil assetPatternUtil = new AssetPatternUtil(ics);
	String id = ics.GetVar("assetId");
	Map<String, Object> ret = new HashMap<String, Object>();
	if (null != id && !"".equals(id.trim())) {
		AssetId assetId = new AssetIdImpl(assetType, Long.valueOf(id.trim()));		
		ret = assetPatternUtil.getAssetDataAsMap(assetId);
	}
	String evaluatedPattern = "";
	String evaluatedPatterns = "";	
	if (StringUtils.isNotBlank(blobField) && urlPattern.contains("Dindex")) {
		if (ret.get(blobField) != null) {
			if (ret.get(blobField) instanceof List) {
				List<BlobObject> blobListData = (java.util.List) ret.get(blobField);
				int index = 0;
				for (BlobObject blobObject : blobListData) {
					//urlPattern
					String replacedUrlPattern = urlPattern;
					if (urlPattern.contains("Dindex"))
						replacedUrlPattern = urlPattern.replaceAll("Dindex", String.valueOf(index));
					if (index != 0)
						evaluatedPatterns = evaluatedPatterns + ",";
					String evalPattern = assetPatternUtil.getUrlFor(replacedUrlPattern, ret);
					evalPattern = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(evalPattern);
					evaluatedPatterns = evaluatedPatterns + "\"" + evalPattern + "\"";
					index ++;    			
				}
			} else {
				evaluatedPattern = assetPatternUtil.getUrlFor(urlPattern, ret);
			}
		}
		blobHeaders = assetPatternUtil.getUrlFor(blobHeaders, ret);
	}
	else {
		evaluatedPattern = assetPatternUtil.getUrlFor(urlPattern, ret);
	}	
%>
{
	"pattern" : "<%=org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(evaluatedPattern)%>",
	"patterns" : [<%=evaluatedPatterns%>],
	"blobHeaders" : "<%=org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(blobHeaders)%>"
}
</cs:ftcs>