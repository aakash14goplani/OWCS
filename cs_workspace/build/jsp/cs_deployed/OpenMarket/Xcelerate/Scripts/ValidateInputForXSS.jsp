<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%//
// OpenMarket/Xcelerate/Scripts/ValidateInputForXSS
//	Moved the javascript from cs.js to ValidateInputForXSS
// INPUT
//
// OUTPUT
//%>

<cs:ftcs>

<script type="text/javascript">

/** [2007-09-1x KG]
 * Test if there are any characters in str that might
 * trip up and parse as HTML or JS.  Used for XSS fixes,
 * adapted from 6.3 fixes.
 * @param str - variable to test for invalid characters
 * @param morechars - optional string of additional characters to check against
 * @param replace - optional boolean, if true, morechars *replaces* invchars (instead of append)
 * @return - true if str contains NO invalid characters.
 */
//Previously ^ \ and / have been removed.
function isCleanString(str, morechars, replace) {
   //PR#30431 Prevent smart curly quotes in asset names
   // So replacing them with single and double quotes
   // so that then can be checked later
	 str = str.replace( /\u2018|\u2019|\u201A|\uFFFD/g, "'" );
	 str = str.replace( /\u201c|\u201d|\u201e/g, '"' );
  //[2008-02-21 KGF] checking for \ only at end of string.
  //since this is a special case, it can't simply be thrown into
  //the array with the rest... so we'll always check for it here.
  if (str.substr(str.length - 1) == '\\')
    return false;
  
  var invchars;
  if (replace) invchars = new Array(); //morechars replaces defaults
  else invchars = new Array("'", '"', ';', ':', '?', "\<", "\>", '%');
  if (morechars) { //add additional characters present in morechars
    for (var i = 0; i < morechars.length; i++) {
      invchars.push(morechars.charAt(i));
    }
  }
  //6.3 used iterative loop + charAt.
  //indexOf is MUCH faster especially in FF.
  for (var i = 0; i < invchars.length; i++) {
    if (str.indexOf(invchars[i]) >= 0) return false;
  }
  return true;
}



</script>

</cs:ftcs>