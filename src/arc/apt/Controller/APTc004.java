package arc.apt.Controller;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.lang3.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import acf.acf.Abstract.ACFaAppController;
import acf.acf.Database.ACFdSQLAssDelete;
import acf.acf.Database.ACFdSQLAssInsert;
import acf.acf.Database.ACFdSQLAssUpdate;
import acf.acf.Database.ACFdSQLRule;
import acf.acf.Database.ACFdSQLRule.RuleCase;
import acf.acf.Database.ACFdSQLRule.RuleCondition;
import acf.acf.Database.ACFdSQLWhere;
import acf.acf.General.annotation.ACFgAuditKey;
import acf.acf.General.annotation.ACFgFunction;
import acf.acf.General.annotation.ACFgTransaction;
import acf.acf.General.core.ACFgRawModel;
import acf.acf.General.core.ACFgRequestParameters;
import acf.acf.General.core.ACFgResponseParameters;
import acf.acf.General.core.ACFgSearch;
import acf.acf.Interface.ACFiCallback;
import acf.acf.Interface.ACFiSQLAssWriteInterface;
import acf.acf.Model.ACFmGridResult;
import arc.apf.Service.ARCsPaymentRequest;
import arc.apf.Dao.ARCoPaymentRequest;
import arc.apf.Model.ARCmPaymentRequest;
import arc.apf.Model.ARCmSection;
import arc.apf.Service.ARCsSupplier;
import arc.apf.Static.APFtMapping;
import arc.apt.Static.APTtGlobal;
import arc.apt.Static.APTtMapping;

@Controller
@Scope("session")
@ACFgFunction(id="APTF004")
@RequestMapping(value=APTtMapping.APTF004)
public class APTc004 extends ACFaAppController {

	@Autowired ARCoPaymentRequest paymentRequestDao;
	@Autowired ARCsPaymentRequest paymentRequestService;
	@Autowired ARCsSupplier       supplierService;

	@ACFgAuditKey String payment_form_no;
	@ACFgAuditKey Timestamp request_date;
	@ACFgAuditKey String supplier_code;
	
	String section_id = APTtGlobal.APT_SECTION_ID;
	Timestamp defaultTimestamp = getDefaultTimestamp();
	
	Search search = new Search();
	
	private class Search extends ACFgSearch {
		public Search() {
			super();
			setCustomSQL("select t1.payment_form_no as payment_form_no, t1.request_date as request_date, t1.supplier_code as supplier_code, " +
		             "t1.despatch_date as despatchdate, t1.despatch_date as despatch_date , t1 .modified_at as modified_at" +
		             "   from arc_payment_request t1");
            setKey("payment_form_no");	

            System.out.println("call search ");
		
			addRule(new ACFdSQLRule("section_id", RuleCondition.EQ,null, RuleCase.Insensitive));		
			addRule(new ACFdSQLRule("supplier_code", RuleCondition.EQ,null, RuleCase.Insensitive));	

		}

        @Override
        public Search setValues(ACFgRequestParameters param) throws Exception { //use the search class to setup an object
            super.setValues(param);// param is a object, "Search" 's mother class passed
            param.put("section_id", section_id);
            param.put("despatch_date", defaultTimestamp);
            if(!param.isEmptyOrNull("section_id")) {
            System.out.println(param.get("section_id", String.class));	
            System.out.println(param.get("despatch_date", Timestamp.class));	
            wheres.and("section_id", ACFdSQLRule.RuleCondition.EQ, param.get("section_id", String.class));
            wheres.and("despatch_date", ACFdSQLRule.RuleCondition.EQ, param.get("despatch_date", Timestamp.class));
            }
            if(!param.isEmptyOrNull("fr_form_no")) {
            System.out.println(param.get("fr_form_no", String.class));	
            wheres.and("payment_form_no", ACFdSQLRule.RuleCondition.GE, param.get("fr_form_no", String.class));
            }
            if(!param.isEmptyOrNull("to_form_no")) {
            System.out.println(param.get("to_form_no", String.class));		
            wheres.and("payment_form_no", ACFdSQLRule.RuleCondition.LE, param.get("to_form_no", String.class));
            }            
            if(!param.isEmptyOrNull("select_fr_date")) {	
            System.out.println(param.get("select_fr_date", Timestamp.class));	            	
            wheres.and("request_date", ACFdSQLRule.RuleCondition.GE, param.get("select_fr_date", Timestamp.class));
            }
            if(!param.isEmptyOrNull("select_to_date")) {
            System.out.println(param.get("select_to_date", Timestamp.class));	                  	
            wheres.and("request_date", ACFdSQLRule.RuleCondition.LE, new Timestamp(param.get("select_to_date", Long.class) + 24*60*60*1000));
            }
               
			return this;
		}			
		
	}

	@RequestMapping(value=APTtMapping.APTF004_MAIN, method=RequestMethod.GET)
	public String main(ModelMap model) throws Exception {

		model.addAttribute("supplierselect", supplierService.getSupplierPairs());
		
		return view();
	}

	public static Timestamp getDefaultTimestamp(){
		return getDateOnly(getTimestamp(1900, Calendar.JANUARY, 1));
	}
		
	public static Timestamp getDateOnly(Timestamp timestamp){
		Date datetime = new Date(timestamp.getTime());
		return new Timestamp(DateUtils.truncate(datetime, Calendar.DATE).getTime());
	}
	
	public static Timestamp getTimestamp(int year, int month, int date){
		Calendar c = new GregorianCalendar(year, month, date);
		return new Timestamp(c.getTimeInMillis());
	}
	
	
	@RequestMapping(value=APTtMapping.APTF004_SEARCH_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getGrid(@RequestBody ACFgRequestParameters param) throws Exception {

		search.setConnection(getConnection("ARCDB"));
		search.setValues(param);
		search.setFocus(payment_form_no);
		System.out.println("search grid ");
		
		return getResponseParameters().set("grid_payment_request", search.getGridResult());
	}  		

	@RequestMapping(value=APTtMapping.APTF004_GET_FORM_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getForm(@RequestBody ACFgRequestParameters param) throws Exception {
		
		ACFgResponseParameters resParam = this.getResponseParameters();		
		this.getPayment(param.getRequestParameter("grid_payment_request"));

		return resParam;
	}

	@RequestMapping(value=APTtMapping.APTF004_GET_PAYMENT_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getPayment(@RequestBody ACFgRequestParameters reqparam) throws Exception {

		search.setConnection(getConnection("ARCDB"));
		search.setValues(reqparam);
		search.setFocus(payment_form_no);
		
		ACFmGridResult grid = search.getGridResult();

		return this.getResponseParameters().set("grid_payment_request", grid);
	}	
	
	@ACFgTransaction
	@RequestMapping(value=APTtMapping.APTF004_SAVE_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters save(@RequestBody ACFgRequestParameters param) throws Exception {

        final List<ARCmPaymentRequest> amendments = param.getList("payment_request", ARCmPaymentRequest.class);
        
        ARCmPaymentRequest lastItem = paymentRequestDao.saveItems(amendments);
        
        return new ACFgResponseParameters();

     }
	

    @RequestMapping(value=APTtMapping.APTF004_GET_SUPPLIER_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getSupplier(@RequestBody ACFgRequestParameters param) throws Exception {
 
        String supplier_code = param.get("supplier_code", String.class);
        
        getResponseParameters().put("supplier_desc", supplierService.getSupplierDesc(supplier_code));
        return getResponseParameters();
    }

}