unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, bass, SongStream, pngimage;

const
  PixelMax=32768;

type
  pPixelArray = ^TPixelArray;
  TPixelArray = array [0..PixelMax-1] of TRGBTriple;

  Planes=record
  X,Y,zadPad,speed,zadtorm,xc,yc,height,animVzruva,xvzr,yvzr,zadVzruva:Integer;
  prorisovka,PR,PL,padU,PD,kordon,padinya,prorisovkaVzruva:Boolean;
  logkV:Boolean;
  Kut:Single;
  Sam,FIMG,OriginalIMG:TBitmap;
  Vzruv,Fvzruv:array [1..11] of TBitmap;
  popadanie,animdum,animfire,zadFire,zadDum:Integer;
  dum,fire:array [1..3] of TBitmap;
  end;

  Tanks=record
  X,Y,speed,zadtorm,xc,yc,height,animVzruva,xvzr,yvzr,zadVzruva:Integer;
  prorisovka,PR,PL,padU,PD,kordon,prorisovkaVzruva,prorisovkaFire,prorisovkaDum:Boolean;
  logkV:Boolean;
  Kut:Single;
  Tnk,Push,FIMG,OriginalIMG:TBitmap;
  Vzruv:array [1..11] of TBitmap;
  popadanie,animdum,animfire,zadFire,zadDum:Integer;
  dum,fire:array [1..3] of TBitmap;
  end;

  Bullets=record
  X,Y,interval:integer;
  Bullet,FBullet:TBitmap;
  KorPoch:TPoint;
  prorisovka,dozvil:Boolean;
  Kut:Single;

  end;

  Players=record
  Score,zadReborn:Integer;
  Dead,logScore:Boolean;
  end;

  Song=record
  Bullet,Vzruv:array [1..2] of TSongStream;
  Music:array [1..6] of TSongStream;
  mIndex,backIndex:integer;
  end;

  TForm4 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure win;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  Player1,Player2:Players;
  Pl1:Planes;
  Tank1:Tanks;
  Bullet1,Bullet2:Bullets;
  logBullkord1,logBullkord2:Boolean;
  BufM,Fon,Ground,Panel,plus,parplus:TBitmap;
  HUDSEC:array[0..3] of TBitmap;
  Cufru:array[0..10] of TBitmap;
  Loading:array[1..3] of TBitmap; kL,final,secFinal,plusTiming:Integer;
  wins:array[1..2] of TPNGObject;
  cd:array[1..2] of TBitmap;
  logLoading,logFinal,prorisovkaPlus,logPlus,parashPlus,logPlusTiming:Boolean;
  path:string;
  CenterSam,CenterBullet,TochPushku,PlusKor:TPoint;
  Songs:Song;
  pausefon:TPNGObject;
//Klavishi
  dLeft,uLeft,dRight,uRight,dUP,dDOWN,dCTRL:Boolean; //Player1
  dA,uA,dD,uD,uS,uW,dW,dS,dSpace:Boolean; //Player2
//Klavishi

//procedure IMGRotate(IMG:TBitmap; Angle:Single);

/////////////Player1///////////////////
procedure LeftRuhPl1(Speed:Integer);
procedure RightRuhPl1(Speed:Integer);
procedure Vustril1;
procedure LeftRuhBullet1(Speed:Integer);
procedure RightRuhBullet1(Speed:Integer);
procedure RefreshPL1Hero;
/////////////Player1///////////////////

/////////////Player2///////////////////
procedure Vustril2;
procedure RuhBullet2(Speed:Integer);
//procedure LeftRuhBullet2(Speed:Integer);
//procedure RightRuhBullet2(Speed:Integer);
procedure RefreshPL2Hero;
/////////////Player2///////////////////

procedure RebornPlayers;

procedure RotateBitmap_ads(SourceBitmap: TBitmap;
out DestBitmap: TBitmap; Center: TPoint; Angle: Double);

procedure SetPlus;

procedure RotateVustril(pochtoch:TPoint;rotatetoch:TPoint;KutPov:double;var vusX:Integer; var vusY:Integer);

implementation
uses Unit2,Unit5;
{$R *.dfm}

//процедура руху літака 1 при натиснутій клавіші Вліво
procedure LeftRuhPl1(Speed:Integer);
begin

  IF Pl1.Kut=0 then Pl1.X:=Pl1.X+speed;

  IF (Pl1.Kut>0) and (Pl1.Kut<=15) then
  begin
   if Pl1.Kut<>5 then
   begin
    Pl1.X:=Pl1.X+speed;
    Pl1.Y:=Pl1.Y-(speed div 3);
   end
   else
   begin
    Pl1.X:=Pl1.X+speed;
    Pl1.Y:=Pl1.Y;
   end
  end;

  IF (Pl1.Kut>15) and (Pl1.Kut<=30) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y-(speed div 2);
  end;

  IF (Pl1.Kut>30) and (Pl1.Kut<=60) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y-speed;
  end;

  IF (Pl1.Kut>60) and (Pl1.Kut<=75) then
  begin
   Pl1.Y:=Pl1.Y-speed;
   Pl1.X:=Pl1.X+(speed div 2);
  end;

  IF (Pl1.Kut>75) and (Pl1.Kut<90) then
  begin
   Pl1.Y:=Pl1.Y-speed;
   Pl1.X:=Pl1.X+(speed div 3);
  end;

  IF Pl1.Kut=90 then Pl1.Y:=Pl1.Y-speed;

   IF (Pl1.Kut>90) and (Pl1.Kut<=105) then
  begin
   Pl1.X:=Pl1.X-(speed div 3);
   Pl1.Y:=Pl1.Y-speed;
  end;

    IF (Pl1.Kut>105) and (Pl1.Kut<=120) then
  begin
   Pl1.X:=Pl1.X-(speed div 2);
   Pl1.Y:=Pl1.Y-speed;
  end;

   IF (Pl1.Kut>120) and (Pl1.Kut<=150) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-speed;
  end;

   IF (Pl1.Kut>150) and (Pl1.Kut<=165) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-(speed div 2);
  end;

  IF (Pl1.Kut>165) and (Pl1.Kut<180) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-(speed div 3);
  end;

  IF Pl1.Kut=180 then Pl1.X:=Pl1.X-speed;

  IF (Pl1.Kut>180) and (Pl1.Kut<=195) then
  begin
   if Pl1.Kut<>185 then
   begin
    Pl1.X:=Pl1.X-speed;
    Pl1.Y:=Pl1.Y+(speed div 3);
   end
   else
   begin
    Pl1.X:=Pl1.X-speed;
    Pl1.Y:=Pl1.Y;
   end
  end;

   IF (Pl1.Kut>195) and (Pl1.Kut<=210) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y+(speed div 2);
  end;

   IF (Pl1.Kut>210) and (Pl1.Kut<=240) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y+speed;
  end;

   IF (Pl1.Kut>240) and (Pl1.Kut<=255) then
  begin
   Pl1.X:=Pl1.X-(speed div 2);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>255) and (Pl1.Kut<270) then
  begin
   Pl1.X:=Pl1.X-(speed div 3);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF Pl1.Kut=270 then Pl1.Y:=Pl1.Y+speed;

  IF (Pl1.Kut>270) and (Pl1.Kut<=285) then
  begin
   Pl1.X:=Pl1.X+(speed div 3);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>285) and (Pl1.Kut<=300) then
  begin
   Pl1.X:=Pl1.X+(speed div 2);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>300) and (Pl1.Kut<=330) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>330) and (Pl1.Kut<=345) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+(speed div 2);
  end;

  IF (Pl1.Kut>345) and (Pl1.Kut<360) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+(speed div 3);
  end;

  IF Pl1.Kut=360 then Pl1.Kut:=0;

 end;


 //процедура руху літака 1 при натиснутій клавіші Вправо
procedure RightRuhPl1(Speed:Integer);
begin
  IF (Pl1.Kut>=-359) and (Pl1.Kut<=-345) then
  begin
   if Pl1.Kut<>-355 then
   begin
    Pl1.X:=Pl1.X+speed;
    Pl1.Y:=Pl1.Y-(speed div 3);
   end
   else
   begin
    Pl1.X:=Pl1.X+speed;
    Pl1.Y:=Pl1.Y;
   end
  end;

  IF (Pl1.Kut>-345) and (Pl1.Kut<=-330) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y-(speed div 2);
  end;

  IF (Pl1.Kut>-330) and (Pl1.Kut<=-300) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y-speed;
  end;

  IF (Pl1.Kut>-300) and (Pl1.Kut<=-285) then
  begin
   Pl1.Y:=Pl1.Y-speed;
   Pl1.X:=Pl1.X+(speed div 2);
  end;

  IF (Pl1.Kut>-285) and (Pl1.Kut<-270) then
  begin
   Pl1.Y:=Pl1.Y-speed;
   Pl1.X:=Pl1.X+(speed div 3);
  end;

  IF Pl1.Kut=-270 then Pl1.Y:=Pl1.Y-speed;

   IF (Pl1.Kut>-270) and (Pl1.Kut<=-255) then
  begin
   Pl1.X:=Pl1.X-(speed div 3);
   Pl1.Y:=Pl1.Y-speed;
  end;

    IF (Pl1.Kut>-255) and (Pl1.Kut<=-240) then
  begin
   Pl1.X:=Pl1.X-(speed div 2);
   Pl1.Y:=Pl1.Y-speed;
  end;

   IF (Pl1.Kut>-240) and (Pl1.Kut<=-210) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-speed;
  end;

   IF (Pl1.Kut>-210) and (Pl1.Kut<=-195) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-(speed div 2);
  end;

  IF (Pl1.Kut>-195) and (Pl1.Kut<-180) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y-(speed div 3);
  end;

  IF Pl1.Kut=-180 then Pl1.X:=Pl1.X-speed;

  IF (Pl1.Kut>-180) and (Pl1.Kut<=-165) then
  begin
   if Pl1.Kut<>-175 then
   begin
    Pl1.X:=Pl1.X-speed;
    Pl1.Y:=Pl1.Y+(speed div 3);
   end
   else
   begin
    Pl1.X:=Pl1.X-speed;
    Pl1.Y:=Pl1.Y;
   end
  end;

   IF (Pl1.Kut>-165) and (Pl1.Kut<=-150) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y+(speed div 2);
  end;

   IF (Pl1.Kut>-150) and (Pl1.Kut<=-120) then
  begin
   Pl1.X:=Pl1.X-speed;
   Pl1.Y:=Pl1.Y+speed;
  end;

   IF (Pl1.Kut>-120) and (Pl1.Kut<=-105) then
  begin
   Pl1.X:=Pl1.X-(speed div 2);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>-105) and (Pl1.Kut<-90) then
  begin
   Pl1.X:=Pl1.X-(speed div 3);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF Pl1.Kut=-90 then Pl1.Y:=Pl1.Y+speed;

  IF (Pl1.Kut>-90) and (Pl1.Kut<=-75) then
  begin
   Pl1.X:=Pl1.X+(speed div 3);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>-75) and (Pl1.Kut<=-60) then
  begin
   Pl1.X:=Pl1.X+(speed div 2);
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>-60) and (Pl1.Kut<=-30) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+speed;
  end;

  IF (Pl1.Kut>-30) and (Pl1.Kut<=-15) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+(speed div 2);
  end;

  IF (Pl1.Kut>-15) and (Pl1.Kut<0) then
  begin
   Pl1.X:=Pl1.X+speed;
   Pl1.Y:=Pl1.Y+(speed div 3);
  end;

  IF Pl1.Kut=-360 then Pl1.Kut:=0;

 end;


 procedure TForm4.FormCreate(Sender: TObject);
var i,j:Integer;
begin
 Randomize;
 Form4.Width:=Screen.Width;
 Form4.Height:=Screen.Width;
 logLoading:=True;
 kL:=3;
 logFinal:=False;
 secFinal:=0;
 final:=maxschet;
 path:=ExtractFileDir(Application.ExeName);

 ///////ekran zagruzki//////
 for i:=1 to 3 do
 begin
  Loading[i]:=TBitmap.Create;
  Loading[i].LoadFromFile(path+'/data/interface/loading/zagruzka'+inttostr(i)+'.bmp');
 end;


 ///////ekran zagruzki//////

 pausefon:=TPNGObject.Create;
 pausefon.LoadFromFile(path+'/data/interface/pause/pause.png');

 with Songs do
 begin
   for i:=1 to 2 do
   begin
    Bullet[i]:=TSongStream.Create;
    Bullet[i].Init(path+'/data/sounds/Bullet.mp3');
    Bullet[i].SetVolume(Form2.TrackBar1.Position);

    Vzruv[i]:=TSongStream.Create;
    Vzruv[i].Init(path+'/data/sounds/vzruv.mp3');
    Vzruv[i].SetVolume(Form2.TrackBar1.Position);
   end;

   mIndex:=Random(6)+1;

   for i:=1 to 6 do
   begin

    Music[i]:=TSongStream.Create;
    Music[i].Init(path+'/data/sounds/music/'+inttostr(i)+'.mp3');
    Music[i].SetVolume(Form2.TrackBar2.Position);

   end;

   Music[mIndex].Play(True);
 end;

 Panel:=TBitmap.Create;
 Panel.Transparent:=True;
 Panel.LoadFromFile(path+'/data/interface/hud/default/panel.bmp');

 plus:=TBitmap.Create;
 plus.Transparent:=True;
 plus.LoadFromFile(path+'/data/tank/plus.bmp');

 parplus:=TBitmap.Create;
 parplus.Transparent:=True;
 parplus.LoadFromFile(path+'/data/tank/parplus.bmp');

 plusTiming:=30;
 parashPlus:=True;
 logPlus:=False;
 prorisovkaPlus:=False;
 logPlusTiming:=False;

 for i:=1 to 2 do
 begin
   cd[i]:=TBitmap.Create;
   cd[i].LoadFromFile(path+'/data/interface/hud/default/cd'+inttostr(i)+'.bmp');
 end;

 for i:=0 to 10 do
 begin
  Cufru[i]:=TBitmap.Create;
  Cufru[i].Transparent:=True;
  Cufru[i].LoadFromFile(path+'/data/interface/hud/default/c'+inttostr(i)+'.bmp');
 end;

 for i:=0 to 3 do
 begin
   HUDSEC[i]:=TBitmap.Create;
   HUDSEC[i].Transparent:=True;
   HUDSEC[i].LoadFromFile(path+'/data/interface/hud/default/'+inttostr(i)+'.bmp');
 end;

 BufM:=TBitmap.Create;
 BufM.Width:=2000;
 BufM.Height:=1000;

 Fon:=TBitmap.Create;
 Fon.LoadFromFile(path+'/data/fon1.bmp');

 Ground:=TBitmap.Create;
 Ground.LoadFromFile(path+'/data/ground.bmp');

 for i:=1 to 2 do
 begin

  wins[i]:=TPNGObject.Create;
  wins[i].LoadFromFile(path+'/data/interface/win/win'+inttostr(i)+'.png');

 end;


 /////////////////////////////////////////////////
 ////////////////////////////////////// Player1///
 /////////////////////////////////////////////////
 Player1.zadReborn:=0;
 Player1.Dead:=False;
 Player1.Score:=0;
 Player1.logScore:=False;

 //Bullet1
 Bullet1.Bullet:=TBitmap.Create;
 Bullet1.Bullet.Transparent:=True;
 Bullet1.Bullet.LoadFromFile(path+'/data/bullet/1/bullet.bmp');

 Bullet1.FBullet:=TBitmap.Create;
 Bullet1.FBullet.Transparent:=True;
 Bullet1.FBullet.LoadFromFile(path+'/data/bullet/1/bullet.bmp');

 Bullet1.prorisovka:=False;
 //Bullet1.xp:=Pl1.X+126;
 //Bullet1.yp:=Pl1.Y+95;

 Bullet1.KorPoch.X:=128;
 Bullet1.KorPoch.Y:=93;

 Bullet1.X:=Bullet1.KorPoch.X+Pl1.X;
 Bullet1.Y:=Bullet1.KorPoch.Y+Pl1.Y;
 Bullet1.interval:=2;
 Bullet1.dozvil:=True;

 CenterBullet.X:=Bullet1.Bullet.Width div 2;
 CenterBullet.Y:=Bullet1.Bullet.Height div 2;

 //Bullet1

//Pl1

 Pl1.X:=20;
 Pl1.Y:=100;
 Pl1.Kut:=0;
 
 Pl1.prorisovka:=True;
 Pl1.kordon:=True;

 Pl1.Sam:=TBitmap.Create;
 Pl1.Sam.Transparent:=True;
 Pl1.Sam.LoadFromFile(path+'/data/plane/1/Pl1.bmp');
 Pl1.OriginalIMG:=TBitmap.Create;
 Pl1.OriginalIMG.Assign(Pl1.Sam);
 Pl1.FIMG:=TBitmap.Create;
 Pl1.FIMG.Assign(Pl1.Sam);

 Pl1.logkV:=True;

 CenterSam.X:=Pl1.Sam.Width div 2;
 CenterSam.Y:=Pl1.Sam.Height div 2;

 Pl1.zadPad:=0;
 Pl1.speed:=4;
 Pl1.padinya:=False;
 Pl1.zadtorm:=0;
 Pl1.zadVzruva:=0;
 Pl1.animVzruva:=1;

 for i:=1 to 11 do
 begin
  Pl1.Vzruv[i]:=TBitmap.Create;
  Pl1.Vzruv[i].Transparent:=True;
  Pl1.Vzruv[i].LoadFromFile(path+'/data/plane/1/Vzruv/'+inttostr(i)+'.bmp');
 end;

 for i:=1 to 11 do Pl1.Fvzruv[i]:=TBitmap.Create;

 Pl1.prorisovkaVzruva:=False;
 Pl1.padU:=False;

 Pl1.popadanie:=0;

 for i:=1 to 3 do
 begin
  Pl1.dum[i]:=TBitmap.Create;
  Pl1.dum[i].Transparent:=True;
  Pl1.dum[i].LoadFromFile(path+'/data/plane/1/dum/'+inttostr(i)+'.bmp');
 end;


 for i:=1 to 3 do
 begin
  Pl1.fire[i]:=TBitmap.Create;
  Pl1.fire[i].Transparent:=True;
  Pl1.fire[i].LoadFromFile(path+'/data/plane/1/fire/'+inttostr(i)+'.bmp');
 end;


 Pl1.animdum:=1;
 Pl1.animfire:=1;

 Pl1.height:=Pl1.Y+110;

//Pl1

 /////////////////////////////////////////////////
 ////////////////////////////////////// Player1///
 /////////////////////////////////////////////////



 /////////////////////////////////////////////////
 ////////////////////////////////////// Player2///
 /////////////////////////////////////////////////
 Player2.zadReborn:=0;
 Player2.Dead:=False;
 Player2.Score:=0;
 Player2.logScore:=False;

 //Bullet2
 Bullet2.Bullet:=TBitmap.Create;
 Bullet2.Bullet.Transparent:=True;
 Bullet2.Bullet.LoadFromFile(path+'/data/bullet/2/bullet.bmp');

 Bullet2.FBullet:=TBitmap.Create;
 Bullet2.FBullet.Transparent:=True;
 Bullet2.FBullet.LoadFromFile(path+'/data/bullet/2/bullet.bmp');

 Bullet2.KorPoch.X:=5;
 Bullet2.KorPoch.Y:=87;

 Bullet2.prorisovka:=False;
 //Bullet2.xp:=Tank1.X+5;
 //Bullet2.yp:=Tank1.Y+87;
 Bullet2.X:=Bullet2.KorPoch.X+Tank1.X;
 Bullet2.Y:=Bullet2.KorPoch.Y+Tank1.Y;
 Bullet2.interval:=3;
 Bullet2.dozvil:=True;

 CenterBullet.X:=Bullet2.Bullet.Width div 2;
 CenterBullet.Y:=Bullet2.Bullet.Height div 2;

 //Bullet2

//Tank1

 Tank1.X:=BufM.Width-148;
 Tank1.Y:=BufM.Height-82-127;;
 Tank1.Kut:=0;
 
 Tank1.prorisovka:=True;
 Tank1.kordon:=True;

 Tank1.Tnk:=TBitmap.Create;
 Tank1.Tnk.Transparent:=True;
 Tank1.Tnk.LoadFromFile(path+'/data/tank/tank1.bmp');

 Tank1.Push:=TBitmap.Create;
 Tank1.Push.Transparent:=True;
 Tank1.Push.LoadFromFile(path+'/data/tank/pushka1.bmp');
 Tank1.OriginalIMG:=TBitmap.Create;
 Tank1.OriginalIMG.Assign(Tank1.Push);
 Tank1.FIMG:=TBitmap.Create;
 Tank1.FIMG.Assign(Tank1.Push);

 Tank1.logkV:=True;

 TochPushku.X:=61;
 TochPushku.Y:=88;

 Tank1.speed:=3;
 Tank1.zadtorm:=0;
 Tank1.zadVzruva:=0;
 Tank1.animVzruva:=1;

 for i:=1 to 11 do
 begin
  Tank1.Vzruv[i]:=TBitmap.Create;
  Tank1.Vzruv[i].Transparent:=True;
  Tank1.Vzruv[i].LoadFromFile(path+'/data/tank/Vzruv/'+inttostr(i)+'.bmp');
 end;


 Tank1.prorisovkaVzruva:=False;
 Tank1.padU:=False;

 Tank1.prorisovkaFire:=False;
 Tank1.prorisovkaDum:=False;

 Tank1.popadanie:=0;

 for i:=1 to 3 do
 begin
  Tank1.dum[i]:=TBitmap.Create;
  Tank1.dum[i].Transparent:=True;
  Tank1.dum[i].LoadFromFile(path+'/data/tank/dum/'+inttostr(i)+'.bmp');
 end;


 for i:=1 to 3 do
 begin
  Tank1.fire[i]:=TBitmap.Create;
  Tank1.fire[i].Transparent:=True;
  Tank1.fire[i].LoadFromFile(path+'/data/tank/fire/'+inttostr(i)+'.bmp');
 end;


 Tank1.animdum:=1;
 Tank1.animfire:=1;

//Tank1

 //////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////// Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////

end;

procedure TForm4.Timer1Timer(Sender: TObject);
var Bitmap:TBitmap;

begin
 Randomize;

 //////////////MUSIC//////////////////
  with Songs do
  begin

   if Music[mIndex].PositionCurrent=Music[mIndex].LongueurTotal then
   begin
     backIndex:=mIndex;
     while  mIndex=backIndex do mIndex:=Random(6)+1;
     Music[mIndex].Play(True)
   end;
  end;
 //////////////MUSIC//////////////////

 //Obrabotka Klavish

 //Nazhatie

 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////
  if dLeft=True then
  begin
   Pl1.PL:=True;
   Pl1.Speed:=4;
   Pl1.padinya:=False;
   Pl1.zadPad:=0;
  end;
  if dRight=True then
  begin
   Pl1.PR:=True;
   Pl1.Speed:=4;
   Pl1.padinya:=False;
   Pl1.zadPad:=0;
  end;

 if Bullet1.dozvil=True then
 if dCTRL=True then
 begin
   Songs.Bullet[1].Play(True);
   Bullet1.Kut:=Pl1.Kut;
   //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Bullet1.Bullet,Bitmap,CenterBullet,Bullet1.Kut);
    Bullet1.FBullet.Assign(Bitmap);
    Bullet1.FBullet.TransparentColor:=clWhite;
    Bullet1.FBullet.Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish
   Vustril1;
   Bullet1.dozvil:=False;

   Bullet1.prorisovka:=True;
   logBullkord1:=True;
   dCTRL:=False;
 end;

 if (dDOWN=True) and (Pl1.prorisovka=True) then // [ х х
 begin
 //sasdsadas
 end;

 if (dUP=True) then // p з з
 begin
 //asdsadas
 end;


 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

  if dS=True then
  begin
   Tank1.PL:=True;
  end;
  if dW=True then
  begin
   Tank1.PR:=True;
  end;

 if Bullet2.dozvil=True then
 if dSpace=True then
 begin
   Songs.Bullet[2].Play(True);
   Bullet2.Kut:=Tank1.Kut;
   //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Bullet2.Bullet,Bitmap,CenterBullet,Bullet2.Kut);
    Bullet2.FBullet.Assign(Bitmap);
    Bullet2.FBullet.TransparentColor:=clWhite;
    Bullet2.FBullet.Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish
   Vustril2;
   Bullet2.dozvil:=False;
   logBullkord2:=True;
   Bullet2.prorisovka:=True;
   dSpace:=False;
 end;

 if dA=True then // [ х х
 begin
  Tank1.X:=Tank1.X-Tank1.speed;
 end;

 if dD=True then // p з з
 begin
  Tank1.X:=Tank1.X+Tank1.speed;
 end;

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

 //Nazhatie

 ////////////////////

 //Otzhatie

 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

  if uLeft=True then
  begin
   dLeft:=False;
   dRight:=False;
   Pl1.PL:=False;
   uLeft:=False;
  end;
  if uRight=True then
  begin
   dLeft:=False;
   dRight:=False;
   Pl1.PR:=False;
   uRight:=False;
  end;

 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

  if uA=True then
  begin
   dA:=False;
   dD:=False;
   uA:=False;
  end;
  if uD=True then
  begin
   dA:=False;
   dD:=False;
   uD:=False;
  end;

  if uS=True then
  begin
   dW:=False;
   dS:=False;
   Tank1.PL:=False;
   uS:=False;
  end;
  if uW=True then
  begin
   dW:=False;
   dS:=False;
   Tank1.PR:=False;
   uW:=False;
  end;

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

 //Otzhatie

 //Obrabotka Klavish

/////////////////////Vzaemodiya//////////////////////////
  ///Bullet1
  if (((Bullet1.X+12)>=Tank1.X) and ((Bullet1.X-12)<=Tank1.X+128)) and
  (((Bullet1.Y+12)>=Tank1.Y+74) and ((Bullet1.Y-12)<=Tank1.Y+126)) and
  (Bullet1.prorisovka=True) then
  begin
   Tank1.popadanie:=Tank1.popadanie+1;
   Bullet1.prorisovka:=False;
  end;

//////////////////////////////////////////////////////////////////////
  ///Bulet2
  if (((Bullet2.X+12)>=Pl1.X) and ((Bullet2.X-12)<=Pl1.X+128)) and
  (((Bullet2.Y+12)>=Pl1.Y) and ((Bullet2.Y-12)<=Pl1.Y+128)) and
  (Bullet2.prorisovka=True) {and (Pl1.prorisovka=True)} then
  begin
   Pl1.popadanie:=Pl1.popadanie+1;
   Bullet2.prorisovka:=False;
  end;

/////////////////////Vzaemodiya//////////////////////////


 BufM.Canvas.Draw(0,0,Fon);
 BufM.Canvas.Draw(0,BufM.Height-82,Ground);


 ///////////////////////////////////////////////////////////////////////
 ///////////////////////////Player1/////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////


 //Bullet1

  if Bullet1.prorisovka=True then
  begin
    BufM.Canvas.Draw(Bullet1.X,Bullet1.Y,Bullet1.FBullet);
    LeftRuhBullet1(20);
    RightRuhBullet1(20);
  end;

  if (Bullet1.Y+8>BufM.Height-82) then Bullet1.prorisovka:=False;
  if logBullkord1=False then
  begin
  if Bullet1.X>BufM.Width then Bullet1.prorisovka:=False;
  if Bullet1.X+20<0 then Bullet1.prorisovka:=False;
  end
  else
  begin
   if Bullet1.X>BufM.Width then
   begin
    Bullet1.X:=0-10;
    logBullkord1:=False;
   end;
   if Bullet1.X+20<0 then
   begin
    Bullet1.X:=BufM.Width+10;
    logBullkord1:=False;
   end;
  end;
  if Bullet1.Y+14<0 then Bullet1.prorisovka:=False;

 //Bullet1

 //Pl1



 if (Pl1.padinya=False) then
 begin
  if (Pl1.PL=False) and (Pl1.PR=False) then
  begin
   RightRuhPl1(Pl1.speed+3);
   LeftRuhPl1(Pl1.speed+3);
  end
  else
  begin
   RightRuhPl1(Pl1.speed);
   LeftRuhPl1(Pl1.speed);
  end;
 end;


 if Pl1.padinya=False then
 if ((Pl1.Kut>=60) and (Pl1.Kut<=120)) or
    ((Pl1.Kut>=-300) and (Pl1.Kut<=-240)) then
 begin
   Pl1.zadPad:=Pl1.zadPad+1;

  if Pl1.zadPad=50 then Pl1.speed:=3;
  if Pl1.zadPad=100 then Pl1.speed:=2;
  if Pl1.zadPad=150 then Pl1.speed:=1;
  if Pl1.zadPad=150 then
 begin
  Pl1.speed:=-1;
  Pl1.padinya:=True;
  Pl1.zadPad:=0;

  RightRuhPl1(Pl1.speed-1);
  LeftRuhPl1(Pl1.speed-1);
 end;
 end;

 if (Pl1.padinya=True) then
 begin
   Pl1.zadPad:=Pl1.zadPad+1;

  if Pl1.zadPad=50 then Pl1.speed:=-1;
  if Pl1.zadPad=80 then Pl1.speed:=-2;
  if Pl1.zadPad=110 then Pl1.speed:=-3;


  Pl1.Y:=Pl1.Y-Pl1.speed;

  //RightRuhPl1(Pl1.speed-1);
  //LeftRuhPl1(Pl1.speed-1);

 end;

 //dum
   if Pl1.popadanie=1 then
   begin
    if Pl1.animdum>3 then Pl1.animdum:=1;

    Pl1.Sam.Assign(Pl1.dum[Pl1.animdum]);

    if Pl1.zadDum=7 then Pl1.animdum:=Pl1.animdum+1;

    if Pl1.zadDum>7 then Pl1.zadDum:=0;


    Pl1.zadDum:=Pl1.zadDum+1;


   end;
 //dum

 //fire
  if Pl1.popadanie=2 then
   begin
    if Pl1.animfire>3 then Pl1.animfire:=1;

    Pl1.Sam.Assign(Pl1.fire[Pl1.animfire]);

    if Pl1.zadFire=7 then Pl1.animfire:=Pl1.animfire+1;

    if Pl1.zadFire>7 then Pl1.zadFire:=0;


    Pl1.zadFire:=Pl1.zadFire+1;


   end;
 //fire

 //3 popadanie VZRUV

 if Pl1.popadanie=3 then
 begin
    Pl1.prorisovka:=False;
    Pl1.prorisovkaVzruva:=True;
    if Pl1.logkV=True then
    begin
     Pl1.xvzr:=Pl1.X;
     Pl1.yvzr:=Pl1.Y;
     Pl1.logkV:=False;
    end;
 end;

 //3 popadanie VZRUV



 if (Pl1.prorisovka=True) then
 begin

   BufM.Canvas.Draw(Pl1.X, Pl1.Y, Pl1.FIMG);

  if Pl1.kordon=True then
  begin
   if Pl1.X+10>BufM.Width then Pl1.X:=-114; //za pravy stor
   if Pl1.X+118<0 then Pl1.X:=BufM.Width-30; // za levy stor
   if Pl1.Y<0 then Pl1.Y:=0; //za verh mezhu
   if (Pl1.Y+127>BufM.Height-82) {and (BufM.Width=PX+127)} then
   begin
    Pl1.prorisovka:=False; // znushenya pru padini
     {potribno zviryati koord SAM z koord zobrazh zemli}
    Pl1.prorisovkaVzruva:=True;
    if Pl1.logkV=True then
    begin
     Pl1.xvzr:=Pl1.X;
     Pl1.yvzr:=Pl1.Y;
     Pl1.logkV:=False;
    end;
   end;
  end;

 end;

 if Pl1.animVzruva>11 then
 begin
  Pl1.prorisovkaVzruva:=False;
  Player1.Dead:=True;
 end;

 if (Pl1.prorisovkaVzruva=True) and (Pl1.padU=False) then
 begin
   Pl1.PL:=False;
   Pl1.PR:=False;
  if Pl1.animVzruva=1 then
  Songs.Vzruv[1].Play(True);

  //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Pl1.Vzruv[Pl1.animVzruva],Bitmap,CenterSam,Pl1.Kut);
    Pl1.Fvzruv[Pl1.animVzruva].Assign(Bitmap);
    Pl1.Fvzruv[Pl1.animVzruva].TransparentColor:=clWhite;
    Pl1.Fvzruv[Pl1.animVzruva].Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish


  BufM.Canvas.Draw(Pl1.xvzr,Pl1.yvzr,Pl1.Fvzruv[Pl1.animVzruva]);

  if Pl1.zadVzruva=3 then Pl1.animVzruva:=Pl1.animVzruva+1;

  if Pl1.zadVzruva>3 then Pl1.zadVzruva:=0;


  Pl1.zadVzruva:=Pl1.zadVzruva+1;

 end;

 //Pl1


 ///////////////////////////////////////////////////////////////////////
 ///////////////////////////Player1/////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////


 ///////////////////////////////////////////////////////////////////////
 ///////////////////////////Player2/////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////

 //Bullet2

  if Bullet2.prorisovka=True then
  begin
    BufM.Canvas.Draw(Bullet2.X,Bullet2.Y,Bullet2.FBullet);
    RuhBullet2(20);
  end;

  if (Bullet2.Y+8>BufM.Height-82) then Bullet2.prorisovka:=False;
  if logBullkord2=False then
  begin
   if Bullet2.X>BufM.Width then Bullet2.prorisovka:=False;
   if Bullet2.X+20<0 then Bullet2.prorisovka:=False;
  end
  else
  begin
   if Bullet2.X>BufM.Width then
   begin
    Bullet2.X:=0-10;
    logBullkord2:=False;
   end;
   if Bullet2.X+20<0 then
   begin
    Bullet2.X:=BufM.Width+10;
    logBullkord2:=False;
   end;
  end;
  if Bullet2.Y+14<0 then Bullet2.prorisovka:=False;

 //Bullet2

 //Tank1

 //dum
   if Tank1.popadanie=1 then
   begin
    Tank1.prorisovkaFire:=False;
    Tank1.prorisovkaDum:=True;

    if Tank1.zadDum=7 then Tank1.animdum:=Tank1.animdum+1;
    if Tank1.animdum>3 then Tank1.animdum:=1;
    if Tank1.zadDum>7 then Tank1.zadDum:=0;

    BufM.Canvas.Draw(Tank1.X, Tank1.Y, Tank1.FIMG);
    BufM.Canvas.Draw(Tank1.X,Tank1.Y,Tank1.dum[Tank1.animdum]);

    Tank1.zadDum:=Tank1.zadDum+1;


   end;
 //dum

 //fire
  if Tank1.popadanie=2 then
   begin
    Tank1.prorisovkaDum:=False;
    Tank1.prorisovkaFire:=True;

    if Tank1.zadFire=7 then Tank1.animfire:=Tank1.animfire+1;
    if Tank1.animfire>3 then Tank1.animfire:=1;
    if Tank1.zadFire>7 then Tank1.zadFire:=0;

    BufM.Canvas.Draw(Tank1.X, Tank1.Y, Tank1.FIMG);
    BufM.Canvas.Draw(Tank1.X,Tank1.Y,Tank1.fire[Tank1.animfire]);

    Tank1.zadFire:=Tank1.zadFire+1;


   end;
 //fire

 //3 popadanie VZRUV

 if Tank1.popadanie=3 then
 begin
    Tank1.prorisovka:=False;
    Tank1.prorisovkaVzruva:=True;
    if Tank1.logkV=True then
    begin
     Tank1.xvzr:=Tank1.X;
     Tank1.yvzr:=Tank1.Y;
     Tank1.logkV:=False;
    end;
 end;

 //3 popadanie VZRUV



 if (Tank1.prorisovka=True) then
 begin


   if (Tank1.prorisovkaFire=False) and (Tank1.prorisovkaDum=False) then
   begin
    BufM.Canvas.Draw(Tank1.X, Tank1.Y, Tank1.FIMG);
    BufM.Canvas.Draw(Tank1.X, Tank1.Y, Tank1.Tnk);
   end;
  if Tank1.kordon=True then
  begin
   if Tank1.X+64>BufM.Width then Tank1.X:=-64; //za pravy stor
   if Tank1.X+64<0 then Tank1.X:=BufM.Width-64; // za levy stor
   end;
 end;

 if Tank1.animVzruva>11 then
 begin
  Tank1.prorisovkaVzruva:=False;
  Player2.Dead:=True;
 end;
 if (Tank1.prorisovkaVzruva=True) and (Tank1.padU=False) then
 begin
   Tank1.PL:=False;
   Tank1.PR:=False;
   if Tank1.animVzruva=1 then
  Songs.Vzruv[2].Play(True);

  BufM.Canvas.Draw(Tank1.xvzr,Tank1.yvzr,Tank1.vzruv[Tank1.animVzruva]);

  if Tank1.zadVzruva=3 then Tank1.animVzruva:=Tank1.animVzruva+1;

  if Tank1.zadVzruva>3 then Tank1.zadVzruva:=0;


  Tank1.zadVzruva:=Tank1.zadVzruva+1;

 end;

 //Tank1

 ///////////////////////////////////////////////////////////////////////
 ///////////////////////////Player2/////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////


 /////////////////////////////////////////////////////////Nach Plus

 if prorisovkaPlus=True then
 begin
   if parashPlus=True then
   begin
    BufM.Canvas.Draw(PlusKor.X,PlusKor.Y,parplus);
    PlusKor.Y:=PlusKor.Y+3;
   end;
    if parashPlus=False then
   begin
    BufM.Canvas.Draw(PlusKor.X,PlusKor.Y,plus);
    PlusKor.Y:=PlusKor.Y+6;
   end;

  if PlusKor.Y+276>BufM.Height-82 then
  begin
   prorisovkaPlus:=False;
   parashPlus:=True;
   logPlusTiming:=True;
  end;

  if (((Pl1.X+64)>=PlusKor.X) and ((Pl1.X+64)<=PlusKor.X+181)) and
   (((Pl1.Y+64)>=PlusKor.Y) and ((Pl1.Y+64)<=PlusKor.Y+186))
  then parashPlus:=False;

  if Pl1.popadanie<>0 then
  if (((PlusKor.X+58)>=Pl1.X) and ((PlusKor.X+120)<=Pl1.X+128)) and
   (((PlusKor.Y+203)>=Pl1.Y) and ((PlusKor.Y+273)<=Pl1.Y+128))
  then
  begin
   prorisovkaPlus:=False;
   parashPlus:=True;
   logPlusTiming:=True;
   Pl1.popadanie:=Pl1.popadanie-1;
   if Pl1.popadanie=0 then Pl1.Sam.Assign(Pl1.OriginalIMG);
  end;

  if Tank1.popadanie<>0 then
  if (((PlusKor.X+58)>=Tank1.X) and ((PlusKor.X+120)<=Tank1.X+128)) and
   (((PlusKor.Y+203)>=Tank1.Y) and ((PlusKor.Y+273)<=Tank1.Y+128))
  then
  begin
   prorisovkaPlus:=False;
   parashPlus:=True;
   logPlusTiming:=True;
   Tank1.prorisovkaFire:=False;
   Tank1.prorisovkaDum:=False;
   Tank1.popadanie:=Tank1.popadanie-1;
  end;

 end;

 /////////////////////////////////////////////////////////Kinec Plus

 RebornPlayers;


 BufM.Canvas.Draw((BufM.Width div 2)-285,-5,Panel);
 BufM.Canvas.Draw((BufM.Width div 2)-285+200,2,Cufru[Player1.Score]);// Player1
 BufM.Canvas.Draw((BufM.Width div 2)-285+308,2,Cufru[Player2.Score]);//Player2
 {if Bullet1.dozvil=False then
 begin
  BufM.Canvas.Draw((BufM.Width div 2)-285-33,0,cd[1]);
  BufM.Canvas.StretchDraw(Rect((BufM.Width div 2)-285-33,0,(BufM.Width div 2)-285,33),Cufru[Bullet1.interval+1]);
 end;
 if Bullet2.dozvil=False then
 begin
  BufM.Canvas.Draw((BufM.Width div 2)+285+1,0,cd[2]);
  BufM.Canvas.StretchDraw(Rect((BufM.Width div 2)+285+1,0,(BufM.Width div 2)+285+1+33,33),Cufru[Bullet2.interval+1]);
 end;}
 win;
 Form4.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),BufM);
 end;
//end;

procedure TForm4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////
 if Key=VK_LEFT then dLeft:=True;
 if Key=VK_RIGHT then dRight:=True;

  if Key=VK_Control then dCTRL:=True;


  if Key= VK_DOWN then  dDOWN:=True;


  if Key=VK_UP  then dUP:=True;
 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////
 if Key=65 then dA:=True;  ////A a
 if Key=68 then dD:=True; ////D d

 if Key=VK_SPACE then dSpace:=True;


 if Key=83 then dS:=True; // S s

 if Key=87 then dW:=True; //W w



 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////


 if Key=VK_ESCAPE then
 begin
  Timer1.Enabled:=False;
  Timer2.Enabled:=False;
  Timer3.Enabled:=False;
  Form4.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),pausefon);
  Form5.Show;
 end;
end;


procedure TForm4.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////
  if Key=VK_LEFT then uLeft:=True;

  if Key=VK_RIGHT then uRight:=True;

  if Key=VK_Control then dCTRL:=False;


  if Key= VK_DOWN then  dDOWN:=False;


  if Key=VK_UP  then dUP:=False;


 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////
  if Key=65 then uA:=True;// A a

  if Key=68 then uD:=True;//D d

  if Key=VK_SPACE then dSpace:=False;


  if Key=83 then uS:=True; // S s


  if Key=87 then uW:=True; //W w


 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

end;

procedure Vustril1;
var Angle:Single;
begin

 Angle:=-Bullet1.Kut;
 
 RotateVustril(Bullet1.KorPoch,CenterSam,Angle,Bullet1.X,Bullet1.Y);

 Bullet1.X:=Bullet1.X+Pl1.X;
 Bullet1.Y:=Bullet1.Y+Pl1.Y;

end;

procedure LeftRuhBullet1(Speed:Integer);
begin

  IF Bullet1.Kut=0 then Bullet1.X:=Bullet1.X+speed;


  IF (Bullet1.Kut>0) and (Bullet1.Kut<=15) then
  begin
   if Bullet1.Kut<>5 then
   begin
    Bullet1.X:=Bullet1.X+speed;
    Bullet1.Y:=Bullet1.Y-(speed div 3);
   end
   else
   begin
    Bullet1.X:=Bullet1.X+speed;
    Bullet1.Y:=Bullet1.Y;
   end;
  end;

  IF (Bullet1.Kut>15) and (Bullet1.Kut<=30) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y-(speed div 2);
  end;

  IF (Bullet1.Kut>30) and (Bullet1.Kut<=60) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y-speed;
  end;

  IF (Bullet1.Kut>60) and (Bullet1.Kut<=75) then
  begin
   Bullet1.Y:=Bullet1.Y-speed;
   Bullet1.X:=Bullet1.X+(speed div 2);
  end;

  IF (Bullet1.Kut>75) and (Bullet1.Kut<90) then
  begin
   Bullet1.Y:=Bullet1.Y-speed;
   Bullet1.X:=Bullet1.X+(speed div 3);
  end;

  IF Bullet1.Kut=90 then Bullet1.Y:=Bullet1.Y-speed;

   IF (Bullet1.Kut>90) and (Bullet1.Kut<=105) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 3);
   Bullet1.Y:=Bullet1.Y-speed;
  end;

    IF (Bullet1.Kut>105) and (Bullet1.Kut<=120) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 2);
   Bullet1.Y:=Bullet1.Y-speed;
  end;

   IF (Bullet1.Kut>120) and (Bullet1.Kut<=150) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-speed;
  end;

   IF (Bullet1.Kut>150) and (Bullet1.Kut<=165) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-(speed div 2);
  end;

  IF (Bullet1.Kut>165) and (Bullet1.Kut<180) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-(speed div 3);
  end;

  IF Bullet1.Kut=180 then Bullet1.X:=Bullet1.X-speed;

  IF (Bullet1.Kut>180) and (Bullet1.Kut<=195) then
  begin
   if Bullet1.Kut<>185 then
   begin
    Bullet1.X:=Bullet1.X-speed;
    Bullet1.Y:=Bullet1.Y+(speed div 3);
   end
   else
   begin
    Bullet1.X:=Bullet1.X-speed;
    Bullet1.Y:=Bullet1.Y;
   end;
  end;

   IF (Bullet1.Kut>195) and (Bullet1.Kut<=210) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y+(speed div 2);
  end;

   IF (Bullet1.Kut>210) and (Bullet1.Kut<=240) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y+speed;
  end;

   IF (Bullet1.Kut>240) and (Bullet1.Kut<=255) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 2);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>255) and (Bullet1.Kut<270) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 3);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF Bullet1.Kut=270 then Bullet1.Y:=Bullet1.Y+speed;

  IF (Bullet1.Kut>270) and (Bullet1.Kut<=285) then
  begin
   Bullet1.X:=Bullet1.X+(speed div 3);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>285) and (Bullet1.Kut<=300) then
  begin
   Bullet1.X:=Bullet1.X+(speed div 2);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>300) and (Bullet1.Kut<=330) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>330) and (Bullet1.Kut<=345) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+(speed div 2);
  end;

  IF (Bullet1.Kut>345) and (Bullet1.Kut<360) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+(speed div 3);
  end;

end;

procedure RightRuhBullet1(Speed:Integer);
begin

 IF (Bullet1.Kut>=-359) and (Bullet1.Kut<=-345) then
  begin
   if Bullet1.Kut<>-355 then
   begin
    Bullet1.X:=Bullet1.X+speed;
    Bullet1.Y:=Bullet1.Y-(speed div 3);
   end
   else
   begin
    Bullet1.X:=Bullet1.X+speed;
    Bullet1.Y:=Bullet1.Y;
   end;
  end;

  IF (Bullet1.Kut>-345) and (Bullet1.Kut<=-330) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y-(speed div 2);
  end;

  IF (Bullet1.Kut>-330) and (Bullet1.Kut<=-300) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y-speed;
  end;

  IF (Bullet1.Kut>-300) and (Bullet1.Kut<=-285) then
  begin
   Bullet1.Y:=Bullet1.Y-speed;
   Bullet1.X:=Bullet1.X+(speed div 2);
  end;

  IF (Bullet1.Kut>-285) and (Bullet1.Kut<-270) then
  begin
   Bullet1.Y:=Bullet1.Y-speed;
   Bullet1.X:=Bullet1.X+(speed div 3);
  end;

  IF Bullet1.Kut=-270 then Bullet1.Y:=Bullet1.Y-speed;

   IF (Bullet1.Kut>-270) and (Bullet1.Kut<=-255) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 3);
   Bullet1.Y:=Bullet1.Y-speed;
  end;

    IF (Bullet1.Kut>-255) and (Bullet1.Kut<=-240) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 2);
   Bullet1.Y:=Bullet1.Y-speed;
  end;

   IF (Bullet1.Kut>-240) and (Bullet1.Kut<=-210) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-speed;
  end;

   IF (Bullet1.Kut>-210) and (Bullet1.Kut<=-195) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-(speed div 2);
  end;

  IF (Bullet1.Kut>-195) and (Bullet1.Kut<-180) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y-(speed div 3);
  end;

  IF Bullet1.Kut=-180 then Bullet1.X:=Bullet1.X-speed;

  IF (Bullet1.Kut>-180) and (Bullet1.Kut<=-165) then
  begin
   if Bullet1.Kut<>-175 then
   begin
    Bullet1.X:=Bullet1.X-speed;
    Bullet1.Y:=Bullet1.Y+(speed div 3);
   end
   else
   begin
    Bullet1.X:=Bullet1.X-speed;
    Bullet1.Y:=Bullet1.Y;
   end;
  end;

   IF (Bullet1.Kut>-165) and (Bullet1.Kut<=-150) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y+(speed div 2);
  end;

   IF (Bullet1.Kut>-150) and (Bullet1.Kut<=-120) then
  begin
   Bullet1.X:=Bullet1.X-speed;
   Bullet1.Y:=Bullet1.Y+speed;
  end;

   IF (Bullet1.Kut>-120) and (Bullet1.Kut<=-105) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 2);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>-105) and (Bullet1.Kut<-90) then
  begin
   Bullet1.X:=Bullet1.X-(speed div 3);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF Bullet1.Kut=-90 then Bullet1.Y:=Bullet1.Y+speed;

  IF (Bullet1.Kut>-90) and (Bullet1.Kut<=-75) then
  begin
   Bullet1.X:=Bullet1.X+(speed div 3);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>-75) and (Bullet1.Kut<=-60) then
  begin
   Bullet1.X:=Bullet1.X+(speed div 2);
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>-60) and (Bullet1.Kut<=-30) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+speed;
  end;

  IF (Bullet1.Kut>-30) and (Bullet1.Kut<=-15) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+(speed div 2);
  end;

  IF (Bullet1.Kut>-15) and (Bullet1.Kut<0) then
  begin
   Bullet1.X:=Bullet1.X+speed;
   Bullet1.Y:=Bullet1.Y+(speed div 3);
  end;

end;


procedure RotateBitmap_ads(SourceBitmap: TBitmap;
out DestBitmap: TBitmap; Center: TPoint; Angle: Double);
var
  cosRadians : Double;
  inX : Integer;
  inXOriginal : Integer;
  inXPrime : Integer;
  inXPrimeRotated : Integer;
  inY : Integer;
  inYOriginal : Integer;
  inYPrime : Integer;
  inYPrimeRotated : Integer;
  OriginalRow : pPixelArray;
  Radians : Double;
  RotatedRow : pPixelArray;
  sinRadians : Double;
begin
  DestBitmap.Width := SourceBitmap.Width;
  DestBitmap.Height := SourceBitmap.Height;
  DestBitmap.PixelFormat := pf24bit;
  Radians := (Angle) * PI / 180;
  sinRadians := Sin(Radians);
  cosRadians := Cos(Radians);
  for inX := DestBitmap.Height-1 downto 0 do
  begin
    RotatedRow := DestBitmap.Scanline[inX];
    inXPrime := 2*(inX - Center.y) + 1;
    for inY := DestBitmap.Width-1 downto 0 do
    begin
      inYPrime := 2*(inY - Center.x) + 1;
      inYPrimeRotated := Round(inYPrime * CosRadians - inXPrime * sinRadians);
      inXPrimeRotated := Round(inYPrime * sinRadians + inXPrime * cosRadians);
      inYOriginal := (inYPrimeRotated - 1) div 2 + Center.x;
      inXOriginal := (inXPrimeRotated - 1) div 2 + Center.y;
      if (inYOriginal >= 0) and (inYOriginal <= SourceBitmap.Width-1) and
      (inXOriginal >= 0) and (inXOriginal <= SourceBitmap.Height-1) then
      begin
        OriginalRow := SourceBitmap.Scanline[inXOriginal];
        RotatedRow[inY] := OriginalRow[inYOriginal]
      end
      else
      begin
        RotatedRow[inY].rgbtBlue := 255;
        RotatedRow[inY].rgbtGreen := 255;
        RotatedRow[inY].rgbtRed := 255
      end;
  end;
end;
end;

procedure TForm4.Timer2Timer(Sender: TObject);
var Bitmap:TBitmap;
begin
 //////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////Player1////////////////////////////
 //////////////////////////////////////////////////////////////////////////
 if Pl1.PL=True then
 begin
  Pl1.Kut:=Pl1.Kut+5;
  LeftRuhPl1(Pl1.speed);
  RightRuhPl1(Pl1.speed);
 end;

 if Pl1.PR=True then
 begin
  Pl1.Kut:=Pl1.Kut-5;
  LeftRuhPl1(Pl1.speed);
  RightRuhPl1(Pl1.speed);
 end;

  //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Pl1.Sam,Bitmap,CenterSam,Pl1.Kut);
    Pl1.FIMG.Assign(Bitmap);
    Pl1.FIMG.TransparentColor:=clWhite;
    Pl1.FIMG.Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish

 //////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////Player1////////////////////////////
 //////////////////////////////////////////////////////////////////////////

 //////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////

 if (Tank1.PL=True) and (Tank1.Kut<>0) then
  Tank1.Kut:=Tank1.Kut+5;


 if (Tank1.PR=True) and (Tank1.Kut<>-180) then
  Tank1.Kut:=Tank1.Kut-5;
  


   //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Tank1.Push,Bitmap,TochPushku,Tank1.Kut);
    Tank1.FIMG.Assign(Bitmap);
    Tank1.FIMG.TransparentColor:=clWhite;
    Tank1.FIMG.Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish


 //////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////
end;

procedure RefreshPL1Hero;
begin
Player1.zadReborn:=0;
Player2.logScore:=False;// drygomy ne zaboron uvilichyvatu Score

//Pl1
 Pl1.Sam.Assign(Pl1.OriginalIMG);
 Pl1.X:=Random(871)+1;
 Pl1.Y:=Random(657);
 Pl1.Kut:=0;
 Pl1.prorisovka:=True;
 Pl1.kordon:=True;
 Pl1.popadanie:=0;
 Pl1.FIMG.Assign(Pl1.Sam);
 Pl1.logkV:=True;
 Pl1.zadPad:=0;
 Pl1.speed:=4;
 Pl1.padinya:=False;
 Pl1.zadtorm:=0;
 Pl1.zadVzruva:=0;
 Pl1.animVzruva:=1;
 Pl1.prorisovkaVzruva:=False;
 Pl1.padU:=False;
 Pl1.animdum:=1;
 Pl1.animfire:=1;
 Pl1.height:=Pl1.Y+110;
//Pl1

end;


////////////////////////
/////////Player2////////
////////////////////////

procedure Vustril2;
var Angle:Single;  tochdop,novatoch:TPoint; rad:Double;
begin

 Angle:=-Bullet2.Kut;

 RotateVustril(Bullet2.KorPoch,TochPushku,Angle,Bullet2.X,Bullet2.Y);

 Bullet2.X:=Bullet2.X+Tank1.X;
 Bullet2.Y:=Bullet2.Y+Tank1.Y;
end;

procedure RuhBullet2(Speed:Integer);
var Angle:Single;
begin

 if Bullet2.Kut=360 then Bullet2.Kut:=0;
 if Bullet2.Kut=-360 then Bullet2.Kut:=0;
 Angle:=Bullet2.Kut;
 if Angle=5 then Angle:=-355;
 if Angle=10 then Angle:=-350;
 if Angle=15 then Angle:=-345;
 if Angle=20 then Angle:=-340;
 if Angle=25 then Angle:=-335;
 if Angle=30 then Angle:=-330;
 if Angle=35 then Angle:=-325;
 if Angle=40 then Angle:=-320;
 if Angle=45 then Angle:=-315;
 if Angle=50 then Angle:=-310;
 if Angle=55 then Angle:=-305;
 if Angle=60 then Angle:=-300;
 if Angle=65 then Angle:=-295;
 if Angle=70 then Angle:=-290;
 if Angle=75 then Angle:=-285;
 if Angle=80 then Angle:=-280;
 if Angle=85 then Angle:=-275;
 if Angle=90 then Angle:=-270;
 if Angle=95 then Angle:=-265;
 if Angle=100 then Angle:=-260;
 if Angle=105 then Angle:=-255;
 if Angle=110 then Angle:=-250;
 if Angle=115 then Angle:=-245;
 if Angle=120 then Angle:=-240;
 if Angle=125 then Angle:=-235;
 if Angle=130 then Angle:=-230;
 if Angle=135 then Angle:=-225;
 if Angle=140 then Angle:=-220;
 if Angle=145 then Angle:=-215;
 if Angle=150 then Angle:=-210;
 if Angle=155 then Angle:=-205;
 if Angle=160 then Angle:=-200;
 if Angle=165 then Angle:=-195;
 if Angle=170 then Angle:=-190;
 if Angle=175 then Angle:=-185;
 if Angle=180 then Angle:=-180;
 if Angle=185 then Angle:=-175;
 if Angle=190 then Angle:=-170;
 if Angle=195 then Angle:=-165;
 if Angle=200 then Angle:=-160;
 if Angle=205 then Angle:=-155;
 if Angle=210 then Angle:=-150;
 if Angle=215 then Angle:=-145;
 if Angle=220 then Angle:=-140;
 if Angle=225 then Angle:=-135;
 if Angle=230 then Angle:=-130;
 if Angle=235 then Angle:=-125;
 if Angle=240 then Angle:=-120;
 if Angle=245 then Angle:=-115;
 if Angle=250 then Angle:=-110;
 if Angle=255 then Angle:=-105;
 if Angle=260 then Angle:=-100;
 if Angle=265 then Angle:=-95;
 if Angle=270 then Angle:=-90;
 if Angle=275 then Angle:=-85;
 if Angle=280 then Angle:=-80;
 if Angle=285 then Angle:=-75;
 if Angle=290 then Angle:=-70;
 if Angle=295 then Angle:=-65;
 if Angle=300 then Angle:=-60;
 if Angle=305 then Angle:=-55;
 if Angle=310 then Angle:=-50;
 if Angle=315 then Angle:=-45;
 if Angle=320 then Angle:=-40;
 if Angle=325 then Angle:=-35;
 if Angle=330 then Angle:=-30;
 if Angle=335 then Angle:=-25;
 if Angle=340 then Angle:=-20;
 if Angle=345 then Angle:=-15;
 if Angle=350 then Angle:=-10;
 if Angle=355 then Angle:=-5;

 IF (Angle>=-179) and (Angle<=-165) then
  begin
    Bullet2.X:=Bullet2.X+speed;
    Bullet2.Y:=Bullet2.Y-(speed div 3);
  end;

  IF (Angle>-165) and (Angle<=-150) then
  begin
   Bullet2.X:=Bullet2.X+speed;
   Bullet2.Y:=Bullet2.Y-(speed div 2);
  end;

  IF (Angle>-150) and (Angle<=-120) then
  begin
   Bullet2.X:=Bullet2.X+speed;
   Bullet2.Y:=Bullet2.Y-speed;
  end;

  IF (Angle>-120) and (Angle<=-105) then
  begin
   Bullet2.Y:=Bullet2.Y-speed;
   Bullet2.X:=Bullet2.X+(speed div 2);
  end;

  IF (Angle>-105) and (Angle<-90) then
  begin
   Bullet2.Y:=Bullet2.Y-speed;
   Bullet2.X:=Bullet2.X+(speed div 3);
  end;

  IF Angle=-90 then Bullet2.Y:=Bullet2.Y-speed;

   IF (Angle>-90) and (Angle<=-75) then
  begin
   Bullet2.X:=Bullet2.X-(speed div 3);
   Bullet2.Y:=Bullet2.Y-speed;
  end;

    IF (Angle>-75) and (Angle<=-60) then
  begin
   Bullet2.X:=Bullet2.X-(speed div 2);
   Bullet2.Y:=Bullet2.Y-speed;
  end;

   IF (Angle>-60) and (Angle<-30) then
  begin
   Bullet2.X:=Bullet2.X-speed;
   Bullet2.Y:=Bullet2.Y-speed;
  end;

   IF (Angle>=-30) and (Angle<=-15) then
  begin
   Bullet2.X:=Bullet2.X-speed;
   Bullet2.Y:=Bullet2.Y-(speed div 2);
  end;

  IF (Angle>-15) and (Angle<0) then
  begin
   if Angle<>-5 then
   begin
    Bullet2.X:=Bullet2.X-speed;
    Bullet2.Y:=Bullet2.Y-(speed div 3);
   end
   else
   begin
    Bullet2.X:=Bullet2.X-speed;
    Bullet2.Y:=Bullet2.Y;
   end;
  end;

  IF Angle=0 then Bullet2.X:=Bullet2.X-speed;

  IF (Angle>-359) and (Angle<=-345) then
  begin
    Bullet2.X:=Bullet2.X-speed;
    Bullet2.Y:=Bullet2.Y;
  end;

   IF (Angle>-345) and (Angle<=-330) then
  begin
   Bullet2.X:=Bullet2.X-speed;
   Bullet2.Y:=Bullet2.Y+(speed div 2);
  end;

   IF (Angle>-330) and (Angle<=-300) then
  begin
   Bullet2.X:=Bullet2.X-speed;
   Bullet2.Y:=Bullet2.Y+speed;
  end;

   IF (Angle>-300) and (Angle<=-285) then
  begin
   Bullet2.X:=Bullet2.X-(speed div 2);
   Bullet2.Y:=Bullet2.Y+speed;
  end;

  IF (Angle>-285) and (Angle<-270) then
  begin
   Bullet2.X:=Bullet2.X-(speed div 3);
   Bullet2.Y:=Bullet2.Y+speed;
  end;

  IF Angle=-270 then Bullet2.Y:=Bullet2.Y+speed;

  IF (Angle>-270) and (Angle<=-255) then
  begin
   Bullet2.X:=Bullet2.X+(speed div 3);
   Bullet2.Y:=Bullet2.Y+speed;
  end;

  IF (Angle>-255) and (Angle<=-240) then
  begin
   Bullet2.X:=Bullet2.X+(speed div 2);
   Bullet2.Y:=Bullet2.Y+speed;
  end;

  IF (Angle>-240) and (Angle<=-210) then
  begin
   Bullet2.X:=Bullet2.X+speed;
   Bullet2.Y:=Bullet2.Y+speed;
  end;

  IF (Angle>-210) and (Angle<=-195) then
  begin
   Bullet2.X:=Bullet2.X+speed;
   Bullet2.Y:=Bullet2.Y+(speed div 3);
  end;

  IF (Angle>-195) and (Angle<-180) then
  begin
   if (Angle<>-185) and (Angle<>-190) then
   begin
    Bullet2.X:=Bullet2.X+speed;
    Bullet2.Y:=Bullet2.Y+(speed div 3);
   end
   else
   begin
    Bullet2.X:=Bullet2.X+speed;
    Bullet2.Y:=Bullet2.Y;
   end;
  end;

  IF Angle=-180 then Bullet2.X:=Bullet2.X+speed;

end;



procedure RefreshPl2Hero;
begin
 Player2.zadReborn:=0;
 Player1.logScore:=False;// pershomy ne zaboron uvilichyvatu Score
 
//Tank1
 Tank1.Push.Assign(Tank1.OriginalIMG);
 Tank1.X:=Random(871)+1001+1;
 Tank1.Kut:=0;
 Tank1.prorisovka:=True;
 Tank1.kordon:=True;
 Tank1.popadanie:=0;
 Tank1.FIMG.Assign(Tank1.Push);
 Tank1.logkV:=True;
 Tank1.speed:=4;
 Tank1.zadtorm:=0;
 Tank1.zadVzruva:=0;
 Tank1.animVzruva:=1;
 Tank1.prorisovkaVzruva:=False;
 Tank1.padU:=False;
 Tank1.animdum:=1;
 Tank1.animfire:=1;
 Tank1.prorisovkaFire:=False;
 Tank1.prorisovkaDum:=False;
//Tank1
end;

////////////////////////
/////////Player2////////
////////////////////////

procedure TForm4.Timer3Timer(Sender: TObject);
begin
  if logLoading=True then
  begin
   if kL=0 then
   begin
    logLoading:=False;
    Timer1.Enabled:=True;
    Timer2.Enabled:=True;
   end;
   if kL<>0 then
   Form4.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),Loading[kL]);
   kL:=kL-1;
  end;

  if Player1.Dead=True then Player1.zadReborn:=Player1.zadReborn+1;

  if Player2.Dead=True then Player2.zadReborn:=Player2.zadReborn+1;

  if Bullet1.dozvil=False then
  begin
    Bullet1.interval:=Bullet1.interval-1;
    if Bullet1.interval<=0 then
    begin
     Bullet1.interval:=2;
     Bullet1.dozvil:=True;
    end;
  end;

  if Bullet2.dozvil=False then
  begin
    Bullet2.interval:=Bullet2.interval-1;
    if Bullet2.interval<=0 then
    begin
     Bullet2.interval:=3;
     Bullet2.dozvil:=True;
    end;
  end;

  if logFinal=True then
  begin
    secFinal:=secFinal+1;
    if secFinal=3 then logFinal:=False;
  end;

//////Nach Plus
if logPlusTiming=True then plusTiming:=plusTiming-1;
if plusTiming=0 then
 begin
  plusTiming:=30;
  logPlusTiming:=False;
  logPlus:=False;
 end;

if logPlus=False then
 begin
  case final of
  3:if ((Pl1.popadanie<>0) or (Tank1.popadanie<>0)) and
    ((Player1.Score=2) or (Player2.Score=2))
    then SetPlus;

  7:if ((Pl1.popadanie<>0) or (Tank1.popadanie<>0)) and
      ((Player1.Score=2) or (Player2.Score=2) or (Player1.Score=4)
      or (Player2.Score=4) or (Player1.Score=6) or (Player2.Score=6))
    then SetPlus;

  10:if ((Pl1.popadanie<>0) or (Tank1.popadanie<>0)) and
      ((Player1.Score=3) or (Player2.Score=3) or (Player1.Score=5)
      or (Player2.Score=5) or (Player1.Score=7) or (Player2.Score=7)
      or (Player1.Score=9) or (Player2.Score=9))
     then SetPlus;
  end;
 end;

 //////Kinec Plus

end;

procedure RebornPlayers;
begin

/////////////////////////////////////////////////////////
/////////////////////Vozrogdenie/////////////////////////
/////////////////////////////////////////////////////////

///Player1///
 if Player1.Dead=True then
 begin
  if Player2.logScore=False then
  begin
   Player2.Score:=Player2.Score+1;
   Player2.logScore:=True;
  end;
  if Player1.zadReborn>3 then
  begin
    RefreshPl1Hero;
    Player1.Dead:=False;
    Player1.zadReborn:=0;
  end;
  if logFinal=False then
  BufM.Canvas.Draw(0,400,HUDSEC[Player1.zadReborn]);
 end;
///Player1///

///Player2///
 if Player2.Dead=True then
 begin
   if Player1.logScore=False then
  begin
   Player1.Score:=Player1.Score+1;
   Player1.logScore:=True;
  end;
  if Player2.zadReborn>3 then
  begin
    RefreshPl2Hero;
    Player2.Dead:=False;
    Player2.zadReborn:=0;
  end;
  if logFinal=False then
  BufM.Canvas.Draw(BufM.Width-54,400,HUDSEC[Player2.zadReborn]);
 end;
///Player2///

/////////////////////////////////////////////////////////
/////////////////////Vozrogdenie/////////////////////////
/////////////////////////////////////////////////////////

end;

procedure TForm4.win;
var i:Integer;
begin
 if Player1.Score=final then
 begin

  BufM.Canvas.Draw((BufM.Width div 2)-(wins[1].Width div 2), (BufM.Height div 2)-(wins[1].Height div 2), wins[1]);
  logFinal:=True;
  Pl1.prorisovka:=False;

  if secFinal=3 then
  begin
   Timer1.Enabled:=False;
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
  end;
 end;

  if Player2.Score=final then
 begin

  BufM.Canvas.Draw((BufM.Width div 2)-(wins[2].Width div 2), (BufM.Height div 2)-(wins[2].Height div 2), wins[2]);
  logFinal:=True;
  Tank1.prorisovka:=False;

  if secFinal=3 then
  begin
   Timer1.Enabled:=False;
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
  end;
 end;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
var i:Integer;
begin
 Timer1.Enabled:=False;
 Timer2.Enabled:=False;
 Timer3.Enabled:=False;

 ///////ekran zagruzki//////
 for i:=1 to 3 do
 begin
  Loading[i].Free;
 end;


 ///////ekran zagruzki//////

 pausefon.Free;

 Panel.Free;

 plus.Free;

 parplus.Free;

 for i:=1 to 2 do
 begin
   cd[i].Free;
 end;

 for i:=0 to 10 do
 begin
  Cufru[i].Free;
 end;

 for i:=0 to 3 do
 begin
   HUDSEC[i].Free;
 end;

 BufM.Free;

 Fon.Free;

 Ground.Free;

 for i:=1 to 2 do
 begin
  wins[i].Free;
 end;


 /////////////////////////////////////////////////
 ////////////////////////////////////// Player1///
 /////////////////////////////////////////////////

 //Bullet1
 Bullet1.Bullet.Free;
 Bullet1.FBullet.Free;
//Bullet1

//Pl1

 Pl1.Sam.Free;
 Pl1.OriginalIMG.Free;
 Pl1.FIMG.Free;

 for i:=1 to 11 do
 begin
  Pl1.Vzruv[i].Free;
 end;

 for i:=1 to 11 do Pl1.Fvzruv[i].Free;

 for i:=1 to 3 do
 begin
  Pl1.dum[i].Free;
 end;

 for i:=1 to 3 do
 begin
  Pl1.fire[i].Free;
 end;

//Pl1

 /////////////////////////////////////////////////
 ////////////////////////////////////// Player1///
 /////////////////////////////////////////////////



 /////////////////////////////////////////////////
 ////////////////////////////////////// Player2///
 /////////////////////////////////////////////////

//Bullet2
 Bullet2.Bullet.Free;
 Bullet2.FBullet.Free;
//Bullet2

//Tank1

 Tank1.Tnk.Free;

 Tank1.Push.Free;
 Tank1.OriginalIMG.Free;
 Tank1.FIMG.Free;

 for i:=1 to 11 do
 begin
  Tank1.Vzruv[i].Free;
 end;

 for i:=1 to 3 do
 begin
  Tank1.dum[i].Free;
 end;

 for i:=1 to 3 do
 begin
  Tank1.fire[i].Free;
 end;

//Tank1

 //////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////// Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////

end;

procedure SetPlus;
var rplus:Integer;
begin
  rplus:=Random(2)+1;
  if rplus=2 then
  begin
   PlusKor.X:=Random(1818);
   PlusKor.Y:=0-297;
   prorisovkaPlus:=True;
   logPlus:=True;
  end;
end;

procedure RotateVustril(pochtoch:TPoint;rotatetoch:TPoint;KutPov:Double;
var vusX:Integer; var vusY:Integer);
var tochdop,novatoch:TPoint; rad:Double;
begin
 rad:=(KutPov) * PI / 180;

 tochdop.X:=pochtoch.X-rotatetoch.X;
 tochdop.Y:=pochtoch.Y-rotatetoch.Y;

 novatoch.X:=Round(tochdop.X*cos(rad)-tochdop.Y*sin(rad));
 novatoch.Y:=Round(tochdop.X*sin(rad)+tochdop.Y*cos(rad));

 vusX:=novatoch.X+rotatetoch.X;
 vusY:=novatoch.Y+rotatetoch.Y;
end;

end.
