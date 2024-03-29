USE [master]
GO
/****** Object:  Database [TechTestDB]    Script Date: 19/12/2019 9:25:02 AM ******/
CREATE DATABASE [TechTestDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TechTestDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TechTestDB.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TechTestDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TechTestDB_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TechTestDB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TechTestDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TechTestDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TechTestDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TechTestDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TechTestDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TechTestDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TechTestDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TechTestDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TechTestDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TechTestDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TechTestDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TechTestDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TechTestDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TechTestDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TechTestDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TechTestDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TechTestDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TechTestDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TechTestDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TechTestDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TechTestDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TechTestDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TechTestDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TechTestDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TechTestDB] SET  MULTI_USER 
GO
ALTER DATABASE [TechTestDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TechTestDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TechTestDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TechTestDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [TechTestDB] SET DELAYED_DURABILITY = DISABLED 
GO
USE [TechTestDB]
GO
USE [TechTestDB]
GO
/****** Object:  Sequence [dbo].[EMPLOYEEID]    Script Date: 19/12/2019 9:25:03 AM ******/
CREATE SEQUENCE [dbo].[EMPLOYEEID] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE 1
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 19/12/2019 9:25:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Employee](
	[Firstname] [varchar](75) NOT NULL,
	[Lastname] [varchar](75) NOT NULL,
	[DOB] [datetime] NOT NULL,
	[Gender] [varchar](1) NOT NULL,
	[Department] [varchar](75) NOT NULL,
	[Active] [bit] NULL,
	[Created] [datetime] NULL,
	[Id] [bigint] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[CreateEmployee]    Script Date: 19/12/2019 9:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateEmployee]
	@created DATETIME = GETDATE,
	@firstname VARCHAR(75),
	@lastname VARCHAR(75),
	@dob datetime,
	@gender VARCHAR(1),
	@department VARCHAR(75),
	@active BIT = 1
AS
BEGIN
	INSERT INTO dbo.[Employee](Id, [Firstname], [Lastname], [DOB], [Gender], [Department], [Active], [Created]) 
	VALUES(NEXT VALUE FOR EMPLOYEEID, @firstname, @lastname, @dob, @gender, @department, @active, @created)
	DECLARE @id BIGINT = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'EMPLOYEEID')
	SELECT @id AS [CURRENTID]
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteEmployee]    Script Date: 19/12/2019 9:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteEmployee]
	@id BIGINT = 0
AS
BEGIN
	DELETE
	FROM dbo.[Employee]
	WHERE dbo.[Employee].Id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployee]    Script Date: 19/12/2019 9:25:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployee]
	@id BIGINT = 0
AS
BEGIN
	SELECT [Id], [Firstname], [Lastname], [DOB], [Gender], [Department], [Active]
	FROM dbo.[Employee]
	WHERE dbo.[Employee].Id = @id
	ORDER BY [Created] DESC
END

GO
USE [master]
GO
ALTER DATABASE [TechTestDB] SET  READ_WRITE 
GO
