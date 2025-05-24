trigger CountDeals on Deal_Action__c (After insert,After Update) {
    Set<Id> contactsId = new Set<Id>();
    Set<Id> dealsId = new Set<Id>();
    List<Contact> updatedAcceptDealonCon = new List<Contact>();
    List<Contact> updatedRejectDealonCon= new List <Contact>();
    List<Deal__c> updatedAcceptedonDeal = new List<Deal__c>();
    List<Deal__c> updatedRejectedonDeal = new List<Deal__c>();
    
    if(Trigger.isAfter){
        if(Trigger.IsInsert || Trigger.IsUpdate){
            for(Deal_Action__c da : Trigger.new){
                if(da.Contact__c !=null){
                    contactsId.add(da.Contact__c);
                    System.debug('contacts Id'+'  '+contactsId);
                }
                if(da.Deal__c !=null){
                    dealsId.add(da.Deal__c);
                    System.debug('Deals Id'+'  '+dealsId);
                }
            }
        }
        if(Trigger.IsDelete){
            for(Deal_Action__c da : Trigger.old){
                if(da.Contact__c !=null){
                    contactsId.add(da.Contact__c);
                    System.debug('contacts Id'+'  '+contactsId);
                }
                if(da.Deal__c !=null){
                    dealsId.add(da.Deal__c);
                    System.debug('Deals Id'+'  '+dealsId);
                }
            }
        }
        
       /* List<Deal_Action__c> allAcceptsDeals =[SELECT Id,name,Action__c FROM Deal_Action__c WHERE Action__c='Accepted'];
        System.debug('Accepted Deals'+'  '+allAcceptsDeals);
        List<Deal_Action__c> allRejectsDeals =[SELECT Id,name,Action__c FROM Deal_Action__c WHERE Action__c='Rejected'];
        System.debug('Rejected Deals'+'  '+allRejectsDeals);*/
        
        /**
* 
*Deal Accept and Reject values on Contact Line 23- 40**
*  
***/
        for(Contact cont: [SELECT Id,name,Deals_Accepted__c,(SELECT ID,Action__c,Contact__c FROM Deal_Actions__r WHERE Action__c ='Accepted') FROM Contact WHERE Id IN:contactsId]){
            
            List<Deal_Action__c> AccepteddealsList = cont.Deal_Actions__r;
            System.debug('List of Deals Accepted data'+'  '+ AccepteddealsList);
            cont.Deals_Accepted__c= AccepteddealsList.size();
            updatedAcceptDealonCon.add(cont);
            System.debug('Counted Accepted values'+'  '+ updatedAcceptDealonCon);
        }
        try{
            UPDATE updatedAcceptDealonCon;
        }
        catch(System.Exception e){
            
        }
        for(Contact cont: [SELECT Id,name,Deals_Rejected__c,(SELECT ID,Action__c,Contact__c FROM Deal_Actions__r WHERE Action__c ='Rejected') FROM Contact WHERE Id IN:contactsId]){
            List<Deal_Action__c> RejecteddealsList = cont.Deal_Actions__r;
            System.debug('List of Deals Rejected data'+'  '+ RejecteddealsList);
            cont.Deals_Rejected__c= RejecteddealsList.size();
            updatedRejectDealonCon.add(cont);
            System.debug('Counted Rejected values on contact'+'  '+ updatedRejectDealonCon); 
        }     
        try{
            UPDATE updatedRejectDealonCon;
        }catch(System.Exception e){
            
        }
        /**
* 
*Deal Accept and Reject values on Deal Line 55- 72**
*  
***/
        
        for(Deal__c dl :[SELECT Id,name,Acceptance__c,Available_Deals__c,(SELECT ID,Action__c,Deal__c FROM Deal_Actions__r WHERE Action__c ='Accepted') FROM Deal__c WHERE Id IN:dealsId]){
            List<Deal_Action__c> AccepteddealsList = dl.Deal_Actions__r;
            System.debug('List of Deals Accepted data'+'  '+ AccepteddealsList);
            dl.Acceptance__c= AccepteddealsList.size();
            updatedAcceptedonDeal.add(dl);
            System.debug('Counted Accepted values on Deal'+'  '+ updatedAcceptedonDeal);
        }
        try{
            UPDATE updatedAcceptedonDeal;
        }catch(System.Exception e){
            
        }
        for(Deal__c dl :[SELECT Id,name,Rejection__c,Available_Deals__c,(SELECT ID,Action__c,Deal__c FROM Deal_Actions__r WHERE Action__c ='Rejected') FROM Deal__c WHERE Id IN:dealsId]){
            List<Deal_Action__c> RejectdealsList = dl.Deal_Actions__r;
            System.debug('List of Deals Rejected data'+'  '+ RejectdealsList);
            dl.Rejection__c= RejectdealsList.size();
            updatedRejectedonDeal.add(dl);
            System.debug('Counted Rejected values on Deal'+'  '+ updatedRejectedonDeal);
        }
        try{
            UPDATE updatedRejectedonDeal;
        }catch(System.Exception e){
            
        }
        /*  if(Trigger.isInsert || Trigger.isUpdate){

Helper_CountDeals.countParent(trigger.new);
try{
update accountListToUpdate;
}catch(System.Exception e){

}


}*/
    }
}