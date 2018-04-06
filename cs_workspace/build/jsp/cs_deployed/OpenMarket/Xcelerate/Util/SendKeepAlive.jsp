<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,java.io.*"
%>

<%--
- OpenMarket/Xcelerate/Util/SendKeepAlive
- This jsp element sends KeepAlive to the response of a long running process 
- so that the browser does not face timeout
- INPUT
- OUTPUT
--%>
<%! class KeepAliveThread extends Thread{
		JspWriter out;
		ServletResponse response;
		final static long WAIT_TIME=60000L;//wait time in msec, default value 1 min
		
		//mandatory constructor, however we do not need this, so private
		private KeepAliveThread(JspWriter out){
			this.out=out;
		}
		
		public KeepAliveThread(ServletResponse resp){
			this.response=resp;
		}
		
		public void run(){
			while(true){
				try{
					Thread.sleep(WAIT_TIME);//waiting for WAIT_TIME
					if(response.isCommitted()){
						response.getWriter().write("<!--KeepAlive Comment-->");
						response.flushBuffer();
					}else{
						break;
					}
				}catch(Exception ex){
					if(ex instanceof IOException){
						//breaking the loop in case of any exception
						break;
					}
				}
			}
		}
	}
%>
<%
	//initializing KeepAlive thread
	KeepAliveThread objKeepAliveThread=new KeepAliveThread(response);
	//start sending KeepAlive response
	objKeepAliveThread.start();
%> 

