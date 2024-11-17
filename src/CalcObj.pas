unit CalcObj;

{$mode objfpc}{$H+}

interface

uses Classes, CalcTypes;


type
  {Объявление типов для базового класса TCalc}
  TOnDigitsChange = procedure of object;
  TOnError = procedure(ErrorIndex: Byte) of object;
  
  { TCalc }
  
  TCalc = class
  private
    FDigits: Byte;
    FCalculated: Boolean;
    function GetCalculated: Boolean;
    function GetDigits: Byte;
    procedure SetDigits(const Value: Byte);
  protected
    OnDigitsChange: TOnDigitsChange;
    function NumToStr(const ANum: Real; ADigits: Byte = $FF): String;
    function StrToNum(const AString: String; out ANum: Real): Byte;
    procedure DoError(const ErrorIndex: Byte);
  public
    OnError:  TOnError;
    constructor Create(ADigits: Byte); dynamic;
    procedure Calculate; virtual;
    property Digits: Byte read GetDigits write SetDigits;
    property Calculated: Boolean read GetCalculated;
  end;

  {Объявление типов для класса TCalcPwrCrnt}
  TValue = (cvPower, cvCurrent, cvVoltage, cvPowerFactor,
    cvCurrentSort, cvPhaseCount, cvDigits);
  TValues = set of TValue;
  TCurrentSort = (csDC, csAC);
  TPhaseCount = (pcSingle,pcThree);
  TOnCalculate = procedure(ACalculated: TValue) of object;
  {Объявление класса TCalcPwrCrnt}
  TCalcPwrCrnt = class(TCalc)
  private
    FPowerCalc:    Boolean;
    FPower:        Real;
    FCurrent:      Real;
    FVoltage:      Real;
    FPowerFactor:  Real;
    FCurrentSort:  TCurrentSort;
    FPhaseCount:   TPhaseCount;
    function GetCurrent: String;
    procedure SetCurrent(const Value: String);
    function GetPower: String;
    procedure SetPower(const Value: String);
    function GetVoltage: String;
    procedure SetVoltage(const Value: String);
    function GetPowerFactor: String;
    procedure SetPowerFactor(const Value: String);
    function GetCurrentSort: TCurrentSort;
    procedure SetCurrentSort(const Value: TCurrentSort);
    function GetPhaseCount: TPhaseCount;
    procedure SetPhaseCount(const Value: TPhaseCount);
    function GetPowerCalc: Boolean;
    procedure SetPowerCalc(const Value: Boolean);
  protected
    procedure DoCalculate(const ACalculated: TValue); virtual;
  public
    OnCalculate: TOnCalculate;
    constructor Create(AVoltage: Real; ACurrentSort: TCurrentSort;
      APhaseCount: TPhaseCount; ADigits: Byte); reintroduce; overload;
    procedure Calculate; override;
    property EPower: String read GetPower write SetPower;
    property Current: String read GetCurrent write SetCurrent;
    property Voltage: String read GetVoltage write SetVoltage;
    property PowerFactor: String read GetPowerFactor write SetPowerFactor;
    property CurrentSort: TCurrentSort read GetCurrentSort
      write SetCurrentSort;
    property PhaseCount: TPhaseCount read GetPhaseCount write SetPhaseCount;
    property PowerCalc: Boolean read GetPowerCalc write SetPowerCalc;
  end;

  {Объявления для класса TCalcSection}

type
  TSecValue = (cvMarRegister,cvEnvTemp,cvHeavyLaying,cvCable,cvSection,
    cvIsolMaterial,cvCoreMaxTemp,cvNumOfCores,cvLoadRegime,cvMtlCover,
    cvCableCount);
  TOnSecCalculate = procedure(Value: TSecValue) of object;
  {Объявление класса TCalcLoad}
  TCalcSection = class(TCalcPwrCrnt)
  private
    FSectionCalc:  Boolean;
    FMarRegister:  Boolean;
    FEnvTemp:      TTemperature;
    FHeavyLayng:   THeavyLaying;
    FCable:        String;
    FCables:       TStringList;
    FCableMaterials: TStringList;
    FCurrentMaterial: String;
    FCableTemperatures: array of TTemperature;
    FCableCount:   Byte;
    FSection:      TSection;
    FIsolMaterial: TIsolMaterial;
    FCoreMaxTemp:  TTemperature;
    FNumOfCores:   TCoreCount;
    FLoadRegime:   TLoadRegime;
    FMtlCover:     TMtlCover;
    FRealCurrents: packed array[TSection] of Real;
    procedure DoRealCurrentTable;
    function MTable1Col: Byte;
    function MCorrFactor1: Single;
    function MCorrFactor2(ASection: TSection): Single;
    function MCorrFactor3: Single;
    function MCorrFactor4: Single;
    function RTable1Num: Byte;
    function RCorrFactor1(ASection: TSection): Single;
    function RCorrFactor2: Single;
    function GetMarRegister: Boolean;
    procedure SetMarRegister(const Value: Boolean);
    function GetEnvTemp: String;
    procedure SetEnvTemp(const Value: String);
    function GetHeavyLaying: Boolean;
    procedure SetHeavyLaying(const Value: Boolean);
    function GetCable: String;
    procedure SetCable(const Value: String);
    function GetSection: TSection;
    procedure SetSection(const Value: TSection);
    function GetCoreMaxTemp: String;
    procedure SetCoreMaxTemp(const Value: String);
    function GetIsolMaterial: TIsolMaterial;
    procedure SetIsolMaterial(const Value: TIsolMaterial);
    function GetCableCores: TCoreCount;
    procedure SetCableCores(const Value: TCoreCount);
    procedure SetSectionCalc(const Value: Boolean);
    function GetSectionCalc: Boolean;
    function GetLoadRegime: TLoadRegime;
    procedure SetLoadRegime(const Value: TLoadRegime);
    function GetMtlCover: Boolean;
    procedure SetMtlCover(const Value: Boolean);
    procedure SetCableCount(const Value: Byte);
    function GetCableCount: Byte;
    function GetCableTemperatures(Index: Integer): TTemperature;
    procedure SetCableTemperatures(Index: Integer;
      const Value: TTemperature);
  protected
    procedure DoChange(ASecCalculated: TSecValue); reintroduce; overload;
  public
    OnSecCalculate: TOnSecCalculate;
    constructor Create; reintroduce; overload;
    procedure Calculate; override;
    destructor Destroy; override;
    procedure CalcTbl;
    function FindCable(const ACable: String): Boolean;
    function SectionStrings(Index: Byte): String;
    function SectionHighIndex: Byte;
    function LoadRegimeStrings(Index: TLoadRegime): String;
    function IsolMaterialStrings(Index: TIsolMaterial): String;
    function EnvTempStrings(Index: Byte): String;
    function EnvTempsHighIndex: Byte;
    function MaxCoreTempStrings(Index: Byte): String;
    function MaxCoreTempHighIndex: Byte;
    property SectionCalc: Boolean read GetSectionCalc write SetSectionCalc;
    property MarRegister: Boolean read GetMarRegister write SetMarRegister;
    property EnvTemp: String read GetEnvTemp write SetEnvTemp;
    property HeavyLaying: Boolean read GetHeavyLaying write SetHeavyLaying;
    property Cable: String read GetCable write SetCable;
    property CableTemperatures[Index: Integer]: TTemperature
      read GetCableTemperatures write SetCableTemperatures;
    property CableMaterials: TStringList read FCableMaterials
      write FCableMaterials;
    property Cables: TStringList read FCables write FCables;
    property CableCount: Byte read GetCableCount write SetCableCount;
    property CurrentMaterial: String read FCurrentMaterial
      write FCurrentMaterial;
    property Section: TSection read GetSection write SetSection;
    property IsolMaterial: TIsolMaterial read GetIsolMaterial write
      SetIsolMaterial;
    property CoreMaxTemp: String read GetCoreMaxTemp write
      SetCoreMaxTemp;
    property NumOfCores: TCoreCount read GetCableCores write
      SetCableCores;
    property LoadRegime: TLoadRegime read GetLoadRegime write
      SetLoadRegime;
    property MtlCover: Boolean read GetMtlCover write SetMtlCover;
  end;

implementation

uses SysUtils, Tables, EStrConst;

const
  kWInW = 1000;
  MaxNumOfDigits = 7;

{ TCalcSec }

procedure TCalcPwrCrnt.Calculate;
begin
  if PowerCalc then
  begin
    FPower := FVoltage * FCurrent / kWInW;
    if FCurrentSort = csAC then
    begin
      FPower := FPower * FPowerFactor;
      if FPhaseCount = pcThree then
        FPower := FPower * Sqrt(3)
    end;
    DoCalculate(cvPower)
  end
  else begin
    if FVoltage <> 0 then
      FCurrent := FPower * kWInW / FVoltage
    else
      DoError(csEDivByZero);
    if FCurrentSort = csAC then
    begin
      if FPowerFactor <> 0 then
        FCurrent := FCurrent / FPowerFactor
      else
        DoError(csEDivByZero);
      if FPhaseCount = pcThree then
        FCurrent := FCurrent / Sqrt(3)
    end;
    DoCalculate(cvCurrent)
  end;
  FCalculated := True
end;

constructor TCalcPwrCrnt.Create(AVoltage: Real; ACurrentSort: TCurrentSort;
  APhaseCount: TPhaseCount; ADigits: Byte);
begin
  inherited Create(ADigits);
  FPowerCalc := True;
  FPower := 0;
  FCurrent := 0;
  FVoltage := AVoltage;
  FPowerFactor := 1;
  FCurrentSort := ACurrentSort;
  FPhaseCount := APhaseCount
end;

procedure TCalcPwrCrnt.DoCalculate(const ACalculated: TValue);
begin
  if Assigned(OnCalculate) then
    OnCalculate(ACalculated)
end;

procedure TCalc.Calculate;
begin
  FCalculated := True
end;

constructor TCalc.Create(ADigits: Byte);
begin
  FCalculated := False;
  if ADigits <= MaxNumOfDigits then
    FDigits := ADigits
end;

procedure TCalc.DoError(const ErrorIndex: Byte);
begin
  if Assigned(OnError) then
    OnError(ErrorIndex)
end;

function TCalc.GetCalculated: Boolean;
begin
  Result := FCalculated
end;

function TCalcPwrCrnt.GetCurrent: String;
begin
  Result := NumToStr(FCurrent)
end;

function TCalcPwrCrnt.GetCurrentSort: TCurrentSort;
begin
  Result := FCurrentSort
end;

function TCalc.GetDigits: Byte;
begin
  Result := FDigits
end;

function TCalcPwrCrnt.GetPhaseCount: TPhaseCount;
begin
  Result := FPhaseCount
end;

function TCalcPwrCrnt.GetPower: String;
begin
  Result := NumToStr(FPower)
end;

function TCalcPwrCrnt.GetPowerCalc: Boolean;
begin
  Result := FPowerCalc
end;

function TCalcPwrCrnt.GetPowerFactor: String;
begin
  Result := NumToStr(FPowerFactor,2)
end;

function TCalcPwrCrnt.GetVoltage: String;
begin
  Result := NumToStr(FVoltage,0)
end;

function TCalc.NumToStr(const ANum: Real; ADigits: Byte = $FF): String;
begin
  if ADigits = $FF then
    ADigits := FDigits;
  Result := FloatToStrF(ANum,ffFixed,14,ADigits)
end;

procedure TCalcPwrCrnt.SetCurrent(const Value: String);
var
  AError: Byte;
begin
  AError := StrToNum(Value,FCurrent);
  if AError <> 0 then DoError(AError)
end;

procedure TCalcPwrCrnt.SetCurrentSort(const Value: TCurrentSort);
begin
  FCurrentSort := Value;
  FCalculated := False
end;

procedure TCalc.SetDigits(const Value: Byte);
begin
  if Value <= MaxNumOfDigits then
      FDigits := Value
  else
    DoError(csETooBigDigitCount);
  if Assigned(OnDigitsChange) then OnDigitsChange
end;

procedure TCalcPwrCrnt.SetPhaseCount(const Value: TPhaseCount);
begin
  FPhaseCount := Value;
  FCalculated := False
end;

procedure TCalcPwrCrnt.SetPower(const Value: String);
var
  AError: Byte;
begin
  AError := StrToNum(Value,FPower);
  if AError <> 0 then
    DoError(AError)
end;

procedure TCalcPwrCrnt.SetPowerCalc(const Value: Boolean);
begin
  FPowerCalc := Value
end;

procedure TCalcPwrCrnt.SetPowerFactor(const Value: String);
var
  AError: Byte;
begin
  AError := StrToNum(Value,FPowerFactor);
  if AError <> 0 then DoError(AError)
end;

procedure TCalcPwrCrnt.SetVoltage(const Value: String);
var
  AError: Byte;
begin
  AError := StrToNum(Value,FVoltage);
  if AError <> 0 then
    DoError(AError)
end;

function TCalc.StrToNum(const AString: String; out ANum: Real): Byte;
begin
  Result := 0;
  try
    ANum := StrToFloat(AString)
  except
    on EConvertError do
      Result := csEConvert
  end;
  FCalculated := False
end;

{ TCalcLoad }

function TCalcSection.GetCable: String;
begin
  Result := FCable
end;

function TCalcSection.GetCoreMaxTemp: String;
begin
  Result := NumToStr(FCoreMaxTemp, 0)
end;

function TCalcSection.GetEnvTemp: String;
begin
  Result := NumToStr(FEnvTemp,0)
end;

function TCalcSection.GetIsolMaterial: TIsolMaterial;
begin
  Result := FIsolMaterial
end;

function TCalcSection.GetMarRegister: Boolean;
begin
  Result := FMarRegister
end;

function TCalcSection.GetHeavyLaying: Boolean;
begin
  Result := FHeavyLayng
end;

function TCalcSection.GetSection: TSection;
begin
  Result := FSection
end;



procedure TCalcSection.SetCable(const Value: String);
var
  i: Integer;
begin
  if FindCable(Value) then
  begin
    i := FCables.IndexOf(Value);
    FIsolMaterial := High(TIsolMaterial);
    while not SameText(IsolMaterialStrings(FIsolMaterial),
      FCableMaterials[i]) and (FIsolMaterial <> imNone) do
      Dec(FIsolMaterial);
    if FIsolMaterial = imNone then
      FCurrentMaterial := FCableMaterials[i]
    else
      FCurrentMaterial := IsolMaterialStrings(FIsolMaterial);
    DoChange(cvIsolMaterial);
    FCoreMaxTemp := FCableTemperatures[i];
    DoChange(cvCoreMaxTemp);
    FCable := Value;
    if Copy(Value,1,2) = 'ПВ' then
    begin
      FNumOfCores := ccSingle;
      DoChange(cvNumOfCores)
    end
  end
  else
    DoError(csECableNotFound)
end;

procedure TCalcSection.SetCoreMaxTemp(const Value: String);
var
  AReal: Real;
  AErrorIndex: Byte;
begin
  AErrorIndex := StrToNum(Value,AReal);
  if AErrorIndex = 0 then
  begin
    FCoreMaxTemp := Trunc(AReal);
    FCable := '';
    DoChange(cvCable);
    FIsolMaterial := imNone;
    DoChange(cvIsolMaterial)
  end
  else
    DoError(AErrorIndex)
end;

procedure TCalcSection.SetEnvTemp(const Value: String);
var
  AReal: Real;
  AErrorIndex: Byte;
begin
  AErrorIndex := StrToNum(Value,AReal);
  if AErrorIndex = 0 then
    FEnvTemp := Trunc(AReal)
  else
    DoError(AErrorIndex)
end;

procedure TCalcSection.SetIsolMaterial(const Value: TIsolMaterial);
begin
  FIsolMaterial := Value;
  if Value <> imNone then
  begin
    FCoreMaxTemp := IsolMtrlMaxTemps[Value];
    DoChange(cvCoreMaxTemp);
    FCable := '';
    DoChange(cvCable)
  end
end;

procedure TCalcSection.SetMarRegister(const Value: Boolean);
begin
  FMarRegister := Value
end;

procedure TCalcSection.SetHeavyLaying(const Value: Boolean);
begin
  FHeavyLayng := Value
end;

procedure TCalcSection.SetSection(const Value: TSection);
begin
  FSection := Value
end;

function TCalcSection.GetCableCores: TCoreCount;
begin
  Result := FNumOfCores
end;

procedure TCalcSection.SetCableCores(const Value: TCoreCount);
begin
  if Copy(FCable,1,2) = 'ПВ' then
    if Value <> ccSingle then
    begin
      FCable := '';
      DoChange(cvCable)
    end;
  FNumOfCores := Value
end;

procedure TCalcSection.SetSectionCalc(const Value: Boolean);
begin
  FSectionCalc := Value;
  if not FSectionCalc then
    PowerCalc := True
end;

function TCalcSection.GetSectionCalc: Boolean;
begin
  Result := FSectionCalc
end;

procedure TCalcSection.Calculate;
var
  SectionCounter: TSection;
begin
  if SectionCalc then
  begin
    inherited Calculate;
    if FCurrent <= FRealCurrents[SectionHighIndex] then
    begin
      SectionCounter := Low(TSection);
      while FCurrent > FRealCurrents[SectionCounter] do
        Inc(SectionCounter);
      FSection := SectionCounter;
      DoChange(cvSection)
    end
    else
      DoError(csETooBigCurrent);
  end
  else begin
    if FSection <= SectionHighIndex then
      FCurrent := FRealCurrents[FSection];
    inherited Calculate;
    DoCalculate(cvCurrent)
  end;
end;

function TCalcSection.MCorrFactor2(ASection: TSection): Single;
begin
  if FLoadRegime = lrContinuous then
    Result := 1
  else
    Result := MTable4[ASection,FLoadRegime,not FMtlCover]
end;

function TCalcSection.GetLoadRegime: TLoadRegime;
begin
  Result := FLoadRegime
end;

procedure TCalcSection.SetLoadRegime(const Value: TLoadRegime);
begin
  FLoadRegime := Value
end;

function TCalcSection.GetMtlCover: Boolean;
begin
  Result := FMtlCover
end;

procedure TCalcSection.SetMtlCover(const Value: Boolean);
begin
  FMtlCover := Value
end;

function TCalcSection.MCorrFactor3: Single;
var
  i,j: Byte;
begin
  j := High(MTable5Rows);
  if FCoreMaxTemp >= MTable5Rows[Low(MTable5Rows)] then
  begin
    while MTable5Rows[j] > FCoreMaxTemp do Dec(j);
    i := Low(MTable5Columns);
    if FEnvTemp <= MTable5Columns[High(MTable5Columns)] then
    begin
      while MTable5Columns[i] < FEnvTemp do
        Inc(i);
      Result := MTable5[j,i]
    end
    else begin
      Result := 0;
      DoError(csETooBigEnvTemp)
    end
  end
  else begin
    Result := 0;
    DoError(csETooSmallCoreTemp)
  end;
end;

function TCalcSection.MCorrFactor1: Single;
begin
  Result := MCorrFactor1Table[FNumOfCores]
end;

function TCalcSection.MTable1Col: Byte;
begin
  Result := High(MTable1Columns);
  if FCoreMaxTemp >= MTable1Columns[Low(MTable1Columns)] then
    while MTable1Columns[Result] > FCoreMaxTemp do Dec(Result)
  else begin
     Result := $FF;
     DoError(csETooSmallCoreTemp)
  end;
end;

constructor TCalcSection.Create;
begin
  inherited Create(380,csAC,pcThree,3);
  FSectionCalc := True;
  FMarRegister := True;
  FEnvTemp := 45;
  FHeavyLayng := False;
  FCable := '';
  FCableCount := 1;
  FSection := 0;
  FIsolMaterial := imNone;
  FCoreMaxTemp := 60;
  FNumOfCores := ccThreeFour;
  FLoadRegime := lrContinuous;
  FMtlCover := False;
  FCables := TStringList.Create;
  FCableMaterials := TStringList.Create
end;

procedure TCalcSection.DoChange(ASecCalculated: TSecValue);
begin
  if Assigned(OnSecCalculate) then
    OnSecCalculate(ASecCalculated)
end;

function TCalcSection.MCorrFactor4: Single;
begin
  if not FHeavyLayng then
    Result := 1
  else
    Result := 0.85
end;

function TCalcSection.RCorrFactor1(ASection: TSection): Single;
begin
  if FLoadRegime = lrContinuous then
    Result := 1
  else
    Result := RTable2[ASection,FLoadRegime,FMtlCover]
end;

function TCalcSection.RCorrFactor2: Single;
var
  i,j: Byte;
begin
  j := High(RTable3Rows);
  if FCoreMaxTemp >= RTable3Rows[Low(RTable3Rows)] then
  begin
    while RTable3Rows[j] > FCoreMaxTemp do Dec(j);
    i := Low(RTable3Columns);
    if FEnvTemp <= RTable3Columns[High(RTable3Columns)] then
      if FEnvTemp <= 40 then
        Result := 1
      else begin
        while RTable3Columns[i] < FEnvTemp do
          Inc(i);
        Result := RTable3[j,i]
      end
    else begin
      Result := 0;
      DoError(csETooBigEnvTemp)
    end;
  end
  else begin
    Result := 0;
    DoError(csETooSmallCoreTemp)
  end
end;

function TCalcSection.RTable1Num: Byte;
begin
  Result := High(RTable1Numbers);
  if FCoreMaxTemp >= RTable1Numbers[Low(RTable1Numbers)] then
    while RTable1Numbers[Result] > FCoreMaxTemp do Dec(Result)
  else begin
     Result := $FF;
     DoError(csETooSmallCoreTemp)
  end;
end;

procedure TCalcSection.DoRealCurrentTable;
var
  SectionCounter: TSection;
  ACorrFactor: Real;
  BufferWord: Word;
begin
  for SectionCounter := Low(TSection) to SectionHighIndex do
    if FMarRegister then
    begin
      ACorrFactor := MCorrFactor1*MCorrFactor2(SectionCounter) * MCorrFactor3
        * MCorrFactor4;
      BufferWord := MTable1Col;
      if BufferWord <> $FF then
        FRealCurrents[SectionCounter] := MTable1[SectionCounter,BufferWord]
          * ACorrFactor * FCableCount
    end
    else begin
      ACorrFactor := RCorrFactor1(SectionCounter)*RCorrFactor2;
      BufferWord := RTable1Num;
      if RTable1Num <> $FF then
        FRealCurrents[SectionCounter] := RTable1[BufferWord,SectionCounter,
          FNumOfCores,FHeavyLayng]*ACorrFactor*FCableCount
    end
end;

procedure TCalcSection.CalcTbl;
begin
  DoRealCurrentTable
end;

function TCalcSection.EnvTempStrings(Index: Byte): String;
begin
  Result:=EmptyStr;
  if FMarRegister then
  begin
    if Index <= High(MTable5Columns) then
      Result := NumToStr(MTable5Columns[Index],0)
  end
  else begin
    if Index <= High(RTable3Columns) then
    begin
      if Index = 0 then
        Result := '40'
      else
        Result := NumToStr(RTable3Columns[Index],0)
    end
  end
end;

function TCalcSection.MaxCoreTempStrings(Index: Byte): String;
begin
  Result:=EmptyStr;
  if FMarRegister then
  begin
    if Index <= High(MTable1Columns) then
      Result := NumToStr(MTable1Columns[Index],0)
  end
  else begin
    if Index <= High(RTable1Numbers) then
      Result := NumToStr(RTable1Numbers[Index],0)
  end

end;

function TCalcSection.EnvTempsHighIndex: Byte;
begin
  if MarRegister then
    Result := High(MTable5Columns)
  else
    Result := High(RTable3Columns)
end;

function TCalcSection.MaxCoreTempHighIndex: Byte;
begin
  if MarRegister then
    Result := High(MTable1Columns)
  else
    Result := High(RTable1Numbers)
end;

function TCalcSection.SectionStrings(Index: Byte): String;
begin
  Result := FloatToStr(Sections[Index])
end;

function TCalcSection.SectionHighIndex: Byte;
begin
  if FMarRegister then
    Result := High(TSection)
  else
    Result := Pred(High(TSection))
end;

function TCalcSection.IsolMaterialStrings(Index: TIsolMaterial): String;
begin
  Result := IsolMaterials[Index]
end;

function TCalcSection.LoadRegimeStrings(Index: TLoadRegime): String;
begin
  Result := LoadRegimes[Index]
end;

procedure TCalcSection.SetCableCount(const Value: Byte);
begin
  if Value <> 0 then
    FCableCount := Value
  else
    FCableCount := 1
end;

function TCalcSection.GetCableCount: Byte;
begin
  Result := FCableCount
end;

destructor TCalcSection.Destroy;
begin
  FCables.Free;
  FCableMaterials.Free;
  inherited Destroy
end;

function TCalcSection.FindCable(const ACable: String): Boolean;
begin
  Result := FCables.IndexOf(ACable) <> -1
end;

function TCalcSection.GetCableTemperatures(Index: Integer): TTemperature;
begin
  if Index < Length(FCableTemperatures) then
    Result := FCableTemperatures[Index]
  else
    Result := 0
end;

procedure TCalcSection.SetCableTemperatures(Index: Integer;
  const Value: TTemperature);
begin
  if Index >= Length(FCableTemperatures) then
    SetLength(FCableTemperatures, Index + 1);
  FCableTemperatures[Index] := Value
end;

end.
