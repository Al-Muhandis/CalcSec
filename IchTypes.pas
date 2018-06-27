unit IchTypes;

interface

  {���������� �����, ����� ��� �������� � ������� ��������}

type
  TSection = 0..16;
  TLoadRegime = (lrContinuous,lrIntermittent,lrShortTerm30,lrShortTerm60);
  TTemperature = Word;
  TMtlCover = Boolean;
  TCoreCount = (ccSingle,ccDouble,ccThreeFour);
  THeavyLaying = Boolean;
  TIsolMaterial = (imNone,imPVC,imRbr,imHeatResPVC,imHeatResRbr,imButylRbr,
    imLacquarClth,imAsbestosClth,imLacquarGls,imEthlnPrplnRbr,imPolytheneOfNStr,
    imMineral,imSiliconeRbr,imOrgSiliconeRbr,imPolythene);
  TIsolMaterials = set of TIsolMaterial;

const
  Sections: packed array[TSection] of Single = (1,1.5,2.5,4,6,10,16,25,35,50,70,
    95,120,150,185,240,300);
  IsolMaterials: packed array[TIsolMaterial] of String = ('��������������',
    '���������������','������','��������������� ������������',
    '������ ������������','��������� ������','���������','������������',
    '����������','������������������ ������','���������� �������� ���������',
    '����������� ��������','����������� ������','������������������� ������',
    '�������������� ��������');
  IsolMtrlMaxTemps: packed array[TIsolMaterial] of TTemperature =
    ($00,60,60,75,75,80,80,85,85,85,85,95,95,85,70);
  LoadRegimes: packed array[TLoadRegime] of String = ('���������� ��������',
    '��������-��������������� ��40%','��������������� ������ 30 ���',
    '��������������� ������ 60 ���');

implementation

end.
