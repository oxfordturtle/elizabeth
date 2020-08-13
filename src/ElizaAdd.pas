unit ElizaAdd;

interface

uses ElizaTypes;

function addhalt(s,condline,actline,errcontext: string; addflag: boolean): Texeresult;
function addfixed(fixedset: integer; s,newindex,condline,actline,errcontext: string; addflag,starred: boolean): Texeresult;
function addiof(iof: Tiof; s,newindex,condline,actline,typestr,errcontext: string; addflag,starred: boolean): Texeresult;
function addkeyword(s,newindex,condline,actline: string;errcontext: string; addflag,starred: boolean): Texeresult;
function addresponse(s,newindex,condline,actline: string;errcontext: string; addflag,starred: boolean): Texeresult;
function addmemory(s,newindex,condline,actline,errcontext: string; addflag: boolean): Texeresult;
function addsave(s,newindex,condline,actline,errcontext: string; addflag: boolean): Texeresult;

implementation

uses Dialogs, SysUtils, TSGrid, FileCtrl {for ForceDirectories},
     ElizaU, ElizaMatch, ElizaProcess, ElizaUtils, ElizaSetup,
     ElizaExecute {for actiontolist}, ElizaMemFun {for condok};

function addhalt(s,condline,actline,errcontext: string; addflag: boolean): Texeresult;
begin
 charfilter(s,transformset);
 if addflag then
  haltmessage:=s
 else
  haltmessage:='';
 haltaction:=actline;
 haltcondition:=condline;
 result:=exedone
end;

function checkpattern(VAR orig: Tpatternstring;typestr,errorcontext: string): boolean;
{TYPESTR and ERRORCONTEXT are used only for error reporting}
type Tstate = (normal,openb,inb,endnull);
var s: string;
    c: char;
    startsp,spchar: string[1];
    i,posn: integer;
    state: Tstate;
begin
 while copy(orig,1,1)=' ' do
  delete(orig,1,1);
 while copy(orig,length(orig),1)=' ' do
  delete(orig,length(orig),1); {ensure no space at beginning or end}
 s:='';
 startsp:='';
 spchar:='';
 state:=normal;
 for i:=1 to length(orig) do
  begin
   c:=orig[i];
   if (state=endnull) and (c<>' ') then
    begin
     inform('Term "[]" is permitted only at ends of '+typestr+' - "'
                 +orig+'" not accepted '+errorcontext);
     result:=false;
     exit
    end
   else
    case c of
     ' ':     case state of
               normal: spchar:=startsp;
               inb:    s:=s+'_'
              end;
     '(',')': case state of
               normal: begin
                        s:=s+startsp+c;
                        startsp:=' ';
                        spchar:=' '
                       end;
               else    begin
                        inform('Bracket "'+c+'" in '+typestr+' - "'
                                    +orig+'" not accepted '+errorcontext);
                        result:=false;
                        exit
                       end;
              end;
     '[':     case state of
               normal: state:=openb;
               else    begin
                        inform('Nested "[" in '+typestr+' - "'
                                    +orig+'" not accepted '+errorcontext);
                        result:=false;
                        exit
                       end;
              end;
     ']':     case state of
               normal: begin
                        inform('Unmatched "]" in '+typestr+' - "'
                                    +orig+'" not accepted '+errorcontext);
                        result:=false;
                        exit
                       end;
               openb:  begin
                        s:=s+startsp+'[]';
                        if startsp='' then
                         begin
                          state:=normal;
                          startsp:=' ';
                          spchar:=' '
                         end
                        else
                         state:=endnull
                       end;
               inb:    begin
                        s:=s+']';
                        state:=normal
                       end;
              end;
     else     case state of
               normal: begin
                        s:=s+spchar+c;
                        startsp:=' ';
                        spchar:=''
                       end;
               openb:  begin
                        if upcase(c) in ['A'..'Z'] then
                         with patspec[upcase(c)] do
                          begin
                           if pattype=ptbad then
                            begin
                             inform('Term type "['+c+']" in '+typestr+' not recognised - "'
                                         +orig+'" not accepted '+errorcontext);
                             result:=false;
                             exit
                            end
                           else
                           if pextent=multi then
                            begin
                             s:=s+startsp+'['+c;
                             spchar:=' '
                            end
                          else
                           begin
                            s:=s+spchar+'['+c;
                            spchar:=''
                           end
                          end
                        else
                        if c in [',','.',';','!'] then
                         begin
                          s:=s+startsp+'['+c;
                          spchar:=' '
                         end
                        else
                         begin
                          inform('Term type "['+c+']" in '+typestr+' not recognised - "'
                                      +orig+'" not accepted '+errorcontext);
                          result:=false;
                          exit
                         end;
                        startsp:=' ';
                        state:=inb
                       end;
               inb:    s:=s+c
              end
    end {case c}
  end; {for i:=1 to length(orig) do}
 if state in [openb,inb] then
  begin
   inform('Unmatched "[" in '+typestr+' - "'
               +orig+'" not accepted '+errorcontext);
   result:=false;
   exit
  end;
 orig:=s;
 result:=true
end; {function checkpattern}

function addfixed(fixedset: integer; s,newindex,condline,actline,errcontext: string; addflag,starred: boolean): Texeresult;
var thisresponse,i: integer;
    found: boolean;
    seqcode: char;
begin
 charfilter(s,transformset);
 seqcode:=' ';
 if newindex<>'' then
  if newindex[1] in ['!','?'] then
   begin
    seqcode:=newindex[1];
    delete(newindex,1,1)
   end; {SEQCODE is now ' ', '!', or '?'}
 with fixedsetarray[fixedset] do
  begin
   case seqcode of
    '!': sequential:=true;
    '?': sequential:=false
   end;
   if (s='') and (addflag or (newindex='')) then
    begin
     if addflag then
      begin
       inform('Null '+fixedcodes[fixedset]+' response not accepted '
                  +errcontext);
       result:=exerror {"N" or "Nindex" without a string is an error}
      end
     else
      begin
       initfixed(fixedset);
       result:=exedone {"N\" deletes all no-keyword responses}
      end;
     exit
    end;
   thisresponse:=0;
   if newindex='' then {if no index then ...}
    begin
     repeat
      inc(thisresponse)
     until ((fixedresps[thisresponse].msgstring=s)
           and ((fixedresps[thisresponse].condstr=condline) or (condline='')))
           or (thisresponse>numresponses);
     found:=(thisresponse<=numresponses);   {... FOUND iff string and condition match}
     if addflag and not(found) then
      begin
       newindex:=autoindex(lastautonumf);   {else if adding, generate index ...}
       thisresponse:=0;                     {... and search for position}
       repeat
        if thisresponse>0 then
         newindex:=autoindex(lastautonumf); {if already used, increment index}
        repeat
         inc(thisresponse)
        until (fixedresps[thisresponse].index>=newindex) or (thisresponse>numresponses)
       until (fixedresps[thisresponse].index>newindex) or (thisresponse>numresponses)
      end
    end {if newindex=''}
   else
    begin
     repeat
      inc(thisresponse)
     until (fixedresps[thisresponse].index>=newindex) or (thisresponse>numresponses);
     found:=(fixedresps[thisresponse].index=newindex) and (thisresponse<=numresponses)
    end; {if index given, then FOUND iff index matches}
   if addflag and not(found) and (numresponses=maxfixedresp) then
    begin
     inform('Too many '+fixedcodes[fixedset]+' responses - "'
                  +s+'" not accepted '+errcontext);
     result:=exerror {error if too many responses}
    end
   else
   if addflag then
    begin
     result:=exedone;
     if not(found) then {make room if not found, and adding}
      begin
       for i:=numresponses downto thisresponse do
        fixedresps[i+1]:=fixedresps[i];
       inc(numresponses);
       fixedresps[thisresponse].index:=newindex {new index only in this case}
      end;
     with fixedresps[thisresponse] do {fix non-index details of new response}
      begin
       weight:=1;
       msgstring:=s;
       condstr:=condline;
       actstr:=actline;
       used:=false;
       selfdel:=starred
      end
    end {if addflag}
   else
    begin
     result:=exetried; {if deleting, default result is EXETRIED}
     if found then
      begin {delete existing response only if S is null, or S matches}
       if (s='') or (fixedresps[thisresponse].msgstring=s) then
        begin
         dec(numresponses);
         for i:=thisresponse to numresponses do
          fixedresps[i]:=fixedresps[i+1];
         result:=exedone
        end
      end {if found}
    end {if not(addflag)}
  end {with fixedsetarray[fixedset] do}
end;

function addiof(iof: Tiof; s,newindex,condline,actline,typestr,errcontext: string; addflag,starred: boolean): Texeresult;
{TYPESTR and ERRORCONTEXT are used only for error reporting}
var ioset: ^Tioset;
    posn,thistrans,i: integer;
    sleft,sright: string;
    leftpattern,rightreplace,rightshort: Tpatternstring;
    wildleft,wildright,found: boolean;
begin
 case iof of
  iofi: ioset:=@inputtrans;
  iofo: ioset:=@outputtrans;
  ioff: ioset:=@finaltrans
 end;
 charfilter(s,transformset+['=','>','{','}']);
 if (s='') and (addflag or (newindex='')) then
  begin
   if addflag then
    begin
     inform('Null '+typestr+' Transformation not accepted '
                 +errcontext);
     result:=exerror {"I" or "Iindex" without a string is an error}
    end
   else
    begin
     initiof(iof);
     result:=exedone {"I\" deletes all input transformations}
    end;
   exit
  end;
 posn:=pos('=>',s);
 if addflag and (posn<2) then
  begin
   inform(typestr+' Transformation "'+s+'" '+errcontext
               +' is not of form: FIND => REPLACE');
   result:=exerror; {can't add with null L.H.S. or missing "=>"}
   exit
  end;
 if posn=0 then
  begin
   sleft:=s;
   sright:='#' {"I\ one" is treated as "I\ one => wild" - # later filtered}
  end
 else
  begin
   sleft:=copy(s,1,posn-1);
   sright:=copy(s,posn+2,maxint)
  end;
 wildleft:=(sleft='');
 wildright:=(sright='#');
 charfilter(sleft,transformset);
 charfilter(sright,transformset+['{','}']); {here "#" is filtered out}
 leftpattern:=sleft;
 rightreplace:=sright;
 rightshort:=sright;
 if not(checkpattern(leftpattern,typestr+' Transformation',errcontext)) then
  begin
   result:=exerror;
   exit
  end;
 checkends2(leftpattern,rightreplace,rightshort);
 spaceout(leftpattern);
 thistrans:=0;
 if newindex='' then {if no index then ...}
  begin
   repeat
    inc(thistrans)
   until (((ioset.transforms[thistrans].pattern=leftpattern)
           or wildleft)
          and ((ioset.transforms[thistrans].replace=rightreplace)
               or wildright)
          and ((ioset.transforms[thistrans].condstr=condline)
               or (condline='')))
         or (thistrans>ioset.numtransforms);
   found:=(thistrans<=ioset.numtransforms); {... FOUND if transformation and condition match}
   if addflag and not(found) then
    begin
     newindex:=autoindex(ioset.lastautonumio); {else if adding, generate index ...}
     thistrans:=0;                             {... and search for position}
     repeat
      if thistrans>0 then
       newindex:=autoindex(ioset.lastautonumio); {if already used, increment index}
      repeat
       inc(thistrans)
      until (ioset.transforms[thistrans].index>=newindex)
         or (thistrans>ioset.numtransforms)
     until (ioset.transforms[thistrans].index>newindex)
        or (thistrans>ioset.numtransforms)
    end
  end {if newindex=''}
 else
  begin
   repeat
    inc(thistrans)
   until (ioset.transforms[thistrans].index>=newindex) or (thistrans>ioset.numtransforms);
   found:=(ioset.transforms[thistrans].index=newindex) and (thistrans<=ioset.numtransforms)
  end; {if index given, then FOUND iff index matches}
 if addflag and not(found) and (ioset.numtransforms=maxtransforms) then
  begin
   inform('Too many '+typestr+' Transformations - "'
               +s+'" not accepted '+errcontext);
   result:=exerror {error if too many transformations}
  end
 else
 if addflag then
  begin
   result:=exedone;
   if not(found) then {make room if not found, and adding}
    begin
     for i:=ioset.numtransforms downto thistrans do
      ioset.transforms[i+1]:=ioset.transforms[i];
     inc(ioset.numtransforms);
     ioset.transforms[thistrans].index:=newindex {new index only in this case}
    end;
   with ioset.transforms[thistrans] do {fix non-index details of new transform}
    begin
     pattern:=leftpattern;
     replace:=rightreplace;
     shortreplace:=rightshort;
     condstr:=condline;
     actstr:=actline;
     repeatable:=(pos('[X#1?]',leftpattern)>0) and (pos('[X#2?]',leftpattern)>0);
     {could just as well test RIGHTREPLACE - same effect};
     used:=false;
     selfdel:=starred;
     inuse:=false
    end
  end {if addflag}
 else
  begin
   result:=exetried; {if deleting, default result is EXETRIED}
   if found then
    begin {delete existing transform only if it matches}
     if (s='')
        or (((ioset.transforms[thistrans].pattern=leftpattern)
             or wildleft)
           and ((ioset.transforms[thistrans].replace=rightreplace)
                or wildright)) then
      begin
       selfdelIOF:=ioset.transforms[thistrans].inuse; {is transformation de facto deleting itself?}
       dec(ioset.numtransforms);
       for i:=thistrans to ioset.numtransforms do
        ioset.transforms[i]:=ioset.transforms[i+1];
       result:=exedone
      end
    end
  end {if not(addflag)}
end; {function addiof}

function addmemory(s,newindex,condline,actline,errcontext: string; addflag: boolean): Texeresult;
var thismemory,i: integer;
    found: boolean;
    dummylist: string;
begin
 charfilter(s,transformset); {allows "[" and "]" through for now}
 thismemory:=0;
 if newindex='' then {if no index then ...}
  begin
   if addflag then
    begin
     found:=false;
     newindex:=autoindex(lastautonumm); {else if adding, generate index ...}
     repeat                             {... and search for position}
      if thismemory>0 then
       newindex:=autoindex(lastautonumm); {if already used, increment index}
      repeat
       inc(thismemory)
      until (memoryarray[thismemory].index>=newindex)
         or (thismemory>nummemory);
     until (memoryarray[thismemory].index>newindex)
        or (thismemory>nummemory)
    end {if addflag}
   else
    begin
     if (s='') then
      begin
       initmemory;
       result:=exedone; {"M\" deletes all memories}
       exit
      end
     else
      begin {deletion without index code} (*
       repeat
        inc(thismemory)
       until ((memoryarray[thismemory].phrase=s) and
              ((memoryarray[thismemory].condstr=condline) or (condline=''))
             or (thismemory>nummemory);
       found:=(thismemory<=nummemory); {... FOUND iff string and condition match} *)
       found:=false (* to allow for multiple deletions of memories *)
      end
    end {if not(addflag)}
  end {if newindex=''}
 else
  begin
   if newindex[1] in ['+','-'] then
    begin
     repeat
      inc(thismemory)
     until (newindex='+'+IntToStr(thismemory)) or
           (newindex='-'+IntToStr(nummemory-thismemory)) or
           (thismemory>nummemory);
     found:=(thismemory<=nummemory)
    end
   else
    begin
     repeat
      inc(thismemory)
     until (memoryarray[thismemory].index>=newindex) or (thismemory>nummemory);
     found:=(memoryarray[thismemory].index=newindex) and (thismemory<=nummemory)
    end
  end; {if index given, then FOUND iff index matches}
 if addflag and not(found) and (nummemory=maxmemory) then
  begin
   inform('Too many memorised phrases - "'+s
               +'" not accepted '+errcontext);
   result:=exerror {error if too many memories}
  end
 else
 if addflag then
  begin
   result:=exedone;
   if not(found) then {make room if not found, and adding}
    begin
     for i:=nummemory downto thismemory do
      memoryarray[i+1]:=memoryarray[i];
     inc(nummemory);
     memoryarray[thismemory].index:=newindex {new index only in this case}
    end;
   with memoryarray[thismemory] do
    begin
     phrase:=s;
     charfilter(phrase,memoryset); {filters out "[" and "]" when added}
     condstr:=condline;
     actstr:=actline
    end
  end {if addflag}
 else
  begin
   result:=exetried;
   if found then
    begin {delete existing memory}
     dummylist:=#0;
     if (s='') or (memoryarray[thismemory].phrase=s)
        or callmatch(memoryarray[thismemory].phrase,s,dummylist,false,'Deleting Memory') then
      begin {MATCH allows for pattern matching as well as string identity}
       dec(nummemory);
       for i:=thismemory to nummemory do
        memoryarray[i]:=memoryarray[i+1];
       result:=exedone
      end
    end {if found}
   else
    begin {in case of pattern deletion, delete ALL matches}
     if (newindex='') and (nummemory>0) then
      begin
       thismemory:=nummemory+1;
       repeat
        dec(thismemory);
        dummylist:=#0;
        if callmatch(memoryarray[thismemory].phrase,s,dummylist,false,'Adding Memory')
           and ((memoryarray[thismemory].condstr=condline)
                or (condline=''))
        then
         begin
          dec(nummemory);
          for i:=thismemory to nummemory do
           memoryarray[i]:=memoryarray[i+1];
          result:=exedone
         end;
       until thismemory=1
      end
    end {if not(found)}
  end {if not(addflag)}
end; {function addmemory}

function addsave(s,newindex,condline,actline,errcontext: string; addflag: boolean): Texeresult;
var fname: string;
    fexists: boolean;
    wfile: textfile;
    posn: integer;
begin
 fname:=fullpath(newindex);
 fexists:=FileExists(fname);
 if not(fexists) and (pos('\',fname)>0) then
  if not(ForceDirectories(ExtractFilePath(fname))) then
   begin
    result:=exerror;
    exit
   end;
 assignfile(wfile,fname);
 result:=exetried;
 if condok('Saving to file '+newindex,condline) then
  begin
   if (s='') and not(addflag) then {Sfilename.txt\ with nothing to save, hence delete file}
    begin
     if not(fexists) then
      result:=exetried {redundant but left for clarity}
     else
     if deletefile(fname) then
      begin
       actiontolist(actline,'',errcontext);
       result:=exedone
      end
     else
      result:=exerror;
     exit
    end;
   if addflag then {file to be appended to}
    begin
     {$I-}
      if not(fexists) then
       rewrite(wfile)
      else
       append(wfile);
     {$I+}
    end
   else {new file}
    begin
     {$I-}
      rewrite(wfile)
     {$I+}
    end;
   if ioresult<>0 then
    begin
     result:=exerror;
     exit
    end;
   {$I-}
    posn:=pos('\n',s);
    while posn>0 do
     begin
      writeln(wfile,copy(s,1,posn-1));
      delete(s,1,posn+1);
      posn:=pos('\n',s)
     end;
    if trim(s)<>'' then
     write(wfile,s);
    closefile(wfile);
   {$I+}
   if ioresult<>0 then
    begin
     result:=exerror;
     exit
    end;
   result:=exedone;
   testexecute(actline,errcontext) {does anything else need to be done first?}
  end
end; {function addsave}

function newkeyset(newsetindex: Tindexstring;var n: integer;seqcode: char): boolean;
{if newsetindex='' then index and n are both calculated; if n=0 then
 n is calculated, otherwise n is presumed to be set up correctly}
var i: integer;
begin
 result:=(numkeysets<maxkeysets);
 if not(result) then
  exit;
 if newsetindex='' then
  begin
   newsetindex:=autoindex(lastautonumks);
   n:=0
  end;
 if n=0 then
  repeat
   if n>0 then
    newsetindex:=autoindex(lastautonumks); {if newsetindex is already "taken"}
   repeat
    inc(n)
   until (keyarray[n].index>=newsetindex) or (n>numkeysets)
  until (keyarray[n].index>newsetindex) or (n>numkeysets);
 for i:=numkeysets downto n do
  keyarray[i+1]:=keyarray[i];
 inc(numkeysets);
 with keyarray[n] do
  begin
   index:=newsetindex;
   numkeys:=0;
   lastautonumk:=0;
   numresp:=0;
   lastautonumr:=0;
   lastresp:='';
   case seqcode of
    ' ': sequential:=seqdefault;
    '!': sequential:=true;
    '?': sequential:=false
   end;
   lastkeyset:=index {needed in case of just "K", where not followed by insertion}
  end
end; {function newkeyset}

procedure removeset(thiskeyset: integer);
var i: integer;
begin
 lastkeyset:='';
 dec(numkeysets);
 for i:=thiskeyset to numkeysets do
  keyarray[i]:=keyarray[i+1]
end;

procedure testremoveset(thiskeyset: integer);
var i: integer;
begin
 if (keyarray[thiskeyset].numkeys=0)
    and (keyarray[thiskeyset].numresp=0) then
  removeset(thiskeyset)
end;

procedure delkrs(thiskeyset: integer; ktrf: boolean; delset: boolean; seqcode: char);
var i: integer;
begin
 if thiskeyset>0 then
  begin
   if delset then
    removeset(thiskeyset)
   else
    with keyarray[thiskeyset] do
     begin
      if ktrf then
       numkeys:=0
      else
       begin
        numresp:=0;
        lastresp:=''
       end;
       case seqcode of
        '!': sequential:=true;
        '?': sequential:=false
       end;
      lastkeyset:=index
     end
  end
 else
  begin
   if delset then
    begin
     numkeysets:=0;
     lastkeyset:=''
    end
   else
   if ktrf then
    for i:=1 to numkeysets do
     keyarray[i].numkeys:=0
   else
    for i:=1 to numkeysets do
     with keyarray[i] do
      begin
       numresp:=0;
       lastresp:=''
      end
  end
end;

function findnamedset(setname: string): integer;
var i: integer;
begin
 result:=0;
 if setname<>'' then
  for i:=1 to numkeysets do
   if keyarray[i].index=setname then
    result:=i
end;

{MAKE SURE LASTKEYSET IS SET IN ALL CASES OF DELETION - USED TO BE DONE IN
 TESTREMOVESET}

function addkeyword(s,newindex,condline,actline: string;errcontext: string; addflag,starred: boolean): Texeresult;
var thiskeyset,i,posn: integer;
    keypattern: Tpatternstring;
    setindex,keyindex,siparam: string;
    found,slash,testdel: boolean;
    seqcode: char; {'!' or '?' after keyword set code, or ' ' if neither}

 procedure delkeyword(thiskeyset,thiskey: integer;testremove: boolean);
 var i: integer;
 begin
  with keyarray[thiskeyset] do
   begin
    dec(numkeys);
    for i:=thiskey to numkeys do
     keywords[i]:=keywords[i+1];
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end;
  if testremove then
   testremoveset(thiskeyset)
 end;

 procedure replacekeyword(thiskeyset,thiskey: integer);
 begin     {existing keyword index remains unchanged}
  with keyarray[thiskeyset] do
   begin
    with keywords[thiskey] do
     begin
      weight:=1;
      keystring:=keypattern;
      condstr:=condline;
      actstr:=actline;
      used:=false;
      selfdel:=starred
     end;
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end
 end;

 function searchkset(setcount: integer; replace,testremove: boolean): Texeresult;
 var setlimit,keycount: integer;
 begin
  result:=exetried;
  if numkeysets=0 then
   exit; {just in case}
  if setcount=0 then
   begin
    inc(setcount);
    setlimit:=numkeysets
   end
  else
   setlimit:=setcount;
  repeat
   with keyarray[setcount] do
    begin
     keycount:=0;
     repeat
      inc(keycount)
     until (keycount>numkeys)
           or ((keywords[keycount].index=keyindex)
               and (replace or (((keywords[keycount].keystring=keypattern) or (s=''))
                                and ((keywords[keycount].condstr=condline) or (condline=''))
                               )
                   )
              )
           or ((keyindex='')
               and (keywords[keycount].keystring=keypattern)
               and ((keywords[keycount].condstr=condline) or (condline=''))
              );
     if keycount<=numkeys then
      begin
       if replace then
        replacekeyword(setcount,keycount)
       else
        delkeyword(setcount,keycount,testremove);
       result:=exedone
      end
    end;
   inc(setcount)
  until (setcount>setlimit) or (result=exedone)
 end; {procedure searchkset}

 function insertkeyword(thiskeyset: integer;
                        newkeyindex: Tindexstring;n: integer): boolean;
{if newkeyindex='' then index and n are both calculated; if n=0 then
 n is calculated, otherwise n is presumed to be set up correctly}
 var i: integer;
 begin
  with keyarray[thiskeyset] do
   begin
    result:=(numkeys<maxkeysinset);
    if not(result) then
     begin
      if newkeyindex='' then
       inform('Too many keywords in one set - "'+index+': '+s+'" not accepted '+errcontext)
      else
       inform('Too many keywords in one set - keyword "'+index+'/'+newkeyindex+': '+s+'" not accepted '+errcontext);
      exit
     end;
    if newkeyindex='' then
     begin
      newkeyindex:=autoindex(lastautonumk);
      n:=0
     end;
    if n=0 then
     repeat
      if n>0 then
       newkeyindex:=autoindex(lastautonumk); {if newkeyindex is already "taken"}
      repeat
       inc(n)
      until (keywords[n].index>=newkeyindex) or (n>numkeys)
     until (keywords[n].index>newkeyindex) or (n>numkeys);
    for i:=numkeys downto n do
     keywords[i+1]:=keywords[i];
    inc(numkeys);
    with keywords[n] do
     begin
      index:=newkeyindex;
      weight:=1;
      keystring:=keypattern;
      condstr:=condline;
      actstr:=actline;
      used:=false;
      selfdel:=starred;
     end;
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end
 end; {function insertkeyword}

begin {function addkeyword}
 charfilter(s,transformset);
 seqcode:=' ';
 if newindex<>'' then
  if newindex[1] in ['!','?'] then
   begin
    seqcode:=newindex[1];
    delete(newindex,1,1)
   end; {SEQCODE is now ' ', '!', or '?'}
 posn:=pos('/',newindex);
 if posn=0 then
  begin
   setindex:=newindex;
   keyindex:=''
  end
 else
  begin
   setindex:=copy(newindex,1,posn-1);
   keyindex:=copy(newindex,posn+1,maxint)
  end;
 keypattern:=s;
 if not(checkpattern(keypattern,'Keyword Specification',errcontext)) then
  begin
   result:=exerror;
   exit
  end;
 s:=keypattern; {s is now "cleaned up", before ends get put on keypattern}
 checkends1(keypattern);
 spaceout(keypattern); {is this the right place for this?}
 if (newindex='') then
  slash:=false
 else
  slash:=(posn=1) or (posn=length(newindex));
 testdel:=false; {usually do not test to delete set which is emptied}
 if slash and not(addflag) and (setindex<>'') and (s<>'') then
  begin
   slash:=false;
   testdel:=true
  end; {for Ksi/\ SURE case, where "/" means testdelete rather than search}
 result:=exetried; {default EXETRIED}
 thiskeyset:=findnamedset(lastkeyset);
 if (thiskeyset>0) and (setindex<>'@') and ((newindex<>'') or (s='')) then
  thiskeyset:=0;
 if setindex='@' then
  begin
   if slash then
    siparam:=#0
   else
    siparam:=''
  end
 else
  begin
   siparam:=setindex;
   if siparam<>'' then
    thiskeyset:=findnamedset(siparam) {0 if no such set}
  end;
 if addflag then
  begin
   if (posn>1) and (s='') then
    begin
     inform('Null keyword not accepted '+errcontext);
     result:=exerror;
     exit
    end;
   if slash then
    begin
     if thiskeyset<>0 then
      result:=searchkset(thiskeyset,true,false)
     else
     if siparam='' then
      result:=searchkset(0,true,false) {search doesn't occur if siparam=#0}
    end {if slash}
   else
    begin {if not(slash)}
     if (s<>'') and (newindex='') then {simplest case: K SURE}
      begin
       if loadingscript then
        begin {if loading script, don't check to see if keyword exists already}
         if thiskeyset<>0 then
          if (keyarray[thiskeyset].numkeys>0)
             and (keyarray[thiskeyset].numresp>0) then
           thiskeyset:=0
        end
       else
        begin
         if thiskeyset=0 then
          result:=searchkset(0,true,false)
         else
          begin
           result:=searchkset(thiskeyset,true,false);
           if (result=exetried) then
            begin
             if (keyarray[thiskeyset].numkeys>0)
                and (keyarray[thiskeyset].numresp>0) then
              begin
               thiskeyset:=0;
               result:=searchkset(0,true,false)
              end {if not found and replaced, new set will be created later}
             else
              begin
               result:=exedone;
               if searchkset(0,true,false)=exetried then
                if not(insertkeyword(thiskeyset,keyindex,0)) then
                 result:=exerror
              end
            end
          end;
         if result<>exetried then
          exit {exit if existing keyword found and replaced}
        end {if not(loadingscript)}
      end;
     if thiskeyset<>0 then
      begin
       {if s='' then leave result as EXETRIED; set already existed}
       if s<>'' then
        begin
         result:=exedone;
         if searchkset(thiskeyset,true,false)=exetried then
          if not(insertkeyword(thiskeyset,keyindex,0)) then
           result:=exerror
        end
      end
     else
      begin {create new set}
       if not(newkeyset(siparam,thiskeyset,seqcode)) then
        begin {siparam='' or thiskeyset=0, so THISKEYSET automatically generated}
         if siparam<>'' then
          inform('Too many keyword sets - set "'+siparam+'" cannot be created '+errcontext)
         else
         if s='' then
          inform('Too many keyword sets - new one cannot be created '+errcontext)
         else
          inform('Too many keyword sets - keyword "'+s+'" not accepted '+errcontext);
         result:=exerror; {thiskeyset=0 will be changed to number of set}
         exit
        end;
       result:=exedone;
       if s<>'' then
        insertkeyword(thiskeyset,keyindex,1) {cannot have overfill error here, since it's a new set}
      end {create new set}
    end {if not(slash)}
  end {if addflag}
 else
  begin {if not(addflag)}
   if (s='') and (keyindex='') then
    begin
     if (setindex='') or (thiskeyset<>0) then
      begin
       delkrs(thiskeyset,true,slash,seqcode);
       result:=exedone
      end
    end
   else
   if newindex='' then
    begin {K\ SURE case}
     if thiskeyset<>0 then
      result:=searchkset(thiskeyset,false,false);
     if result=exetried then
      result:=searchkset(0,false,false)
    end
   else
   if slash then
    result:=searchkset(0,false,false)
   else
   if thiskeyset<>0 then
    result:=searchkset(thiskeyset,false,testdel)
  end {if not(addflag)}
end; {function addkeyword}

function addresponse(s,newindex,condline,actline: string;errcontext: string; addflag,starred: boolean): Texeresult;
var thiskeyset,i,posn: integer;
    resppattern: Tpatternstring;
    setindex,respindex,siparam: string;
    found,slash,testdel: boolean;
    seqcode: char; {'!' or '?' after keyword set code, or ' ' if neither}

 procedure delresponse(thiskeyset,thisresp: integer;testremove: boolean);
 var i: integer;
 begin
  with keyarray[thiskeyset] do
   begin
    if lastresp=keyresps[thisresp].index then
     lastresp:='';
    dec(numresp);
    for i:=thisresp to numresp do
     keyresps[i]:=keyresps[i+1];
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end;
  if testremove then
   testremoveset(thiskeyset)
 end;

 procedure replaceresponse(thiskeyset,thisresp: integer);
 begin     {existing response index remains unchanged}
  with keyarray[thiskeyset] do
   begin
    with keyresps[thisresp] do
     begin
      weight:=1;
      keystring:=resppattern;
      condstr:=condline;
      actstr:=actline;
      used:=false;
      selfdel:=starred
     end;
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end
 end;

 function searchrset(setcount: integer; replace,testremove: boolean): Texeresult;
 var setlimit,respcount: integer;
 begin
  result:=exetried;
  if numkeysets=0 then
   exit; {just in case}
  if setcount=0 then
   begin
    inc(setcount);
    setlimit:=numkeysets
   end
  else
   setlimit:=setcount;
  repeat
   with keyarray[setcount] do
    begin
     respcount:=0;
     repeat
      inc(respcount)
     until (respcount>numresp)
           or ((keyresps[respcount].index=respindex)
               and (replace or (((keyresps[respcount].keystring=resppattern) or (resppattern=''))
                                and ((keyresps[respcount].condstr=condline) or (condline=''))
                               )
                   )
              )
           or ((respindex='')
               and (keyresps[respcount].keystring=resppattern)
               and ((keyresps[respcount].condstr=condline) or (condline=''))
              );
     if respcount<=numresp then
      begin
       if replace then
        replaceresponse(setcount,respcount)
       else
        delresponse(setcount,respcount,testremove);
       result:=exedone
      end
    end;
   inc(setcount)
  until (setcount>setlimit) or (result=exedone)
 end; {procedure searchrset}

 function insertresponse(thiskeyset: integer;
                         newrespindex: Tindexstring;n: integer): boolean;
{if newrespindex='' then index and n are both calculated; if n=0 then
 n is calculated, otherwise n is presumed to be set up correctly}
 var i: integer;
 begin
  with keyarray[thiskeyset] do
   begin
    result:=(numresp<maxrespinset);
    if not(result) then
     begin
      if newrespindex='' then
       inform('Too many responses in one set - "'+index+': '+s+'" not accepted '+errcontext)
      else
       inform('Too many responses in one set - response "'+index+'/'+newrespindex+': '+s+'" not accepted '+errcontext);
      exit
     end;
    if newrespindex='' then
     begin
      newrespindex:=autoindex(lastautonumr);
      n:=0
     end;
    if n=0 then
     repeat
      if n>0 then
       newrespindex:=autoindex(lastautonumr); {if newrespindex is already "taken"}
      repeat
       inc(n)
      until (keyresps[n].index>=newrespindex) or (n>numresp)
     until (keyresps[n].index>newrespindex) or (n>numresp);
    for i:=numresp downto n do
     keyresps[i+1]:=keyresps[i];
    inc(numresp);
    with keyresps[n] do
     begin
      index:=newrespindex;
      weight:=1;
      keystring:=resppattern;
      condstr:=condline;
      actstr:=actline;
      used:=false;
      selfdel:=starred
     end;
    case seqcode of
     '!': sequential:=true;
     '?': sequential:=false
    end;
    lastkeyset:=index
   end
 end; {function insertresponse}

begin {function addresponse}
 charfilter(s,transformset+['{','}']);
 seqcode:=' ';
 if newindex<>'' then
  if newindex[1] in ['!','?'] then
   begin
    seqcode:=newindex[1];
    delete(newindex,1,1)
   end; {SEQCODE is now ' ', '!', or '?'}
 posn:=pos('/',newindex);
 if posn=0 then
  begin
   setindex:=newindex;
   respindex:=''
  end
 else
  begin
   setindex:=copy(newindex,1,posn-1);
   respindex:=copy(newindex,posn+1,maxint)
  end;
 resppattern:=s; {response need not conform to CHECKPATTERN nor CHECKENDS}
 if (newindex='') then
  slash:=false {for deletion of specific response from set, slash is irrelevant}
 else
  slash:=(posn=1) or (posn=length(newindex));
 testdel:=false; {usually do not test to delete set which is emptied}
 if slash and not(addflag) and (setindex<>'') and (s<>'') then
  begin
   slash:=false;
   testdel:=true
  end; {for Rsi/\ SURE case, where "/" means testdelete rather than search}
 result:=exetried; {default EXETRIED}
 thiskeyset:=findnamedset(lastkeyset);
 if (thiskeyset>0) and (setindex<>'@') then
  begin
   if (newindex<>'') or (s='') then
    thiskeyset:=0
  end;
 if setindex='@' then
  begin
   if slash then
    siparam:=#0
   else
    siparam:=''
  end
 else
  begin
   siparam:=setindex;
   if siparam<>'' then
    thiskeyset:=findnamedset(siparam) {0 if no such set}
  end;
 if addflag then
  begin
   if (posn>1) and (s='') then
    begin
     inform('Null response not accepted '+errcontext);
     result:=exerror;
     exit
    end;
   if slash then
    begin
     if thiskeyset<>0 then
      result:=searchrset(thiskeyset,true,false)
     else
     if siparam='' then
      result:=searchrset(0,true,false) {search doesn't occur if siparam=#0}
    end {if slash}
   else
    begin {if not(slash)}
     if thiskeyset<>0 then
      begin
       {if s='' then leave result as EXETRIED; set already existed}
       if s<>'' then
        begin
         result:=exedone;
         if searchrset(thiskeyset,true,false)=exetried then
          if not(insertresponse(thiskeyset,respindex,0)) then
           result:=exerror
        end
      end
     else
      begin {create new set}
       if not(newkeyset(siparam,thiskeyset,seqcode)) then
        begin {siparam='' or thiskeyset=0, so THISKEYSET automatically generated}
         if siparam<>'' then
          inform('Too many keyword sets - set "'+siparam+'" cannot be created '+errcontext)
         else
         if s='' then
          inform('Too many keyword sets - new one cannot be created '+errcontext)
         else
          inform('Too many keyword sets - response "'+s+'" not accepted '+errcontext);
         result:=exerror; {thiskeyset=0 will be changed to number of set}
         exit
        end;
       result:=exedone;
       if s<>'' then
        insertresponse(thiskeyset,respindex,1) {cannot have overfill error here, since it's a new set}
      end {create new set}
    end {if not(slash)}
  end {if addflag}
 else
  begin {if not(addflag)}
   if (s='') and (respindex='') then
    begin
     if (setindex='') or (thiskeyset<>0) then
      begin
       delkrs(thiskeyset,false,slash,seqcode);
       result:=exedone
      end
    end
   else
   if newindex='' then
    begin {R\ SURE case}
     if thiskeyset<>0 then
      result:=searchrset(thiskeyset,false,false)
    end
   else
   if slash then
    result:=searchrset(0,false,false)
   else
   if thiskeyset<>0 then
    result:=searchrset(thiskeyset,false,testdel)
  end {if not(addflag)}
end; {function addresponse}

end.
