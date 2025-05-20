import pandas as pd
import mysql.connector

file_path = "Excel_Data.xlsx"  
df = pd.read_excel(file_path, engine="openpyxl")

df = df.where(pd.notnull(df), None)

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "password",
    "database": "excel"
}

conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

table_name = "SG_Companies"

column_definitions = ", ".join([f"`{col}` TEXT" for col in df.columns])
create_table_query = f"CREATE TABLE IF NOT EXISTS `{table_name}` ({column_definitions});"
cursor.execute(create_table_query)

columns = ", ".join([f"`{col}`" for col in df.columns]) 
placeholders = ", ".join(["%s"] * len(df.columns)) 
insert_query = f"INSERT INTO `{table_name}` ({columns}) VALUES ({placeholders})"

for _, row in df.iterrows():
    cursor.execute(insert_query, tuple(row))


conn.commit()
cursor.close()
conn.close()

print("Data successfully exported to MySQL database.")
