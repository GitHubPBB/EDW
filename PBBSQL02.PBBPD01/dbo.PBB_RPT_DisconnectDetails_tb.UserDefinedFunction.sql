USE [PBBPDW01]
GO
/****** Object:  UserDefinedFunction [dbo].[PBB_RPT_DisconnectDetails_tb]    Script Date: 12/5/2023 4:42:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[PBB_RPT_DisconnectDetails_tb](
			@ReportStartDate date
		   ,@ReportEndDate date
			)
RETURNS @DiscoDetails TABLE 
([Date] Date
,Market Varchar(50)
,BundleType Varchar(50)
,AccountGroup Varchar(50)
,AccountCode Int
,CustomerName Varchar(100)
,CurrentAccountStatus Varchar(50)
,ActivationDate Date
,DeactivationDate Date
,Tenure Int
,ReconnectedServices varchar(1)
,NonPayCountLast6Months tinyint
,PaidInvoicesLast6Months tinyint
,PartialPaidInvoicesLast6Months tinyint
,PTPLast6Months tinyint
,ServiceLocationFullAdress varchar(200)
,Latitude decimal(11,2)
,Longitude decimal(11,2)
,ProjectName varchar(50)
,DisconnectOrderNumber varchar(50)
,DisconnectOrderName   varchar(200)
,DisconnectOrderChannel varchar(50)
,DisconnectOrderSegment varchar(10)
,DisconnectReason varchar(50)
,DisconnectCreateDate date
,DisoOrderBillReviewDate date
,PortalUserExists varchar(1)
,PrintGroup varchar(20)
,PaymentMethod varchar(20)
,Orig_InstallType varchar(20)
,Orig_InstallOrderNumber varchar(50)
,Orig_InstallOrderName varchar(200)
,Orig_InstallOrderChannel varchar(50)
,Orig_InstallOrderSegment varchar(10)
,Orig_InstallOrderOwner varchar(50)
,SalesAgent varchar(50)
,Orig_InstallOrderBillReviewDate date
)
AS
BEGIN
 

    Declare @ME_Date date;

	SELECT @ME_Date = EOMONTH(@ReportStartDate,0);

	INSERT INTO @DiscoDetails
	SELECT [Date],
	Market,
	BundleType,
	AccountGroup,
	NP.AccountCode,
	CustomerName,
	CurrentAccountStatus,
	ActivationDate,
	DeactivationDate,
	Tenure,
	ReconnectedServices,
	isnull(NonPayCountLast6Months,0) NonPayCountLast6Months,
	isnull(PaidInvoicesLast6Months,0) PaidInvoicesLast6Months,
	isnull(PartialPaidInvoicesLast6Months,0) PartialPaidInvoicesLast6Months,
	isnull(PTP.PTPCount,0) PTPLast6Months,
	ServiceLocationFullAddress,
	Latitude,
	Longitude,
	ProjectName,
	DisconnectOrderNumber,
	DisconnectorderName,
	DisconnectOrderChannel,
	DisconnectOrderSegment,
	DisconnectReason,
	DisconnectCreateDate,
	DiscoOrderBillReviewDate,
	PortalUserExists,
	PrintGroup,
	case when [Recurring Payment Method] = '' then 'Other' else [Recurring Payment Method] end as [Payment Method],
	Orig_InstallType,
	Orig_InstallOrderNumber,
	Orig_InstallOrderName,
	Orig_InstallOrderChannel,
	Orig_InstallOrderSegment,
	Orig_InstallOrderOwner,
	SalesAgent,
	Orig_InstallOrderBillReviewDate
	FROM PBB_DisconnectDetails(@ME_Date) NP
	LEFT JOIN
	(
	SELECT AccountCode,
	COUNT(PromiseDate) PTPCount
	FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount AS AA WITH(NOLOCK)
	INNER JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP WITH(NOLOCK) ON AA.AccountID = PTP.AccountID
	WHERE PTP.PromiseDate BETWEEN(DATEADD(month, -6, GETDATE())) AND GETDATE()
	GROUP BY accountcode
	) PTP ON np.accountcode = ptp.accountcode

	
	Declare @StartYearMo INT;
	Declare @EndYearMo   INT;
	Declare @OrigStartDate date = @ReportStartDate;
	
	SELECT @StartYearMo = cast(concat(YEAR(@ReportStartDate), right(concat('0',MONTH(@ReportStartDate)),2)) as int)
	SELECT @EndYearMo   = cast(concat(YEAR(@ReportEndDate)  , right(concat('0',MONTH(@ReportEndDate)),2))   as int)



	WHILE @StartYearMo < @EndYearMo
	BEGIN
	
		SELECT @ReportStartDate = dateadd(mm,1,@ReportStartDate)
		SELECT @StartYearMo     = cast(concat(YEAR(@ReportStartDate), right(concat('0',MONTH(@ReportStartDate)),2)) as int)
		SELECT @ME_Date         = EOMONTH(@ReportStartDate,0);

		INSERT INTO @DiscoDetails
		SELECT [Date],
		Market,
		BundleType,
		AccountGroup,
		NP.AccountCode,
		CustomerName,
		CurrentAccountStatus,
		ActivationDate,
		DeactivationDate,
		Tenure,
		ReconnectedServices,
		isnull(NonPayCountLast6Months,0) NonPayCountLast6Months,
		isnull(PaidInvoicesLast6Months,0) PaidInvoicesLast6Months,
		isnull(PartialPaidInvoicesLast6Months,0) PartialPaidInvoicesLast6Months,
		isnull(PTP.PTPCount,0) PTPLast6Months,
		ServiceLocationFullAddress,
		Latitude,
		Longitude,
		ProjectName,
		DisconnectOrderNumber,
		DisconnectorderName,
		DisconnectOrderChannel,
		DisconnectOrderSegment,
		DisconnectReason,
		DisconnectCreateDate,
		DiscoOrderBillReviewDate,
		PortalUserExists,
		PrintGroup,
		case when [Recurring Payment Method] = '' then 'Other' else [Recurring Payment Method] end as [Payment Method],
		Orig_InstallType,
		Orig_InstallOrderNumber,
		Orig_InstallOrderName,
		Orig_InstallOrderChannel,
		Orig_InstallOrderSegment,
		Orig_InstallOrderOwner,
		SalesAgent,
		Orig_InstallOrderBillReviewDate
		FROM PBB_DisconnectDetails(@ME_Date) NP
		LEFT JOIN
		(
		SELECT AccountCode,
		COUNT(PromiseDate) PTPCount
		FROM pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArAccount AS AA WITH(NOLOCK)
		INNER JOIN pbbsql01.omnia_epbb_p_pbb_ar.dbo.ArPromiseToPay AS PTP WITH(NOLOCK) ON AA.AccountID = PTP.AccountID
		WHERE PTP.PromiseDate BETWEEN(DATEADD(month, -6, GETDATE())) AND GETDATE()
		GROUP BY accountcode
		) PTP ON np.accountcode = ptp.accountcode

	END

	DELETE FROM @DiscoDetails WHERE DisconnectCreateDate < @OrigStartDate;
	DELETE FROM @DiscoDetails WHERE DisconnectCreateDate > @ReportEndDate;

	


    RETURN 
END;

GO
