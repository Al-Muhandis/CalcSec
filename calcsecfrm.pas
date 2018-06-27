unit CalcSecFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, StdCtrls,
  ComCtrls, ExtCtrls, Buttons, CalcObj, Menus;

type

  { TFrm }

  TFrm = class(TForm)
    BtnClose: TButton;
    ChckBxMtlCover: TCheckBox;
    CmbBxCable: TComboBox;
    CmbBxEnvTemp: TComboBox;
    CmbBxIsolMaterial: TComboBox;
    CmbBxLoadRegime: TComboBox;
    CmbBxMaxCoreTemp: TComboBox;
    CmbBxPF: TComboBox;
    CmbBxSection: TComboBox;
    CmbBxVoltage: TComboBox;
    EdtCableCount: TEdit;
    EdtCurrent: TEdit;
    EdtDigits: TEdit;
    EdtPower: TEdit;
    GrpBxCable: TGroupBox;
    GrpBxLaying: TGroupBox;
    GrpBxLoad: TGroupBox;
    LblEMail: TLabel;
    LabelMaxCoreTemp: TLabel;
    LblCable: TLabel;
    LblCableCount: TLabel;
    LblCos: TLabel;
    LblCurrent: TLabel;
    LblDigits: TLabel;
    LblEnvTemp: TLabel;
    LblFi: TLabel;
    LblIsolMtrl: TLabel;
    LblLoadRegime: TLabel;
    LblPower: TLabel;
    LblSection: TLabel;
    LblSquare: TLabel;
    LblVoltage: TLabel;
    miCopy: TMenuItem;
    PppMn: TPopupMenu;
    RdGrpCurrentSort: TRadioGroup;
    RdGrpHeavyLaying: TRadioGroup;
    RdGrpNumOfCores: TRadioGroup;
    RdGrpPhaseCount: TRadioGroup;
    RdGrpRegister: TRadioGroup;
    SttsBr: TStatusBar;
    UpDwnCableCount: TUpDown;
    UpDwnDigits: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var BAction: TCloseAction);
    procedure EdtPowerEnter(Sender: TObject);
    procedure EdtCurrentEnter(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure EdtLoadChange(Sender: TObject);
    procedure LblEMailClick(Sender: TObject);
    procedure LblWebMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure miCopyClick(Sender: TObject);
    procedure RdGrpSectionClick(Sender: TObject);
    procedure CmbBxLoadChange(Sender: TObject);
    procedure RdGrpCurrentSortClick(Sender: TObject);
    procedure RdGrpPhaseCountClick(Sender: TObject);
    procedure CmbBxSectionEnter(Sender: TObject);
    procedure CmbBxLoadRegimeChange(Sender: TObject);
    procedure EdtCableCountChange(Sender: TObject);
    procedure CmbBxIsolMaterialChange(Sender: TObject);
    procedure CmbBxCableChange(Sender: TObject);
    procedure CmbBxEnvTempChange(Sender: TObject);
    procedure CmbBxMaxCoreTempChange(Sender: TObject);
    procedure ChckBxMtlCoverClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure CmbBxSectionChange(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
  private
    CalcObj: TCalcSection;
    procedure UpdateLoadCtrl(Value: TValue);
    procedure UpdateCtrl(Value: TSecValue);
    procedure UpdateSecPrpty(Value: TSecValue);
    procedure UpdateLoadPrpty(Value: TValue);
    procedure ErrorProc(ErrorIndex: Byte);
    procedure UpdateCurrentSort;
    procedure UpdatePhaseCount(APhaseCount: TPhaseCount);
    procedure UpdateRegister;
    procedure SetRdGrpRegister;
    procedure CreateCmbBxIsolMaterial;
    procedure CreateCmbBxLoadRegime;
    procedure CreateCmbBxCable;
  public
    { public declarations }
  end; 

var
  Frm: TFrm;

implementation

uses CalcTypes, EStrConst, ClipBrd, Windows;

var
  BufferLabel: TLabel;

const
  PowerHints: packed array[TCurrentSort] of string =
    ('Мощность нагрузки в килоВаттах','Активная мощность в килоВаттах');
  CurrentHints: packed array[TPhaseCount] of string =
    ('Величина тока в Амперах','Фазный ток в Амперах');
  VoltageHints: packed array[TPhaseCount] of string =
    ('Напряжение в Вольтах','Линейное напряжение в Вольтах');
    
procedure TFrm.FormCreate(Sender: TObject);
var
  Ctrl: TValue;
  SecCtrl: TSecValue;
begin
  CalcObj := TCalcSection.Create;
  with CalcObj do
  begin
    SectionCalc := True;
    MarRegister := True;
    EnvTemp := '45';
    HeavyLaying := False;
    Cable := '';
    Section := 1;
    IsolMaterial := imNone;
    CoreMaxTemp := '60';
    NumOfCores := ccThreeFour;
    LoadRegime := lrContinuous;
    MtlCover := False;
    EPower := '0';
    Current := '0';
    Voltage := '380';
    PowerFactor := '1';
    CurrentSort := csAC;
    PhaseCount := pcThree;
    Digits := 3;
    OnSecCalculate := @UpdateCtrl;
    OnCalculate := @UpdateLoadCtrl;
    OnError := @ErrorProc
  end;
  CreateCmbBxIsolMaterial;
  CreateCmbBxLoadRegime;
  CreateCmbBxCable;
  for Ctrl := Low(TValue) to High(TValue) do
    UpdateLoadCtrl(Ctrl);
  for SecCtrl := Low(TSecValue) to High(TSecValue) do
    UpdateCtrl(SecCtrl);
  with CalcObj do
  begin
    CalcTbl;
    Calculate
  end
end;

procedure TFrm.FormClose(Sender: TObject; var BAction: TCloseAction);
begin
  CalcObj.Free
end;

procedure TFrm.EdtPowerEnter(Sender: TObject);
begin
  with CalcObj do
  begin
    SectionCalc := True;
    PowerCalc := False
  end
end;

procedure TFrm.EdtCurrentEnter(Sender: TObject);
begin
  with CalcObj do
  begin
    SectionCalc := True;
    PowerCalc := True
  end
end;

procedure TFrm.BtnCloseClick(Sender: TObject);
begin
  Frm.Close
end;

procedure TFrm.EdtLoadChange(Sender: TObject);
begin
  if Sender = EdtPower then
    UpdateLoadPrpty(cvPower)
  else
    if Sender = EdtCurrent then
      UpdateLoadPrpty(cvCurrent)
    else
      UpdateLoadPrpty(cvDigits)
end;

procedure TFrm.LblEMailClick(Sender: TObject);
begin
  ShellExecute(Handle, nil, 'mailto:SuleymanovR@yandex.ru', nil, nil,
    SW_SHOW)
end;

procedure TFrm.LblWebMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    PppMn.PopUp(Mouse.CursorPos.x, Mouse.CursorPos.y);
    BufferLabel := Sender as TLabel
  end
end;

procedure TFrm.miCopyClick(Sender: TObject);
begin
  Clipboard.AsText := BufferLabel.Caption
end;

procedure TFrm.UpdateCtrl(Value: TSecValue);
begin
  with CalcObj do
    case Value of
      cvMarRegister: SetRdGrpRegister;
      cvEnvTemp: CmbBxEnvTemp.Text := EnvTemp;
      cvHeavyLaying: RdGrpHeavyLaying.ItemIndex := Ord(HeavyLaying);
      cvCable:
        if Cable = '' then
          CmbBxCable.ItemIndex := -1
        else
          CmbBxCable.Text := Cable;
      cvSection: CmbBxSection.ItemIndex := Section;
      cvIsolMaterial: CmbBxIsolMaterial.Text := CurrentMaterial;
      cvCoreMaxTemp: CmbBxMaxCoreTemp.Text := CoreMaxTemp;
      cvNumOfCores: RdGrpNumOfCores.ItemIndex := Ord(NumOfCores);
      cvLoadRegime: CmbBxLoadRegime.ItemIndex := Ord(LoadRegime);
      cvMtlCover: ChckBxMtlCover.Checked := MtlCover;
    end
end;

procedure TFrm.UpdateLoadCtrl(Value: TValue);
begin
  with CalcObj do
    case Value of
      cvPower:       EdtPower.Text := EPower;
      cvCurrent:     EdtCurrent.Text := Current;
      cvVoltage:     CmbBxVoltage.Text := Voltage;
      cvPowerFactor: CmbBxPF.Text := PowerFactor;
      cvCurrentSort:
      begin
        RdGrpCurrentSort.ItemIndex := Ord(CurrentSort);
        UpdateCurrentSort
      end;
      cvPhaseCount:
      begin
        RdGrpPhaseCount.ItemIndex := Ord(PhaseCount);
        UpdatePhaseCount(PhaseCount)
      end;
      cvDigits:      UpDwnDigits.Position := Digits
    end
end;

procedure TFrm.UpdateCurrentSort;
var
  ACurrentSort: TCurrentSort;
begin
  ACurrentSort := TCurrentSort(RdGrpCurrentSort.ItemIndex);
  RdGrpPhaseCount.Enabled := Boolean(ACurrentSort);
  CmbBxPF.Enabled := Boolean(ACurrentSort);
  EdtPower.Hint := PowerHints[ACurrentSort];
  if ACurrentSort = csDC then
    UpdatePhaseCount(pcSingle)
  else
    UpdatePhaseCount(TPhaseCount(RdGrpPhaseCount.ItemIndex))
end;

procedure TFrm.UpdatePhaseCount(APhaseCount: TPhaseCount);
begin
  EdtCurrent.Hint := CurrentHints[APhaseCount];
  CmbBxVoltage.Hint := VoltageHints[APhaseCount]
end;

procedure TFrm.UpdateRegister;
var
  ASection: TSection;
  i: Byte;
begin
  with CalcObj do
  begin
    with CmbBxSection do
    begin
      Items.Clear;
      for ASection := Low(TSection) to SectionHighIndex do
        Items.Add(SectionStrings(ASection));
      if not ((RdGrpRegister.ItemIndex = 0) and
        (Section = High(TSection))) then
        ItemIndex := Section
      else begin
        Section := Pred(High(TSection));
        ItemIndex := Section
      end
    end;
    with CmbBxEnvTemp.Items do
    begin
      Clear;
      for i := 0 to EnvTempsHighIndex do
        Add(EnvTempStrings(i))
    end;
    with CmbBxMaxCoreTemp.Items do
    begin
      Clear;
      for i := 0 to MaxCoreTempHighIndex do
        Add(MaxCoreTempStrings(i))
    end;
  end
end;

procedure TFrm.SetRdGrpRegister;
begin
  RdGrpRegister.ItemIndex := Ord(CalcObj.MarRegister);
  UpdateRegister
end;

procedure TFrm.CreateCmbBxIsolMaterial;
var
  i: TIsolMaterial;
begin
  for i:= Low(TIsolMaterial) to High(TIsolMaterial) do
    CmbBxIsolMaterial.Items.Add(CalcObj.IsolMaterialStrings(i))
end;

procedure TFrm.RdGrpSectionClick(Sender: TObject);
var
  Value: TSecValue;
begin
  if Sender = RdGrpRegister then
    Value := cvMarRegister
  else
    if Sender = RdGrpHeavyLaying then
      Value := cvHeavyLaying
    else
      Value := cvNumOfCores;
  UpdateSecPrpty(Value)
end;

procedure TFrm.CreateCmbBxLoadRegime;
var
  i: TLoadRegime;
begin
  for i:= Low(TLoadRegime) to High(TLoadRegime) do
    CmbBxLoadRegime.Items.Add(CalcObj.LoadRegimeStrings(i))
end;

procedure TFrm.CmbBxLoadChange(Sender: TObject);
begin
  if Sender = CmbBxVoltage then
    UpdateLoadPrpty(cvVoltage)
  else
    UpdateLoadPrpty(cvPowerFactor)
end;

procedure TFrm.RdGrpCurrentSortClick(Sender: TObject);
begin
  UpdateCurrentSort;
  UpdateLoadPrpty(cvCurrentSort)
end;

procedure TFrm.RdGrpPhaseCountClick(Sender: TObject);
var
  APhaseCount: TPhaseCount;
begin
  APhaseCount := TPhaseCount(RdGrpPhaseCount.ItemIndex);
  UpdatePhaseCount(APhaseCount);
  UpdateLoadPrpty(cvPhaseCount)
end;

procedure TFrm.CmbBxSectionEnter(Sender: TObject);
begin
  with CalcObj do
  begin
    SectionCalc := False;
    Calculate
  end
end;

procedure TFrm.CmbBxLoadRegimeChange(Sender: TObject);
begin
  UpdateSecPrpty(cvLoadRegime)
end;


procedure TFrm.EdtCableCountChange(Sender: TObject);
begin
  UpdateSecPrpty(cvCableCount)
end;

procedure TFrm.CmbBxIsolMaterialChange(Sender: TObject);
begin
  UpdateSecPrpty(cvIsolMaterial)
end;

procedure TFrm.CmbBxCableChange(Sender: TObject);
begin
  UpdateSecPrpty(cvCable)
end;

procedure TFrm.CmbBxEnvTempChange(Sender: TObject);
begin
  UpdateSecPrpty(cvEnvTemp)
end;

procedure TFrm.CmbBxMaxCoreTempChange(Sender: TObject);
begin
  UpdateSecPrpty(cvCoreMaxTemp)
end;

procedure TFrm.ErrorProc(ErrorIndex: Byte);
begin
  if ErrorIndex = csETooBigCurrent then
    CmbBxSection.ItemIndex := -1;
  SttsBr.SimpleText := 'Ошибка: ' + ErrorStrings(ErrorIndex)
end;

procedure TFrm.ChckBxMtlCoverClick(Sender: TObject);
begin
  UpdateSecPrpty(cvMtlCover)
end;

procedure TFrm.BtnHelpClick(Sender: TObject);
var
  Path: String;
begin
  Path := ExtractFileDir(Application.ExeName) + '\calcsec.hlp';
  ShellExecute(Handle, nil, PChar(Path), nil, nil,  SW_SHOW)
end;

procedure TFrm.UpdateLoadPrpty(Value: TValue);
begin
  SttsBr.SimpleText := '';
  with CalcObj do
  begin
    case Value of
      cvPower: EPower := EdtPower.Text;
      cvCurrent: Current := EdtCurrent.Text;
      cvVoltage: Voltage := CmbBxVoltage.Text;
      cvPowerFactor: PowerFactor := CmbBxPF.Text;
      cvCurrentSort: CurrentSort := TCurrentSort(RdGrpCurrentSort.ItemIndex);
      cvPhaseCount: PhaseCount := TPhaseCount(RdGrpPhaseCount.ItemIndex);
      cvDigits: Digits := UpDwnDigits.Position;
    end;
    Calculate
  end
end;

procedure TFrm.UpdateSecPrpty(Value: TSecValue);
begin
  SttsBr.SimpleText := '';
  with CalcObj do
  begin
    case Value of
      cvMarRegister:
      begin
        MarRegister := Boolean(RdGrpRegister.ItemIndex);
        UpdateRegister
      end;
      cvEnvTemp: EnvTemp := CmbBxEnvTemp.Text;
      cvHeavyLaying: HeavyLaying := Boolean(RdGrpHeavyLaying.ItemIndex);
      cvCable: Cable := CmbBxCable.Text;
      cvSection: Section := CmbBxSection.ItemIndex;
      cvIsolMaterial:
        IsolMaterial := TIsolMaterial(CmbBxIsolMaterial.ItemIndex);
      cvCoreMaxTemp: CoreMaxTemp := CmbBxMaxCoreTemp.Text;
      cvNumOfCores: NumOfCores := TCoreCount(RdGrpNumOfCores.ItemIndex);
      cvLoadRegime: LoadRegime := TLoadRegime(CmbBxLoadRegime.ItemIndex);
      cvMtlCover: MtlCover := ChckBxMtlCover.Checked;
      cvCableCount: CableCount := UpDwnCableCount.Position
    end;
    if Value <> cvSection then
      CalcTbl;
    Calculate
  end
end;

procedure TFrm.CmbBxSectionChange(Sender: TObject);
begin
  UpdateSecPrpty(cvSection)
end;

procedure TFrm.CreateCmbBxCable;
var
  ACablesDatas, ACableData: TStringList;
  i: Integer;
  S, CableMark: String;
begin
  ACablesDatas := TStringList.Create;
  try
    ACablesDatas.LoadFromFile('Cables.csv');
    ACableData := TStringList.Create;
    try
      for i := 0 to ACablesDatas.Count - 1 do
      begin
        ACableData.Clear;
        S := ACablesDatas.Strings[i];
        ExtractStrings([';'], [' '], PChar(S),
          ACableData);
        CableMark := ACableData.Strings[0];
        CmbBxCable.AddItem(CableMark, nil);
        CalcObj.Cables.Add(CableMark);
        CalcObj.CableMaterials.Add(ACableData.Strings[1]);
        CalcObj.CableTemperatures[i] :=
          StrToIntDef(ACableData.Strings[2], 0)
      end
    finally
      ACableData.Free
    end
  finally
    ACablesDatas.Free
  end
end;

procedure TFrm.EdtKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    ',', '.', '/': Key := DecimalSeparator
  end
end;

initialization
  {$I calcsecfrm.lrs}

finalization

end.

