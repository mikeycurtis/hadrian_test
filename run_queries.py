import duckdb
import pandas as pd

"""
This file will execute all of the sql script files and save the results in csv files.
The result files will be named according to the question it is answering.
"""

# Connect to DuckDB database
con = duckdb.connect("nba_data.duckdb")

# List of query files
query_files = [f"scripts/q{i}.sql" for i in range(1, 7)]

# Execute each query file
for query_file in query_files:
    with open(query_file, "r") as file:
        sql_script = file.read()

    # Execute the SQL script
    con.execute(sql_script)

    result_df = con.df()

    result_df.to_csv(
        query_file.replace("scripts/", "").replace(".sql", ".csv"), index=False
    )
