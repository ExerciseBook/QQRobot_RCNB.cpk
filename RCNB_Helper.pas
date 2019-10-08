unit RCNB_Helper;
{$CODEPAGE UTF-8}

{$IFDEF FPC}
	{$MODE DELPHI}
{$ENDIF}

interface
    function RCNB_Helper(msg:WideString;var back:WideString):boolean;

    
implementation
uses
    SysUtils, Classes, RCNB, WideAndUTF8, CoolQSDK;
    function toAnsiString(a:tbytes):ansistring;
    var
        i:longint;
    begin
        setlength(result,length(a));
        for i:=0 to length(a)-1 do result[i+1]:=ansichar(a[i]);
    end;


    function RCNB_Helper(msg:WideString;var back:WideString):boolean;
    var
        s:widestring;
        instr:widestring;

        b:TBytes;
    begin
        s:=upcase(copy(msg,1,length('!RCNBXXcode ')));

        if (s='!RCNBENCODE ') then begin
            instr:=copy(msg,length('!RCNBXXcode ')+1,length(msg));
            try
                back:=RCNB_Encode(BytesOf(CoolQ_Tools_WideToUTF8(instr)));
            except
                on e:Exception do back:=widestring(e.Message);
            end;
            exit(true);
        end;

        if (s='!RCNBDECODE ') then begin
            instr:=copy(msg,length('!RCNBXXcode ')+1,length(msg));
            try
                b:=RCNB_Decode(instr);
                back:=CoolQ_Tools_UTF8ToWide(toAnsiString(b));
            except
                on e:Exception do back:=widestring(e.Message);
            end;
            exit(true);
        end;

        exit(false);
    end;

    
end.