// package arc.apf.Controller;
//
// import java.util.List;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.context.annotation.Scope;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.ModelMap;
// import org.springframework.web.bind.annotation.RequestBody;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestMethod;
// import org.springframework.web.bind.annotation.ResponseBody;

// import acf.acf.Abstract.ACFaAppController;
// import acf.acf.General.annotation.ACFgFunction;
// import arc.apf.Static.APTtMapping;

// @Controller
// @Scope("session")
// @ACFgFunction(id="APTF002")
// @RequestMapping(value=APTtMapping.APTF002)
// public class APTc002 extends ACFaAppController {
// 
// 	@RequestMapping(value=APTtMapping.APTF002_MAIN, method=RequestMethod.GET)
// 	public String main(ModelMap model) throws Exception {
// 		return view();
// 	}
// 
// 
// }

package arc.apt.Controller;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import acf.acf.Database.ACFdSQLAssDelete;
import acf.acf.Database.ACFdSQLAssInsert;
import acf.acf.Database.ACFdSQLAssSelect;
import acf.acf.Database.ACFdSQLAssUpdate;
import acf.acf.Database.ACFdSQLRule;
import acf.acf.Database.ACFdSQLRule.RuleCase;
import acf.acf.Database.ACFdSQLRule.RuleCondition;
import acf.acf.General.annotation.ACFgAuditKey;
import acf.acf.General.annotation.ACFgFunction;
import acf.acf.General.annotation.ACFgTransaction;
import acf.acf.General.core.ACFgRequestParameters;
import acf.acf.General.core.ACFgResponseParameters;
import acf.acf.General.core.ACFgSearch;
import acf.acf.Interface.ACFiCallback;
import acf.acf.Interface.ACFiSQLAssWriteInterface;
import acf.acf.Abstract.ACFaAppController;
//import arc.apf.Controller.APFc004.Search;
import arc.apf.Dao.APFoLocation;
import arc.apf.Dao.ARCoPaymentDetails;
import arc.apf.Dao.ARCoPaymentRequest;
import arc.apf.Dao.ARCoSupplier;
import arc.apf.Model.APFmLocation;
import arc.apf.Model.ARCmItemInventory;
import arc.apf.Model.ARCmPOHeader;
import arc.apf.Model.ARCmPaymentDetails;
import arc.apf.Model.ARCmPaymentRequest;
import arc.apf.Model.ARCmSupplier;
import arc.apf.Model.ARCmWPConsumptionHeader;
import arc.apf.Model.ARCmWPConsumptionItem;
import arc.apf.Service.APFsModule;
import arc.apf.Service.ARCsAccountAllocation;
import arc.apf.Service.ARCsPaymentRequest;
import arc.apf.Service.ARCsProgrammeMaster;
import arc.apf.Service.ARCsSection;
import arc.apf.Service.ARCsSupplier;
import arc.apf.Static.APFtMapping;
import arc.apt.Static.APTtMapping;

@Controller
@Scope("session")
@ACFgFunction(id="APTF002")
@RequestMapping(value=APTtMapping.APTF002)
public class APTc002 extends ACFaAppController {
    
    private static final String ProgrammeMasterService = null;
    @Autowired ARCoPaymentRequest paymentrequestDao;
    @Autowired ARCoPaymentDetails paymentdetailsDao;
    
    @ACFgAuditKey String payment_form_no;
    @ACFgAuditKey String supplier_code;
    @Autowired ARCsSupplier supplierService;
    @Autowired ARCsPaymentRequest paymentrequestService;
    @Autowired ARCsSection SectionService;
    @Autowired ARCsAccountAllocation AccountAllocationService;
    @Autowired ARCoPaymentDetails paymentdetailsService;
    @Autowired ARCsProgrammeMaster programmemasterService;
    
      
    private class Search extends ACFgSearch {
       
        public Search() {
            super();
          //SQL to combine two tables to form one grid in browser function
            setCustomSQL("select * from (select pr.payment_form_no, pr.request_date, pr.section_id, pr.request_department, pr.supplier_code, pr.despatch_date, pr.remarks, sp.supplier_name " +
                    "from arc_payment_request pr, arc_supplier sp " +
                    "where (pr.supplier_code = sp.supplier_code) "
                    + "and (pr.section_id = '07') and (sp.supplier_code = 'CASH')) ");
            setKey("payment_form_no");
            //setModel(ARCmPaymentRequest.class);
            addRule(new ACFdSQLRule("payment_form_no", RuleCondition.EQ, null, RuleCase.Insensitive));
          //  addRule(new ACFdSQLRule("request_date", RuleCondition.EQ, null, RuleCase.Insensitive));
           // addRule(new ACFdSQLRule("supplier_name", RuleCondition._LIKE_, null, RuleCase.Insensitive));
           // addRule(new ACFdSQLRule("supplier_code", RuleCondition.EQ, null, RuleCase.Insensitive));
          
        }

        @Override
        public Search setValues(ACFgRequestParameters param) throws Exception {
            super.setValues(param);// param is a object, "Search" 's mother class passed
                if(!param.isEmptyOrNull("request_date")) {
                wheres.and("request_date", ACFdSQLRule.RuleCondition.EQ, param.get("request_date", Timestamp.class));
                }
            
            orders.put("request_date", false);
            return this;
        }

    
    }
    Search search = new Search();
    @RequestMapping(value=APTtMapping.APTF002_MAIN, method=RequestMethod.GET)
    public String main(ModelMap model) throws Exception {
        
       model.addAttribute("searchsupplier", supplierService.getSupplierPairs());
       model.addAttribute("searchpayformno", paymentrequestService.getPaymentRequestByNoCash());
       model.addAttribute("subsectionidselect", SectionService.getAllSubSectionName7());
       model.addAttribute("acallocselect", AccountAllocationService.getAcAllocPairs());
       model.addAttribute("prognoselect", programmemasterService.getProgNoPairs());
       model.addAttribute("getsuppliercode", supplierService.getSupplierNameCash(supplier_code));
 //      model.addAttribute("getsuppliercode", supplierService.getSupplierPairs());  only 'CASH' can be selected     
       
       return view();
    }

    

    
    ////form maintenance here, how to modify? imoprt apff001.java and remove grid in jsp file
    @RequestMapping(value=APTtMapping.APTF002_SEARCH_AJAX, method=RequestMethod.POST)
    @ResponseBody
     public ACFgResponseParameters getGrid(@RequestBody ACFgRequestParameters param) throws Exception {
          //The method getGrid responds to AJAX by obtain the Search JSON result and put in variable “grid_browse”.
            // ACF will forward the content to client and post to the grid which ID equals to “grid_browse”.
            search.setConnection(getConnection("ARCDB")); //get connection to the database
            search.setValues(param);
            search.setFocus(payment_form_no);
          // System.out.println("param:"+param);
          // System.out.println(search.getGridResult());
            return new ACFgResponseParameters().set("grid_browse", search.getGridResult()); // can only be called once, otherwise reset parameter
        }
    @RequestMapping(value=APTtMapping.APTF002_GET_SUPPLIER_NAME_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getSupplierName(@RequestBody ACFgRequestParameters param) throws Exception {
        setAuditKey("supplier_code", param.get("supplier_code", String.class));
        getResponseParameters().put("supplier_name",       supplierService.getSupplierNameById((param.get("supplier_code", String.class))));
        return getResponseParameters();
    } 
    
    @RequestMapping(value=APTtMapping.APTF002_GET_PAYMENTDETAILS_TABLE_AJAX, method=RequestMethod.POST) //get rows of the second grid
    @ResponseBody
    public ACFgResponseParameters getPaymentDetailsTable(@RequestBody ACFgRequestParameters param) throws Exception {
        System.out.print("-------------------------");
      ACFdSQLAssSelect select = new ACFdSQLAssSelect(); //must have modified_at in SQL otherwise won't save!!!
      select.setCustomSQL("select * from (select pd.payment_form_no, pd.sequence_no, pd.modified_at,"
              + "pd.sub_section_id, pd.purchase_order_no,"
              + "pd.invoice_no, pd.programme_no, pd.from_episode_no, "
              + "pd.to_episode_no, pd.particulars, pd.job_description, pd.account_allocation, pd.payment_amount,"
              + "pd.include_in_weekly_reporting, pd.include_in_monthly_reporting,"
              + "pg.programme_name, pg.business_platform, pg.department, bp.description "
              + "from arc_payment_request pr, arc_payment_details pd, arc_programme_master pg, arc_business_platform bp "
              + "where pr.payment_form_no = pd.payment_form_no "
              + "and pd.programme_no = pg.programme_no "
              + "and pg.business_platform = bp.business_platform "
              + "and pg.department = bp.department )");
      
   //    select.setCustomSQL("select * from (select pd.payment_form_no, pd.sequence_no, pd.modified_at, pd.sub_section_id,"
   //                 + " pd.purchase_order_no, pd.invoice_no, pd.programme_no, pd.from_episode_no, "
   //                 + "pd.to_episode_no, pd.particulars, pd.job_description, pd.account_allocation,"
   //                 + " pd.payment_amount, pd.include_in_weekly_reporting, "
   //                 + "pd.include_in_monthly_reporting "
   //                 + "from arc_payment_request pr, arc_payment_details pd "
   //                 + "where pr.payment_form_no = pd.payment_form_no )");
       
      select.setKey("payment_form_no","sequence_no");
      select.wheres.and("payment_form_no", payment_form_no);
      //select.orders.put("seq", true);
      return getResponseParameters().set("grid_paymentdetails", select.executeGridQuery(getConnection("ARCDB"), param));
    
    }
    
    
     @RequestMapping(value=APTtMapping.APTF002_GET_FORM_AJAX, method=RequestMethod.POST)
        @ResponseBody
        public ACFgResponseParameters getForm(@RequestBody ACFgRequestParameters param) throws Exception {
            payment_form_no = param.get("payment_form_no", String.class); //pick the value of parameter “func_id” from client
            getPaymentDetailsTable(param.getRequestParameter("grid_paymentdetails"));
            //retrieves the result by DAO, and put in the variable “frm_main”. 
            //ACF will forward the content to client and post to the form which ID equals to “frm_main”
            return getResponseParameters().set("frm_main", paymentrequestDao.selectItem(payment_form_no)); //change dao here
        }
     @ACFgTransaction
        @RequestMapping(value=APTtMapping.APTF002_SAVE_AJAX, method=RequestMethod.POST)
        @ResponseBody
        public ACFgResponseParameters save(@RequestBody ACFgRequestParameters param) throws Exception { //function in the upper right "save" button
          //the controller obtains the changes of form data 
            List<ARCmPaymentRequest> amendments = param.getList("form", ARCmPaymentRequest.class);
            final List<ARCmPaymentDetails> Paymentdetailsamendments = param.getList("paymentdetails", ARCmPaymentDetails.class);

            //  final List<ARCmPaymentDetails> Paymentdetailsamendments = param.getList("payment_details", ARCmPaymentDetails.class);
            
            //and call DAO to save the changes
            ARCmPaymentRequest lastItem = paymentrequestDao.saveItems(amendments, new ACFiSQLAssWriteInterface<ARCmPaymentRequest>(){
                
                //interface for the related functions
                @Override
                public boolean insert(ARCmPaymentRequest newItem, ACFdSQLAssInsert ass) throws Exception {
                    //ass.columns.put("allow_print", 1); //without the allow_print column, the whole sql won't work
                	System.out.println("****" + newItem.payment_form_no);
                	final String abc = newItem.payment_form_no;
                	
                	ass.setAfterExecute(new ACFiCallback() {
                    @Override
                    public void callback() throws Exception {
                        if (Paymentdetailsamendments != null)
                            paymentdetailsDao.saveItems(Paymentdetailsamendments, abc);
                    }
                });
                return false;
                }

                @Override
                public boolean update(ARCmPaymentRequest oldItem, final ARCmPaymentRequest newItem, ACFdSQLAssUpdate ass) throws Exception {
                    ass.setAfterExecute(new ACFiCallback() {
                    	
                    	final String abc = newItem.payment_form_no;
                    	
                        @Override
                        public void callback() throws Exception {
                            if (Paymentdetailsamendments != null){
                                System.out.println("----------------testing- update------" + Paymentdetailsamendments);
                                paymentdetailsDao.saveItems(Paymentdetailsamendments, abc);
                            }
                        }
                    });
                    return false;
                }

                @Override
                public boolean delete(ARCmPaymentRequest oldItem, ACFdSQLAssDelete ass) throws Exception {
                	if(!oldItem.despatch_date.equals(Timestamp.valueOf("1900-01-01 00:00:00"))){
                		throw exceptionService.error("APT004E");
                	}
                	List<ARCmPaymentDetails> details = paymentdetailsDao.selectItems(oldItem.payment_form_no);
                	for(ARCmPaymentDetails d : details){
                		paymentdetailsDao.deleteItem(d);
                	}
                	return false;
                }
            });
            payment_form_no = lastItem!=null? lastItem.payment_form_no: null;
            ACFgResponseParameters r = getResponseParameters();
            r.set("new_form_no", payment_form_no);
            r.set("action", amendments.get(0).getAction());
            return r;
        }
     
    
     
     
}


