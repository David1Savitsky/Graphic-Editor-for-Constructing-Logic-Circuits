unit UMakePrioritySp;

interface
uses
  SysUtils,
  UAllTypes;

var
  SlArr:TArr;  

procedure MakePriorSp(Arr:TArr; HeadEl:TSPElement);
function MakeSlArr(Arr:TArr):TArr;

implementation

function MakeSlArr(Arr:TArr):TArr;
var
  i,k,j,el:Integer;
  flag:Boolean;
begin
  el := 4;
  SetLength(result,el);
  k:=0;
  for i := Low(Arr) to High(Arr) do
  begin
    if not ((Arr[i] = 'and') or (Arr[i] = 'or') or
       (Arr[i] = 'xor') or (Arr[i] = 'not') or (Arr[i] = '')) then
    begin
      if k = el then
      begin
        el := el * 2;
        SetLength(result,el);
      end;

      j := 0;
      flag := True;
      while (j < el) and flag do
      begin
        if result[j] = Arr[i] then
          flag := false;
        inc(j);
      end;

      if flag then
      begin
        result[k] := Arr[i];
        inc(k);
      end;
    end;
  end;
  i := 0;
  while (i <= High(result)) and (result[i] <> '') do
    inc(i);
  SetLength(result,i);
end;

procedure MakeHeadPin(var HeadEl:TSPElement; YofEl:Integer; SlArr:TArr; Sl:String);
var
  i:Integer;
  flag:Boolean;
begin
  New(HeadEl^.INF.Pin^.AdrNext);
  HeadEl^.INF.Pin := HeadEl^.INF.Pin^.AdrNext;
  HeadEl^.INF.Pin^.AdrNext := nil;
  with HeadEl^.INF.Pin^.INF do
  begin
    Y := YofEl;
    i := 0;
    flag := True;
    while (i <= High(SlArr)) and flag do
    begin
      if SlArr[i] = Sl  then
        flag := false;
      inc(i);
    end;
    X := (i-1)*10 + 5;
  end;
end;

function GetNumbPin(HeadEl:TSPElement;id:Integer):TSPPin;
var
  TempEl:TSPElement;
  HTempPin:TSPPin;
begin
  TempEl := HeadEl;
  while (TempEl^.AdrNext <> nil) and (TempEl^.INF.ID <> id) do
    TempEl := TempEl^.AdrNext;

  //Ищем Последний пин(выход из логического блока)
  HTempPin := TempEl^.INF.Pin;
  while TempEl^.INF.Pin^.AdrNext <> nil do
    TempEl^.INF.Pin := TempEl^.INF.Pin^.AdrNext;
  result := TempEl^.INF.Pin;
  TempEl^.INF.Pin := HTempPin;
end;

procedure ArrangePin(HeadEl,TempEl:TSPElement; Operand1,Operand2:string; SlArr:TArr; fl:Boolean); //fl = False  -  not
var                                                                                               //fl = True   -  other
  s,idPin:Integer;
  flag:Boolean;
  HTempPin:TSPPin;
begin
  case fl of
    True:
    begin
      idPin := 1;
      with TempEl^.INF do
      begin
        HTempPin := Pin;
        flag := True;
        for s := 1 to 3 do
        begin
          New(Pin^.AdrNext);
          Pin := Pin^.AdrNext;
          Pin^.AdrNext := nil;
          Pin^.INF.ID := s;
          if s <> 3 then
          begin
            Pin^.INF.X := X1;
            Pin^.INF.Y := ((Y2 - Y1) div 3) * s + Y1;      // Если s=1, то пин первый и вход норм
            if not flag then
            begin
              if (Operand2[1] in ELetters) and not flag then
              begin
                MakeHeadPin(HeadEl,Pin^.INF.Y,SlArr,Operand2);
                HeadEl^.INF.Pin^.INF.ID := idPin;
                inc(idPin);
                Pin^.INF.AdrConnect := HeadEl^.INF.Pin;
              end
              else
                Pin^.INF.AdrConnect := GetNumbPin(HeadEl,StrtoInt(Operand2));
            end
            else
            begin
              if (Operand1[1] in ELetters) then
              begin
                MakeHeadPin(HeadEl,Pin^.INF.Y,SlArr,Operand1);
                HeadEl^.INF.Pin^.INF.ID := idPin;
                inc(idPin);
                Pin^.INF.AdrConnect := HeadEl^.INF.Pin
              end
              else
                Pin^.INF.AdrConnect := GetNumbPin(HeadEl,StrtoInt(Operand1));
              flag := False;
            end;
          end
          else
          begin
            if (LogEl = LEnot) or (LogEl = LEnxor) or (LogEl = LEnor) or (LogEl = LEnand) then
              Pin^.INF.X := X2 + 3
            else
              Pin^.INF.X := X2;
            Pin^.INF.Y := (Y2-Y1) div 2 + Y1;
            Pin^.INF.AdrConnect := nil;
          end;
        end;
        Pin := HTempPin;
      end;
    end;
    False:
    begin
      idPin := 1;
      with TempEl^.INF do
      begin
        HTempPin := Pin;
        for s := 1 to 2 do
        begin
          New(Pin^.AdrNext);
          Pin := Pin^.AdrNext;
          Pin^.AdrNext := nil;
          Pin^.INF.ID := s;
          if s = 1 then
          begin
            Pin^.INF.X := X1;
            Pin^.INF.Y := ((Y2 - Y1) div 2) + Y1;
            if (Operand1[1] in ELetters) then
            begin
              MakeHeadPin(HeadEl,Pin^.INF.Y,SlArr,Operand1);
              HeadEl^.INF.Pin^.INF.ID := idPin;
              inc(idPin);
              Pin^.INF.AdrConnect := HeadEl^.INF.Pin
            end
            else
              Pin^.INF.AdrConnect := GetNumbPin(HeadEl,StrtoInt(Operand1));
          end
          else
          begin
            Pin^.INF.X := X2 + 3;
            Pin^.INF.Y := (Y2-Y1) div 2 + Y1;
            Pin^.INF.AdrConnect := nil;
          end;
        end;
        Pin := HTempPin;
      end;
    end;
  end;
end;

procedure GetY(TempEl:TSPElement;Operand1,Operand2:Integer);
var
  HTempEl:TSPElement;
  y1,y2:Integer;
begin
  HTempEl := TempEl;
  while (HTempEl^.AdrPrev <> nil) and (HTempEl^.INF.ID <> Operand2) do
    HTempEl := HTempEl^.AdrPrev;
  y2 := HTempEl^.INF.Y1;

 // HTempEl := TempEl;
  while (HTempEl^.AdrPrev <> nil) and (HTempEl^.INF.ID <> Operand1) do
    HTempEl := HTempEl^.AdrPrev;
  y1 := HTempEl^.INF.Y1;

  TempEl^.INF.Y1 := (y2+y1) div 2;
  TempEl^.INF.Y2 := (y2+y1) div 2 + BlockH;
end;

procedure MakePriorSp(Arr:TArr; HeadEl:TSPElement);
var
  {TempEl,}tmpPrev:TSPElement;
  i,j,k,{BlockH,BlockW,}X,Y:Integer;
  //SlArr:TArr;
  HeadPin:TSPPin;
  Stmp:String;
begin
  SlArr := MakeSlArr(Arr);
  BlockH := 40;
  BlockW := 20;
  X := (High(SlArr) + 1) * 10 + 5;
  Y := 20;
  if 2 * BlockW * (High(Arr)-High(SlArr)) > imgClientWidth then
  begin
    i := BlockW;
    BlockW := trunc((BlockW - (BlockW * (High(Arr)-High(SlArr))-imgClientWidth) div (High(Arr)-High(SlArr))) * 1.5);
    BlockH := trunc(BlockW / i * BlockH);
  end;
  if (BlockH div 2 + BlockH div 4)*(High(Arr)-High(SlArr)) > imgClientHeight then
  begin
    i := BlockH;
    BlockH := trunc((BlockH - (BlockH * (High(Arr)-High(SlArr))-imgClientHeight) div (High(Arr)-High(SlArr))) * 1.5);
    BlockW := trunc(BlockH / i * BlockW);
  end;
  
  New(HeadEl^.INF.Pin);
  HeadPin := HeadEl^.INF.Pin;

  i := 1
  i := 0;
  idEl := 1;
  HeadEl^.AdrPrev := nil;
  TempEl := HeadEl;
  tmpPrev := TempEl;
  while i <= High(Arr) do
  begin
    if (Arr[i] = 'and') or (Arr[i] = 'or') or (Arr[i] = 'xor') or (Arr[i] = 'not') then
    begin
      New(TempEl^.AdrNext);
      TempEl := TempEl^.AdrNext;
      TempEl^.AdrNext := nil;
      TempEl^.AdrPrev := tmpPrev;
      New(TempEl^.INF.Pin);
      TempEl^.INF.ID := idEl;
      tmpPrev := TempEl;    
      if ((i+1 <= High(Arr)) and (Arr[i+1] = 'not')) or (Arr[i] = 'not') then
      begin
        if (Arr[i] = 'and') or (Arr[i] = 'or') or (Arr[i] = 'xor') then
        begin
          j := i;
          while (Arr[j] = 'and') or (Arr[j] = 'or') or (Arr[j] = 'xor') or (Arr[j] = 'not') or (Arr[j] = '0') do
            dec(j);
          k := j-1;
          while (Arr[k] = 'and') or (Arr[k] = 'or') or (Arr[k] = 'xor') or (Arr[k] = 'not') or (Arr[k] = '0') do
            dec(k);
          with TempEl^.INF do
          begin
            if (Arr[j][1] in Numbers) and (Arr[k][1] in Numbers) then
            begin
              GetY(TempEl,StrtoInt(Arr[k]),StrtoInt(Arr[j]));
              X1 := X;
              //Y1 := Y + Y1;
              X2 := X + BlockW;
              //Y2 := Y + Y2;
              Y := Y - (BlockH div 2 + BlockH div 4);
            end
            else
            begin
              X1 := X;
              Y1 := Y;
              X2 := X + BlockW;
              Y2 := Y + BlockH;
            end;
            if Arr[i] = 'and' then
              LogEl := LEnand
            else if Arr[i] = 'or' then
              LogEl := LEnor
            else if Arr[i] = 'xor' then
              LogEl := LEnxor;

            State := stNormal;
            ArrangePin(HeadEl,TempEl, Arr[k],Arr[j],SlArr,True);
          end;
          Arr[i+1] := InttoStr(TempEl^.INF.ID);
          Arr[i] := '0';
          Arr[k] := '0';
          Arr[j] := '0';

          //inc(X,(BlockW+20));
          //inc(Y,(BlockH+5));
        end
        else
        begin
          k := i;
          while (Arr[k] = 'and') or (Arr[k] = 'or') or (Arr[k] = 'xor') or (Arr[k] = 'not') do
            dec(k);
          with TempEl^.INF do
          begin
            X1 := X;
            Y1 := Y;
            X2 := X + BlockW;
            Y2 := Y + BlockH;
            LogEl := LEnot;

            State := stNormal;
            j := 1;
            ArrangePin(HeadEl,TempEl, Arr[k],Arr[j],SlArr,False);
            //Pin.INF.X := Pin.INF.X + 10;
          end;
          Arr[i] := InttoStr(TempEl^.INF.ID);
          Arr[k] := '0';

          //inc(X,(BlockW+20));
          //inc(Y,(BlockH+5));
        end;

      end
      else
      begin
        j := i;
        while (Arr[j] = 'and') or (Arr[j] = 'or') or (Arr[j] = 'xor') or (Arr[j] = 'not') or (Arr[j] = '0') do
          dec(j);
        k := j-1;
        while (Arr[k] = 'and') or (Arr[k] = 'or') or (Arr[k] = 'xor') or (Arr[k] = 'not') or (Arr[k] = '0') do
          dec(k);
        with TempEl^.INF do
        begin
          if (Arr[j][1] in Numbers) and (Arr[k][1] in Numbers) then
          begin
            GetY(TempEl,StrtoInt(Arr[k]),Strtoint(Arr[j]));
            X1 := X;
            //Y1 := Y + Y1;
            X2 := X + BlockW;
            //Y2 := Y + Y2;
            Y := Y - (BlockH div 2 + BlockH div 4);
          end
          else
          begin
            X1 := X;
            Y1 := Y;
            X2 := X + BlockW;
            Y2 := Y + BlockH;
          end;
          if Arr[i] = 'and' then
            LogEl := LEand
          else if Arr[i] = 'or' then
            LogEl := LEor
          else if Arr[i] = 'xor' then
            LogEl := LExor;

          State := stNormal;

          if (Arr[j] = '1') and (Arr[k] <> '1') then
          begin
            Stmp := Arr[j];
            Arr[j] := Arr[k];
            Arr[k] := Stmp;
          end;
          ArrangePin(HeadEl,TempEl, Arr[k],Arr[j],SlArr,True);
        end;
        Arr[i] := InttoStr(TempEl^.INF.ID);
        Arr[j] := '0';
        Arr[k] := '0';
      end;
      inc(X,(BlockW * 2));
      inc(Y,(BlockH div 2 + BlockH div 4));
      //TempEl^.INF.Inversion := True;
      inc(idEl);
      //idPin := 1;
    end;
    inc(i);
  end;
  HeadEl^.INF.Pin := HeadPin;
end;

end.
