({
	doInitHelper : function(component,event) {
		var action = component.get("c.totalDealSummary");
        var contactId = component.get("v.recordId");
        action.setParams({
            "contactId":contactId
        });
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                //console.log(JSON.stringify(resultData));  
                component.set("v.totalDealSummary",resultData);
                
            }else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	},
    
    getDAData: function(component, event) {
        var action = component.get("c.getDAlst");
        var recordId= component.get("v.recordId");
        action.setParams({
            "recordId":recordId
        });
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.DAList", resultData);
              //  component.set("v.DAListCount", resultData.length);
               // alert(JSON.stringify(resultData));
                console.log(JSON.stringify(resultData));
            }else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateStatusHelper : function(component,event,whichOne,recId){
        var action = component.get("c.updateDealActionStatus"); 
        action.setParams({
            "recordId" : recId,
            "status" : whichOne
        });
        
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                this.getDAData(component,event);
                this.doInitHelper(component,event);
            }else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    updateTodayDealSummary : function(component,event,whichOne){
        var TodayDealsAccepted = component.get("v.TodayDealsAccepted");
        var TodayDealsRejected = component.get("v.TodayDealsRejected");
        if(whichOne == 'Accepted'){
            TodayDealsAccepted ++;
            component.set("v.TodayDealsAccepted",TodayDealsAccepted);
        }
        else if(whichOne == 'Rejected'){
            TodayDealsRejected ++;
            component.set("v.TodayDealsRejected",TodayDealsRejected);
        }
    },
})