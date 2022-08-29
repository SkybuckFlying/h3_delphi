unit unit_UBER_H3_V4_TH3Index_version_007;

{

UBER H3Index implementation

version 0.01 created on 1 august 2022 by Skybuck Flying

TestedOK.

Tested OK super fast on Toshiba Laptop L670, pretty damn amazing !

I don't believe it myself, but it's probably because fields tested individually
and that reduces the testing range from full blown 64 bit down to something
much less apperently, nice !

I could still do some more testing with maybe garbage input for the properties
but I am pretty sure they are somewhat protected against garbage input by
isolating the values/masking off the values.

What is still possible is inputting an invalid resolution range for the digit.
This could be checked with assert statements which don't end up in release code.
For now I am going to assume that the user will write property resolution
indexing/code.

It's dangerous to leave it unchecked, the resolution range that is.

I am going to protect/fix this problem in version 0.02 and then see
if it slows down the testing too much...
for now I will leave version 0.01 as it is, nice and fast.

}

{

version 0.02 created on 1 august 2022 by Skybuck Flying

+ Checks/Safeguard/Protection added for out of range resolutions.
+ -1 returned for cell value if resolution is out of range.

I might as well "generalize" the cell property now that branches are added
to check the resolution range. I can do this in version 0.03.

}

{

version 0.03 created on 1 august 2022 by Skybuck Flying

+ BaseCell integrated into Cell property. BaseCell is located at index 0.

A version 0.04 could be created where all this shifting, and-ing and or-ing
basically clearing and copie-ing of bitfields could be done in functions
for more code/instruction re-use, this could/would lower the L1 instruction
cache usage at maybe the expensive of some more call overhead.

Though it might come at the cost of thougher branch prediction for the CPU.

Alternatively the functions could also be inlined and then it would just be
a little bit shorter code and if there was a bug somewhere in it it could
be fixed at one place. However the current "copy & paste" code does allow
customization if needed but for now it does not seem to be the case.

}

{

version 0.05 created on 20 august 2022 by Skybuck Flying

no further changes, version number bumped to be in sync with main uber h3 api file/folder version.

}

{

version 0.06 created on 28 august 2022 by Skybuck Flying

+ function ClearIndexes
+ function UnUseIndexes

Take note: these two functions take mode into consideration.

}

{

version 0.07 created on 29 august 2022 by Skybuck Flying

+ upgrading to version 4 of UBER H3 library, ALL api implementation version
+ TH3CellIndex renamed TH3Index

}

interface

{

  Fields and bits and bit positions
  A = Digit 15 = 3 bits = 00..02 bit offset
  B = Digit 14 = 3 bits = 03..05 bit offset
  C = Digit 13 = 3 bits = 06..08 bit offset
  D = Digit 12 = 3 bits = 09..11 bit offset
  E = Digit 11 = 3 bits = 12..14 bit offset
  F = Digit 10 = 3 bits = 15..17 bit offset
  G = Digit 09 = 3 bits = 18..20 bit offset
  H = Digit 08 = 3 bits = 21..23 bit offset
  I = Digit 07 = 3 bits = 24..26 bit offset
  J = Digit 06 = 3 bits = 27..29 bit offset
  K = Digit 05 = 3 bits = 30..32 bit offset
  L = Digit 04 = 3 bits = 33..35 bit offset
  M = Digit 03 = 3 bits = 36..38 bit offset
  N = Digit 02 = 3 bits = 39..41 bit offset
  O = Digit 01 = 3 bits = 42..44 bit offset
  P = Base Cell = 7 bits = 45..51 bit offset
  Q = Resolution = 4 bits = 52..55 bit offset
  R = Mode-Dependent = 3 bits = 56..58 bit offset
  S = Mode = 4 bits = 59..62 bit offset
  T = Reserved = 1 bit = 63 bit offset

  bit positions
  0         1         2         3         4         5         6
  0123456789012345678901234567890123456789012345678901234567890123
  AAABBBCCCDDDEEEFFFGGGHHHIIIJJJKKKLLLMMMNNNOOOPPPPPPPQQQQRRRSSSST

}

{
  Mode 0 is reserved and indicates an invalid H3 index.
  Mode 1 is an H3 Cell (Hexagon/Pentagon) index.
  Mode 2 is an H3 Unidirectional Edge (Cell A -> Cell B) index.
  Mode 3 is planned to be a bidirectional edge (Cell A <-> Cell B).
  Mode 4 is an H3 Vertex (i.e. a single vertex of an H3 Cell).
}

type
	// This record describes a mode 1 H3 Cell (Hexagon/Pentagon) index
	TH3Index = record
	private
		function GetReserved: integer;
		procedure SetReserved(const Value: integer);

		// function GetBaseCell: integer;
		// procedure SetBaseCell(const Value: integer);

		function GetMode: integer;
		procedure SetMode(const Value: integer);

		function GetModeDependent: integer;
		procedure SetModeDependent(const Value: integer);

		function GetResolution: integer;
		procedure SetResolution(const Value: integer);

		function GetCell(ParaResolution: integer): integer;
		procedure SetCell(ParaResolution: integer; const Value: integer);

	public
		// case integer of
		// 0 : ( mData : int64 );
		// 1 : ( mByte : packed array[0..7] of byte );
		mData: uint64;

//		procedure Clear;

		// these two functions take mode into consideration
		procedure ClearIndexes;
		procedure UnuseIndexes;

		property Reserved: integer read GetReserved write SetReserved;
		property Mode: integer read GetMode write SetMode;
		property ModeDependent : integer read GetModeDependent write SetModeDependent;
		property Resolution: integer read GetResolution write SetResolution;

		property Cell[ParaIndex: integer]: integer read GetCell write SetCell;
		// property BaseCell : integer read GetBaseCell write SetBaseCell; // illiminated for now, don't need it anymore, integrated into cell
	end;

implementation

{ TH3CellIndex }

uses
	unit_UBER_H3_V4_TH3Index_BitConstants_version_007;

function TH3Index.GetCell(ParaResolution: integer): integer;
var
	vDigitIndex: integer;
	vShiftIndex: integer;
	vShiftedData: uint64;
begin
	result := -1;
	// set an invalid value to indicate that the resolution is out of range.
	if (ParaResolution >= 1) and (ParaResolution <= 15) then
	begin
		// compute digix index and shift index
		vDigitIndex := ConstMaxResolution - ParaResolution;
		vShiftIndex := vDigitIndex * ConstBitsPerDigit;

		// shift down right the data and isolate
		vShiftedData := mData shr vShiftIndex;
		result := vShiftedData and ConstDigitMask;
	end
	else if (ParaResolution = 0) then
	// get base cell, 7 bits instead of 3.
	begin
		// shift down the data
		result := mData shr ConstBaseCellBitOffset;
		// isolate the field we want
		result := result and ConstBaseCellMask;
	end;
end;

procedure TH3Index.SetCell(ParaResolution: integer; const Value: integer);
var
	vDigitIndex: integer;
	vShiftIndex: integer;

	vMask: uint64;
	vShiftedMask: uint64;
	vInvertedMask: uint64;

	vIsolatedData: uint64;
	vShiftedData: uint64;
begin
	if (ParaResolution >= 1) and (ParaResolution <= 15) then
	begin
		// compute the digit index and shift index
		vDigitIndex := ConstMaxResolution - ParaResolution;
		vShiftIndex := vDigitIndex * ConstBitsPerDigit;

		// clear out the bits for the field in mData
		vMask := ConstDigitMask;
		vShiftedMask := vMask shl vShiftIndex;
		vInvertedMask := not vShiftedMask;
		mData := mData and vInvertedMask;

		// copy/or the value bits to the field in mData
		vIsolatedData := Value and ConstDigitMask;
		vShiftedData := vIsolatedData shl vShiftIndex;
		mData := mData or vShiftedData;
	end
	else if (ParaResolution = 0) then
	// set base cell, 7 bits instead of 3.
	begin
		// clear out the bits for the field in mData

		// set the mask first
		vMask := ConstBaseCellMask;
		// shift the mask to the correct position, this shifts in zeros.
		vShiftedMask := vMask shl ConstBaseCellBitOffset;
		// invert the shifted mask
		vInvertedMask := not vShiftedMask;
		// clear out the bits in the data field
		mData := mData and vInvertedMask;

		// copy/or the value bits to the field in mData

		// isolate the value bits
		vIsolatedData := Value and ConstBaseCellMask;
		// shift the value bits to their position
		vShiftedData := vIsolatedData shl ConstBaseCellBitOffset;
		// or in the shifted data bits
		mData := mData or vShiftedData;
	end;
end;

// Going to leave this code in in case I regret the (cell integration/generic) re-design decision later
(*
  function TH3Index.GetBaseCell: integer;
  begin
  // shift down the data
  result := mData shr ConstBaseCellBitOffset;
  // isolate the field we want
  result := result and ConstBaseCellMask;
  end;

  procedure TH3Index.SetBaseCell(const Value: integer);
  var
  vMask : int64;
  vShiftedMask : int64;
  vInvertedMask : int64;
  vIsolatedData : int64;
  vShiftedData : int64;
  begin
  // clear out the bits for the field in mData

  // set the mask first
  vMask := ConstBaseCellMask;
  // shift the mask to the correct position, this shifts in zeros.
  vShiftedMask := vMask shl ConstBaseCellBitOffset;
  // invert the shifted mask
  vInvertedMask := not vShiftedMask;
  // clear out the bits in the data field
  mData := mData and vInvertedMask;

  // copy/or the value bits to the field in mData

  // isolate the value bits
  vIsolatedData := Value and ConstBaseCellMask;
  // shift the value bits to their position
  vShiftedData := vIsolatedData shl ConstBaseCellBitOffset;
  // or in the shifted data bits
  mData := mData or vShiftedData;
  end;
*)

function TH3Index.GetMode: integer;
begin
	// shift down the data
	result := mData shr ConstModeBitOffset;
	// isolate the field we want
	result := result and ConstModeMask;
end;

procedure TH3Index.SetMode(const Value: integer);
var
	vMask: uint64;
	vShiftedMask: uint64;
	vInvertedMask: uint64;
	vIsolatedData: uint64;
	vShiftedData: uint64;
begin
	// clear out the bits for the field in mData

	// set the mask first
	vMask := ConstModeMask;
	// shift the mask to the correct position, this shifts in zeros.
	vShiftedMask := vMask shl ConstModeBitOffset;
	// invert the shifted mask
	vInvertedMask := not vShiftedMask;
	// clear out the bits in the data field
	mData := mData and vInvertedMask;

	// copy/or the value bits to the field in mData

	// isolate the value bits
	vIsolatedData := Value and ConstModeMask;
	// shift the value bits to their position
	vShiftedData := vIsolatedData shl ConstModeBitOffset;
	// or in the shifted data bits
	mData := mData or vShiftedData;
end;

function TH3Index.GetModeDependent: integer;
begin
	// shift down the data
	result := mData shr ConstModeDependentBitOffset;
	// isolate the field we want
	result := result and ConstModeDependentMask;
end;
procedure TH3Index.SetModeDependent(const Value: integer);
var
	vMask: uint64;
	vShiftedMask: uint64;
	vInvertedMask: uint64;
	vIsolatedData: uint64;
	vShiftedData: uint64;
begin
	// clear out the bits for the field in mData

	// set the mask first
	vMask := ConstModeDependentMask;
	// shift the mask to the correct position, this shifts in zeros.
	vShiftedMask := vMask shl ConstModeDependentBitOffset;
	// invert the shifted mask
	vInvertedMask := not vShiftedMask;
	// clear out the bits in the data field
	mData := mData and vInvertedMask;

	// copy/or the value bits to the field in mData

	// isolate the value bits
	vIsolatedData := Value and ConstModeDependentMask;
	// shift the value bits to their position
	vShiftedData := vIsolatedData shl ConstModeDependentBitOffset;
	// or in the shifted data bits
	mData := mData or vShiftedData;
end;

function TH3Index.GetResolution: integer;
begin
	// shift down the data
	result := mData shr ConstResolutionBitOffset;
	// isolate the field we want
	result := result and ConstResolutionMask;
end;

procedure TH3Index.SetResolution(const Value: integer);
var
	vMask: uint64;
	vShiftedMask: uint64;
	vInvertedMask: uint64;
	vIsolatedData: uint64;
	vShiftedData: uint64;
begin
	// clear out the bits for the field in mData

	// set the mask first
	vMask := ConstResolutionMask;
	// shift the mask to the correct position, this shifts in zeros.
	vShiftedMask := vMask shl ConstResolutionBitOffset;
	// invert the shifted mask
	vInvertedMask := not vShiftedMask;
	// clear out the bits in the data field
	mData := mData and vInvertedMask;

	// copy/or the value bits to the field in mData

	// isolate the value bits
	vIsolatedData := Value and ConstResolutionMask;
	// shift the value bits to their position
	vShiftedData := vIsolatedData shl ConstResolutionBitOffset;
	// or in the shifted data bits
	mData := mData or vShiftedData;
end;

function TH3Index.GetReserved: integer;
begin
	// shift down the data
	result := mData shr ConstReservedBitOffset;
	// isolate the field we want
	result := result and ConstReservedMask;
end;

procedure TH3Index.SetReserved(const Value: integer);
var
	vMask: uint64;
	vShiftedMask: uint64;
	vInvertedMask: uint64;
	vIsolatedData: uint64;
	vShiftedData: uint64;
begin
	// clear out the bits for the field in mData

	// set the mask first
	vMask := ConstReservedMask;
	// shift the mask to the correct position, this shifts in zeros.
	vShiftedMask := vMask shl ConstReservedBitOffset;
	// invert the shifted mask
	vInvertedMask := not vShiftedMask;
	// clear out the bits in the data field
	mData := mData and vInvertedMask;

	// copy/or the value bits to the field in mData

	// isolate the value bits
	vIsolatedData := Value and ConstReservedMask;
	// shift the value bits to their position
	vShiftedData := vIsolatedData shl ConstReservedBitOffset;
	// or in the shifted data bits
	mData := mData or vShiftedData;
end;

procedure TH3Index.ClearIndexes;
begin
	case Mode of
		0 :
		begin
			mData := 0;
		end;

		1 :
		begin
			mData := mData and ConstAllIndexClearMask;
		end;
	end;
end;

procedure TH3Index.UnuseIndexes;
begin
	case Mode of
		1 :
		begin
			mData := mData or ConstAllIndexKeepMask;
		end;
	end;
end;


end.
