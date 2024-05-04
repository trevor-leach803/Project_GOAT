import boto3
import requests
import pandas as pd
import sqlite3
from sklearn.model_selection import train_test_split

s3 = boto3.client('s3')

def train_data_split(connection):
    buckets = ['goat-training-images','goat-testing-images']
    table_file_pairs = {'BILLY_IMAGE_LINKS':'billy-images/','NOT_BILLY_IMAGE_LINKS':'not-billy-images/'}

    for table, file in table_file_pairs.items():
        df = pd.read_sql_query(f'SELECT * FROM {table}', connection)
        X = df['id']
        y = df['url']
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state=42)

        for i in range(len(y)):
            if i in X_train:
                file_upload(y[i], buckets[0], i, file)
            elif i in X_test:
                file_upload(y[i], buckets[1], i, file)
            else:
                exit

def save_to_s3(connection):
    # Function to retrieve and save images to S3 without downloading the image locally
    table_bucket_pairs = {'BILLY_IMAGE_LINKS':'billies', 'NOT_BILLY_IMAGE_LINKS':'not-billies'}

    for table, bucket in table_bucket_pairs.items():
        url_df = pd.read_sql_query(f'SELECT * FROM {table}', connection)
        for i in range(len(url_df)):
            try:
                imageResponse = requests.get(url_df['url'][i], stream=True).raw
                s3.upload_fileobj(imageResponse, bucket, bucket + '-' + str(i))
                print(f"Upload Successful {bucket} {i}")
            except:
                print(f"Failure at {bucket} id {i}")


def file_upload(url, bucket, index, file):
    try:
        imageResponse = requests.get(url, stream=True).raw
        s3.upload_fileobj(imageResponse, bucket, file+str(index))
        print(f"Upload Successful {file} {index}")
    except:
        print(f"Failure at {file} id {index}")


if __name__ == '__main__':
    connection = sqlite3.connect('images.db')
    save_to_s3(connection)
    train_data_split(connection)
    connection.close()