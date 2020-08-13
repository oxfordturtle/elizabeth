unit ActionU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TActionForm = class(TForm)
    ActionLbl: TLabel;
    Label1: TLabel;
    CondLbl: TLabel;
    Label3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActionForm: TActionForm;

implementation

{$R *.DFM}

end.
