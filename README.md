# Project_GOAT
CNN to predict Rocky Mountain Goat sex based on images

Images not included in GitHub due to size of image files.

Files:


web_crawler.py - Use iCrawler web crawlers to collect images from Bing and Google and store the URLs in a database (images.db)

image_review.py - Manually review each image to ensure they are Rocky Mountain Goats and in the correct class. Also houses function to remove unwanted images

AWS_S3.py - Upload the list of cleaned images from images.db to S3 buckets

example_model.ipynb - CNN tutorial using TensorFlow

custom_model.ipynb - CNN for predicting Rocky Mountain Goat sex
