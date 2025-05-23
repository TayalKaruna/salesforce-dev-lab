({
	clickAdd : function(component, event, helper) {
		var auraInp1= component.get('v.input1');
        var auraInp2= component.get('v.input2');
        component.set('v.result', parseInt(auraInp1) + parseInt(auraInp2));
	},
    clickMulty : function(component, event, helper) {
		var auraInp1= component.get('v.input1');
        var auraInp2= component.get('v.input2');
        component.set('v.result', parseInt(auraInp1) * parseInt(auraInp2));
	},
    clickDiv : function(component, event, helper) {
		var auraInp1= component.get('v.input1');
        var auraInp2= component.get('v.input2');
        component.set('v.result', parseInt(auraInp1) / parseInt(auraInp2));
	},
    clickSub : function(component, event, helper) {
		var auraInp1= component.get('v.input1');
        var auraInp2= component.get('v.input2');
        component.set('v.result', parseInt(auraInp1) - parseInt(auraInp2));
	}
})