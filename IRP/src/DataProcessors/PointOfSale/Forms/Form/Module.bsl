
&AtClient
Var Component Export;

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.HTMLDate = GetCommonTemplate("HTMLClock").GetText();
	ThisObject.HTMLTextTemplate = GetCommonTemplate("HTMLTextField").GetText();
	Workstation = SessionParametersServer.GetSessionParameter("Workstation");
	If Workstation.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_103, "Workstation"));
	EndIf;
	
	If SessionParameters.isMobile Then
		
		Items.HTMLDate.Visible = False;
		Items.DetailedInformation.Visible = False;
		
		Items.GroupHeaderTop.Group = ChildFormItemsGroup.Vertical;
		Items.Move(Items.GroupHeaderTop, Items.AdditionalPage);
		
		Items.Move(Items.PageButtons, ThisObject);
		Items.Move(Items.GroupPicture, Items.GroupPaymentLeft);
		Items.Move(Items.PagePayment, Items.PageButtons);
		Items.PageButtons.PagesRepresentation = FormPagesRepresentation.TabsOnBottom;
		Items.GroupPaymentRight.ShowTitle = False;

	EndIf;
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		FillCashInList();
	EndIf;
		
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	NewTransaction();
	SetShowItems();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		SessionIsCreated = Not Object.ConsolidatedRetailSales.IsEmpty();
		If SessionIsCreated Then
			Status = CommonFunctionsServer.GetRefAttribute(Object.ConsolidatedRetailSales, "Status");
			Form.Items.OpenSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New");
			Form.Items.CloseSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.Open");
			Form.Items.CancelSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New");
			Form.Items.GroupCommonCommands.Visible = True;
		Else
			Form.Items.OpenSession.Enabled = Not SessionIsCreated;
			Form.Items.CloseSession.Enabled = SessionIsCreated;
			Form.Items.CancelSession.Enabled = SessionIsCreated;
		EndIf;
	Else
		Form.Items.GroupCommonCommands.Visible = False;
	EndIf;
	
	Form.Items.GroupCashCommands.Visible = 
		CommonFunctionsServer.GetRefAttribute(Form.Workstation, "UseCashInAndCashOut");
		
	Form.Items.ReturnPage.Visible =	Form.isReturn;
	
	Form.Title = R().InfoMessage_POS_Title + ?(Form.isReturn, ": " + R().InfoMessage_ReturnTitle, "");
EndProcedure

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocRetailSalesReceiptClient.AgreementOnChange(Object, ThisObject, Item);
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailSalesReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocRetailSalesReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CONSOLIDATED_RETAIL_SALES

&AtClient
Async Procedure OpenSession(Command)
	DocConsolidatedRetailSales = DocConsolidatedRetailSalesServer.CreateDocument(Object.Company, Object.Branch, ThisObject.Workstation);

	EquipmentOpenShiftResult = Await EquipmentFiscalPrinterClient.OpenShift(DocConsolidatedRetailSales);
	If EquipmentOpenShiftResult.Success Then
		DocConsolidatedRetailSalesServer.DocumentOpenShift(DocConsolidatedRetailSales, EquipmentOpenShiftResult);
		ChangeConsolidatedRetailSales(Object, ThisObject, DocConsolidatedRetailSales);
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
		
		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	EndIf;
EndProcedure

&AtClient
Procedure CloseSession(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("Store", ThisObject.Store);
	FormParameters.Insert("Workstation", Object.Workstation);
	FormParameters.Insert("AutoCreateMoneyTransfer"
		, CommonFunctionsServer.GetRefAttribute(Object.Workstation, "AutoCreateMoneyTransferAtSessionClosing"));
	FormParameters.Insert("ConsolidatedRetailSales", Object.ConsolidatedRetailSales);
	
	NotifyDescription = New NotifyDescription("CloseSessionFinish", ThisObject);
	
	OpenForm(
		"DataProcessor.PointOfSale.Form.SessionClosing", 
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Async Procedure CloseSessionFinish(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	If Result.AutoCreateMoneyTransfer Then
		CreateCashOut(Commands.CreateCashOut, True);
	EndIf;
	
	EquipmentCloseShiftResult = Await EquipmentFiscalPrinterClient.CloseShift(Object.ConsolidatedRetailSales);
	If EquipmentCloseShiftResult.Success Then
		DocConsolidatedRetailSalesServer.DocumentCloseShift(Object.ConsolidatedRetailSales, EquipmentCloseShiftResult, Result);
		ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);
	
		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	EndIf;
EndProcedure

&AtClient
Procedure CancelSession(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("Store", ThisObject.Store);
	FormParameters.Insert("Workstation", Object.Workstation);
	FormParameters.Insert("ConsolidatedRetailSales", Object.ConsolidatedRetailSales);
	
	NotifyDescription = New NotifyDescription("CancelSessionFinish", ThisObject);
	
	OpenForm(
		"DataProcessor.PointOfSale.Form.SessionClosing", 
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure CancelSessionFinish(Result, AddInfo) Export
	If Not Result = DialogReturnCode.OK Then
		Return;
	EndIf;
	
	DocConsolidatedRetailSalesServer.CancelDocument(Object.ConsolidatedRetailSales);
	ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);
	
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();
EndProcedure

&AtClient
Async Procedure PrintXReport(Command)
	
	EquipmentResult = Await EquipmentFiscalPrinterClient.PrintXReport(Object.ConsolidatedRetailSales);
	If EquipmentResult.Success Then
		
	EndIf;
EndProcedure
			
#EndRegion

#Region FormTableItemsEventHandlers

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailSalesReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	CheckRetailBasis();
	SetDetailedInfo("");
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If ThisObject.isReturn And Not ThisObject.RetailBasis.IsEmpty() Then
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	EnabledPaymentButton();
	FillSalesPersonInItemList();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	Return;
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	UpdateHTMLPictures();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	CheckRetailBasis();
	UpdateHTMLPictures();
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocRetailSalesReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
	CheckRetailBasis();
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocRetailSalesReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
	CheckRetailBasis();
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocRetailSalesReceiptClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocRetailSalesReceiptClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailSalesReceiptClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocRetailSalesReceiptClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRetailSalesReceiptStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;

	RowID = Undefined;
	If Not Items.ItemList.CurrentRow = Undefined Then
		RowID = Items.ItemList.CurrentRow;
	EndIf;
	
	FindRetailBasis(RowID);
EndProcedure

&AtClient
Procedure RetailSalesReceiptStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	FindRetailBasis(Undefined);
EndProcedure

&AtClient
Procedure RetailSalesReceiptOnChange(Item)
	If ThisObject.RetailBasis.IsEmpty() Then
		For Each ListItem In ThisObject.Object.ItemList Do
			ListItem.RetailBasis = ThisObject.RetailBasis; 
		EndDo;
		ThisObject.BasisPayments.Clear();
	EndIf;
EndProcedure

#Region SerialLotNumbers

&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing) Export
	SerialLotNumberClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	SerialLotNumberClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemListPickupEvents

&AtClient
Procedure ItemsPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If Not CurrentData.Property("Ref") Then
		Return;
	EndIf;
	StandardProcessing = False;
	
	AddItemKeyToItemList(CurrentData.Ref);
EndProcedure

&AtClient
Procedure ItemsPickupOnActivateRow(Item)
	UpdateHTMLPictures();
EndProcedure

#EndRegion

#Region ItemkeyPickupList

&AtClient
Procedure AddItemKeyToItemList(ItemKey)
	
	Result = New Structure("FoundedItems", GetItemInfo.GetInfoByItemsKey(ItemKey));
	SearchByBarcodeEnd(Result, New Structure());
	
EndProcedure

#EndRegion

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	PriceType = PredefinedValue("Catalog.PriceKeys.EmptyRef");
	If ValueIsFilled(Object.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceType = AgreementInfo.PriceType;
	EndIf;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, PriceType);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If Result.FoundedItems.Count() Then
		FillSalesPersonInItemList();
		
		NotifyParameters = New Structure();
		NotifyParameters.Insert("Form", ThisObject);
		NotifyParameters.Insert("Object", Object);
		SetDetailedInfo("");
		DocumentsClient.PickupItemsEnd(Result.FoundedItems, NotifyParameters);
		EnabledPaymentButton();
		
		If Not SalesPersonByDefault.IsEmpty() Then
			FillSalesPersonInItemList();
		EndIf;
		
	Else
		
		DetailedInformation = "<span style=""color:red;"">" + StrTemplate(R().S_019, StrConcat(
			Result.Barcodes, ",")) + "</span>";
		SetDetailedInfo(DetailedInformation);
		
	EndIf;
EndProcedure

&AtClient
Procedure qPayment(Command)

	Object.Date = CommonFunctionsServer.GetCurrentSessionDate();

	If Not CheckFilling() Then
		Cancel = True;
		Return;
	EndIf;

	Cancel = False;
	DPPointOfSaleClient.BeforePayment(ThisObject, Cancel);
	
	If ThisObject.isReturn Then
		If Not ThisObject.RetailBasis.IsEmpty() Then
			EmptyRows = Object.ItemList.FindRows(
				New Structure("RetailBasis", PredefinedValue("Document.RetailSalesReceipt.EmptyRef")));
			If EmptyRows.Count() > 0 Then
				Cancel = True;
				For Each EmptyRow In EmptyRows Do
					Message = StrTemplate(R().Error_077, EmptyRow.LineNumber);
					Path = StrTemplate(
						"Object.ItemList[%1].RetailBasis", 
						Format(EmptyRow.LineNumber - 1, "NZ=; NG=;"));
					CommonFunctionsClientServer.ShowUsersMessage(Message, Path);
				EndDo;
			EndIf;
		EndIf;
	EndIf;

	If Cancel Then
		Return;
	EndIf;

	If Not ThisObject.isReturn Then
		OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument", Undefined, True);
	EndIf;

	OpenFormNotifyDescription = New NotifyDescription("PaymentFormClose", ThisObject);
	ObjectParameters = New Structure();
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("Branch", Object.Branch);
	ObjectParameters.Insert("Workstation", Workstation);
	ObjectParameters.Insert("IsAdvance", False);
	ObjectParameters.Insert("RetailCustomer", Object.RetailCustomer);
	ObjectParameters.Insert("Company", Object.Company);
	ObjectParameters.Insert("Discount", Object.ItemList.Total("OffersAmount"));
	OpenForm("DataProcessor.PointOfSale.Form.Payment", ObjectParameters, ThisObject, UUID, , ,
		OpenFormNotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure Advance(Command)
	If Not ValueIsFilled(Object.RetailCustomer) Then
		// "Error. Retail customer is not filled
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_123);
		Return;
	EndIf;
	
	OpenFormNotifyDescription = New NotifyDescription("AdvanceFormClose", ThisObject);
	ObjectParameters = New Structure();
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("Branch", Object.Branch);
	ObjectParameters.Insert("Workstation", Workstation);
	ObjectParameters.Insert("IsAdvance", True);
	ObjectParameters.Insert("RetailCustomer", Object.RetailCustomer);
	ObjectParameters.Insert("Company", Object.Company);
	
	OpenForm("DataProcessor.PointOfSale.Form.Payment", ObjectParameters, ThisObject, UUID, , ,
		OpenFormNotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure DocReturn(Command)
	isReturn = Not isReturn;
	ThisObject.RetailBasis = Undefined;
	For Each ListItem In ThisObject.Object.ItemList Do
		 ListItem.RetailBasis = Undefined;
	EndDo;
	
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();
	
	If isReturn Then
		Items.PageButtons.CurrentPage = Items.ReturnPage;
	EndIf;
EndProcedure

&AtClient
Procedure CancelReceipt(Command)
	Return;
EndProcedure

&AtClient
Procedure ChangeCashier(Command)
	Return;
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Close();
EndProcedure

&AtClient
Procedure CalculateOffers(Command)
	Return;
EndProcedure

&AtClient
Procedure PrintReceipt(Command)
	Cancel = False;
	DPPointOfSaleClient.PrintLastReceipt(ThisObject, Cancel);
EndProcedure

&AtClient
Procedure SearchCustomer(Command)
	Notify = New NotifyDescription("SetRetailCustomer", ThisObject);
	OpenForm("Catalog.RetailCustomers.Form.QuickSearch", New Structure("RetailCustomer", Object.RetailCustomer), ThisObject, , ,
		, Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure SetRetailCustomer(Value, AddInfo = Undefined) Export
	If ValueIsFilled(Value) Then
		Object.RetailCustomer = Value;
		DocRetailSalesReceiptClient.RetailCustomerOnChange(Object, ThisObject,
			ThisObject.Items.RetailCustomer);
	EndIf;
EndProcedure

&AtClient
Procedure ItemListDrag(Item, DragParameters, StandardProcessing, Row, Field)
	StandardProcessing = False;
	If DragParameters.Action = DragAction.Move And DragParameters.Value.Count() Then
		Value = DragParameters.Value[0];
		If TypeOf(Value) = Type("CatalogRef.ItemKeys") Then
			AddItemKeyToItemList(Value);
		EndIf;
	EndIf;
EndProcedure

#Region SpecialOffers

#Region Offers_for_document

&AtClient
Procedure SetSpecialOffers(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

#EndRegion

#Region Offers_for_row

&AtClient
Procedure SetSpecialOffersAtRow(Command)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, CurrentData, ThisObject, "SpecialOffersEditFinish_ForRow");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForRow(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion
#EndRegion

#EndRegion

#Region Private

#Region SetDetailedInfo

&AtClient
Procedure SetDetailedInfo(DetailedInformation)
	If Items.DetailedInformation.Visible Then
		Items.DetailedInformation.document.getElementById("text").innerHTML = DetailedInformation;
	EndIf;
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Procedure UpdateHTMLPictures() Export
	If Not Items.ItemPicture.Visible Then
		Return;
	EndIf;

	If CurrentItem = Items.ItemList Then
		CurrentRow = Items.ItemList.CurrentData;
	ElsIf CurrentItem = Items.ItemsPickup Then
		CurrentRow = Items.ItemsPickup.CurrentData;
	Else
		CurrentRow = Undefined;
	EndIf;

	If CurrentRow = Undefined Then
		Return;
	EndIf;

	ItemPicture = GetURL(GetPictureFile(CurrentRow.Item), "Preview");

EndProcedure

&AtServerNoContext
Function GetPictureFile(Item)
	ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(Item);
	If ArrayOfFiles.Count() Then
		If ArrayOfFiles[0].isPreviewSet Then
			Return ArrayOfFiles[0];
		EndIf;
	Else
		Return Catalogs.Files.EmptyRef();
	EndIf;
EndFunction

#EndRegion

#Region SalesPerson

&AtClient
Procedure SetSalesPerson(Command)
	SetDefaultSalesPerson();
EndProcedure

&AtClient
Async Procedure SetDefaultSalesPerson()
	SalesPersons = GetSalesPersonsAtServer();
	If SalesPersons.Count() = 1 Then
		SalesPersonByDefault = SalesPersons[0];
	ElsIf SalesPersons.Count() > 1 Then
		SelectDefPerson = New ValueList();
		SelectDefPerson.LoadValues(SalesPersons);
		SelectDefPersonValue = Await SelectDefPerson.ChooseItemAsync(R().POS_s5);
		If Not SelectDefPersonValue = Undefined Then
			SalesPersonByDefault = SelectDefPersonValue.Value;
		EndIf;
	Else
		SalesPersonByDefault = Undefined;
	EndIf;
	
	If Not SalesPersonByDefault.IsEmpty() Then
		FillSalesPersonInItemList();
		For Each Row In Items.ItemList.SelectedRows Do
			ObjRow = Object.ItemList.FindByID(Row);
			ObjRow.SalesPerson = SalesPersonByDefault;
		EndDo;
	EndIf;
 
EndProcedure

&AtClient
Async Procedure FillSalesPersonInItemList()
	If SalesPersonByDefault.IsEmpty() Then
		SetDefaultSalesPerson();
	EndIf;
	
	For Each Row In Object.ItemList Do
		If Row.SalesPerson.IsEmpty() Then
			Row.SalesPerson = SalesPersonByDefault;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function GetSalesPersonsAtServer()
	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	RetailWorkers.Worker
		|FROM
		|	InformationRegister.RetailWorkers AS RetailWorkers
		|WHERE
		|	RetailWorkers.Store = &Store
		|GROUP BY
		|	RetailWorkers.Worker
		|AUTOORDER";
	
	Query.SetParameter("Store", Store);
	
	QueryResult = Query.Execute().Unload().UnloadColumn("Worker");
	
	Return QueryResult;
EndFunction

#EndRegion

#Region RegionArea

&AtClient
Async Procedure PaymentFormClose(Result, AdditionalData) Export

	If Result = Undefined Then
		Return;
	EndIf;
	
	CashbackAmount = WriteTransaction(Result);
	ResultPrint = Await PrintFiscalReceipt();
	If Not ResultPrint Then
		Return;
	EndIf;
	DetailedInformation = R().S_030 + ": " + Format(CashbackAmount, "NFD=2; NZ=0;");
	SetDetailedInfo(DetailedInformation);
	
	DPPointOfSaleClient.BeforeStartNewTransaction(Object, ThisObject, DocRef);
	
	NewTransaction();
	Modified = False;
EndProcedure

&AtClient
Procedure AdvanceFormClose(Result, AdditionalData) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ArrayOfPayments = New Array();
	For Each Row In Result.Payments Do
		If Row.Amount < 0 Then
			Continue;
		EndIf;
		NewPayment = New Structure();
		NewPayment.Insert("PaymentType");
		NewPayment.Insert("PaymentTypeEnum");
		NewPayment.Insert("Amount");
		NewPayment.Insert("Account");
		NewPayment.Insert("BankTerm");
		NewPayment.Insert("Percent");
		NewPayment.Insert("Commission");
		FillPropertyValues(NewPayment, Row);
		ArrayOfPayments.Add(NewPayment);
	EndDo;
	CreateDocumentsAtServer(ArrayOfPayments);
	Object.RetailCustomer = Undefined;
EndProcedure

&AtServer
Procedure CreateDocumentsAtServer(ArrayOfPayments)
	// cash receipt
	CashReceiptTable = New ValueTable();
	CashReceiptTable.Columns.Add("Account");
	CashReceiptTable.Columns.Add("Amount");
	
	For Each Row In ArrayOfPayments Do
		If Row.PaymentTypeEnum = Enums.PaymentTypes.Cash Then
			NewRow = CashReceiptTable.Add();
			NewRow.Account = Row.Account;
			NewRow.Amount  = Row.Amount;
		EndIf;
	EndDo;
	
	CashReceiptTableGrouped = CashReceiptTable.Copy();
	CashReceiptTableGrouped.GroupBy("Account");
	For Each RowHeader In CashReceiptTableGrouped Do
		CashReceipt = BuilderAPI.Initialize("CashReceipt");
		BuilderAPI.SetProperty(CashReceipt, "Company"     , Object.Company, "PaymentList");
		BuilderAPI.SetProperty(CashReceipt, "Branch"      , Object.Branch, "PaymentList");
		BuilderAPI.SetProperty(CashReceipt, "Date"        , CurrentSessionDate(), "PaymentList");
		BuilderAPI.SetProperty(CashReceipt, "TransactionType" , Enums.IncomingPaymentTransactionType.CustomerAdvance, "PaymentList");
		BuilderAPI.SetProperty(CashReceipt, "CashAccount" , RowHeader.Account, "PaymentList");
	
		
		For Each RowList In CashReceiptTable.FindRows(New Structure("Account", RowHeader.Account)) Do	
			NewRow = BuilderAPI.AddRow(CashReceipt, "PaymentList");
			BuilderAPI.SetRowProperty(CashReceipt, NewRow, "RetailCustomer", Object.RetailCustomer, "PaymentList");
			BuilderAPI.SetRowProperty(CashReceipt, NewRow, "TotalAmount"   , RowList.Amount, "PaymentList");
		EndDo;
		BuilderAPI.Write(CashReceipt, DocumentWriteMode.Posting);
	EndDo;
	
	// bank receipt
	BankReceiptTable = New ValueTable();
	BankReceiptTable.Columns.Add("Account");
	BankReceiptTable.Columns.Add("PaymentType");
	BankReceiptTable.Columns.Add("PaymentTerminal");
	BankReceiptTable.Columns.Add("BankTerm");
	BankReceiptTable.Columns.Add("Amount");
	
	For Each Row In ArrayOfPayments Do
		If Row.PaymentTypeEnum = Enums.PaymentTypes.Card Then
			NewRow = BankReceiptTable.Add();
			NewRow.Account         = Row.Account;
			NewRow.PaymentType     = Row.PaymentType;
//			NewRow.PaymentTerminal = Row.PaymentTerminal;
			NewRow.BankTerm        = Row.BankTerm;
			NewRow.Amount          = Row.Amount;
		EndIf;
	EndDo;
	
	BankReceiptTableGrouped = BankReceiptTable.Copy();
	BankReceiptTableGrouped.GroupBy("Account");
	For Each RowHeader In BankReceiptTableGrouped Do
		BankReceipt = BuilderAPI.Initialize("BankReceipt");
		BuilderAPI.SetProperty(BankReceipt, "Company"     , Object.Company, "PaymentList");
		BuilderAPI.SetProperty(BankReceipt, "Branch"      , Object.Branch, "PaymentList");
		BuilderAPI.SetProperty(BankReceipt, "Date"        , CurrentSessionDate(), "PaymentList");
		BuilderAPI.SetProperty(BankReceipt, "TransactionType" , Enums.IncomingPaymentTransactionType.CustomerAdvance, "PaymentList");
		BuilderAPI.SetProperty(BankReceipt, "Account" , RowHeader.Account, "PaymentList");
	
		For Each RowList In BankReceiptTable.FindRows(New Structure("Account", RowHeader.Account)) Do	
			NewRow = BuilderAPI.AddRow(BankReceipt, "PaymentList");
			BuilderAPI.SetRowProperty(BankReceipt, NewRow, "RetailCustomer"   , Object.RetailCustomer, "PaymentList");
			BuilderAPI.SetRowProperty(BankReceipt, NewRow, "PaymentType"      , RowList.PaymentType, "PaymentList");
			BuilderAPI.SetRowProperty(BankReceipt, NewRow, "BankTerm"         , RowList.BankTerm, "PaymentList");
//			BuilderAPI.SetRowProperty(BankReceipt, NewRow, "PaymentTerminal"  , RowList.PaymentTerminal, "PaymentList");
			BuilderAPI.SetRowProperty(BankReceipt, NewRow, "TotalAmount"      , RowList.Amount, "PaymentList");
		EndDo;
		BuilderAPI.Write(BankReceipt, DocumentWriteMode.Posting);
	EndDo;
	
EndProcedure	

&AtClient
Procedure NewTransaction()
	NewTransactionAtServer();
	Cancel = False;
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
	EndIf;
	
	EnabledPaymentButton();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Async Function PrintFiscalReceipt()
	If Object.ConsolidatedRetailSales.IsEmpty() Then
		Return True;
	EndIf;
	
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(Object.ConsolidatedRetailSales, DocRef);
	Return EquipmentPrintFiscalReceiptResult.Success;
EndFunction

&AtServer
Procedure NewTransactionAtServer()
	ObjectValue = Documents.RetailSalesReceipt.CreateDocument();
	ObjectValue.Fill(Undefined);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ValueToFormAttribute(ObjectValue, "Object");
	Cancel = False;
	DocRetailSalesReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, True);
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		If ThisObject.ConsolidatedRetailSales.IsEmpty() Then
			ChangeConsolidatedRetailSales(Object, ThisObject, 
				DocConsolidatedRetailSalesServer.GetDocument(Object.Company, Object.Branch, ThisObject.Workstation));
		Else
			Object.ConsolidatedRetailSales = ThisObject.ConsolidatedRetailSales;
		EndIf;
	EndIf;
	
	SalesPersonByDefault = Undefined;
	ThisObject.RetailBasis = Undefined;
	ThisObject.isReturn = False;
EndProcedure

&AtServer
Function WriteTransaction(Result)
	OneHundred = 100;
	If Result = Undefined Or Not Result.Payments.Count() Then
		Return 0;
	EndIf;
	Payments = Result.Payments.Unload();
	ZeroAmountFilter = New Structure();
	ZeroAmountFilter.Insert("Amount", 0);
	ZeroAmountFoundRows = Payments.FindRows(ZeroAmountFilter);
	ZeroAmountRows = New Array();
	For Each Row In ZeroAmountFoundRows Do
		ZeroAmountRows.Add(Row);
	EndDo;
	For Each Row In ZeroAmountRows Do
		Payments.Delete(Row);
	EndDo;
	For Each Row In Payments Do
		If Row.Percent Then
			Row.Commission = Row.Amount * Row.Percent / OneHundred;
		EndIf;
	EndDo;

	DocRef = Undefined;
	CashbackAmount = 0;
	
	If ThisObject.isReturn Then

		PaymentsTable = Result.Payments.Unload(); // ValueTable
		For Each PaymentsItem In PaymentsTable Do
			If PaymentsItem.Amount < 0 Then
				CashbackAmount = CashbackAmount + PaymentsItem.Amount * (-1);
			EndIf;
		EndDo;
		PaymentsTable.GroupBy("Account,BankTerm,PaymentType,PaymentTypeEnum", "Amount,Commission");
		
		If ThisObject.RetailBasis.IsEmpty() Then
			CreateReturnWithoutBase(PaymentsTable);
		Else
			CreateReturnOnBase(PaymentsTable);
		EndIf;
		
	Else
		
		ObjectValue = FormAttributeToValue("Object");
		ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
		ObjectValue.Payments.Load(Payments);
		ObjectValue.PaymentMethod = Result.ReceiptPaymentMethod;
		DPPointOfSaleServer.BeforePostingDocument(ObjectValue);
	
		ObjectValue.Write(DocumentWriteMode.Posting);
		
		DocRef = ObjectValue.Ref;
		DPPointOfSaleServer.AfterPostingDocument(DocRef);
	
	EndIf;

	CashAmountFilter = New Structure();
	CashAmountFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashAmountFoundRows = Payments.FindRows(CashAmountFilter);
	For Each Row In CashAmountFoundRows Do
		If Row.Amount < 0 Then
			CashbackAmount = CashbackAmount + Row.Amount * (-1);
		EndIf;
	EndDo;
	
	Return CashbackAmount;
EndFunction

&AtClient
Procedure ShowPictures()
	Items.ItemListShowPictures.Check = Not Items.ItemPicture.Visible;
	Items.ItemPicture.Visible = Items.ItemListShowPictures.Check;
EndProcedure

&AtClient
Procedure ShowItems()
	SetShowItems();
EndProcedure

&AtClient
Procedure SetShowItems()
	Items.PageButtons.CurrentPage = Items.GroupItems;
EndProcedure

&AtClient
Procedure EnabledPaymentButton()
	Items.qPayment.Enabled = Object.ItemList.Count() > 0;
	Items.CommandBarPayments.Enabled = Object.ItemList.Count() = 0;
	SetPaymentButtonOnServer();
EndProcedure

&AtServer
Procedure SetPaymentButtonOnServer()
	ColorGreen = StyleColors.AccentColor;
	ColorRed = StyleColors.NegativeTextColor;
	
	If ThisObject.isReturn Then
		Items.qPayment.Title = R().InfoMessage_PaymentReturn;
		Items.qPayment.TextColor = ColorRed;
	Else
		Items.qPayment.Title = R().InfoMessage_Payment;
		Items.qPayment.TextColor = ColorGreen;
	EndIf;
	Items.qPayment.BorderColor = ColorGreen;
	Items.GroupPaymentButtons.Enabled = True;
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		If Not ValueIsFilled(Object.ConsolidatedRetailSales) Then
			Items.qPayment.Title = R().InfoMessage_SessionIsClosed;
			Items.qPayment.TextColor = ColorRed;
			Items.qPayment.BorderColor = ColorRed;
			Items.GroupPaymentButtons.Enabled = False;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure BuildDetailedInformation(ItemKey)
	If Not ValueIsFilled(ItemKey) Then
		DetailedInformation = "";
		Return;
	EndIf;
	ItemListFilter = New Structure();
	ItemListFilter.Insert("ItemKey", ItemKey);
	FoundItemKeyRows = Object.ItemList.FindRows(ItemListFilter);
	InfoItem = PredefinedValue("Catalog.Items.EmptyRef");
	InfoPrice = 0;
	InfoQuantity = 0;
	InfoOffersAmount = 0;
	InfoTotalAmount = 0;
	For Each FoundItemKeyRow In FoundItemKeyRows Do
		InfoItem = FoundItemKeyRow.Item;
		InfoPrice = FoundItemKeyRow.Price;
		InfoOffersAmount = InfoOffersAmount + FoundItemKeyRow.OffersAmount;
		InfoQuantity = InfoQuantity + FoundItemKeyRow.Quantity;
		InfoTotalAmount = InfoTotalAmount + FoundItemKeyRow.TotalAmount;
	EndDo;
	DetailedInformation = String(InfoItem) + ?(ValueIsFilled(ItemKey), " [" + String(ItemKey) + "]", "]") + " " + InfoQuantity
		+ " x " + Format(InfoPrice, "NFD=2; NZ=0.00;") + ?(ValueIsFilled(InfoOffersAmount), "-" + Format(
		InfoOffersAmount, "NFD=2; NZ=0.00;"), "") + " = " + Format(InfoTotalAmount, "NFD=2; NZ=0.00;");
	
	SetDetailedInfo(DetailedInformation);
EndProcedure

&AtClient
Procedure ClearRetailCustomer(Command)
	Object.RetailCustomer = Undefined;
	DocRetailSalesReceiptClient.RetailCustomerOnChange(Object, ThisObject, Undefined);

	ClearRetailCustomerAtServer();
	DocRetailSalesReceiptClient.AgreementOnChange(Object, ThisObject, Items.RetailCustomer);
EndProcedure

&AtServer
Procedure ClearRetailCustomerAtServer()
	ObjectValue = FormAttributeToValue("Object");
	FillingWithDefaultDataEvent.FillingWithDefaultDataFilling(ObjectValue, Undefined, Undefined, True, True);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ValueToFormAttribute(ObjectValue, "Object");
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.ItemKey) Then
			Row.Item = Row.ItemKey.Item;
		Else
			Row.Item = Undefined;
		EndIf;
	EndDo;
EndProcedure

&AtClientAtServerNoContext
Procedure ChangeConsolidatedRetailSales(Object, Form, NewDocument)
	Form.ConsolidatedRetailSales = NewDocument;
	Object.ConsolidatedRetailSales = NewDocument;
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	Return;
EndProcedure

&AtServer
Procedure PutToTaxTable_(ItemName, Key, Value) Export
	Return;
EndProcedure

&AtServer
Procedure Taxes_CreateFormControls() Export
	ColumnFieldParameters = New Structure();
	ColumnFieldParameters.Insert("Visible", False);

	TaxesParameters = TaxesServer.GetCreateFormControlsParameters();
	TaxesParameters.Date = Object.Date;
	TaxesParameters.Company = Object.Company;
	TaxesParameters.PathToTable = "Object.ItemList";
	TaxesParameters.ItemParent = ThisObject.Items.ItemList;
	TaxesParameters.ColumnOffset = ThisObject.Items.ItemListOffersAmount;
	TaxesParameters.ItemListName = "ItemList";
	TaxesParameters.TaxListName = "TaxList";
	TaxesParameters.TotalAmountColumnName = "ItemListTotalAmount";
	TaxesParameters.ColumnFieldParameters = ColumnFieldParameters;
	TaxesServer.CreateFormControls(Object, ThisObject, TaxesParameters);
EndProcedure

&AtServer
Procedure Taxes_CreateTaxTree() Export
	Return;
EndProcedure

#EndRegion

#EndRegion

&AtClient
Procedure CreateCashIn(Command)
	Items.GroupMainPages.CurrentPage = Items.CashPage;
EndProcedure

&AtClient
Procedure ReturnToMain(Command)
	Items.GroupMainPages.CurrentPage = Items.MainPage;
EndProcedure

&AtClient
Procedure CashInListSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.CashInList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CashInData = New Structure();
	CashInData.Insert("MoneyTransfer"           , CurrentData.MoneyTransfer);
	CashInData.Insert("Currency"                , CurrentData.Currency);
	CashInData.Insert("Amount"                  , CurrentData.Amount);
	CashInData.Insert("ConsolidatedRetailSales" , Object.ConsolidatedRetailSales);
	
	FillingData = GetFillingDataMoneyTransferForCashReceipt(CashInData);
	OpenForm(
		"Document.CashReceipt.ObjectForm", 
		New Structure("FillingValues", FillingData), , 
		New UUID(), , ,
		New NotifyDescription("CreateCashInFinish", ThisObject),
		FormWindowOpeningMode.LockWholeInterface);	
EndProcedure

&AtClient
Procedure CreateCashInFinish(Result, AddInfo) Export
	FillCashInList();
EndProcedure

&AtClient
Procedure UpdateMoneyTransfers(Command)
	FillCashInList();
EndProcedure

&AtClient
Procedure CreateCashOut(Command, AutoCreateMoneyTransfer = False)
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("AutoCreateMoneyTransfer", AutoCreateMoneyTransfer);
	OpenFormParameters.Insert("FillingData", GetFillingDataMoneyTransfer(0));
	OpenForm("DataProcessor.PointOfSale.Form.CashOut", 
			OpenFormParameters, , 
			UUID, , , 
			New NotifyDescription("CreateCashOutFinish", ThisObject), 
			FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure CreateCashOutFinish(Result, AddInfo) Export
	If TypeOf(Result) = Type("String") Then
		CommonFunctionsClientServer.ShowUsersMessage(Result);
	EndIf;
EndProcedure

&AtServer
Function GetFillingDataMoneyTransfer(CashOutAmount)
	POSCashAccount = ThisObject.Workstation.CashAccount;
	
	FillingData = New Structure();
	FillingData.Insert("BasedOn" , "PointOfSale");	
	FillingData.Insert("Date"    , CommonFunctionsServer.GetCurrentSessionDate());	
	FillingData.Insert("Company" , Object.Company);	
	FillingData.Insert("Branch"  , Object.Branch);
	
	FillingData.Insert("Sender"  , POSCashAccount);
	FillingData.Insert("Receiver"  , POSCashAccount.CashAccount);
	
	FillingData.Insert("SendCurrency"    , POSCashAccount.Currency);
	FillingData.Insert("ReceiveCurrency" , POSCashAccount.Currency);
	
	FillingData.Insert("SendFinancialMovementType"     , POSCashAccount.FinancialMovementType);
	FillingData.Insert("ReceiveFinancialMovementType"  , POSCashAccount.FinancialMovementType);
	
	FillingData.Insert("SendUUID"    , String(New UUID()));
	FillingData.Insert("ReceiveUUID" , String(New UUID()));
	
	FillingData.Insert("SendAmount"    , CashOutAmount);
	FillingData.Insert("ReceiveAmount" , CashOutAmount);
	
	Return FillingData;
EndFunction

&AtServer
Function GetFillingDataMoneyTransferForCashReceipt(CashInData)
	FillingData = New Structure();
	FillingData.Insert("BasedOn" , "MoneyTransfer");	
	FillingData.Insert("Date"    , CommonFunctionsServer.GetCurrentSessionDate());	
	FillingData.Insert("TransactionType", Enums.IncomingPaymentTransactionType.CashIn);	
	FillingData.Insert("Company"        , CashInData.MoneyTransfer.Company);	
	FillingData.Insert("Branch"         , CashInData.MoneyTransfer.Branch);	
	FillingData.Insert("CashAccount"    , ThisObject.Workstation.CashAccount);	
	FillingData.Insert("Currency"       , CashInData.Currency);
	FillingData.Insert("ConsolidatedRetailSales" , CashInData.ConsolidatedRetailSales);	
	FillingData.Insert("PaymentList"    , New Array());	
	NewRow = New Structure();
	NewRow.Insert("TotalAmount"           , CashInData.Amount);	
	NewRow.Insert("MoneyTransfer"         , CashInData.MoneyTransfer);	
	NewRow.Insert("FinancialMovementType" , CashInData.MoneyTransfer.ReceiveFinancialMovementType);
	FillingData.PaymentList.Add(NewRow);
	
	Return FillingData;	
EndFunction

&AtServer
Procedure FillCashInList()
	ThisObject.CashInList.Clear();
	If Not ValueIsFilled(ThisObject.Workstation) Then
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	R3021B_CashInTransitIncoming.Basis AS MoneyTransfer,
	|	R3021B_CashInTransitIncoming.Currency AS Currency,
	|	R3021B_CashInTransitIncoming.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3021B_CashInTransitIncoming.Balance(,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND ReceiptingAccount = &CashAccount) AS R3021B_CashInTransitIncoming";
	Query.SetParameter("CashAccount", Workstation.CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ThisObject.CashInList.Add(), QuerySelection);
	EndDo;
EndProcedure

&AtClient
Procedure FindRetailBasis(RowID)
	FormParameters = New Structure;
	FormParameters.Insert("RetailCustomer", ThisObject.Object.RetailCustomer);
	
	If RowID = Undefined And Object.ItemList.Count() > 0 Then
		RowID = Object.ItemList[0].GetID();
	EndIf;
	
	If Not RowID = Undefined Then
		CurrentRow = Object.ItemList.FindByID(RowID);
		FormParameters.Insert("ItemKey", CurrentRow.ItemKey);
	EndIf;
	
	NotifyDescription = New NotifyDescription("FindRetailBasisFinish", ThisObject, RowID);
	OpenForm("CommonForm.SelectionRetailBasisForReturn", 
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure FindRetailBasisFinish(Result, RowID) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.RetailBasis = Result;
	FillingAndCheckByRetailBasis();
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure FillingAndCheckByRetailBasis()
	
	ThisObject.BasisPayments.Clear();
	ThisObject.BasisPayments.Load(ThisObject.RetailBasis.Payments.Unload(, "PaymentType,Amount"));
	
	SaleData = GetSaleData(ThisObject.RetailBasis);
	
	ArrayOfBasises = New Array();
	ArrayOfBasises.Add(ThisObject.RetailBasis);
	MainFilter = New Structure();
	MainFilter.Insert("Ref", PredefinedValue("Document.RetailReturnReceipt.EmptyRef"));
	MainFilter.Insert("Basises", ArrayOfBasises); 
	BasisesTable = RowIDInfoPrivileged.GetBasises(MainFilter.Ref, MainFilter);

	If ThisObject.Object.ItemList.Count() = 0 Then
		
		For Each BasisesTableItem In BasisesTable Do
			NewRecord = ThisObject.Object.ItemList.Add();
			NewRecord.RetailBasis = BasisesTableItem.Basis;
			NewRecord.Store = BasisesTableItem.Store;
			NewRecord.Key = BasisesTableItem.Key;
			NewRecord.Item = BasisesTableItem.Item;
			NewRecord.ItemKey = BasisesTableItem.ItemKey;
			NewRecord.Unit = BasisesTableItem.BasisUnit;
			NewRecord.QuantityInBaseUnit = BasisesTableItem.QuantityInBaseUnit;
			NewRecord.Quantity = NewRecord.QuantityInBaseUnit;
			
			SaleRow = SaleData.Find(BasisesTableItem.Key, "Key");
			If Not SaleRow = Undefined Then
				NewRecord.PriceType = SaleRow.PriceType;
				NewRecord.Price = SaleRow.Price;
				NewRecord.TotalAmount = NewRecord.Price * NewRecord.Quantity;
				NewRecord.NetAmount = NewRecord.TotalAmount;
				NewRecord.TaxAmount = 0;
				NewRecord.OffersAmount = 0;
			EndIf;
		EndDo;
		
	Else
		
		For Each ListItem In ThisObject.Object.ItemList Do
			BasisKey = "";
			NeedQuantity = ListItem.QuantityInBaseUnit;
			BasisRows = BasisesTable.FindRows(New Structure("ItemKey", ListItem.ItemKey));
			For Each BasisRow In BasisRows Do
				BasisKey = BasisRow.Key;
				UseQuantity = Min(NeedQuantity, BasisRow.QuantityInBaseUnit);
				BasisRow.QuantityInBaseUnit = BasisRow.QuantityInBaseUnit - UseQuantity;
				NeedQuantity = NeedQuantity - UseQuantity;
				If NeedQuantity = 0 Then
					Break;
				EndIf;
			EndDo;
			If NeedQuantity > 0 Then
				ErrorMessageString = StrTemplate(R().POS_Error_ReturnAmountLess, 
					ListItem.ItemKey,
					Format(ListItem.QuantityInBaseUnit, "NZ=; NG=;"),
					Format((ListItem.QuantityInBaseUnit - NeedQuantity), "NZ=; NG=;"),
					ThisObject.RetailBasis);
				CommonFunctionsClientServer.ShowUsersMessage(ErrorMessageString);
				ListItem.RetailBasis = Undefined;
			Else
				ListItem.RetailBasis = ThisObject.RetailBasis;
			EndIf;
			
			SaleRow = SaleData.Find(BasisKey, "Key");
			If Not SaleRow = Undefined Then
				ListItem.PriceType = SaleRow.PriceType;
				ListItem.Price = SaleRow.Price;
				ListItem.TotalAmount = ListItem.Price * ListItem.Quantity;
				ListItem.NetAmount = ListItem.TotalAmount;
				ListItem.TaxAmount = 0;
				ListItem.OffersAmount = 0;
			EndIf;
		EndDo;
		
	EndIf;
	
EndProcedure

&AtServer
Function GetSaleData(RetailRef)
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceiptItemList.Key,
	|	RetailSalesReceiptItemList.Item,
	|	RetailSalesReceiptItemList.ItemKey,
	|	RetailSalesReceiptItemList.Quantity,
	|	RetailSalesReceiptItemList.Price,
	|	RetailSalesReceiptItemList.PriceType
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref";
	Query.SetParameter("Ref", RetailRef);
	Return Query.Execute().Unload();
EndFunction
	
&AtServer
Procedure CreateReturnOnBase(PaymentData)

	ReturnData = ThisObject.Object.ItemList.Unload();
	ReturnData.GroupBy("ItemKey, RetailBasis", "QuantityInBaseUnit");
	ReturnData.Columns.RetailBasis.Name = "Basis";
	
	ArrayOfBasises = New Array();
	For Each ReturnItem In ReturnData Do
		If ValueIsFilled(ReturnItem.Basis) 
				And ArrayOfBasises.Find(ReturnItem.Basis) = Undefined Then
			ArrayOfBasises.Add(ReturnItem.Basis);
		EndIf;
	EndDo;
	
	MainFilter = New Structure();
	MainFilter.Insert("Ref", PredefinedValue("Document.RetailReturnReceipt.EmptyRef"));
	MainFilter.Insert("Basises", ArrayOfBasises); 
	BasisesTable = RowIDInfoPrivileged.GetBasises(MainFilter.Ref, MainFilter);
	
	ClearArray = New Array;
	RowFilter = New Structure("ItemKey, Basis");
	For Each BasisesTableItem In BasisesTable Do
		FillPropertyValues(RowFilter, BasisesTableItem);
		
		ReturnQuantity = 0;
		ReturnDataItems = ReturnData.FindRows(RowFilter);
		For Each ReturnDataItem In ReturnDataItems Do
			ReturnQuantity = ReturnQuantity + ReturnDataItem.QuantityInBaseUnit; 
		EndDo;
		
		If ReturnQuantity = 0 Then
			ClearArray.Add(BasisesTableItem);
		ElsIf BasisesTableItem.QuantityInBaseUnit > ReturnQuantity Then
			BasisesTableItem.QuantityInBaseUnit = ReturnQuantity;
		EndIf;
		For Each ReturnDataItem In ReturnDataItems Do
			If ReturnQuantity = 0 Then
				Break;
			EndIf; 
			CurrentAmount = Min(ReturnDataItem.QuantityInBaseUnit, ReturnQuantity);
			ReturnDataItem.QuantityInBaseUnit = ReturnDataItem.QuantityInBaseUnit - CurrentAmount; 
			ReturnQuantity = ReturnQuantity - CurrentAmount;
		EndDo;
	EndDo;
	For Each ClearItem In ClearArray Do
		BasisesTable.Delete(ClearItem);
	EndDo;
	
	BasisesTypes = New Array();
	For Each Doc In Metadata.Documents Do
		If Doc.TabularSections.Find("RowIDInfo") <> Undefined Then
			BasisesTypes.Add(Type("DocumentRef." + Doc.Name));
		EndIf;
	EndDo;
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Basis"          , New TypeDescription(BasisesTypes));
	ResultTable.Columns.Add("BasisKey"       , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("BasisUnit"      , New TypeDescription("CatalogRef.Units"));
	ResultTable.Columns.Add("Unit"           , New TypeDescription("CatalogRef.Units"));
	ResultTable.Columns.Add("CurrentStep"    , New TypeDescription("CatalogRef.MovementRules"));
	ResultTable.Columns.Add("IsMainDocument" , New TypeDescription("Boolean"));
	ResultTable.Columns.Add("Item"           , New TypeDescription("CatalogRef.Items"));
	ResultTable.Columns.Add("ItemKey"        , New TypeDescription("CatalogRef.ItemKeys"));
	ResultTable.Columns.Add("Key"            , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("ParentBasis"    , New TypeDescription(BasisesTypes));
	ResultTable.Columns.Add("QuantityInBaseUnit" , Metadata.DefinedTypes.typeQuantity.Type);
	ResultTable.Columns.Add("RowID"          , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("RowRef"         , New TypeDescription("CatalogRef.RowIDs"));
	ResultTable.Columns.Add("Store"          , New TypeDescription("CatalogRef.Stores"));
	
	For Each Row In BasisesTable Do
		NewRow = ResultTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Unit = Row.BasisUnit;
	EndDo;
	
	ExtractedData = RowIDInfoPrivileged.ExtractData(ResultTable, MainFilter.Ref);
	
	isFirst = True;
	For Each ExtractedDataItem In ExtractedData Do
		ExtractedDataItem.Payments.Clear();
		If isFirst Then
			isFirst = False;
			For Each PaymentDataItem In PaymentData Do
				FillPropertyValues(ExtractedDataItem.Payments.Add(), PaymentDataItem);
			EndDo;
		EndIf;
	EndDo;
	
	ArrayOfFillingValues = RowIDInfoPrivileged.ConvertDataToFillingValues(MainFilter.Ref.Metadata(), ExtractedData);
	
	NewDoc = Undefined;
	For Each FillingValues In ArrayOfFillingValues Do
		NewDoc = Documents.RetailReturnReceipt.CreateDocument();
		NewDoc.Date = CurrentSessionDate();
		NewDoc.Fill(FillingValues);
		NewDoc.Write();
	EndDo;
	If Not NewDoc = Undefined Then
		NewDoc.Write(DocumentWriteMode.Posting);
		DocRef = NewDoc.Ref;
		DPPointOfSaleServer.AfterPostingDocument(DocRef);
	EndIf;
	
EndProcedure

&AtServer
Procedure CreateReturnWithoutBase(PaymentData)
	
	FillingData = New Structure();
	FillingData.Insert("BasedOn"                , "RetailReturnReceipt");
	FillingData.Insert("RetailCustomer"         , Object.RetailCustomer);
	FillingData.Insert("Company"                , Object.Company);
	FillingData.Insert("Branch"                 , Object.Branch);
	FillingData.Insert("Partner"                , Object.Partner);
	FillingData.Insert("LegalName"              , Object.LegalName);
	FillingData.Insert("LegalNameContract"      , Object.LegalNameContract);
	FillingData.Insert("Agreement"              , Object.Agreement);
	FillingData.Insert("Currency"               , Object.Currency);
	FillingData.Insert("PriceIncludeTax"        , Object.PriceIncludeTax);
	FillingData.Insert("ManagerSegment"         , Object.ManagerSegment);
	FillingData.Insert("UsePartnerTransactions" , Object.UsePartnerTransactions);
	FillingData.Insert("Workstation"            , Object.Workstation);
	
	FillingData.Insert("Payments"               , PaymentData);
	FillingData.Insert("ItemList"               , GetItemListForReturn());
	
	NewDoc = Documents.RetailReturnReceipt.CreateDocument();
	NewDoc.Date = CurrentSessionDate();
	NewDoc.Fill(FillingData);
	NewDoc.Write(DocumentWriteMode.Posting);
	
	DocRef = NewDoc.Ref;
	DPPointOfSaleServer.AfterPostingDocument(DocRef);
		
EndProcedure

Function GetItemListForReturn()
	Result = New Array;
	For Each ListItem In ThisObject.Object.ItemList Do
		NewRecord = New Structure;
		NewRecord.Insert("Key",       "");
		NewRecord.Insert("Store",     ListItem.Store);
		NewRecord.Insert("Item",      ListItem.Item);
		NewRecord.Insert("ItemKey",   ListItem.ItemKey);
		NewRecord.Insert("Unit",      ListItem.Unit);
		NewRecord.Insert("Quantity",  ListItem.Quantity);
		NewRecord.Insert("Price",     ListItem.Price);
		NewRecord.Insert("IsService", ListItem.IsService);
		Result.Add(NewRecord);
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure CheckRetailBasis()
	If ThisObject.isReturn And Not ThisObject.RetailBasis.IsEmpty() Then
		FillingAndCheckByRetailBasis();
	EndIf;
EndProcedure