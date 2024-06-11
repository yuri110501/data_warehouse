import os
import pandas as pd
from sqlalchemy import create_engine

# Configuração da conexão com o banco de dados
user = 'root'
password = '43690'
host = 'localhost'
port = 3306
database = 'db_restaurante_dimensional'
table_name = 'DimMesa'
csv_filename = 'tb_mesa.csv'  # Substitua pelo nome do seu arquivo CSV

# Cria a string de conexão
engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}')

# Caminho para o arquivo CSV
csv_path = r'C:\Users\YURI Lima\Desktop\PROJETO DATA BASE\tb_mesa.csv'

# Lê o arquivo CSV usando pandas
df = pd.read_csv(csv_path)

# Insere os dados no banco de dados
df.to_sql(table_name, con=engine, if_exists='append', index=False)

# Desliga a conexão com o banco
engine.dispose()
