unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,bass,SongStream,pngimage,ExtCtrls, ComCtrls, RzTrkBar,
  StdCtrls, RzLabel, RzStatus, RzEdit;

type
  TForm2 = class(TForm)
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    TrackBar2: TTrackBar;
    Label2: TLabel;
    RzMemo1: TRzMemo;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  BufLaunch,FonMenu:TBitmap;
  Logo:array[1..28] of TPNGObject;
  animLogo,zadLogo:Integer;
  Buttons:array[1..2,1..9] of TPNGObject;
  Activation:array[1..9] of Integer;
  Koord:array[1..9] of TPoint;
  path,regim:string;
  ZX,ZY:Integer;
  WindowsExit:TPNGObject;
  ExitButton:array[1..2,1..2] of TPNGObject;
  ActivExit:array[1..2] of Integer;
  PanelVboi,PanelRazr:TPNGObject;
  VboiBtn:array[1..3,1..3] of TPNGObject;
  ActivVboi:array[1..3] of Integer;
  VuborVboi:Integer;
  PhPl1,PhPl2,PhTank:TBitmap;
  maxschet:Integer;
  //options
  PanelUpr,PanelZvuk,NapusZvuk,NapusMuz,Upr,PanelUpr2,Upr2:TPNGObject;
  //options
  Musics:array[1..4] of TSongStream;
  Beep:TSongStream;
  musIndex,backsIndex:Integer;



implementation
uses Unit1,Unit4;
{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
var i,j:Integer;
begin
 regim:='logo';

 path:=ExtractFileDir(Application.ExeName);

 BufLaunch:=TBitmap.Create;
 BufLaunch.Width:=1000;
 BufLaunch.Height:=500;

 for i:=1 to 28 do
 begin
  Logo[i]:=TPNGObject.Create;
  Logo[i].LoadFromFile(path+'/data/menu/logo/'+inttostr(i)+'.png');
 end;
 animLogo:=1;

 FonMenu:=TBitmap.Create;
 FonMenu.LoadFromFile(path+'/data/menu/FonMenu.bmp');

 PanelUpr:=TPNGObject.Create;
 PanelUpr.LoadFromFile(path+'/data/menu/panelupr.png');

 PanelUpr2:=TPNGObject.Create;
 PanelUpr2.LoadFromFile(path+'/data/menu/panelupr2.png');

 PanelZvuk:=TPNGObject.Create;
 PanelZvuk.LoadFromFile(path+'/data/menu/panelzvuk.png');

 NapusZvuk:=TPNGObject.Create;
 NapusZvuk.LoadFromFile(path+'/data/menu/RegZvuk.png');

 NapusMuz:=TPNGObject.Create;
 NapusMuz.LoadFromFile(path+'/data/menu/RegMuz.png');

 Upr:=TPNGObject.Create;
 Upr.LoadFromFile(path+'/data/menu/upr.png');

 Upr2:=TPNGObject.Create;
 Upr2.LoadFromFile(path+'/data/menu/upr2.png');

 for i:=1 to 2 do
 for j:=1 to 9 do
 begin
  Buttons[i,j]:=TPNGObject.Create;
  Buttons[i,j].LoadFromFile(path+'/data/menu/'+inttostr(i)+inttostr(j)+'.png');
 end;
 for i:=1 to 9 do Activation[i]:=1;

 for i:=1 to 4 do
 with Koord[i] do
 begin

  Koord[i].X:=(BufLaunch.Width div 2)-84;
  if i=1 then Koord[i].Y:=125
  else Koord[i].Y:=Koord[i-1].Y+66;

 end;

 WindowsExit:=TPNGObject.Create;
 WindowsExit.LoadFromFile(path+'/data/menu/exit/FonExit.png');

 for i:=1 to 2 do
 for j:=1 to 2 do
 begin
   ExitButton[i,j]:=TPNGObject.Create;
   ExitButton[i,j].LoadFromFile(path+'/data/menu/exit/'+inttostr(i)+inttostr(j)+'.png');
   ActivExit[j]:=1;
 end;

 PanelVboi:=TPNGObject.Create;
 PanelVboi.LoadFromFile(path+'/data/menu/vboi/panelvboi.png');

 for i:=1 to 3 do
 for j:=1 to 3 do
 begin
   VboiBtn[i,j]:=TPNGObject.Create;
   VboiBtn[i,j].LoadFromFile(path+'/data/menu/vboi/'+inttostr(i)+inttostr(j)+'.png');
 end;
 for i:=1 to 3 do ActivVboi[i]:=1;

 PhPl1:=TBitmap.Create;
 PhPl1.Transparent:=True;
 PhPl1.LoadFromFile(path+'/data/menu/vboi/Pl1.bmp');

 PhPl2:=TBitmap.Create;
 PhPl2.Transparent:=True;
 PhPl2.LoadFromFile(path+'/data/menu/vboi/Pl2.bmp');

 PhTank:=TBitmap.Create;
 PhTank.Transparent:=True;
 PhTank.LoadFromFile(path+'/data/menu/vboi/tank1.bmp');

 for i:=1 to 4 do
 begin
   Musics[i]:=TSongStream.Create;
   Musics[i].Init(path+'/data/menu/music/'+inttostr(i)+'.mp3');
   Musics[i].SetVolume(TrackBar2.Position);
 end;
 musIndex:=Random(4)+1;

 Beep:=TSongStream.Create;
 Beep.Init(path+'/data/menu/sound/beep.mp3');
 Beep.SetVolume(TrackBar1.Position);

 RzMemo1.Lines.LoadFromFile(path+'/data/settings.dk');
 TrackBar1.Position:=StrToInt(RzMemo1.Lines.Strings[0]);
 TrackBar2.Position:=StrToInt(RzMemo1.Lines.Strings[1]);

 PanelRazr:=TPNGObject.Create;
 PanelRazr.LoadFromFile(path+'/data/menu/razrabupanel.png');



end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
 BufLaunch.Canvas.Draw(0,0,FonMenu);

 if regim='logo' then
 begin

   if animLogo=1 then
   if zadLogo=7 then
   begin
    animLogo:=animLogo+1;
    zadLogo:=0;
   end;

   if animLogo<>1 then
   if zadLogo=1 then
   begin
    animLogo:=animLogo+1;
    zadLogo:=0;
   end;
  BufLaunch.Canvas.Draw(0,0,Logo[animLogo]);

  zadLogo:=zadLogo+1;
   if animLogo+1>28 then
  begin
    regim:='menu';
    Musics[musIndex].Play(True);
  end;
 end;



 if Musics[musIndex].PositionCurrent=Musics[musIndex].LongueurTotal then
 begin
  backsIndex:=musIndex;
  while musIndex=backsIndex do musIndex:=Random(4)+1;
  Musics[musIndex].Play(True);
 end;


 if regim='menu' then
 begin
  BufLaunch.Canvas.Draw(Koord[1].X,Koord[1].Y,Buttons[Activation[1],1]);
  BufLaunch.Canvas.Draw(Koord[2].X,Koord[2].Y,Buttons[Activation[2],2]);
  BufLaunch.Canvas.Draw(Koord[3].X,Koord[3].Y,Buttons[Activation[3],3]);
  BufLaunch.Canvas.Draw(Koord[4].X,Koord[4].Y,Buttons[Activation[4],4]);
 end;
 if regim='options' then
 begin

  BufLaunch.Canvas.Draw(25,22,PanelUpr);
  BufLaunch.Canvas.Draw(35,45,Upr);
  BufLaunch.Canvas.Draw(575,200,PanelUpr2);
  BufLaunch.Canvas.Draw(575,200,Upr2);
  BufLaunch.Canvas.Draw(575,22,PanelZvuk);
  BufLaunch.Canvas.Draw(580,71,NapusZvuk);
  BufLaunch.Canvas.Draw(580,121,NapusMuz);

  TrackBar1.Left:=580+200+10;
  TrackBar1.Top:=71;
  TrackBar1.Visible:=True;
  Label1.Left:=TrackBar1.Left+TrackBar1.Width+5;
  Label1.Top:=TrackBar1.Top;
  Label1.Visible:=True;
  Label1.Caption:=IntToStr(TrackBar1.Position)+'%';

  TrackBar2.Left:=580+200+10;
  TrackBar2.Top:=121;
  TrackBar2.Visible:=True;
  Label2.Left:=TrackBar2.Left+TrackBar2.Width+5;
  Label2.Top:=TrackBar2.Top;
  Label2.Visible:=True;
  Label2.Caption:=IntToStr(TrackBar2.Position)+'%';


    Koord[5].X:=(BufLaunch.Width div 2)-178;
    Koord[5].Y:=425;
    Koord[6].X:=(BufLaunch.Width div 2)+10;
    Koord[6].Y:=425;

  BufLaunch.Canvas.Draw(Koord[5].X,Koord[5].Y,Buttons[Activation[5],5]);
  BufLaunch.Canvas.Draw(Koord[6].X,Koord[6].Y,Buttons[Activation[6],6]);
 end;

 if regim='razr' then
 begin
   BufLaunch.Canvas.Draw(25,22,PanelRazr);
   Koord[5].X:=(BufLaunch.Width div 2)-84;
   Koord[5].Y:=425;
   BufLaunch.Canvas.Draw(Koord[5].X,Koord[5].Y,Buttons[Activation[5],5]);
 end;

 if regim='exit' then
 begin
   BufLaunch.Canvas.Draw
   ((BufLaunch.Width div 2)-197,(BufLaunch.Height div 2)-87,WindowsExit);

   BufLaunch.Canvas.Draw
   ((BufLaunch.Width div 2)-145,(BufLaunch.Height div 2),ExitButton[ActivExit[1],1]);

      BufLaunch.Canvas.Draw
   ((BufLaunch.Width div 2)+20,(BufLaunch.Height div 2),ExitButton[ActivExit[2],2]);
 end;

 if regim='vubor' then
 begin
   Koord[8].X:=(BufLaunch.Width div 2)-84;
   Koord[8].Y:=191;
   Koord[9].X:=(BufLaunch.Width div 2)-84;
   Koord[9].Y:=257;
   BufLaunch.Canvas.Draw(Koord[8].X,Koord[8].Y,Buttons[Activation[8],8]);
   BufLaunch.Canvas.Draw(Koord[9].X,Koord[9].Y,Buttons[Activation[9],9]);
   Koord[5].X:=(BufLaunch.Width div 2)-84;
   Koord[5].Y:=425;
   BufLaunch.Canvas.Draw(Koord[5].X,Koord[5].Y,Buttons[Activation[5],5]);
 end;

 if regim='vboi1' then
 begin
   BufLaunch.Canvas.Draw(25,22,PanelVboi);
   BufLaunch.Canvas.Draw(164-50,159-50,PhPl1);
   BufLaunch.Canvas.Draw(836-50,159-50,PhPl2);

   if VuborVboi<>1 then
    BufLaunch.Canvas.Draw(402,148,VboiBtn[ActivVboi[1],1])
   else BufLaunch.Canvas.Draw(402,148,VboiBtn[3,1]);
   if VuborVboi<>2 then
    BufLaunch.Canvas.Draw(402,148+57,VboiBtn[ActivVboi[2],2])
   else BufLaunch.Canvas.Draw(402,148+57,VboiBtn[3,2]);
   if VuborVboi<>3 then
    BufLaunch.Canvas.Draw(402,148+57+57,VboiBtn[ActivVboi[3],3])
   else BufLaunch.Canvas.Draw(402,148+57+57,VboiBtn[3,3]);

   Koord[5].X:=(BufLaunch.Width div 2)-178;
   Koord[5].Y:=425;
   Koord[7].X:=(BufLaunch.Width div 2)+10;
   Koord[7].Y:=425;

  BufLaunch.Canvas.Draw(Koord[5].X,Koord[5].Y,Buttons[Activation[5],5]);
  BufLaunch.Canvas.Draw(Koord[7].X,Koord[7].Y,Buttons[Activation[7],7]);

 end;

  if regim='vboi2' then
 begin
   BufLaunch.Canvas.Draw(25,22,PanelVboi);
   BufLaunch.Canvas.Draw(164-50,159-50,PhPl1);
   BufLaunch.Canvas.Draw(836-60,159-88,PhTank);

   if VuborVboi<>1 then
    BufLaunch.Canvas.Draw(402,148,VboiBtn[ActivVboi[1],1])
   else BufLaunch.Canvas.Draw(402,148,VboiBtn[3,1]);
   if VuborVboi<>2 then
    BufLaunch.Canvas.Draw(402,148+57,VboiBtn[ActivVboi[2],2])
   else BufLaunch.Canvas.Draw(402,148+57,VboiBtn[3,2]);
   if VuborVboi<>3 then
    BufLaunch.Canvas.Draw(402,148+57+57,VboiBtn[ActivVboi[3],3])
   else BufLaunch.Canvas.Draw(402,148+57+57,VboiBtn[3,3]);

   Koord[5].X:=(BufLaunch.Width div 2)-178;
   Koord[5].Y:=425;
   Koord[7].X:=(BufLaunch.Width div 2)+10;
   Koord[7].Y:=425;

  BufLaunch.Canvas.Draw(Koord[5].X,Koord[5].Y,Buttons[Activation[5],5]);
  BufLaunch.Canvas.Draw(Koord[7].X,Koord[7].Y,Buttons[Activation[7],7]);

 end;

 Form2.Canvas.Draw(0,0,BufLaunch);
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i:Integer;
begin
 ZX:=X;
 ZY:=Y;
 if regim='menu' then
 for i:=1 to 4 do
 if (X>Koord[i].X) and (X<Koord[i].X+168)
 and (Y>Koord[i].Y) and (Y<Koord[i].Y+56) then
 begin
  Activation[i]:=2;
  Beep.Play(True);
 end
 else Activation[i]:=1;

 if regim='vubor' then
 begin
  for i:=8 to 9 do
  if (X>Koord[i].X) and (X<Koord[i].X+168)
  and (Y>Koord[i].Y) and (Y<Koord[i].Y+56) then
  begin
   Activation[i]:=2;
   Beep.Play(True);
  end
  else Activation[i]:=1;

  if (X>Koord[5].X) and (X<Koord[5].X+168)
  and (Y>Koord[5].Y) and (Y<Koord[5].Y+56) then
  begin
   Activation[5]:=2;
   Beep.Play(True);
  end
  else Activation[5]:=1;
 end;
 
 if regim='options' then
 for i:=5 to 6 do
 if (X>Koord[i].X) and (X<Koord[i].X+168)
 and (Y>Koord[i].Y) and (Y<Koord[i].Y+56) then
  begin
   Activation[i]:=2;
   Beep.Play(True);
  end
 else Activation[i]:=1;

 if regim='exit' then
 begin

  if (X>(BufLaunch.Width div 2)-145) and (X<(BufLaunch.Width div 2)-20)
  and (Y>(BufLaunch.Height div 2)) and (Y<(BufLaunch.Height div 2)+56) then
  begin
   ActivExit[1]:=2;
   Beep.Play(True);
  end
  else ActivExit[1]:=1;

  if (X>(BufLaunch.Width div 2)+20) and (X<(BufLaunch.Width div 2)+145)
  and (Y>(BufLaunch.Height div 2)) and (Y<(BufLaunch.Height div 2)+56) then
  begin
   ActivExit[2]:=2;
   Beep.Play(True);
  end
  else ActivExit[2]:=1;
 end;

 if regim='razr' then
 if (X>Koord[5].X) and (X<Koord[5].X+168)
 and (Y>Koord[5].Y) and (Y<Koord[5].Y+56) then
  begin
   Activation[5]:=2;
   Beep.Play(True);
  end
 else Activation[5]:=1;


 if (regim='vboi1') or (regim='vboi2') then
 begin

  if (X>Koord[5].X) and (X<Koord[5].X+168)
  and (Y>Koord[5].Y) and (Y<Koord[5].Y+56) then
   begin
    Activation[5]:=2;
    Beep.Play(True);
   end
  else Activation[5]:=1;

  if (X>Koord[7].X) and (X<Koord[7].X+168)
  and (Y>Koord[7].Y) and (Y<Koord[7].Y+56) then
   begin
    Activation[7]:=2;
    Beep.Play(True);
   end
  else Activation[7]:=1;

  if (X>402) and (X<402+234)
  and (Y>148) and (Y<148+47) then
   begin
    ActivVboi[1]:=2;
    Beep.Play(True);
   end
  else ActivVboi[1]:=1;

  if (X>402) and (X<402+234)
  and (Y>148+57) and (Y<148+57+47) then
   begin
    ActivVboi[2]:=2;
    Beep.Play(True);
   end
  else ActivVboi[2]:=1;

  if (X>402) and (X<402+234)
  and (Y>148+57+57) and (Y<148+57+57+47) then
   begin
    ActivVboi[3]:=2;
    Beep.Play(True);
   end
  else ActivVboi[3]:=1;

 end;

end;

procedure TForm2.FormClick(Sender: TObject);
var i:Integer;
begin
 if regim='menu' then
 begin
  if (ZX>Koord[1].X) and (ZX<Koord[1].X+168)
  and (ZY>Koord[1].Y) and (ZY<Koord[1].Y+56) then regim:='vubor';


  if (ZX>Koord[2].X) and (ZX<Koord[2].X+168)
  and (ZY>Koord[2].Y) and (ZY<Koord[2].Y+56) then regim:='options';

  if (ZX>Koord[3].X) and (ZX<Koord[3].X+168)
  and (ZY>Koord[3].Y) and (ZY<Koord[3].Y+56) then regim:='razr';

  if (ZX>Koord[4].X) and (ZX<Koord[4].X+168)
  and (ZY>Koord[4].Y) and (ZY<Koord[4].Y+56) then regim:='exit';
 end;

  if regim='vubor' then
 begin
  if (ZX>Koord[8].X) and (ZX<Koord[8].X+168)
  and (ZY>Koord[8].Y) and (ZY<Koord[8].Y+56) then regim:='vboi1';


  if (ZX>Koord[9].X) and (ZX<Koord[9].X+168)
  and (ZY>Koord[9].Y) and (ZY<Koord[9].Y+56) then regim:='vboi2';

  if (ZX>Koord[5].X) and (ZX<Koord[5].X+168)
  and (ZY>Koord[5].Y) and (ZY<Koord[5].Y+56) then regim:='menu';
 end;

 if regim='options' then
 begin

  if (ZX>Koord[5].X) and (ZX<Koord[5].X+168)
  and (ZY>Koord[5].Y) and (ZY<Koord[5].Y+56) then
  begin
    TrackBar1.Visible:=False;
    TrackBar2.Visible:=False;
    Label1.Visible:=False;
    Label2.Visible:=False;
    regim:='menu';
  end;

  if (ZX>Koord[6].X) and (ZX<Koord[6].X+168)
  and (ZY>Koord[6].Y) and (ZY<Koord[6].Y+56) then
  begin
   RzMemo1.Clear;
   RzMemo1.Lines.Add(IntToStr(TrackBar1.Position));
   RzMemo1.Lines.Add(IntToStr(TrackBar2.Position));
   RzMemo1.Lines.SaveToFile(path+'/data/settings.dk');
   TrackBar1.Visible:=False;
   TrackBar2.Visible:=False;
   Label1.Visible:=False;
   Label2.Visible:=False;
   regim:='menu';
  end;
 end;

  if regim='exit' then
 begin

  if (ZX>(BufLaunch.Width div 2)-145) and (ZX<(BufLaunch.Width div 2)-20)
  and (ZY>(BufLaunch.Height div 2)) and (ZY<(BufLaunch.Height div 2)+56) then
   Form2.Close;


  if (ZX>(BufLaunch.Width div 2)+20) and (ZX<(BufLaunch.Width div 2)+145)
  and (ZY>(BufLaunch.Height div 2)) and (ZY<(BufLaunch.Height div 2)+56) then
  regim:='menu';
 end;

  if regim='vboi1' then
 begin

  if (ZX>Koord[5].X) and (ZX<Koord[5].X+168)
  and (ZY>Koord[5].Y) and (ZY<Koord[5].Y+56) then
  regim:='vubor';

  if (ZX>Koord[7].X) and (ZX<Koord[7].X+168)
  and (ZY>Koord[7].Y) and (ZY<Koord[7].Y+56) then
  begin
   Form2.Visible:=False;
   for i:=1 to 4 do Musics[i].Pause;
   Application.CreateForm(TForm1,Form1);
   Form1.Show;
  end;

  if (ZX>402) and (ZX<402+234)
  and (ZY>148) and (ZY<148+47) then
   begin
    VuborVboi:=1;
    maxschet:=3;
    Label3.Caption:=IntToStr(maxschet);
   end;


  if (ZX>402) and (ZX<402+234)
  and (ZY>148+57) and (ZY<148+57+47) then
   begin
    VuborVboi:=2;
    maxschet:=7;
    Label3.Caption:=IntToStr(maxschet);
   end;

  if (ZX>402) and (ZX<402+234)
  and (ZY>148+57+57) and (ZY<148+57+57+47) then
  begin
    VuborVboi:=3;
    maxschet:=10;
    Label3.Caption:=IntToStr(maxschet);
   end;

 end;

 if regim='vboi2' then
 begin

  if (ZX>Koord[5].X) and (ZX<Koord[5].X+168)
  and (ZY>Koord[5].Y) and (ZY<Koord[5].Y+56) then
  regim:='vubor';

  if (ZX>Koord[7].X) and (ZX<Koord[7].X+168)
  and (ZY>Koord[7].Y) and (ZY<Koord[7].Y+56) then
  begin
   Form2.Visible:=False;
   for i:=1 to 4 do Musics[i].Pause;
   Application.CreateForm(TForm4,Form4);
   Form4.Show;
  end;

  if (ZX>402) and (ZX<402+234)
  and (ZY>148) and (ZY<148+47) then
   begin
    VuborVboi:=1;
    maxschet:=3;
    Label3.Caption:=IntToStr(maxschet);
   end;


  if (ZX>402) and (ZX<402+234)
  and (ZY>148+57) and (ZY<148+57+47) then
   begin
    VuborVboi:=2;
    maxschet:=7;
    Label3.Caption:=IntToStr(maxschet);
   end;

  if (ZX>402) and (ZX<402+234)
  and (ZY>148+57+57) and (ZY<148+57+57+47) then
  begin
    VuborVboi:=3;
    maxschet:=10;
    Label3.Caption:=IntToStr(maxschet);
   end;

 end;

 if regim='razr' then
 begin

  if (ZX>Koord[5].X) and (ZX<Koord[5].X+168)
  and (ZY>Koord[5].Y) and (ZY<Koord[5].Y+56) then
  begin
    regim:='menu';
  end;
 end;

end;

procedure TForm2.TrackBar2Change(Sender: TObject);
var i:Integer;
begin
  for i:=1 to 4 do Musics[i].SetVolume(TrackBar2.Position);
  TrackBar2.SelEnd:=TrackBar2.Position;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  Beep.SetVolume(TrackBar1.Position);
  TrackBar1.SelEnd:=TrackBar1.Position;
end;

end.
