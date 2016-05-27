unit Unit1;

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

  Heroes=record
  X,Y,povorot,anim,touch,height,zadanim,zadkill,animkill:Integer;
  prorisovka,Fly,PR,PL,LogM,LogP,Death,Akill,logRefresh:Boolean;
  IMG:array [1..2,1..12] of TBitmap;
  Parash:TBitmap;
  Spirit:array [3..10] of TBitmap;
  kill:array[1..3] of TBitmap;
  SpiritAlpha:Integer;
  Spzad,SpY:Integer;
  logSp,SPprorisovka:Boolean;
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

  TForm1 = class(TForm)
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
  Form1: TForm1;
  Player1,Player2:Players;
  Pl1,Pl2:Planes;
  Hero1,Hero2:Heroes;
  Bullet1,Bullet2:Bullets;
  BufM,Fon,Ground,Home,Panel:TBitmap;
  HUDSEC:array[0..3] of TBitmap;
  Cufru:array[0..10] of TBitmap;
  Loading:array[1..3] of TBitmap; kL,final,secFinal:Integer;
  wins:array[1..2] of TPNGObject;
  logLoading,logFinal:Boolean;
  path:string;
  CenterSam,CenterBullet:TPoint;
  Songs:Song;
  pausefon:TPNGObject;
//Klavishi
  dLeft,uLeft,dRight,uRight,dUP,dDOWN,dCTRL:Boolean; //Player1
  dA,uA,dD,uD,dW,dS,dSpace:Boolean; //Player2
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
procedure RuhPl2(Speed:Integer);
procedure Vustril2;
procedure RuhBullet2(Speed:Integer);
//procedure LeftRuhBullet2(Speed:Integer);
//procedure RightRuhBullet2(Speed:Integer);
procedure RefreshPL2Hero;
/////////////Player2///////////////////

procedure RebornPlayers;

procedure RotateBitmap_ads(SourceBitmap: TBitmap;
out DestBitmap: TBitmap; Center: TPoint; Angle: Double);

procedure RotateVustril(pochtoch:TPoint;rotatetoch:TPoint;KutPov:Double;
var vusX:Integer; var vusY:Integer);

implementation
uses Unit2,Unit3;
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


 procedure TForm1.FormCreate(Sender: TObject);
var i,j:Integer;
begin
 Randomize;
 Form1.Width:=Screen.Width;
 Form1.Height:=Screen.Width;
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

 //Home
 Home:=TBitmap.Create;
 Home.Transparent:=True;
 Home.LoadFromFile(path+'/data/home.bmp');
 //Home

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

//Hero1
 Hero1.X:=Pl1.X+64;
 Hero1.Y:=Pl1.Y+105;
 Hero1.prorisovka:=False;
 Hero1.povorot:=2;
 Hero1.Fly:=False;
 Hero1.anim:=1;
 Hero1.PL:=False;
 Hero1.PR:=False;
 Hero1.zadanim:=0;
 Hero1.Death:=False;
 Hero1.SpiritAlpha:=10;
 Hero1.logSp:=False;
 Hero1.touch:=0;
 Hero1.SPprorisovka:=True;
 Hero1.height:=0;
 Hero1.LogP:=False;
 Hero1.Akill:=False;
 Hero1.zadkill:=0;
 Hero1.animkill:=1;
 Hero1.logRefresh:=False;

 for i:=1 to 3 do
 begin
   Hero1.kill[i]:=TBitmap.Create;
   Hero1.kill[i].Transparent:=True;
   Hero1.kill[i].LoadFromFile(path+'/data/hero/1/kill/'+inttostr(i)+'.bmp');
 end;

 for i:=1 to 2 do
 for j:=1 to 12 do
 begin
  Hero1.IMG[i,j]:=TBitmap.Create;
  Hero1.IMG[i,j].Transparent:=True;
  Hero1.IMG[i,j].LoadFromFile(path+'/data/hero/1/'+inttostr(i)+inttostr(j)+'.bmp');
 end;


 Hero1.Parash:=TBitmap.Create;
 Hero1.Parash.Transparent:=True;
 Hero1.Parash.LoadFromFile(path+'/data/hero/1/fly.bmp');

 For i:=3 to 10 do
 begin
  Hero1.Spirit[i]:=TBitmap.Create;
  Hero1.Spirit[i].Transparent:=True;
  Hero1.Spirit[i].LoadFromFile(path+'/data/hero/1/spirit/'+inttostr(i)+'0.bmp');
 end;
//Hero1

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

 Bullet2.prorisovka:=False;
 Bullet2.KorPoch.X:=2;
 Bullet2.KorPoch.Y:=91;

 Bullet2.X:=Bullet2.KorPoch.X+Pl2.X;
 Bullet2.Y:=Bullet2.KorPoch.Y+Pl2.Y;
 Bullet2.interval:=2;
 Bullet2.dozvil:=True;

 CenterBullet.X:=Bullet2.Bullet.Width div 2;
 CenterBullet.Y:=Bullet2.Bullet.Height div 2;

 //Bullet2

//Pl2

 Pl2.X:=BufM.Width-148;
 Pl2.Y:=500;
 Pl2.Kut:=0;
 
 Pl2.prorisovka:=True;
 Pl2.kordon:=True;

 Pl2.Sam:=TBitmap.Create;
 Pl2.Sam.Transparent:=True;
 Pl2.Sam.LoadFromFile(path+'/data/plane/2/Pl2.bmp');
 Pl2.OriginalIMG:=TBitmap.Create;
 Pl2.OriginalIMG.Assign(Pl2.Sam);
 Pl2.FIMG:=TBitmap.Create;
 Pl2.FIMG.Assign(Pl2.Sam);

 Pl2.logkV:=True;

 CenterSam.X:=Pl2.Sam.Width div 2;
 CenterSam.Y:=Pl2.Sam.Height div 2;

 Pl2.zadPad:=0;
 Pl2.speed:=4;
 Pl2.padinya:=False;
 Pl2.zadtorm:=0;
 Pl2.zadVzruva:=0;
 Pl2.animVzruva:=1;

 for i:=1 to 11 do
 begin
  Pl2.Vzruv[i]:=TBitmap.Create;
  Pl2.Vzruv[i].Transparent:=True;
  Pl2.Vzruv[i].LoadFromFile(path+'/data/plane/2/Vzruv/'+inttostr(i)+'.bmp');
 end;

 for i:=1 to 11 do Pl2.Fvzruv[i]:=TBitmap.Create;

 Pl2.prorisovkaVzruva:=False;
 Pl2.padU:=False;

 Pl2.popadanie:=0;

 for i:=1 to 3 do
 begin
  Pl2.dum[i]:=TBitmap.Create;
  Pl2.dum[i].Transparent:=True;
  Pl2.dum[i].LoadFromFile(path+'/data/plane/2/dum/'+inttostr(i)+'.bmp');
 end;


 for i:=1 to 3 do
 begin
  Pl2.fire[i]:=TBitmap.Create;
  Pl2.fire[i].Transparent:=True;
  Pl2.fire[i].LoadFromFile(path+'/data/plane/2/fire/'+inttostr(i)+'.bmp');
 end;


 Pl2.animdum:=1;
 Pl2.animfire:=1;

 Pl2.height:=Pl2.Y+110;

//Pl2

//Hero2
 Hero2.X:=Pl2.X+64;
 Hero2.Y:=Pl2.Y+105;
 Hero2.prorisovka:=False;
 Hero2.povorot:=1;
 Hero2.Fly:=False;
 Hero2.anim:=1;
 Hero2.PL:=False;
 Hero2.PR:=False;
 Hero2.zadanim:=0;
 Hero2.Death:=False;
 Hero2.SpiritAlpha:=10;
 Hero2.logSp:=False;
 Hero2.touch:=0;
 Hero2.SPprorisovka:=True;
 Hero2.height:=0;
 Hero2.LogP:=False;
 Hero2.Akill:=False;
 Hero2.zadkill:=0;
 Hero2.animkill:=1;
 Hero2.logRefresh:=False;
 for i:=1 to 3 do
 begin
   Hero2.kill[i]:=TBitmap.Create;
   Hero2.kill[i].Transparent:=True;
   Hero2.kill[i].LoadFromFile(path+'/data/hero/2/kill/'+inttostr(i)+'.bmp');
 end;

 for i:=1 to 2 do
 for j:=1 to 12 do
 begin
  Hero2.IMG[i,j]:=TBitmap.Create;
  Hero2.IMG[i,j].Transparent:=True;
  Hero2.IMG[i,j].LoadFromFile(path+'/data/hero/2/'+inttostr(i)+inttostr(j)+'.bmp');
 end;


 Hero2.Parash:=TBitmap.Create;
 Hero2.Parash.Transparent:=True;
 Hero2.Parash.LoadFromFile(path+'/data/hero/2/fly.bmp');

 For i:=3 to 10 do
 begin
  Hero2.Spirit[i]:=TBitmap.Create;
  Hero2.Spirit[i].Transparent:=True;
  Hero2.Spirit[i].LoadFromFile(path+'/data/hero/2/spirit/'+inttostr(i)+'0.bmp');
 end;
//Hero2

 //////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////// Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////

end;

procedure TForm1.Timer1Timer(Sender: TObject);
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

 Form1.Caption:=FloatToStr(Pl2.Kut)+'|||'+FloatToStr(Pl1.Kut);
 //Obrabotka Klavish

 //Nazhatie

 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////
 if Hero1.prorisovka=False then
 begin
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

 end
 else
 begin
  if (dLeft=True) and (dRight=False) then
  begin
   Hero1.PL:=True;
   Hero1.zadanim:=Hero1.zadanim+1;
  end;
  if (dRight=True) and (dLeft=False) then
  begin
   Hero1.PR:=True;
   Hero1.zadanim:=Hero1.zadanim+1;
  end;

 end;

 if Hero1.prorisovka=False then
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
   dCTRL:=False;
 end;

 if (dDOWN=True) and (Hero1.touch=0) and (Pl1.prorisovka=True) then // [ х х
 begin
  Pl1.height:=Pl1.Y+110;
  Hero1.touch:=1;
  Form1.Caption:='1';
  Hero1.prorisovka:=True;
  Hero1.Fly:=True;
  Hero1.X:=Pl1.X+64;
  Hero1.Y:=Pl1.Y+105;
  Pl1.PL:=False;
  Pl1.PR:=False;
  dDOWN:=False;
 end;

 if (dUP=True) and (Hero1.touch=1) and (Hero1.LogP=False) then // p з з
 begin
   Hero1.height:=Hero1.Y;
   Hero1.LogP:=True;
   Hero1.touch:=2;
   Form1.Caption:='2';
   dUP:=False;
 end;


 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////
 if Hero2.prorisovka=False then
 begin
  if dA=True then
  begin
   Pl2.PL:=True;
   Pl2.Speed:=4;
   Pl2.padinya:=False;
   Pl2.zadPad:=0;
  end;
  if dD=True then
  begin
   Pl2.PR:=True;
   Pl2.Speed:=4;
   Pl2.padinya:=False;
   Pl2.zadPad:=0;
  end;

 end
 else
 begin
  if (dA=True) and (dD=False) then
  begin
   Hero2.PL:=True;
   Hero2.zadanim:=Hero2.zadanim+1;
  end;
  if (dD=True) and (dA=False) then
  begin
   Hero2.PR:=True;
   Hero2.zadanim:=Hero2.zadanim+1;
  end;

 end;

 if Hero2.prorisovka=False then
 if Bullet2.dozvil=True then
 if dSpace=True then
 begin
   Songs.Bullet[2].Play(True);
   Bullet2.Kut:=Pl2.Kut;
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

   Bullet2.prorisovka:=True;
   dSpace:=False;
 end;

 if (dS=True) and (Hero2.touch=0) and (Pl2.prorisovka=True) then // [ х х
 begin
  Pl2.height:=Pl2.Y+110;
  Hero2.touch:=1;
  Hero2.prorisovka:=True;
  Hero2.Fly:=True;
  Hero2.X:=Pl2.X+64;
  Hero2.Y:=Pl2.Y+105;
  Pl2.PL:=False;
  Pl2.PR:=False;
  dS:=False;
 end;

 if (dW=True) and (Hero2.touch=1) and (Hero2.LogP=False) then // p з з
 begin
   Hero2.height:=Hero2.Y;
   Hero2.LogP:=True;
   Hero2.touch:=2;
   dW:=False;
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
 if Hero1.prorisovka=False then
 begin
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
 end
 else
 begin
  if uLeft=True then
  begin
  dLeft:=False;
  dRight:=False;
  Hero1.PL:=False;
  Hero1.anim:=1;
  Hero1.povorot:=2;
  Hero1.zadanim:=0;
  uLeft:=False;
  end;
  if uRight=True then
  begin
  dLeft:=False;
  dRight:=False;
  Hero1.PR:=False;
  Hero1.anim:=1;
  Hero1.povorot:=1;
  Hero1.zadanim:=0;
  uRight:=False;
  end;
 end;
 ////////////////////////////////////
 //////////////Player1///////////////
 ////////////////////////////////////

 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////
 if Hero2.prorisovka=False then
 begin
  if uA=True then
  begin
   dA:=False;
   dD:=False;
   Pl2.PL:=False;
   uA:=False;
  end;
  if uD=True then
  begin
   dA:=False;
   dD:=False;
   Pl2.PR:=False;
   uD:=False;
  end;
 end
 else
 begin
  if uA=True then
  begin
  dA:=False;
  dD:=False;
  Hero2.PL:=False;
  Hero2.anim:=1;
  Hero2.povorot:=2;
  Hero2.zadanim:=0;
  uA:=False;
  end;
  if uD=True then
  begin
  dA:=False;
  dD:=False;
  Hero2.PR:=False;
  Hero2.anim:=1;
  Hero2.povorot:=1;
  Hero2.zadanim:=0;
  uD:=False;
  end;
 end;
 ////////////////////////////////////
 //////////////Player2///////////////
 ////////////////////////////////////

 //Otzhatie

 //Obrabotka Klavish

/////////////////////Vzaemodiya//////////////////////////
  ///Bullet1
  if (((Bullet1.X+12)>=Pl2.X) and ((Bullet1.X-12)<=Pl2.X+128)) and
  (((Bullet1.Y+12)>=Pl2.Y) and ((Bullet1.Y-12)<=Pl2.Y+128)) and
  (Bullet1.prorisovka=True) {and (Pl1.prorisovka=True)} then
  begin
   Pl2.popadanie:=Pl2.popadanie+1;
   Bullet1.prorisovka:=False;
  end;

  if Hero2.touch=2 then
   if (((Bullet1.X+12)>=Hero2.X-50) and ((Bullet1.X-12)<=Hero2.X-50+151)) and
   (((Bullet1.Y+12)>=Hero2.Y-151) and ((Bullet1.Y-12)<=Hero2.Y-151+189)) and
   (Bullet1.prorisovka=True) {and (Pl1.prorisovka=True)} then
   begin
    Hero2.touch:=1;
   end;

 if Hero2.touch=1 then
  if (((Bullet1.X+12)>=Hero2.X) and ((Bullet1.X-12)<=Hero2.X+43)) and
   (((Bullet1.Y+12)>=Hero2.Y) and ((Bullet1.Y-12)<=Hero2.Y+38)) and
  (Bullet1.prorisovka=True)  then
   begin
    Hero2.Akill:=True;
   end;

 if Hero2.Y+37>=BufM.Height-82 then
  if (((Bullet1.X+12)>=Hero2.X) and ((Bullet1.X-12)<=Hero2.X+43)) and
   (((Bullet1.Y+12)>=Hero2.Y) and ((Bullet1.Y-12)<=Hero2.Y+38)) and
  (Bullet1.prorisovka=True)  then
   begin
    Hero2.Death:=True;
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

  
  if Hero1.touch=2 then
   if (((Bullet2.X+12)>=Hero1.X-50) and ((Bullet2.X-12)<=Hero1.X-50+151)) and
   (((Bullet2.Y+12)>=Hero1.Y-151) and ((Bullet2.Y-12)<=Hero1.Y-151+189)) and
   (Bullet2.prorisovka=True) {and (Pl1.prorisovka=True)} then
   begin
    Hero1.touch:=1;
   end;

 if Hero1.touch=1 then
  if (((Bullet2.X+12)>=Hero1.X) and ((Bullet2.X-12)<=Hero1.X+43)) and
   (((Bullet2.Y+12)>=Hero1.Y) and ((Bullet2.Y-12)<=Hero1.Y+38)) and
  (Bullet2.prorisovka=True)  then
   begin
    Hero1.Akill:=True;
   end;

 if Hero1.Y+37>=BufM.Height-82 then
  if (((Bullet2.X+12)>=Hero1.X) and ((Bullet2.X-12)<=Hero1.X+43)) and
   (((Bullet2.Y+12)>=Hero1.Y) and ((Bullet2.Y-12)<=Hero1.Y+38)) and
  (Bullet2.prorisovka=True)  then
   begin
    Hero1.Death:=True;
   end;


/////////////////////Vzaemodiya//////////////////////////



 BufM.Canvas.Draw(0,0,Fon);
 BufM.Canvas.Draw(0,BufM.Height-82,Ground);
 BufM.Canvas.Draw(904,BufM.Height-266,Home);

 {if (Hero1.Fly=True) and (Hero1.touch<>0) then begin
 BufM.Canvas.MoveTo(0,Pl1.height);
 BufM.Canvas.LineTo(BufM.Width,Pl1.height);
 end;
 if (Hero1.Fly=True) and (Hero1.touch<>1) and (Hero1.touch<>0) then begin
 BufM.Canvas.MoveTo(0,Hero1.height);
 BufM.Canvas.LineTo(BufM.Width,Hero1.height);
  end;

  BufM.Canvas.MoveTo(0,775);
 BufM.Canvas.LineTo(BufM.Width,775);

 BufM.Canvas.MoveTo(0,291);
 BufM.Canvas.LineTo(BufM.Width,291);

 BufM.Canvas.MoveTo(0,592);
 BufM.Canvas.LineTo(BufM.Width,592);

  BufM.Canvas.MoveTo(0,691);
 BufM.Canvas.LineTo(BufM.Width,691);

 BufM.Canvas.MoveTo(0,139);
 BufM.Canvas.LineTo(BufM.Width,139);

 BufM.Canvas.MoveTo(0,419);
 BufM.Canvas.LineTo(BufM.Width,419);   }

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
  if (Bullet1.Y+8>BufM.Height-82-131) and (Bullet1.X+22>=904) and (Bullet1.X+22<=1083) then
   Bullet1.prorisovka:=False;//Перевірка пулі щодо дому
  if Bullet1.X>BufM.Width then Bullet1.prorisovka:=False;
  if Bullet1.X+20<0 then Bullet1.prorisovka:=False;
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


 if Hero1.prorisovka=True then
 begin
  Pl1.kordon:=False;
  if Pl1.X>BufM.Width then Pl1.prorisovka:=False; //za pravy stor
  if Pl1.X+128<0 then Pl1.prorisovka:=False; // za levy stor
  if Pl1.Y+128<0 then
  begin
   Pl1.prorisovka:=False;
   Pl1.padU:=True;
  end;
   //za verh mezhu
  if (Pl1.Y+127>BufM.Height-82)  then
  begin // znushenya pru padini
  {potribno zviryati koord SAM z koord zobrazh zemli}
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

  if (Pl1.Y>BufM.Height-394) and (Pl1.X>=904) and (Pl1.X<=1000) then
   begin //Перевірка літака щодо дому
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
  //if (PL=False) and (PR=False) and (zad=10) then
  //begin

   BufM.Canvas.Draw(Pl1.X, Pl1.Y, Pl1.FIMG);

   //zad:=0;
  //end;
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
    if (Pl1.Y>BufM.Height-341) and (Pl1.X>=904-133) and (Pl1.X<=1083) then
   begin //Перевірка літака щодо дому
    Pl1.prorisovka:=False;
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
  if Hero1.prorisovka=False then Player1.Dead:=True;
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

 //Hero1
 if (Hero1.X<BufM.Width div 2) and (Hero1.Fly=True) then
 Hero1.povorot:=1;
 if (Hero1.X>BufM.Width div 2) and (Hero1.Fly=True) then
 Hero1.povorot:=2;

 if Hero1.Y+37>=BufM.Height-82 then
 begin
 Hero1.Fly:=False;
 end;
 ////////////////////////////////////////////////////////// Start
 if Hero1.Death=True then Form1.Caption:=Form1.Caption+'//Death True';
 if Hero1.Akill=True then Form1.Caption:=Form1.Caption+'//Akill True';

 if (Hero1.prorisovka=True) and (Hero1.Fly=True)
 and (Hero1.touch=1)  then
 begin
   if Hero1.Akill=False then
  BufM.Canvas.Draw(Hero1.X,Hero1.Y,Hero1.IMG[Hero1.povorot,12]);
   if Hero1.Akill=True then
   begin
     Hero1.Death:=True;
     if Hero1.animkill>=3 then Hero1.animkill:=3;
     BufM.Canvas.Draw(Hero1.X,Hero1.Y,Hero1.kill[Hero1.animkill]);

     if Hero1.zadkill=15 then
     begin
      Hero1.animkill:=Hero1.animkill+1;
      Hero1.zadkill:=0;
     end;
     Hero1.zadkill:=Hero1.zadkill+1;
   end;
     Hero1.Y:=Hero1.Y+6;
  end;

  if Hero1.Akill=False then
  begin
  if  (Hero1.touch=1) and (Hero1.Y>BufM.Height-119)  then
   if Pl1.height<=775 then
     Hero1.Death:=True;

  if  (Hero1.touch=2) and (Hero1.Y>BufM.Height-119) then
   begin
   if Pl1.height<=139 then
     if Hero1.height>=419 then
      Hero1.Death:=True;
   if Pl1.height<=291 then
     if Hero1.height>=691 then
      Hero1.Death:=True;
   if (Pl1.height>=291) and (Pl1.height<=775)  then
     if Hero1.height>=592 then
      Hero1.Death:=True;
   end;
  end;

    if ((Hero1.Death=True) and (Hero1.Y>BufM.Height-119)) or ((Hero1.Death=True) and (Hero1.Y+37>=BufM.Height-82))
     then
     begin
       if Hero1.logSp=False then
       begin
        Hero1.logSp:=True;
        Hero1.SpY:=Hero1.Y-20;
       end;
       Form1.Caption:='Death';
      if Hero1.SPprorisovka=True then
      begin
       BufM.Canvas.Draw(Hero1.X,Hero1.SpY,Hero1.spirit[Hero1.spiritalpha]);
       Hero1.SpY:=Hero1.SpY-2;
       Hero1.Spzad:=Hero1.Spzad+1;
      end;
      If (Hero1.Spzad=10) and (Hero1.SpiritAlpha<>3)  then
       begin
        Hero1.Spzad:=0;
        Hero1.spiritalpha:=Hero1.spiritalpha-1;
       end;
      if Hero1.SpiritAlpha=3 then
      begin
       Player1.Dead:=True;
       Hero1.SPprorisovka:=False;
      end;

     end;


  if (Hero1.prorisovka=True) and (Hero1.Fly=True)
   and (Hero1.Y<BufM.Height-82)
    and (Hero1.touch=2)
    then
 begin

  BufM.Canvas.Draw(Hero1.X-50,Hero1.Y-151,Hero1.Parash);
  Hero1.Y:=Hero1.Y+2;


  end;

 //////////////////////////////////////////////////////////////// Finish

 if (Hero1.prorisovka=True) and (Hero1.Fly=False)
 and (Hero1.Death=False) then
 begin

  if Hero1.PR=True then
  begin
   Hero1.povorot:=1;
   if Hero1.zadanim=4 then
   begin
    Hero1.anim:=Hero1.anim+1;
    Hero1.X:=Hero1.X+10;
    if Hero1.anim>10 then Hero1.anim:=2;
    Hero1.zadanim:=0;
   end;
  end;

  if Hero1.PL=True then
  begin
   Hero1.povorot:=2;
   if Hero1.zadanim=4 then
   begin
    Hero1.anim:=Hero1.anim+1;
    Hero1.X:=Hero1.X-10;
    if Hero1.anim>10 then Hero1.anim:=2;
    Hero1.zadanim:=0;
   end;
  end;

  if Hero1.X+5>BufM.Width then Hero1.X:=-10;
  if Hero1.X+38<0 then Hero1.X:=BufM.Width-5;


  if (Hero1.Y>BufM.Height-233) and (Hero1.X>=904+48-21) and (Hero1.X<=904+75-21)
  then
  begin
   Hero1.logRefresh:=True;
   Hero1.prorisovka:=False;
   Player1.Dead:=True;
   RebornPlayers;
  end;

  BufM.Canvas.Draw(Hero1.X,Hero1.Y,Hero1.IMG[Hero1.povorot,Hero1.anim]);

 end;
 //Hero1

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
    //LeftRuhBullet2(12);
    //RightRuhBullet2(12);
    RuhBullet2(20);
  end;

  if (Bullet2.Y+8>BufM.Height-82) then Bullet2.prorisovka:=False;
  if (Bullet2.Y+8>BufM.Height-82-131) and (Bullet2.X+22>=904) and (Bullet2.X+22<=1083) then
   Bullet2.prorisovka:=False;//Перевірка пулі щодо дому
  if Bullet2.X>BufM.Width then Bullet2.prorisovka:=False;
  if Bullet2.X+20<0 then Bullet2.prorisovka:=False;
  if Bullet2.Y+14<0 then Bullet2.prorisovka:=False;

 //Bullet2

 //Pl2

 if Pl2.padinya=False then
 begin
  //RightRuhPl2(Pl2.speed);
  //LeftRuhPl2(Pl2.speed);

  if (Pl2.PL=False) and (Pl2.PR=False) then RuhPl2(Pl2.speed+3)
  else RuhPl2(Pl2.speed);


 end;


 if Pl2.padinya=False then
 if ((Pl2.Kut<=-60) and (Pl2.Kut>=-120)) or
    ((Pl2.Kut<=300) and (Pl2.Kut>=240)) then
 begin
   Pl2.zadPad:=Pl2.zadPad+1;

  if Pl2.zadPad=50 then Pl2.speed:=3;
  if Pl2.zadPad=100 then Pl2.speed:=2;
  if Pl2.zadPad=150 then Pl2.speed:=1;
  if Pl2.zadPad=150 then
 begin
  Pl2.speed:=-1;
  Pl2.padinya:=True;
  Pl2.zadPad:=0;

  //RightRuhPl2(Pl2.speed-1);
  //LeftRuhPl2(Pl2.speed-1);
  RuhPl2(Pl2.speed-1);
 end;
 end;

 if (Pl2.padinya=True) then
 begin
   Pl2.zadPad:=Pl2.zadPad+1;

  if Pl2.zadPad=50 then Pl2.speed:=-1;
  if Pl2.zadPad=80 then Pl2.speed:=-2;
  if Pl2.zadPad=110 then Pl2.speed:=-3;


  Pl2.Y:=Pl2.Y-Pl2.speed;

  //RightRuhPl2(Pl2.speed-1);
  //LeftRuhPl2(Pl2.speed-1);

 end;


 if Hero2.prorisovka=True then
 begin
  Pl2.kordon:=False;
  if Pl2.X>BufM.Width then Pl2.prorisovka:=False; //za pravy stor
  if Pl2.X+128<0 then Pl2.prorisovka:=False; // za levy stor
  if Pl2.Y+128<0 then
  begin
   Pl2.prorisovka:=False;
   Pl2.padU:=True;
  end;
   //za verh mezhu
  if (Pl2.Y+127>BufM.Height-82)  then
  begin // znushenya pru padini
  {potribno zviryati koord SAM z koord zobrazh zemli}
    Pl2.prorisovka:=False; // znushenya pru padini
     {potribno zviryati koord SAM z koord zobrazh zemli}
    Pl2.prorisovkaVzruva:=True;
    if Pl2.logkV=True then
    begin
     Pl2.xvzr:=Pl2.X;
     Pl2.yvzr:=Pl2.Y;
     Pl2.logkV:=False;
    end;
  end;

  if (Pl2.Y>BufM.Height-394) and (Pl2.X>=904) and (Pl2.X<=1000) then
   begin //Перевірка літака щодо дому
    Pl2.prorisovka:=False; // znushenya pru padini
     {potribno zviryati koord SAM z koord zobrazh zemli}
    Pl2.prorisovkaVzruva:=True;
    if Pl2.logkV=True then
    begin
     Pl2.xvzr:=Pl2.X;
     Pl2.yvzr:=Pl2.Y;
     Pl2.logkV:=False;
    end;
   end;
 end;

 //dum
   if Pl2.popadanie=1 then
   begin
    if Pl2.animdum>3 then Pl2.animdum:=1;

    Pl2.Sam.Assign(Pl2.dum[Pl2.animdum]);

    if Pl2.zadDum=7 then Pl2.animdum:=Pl2.animdum+1;

    if Pl2.zadDum>7 then Pl2.zadDum:=0;


    Pl2.zadDum:=Pl2.zadDum+1;


   end;
 //dum

 //fire
  if Pl2.popadanie=2 then
   begin
    if Pl2.animfire>3 then Pl2.animfire:=1;

    Pl2.Sam.Assign(Pl2.fire[Pl2.animfire]);
    
    if Pl2.zadFire=7 then Pl2.animfire:=Pl2.animfire+1;

    if Pl2.zadFire>7 then Pl2.zadFire:=0;


    Pl2.zadFire:=Pl2.zadFire+1;


   end;
 //fire

 //3 popadanie VZRUV

 if Pl2.popadanie=3 then
 begin
    Pl2.prorisovka:=False;
    Pl2.prorisovkaVzruva:=True;
    if Pl2.logkV=True then
    begin
     Pl2.xvzr:=Pl2.X;
     Pl2.yvzr:=Pl2.Y;
     Pl2.logkV:=False;
    end;
 end;

 //3 popadanie VZRUV



 if (Pl2.prorisovka=True) then
 begin
  //if (PL=False) and (PR=False) and (zad=10) then
  //begin

   BufM.Canvas.Draw(Pl2.X, Pl2.Y, Pl2.FIMG);

   //zad:=0;
  //end;
  if Pl2.kordon=True then
  begin
   if Pl2.X+10>BufM.Width then Pl2.X:=-114; //za pravy stor
   if Pl2.X+118<0 then Pl2.X:=BufM.Width-30; // za levy stor
   if Pl2.Y<0 then Pl2.Y:=0; //za verh mezhu
   if (Pl2.Y+127>BufM.Height-82) {and (BufM.Width=PX+127)} then
   begin
    Pl2.prorisovka:=False; // znushenya pru padini
     {potribno zviryati koord SAM z koord zobrazh zemli}
    Pl2.prorisovkaVzruva:=True;
    if Pl2.logkV=True then
    begin
     Pl2.xvzr:=Pl2.X;
     Pl2.yvzr:=Pl2.Y;
     Pl2.logkV:=False;
    end;
   end;
    if (Pl2.Y>BufM.Height-341) and (Pl2.X>=904-133) and (Pl2.X<=1083) then
   begin //Перевірка літака щодо дому
    Pl2.prorisovka:=False;
    Pl2.prorisovkaVzruva:=True;
    if Pl2.logkV=True then
    begin
     Pl2.xvzr:=Pl2.X;
     Pl2.yvzr:=Pl2.Y;
     Pl2.logkV:=False;
    end;
   end;
  end;

 end;

 if Pl2.animVzruva>11 then
 begin
  Pl2.prorisovkaVzruva:=False;
  if Hero2.prorisovka=False then Player2.Dead:=True;
 end;
 if (Pl2.prorisovkaVzruva=True) and (Pl2.padU=False) then
 begin
   Pl2.PL:=False;
   Pl2.PR:=False;
   if Pl2.animVzruva=1 then
  Songs.Vzruv[2].Play(True);
  //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Pl2.Vzruv[Pl2.animVzruva],Bitmap,CenterSam,Pl2.Kut);
    Pl2.Fvzruv[Pl2.animVzruva].Assign(Bitmap);
    Pl2.Fvzruv[Pl2.animVzruva].TransparentColor:=clWhite;
    Pl2.Fvzruv[Pl2.animVzruva].Transparent:=True;
   finally
    Bitmap.Free;
   end;

  //Rotate Finish


  BufM.Canvas.Draw(Pl2.xvzr,Pl2.yvzr,Pl2.Fvzruv[Pl2.animVzruva]);

  if Pl2.zadVzruva=3 then Pl2.animVzruva:=Pl2.animVzruva+1;

  if Pl2.zadVzruva>3 then Pl2.zadVzruva:=0;


  Pl2.zadVzruva:=Pl2.zadVzruva+1;

 end;

 //Pl2

 //Hero2
 if (Hero2.X<BufM.Width div 2) and (Hero2.Fly=True) then
 Hero2.povorot:=1;
 if (Hero2.X>BufM.Width div 2) and (Hero2.Fly=True) then
 Hero2.povorot:=2;

 if Hero2.Y+37>=BufM.Height-82 then
 begin
 Hero2.Fly:=False;
 end;
 ////////////////////////////////////////////////////////// Start
 if Hero2.Death=True then Form1.Caption:=Form1.Caption+'//Death True';
 if Hero2.Akill=True then Form1.Caption:=Form1.Caption+'//Akill True';

 if (Hero2.prorisovka=True) and (Hero2.Fly=True)
 and (Hero2.touch=1)  then
 begin
   if Hero2.Akill=False then
  BufM.Canvas.Draw(Hero2.X,Hero2.Y,Hero2.IMG[Hero2.povorot,12]);
   if Hero2.Akill=True then
   begin
     Hero2.Death:=True;
     if Hero2.animkill>=3 then Hero2.animkill:=3;
     BufM.Canvas.Draw(Hero2.X,Hero2.Y,Hero2.kill[Hero2.animkill]);

     if Hero2.zadkill=15 then
     begin
      Hero2.animkill:=Hero2.animkill+1;
      Hero2.zadkill:=0;
     end;
     Hero2.zadkill:=Hero2.zadkill+1;
   end;
     Hero2.Y:=Hero2.Y+6;
  end;

  if Hero2.Akill=False then
  begin
  if  (Hero2.touch=1) and (Hero2.Y>BufM.Height-119)  then
   if Pl2.height<=775 then
     Hero2.Death:=True;

  if  (Hero2.touch=2) and (Hero2.Y>BufM.Height-119) then
   begin
   if Pl2.height<=139 then
     if Hero2.height>=419 then
      Hero2.Death:=True;
   if Pl2.height<=291 then
     if Hero2.height>=691 then
      Hero2.Death:=True;
   if (Pl2.height>=291) and (Pl2.height<=775)  then
     if Hero2.height>=592 then
      Hero2.Death:=True;
   end;
  end;

    if ((Hero2.Death=True) and (Hero2.Y>BufM.Height-119)) or((Hero2.Death=True) and (Hero2.Y+37>=BufM.Height-82))
     then
     begin
       if Hero2.logSp=False then
       begin
        Hero2.logSp:=True;
        Hero2.SpY:=Hero2.Y-20;
       end;
       Form1.Caption:='Death';
      if Hero2.SPprorisovka=True then
      begin
       BufM.Canvas.Draw(Hero2.X,Hero2.SpY,Hero2.spirit[Hero2.spiritalpha]);
       Hero2.SpY:=Hero2.SpY-2;
       Hero2.Spzad:=Hero2.Spzad+1;
      end;
      If (Hero2.Spzad=10) and (Hero2.SpiritAlpha<>3)  then
       begin
        Hero2.Spzad:=0;
        Hero2.spiritalpha:=Hero2.spiritalpha-1;
       end;
      if Hero2.SpiritAlpha=3 then
      begin
       Player2.Dead:=True;
       Hero2.SPprorisovka:=False;
      end;

     end;


  if (Hero2.prorisovka=True) and (Hero2.Fly=True)
   and (Hero2.Y<BufM.Height-82)
    and (Hero2.touch=2)
    then
 begin

  BufM.Canvas.Draw(Hero2.X-50,Hero2.Y-151,Hero2.Parash);
  Hero2.Y:=Hero2.Y+2;


  end;

 //////////////////////////////////////////////////////////////// Finish

 if (Hero2.prorisovka=True) and (Hero2.Fly=False)
 and (Hero2.Death=False) then
 begin

  if Hero2.PR=True then
  begin
   Hero2.povorot:=1;
   if Hero2.zadanim=4 then
   begin
    Hero2.anim:=Hero2.anim+1;
    Hero2.X:=Hero2.X+10;
    if Hero2.anim>10 then Hero2.anim:=2;
    Hero2.zadanim:=0;
   end;
  end;

  if Hero2.PL=True then
  begin
   Hero2.povorot:=2;
   if Hero2.zadanim=4 then
   begin
    Hero2.anim:=Hero2.anim+1;
    Hero2.X:=Hero2.X-10;
    if Hero2.anim>10 then Hero2.anim:=2;
    Hero2.zadanim:=0;
   end;
  end;

  if Hero2.X+5>BufM.Width then Hero2.X:=-10;
  if Hero2.X+38<0 then Hero2.X:=BufM.Width-5;


  if (Hero2.Y>BufM.Height-233) and (Hero2.X>=904+48-21) and (Hero2.X<=904+75-21)
  then
  begin
   Hero2.logRefresh:=True;
   Hero2.prorisovka:=False;
   Player2.Dead:=True;
   RebornPlayers;
  end;

  BufM.Canvas.Draw(Hero2.X,Hero2.Y,Hero2.IMG[Hero2.povorot,Hero2.anim]);

 end;
 //Hero2

 ///////////////////////////////////////////////////////////////////////
 ///////////////////////////Player2/////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////


 /////////////////////////////////////////////////////////Score Start

 
 /////////////////////////////////////////////////////////Score Finish

 RebornPlayers;

 BufM.Canvas.Draw((BufM.Width div 2)-285,-5,Panel);
 BufM.Canvas.Draw((BufM.Width div 2)-285+200,2,Cufru[Player1.Score]);// Player1
 BufM.Canvas.Draw((BufM.Width div 2)-285+308,2,Cufru[Player2.Score]);//Player2
 win;
 Form1.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),BufM);
 end;
//end;
 
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
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
  Form1.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),pausefon);
  Form3.Show;
 end;
end;


procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
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


  if Key=83 then dS:=False; // S s


  if Key=87 then dW:=False; //W w


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

procedure TForm1.Timer2Timer(Sender: TObject);
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
 if Pl2.PL=True then
 begin
  Pl2.Kut:=Pl2.Kut+5;
  RuhPl2(Pl2.speed);
 end;

 if Pl2.PR=True then
 begin
  Pl2.Kut:=Pl2.Kut-5;
  RuhPl2(Pl2.speed);
 end;

   //Rotate Start

   Bitmap := TBitmap.Create;
   try
    RotateBitmap_ads(Pl2.Sam,Bitmap,CenterSam,Pl2.Kut);
    Pl2.FIMG.Assign(Bitmap);
    Pl2.FIMG.TransparentColor:=clWhite;
    Pl2.FIMG.Transparent:=True;
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

//Hero1
 Hero1.X:=Pl1.X+64;
 Hero1.Y:=Pl1.Y+105;
 Hero1.prorisovka:=False;
 Hero1.povorot:=2;
 Hero1.Fly:=False;
 Hero1.anim:=1;
 Hero1.PL:=False;
 Hero1.PR:=False;
 Hero1.zadanim:=0;
 Hero1.Death:=False;
 Hero1.SpiritAlpha:=10;
 Hero1.logSp:=False;
 Hero1.touch:=0;
 Hero1.SPprorisovka:=True;
 Hero1.height:=0;
 Hero1.LogP:=False;
 Hero1.Akill:=False;
 Hero1.zadkill:=0;
 Hero1.animkill:=1;
 Hero1.logRefresh:=False;
//Hero1

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

procedure RuhPl2(Speed:Integer);
var Angle:Single;
begin
 if Pl2.Kut=360 then Pl2.Kut:=0;
 if Pl2.Kut=-360 then Pl2.Kut:=0;
 Angle:=Pl2.Kut;
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
    Pl2.X:=Pl2.X+speed;
    Pl2.Y:=Pl2.Y-(speed div 3);
  end;

  IF (Angle>-165) and (Angle<=-150) then
  begin
   Pl2.X:=Pl2.X+speed;
   Pl2.Y:=Pl2.Y-(speed div 2);
  end;

  IF (Angle>-150) and (Angle<=-120) then
  begin
   Pl2.X:=Pl2.X+speed;
   Pl2.Y:=Pl2.Y-speed;
  end;

  IF (Angle>-120) and (Angle<=-105) then
  begin
   Pl2.Y:=Pl2.Y-speed;
   Pl2.X:=Pl2.X+(speed div 2);
  end;

  IF (Angle>-105) and (Angle<-90) then
  begin
   Pl2.Y:=Pl2.Y-speed;
   Pl2.X:=Pl2.X+(speed div 3);
  end;

  IF Angle=-90 then Pl2.Y:=Pl2.Y-speed;

   IF (Angle>-90) and (Angle<=-75) then
  begin
   Pl2.X:=Pl2.X-(speed div 3);
   Pl2.Y:=Pl2.Y-speed;
  end;

    IF (Angle>-75) and (Angle<=-60) then
  begin
   Pl2.X:=Pl2.X-(speed div 2);
   Pl2.Y:=Pl2.Y-speed;
  end;

   IF (Angle>-60) and (Angle<-30) then
  begin
   Pl2.X:=Pl2.X-speed;
   Pl2.Y:=Pl2.Y-speed;
  end;

   IF (Angle>=-30) and (Angle<=-15) then
  begin
   Pl2.X:=Pl2.X-speed;
   Pl2.Y:=Pl2.Y-(speed div 2);
  end;

  IF (Angle>-15) and (Angle<0) then
  begin
   if Angle<>-5 then
   begin
    Pl2.X:=Pl2.X-speed;
    Pl2.Y:=Pl2.Y-(speed div 3);
   end
   else
   begin
    Pl2.X:=Pl2.X-speed;
    Pl2.Y:=Pl2.Y;
   end;
  end;

  IF Angle=0 then Pl2.X:=Pl2.X-speed;

  IF (Angle>-359) and (Angle<=-345) then
  begin
    Pl2.X:=Pl2.X-speed;
    Pl2.Y:=Pl2.Y;
  end;

   IF (Angle>-345) and (Angle<=-330) then
  begin
   Pl2.X:=Pl2.X-speed;
   Pl2.Y:=Pl2.Y+(speed div 2);
  end;

   IF (Angle>-330) and (Angle<=-300) then
  begin
   Pl2.X:=Pl2.X-speed;
   Pl2.Y:=Pl2.Y+speed;
  end;

   IF (Angle>-300) and (Angle<=-285) then
  begin
   Pl2.X:=Pl2.X-(speed div 2);
   Pl2.Y:=Pl2.Y+speed;
  end;

  IF (Angle>-285) and (Angle<-270) then
  begin
   Pl2.X:=Pl2.X-(speed div 3);
   Pl2.Y:=Pl2.Y+speed;
  end;

  IF Angle=-270 then Pl2.Y:=Pl2.Y+speed;

  IF (Angle>-270) and (Angle<=-255) then
  begin
   Pl2.X:=Pl2.X+(speed div 3);
   Pl2.Y:=Pl2.Y+speed;
  end;

  IF (Angle>-255) and (Angle<=-240) then
  begin
   Pl2.X:=Pl2.X+(speed div 2);
   Pl2.Y:=Pl2.Y+speed;
  end;

  IF (Angle>-240) and (Angle<=-210) then
  begin
   Pl2.X:=Pl2.X+speed;
   Pl2.Y:=Pl2.Y+speed;
  end;

  IF (Angle>-210) and (Angle<=-195) then
  begin
   Pl2.X:=Pl2.X+speed;
   Pl2.Y:=Pl2.Y+(speed div 3);
  end;

  IF (Angle>-195) and (Angle<-180) then
  begin
   if (Angle<>-185) and (Angle<>-190) then
   begin
    Pl2.X:=Pl2.X+speed;
    Pl2.Y:=Pl2.Y+(speed div 3);
   end
   else
   begin
    Pl2.X:=Pl2.X+speed;
    Pl2.Y:=Pl2.Y;
   end;
  end;

  IF Angle=-180 then Pl2.X:=Pl2.X+speed;

end;

procedure Vustril2;
var Angle:Single;
begin
 Angle:=-Bullet2.Kut;

 RotateVustril(Bullet2.KorPoch,CenterSam,Angle,Bullet2.X,Bullet2.Y);

 Bullet2.X:=Bullet2.X+Pl2.X;
 Bullet2.Y:=Bullet2.Y+Pl2.Y;
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

//Hero2
 Hero2.X:=Pl2.X+64;
 Hero2.Y:=Pl2.Y+105;
 Hero2.prorisovka:=False;
 Hero2.povorot:=2;
 Hero2.Fly:=False;
 Hero2.anim:=1;
 Hero2.PL:=False;
 Hero2.PR:=False;
 Hero2.zadanim:=0;
 Hero2.Death:=False;
 Hero2.SpiritAlpha:=10;
 Hero2.logSp:=False;
 Hero2.touch:=0;
 Hero2.SPprorisovka:=True;
 Hero2.height:=0;
 Hero2.LogP:=False;
 Hero2.Akill:=False;
 Hero2.zadkill:=0;
 Hero2.animkill:=1;
 Hero2.logRefresh:=False;
//Hero2

//Pl2
 Pl2.Sam.Assign(Pl2.OriginalIMG);
 Pl2.X:=Random(871)+1001+1;
 Pl2.Y:=Random(657);
 Pl2.Kut:=0;
 Pl2.prorisovka:=True;
 Pl2.kordon:=True;
 Pl2.popadanie:=0;
 Pl2.FIMG.Assign(Pl2.Sam);
 Pl2.logkV:=True;
 Pl2.zadPad:=0;
 Pl2.speed:=4;
 Pl2.padinya:=False;
 Pl2.zadtorm:=0;
 Pl2.zadVzruva:=0;
 Pl2.animVzruva:=1;
 Pl2.prorisovkaVzruva:=False;
 Pl2.padU:=False;
 Pl2.animdum:=1;
 Pl2.animfire:=1;
 Pl2.height:=Pl2.Y+110;
//Pl2

end;

////////////////////////
/////////Player2////////
////////////////////////

procedure TForm1.Timer3Timer(Sender: TObject);
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
   Form1.Canvas.StretchDraw(Rect(0,0,ClientWidth,ClientHeight),Loading[kL]);
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
     Bullet2.interval:=2;
     Bullet2.dozvil:=True;
    end;
  end;

  if logFinal=True then
  begin
    secFinal:=secFinal+1;
    if secFinal=3 then logFinal:=False;
  end;


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
   if Hero1.logRefresh=False then
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
   if Hero2.logRefresh=False then
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

procedure TForm1.win;
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
   Form1.Close;
  end;
 end;

  if Player2.Score=final then
 begin

  BufM.Canvas.Draw((BufM.Width div 2)-(wins[2].Width div 2), (BufM.Height div 2)-(wins[2].Height div 2), wins[2]);
  logFinal:=True;
  Pl2.prorisovka:=False;

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
   Form1.Close;
  end;
 end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i,j:integer;
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

 //Home
 Home.Free;
 //Home

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

//Hero1
 for i:=1 to 3 do
 begin
   Hero1.kill[i].Free;
 end;

 for i:=1 to 2 do
 for j:=1 to 12 do
 begin
  Hero1.IMG[i,j].Free;
 end;


 Hero1.Parash.Free;

 For i:=3 to 10 do
 begin
  Hero1.Spirit[i].Free;
 end;
//Hero1

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

//Pl2

 Pl2.Sam.Free;
 Pl2.OriginalIMG.Free;
 Pl2.FIMG.Free;

 for i:=1 to 11 do
 begin
  Pl2.Vzruv[i].Free;
 end;

 for i:=1 to 11 do Pl2.Fvzruv[i].Free;

 for i:=1 to 3 do
 begin
  Pl2.dum[i].Free;
 end;


 for i:=1 to 3 do
 begin
  Pl2.fire[i].Free;
 end;

//Pl2

//Hero2
 for i:=1 to 3 do
 begin
   Hero2.kill[i].Free;
 end;

 for i:=1 to 2 do
 for j:=1 to 12 do
 begin
  Hero2.IMG[i,j].Free;
 end;


 Hero2.Parash.Free;

 For i:=3 to 10 do
 begin
  Hero2.Spirit[i].Free;
 end;
//Hero2

 //////////////////////////////////////////////////////////////////////////
 ////////////////////////////////////// Player2////////////////////////////
 //////////////////////////////////////////////////////////////////////////
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
