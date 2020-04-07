import sqlalchemy
from sqlalchemy.sql import text
import pandas as pd

class DatabaseHelper():
    def __init__(self, connection_uri):
        self.connection_uri = connection_uri
        self._db_engine = sqlalchemy.create_engine(connection_uri)
        
    def extract_table_to_pandas(self, tablename, columns= None, limit = None):
        query = "SELECT " + (columns if columns != None else '*') + " FROM {} order by id".format(tablename) + (' limit ' + str(limit) if limit != None else '')
        return self.extract_query_to_pandas(query)
    
    def extract_query_to_pandas(self, query):
        return pd.read_sql(query, self._db_engine)

    def load_df_into_dwh(self, df, tablename, schema):
        return df.to_sql(tablename, self._db_engine, schema=schema, if_exists="replace", index=False)
    
    def run_command(self, command):
        with self._db_engine.connect() as con:
            statement = text("""select version();""")
            con.execute(statement)
                