public class OpportunityHandler {
    
    // Main method: total opportunity amount per account
    public static void totalOppAmt(List<Opportunity> oppList) {
        Set<Id> accountIds = new Set<Id>();
        
        // Collect AccountIds from Opportunities
        for (Opportunity opp : oppList) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) return;
        
        // Aggregate total Opportunity Amount grouped by Account
        List<AggregateResult> aggResults = [
            SELECT AccountId, SUM(Amount) totalAmount
            FROM Opportunity
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ];
        
        List<Account> accountsToUpdate = new List<Account>();
        Integer recordsProcessed = 0;
        for (AggregateResult ar : aggResults) {
            accountsToUpdate.add(new Account(
                Id = (Id) ar.get('AccountId'),
                TotalOppAmount__c = (Decimal) ar.get('totalAmount')
            ));
            recordsProcessed++;
            System.debug('recordsProcessed@@@'+recordsProcessed);
            System.debug('accountsToUpdate>>>>'+accountsToUpdate);
            System.debug('accountsToUpdate size###'+accountsToUpdate.size());
            
            if (recordsProcessed == 10000) {
                update accountsToUpdate;
                System.debug('accountsToUpdate update'+accountsToUpdate);
                System.debug('accountsToUpdate size--'+accountsToUpdate.size());
                accountsToUpdate.clear();
                recordsProcessed = 0;
                System.debug('recordsProcessed update'+recordsProcessed);
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            System.debug('before update'+accountsToUpdate);
            update accountsToUpdate;
            System.debug('after update'+accountsToUpdate);
        }
    }
    
    // 🔁 Batch-safe update method without using subList
    private static void updateAccountsInBatches(List<Account> allAccounts) {
    Integer batchSize = 200;
    Integer maxDmlRows = 10000;
    Integer rowsProcessed = 0;

    for (Integer i = 0; i < allAccounts.size() && rowsProcessed < maxDmlRows; i += batchSize) {
        List<Account> batch = new List<Account>();

        for (Integer j = i; j < Math.min(i + batchSize, allAccounts.size()); j++) {
            if (rowsProcessed >= maxDmlRows) break;

            batch.add(allAccounts[j]);
            rowsProcessed++;
        }

        if (!batch.isEmpty()) {
            //update batch;
        }
    }

    if (rowsProcessed < allAccounts.size()) {
        System.debug('Skipped some records to avoid DML governor limit.');
    }
}

    
    public static void minOppAmt(List<Opportunity> oppList) {
        // Implement your logic here...
    }
    
    public static void maxOppAmt(List<Opportunity> oppList) {
        // Implement your logic here...
    }
}