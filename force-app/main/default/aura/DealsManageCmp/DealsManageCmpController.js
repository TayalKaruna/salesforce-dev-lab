({
	doInit : function(component, event, helper) {
        
		helper.doInitHelper(component,event);
        helper.getDAData(component,event);
	},
    
     updateStatus: function(component, event, helper){
         // whichOne will returns the aura:id of the button (whichOne is Out of the box)
       
         var whichOne = event.getSource().getLocalId();
         
         alert('1st button AURA ID is'+ whichOne);
         
        //butonName returns the name of the clicked button
        //var butonName = event.getSource().get("v.label");
        
        var recId  = event.getSource().get("v.value");
         
         //var butonlabel = event.getSource().get("v.label");
         
         //  alert(' Aura Id of this button is'+ whichOne);
         //  
        helper.updateStatusHelper(component,event,whichOne,recId);
        helper.updateTodayDealSummary(component,event,whichOne); 
    },
})