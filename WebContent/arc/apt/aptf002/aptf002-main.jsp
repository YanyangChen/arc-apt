<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="acf" uri="/acf/tld/acf-taglib" %> 

<script>
	var programme_no = '${programme_no}';
	function episodeNo_OnValidate(newValue, oldValue, newData, oldData, id){
		var from = newData.from_episode_no;
		var to = newData.to_episode_no;
		if($.isNumeric(from) && $.isNumeric(to)){
			if(Number(from) > Number(to))
				return ACF.getQtipHint("ACF068V");
			else return "";
		}else return ACF.getQtipHint("ACF051V");
	}

</script>

<div class="col-md-12 nopadding">
	<acf:Region id="reg_search" title="SEARCH" type="search">
		<acf:RegionAction>
			<a href="#" onClick="$(this).parents('.widget-box').pForm$clear();">Clear</a>
		</acf:RegionAction>
		
		<form id="frm_search" class="form-horizontal" data-role="search" >
			<div class="form-group">
	    		<div class="col-lg-2 col-md-6 col-sm-6 col-xs-12">
	      			<label for=payment_form_no style="display:block">PAT/AT FORM NO.</label>
	      			<acf:ComboBox id="s_payment_form_no" name="payment_form_no">
	      			<acf:Bind on="initData">
	      				<script>
	 						$(this).acfComboBox("init", ${searchpayformno} );
	 					</script>
	 				</acf:Bind>
	      			</acf:ComboBox>
	        	</div>
	        	
	        	<div class="col-lg-2 col-md-6 col-sm-6 col-xs-12">
	      			<label for=s_request_date style="display:block">REQUEST DATE</label>
	      			<acf:DateTimePicker id="s_request_date" name="request_date" pickTime="false">
	      			</acf:DateTimePicker>
	        	</div>
	    	</div>
		</form>
	</acf:Region>


	
 	<acf:Region id="reg_div_list" type="list" title="PAYMENT REQUEST LIST">
   		<acf:RegionAction> 
			<a href="javascript:$('#grid_browse').pGrid$prevRecord();">Previous</a>
			&nbsp;
			<a href="javascript:$('#grid_browse').pGrid$nextRecord();">Next</a>
		</acf:RegionAction>
		<div class="col-xs-12">
			<acf:Grid id="grid_browse" url="aptf002-search.ajax" readonly="true" autoLoad="false">
				<acf:Column name="section_id" caption="section id." width="100"></acf:Column>

				<acf:Column name="payment_form_no" caption="PAT/AT Form No." width="100"></acf:Column>
				<acf:Column name="request_date" caption="Request Date" type="date" width="100" ></acf:Column>
				<acf:Column name="supplier_name" caption="Supplier Name" width="200"></acf:Column>
				<acf:Column name="supplier_code" caption="Supplier Code" width="100"></acf:Column>
			   	<acf:Column name="despatch_date" caption="Despatch Date" width="100" type="date"></acf:Column>
			   	<acf:Column name="remarks" caption="Remarks" width="200"></acf:Column>
				<acf:Column name="request_department" caption="Request Dept" width="200"></acf:Column>

			</acf:Grid>
	    </div>
 	</acf:Region>
 	
</div>	
<!--   <acf:Region id="reg_form" title="PAYMENT REQUEST LIST">-->
	<form id="frm_main" class="form-horizontal" data-role="form" >
	
	<acf:Region id="reg_mod_main" title="PAYMENT REQUEST MAINTENANCE (CASH)" type="form">
	
		<div class="form-group">		
			<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="payment_form_no">PAT/AT Form No.:</label>
		 		<div class="col-md-2">
			   	      <acf:TextBox id="payment_form_no" name="payment_form_no" editable="false" multiple="false" maxlength="11" /> 
			    </div>
			   
			    <div class="col-md-2">
			   	      <acf:ButtonGroup id="form_id" name="form_id" type="radio" checkMandatory="true">
	      			 		<setting>
			    				<option id="form_id1" value="PAT" label="PAT" />
			    				<option id="form_id2" value="AT" label="AT" />
			    			</setting>
			    			<acf:Bind on="click"><script></script></acf:Bind>
	      		      </acf:ButtonGroup>  
			   	</div>
				<label class="control-label col-md-1" for="adjustment_indicator">Adjustment:</label>
      			<div class="col-md-1">
      			  	<acf:CheckBox id="adjustment_indicator" name="adjustment_indicator" choice="y,n"/>
      			</div>
     		
	 		</div>
	 		
	 		
	 		
	 		<div class="col-xs-12 form-padding oneline">
   				<label class="control-label col-md-2" for="request_date">Request Date:</label>
      			<div class="col-md-2">
      			<acf:DateTimePicker id="request_date" name="request_date" pickDate="true" pickTime="false" displayformat="YYYY/MM/DD" checkMandatory="false">
      			</acf:DateTimePicker>
			</div>
     		
		<!-- 	<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="section_id">Section Id.:</label>
		 		<div class="col-md-2">
			   		<acf:TextBox id="section_id" name="section_id" editable="false" multiple="false" maxlength="2" />
		 		</div>
	 		</div>

     	-->	
			<div class="hidden"> 	
  	 	<!--  	<div class="col-xs-12 form-padding oneline">  for testing, not hidden the column-->
     			<label class="control-label col-md-2" for="section_id">Section ID</label>
      			<div class="col-md-4">
      				<acf:TextBox id="section_id" name="section_id"/>
      			</div>
 			</div>     	
	 
	 		<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="request_department">From Department:</label>
		 		<div class="col-md-3">
			   		<acf:TextBox id="request_department" name="request_department" editable="true"  multiple="false" maxlength="30" />
		 		</div>
		 		
	     	    <label class="control-label col-md-1" for="spacing_purpose">                 </label>
		 		<label class="control-label col-md-1" for="dds_code">DDS:</label>
		 		<div class="col-md-1">
			   		<acf:TextBox id="dds_code" name="dds_code" editable="true" multiple="false" maxlength="4" />
		 		</div>
	 		</div>
		
			<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="supplier_code">Pay to Supplier Code:</label>
		 		<div class="col-md-2">
			   		<acf:ComboBox id="supplier_code" name="supplier_code" editable="true" multiple="false" format="^([A-Z]|[0-9]){4}$">
			   		<acf:Bind on="initData">
			   			<script>
	 					//	$(this).acfComboBox("init", ${getsuppliercode});
	 					</script>
	 				</acf:Bind>
			   		<acf:Bind on="change"><script>
   						supplier_code = $(this).getValue(); //this bloack is the same as onLoadSucess except $this value
   						
   						if (supplier_code == ""){
   							//$("#frm_main #supplier_desc").setValue("CASH A/C");	
   						}
   						else {					
	   						$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "${ctx}/arc/apt/aptf002/aptf002-apt-get-supplier-name.ajax",
								data   : JSON.stringify({
									'supplier_code'	: supplier_code,
								}),
								success: function(data) {
									if (data.supplier_name != null) {
										$("#frm_main #supplier_name").setValue(data.supplier_name);
									}
									else {
										//$("#frm_main #supplier_name").setValue("");
									}
								}
							});
   						}
					</script></acf:Bind>	
					</acf:ComboBox>
			   		
		 		</div>
				<div class="col-md-6">
			   			<acf:TextBox id="supplier_name" name="supplier_name" maxlength="60" /> 
				</div>
	 		</div>

	
			<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="purpose">Purpose: </label>
		 		<div class="col-md-6">
			   		<acf:TextBox id="payment_purpose" name="payment_purpose" editable="true" multiple="false" maxlength="60" />
		 		</div>
	 		</div>
		
			<div class="col-xs-12 form-padding oneline">
				<label class="control-label col-md-2" for="remarks">Remarks: </label>
		 		<div class="col-md-6">
			   		<acf:TextBox id="remarks" name="remarks" editable="true" multiple="false" maxlength="60" />
		 		</div>
	 		</div>
	
			<label class="control-label col-md-2" for="despatch_date">Despatch Date:</label>
      		<div class="col-md-2">         
      			<acf:DateTimePicker id="despatch_date" name="despatch_date" pickDate="true" pickTime="false" displayformat="YYYY/MM/DD" checkMandatory="false">
			   			<acf:Bind on="validate"><script>
			   				var ts = $(this).getValue();
			   				// check against with 1900/01/01 ("-2209017600000")
			   			    if (ts != "-2209017600000" && ts < $("#request_date").getValue()) { 
			   					//$(this).setError(ACF.getQtipHint("Earlier than request date!"), "EXE003");
			   					$(this).setError(ACF.getQtipHint("APT001E"), "APT001E");
			   					//ACF.getQtipHint("Earlier than start date!");
			   					//Alert.showError(ACF.getDialogMessage("ACFF004E"), callback);
			   				}
			   				else {
			   				if($(this).isError() == true)
			   					{
			   					$(this).disable();
			   					$(this).enable();
			   					// disable + enable = clearerror...
			   					}
			   				}
			   			</script></acf:Bind>
			 	</acf:DateTimePicker>
			 </div>
    		</div>
	 		
	
			<div class="col-xs-12 form-padding oneline">  	
				<label class="control-label col-md-2" for="printed_by">Printed by:</label>
		 		<div class="col-md-2">
			   		<acf:TextBox id="printed_by" name="printed_by" readonly="false"  /> 
		 		</div>
		 		
		 		<label class="control-label col-md-2" for="printed_at">Last Printed Date:</label>
		 		<div class="col-md-2">
      				<acf:DateTimePicker id="printed_at" name="printed_at" pickDate="true" pickTime="false" displayformat="YYYY/MM/DD" checkMandatory="false" readonly="false"/>
		 		</div>
		 		
		 		<label class="control-label col-md-2" for="no_of_times_printed">No. of Times Printed:</label>
		 		<div class="col-md-1">
			   		<acf:TextBox id="no_of_times_printed" name="no_of_times_printed" maxlength="1" readonly="true" /> 
		 		</div>
	 		</div>
	
			
     		<div class="col-xs-12 form-padding oneline">  	
     		    <label class="control-label col-md-2" for="input_date">Input Date:</label>		
	 	 	    <div class="col-md-2">    
      				<acf:DateTimePicker id="input_date" name="input_date" pickDate="true" pickTime="false" displayformat="YYYY/MM/DD" checkMandatory="false"/>
			    </div>
     			<label class="control-label col-md-2" for="cut_off_Date: ">Cut-off Date:</label>
	 			<div class="col-md-2">    
      				<acf:DateTimePicker id="cut_off_date" name="cut_off_date" pickDate="true" pickTime="false" displayformat="YYYY/MM/DD" readonly="false"  checkMandatory="false"/>
     			 <!-- <acf:TextBox id="cut_off_date" name="cut_off_date" editable="false" multiple="false" /> -->
				</div>
		    </div>
    </div>		
	
	</acf:Region>	
		
		
	<acf:Region id="payment_details" title="PAYMENT DETAILS" type="list">			
		<div class="col-md-12">
			<acf:Grid id="grid_paymentdetails" url="aptf002-get-paymentdetails-table.ajax" autoLoad="false" addable="true" deletable="true" editable="true" rowNum="9999" multiLineHeader="true">
				<acf:Column name="payment_form_no" caption="Payment Form No." width="50" editable="true" readonlyIfOld="true" checkMandatory="true" hidden="true" >
				</acf:Column>
				<acf:Column name="sequence_no" caption="Seq. No" width="30" editable="false"></acf:Column>
				<acf:Column name="programme_no" caption="Prog. No." width="70" editable="true" checkMandatory="true" type="textButton">
				<acf:Bind on='click' target="button"><script>
	   		    			programme_no = null;
		   		    		Dialog.create()
								.setCaption("Search")
								.setWidth(1000)
								.addDismissButton("OK", function(){
									if (typeof selectedResult != 'undefined' && selectedResult.programme_no){
									   var programme_no = selectedResult.programme_no
									   var programme_name = selectedResult.programme_name
									   var business_platform = selectedResult.business_platform
									   var department = selectedResult.department
									   var description = selectedResult.description
									   var id = $("#grid_paymentdetails").pGrid$getSelectedId();
									
								$.ajax({ //to get business platform desc 
									headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
									},
									async  : false,
									type   : "POST",
									url    : "${ctx}/arc/apt/apt-businessplatform-desc.ajax",
									data   : JSON.stringify({
									'programme_no'	: programme_no}),
								    
								    success: function(data) {
									if (data != null) {
										description = data.description;
									}
									else {
									}
									}
							   	});
									   
									$("#grid_paymentdetails").setRowData(id, {programme_no: programme_no, programme_name: programme_name, business_platform: business_platform, department: department, description: description});
									$("#grid_paymentdetails").pGrid$saveRecord(id);
									}
									
								})
								.setResultCallback(function(result) {
								    selectedResult = result;
									programme_no = result.programme_no;
								})
								.showUrl("../../apf/apff011/apff011-search-arc-prog");
	   			</script></acf:Bind>
	   			<acf:Bind target="textBox" on="change"><script>
	   					console.log("bbbb");
						if(input.newValue!=null && $.trim(input.newValue).length==9) {
							$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "${ctx}/arc/apt/apt-programme-fields.ajax",
								data   : JSON.stringify({
									'programme_no' : input.newValue
								}),
								success: function(data) {
									if (data != null) {
									        console.log("aaaaa" + data.programme_name + data.description);
											$("#grid_paymentdetails").setRowData(input.rowid, {programme_name: data.programme_name, business_platform: data.business_platform, department: data.department, description: data.description});
									}
									else {
										$("#grid_paymentdetails").setRowData(input.rowid, {programme_name: '', business_platform: '', department: '', descrption: ''});
									}
									$("#grid_paymentdetails").pGrid$saveRecord(input.rowid);
								}
							});
						}
						else {
							$("#grid_paymentdetails").setRowData(input.rowid, {programme_name: '', business_platform: '', department: '', descrption: ''});
							$("#grid_paymentdetails").pGrid$saveRecord(input.rowid);
						}
						
					</script></acf:Bind>	
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
					    var row = $("#grid_paymentdetails").getRowData(id);
				    	if(row.programme_name == null || row.programme_name == ""){
					    	return ACF.getQtipHint("APT002E");
					    }
				    }
					</script></acf:Bind>
	   			
	   			
				</acf:Column>
				

				<acf:Column name="programme_name" caption="Prog. Name" width="150" readonly="true"></acf:Column>
				<acf:Column name="from_episode_no" caption="Epi No. From" width="60" editable="true"  checkMandatory="true" maxlength="7">
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
						    return episodeNo_OnValidate(newValue, oldValue, newData, oldData, id);
				    	}
						</script>
					</acf:Bind>
				</acf:Column>
				<acf:Column name="to_episode_no"   caption="Epi No. To  " width="60" editable="true"  checkMandatory="true" maxlength="7">
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
						    return episodeNo_OnValidate(newValue, oldValue, newData, oldData, id);
				    	}
						</script>
					</acf:Bind>				
				</acf:Column>
				
				<acf:Column name="invoice_no" caption="Invoice No." width="80" editable="true"  multiple="false" maxlength="25"></acf:Column>
				<acf:Column name="sub_section_id" caption="Sub-section Id." width="80" editable="true"  maxlength="1" checkMandatory="true"  checkValidOption="true" type="select" initData="${subsectionidselect}" ></acf:Column>
				<acf:Column name="business_platform" caption="busi. platform No" width="30" editable="false" hidden="true" >
				</acf:Column>
				<acf:Column name="department" caption="Department No" width="30" editable="false" hidden="true" ></acf:Column>
				<acf:Column name="purchase_order_no" caption="PO No." width="70" editable="true" multiple="false" maxlength="9"></acf:Column>
  				<acf:Column name="particulars"   caption="Particulars" width="150" editable="true" maxlength="30"></acf:Column>
  				<acf:Column name="job_description"   caption="Job Description" width="150" editable="true" maxlength="30"></acf:Column>
  				<acf:Column name="account_allocation"   caption="A/C Alloc." width="100" editable="true" checkMandatory="true" checkValidOption="true" type="select" initData="${acallocselect}"  ></acf:Column>
  				<acf:Column name="business_platform"   caption="Busi. Platform" width="100" readonly="true" hidden="true"></acf:Column>
  				<acf:Column name="department"          caption="Department" width="100" readonly="true" hidden="true"></acf:Column>
  				<acf:Column name="payment_amount"   caption="Amount " width="100" align= "right" editable="true" checkMandatory="true" align="right">
					<acf:Bind on="validate"><script>
					function validation (newValue, oldValue, newData, oldData, id) {
					var row = $("#grid_paymentdetails").getRowData(id);
					if(!$.isNumeric(row.payment_amount) || Number(row.payment_amount) == 0){
						return ACF.getQtipHint("APT003E");
					}
					}
					</script>
					</acf:Bind>
				</acf:Column>
				<acf:Column name="include_in_weekly_reporting"   caption="Print Week" width="30" type="checkBox" editable="true" readonly="false"></acf:Column>
				<acf:Column name="include_in_monthly_reporting"  caption="Print Mth " width="30" type="checkBox" editable="true" readonly="false"></acf:Column>
				<acf:Column name="description"  caption="Busi. Platform " width="150" editable="false"></acf:Column>
	
				<!--<acf:Bind on="validate"><script>
				function validation (newValue, oldValue, newData, oldData, id) {
				var payamount = $("#grid_paymentdetails").getRowData(id).payment_amount;
				var ttl = ttl + payamount;
				$("#grid_payment_details").setRowData(id, {tl_payment:ttl});
				}
				</script></acf:Bind>-->
				<acf:Column name="modified_at" type="dateTime" caption="" hidden="true"></acf:Column>
				<acf:Column name="created_at" caption="" hidden="true"></acf:Column>
				<acf:Column name="created_by" caption="" hidden="true"></acf:Column>
				<acf:Column name="modified_by" caption="" hidden="true"></acf:Column>
				
			</acf:Grid>

	    </div>
	    <div class="col-md-12 form-padding oneline">
	    <div class="col-md-8"> </div>	
      		
     		<label class="control-label col-md-1" for="total_payment_amount">Total: </label>
      		<div class="col-md-1">
      			<acf:TextBox id="total_payment_amount" name="total_payment_amount" readonly="true" useNumberFormat="true" align="right"></acf:TextBox>
        	</div>	        	
    	</div>

	</acf:Region>
	

	
	<acf:Region id="reg_stat" title="UPDATE STATISTICS">
		<div class="col-xs-12 form-padding">
     		<label class="control-label col-md-2" for="modified_at">Modified At:</label>
      		<div class="col-md-2">          
        		<acf:DateTime id="modified_at" name="modified_at" readonly="true" useSeconds="true"/>  	
        	</div>
     		<label class="control-label col-md-2" for="created_at">Created At:</label>
      		<div class="col-md-2"> 
      			<acf:DateTime id="created_at" name="created_at" readonly="true" useSeconds="true"/>           
      		</div>
    	</div>
    	<div class="col-xs-12 form-padding">
     		<label class="control-label col-md-2" for="modified_by">Modified By:</label>
      		<div class="col-md-2">          
        		<acf:TextBox id="modified_by" name="modified_by" readonly="true"/>  	
        	</div>
     		<label class="control-label col-md-2" for="created_by">Created By:</label>
      		<div class="col-md-2"> 
      			<acf:TextBox id="created_by" name="created_by" readonly="true"/>           
      		</div>
    	</div>
    	
	</acf:Region>
		
	</form>
<!-- </acf:Region> -->

<script>
Controller.setOption({
	searchForm: $("#frm_search"),
	browseGrid: $("#grid_browse"),
	searchKey: "payment_form_no",
	browseKey: "payment_form_no",
	//searchForm: $("#frm_search"),
	//browseKey: "supplier code",
	
	
	//initMode: "${mode}",
	recordForm: $("#frm_main"),
	recordKey: 
	{
	payment_form_no : "${payment_form_no}",
	},
    getUrl: "aptf002-get-form.ajax",
	saveUrl: "aptf002-save.ajax",
	ready: function() { Action.setMode("search"); },
	
	onClone: function() {
		$("#frm_main").pForm$enableAll();
		$("#grid_paymentdetails").pGrid$copyRecord();

	},
	
	onNew: function(){
		$("#frm_main").pForm$clear();
		$("#frm_main").pForm$enableAll();
		
		$("#grid_paymentdetails").pGrid$clear();
		$("#total_payment_amount").setValue(" ");
	},
	onLoadSuccess: function(data)
	{
	// $("#total_payment_amount").setValue($("#grid_paymentdetails").pGrid$getSumOfColumn("payment_amount"));
	var s =$("#grid_paymentdetails").pGrid$getTotalOfColumn("payment_amount") ;
        s = Math.round(s*100)/100;
    $("#total_payment_amount").setValue(s);
	},
	
	getSaveData: function() {
	$("#grid_paymentdetails").pGrid$setHiddenValueForAllRecords("payment_form_no", $("#frm_main #payment_form_no").getValue());
	$("#grid_paymentdetails").pGrid$setHiddenValueForAllRecords("supplier_code", $("#frm_main #supplier_code").getValue());
	$("#grid_paymentdetails").pGrid$setHiddenValueForAllRecords("request_date", $("#frm_main #request_date").getValue());
		return JSON.stringify({
			'form' : Controller.opt.recordForm.pForm$getModifiedRecord( Action.getMode() ),
			'paymentdetails' : $("#grid_paymentdetails").pGrid$getModifiedRecord(), 
	
		});
	},
	
	onSaveSuccessCallback : function(data){
	var msg = "";
            if(data.action == 1){
              msg = "record " + data.new_form_no + " is created";
              Dialog.create($("#dialog1_arc"))
                                    .setCaption("ACKNOWLEDGEMENT")
                                    .addDismissButton("Close")
                                    .showHtml(msg);
            }
            if(data.action == 3){
              $("#grid_paymentdetails").pGrid$clear();
            }
 
	  },
	
}).executeSearchBrowserForm(); 

$(document).on('amend', function() {
	$("#frm_main #payment_form_no").disable();
	$("#frm_main #form_id").disable();
//	$("#frm_main #adjustment_indicator").disable();
	$("#frm_main #supplier_code").disable();
	$("#frm_main #supplier_name").disable();
	$("#frm_main #canceled_by").disable();
	$("#frm_main #printed_by").disable();
	$("#frm_main #printed_at").disable();
	$("#frm_main #no_of_times_printed").disable();
});

$(document).on('view', function() {
	$("#frm_main").pForm$disableAll();
});

$(document).on('new', function() {
	$('#grid_paymentdetails').pGrid$clear();
	$("#mod_main #payment_request_no").disable();
	$("#frm_main #payment_form_no").disable();	

	$("#frm_main #supplier_code").enable();
	$("#frm_main #supplier_code").setValue("CASH");
	$("#frm_main #supplier_name").disable();
	$("#frm_main #dds_code").enable();
	$("#frm_main #dds_code").setValue("2204");
	$("#frm_main #request_date").setValue(new Date());
    $("#frm_main #input_date").setValue(new Date());
	$("#frm_main #despatch_date").setValue(moment("1900-01-01"));
	$("#frm_main #request_department").enable();
	$("#frm_main #request_department").setValue("Production Admin.");
	$("#frm_main #payment_purpose").enable();
	$("#frm_main #payment_purpose").setValue("Art-props & Setting Expenses");
	$("#frm_main #printed_by").disable();
	$("#frm_main #printed_at").disable();
	$("#frm_main #printed_at").setValue(moment("1900-01-01"));
	$("#frm_main #cut_off_date").disable();
	$("#frm_main #cut_off_date").setValue(moment("1900-01-01"));
	$("#frm_main #no_of_times_printed").setValue(0);
	$("#frm_main #no_of_times_printed").disable();
	$("#frm_main #section_id").setValue("07");
	
});

$(document).on('clone', function() {
     $("#frm_main #payment_form_no").setValue(" ");
	 $("#frm_main #payment_form_no").disable();
	 $("#frm_main #supplier_code").enable();
     $("#frm_main #supplier_code").setValue("CASH");
 	 $("#frm_main #supplier_name").disable();
});

// $("#frm_main").pForm$setJsonData(${row});

Action.enable("save,cancel");
Action.amend();
</script>