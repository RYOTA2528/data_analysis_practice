-- 基本操作
model/my_first_python_model.py

def model(dbt, session):
    dbt.config(materialized = "table")

    df = dbt.ref("my_first_dbt_model")  # dbt.ref()SQLモデルでは、Jinjaの同等の関数とdbt.source()同様

    return df

