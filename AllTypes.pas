unit UAllTypes;

interface
const
  Eletters = ['A'..'Z','a'..'z'];
type
  // Стек
  TSPStek = ^TMyStek;
  TMyStek = record
                El:String[6];
                ADR:TSPStek;
             end;
  // Динамический массив, куда складываем токены
  TArr = array of string;
implementation

end.
 