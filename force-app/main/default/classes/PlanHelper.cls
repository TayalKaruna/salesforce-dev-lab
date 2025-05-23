public class PlanHelper {

    public static void planValidation(List<Plan__c> planList){
        for(Plan__c plan : planList){
            if(plan.Travel_Hours__c > 100 && ( plan.Travel_Location__c.contains('A') || plan.Travel_Location__c.contains('F'))){
                plan.Travel_Hours__c.addError('Plan should not be more than 100 hours');
            }
        }
    }
}