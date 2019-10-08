unit RCNB;
{$MODE DELPHI}
{$CODEPAGE UTF-8}

interface
uses
	sysutils,classes,math;

Type
	LengthNotNBException = Class(Exception);
	NotEnoughNBException = Class(Exception);
	RCNBOverflowException = Class(Exception);

function RCNB_Encode(s:TBytes):widestring;
function RCNB_Decode(s:widestring):TBytes;

implementation
Const
    cr = 'rRŔŕŖŗŘřƦȐȑȒȓɌɍ';
    cc = 'cCĆćĈĉĊċČčƇƈÇȻȼ';
    cn = 'nNŃńŅņŇňƝƞÑǸǹȠȵ';
    cb = 'bBƀƁƃƄƅßÞþ';

    sr = length(cr);
    sc = length(cc);
    sn = length(cn);
    sb = length(cb);
    src = sr * sc;
    snb = sn * sb;
    scnb = sc * snb;

	
function _div(a,b:longint):longint;
Begin
	exit(floor(a/b));
End;
	
function encodeByte(i:longint):widestring;
Var
	value : longint;
Begin
	if (i > $FF) then begin
		raise RCNBOverflowException.Create('RCNB(RC/NB) Overflow.');
	end
	else
	if (i > $7F) then begin
		value := i and $7F;
		result := cn[_div(value,sb) +1] + cb[value mod sb+1]
	end
	else
	begin
		result := cr[_div(i,sc) +1] + cc[i mod sc +1]
	end;
End;


function encodeShort(value : longint):widestring;
Var
	reverse : boolean;
	i : longint;
	chars : widestring;
Begin
	if (value > $FFFF) then raise RCNBOverflowException.Create('RCNB(RC/NB) Overflow.');
	reverse := false;
	i := value;
	if (i > $7FFF) then begin
		reverse := true;
		i := i and $7FFF;
	end;
	chars:= cr[_div(i,scnb)+1] + cc[_div(i mod scnb,snb)+1] + cn[_div(i mod snb,sb)+1] + cb[i mod sb+1];
	if reverse then begin
		result := chars[3] + chars[4] + chars[1] + chars[2];
	end
	else
		result := chars;
End;

function RCNB_Encode(s:TBytes):widestring;
Var
	i : longint;
Begin
	result:='';
	for i := 0 to (length(s) div 2)-1 do result := result + encodeShort( s[i*2]<<8 or s[i*2+1] );
	if length(s) mod 2 <> 0 then
		result := result + encodeByte( s[length(s)-1] );
End;

function decodeByte(c:widestring):longint;
Var
	nb : boolean;
	idx : array[1..2] of longint;
Begin
	nb:=false;
	idx[1]:=pos(c[1],cr)-1;
	idx[2]:=pos(c[2],cc)-1;
	if (idx[1]<0) or (idx[2]<0) then begin
		idx[1]:=pos(c[1],cn)-1;
		idx[2]:=pos(c[2],cb)-1;	
		nb:=true;
	end;
	if (idx[1]<0) or (idx[2]<0) then
		raise NotEnoughNBException.Create('This string is not enough nb!');
	if nb
		then exit( (idx[1]*sb + idx[2]) or $80)
		else exit(  idx[1]*sc + idx[2]);
End;

function decodeShort(c:widestring):longint;
Var
	reverse : boolean;
	idx : array[1..4] of longint;
Begin
	reverse := pos(c[1],cr) = 0;
	if not reverse then begin
		idx[1] := pos(c[1],cr)-1;
		idx[2] := pos(c[2],cc)-1;
		idx[3] := pos(c[3],cn)-1;
		idx[4] := pos(c[4],cb)-1;
	end
	else
	begin
		idx[1] := pos(c[3],cr)-1;
		idx[2] := pos(c[4],cc)-1;
		idx[3] := pos(c[1],cn)-1;
		idx[4] := pos(c[2],cb)-1;
	end;
	if (idx[1]<0) or (idx[2]<0) or (idx[3]<0) or (idx[4]<0) then
		raise NotEnoughNBException.Create('This string is not enough nb!');
	result:= idx[1]*scnb + idx[2]*snb + idx[3]*sb + idx[4];
	if result>$7FFF then 
		raise RCNBOverflowException.Create('RCNB(RC/NB) Overflow');
	if reverse then result := result or $8000;
End;

function RCNB_Decode(s:widestring):TBytes;
Var
	i,value:longint;
Begin
	if length(s) and 1 = 1 then
		raise LengthNotNBException.Create('Not a Nb length for a string!');
	setlength(result,length(s) >> 1);
	for i:=0 to (length(s) >> 2)-1 do begin
		value := decodeShort(copy(s,i*4+1,4));
		result[i*2]:=value >> 8;
		result[i*2+1]:=value and $ff;
	end;
	if length(s) and 2 > 0 then
		result[length(result)-1]:=decodeByte(copy(s,length(s)-1,2));

End;


end.