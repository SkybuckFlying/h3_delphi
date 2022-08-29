unit unit_UBER_H3_V4_TH3Index_BitConstants_version_007;

interface

const
	ConstMaxResolution = 15;
	ConstBitsPerDigit = 3;

	ConstReservedBitOffset = 63;
	ConstReservedMask : uint64 = 1;

	ConstModeBitOffset = 59;
	ConstModeMask : uint64 = 1 + 2 + 4 + 8; // 15

	ConstModeDependentBitOffset = 56;
	ConstModeDependentMask : uint64 = 1 + 2 + 4; // 7

	ConstResolutionBitOffset = 52;
	ConstResolutionMask : uint64 = 1 + 2 + 4 + 8; // 15;

	ConstBaseCellBitOffset = 45;
	ConstBaseCellMask : uint64 = 1 + 2 + 4 + 8 + 16 + 32 + 64; // 127

	// only for digits 1 to 15, not the base cell digit.
	ConstDigitMask : uint64 = 1 + 2 + 4; // 7

	// Delphi 64 bit compiler limitation, cannot add the last bit value properly :(
(*
	ConstAllIndexClearMask : uint64 =
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // first 8 bits total  8 bits
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // next 8 bits, total 16 bits
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // next 8 bits, total 24 bits
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // next 8 bits, total 32 bits
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // next 8 bits, total 40 bits
	  0 + 0 + 0 + 0 + 0 + 0 + 0 + 0 + // next 8 bits, total 48 bits
					  0 +                  0 +                  0 +                  0 +                   0 +    9007199254740992 +   18014398509481984 +   36028797018963968 ;  // next 8 bits, total 56 bits
	  72057594037927936 + 144115188075855872 + 288230376151711744 + 576460752303423488 + 1152921504606846976 + 2305843009213693952 + 4611686018427387904 + 9223372036854775808;   // next 8 bits, total 64 bits *** PROBLEM ***
*)
	ConstAllIndexClearMask : uint64 = $FFFFFFFFFFFFFFFF shl 53;

(*
	// CORRECT, as long as you don't touch it fool ! ;) =D
	ConstAllIndexKeepMask : uint64 =
					  1 +                  2 +                  4 +                  8 +                 16 +                   32 +                64 +                   128 +  // first 8 bits, total 8 bits
					256 +                512 +               1024 +               2048 +               4096 +                 8192 +             16384 +                 32768 +  // next 8 bits, total 16 bits
				  65536 +             131072 +             262144 +             524288 +            1048576 +              2097152 +           4194304 +               8388608 +  // next 8 bits, total 24 bits
			   16777216 +           33554432 +           67108864 +          134217728 +          268435456 +            536870912 +        1073741824 +            2147483648 +  // next 8 bits, total 32 bits
			 4294967296 +         8589934592 +        17179869184 +        34359738368 +        68719476736 +         137438953472 +      274877906944 +          549755813888 +  // next 8 bits, total 40 bits
		  1099511627776 +      2199023255552 +      4398046511104 +      8796093022208 +     17592186044416 +       35184372088832 +    70368744177664 +       140737488355328 +  // next 8 bits, total 48 bits
		281474976710656 +	 562949953421312 +   1125899906842624 +   2251799813685248 +   4503599627370496;  // next 5 bits, total 53 bits
*)

	ConstAllIndexKeepMask : uint64 = $FFFFFFFFFFFFFFFF shr 11;

implementation

{

H3Index base according to documentation



DX = D=Digit X=Number
B = Base Cell
R = Resolution
MD = Mode Dependent
M = Mode
. = Reserved


        63  62  61  60  59  58  57  56  55  54  53  52  51  50  49  48
0063    .   M   M   M   M   MD  MD  MD  R   R   R   R   B   B   B   B    0048

		47  46  45  44  43  42  41  40  39  38  37  36  35  34  33  32
0047    B   B   B   D1  D1  D1  D2  D2  D2  D3  D3  D3  D4  D4  D4  D5   0032

		31  30  29  28  27  26  25  24  23  22  21  20  19  18  17  16
0031    D5  D5  D6  D6  D6  D7  D7  D7  D8  D8  D8  D9  D9  D9  D10 D10  0016

		15  14  13  12  11  10  9   8   7   6   5   4   3   2   1   0
0015    D10 D11 D11 D12 D12 D12 D13 D13 D13 D14 D14 D14 D14 D15 D15 D15  0000


}


end.
