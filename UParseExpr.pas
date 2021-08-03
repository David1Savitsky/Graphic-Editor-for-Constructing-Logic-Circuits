unit UParseExpr;

interface
  uses
    UAllTypes;
  function ParseExpr(s:string; var flag:Boolean; var Wordnumb:Integer):TArr;

implementation

{procedure SyntaxError(s:string);
begin
  writeln(s);
end;}

function LexAnalyser(s:string; var k:Integer):TArr;
var
  i,j,el:Integer;
  flag:Boolean;
begin
  el:=4;
  SetLength(result,el);
  i:=1;
  flag:=true;
  while (i <= length(s)) and (flag) do
  begin
    if el = k then
    begin
      el:= el * 2;
      SetLength(result, el);
    end;

    if s[i] in ['(',')'] then
    begin
      result[k]:=s[i];
      inc(k);
      inc(i);
    end
    else if (s[i] = 'n') and (length(s) - i > 2) and (s[i+1] = 'o') and (s[i+2] = 't') then
    begin
      result[k]:='not';
      inc(k);
      inc(i,3);
    end
    else if (s[i] = 'x') and (length(s) - i > 2) and (s[i+1] = 'o') and (s[i+2] = 'r') then
    begin
      result[k]:='xor';
      inc(k);
      inc(i,3);
    end
    else if (s[i] = 'a') and (length(s) - i > 2) and (s[i+1] = 'n') and (s[i+2] = 'd') then
    begin
      result[k]:='and';
      inc(k);
      inc(i,3);
    end
    else if (s[i] = 'o') and (length(s) - i > 1) and (s[i+1] = 'r') then
    begin
      result[k]:='or';
      inc(k);
      inc(i,2);
    end
    else if s[i] in Eletters then
    begin
      j:=i;
      while (i <= length(s)) and (s[i] in Eletters) do inc(i);
      result[k]:=copy(s,j,i-j);
      inc(k);
    end
    else if s[i] = ' ' then
      inc(i)
    else
    begin
      //SyntaxError('Invalid Input');
      //flag:=false;
      //exit;
      inc(i);
    end;
    //inc(i);
  end;
end;

procedure PushStek(var St:TSPStek; El:string);
var
  Q:TSPStek;
begin
   New(Q);
   Q^.El:=El;
   Q^.ADR:=St;
   St:=Q;
end;

procedure PopStek(var St:TSPStek; var El:String);
var
  Q:TSPStek;
begin
  El:= St^.El;
  Q:=St;
  St:=St^.ADR;
  Dispose(Q);
end;

function OperPrior(Oper:String; LastStEl:string):Integer;                   //True -  ����     //�������� �� ��������� � �������� � �����
begin                                                                       //False - ������������
  if Oper = 'not' then                                                      //False - ����
    result:= 1
  else if Oper = '('  then                                                  // 1 ������� �����
    result:= 2
  else if LastStEl = 'not'  then                                                  // 1 ������� �����
    result:= 6
  else if Oper = ')'  then                                                  // 1 ������� �����
    result:= 3
  else if Oper = LastStEl  then                                                  // 1 ������� �����
    result:= 5
  else if ((Oper = 'or') and (LastStEl = 'xor')) or ((Oper = 'xor') and (LastStEl = 'or'))  then                                                  // 1 ������� �����
    result:= 5
  else if (LastStEl = 'and') and ((Oper = 'or') or (Oper = 'xor')) then                                                  // 1 ������� �����
    result:= 7                                                                                                            // 2 ����
  else if Oper = 'and' then                                                                                               // 3 ������������ + ����
    result:= 4
  else if LastStEl = '(' then                                                                                           // 3 ������������ + ����
    result:= 4
  else                                                                      // 1 ������� �����
    result:= -1;                                                             // 2 (
                                                                            // 3 )
  {if Oper = 'not' then                                                     // 4 ����
    result:= true                                                           // 5 �����������
  else if Oper = LastStEl then                                              // 6 ����� ����� ������� 'not' �� �����
    result:= false                                                          // 7 ����
  else if Oper = 'and' then
    result:= true
  else
    result:= false; }
end;

function Operations(Oper:String):Boolean;
begin
  if Oper = 'not'  then
    result:= True
  else if Oper = 'and' then
    result:=True
  else if Oper = 'or' then
    result:=True
  else if Oper = 'xor' then
    result:=True
  else if Oper = '(' then
    result:=True
  else if Oper = ')' then
    result:=True
  else
    result:= false;
end;

function CheckSymbol(s:string):Boolean;
var
  i:integer;
begin
  result := False;
  if (s <> 'and') and (s <> 'or') and (s <> 'xor') and (s <> 'not') then
    result:= True;
  for i:= 1 to length(s) do;
  begin
    if ((result) and (s[i] in Eletters)) then
      result:=false;
  end;
end;

function InputExpress(s: string; var Wordnumb:Integer; var flag:Boolean):TArr;
Var
  i, InputErr: Integer;
  Brackets, Operation, UnMin, Numb: Integer;
  //s:string;
  //Input:TArr;
Begin
 // Repeat
    Brackets := 0;
    Operation := 0;
    Numb := 0;
    UnMin := 0;
    InputErr := 0;
    //readln(s);
    Wordnumb:=0;
    result:=LexAnalyser(s,Wordnumb);
    i := 0;
    while (i < (Wordnumb)) and (InputErr < 2)  do
    Begin
      if result[i] = '(' then Inc(Brackets)
      else if result[i] = ')' then Dec(Brackets)
      else if result[i] = 'not' then
          begin
            if i = 0 then
              Inc(UnMin);
           if {not (result[i+1][1] =  '(') and (CheckSymbol(result[i+1]))} not (CheckSymbol(result[i+1]) or (result[i+1] = '(')) then
            begin
              InputErr := 2;
              //SyntaxError('Incorrectly used unary minus');
              flag:=false
            end;
          end
      else if (result[i] =  'or') or  (result[i] = 'xor') or  (result[i] = 'and') then
      begin
          if InputErr = 1 then
          begin
            InputErr := 0;
            Inc(Operation);
          end

          else
          begin
            InputErr := 2;
            //SyntaxError('Invalid number of operands and operations');
            flag:=false
          end
       end
      else if CheckSymbol(result[i]) then
          if InputErr = 0 then
          begin
            InputErr := 1;
            Inc(Numb);
          end

          else
          begin
            InputErr := 2;
            flag:=false;
            //SyntaxError('Invalid number of operands and operations');
          end
      else
      begin
        InputErr := 2;
        //SyntaxError('Invalid character');
        flag:=false
      end;


      if Brackets < 0 then
      begin
        InputErr := 2;
        //SyntaxError('Invalid parenthesis order');
        flag:=false
      end;

      inc(i);
    end;

      if (Numb - Operation <> 1) or
         ((Numb < 2) and (UnMin = 0)) or
         (Brackets <> 0) then
        InputErr := 2;

      if InputErr = 2 then
        //SyntaxError('Incorrect input. Please try again')
        flag:=false
      else
        InputErr := 0;
  //until InputErr = 0;
end;

function ParseExpr(s:string; var flag: Boolean; var Wordnumb:Integer):TArr;
var
  Arr{,ArrRPN}:TArr;
  i,k,{WordNumb,}elem:Integer;
  MyStek:TSPStek;
begin
  flag:=True;
  Arr:=InputExpress(s,Wordnumb, flag);
  elem:=4;
  SetLength(result, elem);
  if flag then
  begin
    k:=0;
    i:=0;
    MyStek:=nil;
    while i < (Wordnumb)  do
    begin
      if Operations(Arr[i]) then
      begin
        if MyStek = nil then
        begin
          PushStek(MyStek,Arr[i]);
          inc(i);
        end
        else case OperPrior(Arr[i],MyStek^.El) of
          1 :
            begin
              PushStek(MyStek,Arr[i]);
              inc(i);
            end;
          2 :
            begin
              PushStek(MyStek,Arr[i]);
              inc(i);
            end;
          3 :
            begin
              While (MyStek^.ADR <> nil) and (MyStek^.El <> '(')  do
              begin
                if k = elem then
                begin
                  elem:= elem * 2;
                  SetLength(result, elem);
                end;
                PopStek(MyStek,result[k]);
                inc(k);
              end;
              MyStek:=MyStek^.ADR;
              inc(i);
            end;
          4 :                             
            begin
              PushStek(MyStek,Arr[i]);
              inc(i);
            end;
          5:
            begin
              if k = elem then
              begin
                elem:= elem * 2;
                SetLength(result, elem);
              end;
              PopStek(MyStek,result[k]);
              inc(k);
              PushStek(MyStek,Arr[i]);
              inc(i);
            end;
          6:
            begin
              if k = elem then
              begin
                elem:= elem * 2;
                SetLength(result, elem);
              end;
              PopStek(MyStek,result[k]);
              inc(k);
            end;
          7:
            begin
              if k = elem then
              begin
                elem:= elem * 2;
                SetLength(result, elem);
              end;
              PopStek(MyStek,result[k]);
              inc(k);
            end;
        end;
      end
      else
      begin
        if k = elem then
        begin
          elem:= elem * 2;
          SetLength(result, elem);
        end;
        result[k]:= Arr[i];
        inc(k);
        inc(i);
      end;
    end;

    While MyStek <> nil do                                    //��������� �� �����
    begin
      if (MyStek^.El = '(') then
        MyStek:=MyStek^.ADR
      else
      begin
        if k = elem then
        begin
          elem:= elem * 2;
          SetLength(result, elem);
        end;
        PopStek(MyStek,result[k]);
        inc(k);
      end;
    end;
    i := 0;
    while (i <= High(result)) and (result[i] <> '') do
      inc(i);
    SetLength(result,i);
  end
end;

end.
