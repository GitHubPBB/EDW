USE [PBBPDW01]
GO
/****** Object:  StoredProcedure [info].[GetTableScript]    Script Date: 12/5/2023 4:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --SELECT * from [POINTBROADBAND.CHANGEGEARCLOUD.COM,10033].[ChangeGear].information_schema.columns where table_name = 'VCG_ServiceRequest_Grid_View'  order by ordinal_position;


 CREATE  proc [info].[GetTableScript] (  @table sysname  )
as
declare @sql table(s varchar(1000), id int identity)
 

insert into  @sql(s) values ('create table [' + @table + '] (')
 

insert into @sql(s)
select 
    '  ['+column_name+'] ' + 
    data_type + coalesce('('+cast(character_maximum_length as varchar)+')','') + ' ' +
    case when exists ( 
        select id from syscolumns
        where object_name(id)=@table
        and name=column_name
        and columnproperty(id,name,'IsIdentity') = 1 
    ) then
        'IDENTITY(' + 
        cast(ident_seed(@table) as varchar) + ',' + 
        cast(ident_incr(@table) as varchar) + ')'
    else ''
    end + ' ' +
    ( case when IS_NULLABLE = 'No' then 'NOT ' else '' end ) + 'NULL ' + 
    coalesce('DEFAULT '+COLUMN_DEFAULT,'') + ','
 
 from information_schema.columns where table_name = @table
 order by ordinal_position
 

declare @pkname varchar(100)
select @pkname = constraint_name from information_schema.table_constraints
where table_name = @table and constraint_type='PRIMARY KEY'
 
if ( @pkname is not null ) begin
    insert into @sql(s) values('  PRIMARY KEY (')
    insert into @sql(s)
        select '   ['+COLUMN_NAME+'],' from information_schema.key_column_usage
        where constraint_name = @pkname
        order by ordinal_position

    update @sql set s=left(s,len(s)-1) where id=@@identity
    insert into @sql(s) values ('  )')
end
else begin

    update @sql set s=left(s,len(s)-1) where id=@@identity
end
 
insert into @sql(s) values( ')' )
 
select s from @sql order by id
GO
