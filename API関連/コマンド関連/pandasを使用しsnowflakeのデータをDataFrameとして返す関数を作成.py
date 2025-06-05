def load_dataframe(table_name: str) -> pd.DataFrame:
    import snowflake.connector
    import pandas as pd

    conn = snowflake.connector.connect(
        user='YOUR_USER',
        password='YOUR_PASSWORD',
        account='YOUR_ACCOUNT',
        warehouse='YOUR_WH',
        database='YOUR_DB',
        schema='YOUR_SCHEMA'
    )

    query = f"SELECT * FROM {table_name}"
    df = pd.read_sql(query, conn)
    conn.close()
    return df