﻿/*
Deployment script for Attendance

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "Attendance"
:setvar DefaultFilePrefix "Attendance"
:setvar DefaultDataPath "D:\softwares\ProgramFiles\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "D:\softwares\ProgramFiles\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Attendance].[DepartmentID] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Attendance])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'The following operation was generated from a refactoring log file 26cd3bdf-d637-4845-8b32-947e4ce3f512';

PRINT N'Rename [dbo].[Attendance].[DateTime] to AttendanceDate';


GO
EXECUTE sp_rename @objname = N'[dbo].[Attendance].[DateTime]', @newname = N'AttendanceDate', @objtype = N'COLUMN';


GO
PRINT N'Altering Table [dbo].[Attendance]...';


GO
ALTER TABLE [dbo].[Attendance] DROP COLUMN [DepartmentID];


GO
ALTER TABLE [dbo].[Attendance]
    ADD [isApprove]    BIT        NULL,
        [ApprovedBy]   NCHAR (10) NULL,
        [ApprovedTime] DATETIME   NULL;


GO
PRINT N'Creating Table [dbo].[AttendanceInfo]...';


GO
CREATE TABLE [dbo].[AttendanceInfo] (
    [Id]           INT      NOT NULL,
    [AttendanceID] INT      NULL,
    [InTime]       DATETIME NULL,
    [OutTime]      DATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
-- Refactoring step to update target server with deployed transaction logs
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '26cd3bdf-d637-4845-8b32-947e4ce3f512')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('26cd3bdf-d637-4845-8b32-947e4ce3f512')

GO

GO
PRINT N'Update complete.';


GO
