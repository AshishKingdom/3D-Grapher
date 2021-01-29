' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''

' JavaScript: STARTSKIP

'\\std::string subExecute (std::string TheScriptIn, std::string TheModeIn, std::string ScopeSwitchIn);
'\\std::string numberCrunch (std::string TheStringIn);
'\\std::string sxriptEval (std::string TheStringIn);
'\\std::string evalStep (std::string TheStringIn);
' JavaScript: ENDSKIP

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''

DECLARE FUNCTION GetDecimalPos (TheStringIn AS STRING)
DECLARE FUNCTION InsertCharacter$ (TheStringIn AS STRING, TheCharIn AS STRING, TheDigitIn AS INTEGER, NumTimesIn AS INTEGER)
DECLARE FUNCTION ReadManyCharacter$ (TheStringIn AS STRING, StartDigitIn AS INTEGER, FinishDigitIn AS INTEGER)
DECLARE FUNCTION ReadOneCharacter$ (TheStringIn AS STRING, TheDigitIn AS INTEGER)
DECLARE FUNCTION RemoveCharacter$ (TheStringIn AS STRING, TheDigitIn AS INTEGER)
DECLARE FUNCTION RemoveDecimal$ (TheStringIn AS STRING)
DECLARE FUNCTION RemoveSign$ (TheStringIn AS STRING)
DECLARE FUNCTION RemoveZerosLeft$ (TheStringIn AS STRING, TheStartingDigitIn AS INTEGER)
DECLARE FUNCTION RemoveZerosRight$ (TheStringIn AS STRING)
DECLARE FUNCTION ReverseSign$ (TheStringIn AS STRING)
DECLARE FUNCTION SelectLargerInteger$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION RepairFormat$ (TheStringIn AS STRING)
DECLARE FUNCTION InternalAdd$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION InternalSub$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION InternalMul$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION InternalInv$ (DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION InternalDiv$ (NumerIn AS STRING, DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION STxAxTICAdd$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION STxAxTICSub$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION STxAxTICMul$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION STxAxTICInv$ (DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION STxAxTICDiv$ (NumerIn AS STRING, DenomIn AS STRING, NumDigitsIn AS INTEGER)

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''

DECLARE FUNCTION CountElements (TheStringIn AS STRING, TheSeparatorIn AS STRING)
DECLARE FUNCTION FindMatching (TheStringIn AS STRING, TheSymbolIn AS STRING, TheStartPosIn AS INTEGER)
DECLARE FUNCTION FindMostEmbedded (TheStringIn AS STRING)
DECLARE FUNCTION GetSeparatorPos (TheStringIn AS STRING, TheSeparatorTypeIn AS STRING, TheSeparatorNumIn AS INTEGER, TheStartPosIn AS INTEGER)
DECLARE FUNCTION ManageWhiteSpace$ (TheStringIn AS STRING)
DECLARE FUNCTION RemoveWrapping$ (TheStringIn AS STRING, TheWrapIn AS STRING)
DECLARE FUNCTION ReplaceWord$ (TheStringIn AS STRING, TheWordIn AS STRING, TheReplacementIn AS STRING, CurlyDepthIn As INTEGER)
DECLARE FUNCTION ReplaceRaw$ (TheStringIn AS STRING, TheWordIn AS STRING, TheReplacementIn AS STRING)
DECLARE FUNCTION ScanForName (TheStringIn AS STRING, TheCritPosIn AS INTEGER, TheSwitchIn AS STRING)
DECLARE FUNCTION ScanForOperator (TheStringIn AS STRING, TheSymbolIn AS STRING)
DECLARE FUNCTION TypeCheck$ (TheStringIn AS STRING)
DECLARE FUNCTION ManageOperators$ (TheStringIn AS STRING)
DECLARE FUNCTION PlotASCII$ (TheFuncIn AS STRING, LowLimitIn AS DOUBLE, HighLimitIn AS DOUBLE, StepSizeIn AS DOUBLE)
DECLARE FUNCTION ReturnElement$ (TheStringIn AS STRING, TheArgNumberIn AS INTEGER)
DECLARE FUNCTION VectorASMD$ (Vector1In AS STRING, Vector2In AS STRING, TheOperatorIn AS STRING)
DECLARE FUNCTION StructureEval$ (TheVectorIn AS STRING, TheLeftBrackIn AS STRING, TheRightBrackIn AS STRING)
DECLARE FUNCTION StructureApplyFunc$ (TheVectorIn AS STRING, TheFunctionIn AS STRING, TheBracketsIn AS STRING)
DECLARE FUNCTION FormatForTerminal$ (TheStringIn AS STRING)
DECLARE FUNCTION EvalStep$ (TheStringIn AS STRING)
DECLARE FUNCTION InternalEval$ (TheStringIn AS STRING)
DECLARE FUNCTION SxriptEval$ (TheStringIn AS STRING)
DECLARE FUNCTION NumberCrunch$ (TheStringIn AS STRING)
DECLARE FUNCTION SubExecute$ (TheScriptIn AS STRING, TheModeIn AS STRING, ScopeSwitchIn AS STRING)

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''

' Initialize globals and startup variables.
DIM kglob AS INTEGER
DIM jglob AS INTEGER
DIM SHARED BrackList AS STRING

' ''''' Define array for Sxript logo. '''''
DIM SHARED SxriptLogoText(30) AS STRING
DIM SHARED SxriptLogoSize AS INTEGER

' ''''' Define structure for function and variable storage. '''''
DIM SHARED FunctionUserListSize AS INTEGER
DIM SHARED VariableUserListSize AS INTEGER
DIM SHARED ScopeLevel AS INTEGER
DIM SHARED FunctionUserList(101, 2) AS STRING
DIM SHARED VariableUserList(101, 2) AS STRING
DIM SHARED FunctionUserListScope(101, 2, 24) AS STRING
DIM SHARED VariableUserListScope(101, 2, 24) AS STRING

' ''''' Define structure for operator table. '''''
'DIM SHARED OperatorTable(20, 2) AS STRING
'DIM SHARED NumOperators AS INTEGER
DIM SHARED OpList AS STRING

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''

' CPP: STARTSKIP
'\\var document;
'\\var FunctionUserList = new Array(99);
'\\var VariableUserList = new Array(101);
'\\var OperatorTable = new Array(15);
'\\var FunctionUserListScope = new Array(99);
'\\var VariableUserListScope = new Array(101);

'\\(function () {
'\\    "use strict";
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    FunctionUserList[kglob] = new Array(2);
'\\}
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    VariableUserList[kglob] = new Array(2);
'\\}
'\\for (kglob = 1; kglob <= 20; kglob += 1) {
'\\    OperatorTable[kglob] = new Array(2);
'\\}
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    FunctionUserListScope[kglob] = new Array(2);
'\\}
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    VariableUserListScope[kglob] = new Array(2);
'\\}
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    for (jglob = 1; jglob <= 2; jglob += 1) {
'\\        FunctionUserListScope[kglob][jglob] = new Array(24);
'\\    }
'\\}
'\\for (kglob = 1; kglob <= 101; kglob += 1) {
'\\    for (jglob = 1; jglob <= 2; jglob += 1) {
'\\        VariableUserListScope[kglob][jglob] = new Array(24);
'\\    }
'\\}
' CPP: ENDSKIP

' CPP: STARTSKIP
SxriptLogoSize = 0
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "                  .      "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "    +@@@@,        @@     "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "   @@@@@@@'       @@@:   "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "  @@@@@@@@@      +@@@@@: "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "  #    @@@@#     @@@@@@  "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "       ,@@@@    .++@@@+  "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "        @@@@#   @    @   "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "        ;@@@@  ,@        "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "         @@@@# @         "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "         #@@@@'@         "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "          @@@@@,         "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "      '###@@@@@#######   "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "      @@@@@@@@@@@@@@@.   "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "     .@@@@@@@@@@@@@@@    "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "      ``....@@@@#        "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "           ,@@@@@        "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "           @`@@@@#       "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "          `@ @@@@@       "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "          @;  @@@@'      "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "          @   @@@@@      "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "    @;   #+   `@@@@'     "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "   ,@@@' @     @@@@@     "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "   @@@@@@@     .@@@@; +  "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "   @@@@@@       @@@@@@+  "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "    +@@@@       .@@@@#   "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "      @@.        #@@@    "
SxriptLogoSize = SxriptLogoSize + 1
SxriptLogoText(SxriptLogoSize) = "       `          `+     "

FunctionUserListSize = 0
VariableUserListSize = 0
ScopeLevel = 1

BrackList = "`',()<>[]{}"
OpList = "!^*/%+-=&|~?"

' CPP: ENDSKIP

' CPP: STARTSKIP
'\\}());
' CPP: ENDSKIP

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''
