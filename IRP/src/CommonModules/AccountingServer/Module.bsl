
Function GetOperationsDefinition()
	Map = New Map();
	AO = Catalogs.AccountingOperations;
	// Bank payment
	Map.Insert(AO.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B , New Structure("ByRow", True));
	Map.Insert(AO.BankPayment_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand , New Structure("ByRow", True));
	
	// Bank receipt
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.BankReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers , New Structure("ByRow", True));
	
	// Purchase invoice
	//
	// receipt inventory
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions , New Structure("ByRow", True));
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation , New Structure("ByRow", True));
	// offset of advabces
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", False));
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation , New Structure("ByRow", False));
	
	Map.Insert(AO.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions , New Structure("ByRow", True));
	
	// Sales invoice
	//
	// sales inventory
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation , New Structure("ByRow", True));
	// offset of advances
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions , New Structure("ByRow", False));
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation , New Structure("ByRow", False));
	
	Map.Insert(AO.SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming , New Structure("ByRow", True));
	Map.Insert(AO.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory , New Structure("ByRow", True));
	
	// Retail sales receipt
	Map.Insert(AO.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory , New Structure("ByRow", True));

	// Foreign currency revaluation
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues , New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers , New Structure("ByRow, RequestTable", True, True));
	

	Return Map;
EndFunction

Function GetSupportedDocuments() Export
	ArrayOfDocuments = New Array();
	Docs = Metadata.Documents;
	ArrayOfDocuments.Add(Docs.BankPayment);	
	ArrayOfDocuments.Add(Docs.BankReceipt);	
	ArrayOfDocuments.Add(Docs.PurchaseInvoice);	
	ArrayOfDocuments.Add(Docs.RetailSalesReceipt);
	ArrayOfDocuments.Add(Docs.SalesInvoice);
	Return ArrayOfDocuments;
EndFunction

#Region Service

Function GetAccountingAnalyticsResult(Parameters) Export
	AccountingAnalytics = New Structure();
	AccountingAnalytics.Insert("Operation" , Parameters.Operation);
	AccountingAnalytics.Insert("LedgerType", Parameters.LedgerType);
	
	// Debit
	AccountingAnalytics.Insert("Debit", Undefined);
	AccountingAnalytics.Insert("DebitExtDimensions", New Array());
	
	// Credit
	AccountingAnalytics.Insert("Credit", Undefined);
	AccountingAnalytics.Insert("CreditExtDimensions", New Array());
	Return AccountingAnalytics;
EndFunction

Function GetAccountingDataResult()
	Result = New Structure();
	Result.Insert("CurrencyDr", Undefined);
	Result.Insert("CurrencyAmountDr", 0);
	Result.Insert("CurrencyCr", Undefined);
	Result.Insert("CurrencyAmountCr", 0);
	
	Result.Insert("QuantityDr", 0);
	Result.Insert("QuantityCr", 0);
	
	Result.Insert("Amount", 0);
	Return Result;
EndFunction

Function IsAdvance(RowData) Export
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	If RowData.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments
		And Not ValueIsFilled(RowData.BasisDocument) Then
			Return True;
	EndIf;
	Return False; // IsTransaction
EndFunction

Procedure SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintDebitExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Procedure SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintCreditExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Function ExtractValueByType(ObjectData, RowData, ArrayOfTypes, AdditionalAnalyticsValues)
	If AdditionalAnalyticsValues <> Undefined Then
		For Each KeyValue In AdditionalAnalyticsValues Do
			If ArrayOfTypes.Find(TypeOf(AdditionalAnalyticsValues[KeyValue.Key])) <> Undefined Then
				Return AdditionalAnalyticsValues[KeyValue.Key];
			EndIf;
		EndDo;	
	EndIf;

	If RowData <> Undefined Then
		If TypeOf(RowData) = Type("ValueTableRow") Then
			For Each RowItem In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowItem)) <> Undefined Then
					Return RowItem;
				EndIf;
			EndDo;
		ElsIf TypeOf(RowData) = Type("Structure") Then	
			For Each KeyValue In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowData[KeyValue.Key])) <> Undefined Then
					Return RowData[KeyValue.Key];
				EndIf;
			EndDo;
		Else
			Raise "Unsupported type of row data";
		EndIf;
	EndIf;
	
	For Each KeyValue In ObjectData Do
		If ArrayOfTypes.Find(TypeOf(ObjectData[KeyValue.Key])) <> Undefined Then
			Return ObjectData[KeyValue.Key];
		EndIf;
	EndDo;
	
	
	Return Undefined;
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, AnalyticRow) Export
	If Not ValueIsFilled(AnalyticRow.AccountDebit) Or Not ValueIsFilled(AnalyticRow.AccountCredit) Then
		Return GetAccountingDataResult();
	EndIf;
	Parameters = New Structure();
	Parameters.Insert("Recorder" , BasisRef);
	Parameters.Insert("RowKey"   , AnalyticRow.Key);
	Parameters.Insert("Operation", AnalyticRow.Operation);
	Parameters.Insert("CurrencyMovementType", AnalyticRow.LedgerType.CurrencyMovementType);
	Data = GetAccountingData(Parameters);
	
	Result = GetAccountingDataResult();
	
	If Data = Undefined Then
		Return Result;
	EndIf;
	
	If Data.Property("CurrencyDr") Then
		Result.CurrencyDr = Data.CurrencyDr;
	EndIf;

	If Data.Property("CurrencyAmountDr") Then
		Result.CurrencyAmountDr = Data.CurrencyAmountDr;
	EndIf;

	If Data.Property("CurrencyCr") Then
		Result.CurrencyCr = Data.CurrencyCr;
	EndIf;

	If Data.Property("CurrencyAmountCr") Then
		Result.CurrencyAmountCr = Data.CurrencyAmountCr;
	EndIf;

	If Data.Property("QuantityDr") Then
		Result.QuantityDr = Data.QuantityDr;
	EndIf;

	If Data.Property("QuantityCr") Then
		Result.QuantityCr = Data.QuantityCr;
	EndIf;

	If Data.Property("Amount") Then
		Result.Amount = Data.Amount;
	EndIf;
	Return Result;	
EndFunction

Function GetLedgerTypesByCompany(Ref, Date, Company) Export
	If Not ValueIsFilled(Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLedgerTypesSliceLast.LedgerType
	|FROM
	|	InformationRegister.CompanyLedgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLedgerTypesSliceLast
	|WHERE
	|	CompanyLedgerTypesSliceLast.Use";
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period" , Period);
	Query.SetParameter("Company", Company);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	Return ArrayOfLedgerTypes;
EndFunction

Function GetAccountingOperationsByLedgerType(Ref, Period, LedgerType) Export
	OperationsDefinition = GetOperationsDefinition();
	MetadataName = Ref.Metadata().Name;
	AccountingOperationGroup = Catalogs.AccountingOperations["Document_" + MetadataName];
	Query = New Query();
	Query.Text =
	"SELECT
	|	LedgerTypeOperationsSliceLast.AccountingOperation AS AccountingOperation
	|FROM
	|	InformationRegister.LedgerTypeOperations.SliceLast(&Period, LedgerType = &LedgerType
	|	AND AccountingOperation.Parent = &AccountingOperationGroup) AS LedgerTypeOperationsSliceLast
	|WHERE
	|	LedgerTypeOperationsSliceLast.Use";
	Query.SetParameter("Period", Period);
	Query.SetParameter("LedgerType", LedgerType);
	Query.SetParameter("AccountingOperationGroup", AccountingOperationGroup);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfAccountingOperations = New Array();
	While QuerySelection.Next() Do
		Def = OperationsDefinition.Get(QuerySelection.AccountingOperation);
		ByRow = ?(Def = Undefined, False, Def.ByRow);
		RequestTable = False;
		If Def <> Undefined And Def.Property("RequestTable") Then
			RequestTable = Def.RequestTable;
		EndIf;
		ArrayOfAccountingOperations.Add(New Structure("Operation, ByRow, RequestTable, MetadataName",
			QuerySelection.AccountingOperation, ByRow, RequestTable, MetadataName));
	EndDo;
	Return ArrayOfAccountingOperations;
EndFunction

Function GetLedgerTypeVariants() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypeVariants.Ref
	|FROM
	|	Catalog.LedgerTypeVariants AS LedgerTypeVariants
	|WHERE
	|	NOT LedgerTypeVariants.DeletionMark";
	QueryResult = Query.Execute();
	Result = New Array();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Result.Add(QuerySelection.Ref);
	EndDo;
	Return Result;
EndFunction

#EndRegion

#Region Accounts

Function GetAccountParameters(Parameters) Export
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);
	AccountParameters = New Structure();
	AccountParameters.Insert("Period", Period);
	AccountParameters.Insert("Company", Parameters.ObjectData.Company);
	AccountParameters.Insert("LedgerTypeVariant", Parameters.LedgerType.Variant);
	Return AccountParameters;
EndFunction

Function GetT9010S_AccountsItemKey(AccountParameters, ItemKey) Export
	Return AccountingServerReuse.GetT9010S_AccountsItemKey_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ItemKey);
EndFunction

Function __GetT9010S_AccountsItemKey(Period, Company, LedgerTypeVariant, ItemKey) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByItemKey.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND ItemKey = &ItemKey
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL) AS ByItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	ByItem.Account,
	|	2
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND ItemKey.Ref IS NULL
	|	AND Item = &Item
	|	AND ItemType.Ref IS NULL) AS ByItem
	|
	|UNION ALL
	|
	|SELECT
	|	ByItemType.Account,
	|	3
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType = &ItemType) AS ByItemType
	|
	|UNION ALL
	|
	|SELECT
	|	ByType.Account,
	|	4
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType = &TypeOfItemType) AS ByType
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	5
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("Variant"  , LedgerTypeVariant);
	Query.SetParameter("ItemKey"  , ItemKey);
	Query.SetParameter("Item"     , ItemKey.Item);
	Query.SetParameter("ItemType" , ItemKey.Item.ItemType);
	Query.SetParameter("TypeOfItemType" , ItemKey.Item.ItemType.Type);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9011S_AccountsCashAccount(AccountParameters, CashAccount) Export
	Return AccountingServerReuse.GetT9011S_AccountsCashAccount_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		CashAccount);
EndFunction

Function __GetT9011S_AccountsCashAccount(Period, Company, LedgerTypeVariant, CashAccount) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByCashAccount.Company,
	|	ByCashAccount.CashAccount,
	|	ByCashAccount.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND CashAccount = &CashAccount) AS ByCashAccount
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.CashAccount,
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND Variant = &Variant
	|	AND CashAccount.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.CashAccount,
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"      , Period);
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("Variant"     , LedgerTypeVariant);
	Query.SetParameter("CashAccount" , CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9012S_AccountsPartner(AccountParameters, Partner, Agreement) Export
	Return AccountingServerReuse.GetT9012S_AccountsPartner_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant,
		Partner, Agreement);
EndFunction

Function __GetT9012S_AccountsPartner(Period, Company, LedgerTypeVariant, Partner, Agreement) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByAgreement.AccountAdvancesVendor,
	|	ByAgreement.AccountTransactionsVendor,
	|	ByAgreement.AccountAdvancesCustomer,
	|	ByAgreement.AccountTransactionsCustomer,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesVendor,
	|	ByPartner.AccountTransactionsVendor,
	|	ByPartner.AccountAdvancesCustomer,
	|	ByPartner.AccountTransactionsCustomer,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesVendor,
	|	ByCompany.AccountTransactionsVendor,
	|	ByCompany.AccountAdvancesCustomer,
	|	ByCompany.AccountTransactionsCustomer,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.AccountAdvancesVendor,
	|	Accounts.AccountTransactionsVendor,
	|	Accounts.AccountAdvancesCustomer,
	|	Accounts.AccountTransactionsCustomer,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("Variant"   , LedgerTypeVariant);
	Query.SetParameter("Partner"   , Partner);
	Query.SetParameter("Agreement" , Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure();
	Result.Insert("AccountAdvancesVendor"        , Undefined);
	Result.Insert("AccountTransactionsVendor"    , Undefined);
	Result.Insert("AccountAdvancesCustomer"      , Undefined);
	Result.Insert("AccountTransactionsCustomer" , Undefined);

	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetT9013S_AccountsTax(AccountParameters, Tax) Export
	Return AccountingServerReuse.GetT9013S_AccountsTax_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		Tax);	
EndFunction

Function __GetT9013S_AccountsTax(Period, Company, LedgerTypeVariant, Tax) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByTax.Company,
	|	ByTax.Tax,
	|	ByTax.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND Tax = &Tax) AS ByTax
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.Tax,
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND Tax.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.Tax,
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("Variant" , LedgerTypeVariant);
	Query.SetParameter("Tax"     , Tax);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9014S_AccountsExpenseRevenue(AccountParameters, ExpenseRevenue) Export
	Return __GetT9014S_AccountsExpenseRevenue(//AccountingServerReuse.GetT9014S_AccountsExpenseRevenue_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ExpenseRevenue);
EndFunction

Function __GetT9014S_AccountsExpenseRevenue(Period, Company, LedgerTypeVariant, ExpenseRevenue) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByExpenseRevenue.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND ExpenseRevenue = &ExpenseRevenue) AS ByExpenseRevenue
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Company = &Company AND Variant = &Variant
	|	AND ExpenseRevenue.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("Variant" , LedgerTypeVariant);
	Query.SetParameter("ExpenseRevenue" , ExpenseRevenue);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

#EndRegion

Procedure UpdateAccountingTables(Object, 
							     AccountingRowAnalytics,
							     AccountingExtDimensions,
							     MainTableName, 
							     Filter_LedgerType = Undefined, 
							     IgnoreFixed = False,
							     AddInfo = Undefined) Export
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
	LedgerTypes = GetLedgerTypesByCompany(Object.Ref, Period, Object.Company);
	
	OperationsByLedgerType = New Array();
	For Each LedgerType In LedgerTypes Do
		// filter by ledger type
		If Filter_LedgerType <> Undefined And Filter_LedgerType <> LedgerType Then
			Continue;
		EndIf;
		OperationsInfo = GetAccountingOperationsByLedgerType(Object.Ref, Period, LedgerType);
		For Each OperationInfo In OperationsInfo Do
			OperationsByLedgerType.Add(New Structure("LedgerType, OperationInfo", LedgerType, OperationInfo));
		EndDo;
	EndDo;
			
	ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName);
	
	ObjectData = GetDocumentData(Object, Undefined, Undefined).ObjectData;
	
	For Each Operation In OperationsByLedgerType Do
		If Operation.OperationInfo.ByRow Then
			Continue;
		EndIf;
		Parameters = New Structure();
		Parameters.Insert("Object"        , Object);
		Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
		Parameters.Insert("LedgerType"    , Operation.LedgerType);
		Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
		Parameters.Insert("MainTableName" , MainTableName);
		Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
		Parameters.Insert("ObjectData"    , ObjectData);
		Parameters.Insert("RowData"       , Undefined);
		Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
		Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
		
		FillAccountingRowAnalytics(Parameters);
	EndDo;
	
	If MainTableName = Undefined Then
		For Each Operation In OperationsByLedgerType Do
			If Not Operation.OperationInfo.RequestTable Then
				Continue;
			EndIf;
			
			DataTable = Documents[Operation.OperationInfo.MetadataName].GetAccountingDataTable(Operation.OperationInfo.Operation, AddInfo);
			
			For Each Row In DataTable Do
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , Row);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
			
		EndDo;
	Else
		For Each Row In Object[MainTableName] Do
			RowData = GetDocumentData(Object, Row, MainTableName).RowData;
			For Each Operation In OperationsByLedgerType Do
				If Not Operation.OperationInfo.ByRow Then
					Continue;
				EndIf;
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , RowData);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
		EndDo;
	EndIf;
EndProcedure

Function GetDocumentData(Object, TableRow, MainTableName)
	Result = New Structure("ObjectData, RowData", New Structure(), New Structure());
	// data from row
	If TableRow <> Undefined Then
		TabularSections =  Object.Ref.Metadata().TabularSections;
		For Each Column In TabularSections[MainTableName].Attributes Do
			Result.RowData.Insert(Column.Name, TableRow[Column.Name]);	
		EndDo;
				
		If CommonFunctionsClientServer.ObjectHasProperty(TableRow, "VatRate") Then
			TaxInfo = New Structure();
			TaxInfo.Insert("Key", TableRow.Key);
			TaxInfo.Insert("Tax", TaxesServer.GetVatRef());
			Result.RowData.Insert("TaxInfo", TaxInfo);
		EndIf;
		
	Else
		Result.RowData.Insert("Key", "");
	EndIf;
	
	// data from object
	If Object <> Undefined Then
		For Each Attr In Object.Ref.Metadata().Attributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
		For Each Attr In Object.Ref.Metadata().StandardAttributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
	EndIf;
	
	Return Result;
EndFunction

Procedure FillAccountingRowAnalytics(Parameters, Row = Undefined)
	AnalyticRow = Undefined;
	RowKey = "";
	Filter = New Structure();
	If Row <> Undefined Then
		RowKey = Row.Key;
		Filter.Insert("Key" , RowKey);
	EndIf;
	Filter.Insert("Operation"  , Parameters.Operation);
	Filter.Insert("LedgerType" , Parameters.LedgerType);
	
	AnalyticRows = Parameters.AccountingRowAnalytics.FindRows(Filter);
	
	If AnalyticRows.Count() > 1 Then
		Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Operation[%2] LedgerType[%3]", Filter.Key, Filter.Operation, Filter.LedgerType);
	ElsIf AnalyticRows.Count() = 1 Then
		AnalyticRow = AnalyticRows[0];
		If AnalyticRow.IsFixed And Not Parameters.IgnoreFixed Then
			Return;
		EndIf;
	Else
		AnalyticRow = Parameters.AccountingRowAnalytics.Add();
		AnalyticRow.Key = RowKey;		
	EndIf;
	AnalyticRow.IsFixed = False;
	
	AnalyticParameters = New Structure();
	AnalyticParameters.Insert("ObjectData"   , Parameters.ObjectData);
	AnalyticParameters.Insert("RowData"      , Parameters.RowData);
	AnalyticParameters.Insert("Operation"    , Parameters.Operation);
	AnalyticParameters.Insert("LedgerType"   , Parameters.LedgerType);
	AnalyticParameters.Insert("MetadataName" , Parameters.MetadataName);
	
	AnalyticData = Documents[Parameters.MetadataName].GetAccountingAnalytics(AnalyticParameters);
	If AnalyticData = Undefined Then
		Raise StrTemplate("Document [%1] not supported accounting operation [%2]", 
			Parameters.MetadataName, Parameters.Operation);
	EndIf;
		
	AnalyticRow.Operation = AnalyticData.Operation;
	AnalyticRow.LedgerType = AnalyticData.LedgerType;
	
	AnalyticRow.AccountDebit = AnalyticData.Debit;
	FillAccountingExtDimensions(AnalyticData.DebitExtDimensions, Parameters.AccountingExtDimensions);
	
	AnalyticRow.AccountCredit = AnalyticData.Credit;
	FillAccountingExtDimensions(AnalyticData.CreditExtDimensions, Parameters.AccountingExtDimensions);
EndProcedure

Procedure FillAccountingExtDimensions(ArrayOfData, AccountingExtDimensions)
	For Each ExtDim In ArrayOfData Do
		Filter = New Structure();
		If ValueIsFilled(ExtDim.Key) Then
			Filter.Insert("Key" , ExtDim.Key);
		EndIf;
		Filter.Insert("AnalyticType" , ExtDim.AnalyticType);
		Filter.Insert("Operation"    , ExtDim.Operation);
		Filter.Insert("LedgerType"   , ExtDim.LedgerType);
		AccountingExtDimensionRows = AccountingExtDimensions.FindRows(Filter);
		For Each RowForDelete In AccountingExtDimensionRows Do
			AccountingExtDimensions.Delete(RowForDelete);
		EndDo;
	EndDo;
	
	For Each ExtDim In ArrayOfData Do
		NewRow = AccountingExtDimensions.Add();
		NewRow.Key              = ExtDim.Key;
		NewRow.AnalyticType     = ExtDim.AnalyticType;
		NewRow.Operation        = ExtDim.Operation;
		NewRow.LedgerType       = ExtDim.LedgerType;
		NewRow.ExtDimensionType = ExtDim.ExtDimensionType;
		NewRow.ExtDimension     = ExtDim.ExtDimension;
	EndDo;
EndProcedure

Procedure ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName)
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In AccountingRowAnalytics Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
	
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object.Ref, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else		
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		AccountingRowAnalytics.Delete(ItemForDelete);
	EndDo;
	
	// AccountingExtDimensions
	ArrayForDelete.Clear();
	For Each Row In AccountingExtDimensions Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object.Ref, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else	
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

Function GetAccountingData_LandedCost(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Ref,
	|	ItemList.Key,
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.QuantityInBaseUnit
	|INTO ItemList
	|FROM
	|	Document.%1.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &Recorder and ItemList.Key = &RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency AS Currency,
	|	ItemList.QuantityInBaseUnit AS Quantity,
	|	sum(isnull(R6020B_BatchBalance.Quantity, 0)) AS QuantityBatchBalance,
	|	sum(isnull(R6020B_BatchBalance.TotalNetAmount, 0)) AS AmountBatchBalance,
	|	0 AS Amount
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R6020B_BatchBalance AS R6020B_BatchBalance
	|		ON R6020B_BatchBalance.Store = ItemList.Store
	|		AND R6020B_BatchBalance.ItemKey = ItemList.ItemKey
	|		AND R6020B_BatchBalance.Recorder = ItemList.Ref
	|GROUP BY
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency,
	|	ItemList.QuantityInBaseUnit";
	
	Query.Text = StrTemplate(Query.Text, Parameters.Recorder.MeTadata().Name);
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder" , Parameters.Recorder);
	Query.SetParameter("RowKey"   , RowKey);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	TotalAmount   = 0;
	TotalQuantity = 0;
	If QueryTable.Count() Then
		TotalAmount   = QueryTable[0].AmountBatchBalance;
		TotalQuantity = QueryTable[0].QuantityBatchBalance;
	EndIf;
	
	For Each Row In QueryTable Do
		If Row.Quantity = TotalQuantity Then
			Row.Amount = TotalAmount;
		Else
			Row.Amount = ?(Row.QuantityBatchBalance = 0, 0, (TotalAmount / TotalQuantity) * Row.Quantity);
			TotalQuantity = TotalQuantity - Row.Quantity;
			TotalAmount   = TotalAmount - Row.Amount;
		EndIf;
	EndDo;
	
	RecordSet_AccountingAmounts = AccumulationRegisters.T1040T_AccountingAmounts.CreateRecordSet();
	
	TableAccountingAmounts = RecordSet_AccountingAmounts.UnloadColumns();
	TableAccountingAmounts.Columns.Delete(TableAccountingAmounts.Columns.PointInTime);
	CalculatedTableAccountingAmounts = TableAccountingAmounts.Copy();
		
	For Each Row In QueryTable Do		
		// Accounting amounts
		NewRow_AccountingAmounts = TableAccountingAmounts.Add();
		FillPropertyValues(NewRow_AccountingAmounts, Row);
		NewRow_AccountingAmounts.Period = Parameters.Recorder.Date;
		NewRow_AccountingAmounts.RowKey = Row.Key;
		NewRow_AccountingAmounts.Operation = Parameters.Operation;
	EndDo;
	
	// Currency calculation
	
	CurrenciesTableParams = New Structure();
	CurrenciesTableParams.Insert("Ref"            , Parameters.Recorder);
	CurrenciesTableParams.Insert("Date"           , Parameters.Recorder.Date);
	CurrenciesTableParams.Insert("Company"        , Parameters.Recorder.Company);
	CurrenciesTableParams.Insert("Currency"       , Parameters.Recorder.Company.LandedCostCurrencyMovementType.Currency);
	CurrenciesTableParams.Insert("Agreement"      , Undefined);
	CurrenciesTableParams.Insert("RowKey"         , "");
	CurrenciesTableParams.Insert("DocumentAmount" , 0);
	CurrenciesTableParams.Insert("Currencies"     , New Array());
	
	CurrenciesTable = Parameters.Recorder.Currencies.UnloadColumns();
	CurrenciesServer.UpdateCurrencyTable(CurrenciesTableParams, CurrenciesTable);
	
	
	CurrenciesParameters = New Structure();
	PostingDataTables = New Map();
	PostingDataTables.Insert(RecordSet_AccountingAmounts, New Structure("RecordSet", TableAccountingAmounts));
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	CurrenciesParameters.Insert("Object", Parameters.Recorder);
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	CurrenciesParameters.Insert("IsLandedCost", True);
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, CurrenciesTable);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.T1040T_AccountingAmounts") Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(CalculatedTableAccountingAmounts.Add(), RowPostingInfo);
			EndDo;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"select
	|	table.Currency,
	|	table.Amount,
	|	table.Operation,
	|	table.CurrencyMovementType,
	|	table.RowKey
	|into table
	|from
	|	&table as table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Amounts.RowKey = &RowKey
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND Amounts.RowKey = &RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND Quantities.RowKey = &RowKey";
	
	Query.SetParameter("table"                , CalculatedTableAccountingAmounts);
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("RowKey"           	  , RowKey);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[3].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	EndIf;
	
	Return Result;	
EndFunction

Function GetAccountingData(Parameters)

	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND case
	|		when &FilterByRowKey
	|			then Quantities.RowKey = &RowKey
	|		else True
	|	end";
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("FilterByRowKey"       , ValueIsFilled(RowKey));
	Query.SetParameter("RowKey"           	  , RowKey);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	EndIf;
	
	Return Result;	
EndFunction

#Region Event_Handlers

// Form

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure BeforeWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	CurrentObject.AdditionalProperties.Insert("AccountingRowAnalytics"  , Form.AccountingRowAnalytics.Unload());
	CurrentObject.AdditionalProperties.Insert("AccountingExtDimensions" , Form.AccountingExtDimensions.Unload());
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure UpdateFormTables(Object, Form)
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingRowAnalytics.Load(RecordSet.Unload());
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingExtDimensions.Load(RecordSet.Unload());
EndProcedure	

// Object

Procedure OnWrite(Object, Cancel) Export
	_AccountingRowAnalytics = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingRowAnalytics", Undefined);
	If _AccountingRowAnalytics = Undefined Then
		RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingRowAnalytics = RecordSet.Unload();
	EndIf;
			
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingExtDimensions", Undefined);
	If _AccountingExtDimensions = Undefined Then
		RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingExtDimensions = RecordSet.Unload();
	EndIf;
		
	AccountingClientServer.UpdateAccountingTables(Object, 
		                                         _AccountingRowAnalytics, 
		                                         _AccountingExtDimensions,
		                                         AccountingClientServer.GetDocumentMainTable(Object));
		
	Object.AdditionalProperties.Insert("AccountingRowAnalytics"  , _AccountingRowAnalytics);
	Object.AdditionalProperties.Insert("AccountingExtDimensions" , _AccountingExtDimensions);
EndProcedure

// Manager

Procedure CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo) Export
	_AccountingRowAnalytics  = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingRowAnalytics", Undefined);
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingExtDimensions", Undefined);
	
	If _AccountingRowAnalytics = Undefined Or _AccountingExtDimensions = Undefined Then
		Return;
	EndIf;
	
	_AccountingRowAnalytics.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingRowAnalytics);
	RecordSet.Write();
		
	_AccountingExtDimensions.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingExtDimensions);
	RecordSet.Write();	
EndProcedure

#EndRegion


