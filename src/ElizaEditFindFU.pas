unit ElizaEditFindFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TElizaEditFindForm = class(TForm)
    ReplaceEdit: TEdit;
    Label2: TLabel;
    FindEdit: TEdit;
    ReplaceChk: TCheckBox;
    FindNextBtn: TButton;
    ReplaceBtn: TButton;
    CancelBtn: TButton;
    ReplFindChk: TCheckBox;
    ReplaceAllBtn: TButton;
    ReplAllScopeChk: TCheckBox;
    Label1: TLabel;
    FindStartBtn: TButton;
    procedure ReplaceChkClick(Sender: TObject);
    procedure FindNextBtnClick(Sender: TObject);
    procedure ReplaceBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ReplaceAllBtnClick(Sender: TObject);
    procedure FindStartBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ElizaEditFindForm: TElizaEditFindForm;

procedure fixselection;

implementation

{$R *.DFM}

uses ElizaEditFU, ElizaUtils;

procedure fixselection;
begin
 with ElizaEditFindForm do
  with EditForm.EditorMemo do
   with ReplAllScopeChk do
    begin
     Enabled:=ReplaceChk.Checked {and ((SelLength>0) or (SelStart>0))};
     if EditForm.EditorMemo.SelLength>0 then
      Caption:='... in selection'
     else
      Caption:='... from cursor'
    end
end;

procedure TElizaEditFindForm.ReplaceChkClick(Sender: TObject);
begin
 ReplaceEdit.Enabled:=ReplaceChk.Checked;
 ReplaceBtn.Enabled:=ReplaceChk.Checked;
 ReplFindChk.Enabled:=ReplaceChk.Checked;
 ReplaceAllBtn.Enabled:=ReplaceChk.Checked;
 fixselection
end;

procedure specchar(VAR s: string);
var posn: integer;
begin
 posn:=pos('##',s);
 while posn>0 do
  begin
   s[posn]:=#13;
   s[posn+1]:=#10;
   posn:=pos('##',s)
  end;
end;

procedure find(fromstart: boolean);
var textstring,findstring: string;
    posn: integer;
begin
 with ElizaEditFindForm do
  begin
   findstring:=FindEdit.Text;
   if findstring='' then
    exit;
   specchar(findstring);
   with EditForm.EditorMemo do
    begin
     textstring:=Text;
     if SelStart=0 then
      fromstart:=true;
     if not(fromstart) then
      delete(textstring,1,SelStart+1);
     posn:=pos(findstring,textstring);
     if posn>0 then
      begin
       if fromstart then
        SelStart:=posn-1
       else
        SelStart:=SelStart+posn;
       SelLength:=length(findstring)
      end
     else
      inform('Not found')
    end
  end;
 fixselection
end; {procedure find}

procedure TElizaEditFindForm.FindNextBtnClick(Sender: TObject);
begin
 find(false)
end;

procedure TElizaEditFindForm.FindStartBtnClick(Sender: TObject);
begin
 find(true)
end;

procedure TElizaEditFindForm.ReplaceBtnClick(Sender: TObject);
var replstring,textstring,findstring: string;
    posn: integer;
    fromstart: boolean;
begin
 replstring:=ReplaceEdit.Text;
 specchar(replstring);
 with EditForm.EditorMemo do
  begin
   posn:=SelStart;
   if posn>0 then
    begin
     SelText:=replstring;
     SelStart:=posn;
     SelLength:=length(replstring);
     Modified:=true;
     fixselection
    end;
   if ReplFindChk.Checked then
    begin
     findstring:=FindEdit.Text;
     if findstring='' then
      exit;
     specchar(findstring);
     textstring:=Text;
     fromstart:=(SelStart=0);
     if not(fromstart) then
      delete(textstring,1,SelStart+1);
     posn:=pos(findstring,textstring);
     if posn>0 then
      begin
       if fromstart then
        SelStart:=posn-1
       else
        SelStart:=SelStart+posn;
       SelLength:=length(findstring)
      end
     else
      inform('Not found')
    end
  end;
 fixselection
end;

procedure TElizaEditFindForm.ReplaceAllBtnClick(Sender: TObject);
var findstring,replstring,astring,bstring,textstring,zstring: string;
    posn,countrepl: integer;
    entiretext: boolean;
begin
 findstring:=FindEdit.Text;
 replstring:=ReplaceEdit.Text;
 specchar(findstring);
 specchar(replstring);
 entiretext:=not(ReplAllScopeChk.Checked);
 with EditForm.EditorMemo do
  begin
   textstring:=Text;
   astring:=''; {beginning, not searched}
   bstring:=''; {already processed}
   zstring:=''; {end, not searched}
   if not(entiretext) then
    begin
     astring:=copy(textstring,1,SelStart);
     delete(textstring,1,SelStart);
     if SelLength>0 then
      begin
       zstring:=textstring;
       textstring:=copy(textstring,1,SelLength);
       delete(zstring,1,SelLength)
      end
    end;
   posn:=pos(findstring,textstring);
   if posn>0 then
    begin
     countrepl:=0;
     while posn>0 do
      begin
       inc(countrepl);
       bstring:=bstring+copy(textstring,1,posn-1)+replstring;
       delete(textstring,1,posn-1+length(findstring));
       posn:=pos(findstring,textstring)
      end;
     Text:=astring+bstring+textstring+zstring;
     SelStart:=length(astring);
     if zstring='' then
      SelLength:=0
     else
      SelLength:=length(bstring)+length(textstring);
     Modified:=true;
     inform(IntToStr(countrepl)+' replacements made')
    end
   else
    inform('Not found')
  end;
 fixselection
end;

procedure TElizaEditFindForm.CancelBtnClick(Sender: TObject);
begin
 Close
end;

procedure TElizaEditFindForm.FormShow(Sender: TObject);
begin
 fixselection
end;

end.
