public class OpportunityHandler {
    public static void countOnAcc(List<Opportunity> oppList){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opNew : oppList){
            if(opNew.accountId != null){
                accountIds.add(opNew.accountId);
            }
        }
        Map<Id, Decimal> accountTotalAmountMap = new Map<Id, Decimal>();
        
        for(AggregateResult aggRes : [SELECT AccountId,SUM(Amount) totalAmount FROM Opportunity where AccountId IN :accountIds 
                                         and StageName='Closed Won' GROUP BY AccountId]){
                                             accountTotalAmountMap.put((Id)aggRes.get('AccountId'),(Decimal)aggRes.get('totalAmount'));
                                         }
        List<Account> accToUpdate = new List<Account>();
        for(Id accId : accountIds){
            if(accountTotalAmountMap.containsKey(accId)){
                 Decimal totalAmt = accountTotalAmountMap.get(accId);
                accToUpdate.add(new Account(Id = accId, Total_Won_Amount__c = totalAmt));
            }
        }
        Update accToUpdate;
    }
}