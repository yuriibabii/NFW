unit SongStream;

interface

uses Bass, SysUtils;

const
  CHORUS    = 1;
  COMPRESSOR = 2;
  DISTORTION = 3;
  ECHO      = 4;
  FLANGER   = 5;
  GARGLE    = 6;
  PARAMEQLOW = 7;
  PARAMEQMED = 8;
  PARAMEQHIGH = 9;
  REVERB    = 10;
  MAX_EFFET = 10;

  FREQUENCE_INITIAL = 44100;
  FREQUENCE_MIN     = 100;
  FREQUENCE_MAX     = 100000;

  PAN_INI = 0;
  PAN_MAX = 100;
  PAN_MIN = -100;

  VOLUME_INI = 75;
  VOLUME_MAX = 100;
  VOLUME_MIN = 0;


  CHORUS_MIN_WET_DRY_MIX = 0.0;
  CHORUS_INI_WET_DRY_MIX = 0.0;
  CHORUS_MAX_WET_DRY_MIX = 100.0;

  CHORUS_MIN_DEPTH = 0.0;
  CHORUS_INI_DEPTH = 25.0;
  CHORUS_MAX_DEPTH = 100.0;

  CHORUS_MIN_FEEDBACK = -99.0;
  CHORUS_INI_FEEDBACK = 0.0;
  CHORUS_MAX_FEEDBACK = 99.0;

  CHORUS_MIN_FREQUENCY = 0.0;
  CHORUS_INI_FREQUENCY = 0.0;
  CHORUS_MAX_FREQUENCY = 10.0;

  CHORUS_MIN_DELAY = 0.0;
  CHORUS_INI_DELAY = 0.0;
  CHORUS_MAX_DELAY = 20.0;


  FLANGER_MIN_WET_DRY_MIX = 0.0;
  FLANGER_INI_WET_DRY_MIX = 0.0;
  FLANGER_MAX_WET_DRY_MIX = 100.0;

  FLANGER_MIN_DEPTH = 0.0;
  FLANGER_INI_DEPTH = 25.0;
  FLANGER_MAX_DEPTH = 100.0;

  FLANGER_MIN_FEEDBACK = -99.0;
  FLANGER_INI_FEEDBACK = 0.0;
  FLANGER_MAX_FEEDBACK = 99.0;

  FLANGER_MIN_FREQUENCY = 0.0;
  FLANGER_INI_FREQUENCY = 0.0;
  FLANGER_MAX_FREQUENCY = 10.0;

  FLANGER_MIN_DELAY = 0.0;
  FLANGER_INI_DELAY = 0.0;
  FLANGER_MAX_DELAY = 4.0;

  COMPRESSOR_MAX_GAIN = 60.0;
  COMPRESSOR_INI_GAIN = 0.0;
  COMPRESSOR_MIN_GAIN = -60.0;

  PARAMEQ_MAX_GAIN = 15.0;
  PARAMEQ_MIN_GAIN = -15.0;
  PARAMEQ_INI_GAIN = 0.0;

  DISTORTION_MIN_GAIN = -60.0;
  DISTORTION_INI_GAIN = 0.0;
  DISTORTION_MAX_GAIN = 0.0;

  DISTORTION_MIN_EDGE = 0.0;
  DISTORTION_INI_EDGE = 50.0;
  DISTORTION_MAX_EDGE = 100.0;

  DISTORTION_MIN_POST_EQ_CENTER_FREQUENCY = 100.0;
  DISTORTION_INI_POST_EQ_CENTER_FREQUENCY = 4000.0;
  DISTORTION_MAX_POST_EQ_CENTER_FREQUENCY = 8000.0;

  DISTORTION_MIN_POST_EQ_BANDWITH = 100.0;
  DISTORTION_INI_POST_EQ_BANDWITH = 4000.0;
  DISTORTION_MAX_POST_EQ_BANDWITH = 8000.0;

  DISTORTION_MIN_PRE_LOWPASS_CUT_OFF = 100.0;
  DISTORTION_INI_PRE_LOWPASS_CUT_OFF = 4000.0;
  DISTORTION_MAX_PRE_LOWPASS_CUT_OFF = 8000.0;

  GARGLE_MIN_DW_RATE_HZ = 1;
  GARGLE_INI_DW_RATE_HZ = 15;
  GARGLE_MAX_DW_RATE_HZ = 1000;

type

  TSongStream = class(TObject)
  private
    nom: string;
    nomComplet: string;
    volume, frequence, pan: integer;

    stream: HSTREAM;

    ch: BASS_FXCHORUS;
    co: BASS_FXCOMPRESSOR;
    di: BASS_FXDISTORTION;
    ec: BASS_FXECHO;
    fl: BASS_FXFLANGER;
    ga: BASS_FXGARGLE;
    pq: BASS_FXPARAMEQ;
    rv: BASS_FXREVERB;

    fx: array [1..MAX_EFFET] of HFX;

    procedure SetAttributes(volume, frequence, pan: integer);

  public
    constructor Create;
    destructor Destroy; override;

    {general}
    procedure Init(Name: string);
    procedure Play(InDebut: boolean);
    procedure Stop;
    procedure Pause;

    function GetNom: string;
    function GetNomComplet: string;

    function PositionCurrent: dword;
    procedure ChangerPosition(NouvellePosition: dword);
    function LongueurTotal: dword;

    function GetTempsTotal: float;
    function GetTempsCurrent: float;

    procedure SetVolume(NewVolume: integer);
    function GetVolume: integer;

    function GetVolumeMax: integer;
    function GetVolumeMin: integer;

    procedure SetPan(NewPan: integer);
    function GetPan: integer;

    function GetPanMax: integer;
    function GetPanMin: integer;
    function GetPanIni: integer;

    procedure SetFrequence(NewFrequence: integer);
    function GetFrequence: integer;

    function GetFrequenceMax: integer;
    function GetFrequenceIni: integer;
    function GetFrequenceMin: integer;

    function GetChannelState: integer;

    {effects}
    procedure AppliquerChorus;
    procedure RetirerChorus;

    procedure AppliquerCompressor;
    procedure RetirerCompressor;

    procedure AppliquerDistortion;
    procedure RetirerDistortion;

    procedure AppliquerEcho;
    procedure RetirerEcho;

    procedure AppliquerFlanger;
    procedure RetirerFlanger;

    procedure AppliquerGargle;
    procedure RetirerGargle;

    procedure AppliquerParamEQLow;
    procedure RetirerParamEQLow;

    procedure AppliquerParamEQMed;
    procedure RetirerParamEQMed;

    procedure AppliquerParamEQHigh;
    procedure RetirerParamEQHigh;

    procedure AppliquerReverb;
    procedure RetirerReverb;


    procedure SetCompressor(fGain: float);

    procedure SetParamEQLow(fGain: float);
    procedure SetParamEQMed(fGain: float);
    procedure SetParamEQHigh(fGain: float);

    procedure SetFlanger(fWetDryMix: float; fDepth: float; fFeedback: float;
      fFrequency: float; lWaveform: Dword; fDelay: float; lPhase: Dword);

    procedure SetChorus(fWetDryMix: float; fDepth: float; fFeedback: float;
      fFrequency: float; lWaveform: DWORD; fDelay: float; lPhase: DWORD);

    procedure SetDistortion(fGain: float; fEdge: float; fPostEQCenterFrequency: float;
      fPostEQBandwidth: float; fPreLowpassCutoff: float);

    procedure SetGargle(dwRateHz: Dword; dwWaveShape: DWORD);


    function GetMaxChorusWetDryMix: float;
    function GetMaxChorusDepth: float;
    function GetMaxChorusFeedback: float;
    function GetMaxChorusFrquency: float;
    function GetMaxChorusDelay: float;

    function GetMinChorusWetDryMix: float;
    function GetMinChorusDepth: float;
    function GetMinChorusFeedback: float;
    function GetMinChorusFrquency: float;
    function GetMinChorusDelay: float;

    function GetIniChorusWetDryMix: float;
    function GetIniChorusDepth: float;
    function GetIniChorusFeedback: float;
    function GetIniChorusFrquency: float;
    function GetIniChorusDelay: float;

    function GetMaxFlangerWetDryMix: float;
    function GetMaxFlangerDepth: float;
    function GetMaxFlangerFeedback: float;
    function GetMaxFlangerFrquency: float;
    function GetMaxFlangerDelay: float;

    function GetMinFlangerWetDryMix: float;
    function GetMinFlangerDepth: float;
    function GetMinFlangerFeedback: float;
    function GetMinFlangerFrquency: float;
    function GetMinFlangerDelay: float;

    function GetIniFlangerWetDryMix: float;
    function GetIniFlangerDepth: float;
    function GetIniFlangerFeedback: float;
    function GetIniFlangerFrquency: float;
    function GetIniFlangerDelay: float;

    function GetMaxCompressorGain: float;
    function GetMinCompressorGain: float;
    function GetIniCompressorGain: float;

    function GetMaxParamEQGain: float;
    function GetMinParamEQGain: float;
    function GetIniParamEQGain: float;

    function GetMaxDistortionGain: float;
    function GetMaxDistortionEdge: float;
    function GetMaxDistortionPostEqCenterFrequency: float;
    function GetMaxDistortionPostEqBandwith: float;
    function GetMaxDistortionPreLowpassCutOff: float;

    function GetMinDistortionGain: float;
    function GetMinDistortionEdge: float;
    function GetMinDistortionPostEqCenterFrequency: float;
    function GetMinDistortionPostEqBandwith: float;
    function GetMinDistortionPreLowpassCutOff: float;

    function GetIniDistortionGain: float;
    function GetIniDistortionEdge: float;
    function GetIniDistortionPostEqCenterFrequency: float;
    function GetIniDistortionPostEqBandwith: float;
    function GetIniDistortionPreLowpassCutOff: float;

    function GetMaxGargleDwRateHz: DWORD;
    function GetMinGargleDwRateHz: DWORD;
    function GetIniGargleDwRateHz: DWORD;
  end;

implementation

constructor TSongStream.Create;
begin
  Bass_Init(-1, FREQUENCE_INITIAL, 0, 0, nil);
  volume := VOLUME_INI;
  pan    := PAN_INI;
  frequence := FREQUENCE_INITIAL;
end;

destructor TSongStream.Destroy;
begin
  Bass_StreamFree(stream);
  Bass_Free;
  inherited;
end;

procedure TSongStream.Init(Name: string);
begin
  if (stream <> 0) then
    Bass_StreamFree(stream);
  stream := BASS_StreamCreateFile(False, PChar(Name), 0, 0, 0);
  if (stream = 0) then
    exit;
  nom := ExtractFileName(Name);
  nomComplet := Name;
end;

procedure TSongStream.Play(InDebut: boolean);
begin
  SetAttributes(volume, frequence, pan);
  Bass_ChannelPlay(stream, InDebut);
end;

procedure TSongStream.Stop;
begin
  Bass_ChannelStop(stream);
end;

procedure TSongStream.Pause;
begin
  Bass_ChannelPause(stream);
end;

function TSongStream.GetNom: string;
begin
  Result := nom;
end;

function TSongStream.GetNomComplet: string;
begin
  Result := nomComplet;
end;

function TSongStream.LongueurTotal: dword;
begin
  Result := BASS_ChannelGetLength(stream);
end;

function TSongStream.GetTempsTotal: float;
begin
  Result := BASS_ChannelBytes2Seconds(stream, LongueurTotal);
end;

function TSongStream.GetTempsCurrent: float;
begin
  Result := BASS_ChannelBytes2Seconds(stream, PositionCurrent);
end;


procedure TSongStream.ChangerPosition(NouvellePosition: dword);
begin
  BASS_ChannelSetPosition(stream, NouvellePosition);
end;

function TSongStream.PositionCurrent: dword;
begin
  Result := BASS_ChannelGetPosition(stream);
end;

procedure TSongStream.SetVolume(NewVolume: integer);
begin
  volume := NewVolume;
  if (volume > VOLUME_MIN) and (volume < VOLUME_MAX) then
    SetAttributes(volume, frequence, pan);
end;

function TSongStream.GetVolume: integer;
begin
  Result := volume;
end;

function TSongStream.GetVolumeMax: integer;
begin
  Result := VOLUME_MAX;
end;

function TSongStream.GetVolumeMin: integer;
begin
  Result := VOLUME_MIN;
end;

procedure TSongStream.SetPan(NewPan: integer);
begin
  pan := NewPan;
  if (pan > PAN_MIN) and (pan < PAN_MAX) then
    SetAttributes(volume, frequence, pan);
end;

function TSongStream.GetPan: integer;
begin
  Result := pan;
end;

function TSongStream.GetPanMax: integer;
begin
  Result := PAN_MAX;
end;

function TSongStream.GetPanMin: integer;
begin
  Result := PAN_MIN;
end;

function TSongStream.GetPanIni: integer;
begin
  Result := PAN_INI;
end;

procedure TSongStream.SetFrequence(NewFrequence: integer);
begin
  frequence := NewFrequence;
  if (frequence > FREQUENCE_MIN) and (frequence < FREQUENCE_MAX) then
    SetAttributes(volume, frequence, pan);
end;

function TSongStream.GetFrequence: integer;
begin
  Result := frequence;
end;

function TSongStream.GetFrequenceMax: integer;
begin
  Result := FREQUENCE_MAX;
end;

function TSongStream.GetFrequenceIni: integer;
begin
  Result := FREQUENCE_INITIAL;
end;

function TSongStream.GetFrequenceMin: integer;
begin
  Result := FREQUENCE_MIN;
end;

procedure TSongStream.SetAttributes(volume, frequence, pan: integer);
begin
  BASS_ChannelSetAttributes(stream, frequence, volume, pan);
end;

procedure TSongStream.AppliquerChorus;
begin
  fx[CHORUS] := BASS_ChannelSetFX(stream, BASS_FX_CHORUS, 0);
end;

procedure TSongStream.RetirerChorus;
begin
  BASS_ChannelRemoveFX(stream, fx[CHORUS]);
end;

procedure TSongStream.AppliquerCompressor;
begin
  fx[COMPRESSOR] := BASS_ChannelSetFX(stream, BASS_FX_COMPRESSOR, 0);
end;

procedure TSongStream.RetirerCompressor;
begin
  BASS_ChannelRemoveFX(stream, fx[COMPRESSOR]);
end;

procedure TSongStream.AppliquerDistortion;
begin
  fx[DISTORTION] := BASS_ChannelSetFX(stream, BASS_FX_DISTORTION, 0);
end;

procedure TSongStream.RetirerDistortion;
begin
  BASS_ChannelRemoveFX(stream, fx[DISTORTION]);
end;

procedure TSongStream.AppliquerEcho;
begin
  fx[ECHO] := BASS_ChannelSetFX(stream, BASS_FX_ECHO, 0);
end;

procedure TSongStream.RetirerEcho;
begin
  BASS_ChannelRemoveFX(stream, fx[ECHO]);
end;

procedure TSongStream.AppliquerFlanger;
begin
  fx[FLANGER] := BASS_ChannelSetFX(stream, BASS_FX_FLANGER, 0);
end;

procedure TSongStream.RetirerFlanger;
begin
  BASS_ChannelRemoveFX(stream, fx[FLANGER]);
end;


procedure TSongStream.AppliquerGargle;
begin
  fx[GARGLE] := BASS_ChannelSetFX(stream, BASS_FX_GARGLE, 0);
end;

procedure TSongStream.RetirerGargle;
begin
  BASS_ChannelRemoveFX(stream, fx[GARGLE]);
end;

procedure TSongStream.AppliquerParamEQLow;
begin
  fx[PARAMEQLOW] := BASS_ChannelSetFX(stream, BASS_FX_PARAMEQ, 0);
  BASS_FXGetParameters(fx[PARAMEQLOW], @pq);
  pq.fGain      := 0;
  pq.fCenter    := 80;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQLOW], @pq);

end;

procedure TSongStream.RetirerParamEQLow;
begin
  BASS_ChannelRemoveFX(stream, fx[PARAMEQLOW]);
end;

procedure TSongStream.AppliquerParamEQMed;
begin
  fx[PARAMEQMED] := BASS_ChannelSetFX(stream, BASS_FX_PARAMEQ, 0);
  BASS_FXGetParameters(fx[PARAMEQMED], @pq);
  pq.fGain      := 0;
  pq.fCenter    := 5000;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQMED], @pq);
end;

procedure TSongStream.RetirerParamEQMed;
begin
  BASS_ChannelRemoveFX(stream, fx[PARAMEQMED]);
end;

procedure TSongStream.AppliquerParamEQHigh;
begin
  fx[PARAMEQHIGH] := BASS_ChannelSetFX(stream, BASS_FX_PARAMEQ, 0);
  BASS_FXGetParameters(fx[PARAMEQHIGH], @pq);
  pq.fGain      := 0;
  pq.fCenter    := 12000;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQHIGH], @pq);
end;

procedure TSongStream.RetirerParamEQHigh;
begin
  BASS_ChannelRemoveFX(stream, fx[PARAMEQHIGH]);
end;

procedure TSongStream.AppliquerReverb;
begin
  fx[REVERB] := BASS_ChannelSetFX(stream, BASS_FX_REVERB, 0);
end;

procedure TSongStream.RetirerReverb;
begin
  BASS_ChannelRemoveFX(stream, fx[REVERB]);
end;

procedure TSongStream.SetFlanger(fWetDryMix: float; fDepth: float; fFeedback: float;
  fFrequency: float; lWaveform: Dword; fDelay: float; lPhase: Dword);
begin
  BASS_FXGetParameters(fx[FLANGER], @fL);
  if (fWetDryMix > FLANGER_MIN_WET_DRY_MIX) and
    (fWetDryMix < FLANGER_MAX_WET_DRY_MIX) then
    fL.fWetDryMix := fWetDryMix;
  if (fDepth > FLANGER_MIN_DEPTH) and (fDepth < FLANGER_MAX_DEPTH) then
    fl.fDepth := fDepth;
  if (fFeedback > FLANGER_MIN_FEEDBACK) and (fFeedback < FLANGER_MAX_FEEDBACK) then
    fl.fFeedback := fFeedback;

  if (fFrequency > FLANGER_MIN_FEEDBACK) and (fFrequency < FLANGER_MAX_FEEDBACK) then
    fl.fFrequency := fFrequency;
  fl.lWaveform := lWaveform;
  if (fDelay > FLANGER_MIN_DELAY) and (fDelay < FLANGER_MAX_DELAY) then
    fl.fDelay := fDelay;
  fl.lPhase := lPhase;
  BASS_FXSetParameters(fx[FLANGER], @fL);
end;

procedure TSongStream.SetCompressor(fGain: float);
begin
  BASS_FXGetParameters(fx[COMPRESSOR], @co);
  if (fGain > COMPRESSOR_MIN_GAIN) and (fGain < COMPRESSOR_MAX_GAIN) then
    co.fGain := fGain;
  BASS_FXSetParameters(fx[COMPRESSOR], @co);
end;

procedure TSongStream.SetParamEQLow(fGain: float);
begin
  BASS_FXGetParameters(fx[PARAMEQLOW], @pq);
  if (fGain > PARAMEQ_MIN_GAIN) and (fGain < PARAMEQ_MAX_GAIN) then
    pq.fGain := fGain;
  pq.fCenter := 80;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQLOW], @pq);

end;

procedure TSongStream.SetParamEQMed(fGain: float);
begin
  BASS_FXGetParameters(fx[PARAMEQMED], @pq);
  if (fGain > PARAMEQ_MIN_GAIN) and (fGain < PARAMEQ_MAX_GAIN) then
    pq.fGain := fGain;
  pq.fCenter := 5000;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQMED], @pq);
end;

procedure TSongStream.SetParamEQHigh(fGain: float);
begin
  BASS_FXGetParameters(fx[PARAMEQHIGH], @pq);
  if (fGain > PARAMEQ_MIN_GAIN) and (fGain < PARAMEQ_MAX_GAIN) then
    pq.fGain := fGain;
  pq.fCenter := 12000;
  pq.fBandwidth := 30;
  BASS_FXSetParameters(fx[PARAMEQHIGH], @pq);
end;

procedure TSongStream.SetChorus(fWetDryMix: float; fDepth: float; fFeedback: float;
  fFrequency: float; lWaveform: DWORD; fDelay: float; lPhase: DWORD);
begin
  BASS_FXGetParameters(fx[CHORUS], @ch);
  if (fWetDryMix > CHORUS_MIN_WET_DRY_MIX) and
    (fWetDryMix < CHORUS_MAX_WET_DRY_MIX) then
    ch.fWetDryMix := fWetDryMix;
  if (fDepth > CHORUS_MIN_DEPTH) and (fDepth < CHORUS_MAX_DEPTH) then
    ch.fDepth := fDepth;
  if (fFeedback > CHORUS_MIN_FEEDBACK) and (fFeedback < CHORUS_MAX_FEEDBACK) then
    ch.fFeedback := fFeedback;

  if (fFrequency > CHORUS_MIN_FEEDBACK) and (fFrequency < CHORUS_MAX_FEEDBACK) then
    ch.fFrequency := fFrequency;
  ch.lWaveform := lWaveform;
  if (fDelay > CHORUS_MIN_DELAY) and (fDelay < CHORUS_MAX_DELAY) then
    ch.fDelay := fDelay;
  ch.lPhase := lPhase;

  BASS_FXSetParameters(fx[CHORUS], @ch);
end;

procedure TSongStream.SetDistortion(fGain: float; fEdge: float; fPostEQCenterFrequency: float;
  fPostEQBandwidth: float; fPreLowpassCutoff: float);
begin
  BASS_FXGetParameters(fx[DISTORTION], @di);
  if (fGain > DISTORTION_MIN_GAIN) and (fGain < DISTORTION_MAX_GAIN) then
    di.fGain := fGain;

  if (fEdge > DISTORTION_MIN_EDGE) and (fEdge < DISTORTION_MAX_EDGE) then
    di.fEdge := fEdge;

  if (fPostEQCenterFrequency > DISTORTION_MIN_POST_EQ_CENTER_FREQUENCY) and
    (fPostEQCenterFrequency < DISTORTION_MAX_POST_EQ_CENTER_FREQUENCY) then
    di.fPostEQCenterFrequency := fPostEQCenterFrequency;
  if (fPostEQBandwidth > DISTORTION_MIN_POST_EQ_BANDWITH) and
    (fPostEQBandwidth < DISTORTION_MAX_POST_EQ_BANDWITH) then
    di.fPostEQBandwidth := fPostEQBandwidth;
  if (fPreLowpassCutoff > DISTORTION_MIN_PRE_LOWPASS_CUT_OFF) and
    (fPreLowpassCutoff < DISTORTION_MAX_PRE_LOWPASS_CUT_OFF) then
    di.fPreLowpassCutoff := fPreLowpassCutoff;
  BASS_FXSetParameters(fx[DISTORTION], @di);
end;

procedure TSongStream.SetGargle(dwRateHz: Dword; dwWaveShape: DWORD);
begin
  BASS_FXGetParameters(fx[GARGLE], @ga);
  if (dwRateHz > GARGLE_MIN_DW_RATE_HZ) and (dwRateHz < GARGLE_MAX_DW_RATE_HZ) then
    ga.dwRateHz := dwRateHz;
  ga.dwWaveShape := dwWaveShape;
  BASS_FXSetParameters(fx[GARGLE], @ga);
end;

function TSongStream.GetMaxChorusWetDryMix: float;
begin
  Result := CHORUS_MAX_WET_DRY_MIX;
end;

function TSongStream.GetMaxChorusDepth: float;
begin
  Result := CHORUS_MAX_DEPTH;
end;

function TSongStream.GetMaxChorusFeedback: float;
begin
  Result := CHORUS_MAX_FEEDBACK;
end;

function TSongStream.GetMaxChorusFrquency: float;
begin
  Result := CHORUS_MAX_FREQUENCY;
end;

function TSongStream.GetMaxChorusDelay: float;
begin
  Result := CHORUS_MAX_DELAY;
end;

function TSongStream.GetMinChorusWetDryMix: float;
begin
  Result := CHORUS_MIN_WET_DRY_MIX;
end;

function TSongStream.GetMinChorusDepth: float;
begin
  Result := CHORUS_MIN_DEPTH;
end;

function TSongStream.GetMinChorusFeedback: float;
begin
  Result := CHORUS_MIN_FEEDBACK;
end;

function TSongStream.GetMinChorusFrquency: float;
begin
  Result := CHORUS_MIN_FREQUENCY;
end;

function TSongStream.GetMinChorusDelay: float;
begin
  Result := CHORUS_MIN_DELAY;
end;

function TSongStream.GetIniChorusWetDryMix: float;
begin
  Result := CHORUS_INI_WET_DRY_MIX;
end;

function TSongStream.GetIniChorusDepth: float;
begin
  Result := CHORUS_INI_DEPTH;
end;

function TSongStream.GetIniChorusFeedback: float;
begin
  Result := CHORUS_INI_FEEDBACK;
end;

function TSongStream.GetIniChorusFrquency: float;
begin
  Result := CHORUS_INI_FREQUENCY;
end;

function TSongStream.GetIniChorusDelay: float;
begin
  Result := CHORUS_INI_DELAY;
end;

function TSongStream.GetMaxFlangerWetDryMix: float;
begin
  Result := FLANGER_MAX_WET_DRY_MIX;
end;

function TSongStream.GetMaxFlangerDepth: float;
begin
  Result := FLANGER_MAX_DEPTH;
end;

function TSongStream.GetMaxFlangerFeedback: float;
begin
  Result := FLANGER_MAX_FEEDBACK;
end;

function TSongStream.GetMaxFlangerFrquency: float;
begin
  Result := FLANGER_MAX_FREQUENCY;
end;

function TSongStream.GetMaxFlangerDelay: float;
begin
  Result := FLANGER_MAX_DELAY;
end;

function TSongStream.GetMinFlangerWetDryMix: float;
begin
  Result := FLANGER_MIN_WET_DRY_MIX;
end;

function TSongStream.GetMinFlangerDepth: float;
begin
  Result := FLANGER_MIN_DEPTH;
end;

function TSongStream.GetMinFlangerFeedback: float;
begin
  Result := FLANGER_MIN_FEEDBACK;
end;

function TSongStream.GetMinFlangerFrquency: float;
begin
  Result := FLANGER_MIN_FREQUENCY;
end;

function TSongStream.GetMinFlangerDelay: float;
begin
  Result := FLANGER_MIN_DELAY;
end;

function TSongStream.GetIniFlangerWetDryMix: float;
begin
  Result := FLANGER_INI_WET_DRY_MIX;
end;

function TSongStream.GetIniFlangerDepth: float;
begin
  Result := FLANGER_INI_DEPTH;
end;

function TSongStream.GetIniFlangerFeedback: float;
begin
  Result := FLANGER_INI_FEEDBACK;
end;

function TSongStream.GetIniFlangerFrquency: float;
begin
  Result := FLANGER_INI_FREQUENCY;
end;

function TSongStream.GetIniFlangerDelay: float;
begin
  Result := FLANGER_INI_DELAY;
end;

function TSongStream.GetMaxCompressorGain: float;
begin
  Result := COMPRESSOR_MAX_GAIN;
end;

function TSongStream.GetMinCompressorGain: float;
begin
  Result := COMPRESSOR_MIN_GAIN;
end;

function TSongStream.GetIniCompressorGain: float;
begin
  Result := COMPRESSOR_INI_GAIN;
end;

function TSongStream.GetMaxParamEQGain: float;
begin
  Result := PARAMEQ_MAX_GAIN;
end;

function TSongStream.GetMinParamEQGain: float;
begin
  Result := PARAMEQ_MIN_GAIN;
end;

function TSongStream.GetIniParamEQGain: float;
begin
  Result := PARAMEQ_INI_GAIN;
end;

function TSongStream.GetMaxDistortionGain: float;
begin
  Result := DISTORTION_MAX_GAIN;
end;

function TSongStream.GetMaxDistortionEdge: float;
begin
  Result := DISTORTION_MAX_EDGE;
end;

function TSongStream.GetMaxDistortionPostEqCenterFrequency: float;
begin
  Result := DISTORTION_MAX_POST_EQ_CENTER_FREQUENCY;
end;

function TSongStream.GetMaxDistortionPostEqBandwith: float;
begin
  Result := DISTORTION_MAX_POST_EQ_BANDWITH;
end;

function TSongStream.GetMaxDistortionPreLowpassCutOff: float;
begin
  Result := DISTORTION_MAX_PRE_LOWPASS_CUT_OFF;
end;

function TSongStream.GetMinDistortionGain: float;
begin
  Result := DISTORTION_MIN_GAIN;
end;

function TSongStream.GetMinDistortionEdge: float;
begin
  Result := DISTORTION_MIN_EDGE;
end;

function TSongStream.GetMinDistortionPostEqCenterFrequency: float;
begin
  Result := DISTORTION_MIN_POST_EQ_CENTER_FREQUENCY;
end;

function TSongStream.GetMinDistortionPostEqBandwith: float;
begin
  Result := DISTORTION_MIN_POST_EQ_BANDWITH;
end;

function TSongStream.GetMinDistortionPreLowpassCutOff: float;
begin
  Result := DISTORTION_MIN_PRE_LOWPASS_CUT_OFF;
end;

function TSongStream.GetIniDistortionGain: float;
begin
  Result := DISTORTION_INI_GAIN;
end;

function TSongStream.GetIniDistortionEdge: float;
begin
  Result := DISTORTION_INI_EDGE;
end;

function TSongStream.GetIniDistortionPostEqCenterFrequency: float;
begin
  Result := DISTORTION_INI_POST_EQ_CENTER_FREQUENCY;
end;

function TSongStream.GetIniDistortionPostEqBandwith: float;
begin
  Result := DISTORTION_INI_POST_EQ_BANDWITH;
end;

function TSongStream.GetIniDistortionPreLowpassCutOff: float;
begin
  Result := DISTORTION_INI_PRE_LOWPASS_CUT_OFF;
end;

function TSongStream.GetMaxGargleDwRateHz: DWORD;
begin
  Result := GARGLE_MAX_DW_RATE_HZ;
end;

function TSongStream.GetMinGargleDwRateHz: DWORD;
begin
  Result := GARGLE_MIN_DW_RATE_HZ;
end;

function TSongStream.GetIniGargleDwRateHz: DWORD;
begin
  Result := GARGLE_INI_DW_RATE_HZ;
end;

function TSongStream.GetChannelState: integer;
begin
  Result := BASS_ChannelIsActive(stream);
end;

end.
