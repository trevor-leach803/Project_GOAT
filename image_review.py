import sqlite3
import pandas as pd
import webbrowser
import time

def image_review(connection):
    # Function to review each image to ensure that they are of Rocky Mountain Goats
    table_bucket_pairs = {'BILLY_IMAGE_LINKS':'billies','NOT_BILLY_IMAGE_LINKS':'not-billies'}

    # Open each image in the default browser and pause for 6 seconds for review
    for table, bucket in table_bucket_pairs.items():
        url_df = pd.read_sql_query(f'SELECT * FROM {table}', connection)
        for i in range(len(url_df)):
            webbrowser.open(url_df['url'][i])
            print(bucket + str(i))
            time.sleep(6)

def clean_database(connection):
    # Function to remove the images that do not belong in the dataset
    # Relies on Excel doc manually created from image review
    remove_df = pd.read_excel('./remove_images.xlsx')
    tables = ['BILLY_IMAGE_LINKS','NOT_BILLY_IMAGE_LINKS']
    cursor = connection.cursor()

    for table in tables:
        if table == 'NOT_BILLY_IMAGE_LINKS':
            indicies = list(remove_df['not_billies_remove'].values)
            for i in indicies:
                if pd.isna(i):
                    exit
                else:
                    cursor.execute(f"""DELETE FROM {table} WHERE id={int(i)}""")
        else:
            indicies = list(remove_df['billies_to_remove'].values)
            for i in indicies:
                cursor.execute(f"""DELETE FROM {table} WHERE id={int(i)}""")
        connection.commit()

if __name__ == '__main__':
    connection = sqlite3.connect('images.db')
    image_review(connection)
    clean_database(connection)
    connection.close()