#Import library pandas for DataFrame manipulation
import pandas as pd

#Change to a DataFrame all items into the file
df = pd.DataFrame([item.json for item in items])

#Repleacing the # for empty for has just the number of trade
df['Número de venta'] = df['Número de venta'].astype(str).str.replace('#', '', regex=False)

#Renaming the column for be clear and easy to understand
df.rename(columns={'Número de venta': 'idVenta'}, inplace=True)
df.rename(columns={'Descuento': 'Descuento Global'}, inplace=True)

#Making constant idVendedor because there is just 1 seller
df['idVendedor'] = 1

#Casting in to a int number the idVenta for easy add
df['idVenta'] = df['idVenta'].astype(int)

#Getting the items that just are with out "local" words into the Cliente
df = df[~df['Cliente'].str.contains('Local', case=False, na=False)]

#Changing to the correct format that SQL supports
df['Fecha'] = pd.to_datetime(df['Fecha'], dayfirst=True, errors='coerce').dt.strftime('%Y-%m-%d %H:%M:%S')

#Returning all rows after cleaning the data
return [{"json": row} for row in df.to_dict(orient="records")]