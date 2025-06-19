public with sharing class accountHelper {
    public static void accountWithContact(List<Account> acList) {
        
        List<Contact> contactList = new List<Contact>();
        
        for(Account acNew : acList){
            for(Integer i=0;i <= acNew.NumberOfEmployees;i++){
                Contact contNew = new Contact();
                contNew.firstName = 'Default';
                contNew.LastName = 'Contact' + i;
                contNew.accountId = acNew.Id;
                contactList.add(contNew);
            }
        }
        insert contactList ;
        System.debug('contactList Data'+contactList);
    }
    
    
    
}