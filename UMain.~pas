unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  UParseExpr,UAllTypes,UMakePrioritySp, UHelp, Buttons, ActnList, Menus, ImgList,
  ComCtrls, ToolWin, ExtDlgs,Jpeg;

const
  DragSensitivity = 5;

type
  TForm1 = class(TForm)
    pnlBotton: TPanel;
    btnDraw: TButton;
    edtLogExpr: TEdit;
    btnExit: TBitBtn;
    pnlSch: TPanel;
    pbMain: TPaintBox;
    btnAnd: TButton;
    btnOr: TButton;
    btnXor: TButton;
    btnNot: TButton;
    btnnAnd: TButton;
    btnnOr: TButton;
    btnnXor: TButton;
    btnLine: TButton;
    aMain: TActionList;
    ilMain: TImageList;
    actFileNew: TAction;
    actFileImport: TAction;
    actFileExit: TAction;
    actHelp: TAction;
    menuMain: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    //N3: TMenuItem;
    //N4: TMenuItem;
    N5: TMenuItem;
    mniFileImport: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    actHelp1: TMenuItem;
    tlbMain: TToolBar;
    btnFileNew: TToolButton;
    btnFileImport: TToolButton;
    btnHelp: TToolButton;
    dlgImport: TSavePictureDialog;
    dlgSave: TSaveDialog;
    procedure btnDrawClick(Sender: TObject);
   // procedure btnExitClick(Sender: TObject);
    procedure edtLogExprClick(Sender: TObject);
    procedure edtLogExprKeyPress(Sender: TObject; var Key: Char);
    procedure btnAndClick(Sender: TObject);
    procedure pbMainDblClick(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure btnOrClick(Sender: TObject);
    procedure btnXorClick(Sender: TObject);
    procedure btnnAndClick(Sender: TObject);
    procedure btnnOrClick(Sender: TObject);
    procedure btnnXorClick(Sender: TObject);
    procedure btnNotClick(Sender: TObject);
    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure btnLineClick(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure actFileNewExecute(Sender: TObject);
    procedure actFileImportExecute(Sender: TObject);
    //procedure actFileSaveExecute(Sender: TObject);
    //procedure actFileOpenExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);

  private
    //Данные модели
    FSelCount: Integer;       // Счётчик выделенных элементов

    // Данные контроллера
    FMayDrag: Boolean;        // Флаг: зажата левая кнопка мыши (неизвестно, щелчок или перетаскивание)
    FDragging: Boolean;       // Флаг: идёт перетаскивание
    FStartPoint: TPoint;      // Точка, в которой быда нажата кнопка мыши
    FDragDelta: TPoint;       // Смещение от FStartPoint до текущей позиции мыши
    FConnect1: Boolean;        // Флаг: выбираем соединения элементов
    FConnect2: Boolean;        // Флаг: выбираем соединения элементов
    FPin: TSPPin;
    FSlCon: Integer;

    FImage:TPicture;

    //procedure NotOper(X1,Y1,X2,Y2:Integer);overload;
    procedure NotOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure AndOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure OrOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure XorOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure NAndOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure NOrOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure NXorOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
    procedure DrawPin(X1,Y1,X2,Y2:Integer);

    procedure VertLines(Arr:TArr);
    procedure DrawElandPin(HeadEl:TSPElement);

//    procedure NewItem(LE:TLogEl); overload;
    procedure NewItem(Point:TPoint); overload;
    procedure Draw(ACanvas:Tcanvas; IsDragging:Boolean; FDragDelta:TPoint );

    function GetItemIndex(const Point: TPoint): TSPElement;
    function IsItemSelected(Index: TSPElement): Boolean;
    procedure UnselectItems;
    function ToggleItem(Index: TSPElement): Boolean;
    procedure MoveItems(const DragDelta: TPoint);
    procedure DeleteItem(Index:TSPElement);

    procedure HighLightEl(color:TColor);
    function ChooseConnect(const Point:TPoint; var PinConnect:TSPPin):Boolean;
    procedure ConnectPins(Pin1,Pin2:TSPPin);
    function ElConnect(FStartPoint: TPoint; var i: Integer):Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TForm1;
  flg:Boolean = True;
  ArrCopy:TArr;

  LE:TLogEl;

implementation
{$R *.dfm}

procedure TForm1.VertLines(Arr:TArr);
var
  i,x,y:Integer;
  Rect:TRect;
  SlArr:TArr;
begin
  //MainForm.imgMain.Canvas.Pen.Width := 3;
  Rect.Left := 0;
  Rect.Top := 0;
  imgClientWidth := MainForm.pbMain.ClientWidth;
  imgClientHeight := MainForm.pbMain.ClientHeight;
  Rect.Right := MainForm.pbMain.ClientWidth;
  Rect.Bottom := MainForm.pbMain.ClientHeight;
  MainForm.pbMain.Canvas.FillRect(Rect);
  SlArr := MakeSlArr(Arr);
  x := 5;
  y := 10;
  for i := Low(SlArr) to High(SlArr) do
  begin
    MainForm.pbMain.Canvas.TextOut(x+1,y-5,SlArr[i]);
    MainForm.pbMain.Canvas.MoveTo(x,y);
    MainForm.pbMain.Canvas.LineTo(x,MainForm.pbMain.ClientHeight);
    inc(x,10);
  end;
end;

procedure TForm1.NotOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
var
  R:Integer;
begin
  R := (Y2 - Y1) div 5;
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Ellipse(X2-round(R/2),Y2-(round((Y2-Y1)/2)-round(R/2)),X2+round(R/2),Y2-(round((Y2-Y1)/2)+round(R/2)));
    Font.Size:=trunc(sqrt((X2-X1)/5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'1');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.AndOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
begin
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Font.Size:=trunc(sqrt((X2-X1)/3.5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'&');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.OrOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
begin
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Font.Size:=trunc(sqrt((X2-X1)/3.5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'1');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.XorOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
begin
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Font.Size:=trunc(sqrt((X2-X1)/5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'=1');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.NAndOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
var
  R:Integer;
begin
  R := (Y2 - Y1) div 5;
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Ellipse(X2-round(R/2),Y2-(round((Y2-Y1)/2)-round(R/2)),X2+round(R/2),Y2-(round((Y2-Y1)/2)+round(R/2)));
    Font.Size:=trunc(sqrt((X2-X1)/5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'&');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.NOrOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
var
  R:Integer;
begin
  R := (Y2 - Y1) div 5;
  with pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Ellipse(X2-round(R/2),Y2-(round((Y2-Y1)/2)-round(R/2)),X2+round(R/2),Y2-(round((Y2-Y1)/2)+round(R/2)));
    Font.Size:=trunc(sqrt((X2-X1)/5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'1');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.NXorOper(X1,Y1,X2,Y2:Integer;State:TItemStat);
var
  R:Integer;
begin
  R := (Y2 - Y1) div 5;
  with MainForm.pbMain.Canvas do
  begin
    Rectangle(X1,Y1,X2,Y2);
    Ellipse(X2-round(R/2),Y2-(round((Y2-Y1)/2)-round(R/2)),X2+round(R/2),Y2-(round((Y2-Y1)/2)+round(R/2)));
    Font.Size:=trunc(sqrt((X2-X1)/5));
    TextOut(X1 + (X2-X1) div 5,Y1 + (Y2-Y1) div 10,'=1');
    if State = stSelected then
    begin
      Rectangle(X1,    Y1,     X1 + 4, Y1 + 4);
      Rectangle(X1,    Y2 - 4, X1 + 4, Y2    );
      Rectangle(X2 - 4,Y1,     X2,     Y1 + 4);
      Rectangle(X2 - 4,Y2 - 4, X2,     Y2    );
    end;
  end;
end;

procedure TForm1.DrawPin(X1,Y1,X2,Y2:Integer);
var
  dX : Integer;
begin
  with pbMain.Canvas do
  begin
    MoveTo(X1, Y1);
    dX := (X2 - X1) div 7 * 6;
    if Y1 <> Y2 then
    begin
      LineTo(X1 + dX, Y1);
      LineTo(X1 + dx, Y2);
      LineTo(X2, Y2)
    end
    else
      LineTo(X2,Y2);
  end;
end;

procedure TForm1.DrawElandPin(HeadEl:TSPElement);
var
  TempEl:TSPElement;
  HTempPin:TSPPin;
begin
  TempEl := HeadEl;
  while TempEl^.AdrNext <> nil do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      case LogEl of
        LEnot : MainForm.NotOper(X1,Y1,X2,Y2,State);
        LEand : MainForm.AndOper(X1,Y1,X2,Y2,State);
        LEor : MainForm.OrOper(X1,Y1,X2,Y2,State);
        LExor : MainForm.XorOper(X1,Y1,X2,Y2,State);
        LEnand : MainForm.NAndOper(X1,Y1,X2,Y2,State);
        LEnor : MainForm.NOrOper(X1,Y1,X2,Y2,State);
        LEnxor : MainForm.NXorOper(X1,Y1,X2,Y2,State);
      end;
      
      HTempPin := Pin;
      while Pin^.AdrNext <> nil do
      begin
        Pin := Pin^.AdrNext;
        with Pin^.INF do
        begin
          if AdrConnect <> nil then
            MainForm.DrawPin(AdrConnect^.INF.X,AdrConnect^.INF.Y,X,Y)
          else
          begin
            with TempEl^.INF do
            begin
              if (LogEl = LEnot) or (LogEl = LEnxor) or (LogEl = LEnor) or (LogEl = LEnand) then
                pbMain.Canvas.MoveTo(X2+3,(Y2-Y1) div 2 + Y1)
              else
                pbMain.Canvas.MoveTo(X2,(Y2-Y1) div 2 + Y1);
              pbMain.Canvas.LineTo(X2+10,(Y2-Y1) div 2 + Y1);
            end;
          end;
        end;
      end;
      Pin := HTempPin;
    end;
  end;
  {with TempEl^.INF do
  begin
    if (LogEl = LEnot) or (LogEl = LEnxor) or (LogEl = LEnor) or (LogEl = LEnand) then
      pbMain.Canvas.MoveTo(X2+3,(Y2-Y1) div 2 + Y1)
    else
      pbMain.Canvas.MoveTo(X2,(Y2-Y1) div 2 + Y1);
    pbMain.Canvas.LineTo(X2+30,(Y2-Y1) div 2 + Y1);
  end;}
end;

procedure DrawScheme(Arr:Tarr; Wordnumb:Integer);
begin
  MainForm.VertLines(Arr);
  New(HeadEl);
  flg := False;// Чтобы добавление новых объектов прикреплялись к данному списку элементов
  MakePriorSp(Arr,HeadEl);
  MainForm.DrawElandPin(HeadEl);

  //MainForm.NotOper(110,0,130,40);
end;

procedure TForm1.btnDrawClick(Sender: TObject);
var
  s:string;
  Arr:TArr;
  flag:Boolean;
  Wordnumb:Integer;
begin
  s := string(edtLogExpr.Text);
  Arr := ParseExpr(s,flag,Wordnumb);
  ArrCopy := Arr; // Для Добавления элементов
  if flag then
  begin
    DrawScheme(Arr, Wordnumb)                                
  end
  else
    ShowMessage('Invalid Input');
end;

procedure TForm1.edtLogExprClick(Sender: TObject);
begin
  MainForm.edtLogExpr.SelStart := 0;
  MainForm.edtLogExpr.SelLength := length(edtLogExpr.Text)
end;

procedure TForm1.edtLogExprKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13 : btnDraw.Click;
  end;  
end;

procedure TForm1.NewItem(Point:TPoint); 
var
  tmpPrev:TSPElement;
  HTempPin:TSPPin;
begin
  if flg then
  begin
    New(HeadEl);
    HeadEl^.INF.Pin := nil;
    HeadEl^.AdrPrev := nil;
    TempEl := HeadEl;
    flg := False;
    idEl := 1;
  end;

  New(TempEl^.AdrNext);
  tmpPrev := TempEl;
  TempEl := TempEl^.AdrNext;
  TempEl^.AdrNext := nil;
  TempEl^.AdrPrev := tmpPrev;
  //TempEl^.INF.Pin := nil;

  with TempEl^.INF do
  begin
    ID := idEl;
    inc(idEl);
    LogEl := LE;
    X1 := Point.X - BlockW div 2;
    Y1 := Point.Y - BlockH div 2;
    X2 := Point.X + BlockW div 2;
    Y2 := Point.Y + BlockH div 2;

    New(Pin);
    HTempPin := Pin;
    New(Pin^.AdrNext);
    Pin := Pin^.AdrNext;
    if LogEl <> LEnot then
    begin
      Pin^.INF.ID := 1;
      Pin^.INF.X := X1;
      Pin^.INF.Y := (Y2-Y1) div 3 + Y1;
      Pin^.INF.AdrConnect := nil;

      New(Pin^.AdrNext);
      Pin := Pin^.AdrNext;
      Pin^.INF.ID := 2;
      Pin^.INF.X := X1;
      Pin^.INF.Y := (Y2-Y1) div 3 * 2 + Y1;
      Pin^.INF.AdrConnect := nil;

      New(Pin^.AdrNext);
      Pin := Pin^.AdrNext;
      Pin^.INF.ID := 3;
      Pin^.INF.X := X2;
      Pin^.INF.Y := (Y2-Y1) div 2 + Y1;
      Pin^.INF.AdrConnect := nil;
      Pin^.AdrNext := nil;
    end
    else
    begin
      Pin^.INF.ID := 1;
      Pin^.INF.X := X1;
      Pin^.INF.Y := (Y2-Y1) div 2 + Y1;
      Pin^.INF.AdrConnect := nil;

      New(Pin^.AdrNext);
      Pin := Pin^.AdrNext;
      Pin^.INF.ID := 2;
      Pin^.INF.X := X2;
      Pin^.INF.Y := (Y2-Y1) div 2 + Y1;
      Pin^.INF.AdrConnect := nil;
      Pin^.AdrNext := nil;
    end;
    Pin := HTempPin;
  end;
end;

procedure MakebtnEnabled();
begin
  with MainForm do
  begin
    btnAnd.Enabled := True;
    btnOr.Enabled := True;
    btnXor.Enabled := True;
    btnNot.Enabled := True;
    btnnAnd.Enabled := True;
    btnnOr.Enabled := True;
    btnnXor.Enabled := True;
  end;
end;

procedure TForm1.btnAndClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnAnd.Enabled := False;
  LE := LEand;
end;

procedure TForm1.btnOrClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnOr.Enabled := False;
  LE := LEor;
end;

procedure TForm1.btnXorClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnXor.Enabled := False;
  LE := LExor;
end;

procedure TForm1.btnnAndClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnnAnd.Enabled := False;
  LE := LEnand;
end;

procedure TForm1.btnnOrClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnnOr.Enabled := False;
  LE := LEnor;
end;

procedure TForm1.btnnXorClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnnXor.Enabled := False;
  LE := LEnxor;
end;

procedure TForm1.btnNotClick(Sender: TObject);
begin
  MakebtnEnabled();
  btnNot.Enabled := False;
  LE := LEnot;
end;

function CheckAdrConnect(TempEl:TSPElement;CheckPin:TSPPin; var tmpPin:TSPPin):Boolean;
var
  HTempPin:TSPPin;
begin
  result := False;
  if TempEl = nil then
  begin
    result := False;
  end
  else
  begin
    while (TempEl^.AdrNext <> nil) and not result do
    begin
      TempEl := TempEl^.AdrNext;
      with TempEl^.INF do
      begin
        HTempPin := Pin;                       
        while (Pin^.AdrNext <> nil) and not result do               
        begin
          Pin := Pin^.AdrNext;
          if Pin^.INF.AdrConnect = CheckPin then
          begin
            result := True;
            tmpPin := Pin;
          end;
        end;
        Pin := HTempPin;
      end;
    end;
  end;
end;

procedure TForm1.HighLightEl(color:TColor);
var
  TempEl:TSPElement;
  HTempPin:TSPPin;
  tmpP:TSPPin;
begin
  if HeadEl = nil then exit;
  TempEl := HeadEl;
  while TempEl^.AdrNext <> nil do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while Pin^.AdrNext <> nil do
      begin
        Pin := Pin^.AdrNext;
        if (Pin^.INF.AdrConnect = nil) and not CheckAdrConnect(TempEl,Pin,tmpP) then
        begin
          pbMain.Canvas.Brush.Color := color;
          pbMain.Canvas.Ellipse(Pin^.INF.X-5,Pin^.INF.Y-5,Pin^.INF.X+5,Pin^.INF.Y+5);
        end;
      end;
      Pin := HTempPin;
    end;
  end;
end;

procedure TForm1.btnLineClick(Sender: TObject);
begin
  MakebtnEnabled();
  if (HeadEl = nil) or (HeadEl^.AdrNext = nil) or (HeadEl^.AdrNext^.AdrNext = nil) then exit;
  
  btnLine.Enabled := False;
  if not btnLine.Enabled then
  begin
    HighlightEl(clYellow);
    FConnect1 := True;
    FConnect2 := True;        
  end;
end;

function ButtonIsOn():Boolean;
begin
  result := False;
  with MainForm do
  begin
    if not(btnAnd.Enabled) or not(btnOr.Enabled) or not(btnXor.Enabled) or
       not(btnNot.Enabled) or not(btnnAnd.Enabled) or not(btnnOr.Enabled) or not(btnnXor.Enabled) then
      result := True;
  end;
end;

procedure TForm1.pbMainDblClick(Sender: TObject);
var
  Point:TPoint;
begin
  if not ButtonIsOn() then Exit;

  MakebtnEnabled();
  Point := (Sender as TControl).ScreenToClient(Mouse.CursorPos);
  MainForm.NewItem(Point);
  //MainForm.DrawItem();
  (Sender as TControl).Invalidate;
end;

procedure TForm1.Draw(ACanvas:Tcanvas;IsDragging:Boolean;FDragDelta:TPoint);
var
  TempEl,tmpEl:TSPElement;
  HTempPin,tmpPin:TSPPin;
  flag:Boolean;
  Wordnumb:Integer;
  Rect:TRect;
  tX1,tX2,tY1,tY2,tXp,tYp:integer;
  s:Integer;
begin
  VertLines(SlArr);
  if HeadEl <> nil then
  begin
    TempEl := HeadEl;
    while TempEl^.AdrNext <> nil do
    begin
      TempEl := TempEl^.AdrNext;
      with TempEl^.INF do
      begin
        if  (IsDragging and (State = stSelected)) then
        begin
          tX1 := x1+FDragDelta.X;
          tY1 := y1+FDragDelta.Y;
          tX2 := X2+FDragDelta.X;
          tY2 := Y2+FDragDelta.Y;
        end
        else
        begin
          tX1 := X1;
          tY1 := Y1;
          tX2 := X2;
          tY2 := Y2;
        end;
        if LogEl = LEand then MainForm.AndOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LEor then MainForm.OrOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LExor then MainForm.XorOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LEnot then MainForm.NotOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LEnand then MainForm.nAndOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LEnOr then MainForm.nOrOper(tX1,tY1,tX2,tY2,State)
        else if LogEl = LEnxor then MainForm.nXorOper(tX1,tY1,tX2,tY2,State);

        s := 1;
        if Pin <> nil then
        begin
          HTempPin := Pin;
          while Pin^.AdrNext <> nil do          
          begin                                      
            Pin := Pin^.AdrNext;
            with Pin^.INF do
            begin
              if  (IsDragging and (State = stSelected)) then
              begin
                tXp := X+FDragDelta.X;
                tYp := Y+FDragDelta.Y;
              end
              else
              begin         
                tXp := X;               
                tYp := Y;                
              end;

              if AdrConnect <> nil then
              begin
                MainForm.DrawPin(AdrConnect^.INF.X,AdrConnect^.INF.Y,tXp,tYp);
                inc(s);
              end
              else if CheckAdrConnect(TempEl,Pin,tmpPin) then
              begin
                MainForm.DrawPin(tXp,tYp,tmpPin^.INF.AdrConnect^.INF.X,tmpPin^.INF.AdrConnect^.INF.Y);
                inc(s);
              end
              else
              begin
                with pbMain.Canvas do
                begin
                  if LogEl <> LEnot then
                  begin
                    if s <> 3 then
                    begin
                      MoveTo(tX1,(tY2-tY1) div 3 * s + tY1);
                      LineTo(tX1-10,(tY2-tY1) div 3 * s + tY1);
                    end
                    else
                    begin
                      if (LogEl = LEnxor) or (LogEl = LEnor) or (LogEl = LEnand) then
                        tX2 := tX2 + 3;
                      MoveTo(tX2,(tY2-tY1) div 2 + tY1);
                      LineTo(tX2+10,(tY2-tY1) div 2 + tY1);
                    end;
                  end
                  else
                  begin
                    if s <> 2 then
                    begin
                      MoveTo(tX1,(tY2-tY1) div 2 + tY1);
                      LineTo(tX1-10,(tY2-tY1) div 2 + tY1);
                    end
                    else
                    begin
                      MoveTo(tX2+3,(tY2-tY1) div 2 + tY1);
                      LineTo(tX2+10+3,(tY2-tY1) div 2  + tY1);
                    end;
                  end;
                  inc(s);
                end;
              end;
            end;
          end;
          Pin := HTempPin;
        end;
      end;
    end;
    if not btnLine.Enabled then
      HighLightEl(clYellow);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TForm1.pbMainPaint(Sender: TObject);
begin
  Draw((Sender as TPaintBox).Canvas,FDragging,FDragDelta);
end;

procedure TForm1.pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (X >= pbMain.ClientWidth-BlockW) or (Y >= pbMain.ClientHeight-BlockW) or
     (X <= BlockW) or (Y <= BlockW) then exit;
  FDragDelta.X := X - FStartPoint.X;
  FDragDelta.Y := Y - FStartPoint.Y;
  if not FDragging and FMayDrag then
  begin
    if Sqrt(Sqr(FDragDelta.X) + Sqr(FDragDelta.Y)) > DragSensitivity then
      FDragging := True;
  end;
  if FDragging then
    (Sender as TControl).Invalidate;
end;

function TForm1.GetItemIndex(const Point: TPoint): TSPElement;
var
  TempEl:TSPElement;
  Rect:TRect;
begin
  Result := nil;
  if HeadEl <> nil then
  begin
    TempEl := HeadEl;
    while TempEl^.AdrNext <> nil do
    begin
      TempEl := TempEl^.AdrNext;
      with Rect, TempEl^.INF do
      begin
        Left := X1;
        Top := Y1;
        Right := X2;
        Bottom := Y2;
      end;
      if PtInRect(Rect,Point) then
      begin
        Result := TempEl;
        break;
      end;
    end;
  end;
end;

function TForm1.IsItemSelected(Index: TSPElement): Boolean;
begin
  Result := Index^.INF.State = stSelected;
end;

procedure TForm1.UnselectItems;
var
  TempEl:TSPElement;
begin
  if HeadEl <> nil then
  begin
    TempEl := HeadEl;
    while TempEl^.AdrNext <> nil do
    begin
      TempEl := TempEl^.AdrNext;
      TempEl^.INF.State := stNormal;
    end;
  end;
  FSelCount := 0;
end;

function TForm1.ToggleItem(Index: TSPElement): Boolean;
begin
  with Index^.INF do
  begin
    Result := (State = stNormal);
    if Result then
    begin
      State := stSelected;
      //pbMain.Canvas.Brush.Color := clYellow;
      Inc(FSelCount);
    end
    else
    begin
      State := stNormal;
      //pbMain.Canvas.Brush.Color := clWhite;
      Dec(FSelCount);
    end;
  end;
end;

function TForm1.ChooseConnect(const Point:TPoint; var PinConnect:TSPPin):Boolean;
var
  TempEl:TSPElement;
  HTempPin,tmpP:TSPPin;
  Rect:TRect;
begin
  result := False;
  PinConnect := nil;
  TempEl := HeadEl;
  while (TempEl^.AdrNext <> nil) and not result do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while (Pin^.AdrNext <> nil) and not result do
      begin
        Pin := Pin^.AdrNext;
        if (Pin^.INF.AdrConnect = nil) and not CheckAdrConnect(TempEl,Pin,tmpP) then
        begin
          Rect.Left := Pin.INF.X - 5;
          Rect.Top := Pin^.INF.Y - 5;
          Rect.Right := Pin^.INF.X + 5;
          Rect.Bottom := Pin^.INF.Y + 5;
          if PtInRect(Rect,Point) then
          begin
            result := True;
            PinConnect := Pin;
          end;
        end;
      end;
      Pin := HTempPin;
    end;
  end;
end;

procedure MakeDisconnect(PinDis:TSPPin);
var
  TempEl: TSPElement;
  HTempPin: TSPPin;
begin
  TempEl := HeadEl;
  while TempEl^.AdrNext <> nil do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while Pin^.AdrNext <> nil do
      begin
        Pin := Pin^.AdrNext;
        if Pin^.INF.AdrConnect = PinDis then
          Pin^.INF.AdrConnect := nil;
      end;
      Pin := HTempPin;
    end;
  end;
end;

procedure TForm1.DeleteItem(Index:TSPElement);
var
  TempPrev,TempNext:TSPElement;
  tmpP:TSPPin;
begin
  TempPrev := Index^.AdrPrev;
  TempPrev^.AdrNext := Index^.AdrNext;
  if Index^.AdrNext <> nil then
  begin
    TempNext := Index^.AdrNext;
    TempNext^.AdrPrev := Index^.AdrPrev;
  end
  else
  begin
    TempEl := Index^.AdrPrev;
    TempPrev^.AdrPrev := Index^.AdrPrev^.AdrPrev;
  end;
  if TempPrev = HeadEl then
    flg := True;
  with Index^.INF do
  begin
    while Pin <> nil do
    begin
      tmpP := Pin;
      MakeDisconnect(Pin);
      Pin := Pin^.AdrNext ;
      Dispose(tmpP);
    end;
  end;
  Dispose(Index);
end;

function PinCheck(Pin1,Pin2:TSPPin):Boolean;
var
  TempEl: TSPElement;
  HTempPin: TSPPin;
  m1,m2: Integer;
  flag: Boolean;
  LE1,LE2: TLogEl;
begin
  result := True;
  if Pin1 = Pin2 then
    result := False;
  TempEl := HeadEl;
  flag := False;     
  while (TempEl^.AdrNext <> nil) and not flag do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      LE1 := LogEl;
      HTempPin := Pin;
      m1 := 0;
      while (Pin^.AdrNext <> nil) and not flag do
      begin
        Pin := Pin^.AdrNext;
        inc(m1);
        if Pin = Pin1 then
          flag := True;
      end;
      Pin := HTempPin;
    end;
  end;

  TempEl := HeadEl;  
  flag := False;
  while (TempEl^.AdrNext <> nil) and not flag do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      LE2 := LogEl;
      HTempPin := Pin;
      m2 := 0;
      while (Pin^.AdrNext <> nil) and not flag do
      begin
        Pin := Pin^.AdrNext;
        inc(m2);
        if Pin = Pin2 then
          flag := True;
      end;                               
      Pin := HTempPin;
    end;
  end;

  if result and (((m1 = 1) and (m2 = 2) and (LE1 <> LEnot) and (LE2 <> LEnot))
     or ((m2 = 1) and (m1 = 2) and (LE1 <> LEnot) and (LE2 <> LEnot))
     or ((m1 = 1) and (m2 = 1) and (LE1 <> LEnot) and (LE2 <> LEnot))
     or ((m1 = 2) and (m2 = 2) and (LE1 <> LEnot) and (LE2 <> LEnot))
     or ((m1 = 3) and (m2 = 3) and (LE1 <> LEnot) and (LE2 <> LEnot))
     or ((m1 = 1) and (m2 = 1) and (LE1 = LEnot) and (LE2 = LEnot))
     or ((m1 = 2) and (m2 = 2) and (LE1 = LEnot) and (LE2 = LEnot))
     or ((m1 = 1) and (m2 = 1) and (LE1 <> LEnot) and (LE2 = LEnot))
     or ((m1 = 2) and (m2 = 1) and (LE1 <> LEnot) and (LE2 = LEnot))
     or ((m1 = 2) and (m2 = 3) and (LE1 = LEnot) and (LE2 <> LEnot))
     or ((m1 = 1) and (m2 = 1) and (LE1 = LEnot) and (LE2 <> LEnot))
     or ((m1 = 1) and (m2 = 2) and (LE1 = LEnot) and (LE2 <> LEnot))  )
  then
     result := False;
end;

procedure TForm1.ConnectPins(Pin1,Pin2:TSPPin);
var
  flag:Boolean;
  TempEl:TSPElement;
  HTempPin:TSPPin;
begin
  TempEl := HeadEl;
  while TempEl^.AdrNext <> nil do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while Pin^.AdrNext <> nil do
      begin
        Pin := Pin^.AdrNext;
        if Pin = Pin2 then
          flag := False;
        if Pin = Pin1 then
          flag := True;
      end;
      Pin := HTempPin;
    end;
  end;

  if not flag then
  begin
    HTempPin := Pin1;
    Pin1 := Pin2;
    Pin2 := HTempPin;
  end;

  if PinCheck(Pin1,Pin2) then
    Pin1^.INF.AdrConnect := Pin2;
end;

function TForm1.ElConnect(FStartPoint: TPoint; var i: Integer):Boolean;
var
  Rect: TRect;
begin
  result := False;
  i := 0;
  while (i <= High(SlArr)) and not result do
  begin
    Rect.Left := i * 10 + 3;
    Rect.Top := 0;
    Rect.Right := i * 10 + 7;
    Rect.Bottom := pbMain.Height;
    if PtinRect(Rect,FStartPoint)  then
      result := True;
    inc(i);
  end;
  dec(i);
end;

function CreateHeadPin(SlCon:Integer;Y:Integer):TSPPin;
var
  HTempPin:TSPPin;
  tmpP:TSPPin;
begin
  with HeadEl^.INF do
  begin
    HTempPin := Pin;
    while Pin^.AdrNext <> nil do
    begin
      tmpP := Pin^.AdrNext;
      Pin := Pin^.AdrNext;
    end;
    New(Pin^.AdrNext);
    Pin := Pin^.AdrNext;
    Pin^.AdrNext := nil;
    result := Pin;
    result^.INF.X := SlCon * 10 + 5;
    result^.INF.Y := Y;
    Pin := HTempPin;
  end;
end;

procedure TForm1.pbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Index: TSPElement;
  Pin:TSPPin;
begin
  case Button of
    mbLeft:   // Если зажата левая кнопка мыши
      begin
        FStartPoint := Point(X, Y);
        if (FConnect1 or FConnect2) and (ChooseConnect(FStartPoint,Pin) or ElConnect(FStartPoint,FSlCon))
           and not btnLine.Enabled then
        begin
          if FConnect1 then
          begin
            FConnect1 := False;
            if ElConnect(FStartPoint,FSlCon) then
              FPin := CreateHeadPin(FSlCon,FStartPoint.Y)
            else
              FPin := Pin
          end
          else if FConnect2 then
          begin
            FConnect2 := False;
            if ElConnect(FStartPoint,FSlCon) then
              ConnectPins(FPin,CreateHeadPin(FSlCon,FStartPoint.Y))
            else
              ConnectPins(FPin,Pin);
            btnLine.Enabled := True;
          end;
        end
        else
        begin
          FConnect1 := False;
          FConnect2 := False;
          btnLine.Enabled := True;
        end;

        Index := GetItemIndex(FStartPoint);
        if Index <> nil then
        begin
          FMayDrag := IsItemSelected(Index);

          if not FMayDrag then//and not(ssShift in Shift) then
          begin
            if not(ssShift in Shift) then
              UnselectItems;
            ToggleItem(Index);
            FMayDrag := True;
          end;
        end
        else
          UnselectItems;
      end;
    mbRight:  // Если зажата правая кнопка мыши
      begin
        FStartPoint := Point(X, Y);
        Index := GetItemIndex(FStartPoint);
        if Index <> nil then
          DeleteItem(Index);
      end;
  end;

  (Sender as TControl).Invalidate;
end;

procedure TForm1.MoveItems(const DragDelta: TPoint);
var
  TempEl:TSPElement;
  Rect:TRect;
  HTempPin:TSPPin;
begin
  if FSelCount = 0 then Exit;

  if HeadEl <> nil then
  begin
    TempEl := HeadEl;
    while TempEl^.AdrNext <> nil do
    begin
      TempEl := TempEl^.AdrNext;
      with TempEl^.INF, Rect do
      begin
        if State = stSelected then
        begin
          X1 := X1 + DragDelta.X;
          Y1 := Y1 + DragDelta.Y;
          X2 := X2 + DragDelta.X;
          Y2 := Y2 + DragDelta.Y;
          if Pin <> nil then
          begin
            HTempPin := Pin;
            while Pin^.AdrNext <> nil do
            begin
              Pin := Pin^.AdrNext;
              Pin^.INF.X := Pin^.INF.X + FDragDelta.X;
              Pin^.INF.Y := Pin^.INF.Y + FDragDelta.Y
            end;
            Pin := HTempPin;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.pbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (X >= pbMain.ClientWidth-BlockW) or (Y >= pbMain.ClientHeight-BlockW) or
     (X <= BlockW) or (Y <= BlockW) then exit;
  if Button <> mbLeft then Exit;

  if FDragging then
  begin
    FDragDelta.X := X - FStartPoint.X;
    FDragDelta.Y := Y - FStartPoint.Y;
    MoveItems(FDragDelta);

    (Sender as TControl).Invalidate;
  end;

  FMayDrag := False;
  FDragging := False;
end;


procedure TForm1.actFileExitExecute(Sender: TObject);
var
  DisPin:TSPPin;
  DisEl:TSPElement;
begin
  while HeadEl <> nil do
  begin
    DisEl := HeadEl;
    with HeadEl^.INF do
    begin
      while Pin <> nil do
      begin
        DisPin := Pin;
        Pin := Pin^.AdrNext;
        Dispose(DisPin);
      end;
    end;
    HeadEl := HeadEl^.AdrNext;
    Dispose(DisEl);
  end;

  Close;
end;


procedure TForm1.actFileNewExecute(Sender: TObject);
var
  DisPin:TSPPin;
  DisEl:TSPElement;
begin
  while HeadEl <> nil do
  begin
    DisEl := HeadEl;
    with HeadEl^.INF do
    begin
      while Pin <> nil do
      begin
        DisPin := Pin;
        Pin := Pin^.AdrNext;
        Dispose(DisPin);
      end;
    end;
    HeadEl := HeadEl^.AdrNext;
    Dispose(DisEl);
  end;
  flg := True;
  FConnect1 := False;
  FConnect2 := False;
  TempEl := nil;
  MakebtnEnabled;
  btnLine.Enabled := True;
  FDragging := False;
  FDragDelta := Point(0,0);
  edtLogExpr.Text := 'Введите логическое выражение';
  SetLength(SlArr,0);
  pbMain.Canvas.Brush.Color := clWhite;
  Draw(Canvas,FDragging,FDragDelta);
end;

procedure TForm1.actFileImportExecute(Sender: TObject);
var
  Bitmap:TBitmap;
begin
  if not dlgImport.Execute then exit;
  Bitmap := TBitmap.Create;
  Bitmap.Width := pbMain.Width;
  Bitmap.Height := pbMain.Height;
  Bitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,pbMain.Canvas,pbMain.Canvas.ClipRect);
  Bitmap.SaveToFile(dlgImport.Files[0]);
  Bitmap.Free;
end;

procedure ConvertPintoSavePin(PinSearch:TSPPin; var NLogEl,NPin:Integer);
var
  TempEl: TSPElement;
  HTempPin: TSPPin;
  flag: Boolean;
begin
  flag := True;
  TempEl := HeadEl;
  while (TempEl^.AdrNext <> nil) and flag do
  begin
    TempEl := TempEl^.AdrNext;
    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while (Pin^.AdrNext <> nil) and flag do
      begin
        Pin := Pin^.AdrNext;
        if Pin = PinSearch then
        begin
          NLogEl := ID;
          NPin := Pin.INF.ID;
          flag := False;
        end;
      end;
      Pin := HTempPin;
    end;
  end;
end;

{procedure TForm1.actFileSaveExecute(Sender: TObject);
var
  fEl: file of TElementSave;
  fPin: file of TPinSave;
  i: Integer;
  //tmpEl,tmpElPrev:TSPElement;
  HeadElS,TempElS,TempPrevS: TSPElementSave;
  TempEl: TSPElement;
  HTempPin: TSPPin;
  HeadPinS,tmpPinS,dPinPrev: TSPPinSave;
  NLogEl,NPin: Integer;
  SlArrS: TArr1;
begin
  if not dlgSave.Execute then Exit;
  if HeadEl = nil then Exit;

  TempEl := HeadEl;
  New(HeadPinS);
  tmpPinS := HeadPinS;
  with TempEl^.INF do
  begin
    HTempPin := Pin;
    While Pin^.AdrNext <> nil do
    begin
      Pin := Pin^.AdrNext;
      New(tmpPinS^.AdrNext);
      tmpPinS := tmpPinS^.AdrNext;
      tmpPinS^.AdrNext := nil;
      tmpPinS^.INF.ID := Pin^.INF.ID;
      i := Pin^.INF.ID;
      tmpPinS^.INF.X := Pin^.INF.X;
      tmpPinS^.INF.Y := Pin^.INF.Y
    end;
    i := Pin^.INF.ID;
    Pin := HTempPin;
  end;
  New(HeadElS);
  HeadElS^.AdrPrev := nil;
  HeadElS^.AdrNext := nil;
  HeadElS^.INF.Pinnumb := i;
  for i := Low(SlArr) to High(SlArr) do
    SlArrS[i+1] := SlArr[i];
  HeadElS^.INF.SlArr := SlArrS;

  TempElS := HeadElS;
  while TempEl^.AdrNext <> nil do
  begin
    TempEl := TempEl^.AdrNext;
    TempPrevS := TempElS;
    New(TempElS^.AdrNext);
    TempElS := TempElS^.AdrNext;
    TempElS^.AdrNext := nil;
    TempElS^.AdrPrev := TempPrevS;
    TempElS^.INF.ID := TempEl^.INF.ID;
    TempElS^.INF.X1 := TempEl^.INF.X1;
    TempElS^.INF.Y1 := TempEl^.INF.Y1;
    TempElS^.INF.X2 := TempEl^.INF.X2;
    TempElS^.INF.Y2 := TempEl^.INF.Y2;
    TempElS^.INF.LogEl := TempEl^.INF.LogEl;
    TempElS^.INF.State := TempEl^.INF.State;

    with TempEl^.INF do
    begin
      HTempPin := Pin;
      while Pin^.AdrNext <> nil do
      begin
        Pin := Pin^.AdrNext;
        New(tmpPinS^.AdrNext);
        tmpPinS := tmpPinS^.AdrNext;
        tmpPinS^.AdrNext := nil;
        tmpPinS^.INF.ID := Pin^.INF.ID;
        tmpPinS^.INF.X := Pin^.INF.X;
        tmpPinS^.INF.Y := Pin^.INF.Y;
        if Pin^.INF.AdrConnect <> nil then
        begin
          ConvertPintoSavePin(Pin^.INF.AdrConnect,NLogEl,NPin);
          tmpPinS^.INF.LogElConnect := NLogEl;
          tmpPinS^.INF.PinConnect := NPin;
        end
        else
        begin
          tmpPinS^.INF.LogElConnect := -1;
          tmpPinS^.INF.PinConnect := -1;
        end;
      end;
      i := Pin^.INF.ID;
      Pin := HTempPin;
    end;

    TempElS^.INF.Pinnumb := i;
  end;

  AssignFile(fEl,'Elements.dat');
  rewrite(fEl);
  write(fEl,HeadElS^.INF);
  TempElS := HeadElS;
  while TempElS^.AdrNext <> nil do
  begin
    TempPrevS := TempElS;
    TempElS := TempElS^.AdrNext;
    Dispose(TempPrevS);
    write(fEl,TempElS^.INF);
  end;
  CloseFile(fEl);

  AssignFile(fPin,'Pins.dat');
  rewrite(fPin);
  tmpPinS := HeadPinS;
  while tmpPinS^.AdrNext <> nil do
  begin
    dPinPrev := tmpPinS;
    tmpPinS := tmpPinS^.AdrNext;
    Dispose(dPinPrev);
    write(fPin,tmpPinS^.INF);
  end;
  CloseFile(fPin);
end;

procedure MakePinAdr(PinC:TSPPin;LogElConnect,PinConnect:Integer);
var
  TempEl: TSPElement;
  HTempPin: TSPPin;
  flag: Boolean;
begin
  flag := True;
  TempEl := HeadEl;
  while (TempEl^.AdrNext <> nil) and flag do
  begin
    TempEl := TempEl^.AdrNext;
    if TempEl^.INF.ID = LogElConnect then
    begin
      with TempEl^.INF do
      begin
        HTempPin := Pin;
        while (Pin^.AdrNext <> nil) and flag do
        begin
          Pin := Pin^.AdrNext;
          if Pin^.INF.ID = PinConnect then
          begin
            PinC^.INF.AdrConnect := Pin;
            flag := False;
          end;
        end;
        Pin := HTempPin;
      end;
    end;
  end;
end;

procedure TForm1.actFileOpenExecute(Sender: TObject);
var
  HPinS,PinS,PinSPrev: TSPPinSave;
  HTempElS,TempElS,TempElSPrev: TSPElementSave;
  HPin,Pin: TSPPin;
  TempEl,TempElPrev: TSPElement;
  fEl: file of TElementSave;
  fPin: file of TPinSave;
  SlArrS: TArr1;
  i,s: Integer;
begin
  if not dlgOpen.Execute then exit;
  AssignFile(fEl,'Elements.dat');
  Reset(fEl);
  New(HTempElS);
  read(fEl,HTempElS^.INF);
  HTempElS^.AdrPrev := nil;
  TempElS := HTEmpElS;
  while not eof(fEl) do
  begin
    New(TempElS^.AdrNext);
    TempElSPrev := TempElS;
    TempElS := TempElS^.AdrNext;
    TempElS^.AdrPrev := TempElSPrev;
    read(fEl,TempElS^.INF);
  end;
  TempElS^.AdrNext := nil;
  CloseFile(fEl);

  AssignFile(fPin,'Pins.dat');
  Reset(fPin);
  New(HPinS);
  PinS := HPinS;
  while not eof(fPin) do
  begin
    New(PinS^.AdrNext);
    PinS := PinS^.AdrNext;
    read(fPin,PinS^.INF);
  end;
  PinS^.AdrNext := nil;
  CloseFile(fPin);

  SlArrS := HTempElS^.INF.SlArr;
  SetLength(SlArr,HTempElS^.INF.Pinnumb);
  for i := 0 to HTempElS^.INF.Pinnumb - 1 do
    SlArr[i] := SlArrS[i+1];

  New(HeadEl);
  HeadEl^.AdrPrev := nil;
  with HeadEl^.INF do
  begin
    New(HPin);
    Pin := HPin;
    PinS := HPinS;
    for i := 1 to HTempElS^.INF.Pinnumb do
    begin
      New(Pin^.AdrNext);
      Pin := Pin^.AdrNext;
      PinSPrev := PinS;
      PinS := PinS^.AdrNext;
      Dispose(PinSPrev);
      Pin^.INF.ID := PinS^.INF.ID;
      Pin^.INF.X := PinS^.INF.X;
      Pin^.INF.Y := PinS^.INF.Y;
    end;
    Pin := HPin;
  end;

  TempEl := HeadEl;
  HTEmpElS := TempElS;
  while TempElS^.AdrNext <> nil do
  begin
    TempElSPrev := TempElS;
    TempElS := TempElS^.AdrNext;
    Dispose(TempElSPrev);

    New(TempEl^.AdrNext);
    TempElPrev := TempEl;
    TempEl := TempEl^.AdrNext;
    TempEl^.AdrPrev := TempElPrev;
    TempEl^.INF.ID := TempElS^.INF.ID;
    TempEl^.INF.X1 := TempElS^.INF.X1;
    TempEl^.INF.Y1 := TempElS^.INF.Y1;
    TempEl^.INF.X2 := TempElS^.INF.X2;
    TempEl^.INF.Y2 := TempElS^.INF.Y2;
    TempEl^.INF.LogEl := TempElS^.INF.LogEl;
    TempEl^.INF.State := TempElS^.INF.State;
    New(HPin);
    with TempEl^.INF do
    begin
      Pin := HPin;
      if LogEl = LEnot then
        s := 2
      else
        s := 3;
      for i := 1 to s do
      begin
        PinS := PinS^.AdrNext;
        New(Pin^.AdrNext);
        Pin := Pin^.AdrNext;
        Pin^.INF.ID := PinS^.INF.ID;
        Pin^.INF.X := PinS^.INF.X;
        Pin^.INF.Y := PinS^.INF.Y;
        if PinS^.INF.PinConnect <> -1 then
          MakePinAdr(Pin,PinS^.INF.LogElConnect,PinS^.INF.PinConnect)
        else
          Pin^.INF.AdrConnect := nil;
      end;
      Pin := HPin;
    end;
  end;
end;}

procedure TForm1.actHelpExecute(Sender: TObject);
begin
  Help.LoadData;
  Help.ShowModal;
end;

end.
