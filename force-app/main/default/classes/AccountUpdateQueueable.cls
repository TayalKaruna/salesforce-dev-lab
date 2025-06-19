public class AccountUpdateQueueable implements Queueable {
    private List<Account> accountsToUpdate;

    public AccountUpdateQueueable(List<Account> accounts) {
        this.accountsToUpdate = accounts;
    }

    public void execute(QueueableContext context) {
        try {
            Integer batchSize = 200;

            System.debug('accountsToUpdate: ' + accountsToUpdate);
            System.debug('accountsToUpdate: size' + accountsToUpdate.size());
            for (Integer i = 0; i < accountsToUpdate.size(); i += batchSize) {
                List<Account> batch = new List<Account>();

                for (Integer j = i; j < Math.min(i + batchSize, accountsToUpdate.size()); j++) {
                    if (accountsToUpdate[j].Id != null) {
                        batch.add(accountsToUpdate[j]);
                        System.debug('accountsToUpdate: ' + accountsToUpdate);
                    }
                }

                if (!batch.isEmpty()) {
                    update batch;
                    System.debug('batch in Queueable: ' + batch);
                }
            }
        } catch (Exception e) {
            System.debug('Error in Queueable: ' + e.getMessage()+ e.getLineNumber());
        }
    }
}