trigger accountTrigger on Account (after insert,after update) {
    accountHelper.accountWithContact(trigger.new);
}