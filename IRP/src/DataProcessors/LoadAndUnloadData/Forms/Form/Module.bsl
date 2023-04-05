// @strict-types

&AtClient
Procedure FindRef(Command)
	FindRefAtServer();
EndProcedure

&AtServer
Procedure FindRefAtServer()
	SearchRefArray = New Array; // Array Of AnyRef
	SearchRefArray.Add(SearchRef);
	RefList = FindByRef(SearchRefArray);
	FoundRefList.Clear();
	For Each Row In RefList Do
		NewRow = FoundRefList.Add();
		NewRow.Ref = Row.Data;
		NewRow.MetadataName = String(Row.Metadata);
	EndDo;
EndProcedure

&AtClient
Function GetAllWindows()
	WindowsForWork = New Array; // Array Of ClientApplicationWindow
	
	AllWindows = GetWindows();
	For Each SelectedWindow In AllWindows Do
		If SelectedWindow.HomePage 
			OR SelectedWindow.IsMain
			OR SelectedWindow = Window Then
			Continue;
		EndIf;
		
		ClientForm = SelectedWindow.Content[0]; // ClientApplicationForm
		
		If ClientForm.CurrentItem = Undefined Then
			Continue;
		EndIf;
		If Not TypeOf(ClientForm.CurrentItem) = Type("FormTable") Then
			Continue;
		EndIf;
		
		WindowsForWork.Add(SelectedWindow);
	EndDo;
	Return WindowsForWork;
EndFunction

&AtClient
Procedure Update(Command)
	FormItems.Clear();
	
	For Each SelectedWindow In GetAllWindows() Do
		NewForm = FormItems.Add();
		ClientForm = SelectedWindow.Content[0]; // ClientApplicationForm
		NewForm.Description = SelectedWindow.Caption + "/" + ClientForm.CurrentItem.Name + "/Rows:" + ClientForm.CurrentItem.SelectedRows.Count();
		NewForm.URL = SelectedWindow.GetURL();		
	EndDo;
EndProcedure

&AtClient
Procedure Serialize(Command)
	
	If Items.FormItems.CurrentData = Undefined Then
		Return;
	EndIf;
	
	Array = New Array; // Array of Arbitrary
	For Each SelectedWindow In GetAllWindows() Do
		//@skip-check property-return-type
		If Not Items.FormItems.CurrentData.URL = SelectedWindow.GetURL() Then
			Continue;
		EndIf;
		
		ClientForm = SelectedWindow.Content[0]; // ClientApplicationForm
		Table = ClientForm.CurrentItem; // FormTableExtensionForDynamicList
		For Each Row In Table.SelectedRows Do
			//@skip-check typed-value-adding-to-untyped-collection
			Array.Add(Row);
		EndDo;
		Break;
	EndDo;
	
	If Array.Count() = 0 Then
		Return;
	EndIf;
	Result = SerializeAtServer(Array);
	Object.SerializedInfo = Result.Serialized;
	Object.ArchivedInfo = Result.Archived;
EndProcedure

// Serialize at server.
// 
// Parameters:
//  ArrayRef - Array of Arbitrary - Array
// 
// Returns:
//  Structure - Serialize at server:
// * Serialized - String -
// * Archived - String -
// @skip-check typed-value-adding-to-untyped-collection, dynamic-access-method-not-found, property-return-type
&AtServerNoContext
Function SerializeAtServer(ArrayRef)
	ArrayOfObjects = New Array; // Array of Arbitrary
	isRef = False;
	MetadataData = ArrayRef[0].Metadata(); // MetadataObject
	For Each Attr In MetadataData.StandardAttributes Do
		If Attr.Name = "Ref" Then
			isRef = True;
		EndIf;
	EndDo;
	
	For Each Row In ArrayRef Do
		If isRef Then
			ArrayOfObjects.Add(Row.GetObject());
		Else
			Row = Row; // InformationRegisterRecordKeyInformationRegisterName
			RecordSet = InformationRegisters[MetadataData.Name].CreateRecordSet();
			For Each Filter In RecordSet.Filter Do
				Filter.Set(Row[Filter.Name]);
			EndDo;
			RecordSet.Read();
			ArrayOfObjects.Add(RecordSet);
		EndIf;
	EndDo;
	Result = New Structure;
	Result.Insert("Serialized", CommonFunctionsServer.SerializeXMLUseXDTO(ArrayOfObjects));
	VS = New ValueStorage(Result.Serialized, New Deflation(9));
	Result.Insert("Archived", CommonFunctionsServer.SerializeXMLUseXDTO(VS));
	Return Result;
EndFunction

&AtClient
Procedure Import(Command)
	Log = "";
	Log = DeserializeAtServer(Object.DeserializedInfo, ImportDataToProductDataBaseIsGranted);
EndProcedure

// Deserialize at server.
// 
// Parameters:
//  Data - String - Data
// 	ImportDataToProductDataBaseIsGranted - Boolean -
// Returns:
//  String
&AtServerNoContext
Function DeserializeAtServer(Val Data, Val ImportDataToPoductDataBaseIsGranted)
	
	If SessionParameters.ConnectionSettings.isProduction Then
		If Not ImportDataToPoductDataBaseIsGranted Then 
			Raise R().InfoMessage_ImportError;
		EndIf;
	EndIf;
	
	Info = CommonFunctionsServer.DeserializeXMLUseXDTO(Data); // Array of Arbitrary, ValueStorage
	Data = "";
	If TypeOf(Info) = Type("ValueStorage") Then
		DataVS = Info.Get(); // String
		InfoArray = CommonFunctionsServer.DeserializeXMLUseXDTO(DataVS); // Array of Arbitrary
	Else
		InfoArray = Info;
	EndIf;
	Log = New Array; // Array Of String
	For Each Row In InfoArray Do
		Try
			Row.Write();
		Except
			Log.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()) + Chars.LF + CommonFunctionsServer.SerializeXMLUseXDTO(Row));
		EndTry;
		Log.Add(String(Row));
	EndDo;
	
	Return StrConcat(Log, Chars.LF + "-----------------------------" + Chars.LF);
EndFunction
