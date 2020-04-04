import pandas as pd
from dbhelper import DatabaseHelper

class PlaceTypes():
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
        return self._db.extract_table_to_pandas("musicbrainz.place_type", columns="id, name, parent, child_order")
    
    def __transform(self, df):
        top_row = pd.DataFrame({'id':[0],'name':['Unknown'],'parent':[None], 'child_order': [0]})
        df = pd.concat([top_row, df]).reset_index(drop = True) #Trick to add row to the line of base data framw
        return df.sort_values(by=['id'], ascending=True)

    def __load(self, transformed_df):
        self._dw.load_df_into_dwh(transformed_df, "dim.place_types", "public")
    
