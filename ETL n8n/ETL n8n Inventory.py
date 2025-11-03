#Import library pandas for DataFrame manipulation
import pandas as pd

#Change to a DataFrame all items into the file
df = pd.DataFrame([item.json for item in items])

#Removing the wrong data as is loaded with some empty headers, changing the header to the second row
df.columns = df.iloc[0]
df = df[1:]

#Renaming one of the columns
df.rename(columns={'Variantes de Color': 'Variantes de Sabor'}, inplace=True)

#List of the columns to remove from the frame
dropColumns = ['Identificador (No Cambiar)',
'Variantes de Tamaño',
'Variantes de Material',
'Variantes de Estilo',
'Usa Lotes',
'Lote',
'Fabricación del Lote',
'Caducidad del Lote',
'Utiliza Stock',
'Es un Servicio',
'Stock Mínimo ',
'Stock Apartado ',
'Ubicación ',
'Costo',
'Impuestos',
'IVA',
'Se Vende',
'IEPS',
'Clave SAT',
'Receta Médica',
'Catálogo en Línea',
'Unidad de Venta',
'Código de Barras',
'SKU']

#Removing some of the columns from the Frame
df = df.drop(columns=dropColumns).reset_index()

#Returning all rows after cleaning the data
return [{"json": row} for row in df.to_dict(orient="records")]