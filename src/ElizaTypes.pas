unit ElizaTypes;

interface

{***********************************************************************}
{* VARIOUS GENERAL TYPES, CONSTANTS, AND VARIABLES                     *}
{***********************************************************************}

const maxwords = 1000;    {maximum words in user input}
      unlimited = 200000; {value to represent unlimited iteration/cycling}
      maxactions = 100; {maximum number of pending (?) actions}
      maxfixedresp = 100; {maximum responses in any of the 5 "fixed" sets, WVNQE}
      maxtransforms = 5000; {maximum input/output transformations}
      maxkeysets = 5000;  {maximum number of keyword sets}
      maxkeysinset = 100; {maximum keywords in set}
      maxrespinset = 100; {maximum responses in set}
      maxmemory = 5000; {maximum number of memorised phrases}
      maxiomem = 5000; {maximum number of memorised inputs/outputs}
      maxsaved = 5000; {maximum number of lines in saved dialogue}

      nulltext = #0; {used to signify "drop through" in recursion}
      doapply = true; {for memiocheck}
      dontapply = false;
      dotrace = true;
      donttrace = false;

type Tcharset = set of char; {used for alphabets}
     Twordstring = string[28];  {maximum length of one word}
     Tindexstring = string[16]; {maximum length of index string}
     Tpatternstring = string; {maximum length of pattern/replace string}
     Tphrasestring = string; {maximum length of memorised phrase}
     Tresponsestring = string; {keyword response string}
     Tcondstring = string; {condition string}
     Tactionstring = string; {action string}
    {Tkeystate = (noset,keys,resps); {no longer used - for reading in keywords & responses}
     Texeresult = (exedone,exetried,exerror); {result (so far) of command execution: done, test performed, or error}
     Tprocessing = (pfalse,ptrue,pmsg); {pmsg when message has been given}

const pathfilename = 'Elizabeth.path';      {name of file that specifies BASEPATH}
      inputoutputset: Tcharset = ['!','"','''','(',')','+',',','-','.','0'..'9',
                                  ':',';','<','>','?','A'..'Z','a'..'z']; {ok for input/output}
      transformset: Tcharset =   ['!','"','''','(',')',',','-','.','0'..'9',
                                  ':',';','<','=','>','?','A'..'Z','a'..'z',
                                  '$','%','*','+','@','[','\',']','^','_','~']; {ok in transformations}
      scriptset: Tcharset =      ['!','"','''','(',')',',','-','.','0'..'9',
                                  ':',';','<','>','?','A'..'Z','a'..'z',
                                  '$','%','*','+','@','[','\',']','^','_','~',
                                  '&','/','=','>','{','}']; {ok in script}
      memoryset: Tcharset =       ['!','"','''','(',')',',','-','.','0'..'9',
                                  ':',';','<','>','?','A'..'Z','a'..'z',
                                  '$','%','*','+','^','_','~']; {ok in memorised phrases}
      indexset: Tcharset =       ['!','"','''','(',')',',','-','.','0'..'9',
                                  ':',';','<','>','?','@','A'..'Z','a'..'z',
                                  '$','%','*','+','^','_','~']; {ok in index codes}
      filenameset: Tcharset =    ['!','#','$','%','&','''','(',')','+',',','-',
                                  '.','/','0'..'9',':',';','=','@','A'..'Z','[',
                                  '\',']','^','_','`','a'..'z','{','}','~','*'];
                                  {ok in filenames, but :/\ only for paths;
                                   * replaced by space, rules out "*<>?|:}
      puncset: Tcharset =      ['!',',','.',':',';','?']; {punctuation}
      bktset: Tcharset =       ['(',')','<','>'];
      moodset: Tcharset =      ['.','!','?']; {punctuation which can terminate response}
      letterset: Tcharset =    ['A'..'Z','a'..'z','-','_','''']; {underscore can be used for categories}
      digitset: Tcharset =     ['0'..'9'];

(* THE FOLLOWING VARIABLES USED TO BE TYPED CONSTANTS IN EARLIER VERSIONS *)
var progpath: string = 'C:\';             {made equal to program path + '\'}
    basepath: string = 'C:\';             {made equal to parent of 'My Scripts' +'\', default PROGPATH}
    userdir: string = 'My Scripts';       {BASEPATH+USERDIR is default user directory}
    scriptsdir: string = 'Illustrative Scripts'; {PROGPATH+SCRIPTSDIR+'\' is where scripts are stored}
    pdfname: string = 'Elizabeth.pdf';    {default name of PDF help file}
    startscriptfile: string = 'Elizabeth.txt'; {filename tried on startup, within USERDIR}
    backupscriptfile: string = 'EOriginal.txt'; {ORIG can be recreated from this}
    pdfpath: string = 'C:\Elizabeth.pdf'; {adjusted to progpath+pdfname}

    processing: Tprocessing = pfalse;
    tracestep: integer = 0; {step in trace}
    timerup: boolean = true;
    pending: boolean = false;  {if outputting is under way}
    matchlevel: string = ''; {indent for trace of matching algorithm}
    matchcount: integer = 0;
    memcheckcount: integer = 0;
    memcheckexceeded: boolean = false;
    selfdelIOF: boolean = false; {signifies self-deletion by IOF transformation
                                  (something to do with iteration checking, perhaps??)
                                  - not the same as starred self-deletion, which is when they're
                                  defined as self-deleting}
    condused: boolean = false;
    matchlimit: integer = 5000;
    doactions: boolean = true; {becomes false if pause=>halt, so remove actions}
    dval: integer = 5; {delay coefficient}
    checkpunct: boolean = true; {check final punctuation}
    seqdefault: boolean = true; {keyword responses sequential by default}
    echoblank: boolean = true; {echo active text, or blank it}
    uppercaseonly: boolean = true; {upper-case output only}
    memchecklimit: integer = 500;
    loadingscript: boolean = false; {true only while script being loaded}
    mainscriptfile: string = 'Elizabeth.txt'; {changed to FULL NAME when new script loaded}
    editorfile: string = '';
    defaultconversespeed: integer = 10;
    defaultDevViewOrTonly: boolean = true;
    saidgoodbye: boolean = false;
    firstload: boolean = false; {whether first loading has been done yet}
    startup: boolean = true; {whether Activate should initialise}

type Tviewsetting = (viewAll,viewTonly,hideAll);

var viewsetting: Tviewsetting = viewAll;

      {for conversational settings:
        defaultconversespeed and
         dval:=25;  Slow
         dval:=10;  Medium
         dval:=5.   Fast
        MenuOptConverse.Checked:=true;
        MenuOptHide.Checked:=true;
        All tabs hidden;

       for development settings:
        dval:=0;  Instant;
        MenuOptDevelopment.Checked:=true;
        MenuOptHide.Checked:=true;
        defaultDevViewOrTonly:
         true:  MenuOptView.Checked:=true;
         false: MenuOptTransOnly.Checked:=true;
        Relevant tabs shown.}

      recurse: boolean = true;
      itercycle: boolean = false; {whether IterCycleBtn used}
      matchtrace: Tcharset = []; {IKOFE if all set, but E treated separately}
      deeptrace: boolean = false; {whether to do deep match tracing}
      matchchar: char = ' '; {type of matching - I, K, O, F}
      inputiter: integer = 0; {whether to iterate input transformations}
      outputiter: integer = 0; {whether to iterate output transformations}
      finaliter: integer = 0; {whether to iterate final transformations}
      inputcycle: integer = 0; {whether to cycle input transformation set}
      outputcycle: integer = 0; {whether to cycle output transformation set}
      finalcycle: integer = 0; {whether to cycle final transformation set}

      numsaved: integer = 0; {number of lines from saved dialogue}
      lastsaved: integer = 0; {last line used from saved dialogue}

var savedlist: array[1..maxsaved] of string; {array of saved lines}

type Tpattype = (ptbad,ptnorm,ptbrak,ptmemio);
     Tpextent = (indiv,contig,multi);
     Tpatspec = record
                 pattype: Tpattype;
                 pextent: Tpextent;
                 pcharok: Tcharset
                end;

var patspec: array['A'..'Z'] of Tpatspec;

type Taction = record
                line: string;
                act: string;
                context: string
               end;

var numactions: integer = 0;
    actionlist: array[1..maxactions] of Taction;

{***********************************************************************}
{* FIXED SETS OF RESPONSES:  Welcome / Void / No key / Quit            *}
{***********************************************************************}

const welcomeset = 1;
      voidset = 2;
      nokeyset = 3;
      quitset = 4;
      exitset = 5;
      lastfixedset = 5;
      fixedcodes: array[1..lastfixedset] of string[16] {for overflow error message}
                 = ('W (welcome)','V (void input)',
                    'N (no keyword)','Q (quit)','X (exit)');
      fixedtrace: array[1..lastfixedset] of string[20] {for trace reports}
                 = ('Welcome message','Void input response',
                    'No keyword found','Quitting message','Exit message');

var haltmessage: Tresponsestring = ''; {message for overload halt}
    haltaction: Tactionstring = '';    {action on overload halting}
    haltcondition: Tcondstring = '';   {could use this for conditional haltmessage?}

type Tfixedresp = record
                   index: Tindexstring;
                   weight: integer; {2=double chance of occurring etc - not yet implemented}
                   msgstring: Tresponsestring;
                   gridindex: integer;
                   condstr: Tcondstring;
                   actstr: Tactionstring;
                   selfdel: boolean; {whether self-deleting}
                   used: boolean; {whether used}
                   tried: boolean {whether tried out, for [m] checking}
                  end;
     Tfixedset = record
                  sequential: boolean;
                  numresponses: integer;
                  lastresponse: Tindexstring;
                  lastautonumf:  integer;
                  fixedresps: array[1..maxfixedresp+1] of Tfixedresp
                                                  {+1 avoids range error when testing}
                 end;

var fixedsetarray: array[1..lastfixedset] of Tfixedset;

{***********************************************************************}
{* INPUT AND OUTPUT TRANSFORMATIONS                                    *}
{***********************************************************************}

type Tiotrans = record
                 index: Tindexstring;
                 pattern: Tpatternstring;
                 replace: Tpatternstring;
                 shortreplace: Tpatternstring; {doesn't include [X#2?]}
                 gridindex: integer;
                 condstr: Tcondstring;
                 actstr: Tactionstring;
                 repeatable: boolean;
                 selfdel: boolean; {whether self-deleting}
                 used: boolean; {whether used}
                 inuse: boolean
                end;

     Tioset = record
               numtransforms: integer;
               lastautonumio: integer;
               transforms: array[1..maxtransforms+1] of Tiotrans
              end;

    Tiof = (iofi,iofo,ioff);

var inputtrans,outputtrans,finaltrans: Tioset;

{***********************************************************************}
{* KEYWORD TRANSFORMATIONS                                             *}
{***********************************************************************}

var numkeysets: integer = 0;
    lastautonumks: integer = 0;
    lastkeyset: Tindexstring = '';

type Tkeyresp = record
                 index: Tindexstring;
                 weight: integer;
                 keystring: Tpatternstring;
                 gridindex: integer;
                 condstr: Tcondstring;
                 actstr: Tactionstring;
                 selfdel: boolean; {whether self-deleting}
                 used: boolean; {whether used}
                 tried: boolean {whether tried out, for [m] checking}
                end;

     Tkeyset = record
                index: Tindexstring;
                numkeys: integer;
                lastautonumk: integer;
                numresp: integer;
                lastautonumr: integer;
                lastresp: Tindexstring;
                sequential: boolean; {whether responses to be chosen sequentially}
                keywords: array[1..maxkeysinset+1] of Tkeyresp;
                keyresps: array[1..maxrespinset+1] of Tkeyresp
               end;

var keyarray: array[1..maxkeysets+1] of Tkeyset;

{***********************************************************************}
{* MEMORISED PHRASES                                                   *}
{***********************************************************************}

var nummemory: integer = 0;
    lastautonumm: integer = 0;

type Tmemory = record
 	        index: Tindexstring;
                phrase: Tphrasestring;
                gridindex: integer;
                condstr: Tcondstring;
                actstr: Tactionstring;
                used: byte {whether used for substitution, so action can be}
               end;        {done if substitutions turn out to be successful}

var memoryarray: array[1..maxmemory+1] of Tmemory;

{***********************************************************************}
{* MEMORISED INPUTS/OUTPUTS                                            *}
{***********************************************************************}

var numoutputs: integer = 0; {number of outputs - incremented by SPEAK}

type Tiomem = record
               phrase: Tphrasestring;
               used: byte {whether used for substitution, so trace can be}
              end;        {displayed appropriately if sustitutions are made}

     Tiomemarray = array[1..maxiomem+1] of Tiomem;

var imemarray,omemarray: Tiomemarray;

implementation

var pattlet: char;

initialization;

for pattlet:='A' to 'Z' do
 with patspec[pattlet] do
  begin
   if pattlet='B' then
    pattype:=ptbrak
   else
   if pos(pattlet,'ACDEFLNPSTXW')>0 then
    pattype:=ptnorm
   else
   if pos(pattlet,'MIO')>0 then
    pattype:=ptmemio
   else
    pattype:=ptbad;
   case pattlet of
    'A','C','D','L':     pextent:=indiv;
    'N','S','T','W':     pextent:=contig;
    'B','E','F','P','X': pextent:=multi;
    'M','I','O':         pextent:=contig {only needed for CHECKPATTERN}
   end;
   case pattlet of
    'B','X':         pcharok:=transformset; {is this the right set?}
    'D','N':         pcharok:=digitset;
    'C','F','S':     pcharok:=transformset-puncset;
    'A','E','T':     pcharok:=letterset+digitset;
    'L','P','W':     pcharok:=letterset;
    'M','I','O':     pcharok:=[];
    else pcharok:=transformset
   end
 end;
end.

