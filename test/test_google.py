# 进入你的 TrendRadar 配置目录
# 创建测试脚本
cat > test_google.py << 'EOF'
import feedparser
from urllib.parse import quote

def test_google_news(keyword):
    """测试 Google News RSS 抓取"""
    print(f"\n🔍 测试关键词: {keyword}")
    print("-" * 50)
    
    # 构建 URL
    encoded_keyword = quote(keyword)
    url = f"https://news.google.com/rss/search?q={encoded_keyword}+when:24h&hl=zh-CN&gl=CN&ceid=CN:zh-cn"
    print(f"📡 请求 URL: {url}")
    
    try:
        # 抓取 RSS
        feed = feedparser.parse(url)
        
        print(f"📊 状态: {feed.get('status', 'unknown')}")
        print(f"📰 找到 {len(feed.entries)} 条新闻")
        
        if feed.entries:
            print("\n📋 前5条新闻:")
            for i, entry in enumerate(feed.entries[:5], 1):
                print(f"\n  {i}. {entry.title}")
                print(f"     来源: {entry.get('source', {}).get('title', '未知')}")
                print(f"     时间: {entry.get('published', '未知')}")
                print(f"     链接: {entry.link[:60]}..." if len(entry.link) > 60 else f"     链接: {entry.link}")
        else:
            print("❌ 没有找到新闻")
            
        return len(feed.entries) > 0
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        return False

def test_multiple_keywords():
    """测试多个关键词"""
    keywords = ["AI", "人工智能", "大模型", "机器学习", "ChatGPT"]
    
    print("=" * 60)
    print("🚀 开始测试 Google News RSS 抓取")
    print("=" * 60)
    
    success_count = 0
    for kw in keywords:
        if test_google_news(kw):
            success_count += 1
        print("-" * 50)
    
    print(f"\n📊 测试完成: {success_count}/{len(keywords)} 个关键词成功")

if __name__ == "__main__":
    # 如果指定了命令行参数，测试单个关键词
    import sys
    if len(sys.argv) > 1:
        test_google_news(sys.argv[1])
    else:
        test_multiple_keywords()
EOF
