import feedparser

# Test a feed
feed = feedparser.parse("https://www.nasdaq.com/feed/rss")
print(f"Found {len(feed.entries)} articles")
for entry in feed.entries[:3]:
    print(f"- {entry.title}")