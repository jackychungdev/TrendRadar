from bs4 import BeautifulSoup
import os

HTML_REPORT_PATH = os.path.join('output', 'html', 'latest', 'incremental.html')
PLATFORM_NAME = '华尔街见闻'

def main():
    if not os.path.exists(HTML_REPORT_PATH):
        print('HTML report not found:', HTML_REPORT_PATH)
        return
    with open(HTML_REPORT_PATH, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f, 'html.parser')

    # Find all news items for 华尔街见闻
    found = False
    for group in soup.find_all(class_='word-group'):
        header = group.find(class_='word-name')
        if header and PLATFORM_NAME in header.text:
            found = True
            print(f'News from {PLATFORM_NAME} today:')
            for idx, item in enumerate(group.find_all(class_='news-item'), 1):
                title_tag = item.find(class_='news-title')
                if title_tag:
                    print(f'{idx}. {title_tag.text.strip()}')
            break
    if not found:
        print(f'No news found for {PLATFORM_NAME} today.')

if __name__ == '__main__':
    main()
