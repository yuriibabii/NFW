object Form2: TForm2
  Left = 203
  Top = 194
  AlphaBlendValue = 250
  BorderStyle = bsNone
  Caption = 'Need for Win'
  ClientHeight = 500
  ClientWidth = 1000
  Color = clMenuHighlight
  TransparentColorValue = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClick = FormClick
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 872
    Top = 112
    Width = 4
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'AngryBirds'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 872
    Top = 160
    Width = 4
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'AngryBirds'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 720
    Top = 312
    Width = 3
    Height = 13
    Visible = False
  end
  object TrackBar1: TTrackBar
    Left = 720
    Top = 112
    Width = 150
    Height = 33
    Max = 100
    Position = 50
    SelEnd = 50
    TabOrder = 0
    TickStyle = tsManual
    Visible = False
    OnChange = TrackBar1Change
  end
  object TrackBar2: TTrackBar
    Left = 720
    Top = 160
    Width = 150
    Height = 33
    Max = 100
    Position = 25
    SelEnd = 25
    TabOrder = 1
    TickStyle = tsManual
    Visible = False
    OnChange = TrackBar2Change
  end
  object RzMemo1: TRzMemo
    Left = 192
    Top = 88
    Width = 185
    Height = 89
    TabOrder = 2
    Visible = False
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 8
    Top = 8
  end
end
