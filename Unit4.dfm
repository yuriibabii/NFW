object Form4: TForm4
  Left = 252
  Top = 168
  BorderStyle = bsNone
  Caption = #1056#1077#1078#1080#1084' '#1073#1086#1102' '#1079#1077#1084#1083#1103'-'#1087#1086#1074#1110#1090#1088#1103
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
    Left = 32
    Top = 40
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 45
    OnTimer = Timer2Timer
    Left = 32
    Top = 168
  end
  object Timer3: TTimer
    OnTimer = Timer3Timer
    Left = 208
    Top = 40
  end
end
