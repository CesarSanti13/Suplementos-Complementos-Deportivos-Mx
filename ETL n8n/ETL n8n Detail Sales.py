#Import library pandas for DataFrame manipulation
import pandas as pd

#Change to a DataFrame all items into the file
df = pd.DataFrame([item.json for item in items])

#Repleacing the # for empty for has just the number of trade
df['Número de Venta'] = df['Número de Venta'].astype(str).str.replace('#', '', regex=False)

#Renaming the column for be clear and easy to understand
df.rename(columns={'Número de Venta': 'idVenta'}, inplace=True)

#Getting the items that just are with out "local" words into the Cliente
df = df[~df['Cliente'].str.contains('Local', case=False, na=False)]
df = df[~df['Categoria'].str.contains('Suplementos', case=False, na=False)]

#Changing to the correct format that SQL supports
df['Fecha'] = pd.to_datetime(df['Fecha'], dayfirst=True, errors='coerce').dt.strftime('%Y-%m-%d %H:%M:%S')

#Adding extra column for have the cost Snapshot for right analysis
df['costoSnapshot'] = df['Costo'] / df['Cantidad'] 

#Returning all rows after cleaning the data
return [{"json": row} for row in df.to_dict(orient="records")]