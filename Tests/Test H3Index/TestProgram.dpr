program TestProgram;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  unit_test_TH3Index_version_007 in 'unit_test_TH3Index_version_007.pas',
  unit_UBER_H3_V4_API_ALL_version_007 in '..\..\Source\unit_UBER_H3_V4_API_ALL_version_007.pas',
  unit_UBER_H3_V4_TH3Index_BitConstants_version_007 in '..\..\Source\unit_UBER_H3_V4_TH3Index_BitConstants_version_007.pas',
  Unit_UBER_H3_V4_TH3Index_version_007 in '..\..\Source\Unit_UBER_H3_V4_TH3Index_version_007.pas';

function BooleanToString( ParaValue : boolean ) : string;
begin
	if ParaValue = True then
	begin
		result := 'True';
	end else
	begin
		result := 'False';
	end;
end;

procedure Main;
begin
	writeln('program started');
	writeln;

	writeln( 'IsH3IndexTestedOK: ', BooleanToString(IsH3IndexTestedOK) );

	writeln;
	writeln('program finished');
end;

begin
	try
		Main;
	except
		on E: Exception do
			Writeln(E.ClassName, ': ', E.Message);
	end;
	writeln;
	writeln('press enter to exit');
	ReadLn;
end.
