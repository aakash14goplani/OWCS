import COM.FutureTense.Interfaces.FTValList
import COM.FutureTense.Util.ftMessage
import com.fatwire.csdt.service.CSDTService
import com.fatwire.csdt.service.factory.CSDTServicefactory
import com.fatwire.csdt.service.valueobject.ServiceQueryValueObject

FTValList updateVal = new FTValList();
updateVal.setValString(ftMessage.verb, ftMessage.login);
updateVal.setValString(ftMessage.username, ics.GetVar("username"));
updateVal.setValString(ftMessage.password, ics.GetVar("password"));
updateVal.setValString(ftMessage.cstimeout, "-1"); // don't time out
ics.CatalogManager(updateVal);

boolean isMember = ics.UserIsMember("xceladmin");

if (isMember)
{
    List<String> errorList = new ArrayList<String>();
    ServiceQueryValueObject valueObject = new ServiceQueryValueObject();
    valueObject.setIds(ics.GetVar("resources"));
    valueObject.setDataStoreName(ics.GetVar("datastore"));
    valueObject.setIsDeps(!"false".equalsIgnoreCase(ics.GetVar("includeDeps")));
    String siteNames = ics.GetVar("fromSites");
    valueObject.setSourceSiteNames(siteNames);
    valueObject.setTargetSiteNames(ics.GetVar("toSites"));
    valueObject.setModifiedSince(ics.GetVar("modifiedSince"));
    valueObject.setDSKeys(ics.GetVar("dskeys"));
    valueObject.setIsRemote("true".equalsIgnoreCase(ics.GetVar("remote")));
    String command = ics.GetVar("command");
    CSDTService service = CSDTServicefactory.getService(command);
    errorList = service.execute(ics, valueObject);
}

FTValList list = new FTValList();
list.setValString(ftMessage.verb, ftMessage.logout);
list.setValString(ftMessage.killsession, ftMessage.truestr);
ics.CatalogManager(list);
