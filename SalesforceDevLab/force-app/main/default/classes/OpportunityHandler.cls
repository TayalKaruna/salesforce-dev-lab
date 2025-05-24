public class OpportunityHandler {
    
    public static void oppAmountRollup(List<Opportunity> opptyList, Map<Id,Opportunity> oldMap){
        Set<Id> accountIds = new Set<Id>();
        //new parent (accountId)
        try{
            for(Opportunity opRec : opptyList){
                if(opRec.AccountId != null){
                    accountIds.add(opRec.AccountId);
                }
                
                //re-parenting
                if(oldMap != null){
                    Opportunity oldOpportunity = oldMap.get(opRec.Id);
                    if((oldOpportunity != null && oldOpportunity.AccountId != null && opRec.AccountId != null)  && 
                       (opRec.AccountId != oldOpportunity.AccountId)){
                           
                           accountIds.add(opRec.AccountId);
                           accountIds.add(oldOpportunity.AccountId);
                       }
                }
            }
            
            List<AggregateResult> agrList = [select SUM(Amount) totalAmt, AccountId,StageName from opportunity 
                                             where accountid IN: accountIds GROUP BY AccountId,StageName];
            System.debug('agrList####'+agrList);
            
            Map<Id,Decimal> wonAmtOpMap =  new Map<Id,Decimal>();
            Map<Id,Decimal> lostAmtOpMap = new Map<Id,Decimal>();
            
            List<Account> listToUpdate = new List<Account>();
            
            for(AggregateResult agr : agrList){
                String stage = (String)agr.get('stagename');
                Decimal amount = (Decimal)agr.get('totalAmt');
                Id acId = (Id)agr.get('AccountId');
                
                
                if(stage == 'Closed Won'){
                    wonAmtOpMap.put(acId,amount);
                    System.debug('wonAmtOpMap####'+wonAmtOpMap);
                }else if(stage == 'Closed Lost'){
                    lostAmtOpMap.put(acId,amount); 
                    System.debug('lostAmtOpMap####'+lostAmtOpMap);
                }
            }
            
            for(Id acIdd : accountIds){
                
                //Decimal wonAmt = wonAmtOpMap.containskey(acIdd) ? wonAmtOpMap.get(acIdd) : 0;
                //Decimal lostAmt = lostAmtOpMap.containskey(acIdd) ? lostAmtOpMap.get(acIdd) :0;
                
                Decimal wonAmt = wonAmtOpMap.containsKey(acIdd) ? wonAmtOpMap.get(acIdd) : 0;
                Decimal lostAmt = lostAmtOpMap.containsKey(acIdd) ? lostAmtOpMap.get(acIdd) : 0;
                
                Account acRec = new Account(
                    Id = acIdd,
                    Total_Won_Amount__c = wonAmt,
                    TotalOppAmount__c = lostAmt
                );
                System.debug('acRec####'+acRec);
                listToUpdate.add(acRec);
            }
            
            if(!listToUpdate.isEmpty()){
                Update listToUpdate;
                System.debug('listToUpdate'+listToUpdate);
                
            }
            
        }catch(Exception ex){
            System.debug('Exception'+ex.getMessage() + ex.getLineNumber()+ ex.getCause()+ ex.getTypeName() + ex.getStackTraceString());
        }
    }    
}