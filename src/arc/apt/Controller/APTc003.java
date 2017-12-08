package arc.apt.Controller;

import java.math.BigDecimal;
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
import arc.apf.Service.ARCsSectionLabour;
import arc.apf.Dao.ARCoLabourConsumption;
import arc.apf.Model.ARCmLabourConsumption;
import arc.apf.Service.ARCsLabourConsumptionDetails;
import arc.apf.Dao.ARCoLabourConsumptionDetails;
import arc.apf.Model.ARCmLabourConsumptionDetails;
import arc.apf.Service.ARCsLabourType;
import arc.apf.Dao.ARCoLabourType;
import arc.apf.Model.ARCmLabourType;
import arc.apf.Service.ARCsSection;
import arc.apf.Dao.ARCoSection;
import arc.apf.Model.ARCmSection;
import arc.apf.Dao.ARCoBusinessPlatform;
import arc.apf.Model.ARCmBusinessPlatform;
import arc.apf.Dao.ARCoProgrammeMaster;
import arc.apf.Model.ARCmProgrammeMaster;
import arc.apf.Service.ARCsProgrammeMaster;
import arc.apt.Static.APTtGlobal;
import arc.apt.Static.APTtMapping;

@Controller
@Scope("session")
@ACFgFunction(id="APTF003")
@RequestMapping(value=APTtMapping.APTF003)
public class APTc003 extends ACFaAppController {

	@Autowired ARCoBusinessPlatform  businessPlatformDao;
	@Autowired ARCoProgrammeMaster   programmeMasterDao;
	@Autowired ARCsProgrammeMaster   programmeMasterService;	
	@Autowired ARCoLabourConsumption labourConsumptionDao;
	
	@Autowired ARCoLabourConsumptionDetails labourConsumptionDetailsDao;
	@Autowired ARCsLabourConsumptionDetails labourConsumptionDetailsService;
	@Autowired ARCoLabourType        labourTypeDao;
	@Autowired ARCsLabourType        labourTypeService;
	@Autowired ARCoSection           sectionDao;
	@Autowired ARCsSection           sectionService;
	@Autowired ARCsSectionLabour     sectionLabourService;	

	
	@ACFgAuditKey Timestamp process_date;	
	@ACFgAuditKey String programme_no;	
	@ACFgAuditKey String from_episode_no;	
	@ACFgAuditKey String to_episode_no;	
	@ACFgAuditKey String labour_type;
	
	String section_id = APTtGlobal.APT_SECTION_ID;
	
	Search search = new Search();
	SearchConsumeDtl searchConsumeDtl = new SearchConsumeDtl();
	
	private class Search extends ACFgSearch {
		public Search() {
			super();
						
			setCustomSQL("select * from (select t1.process_date as process_date, t1.section_id as section_id, t1.programme_no as programme_no,  " +
			         "t2.programme_name as programme_name, t2.chinese_programme_name as chinese_programme_name, " +
					 "t1.from_episode_no as from_episode_no, t1.to_episode_no as to_episode_no, " +
			         "t2.business_platform as business_platform, t2.department as department, " +
					 "t1.input_date as input_date " +
	                 "from arc_labour_consumption t1, arc_programme_master t2 " +
	                 "where t1.programme_no = t2.programme_no " +
	                 "  and t1.section_id = '"+APTtGlobal.APT_SECTION_ID+"')");			
            setKey("process_date","section_id","programme_no","from_episode_no","to_episode_no");	
            			
			addRule(new ACFdSQLRule("programme_no", RuleCondition.EQ,null, RuleCase.Insensitive));		
			addRule(new ACFdSQLRule("programme_name", RuleCondition._LIKE_,null, RuleCase.Insensitive));	
			addRule(new ACFdSQLRule("chinese_programme_name", RuleCondition._LIKE_,null, RuleCase.Insensitive));	

		}

        @Override
        public Search setValues(ACFgRequestParameters param) throws Exception { //use the search class to setup an object
            super.setValues(param);// param is a object, "Search" 's mother class passed
                if(!param.isEmptyOrNull("process_date")) {
                wheres.and("process_date", ACFdSQLRule.RuleCondition.EQ, param.get("process_date", Timestamp.class));
                }
 
            return this;
		}				
		
	}

	private class SearchConsumeDtl extends ACFgSearch {
		public SearchConsumeDtl() {
			super();
			setModel(ARCmLabourConsumptionDetails.class);
			
			addRule(new ACFdSQLRule("process_date", RuleCondition.EQ, Timestamp.class));
			addRule(new ACFdSQLRule("section_id", RuleCondition.EQ, null, RuleCase.Insensitive));
			addRule(new ACFdSQLRule("programme_no", RuleCondition.EQ, null, RuleCase.Insensitive));
			addRule(new ACFdSQLRule("from_episode_no", RuleCondition.EQ, null, RuleCase.Insensitive));
			addRule(new ACFdSQLRule("to_episode_no", RuleCondition.EQ, null, RuleCase.Insensitive));
		}
	}

	
	@RequestMapping(value=APTtMapping.APTF003_MAIN, method=RequestMethod.GET)
	public String main(ModelMap model) throws Exception {
		
		model.addAttribute("labourselect", labourTypeService.getAllEffLabourTypebySection(section_id));
	    //model.addAttribute("SubSectionselect", sectionService.getAllSubSection(section_id)); 
		
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
	
	
	@RequestMapping(value=APTtMapping.APTF003_SEARCH_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getGrid(@RequestBody ACFgRequestParameters param) throws Exception {

		search.setConnection(getConnection("ARCDB"));
		search.setValues(param);
		search.setFocus(process_date,section_id,programme_no,from_episode_no,to_episode_no);

		return new ACFgResponseParameters().set("grid_browse", search.getGridResult());
	}
  		
	@RequestMapping(value=APTtMapping.APTF003_GET_FORM_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getForm(@RequestBody ACFgRequestParameters param) throws Exception {
		
		process_date = param.get("process_date", Timestamp.class);
		programme_no = param.get("programme_no", String.class);
		from_episode_no = param.get("from_episode_no", String.class);
		to_episode_no = param.get("to_episode_no", String.class);
		section_id = param.get("section_id", String.class);
		
		getConsumeDtl(param);
		
		return getResponseParameters().set("frm_main", labourConsumptionDao.selectItem(process_date, section_id, programme_no, from_episode_no, to_episode_no));
	}

	@RequestMapping(value=APTtMapping.APTF003_GET_CONSUME_DTL_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters getConsumeDtl(@RequestBody ACFgRequestParameters param) throws Exception {

		param.put("section_id", section_id);
		param.put("process_date", param.get("process_date", Timestamp.class));
		
		searchConsumeDtl.setConnection(getConnection("ARCDB"));
		searchConsumeDtl.setValues(param);

		return getResponseParameters().set("grid_consume_dtl", searchConsumeDtl.getGridResult());

	}	
	
	@ACFgTransaction
	@RequestMapping(value=APTtMapping.APTF003_SAVE_AJAX, method=RequestMethod.POST)
	@ResponseBody
	public ACFgResponseParameters save(@RequestBody ACFgRequestParameters param) throws Exception {
		List<ARCmLabourConsumption> Hdramendments = param.getList("form", ARCmLabourConsumption.class);
        final List<ARCmLabourConsumptionDetails> Dtlamendments = param.getList("consume_dtl", ARCmLabourConsumptionDetails.class);

        Timestamp defaultTimestamp = getDefaultTimestamp();
        
        ARCmLabourConsumption Hdramend = Hdramendments.get(0);

        if (Hdramend.cancel_date == null) Hdramend.cancel_date = defaultTimestamp;
        if (Hdramend.cut_off_date == null) Hdramend.cut_off_date = defaultTimestamp;

        final String chk_prog_no = Hdramend.programme_no;
        final Timestamp upd_process_date = Hdramend.process_date;
        
        ARCmLabourConsumption lastItem = labourConsumptionDao.saveItems(Hdramendments, new ACFiSQLAssWriteInterface<ARCmLabourConsumption>(){
        	
        	@Override
            public boolean insert(final ARCmLabourConsumption newItem, ACFdSQLAssInsert ass) throws Exception {
                
                ass.setAfterExecute(new ACFiCallback() {
                    @Override
                    public void callback() throws Exception {
                        if (Dtlamendments != null)
                            labourConsumptionDetailsDao.saveItems(Dtlamendments);                                                   
                    }
                });
                
                Timestamp cost1stInputDate = programmeMasterService.getCost1stInputDate(chk_prog_no);	
                
        		if (cost1stInputDate.equals(Timestamp.valueOf("1900-01-01 00:00:00.000"))){
        			ARCmProgrammeMaster before = programmeMasterDao.selectItem(chk_prog_no);
        			programmeMasterService.updateCost1stInputDate(before, upd_process_date);
        		}
                
                
                return false;
            }
        	
        	@Override
            public boolean update(final ARCmLabourConsumption oldItem, final ARCmLabourConsumption newItem, ACFdSQLAssUpdate ass) throws Exception {
               
                 ass.setAfterExecute(new ACFiCallback() {
                     @Override
                     public void callback() throws Exception {
                         if (Dtlamendments != null)
                             labourConsumptionDetailsDao.saveItems(Dtlamendments);                                                   
                     }
                 });
                 return false;
            }
        	
        	@Override
            public boolean delete(ARCmLabourConsumption oldItem, ACFdSQLAssDelete ass) throws Exception {
               
                return false;
            }
        	
        	
        });
        
        return new ACFgResponseParameters();

     }
	
    @RequestMapping(value=APTtMapping.APTF003_GET_ARC_PROGRAMME_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getARCProgramme(@RequestBody ACFgRequestParameters param) throws Exception {
        ACFgResponseParameters resParam = new ACFgResponseParameters();
        
        programme_no = param.get("programme_no", String.class);

        //BigDecimal pgm_num = programme_no.equals("") ? null : new BigDecimal(programme_no);
        
        ARCmProgrammeMaster pgm = programmeMasterDao.selectItem(programme_no);

        if (pgm != null){
        String busi_platform = pgm.business_platform;
        String dept          = pgm.department;

	    ARCmBusinessPlatform busi_desc = businessPlatformDao.selectItem(busi_platform,"00");
	    ARCmBusinessPlatform dept_desc = businessPlatformDao.selectItem(busi_platform, dept);
        
        resParam.set("pgm", pgm);
        resParam.set("busi_desc", busi_desc);
        resParam.set("dept_desc", dept_desc);}
        
        return resParam;
    }
	
    @RequestMapping(value=APTtMapping.APTF003_GET_LABOUR_TYPE_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getLabourType(@RequestBody ACFgRequestParameters param) throws Exception {
    	
    	System.out.println("bef apt get labour type");
    	Timestamp inputdate = getDefaultTimestamp();  
        if(param.get("input_date")!="")
           inputdate = param.get("input_date", Timestamp.class);	
        System.out.println(param.get("labour_type", String.class)+ " " + inputdate);
        //labour_type = param.get("labour_type", String.class).substring(0,2);
        
        getResponseParameters().put("hourly_rate", labourTypeService.getEffHourlyRatebyLabour(param.get("labour_type", String.class), inputdate));
        getResponseParameters().put("sub_section", sectionLabourService.getLabourSubSection(param.get("labour_type", String.class), inputdate));
        return getResponseParameters();
    }

    @RequestMapping(value=APTtMapping.APTF003_GET_SUB_SECTION_AJAX, method=RequestMethod.POST)
    @ResponseBody
    public ACFgResponseParameters getSubSection(@RequestBody ACFgRequestParameters param) throws Exception {
    	
        Timestamp inputdate = param.get("input_date", Timestamp.class);   	
        
        getResponseParameters().put("sub_section", sectionLabourService.getLabourSubSection(param.get("labour_type", String.class), inputdate));
        return getResponseParameters();
    }
}