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
DECLARE FUNCTION InternalMul$ (Nusm1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION InternalInv$ (DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION InternalDiv$ (NumerIn AS STRING, DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION BigNumAdd$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION BigNumSub$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION BigNumMul$ (Num1In AS STRING, Num2In AS STRING)
DECLARE FUNCTION BigNumInv$ (DenomIn AS STRING, NumDigitsIn AS INTEGER)
DECLARE FUNCTION BigNumDiv$ (NumerIn AS STRING, DenomIn AS STRING, NumDigitsIn AS INTEGER)

' '''''''''' '''''''''' '''''''''' '''''''''' ''''''''''