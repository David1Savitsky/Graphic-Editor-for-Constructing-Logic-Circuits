unit UAllTypes;

interface
const
  Eletters = ['A'..'Z','a'..'z'];
type
  // ����
  TSPStek = ^TMyStek;
  TMyStek = record
                El:String[6];
                ADR:TSPStek;
             end;
  // ������������ ������, ���� ���������� ������
  TArr = array of string;
implementation

end.
 