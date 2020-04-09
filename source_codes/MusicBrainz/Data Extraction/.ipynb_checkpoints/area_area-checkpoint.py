import pandas as pd
from dbhelper import DatabaseHelper

class AreaAreas():
    def __init__(self, oltp_uri, stagedb_uri):       
        self._db = DatabaseHelper(oltp_uri)
        self._dw = DatabaseHelper(stagedb_uri)
        
    def etl(self):
        try:
            df = self.__extract()
            transformed_df = self.__transform(df)
            self.__load(transformed_df)
            print('data loaded successfully')
        except Exception as e:
            print('error occured !!' + str(e))
    
    def __extract(self):
        return self._db.extract_table_to_pandas("musicbrainz.l_area_area", columns="id, entity0, entity1")
    
    def __transform(self, df):
        df["main_area_id"] = df["entity0"]
        df["related_area_id"] = df["entity1"]
        df = df.drop('entity0', 1)
        df = df.drop('entity1', 1)
        return df.sort_values(by=['id'], ascending=True)

    def __load(self, transformed_df):
        self._dw.load_df_into_dwh(transformed_df, "dim.area_area", "public")
    
