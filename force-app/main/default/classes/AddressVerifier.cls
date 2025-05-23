public class AddressVerifier {
    public static void verifyAddress(Lead ld){
        string apiKey = 'c21c889d7be44cbe8249bdd31bf1b252';
        string apiParams = '';
        if(ld.Category__c !='' && ld.Country__c !='' && ld.Language__c !=''){
            apiParams = 'country='+ld.Country__c+'&category'+ld.Category__c+'&language'+ld.Language__c+'&apiKey='+apiKey;
        }
        try{
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://newsapi.org/v2/top-headlines?'+apiParams);
            request.setMethod('GET'); 
            
            // Set headers
            request.setHeader('X-Api-Key', apiKey);
            request.setHeader('Authorization', apiKey);
            
            Http http = new Http();
            HTTPResponse response = http.send(request);
            System.debug('response'+response); 
            System.debug('body==='+response.getBody()); 
            //Check response  
            if(response.getStatusCode() == 200) {
                String author ='';
                String title = '';
                String description = '';
                String url = '';
                String urlToImage = '';
                String publishedAt ='';
                String content = '';
                String sourceId ='';
                String sourceName = '';
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('jsonResponse==='+jsonResponse);
                NewsApiResponse info = (NewsApiResponse) JSON.deserialize(response.getBody(),NewsApiResponse.class);
                System.debug('info-----'+info);
                System.debug('info status'+info.status);
                System.debug('info totalResults'+info.totalResults);
                if(info.articles != null){
                    List<NewsApiResponse.Article> articlesList = info.articles;
                    for(NewsApiResponse.Article article : articlesList){
                        author = article.author;
                        title = article.title;
                        description = article.description;
                        url = article.url;
                        urlToImage = article.urlToImage;
                        publishedAt = article.publishedAt;
                        content = article.content;
                        
                        // Access source information
                        NewsApiResponse.SourceInfo sourceInfo = article.source;
                        sourceId = sourceInfo.Id;
                        sourceName = sourceInfo.name;
                        
                        
                    }
                    System.debug('sourceId:' + sourceId);
                    System.debug('sourceName:' + sourceName);
                    // Now you can use the extracted values as needed
                    System.debug('Author:' + author);
                    System.debug('Title:'  + title);
                    System.debug('Description:' + description);
                    System.debug('url:' + url);
                    System.debug('urlToImage:'  + urlToImage);
                    System.debug('publishedAt:' + publishedAt);
                    System.debug('content:' + content);
                }
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus()); 
            }
        }catch(Exception ex){
            System.debug('Exception occurred:' + ex.getMessage()+ex.getLineNumber());
        }
    }
}