﻿#language: en
@tree
@Positive
@Salary

Feature: Сheck payroll

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _097700 preparation (Сheck payroll)
	When set True value to the constant
	When set True value to the constant Use salary
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog PlanningPeriods objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog PlanningPeriods objects
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
	* Data for salary
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
		When Create information register Taxes records (VAT)
		When Create catalog EmployeeSchedule objects
		When Create document EmployeeHiring objects
		And I execute 1C:Enterprise script at server
			| "Documents.EmployeeHiring.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"   |
			| "Documents.EmployeeHiring.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.EmployeeHiring.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
	* Companies settings for company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I select from "Vacation" drop-down list by "vacation" string
		And I select from "Sick leave" drop-down list by "sick leave" string
		And I select from "Salary basic payroll" drop-down list by "salary" string
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds

	
Scenario: _097701 check preparation
	When check preparation


Scenario: _097704 check Employee hiring
	And I close all client application windows
	* Create EmployeeHiring (David Romanov)
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I move to the next attribute
		And I select from the drop-down list named "Employee" by "David Romanov" string
		And I move to the next attribute
		And I select from the drop-down list named "Position" by "Manager" string
		And I move to the next attribute
		And I select from "Employee schedule" drop-down list by "5 working days / 2 days off (day)" string
		And I select from "Profit loss center" drop-down list by "shop 01" string
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I move to "Employee hiring" tab
		And I input "01.11.2023 00:00:00" text in the field named "Date"
		And I click Select button of "Accrual type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Salary'      |
		And I select current line in "List" table
		And the editing text of form attribute named "Salary" became equal to "10 000,00"					
		And I click the button named "FormPostAndClose"
	* Check
		And "List" table contains lines
			| 'Date'                | 'Company'      | 'Employee'      | 'Position' | 'Branch'  |
			| '01.11.2023 12:00:00' | 'Main Company' | 'David Romanov' | 'Manager'  | 'Shop 01' |
		
				
Scenario: _097705 check Employee firings
	And I close all client application windows
	* Create EmployeeFiring (Arina Brown)
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I move to the next attribute
		And I select from the drop-down list named "Employee" by "Arina Brown" string
		Then the form attribute named "Position" became equal to "Sales person"
		Then the form attribute named "EmployeeSchedule" became equal to "5 working days / 2 days off (hours)"
		Then the form attribute named "ProfitLossCenter" became equal to "Shop 01"
		Then the form attribute named "Branch" became equal to "Shop 01"								
		And I move to "Other" tab
		And I move to "More" tab
		And I input "20.11.2023 00:00:00" text in the field named "Date"	
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeFiring"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                 |
			| '$NumberEmployeeFiring$' |
				
Scenario: _097706 check Employee sick leave
	And I close all client application windows
	* Create EmployeeSickLeave (Arina Brown, David Romanov)
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "01.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "05.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'David Romanov' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "04.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "08.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I move to "Employee sick leave" tab
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeSickLeave"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                    |
			| '$NumberEmployeeSickLeave$' |

Scenario: _097707 check Employee vacation
	And I close all client application windows
	* Create EmployeeVacation (Arina Brown, Anna Petrova)
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I click the button named "FormCreate"
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "06.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "15.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Anna Petrova' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "04.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "08.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeVacation"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                   |
			| '$NumberEmployeeVacation$' |

Scenario: _097708 check Employee transfer
	And I close all client application windows
	* Create EmployeeTransfer (Arina Brown)
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		And I click the button named "FormCreate" 
	* Filling main info
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click Choice button of the field named "Employee"
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I input "17.11.2023" text in "End of date" field
		And I move to "Other" tab
		And I move to "More" tab
		And I input "16.11.2023 00:00:00" text in the field named "Date"
		And I move to "Employee transfer" tab
		And I click Select button of "To position" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Sales person' |
		And I select current line in "List" table
		And I click Select button of "To employee schedule" field
		And I go to line in "List" table
			| 'Description'             |
			| '5 working days / 2 days off (day)' |
		And I select current line in "List" table
		And I click Select button of "To branch" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click Select button of "To profit loss center" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Check filling
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "Branch" became equal to "Shop 01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Date" became equal to "16.11.2023 00:00:00"
		Then the form attribute named "Employee" became equal to "Arina Brown"
		And the editing text of form attribute named "EndOfDate" became equal to "17.11.2023"
		Then the form attribute named "FromEmployeeSchedule" became equal to "5 working days / 2 days off (hours)"
		Then the form attribute named "FromPosition" became equal to "Sales person"
		Then the form attribute named "FromProfitLossCenter" became equal to "Shop 01"
		Then the form attribute named "ToBranch" became equal to "Distribution department"
		Then the form attribute named "ToEmployeeSchedule" became equal to "5 working days / 2 days off (day)"
		Then the form attribute named "ToPosition" became equal to "Sales person"
		Then the form attribute named "ToProfitLossCenter" became equal to "Distribution department"
		And I click "Post" button	
		And I save the value of "Number" field as "NumberEmployeeTransfer"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'                   |
			| '$NumberEmployeeTransfer$' |
			
				



Scenario: _097709 create Accrual and deduction values records (T9500)
	And I close all client application windows
	* Open  Accrual and deduction values records register
		Given I open hyperlink "e1cib/list/InformationRegister.T9500S_AccrualAndDeductionValues"
		* For position
			And I click the button named "FormCreate"
			And I click Select button of "Employee or position" field
			Then "Select data type" window is opened
			And I go to line in "" table
				| ''                   |
				| 'Employee positions' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Accountant'     |
			And I select current line in "List" table
			And I click Select button of "Accual or deduction type" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Salary'         |
			And I select current line in "List" table
			And I input "12 000,00" text in the field named "Value"
			And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Employee or position'   | 'Value'        |
				| 'Accountant'             | '12 000,00'    |
			And I close all client application windows

Scenario: _097710 create T9530S_WorkDays
	And I close all client application windows
	And In the command interface I select "Salary" "T9530 Work days"
	And I click Choice button of the field named "EmployeeScheduleFilter"
	* 5 working days / 2 days off (day)	
		And I go to line in "List" table
			| 'Code' | 'Description'                       | 'Type' |
			| '1'    | '5 working days / 2 days off (day)' | 'Day'  |
		And I select current line in "List" table
		And I click Choice button of the field named "Period"
		And I input "01.11.2023" text in the field named "DateBegin"
		And I input "30.11.2023" text in the field named "DateEnd"
		And I click the button named "Select"	
		And I click "Create schedule" button
		Then the form attribute named "Period" became equal to "01.11.2023 - 30.11.2023"			
		Then the form attribute named "EmployeeSchedule" became equal to "5 working days / 2 days off (day)"
		And the editing text of form attribute named "ScheduleVariant" became equal to "Week with days off"
		And "Weekends" table became equal
			| 'Check' | 'Presentation' |
			| 'No'    | 'Monday'       |
			| 'No'    | 'Tuesday'      |
			| 'No'    | 'Wednesday'    |
			| 'No'    | 'Thursday'     |
			| 'No'    | 'Friday'       |
			| 'Yes'   | 'Saturday'     |
			| 'Yes'   | 'Sunday'       |
		And I click "Ok" button
	* Check
		And I change the radio button named "ListMode" value to "Table"
		And I move to "Page List" tab
		And "List" table became equal
			| 'Date'       | 'Employee schedule'                 | 'Count days/hours' |
			| '01.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '02.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '03.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '04.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '05.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '06.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '07.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '08.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '09.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '10.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '11.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '12.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '13.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '14.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '15.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '16.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '17.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '18.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '19.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '20.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '21.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '22.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '23.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '24.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '25.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '26.11.2023' | '5 working days / 2 days off (day)' | ''                 |
			| '27.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '28.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '29.11.2023' | '5 working days / 2 days off (day)' | '1'                |
			| '30.11.2023' | '5 working days / 2 days off (day)' | '1'                |
		* 5 working days / 2 days off (hours)
			Given I open hyperlink "e1cib/list/InformationRegister.T9530S_WorkDays"			
			And I click Choice button of the field named "EmployeeScheduleFilter"
			And I go to line in "List" table
				| 'Description'                         | 'Type'  |
				| '5 working days / 2 days off (hours)' | 'Hour'  |
			And I select current line in "List" table
			And I click "Create schedule" button
			And I click Choice button of the field named "Period"
			And I input "01.11.2023" text in the field named "DateBegin"
			And I input "30.11.2023" text in the field named "DateEnd"
			And I click the button named "Select"	
			Then the form attribute named "EmployeeSchedule" became equal to "5 working days / 2 days off (hours)"
			And I input "5" text in "Count hours" field
			And I go to line in "Weekends" table
				| 'Check' | 'Presentation' |
				| 'Yes'   | 'Saturday'     |
			And I remove "Check" checkbox in "Weekends" table
			And I go to line in "Weekends" table
				| 'Check'| 'Presentation'|
				| 'No'   | 'Monday'      |
			And I set "Check" checkbox in "Weekends" table
			And I finish line editing in "Weekends" table
			And the editing text of form attribute named "ScheduleVariant" became equal to "Week with days off"
			And "Weekends" table became equal
				| 'Check' | 'Presentation' |
				| 'Yes'   | 'Monday'       |
				| 'No'    | 'Tuesday'      |
				| 'No'    | 'Wednesday'    |
				| 'No'    | 'Thursday'     |
				| 'No'    | 'Friday'       |
				| 'No'    | 'Saturday'     |
				| 'Yes'   | 'Sunday'       |
			And I click "Ok" button
		* Check
			And I change the radio button named "ListMode" value to "Table"
			And I move to "Page List" tab
			And "List" table became equal
				| 'Date'       | 'Employee schedule'                   | 'Count days/hours' |
				| '01.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '02.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '03.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '04.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '05.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '06.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '07.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '08.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '09.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '10.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '11.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '12.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '13.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '14.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '15.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '16.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '17.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '18.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '19.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '20.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '21.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '22.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '23.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '24.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '25.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '26.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '27.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '28.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '29.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
				| '30.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
		* Change Work days
			And I go to line in "List" table
				| 'Date'       |
				| '04.11.2023' |
			And I select current line in "List" table
			And I input "6" text in "Count days/hours" field
			And I click "Save and close" button
			And I wait "T9530 Work days *" window closing in 20 seconds
			And I go to line in "List" table
				| 'Date'       |
				| '07.11.2023' |
			And I select current line in "List" table
			Then "T9530 Work days" window is opened
			And I input "0" text in "Count days/hours" field
			And I click "Save and close" button
			And I wait "T9530 Work days *" window closing in 20 seconds
			And "List" table contains lines
				| 'Date'       | 'Employee schedule'                   | 'Count days/hours' |
				| '04.11.2023' | '5 working days / 2 days off (hours)' | '6'                |
				| '05.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '06.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '07.11.2023' | '5 working days / 2 days off (hours)' | ''                 |
				| '08.11.2023' | '5 working days / 2 days off (hours)' | '5'                |
	* 1 working day / 2 days off (day)
		Given I open hyperlink "e1cib/list/InformationRegister.T9530S_WorkDays"			
		And I click Choice button of the field named "EmployeeScheduleFilter"
		And I go to line in "List" table
			| 'Description'                      | 'Type' |
			| '1 working day / 2 days off (day)' | 'Day'  |
		And I select current line in "List" table
		And I click "Create schedule" button
		And I select "In two days" exact value from "Schedule variant" drop-down list
		And I input "02.11.2023" text in "Start working day" field
		And I click "Ok" button
		* Check
			And "List" table became equal
				| 'Date'       | 'Employee schedule'                | 'Count days/hours' |
				| '01.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '02.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '03.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '04.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '05.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '06.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '07.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '08.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '09.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '10.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '11.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '12.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '13.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '14.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '15.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '16.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '17.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '18.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '19.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '20.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '21.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '22.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '23.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '24.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '25.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '26.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '27.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '28.11.2023' | '1 working day / 2 days off (day)' | ''                 |
				| '29.11.2023' | '1 working day / 2 days off (day)' | '1'                |
				| '30.11.2023' | '1 working day / 2 days off (day)' | ''                 |			
	* 2 working day / 2 days off (day)
		Given I open hyperlink "e1cib/list/InformationRegister.T9530S_WorkDays"			
		And I click Choice button of the field named "EmployeeScheduleFilter"
		And I go to line in "List" table
			| 'Description'                      | 'Type' |
			| '2 working day / 2 days off (day)' | 'Day'  |
		And I select current line in "List" table
		And I click "Create schedule" button
		And I select "Two in two days" exact value from "Schedule variant" drop-down list
		And I input "01.11.2023" text in "Start working day" field
		And I click "Ok" button
		* Check
			And "List" table became equal
				| 'Date'       | 'Employee schedule'                | 'Count days/hours' |
				| '01.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '02.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '03.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '04.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '05.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '06.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '07.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '08.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '09.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '10.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '11.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '12.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '13.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '14.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '15.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '16.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '17.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '18.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '19.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '20.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '21.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '22.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '23.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '24.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '25.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '26.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '27.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '28.11.2023' | '2 working day / 2 days off (day)' | ''                 |
				| '29.11.2023' | '2 working day / 2 days off (day)' | '1'                |
				| '30.11.2023' | '2 working day / 2 days off (day)' | '1'                |			
	* 3 working day / 3 days off (day)	
		Given I open hyperlink "e1cib/list/InformationRegister.T9530S_WorkDays"			
		And I click Choice button of the field named "EmployeeScheduleFilter"
		And I go to line in "List" table
			| 'Description'                      | 'Type' |
			| '3 working day / 3 days off (day)' | 'Day'  |
		And I select current line in "List" table
		And I click "Create schedule" button
		And I select "Three in Three days" exact value from "Schedule variant" drop-down list
		And I input "03.11.2023" text in "Start working day" field
		And I click "Ok" button
		* Check
			And "List" table became equal
				| 'Date'       | 'Employee schedule'                | 'Count days/hours' |
				| '01.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '02.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '03.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '04.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '05.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '06.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '07.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '08.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '09.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '10.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '11.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '12.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '13.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '14.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '15.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '16.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '17.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '18.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '19.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '20.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '21.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '22.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '23.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '24.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '25.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '26.11.2023' | '3 working day / 3 days off (day)' | ''                 |
				| '27.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '28.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '29.11.2023' | '3 working day / 3 days off (day)' | '1'                |
				| '30.11.2023' | '3 working day / 3 days off (day)' | ''                 |
	And I close all client application windows
	
Scenario: _097712 create TimeSheet (for Shop 01)
	And I close all client application windows
	* Create TimeSheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Period"
		And I input "01.11.2023" text in the field named "DateBegin"
		And I input "30.11.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I move to "Time sheet" tab
		And in the table "Workers" I click "Fill all" button
	* Check filling
		And "Workers" table became equal
			| 'Employee'        | 'Schedule'                            | 'Begin date' | 'End date'   | 'Position'     | 'Profit loss center' |
			| 'Alexander Orlov' | '1 working day / 2 days off (day)'    | '01.11.2023' | '30.11.2023' | 'Sales person' | 'Shop 01'            |
			| 'Anna Petrova'    | '1 working day / 2 days off (day)'    | '01.11.2023' | '30.11.2023' | 'Sales person' | 'Shop 01'            |
			| 'David Romanov'   | '5 working days / 2 days off (day)'   | '01.11.2023' | '30.11.2023' | 'Manager'      | 'Shop 01'            |
			| 'Arina Brown'     | '5 working days / 2 days off (hours)' | '01.11.2023' | '19.11.2023' | 'Sales person' | 'Shop 01'            |
		* Check vacation
			And I go to line in "Workers" table
				| 'Employee'  |
				| 'Anna Petrova' |
			Then the form attribute named "TotalDays" became equal to "30"
			Then the form attribute named "TotalWeekends" became equal to "20"
			Then the form attribute named "TotalVacation" became equal to "2"
			Then the form attribute named "TotalWorkingDays" became equal to "8"
		* Check sick leave 
			And I go to line in "Workers" table
				| 'Employee'   |
				| 'David Romanov' |	
			Then the form attribute named "TotalDays" became equal to "30"
			Then the form attribute named "TotalWeekends" became equal to "8"
			Then the form attribute named "TotalVacation" became equal to "0"
			Then the form attribute named "TotalWorkingDays" became equal to "19"
			Then the form attribute named "TotalSickLeave" became equal to "3"
		* Check sick leave, vacation and employee trasfer, employee firing
			And I go to line in "Workers" table
				| 'Employee' |
				| 'Arina Brown' |	
			Then the form attribute named "TotalDays" became equal to "18"
			Then the form attribute named "TotalWeekends" became equal to "6"
			Then the form attribute named "TotalVacation" became equal to "6"
			Then the form attribute named "TotalWorkingDays" became equal to "2"
			Then the form attribute named "TotalSickLeave" became equal to "4"
		And I click "Post" button	
		And I delete "$$NumberTimeSheet$$" variable
		And I save the value of "Number" field as "$$NumberTimeSheet$$"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'              |
			| '$$NumberTimeSheet$$' |


Scenario: _097713 check work time changes in TimeSheet (for Distribution department)
	And I close all client application windows
	* Create TimeSheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
	* Filling main info
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Period"
		And I input "01.11.2023" text in the field named "DateBegin"
		And I input "30.11.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "Branch" by "Distribution department" string
		And I move to "Time sheet" tab
		And in the table "Workers" I click "Fill all" button
	* Check
		And "TimeSheetList" table became equal
			| 'Date'       | 'Count days/hours' | 'Actually days/hours' |
			| '16.11.2023' | '1'                | '1'                   |
		Then the form attribute named "TotalDays" became equal to "1"
		Then the form attribute named "TotalNotWorkingDays" became equal to "0"
		Then the form attribute named "TotalSickLeave" became equal to "0"
		Then the form attribute named "TotalVacation" became equal to "0"
		Then the form attribute named "TotalWeekends" became equal to "0"
		Then the form attribute named "TotalWorkingDays" became equal to "1"
		And "Workers" table became equal
			| 'Employee'    | 'Schedule'                          | 'Begin date' | 'End date'   | 'Position'     | 'Profit loss center'      |
			| 'Arina Brown' | '5 working days / 2 days off (day)' | '16.11.2023' | '16.11.2023' | 'Sales person' | 'Distribution department' |
	* Change work time from calendar
		And I go to the 16.11.2023 date in "Calendar" field
		And I click Choice button of the field named "Calendar"
		And I input "0" text in "Actually days/hours" field
		And I click "Ok" button
		Then the form attribute named "TotalDays" became equal to "1"
		Then the form attribute named "TotalNotWorkingDays" became equal to "1"
		Then the form attribute named "TotalSickLeave" became equal to "0"
		Then the form attribute named "TotalVacation" became equal to "0"
		Then the form attribute named "TotalWeekends" became equal to "0"
		Then the form attribute named "TotalWorkingDays" became equal to "0"
	* Change work time from table
		And I change the radio button named "ListMode" value to "Table"
		And I move to "Time sheet page table" tab
		And I activate "Actually days/hours" field in "TimeSheetList" table
		And I select current line in "TimeSheetList" table
		And I input "1" text in "Actually days/hours" field of "TimeSheetList" table
		And I finish line editing in "TimeSheetList" table
		Then the form attribute named "TotalDays" became equal to "1"
		Then the form attribute named "TotalNotWorkingDays" became equal to "0"
		Then the form attribute named "TotalSickLeave" became equal to "0"
		Then the form attribute named "TotalVacation" became equal to "0"
		Then the form attribute named "TotalWeekends" became equal to "0"
		Then the form attribute named "TotalWorkingDays" became equal to "1"
		And I click "Post" button	
		And I delete "$$NumberTimeSheet2$$" variable
		And I save the value of "Number" field as "$$NumberTimeSheet2$$"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'               |
			| '$$NumberTimeSheet2$$' |
	
				
Scenario: _097715 refill TimeSheet by current employee
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I click choice button of "Employee" attribute in "EmployeeList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'David Romanov' |
		And I select current line in "List" table
		And I activate "Begin date" field in "EmployeeList" table
		And I input "28.11.2023" text in "Begin date" field of "EmployeeList" table
		And I activate "End date" field in "EmployeeList" table
		And I input "29.11.2023" text in "End date" field of "EmployeeList" table
		And I finish line editing in "EmployeeList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I input "28.11.2023 00:00:00" text in the field named "Date"		
		And I click "Post and close" button				
	* Update time sheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"			
		And I go to line in "List" table
			| 'Number'              |
			| '$$NumberTimeSheet$$' |
		And I select current line in "List" table
		And I go to line in "Workers" table
			| 'Employee'      |
			| 'David Romanov' |	
		And in the table "Workers" I click "Refill by current employee" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then the form attribute named "TotalDays" became equal to "30"
		Then the form attribute named "TotalWeekends" became equal to "8"
		Then the form attribute named "TotalVacation" became equal to "2"
		Then the form attribute named "TotalWorkingDays" became equal to "17"
		Then the form attribute named "TotalSickLeave" became equal to "3"
		And I click "Post and close" button
	And I close all client application windows
	
Scenario: _097716 create payroll
	And I close all client application windows
	* Create Payroll (Shop 01)
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I click the button named "FormCreate"	
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Branch" by "shop 01" string
		And I select from the drop-down list named "Currency" by "Turkish lira" string
		And I select from "Payment period" drop-down list by "fourth" string
		And I input "01.11.2023" text in "Begin date" field
		And I input "30.11.2023" text in "End date" field
		And in the table "AccrualList" I click the button named "FillAccrual"
	* Check
		And "AccrualList" table became equal
			| '#' | 'Amount'   | 'Employee'        | 'Position'     | 'Accrual type' | 'Expense type' | 'Profit loss center' |
			| '1' | '7 000,00' | 'Alexander Orlov' | 'Sales person' | 'Salary'       | 'Expense'      | 'Shop 01'            |
			| '2' | '7 000,00' | 'Anna Petrova'    | 'Sales person' | 'Salary'       | 'Expense'      | 'Shop 01'            |
			| '3' | '471,70'   | 'Arina Brown'     | 'Sales person' | 'Salary'       | 'Expense'      | 'Shop 01'            |
			| '4' | '9 545,45' | 'David Romanov'   | 'Manager'      | 'Salary'       | 'Expense'      | 'Shop 01'            |
		And I click "Post" button	
		And I delete "$$NumberPayroll$$" variable
		And I save the value of "Number" field as "$$NumberPayroll$$"
		And I click "Post and close" button
	* Check
		And "List" table contains lines
			| 'Number'            |
			| '$$NumberPayroll$$' |	
		
				
				