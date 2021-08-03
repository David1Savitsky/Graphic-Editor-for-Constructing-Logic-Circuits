unit UHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  THelp = class(TForm)
    lblMain: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadData();
  end;

var
  Help: THelp;

implementation

{$R *.dfm}

{ THelp }

procedure THelp.LoadData;
var
  buf: string;
  f: Textfile;    
begin
  AssignFile(f,'Documentation.txt');
  Reset(f);
  Read(f,buf);
  lblMain.Caption := buf;
  CloseFile(f);
end;

end.
