unit ElizaEditFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus;

type
  TEditForm = class(TForm)
    EditorMenu: TMainMenu;
    EMenuFile: TMenuItem;
    EMenuFileNew: TMenuItem;
    EMenuFileOpen: TMenuItem;
    EMenuFileSave: TMenuItem;
    EMenuFileClose: TMenuItem;
    EditOpenDlg: TOpenDialog;
    EditSaveDlg: TSaveDialog;
    EditorMemo: TMemo;
    EMenuView: TMenuItem;
    EMenuViewFont: TMenuItem;
    EditorFontDlg: TFontDialog;
    EMenuViewWordwrap: TMenuItem;
    EMenuFileSaveAs: TMenuItem;
    EMenuFileRestart: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    EMenuFileSwitch: TMenuItem;
    EMenuFileLoad: TMenuItem;
    EMenuFileTransfer: TMenuItem;
    EditorLbl: TLabel;
    EMenuEdit: TMenuItem;
    EMenuEditCut: TMenuItem;
    EMenuEditCopy: TMenuItem;
    EMenuEditPaste: TMenuItem;
    N3: TMenuItem;
    EMenuEditFind: TMenuItem;
    EMenuEditUndo: TMenuItem;
    EMenuFilePrint: TMenuItem;
    RichEdit1: TRichEdit;
    EditPrintSetupDlg: TPrinterSetupDialog;
    procedure EMenuFileCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EMenuFileNewClick(Sender: TObject);
    procedure EMenuFileOpenClick(Sender: TObject);
    procedure EMenuFileSaveClick(Sender: TObject);
    procedure EMenuViewFontClick(Sender: TObject);
    procedure EMenuViewWordwrapClick(Sender: TObject);
    procedure EMenuFileSaveAsClick(Sender: TObject);
    procedure EMenuFileRestartClick(Sender: TObject);
    procedure EMenuFileSwitchClick(Sender: TObject);
    procedure EMenuFileLoadClick(Sender: TObject);
    procedure EMenuFileTransferClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EMenuEditCutClick(Sender: TObject);
    procedure EMenuEditCopyClick(Sender: TObject);
    procedure EMenuEditPasteClick(Sender: TObject);
    procedure EMenuEditFindClick(Sender: TObject);
    procedure EMenuEditUndoClick(Sender: TObject);
    procedure EMenuFilePrintClick(Sender: TObject);
    procedure EMenuHelpClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditorMemoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditorMemoChange(Sender: TObject);
    procedure EditorMemoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function loadeditor(fname: string): boolean;

var
  EditForm: TEditForm;

implementation

uses ElizaU, ElizaTypes, ElizaUtils, ElizaEditFindFU, ElizaScript;

{$R *.DFM}

function loadeditor(fname: string): boolean;
var fullname: string; {FNAME is name relative to program directory}
begin
 result:=false;
 if fname<>'' then
  begin
   fullname:=fullpath(fname);
   if FileExists(fullname) then
    begin
     editorfile:=fname;
     EditForm.EditorMemo.Lines.LoadFromFile(fullname);
     EditForm.EditorLbl.Caption:='EDITING FILE:  '+editorfile;
     result:=true
    end
   else
    inform('File "'+fullname+'" not found')
  end
end;

function saveeditor: boolean;
begin
 with EditForm do
  with EditSaveDlg do
   begin
    FileName:=fullpath(editorfile);
    result:=false;
    if Execute then
     begin
      EditorMemo.Lines.SaveToFile(FileName);
      EditorMemo.Modified:=false;
      editorfile:=ExtractRelativePath(basepath,FileName);
      if pos('..\..',editorfile)>0 then
       editorfile:=FileName;
      EditorLbl.Caption:='EDITING FILE:  '+editorfile;
      result:=true
     end
   end
end;

procedure TEditForm.EMenuFileCloseClick(Sender: TObject);
begin
 Close
end;

procedure TEditForm.FormResize(Sender: TObject);
begin
 EditorMemo.Width:=Width-40;  {790, 750}
 EditorLbl.Width:=EditorMemo.Width;
 EditorMemo.Height:=Height-92 {559, 467}
end;

procedure TEditForm.EMenuFileNewClick(Sender: TObject);
begin
 if EditorMemo.Modified then
  if not(query('This operation will lose the editing changes that you have made. '
              +'Are you sure you want to do this?')) then
   exit;
 EditorMemo.Clear;
 editorfile:='';
 EditForm.EditorLbl.Caption:='(no file)'
end;

procedure TEditForm.EMenuFileOpenClick(Sender: TObject);
var relpath: string;
begin
 if EditorMemo.Modified then
  if not(query('This operation will lose the editing changes that you have made. '
              +'Are you sure you want to do this?')) then
   exit;
 with EditOpenDlg do
  begin
   if editorfile<>'' then
    Filename:=fullpath(editorfile);
   if Execute then
    begin
     relpath:=ExtractRelativePath(basepath,FileName);
     if pos('..\..',relpath)>0 then
      relpath:=FileName;
     loadeditor(relpath)
    end
  end
end;

procedure TEditForm.EMenuFileLoadClick(Sender: TObject);
begin
 if EditorMemo.Modified then
  if not(query('This operation will lose the editing changes that you have made. '
              +'Are you sure you want to do this?')) then
   exit;
 loadeditor(mainscriptfile)
end;

procedure TEditForm.EMenuFileSaveClick(Sender: TObject);
begin
 if editorfile='' then
  saveeditor
 else
  begin
   if FileExists(fullpath(editorfile)) then
    if not(query('Overwrite previous version of file?')) then
     exit;
   EditorMemo.Lines.SaveToFile(fullpath(editorfile));
   EditorMemo.Modified:=false
  end
end;

procedure TEditForm.EMenuViewFontClick(Sender: TObject);
begin
 EditorFontDlg.Font:=EditorMemo.Font;
 if EditorFontDlg.Execute then
  EditorMemo.Font:=EditorFontDlg.Font
end;

procedure TEditForm.EMenuViewWordwrapClick(Sender: TObject);
begin
 EMenuViewWordwrap.Checked:=not(EMenuViewWordwrap.Checked);
 EditorMemo.WordWrap:=EMenuViewWordwrap.Checked;
 with EditorMemo do
  if WordWrap then
   ScrollBars:=ssVertical
  else
   ScrollBars:=ssBoth
end;

procedure TEditForm.EMenuFileSaveAsClick(Sender: TObject);
begin
 saveeditor
end;

function saveroutine: boolean;
begin
 with EditForm do
  if editorfile='' then
   result:=saveeditor
  else
   begin
    result:=true;
    if not(FileExists(fullpath(editorfile))) then
     begin
      EditorMemo.Lines.SaveToFile(fullpath(editorfile));
      EditorMemo.Modified:=false
     end
    else
    if EditorMemo.Modified then
     begin
      if query('Overwrite previous version of file?') then
       begin
        EditorMemo.Lines.SaveToFile(fullpath(editorfile));
        EditorMemo.Modified:=false
       end
      else
       result:=saveeditor
     end;
   end
end;

procedure TEditForm.EMenuFileRestartClick(Sender: TObject);
begin
 if not(saveroutine) then
  exit;
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 if restart(mainscriptfile,randseed,true) then
  begin
   ElizaForm.BringToFront;
   ElizaForm.InputEdit.SetFocus
  end
end;

procedure TEditForm.EMenuFileTransferClick(
  Sender: TObject);
begin
 if not(saveroutine) then
  exit;
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 mainscriptfile:=editorfile;
 restart(mainscriptfile,randseed,true)
end;


procedure TEditForm.EMenuFileSwitchClick(Sender: TObject);
begin
  begin
   ElizaForm.BringToFront;
   ElizaForm.InputEdit.SetFocus
  end
end;

procedure TEditForm.FormCreate(Sender: TObject);
begin
 EditOpenDlg.InitialDir:=progpath+userdir;
 EditSaveDlg.InitialDir:=progpath+userdir
end;

procedure TEditForm.EMenuEditCutClick(Sender: TObject);
begin
 EditorMemo.CutToClipboard
end;

procedure TEditForm.EMenuEditCopyClick(Sender: TObject);
begin
 EditorMemo.CopyToClipboard
end;

procedure TEditForm.EMenuEditPasteClick(Sender: TObject);
begin
 EditorMemo.PasteFromClipboard
end;

procedure TEditForm.EMenuEditFindClick(Sender: TObject);
begin
 with ElizaEditFindForm do
  begin
   Show;
   FindEdit.SetFocus
  end
end;

procedure TEditForm.EMenuEditUndoClick(Sender: TObject);
begin
 EditorMemo.Undo
end;

procedure TEditForm.EMenuFilePrintClick(Sender: TObject);
begin
 RichEdit1.Font:=EditorMemo.Font;
 RichEdit1.Text:=EditorMemo.Text;
 if EditPrintSetupDlg.Execute then
  RichEdit1.Print('Elizabeth Script '+editorfile)
end;

procedure TEditForm.EMenuHelpClick(Sender: TObject);
begin
 Application.HelpJump('HelpEditor')
end;

procedure TEditForm.Button1Click(Sender: TObject);
begin
 if EditorMemo.Modified then
  ShowMessage('Modified')
end;

procedure TEditForm.EditorMemoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 fixselection
end;

procedure TEditForm.EditorMemoChange(Sender: TObject);
begin
 {fixselection {when replacement is done, temporarily makes SelLength=0 here}
end;

procedure TEditForm.EditorMemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 fixselection
end;

end.
