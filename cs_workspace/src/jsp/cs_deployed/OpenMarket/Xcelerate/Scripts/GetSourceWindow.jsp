<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Scripts/GetSourceWindow
//
// INPUT
//
// OUTPUT
//%>

<cs:ftcs>

 <script type="text/javascript">
		/**
			Gets the window which has the function declared.
			The function name can also be hierrachial like 'fw.controlpanel.getAssignments' or just 
			the function name like 'getAssignments'.
		*/
		function getSourceWindow(windowObject, functionName)
		{
			var nameParts = functionName.split('.'),
				currObj = windowObject,
				found = true,
				i = 0;			
			for (i = 0; i < nameParts.length; i++) {
				if (currObj[nameParts[i]]) {
					currObj = currObj[nameParts[i]];
				} else {
					if (windowObject === windowObject.parent)
					{
						return null;
					}	
					return getSourceWindow(windowObject.parent,functionName);
				}
			}
			return windowObject;			
		}
 </script>
</cs:ftcs>