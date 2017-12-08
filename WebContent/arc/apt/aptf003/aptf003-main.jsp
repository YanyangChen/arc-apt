<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="acf" uri="/acf/tld/acf-taglib" %> 

<script>
	var programme_no = '${programme_no}';
	
	function episodeNo_OnValidate(sender, e){
		var epiFrom = $("#from_episode_no");
		var epiTo = $("#to_episode_no");	
		var epi = epiFrom.add(epiTo);
		var from = epiFrom.getValue();
		var to = epiTo.getValue();
		if($.isNumeric(from) && $.isNumeric(to)){
			if(Number(from) > Number(to))
				$(sender).setError(ACF.getQtipHint("ACF068V"), "ValueRange");
			else epi.setError(null, "ValueRange");
		}else epi.setError(null, "ValueRange");
	}
		
	function jobDates_OnValidate(sender, e){

		var jobStart = $("#from_job_date");
		var jobEnd = $("#to_job_date");
		var startDate = moment(parseInt(jobStart.getValue()));
		var endDate = moment(parseInt(jobEnd.getValue()));
		if(startDate.isValid() && endDate.isValid()){
			if(startDate.diff(endDate, "days") > 0)
				$(sender).setError(ACF.getQtipHint('ACF069V'), "DateRange");
			else jobStart.add(jobEnd).setError(null, "DateRange");
		}else jobStart.add(jobEnd).setError(null, "DateRange");
	}
</script>	
<div class="col-md-12 nopadding">
	<acf:Region id="reg_search" title="SEARCH" type="search">
		<acf:RegionAction>
			<a href="#" onClick="$(this).parents('.widget-box').pForm$clear();">Clear</a>
		</acf:RegionAction>
		
		<form id="frm_search" class="form-horizontal" data-role="search" >
	    	<div class="form-group">
	      		<div class="col-md-2">
	      			<label for=s_process_date style="display:block">Date</label>
	      			<acf:DateTimePicker id="s_process_date" name="process_date" pickTime="false"/>
	        	</div>

	      		<div class="col-md-2">
	      			<label for=s_programme_no style="display:block">Programme No.</label>
	      			<acf:TextBox id="s_programme_no" name="programme_no" button="fa-search" maxlength="9" allowKey="[tT0-9]" forceCase="upper" format="(T[0-9]{8}|[0-9]{1,9})"> 
	      				<acf:Bind target="button" on="click"><script>
	      					programme_no = null;
		   		    		Dialog.create()
								.setCaption("Search")
								.setWidth(1000)
								.addDismissButton("OK", function(){
									if ($.type(programme_no) == "string"){
										$("#frm_search #s_programme_no").setValue(programme_no);
										programme_no = "";
									}
								})
								.setResultCallback(function(result) {
									programme_no = result.programme_no;
								})
								.showUrl("../../apf/apff011/apff011-search-arc-prog");
	   					</script></acf:Bind>
	      			</acf:TextBox>
	      		</div>

	       		<div class="col-md-3">
	      			<label for=s_programme_name style="display:block">English Prog. Name</label>
	      			<acf:TextBox id="s_programme_name" name="programme_name" maxlength = "60"/>
	        	</div>
	        	
	        	<div class="col-md-3">
	      			<label for=s_chinese_programme_name style="display:block">Chinese Prog. Name</label>
	      			<acf:TextBox id="s_chinese_programme_name" name="chinese_programme_name" maxlength = "60"/>
	        	</div>

	    	</div>
	    	
		</form>
		
		
	</acf:Region>

</div>

<acf:Region id="reg_list" title="LABOUR CONSUMPTION LIST" type="form">
	<div class="widget-main no-padding">
		<div class="col-md-12 form-padding">
			<acf:Grid id="grid_browse" url="aptf003-search.ajax" readonly="true">
				<acf:Column type="date" name="process_date" caption="Date" width="100"></acf:Column>			
				<acf:Column name="programme_no" caption="Programme No." width="100"></acf:Column>
				<acf:Column name="programme_name" caption="Programme Name" width="300"></acf:Column>
				<acf:Column name="chinese_programme_name" caption="Chinese Programme Name" width="300"></acf:Column>
				<acf:Column name="from_episode_no" caption="Episode No. From" width="100"></acf:Column>
				<acf:Column name="to_episode_no" caption="Episode No. To" width="100"></acf:Column>
				<acf:Column name="business_platform" caption="Business Platform" width="100"></acf:Column>
				<acf:Column name="department" caption="Prog. Nature/ Dept." width="100"></acf:Column>
				<acf:Column name="process_date" caption=" " hidden="true"></acf:Column>
				<acf:Column name="section_id" caption=" " hidden="true"></acf:Column>
			</acf:Grid>
	    </div>
	</div>
</acf:Region>


<form id="frm_main" class="form-horizontal" data-role="form" >

	<acf:Region id="reg_form" title="LABOUR CONSUMPTION MAINTENANCE OF TECHNICIAN">
		<div class="form-group">		

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="job_no">Date</label>
		 		<div class="col-md-2">		 		    
			   		<acf:DateTimePicker id="process_date" name="process_date" checkMandatory="true" pickTime="false"></acf:DateTimePicker> 
		 		</div>
		 		
		 		<label class="control-label col-md-2" for="adjustment_indicator">Adjustment</label>
      			<div class="col-md-1">
	      			<acf:CheckBox id="adjustment_indicator" name="adjustment_indicator" choice="Y,N"/>	
	      		</div>		 		
		 		
	 		</div>

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="programme_no">Programme No.</label>
		 		<div class="col-md-2">		 		    
	      			<acf:TextBox id="programme_no" name="programme_no" button="fa-search" maxlength="9" allowKey="[tT0-9]" forceCase="upper" format="(T[0-9]{8}|[0-9]{1,9})"> 
	      				<acf:Bind target="button" on="click"><script>
	      					programme_no = null;
	      				
		   		    		Dialog.create()
								.setCaption("Search")
								.setWidth(1000)
								.addDismissButton("OK", function(){
									if ($.type(programme_no) == "string"){
										$("#frm_main #programme_no").setValue(programme_no);
										programme_no = "";
									}
								})
								.setResultCallback(function(result) {
									programme_no = result.programme_no;
								})
								.showUrl("../../apf/apff011/apff011-search-arc-prog");
	   					</script></acf:Bind>
	   					
	   					<acf:Bind on="change"><script>
	   					programme_no = $(this).getValue();                  

   						if ($.trim(programme_no) != ""){ 
	   						$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "aptf003-get-arc-programme.ajax",
								data   : JSON.stringify({
									'programme_no'	: programme_no,
								
								}),
								success: function(data) {
								    if (data.pgm != null) {
								       $("#frm_main #programme_no").setError("", "APF002V");
								       $("#frm_main #programme_no").setError("", "APF003V");
								       $("#frm_main #transfer_status").setValue($.trim(data.pgm.transfer_status));
								    								    
								       $("#frm_main #programme_name").setValue($.trim(data.pgm.programme_name));
									   $("#frm_main #chinese_programme_name").setValue($.trim(data.pgm.chinese_programme_name));
									
									   if (data.busi_desc) {
								      		$("#frm_main #busi_description").setValue($.trim(data.busi_desc.description));
									   }
									   if (data.dept_desc) {
								     		$("#frm_main #dept_description").setValue($.trim(data.dept_desc.description));
									   }
									
									   if (data.pgm.transfer_status == 'I') {
											$("#frm_main #programme_no").setError(ACF.getQtipHint('APF003V'), "APF003V");
									   }	
									}	
									else {
										$("#frm_main #programme_name").setValue("");	
										$("#frm_main #chinese_programme_name").setValue("");
										$("#frm_main #busi_description").setValue("");
										$("#frm_main #dept_description").setValue("");
										$("#frm_main #programme_no").setError(ACF.getQtipHint('APF002V'), "APF002V");
									}								
									
								}
							});
   						}
					</script></acf:Bind>
	   					
	      			</acf:TextBox>	
		 		</div>
		 		<div class="col-md-6">		 		    
			   		<acf:TextBox id="programme_name" name="programme_name"></acf:TextBox> 
		 		</div>		 		
	 		</div>
	 		
			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-4" for="chinese_programme_name">Chinese Programme Name</label>
		 		<div class="col-md-6">		 		    
			   		<acf:TextBox id="chinese_programme_name" name="chinese_programme_name"></acf:TextBox> 
		 		</div>		 		
	 		</div>	 		

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="from_episode_no">Episode No. From</label>
		 		<div class="col-md-2">
			   		<acf:TextBox id="from_episode_no" name="from_episode_no" checkMandatory="true" maxlength="7">
			   			<acf:Bind on="validate"><script>episodeNo_OnValidate(this, e);</script></acf:Bind></acf:TextBox>
		 		</div>
		 		
		 		<label class="control-label col-md-1" for="to_episode_no">To</label>
		 		<div class="col-md-2">
			   		<acf:TextBox id="to_episode_no" name="to_episode_no" checkMandatory="true" maxlength="7">
			   			<acf:Bind on="validate"><script>episodeNo_OnValidate(this, e);</script></acf:Bind></acf:TextBox>
		 		</div>
	 		</div>

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="busi_description">Business Platform</label>
		 		<div class="col-md-4">		 		    
			   		<acf:TextBox id="busi_description" name="busi_description" editable="false"></acf:TextBox> 
		 		</div>
		 		
		 		<label class="control-label col-md-2" for="dept_description">Prog. Nature/ Dept.</label>
		 		<div class="col-md-4">		 		    
			   		<acf:TextBox id="dept_description" name="dept_description" editable="false"></acf:TextBox> 
		 		</div>
		 		
	 		</div>

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="from_job_date">Job Date from</label>
		 		<div class="col-md-2">
			   		<acf:DateTimePicker id="from_job_date" name="from_job_date" checkMandatory="true" pickTime="false">
			   			<acf:Bind on="validate"><script>jobDates_OnValidate(this, e);</script></acf:Bind></acf:DateTimePicker> 
		 		</div>
		 		<label class="control-label col-md-1" for="to_job_date">To</label>
		 		<div class="col-md-2">
			   		<acf:DateTimePicker id="to_job_date" name="to_job_date" checkMandatory="true" pickTime="false">
			   			<acf:Bind on="validate"><script>jobDates_OnValidate(this, e);</script></acf:Bind></acf:DateTimePicker> 
		 		</div>
		 		
	 		</div>


			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="job_description">Job Description</label>
		 		<div class="col-md-6">
			   		<acf:TextBox id="job_description" name="job_description" maxlength = "60" checkMandatory="true"></acf:TextBox> 
		 		</div>
	 		</div>
	 		
	 		
			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="cancel_indicator">Cancel:</label>
      			<div class="col-md-1">
	      			<acf:CheckBox id="cancel_indicator" name="cancel_indicator" choice="Y,N">	
	      				<acf:Bind on="click"><script>
	      					if ($(this).getValue() == 'N') {
 		      					$("#frm_main #cancel_by").setValue("      ");
 		      					$("#frm_main #cancel_date").setValue(null);
      						}
      						else {
      							$("#frm_main #cancel_by").setValue($("#frm_main #modified_by").getValue());
      							$("#frm_main #cancel_date").setValue(moment());
      						}
      				</script></acf:Bind></acf:CheckBox>	  	      			
	      		</div>
	      		
      			<label class="control-label col-md-1" for="cancel_by">Cancelled By:</label>
      			<div class="col-md-2">         
      				<acf:TextBox id="cancel_by" name="cancel_by" maxlength="30" />	
			 	</div>
			 	
			 	<label class="control-label col-md-1" for="cancel_date">Cancelled Date :</label>
				<div class="col-md-2">         
      				<acf:DateTimePicker id="cancel_date" name="cancel_date" pickTime="false" useDefValIfEmpty="true"></acf:DateTimePicker>
			 	</div>
			 	
	 		</div>	 		

			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="remarks">Remarks</label>
		 		<div class="col-md-6">		 		    
			   		<acf:TextBox id="remarks" name="remarks" checkMandatory="false" maxlength="60"></acf:TextBox> 
		 		</div>
	 		</div>
	
			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="input_date">Input Date</label>
		 		<div class="col-md-2">		 		    
			   		<acf:DateTimePicker id="input_date" name="input_date" checkMandatory="true" pickTime="false"/>
		 		</div>
		 		<label class="control-label col-md-1" for="cut_off_date">Cut-off Date</label>
		 		<div class="col-md-2">		 		    
			   		<acf:DateTimePicker id="cut_off_date" name="cut_off_date" checkMandatory="false" pickTime="false" useDefValIfEmpty="true"></acf:DateTimePicker>
		 		</div>
		 		
	 		</div>
	 		
		</div>

		<div class="hidden">
			<input id="section_id" name="section_id" value="07"/>
			<acf:TextBox id="transfer_status" name="transfer_status"></acf:TextBox>
 		</div>


	</acf:Region>

 	<acf:Region id="consumption_details" title="LABOUR CONSUMPTION DETAILS" type="form">	
		<label class="control-label col-md-1" for="grid_consume_dtl"></label>		
		<div class="col-md-12 form-padding">			
			<acf:Grid id="grid_consume_dtl" url="aptf003-get-consume-dtl.ajax" autoLoad="false" addable="true" deletable="true" editable="true" rowNum="9999" multiLineHeader="true">
				<acf:Column name="labour_type" caption="Labour Type" width="70" type="select" editable="true" readonlyIfOld="true" checkMandatory="true" checkValidOption="true" initData="${labourselect}">
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
							var input_date = $("#frm_main #input_date").getValue();
							var labour_type = newData.labour_type;
							var seq_no = newData.sequence_no;
                			console.log("get labour type " + input_date + " " + labour_type );
							$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "aptf003-get-labour-type.ajax",
								data   : JSON.stringify({
								    'input_date'    : input_date,
									'labour_type'	: labour_type,
									'sequence_no'   : seq_no
								}),
								success: function(data) {
								if (data.hourly_rate != null) {
										$("#grid_consume_dtl").setRowData(id, {hourly_rate: data.hourly_rate, sub_section_id: data.sub_section});								
									}
									else {
									    console.log("hourly rate = null");
									}
								}
							});
						}
				</script></acf:Bind></acf:Column>
				
				<acf:Column name="sub_section_id" caption="Sub. Section ID." width="50" editable="false" ></acf:Column>			
				<acf:Column name="no_of_hours" caption="No. of Hour" type="number" width="30" editable="true" checkMandatory="true">
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
						var unitcost = $("#grid_consume_dtl").getRowData(id).hourly_rate;
						var ttl = unitcost * newValue;
						console.log("update amt " + unitcost + " x " + newValue + " = " + ttl);
						$("#grid_consume_dtl").setRowData(id, {hourly_rate:unitcost, ttl_hour_rate:ttl});
					}
					</script></acf:Bind>
					<acf:Bind target="textBox" on="change"><script>
							setTimeout(function(){
							calculateAmount();
							}, 20);
					</script></acf:Bind>
					</acf:Column>			
				
				<acf:Column name="hourly_rate" caption="Hour Rate" width="30" editable="false" align="right" decimalPlaces="2"></acf:Column>
				<acf:Column name="ttl_hour_rate" caption="Amount($)" width="30" type="number" align="right" useNumberFormat="true" decimalPlaces="2"></acf:Column>
				<acf:Column name="process_date" caption="" hidden = "true"></acf:Column>
				<acf:Column name="section_id" caption="" hidden = "true"></acf:Column>
				<acf:Column name="programme_no" caption="" hidden = "true"></acf:Column>
				<acf:Column name="from_episode_no" caption="" hidden = "true"></acf:Column>
				<acf:Column name="to_episode_no" caption="" hidden = "true"></acf:Column>
				<acf:Column name="sequence_no" caption="" hidden = "true"></acf:Column>
				<acf:Column name="created_at" caption="" hidden="true"></acf:Column>
				<acf:Column name="created_by" caption="" hidden="true"></acf:Column>
				<acf:Column name="modified_at" caption="" hidden="true"></acf:Column>
							
			</acf:Grid>
			
			<div class="col-xs-12" style="height:20px"></div>
			
	    </div>
	    
	    <div class="col-xs-12 form-padding oneline">
	    	<div class="col-md-8">
      		</div>	
     		<label class="control-label col-md-1" for="total_hour_amount">Total Amount</label>
      		<div class="col-md-2">
      			<acf:TextBox id="total_hour_amount" name="total_hour_amount" readonly="true" align="right" useNumberFormat="true" decimalPlaces="2"  useDefValIfEmpty="true" DefVal="0">
      			    <acf:Bind on="change"><script>
      					$(this).setValue($("#grid_consume_dtl").pGrid$getTotalOfColumn("ttl_hour_rate"));
      				</script></acf:Bind>
	 			    <acf:Bind on="validate"><script>
      					$(this).setValue($("#grid_consume_dtl").pGrid$getTotalOfColumn("ttl_hour_rate"));
      				</script></acf:Bind>      			
      			</acf:TextBox>
        	</div>	        	
    	</div>
    	
	</acf:Region>    	
		
		
	<acf:Region id="reg_stat" title="UPDATE STATISTICS">
		<div class="col-xs-12 form-padding">
     		<label class="control-label col-md-2" for="modified_at">Modified At:</label>
      		<div class="col-md-4">          
        		<acf:DateTime id="modified_at" name="modified_at" readonly="true" useSeconds="true"/>  	
        	</div>
     		<label class="control-label col-md-2" for="created_at">Created At:</label>
      		<div class="col-md-4"> 
      			<acf:DateTime id="created_at" name="created_at" readonly="true" useSeconds="true"/>           
      		</div>
    	</div>
    	<div class="col-xs-12 form-padding">
     		<label class="control-label col-md-2" for="modified_by">Modified By:</label>
      		<div class="col-md-4">          
        		<acf:TextBox id="modified_by" name="modified_by" readonly="true"/>  	
        	</div>
     		<label class="control-label col-md-2" for="created_by">Created By:</label>
      		<div class="col-md-4"> 
      			<acf:TextBox id="created_by" name="created_by" readonly="true"/>           
      		</div>
    	</div>
    	<input type="hidden" id="allow_print" name="allow_print" value="1"/>

			    	     	     	  	
	</acf:Region>
		
	</form>

<script>

Controller.setOption({
	searchForm:$("#frm_search"),
	searchKey : "process_date,programme_no,programme_name,chinese_programme_name",
	
	browseGrid: $("#grid_browse"),
	browseKey: "process_date,section_id,programme_no,from_episode_no,to_episode_no", 

	initMode: "",
	recordForm: $("#frm_main"),
	recordKey: {
	    process_date: "$(process_date)",
	    section_id: "$(section_id)",
		programme_no: "${programme_no}",
		from_episode_no: "${from_episode_no}",
		to_episode_no: "${to_episode_no}",
	},
	getUrl: "aptf003-get-form.ajax",
	saveUrl: "aptf003-save.ajax",

	onClone: function() {
		$("#frm_main").pForm$enableAll();

		$("#grid_consume_dtl").pGrid$copyRecord();

	},

	onNew: function(){
		$("#frm_main").pForm$clear();
		$("#frm_main").pForm$enableAll();
		
		$("#grid_consume_dtl").pGrid$clear();
		$("#total_hour_amount").setValue(" ");
	},

	onLoadSuccess: function(data)
	{
	getSubSection();
	calculateAmount();
	$("#total_hour_amount").setValue($("#grid_consume_dtl").pGrid$getSumOfColumn("ttl_hour_rate"));
	},

	getSaveData: function() {
		
		$("#grid_consume_dtl").pGrid$setHiddenValueForAllRecords("process_date", $("#frm_main #process_date").getValue());
		$("#grid_consume_dtl").pGrid$setHiddenValueForAllRecords("section_id", "07");
		$("#grid_consume_dtl").pGrid$setHiddenValueForAllRecords("programme_no", $("#frm_main #programme_no").getValue());
		$("#grid_consume_dtl").pGrid$setHiddenValueForAllRecords("from_episode_no", $("#frm_main #from_episode_no").getValue());
		$("#grid_consume_dtl").pGrid$setHiddenValueForAllRecords("to_episode_no", $("#frm_main #to_episode_no").getValue());
		
		
		return JSON.stringify({
			'form' : Controller.opt.recordForm.pForm$getModifiedRecord( Action.getMode() ),
			'consume_dtl' : $("#grid_consume_dtl").pGrid$getModifiedRecord(), 
		});
	},	

	onSaveSuccessCallback: function(data, mode) {
		if (mode == "amend" || mode == "clone") {
			$("#grid_consume_dtl").pGrid$clear();
		}
	},

}).executeSearchBrowserForm();

$(document).on('new', function() {
	$("#frm_main #programme_name").disable();
	$("#frm_main #chinese_programme_name").disable();
	$("#frm_main #busi_description").disable();
	$("#frm_main #dept_description").disable();
	$("#frm_main #cancel_by").disable();
	$("#frm_main #cancel_date").disable();
	$("#frm_main #cut_off_date").disable();
});

$(document).on('clone', function() {
	$("#frm_main #programme_name").disable();
	$("#frm_main #chinese_programme_name").disable();
	$("#frm_main #busi_description").disable();
	$("#frm_main #dept_description").disable();
	$("#frm_main #cancel_by").disable();
	$("#frm_main #cancel_date").disable();
	$("#frm_main #cut_off_date").disable();
	
	$("#frm_main #cancel_indicator").setValue("");
	$("#frm_main #cancel_by").setValue("");
 	$("#frm_main #cancel_date").setValue(null);
 	$("#frm_main #cut_off_date").setValue(null);
	
	if ($("#frm_main #transfer_status").getValue() == 'I') {
		$("#frm_main #programme_no").setError(ACF.getQtipHint('APF003V'), "APF003V");
	}  		
});
$(document).on('amend', function() {
	$("#frm_main #programme_name").disable();
	$("#frm_main #chinese_programme_name").disable();
	$("#frm_main #busi_description").disable();
	$("#frm_main #dept_description").disable();
	$("#frm_main #cancel_by").disable();
	$("#frm_main #cancel_date").disable();
	$("#frm_main #cut_off_date").disable();
	
	if ($("#frm_main #cancel_indicator").getValue() == 'Y') Action.view();
	if ($("#frm_main #transfer_status").getValue() == 'I') {
		Action.view();
		msg = "Amend consumption for inactive programme " + $("#frm_main #programme_no").getValue() + " is not allowed.";
        Dialog.create($("#dialog1_arc"))
        .setCaption("MESSAGE")
        .addDismissButton("Close")
        .showHtml(msg);
	}                                      	
	checkMonthEnd();
});

function getSubSection(){
    var input_date = $("#frm_main #input_date").getValue();
	$.each($("#grid_consume_dtl").pGrid$getRecord(), function(id, rec){
		console.log(id + " subsection ~ " + rec.labour_type + " " + rec.sequence_no);
		if(rec.sequence_no) {

				$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "aptf003-get-sub-section.ajax",
								data   : JSON.stringify({
								    'input_date'    : input_date,
									'labour_type'	: rec.labour_type,
									'sequence_no'   : rec.sequence_no
								}),
								success: function(data) {
								if (data.sub_section != null) {
										$("#grid_consume_dtl").setRowData(id, {sub_section_id: data.sub_section});								
									}
								else{
									console.log("sub section : null");
									}
								}
							});		

		}
	});

}

function calculateAmount(){
	$.each($("#grid_consume_dtl").pGrid$getRecord(), function(id, rec){
		console.log(id + " calculate ~ " + rec.no_of_hours + " " + rec.hourly_rate);
		if(rec.no_of_hours) {
			$("#grid_consume_dtl").setRowData(id, {
				ttl_hour_rate: rec.no_of_hours * rec.hourly_rate
			});
		}
	});
}


function checkMonthEnd(){
	var cutoffEnd = $("#frm_main #cut_off_date");
	var endDate = moment(parseInt(cutoffEnd.getValue()));

	var responseDate = moment(endDate).format('YYYY-MM-DD');
	console.log("chk month end " + responseDate);
	if (responseDate != '1900-01-01') Action.view();
	
}

</script>