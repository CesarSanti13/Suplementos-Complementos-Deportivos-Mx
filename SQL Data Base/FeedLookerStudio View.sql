CREATE OR REPLACE VIEW FeedLookerStudio AS
SELECT 
    M.nombreMarca AS Marca,
    C.nombreCategoria AS Categoria,
    P.nombreProducto AS Producto,
    DV.cantidad AS Cantidad,
    Cl.seudonimo AS Cliente,
    V.fechaVenta AS FechaVenta,
    DV.costoSnapShotTotal AS CostoTotal,
    DV.totalDetalleVenta AS TotalVenta,
    DV.margen AS Margen,
    DV.montoComision AS Comision,
    DV.margenEmpresa AS MargenEmpresa,
    Di.ciudad AS Ciudad,
    Di.estado AS Estado
FROM DetalleVenta DV
INNER JOIN Producto P ON P.idProducto = DV.idProducto
INNER JOIN Categoria C ON C.idCategoria = P.idCategoria
INNER JOIN Marca M ON M.idMarca = P.idMarca
INNER JOIN Venta V ON V.idVenta = DV.idVenta
INNER JOIN Clientes Cl ON Cl.telefono = V.telefono
LEFT JOIN Direcciones Di ON Di.idDireccion = V.idDireccion;
