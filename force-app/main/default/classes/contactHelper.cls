public class contactHelper {
    public static void rollupAccountInsert(List<Contact> conList){
            try {
                Set<Id> accIds = new Set<Id>();
                for(Contact con : conList){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
                List<AggregateResult> agrList = [SELECT Count(Id) countAcc, AccountId FROM Contact WHERE 
                                                 AccountId IN:accIds Group by accountId];
                
                List<Account> accToUpdate = new List<Account>();
                for(AggregateResult agr : agrList){
                    String acId = (String)agr.get('AccountId');
                    Integer totalChild = (Integer)agr.get('countAcc');
                    Account acRec = new Account();
                    acRec.id = acId;
                    acRec.TotalChild__c = totalChild;
					accToUpdate.add(acRec);                    
                }
                update accToUpdate;
                
            }catch(exception ex){
                system.debug('Exception at--'+ex.getLineNumber()+ex.getMessage()+ex.getCause());
            }
    }
    
    public static void rollupAccountUpdate(List<Contact> conList, Map<Id, Contact> newConMap,Map<Id, Contact> oldConMap){
system.debug('inside rollup method');            
            try {
                Set<Id> accIds = new Set<Id>();
                for(Contact newCon : conList){
                    Contact oldCon = oldConMap.get(newCon.AccountId);
                    system.debug('oldCon name'+oldCon.Name);
                    system.debug('newCon name'+newCon.Name);
                    if(oldCon.AccountId != newCon.AccountId){
                        accIds.add(newCon.AccountId);
                        accIds.add(oldCon.AccountId);
                        system.debug('accIds '+accIds);
                        system.debug('accIds size '+accIds.size());
                    }
                }
                
                List<AggregateResult> agrList = [SELECT Count(Id) countAcc, AccountId FROM Contact WHERE 
                                                 AccountId IN:accIds Group by accountId];
                
                system.debug('agrList size'+agrList.size());
                system.debug('agrList '+agrList);
                List<Account> accToUpdate = new List<Account>();
                for(AggregateResult agr :agrList){
                    String acId = (String)agr.get('AccountId');
                    system.debug('acId '+acId);
                    Integer totalChild = (Integer)agr.get('countAcc');
                    system.debug('totalChild '+totalChild);
                    Account acRec = new Account();
                    acRec.id = acId;
                    acRec.TotalChild__c = totalChild;
					accToUpdate.add(acRec);   
                    system.debug('accToUpdate '+acRec.TotalChild__c);
                }
                update accToUpdate;
                system.debug('accToUpdate '+accToUpdate);
                system.debug('accToUpdate '+accToUpdate.size());
                
            }catch(exception ex){
                system.debug('Exception at--'+ex.getLineNumber()+ex.getMessage()+ex.getCause());
            }
    }
    public static void rollupAccountDelete(List<Contact> conList) {
    try {
        Set<Id> accIds = new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }

        List<AggregateResult> agrList = [SELECT Count(Id) countAcc, AccountId 
                                         FROM Contact 
                                         WHERE AccountId IN :accIds 
                                         GROUP BY AccountId];
        
        Map<Id, Integer> accCountMap = new Map<Id, Integer>();
        for (AggregateResult agr : agrList) {
            accCountMap.put((Id)agr.get('AccountId'), (Integer)agr.get('countAcc'));
        }

        List<Account> accToUpdate = new List<Account>();
        for (Id accId : accIds) {
            Account acc = new Account();
            acc.Id = accId;
            acc.TotalChild__c = accCountMap.containsKey(accId) ? accCountMap.get(accId) : 0;
            accToUpdate.add(acc);
        }

        update accToUpdate;

    } catch(Exception ex){
        System.debug('Exception in rollupAccountDelete: ' + ex.getLineNumber() + ' - ' + ex.getMessage());
    }
}

}