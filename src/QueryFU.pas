unit QueryFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TQueryDlg = class(TForm)
    QueryBevel: TBevel;
    QueryNoBtn: TButton;
    QueryLbl: TLabel;
    QueryYesBtn: TButton;
    procedure QueryYesBtnClick(Sender: TObject);
    procedure QueryYesBtnKeyPress(Sender: TObject; var Key: Char);
    procedure QueryNoBtnKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QueryDlg: TQueryDlg;

implementation

{$R *.DFM}

procedure TQueryDlg.QueryYesBtnClick(Sender: TObject);
begin
 Close
end;

procedure TQueryDlg.QueryYesBtnKeyPress(Sender: TObject; var Key: Char);
begin
 if Key in [#13,'Y','y'] then
  ModalResult:=mrYes
 else
 if Key in ['N','n'] then
  ModalResult:=mrNo
end;

procedure TQueryDlg.QueryNoBtnKeyPress(Sender: TObject; var Key: Char);
begin
 if Key in [#13,'N','n'] then
  ModalResult:=mrNo
 else
 if Key in ['Y','y'] then
  ModalResult:=mrYes
end;

end.
