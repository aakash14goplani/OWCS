<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternSave
//
// INPUT
//
// OUTPUT
//%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencePatternBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesPattern"%>
<%@page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="org.codehaus.jackson.type.TypeReference"%>
<%@page import="org.codehaus.jackson.JsonParseException"%>
<%@page import="org.codehaus.jackson.map.JsonMappingException"%>
<%@page import="java.io.IOException"%>
<%@ page import="com.openmarket.basic.interfaces.AssetException" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="java.util.Collections"%>
<%@page import="com.fatwire.cs.core.db.PreparedStmt"%>
<%@page import="com.fatwire.cs.core.db.StatementParam"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
	private static final String webReferencesPatternTable = "WebReferencesPatterns";
	private static String nameCheckSQL = "SELECT * FROM " + webReferencesPatternTable + " WHERE name=?";
%>
<cs:ftcs>
<xlat:lookup key="UI/Forms/DuplicatePattern" varname="DuplicatePattern"/>
<xlat:lookup key="UI/Forms/DuplicateName" varname="DuplicateName"/>
<xlat:lookup key="dvin/Common/Success" varname="SuccessFulSave"/>
<xlat:lookup key="UI/Forms/ErrorSavingPattern" varname="ErrorSavingPattern"/>
<%
	
	String patternJson = request.getParameter("patterns");
	List<WebReferencePatternBean> patterns = null;
	String status = "fail";
	String patternId = "-1";
	String message = ics.GetVar("ErrorSavingPattern");
	boolean result = false;
	if (StringUtils.isNotBlank(patternJson)) 
	{
		try 
		{
			patterns = new ObjectMapper().readValue(patternJson, new TypeReference<List<WebReferencePatternBean>>() {});
		} 
		catch (JsonParseException e) 
		{
			_log.warn("Unable to parse the given json: " + e.getMessage());
		}
		catch (JsonMappingException e) 
		{
			_log.warn("Unable to map the given json to bean: " + e.getMessage());
		}
		catch (IOException e) 
		{
			_log.error("Unable to get the json" + e.getMessage());
		}
		
		try 
		{
			if (patterns!= null && patterns.size() == 1) 
			{
				WebReferencePatternBean pattbean = patterns.get(0);
				StringBuilder patternFindSQL = new StringBuilder("");
				patternFindSQL.append("SELECT * FROM " + webReferencesPatternTable + " WHERE ");
				patternFindSQL.append("assettype='" + pattbean.getAssettype() + "' AND ");
				patternFindSQL.append("pattern='" + pattbean.getPattern() + "' AND ");
				if (StringUtils.isNotBlank(pattbean.getField()))
				{
					if ("".equals(pattbean.getSubtype()))
						patternFindSQL.append("(subtype='" + pattbean.getSubtype() + "' OR subtype IS NULL) AND ");
					else
						patternFindSQL.append("subtype='" + pattbean.getSubtype() + "' AND ");
						
					patternFindSQL.append("field='" + pattbean.getField() + "'");
				}
				else
				{
					if ("".equals(pattbean.getSubtype()))
						patternFindSQL.append("(subtype='" + pattbean.getSubtype() + "' OR subtype IS NULL) AND ");
					else
						patternFindSQL.append("subtype='" + pattbean.getSubtype() + "' AND ");
						
					if ("".equals(pattbean.getDgroup()))
						patternFindSQL.append("(dgroup='" + pattbean.getDgroup() + "' OR dgroup IS NULL)");
					else
						patternFindSQL.append("dgroup='" + pattbean.getDgroup() + "'");
				}
				
					
				if (pattbean.getId() > 0)
				{
					WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
					result = webReferencesPattern.save(patterns);	
				}
				else
				{
					PreparedStmt stmt1 = new PreparedStmt(nameCheckSQL, Collections.singletonList(webReferencesPatternTable));
					stmt1.setElement(0, webReferencesPatternTable, "name");
					StatementParam param1 = stmt1.newParam();
					param1.setString(0, pattbean.getName());
					IList list1 = ics.SQL(stmt1, param1, false);					
					if ( null != list1 && list1.hasData())
					{
						status = "fail";
						patternId = "-1";
						message = ics.GetVar("DuplicateName");
					} 
					else 
					{						
						IList list2 = ics.SQL(webReferencesPatternTable, patternFindSQL.toString(), null, -1, false, new StringBuffer());
						
						if ( null != list2 && list2.hasData() ) 
						{
							status = "fail";
							patternId = "-1";
							message = ics.GetVar("DuplicatePattern");
						}
						else 
						{
							WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
							result = webReferencesPattern.save(patterns);						
						}
					}
				}				
				if (result) {
					IList list = ics.SQL(webReferencesPatternTable, patternFindSQL.toString(), null, -1, false, new StringBuffer());	
					if ( null != list && list.hasData() )
					{
						list.moveTo(1);
						patternId = list.getValue(ftMessage.objid);
						status = "success";							
						message = ics.GetVar("SuccessFulSave");
					}
				}	
			}			
			out.println("{");
			out.println("\"status\":\"" + status + "\",");
			out.println("\"patternId\":\"" + patternId + "\",");
			out.println("\"message\":\"" + message + "\"");
			out.println("}");
		}
		catch (AssetException e) 
		{
			_log.error("Unable to save the pattern: " + e.getMessage());
		}
	}
%>
</cs:ftcs>