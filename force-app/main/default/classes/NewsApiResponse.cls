public class NewsApiResponse {
    public List<Article> articles;
    public String status;
    public Integer totalResults;

    public class Article {
        public String author;
        public String title;
        public String description;
        public String url;
        public String urlToImage;
        public String publishedAt;
        public String content;
        public SourceInfo source;
    }

    public class SourceInfo {
        public String id;
        public String name;
    }
}