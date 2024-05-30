## Basketball Queries!

#### Completed by Michael Curtis 5/29/2024

### Queries

The SQL Queries are all stored in SQL Script files in the scripts folder. They are named according to the question they are answering.

### How to test

1. Save this directory on your computer and navigate to it
2. Install the python requirements `pip install -r requirements.txt`
3. Create an account for API access key- [Register Here](https://dashboard.api-football.com/register).
4. Copy your access key and paste it in line 7 of `get_data.py`, replacing the `#` with your key.
5. Run `python get_data.py` to retrieve data and create duckdb tables. This may take around a minute to run. I've put in a 5 second sleep in between requests to the api so that our accounts don't get blocked.
6. Run `python run_queries.py` to run the queries on the duckdb and output the results as CSV files.
