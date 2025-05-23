public with sharing class EmailVerificationCallout {
    //Contact Validation via External API
    @AuraEnabled
    public static string validateEmail(String emailAddress){
        String apiKey = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:AbstractEmailValidation/v1/?api_key=67e0591a2bf9465199807033e1f89a4e'+'&email=' + emailAddress);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        System.debug('Response callout## :'+'   '+JSON.deserializeUntyped(response.getBody()));

        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Response results##'+results);

            if(results.get('deliverability') == 'DELIVERABLE'){
                return 'Valid';
            }else if(results.get('deliverability') == 'UNDELIVERABLE'){
                return 'Invalid';
            }
        }else{
            return 'Unknown';
        }
        return 'Failed';
    }
}