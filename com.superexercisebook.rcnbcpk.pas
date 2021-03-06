{
          _____                    _____                    _____                    _____                            _____                    _____                    _____          
         /\    \                  /\    \                  /\    \                  /\    \                          /\    \                  /\    \                  /\    \         
        /::\    \                /::\    \                /::\____\                /::\    \                        /::\    \                /::\    \                /::\____\        
       /::::\    \              /::::\    \              /::::|   |               /::::\    \                      /::::\    \              /::::\    \              /:::/    /        
      /::::::\    \            /::::::\    \            /:::::|   |              /::::::\    \                    /::::::\    \            /::::::\    \            /:::/    /         
     /:::/\:::\    \          /:::/\:::\    \          /::::::|   |             /:::/\:::\    \                  /:::/\:::\    \          /:::/\:::\    \          /:::/    /          
    /:::/__\:::\    \        /:::/  \:::\    \        /:::/|::|   |            /:::/__\:::\    \                /:::/  \:::\    \        /:::/__\:::\    \        /:::/____/           
   /::::\   \:::\    \      /:::/    \:::\    \      /:::/ |::|   |           /::::\   \:::\    \              /:::/    \:::\    \      /::::\   \:::\    \      /::::\    \           
  /::::::\   \:::\    \    /:::/    / \:::\    \    /:::/  |::|   | _____    /::::::\   \:::\    \            /:::/    / \:::\    \    /::::::\   \:::\    \    /::::::\____\________  
 /:::/\:::\   \:::\____\  /:::/    /   \:::\    \  /:::/   |::|   |/\    \  /:::/\:::\   \:::\ ___\          /:::/    /   \:::\    \  /:::/\:::\   \:::\____\  /:::/\:::::::::::\    \ 
/:::/  \:::\   \:::|    |/:::/____/     \:::\____\/:: /    |::|   /::\____\/:::/__\:::\   \:::|    |        /:::/____/     \:::\____\/:::/  \:::\   \:::|    |/:::/  |:::::::::::\____\
\::/   |::::\  /:::|____|\:::\    \      \::/    /\::/    /|::|  /:::/    /\:::\   \:::\  /:::|____|        \:::\    \      \::/    /\::/    \:::\  /:::|____|\::/   |::|~~~|~~~~~     
 \/____|:::::\/:::/    /  \:::\    \      \/____/  \/____/ |::| /:::/    /  \:::\   \:::\/:::/    /          \:::\    \      \/____/  \/_____/\:::\/:::/    /  \/____|::|   |          
       |:::::::::/    /    \:::\    \                      |::|/:::/    /    \:::\   \::::::/    /            \:::\    \                       \::::::/    /         |::|   |          
       |::|\::::/    /      \:::\    \                     |::::::/    /      \:::\   \::::/    /              \:::\    \                       \::::/    /          |::|   |          
       |::| \::/____/        \:::\    \                    |:::::/    /        \:::\  /:::/    /                \:::\    \                       \::/____/           |::|   |          
       |::|  ~|               \:::\    \                   |::::/    /          \:::\/:::/    /                  \:::\    \                       ~~                 |::|   |          
       |::|   |                \:::\    \                  /:::/    /            \::::::/    /                    \:::\    \                                         |::|   |          
       \::|   |                 \:::\____\                /:::/    /              \::::/    /                      \:::\____\                                        \::|   |          
        \:|   |                  \::/    /                \::/    /                \::/____/                        \::/    /                                         \:|   |          
         \|___|                   \/____/                  \/____/                  ~~                               \/____/                                           \|___|          
                                                                                                                                                                                       
}
{$CODEPAGE UTF-8}

library
	RCNBCPK;
	//DLL 编译

{$APPTYPE GUI}
{$I-}
{$h+}

Uses
	iconv,CoolQSDK,		//酷QSDK单元
	windows,math,dateutils,sysutils,Classes,
	
	plugin_events //插件事件处理单元
	;
	//载入库


{ 
* 返回应用的ApiVer、Appid，打包后将不会调用
}
Function AppInfo:PAnsichar;
stdcall; 
Begin
	CQAPPID:='com.superexercisebook.rcnbcpk';
	//请修改APPID为你的APPID
	
	//下面两行不用修改
	CQAPPINFO:=CQAPIVERTEXT+','+CQAPPID;
{$IFDEF FPC}
	exit(StoP(CQAPPINFO));
{$ELSE}
	Result:=StoP(CQAPPINFO);
{$ENDIF}
End;

{
* 接收应用AuthCode，酷Q读取应用信息后，如果接受该应用，将会调用这个函数并传递AuthCode。
* 不要在本函数处理其他任何代码，以免发生异常情况。如需执行初始化代码请在Startup事件中执行（Type=1001）。
}
Function Initialize(ac:longint):longint;
stdcall;
Begin
	AuthCode:=ac;
		
{$IFDEF FPC}
	exit(0);
{$ELSE}
	Result:=0;
{$ENDIF}
End;

Function _eventStartup:longint;
stdcall;
Begin
	randomize;
{$IFDEF FPC}
	exit(code_eventStartup);
{$ELSE}
	result:=code_eventStartup;
{$ENDIF}
End;

Function _eventExit:longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventExit);
{$ELSE}
	result:=code_eventExit;
{$ENDIF}
End;

Function _eventEnable:longint;
stdcall;
Begin
	randomize;
{$IFDEF FPC}
	exit(code_eventEnable);
{$ELSE}
	result:=code_eventEnable;
{$ENDIF}
End;

Function _eventDisable:longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventDisable);
{$ELSE}
	result:=code_eventDisable;
{$ENDIF}
End;

Function _RCNBPM(
			subType,MsgID		:longint;
			fromQQ					:int64;
			const msg				:PAnsichar;
			font					:longint):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventPrivateMsg(
			subType,MsgID,
			fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			font
		)
	);
{$ELSE}
	result:=code_eventPrivateMsg(
			subType,MsgID,
			fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			font
		);
{$ENDIF}
End;

Function _RCNBGM(
			subType,MsgID		:longint;
			fromgroup,fromQQ		:int64;
			const fromAnonymous,msg	:PAnsichar;
			font					:longint):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventGroupMsg(
			subType,MsgID,
			fromgroup,fromQQ,
			PtoS(fromAnonymous),
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			font
		)
	);
{$ELSE}
	result:=code_eventGroupMsg(
			subType,MsgID,
			fromgroup,fromQQ,
			PtoS(fromAnonymous),
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			font
		);
{$ENDIF}
End;

Function _RCNBDM(
			subType,MsgID		:longint;
			fromDiscuss,fromQQ		:int64;
			msg						:PAnsichar;
			font					:longint):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventDiscussMsg(
		subType,MsgID,
		fromDiscuss,fromQQ,
		CoolQ_Tools_AnsiToWide(PtoS(msg)),
		font
		)
	);
{$ELSE}
	result:=code_eventDiscussMsg(
		subType,MsgID,
		fromDiscuss,fromQQ,
		CoolQ_Tools_AnsiToWide(PtoS(msg)),
		font
		);
{$ENDIF}
End;

Function _eventGroupUpload(
			subType,sendTime	:longint;
			fromGroup,fromQQ	:int64;
			fileinfo			:PAnsichar):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventGroupUpload(
			subType,sendTime,
			fromGroup,fromQQ,
			PtoS(fileinfo)));
{$ELSE}
	result:=code_eventGroupUpload(
			subType,sendTime,
			fromGroup,fromQQ,
			PtoS(fileinfo));
{$ENDIF}
End;

Function _eventSystem_GroupAdmin(
			subType,sendTime		:longint;
			fromGroup,
			beingOperateQQ			:int64):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventSystem_GroupAdmin(
		subType,sendTime,
		fromGroup,
		beingOperateQQ
		)
	); 
{$ELSE}
	result:=code_eventSystem_GroupAdmin(
		subType,sendTime,
		fromGroup,
		beingOperateQQ
		);
{$ENDIF}
End;

Function _eventSystem_GroupMemberDecrease(
			subType,sendTime		:longint;
			fromGroup,fromQQ,
			beingOperateQQ			:int64):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventSystem_GroupMemberDecrease(
			subType,sendTime,
			fromGroup,fromQQ,
			beingOperateQQ
		)
	);
{$ELSE}
	result:=code_eventSystem_GroupMemberDecrease(
			subType,sendTime,
			fromGroup,fromQQ,
			beingOperateQQ
		);
{$ENDIF}
End;

Function _eventSystem_GroupMemberIncrease(
			subType,sendTime		:longint;
			fromGroup,fromQQ,
			beingOperateQQ			:int64):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventSystem_GroupMemberIncrease(
			subType,sendTime,
			fromGroup,fromQQ,
			beingOperateQQ	
		)
	); 
{$ELSE}
	result:=code_eventSystem_GroupMemberIncrease(
			subType,sendTime,
			fromGroup,fromQQ,
			beingOperateQQ	
		);
{$ENDIF}
End;

Function _eventFriend_Add(
			subType,sendTime		:longint;
			fromQQ					:int64):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventFriend_Add(
			subType,sendTime,fromQQ
		)
	);
{$ELSE}
	result:=code_eventFriend_Add(
			subType,sendTime,fromQQ
		);
{$ENDIF}
End;

Function _eventRequest_AddFriend(
			subType,sendTime			:longint;
			fromQQ						:int64;
			const msg,responseFlag		:PAnsichar):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventRequest_AddFriend(
			subType,sendTime,
			fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			responseFlag
		)
	);
{$ELSE}
	result:=code_eventRequest_AddFriend(
			subType,sendTime,
			fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			responseFlag
		);
{$ENDIF}
End;

Function _eventRequest_AddGroup(
			subType,sendTime			:longint;
			fromGroup,fromQQ			:int64;
			msg,responseFlag			:PAnsichar):longint;
stdcall;
Begin
{$IFDEF FPC}
	exit(code_eventRequest_AddGroup(
			subType,sendTime,
			fromGroup,fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			responseFlag
		)
	);
{$ELSE}
	result:=code_eventRequest_AddGroup(
			subType,sendTime,
			fromGroup,fromQQ,
			CoolQ_Tools_AnsiToWide(PtoS(msg)),
			responseFlag
		);
{$ENDIF}
End;

exports
	AppInfo index 1,
	Initialize index 2,
	_RCNBPM index 10,
	_RCNBGM index 11,
	_RCNBDM index 12;

Begin
End.