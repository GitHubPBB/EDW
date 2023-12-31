USE [PBBPDW01]
GO
/****** Object:  Table [StgPbbMSCRM].[SalesOrderBase]    Script Date: 12/5/2023 4:42:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [StgPbbMSCRM].[SalesOrderBase](
	[SalesOrderId] [uniqueidentifier] NOT NULL,
	[OpportunityId] [uniqueidentifier] NULL,
	[QuoteId] [uniqueidentifier] NULL,
	[PriorityCode] [int] NULL,
	[SubmitStatus] [int] NULL,
	[SubmitDate] [datetime] NULL,
	[OwningBusinessUnit] [uniqueidentifier] NULL,
	[SubmitStatusDescription] [nvarchar](max) NULL,
	[PriceLevelId] [uniqueidentifier] NULL,
	[LastBackofficeSubmit] [datetime] NULL,
	[OrderNumber] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](300) NULL,
	[PricingErrorCode] [int] NULL,
	[Description] [nvarchar](max) NULL,
	[DiscountAmount] [money] NULL,
	[FreightAmount] [money] NULL,
	[TotalAmount] [money] NULL,
	[TotalLineItemAmount] [money] NULL,
	[TotalLineItemDiscountAmount] [money] NULL,
	[TotalAmountLessFreight] [money] NULL,
	[TotalDiscountAmount] [money] NULL,
	[RequestDeliveryBy] [datetime] NULL,
	[TotalTax] [money] NULL,
	[ShippingMethodCode] [int] NULL,
	[PaymentTermsCode] [int] NULL,
	[FreightTermsCode] [int] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedOn] [datetime] NULL,
	[StateCode] [int] NOT NULL,
	[StatusCode] [int] NULL,
	[ShipTo_Name] [nvarchar](200) NULL,
	[VersionNumber] [int] NULL,
	[ShipTo_Line1] [nvarchar](4000) NULL,
	[ShipTo_Line2] [nvarchar](4000) NULL,
	[ShipTo_Line3] [nvarchar](4000) NULL,
	[ShipTo_City] [nvarchar](80) NULL,
	[ShipTo_StateOrProvince] [nvarchar](50) NULL,
	[ShipTo_Country] [nvarchar](80) NULL,
	[ShipTo_PostalCode] [nvarchar](20) NULL,
	[WillCall] [bit] NULL,
	[ShipTo_Telephone] [nvarchar](50) NULL,
	[BillTo_Name] [nvarchar](200) NULL,
	[ShipTo_FreightTermsCode] [int] NULL,
	[ShipTo_Fax] [nvarchar](50) NULL,
	[BillTo_Line1] [nvarchar](4000) NULL,
	[BillTo_Line2] [nvarchar](4000) NULL,
	[BillTo_Line3] [nvarchar](4000) NULL,
	[BillTo_City] [nvarchar](80) NULL,
	[BillTo_StateOrProvince] [nvarchar](50) NULL,
	[BillTo_Country] [nvarchar](80) NULL,
	[BillTo_PostalCode] [nvarchar](20) NULL,
	[BillTo_Telephone] [nvarchar](50) NULL,
	[BillTo_Fax] [nvarchar](50) NULL,
	[DiscountPercentage] [numeric](23, 10) NULL,
	[BillTo_ContactName] [nvarchar](150) NULL,
	[CampaignId] [uniqueidentifier] NULL,
	[BillTo_AddressId] [uniqueidentifier] NULL,
	[ShipTo_AddressId] [uniqueidentifier] NULL,
	[IsPriceLocked] [bit] NULL,
	[DateFulfilled] [datetime] NULL,
	[ShipTo_ContactName] [nvarchar](150) NULL,
	[UTCConversionTimeZoneCode] [int] NULL,
	[TransactionCurrencyId] [uniqueidentifier] NULL,
	[TimeZoneRuleVersionNumber] [int] NULL,
	[ImportSequenceNumber] [int] NULL,
	[ExchangeRate] [numeric](23, 10) NULL,
	[OverriddenCreatedOn] [datetime] NULL,
	[TotalLineItemAmount_Base] [money] NULL,
	[TotalDiscountAmount_Base] [money] NULL,
	[TotalAmountLessFreight_Base] [money] NULL,
	[TotalAmount_Base] [money] NULL,
	[DiscountAmount_Base] [money] NULL,
	[FreightAmount_Base] [money] NULL,
	[TotalLineItemDiscountAmount_Base] [money] NULL,
	[TotalTax_Base] [money] NULL,
	[CustomerId] [uniqueidentifier] NULL,
	[CreatedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerId] [uniqueidentifier] NOT NULL,
	[ModifiedOnBehalfBy] [uniqueidentifier] NULL,
	[OwnerIdType] [int] NOT NULL,
	[CustomerIdType] [int] NULL,
	[CustomerIdName] [nvarchar](4000) NULL,
	[CustomerIdYomiName] [nvarchar](4000) NULL,
	[StageId] [uniqueidentifier] NULL,
	[EntityImageId] [uniqueidentifier] NULL,
	[ShipTo_Composite] [nvarchar](max) NULL,
	[ProcessId] [uniqueidentifier] NULL,
	[BillTo_Composite] [nvarchar](max) NULL,
	[TraversedPath] [nvarchar](1250) NULL,
	[SLAId] [uniqueidentifier] NULL,
	[LastOnHoldTime] [datetime] NULL,
	[SLAInvokedId] [uniqueidentifier] NULL,
	[OnHoldTime] [int] NULL,
	[chr_BillingDate] [datetime] NULL,
	[chr_ChannelId] [uniqueidentifier] NULL,
	[chr_commitmentdate] [datetime] NULL,
	[chr_CRMOfferingID] [nvarchar](40) NULL,
	[chr_DisconnectReasons] [int] NULL,
	[chr_ExistingOfferingData] [nvarchar](max) NULL,
	[chr_FulfillmentStatus] [uniqueidentifier] NULL,
	[chr_MasterLocationID] [nvarchar](50) NULL,
	[chr_MasterServiceID] [nvarchar](40) NULL,
	[chr_MasterServiceOrderID] [nvarchar](40) NULL,
	[chr_Offering] [nvarchar](max) NULL,
	[chr_OrderCaptureID] [int] NULL,
	[chr_ordertypeid] [uniqueidentifier] NULL,
	[chr_Project] [nvarchar](80) NULL,
	[chr_ProjectManager] [uniqueidentifier] NULL,
	[chr_ProvisioningDate] [datetime] NULL,
	[chr_RegionId] [uniqueidentifier] NULL,
	[chr_SegmentId] [uniqueidentifier] NULL,
	[chr_ServiceLocationId] [uniqueidentifier] NULL,
	[chr_ServiceLocationName] [nvarchar](320) NULL,
	[chr_TechnicianDate] [datetime] NULL,
	[chr_TotalMRC] [money] NULL,
	[chr_totalmrc_Base] [money] NULL,
	[chr_TotalNRC] [money] NULL,
	[chr_totalnrc_Base] [money] NULL,
	[chr_WorkflowId] [uniqueidentifier] NULL,
	[chr_WorkflowInstanceId] [nvarchar](40) NULL,
	[chr_WorkflowStartAttempts] [int] NULL,
	[chr_WorkFlowStatus] [int] NULL,
	[chr_partner_createdbycontact] [uniqueidentifier] NULL,
	[chr_partner_modifiedbycontact] [uniqueidentifier] NULL,
	[chr_partner_partneraccount] [uniqueidentifier] NULL,
	[chr_partner_partnercontact] [uniqueidentifier] NULL,
	[cus_EquipmenttobeReturned] [int] NULL,
	[cus_EquipmentReturnType] [int] NULL,
	[chr_CloseReasonCode] [uniqueidentifier] NULL,
	[chr_CloseReasonDescription] [nvarchar](500) NULL,
	[chr_OrderCreatedBy] [uniqueidentifier] NULL,
	[chr_TotalBilledPartialTax] [money] NULL,
	[chr_totalbilledpartialtax_Base] [money] NULL,
	[chr_totalPartials] [money] NULL,
	[chr_totalpartials_Base] [money] NULL,
	[chr_TotalPrepaidPartials] [money] NULL,
	[chr_totalprepaidpartials_Base] [money] NULL,
	[chr_TotalPrepaidPartialTax] [money] NULL,
	[chr_totalprepaidpartialtax_Base] [money] NULL,
	[chr_TotalPrePaidTax] [money] NULL,
	[chr_totalprepaidtax_Base] [money] NULL,
	[cus_CPELink] [nvarchar](4000) NULL,
	[cus_StaticIPRemoved] [int] NULL,
	[cus_cpelinks] [nvarchar](4000) NULL,
	[cus_CancelOrderTasks] [bit] NULL,
	[cus_Complex] [bit] NULL,
	[cus_Workflow] [uniqueidentifier] NULL,
	[cus_CustomerPON] [nvarchar](100) NULL,
	[cus_HoldforEngineering] [bit] NULL,
	[cus_PlantNeeded] [int] NULL,
	[cus_RelatedOrder] [uniqueidentifier] NULL,
	[cus_SendtoNetworkOperations] [int] NULL,
	[cus_SOC] [uniqueidentifier] NULL,
	[cus_TechnicianNeeded] [bit] NULL,
	[cus_WorkflowDescription] [nvarchar](max) NULL,
	[cus_Project] [uniqueidentifier] NULL,
	[cus_ContractTermLengthInMonths] [int] NULL,
	[cus_AccountGroup] [uniqueidentifier] NULL,
	[chr_AccountChangeOldAccount] [uniqueidentifier] NULL,
	[cus_OrdersId] [uniqueidentifier] NULL,
	[cus_SalesAgent] [uniqueidentifier] NULL,
	[chr_opportunityagencynumber] [nvarchar](4000) NULL,
	[chr_opportunitycontractidcustomer] [nvarchar](4000) NULL,
	[chr_opportunitycontractidvendor] [nvarchar](4000) NULL,
	[chr_opportunitypurchaseorder] [nvarchar](4000) NULL,
	[cus_PortDueDate] [datetime] NULL,
	[cus_EquipmentonOrder] [bit] NULL,
	[cus_EquipmentExistsOnOrder] [int] NULL,
	[cus_EquipmentReturnCase] [uniqueidentifier] NULL,
	[MetaRowKey] [varchar](100) NOT NULL,
	[MetaRowKeyFields] [varchar](100) NOT NULL,
	[MetaRowHash] [varbinary](2000) NOT NULL,
	[MetaSourceSystemCode] [varchar](50) NOT NULL,
	[MetaInsertDatetime] [datetime] NOT NULL,
	[MetaUpdateDatetime] [datetime] NOT NULL,
	[MetaOperationCode] [char](1) NOT NULL,
	[MetaDataQualityStatusId] [varchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
