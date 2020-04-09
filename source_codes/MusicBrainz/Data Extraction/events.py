import pandas as pd
from datetime import datetime
from dateutil.parser import parse
from dbhelper import DatabaseHelper

class Events():
    def __init__(self, oltp_uri, stagedb_uri):       
        self._db = DatabaseHelper(oltp_uri)
        self._dw = DatabaseHelper(stagedb_uri)
        
    def etl(self):
        try:
            df = self.__extract()
            transformed_df = self.__transform(df)
            return self.__load(transformed_df)
            print('data loaded successfully')
        except Exception as e:
            print('error occured !!' + str(e))
    
    def __extract(self):
        return self._db.extract_table_to_pandas("musicbrainz.event", columns="id, gid, begin_date_year, begin_date_month, begin_date_day, end_date_year, end_date_month, end_date_day, time, type, cancelled, ended")
    
    def __transform(self, df):
        df = df[df["gid"] != None]
        df['begin_date_year'] = df.begin_date_year.fillna(0)
        df['end_date_year'] = df.end_date_year.fillna(0)
        df['begin_date_month'] = df.begin_date_month.fillna(0)
        df['end_date_month'] = df.end_date_month.fillna(0)
        
        df = df[df["begin_date_year"] != 0]
        df = df[df["end_date_year"] != 0]
        df = df[df["begin_date_month"] != 0]
        df = df[df["end_date_month"] != 0]
        
        df['begin_date_day'] = df.begin_date_day.fillna(1)
        df['end_date_day'] = df.end_date_day.fillna(1)
            
        df['begin_date_tmp'] = df['begin_date_year'].astype('int64').astype(str) + '/' + df['begin_date_month'].astype('int64').astype(str) + '/' + df['begin_date_day'].astype('int64').astype(str)
        df['begin_date'] = df['begin_date_tmp'].apply(lambda x: parse(x))
        df['begin_date_id'] = df['begin_date'].apply(lambda x: x.strftime('%Y%m%d'))
   
        df['end_date_tmp'] = df['end_date_year'].astype('int64').astype(str) + '/' + df['end_date_month'].astype('int64').astype(str) + '/' + df['end_date_day'].astype('int64').astype(str)
        df['end_date'] = df['end_date_tmp'].apply(lambda x: parse(x))
        df['end_date_id'] = df['end_date'].apply(lambda x: x.strftime('%Y%m%d'))
        
        df['duration'] = df['end_date'] - df['begin_date'] #).dt.days
        
        df = df.drop('begin_date_year', 1)
        df = df.drop('begin_date_month', 1)
        df = df.drop('begin_date_day', 1)
        df = df.drop('begin_date_tmp', 1)
        df = df.drop('begin_date', 1)
        
        df = df.drop('end_date_year', 1)
        df = df.drop('end_date_month', 1)
        df = df.drop('end_date_day', 1)
        df = df.drop('end_date_tmp', 1)
        df = df.drop('end_date', 1)
        
        df.begin_date_id = df.begin_date_id.astype('int64')
        df.end_date_id = df.end_date_id.astype('int64')
        
        return df.sort_values(by=['id'], ascending=True)
            

    def __load(self, transformed_df):      
        self._dw.load_df_into_dwh(transformed_df, "dim.events", "public")
    
