<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/Workflow/ShowAssigneeSelections
//
// INPUT
//  cs_RoleList - name of variable containing comma delimited list of roles
//  cs_RolePrefix - [cs_RolePrefix][RoleName] variable where assignees are stored
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<%
    String sRoleList = ics.GetVar(ics.GetVar("cs_RoleList"));
    if (sRoleList != null && sRoleList.length() != 0) {
        String sCurrentToken = null;
        FTValList vN = new FTValList();
        java.util.StringTokenizer st = new java.util.StringTokenizer(sRoleList, ","); %>
        <table style="min-width:300px" BORDER="0" CELLSPACING="0" CELLPADDING="0">
         <tr>
    		<td></td><td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td><td></td>
    	</tr>
    	<tr>
          <td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
          <td >
          <table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff"><tr><td colspan="6" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>
              <tr><td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
                  <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif"><DIV class="new-table-title"><xlat:stream key="dvin/Common/Role"/></DIV></td>
                  <td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif"><DIV class="new-table-title"><xlat:stream key="dvin/Common/Users"/></DIV></td>
                  <td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
              </tr>
              <tr><td colspan="6" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr> <%
                String sRowStyle = "tile-row-normal";
				boolean bSeparatorLine = false;                                                                                                                                                                                               
                while (st.hasMoreTokens()) {
                  if (bSeparatorLine) { %>
                    <tr>
                        <%--<td colspan="6" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>--%>
                    </tr> <%
                    bSeparatorLine = true;
                  }
                  
                  sCurrentToken = st.nextToken(); %>
                  
                  <tr class="<%=sRowStyle%>"><td><BR /></td>
                  <td><BR /></td>
                    <td VALIGN="TOP" NOWRAP="NOWRAP" ALIGN="LEFT">
                    <DIV class="small-text-inset">
                      <string:stream value='<%=sCurrentToken%>'/>
                    </DIV>
                    </td>
                    <td><BR /></td><td VALIGN="TOP" ALIGN="LEFT">
                    <%
                      java.util.StringTokenizer users = new java.util.StringTokenizer(ics.GetVar(ics.GetVar("cs_RolePrefix")+sCurrentToken), ";");
                      StringBuffer userBuffer = new StringBuffer();
                      while (users.hasMoreTokens()) {
                          vN.setValString("USER", users.nextToken());
                          vN.setValString("VARNAME", "cs_CurrentUser");
                          ics.runTag("usermanager.getdisplayableusername", vN);
                          vN.removeAll();

                          if (userBuffer.length() == 0) {
                              userBuffer.append(ics.GetVar("cs_CurrentUser"));
                          } else userBuffer.append(", "+ics.GetVar("cs_CurrentUser"));
                      }
                      String sUserDisplay = userBuffer.toString();
                      %>
					<DIV class="small-text-inset" style="padding-right:5px;" title='<%=sUserDisplay%>'>
						<string:stream value='<%=sUserDisplay%>'/>
                    </DIV>
                    </td>
                    <td><BR /></td></tr>
                    </div> <%
                    if (sRowStyle.equals("tile-row-normal")) {
                        sRowStyle = "tile-row-highlight";
                    } else sRowStyle = "tile-row-normal";
                } %>
              </table>
      	    </td>
      		<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
      		</tr>
          <tr>
          <td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
          </tr>
          <tr>
          <td></td><td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif"><IMG WIDTH="1" HEIGHT="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td><td></td>
          </tr>
        </table> <%
    }
%>
</cs:ftcs>