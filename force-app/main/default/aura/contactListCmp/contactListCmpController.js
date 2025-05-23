({
    doInit : function(component, event, helper) {
        var action = component.get('c.getContactList');
        action.setCallback(this, function(response){
            var responseVal = response.getReturnValue();
            console.log('response value', responseVal);
            component.set('v.contactData', responseVal);
        });
        $A.enqueueAction(action,false);
    }
})