unit ElizaOptionsFU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSettingsForm = class(TForm)
    Label1: TLabel;
    DisablePanel: TPanel;
    CheckPunctChk: TCheckBox;
    SeqRadioGroup: TRadioGroup;
    EchoRadioGroup: TRadioGroup;
    CaseRadioGroup: TRadioGroup;
    SpeedRadioGroup: TRadioGroup;
    AnalysisRadioGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    RecurShowChk: TCheckBox;
    Label6: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    InItShowLbl: TLabel;
    OutItShowLbl: TLabel;
    FinItShowLbl: TLabel;
    InCyShowLbl: TLabel;
    OutCyShowLbl: TLabel;
    FinCyShowLbl: TLabel;
    Label14: TLabel;
    LimitsShowLbl: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RevertVBtn: TButton;
    RevertPBtn: TButton;
    Label10: TLabel;
    RevertCBtn: TButton;
    procedure DisablePanelEnter(Sender: TObject);
    procedure DisablePanelExit(Sender: TObject);
    procedure RecurShowChkEnter(Sender: TObject);
    procedure RecurShowChkExit(Sender: TObject);
    procedure RevertVBtnClick(Sender: TObject);
    procedure RevertPBtnClick(Sender: TObject);
    procedure RevertCBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses ElizaU,ElizaScript,ElizaControlFU;

procedure TSettingsForm.DisablePanelEnter(Sender: TObject);
begin
 DisablePanel.Enabled:=false
end;

procedure TSettingsForm.DisablePanelExit(Sender: TObject);
begin
 DisablePanel.Enabled:=true
end;

procedure TSettingsForm.RecurShowChkEnter(Sender: TObject);
begin
 RecurShowChk.Enabled:=false
end;

procedure TSettingsForm.RecurShowChkExit(Sender: TObject);
begin
 RecurShowChk.Enabled:=true
end;

procedure TSettingsForm.RevertVBtnClick(Sender: TObject);
begin
 initVsettings;
 fixoptform
end;

procedure TSettingsForm.RevertPBtnClick(Sender: TObject);
begin
 initPsettings;
 fixoptform
end;

procedure TSettingsForm.RevertCBtnClick(Sender: TObject);
begin
 initcontrol;
 fixoptform2
end;

end.
