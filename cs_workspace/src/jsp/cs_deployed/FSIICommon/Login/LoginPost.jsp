<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><cs:ftcs>
<div id="loginpost">
<%-- This is the form processing page.  Because it is
     called by the wrapper, we must not leak any line
     breaks at all if possible.
                
     First, reccord standard dependencies 
--%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>'   c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>'   c="CSElement"/></ics:then></ics:if>
<%--
       Next, verify that the form was properly filled out.
       If it was, then look up the user using a handy
       utility element called FindUser.
--%>
<ics:if condition='<%=ics.GetVar("Username")!=null && ics.GetVar("Password")!=null %>' >
<ics:then>
	<render:lookup key="FindUser" match=":x" varname="FindUserCSElement" ttype="CSElement"/>
	<%-- We call with local scope because we don't want variable leakage, but we do want 
	     the list to be set.  However, lists aren't in the variable pool.... --%>
    <render:callelement scoped="local" elementname='<%=ics.GetVar("FindUserCSElement")%>'>
		<render:argument name="listname" value="theUserList"/>
		<render:argument name="username" value='<%= ics.GetVar("Username") %>' />
		<render:argument name="password" value='<%= ics.GetVar("Password") %>'/>
	</render:callelement>
</ics:then>
<ics:else>
	<p>Username/Password can not be null.</p>
</ics:else>
</ics:if>

<ics:if condition='<%= ics.GetList("theUserList") != null && ics.GetList("theUserList").hasData() %>'>
<ics:then>
    <%-- Note that the assetid field is a standard field, and therefore it does not need to be looked up --%>
	<ics:listget listname="theUserList" fieldname="assetid" output="VisitorId"/>
	
	<render:lookup key="LogInUser" match=":x" varname="LogInUser" ttype="CSElement"/>
	<%-- Call the element with local scope because we aren't going to set any 
	     variables and we don't wany any leaks.  However, We know that the called
		 element will create session objects, which reside in a different pool --%>
	<render:callelement scoped="local" elementname='<%= ics.GetVar("LogInUser")%>'>
		<render:argument name="VisitorID" value='<%= ics.GetVar("VisitorId") %>' />
		<render:argument name="VisitorUserName" value='<%= ics.GetVar("Username") %>'/>
	</render:callelement>
</ics:then>
<ics:else>
	<p>Login failed</p>
</ics:else>
</ics:if>
</div>
</cs:ftcs>