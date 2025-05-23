public with sharing class ContactController {
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts(){
        try {
            List<Contact> contList = new List<Contact>();
            contList = [Select id,FirstName, LastName, Email, Phone from Contact WITH SECURITY_ENFORCED];
                      
            return contList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+'-'+e.getLineNumber()+'-'+e.getCause()+'-'+e.getTypeName());
        }
    }
    @AuraEnabled
    public static void deleteContact(List<Id> contIds){
        if (Schema.sObjectType.Contact.isDeletable() && Schema.sObjectType.Contact.isAccessible()) {
            List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE Id IN :contIds];
            delete contactsToDelete;
        } else{
            throw new AuraHandledException('You do not have access to delete contacts');
        }
    }

    @AuraEnabled(cacheable=true)
    public static Integer getContactsCount() {
            Integer countContact = [SELECT COUNT() FROM Contact];
            return countContact;
    }

    @AuraEnabled
    public static void updateSelectedContacts(List<Contact> updatedContacts) {
        update updatedContacts;
    }
}