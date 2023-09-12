import sqlite3
import pandas as pd
import sqlalchemy

try:
    con = sqlite3.connect("database/datos.db")

    # Carga las tablas en un dataframe
    Obligaciones_df = pd.read_sql_query("SELECT * from Obligaciones_clientes", con)
    tasas_productos_df = pd.read_sql_query("SELECT * from tasas_productos", con)

    # Verify that result of SQL query is stored in the dataframe
    print(Obligaciones_df.head())
    print(tasas_productos_df.head())

    # Cambia el tipo de dato para la columna cod_subsegmento y poderla hacer un merge
    tasas_productos_df['cod_subsegmento']= tasas_productos_df['cod_subsegmento'].astype(int)

    # Realizar merge de las tablas Obligaciones_clientes y tasas_productos
    result_df = pd.merge(Obligaciones_df,tasas_productos_df,how='inner',left_on=['cod_segm_tasa','cod_subsegm_tasa','cal_interna_tasa']
            ,right_on=['cod_segmento','cod_subsegmento','calificacion_riesgos'])
    print(result_df.head())

    # selecciona la data por tipo de tasa
    obligacion_tasa = result_df[result_df['id_producto'].str.contains("cartera|Cartera")==True]

    # Escribir el DataFrame a una nueva tabla SQLite y si existe la remplaza
    obligacion_tasa.to_sql("obligacion_tasa", con, if_exists="replace")

    con.close()
except Exception as ex:
    print (ex)