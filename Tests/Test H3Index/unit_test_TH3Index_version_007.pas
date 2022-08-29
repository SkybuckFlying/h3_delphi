unit unit_test_TH3Index_version_007;

{

Test UBER H3CellIndex implementation

version 0.01 created on 1 august 2022 by Skybuck Flying

}

{

version 0.04 created on 28 august 2022 by Skybuck Flying

+ Test ConstAllIndexClearMask

}

interface

function IsH3IndexTestedOK : boolean;

implementation

uses
	unit_UBER_H3_V4_TH3Index_version_007,
	unit_UBER_H3_V4_TH3Index_BitConstants_version_007;

// special data structure for typecasting, case of delphi language union followed property problem.
type
	TH3IndexData = packed record
		case integer of
			0 : ( mData : uint64 );
			1 : ( mByte : packed array[0..7] of byte );
	end;

function IsDigitTestedOK( ParaH3Index : TH3Index ) : boolean;
var
	vDigit : integer;
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vDigit := 0 to 15 do
	begin
		if (vDigit >= 1) and (vDigit <= 15) then
		begin
			for vInput := 0 to 7 do
			begin
				ParaH3Index.Cell[vDigit] := vInput;
				vOutput := ParaH3Index.Cell[vDigit];

				if not (vInput = vOutput) then
				begin
					result := false;
					break;
				end;
			end;
		end else
		if (vDigit = 0) then
		// test base cell
		begin
			for vInput := 0 to 127 do
			begin
				ParaH3Index.Cell[vDigit] := vInput;
				vOutput := ParaH3Index.Cell[vDigit];

				if not (vInput = vOutput) then
				begin
					result := false;
					break;
				end;
			end;
		end;
	end;
end;

{
function IsBaseCellTestedOK( ParaH3CellIndex : TH3CellIndex ) : boolean;
var
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vInput := 0 to 127 do
	begin
		ParaH3CellIndex.BaseCell := vInput;
		vOutput := ParaH3CellIndex.BaseCell;

		if not (vInput = vOutput) then
		begin
			result := false;
			break;
		end;
	end;
end;
}

function IsResolutionTestedOK( ParaH3CellIndex : TH3Index ) : boolean;
var
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vInput := 0 to 15 do
	begin
		ParaH3CellIndex.Resolution := vInput;
		vOutput := ParaH3CellIndex.Resolution;

		if not (vInput = vOutput) then
		begin
			result := false;
			break;
		end;
	end;
end;

function IsModeTestedOK( ParaH3CellIndex : TH3Index ) : boolean;
var
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vInput := 0 to 15 do
	begin
		ParaH3CellIndex.Mode := vInput;
		vOutput := ParaH3CellIndex.Mode;

		if not (vInput = vOutput) then
		begin
			result := false;
			break;
		end;
	end;
end;

function IsModeDependentTestedOK( ParaH3CellIndex : TH3Index ) : boolean;
var
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vInput := 0 to 7 do
	begin
		ParaH3CellIndex.ModeDependent := vInput;
		vOutput := ParaH3CellIndex.ModeDependent;

		if not (vInput = vOutput) then
		begin
			result := false;
			break;
		end;
	end;
end;

function IsReservedTestedOK( ParaH3CellIndex : TH3Index ) : boolean;
var
	vInput : integer;
	vOutput: integer;
begin
	result := true;

	for vInput := 0 to 1 do
	begin
		ParaH3CellIndex.Reserved := vInput;
		vOutput := ParaH3CellIndex.Reserved;

		if not (vInput = vOutput) then
		begin
			result := false;
			break;
		end;
	end;
end;

procedure ProduceRandomH3CellIndexData( var ParaH3Index : TH3Index );
var
	vByteIndex : integer;
begin
	for vByteIndex := 0 to 7 do
	begin
		TH3IndexData(ParaH3Index).mByte[vByteIndex] := Random(256);
	end;
end;

function IsAllIndexClearMaskOK : boolean;
var
	vMask : uint64;
begin
	result := false;

	vMask := $FFFFFFFFFFFFFFFF;
	vMask := vMask shl 53;

//	writeln;
//	writeln( vMask );
//	writeln( ConstAllIndexClearMask );

	if vMask = ConstAllIndexClearMask then
	begin
		result := true;
	end;
end;

function IsAllIndexKeepMaskOK : boolean;
var
	vMask : uint64;
begin
	result := false;

	vMask := $FFFFFFFFFFFFFFFF;
	vMask := vMask shr 11;

//	writeln;
//	writeln( vMask );
//	writeln( ConstAllIndexKeepMask );

	if vMask = ConstAllIndexKeepMask then
	begin
		result := true;
	end;
end;

function IsClearIndexesOK : boolean;
var
	vH3Index : TH3Index;
	vCellIndex : integer;
begin
	result := true;

	vH3Index.Mode := 1;

	vH3Index.ClearIndexes;

	for vCellIndex := 0 to 15 do
	begin
		if vH3Index.Cell[vCellIndex] <> 0 then
		begin
			result := false;
			break;
		end;
	end;
end;

function IsUnuseIndexesOK : boolean;
var
	vH3Index : TH3Index;
	vCellIndex : integer;
begin
	result := true;

	vH3Index.Mode := 1;

	vH3Index.UnuseIndexes;

	for vCellIndex := 0 to 15 do
	begin
		// check resolution 1 to 15
		if (vCellIndex >= 1) and (vCellIndex <= 15) then
		begin
			if vH3Index.Cell[vCellIndex] <> 7 then
			begin
				result := false;
				break;
			end;
		end else
		// check resolution 0
		if (vCellIndex = 0) then
		begin
			if vH3Index.Cell[vCellIndex] <> 127 then
			begin
				result := false;
				break;
			end;
		end;
	end;
end;

function IsH3IndexTestedOK : boolean;
var
	vH3CellIndex : TH3Index;

	vTestLoopIndex : integer;
	vTestLoopCount : integer;
begin
	result := true;

	// do an insane ammount of testing loops
	vTestLoopCount := 1000;
	vTestLoopCount := vTestLoopCount * 1000;
	for vTestLoopIndex := 1 to vTestLoopCount do
	begin
		// set the data to some random crap, yeah ! for testing purposes
		ProduceRandomH3CellIndexData( vH3CellIndex );
		result := result and IsDigitTestedOK(vH3CellIndex);
//		result := result and IsBaseCellTestedOK(vH3CellIndex);

		ProduceRandomH3CellIndexData( vH3CellIndex );
		result := result and IsResolutionTestedOK(vH3CellIndex);

		ProduceRandomH3CellIndexData( vH3CellIndex );
		result := result and IsModeTestedOk(vH3CellIndex);

		ProduceRandomH3CellIndexData( vH3CellIndex );
		result := result and IsModeDependentTestedOK(vH3CellIndex);

		ProduceRandomH3CellIndexData( vH3CellIndex );
		result := result and IsReservedTestedOK(vH3CellIndex);
	end;

	ProduceRandomH3CellIndexData( vH3CellIndex );
	result := result and IsAllIndexClearMaskOK;

	ProduceRandomH3CellIndexData( vH3CellIndex );
	result := result and IsAllIndexKeepMaskOK;

	ProduceRandomH3CellIndexData( vH3CellIndex );
	result := result and IsClearIndexesOK;

	ProduceRandomH3CellIndexData( vH3CellIndex );
	result := result and IsUnuseIndexesOK;
end;



end.
