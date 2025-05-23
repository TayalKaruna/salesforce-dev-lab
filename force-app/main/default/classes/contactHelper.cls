public class contactHelper {
    private static Boolean isExecuting = false;
    public static void rollupAccount(List<Contact> conList){
        if (!isExecuting) {
            isExecuting = true;
            
            try {
                Set<Id> accIds = new Set<Id>();
                for(Contact con : conList){
                    if(con.AccountId != null){
                        accIds.add(con.AccountId);
                    }
                }
                
                List<Account> accList = [Select id,No_of_contact__c,(Select id from contacts) from Account where Id IN :accIds];
                
                for(Account acc : accList){
                    Integer countCon = acc.contacts.size();
                    acc.No_of_contact__c = countCon;
                }
                update accList;
                //Account  relatedCon = 
                
            }finally {
                isExecuting = false;
            }
        }
    }
}