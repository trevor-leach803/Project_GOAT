# Project_GOAT
CNN to predict Rocky Mountain Goat sex based on images

Images not included in GitHub due to size of image files.

Files:


web_crawler.py - Use iCrawler web crawlers to collect images from Bing and Google and store the URLs in a database (images.db)

image_review.py - Manually review each image to ensure they are Rocky Mountain Goats and in the correct class. Also houses function to remove unwanted images

AWS_S3.py - Upload the list of cleaned images from images.db to S3 buckets

example_model.ipynb - CNN tutorial using TensorFlow

custom_model.ipynb - CNN for predicting Rocky Mountain Goat sex

The mobile_app directory contains the Swift files necessary to build the mobile application in Xcode. These files will not compile on their own, but they do provide a good starting point for creating the mobile app on another machine.

<img src="https://example.com/your-image.jpg](https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/ImageClassification.PNG" width="600" />


![alt text](https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/ImageClassification.PNG)
![ImageClassification](https://github.com/trevor-leach803/Project_GOAT/assets/112582435/0f1c02c8-f663-4dc0-af09-92d7262e205e) | width=200
