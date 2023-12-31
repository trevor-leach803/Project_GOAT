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

Login Screen:

<img src="https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/LoginScreen.PNG" width="400" />

Image Selection Screen:

<img src="https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/ImageSelection.PNG" width="400" />

Result of Image Classification Screen:

<img src="https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/ImageClassification.PNG" width="400" />

Previous Submissions Screen:

<img src="https://github.com/trevor-leach803/Project_GOAT/blob/main/mobile_app/app_screenshots/PreviousSubmissions.PNG" width="400" />
