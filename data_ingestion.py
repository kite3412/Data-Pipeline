import duckdb
import os

# Path to CSV files
csv_folder = "OLIST"

# List of CSV files to load to DB
csv_files = [
    "customers.csv",
    "geolocation.csv",
    "order_items.csv",
    "order_payments.csv",
    "order_reviews.csv",
    "orders.csv",
    "products.csv",
    "sellers.csv"
    ]

# Connect to DuckDB database file
conn = duckdb.connect("olist.db")

# Loop over each CSV file and create respective table in DuckDB
for csv_file in csv_files:
    table_name = os.path.splitext(csv_file)[0]  # table name = filename without .csv
    csv_path = os.path.join(csv_folder, csv_file)
    
    conn.execute(f"""
        CREATE OR REPLACE TABLE {table_name} AS
        SELECT *
        FROM read_csv_auto('{csv_path}');
    """)

# Confirm the tables were created
tables = conn.execute("SHOW TABLES;").fetchall()
print("Tables in DuckDB:", tables)

# Close the DB connection 
conn.close()
