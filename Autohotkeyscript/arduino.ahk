;simpleTerm 12-12-2019
#singleinstance force
setbatchlines -1

inputHistory := ""
header := "- - - - - - TERMINAL OUTPUT - - - - - -" . chr(10) . chr(10) . ">>"

gui main:add,text,w200 x10 center,Terminal Input
gui main:add,text,wp x+10 center,Terminal Output
gui main:add,edit,wp h100 y+5 x10 vgSendField gSend,
gui main:add,edit,wp h100 yp x+10 vgRecieveField readonly,
gui main:show,,SimpleTerm

;attempt to connect to serial port
	
RS232_Port		:= "COM4"
RS232_Baud     	:= 9600
RS232_Parity   	:= "N"
RS232_Data     	:= 8
RS232_Stop     	:= 1
RS232_Delay    	:= 100 ;decrease this value for lower latency 


RS232_Settings   = %RS232_Port%:baud=%RS232_Baud% parity=%RS232_Parity% data=%RS232_Data% stop=%RS232_Stop% dtr=Off	
RS232_FileHandle:= RS232_Initialize(RS232_Settings)
send_serial(header)
setTimer, readData, -%RS232_Delay%
return

~Backspace::
	;clear the terminals
	inputHistory :=""
	guiControl,Main:,gRecieveField,
	guiControl,Main:,gSendField,
	send_serial(header)
return

Send:
	; launched when you type in the terminal input
	; finds what new text you have entered and sends it to the serial connection
	gui,Main:Submit,Nohide
	changes := ""
	changes := strReplace(gSendField,inputHistory) ;allows for copy paste events
	inputHistory := gSendField	
	changes := strReplace(changes,"`n","`n>>") ;modify for output formatting	
	send_serial(changes)
return

readData:
	;read data that is on the serial port buffer
	;post it to the terminal output
	Read_Data := RS232_Read(RS232_FileHandle,"0xFF",RS232_Bytes_Received)
	if(RS232_Bytes_Received>0)
	{
		critical on
		ASCII =
		Read_Data_Num_Bytes := StrLen(Read_Data) / 2 ;RS232_Read() returns 2 characters for each byte
		textRecieved := ""
		Loop %Read_Data_Num_Bytes%
		{
			StringLeft, Byte, Read_Data, 2
			StringTrimLeft, Read_Data, Read_Data, 2
			Byte = 0x%Byte%
			;msgbox %Byte%
			Byte := Byte + 0 ;Convert to Decimal       


			ASCII_Chr := Chr(Byte)
			textRecieved .= ASCII_Chr
			
			
		}
		critical off
		gui,Main:Submit,Nohide
		textRecieved := gRecieveField . textRecieved
		guiControl,Main:,gRecieveField,%textRecieved%
		
		
		If InStr(textRecieved, "VSCode")
   		 Run "code",,hide

		If InStr(textRecieved, "Krita")
   		 Run "C:\Program Files\Krita (x64)\bin\krita.exe",,hide


		If InStr(textRecieved, "YouTube")
	   	  Run https://www.youtube.com

		If InStr(textRecieved, "Arduino")
	   	  Run "C:\Program Files\Arduino IDE\Arduino IDE.exe",,hide


		if (RegExMatch(textRecieved, "Volume:(\d+)", match)) {
         	   SoundSet, %match1%
      		 }
   		

		;clear the terminals
		inputHistory :=""
		guiControl,Main:,gRecieveField,
		guiControl,Main:,gSendField,
		send_serial(header)

	}
	setTimer, readData, -%RS232_Delay%
return

^+r::
	reload
return

send_serial(data)
{
	global
	;msgbox %data%
	SetFormat, INTEGER, H
	var := ""
	loop parse,data
	{		
		var .= Asc(SubStr(A_LoopField,0)) . "`," ;Get the key that was pressed and convert it to its ASCII code
	}	
	SetFormat, INTEGER, D
	RS232_Write(RS232_FileHandle,var)	
}

#Include console.ahk