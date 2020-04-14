import pandas as pd
from dbhelper import DatabaseHelper

class Artists():
    def __init__(self, oltp_uri, stagedb_uri):       
        self._db = DatabaseHelper(oltp_uri)
        self._dw = DatabaseHelper(stagedb_uri)
        
    def etl(self):
        try:
            df = self.__extract()
            #transformed_df = self.__transform(df)
            #self.__load(transformed_df)
            return df
            print('data loaded successfully')
        except Exception as e:
            print('error occured !!' + str(e))
    
    def __extract(self):
        return self._db.extract_table_to_pandas("musicbrainz.artist", columns="id, gid, name, sort_name, type, area, gender, ended")
    
    def __transform(self, df):
        df = df[df["gid"] != None]
        df['type'] = df.type.fillna(0)
        df['area'] = df.type.fillna(0)
        df['gender'] = df.type.fillna(0)
        df["is_active"] =  df.ended.apply(lambda x : not(x))
        df = df.drop('ended', 1)
        return df.sort_values(by=['id'], ascending=True)

    def __load(self, transformed_df):
        self._dw.load_df_into_dwh(transformed_df, "dim.artists", "public")
    
