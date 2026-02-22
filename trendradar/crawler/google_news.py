# file: crawlers/google_news.py
import feedparser
from datetime import datetime, timedelta
import re
from urllib.parse import quote

class GoogleNewsCrawler:
    """Google News RSS 爬虫"""
    
    def __init__(self):
        self.name = "Google News"
        self.base_url = "https://news.google.com/rss"
        
    def fetch_news(self, keywords=None, hours=24):
        """
        抓取 Google News
        :param keywords: 关键词列表，用于构建搜索URL
        :param hours: 抓取最近多少小时的新闻
        """
        all_entries = []
        
        # 如果没有指定关键词，使用默认的AI相关关键词
        if not keywords:
            keywords = ["AI", "人工智能", "机器学习"]
        
        for keyword in keywords:
            # 构建搜索URL
            encoded_keyword = quote(keyword)
            # Google News RSS 搜索URL
            search_url = f"{self.base_url}/search?q={encoded_keyword}+when:{hours}h&hl=zh-CN&gl=CN&ceid=CN:zh-cn"
            
            try:
                # 使用 feedparser 解析 RSS
                feed = feedparser.parse(search_url)
                
                for entry in feed.entries[:10]:  # 每个关键词取前10条
                    news_item = {
                        "title": entry.title,
                        "url": entry.link,
                        "source": "Google News",
                        "published": entry.get("published", datetime.now().isoformat()),
                        "summary": entry.get("summary", ""),
                        "keyword": keyword  # 记录匹配的关键词
                    }
                    all_entries.append(news_item)
                    
            except Exception as e:
                print(f"抓取 Google News 关键词 '{keyword}' 失败: {e}")
                
        return all_entries
    
    def parse_date(self, date_string):
        """解析 Google News 的日期格式"""
        # Google News 的日期格式可能类似：'Tue, 19 Feb 2026 10:30:00 GMT'
        try:
            # 使用 dateutil 解析更灵活
            from dateutil import parser
            return parser.parse(date_string)
        except:
            return datetime.now()