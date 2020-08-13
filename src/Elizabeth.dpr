program Elizabeth;

uses
  Forms,
  ElizaU in 'ElizaU.pas' {ElizaForm},
  ElizaTypes in 'ElizaTypes.pas',
  ElizaUtils in 'ElizaUtils.pas',
  ElizaSetup in 'ElizaSetup.pas',
  ElizaAdd in 'ElizaAdd.pas',
  ElizaProcess in 'ElizaProcess.pas',
  ActionU in 'ActionU.pas' {ActionForm},
  ElizaEditFU in 'ElizaEditFU.pas' {EditForm},
  ElizaControlFU in 'ElizaControlFU.pas' {ControlForm},
  ElizaEditFindFU in 'ElizaEditFindFU.pas' {ElizaEditFindForm},
  InformFU in 'InformFU.pas' {InformDlg},
  ElizaMatch in 'ElizaMatch.pas',
  ElizaExecute in 'ElizaExecute.pas',
  ElizaMemFun in 'ElizaMemFun.pas',
  ElizaScript in 'ElizaScript.pas',
  QueryFU in 'QueryFU.pas' {QueryDlg},
  ElizaOptionsFU in 'ElizaOptionsFU.pas' {SettingsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TElizaForm, ElizaForm);
  Application.CreateForm(TActionForm, ActionForm);
  Application.CreateForm(TControlForm, ControlForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TElizaEditFindForm, ElizaEditFindForm);
  Application.CreateForm(TInformDlg, InformDlg);
  Application.CreateForm(TQueryDlg, QueryDlg);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run
end.
