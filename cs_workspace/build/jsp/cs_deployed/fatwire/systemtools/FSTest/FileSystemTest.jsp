<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%//
// fatwire/systemtools/FSTest/FileSystemTest
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="com.fatwire.cs.systemtools.util.FileZipper"
%><%@ page import="com.fatwire.cs.systemtools.util.SysInfoUtils"
%><%@ page import="com.fatwire.cs.systemtools.util.FileUtil"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.util.ArrayList"
%><%@ page import="java.util.Collection"
%><%@ page import="java.io.*"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.FSTest"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.FSTest.FSTestBean"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.FSTest.FSTestResultBean"
%>
<cs:ftcs>
<string:encode variable="type" varname="type"/>
<%
String fsResults = ics.GetVar("downloadFSResults");
if(fsResults !=null && !"".equals(fsResults))
{
    String blobId = FSTest.writeFSTestResults(ics,fsResults);
	%>
    <satellite:blob assembler="query" service='<%=ics.GetVar("empty")%>'
		blobtable="MungoBlobs"
		blobkey="id"
		blobwhere='<%=blobId%>'
		blobcol="urldata"
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		outstring="fsTestResultsURL"
		blobnocache="true">
		<satellite:argument name="blobheadername1" value="content-type"/>
		<satellite:argument name="blobheadervalue1" value="application/octet-stream"/>
		<satellite:argument name="blobheadername2" value="Content-Disposition"/>
		<satellite:argument name="blobheadervalue2" value="attachment;filename=FSTestResults.zip"/>
		<satellite:argument name="blobheadername3" value="MDT-Type"/>
		<satellite:argument name="blobheadervalue3" value="abinary; charset=UTF-8"/>
	</satellite:blob>
	_FW_MARKER1_{'outPutUrl':'<%=ics.GetVar("fsTestResultsURL")%>'}_FW_MARKER2_
	<%
}
else
{
int numThreads = Integer.parseInt(ics.GetVar("numThreads"));
int numFiles = Integer.parseInt(ics.GetVar("numFiles"));
int fileSize = Integer.parseInt(ics.GetVar("fileSize"));

int numReads = Integer.parseInt(ics.GetVar("numReads"));
boolean fileLock = Boolean.parseBoolean(ics.GetVar("filelock"));
boolean fileAttr = Boolean.parseBoolean(ics.GetVar("fileAttr"));

String where = ics.GetVar("type") ==null?"local":ics.GetVar("type");
String rafMode = ics.GetVar("rafMode") ==null?"rws":ics.GetVar("rafMode");
FSTest.FSTestBean beanInfo = new FSTest.FSTestBean ();
beanInfo.setNumThreads(numThreads);
beanInfo.setNumFiles(numFiles);
beanInfo.setFileSize(fileSize);
beanInfo.setNumReads(numReads);
beanInfo.setFileLock(fileLock);
beanInfo.setFileAttr(fileAttr);
beanInfo.setFile(where, ics, getServletConfig().getServletContext());
beanInfo.setMode(rafMode);
FSTest.FSTestResultBean result = FSTest.test(beanInfo);
%>{where:'<%=where%>',rafMode:'<%=rafMode%>',<%
%>numThreads:<%=Integer.toString(numThreads)%>,<%
%>numFiles:<%=Integer.toString(numFiles)%>,<%
%>fileSize:<%=Integer.toString(fileSize)%>,<%
%>numReads:<%=Integer.toString(numReads)%>,<%
%>fileLock:<%=Boolean.toString(fileLock)%>,<%
%>fileAttr:<%=Boolean.toString(fileAttr)%>,<%
%>avgCreateTime:<%=result.getAvgCreateTime()%>,<%
%>avgWriteTime:<%=result.getAvgWriteTime()%>,<%
%>avgReadTime:<%=result.getAvgReadTime()%>,<%
%>avgDeleteTime:<%=result.getAvgDeleteTime()%>,<%
%>minCreateTime:<%=result.getMinCreateTime()%>,<%
%>minWriteTime:<%=result.getMinWriteTime()%>,<%
%>minReadTime:<%=result.getMinReadTime()%>,<%
%>minDeleteTime:<%=result.getMinDeleteTime()%>,<%
%>maxCreateTime:<%=result.getMaxCreateTime()%>,<%
%>maxWriteTime:<%=result.getMaxWriteTime()%>,<%
%>maxReadTime:<%=result.getMaxReadTime()%>,<%
%>maxDeleteTime:<%=result.getMaxDeleteTime()%>,<%
%>totalTime:<%=result.getTotalTime()%>,<%
%>"threads":<%=result.getjSonResult()%> }<%}%>
</cs:ftcs>
