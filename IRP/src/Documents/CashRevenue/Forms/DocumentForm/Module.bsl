#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashExpenseRevenueServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocCashExpenseRevenueServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocCashExpenseRevenueServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsOtherCompanyExpense = (Object.TransactionType = PredefinedValue("Enum.CashRevenueTransactionTypes.OtherCompanyRevenue"));
	
	Form.Items.OtherCompany.Visible       = IsOtherCompanyExpense;
	Form.Items.PaymentListPartner.Visible = IsOtherCompanyExpense;
	
	Form.Items.PaymentListCurrency.ReadOnly = ValueIsFilled(Form.Currency);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocCashExpenseRevenueClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocCashExpenseRevenueClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ACCOUNT

&AtClient
Procedure AccountOnChange(Item)
	DocCashExpenseRevenueClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashExpenseRevenueClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocCashExpenseRevenueClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocCashExpenseRevenueClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_LIST

&AtClient
Procedure PaymentListSelection(Item, RowSelected, Field, StandardProcessing)
	DocCashExpenseRevenueClient.PaymentListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocCashExpenseRevenueClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocCashExpenseRevenueClient.PaymentListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region REVENUE_TYPE

&AtClient
Procedure PaymentListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashExpenseRevenueClient.PaymentListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashExpenseRevenueClient.PaymentListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashExpenseRevenueClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashExpenseRevenueClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

&AtClient
Procedure PaymentListDontCalculateRowOnChange(Item)
	DocCashExpenseRevenueClient.PaymentListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocCashExpenseRevenueClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocCashExpenseRevenueClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocCashExpenseRevenueClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocCashExpenseRevenueClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V2(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

