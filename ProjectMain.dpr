program ProjectMain;

uses
  Forms,
  UMain in 'UMain.pas' {Form2},
  UParseExpr in 'UParseExpr.pas',
  UAllTypes in 'UAllTypes.pas',
  UMakePrioritySp in 'UMakePrioritySp.pas',
  UHelp in 'UHelp.pas' {Help};

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := 'C:\�����\2 ���\������\All\Icons\���.ico';
  Application.CreateForm(TForm1, MainForm);
  Application.CreateForm(THelp, Help);
  Application.Run;
end.
