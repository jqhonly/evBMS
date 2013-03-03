 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
 ' 6802 Master Version 0.03 Alpha
 ' Greg Fordyce 23 Feb 13
 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Cls

SetPin 11, 8   ' Charger relay on pin 11

'''''''''''''''' CONFIGURATION VARIABLES '''''''''''''''''''''''''''''''''
CellNo = 48

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Mode 4
Print "6802 Master Version 0.04 Alpha"

Pause 3000

Open "COM1:9600" As #1
Dim barval(CellNo)
Dim cellV(CellNo)
Cls
LoadBMP "SCREEN.BMP"


height = 100
margin = 45
width = MM.HRes - margin

 ' parameters for the bar graphs
bx = margin : by = MM.VRes-5
dx = bx : dy = by



Main:
Do

'  Print #1,Chr$(16);   ' Send STCVAD to slaves (start cell voltage A/D)
'  Pause 20
  Print #1,Chr$(200);   ' Read cell voltage register
  Pause 150

         For i = 1 To CellNo
         arg$ = ""                        ' clear ready for data
            Do                                  ' loops until a specific exit
               x$ = Input$(1, #1)                ' get the character
               If x$ = "," Then Exit             ' new data field, increment i
               arg$ = arg$ + x$            ' add to the data
            Loop                                ' loop back for the next char
          CellV(i) = Val( arg$ )
          CellV(i) = CellV(i) / 100
       Next i                                ' move to the next data field


HiV=0 : LoV=5 : PackV=0
For I = 1 To CellNo
If CellV(I) < LoV Then
LoV = CellV(I) : LoCell = I : EndIf
If CellV(I) > HiV Then
HiV = CellV(I) : HiCell = I : EndIf
PackV = PackV + CellV(I)
Next i

If hiv > 3.65 Then Pin(11) = 0	' Turn off charger

Locate 0,0
''''''''''' Display cell and pack values ''''''''''
Print Format$(PackV," Pack %4.1fV   ")
Print @(191,0) Time$
Print @(27,130)Format$(HiCell,"%2.0f")
Print @(15,144)Format$(HiV,"%3.2f")
Print @(27,160)Format$(LoCell,"%2.0f")
Print @(15,174)Format$(LoV,"%3.2f")

''''''''''draw the bar graphs''''''''''

For j = 1 To CellNo
barclr = 2  'set color to green
If cellv(j) > 3.59 Or cellv(j) < 2.5 Then barclr = 6    'yellow
If cellv(j) > 3.65 Or Cellv(j) < 2.3 Then barclr = 4    'red
 barval(j) = (cellV(J)-2)*50
 st = 4*(j - 1) + bx
 Line(st,by)-(st+2,by-barval(j)),barclr,bf
 Line (st,by-barval(j))-(st+2,by-height),0,bf
Next j
'If Inkey$= "S" Then SaveBMP "image1.bmp"
If Inkey$= "1" Then Pin(11) = 1   ' Start charging


Loop


