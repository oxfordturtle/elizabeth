{11/8/20 - got rid of all typed constants. This could only cause problems in
 cases where the "constant" is local to a subroutine but important to preserve
 between calls. So, for example, the STATE "constant" used in function ACTSTRING
 has now been made a variable within the wider procedure LOADSCRIPT}

{Fixed Turbo Eliza includes to say #INCLUDE My Scripts\...
 Not sure whether FULLPATH should be used in COPYSCRIPT procedure}

{Now references PDF file rather than online Help;
 Help file improved in various ways;
 Memory arrays example moved into earlier menu;
 Bug in Control menu save settings fixed - need to use
   fullpath(mainscriptfile) to get correct filename for saving}

{Can have circular references in memories, e.g.:

<[Mone]>: Mtwo B
<[Mtwo]>: Mone A
K TRY
 R [Mone]

MEMCHECK variables accordingly introduced, and Control dialog box changed}

{Self-deletion doesn't appear to apply to memories - need to clarify this in help}

{Should CHOOSEFIXED include MEMIOCHECK to substitute memories?
 Should there be an option to put text through processing by O or F before saving?}

{1/4/14 - introduced USERDIR with illustrative programs being copied over, to
 enable ELIZABETH and ILLUSTRATIVE SCRIPTS directories to be locked down}

{21/4/13 - Removed InitTimer and moved initialisation into on Activate. Timer
 didn't work - not sure why. Removed RANDOMIZE loop which seemed to hang under
 Delphi7 - presume change of behaviour in Delphi system. Resized all windows,
 systematised dialogue boxes (non-sizable, invisible scrollbars, consistent
 margins). Inconsistency in height setting of QueryDlg and InformDlg is odd.
 Numbered 2.06 to recognise move to Delphi7 etc.}

{12/3/2011 - developed loading of previously saved dialogue (e.g. of original
 Weizenbaum ELIZA script) to allow stepping through.
 '_' allowed to count in word, so as to enable [phrase] to include categories}

{9/3/2011 - added option to suppress "ECHO" of input, so separate recursion of
 parts isn't messed up and yet no keyword is needed to clear them up.}

{8/3/2011 - moved Void and NoKey responses before Final transformations,
 to enable adjustment of first/second person etc.}

{23/1/2011 - maybe allow no keyword responses to recurse, so as to be able to
 say =>O? No keyword responses should be checked for memory existence before
 applying, and need to be parsed to take recursion into account}

{Why is SPACEOUT used where it is? ...
 LEFTPATTERN in IOF transformations;
 KEYPATTERN in keyword;
 twice in APPLYIOFTRANSFORM;
 four times in APPLYKEYWORDTRANSFORMS;
 twice in PROCESSINPUT;
 now adapted to permit '=>'}

 {Applykeywordtransforms can now start from a specified index}
{'=' added to transformset}

{matchcount etc. zeroed on restart}

{Help on K WORD should make clear, in italic bit about dynamic commands, that it
 finds the first occurrence (if any) of the specified keyword, never more.
 "memories phrases" should be "memorised phrases". Also clarify when deletion
 of memories applies to one instance only, or potentially all that match.
 Sequential/randomised options (also saved in scripts and shown in Keyword table);
 K! and K? etc. make sets sequential or randomised; Need commands to make the
 relevant keyword the "last one used" in the set, and possibly +/- to move
 forward/back in set?  Correct Help to disallow '!' or '?' in index codes
 Fixed bug in adding K/R with specified index codes - N (position) not calculated

 Also done with fixed sets of messages - e.g. "V! WELL?" will make them sequential}

{24/1/2010 - added DEEPTRACE option to Analysis menu to avoid clutter in match tracing;
 bug fixed on index retention between Input and Output transforms when splitting text;
 bug fixed testing condition[length(condition)]='?' when CONDITION could be null}

{17/1/2010 - fixed Editor resizing and InformDlg/QueryDlg heights and buttons etc.;
 added trace for condition evaluation; renumbered to 2.05 to recognise time interval;
 fixed memory substitution to allow indirection, e.g. '[M[Mindex]]' and thus allow
 simple array manipulation; size constants increased and brought to top of code;
 Array and Turing scripts added to Help menu}

{8/10/2006 - capacity of everything doubled e.g. 50=>100, 500=>1000,
 last change to 2.04 before putting on Web}

{use "L" for loadfrom file! Maybe just save to memory?
 Need to have way of detecting end of file}

{12/2/06 "starred" introduced for self-deleting messages, using "\"}

{11/2/06 "S" introduced for savetofile, with index code as filename etc.,
 '\' for deletion or starting a new file. Q/X behaviour modified and treatment
 of conditions in searching for deletions (edit of command syntax reference)}

{10/2/06 - added eLizabeth icon and label (which disappears if name of script
 file is too long for label to fit); also InitTimer so that label appears
 before script is loaded and welcome message shown; previously initialsetup and
 initload were part of same routine, called with Form.OnPaint rather than OnShow.

 actiontodo while loop rather than for loop counts through actions, to allow for
 possibility than one action will create another - notably file saving

 File processing implemented through addsave procedure}

{19/1/06 - possnull cases dealt with in indiv and contig parts of MATCHWORD, to
 enable decreasing match of e.g. [dig1?] or [word1?] to match nothing even when
 it is followed by a non-null matching field}

{18/1/06 - questionnaire changed from "Leeds" to "Oxford", Help file
 stuff on "?" conditions added}

{Maybe have quitting ACTION rather than message, with output just one
 option? Then should have output action for other types of action
 context to use also.}

{14/1/06 - added ExitPanel etc. and Exit Prevention Message. Renamed "Exit" to
 "Quit" in menu. Need to add documentation accordingly.}

{14/1/06 - started "2.04" to respond to Kolb script. Code
 hangs in Delphi 7, so development continues in Delphi 5.}

{14/1/06 numactions initialised to 0 rather than 100, to avoid
 "more than 100" operations when welcome message includes action.}

{Allow "i", "o", "f" in script to give non-iterating transformations?}

{"Are you sure you want to proceed?" changed to "... do this?"}

{Match algorithm limit changed to 5000 - recursive calls aren't counted
 match count shown in trace table}

{Can put "?" after condition to give TRUE if memories are absent}

{DOACTIONS ensures pending actions are not performed if pause results in halt}

{'" '+errorcontext - space inserted}

{Inform and Query dialogues use ampersand}

{"Illustrative Scripts" directory implemented, e.g. in loadeditor
 and recreation of Elizabeth.txt; added COPYTURBO routine 25/02/05}

{Recreation of Elizabeth.txt from EOriginal.txt (NOT ElizaOrig.txt)
implemented correctly - applies when Elizabeth.txt is absent}

{Inform dialogue centred reliably through use of poOwnerFormCenter}

{Pause added, and keyboard responses to Query & Inform
 Some work done on resolution script, which cannot handle
 P; P implies (Q or R) ; Q implies S; R implies S; therefore S}

{Improved find and replace, with check for selected text etc.}

{Printer dialogues added}

{Checks for "Modified" before saving over original etc. - see "saveroutine";
 "saidgoodbye" introduced to avoid missing quitting message}

{Invoking help file script doesn't automatically run it -
 just puts it into Editor}

{Help menu with illustrative file options}

{Check for failure to load file, e.g. due to being used in Word etc. -
 LOADFILE should probably be a function, like RESTART}

{Do concatenation conditions work? Is DELPADDING adequate in CONDOK test?}

{Check array limits, e.g. memories, outputs, inputs}

{No-keyword response ought to go through output transforms (?)
 e.g. "my ... me" DOES THAT HAVE ANYTHING TO DO WITH THE FACT THAT ... me?}

{Document how condition is tested when replacing transformations etc}

{Undo needs to be much better}

{Must do spacing on Keywords - previously SEEMED to work because field spacing
 made up for lack of punctuation spacing - SPACEOUT inserted, but is that enough?}

{Need to disallow functions on lhs of tests (?), and check for this}

{inc: and dec: now (almost) universal inverses - '' is the exception}

{"No closing bracket for INC" etc is a pain when it repeats - should quit}

{Document that it continues iterating/cycling now, even if active text
 remains the same, if any actions have taken place. Should perhaps be
 some way of preventing this happening if desired?}

{Have way of getting hold of index codes??}

{Write up usage of '[]' to mean null string if this is OK generally}

{Need ability to define own wildcards?}

{Note that ordering of UPPERLOWER[] and SPACEOUT() matters, because SPACEOUT
 removes all spaces within square brackets!  Maybe make this cleverer to avoid
 possible issues in the future? Are memories affected, for example?}

{Add facility for assignment, to handle numbers etc?}

{Need to review punctuation handling generally, especially given recursion;
 check also on use of punctuation wildcards within system.}

{Ability to run a test dialogue useful for marking}

{should loadeditor give error if empty filename etc?}

{Have option to read inputs from file and write outputs to file, e.g.
 to convert grammar to input transforms}

{Maybe apply spacing before input transforms are displayed?
 Allow option for grammar-type spacing ") A" and "A A" the only spaces?}

{Put "are you sure?" in loading/saving/closing operations}

{Take a look at alphabets - are all restrictions necessary?}

{allow decimal points in numbers to be treated as though they were digits rather
than spaced punctuation}

{FIXUPPERLOWER false doesn't yet give an error message - where should the
 error go?}

{Check what happens with actions in iterated I/O transforms}

{Change quotes in Help file to single non-curved}

{Check spacing of activetext in trace display}

{allow definition of new pattern-types e.g. [#2words?] to mean [word1?] [word2?]
 allow disjunctive patterns, e.g. different types of punct, diff. letters}

{allow settings in Script, e.g. like repetition of input transformations from
 index1 to index2 indefinitely until no change etc. (same mechanism as with
 single input transformation)}

{perhaps have option always to choose "longest since last use" option - this
 could be set by default in options menu, but changeable by script or even
 interactively - ideally should also display in tables which options have
 been used (e.g. "1" for longest ago, "2" for next etc.}

unit ElizaU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Spin, Grids_ts, TSGrid, Menus,
  ElizaTypes;

type
  TElizaForm = class(TForm)
    InputEdit: TEdit;
    Label2: TLabel;
    InputBtn: TButton;
    LoadScriptDlg: TOpenDialog;
    TypingTimer: TTimer;
    SaveDialogueDlg: TSaveDialog;
    PageControl1: TPageControl;
    WelcomeTab: TTabSheet;
    VoidTab: TTabSheet;
    InputTab: TTabSheet;
    KeywordTab: TTabSheet;
    OutputTab: TTabSheet;
    DialogueTab: TTabSheet;
    DialogueRichEdit: TRichEdit; {Saved from Memo, Printed from RichEdit}
    MainMenu1: TMainMenu;
    MenuProcessing: TMenuItem;
    MenuFile: TMenuItem;
    MenuFileLoad: TMenuItem;
    MenuFileRestart: TMenuItem;
    MenuFileSave: TMenuItem;
    MenuFileQuit: TMenuItem;
    WelcomeGrid: TtsGrid;
    MenuHelp: TMenuItem;
    MenuFileOpenSaved: TMenuItem;
    ReplayDialogueDlg: TOpenDialog;
    TraceTab: TTabSheet;
    TraceGrid: TtsGrid;
    FinalTab: TTabSheet;
    InputGrid: TtsGrid;
    MemoryTab: TTabSheet;
    MemoryGrid: TtsGrid;
    KeywordGrid: TtsGrid;
    OutputGrid: TtsGrid;
    QuitGrid: TtsGrid;
    MenuProcUpper: TMenuItem;
    MenuProcLower: TMenuItem;
    InputPanel: TPanel;
    Label4: TLabel;
    InputLbl: TLabel;
    OutputPanel: TPanel;
    Label6: TLabel;
    OutputLbl: TLabel;
    MemoryPanel: TPanel;
    Label8: TLabel;
    MemoryLbl: TLabel;
    KeywordPanel: TPanel;
    Label9: TLabel;
    KeywordLbl1: TLabel;
    KeywordLbl2: TLabel;
    WelcomePanel: TPanel;
    Label10: TLabel;
    WelcomeLbl: TLabel;
    QuitPanel: TPanel;
    Label3: TLabel;
    QuitLbl: TLabel;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    MenuFileSwitch: TMenuItem;
    MenuFileCommand: TMenuItem;
    N8: TMenuItem;
    MenuFileTransfer: TMenuItem;
    ScriptLbl: TLabel;
    SpeakMemo: TMemo;
    MenuAnalysis: TMenuItem;
    MenuAnalysisShowHidden: TMenuItem;
    MenuAnalysisShowConds: TMenuItem;
    N4: TMenuItem;
    MenuAnalysisMatchI: TMenuItem;
    MenuAnalysisMatchK: TMenuItem;
    MenuAnalysisMatchO: TMenuItem;
    FinalPanel: TPanel;
    Label5: TLabel;
    FinalLbl: TLabel;
    FinalGrid: TtsGrid;
    MenuAnalysisMatchF: TMenuItem;
    VoidGrid: TtsGrid;
    VoidPanel: TPanel;
    Label1: TLabel;
    VoidLbl: TLabel;
    NoKeywordGrid: TtsGrid;
    NoKeywordPanel: TPanel;
    Label7: TLabel;
    NoKeywordLbl: TLabel;
    Label11: TLabel;
    MenuFilePrint: TMenuItem;
    FontDlg: TFontDialog;
    MenuFileFont: TMenuItem;
    MenuHelpOpen: TMenuItem;
    MenuHelpRecursion: TMenuItem;
    MenuHelpPropositional: TMenuItem;
    N9: TMenuItem;
    ILLUSTRATIVESCRIPTS1: TMenuItem;
    MenuHelpFirst: TMenuItem;
    MenuHelpBasic: TMenuItem;
    MenuHelpTurboAll: TMenuItem;
    MenuHelpTurboMod: TMenuItem;
    MenuHelpMemory: TMenuItem;
    MenuHelpRecurse: TMenuItem;
    MenuHelpHanoi: TMenuItem;
    MenuHelpArithRecurse: TMenuItem;
    MenuHelpArithCycle: TMenuItem;
    MenuHelpAdvanced: TMenuItem;
    MenuHelpPassive: TMenuItem;
    MenuHelpTag: TMenuItem;
    MenuHelpQuestionnaire: TMenuItem;
    MenuProcPunct: TMenuItem;
    DialoguePrintSetupDlg: TPrinterSetupDialog;
    ExitGrid: TtsGrid;
    ExitPanel: TPanel;
    Label12: TLabel;
    ExitLbl: TLabel;
    Image1: TImage;
    MenuAnalysisMatchE: TMenuItem;
    MenuHelpTuring: TMenuItem;
    MenuAnalysisDeep: TMenuItem;
    MenuProcSequential: TMenuItem;
    MenuProcRandom: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    N11: TMenuItem;
    N13: TMenuItem;
    MenuProcEcho: TMenuItem;
    MenuProcBlank: TMenuItem;
    MenuFileInputSaved: TMenuItem;
    N14: TMenuItem;
    MenuFileCloseSaved: TMenuItem;
    DialogueMemo: TMemo;
    MenuHelpDoctor: TMenuItem;
    MenuHelpArrays: TMenuItem;
    MenuView: TMenuItem;
    MenuViewShowAll: TMenuItem;
    MenuViewTonly: TMenuItem;
    MenuViewHide: TMenuItem;
    N15: TMenuItem;
    MenuViewInstant: TMenuItem;
    MenuViewFast: TMenuItem;
    MenuViewMedium: TMenuItem;
    MenuViewSlow: TMenuItem;
    N10: TMenuItem;
    MenuViewConversational: TMenuItem;
    MenuViewDevelopment: TMenuItem;
    MenuViewNormal: TMenuItem;
    N16: TMenuItem;
    MenuViewInsertVS: TMenuItem;
    MenuProcInsertPS: TMenuItem;
    N12: TMenuItem;
    MenuControl: TMenuItem;
    MenuControlPanel: TMenuItem;
    MenuControlInsertCS: TMenuItem;
    N17: TMenuItem;
    Displaycurrentsettingsdynamically1: TMenuItem;
    N2: TMenuItem;
    procedure TypingTimerTimer(Sender: TObject);
    procedure InputBtnClick(Sender: TObject);
    procedure MenuFileLoadClick(Sender: TObject);
    procedure MenuFileRestartClick(Sender: TObject);
    procedure MenuFileSaveClick(Sender: TObject);
    procedure MenuFileQuitClick(Sender: TObject);
    procedure MenuFileOpenSavedClick(Sender: TObject);
    procedure InputEditKeyPress(Sender: TObject; var Key: Char);
    procedure KeywordGridClickCell(Sender: TObject; DataColDown,
      DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
      UpPos: TtsClickPosition);
    procedure WelcomeGridClickCell(Sender: TObject; DataColDown,
      DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
      UpPos: TtsClickPosition);
    procedure QuitGridClickCell(Sender: TObject; DataColDown, DataRowDown,
      DataColUp, DataRowUp: Integer; DownPos, UpPos: TtsClickPosition);
    procedure VoidGridClickCell(Sender: TObject; DataColDown, DataRowDown,
      DataColUp, DataRowUp: Integer; DownPos, UpPos: TtsClickPosition);
    procedure InputGridClickCell(Sender: TObject; DataColDown, DataRowDown,
      DataColUp, DataRowUp: Integer; DownPos, UpPos: TtsClickPosition);
    procedure NoKeywordGridClickCell(Sender: TObject; DataColDown,
      DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
      UpPos: TtsClickPosition);
    procedure OutputGridClickCell(Sender: TObject; DataColDown,
      DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
      UpPos: TtsClickPosition);
    procedure MemoryGridClickCell(Sender: TObject; DataColDown,
      DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
      UpPos: TtsClickPosition);
    procedure MenuProcUpperClick(Sender: TObject);
    procedure MenuProcLowerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuFileSwitchClick(Sender: TObject);
    procedure MenuFileCommandClick(Sender: TObject);
    procedure MenuFileTransferClick(Sender: TObject);
    procedure SpeakMemoEnter(Sender: TObject);
    procedure SpeakMemoExit(Sender: TObject);
    procedure MenuAnalysisShowHiddenClick(Sender: TObject);
    procedure MenuAnalysisShowCondsClick(Sender: TObject);
    procedure MenuAnalysisMatchIClick(Sender: TObject);
    procedure MenuAnalysisMatchKClick(Sender: TObject);
    procedure MenuAnalysisMatchOClick(Sender: TObject);
    procedure MenuAnalysisClick(Sender: TObject);
    procedure FinalGridClickCell(Sender: TObject; DataColDown, DataRowDown,
      DataColUp, DataRowUp: Integer; DownPos, UpPos: TtsClickPosition);
    procedure MenuAnalysisMatchFClick(Sender: TObject);
    procedure MenuFilePrintClick(Sender: TObject);
    procedure MenuFileFontClick(Sender: TObject);
    procedure MenuHelpOpenClick(Sender: TObject);
    procedure MenuHelpPropositionalClick(Sender: TObject);
    procedure MenuHelpFirstClick(Sender: TObject);
    procedure MenuHelpTurboAllClick(Sender: TObject);
    procedure MenuHelpTurboModClick(Sender: TObject);
    procedure MenuHelpMemoryClick(Sender: TObject);
    procedure MenuHelpRecurseClick(Sender: TObject);
    procedure MenuHelpHanoiClick(Sender: TObject);
    procedure MenuHelpArithRecurseClick(Sender: TObject);
    procedure MenuHelpArithCycleClick(Sender: TObject);
    procedure MenuHelpPassiveClick(Sender: TObject);
    procedure MenuHelpTagClick(Sender: TObject);
    procedure MenuHelpQuestionnaireClick(Sender: TObject);
    procedure MenuProcPunctClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ExitGridClickCell(Sender: TObject; DataColDown, DataRowDown,
      DataColUp, DataRowUp: Integer; DownPos, UpPos: TtsClickPosition);
    procedure MenuAnalysisMatchEClick(Sender: TObject);
    procedure MenuHelpArraysClick(Sender: TObject);
    procedure MenuHelpTuringClick(Sender: TObject);
    procedure MenuAnalysisDeepClick(Sender: TObject);
    procedure MenuProcSequentialClick(Sender: TObject);
    procedure MenuProcRandomClick(Sender: TObject);
    procedure MenuProcEchoClick(Sender: TObject);
    procedure MenuProcBlankClick(Sender: TObject);
    procedure MenuFileCloseSavedClick(Sender: TObject);
    procedure MenuFileInputSavedClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MenuFileClick(Sender: TObject);
    procedure MenuHelpDoctorClick(Sender: TObject);
    procedure MenuViewInstantClick(Sender: TObject);
    procedure MenuViewFastClick(Sender: TObject);
    procedure MenuViewMediumClick(Sender: TObject);
    procedure MenuViewSlowClick(Sender: TObject);
    procedure MenuViewConversationalClick(Sender: TObject);
    procedure MenuViewDevelopmentClick(Sender: TObject);
    procedure MenuViewNormalClick(Sender: TObject);
    procedure MenuViewShowAllClick(Sender: TObject);
    procedure MenuViewTonlyClick(Sender: TObject);
    procedure MenuViewHideClick(Sender: TObject);
    procedure MenuViewInsertVSClick(Sender: TObject);
    procedure MenuProcOpenControlClick(Sender: TObject);
    procedure MenuProcInsertPSClick(Sender: TObject);
    procedure Displaycurrentsettingsdynamically1Click(Sender: TObject);
    procedure MenuControlPanelClick(Sender: TObject);
    procedure MenuControlInsertCSClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ElizaForm: TElizaForm;

procedure fixoptform;
procedure setview(setting: Tviewsetting);

implementation

{$R *.DFM}

uses ShellAPI {for ShellExecute},
     ElizaUtils, ElizaAdd, ElizaControlFU, ElizaEditFU, ElizaExecute,
     ElizaMemFun, ElizaProcess, ElizaScript, ElizaSetup, ElizaSpeak,
     ElizaOptionsFU;


{**********************************}
{* ROUTINES REQUIRED BY FILE MENU *}
{**********************************}

procedure showeditor;
begin
 with EditForm do
  if Showing then
   BringToFront
  else
   Show;
end;

procedure fixoptform;

 function checkit(chk: boolean): integer;
 begin
  if chk then
   result:=0
  else
   result:=1
 end;

begin
 with SettingsForm do
  begin
   if dval>10 then {i.e. 25}
    SpeedRadioGroup.ItemIndex:=3
   else {i.e. 0, 5, 10}
    SpeedRadioGroup.ItemIndex:=dval div 5;
   with AnalysisRadioGroup do
    case viewsetting of
     viewAll:   ItemIndex:=0;
     viewTonly: Itemindex:=1;
     hideAll:   Itemindex:=2
    end;
   CheckPunctChk.Checked:=checkpunct;
   SeqRadioGroup.ItemIndex:=checkit(seqdefault);
   EchoRadioGroup.ItemIndex:=checkit(echoblank);
   CaseRadioGroup.ItemIndex:=checkit(uppercaseonly)
  end
end;


{****************************************}
{* ROUTINES REQUIRED BY PROCESSING MENU *}
{****************************************}

procedure fixoptpunct(punct: boolean);
begin
 checkpunct:=punct;
 ElizaForm.MenuProcPunct.Checked:=punct;
 fixoptform
end; {fixoptpunct}

procedure fixoptseq(seq: boolean);
begin
 seqdefault:=seq;
 with ElizaForm do
  case seq of
   true:  MenuProcSequential.Checked:=true;
   false: MenuProcRandom.Checked:=true
  end;
 fixoptform
end; {fixoptseq}

procedure fixecho(echo: boolean);
begin
 echoblank:=echo;
 with ElizaForm do
  case echoblank of
   true:  MenuProcEcho.Checked:=true;
   false: MenuProcBlank.Checked:=true
  end;
 fixoptform
end; {fixecho}

procedure fixcase(upper: boolean);
begin
 uppercaseonly:=upper;
 with ElizaForm do
  case upper of
   true:  MenuProcUpper.Checked:=true;
   false: MenuProcLower.Checked:=true
  end;
 fixoptform
end; {fixcase}

procedure fixoptspeed(speed: integer);
begin
 with ElizaForm do
  begin
   dval:=speed;
   if MenuViewConversational.Checked and (speed>0) then
    defaultconversespeed:=speed;
   case speed of
    0:  MenuViewInstant.Checked:=true;
    5:  MenuViewFast.Checked:=true;
    10: MenuViewMedium.Checked:=true;
    25: MenuViewSlow.Checked:=true
   end {case}
  end;
 fixoptform
end; {fixoptspeed}


{**************************************}
{* ROUTINES REQUIRED BY ANALYSIS MENU *}
{**************************************}

procedure setview(setting: Tviewsetting);
begin
 viewsetting:=setting;
 fixoptform;
 with ElizaForm do
  begin
   TraceTab.TabVisible:=(setting<>hideAll);
   MemoryTab.TabVisible:=(setting<>hideAll);
   WelcomeTab.TabVisible:=(setting=viewAll);
   VoidTab.TabVisible:=(setting=viewAll);
   InputTab.TabVisible:=(setting<>hideAll);
   KeywordTab.TabVisible:=(setting<>hideAll);
   OutputTab.TabVisible:=(setting<>hideAll);
   FinalTab.TabVisible:=(setting<>hideAll)
  end
end;


{**********************************}
{* ROUTINES REQUIRED BY HELP MENU *}
{**********************************}

procedure copyscript(f: string);
var copyfrom,copyto: pchar;
begin
 if not(FileExists(fullpath(userdir+'\'+f))) then
  begin
   if FileExists(progpath+scriptsdir+'\'+f) then
    begin
     copyto:=pchar(fullpath(userdir+'\'+f));
     copyfrom:=pchar(progpath+scriptsdir+'\'+f);
     if not(copyfile(copyfrom,copyto,true)) then
      inform('File "'+f+'" could not be copied from the "'+progpath+scriptsdir+'" directory');
    end
   else
    inform('File "'+progpath+scriptsdir+'\'+f+'" not found');
  end
end;

procedure helpprog(progname,helpname,pdfsect: string);
begin
 if EditForm.EditorMemo.Modified then
  if not(query('This operation will lose the editing changes that you have made. '
              +'Are you sure you want to do this?')) then
   exit;
 copyscript(progname);
 if loadeditor(userdir+'\'+progname) then
  begin
   showeditor;
   inform('The illustrative script has been loaded into the Editor,'
          +' but the Script running in Elizabeth itself is not yet affected.'
          +'  Press CTRL-T to transfer the illustrative Script from the Editor into Elizabeth and run it.'
          +'  For documentation of this script, see Section '+pdfsect+' of Elizabeth.pdf')
  end
end;


{*************}
{* FILE MENU *}
{*************}

procedure TElizaForm.MenuFileClick(Sender: TObject);
begin
 MenuFileOpenSaved.Enabled:=(lastsaved=numsaved);
 MenuFileInputSaved.Enabled:=(lastsaved<numsaved);
 MenuFileCloseSaved.Enabled:=(lastsaved<numsaved)
end;

procedure TElizaForm.MenuFileLoadClick(Sender: TObject);
begin
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 with LoadScriptDlg do
  begin
   FileName:=fullpath(mainscriptfile);
   if Execute then
    begin
     mainscriptfile:=ExtractRelativePath(basepath,FileName);
     if pos('..\..',mainscriptfile)>0 then
      mainscriptfile:=FileName;
     restart(mainscriptfile,randseed,true)
    end
  end
end; {MenuFileLoadClick}

procedure TElizaForm.MenuFileRestartClick(Sender: TObject);
begin
 restart(mainscriptfile,randseed,true)
end; {MenuFileRestartClick}

procedure TElizaForm.MenuFileTransferClick(Sender: TObject);
begin
 if EditForm.EditorMemo.Modified then
  if not(query('This operation will lose the editing changes that you have made. '
              +'Are you sure you want to do this?')) then
   exit;
 loadeditor(mainscriptfile);
 showeditor
end; {MenuFileTransferClick}

procedure TElizaForm.MenuFileSwitchClick(Sender: TObject);
begin
 with EditForm do
  if Showing then
   BringToFront
  else
   Show
end; {MenuFileSwitchClick}

procedure TElizaForm.MenuFileCommandClick(Sender: TObject);
var s: string;
begin
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 s:=InputEdit.Text;
 InputEdit.Text:='';
 testexecute(s,'in command entered from keyboard');
 doallactions
end; {MenuFileCommandClick}

procedure TElizaForm.MenuFileSaveClick(Sender: TObject);
begin
 with SaveDialogueDlg do
  if Execute then
   DialogueMemo.Lines.SaveToFile(FileName)
   {DialogueRichEdit.Lines.SaveToFile(FileName){Saved from Memo, Printed from RichEdit}
end; {MenuFileSaveClick}

procedure TElizaForm.MenuFileFontClick(Sender: TObject);
begin
 FontDlg.Font:=DialogueMemo.Font;
 if FontDlg.Execute then
  begin
   DialogueMemo.Font:=FontDlg.Font;
   DialogueRichEdit.Font:=FontDlg.Font
  end
end; {MenuFileFontClick}

procedure TElizaForm.MenuFilePrintClick(Sender: TObject);
begin
 if DialoguePrintSetupDlg.Execute then
  begin
   DialogueRichEdit.Text:=DialogueMemo.Text;
   DialogueRichEdit.Print('Elizabeth dialogue') {Saved from Memo, Printed from RichEdit}
  end
end; {MenuFilePrintClick}

procedure TElizaForm.MenuFileOpenSavedClick(Sender: TObject);
{some of this code is a hangover from when an RTF file was used with a RichEdit.
 This code has been left in place in case that option is wanted in the future.}
var saveddlg: textfile;
    readline,scriptname,seedstr: string;
    posn: integer;
    seedval: longint;
begin
 with ReplayDialogueDlg do
  begin
   if Execute then
    begin
     seedval:=-1; {indicates failure to read seedvalue}
     assignfile(saveddlg,FileName);
     reset(saveddlg);
     repeat
      readln(saveddlg,readline)
     until eof(saveddlg) or (pos('<File=',readline)>0); {can remove RTF codes}
     if eof(saveddlg) then
      begin
       closefile(saveddlg);
       exit
      end;
     posn:=pos('<File=',readline); {known to be >0}
     delete(readline,1,posn+5);
     posn:=pos('>',readline);
     if posn>1 then
      begin
       scriptname:=copy(readline,1,posn-1);
       delete(readline,1,posn);
       posn:=pos('\\',scriptname); {'\' becomes '\\' in RTF file, if used}
       while posn>0 do
        begin
         delete(scriptname,posn,1);
         posn:=pos('\\',scriptname)
        end;
       posn:=pos('<RandomSeed=',readline);
       if posn>0 then
        begin
         delete(readline,1,posn+11);
         posn:=pos('>',readline);
         if posn>2 then
          begin
           seedstr:=copy(readline,1,posn-1);
           seedval:=StrToIntDef(seedstr,-1)
          end
        end
      end;
     if seedval>=0 then
      begin
       numsaved:=0;
       lastsaved:=0;
       readln(saveddlg);
       while not(eof(saveddlg)) do
        begin
         readln(saveddlg);
         if not(eof(saveddlg)) then
          begin
           readln(saveddlg,readline);
           inc(numsaved);
           savedlist[numsaved]:=readline
          end
        end;
       inform(IntToStr(numsaved)+' dialogue inputs loaded from '+FileName)
      end;
     closefile(saveddlg);
     if seedval<0 then
      inform('File "'+FileName+'" has incorrect format')
     else
      restart(scriptname,seedval,true)
    end
  end
end; {MenuFileOpenSavedClick}

procedure TElizaForm.MenuFileInputSavedClick(Sender: TObject);
begin
 if lastsaved<numsaved then
  begin
   inc(lastsaved);
   with InputEdit do
    begin
     Text:=savedlist[lastsaved];
     SelStart:=length(Text);
     SelLength:=0
    end
  end
end; {MenuFileInputSavedClick}

procedure TElizaForm.MenuFileCloseSavedClick(Sender: TObject);
begin
 numsaved:=0;
 lastsaved:=0
end; {MenuFileCloseSavedClick}

procedure TElizaForm.MenuFileQuitClick(Sender: TObject);
begin
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 if EditForm.EditorMemo.Modified then
  if not(query('Closing Elizabeth now will lose the editing changes that you have made. '
         +'Are you sure you want to do this?')) then
   exit;
 if fixedsetarray[quitset].numresponses=0 then
  begin
   if fixedsetarray[exitset].numresponses=0 then
    begin {default - immediate quit}
     saidgoodbye:=true;
     close
    end
   else
    begin {exit message prevents quitting}
     inform(choosefixed(exitset));
     doallactions;
     exit
    end
  end
 else
  begin {display quitting message, then finish}
   speak(choosefixed(quitset));
   doallactions;
   delay(1000+80*dval);
   saidgoodbye:=true;
   close
  end
end; {MenuFileQuitClick}


{*************}
{* VIEW MENU *}
{*************}

procedure TElizaForm.MenuViewShowAllClick(Sender: TObject);
begin
 setview(viewAll);
 MenuViewShowAll.Checked:=true;
 if MenuViewDevelopment.Checked then
  defaultDevViewOrTonly:=true
end; {MenuViewShowAllClick}

procedure TElizaForm.MenuViewTonlyClick(Sender: TObject);
begin
 setview(viewTonly);
 MenuViewTonly.Checked:=true;
 if MenuViewDevelopment.Checked then
  defaultDevViewOrTonly:=false
end; {MenuViewTonlyClick}

procedure TElizaForm.MenuViewHideClick(Sender: TObject);
begin
 setview(hideAll);
 MenuViewHide.Checked:=true
end; {MenuViewHideClick}

procedure TElizaForm.MenuViewInstantClick(Sender: TObject);
begin
 fixoptspeed(0)
end; {MenuViewInstantClick}

procedure TElizaForm.MenuViewFastClick(Sender: TObject);
begin
 fixoptspeed(5)
end; {MenuViewFastClick}

procedure TElizaForm.MenuViewMediumClick(Sender: TObject);
begin
 fixoptspeed(10)
end; {MenuViewMediumClick}

procedure TElizaForm.MenuViewSlowClick(Sender: TObject);
begin
 fixoptspeed(25)
end; {MenuViewSlowClick}

procedure TElizaForm.MenuViewConversationalClick(Sender: TObject);
begin
 MenuViewConversational.Checked:=true;
 fixoptspeed(defaultconversespeed);
 MenuViewHideClick(Sender)
end; {MenuViewConversationalClick}

procedure TElizaForm.MenuViewDevelopmentClick(Sender: TObject);
begin
 MenuViewDevelopment.Checked:=true;
 fixoptspeed(0);
 case defaultDevViewOrTonly of
  true:  MenuViewShowAllClick(Sender);
  false: MenuViewTonlyClick(Sender)
 end
end; {MenuViewDevelopmentClick}

procedure TElizaForm.MenuViewNormalClick(Sender: TObject);
begin
 MenuViewNormal.Checked:=true;
 fixoptspeed(5);
 MenuViewShowAllClick(Sender)
end; {MenuViewNormalClick}

procedure TElizaForm.MenuViewInsertVSClick(Sender: TObject);
var readfile,writefile: textfile;
    workingfilename,backupfilename,readline: string;
begin
 if (mainscriptfile<>'') then
  begin
   if FileExists(fullpath(mainscriptfile)) then
    begin
     workingfilename:=ChangeFileExt(fullpath(mainscriptfile),'.$$$');
     backupfilename:=ChangeFileExt(fullpath(mainscriptfile),'.bak');
     assignfile(readfile,fullpath(mainscriptfile));
     assignfile(writefile,workingfilename);
     reset(readfile);
     rewrite(writefile);
     if MenuViewShowAll.Checked then
      writeln(writefile,'/V Show all tables')
     else
     if MenuViewTonly.Checked then
      writeln(writefile,'/V Show transformation tables')
     else
     if MenuViewHide.Checked then
      writeln(writefile,'/V Hide tables');
     if MenuViewInstant.Checked then
      writeln(writefile,'/V Instant response')
     else
     if MenuViewFast.Checked then
      writeln(writefile,'/V Fast typing')
     else
     if MenuViewMedium.Checked then
      writeln(writefile,'/V Medium typing')
     else
      writeln(writefile,'/V Slow typing');
     writeln(writefile);
     if not(eof(readfile)) then
      begin
       repeat
        readln(readfile,readline);
        if copy(readline,1,3)='/V ' then
         readline:=''
       until (readline<>'') or eof(readfile);
       writeln(writefile,readline)
      end;
     while not(eof(readfile)) do
      begin
       readln(readfile,readline);
       if copy(readline,1,3)<>'/V ' then
        writeln(writefile,readline)
      end;
     closefile(readfile);
     closefile(writefile);
     if FileExists(backupfilename) then
      DeleteFile(backupfilename);
     RenameFile(fullpath(mainscriptfile),backupfilename);
     RenameFile(workingfilename,fullpath(mainscriptfile));
     inform('View options saved in "'+fullpath(mainscriptfile)+
            '". Old version of file is now "'+backupfilename+'"');
     if editorfile=mainscriptfile then
      if query('Load new version of file into editor?') then
       loadeditor(editorfile)
    end
   else
    inform('Main script file "'+mainscriptfile+'" not found')
  end
 else
  inform('No main script file, so setting options not saved')
end; {MenuViewInsertVSClick}


{******************}
{* PROCESSING MENU*}
{******************}

procedure TElizaForm.MenuProcPunctClick(Sender: TObject);
begin
 fixoptpunct(not(MenuProcPunct.Checked))
end; {MenuProcPunctClick}

procedure TElizaForm.MenuProcSequentialClick(Sender: TObject);
begin
 fixoptseq(true)
end; {MenuProcSequentialClick}

procedure TElizaForm.MenuProcRandomClick(Sender: TObject);
begin
 fixoptseq(false)
end; {MenuProcRandomClick}

procedure TElizaForm.MenuProcEchoClick(Sender: TObject);
begin
 fixecho(true)
end; {MenuProcEchoClick}

procedure TElizaForm.MenuProcBlankClick(Sender: TObject);
begin
 fixecho(false)
end; {MenuProcBlankClick}

procedure TElizaForm.MenuProcUpperClick(Sender: TObject);
begin
 fixcase(true)
end; {MenuProcUpperClick}

procedure TElizaForm.MenuProcLowerClick(Sender: TObject);
begin
 fixcase(false)
end; {MenuProcLowerClick}

procedure TElizaForm.MenuProcOpenControlClick(Sender: TObject);
begin
end; {MenuProcOpenControlClick}

procedure TElizaForm.MenuProcInsertPSClick(Sender: TObject);
var readfile,writefile: textfile;
    workingfilename,backupfilename,readline: string;
begin
 if (mainscriptfile<>'') then
  begin
   if FileExists(fullpath(mainscriptfile)) then
    begin
     workingfilename:=ChangeFileExt(fullpath(mainscriptfile),'.$$$');
     backupfilename:=ChangeFileExt(fullpath(mainscriptfile),'.bak');
     assignfile(readfile,fullpath(mainscriptfile));
     assignfile(writefile,workingfilename);
     reset(readfile);
     rewrite(writefile);
     case MenuProcPunct.Checked of
      true:  writeln(writefile,'/P Final punctuation ON');
      false: writeln(writefile,'/P Final punctuation OFF')
     end;
     if MenuProcSequential.Checked then
      writeln(writefile,'/P Sequential responses')
     else
      writeln(writefile,'/P Randomised responses');
     if MenuProcEcho.Checked then
      writeln(writefile,'/P Echo if no keywords')
     else
      writeln(writefile,'/P Blank if no keywords');
     if MenuProcUpper.Checked then
      writeln(writefile,'/P Upper case output')
     else
      writeln(writefile,'/P Lower case permitted');
     writeln(writefile);
     if not(eof(readfile)) then
      begin
       repeat
        readln(readfile,readline);
        if copy(readline,1,3)='/P ' then
         readline:=''
       until (readline<>'') or eof(readfile);
       writeln(writefile,readline)
      end;
     while not(eof(readfile)) do
      begin
       readln(readfile,readline);
       if copy(readline,1,3)<>'/P ' then
        writeln(writefile,readline)
      end;
     closefile(readfile);
     closefile(writefile);
     if FileExists(backupfilename) then
      DeleteFile(backupfilename);
     RenameFile(fullpath(mainscriptfile),backupfilename);
     RenameFile(workingfilename,fullpath(mainscriptfile));
     inform('Processing options saved in "'+fullpath(mainscriptfile)+
            '". Old version of file is now "'+backupfilename+'"');
     if editorfile=mainscriptfile then
      if query('Load new version of file into editor?') then
       loadeditor(editorfile)
    end
   else
    inform('Main script file "'+mainscriptfile+'" not found')
  end
 else
  inform('No main script file, so processing options not saved')
end; {MenuProcInsertPOClick}


{*****************}
{* ANALYSIS MENU *}
{*****************}

procedure TElizaForm.MenuAnalysisClick(Sender: TObject);
begin
 MenuAnalysisShowHidden.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisShowConds.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisMatchI.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisMatchK.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisMatchO.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisMatchF.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisMatchE.Enabled:=not(MenuViewHide.Checked);
 MenuAnalysisDeep.Enabled:=not(MenuViewHide.Checked)
end; {MenuAnalysisClick}

procedure TElizaForm.MenuAnalysisShowHiddenClick(Sender: TObject);
begin
 MenuAnalysisShowHidden.Checked:=not(MenuAnalysisShowHidden.Checked);
 updategrids
end; {MenuAnalysisShowHiddenClick}

procedure TElizaForm.MenuAnalysisShowCondsClick(Sender: TObject);
begin
 MenuAnalysisShowConds.Checked:=not(MenuAnalysisShowConds.Checked);
 condactheads;
 updategrids
end; {MenuAnalysisShowCondsClick}

procedure TElizaForm.MenuAnalysisMatchIClick(Sender: TObject);
begin
 MenuAnalysisMatchI.Checked:=not(MenuAnalysisMatchI.Checked);
 if MenuAnalysisMatchI.Checked then
  matchtrace:=matchtrace+['I']
 else
  matchtrace:=matchtrace-['I']
end; {MenuAnalysisMatchIClick}

procedure TElizaForm.MenuAnalysisMatchKClick(Sender: TObject);
begin
 MenuAnalysisMatchK.Checked:=not(MenuAnalysisMatchK.Checked);
 if MenuAnalysisMatchK.Checked then
  matchtrace:=matchtrace+['K']
 else
  matchtrace:=matchtrace-['K']
end; {MenuAnalysisMatchKClick}

procedure TElizaForm.MenuAnalysisMatchOClick(Sender: TObject);
begin
 MenuAnalysisMatchO.Checked:=not(MenuAnalysisMatchO.Checked);
 if MenuAnalysisMatchO.Checked then
  matchtrace:=matchtrace+['O']
 else
  matchtrace:=matchtrace-['O']
end; {MenuAnalysisMatchOClick}

procedure TElizaForm.MenuAnalysisMatchFClick(Sender: TObject);
begin
 MenuAnalysisMatchF.Checked:=not(MenuAnalysisMatchF.Checked);
 if MenuAnalysisMatchF.Checked then
  matchtrace:=matchtrace+['F']
 else
  matchtrace:=matchtrace-['F']
end; {MenuAnalysisMatchFClick}

procedure TElizaForm.MenuAnalysisMatchEClick(Sender: TObject);
begin
 MenuAnalysisMatchE.Checked:=not(MenuAnalysisMatchE.Checked);
 if MenuAnalysisMatchE.Checked then
  matchtrace:=matchtrace+['E']
 else
  matchtrace:=matchtrace-['E']
end; {MenuAnalysisMatchEClick}

procedure TElizaForm.MenuAnalysisDeepClick(Sender: TObject);
begin
 MenuAnalysisDeep.Checked:=not(MenuAnalysisDeep.Checked);
 deeptrace:=MenuAnalysisDeep.Checked
end; {MenuAnalysisDeepClick}


{*************}
{* HELP MENU *}
{*************}

procedure TElizaForm.MenuHelpOpenClick(Sender: TObject);
begin
 if FileExists(pdfpath) then
  ShellExecute(0,0,pchar('"'+pdfpath+'"'),0,0,SW_SHOW)
 else
  inform('Help file "'+pdfpath+'" not found')
end; {MenuHelpOpenClick}

procedure TElizaForm.MenuHelpFirstClick(Sender: TObject);
begin
 helpprog('EOriginal.txt','HelpIllustrative','1.4')
end; {MenuHelpFirstClick}

procedure TElizaForm.MenuHelpDoctorClick(Sender: TObject);
begin
 helpprog('Weizenbaum.txt','HelpWeizenbaum','1.5')
end; {MenuHelpDoctorClick}

procedure TElizaForm.MenuHelpTurboAllClick(Sender: TObject);
begin
 helpprog('TurboAll.txt','HelpScriptIntro','2.1.3')
end; {MenuHelpTurboAllClick}

procedure TElizaForm.MenuHelpTurboModClick(Sender: TObject);
begin
 copyscript('TurboFixed.txt');
 copyscript('TurboInput.txt');
 copyscript('TurboKeys.txt');
 copyscript('TurboMy.txt');
 copyscript('TurboOutput.txt');
 helpprog('TurboEliza.txt','HelpScriptIntro','2.1.3')
end; {MenuHelpTurboModClick}

procedure TElizaForm.MenuHelpMemoryClick(Sender: TObject);
begin
 helpprog('EOrigMem.txt','HelpMemorisation','2.4')
end; {MenuHelpMemoryClick}

procedure TElizaForm.MenuHelpArraysClick(Sender: TObject);
begin
 helpprog('Arrays.txt','HelpArrays','2.4.2')
end; {MenuHelpArraysClick}

procedure TElizaForm.MenuHelpRecurseClick(Sender: TObject);
begin
 helpprog('EOrigSplit.txt','HelpRecursion1','3.2.1')
end; {MenuHelpRecurseClick}

procedure TElizaForm.MenuHelpHanoiClick(Sender: TObject);
begin
 helpprog('Hanoi.txt','HelpRecursion2','3.3')
end; {MenuHelpHanoiClick}

procedure TElizaForm.MenuHelpArithRecurseClick(Sender: TObject);
begin
 helpprog('ArithRec.txt','HelpRecursion2','3.3.2')
end; {MenuHelpArithRecurseClick}

procedure TElizaForm.MenuHelpArithCycleClick(Sender: TObject);
begin
 helpprog('ArithCycle.txt','HelpRecursion2','3.3.2')
end; {MenuHelpArithCycleClick}

procedure TElizaForm.MenuHelpPassiveClick(Sender: TObject);
begin
 helpprog('Passive.txt','HelpGrammar','4.1.2')
end; {MenuHelpPassiveClick}

procedure TElizaForm.MenuHelpTagClick(Sender: TObject);
begin
 helpprog('TagQuest.txt','HelpGrammar','4.1.3')
end; {MenuHelpTagClick}

procedure TElizaForm.MenuHelpQuestionnaireClick(Sender: TObject);
begin
 helpprog('Questionr.txt','HelpConditions','4.5.3')
end; {MenuHelpQuestionnaireClick}

procedure TElizaForm.MenuHelpPropositionalClick(Sender: TObject);
begin
 helpprog('Resolution.txt','HelpPropositional','4.6')
end; {MenuHelpPropositionalClick}

procedure TElizaForm.MenuHelpTuringClick(Sender: TObject);
begin
 helpprog('TuringGCD.txt','HelpTuring','4.7')
end; {MenuHelpTuringClick}


{*********************}
{* ELIZA FORM EVENTS *}
{*********************}

procedure initialsetup;
begin
 if firstload then
  exit
 else
  firstload:=true;
 with ElizaForm do
  begin
   PageControl1.ActivePageIndex:=0;
   initgrids;
   LoadScriptDlg.InitialDir:=basepath+userdir;
   SaveDialogueDlg.InitialDir:=basepath+userdir;
   ReplayDialogueDlg.InitialDir:=basepath+userdir
  end
end; {initialsetup}

procedure initload;
var start,backup: pchar;
begin
 with ElizaForm do
  begin
   if not(restart(userdir+'\'+startscriptfile,randseed,false)) then {FALSE - no "file not found" message}
    begin
     if FileExists(progpath+scriptsdir+'\'+backupscriptfile) then
      begin
       start:=pchar(fullpath(userdir+'\'+startscriptfile));
       backup:=pchar(progpath+scriptsdir+'\'+backupscriptfile);
       if copyfile(backup,start,true) then
        begin
         inform('File "'+startscriptfile+'" has been re-created from "'+backupscriptfile+'"');
         restart(userdir+'\'+startscriptfile,randseed,true)
        end
       else
        mainscriptfile:=''
      end
     else
      mainscriptfile:=''
    end;
  end
end; {initload}

procedure TElizaForm.FormActivate(Sender: TObject);
begin
 if startup then
  begin
   startup:=false;
   initialsetup; {was under FormShow}
   Application.ProcessMessages;
   initload
  end
end; {FormActivate}

procedure TElizaForm.FormResize(Sender: TObject);
var halfincrement,thirdincrement: integer;
begin
 with ElizaForm do
  begin
   if Height<577 then
    Height:=577;
   Width:=800;
   halfincrement:=(Height-577) div 2;
   thirdincrement:=(Height-576) div 3;

   PageControl1.Height:=Height-222; {355=577-222}

   DialogueMemo.Height:=Height-260; {317=577-260}
   DialogueRichEdit.Height:=Height-260; {ditto}

   TraceGrid.Height:=Height-260; {ditto}

   MemoryGrid.Height:=Height-296; {276=577-301}
   MemoryPanel.Top:=Height-283; {294=577-283}

   WelcomeGrid.Height:=59+thirdincrement;
   WelcomePanel.Top:=70+thirdincrement;
   QuitGrid.Top:=116+thirdincrement;
   QuitGrid.Height:=59+thirdincrement;
   QuitPanel.Top:=182+2*thirdincrement;
   ExitGrid.Top:=228+2*thirdincrement;
   ExitGrid.Height:=59+thirdincrement;
   ExitPanel.Top:=294+3*thirdincrement;

   VoidGrid.Height:=113+halfincrement;
   VoidPanel.Top:=124+halfincrement;
   NoKeywordGrid.Top:=174+halfincrement;
   NoKeywordGrid.Height:=113+halfincrement;
   NoKeywordPanel.Top:=Height-283; {294=577-283}

   InputGrid.Height:=Height-301; {276=577-301}
   InputPanel.Top:=Height-283; {294=577-283}

   KeywordGrid.Height:=Height-326; {251=577-326}
   KeywordPanel.Top:=Height-308; {269=577-308}

   OutputGrid.Height:=Height-301; {276=577-301}
   OutputPanel.Top:=Height-283; {294=577-283}

   FinalGrid.Height:=Height-301; {276=577-301}
   FinalPanel.Top:=Height-283; {294=577-283}
  end
end; {FormResize}

procedure TElizaForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if pending then
  begin
   inform('Please wait while I finish!');
   CanClose:=false;
   exit
  end;
 if not(saidgoodbye) then
  begin
   if EditForm.EditorMemo.Modified then
    if not(query('Closing Elizabeth now will lose the editing changes that you have made. '
           +'Are you sure you want to do this?')) then
     CanClose:=false;
   if CanClose then
    begin
     if fixedsetarray[exitset].numresponses>0 then
      begin
       inform(choosefixed(exitset));
       doallactions;
       CanClose:=false
      end
     else
     if fixedsetarray[quitset].numresponses>0 then
      begin {display quitting message, then finish}
       speak(choosefixed(quitset));
       doallactions;
       delay(1000+80*dval);
       saidgoodbye:=true {not needed?}
      end
    end
  end
end; {FormCloseQuery}


{************************}
{* ANALYSIS GRID EVENTS *}
{************************}

{* MEMORY GRID *}

procedure TElizaForm.MemoryGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (nummemory=0)
                   or (MemoryGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 repeat
  inc(i)
 until (i=nummemory) or (memoryarray[i].gridindex=DataRowUp);
 with memoryarray[i] do
  if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
end; {MemoryGridClickCell}

{* WELCOME GRID *}

procedure TElizaForm.WelcomeGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (fixedsetarray[welcomeset].numresponses=0)
                   or (WelcomeGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with fixedsetarray[welcomeset] do
  begin
   repeat
    inc(i)
   until (i=numresponses) or (fixedresps[i].gridindex=DataRowUp);
   with fixedresps[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {WelcomeGridClickCell}

{* QUIT GRID *}

procedure TElizaForm.QuitGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (fixedsetarray[quitset].numresponses=0)
                   or (QuitGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with fixedsetarray[quitset] do
  begin
   repeat
    inc(i)
   until (i=numresponses) or (fixedresps[i].gridindex=DataRowUp);
   with fixedresps[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {QuitGridClickCell}

{* EXIT GRID *}

procedure TElizaForm.ExitGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (fixedsetarray[exitset].numresponses=0)
                   or (ExitGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with fixedsetarray[exitset] do
  begin
   repeat
    inc(i)
   until (i=numresponses) or (fixedresps[i].gridindex=DataRowUp);
   with fixedresps[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {ExitGridClickCell}

{* VOID GRID *}

procedure TElizaForm.VoidGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (fixedsetarray[voidset].numresponses=0)
                   or (VoidGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with fixedsetarray[voidset] do
  begin
   repeat
    inc(i)
   until (i=numresponses) or (fixedresps[i].gridindex=DataRowUp);
   with fixedresps[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {VoidGridClickCell}

{* NOKEYWORD GRID *}

procedure TElizaForm.NoKeywordGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>3) or (fixedsetarray[nokeyset].numresponses=0)
                   or (NoKeywordGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with fixedsetarray[nokeyset] do
  begin
   repeat
    inc(i)
   until (i=numresponses) or (fixedresps[i].gridindex=DataRowUp);
   with fixedresps[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {NoKeywordGridClickCell}

{* INPUT GRID *}

procedure TElizaForm.InputGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>4) or (inputtrans.numtransforms=0)
                   or (InputGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with inputtrans do
  begin
   repeat
    inc(i)
   until (i=numtransforms) or (transforms[i].gridindex=DataRowUp);
   with transforms[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {InputGridClickCell}

{* KEYWORD GRID *}

procedure TElizaForm.KeywordGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var setcount,krcount: integer;
begin
 if (DataColUp<>5) or (numkeysets=0)
                   or (KeywordGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 setcount:=0;
 repeat
  inc(setcount);
  with keyarray[setcount] do
   begin
    krcount:=0;
    repeat
     inc(krcount)
    until (krcount>numkeys) or (keywords[krcount].gridindex=DataRowUp)
   end
 until (setcount=numkeysets) or (krcount<=keyarray[setcount].numkeys);
 with keyarray[setcount] do
  with keywords[krcount] do
   if (krcount<=numkeys) and ((condstr<>'') or (actstr<>'')) then
    begin
     showaction(condstr,actstr);
     exit
    end;
 setcount:=0;
 repeat
  inc(setcount);
  with keyarray[setcount] do
   begin
    krcount:=0;
    repeat
     inc(krcount)
    until (krcount>numresp) or (keyresps[krcount].gridindex=DataRowUp)
   end
 until (setcount=numkeysets) or (krcount<=keyarray[setcount].numresp);
 with keyarray[setcount] do
  with keyresps[krcount] do
   if (krcount<=numresp) and ((condstr<>'') or (actstr<>'')) then
    showaction(condstr,actstr);
end; {KeywordGridClickCell}

{* OUTPUT GRID *}

procedure TElizaForm.OutputGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>4) or (outputtrans.numtransforms=0)
                   or (OutputGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with outputtrans do
  begin
   repeat
    inc(i)
   until (i=numtransforms) or (transforms[i].gridindex=DataRowUp);
   with transforms[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {OutputGridClickCell}

{* FINAL GRID *}

procedure TElizaForm.FinalGridClickCell(Sender: TObject; DataColDown,
  DataRowDown, DataColUp, DataRowUp: Integer; DownPos,
  UpPos: TtsClickPosition);
var i: integer;
begin
 if (DataColUp<>4) or (finaltrans.numtransforms=0)
                   or (FinalGrid.Cell[DataColUp,DataRowUp]<>'[Click]') then
  exit;
 i:=0;
 with finaltrans do
  begin
   repeat
    inc(i)
   until (i=numtransforms) or (transforms[i].gridindex=DataRowUp);
   with transforms[i] do
    if (gridindex=DataRowUp) and ((condstr<>'') or (actstr<>'')) then
     showaction(condstr,actstr);
  end
end; {FinalGridClickCell}


{****************************}
{* PROCESSING OF USER INPUT *}
{****************************}

procedure callprocessinput;
begin
 saidgoodbye:=false;
 with ElizaForm.InputBtn do
  begin
   if matchlimit=0 then
    matchlimit:=ControlForm.MatchLimitSpin.Value;
   if Caption='Enter' then
    begin
     Caption:='Halt';
     Application.ProcessMessages;
     processinput;
     Caption:='Enter'
    end
   else
    begin
     Caption:='Enter';
     matchlimit:=0;
     Application.ProcessMessages
    end
  end
end; {callprocessinput}

procedure TElizaForm.InputBtnClick(Sender: TObject);
begin
 callprocessinput
end; {InputBtnClick}

procedure TElizaForm.InputEditKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  begin
   callprocessinput;
   Key:=#0
  end
end; {InputEditKeyPress}


{****************}
{* OTHER EVENTS *}
{****************}

procedure TElizaForm.TypingTimerTimer(Sender: TObject);
begin
 TypingTimer.Enabled:=false;
 timerup:=true;
end;

procedure TElizaForm.SpeakMemoEnter(Sender: TObject);
begin
 SpeakMemo.Enabled:=false
end;

procedure TElizaForm.SpeakMemoExit(Sender: TObject);
begin
 SpeakMemo.Enabled:=true
end;


{******************}
{* INITIALISATION *}
{******************}

procedure fixpaths;
var pathfile: textfile;

 function fixpath(name,default: string): string;
 var s: string;
     posn: integer;
 begin
  result:='';
  reset(pathfile);
  while (result='') and not(eof(pathfile)) do
   begin
    readln(pathfile,s);
    s:=trim(s);
    if pos(uppercase(name),uppercase(s))=1 then
     begin
      delete(s,1,length(name));
      s:=trim(s);
      if (copy(s,1,1)='=') then
       begin
        delete(s,1,1);
        posn:=pos(' /',s);
        if posn>0 then
         delete(s,posn,maxint);
        result:=trim(s)
       end
     end
   end;
  if result='' then
   result:=default
 end;

begin
 progpath:=IncludeTrailingPathDelimiter(ExtractFilePath(paramstr(0)));
 basepath:=progpath;
 if FileExists(progpath+pathfilename) then
  begin
   assignfile(pathfile,progpath+pathfilename);
   basepath:=IncludeTrailingPathDelimiter(fixpath('userpath',basepath));
   userdir:=fixpath('userdir',userdir);
   scriptsdir:=fixpath('library',scriptsdir);
   pdfname:=fixpath('pdfname',pdfname);
   startscriptfile:=fixpath('startscript',startscriptfile);
   backupscriptfile:=fixpath('backupscript',backupscriptfile);
   closefile(pathfile)
  end;
 if not(DirectoryExists(basepath+userdir)) then
  if ForceDirectories(basepath+userdir) then
   ShowMessage('Created new user directory: '+basepath+userdir)
  else
   begin
    ShowMessage('FATAL ERROR: Cannot create user directory: '+basepath+userdir);
    {previously raise Exception.Create('Cannot create '+basepath+userdir);}
    halt
   end;
 pdfpath:=progpath+pdfname
end;

procedure TElizaForm.Displaycurrentsettingsdynamically1Click(
  Sender: TObject);
begin
 SettingsForm.Show
end;

procedure TElizaForm.MenuControlPanelClick(Sender: TObject);
begin
 with ControlForm do
  begin
   if matchlimit>0 then
    MatchLimitSpin.Value:=matchlimit;
   MemCheckSpin.Value:=memchecklimit;
   HaltLbl.Caption:=haltmessage;
   HaltBtn.Enabled:=(haltaction<>'');
   ActiveControl:=OKBtn;
   ShowModal
  end
end;

procedure TElizaForm.MenuControlInsertCSClick(Sender: TObject);
var readfile,writefile: textfile;
    workingfilename,backupfilename,readline: string;

 function setting(s: string; var onradio,undoradio,offradio: TRadioButton;
                  var spin: TSpinEdit): string;
 begin
  if onradio.Checked then
   setting:=s+' unlimited'
  else
  if offradio.Checked then
   setting:=s+' prevented'
  else
   setting:=s+' undo limit: '+IntToStr(spin.Value)
 end;

begin
 if (mainscriptfile<>'') then
  begin
   if FileExists(fullpath(mainscriptfile)) then
    begin
     workingfilename:=ChangeFileExt(fullpath(mainscriptfile),'.$$$');
     backupfilename:=ChangeFileExt(fullpath(mainscriptfile),'.bak');
     assignfile(readfile,fullpath(mainscriptfile));
     assignfile(writefile,workingfilename);
     reset(readfile);
     rewrite(writefile);
     with ControlForm do
      begin
       case RecursionChk.Checked of
        true:  writeln(writefile,'/C Recursion ON');
        false: writeln(writefile,'/C Recursion OFF')
       end;
       writeln(writefile,'/C Matchlimit '+IntToStr(MatchLimitSpin.Value));
       writeln(writefile,'/C Memchecklimit '+IntToStr(MemCheckSpin.Value));
       writeln(writefile,setting('/C Input Iteration',InputIterOnRadio,
                                 InputIterUndoRadio,InputIterOffRadio,InputIterSpin));
       writeln(writefile,setting('/C Output Iteration',OutputIterOnRadio,
                                 OutputIterUndoRadio,OutputIterOffRadio,OutputIterSpin));
       writeln(writefile,setting('/C Final Iteration',FinalIterOnRadio,
                                 FinalIterUndoRadio,FinalIterOffRadio,FinalIterSpin));
       writeln(writefile,setting('/C Input Cycling',InputCycleOnRadio,
                                 InputCycleUndoRadio,InputCycleOffRadio,InputCycleSpin));
       writeln(writefile,setting('/C Output Cycling',OutputCycleOnRadio,
                                 OutputCycleUndoRadio,OutputCycleOffRadio,OutputCycleSpin));
       writeln(writefile,setting('/C Final Cycling',FinalCycleOnRadio,
                               FinalCycleUndoRadio,FinalCycleOffRadio,FinalCycleSpin))
      end;
     writeln(writefile);
     if not(eof(readfile)) then
      begin
       repeat
        readln(readfile,readline);
        if copy(readline,1,3)='/C ' then
         readline:=''
       until (readline<>'') or eof(readfile);
       writeln(writefile,readline)
      end;
     while not(eof(readfile)) do
      begin
       readln(readfile,readline);
       if copy(readline,1,3)<>'/C ' then
        writeln(writefile,readline)
      end;
     closefile(readfile);
     closefile(writefile);
     if FileExists(backupfilename) then
      DeleteFile(backupfilename);
     RenameFile(fullpath(mainscriptfile),backupfilename);
     RenameFile(workingfilename,fullpath(mainscriptfile));
     inform('Control options saved in "'+fullpath(mainscriptfile)+
            '". Old version of file is now "'+backupfilename+'"');
     if editorfile=mainscriptfile then
      if query('Load new version of file into editor?') then
       loadeditor(editorfile)
    end
   else
    inform('Main script file "'+mainscriptfile+'" not found')
  end
 else
  inform('No main script file, so control options not saved')
end;

initialization;
 fixpaths;
 randomize
end.

