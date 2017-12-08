package arc.apt.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;





//import cal.amm.Static.AMMtMapping;
//import cal.exe.Model.EXEmFunction;
import acf.acf.Abstract.ACFaAppController;
import acf.acf.General.annotation.ACFgFunction;
import acf.acf.General.core.ACFgRequestParameters;
import acf.acf.General.core.ACFgResponseParameters;
import arc.apf.Service.ARCsBusinessPlatform;
import arc.apf.Service.ARCsPaymentDetails;
import arc.apf.Service.ARCsProgrammeMaster;
import arc.apt.Static.APTtMapping;

@Controller
@Scope("session")
@ACFgFunction(id="")
@RequestMapping(value=APTtMapping.APT) 
public class APTc extends ACFaAppController {
    

    @Autowired ARCsPaymentDetails paymentdetailsService;
    @Autowired ARCsProgrammeMaster ProgrammeMasterService;
    @Autowired ARCsBusinessPlatform BusinessPlaformService;

    public APTc() throws Exception {
        super();
    }
    
     
    
    @RequestMapping(value=APTtMapping.APT_PAYMENTDETAILS_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getPaymentDetails(@RequestBody ACFgRequestParameters param) throws Exception {
        setAuditKey("payment_form_no", param.get("payment_form_no", String.class));
        System.out.println(param.get("payment_form_no", String.class));
        getResponseParameters().put("paymentdetails",         paymentdetailsService.getPaymentDetailsByNo((param.get("payment_form_no", String.class))));
        return getResponseParameters();
    }
    
    @RequestMapping(value=APTtMapping.APT_PROGRAMME_FIELDS_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters programmeFields(@RequestBody ACFgRequestParameters param) throws Exception {
        setAuditKey("programme_no", param.get("programme_no", String.class));
//   System.out.println(param.get("item_no", String.class));
        if (ProgrammeMasterService.isProgNoExisted((param.get("programme_no", String.class)))){
        getResponseParameters().put("programme_name",    ProgrammeMasterService.getProgrammeName((param.get("programme_no", String.class))));
        getResponseParameters().put("business_platform", ProgrammeMasterService.getProgrammePlatform((param.get("programme_no", String.class))));
        getResponseParameters().put("department",        ProgrammeMasterService.getProgrammeDepartment((param.get("programme_no", String.class))));
        getResponseParameters().put("description",       ProgrammeMasterService.getBusinessPlatformDesc ((param.get("programme_no", String.class))));
        }
        return getResponseParameters();
        
    }
//    
    @RequestMapping(value=APTtMapping.APT_BUSINESSPLATFORM_DESC_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getBusinessPlatformDesc(@RequestBody ACFgRequestParameters param) throws Exception {
//        setAuditKey("programme_no", param.get("programme_no", String.class));
//   System.out.println(param.get("item_no", String.class));
        getResponseParameters().put("description",    ProgrammeMasterService.getBusinessPlatformDesc ((param.get("programme_no", String.class))));
        return getResponseParameters();
    }

    
    
    
}


