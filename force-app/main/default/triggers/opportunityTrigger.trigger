trigger opportunityTrigger on Opportunity (After insert,After update,After delete) {
OpportunityHandler.countOli(trigger.new);
}