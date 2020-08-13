unit InformFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TInformDlg = class(TForm)
    InformBevel: TBevel;
    InformOKBtn: TButton;
    InformLbl: TLabel;
    procedure InformOKBtnClick(Sender: TObject);
    procedure InformOKBtnKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InformDlg: TInformDlg;

implementation

uses ElizaTypes;

{$R *.DFM}

procedure TInformDlg.InformOKBtnClick(Sender: TObject);
begin
 Close
end;

procedure TInformDlg.InformOKBtnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key =VK_RETURN then
  ModalResult:=mrOk
end;

end.
