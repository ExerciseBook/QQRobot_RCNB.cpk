unit WideAndUTF8;

{$CODEPAGE UTF-8}

{$IFDEF FPC}
	{$MODE DELPHI}
{$ENDIF}

interface
	Function CoolQ_Tools_WideToUTF8(Sstr:widestring):ansistring;
	Function CoolQ_Tools_UTF8ToWide(Sstr:ansistring):widestring;

implementation
uses math,sysutils,iconv; 

Function iconvConvert(fromCode,toCode:PAnsiChar;srcBuf:PAnsiChar;srcLen:longint;destBuf:PAnsiChar;destLen:longint):longint;
Var
	cd	:	iconv_t;
	srcLen1,destLen1,status	:	longint;
Begin
	cd := libiconv_open(toCode,fromCode);
	srcLen1:=srcLen;
	destLen1:=destLen;
	status:=libiconv(cd,@srcBuf,@srcLen1,@destBuf,@destLen1);
	libiconv_close(cd);
	result:=status;
End;

Function CoolQ_Tools_WideToUTF8(Sstr:widestring):ansistring;
Var
	str:PAnsiChar;
	sResult:Array [0..262143] of ansichar;
	ret : longint;
Begin
	str:=@Sstr[1];
	fillchar(sResult,sizeof(sResult),0);
	//ret := iconvConvert('UTF-16LE//TRANSLIT//IGNORE','GB18030',Str,StrLen(Str),@sResult[0],sizeof(sResult));
	ret := iconvConvert('UTF-16LE//TRANSLIT//IGNORE','UTF-8',Str,length(Sstr)*sizeof(widechar),@sResult[0],sizeof(sResult));
	//ret := iconvConvert('UTF-16LE//TRANSLIT//IGNORE','GB18030',Str,sizeof(Sstr),@sResult[0],sizeof(sResult));
	if ret<>0
		then result:=''
		else result:=sResult;
End;

Function CoolQ_Tools_UTF8ToWide(Sstr:ansistring):widestring;
Var
	str:PAnsiChar;
	sResult:Array [0..262143] of widechar;
	ret :longint;
Begin
	str:=@Sstr[1];
	fillchar(sResult,sizeof(sResult),0);
	ret := iconvConvert('UTF-8//IGNORE','UTF-16LE',Str,StrLen(Str),@sResult[0],sizeof(sResult));
	if ret<>0
		then result:=''
		else result:=sResult;
End;

end.

