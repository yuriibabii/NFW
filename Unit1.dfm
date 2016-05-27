object Form1: TForm1
  Left = 193
  Top = 88
  BorderStyle = bsNone
  Caption = 'Planes'
  ClientHeight = 689
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 45
    OnTimer = Timer2Timer
    Left = 8
    Top = 120
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 160
    Top = 8
  end
end
