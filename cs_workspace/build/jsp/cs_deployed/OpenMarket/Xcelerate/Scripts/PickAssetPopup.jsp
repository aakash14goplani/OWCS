<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Scripts/PickAssetPopup
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<script type="text/javascript">
    function OpenPickAssetPopup(popupUrl, history)
    {
        window.open(popupUrl+'&cs_History='+history,'Popup','WIDTH=600,HEIGHT=600,status=0,scrollbars=1,resizable=yes');
    }

    function GetBannerHistory()
    {
        var i, histString='', currentVal;
        
        if (parent.parent['XcelBanner']) {
            for(i=0;i<parent.parent['XcelBanner'].hist.length;i++)
            {
                currentVal = parent.parent['XcelBanner'].hist[i];
                if (i==0)
                    histString=currentVal.id;
                else
                    histString=histString+","+currentVal.id;
            }
        }
        return histString;
    }
</script>

</cs:ftcs>