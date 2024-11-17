unit EStrConst;

{$mode objfpc}{$H+}

interface

const
  csETooBigDigitCount = $01;

  csEConvert   =        $09;
  csEInvalidOp =        $0A;
  csEDivByZero =        $0B;

  csETooSmallCoreTemp = $11;
  csETooBigCurrent =    $12;
  csETooBigEnvTemp =    $13;
  csETooBigSection =    $14;
  csEInOut =            $15;
  csECableNotFound =    $16;

function ErrorStrings(ErrorIndex: Byte): String;

implementation

uses
  SysUtils;

function ErrorStrings(ErrorIndex: Byte): String;
begin
  case ErrorIndex of
    csETooBigDigitCount:
      Result := 'Слишком большое количество знаков после запятой';

    csEConvert:   Result := 'Введенное значение не является числом';
    csEInvalidOp: Result := 'Неверные данные для расчета';
    csEDivByZero: Result := 'Это значение не может быть равным нулю';

    csETooSmallCoreTemp: Result :=
      'Недопустимо маленькая максимальная температура жилы';
    csETooBigCurrent:    Result := 'Недопустимо большая нагрузка на кабель';
    csETooBigEnvTemp:    Result :=
      'Слишком высокая температура окружающей среды';
    csETooBigSection:    Result := 'Максимальное сечение кабеля 240 кв.мм';
    csEInOut:            Result := 'Не возможно прочесть файл "Cable.SDB"';
    csECableNotFound:    Result := 'Такого кабеля в базе данных нет';
  else
    Result:=EmptyStr;
  end
end;

end.
