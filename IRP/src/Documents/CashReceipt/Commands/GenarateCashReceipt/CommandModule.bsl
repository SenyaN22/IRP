&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	GenerateDocument(CommandParameter);
EndProcedure

&AtClient
Procedure GenerateDocument(ArrayOfBasisDocuments)
	DocumentStructure = GetDocumentsStructure(ArrayOfBasisDocuments);

	For Each FillingData In DocumentStructure Do
		OpenForm("Document.CashReceipt.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());
	EndDo;
EndProcedure

&AtServer
Function ErrorMessageStructure(BasisDocuments)
	ErrorMessageStructure = New Structure();

	For Each BasisDocument In BasisDocuments Do
		ErrorMessageKey = ErrorMessageKey(BasisDocument);
		If ValueIsFilled(ErrorMessageKey) Then
			ErrorMessageStructure.Insert(ErrorMessageKey, StrTemplate(R()[ErrorMessageKey],
				Metadata.Documents.CashReceipt.Synonym));
		EndIf;
	EndDo;

	If ErrorMessageStructure.Count() = 1 Then
		ErrorMessageText = ErrorMessageStructure[ErrorMessageKey];
	ElsIf ErrorMessageStructure.Count() = 0 Then
		ErrorMessageText = StrTemplate(R().Error_051, Metadata.Documents.CashReceipt.Synonym);
	Else
		ErrorMessageText = StrTemplate(R().Error_059, Metadata.Documents.CashReceipt.Synonym) + Chars.LF + StrConcat(
			BasisDocuments, Chars.LF);
	EndIf;

	Return ErrorMessageText;
EndFunction

&AtServer
Function ErrorMessageKey(BasisDocument)
	ErrorMessageKey = Undefined;

	If TypeOf(BasisDocument) = Type("DocumentRef.CashTransferOrder") Then
		If Not BasisDocument.Receiver.Type = PredefinedValue("Enum.CashAccountTypes.Cash") Then
			ErrorMessageKey = "Error_057";
		Else
			ErrorMessageKey = "Error_060";
		EndIf;
	EndIf;

	Return ErrorMessageKey;
EndFunction

&AtServer
Function GetDocumentsStructure(ArrayOfBasisDocuments)
	ArrayOf_CashTransferOrder          = New Array();
	ArrayOf_IncomingPaymentOrder       = New Array();
	ArrayOf_SalesInvoice               = New Array();
	ArrayOf_SalesOrder_ToBePaid        = New Array();
	ArrayOf_SalesOrder_CustomerAdvance = New Array();
	ArrayOf_PurchaseReturn             = New Array();
	ArrayOf_MoneyTransfer              = New Array();
	ArrayOf_SalesReportFromTradeAgent  = New Array();
	ArrayOf_EmployeeCashAdvance        = New Array();
	
	For Each Row In ArrayOfBasisDocuments Do
		If TypeOf(Row) = Type("DocumentRef.CashTransferOrder") Then
			ArrayOf_CashTransferOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.IncomingPaymentOrder") Then
			ArrayOf_IncomingPaymentOrder.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesInvoice") Then
			ArrayOf_SalesInvoice.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesOrder") Then
			If Row.TransactionType = Enums.SalesTransactionTypes.Sales Then
				ArrayOf_SalesOrder_ToBePaid.Add(Row);
			ElsIf Row.TransactionType = Enums.SalesTransactionTypes.RetailSales Then
				ArrayOf_SalesOrder_CustomerAdvance.Add(Row);
			EndIf;
		ElsIf TypeOf(Row) = Type("DocumentRef.PurchaseReturn") Then
			ArrayOf_PurchaseReturn.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.MoneyTransfer") Then
			ArrayOf_MoneyTransfer.Add(Row);	
		ElsIf TypeOf(Row) = Type("DocumentRef.SalesReportFromTradeAgent") Then
			ArrayOf_SalesReportFromTradeAgent.Add(Row);
		ElsIf TypeOf(Row) = Type("DocumentRef.EmployeeCashAdvance") Then
			ArrayOf_EmployeeCashAdvance.Add(Row);
		Else
			Raise R().Error_043;
		EndIf;
	EndDo;

	ArrayOfTables = New Array();
	ArrayOfTables.Add(GetDocumentTable_CashTransferOrder(ArrayOf_CashTransferOrder));
	ArrayOfTables.Add(GetDocumentTable_IncomingPaymentOrder(ArrayOf_IncomingPaymentOrder));
	ArrayOfTables.Add(GetDocumentTable_SalesInvoice(ArrayOf_SalesInvoice));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder_TobePaid(ArrayOf_SalesOrder_ToBePaid));
	ArrayOfTables.Add(GetDocumentTable_SalesOrder_CustomerAdvance(ArrayOf_SalesOrder_CustomerAdvance));
	ArrayOfTables.Add(GetDocumentTable_PurchaseReturn(ArrayOf_PurchaseReturn));
	ArrayOfTables.Add(GetDocumentTable_MoneyTransfer(ArrayOf_MoneyTransfer));
	ArrayOfTables.Add(GetDocumentTable_SalesReportFromTradeAgent(ArrayOf_SalesReportFromTradeAgent));
	ArrayOfTables.Add(GetDocumentTable_EmployeeCashAdvance(ArrayOf_EmployeeCashAdvance));
	
	Return JoinDocumentsStructure(ArrayOfTables);
EndFunction

&AtServer
Function JoinDocumentsStructure(ArrayOfTables)
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("BasedOn"         , New TypeDescription("String"));
	ValueTable.Columns.Add("Company"         , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("Branch"          , New TypeDescription("CatalogRef.BusinessUnits"));
	ValueTable.Columns.Add("CashAccount"     , New TypeDescription("CatalogRef.CashAccounts"));
	ValueTable.Columns.Add("Currency"        , New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("CurrencyExchange", New TypeDescription("CatalogRef.Currencies"));
	ValueTable.Columns.Add("TransactionType" , New TypeDescription("EnumRef.IncomingPaymentTransactionType"));
	ValueTable.Columns.Add("BasisDocument"   , New TypeDescription(Metadata.DefinedTypes.typeArTransactionBasises.Type));
	ValueTable.Columns.Add("Agreement"       , New TypeDescription("CatalogRef.Agreements"));
	ValueTable.Columns.Add("Partner"         , New TypeDescription("CatalogRef.Partners"));
	ValueTable.Columns.Add("Amount"          , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("NetAmount"       , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("AmountExchange"  , New TypeDescription(Metadata.DefinedTypes.typeAmount.Type));
	ValueTable.Columns.Add("Payer"           , New TypeDescription("CatalogRef.Companies"));
	ValueTable.Columns.Add("PlaningTransactionBasis",
		New TypeDescription(Metadata.DefinedTypes.typePlaningTransactionBasises.Type));
	ValueTable.Columns.Add("FinancialMovementType", New TypeDescription("CatalogRef.ExpenseAndRevenueTypes"));
	ValueTable.Columns.Add("Order", New TypeDescription("DocumentRef.SalesOrder"));
	ValueTable.Columns.Add("MoneyTransfer"  , New TypeDescription("DocumentRef.MoneyTransfer"));
	ValueTable.Columns.Add("RetailCustomer" , New TypeDescription("CatalogRef.RetailCustomers"));
	
	For Each Table In ArrayOfTables Do
		For Each Row In Table Do
			NewRow = ValueTable.Add();
			FillPropertyValues(NewRow, Row);
			If Not ValueIsFilled(NewRow.NetAmount) Then
				NewRow.NetAmount = NewRow.Amount;
			EndIf;
		EndDo;
	EndDo;

	ValueTableCopy = ValueTable.Copy();
	ValueTableCopy.GroupBy("BasedOn, TransactionType, Company, Branch, CashAccount, Currency, CurrencyExchange");

	ArrayOfResults = New Array();

	For Each Row In ValueTableCopy Do
		Result = New Structure();
		Result.Insert("BasedOn"          , Row.BasedOn);
		Result.Insert("TransactionType"  , Row.TransactionType);
		Result.Insert("Company"          , Row.Company);
		Result.Insert("Branch"           , Row.Branch);
		Result.Insert("CashAccount"      , Row.CashAccount);
		Result.Insert("Currency"         , Row.Currency);
		Result.Insert("CurrencyExchange" , Row.CurrencyExchange);
		Result.Insert("PaymentList"      , New Array());

		Filter = New Structure();
		Filter.Insert("BasedOn"          , Row.BasedOn);
		Filter.Insert("TransactionType"  , Row.TransactionType);
		Filter.Insert("Company"          , Row.Company);
		Filter.Insert("Branch"           , Row.Branch);
		Filter.Insert("CashAccount"      , Row.CashAccount);
		Filter.Insert("Currency"         , Row.Currency);
		Filter.Insert("CurrencyExchange" , Row.CurrencyExchange);

		PaymentList = ValueTable.Copy(Filter);
		For Each RowPaymentList In PaymentList Do
			NewRow = New Structure();
			NewRow.Insert("BasisDocument"           , RowPaymentList.BasisDocument);
			NewRow.Insert("Agreement"               , RowPaymentList.Agreement);
			NewRow.Insert("Partner"                 , RowPaymentList.Partner);
			NewRow.Insert("Payer"                   , RowPaymentList.Payer);
			NewRow.Insert("TotalAmount"             , RowPaymentList.Amount);
			NewRow.Insert("NetAmount"               , RowPaymentList.NetAmount);
			NewRow.Insert("AmountExchange"          , RowPaymentList.AmountExchange);
			NewRow.Insert("PlaningTransactionBasis" , RowPaymentList.PlaningTransactionBasis);
			NewRow.Insert("FinancialMovementType"   , RowPaymentList.FinancialMovementType);
			NewRow.Insert("Order"                   , RowPaymentList.Order);
			NewRow.Insert("MoneyTransfer"           , RowPaymentList.MoneyTransfer);
			NewRow.Insert("RetailCustomer"          , RowPaymentList.RetailCustomer);
			Result.PaymentList.Add(NewRow);
		EndDo;
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction

&AtServer
Function GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments)
	Result = DocCashReceiptServer.GetDocumentTable_CashTransferOrder(ArrayOfBasisDocuments);

	ErrorDocuments = New Array();
	For Each BasisDocument In ArrayOfBasisDocuments Do
		If Result.FindRows(New Structure("PlaningTransactionBasis", BasisDocument)).Count() = 0 Then
			ErrorDocuments.Add(BasisDocument);
		EndIf;
	EndDo;

	If ErrorDocuments.Count() Then
		ErrorMessageText = ErrorMessageStructure(ErrorDocuments);
		CommonFunctionsClientServer.ShowUsersMessage(ErrorMessageText);
	EndIf;

	Return Result;
EndFunction

&AtServer
Function GetDocumentTable_IncomingPaymentOrder(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT ALLOWED
	|	""IncomingPaymentOrder"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
	|	R3035T_CashPlanningTurnovers.FinancialMovementType AS FinancialMovementType,
	|	R3035T_CashPlanningTurnovers.Company AS Company,
	|	R3035T_CashPlanningTurnovers.Branch AS Branch,
	|	R3035T_CashPlanningTurnovers.Account AS CashAccount,
	|	R3035T_CashPlanningTurnovers.Currency AS Currency,
	|	R3035T_CashPlanningTurnovers.Partner AS Partner,
	|	R3035T_CashPlanningTurnovers.LegalName AS Payer,
	|	R3035T_CashPlanningTurnovers.AmountTurnover AS Amount,
	|	R3035T_CashPlanningTurnovers.BasisDocument AS PlaningTransactionBasis
	|FROM
	|	AccumulationRegister.R3035T_CashPlanning.Turnovers(, , , CashFlowDirection = VALUE(Enum.CashFlowDirections.Incoming)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND BasisDocument IN (&ArrayOfBasisDocuments)) AS R3035T_CashPlanningTurnovers
	|WHERE
	|	R3035T_CashPlanningTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Cash)
	|	AND R3035T_CashPlanningTurnovers.AmountTurnover > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_EmployeeCashAdvance(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT
	|	TableBasisDocument.Company,
	|	TableBasisDocument.Branch,
	|	TableBasisDocument.Currency,
	|	TableBasisDocument.Partner,
	|	TableBasisDocument.BasisDocument
	|INTO TableBasisDocument
	|FROM
	|	&TableBasisDocument AS TableBasisDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	""EmployeeCashAdvance"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.EmployeeCashAdvance) AS TransactionType,
	|	R3027B_EmployeeCashAdvanceBalance.Company,
	|	R3027B_EmployeeCashAdvanceBalance.Branch,
	|	R3027B_EmployeeCashAdvanceBalance.Currency,
	|	R3027B_EmployeeCashAdvanceBalance.Partner,
	|	R3027B_EmployeeCashAdvanceBalance.AmountBalance AS Amount,
	|	TableBasisDocument.BasisDocument
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(, (Company, Branch, Currency, Partner) IN
	|		(SELECT
	|			TableBasisDocument.Company,
	|			TableBasisDocument.Branch,
	|			TableBasisDocument.Currency,
	|			TableBasisDocument.Partner
	|		FROM
	|			TableBasisDocument AS TableBasisDocument)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R3027B_EmployeeCashAdvanceBalance
	|		INNER JOIN TableBasisDocument AS TableBasisDocument
	|		ON TableBasisDocument.Company = R3027B_EmployeeCashAdvanceBalance.Company
	|		AND TableBasisDocument.Branch = R3027B_EmployeeCashAdvanceBalance.Branch
	|		AND TableBasisDocument.Currency = R3027B_EmployeeCashAdvanceBalance.Currency
	|		AND TableBasisDocument.Partner = R3027B_EmployeeCashAdvanceBalance.Partner
	|WHERE
	|	R3027B_EmployeeCashAdvanceBalance.AmountBalance > 0";
	
	AccReg = Metadata.AccumulationRegisters.R3027B_EmployeeCashAdvance.Dimensions;
	TableBasisDocument = New ValueTable();
	TableBasisDocument.Columns.Add("Company"  , AccReg.Company.Type);
	TableBasisDocument.Columns.Add("Branch"   , AccReg.Branch.Type);
	TableBasisDocument.Columns.Add("Currency" , AccReg.Currency.Type);
	TableBasisDocument.Columns.Add("Partner"  , AccReg.Partner.Type);
	TableBasisDocument.Columns.Add("BasisDocument"          , New TypeDescription("DocumentRef.EmployeeCashAdvance"));
		
	For Each Basis In ArrayOfBasisDocuments Do
		For Each Row In Basis.PaymentList Do
			NewRow = TableBasisDocument.Add();
			NewRow.Company  = Basis.Company;
			NewRow.Branch   = Basis.Branch;
			NewRow.Currency = Row.Currency;
			NewRow.Partner  = Basis.Partner;
			NewRow.BasisDocument = Basis;
		EndDo;
	EndDo;
	
	Query.SetParameter("TableBasisDocument", TableBasisDocument);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtServer
Function GetDocumentTable_MoneyTransfer(ArrayOfBasisDocuments)
	Query = New Query();
	Query.Text =
	"SELECT ALLOWED
	|	""MoneyTransfer"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.CashIn) AS TransactionType,
	|	R3021B_CashInTransitIncoming.Company AS Company,
	|	R3021B_CashInTransitIncoming.Branch AS Branch,
	|	R3021B_CashInTransitIncoming.Account AS CashAccount,
	|	R3021B_CashInTransitIncoming.Currency AS Currency,
	|	R3021B_CashInTransitIncoming.AmountBalance AS Amount,
	|	R3021B_CashInTransitIncoming.Basis AS MoneyTransfer,
	|	R3021B_CashInTransitIncoming.Basis.ReceiveFinancialMovementType AS FinancialMovementType
	|FROM
	|	AccumulationRegister.R3021B_CashInTransitIncoming.Balance(,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Basis IN (&ArrayOfBasisDocuments)) AS R3021B_CashInTransitIncoming";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

&AtServer
Function GetDocumentTable_SalesInvoice(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_SalesDocument_ForReceipt(ArrayOfBasisDocuments, "SalesInvoice");
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder_ToBePaid(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_SalesOrder_ToBePaid(ArrayOfBasisDocuments);
EndFunction

&AtServer
Function GetDocumentTable_SalesOrder_CustomerAdvance(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_SalesOrder_CustomerAdvance(ArrayOfBasisDocuments, Enums.PaymentTypes.Cash);
EndFunction

&AtServer
Function GetDocumentTable_PurchaseReturn(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_PurchaseReturn_ForReceipt(ArrayOfBasisDocuments);
EndFunction

&AtServer
Function GetDocumentTable_SalesReportFromTradeAgent(ArrayOfBasisDocuments)
	Return DocumentsGenerationServer.GetDocumentTable_SalesDocument_ForReceipt(ArrayOfBasisDocuments, "SalesReportFromTradeAgent");
EndFunction
