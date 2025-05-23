trigger planTrigger on Plan__c (before insert,before update) {

    PlanHelper.planValidation(trigger.new);
}