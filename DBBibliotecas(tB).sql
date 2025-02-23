USE [DBBiblioteca]
GO
/****** Object:  User [Luis]    Script Date: 14/04/2024 8:41:43 p. m. ******/
CREATE USER [Luis] FOR LOGIN [Luis] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DiasRetraso]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_DiasRetraso]
(
    @FechaDevolucion DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @DiasRetraso INT;

    SET @DiasRetraso = DATEDIFF(DAY, @FechaDevolucion, GETDATE());

    RETURN CASE
        WHEN @DiasRetraso > 0 THEN @DiasRetraso
        ELSE 0
    END;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_MaximoValorMaterial]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_MaximoValorMaterial]()
RETURNS INT
AS
BEGIN
    DECLARE @MaximoValor INT;

    SELECT @MaximoValor = MAX(ValorMaterial)
    FROM tblMaterial;

    RETURN @MaximoValor;
END;
GO
/****** Object:  Table [dbo].[tblMaterial]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMaterial](
	[Cod_material] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_material] [varchar](30) NOT NULL,
	[ValorMaterial] [int] NOT NULL,
	[añoMaterial] [int] NOT NULL,
	[CodTipo_Material] [int] NOT NULL,
	[CantidadMaterial] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_MaterialesValorAlto]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_MaterialesValorAlto] AS
SELECT *
FROM tblMaterial
WHERE ValorMaterial >= 50000;
GO
/****** Object:  Table [dbo].[tblTipo_Material]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTipo_Material](
	[CodTipo_Material] [int] IDENTITY(1,1) NOT NULL,
	[NombreTipo_Material] [varchar](30) NOT NULL,
	[CantidadTipo_Material] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipo_Material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_MaterialesPrecioAlto]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_MaterialesPrecioAlto] AS
SELECT *
FROM tblMaterial
WHERE ValorMaterial > (
    SELECT MAX(ValorMaterial)
    FROM tblMaterial
    WHERE CodTipo_Material IN (
        SELECT CodTipo_Material
        FROM tblTipo_Material
        WHERE NombreTipo_Material IN ('Audiovisual', 'Revistas')
    )
);
GO
/****** Object:  UserDefinedFunction [dbo].[fn_BuscarMaterialPorTitulo]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_BuscarMaterialPorTitulo]
(
    @TituloMaterial VARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM tblMaterial
    WHERE Nombre_material = @TituloMaterial
);
GO
/****** Object:  Table [dbo].[tbldependencia]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbldependencia](
	[Cod_Dependencia] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_Dependencia] [varchar](30) NOT NULL,
	[Ubicacion] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Dependencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblDevolucion]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDevolucion](
	[Cod_Devolucion] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Devolucion] [datetime] NOT NULL,
	[Num_Prestamo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Devolucion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEjemplar]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEjemplar](
	[Num_Ejemplar] [int] IDENTITY(1,1) NOT NULL,
	[Cod_Material] [int] NOT NULL,
	[estadoEjemplar] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Ejemplar] ASC,
	[Cod_Material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPertenece]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPertenece](
	[Cedula_Usuario] [int] NOT NULL,
	[Cod_Dependencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cedula_Usuario] ASC,
	[Cod_Dependencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPrestamo]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPrestamo](
	[Cod_Prestamo] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Entrega] [datetime] NOT NULL,
	[Fecha_Devolucion] [datetime] NOT NULL,
	[Cod_Material] [int] NOT NULL,
	[Num_Ejemplar] [int] NOT NULL,
	[Cedula_Usuario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Prestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReserva]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReserva](
	[Cod_reserva] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Cedula_Usuario] [int] NOT NULL,
	[Cod_Material] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_reserva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTipo_Usuario]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTipo_Usuario](
	[Cod_tipo] [int] IDENTITY(1,1) NOT NULL,
	[Nom_Tipo] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblusuario]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblusuario](
	[Cedula_Usuario] [int] NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[telefono] [int] NOT NULL,
	[Direccion] [varchar](30) NOT NULL,
	[Cod_TipoUsuario] [int] NOT NULL,
	[Estado_Usuario] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cedula_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDevolucion] ADD  DEFAULT (getdate()) FOR [Fecha_Devolucion]
GO
ALTER TABLE [dbo].[tblPrestamo] ADD  DEFAULT (getdate()) FOR [Fecha_Entrega]
GO
ALTER TABLE [dbo].[tblReserva] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[tblDevolucion]  WITH CHECK ADD FOREIGN KEY([Num_Prestamo])
REFERENCES [dbo].[tblPrestamo] ([Cod_Prestamo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblEjemplar]  WITH CHECK ADD FOREIGN KEY([Cod_Material])
REFERENCES [dbo].[tblMaterial] ([Cod_material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD FOREIGN KEY([CodTipo_Material])
REFERENCES [dbo].[tblTipo_Material] ([CodTipo_Material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPertenece]  WITH CHECK ADD FOREIGN KEY([Cedula_Usuario])
REFERENCES [dbo].[tblusuario] ([Cedula_Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPertenece]  WITH CHECK ADD FOREIGN KEY([Cod_Dependencia])
REFERENCES [dbo].[tbldependencia] ([Cod_Dependencia])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPrestamo]  WITH CHECK ADD FOREIGN KEY([Cedula_Usuario])
REFERENCES [dbo].[tblusuario] ([Cedula_Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPrestamo]  WITH CHECK ADD FOREIGN KEY([Num_Ejemplar], [Cod_Material])
REFERENCES [dbo].[tblEjemplar] ([Num_Ejemplar], [Cod_Material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblReserva]  WITH CHECK ADD FOREIGN KEY([Cedula_Usuario])
REFERENCES [dbo].[tblusuario] ([Cedula_Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblReserva]  WITH CHECK ADD FOREIGN KEY([Cod_Material])
REFERENCES [dbo].[tblMaterial] ([Cod_material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblusuario]  WITH CHECK ADD FOREIGN KEY([Cod_TipoUsuario])
REFERENCES [dbo].[tblTipo_Usuario] ([Cod_tipo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblEjemplar]  WITH CHECK ADD CHECK  (([estadoEjemplar]='Prestado' OR [estadoEjemplar]='Disponible' OR [estadoEjemplar]='En reparacion' OR [estadoEjemplar]='Reservado'))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([añoMaterial]>=(1930) AND [añoMaterial]<=(2012)))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([cantidadMaterial]>=(1) AND [cantidadMaterial]<=(20)))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([ValorMaterial]>=(1000) AND [ValorMaterial]<=(200000)))
GO
/****** Object:  StoredProcedure [dbo].[sp_ActualizarMaterial]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ActualizarMaterial]
    @CodMaterial INT,
    @NombreMaterial VARCHAR(30),
    @ValorMaterial INT,
    @AñoMaterial INT,
    @CodTipoMaterial INT,
    @CantidadMaterial INT
AS
BEGIN
    UPDATE tblMaterial
    SET Nombre_material = @NombreMaterial,
        ValorMaterial = @ValorMaterial,
        añoMaterial = @AñoMaterial,
        CodTipo_Material = @CodTipoMaterial,
        CantidadMaterial = @CantidadMaterial
    WHERE Cod_material = @CodMaterial;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_BorrarPrestamo]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BorrarPrestamo]
    @CodPrestamo INT
AS
BEGIN
    DELETE FROM tblPrestamo
    WHERE Cod_Prestamo = @CodPrestamo;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertarMaterial]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertarMaterial]
    @NombreMaterial VARCHAR(30),
    @ValorMaterial INT,
    @AñoMaterial INT,
    @CodTipoMaterial INT,
    @CantidadMaterial INT
AS
BEGIN
    INSERT INTO tblMaterial (Nombre_material, ValorMaterial, añoMaterial, CodTipo_Material, CantidadMaterial)
    VALUES (@NombreMaterial, @ValorMaterial, @AñoMaterial, @CodTipoMaterial, @CantidadMaterial);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_MaterialesPorValor]    Script Date: 14/04/2024 8:41:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MaterialesPorValor]
    @ValorMinimo INT
AS
BEGIN
    SELECT *
    FROM tblMaterial
    WHERE ValorMaterial > @ValorMinimo;
END;
GO
