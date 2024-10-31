unit CalcLoadFrm;

interface

uses
  Forms, CalcObj,
  Controls, ComCtrls, ExtCtrls, Classes, StdCtrls;

type
  TFrmLoad = class(TForm)
    UpDwnDigits: TUpDown;
    EdtDigits: TEdit;
    LblDigits: TLabel;
    GrpBxLoad: TGroupBox;
    EdtPower: TEdit;
    LblPower: TLabel;
    LblCurrent: TLabel;
    CmbBxVoltage: TComboBox;
    LblVoltage: TLabel;
    EdtCurrent: TEdit;
    CmbBxPF: TComboBox;
    LblCos: TLabel;
    LblFi: TLabel;
    RdGrpPhaseCount: TRadioGroup;
    RdGrpCurrentSort: TRadioGroup;
    BtnOK: TButton;
    BtnHelp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imHelpClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EdtPowerChange(Sender: TObject);
    procedure EdtCurrentChange(Sender: TObject);
    procedure CmbBxPFChange(Sender: TObject);
    procedure CmbBxVoltageChange(Sender: TObject);
    procedure RdGrpCurrentSortClick(Sender: TObject);
    procedure RdGrpPhaseCountClick(Sender: TObject);
    procedure EdtDigitsChange(Sender: TObject);
    procedure EdtPowerEnter(Sender: TObject);
    procedure EdtCurrentEnter(Sender: TObject);
    procedure imCloseClick(Sender: TObject);
  private
    CalcObj: TCalcPwrCrnt;
    procedure UpdateCtrl(Value: TValue);
    procedure UpdatePhaseCount(APhaseCount: TPhaseCount);
    procedure UpdateCurrentSort;
  public
    { Public declarations }
  end;

var
  FrmLoad: TFrmLoad;

implementation

{$R *.DFM}

const
  PowerHints: packed array[TCurrentSort] of string =
    ('Мощность нагрузки в килоВаттах','Активная мощность в килоВаттах');
  CurrentHints: packed array[TPhaseCount] of string =
    ('Величина тока в Амперах','Фазный ток в Амперах');
  VoltageHints: packed array[TPhaseCount] of string =
    ('Напряжение в Вольтах','Линейное напряжение в Вольтах');
  HELP_CONTENTS = 3;

procedure TFrmLoad.FormCreate(Sender: TObject);
var
  Ctrls: TValue;
begin
  CalcObj := TCalcPwrCrnt.Create(380,csAC,pcThree,3);
  with CalcObj do
  begin
    OnCalculate := UpdateCtrl
  end;
  for Ctrls := Low(TValue) to High(TValue) do
    UpdateCtrl(Ctrls)
end;

procedure TFrmLoad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CalcObj.Free
end;

procedure TFrmLoad.imHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS,0)
end;

procedure TFrmLoad.BtnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS,0)
end;

procedure TFrmLoad.BtnOKClick(Sender: TObject);
begin
  FrmLoad.Close
end;

procedure TFrmLoad.EdtPowerChange(Sender: TObject);
begin
  with CalcObj do
  begin
    EPower := EdtPower.Text;
    Calculate
  end
end;

procedure TFrmLoad.EdtCurrentChange(Sender: TObject);
begin
  with CalcObj do
  begin
    Current := EdtCurrent.Text;
    Calculate
  end
end;

procedure TFrmLoad.CmbBxPFChange(Sender: TObject);
begin
  with CalcObj do
  begin
    PowerFactor := CmbBxPF.Text;
    Calculate
  end
end;

procedure TFrmLoad.CmbBxVoltageChange(Sender: TObject);
begin
  with CalcObj do
  begin
    Voltage := CmbBxVoltage.Text;
    Calculate
  end
end;

procedure TFrmLoad.RdGrpCurrentSortClick(Sender: TObject);
begin
  UpdateCurrentSort;
  with CalcObj do
  begin
    CurrentSort := TCurrentSort(RdGrpCurrentSort.ItemIndex);
    Calculate
  end
end;

procedure TFrmLoad.RdGrpPhaseCountClick(Sender: TObject);
var
  APhaseCount: TPhaseCount;
begin
  APhaseCount := TPhaseCount(RdGrpPhaseCount.ItemIndex);
  UpdatePhaseCount(APhaseCount);
  with CalcObj do
  begin
    PhaseCount := APhaseCount;
    Calculate
  end
end;

procedure TFrmLoad.EdtDigitsChange(Sender: TObject);
begin
  with CalcObj do
  begin
    Digits := UpDwnDigits.Position;
    Calculate
  end
end;

procedure TFrmLoad.UpdateCtrl(Value: TValue);
begin
  with CalcObj do
    case Value of
      cvPower: EdtPower.Text := EPower;
      cvCurrent: EdtCurrent.Text := Current;
      cvVoltage: CmbBxVoltage.Text := Voltage;
      cvPowerFactor: CmbBxPF.Text := PowerFactor;
      cvCurrentSort:
      begin
        RdGrpCurrentSort.ItemIndex := ord(CurrentSort);
        UpdateCurrentSort
      end;
      cvPhaseCount:
      begin
        RdGrpPhaseCount.ItemIndex := ord(PhaseCount);
        UpdatePhaseCount(PhaseCount)
      end;
      cvDigits: UpDwnDigits.Position := Digits
    end
end;

procedure TFrmLoad.EdtPowerEnter(Sender: TObject);
begin
  CalcObj.PowerCalc := False;
  EdtCurrent.BevelKind := bkTile;
  EdtPower.BevelKind := bkNone
end;

procedure TFrmLoad.EdtCurrentEnter(Sender: TObject);
begin
  CalcObj.PowerCalc := True;
  EdtPower.BevelKind := bkTile;
  EdtCurrent.BevelKind := bkNone
end;

procedure TFrmLoad.UpdatePhaseCount(APhaseCount: TPhaseCount);
begin
  EdtCurrent.Hint := CurrentHints[APhaseCount];
  CmbBxVoltage.Hint := VoltageHints[APhaseCount]
end;

procedure TFrmLoad.UpdateCurrentSort;
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

procedure TFrmLoad.imCloseClick(Sender: TObject);
begin
  Close
end;

end.
