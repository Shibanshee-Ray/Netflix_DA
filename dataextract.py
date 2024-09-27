import pandas as pd
import sqlalchemy as sal

# Load the CSV file into a DataFrame
df = pd.read_csv('netflix_titles.csv')

# Create the SQLAlchemy engine and fix the connection string
# Replace 'YOUR_SERVER_NAME' with your actual server name, and make sure it's in the correct format
engine = sal.create_engine('mssql+pyodbc://Shibanshee\SQLEXPRESS/master?driver=ODBC+Driver+17+for+SQL+Server')

# Establish a connection to the database
conn = engine.connect()

# Write the DataFrame to the 'netflix_raw' table in the database (Append if the table exists)
df.to_sql('netflix_raw', con=conn, index=False, if_exists='append')

# Close the connection
conn.close()

# Display the first 5 rows of the DataFrame
print(df.head())

# Filter for the specific show_id
print(df[df.show_id == 's5023'])

# Find the maximum length of the 'description' column after dropping null values
print(max(df.description.dropna().str.len()))

# Check for missing values in each column
print(df.isna().sum())
