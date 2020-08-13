unit ElizaControlFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons;

type
  TControlForm = class(TForm)
    RecursionChk: TCheckBox;
    OKBtn: TButton;
    IterCycleBtn: TButton;
    GroupBox7: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    MatchLimitSpin: TSpinEdit;
    HaltBtn: TButton;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    GroupBox2: TGroupBox;
    OutputIterOnRadio: TRadioButton;
    OutputIterUndoRadio: TRadioButton;
    OutputIterOffRadio: TRadioButton;
    OutputIterSpin: TSpinEdit;
    GroupBox4: TGroupBox;
    FinalIterOnRadio: TRadioButton;
    FinalIterUndoRadio: TRadioButton;
    FinalIterOffRadio: TRadioButton;
    FinalIterSpin: TSpinEdit;
    GroupBox1: TGroupBox;
    InputIterOnRadio: TRadioButton;
    InputIterUndoRadio: TRadioButton;
    InputIterOffRadio: TRadioButton;
    InputIterSpin: TSpinEdit;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    GroupBox5: TGroupBox;
    OutputCycleOnRadio: TRadioButton;
    OutputCycleUndoRadio: TRadioButton;
    OutputCycleOffRadio: TRadioButton;
    OutputCycleSpin: TSpinEdit;
    GroupBox6: TGroupBox;
    FinalCycleOnRadio: TRadioButton;
    FinalCycleUndoRadio: TRadioButton;
    FinalCycleOffRadio: TRadioButton;
    FinalCycleSpin: TSpinEdit;
    GroupBox3: TGroupBox;
    InputCycleOnRadio: TRadioButton;
    InputCycleUndoRadio: TRadioButton;
    InputCycleOffRadio: TRadioButton;
    InputCycleSpin: TSpinEdit;
    HaltLbl: TLabel;
    HaltHelpBtn: TSpeedButton;
    Label15: TLabel;
    MemCheckSpin: TSpinEdit;
    CancelBtn: TButton;
    procedure RecursionChkClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure IterCycleBtnClick(Sender: TObject);
    procedure HaltBtnClick(Sender: TObject);
    procedure HaltHelpBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ControlForm: TControlForm;

procedure initcontrol;
procedure fixoptform2;

implementation

uses ElizaTypes,ElizaUtils,ElizaEditFU, ElizaOptionsFU;

var inputiterdef: integer = 10;  {defaults to come into force when recursion}
    inputcycledef: integer = 10; {checkbox is de-checked}
    outputiterdef: integer = 10;
    outputcycledef: integer = 10;
    finaliterdef: integer = 10;
    finalcycledef: integer = 10;

{$R *.DFM}

procedure initcontrol;

 procedure fixsetting(var setting: integer;var ron,rundo,roff: TRadioButton;
                                           var spin: TSpinEdit);
 begin
  if ron.Checked then
   setting:=unlimited
  else
  if roff.Checked then
   setting:=0
  else
  if rundo.Checked then {should always be one of the three}
   setting:=spin.Value
 end;

begin
 with ControlForm do
  begin
   recurse:=RecursionChk.Checked;
   fixsetting(inputiter,InputIterOnRadio,InputIterUndoRadio,InputIterOffRadio,InputIterSpin);
   fixsetting(outputiter,OutputIterOnRadio,OutputIterUndoRadio,OutputIterOffRadio,OutputIterSpin);
   fixsetting(finaliter,FinalIterOnRadio,FinalIterUndoRadio,FinalIterOffRadio,FinalIterSpin);
   fixsetting(inputcycle,InputCycleOnRadio,InputCycleUndoRadio,InputCycleOffRadio,InputCycleSpin);
   fixsetting(outputcycle,OutputCycleOnRadio,OutputCycleUndoRadio,OutputCycleOffRadio,OutputCycleSpin);
   fixsetting(finalcycle,FinalCycleOnRadio,FinalCycleUndoRadio,FinalCycleOffRadio,FinalCycleSpin);
   matchlimit:=MatchLimitSpin.Value;
   memchecklimit:=MemCheckSpin.Value
  end
end;

procedure fixoptform2;

 function showlabel(n: integer): string;
 begin
  case n of
   0:         result:='NO';
   unlimited: result:='YES';
   else       result:='to '+IntToStr(n)
  end
 end;

begin
 with SettingsForm do
  begin
   RecurShowChk.Checked:=recurse;
   InItShowLbl.Caption:=showlabel(inputiter);
   OutItShowLbl.Caption:=showlabel(outputiter);
   FinItShowLbl.Caption:=showlabel(finaliter);
   InCyShowLbl.Caption:=showlabel(inputcycle);
   OutCyShowLbl.Caption:=showlabel(outputcycle);
   FinCyShowLbl.Caption:=showlabel(finalcycle);
   LimitsShowLbl.Caption:=IntToStr(matchlimit)+','+IntToStr(memchecklimit)
  end
end;

procedure TControlForm.RecursionChkClick(Sender: TObject);

 procedure fixrecurseenable(onoff: boolean);
 begin
  with ControlForm do
   begin
    InputIterUndoRadio.Enabled:=onoff;
    InputIterSpin.Enabled:=onoff;
    InputCycleUndoRadio.Enabled:=onoff;
    InputCycleSpin.Enabled:=onoff;
    OutputIterUndoRadio.Enabled:=onoff;
    OutputIterSpin.Enabled:=onoff;
    OutputCycleUndoRadio.Enabled:=onoff;
    OutputCycleSpin.Enabled:=onoff;
    FinalIterUndoRadio.Enabled:=onoff;
    FinalIterSpin.Enabled:=onoff;
    FinalCycleUndoRadio.Enabled:=onoff;
    FinalCycleSpin.Enabled:=onoff;
   end
 end;

 procedure fixchecks1(var def: integer; var rundo,roff,ron: TRadioButton;var spin: TSpinEdit);
 begin
  if rundo.Checked then
   begin
    if def=0 then
     roff.Checked:=true
    else
     ron.Checked:=true
   end;
 end;

 procedure fixchecks2(var value,def: integer; var rundo: TRadioButton);
 begin
  if def>0 then
   begin
    def:=value;
    rundo.Checked:=true
   end
 end;

begin
 recurse:=RecursionChk.Checked;
 if recurse then
  begin
   fixchecks1(inputiterdef,InputIterUndoRadio,InputIterOffRadio,InputIterOnRadio,InputIterSpin);
   fixchecks1(inputcycledef,InputCycleUndoRadio,InputCycleOffRadio,InputCycleOnRadio,InputCycleSpin);
   fixchecks1(outputiterdef,OutputIterUndoRadio,OutputIterOffRadio,OutputIterOnRadio,OutputIterSpin);
   fixchecks1(outputcycledef,OutputCycleUndoRadio,OutputCycleOffRadio,OutputCycleOnRadio,OutputCycleSpin);
   fixchecks1(finaliterdef,FinalIterUndoRadio,FinalIterOffRadio,FinalIterOnRadio,FinalIterSpin);
   fixchecks1(finalcycledef,FinalCycleUndoRadio,FinalCycleOffRadio,FinalCycleOnRadio,FinalCycleSpin);
   fixrecurseenable(false)
  end
 else
  begin
   fixrecurseenable(true);
   fixchecks2(inputiter,inputiterdef,InputIterUndoRadio);
   fixchecks2(inputcycle,inputcycledef,InputCycleUndoRadio);
   fixchecks2(outputiter,outputiterdef,OutputIterUndoRadio);
   fixchecks2(outputcycle,outputcycledef,OutputCycleUndoRadio);
   fixchecks2(finaliter,finaliterdef,FinalIterUndoRadio);
   fixchecks2(finalcycle,finalcycledef,FinalCycleUndoRadio);
  end
end;

procedure TControlForm.OKBtnClick(Sender: TObject);
begin
 initcontrol;
 close
end;

procedure TControlForm.IterCycleBtnClick(Sender: TObject);
begin
 itercycle:=not(itercycle);
 if itercycle then
  begin
   InputIterOnRadio.Checked:=true;
   InputCycleOnRadio.Checked:=true;
   OutputIterOnRadio.Checked:=true;
   OutputCycleOnRadio.Checked:=true;
   FinalIterOnRadio.Checked:=true;
   FinalCycleOnRadio.Checked:=true;
   IterCycleBtn.Caption:='Set ''prevention'' options for input/output/final iteration && cycling'
  end
 else
  begin
   InputIterOffRadio.Checked:=true;
   InputCycleOffRadio.Checked:=true;
   OutputIterOffRadio.Checked:=true;
   OutputCycleOffRadio.Checked:=true;
   FinalIterOffRadio.Checked:=true;
   FinalCycleOffRadio.Checked:=true;
   IterCycleBtn.Caption:='Set ''unlimited'' options for input/output/final iteration && cycling'
  end
end;

procedure TControlForm.HaltBtnClick(Sender: TObject);
begin
 showaction('{Exceeding limit of calls to matching algorithm}',haltaction)
end;

procedure TControlForm.HaltHelpBtnClick(Sender: TObject);
begin
 inform('To adjust halting message, use "H" command in Script.')
end;

procedure TControlForm.CancelBtnClick(Sender: TObject);
begin
 close
end;

end.

