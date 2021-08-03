unit UAllTypes;

interface
uses
  Graphics;
const
  Eletters = ['A'..'Z','a'..'z'];
  Numbers = ['0'..'9'];
type
  // Стек
  TSPStek = ^TMyStek;
  TMyStek = record
                El:String[6];
                ADR:TSPStek;
             end;
  // Динамический массив, куда складываем токены
  TArr = array of string;
  //TArr1 = array[1..30] of string[5];
  Canvas = TCanvas;

  //Выходы из логических элементов
  TSPPin = ^TTPin;
  TPin = record
           ID:Integer;
           X:Integer;   // Расположение точки из логического элемента
           Y:Integer;
           AdrConnect:TSPPin;
         end;
  TTPin = record
            INF:TPin;
            AdrNext:TSPPin;
          end;

  TLogEl = (LEnot,LEand,LEor,LExor,LEnand,LEnor,LEnxor);

  TItemStat = (stNormal, stSelected);
  // Расположение логических элементов
  TElement = record
           ID:Integer;
           X1:Integer;
           Y1:Integer;
           X2:Integer;
           Y2:Integer;
           LogEl:TLogEl;
           State:TItemStat;
           Pin:TSPPin;
          end;
  TSPElement = ^TTElement;
  TTElement = record
           INF:TElement;
           AdrNext:TSPElement;
           AdrPrev:TSPElement;
          end;

 { TElementSave = record
            ID:Integer;
            X1:Integer;
            Y1:Integer;
            X2:Integer;
            Y2:Integer;
            LogEl:TLogEl;
            State:TItemStat;
            Pinnumb:Integer;
            SlArr:TArr1;
           end;
  TSPElementSave = ^TTElementSave;
  TTElementSave = record
            INF:TElementSave;
            AdrNext:TSPElementSave;
            AdrPrev:TSPElementSave;
           end;

  TPinSave = record
            ID:Integer;
            X:Integer;
            Y:Integer;
            LogElConnect:Integer;
            PinConnect:Integer;
           end;
  TSPPinSave = ^TTPinSave;
  TTPinSave = record
            INF:TPinSave;
            AdrNext:TSPPinSave;
           end;}

var
  HeadEl, TempEl:TSPElement;
  imgClientWidth, imgClientHeight : Integer;
  BlockH : Integer = 40;
  BlockW : Integer = 20;
  idEl:Integer;
    
implementation

end.
 