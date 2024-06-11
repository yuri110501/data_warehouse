import pandas as pd
from sqlalchemy import create_engine

# Configuração da conexão com o banco de dados
user = 'root'
password = '43690'
host = 'localhost'
port = 3306
database = 'db_restaurante_dimensional'
table_name = 'DimDataHora'
csv_filename = 'data_hora.csv'

# Criando a string de conexão com o banco de dados
engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}')

# Caminho para o arquivo CSV
csv_path = r'C:\Users\YURI Lima\Desktop\PROJETO DATA BASE\data_hora.csv'

# Lendo o arquivo CSV usando pandas
df = pd.read_csv(csv_path)

# Inserindo os dados no banco de dados
df.to_sql(table_name, con=engine, if_exists='append', index=False)

# Fechando a conexão com o banco de dados
engine.dispose()
