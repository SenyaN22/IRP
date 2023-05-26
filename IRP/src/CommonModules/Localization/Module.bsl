// @strict-types

// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
// Structure
Function Strings(Lang) Export

	Strings = New Structure();

#Region SMS
	Strings.Insert("SMS_SendIsOk", NStr("en = 'SMS sent successfully'", Lang));
	Strings.Insert("SMS_SendIsError", NStr("en = 'Error while SMS send'", Lang));
	Strings.Insert("SMS_WaitUntilNextSend", NStr("en = 'Wait until next send. %1 second'", Lang));
	Strings.Insert("SMS_SMSCodeWrong", NStr("en = 'Not valid SMS code. Try again.'", Lang));



#EndRegion

#Region AdditionalTableControl

	Strings.Insert("ATC_001", NStr("en = 'Unknown document type: %1'", Lang));
	Strings.Insert("ATC_ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList", NStr("en = 'Row: %1. Tax amount in item list is not equal to tax amount in tax list'", Lang));
	Strings.Insert("ATC_ErrorNetAmountGreaterTotalAmount", NStr("en = 'Row: %1. Net amount is greater than total amount'", Lang));
	Strings.Insert("ATC_ErrorQuantityIsZero", NStr("en = 'Row: %1. Quantity is zero'", Lang));
	Strings.Insert("ATC_ErrorQuantityInBaseUnitIsZero", NStr("en = 'Row: %1. Quantity in base unit is zero'", Lang));
	Strings.Insert("ATC_ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList", NStr("en = 'Row: %1. Offers amount in item list is not equal to offers amount in offers list'", Lang));
	Strings.Insert("ATC_ErrorItemTypeIsNotService", NStr("en = 'Row: %1. Item type is not service'", Lang));
	Strings.Insert("ATC_ErrorItemTypeUseSerialNumbers", NStr("en = 'Row: %1. Item type uses serial numbers'", Lang));
	Strings.Insert("ATC_ErrorUseSerialButSerialNotSet", NStr("en = 'Row: %1. Serial is not set but is required'", Lang));
	Strings.Insert("ATC_ErrorNotTheSameQuantityInSerialListTableAndInItemList", NStr("en = 'Row: %1. Quantity in serial list table is not the same as quantity in item list'", Lang));
	Strings.Insert("ATC_ErrorItemNotEqualItemInItemKey", NStr("en = 'Row: %1. Item is not equal to item in item key'", Lang));
	Strings.Insert("ATC_ErrorTotalAmountMinusNetAmountNotEqualTaxAmount", NStr("en = 'Row: %1. Total amount minus net amount is not equal to tax amount'", Lang));
	Strings.Insert("ATC_ErrorQuantityInItemListNotEqualQuantityInRowID", NStr("en = 'Row: %1. Quantity in item list is not equal to quantity in row ID'", Lang));
	Strings.Insert("ATC_ErrorQuantityNotEqualQuantityInBaseUnit", NStr("en = 'Row: %1. Quantity not equal quantity in base unit when unit quantity equal 1'", Lang));
	Strings.Insert("ATC_ErrorNotFilledQuantityInSourceOfOrigins", NStr("en = 'Row: %1. Not filled quantity in source of origins'", Lang));
	Strings.Insert("ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber", NStr("en = 'Row: %1. Quantity in source of origins diff quantity in serial lot number'", Lang));
	Strings.Insert("ATC_ErrorQuantityInSourceOfOriginsDiffQuantityInItemList", NStr("en = 'Row: %1. Quantity in source of origins diff quantity in item list'", Lang));
	Strings.Insert("ATC_ErrorNotFilledUnit", NStr("en = 'Row: %1. Not filled Unit'", Lang));
	
#EndRegion

#Region Equipment
	Strings.Insert("Eq_001", NStr("en = 'Installed'", Lang));
	Strings.Insert("Eq_002", NStr("en = 'Not installed'", Lang));
	Strings.Insert("Eq_003", NStr("en = 'There are no errors.'", Lang));
	Strings.Insert("Eq_004", NStr("en = '%1 connected.'", Lang));
	Strings.Insert("Eq_005", NStr("en = '%1 NOT connected.'", Lang));
	Strings.Insert("Eq_006", NStr("en = 'Installed on current PC.'", Lang));
	Strings.Insert("Eq_007", NStr("en = 'Can not connect device %1'", Lang));
	Strings.Insert("Eq_008", NStr("en = '%1 disconnected.'", Lang));
	Strings.Insert("Eq_009", NStr("en = '%1 NOT disconnected.'", Lang));
	Strings.Insert("Eq_010", NStr("en = 'Can not disconnect device %1'", Lang));
	Strings.Insert("Eq_011", NStr("en = 'Already connected'", Lang));
	Strings.Insert("Eq_012", NStr("en = 'Already disconnected'", Lang));
	
	Strings.Insert("EqError_001", NStr(
		"en = 'The device is connected. The device must be disabled before the operation.'", Lang));

	Strings.Insert("EqError_002", NStr("en = 'The device driver could not be downloaded.
									   |Check that the driver is correctly installed and registered in the system.'",
		Lang));

	Strings.Insert("EqError_003", NStr("en = 'It has to be minimum one dot at Add ID.'", Lang));
	Strings.Insert("EqError_004", NStr("en = 'Before install driver - it has to be loaded.'", Lang));
	Strings.Insert("EqError_005", NStr("en = 'The equipment driver %1 has incorrect AddIn ID %2.'", Lang));
	
	Strings.Insert("EqFP_ShiftAlreadyOpened", NStr("en = 'Shift already opened.'", Lang));
	Strings.Insert("EqFP_ShiftIsNotOpened", NStr("en = 'Shift is not opened.'", Lang));
	Strings.Insert("EqFP_ShiftAlreadyClosed", NStr("en = 'Shift already closed.'", Lang));
	Strings.Insert("EqFP_DocumentAlreadyPrinted", NStr("en = 'The document is already printed.'", Lang));
	
	Strings.Insert("EqAc_AlreadyhasTransaction", NStr("en = 'The document is already has transaction code. Transaction already was done. Else clear RRN code.'", Lang));
	
	Strings.Insert("EqFP_CanNotOpenSessionRegistrationKM", NStr("en = 'Can not open session registration KM.'", Lang));
	Strings.Insert("EqFP_CanNotRequestKM", NStr("en = 'Can not request KM.'", Lang));
	Strings.Insert("EqFP_CanNotGetProcessingKMResult", NStr("en = 'Can not get processing KM result.'", Lang));
	Strings.Insert("EqFP_CanNotCloseSessionRegistrationKM", NStr("en = 'Can not close session registration KM.'", Lang));
	Strings.Insert("EqFP_GetWrongAnswerFromProcessingKM", NStr("en = 'Get wrong answer from Processing KM.'", Lang));
	Strings.Insert("EqFP_ScanedCodeStringAlreadyExists", NStr("en = 'Current barcode already use at document line: %1'", Lang));

	Strings.Insert("EqFP_ProblemWhileCheckCodeString", NStr("en = 'Problem while check code: %1'", Lang));

	Strings.Insert("EqFP_ErrorWhileConfirmCode", NStr("en = 'Error while confirm code on request: %1'", Lang));
#EndRegion

#Region POS

	Strings.Insert("POS_s1", NStr("en = 'Amount paid is less than amount of the document'", Lang));
	Strings.Insert("POS_s2", NStr("en = 'Card fees are more than the amount of the document'", Lang));
	Strings.Insert("POS_s3", NStr("en = 'There is no need to use cash, as card payments are sufficient to pay'", Lang));
	Strings.Insert("POS_s4", NStr("en = 'Amounts of payments are incorrect'", Lang));
	Strings.Insert("POS_s5", NStr("en = 'Select sales person'", Lang));
	Strings.Insert("POS_s6", NStr("en = 'Clear all Items before closing POS'", Lang));
	
	Strings.Insert("POS_Error_ErrorOnClosePayment", NStr("en = 'Cancel all payment before close form.'", Lang));
	Strings.Insert("POS_Error_ErrorOnPayment", NStr("en = 'There some problem to do payment with %1. Retry?'", Lang));
	Strings.Insert("POS_Error_CancelPayment", NStr("en = 'Operation with %1 by amount: %2 will be canceled.'", Lang));
	Strings.Insert("POS_Error_CancelPaymentProblem", NStr("en = 'Cancle payment problem [%1: %2]. Payment not canceled.
																|Copy message and send it to administrator'", Lang));
	Strings.Insert("POS_Error_ReturnAmountLess", NStr(
		"en = 'There are %2 of ""%1"", which is more than the available %3 for return in document ""%4"" .'", Lang));
	Strings.Insert("POS_Error_CannotFindUser", NStr("en = 'Can not find user with barcode [%1]'", Lang));
	
	Strings.Insert("POS_Error_ThisBarcodeFromAnotherItem", NStr("en = 'This is barcode used for %1'", Lang));
	Strings.Insert("POS_Error_ThisIsNotControleStringBarcode", NStr("en = 'Scan control string barcode. Wrong barcode %1'", Lang));
	Strings.Insert("POS_Error_CheckFillingForAllCodes", NStr("en = 'Scan control string for each item.'", Lang));
	
#EndRegion

#Region Service
	
	// %1 - localhost
	// %2 - 8080 
	// %3 - There is no internet connection
	Strings.Insert("S_002", NStr("en = 'Cannot connect to %1:%2. Details: %3'", Lang));
	
	// %1 - localhost
	// %2 - 8080
	Strings.Insert("S_003", NStr("en = 'Received response from %1:%2'", Lang));
	Strings.Insert("S_004", NStr("en = 'Resource address is empty.'", Lang));
	
	// %1 - connection_to_other_system
	Strings.Insert("S_005", NStr("en = 'Integration setting with name %1 is not found.'", Lang));
	Strings.Insert("S_006", NStr("en = 'Method is not supported in Web Client.'", Lang));
	
	// Special offers
	Strings.Insert("S_013", NStr("en = 'Unsupported object type: %1.'", Lang));
	
	// FileTransfer
	Strings.Insert("S_014", NStr("en = 'File name is empty.'", Lang));
	Strings.Insert("S_015", NStr("en = 'Path for saving is not set.'", Lang));
	
	// Test connection
	// %1 - Method unsupported on web client
	// %2 - 404
	// %3 - Text frim site
	Strings.Insert("S_016", NStr("en = '%1 Status code: %2 %3'", Lang));
	
	//	scan barcode
	Strings.Insert("S_018", NStr("en = 'Item added.'", Lang)); 
	
	// %1 - 123123123123
	Strings.Insert("S_019", NStr("en = 'Barcode %1 not found.'", Lang));
	Strings.Insert("S_022", NStr("en = 'Currencies in the base documents must match.'", Lang));
	Strings.Insert("S_023", NStr("en = 'Procurement method'", Lang));

	Strings.Insert("S_026", NStr("en = 'Selected icon will be resized to 16x16 px.'", Lang));

	// presentation of empty value for query result
	Strings.Insert("S_027", NStr("en = '[Not filled]'", Lang));
	// operation is Success
	Strings.Insert("S_028", NStr("en = 'Success'", Lang));
	Strings.Insert("S_029", NStr("en = 'Not supporting web client'", Lang));
	Strings.Insert("S_030", NStr("en = 'Cashback'", Lang));
	Strings.Insert("S_031", NStr("en = 'or'", Lang));
	Strings.Insert("S_032", NStr("en = 'Add code, ex: CommonFunctionsServer.GetCurrentSessionDate()'", Lang));
#EndRegion

#Region Service
	Strings.Insert("Form_001", NStr("en = 'New page'", Lang));
	Strings.Insert("Form_002", NStr("en = 'Delete'", Lang));
	Strings.Insert("Form_003", NStr("en = 'Quantity'", Lang));
	Strings.Insert("Form_004", NStr("en = 'Customers terms'", Lang));
	Strings.Insert("Form_005", NStr("en = 'Customers'", Lang));
	Strings.Insert("Form_006", NStr("en = 'Vendors'", Lang));
	Strings.Insert("Form_007", NStr("en = 'Vendors terms'", Lang));
	Strings.Insert("Form_008", NStr("en = 'User'", Lang));
	Strings.Insert("Form_009", NStr("en = 'User group'", Lang));
	Strings.Insert("Form_013", NStr("en = 'Date'", Lang));
	Strings.Insert("Form_014", NStr("en = 'Number'", Lang));
	
	// change icon
	Strings.Insert("Form_017", NStr("en = 'Change'", Lang));
	
	// clear icon
	Strings.Insert("Form_018", NStr("en = 'Clear'", Lang));
	
	// cancel answer on question
	Strings.Insert("Form_019", NStr("en = 'Cancel'", Lang));
	
	// PriceInfo report 
	Strings.Insert("Form_022", NStr("en = '1. By item keys'", Lang));
	Strings.Insert("Form_023", NStr("en = '2. By properties'", Lang));
	Strings.Insert("Form_024", NStr("en = '3. By items'", Lang));

	Strings.Insert("Form_025", NStr("en = 'Create from classifier'", Lang));

	Strings.Insert("Form_026", NStr("en = 'Item Bundle'", Lang));
	Strings.Insert("Form_027", NStr("en = 'Item'", Lang));
	Strings.Insert("Form_028", NStr("en = 'Item type'", Lang));
	Strings.Insert("Form_029", NStr("en = 'External attributes'", Lang));
	Strings.Insert("Form_030", NStr("en = 'Dimensions'", Lang));
	Strings.Insert("Form_031", NStr("en = 'Weight information'", Lang));
	Strings.Insert("Form_032", NStr("en = 'Period'", Lang));
	Strings.Insert("Form_033", NStr("en = 'Show all'", Lang));
	Strings.Insert("Form_034", NStr("en = 'Hide all'", Lang));
	Strings.Insert("Form_035", NStr("en = 'Head'", Lang));
	Strings.Insert("Form_036", NStr("en = 'Set as default'", Lang));
	Strings.Insert("Form_037", NStr("en = 'Unset as default'", Lang));
	Strings.Insert("Form_038", NStr("en = 'Employee'", Lang));
#EndRegion

#Region ErrorMessages

	// %1 - en
	Strings.Insert("Error_002", NStr("en = '%1 description is empty'", Lang));
	Strings.Insert("Error_003", NStr("en = 'Fill any description.'", Lang));
	Strings.Insert("Error_004", NStr("en = 'Metadata is not supported.'", Lang));
	
	// %1 - en
	Strings.Insert("Error_005", NStr("en = 'Fill the description of an additional attribute %1.'", Lang));
	Strings.Insert("Error_008", NStr("en = 'Groups are created by an administrator.'", Lang));
	
	// %1 - Number 111 is not unique
	Strings.Insert("Error_009", NStr("en = 'Cannot write the object: [%1].'", Lang));
	
	// %1 - Number
	Strings.Insert("Error_010", NStr("en = 'Field [%1] is empty.'", Lang));
	Strings.Insert("Error_011", NStr("en = 'Add at least one row.'", Lang));
	Strings.Insert("Error_012", NStr("en = 'Variable is not named according to the rules.'", Lang));
	Strings.Insert("Error_013", NStr("en = 'Value is not unique.'", Lang));
	Strings.Insert("Error_014", NStr("en = 'Password and password confirmation do not match.'", Lang));
	Strings.Insert("Error_015", NStr("en = 'Password cannot be empty.'", Lang));

	// %1 - Sales order
	Strings.Insert("Error_016", NStr(
		"en = 'There are no more items that you need to order from suppliers in the ""%1"" document.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_017", NStr(
		"en = 'First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));

	// %1 - Shipment confirmation
	// %1 - Sales invoice
	Strings.Insert("Error_018", NStr(
		"en = 'First, create a ""%1"" document or clear the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_019", NStr(
		"en = 'There are no lines for which you need to create a ""%1"" document in the ""%2"" document.'", Lang));

	// %1 - 12
	Strings.Insert("Error_020", NStr("en = 'Specify a base document for line %1.'", Lang));

	// %1 - Purchase invoice
	Strings.Insert("Error_021", NStr(
		"en = 'There are no products to return in the ""%1"" document. All products are already returned.'", Lang));

	// %1 - Internal supply request
	Strings.Insert("Error_023", NStr(
		"en = 'There are no more items that you need to order from suppliers in the ""%1"" document.'", Lang));
	
	// %1 - Goods receipt
	// %2 - Purchase invoice
	Strings.Insert("Error_028", NStr("en = 'Select the ""%1 before %2"" check box on the ""Other"" tab.'", Lang));
	
	// %1 - Cash account
	// %2 - 12
	// %3 - Cheque bonds
	Strings.Insert("Error_030", NStr("en = 'Specify %1 in line %2 of the %3.'", Lang));

	Strings.Insert("Error_031", NStr(
		"en = 'Items were not received from the supplier according to the procurement method.'", Lang));
	Strings.Insert("Error_032", NStr("en = 'Action not completed.'", Lang));
	Strings.Insert("Error_033", NStr("en = 'Duplicate attribute.'", Lang));
	// %1 - Google drive
	Strings.Insert("Error_034", NStr("en = '%1 is not a picture storage volume.'", Lang));
	Strings.Insert("Error_035", NStr("en = 'Cannot upload more than 1 file.'", Lang));
	Strings.Insert("Error_037", NStr("en = 'Unsupported type of data composition comparison.'", Lang));
	Strings.Insert("Error_040", NStr("en = 'Only picture files are supported.'", Lang));
	Strings.Insert("Error_041", NStr("en = 'Tax table contains more than 1 row [key: %1] [tax: %2].'", Lang));
	// %1 - Name
	Strings.Insert("Error_042", NStr("en = 'Cannot find a tax by column name: %1.'", Lang));
	Strings.Insert("Error_043", NStr("en = 'Unsupported document type.'", Lang));
	Strings.Insert("Error_044", NStr("en = 'Operation is not supported.'", Lang));
	Strings.Insert("Error_045", NStr("en = 'Document is empty.'", Lang));
	// %1 - Currency
	Strings.Insert("Error_047", NStr("en = '""%1"" is a required field.'", Lang));
	Strings.Insert("Error_049", NStr("en = 'Default picture storage volume is not set.'", Lang));
	Strings.Insert("Error_050", NStr(
		"en = 'Currency exchange is available only for the same-type accounts (cash accounts or bank accounts).'",
		Lang));
	// %1 - Bank payment
	Strings.Insert("Error_051", NStr(
		"en = 'There are no lines for which you can create a ""%1"" document, or all ""%1"" documents are already created.'",
		Lang));
	// %1 - Main store
	// %2 - Use shipment confirmation
	// %3 - Shipment confirmations
	Strings.Insert("Error_052", NStr("en = 'Cannot clear the ""%2"" check box. 
									 |Documents ""%3"" from store %1 were already created.'", Lang));
	
	// %1 - Main store
	// %2 - Use goods receipt
	// %3 - Goods receipts
	Strings.Insert("Error_053", NStr(
		"en = 'Cannot clear the ""%2"" check box. Documents ""%3"" from store %1 were already created.'", Lang));
	
	// %1 - sales order
	Strings.Insert("Error_054", NStr("en = 'Cannot continue. The ""%1""document has an incorrect status.'", Lang));

	Strings.Insert("Error_055", NStr("en = 'There are no lines with a correct procurement method.'", Lang));

	// %1 - sales order
	// %2 - purchase order
	Strings.Insert("Error_056", NStr(
		"en = 'All items in the ""%1"" document are already ordered using the ""%2"" document(s).'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_057", NStr(
		"en = 'You do not need to create a ""%1"" document for the selected ""%2"" document(s).'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_058", NStr(
		"en = 'The total amount of the ""%2"" document(s) is already paid on the basis of the ""%1"" document(s).'",
		Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_059", NStr("en = 'In the selected documents, there are ""%2"" document(s) with existing ""%1"" document(s)
									 | and those that do not require a ""%1"" document.'", Lang));
	
	// %1 - Bank receipt
	// %2 - Cash transfer order
	Strings.Insert("Error_060", NStr(
		"en = 'The total amount of the ""%2"" document(s) is already received on the basis of the ""%1"" document(s).'",
		Lang));
	
	// %1 - Main store
	// %2 - Shipment confirmation
	// %3 - Sales order
	Strings.Insert("Error_064", NStr(
		"en = 'You do not need to create a ""%2"" document for store(s) %1. The item will be shipped using the ""%3"" document.'",
		Lang));

	Strings.Insert("Error_065", NStr("en = 'Item key is not unique.'", Lang));
	Strings.Insert("Error_066", NStr("en = 'Specification is not unique.'", Lang));
	Strings.Insert("Error_067", NStr("en = 'Fill Users or Group tables.'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - ordered
	// %5 - 11
	// %6 - 15
	// %7 - 4
	// %8 - pcs
	Strings.Insert("Error_068", NStr(
		"en = 'Line No. [%1] [%2 %3] %4 remaining: %5 %8. Required: %6 %8. Lacking: %7 %8.'", Lang));

	// %1 - 12
	// %2 - Boots
	// %3 - Red XL
	// %4 - 00001
	// %5 - ordered
	// %6 - 11
	// %7 - 15
	// %8 - 4
	// %9 - pcs
	Strings.Insert("Error_068_2", NStr(
		"en = 'Line No. [%1] [%2 %3] Serial lot number [%4] %5 remaining: %6 %9. Required: %7 %9. Lacking: %8 %9.'", Lang));

	// %1 - some extention name
	Strings.Insert("Error_071", NStr("en = 'Plugin ""%1"" is not connected.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_072", NStr("en = 'Specify a store in line %1.'", Lang));

	// %1 - Sales order
	// %2 - Goods receipt
	Strings.Insert("Error_073", NStr(
		"en = 'All items in the ""%1"" document(s) are already received using the ""%2"" document(s).'", Lang));
	Strings.Insert("Error_074", NStr("en = 'Currency transfer is available only when amounts are equal.'", Lang));

	// %1 - Physical count by location
	Strings.Insert("Error_075", NStr("en = 'There are ""%1"" documents that are not closed.'", Lang));
	
	// %1 - 12
	Strings.Insert("Error_077", NStr("en = 'Basis document is empty in line %1.'", Lang));
	
	// %1 - 1 %2 - 2
	Strings.Insert("Error_078", NStr("en = 'Quantity [%1] does not match the quantity [%2] by serial/lot numbers'",
		Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_079", NStr("en = 'Payment amount [%1] and return amount [%2] not match'", Lang));
	
	// %1 - 1 
	// %2 - Goods receipt 
	// %3 - 10 
	// %4 - 8
	Strings.Insert("Error_080", NStr("en = 'In line %1 quantity by %2 %3 greater than %4'", Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 8 
	// %5 - 10
	Strings.Insert("Error_081", NStr("en = 'In line %1 quantity by %2-%3 %4 less than quantity %5'",
		Lang));
	
	// %1 - 1 
	// %2 - Dress 
	// %3 - Red/38 
	// %4 - 10 
	// %5 - 8
	Strings.Insert("Error_082", NStr("en = 'In line %1 quantity by %2-%3 %4 less than quantity %5'",
		Lang));
	
	// %1 - 12 
	Strings.Insert("Error_083", NStr("en = 'Location with number `%1` not found.'", Lang));
	
	// %1 - 1000
	// %2 - 300
	// %3 - 350
	// %4 - 50
	// %5 - USD
	Strings.Insert("Error_085", NStr(
		"en = 'Credit limit exceeded. Limit: %1, limit balance: %2, transaction: %3, lack: %4 %5'", Lang));
	
	// %1 - 10
	// %2 - 20	
	Strings.Insert("Error_086", NStr("en = 'Amount : %1 not match Payment term amount: %2'", Lang));

	Strings.Insert("Error_087", NStr("en = 'Parent can not be empty'", Lang));
	Strings.Insert("Error_088", NStr("en = 'Basis unit has to be filled, if item filter used.'", Lang));

	Strings.Insert("Error_089", NStr("en = 'Description%1 ""%2"" is already in use.'", Lang));
	
	// %1 - Boots
	// %2 - Red XL
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090", NStr("en = '[%1 %2] %3 remaining: %4 %7. Required: %5 %7. Lacking: %6 %7.'", Lang));

	// %1 - Boots
	// %2 - Red XL
	// %3 - 0001
	// %3 - ordered
	// %4 - 11
	// %5 - 15
	// %6 - 4
	// %7 - pcs
	Strings.Insert("Error_090_2", NStr("en = '[%1 %2] Serial lot number [%3] %4 remaining: %5 %6. Required: %6 %8. Lacking: %7 %8.'", Lang));

	Strings.Insert("Error_091", NStr("en = 'Only Administrator can create users.'", Lang));

	Strings.Insert("Error_092", NStr("en = 'Can not use %1 role in SaaS mode'", Lang));
	Strings.Insert("Error_093", NStr("en = 'Cancel reason has to be filled if string was canceled'", Lang));
	Strings.Insert("Error_094", NStr("en = 'Can not use confirmation of shipment without goods receipt'", Lang));
	
	// %1 - 100.00 
	// %2 - 120.00
	Strings.Insert("Error_095", NStr("en = 'Payment amount [%1] and sales amount [%2] not match'", Lang));
	
	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_096", NStr("en = 'Can not delete linked row [%1] [%2] [%3]'", Lang));

	// %1 - 1
	// %2 - Boots
	// %3 - Red XL
	Strings.Insert("Error_097", NStr("en = 'Wrong linked row [%1] [%2] [%3]'", Lang));
	
	// %1 - 1
	// %2 - Store
	// %3 - Store 01
	// %4 - Store 02
	Strings.Insert("Error_098", NStr("en = 'Wrong linked row [%1] for column [%2] used value [%3] wrong value [%4]'", Lang));
	
	// %1 - Partner
	// %2 - Partner 01
	// %3 - Partner 02
	Strings.Insert("Error_099", NStr("en = 'Wrong linked data [%1] used value [%2] wrong value [%3]'", Lang));
	
	// %1 - Value 01
	// %2 - Value 02
	Strings.Insert("Error_100", NStr("en = 'Wrong linked data, used value [%1] wrong value [%2]'", Lang));
	
	Strings.Insert("Error_101", NStr("en = 'Select any document'", Lang));
	Strings.Insert("Error_102", NStr("en = 'Default file storage volume is not set.'", Lang));
	Strings.Insert("Error_103", NStr("en = '%1 is undefined.'", Lang));
	Strings.Insert("Error_104", NStr("en = 'Document [%1] have negative stock balance'", Lang));
	Strings.Insert("Error_105", NStr("en = 'Document [%1] already have related documents'", Lang));
	Strings.Insert("Error_106", NStr("en = 'Can not lock data'", Lang));
	Strings.Insert("Error_107", NStr("en = 'You try to call deleted service %1.'", Lang));
	Strings.Insert("Error_108", NStr("en = 'Field is filled, but it has to be empty.'", Lang));
	Strings.Insert("Error_109", NStr("en = 'Serial lot number name [ %1 ] is not match template: %2'", Lang) + Chars.LF);
	Strings.Insert("Error_110", NStr("en = 'Current serial lot number already has movements, it can not disable stock detail option'", Lang) + Chars.LF);
	Strings.Insert("Error_111", NStr("en = 'Period is empty [%1] : [%2]'", Lang) + Chars.LF);
	Strings.Insert("Error_112", NStr("en = 'Not set ledger type by company [%1]'", Lang));
	Strings.Insert("Error_113", NStr("en = 'Serial lot number [ %1 ] has to be unique at the document'", Lang) + Chars.LF);
	Strings.Insert("Error_114", NStr("en = '""Landed cost"" is a required field.'", Lang) + Chars.LF);
	Strings.Insert("Error_115", NStr("en = 'Error while test connection'", Lang) + Chars.LF);
	Strings.Insert("Error_116", NStr("en = 'Cannot unpost, document is closed by [ %1 ]'", Lang) + Chars.LF);
	Strings.Insert("Error_117", NStr("en = 'Sales return when sales by different dates not support'", Lang) + Chars.LF);
	Strings.Insert("Error_118", NStr("en = 'Cannot set deletion mark, document is closed by [ %1 ]'", Lang) + Chars.LF);
	Strings.Insert("Error_119", NStr("en = 'Error Eval code'", Lang) + Chars.LF);
	Strings.Insert("Error_120", NStr("en = 'Consignor batch shortage Item key: %1 Store: %2 Required:%3 Remaining:%4 Lack:%5'", Lang) + Chars.LF);
	Strings.Insert("Error_121", NStr("en = 'Goods received from consignor cannot be shipped to trade agent'", Lang) + Chars.LF);
	Strings.Insert("Error_122", NStr("en = 'Error. Find recursive basis by RowID: %1. Basis list:'", Lang) + Chars.LF);
	Strings.Insert("Error_123", NStr("en = 'Error. Retail customer is not filled'", Lang) + Chars.LF);
	Strings.Insert("Error_124", NStr("en = 'Quantity limit exceeded. line number: [%1] quantity: [%2] limit: [%3]'", Lang));
	Strings.Insert("Error_125", NStr("en = 'Invoice for document: [%1] is empty'", Lang));
	Strings.Insert("Error_126", NStr("en = 'Document does not have transaction types'", Lang));
	
	// manufacturing errors
	Strings.Insert("MF_Error_001", NStr("en = 'Repetitive materials [%1]'", Lang));
	Strings.Insert("MF_Error_002", NStr("en = 'Looped semiproduct [%1]'", Lang));
	Strings.Insert("MF_Error_003", NStr("en = 'Planning by [%1] [%2] [%3] alredy exists'", Lang));
	Strings.Insert("MF_Error_004", NStr("en = 'Document date [%1] less than Planning date [%2]'", Lang));
	Strings.Insert("MF_Error_005", NStr("en = 'Document date [%1] less than last Planning correction date [%2]'", Lang));
	Strings.Insert("MF_Error_006", NStr("en = 'Start date [%1] greater than End date [%2]'", Lang));
	Strings.Insert("MF_Error_007", NStr("en = 'Start date [%1] intersect Period [%2]'", Lang));
	Strings.Insert("MF_Error_008", NStr("en = 'End date [%1] intersect Period [%2]'", Lang));
	Strings.Insert("MF_Error_009", NStr("en = 'Planning closing by [%1] [%2] [%3] alredy exists'", Lang));
	Strings.Insert("MF_Error_010", NStr("en = 'Select any production planing'", Lang));
	
	// Errors matching attributes of basis and related documents
	Strings.Insert("Error_ChangeAttribute_RelatedDocsExist", NStr("en = 'Cannot change %1 if related documents exist'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc", NStr("en = '%1 must be [%2] (according to %3)'", Lang));
	Strings.Insert("Error_AttributeDontMatchValueFromBasisDoc_Row", NStr("en = '%1 must be [%2] (according to %3) in row [%4]'", Lang));
	
	// Store does not match company
	Strings.Insert("Error_Store_Company", NStr("en = 'Store [%1] does not match company [%2]'", Lang));
	Strings.Insert("Error_Store_Company_Row", NStr("en = 'Store [%1] in row [%3] does not match company [%2]'", Lang));
	
#EndRegion

#Region LandedCost

	Strings.Insert("LC_Error_001", NStr("en = 'Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_002", NStr("en = 'Can not expense Batch key: %1 , Quantity: %2 , Doc: %3'", Lang) + Chars.LF);
	Strings.Insert("LC_Error_003", NStr("en = 'Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3'", Lang) + Chars.LF);
#EndRegion

#Region InfoMessages
	// %1 - Purchase invoice
	// %2 - Purchase order
	Strings.Insert("InfoMessage_001", NStr("en = 'The ""%1"" document does not fully match the ""%2"" document because 
										   |there is already another ""%1"" document that partially covered this ""%2"" document.'",
		Lang));
	// %1 - Boots
	Strings.Insert("InfoMessage_002", NStr("en = 'Object %1 created.'", Lang));
	Strings.Insert("InfoMessage_003", NStr("en = 'This is a service form.'", Lang));
	Strings.Insert("InfoMessage_004", NStr("en = 'Save the object to continue.'", Lang));
	Strings.Insert("InfoMessage_005", NStr("en = 'Done'", Lang));
	
	// %1 - Physical count by location
	Strings.Insert("InfoMessage_006", NStr(
		"en = 'The ""%1"" document is already created. You can update the quantity.'", Lang));

	Strings.Insert("InfoMessage_007", NStr("en = '#%1 date: %2'", Lang));
	// %1 - 12
	// %2 - 20.02.2020
	Strings.Insert("InfoMessage_008", NStr("en = '#%1 date: %2'", Lang));

	Strings.Insert("InfoMessage_009", NStr(
		"en = 'Total quantity doesnt match. Please count one more time. You have one more try.'", Lang));
	Strings.Insert("InfoMessage_010", NStr(
		"en = 'Total quantity doesnt match. Location need to be count again (current count is annulated).'", Lang));
	Strings.Insert("InfoMessage_011", NStr("en = 'Total quantity is ok. Please scan and count next location.'", Lang));
	
	// %1 - 12
	// %2 - Vasiya Pupkin
	Strings.Insert("InfoMessage_012", NStr("en = 'Current location #%1 was started by another user. User: %2'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_013", NStr(
		"en = 'Current location #%1 was linked to you. Other users will not be able to scan it.'", Lang));
	
	// %1 - 12
	Strings.Insert("InfoMessage_014", NStr(
		"en = 'Current location #%1 was scanned and closed before. Please scan next location.'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_015", NStr("en = 'Serial lot %1 was not found. Create new?'", Lang));

	// %1 - 123456
	// %2 - Some item
	Strings.Insert("InfoMessage_016", NStr("en = 'Scanned barcode %1 is using for another items %2'", Lang));
	
	// %1 - 123456
	Strings.Insert("InfoMessage_017", NStr("en = 'Scanned barcode %1 is not using set for serial numbers'", Lang));
	Strings.Insert("InfoMessage_018", NStr("en = 'Add or scan serial lot number'", Lang));

	Strings.Insert("InfoMessage_019", NStr("en = 'Data lock reasons:'", Lang));

	Strings.Insert("InfoMessage_020", NStr("en = 'Created document: %1'", Lang));
  
  	// %1 - 42
	Strings.Insert("InfoMessage_021", NStr("en = 'Can not unlock attributes, this is element used %1 times, ex.:'",
		Lang));
  	// %1 - 
	Strings.Insert("InfoMessage_022", NStr("en = 'This order is closed by %1'", Lang));
	Strings.Insert("InfoMessage_023", NStr(
		"en = 'Can not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled.'", Lang));
	Strings.Insert("InfoMessage_024", NStr("en = 'Will be available after save.'", Lang));
	Strings.Insert("InfoMessage_025", NStr("en = 'Before start to scan - choose location'", Lang));
	Strings.Insert("InfoMessage_026", NStr("en = 'Can not add Service item type: %1'", Lang));
	// %1 - 123123123
	// %2 - Item name
	// %3 - Item key
	// %4 - Serial lot number
	Strings.Insert("InfoMessage_027", NStr("en = 'Barcode [%1] is exists for item: %2 [%3] %4'", Lang));
	Strings.Insert("InfoMessage_028", NStr("en = 'New serial [ %1 ] created for item key [ %2 ]'", Lang));
	Strings.Insert("InfoMessage_029", NStr("en = 'This is unique serial and it can be only one at the document'", Lang));
	Strings.Insert("InfoMessage_030", NStr("en = 'Scan barcode of Item, not serial lot numbers'", Lang));
	Strings.Insert("InfoMessage_031", NStr("en = 'Do you want to continue job?'", Lang));
	Strings.Insert("InfoMessage_032", NStr("en = 'Do you want to pause job?'", Lang));
	Strings.Insert("InfoMessage_033", NStr("en = 'Do you want to stop job?'", Lang));
	
	Strings.Insert("InfoMessage_034", NStr("en = 'Time zone not changed'", Lang));
	Strings.Insert("InfoMessage_035", NStr("en = 'Time zone changed to %1'", Lang));
	
	Strings.Insert("InfoMessage_Payment", NStr("en = 'Payment (+)'", Lang));
	Strings.Insert("InfoMessage_PaymentReturn", NStr("en = 'Payment Return'", Lang));
	Strings.Insert("InfoMessage_SessionIsClosed", NStr("en = 'Session is closed'", Lang));
	Strings.Insert("InfoMessage_Sales", NStr("en = 'Sales'", Lang));
	Strings.Insert("InfoMessage_Returns", NStr("en = 'Returns'", Lang));
	Strings.Insert("InfoMessage_ReturnTitle", NStr("en = 'Return'", Lang));
	Strings.Insert("InfoMessage_POS_Title", NStr("en = 'Point of sales'", Lang));
	
	Strings.Insert("InfoMessage_NotProperty", NStr("en = 'The object has no properties for editing'", Lang));
	Strings.Insert("InfoMessage_DataUpdated", NStr("en = 'The data has been updated'", Lang));
	Strings.Insert("InfoMessage_DataSaved", NStr("en = 'The data has been saved'", Lang));
	Strings.Insert("InfoMessage_SettingsApplied", NStr("en = 'The settings have been applied'", Lang));
	Strings.Insert("InfoMessage_ImportError", NStr("en = 'Import data to product database is locked. Go to Settings page'", Lang));
	
#EndRegion

#Region QuestionToUser
	Strings.Insert("QuestionToUser_001", NStr("en = 'Write the object to continue. Continue?'", Lang));
	Strings.Insert("QuestionToUser_002", NStr("en = 'Do you want to switch to scan mode?'", Lang));
	Strings.Insert("QuestionToUser_003", NStr(
		"en = 'Filled data on cheque bonds transactions will be deleted. Do you want to update %1?'", Lang));
	Strings.Insert("QuestionToUser_004", NStr("en = 'Do you want to change tax rates according to the partner term?'",
		Lang));
	Strings.Insert("QuestionToUser_005", NStr("en = 'Do you want to update filled stores?'", Lang));
	Strings.Insert("QuestionToUser_006", NStr("en = 'Do you want to update filled currency?'", Lang));
	Strings.Insert("QuestionToUser_007", NStr("en = 'Transaction table will be cleared. Continue?'", Lang));
	Strings.Insert("QuestionToUser_008", NStr(
		"en = 'Changing the currency will clear the rows with cash transfer documents. Continue?'", Lang));
	Strings.Insert("QuestionToUser_009", NStr("en = 'Do you want to replace filled stores with store %1?'", Lang));
	Strings.Insert("QuestionToUser_011", NStr("en = 'Do you want to replace filled price types with price type %1?'",
		Lang));
	Strings.Insert("QuestionToUser_012", NStr("en = 'Do you want to exit?'", Lang));
	Strings.Insert("QuestionToUser_013", NStr("en = 'Do you want to update filled prices?'", Lang));
	Strings.Insert("QuestionToUser_014", NStr("en = 'Transaction type is changed. Do you want to update filled data?'",
		Lang));
	Strings.Insert("QuestionToUser_015", NStr("en = 'Filled data will be cleared. Continue?'", Lang));
	Strings.Insert("QuestionToUser_016", NStr("en = 'Do you want to change or clear the icon?'", Lang));
	Strings.Insert("QuestionToUser_017", NStr("en = 'How many documents to create?'", Lang));
	Strings.Insert("QuestionToUser_018", NStr("en = 'Please enter total quantity'", Lang));
	Strings.Insert("QuestionToUser_019", NStr("en = 'Do you want to update payment term?'", Lang));
	Strings.Insert("QuestionToUser_020", NStr("en = 'Do you want to overwrite saved option?'", Lang));
	Strings.Insert("QuestionToUser_021", NStr("en = 'Do you want to close this form? All changes will be lost.'", Lang));
	Strings.Insert("QuestionToUser_022", NStr("en = 'Do you want to upload this files'", Lang) + ": " + Chars.LF + "%1");
	Strings.Insert("QuestionToUser_023", NStr("en = 'Do you want to fill according to cash transfer order?'", Lang));
	Strings.Insert("QuestionToUser_024", NStr("en = 'Change planning period?'", Lang));
	Strings.Insert("QuestionToUser_025", NStr("en = 'Do you want to update filled tax rates?'", Lang));
#EndRegion

#Region SuggestionToUser
	Strings.Insert("SuggestionToUser_1", NStr("en = 'Select a value'", Lang));
	Strings.Insert("SuggestionToUser_2", NStr("en = 'Enter a barcode'", Lang));
	Strings.Insert("SuggestionToUser_3", NStr("en = 'Enter an option name'", Lang));
	Strings.Insert("SuggestionToUser_4", NStr("en = 'Enter a new option name'", Lang));
#EndRegion

#Region UsersEvent
	Strings.Insert("UsersEvent_001", NStr("en = 'User not found by UUID %1 and name %2.'", Lang));
	Strings.Insert("UsersEvent_002", NStr("en = 'User found by UUID %1 and name %2.'", Lang));
#EndRegion

#Region Items
	
	// Interface
	Strings.Insert("I_1", NStr("en = 'Enter description'", Lang));
	Strings.Insert("I_2", NStr("en = 'Click to enter description'", Lang));
	Strings.Insert("I_3", NStr("en = 'Fill out the document'", Lang));
	Strings.Insert("I_4", NStr("en = 'Find %1 rows in table by key %2'", Lang));
	Strings.Insert("I_5", NStr("en = 'Not supported table'", Lang));
	Strings.Insert("I_6", NStr("en = 'Ordered without ISR'", Lang));
	Strings.Insert("I_7", NStr("en = 'Change rights'", Lang));
	Strings.Insert("I_8", NStr("en = 'Rollback rights'", Lang));

#EndRegion

#Region Exceptions
	Strings.Insert("Exc_001", NStr("en = 'Unsupported object type.'", Lang));
	Strings.Insert("Exc_002", NStr("en = 'No conditions'", Lang));
	Strings.Insert("Exc_003", NStr("en = 'Method is not implemented: %1.'", Lang));
	Strings.Insert("Exc_004", NStr("en = 'Cannot extract currency from the object.'", Lang));
	Strings.Insert("Exc_005", NStr("en = 'Library name is empty.'", Lang));
	Strings.Insert("Exc_006", NStr("en = 'Library data does not contain a version.'", Lang));
	Strings.Insert("Exc_007", NStr("en = 'Not applicable for library version %1.'", Lang));
	Strings.Insert("Exc_008", NStr("en = 'Unknown row key.'", Lang));
	Strings.Insert("Exc_009", NStr("en = 'Error: %1'", Lang));
	Strings.Insert("Exc_010", NStr("en = 'Unknown metadata type: %1'", Lang));
#EndRegion

#Region Saas
	// %1 - 12
	Strings.Insert("Saas_001", NStr("en = 'Area %1 not found.'", Lang));
	
	// %1 - closed
	Strings.Insert("Saas_002", NStr("en = 'Area status: %1.'", Lang));
	
	// %1 - en
	Strings.Insert("Saas_003", NStr("en = 'Localization %1 of the company is not available.'", Lang));

	Strings.Insert("Saas_004", NStr("en = 'Area preparation completed'", Lang));
#EndRegion

#Region FillingFromClassifiers
    // Do not modify "en" strings
	Strings.Insert("Class_001", NStr("en = 'Purchase price'", Lang));
	Strings.Insert("Class_002", NStr("en = 'Sales price'", Lang));
	Strings.Insert("Class_003", NStr("en = 'Prime cost'", Lang));
	Strings.Insert("Class_004", NStr("en = 'Service'", Lang));
	Strings.Insert("Class_005", NStr("en = 'Product'", Lang));
	Strings.Insert("Class_006", NStr("en = 'Main store'", Lang));
	Strings.Insert("Class_007", NStr("en = 'Main manager'", Lang));
	Strings.Insert("Class_008", NStr("en = 'pcs'", Lang));
#EndRegion

#Region Titles
	// %1 - Cheque bond transaction
	Strings.Insert("Title_00100", NStr("en = 'Select base documents in the ""%1"" document.'", Lang));	// Form PickUpDocuments
#EndRegion

#Region ChoiceListValues
	Strings.Insert("CLV_1", NStr("en = 'All'", Lang));
	Strings.Insert("CLV_2", NStr("en = 'Transaction type'", Lang));
#EndRegion

#Region SalesOrderStatusReport
	Strings.Insert("SOR_1", NStr("en = 'Not enough items in free stock'", Lang));
#EndRegion

#Region Report
	Strings.Insert("R_001", NStr("en = 'Item key'", Lang) + " = ");
	Strings.Insert("R_002", NStr("en = 'Property'", Lang) + " = ");
	Strings.Insert("R_003", NStr("en = 'Item'", Lang) + " = ");
	Strings.Insert("R_004", NStr("en = 'Specification'", Lang) + " = ");
#EndRegion

#Region Defaults
	Strings.Insert("Default_001", NStr("en = 'pcs'", Lang));
	Strings.Insert("Default_002", NStr("en = 'Customer standard term'", Lang));
	Strings.Insert("Default_003", NStr("en = 'Vendor standard term'", Lang));
	Strings.Insert("Default_004", NStr("en = 'Customer price type'", Lang));
	Strings.Insert("Default_005", NStr("en = 'Vendor price type'", Lang));
	Strings.Insert("Default_006", NStr("en = 'Partner term currency type'", Lang));
	Strings.Insert("Default_007", NStr("en = 'Legal currency type'", Lang));
	Strings.Insert("Default_008", NStr("en = 'American dollar'", Lang));
	Strings.Insert("Default_009", NStr("en = 'USD'", Lang));
	Strings.Insert("Default_010", NStr("en = '$'", Lang));
	Strings.Insert("Default_011", NStr("en = 'My Company'", Lang));
	Strings.Insert("Default_012", NStr("en = 'My Store'", Lang));
#EndRegion

#Region MetadataString
	Strings.Insert("Str_Catalog", NStr("en = 'Catalog'", Lang));
	Strings.Insert("Str_Catalogs", NStr("en = 'Catalogs'", Lang));
	Strings.Insert("Str_Document", NStr("en = 'Document'", Lang));
	Strings.Insert("Str_Documents", NStr("en = 'Documents'", Lang));
	Strings.Insert("Str_Code", NStr("en = 'Code'", Lang));
	Strings.Insert("Str_Description", NStr("en = 'Description'", Lang));
	Strings.Insert("Str_Parent", NStr("en = 'Parent'", Lang));
	Strings.Insert("Str_Owner", NStr("en = 'Owner'", Lang));
	Strings.Insert("Str_DeletionMark", NStr("en = 'Deletion mark'", Lang));
	Strings.Insert("Str_Number", NStr("en = 'Number'", Lang));
	Strings.Insert("Str_Date", NStr("en = 'Date'", Lang));
	Strings.Insert("Str_Posted", NStr("en = 'Posted'", Lang));
	Strings.Insert("Str_InformationRegister", NStr("en = 'Information register'", Lang));
	Strings.Insert("Str_InformationRegisters", NStr("en = 'Information registers'", Lang));
	Strings.Insert("Str_AccumulationRegister", NStr("en = 'Accumulation register'", Lang));
	Strings.Insert("Str_AccumulationRegisters", NStr("en = 'Accumulation registers'", Lang));
#EndRegion

#Region AdditionalSettings
	Strings.Insert("Add_Setiings_001", NStr("en = 'Additional settings'", Lang));
	Strings.Insert("Add_Setiings_002", NStr("en = 'Point of sale'", Lang));
	Strings.Insert("Add_Setiings_003", NStr("en = 'Disable - Change price'", Lang));
	Strings.Insert("Add_Setiings_004", NStr("en = 'Disable - Create return'", Lang));
#EndRegion

#Region Mobile
	// %1 - Some item key
	// %2 - Other item key
	Strings.Insert("Mob_001", NStr("en = 'Current barcode used in %1
					|But before you scan for %2'", Lang));
#EndRegion
	
#Region CopyPaste
	Strings.Insert("CP_001", NStr("en = 'Copy to clipboard'", Lang));
	Strings.Insert("CP_002", NStr("en = 'Paste from clipboard'", Lang));
	Strings.Insert("CP_003", NStr("en = 'Can be copy only [%1]'", Lang));
	Strings.Insert("CP_004", NStr("en = 'Copied'", Lang));
	Strings.Insert("CP_005", NStr("en = 'NOT copied'", Lang));
	Strings.Insert("CP_006", NStr("en = 'Copied %1 rows'", Lang));
#EndRegion	
	
#Region LoadDataFromTable
	Strings.Insert("LDT_Button_Title",   NStr("en = 'Load data from table'", Lang));
	Strings.Insert("LDT_Button_ToolTip", NStr("en = 'Load data from table'", Lang));
	Strings.Insert("LDT_FailReading", NStr("en = 'Failed to read the value: [%1]'", Lang));
	Strings.Insert("LDT_ValueNotFound", NStr("en = 'Nothing was found for [%1]'", Lang));
	Strings.Insert("LDT_TooMuchFound", NStr("en = 'Several variants were found for [%1]'", Lang));
#EndRegion	

#Region OpenSerialLotNumberTree
	Strings.Insert("OpenSLNTree_Button_Title",   NStr("en = 'Open serial lot number tree'", Lang));
	Strings.Insert("OpenSLNTree_Button_ToolTip", NStr("en = 'Open serial lot number tree'", Lang));
#EndRegion	
	
	Return Strings;
EndFunction
