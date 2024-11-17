program CalcSec;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, CalcSecFrm
  ;

{$R CalcSec.res}
{$R calcsec_icon.rc}

begin
  Application.Title:='Выбор кабеля по нагрузке';
  Application.Initialize;
  Application.CreateForm(TFrm, Frm);
  Application.Run;
end.

