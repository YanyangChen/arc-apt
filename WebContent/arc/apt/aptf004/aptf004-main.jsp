<%@ taglib prefix="core" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="acf" uri="/acf/tld/acf-taglib" %> 

<script>

	function formNo_OnValidate(sender, e){
		var startForm = $("#s_fr_form").getValue();
		var endForm = $("#s_to_form").getValue();	
		var startID = startForm.substr(0,2);
		var endID   = endForm.substr(0,2);
        if (startID != endID)
			$(sender).setError(ACF.getQtipHint("ACF056V"), "ValueRange");
			else {if (startForm > endForm) 
			$(sender).setError(ACF.getQtipHint("ACF068V"), "ValueRange");
			else $(sender).setError(null, "ValueRange");}			
	}
	
	function selectDates_OnValidate(sender, e){
		var selectStart = $("#s_select_fr_date");
		var selectEnd = $("#s_select_to_date");
		var startDate = moment(parseInt(selectStart.getValue()));
		var endDate = moment(parseInt(selectEnd.getValue()));
		if(startDate.isValid() && endDate.isValid()){
			if(startDate.diff(endDate, "days") > 0)
				$(sender).setError(ACF.getQtipHint('ACF069V'), "DateRange");
			else selectStart.add(selectEnd).setError(null, "DateRange");
		}else selectStart.add(selectEnd).setError(null, "DateRange");
	}
</script>	
<div class="col-md-12 nopadding">
	<acf:Region id="reg_search" title="SEARCH" type="search">
		<acf:RegionAction>
			<a href="#" onClick="$(this).parents('.widget-box').pForm$clear();">Clear</a>
		</acf:RegionAction>
		
		<form id="frm_search" class="form-horizontal" data-role="search" >
	    	<div class="form-group">

				<div class="hidden">
					<acf:TextBox id="section_id" name="section_id"/>
					<acf:DateTimePicker id="despatch_date" name="despatch_date"/>
 				</div>

	      		<div class="col-md-2">
	      			<label for=s_fr_form style="display:block">PAT/ AT Form No.     From</label>
	      			<acf:TextBox id="s_fr_form" name="fr_form_no" editable="true" maxlength = "11" forceCase="upper"></acf:TextBox>    			
	        	</div>

	      		<div class="col-md-2">
	      			<label for=s_to_form style="display:block">To</label>
	      			<acf:TextBox id="s_to_form" name="to_form_no" editable="true" maxlength = "11" forceCase="upper">
	      				<acf:Bind on="validate"><script>formNo_OnValidate(this, e);</script></acf:Bind></acf:TextBox>	      			
	        	</div>


	       		<div class="col-md-2">
	      			<label for=s_select_fr_date style="display:block">Start Date</label>
	      			<acf:DateTimePicker id="s_select_fr_date" name="select_fr_date" pickTime="false">
	      				<acf:Bind on="validate"><script>selectDates_OnValidate(this, e);</script></acf:Bind></acf:DateTimePicker> 	      			
	        	</div>
	        	
	        	<div class="col-md-2">
	      			<label for=s_select_to_date style="display:block">End Date</label>
	      			<acf:DateTimePicker id="s_select_to_date" name="select_to_date" pickTime="false">
	      				<acf:Bind on="validate"><script>selectDates_OnValidate(this, e);</script></acf:Bind></acf:DateTimePicker> 	      			
	        	</div>

	      		<div class="col-md-2">
	      			<label for=s_supplier_code style="display:block">Supplier Code</label>
	      			<acf:ComboBox id="s_supplier_code" name="supplier_code" editable="true" maxlength = "4" multiple="false">
	      			<acf:Bind on="initData"><script>
	 					$(this).acfComboBox("init", ${supplierselect} );
	 				</script></acf:Bind>
	      			</acf:ComboBox>
	        	</div>	    	


	    	</div>
	    	
		</form>
		
		
	</acf:Region>

</div>


<form id="frm_main" class="form-horizontal" data-role="form" >
		
	<acf:Region id="payment_request_headers" title="DESPATCH DATE MAINTENANCE OF TECHNICIAN" type="form">

		<div class="col-md-12">			
			<acf:Grid id="grid_payment_request" url="aptf004-get-payment.ajax" autoLoad="false" addable="false" deletable="false" editable="true" rowNum="20">
				<acf:Column name="payment_form_no" caption="PAT/ AT Form No." width="50" editable="false"></acf:Column>
				<acf:Column type="date" name="request_date" caption="Request Date" width="100"></acf:Column>
				<acf:Column name="supplier_desc" caption="Supplier" width="150" editable="false" ></acf:Column>			

				<acf:Column name="despatchdate" caption="Despatch Date" width="100" type="date" editable="true">
					<acf:Bind on="validate"><script>
						function validation (newValue, oldValue, newData, oldData, id) {
							var warning = null;

							if(newValue == "") {
							    console.log(id + " default time stamp " + oldValue);	
							    $("#grid_payment_request").setRowData(id,{despatch_date:moment(oldValue)});						    
								
							} else {
								$("#grid_payment_request").setRowData(id,{despatch_date:moment(newValue)});
								
							    var startFr = moment(oldData.request_date).format('YYYY-MM-DD');	
							   	var endTo = moment(newValue).format('YYYY-MM-DD');
								console.log(id + " despatch " + endTo + " request " + startFr);
								if (moment(startFr).isAfter(moment(endTo))) {
								  warning = ACF.getQtipHint('APF001V');}
								}
									
							return warning;	
						}
					</script></acf:Bind>
				</acf:Column>

				<acf:Column name="supplier_code" caption="" hidden = "true"></acf:Column>
				<acf:Column name="despatch_date" caption="" hidden = "true"></acf:Column>				
				<acf:Column name="modified_at" caption="" hidden="true"></acf:Column>
							
			</acf:Grid>
			
	    </div>
	    
		<div class="hidden">
			<input id="section_id" name="section_id" value="07"/>
 		</div>

    	
	</acf:Region>    	
		
	</form>

<script>

Controller.setOption({
	searchForm:$("#frm_search"),
	searchKey : "section_id,despatch_date,payment_form_no,request_date,supplier_code,fr_form_no,to_form_no,select_fr_date,select_to_date",
	browseKey: "section_id,despatch_date,payment_form_no,request_date,supplier_code,fr_form_no,to_form_no,select_fr_date,select_to_date", 

	initMode: "none",
	recordForm: $("#frm_main"),
	recordKey: {
	    payment_form_no: "$(payment_form_no)",
	},
	getUrl: "aptf004-get-payment.ajax",
	saveUrl: "aptf004-save.ajax",

	onLoadSuccess: function(data)
	{
	getSupplierDesc();
	},


	getSaveData: function() {
		
		return JSON.stringify({
			'payment_request' : $("#grid_payment_request").pGrid$getModifiedRecord(), 
		});
	},	


}).executeSingleRecSearchBrowserForm();

$("#grid_payment_request").on("afterLoadRecord", function(){
	getSupplierDesc();
});

function getSupplierDesc(){

	$.each($("#grid_payment_request").pGrid$getRecord(), function(id, rec){
		console.log(id + " " + rec.payment_form_no);
		if(rec.payment_form_no) {

				$.ajax({
								headers: {
									'Accept'       : 'application/json',
									'Content-Type' : 'application/json; charset=utf-8'
								},
								async  : false,
								type   : "POST",
								url    : "aptf004-get-supplier.ajax",
								data   : JSON.stringify({
									'payment_form_no'  : rec.payment_form_no,
								    'supplier_code'    : rec.supplier_code
								}),
								success: function(data) {
								if (data.supplier_desc != null) {
										$("#grid_payment_request").setRowData(id, {supplier_desc: data.supplier_desc});								
									}
								else{
									console.log("supplier desc : null");
									}
								}
							});		

		}
	});

}
</script>