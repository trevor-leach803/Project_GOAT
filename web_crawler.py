from icrawler.builtin import GoogleImageCrawler, BingImageCrawler
from icrawler import ImageDownloader
import sqlite3
import pandas as pd
from datetime import date

class CustomLinkPrinter(ImageDownloader):
    # Class to override ImageDownloader in icrawler to retrieve image URLs
    # instead of downloading the images
    file_urls = []

    def get_filename(self, task, default_ext):
        file_idx = self.fetched_num + self.file_idx_offset
        return '{:04d}.{}'.format(file_idx, default_ext)

    def download(self, task, default_ext, timeout=5, max_retry=3, overwrite=False, **kwargs):
        file_url = task['file_url']
        filename = self.get_filename(task, default_ext)

        task['success'] = True
        task['filename'] = filename

        if not self.signal.get('reach_max_num'):
            self.file_urls.append(file_url)

        self.fetched_num += 1

        if self.reach_max_num():
            self.signal.set(reach_max_num=True)

        return
    
    
def create_database(connection):
    # This function creates the database tables
    try:
        connection.execute("""CREATE TABLE IF NOT EXISTS BILLY_IMAGE_LINKS(
            id INT,
            url TEXT PRIMARY KEY);
        """)

        connection.execute("""CREATE TABLE IF NOT EXISTS NOT_BILLY_IMAGE_LINKS(
            id INT,
            url TEXT PRIMARY KEY);
        """)
    except sqlite3.Error as error:
        print("Error occured: {}".format(error))


def initiate_crawler(crawler, source, cursor, queries, table_name):
    # Initiate the crawler to collect urls for images and input the urls into the respective table
    if source == 'google':
        dates = [(2017,1,1),(2017,7,1),(2018,1,1),(2018,7,1),(2019,1,1),(2019,7,1),(2020,1,1),(2020,7,1),(2021,1,1),(2021,7,1),(2022,1,1),(2022,7,1),(2023,1,1),(2023,6,1)]
        count = 0
        for i in range(len(dates)-1):
            filters = dict(date=(dates[i],dates[i+1]))
            for query in queries:
                crawler.downloader.file_urls = []
                crawler.crawl(query, max_num=1000, filters=filters)
                for link in crawler.downloader.file_urls:
                    cursor.execute(f'''INSERT OR IGNORE INTO {table_name} VALUES ('{count}','{link}')''')
                    count += 1
    elif source == 'bing':
        count = 0
        for query in queries:
            crawler.downloader.file_urls = []
            crawler.crawl(query, max_num=1000)
            for link in crawler.downloader.file_urls:
                cursor.execute(f'''INSERT OR IGNORE INTO {table_name} VALUES ('{count}','{link}')''')
                count += 1

    connection.commit()


def main(connection):
    cursor = connection.cursor()
    create_database(connection)
    
    billy_queries = ['male Rocky Mountain Goat','billy Rocky Mountain Goat','adult male Rocky Mountain Goat', 'Rocky Mountain Goat billy', 'Rocky Mountain Goat adult male']
    not_billy_queries = ['female Rocky Mountain Goat','nanny Rocky Mountain Goat','juvenile Rocky Mountain Goat','Rocky Mountain Goat family','adult female Rocky Mountain Goat']

    google_crawler = GoogleImageCrawler(downloader_cls=CustomLinkPrinter, storage={'root_dir': 'images'})
    bing_crawler = BingImageCrawler(downloader_cls=CustomLinkPrinter, storage={'root_dir': 'images'})
    
    crawlers = {'google':google_crawler, 'bing':bing_crawler}

    for source, crawler in crawlers.items():
        initiate_crawler(crawler, source, cursor, billy_queries, 'BILLY_IMAGE_LINKS')
        initiate_crawler(crawler, source, cursor, not_billy_queries, 'NOT_BILLY_IMAGE_LINKS')


if __name__ == '__main__':
    connection = sqlite3.connect('images.db')
    main(connection)
    connection.close()