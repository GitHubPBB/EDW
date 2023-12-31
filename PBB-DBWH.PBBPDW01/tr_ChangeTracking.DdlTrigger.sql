USE [PBBPDW01]
GO
/****** Object:  DdlTrigger [tr_ChangeTracking]    Script Date: 12/5/2023 5:09:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [tr_ChangeTracking] ON database
for create_procedure,alter_procedure,drop_procedure,create_table,alter_table,drop_table,create_function,alter_function,drop_function,create_view,alter_view
as
	
	SET nocount ON
	
	DECLARE @data     xml
		  ,@recordIt bit = 1

	SET @data = eventdata()
	
	if @data.value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(25)') = 'TABLE'
	and @data.value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(256)') NOT LIKE 'PBB_%'
	    begin
		   set @recordIt = 0
	    end

	if @recordIt = 1
	    begin
		   INSERT INTO dbo.PBB_DBChangelog
								(databasename
								,eventtype
								,objectname
								,objecttype
								,sqlcommand
								,loginname
								,eventdate
								)
		   VALUES
		   (
				@data.value('(/EVENT_INSTANCE/DatabaseName)[1]','varchar(256)')
			    ,@data.value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
			    ,@data.value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(256)')
			    ,@data.value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(25)')
			    ,@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]','varchar(max)')
			    ,@data.value('(/EVENT_INSTANCE/LoginName)[1]','varchar(256)')
			    ,getdate()
		   )
	    end
GO
DISABLE TRIGGER [tr_ChangeTracking] ON DATABASE
GO
