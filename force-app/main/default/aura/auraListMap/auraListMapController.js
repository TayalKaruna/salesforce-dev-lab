({
    showMap : function(component, event, helper) {
        var map=[];
        for(var i=0;i<10;i++){
            map.push({
                key:i,
                value: 'mapType' +i,
            });
        }
        component.set('v.mapType',map);
    }
})
