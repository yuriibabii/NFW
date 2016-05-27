unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pngimage, bass, SongStream;

type
  TForm5 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  BufPause,panelfon:TBitmap;
  buttonpause:array [1..2,1..2] of TPNGObject;
  ZX,ZY:Integer;
  Activbtp:array [1..2] of Integer;
  path:string;
  zvuk:TSongStream;
  KoordButton:array [1..2] of TPoint;

implementation
uses Unit2, Unit4;

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
var i,j:Integer;
begin
 path:=ExtractFileDir(Application.ExeName);

 BufPause:=TBitmap.Create;
 BufPause.Width:=ClientWidth;
 BufPause.Height:=ClientHeight;

 panelfon:=TBitmap.Create;
 panelfon.LoadFromFile(path+'/data/interface/pause/tablebmp.bmp');


 for i:=1 to 2 do
 for j:=1 to 2 do
 begin
  buttonpause[i,j]:=TPNGObject.Create;
  buttonpause[i,j].LoadFromFile(path+'/data/interface/pause/'+inttostr(i)+inttostr(j)+'.png');
 end;


 zvuk:=TSongStream.Create;
 zvuk.Init(path+'/data/interface/pause/Beep.mp3');
 zvuk.SetVolume(Form2.TrackBar1.Position);

 for i:=1 to 2 do Activbtp[i]:=1;

 with KoordButton[1] do
 begin
  X:=(ClientWidth div 2)-145;
  Y:=(ClientHeight div 2)-105;
 end;

 with KoordButton[2] do
 begin
  X:=(ClientWidth div 2)-145;
  Y:=(ClientHeight div 2)+45;
 end;
end;



procedure TForm5.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i:Integer;
begin
 ZX:=X;
 ZY:=Y;
 for i:=1 to 2 do
 if (X>KoordButton[i].X) and (X<KoordButton[i].X+290)
 and (Y>KoordButton[i].Y) and (Y<KoordButton[i].Y+65) then
 begin
  Activbtp[i]:=2;
  zvuk.Play(True);
 end
 else Activbtp[i]:=1;
end;


procedure TForm5.FormClick(Sender: TObject);
var i:Integer;
begin


  if (ZX>KoordButton[1].X) and (ZX<KoordButton[1].X+290)
  and (ZY>KoordButton[1].Y) and (ZY<KoordButton[1].Y+65) then
  begin
   Form4.Timer1.Enabled:=True;
   Form4.Timer2.Enabled:=True;
   Form4.Timer3.Enabled:=True;
   Form5.Hide;
  end;

   if (ZX>KoordButton[2].X) and (ZX<KoordButton[2].X+290)
  and (ZY>KoordButton[2].Y) and (ZY<KoordButton[2].Y+65) then
  begin
   Form4.Timer1.Enabled:=False;
   with Songs do
   begin
    for i:=1 to 2 do
    begin
     Bullet[i].Stop;
     Vzruv[i].Stop;
    end;
    for i:=1 to 6 do Music[i].Stop;
   end;
   Form2.Visible:=True;
   Musics[musIndex].Play(True);
   Form4.Close;
   Form5.Close;
  end;

end;

procedure TForm5.Timer1Timer(Sender: TObject);
begin
 BufPause.Canvas.Draw(0,0,panelfon);
 BufPause.Canvas.Draw(KoordButton[1].X,KoordButton[1].Y,buttonpause[1,Activbtp[1]]);
 BufPause.Canvas.Draw(KoordButton[2].X,KoordButton[2].Y,buttonpause[2,Activbtp[2]]);
 Form5.Canvas.Draw(0,0,BufPause);
end;

procedure TForm5.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
 begin
   Form4.Timer1.Enabled:=True;
   Form4.Timer2.Enabled:=True;
   Form4.Timer3.Enabled:=True;
   Form5.Hide;
 end;
end;

end.
