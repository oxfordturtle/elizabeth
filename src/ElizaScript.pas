unit ElizaScript;

interface

procedure initVsettings;
procedure initPsettings;
FUNCTION restart(fname: string;seed: longint;notfoundmsg: boolean): boolean;

implementation

uses Classes, Menus, Spin, stdctrls, SysUtils, ElizaU, ElizaTypes, ElizaUtils,
     ElizaControlFU, ElizaExecute, ElizaMemFun, ElizaProcess, ElizaSetup,
     ElizaOptionsFU;

type Treadfile = record
                  filevar: textfile;
                  fname: string;
                  linecount: integer
                 end;

const maxreadfiles = 20;
      numreadfiles: integer = 0;

var filearray: array[1..maxreadfiles] of Treadfile;
    lastlineread: string;

procedure initVsettings;
begin
 with ElizaForm do
  begin
   if MenuViewFast.Checked then
    dval:=5
   else
   if MenuViewMedium.Checked then
    dval:=10
   else
   if MenuViewSlow.Checked then
    dval:=25
   else
    dval:=0 {MenuViewInstant.Checked}
  end
end; {initVsettings}

procedure initPsettings;
begin
 with ElizaForm do
  begin
   checkpunct:=MenuProcPunct.Checked;
   seqdefault:=MenuProcSequential.Checked;
   echoblank:=MenuProcEcho.Checked;
   uppercaseonly:=MenuProcUpper.Checked
  end;
 fixoptform
end; {initPsettings}

procedure checkcomment(s: string);

 procedure deltosecond(n: integer);
 var posn: integer;
 begin
  delete(s,1,n);
  s:=trim(s);
  posn:=pos(' ',s);
  if posn>0 then
   delete(s,posn,maxint)
 end; {procedure deltosecond}

 procedure checkset(rstr: string;var setting: integer;n: integer);
 begin
  if pos(rstr,s)=1 then
   setting:=n
 end; {procedure checkset}

 procedure checksetstr(rstr: string;var setting: integer);
 begin
  if pos(rstr,s)=1 then
   begin
    delete(s,1,length(rstr));
    s:=trim(s);
    setting:=StrToIntDef(s,setting)
   end
 end; {procedure checksetstr}

 procedure noundo(var setting: integer);
 begin
  if (setting<>unlimited) then
   setting:=0;
 end;

 procedure yesundo(var setting: integer);
 begin
  if (setting>0) and (setting<unlimited) then
   recurse:=false
 end;

begin {procedure checkcomment}
 s:=uppercase(s);
 delpadding(s);
 if copy(s,1,3)='/V ' then
  with ElizaForm do
   begin
    delete(s,1,3);
    if pos('SHOW ALL TABLES',s)=1 then
     setview(viewAll)
    else
    if pos('SHOW TRANSFORMATION TABLES',s)=1 then
     setview(viewTonly)
    else
    if pos('HIDE TABLES',s)=1 then
     setview(hideAll)
    else
    if pos('INSTANT RESPONSE',s)=1 then
     dval:=0
    else
    if pos('FAST TYPING',s)=1 then
     dval:=5
    else
    if pos('MEDIUM TYPING',s)=1 then
     dval:=10
    else
    if pos('SLOW TYPING',s)=1 then
     dval:=25;
    fixoptform
   end {if '/V ' comment, with ElizaForm do}
 else
 if copy(s,1,3)='/P ' then
  with ElizaForm do
   begin
    delete(s,1,3);
    if pos('FINAL PUNCTUATION ON',s)=1 then
     checkpunct:=true
    else
    if pos('FINAL PUNCTUATION OFF',s)=1 then
     checkpunct:=false
    else
    if pos('SEQUENTIAL RESPONSES',s)=1 then
     seqdefault:=true
    else
    if pos('RANDOMISED RESPONSES',s)=1 then
     seqdefault:=false
    else
    if pos('ECHO IF NO KEYWORDS',s)=1 then
     echoblank:=true
    else
    if pos('BLANK IF NO KEYWORDS',s)=1 then
     echoblank:=false
    else
    if pos('UPPER CASE OUTPUT',s)=1 then
     uppercaseonly:=true
    else
    if pos('LOWER CASE PERMITTED',s)=1 then
     uppercaseonly:=false;
    fixoptform
   end {if '/P ' comment, with ElizaForm do}
 else
 if copy(s,1,3)='/C ' then
  with ControlForm do
   begin
    delete(s,1,3);
    if copy(s,1,9)='RECURSION' then
     begin
      deltosecond(9);
      recurse:=not(s='OFF');
      if recurse then
       begin
        noundo(inputiter);
        noundo(outputiter);
        noundo(finaliter);
        noundo(inputcycle);
        noundo(outputcycle);
        noundo(finalcycle)
       end
     end
    else
    if copy(s,1,10)='MATCHLIMIT' then
     begin
      deltosecond(10);
      matchlimit:=StrToIntDef(s,matchlimit)
     end
    else
    if copy(s,1,13)='MEMCHECKLIMIT' then
     begin
      deltosecond(13);
      memchecklimit:=StrToIntDef(s,memchecklimit)
     end
    else
     begin
      checkset('INPUT ITERATION PREVENTED',inputiter,0);
      checkset('OUTPUT ITERATION PREVENTED',outputiter,0);
      checkset('FINAL ITERATION PREVENTED',finaliter,0);
      checkset('INPUT ITERATION UNLIMITED',inputiter,unlimited);
      checkset('OUTPUT ITERATION UNLIMITED',outputiter,unlimited);
      checkset('FINAL ITERATION UNLIMITED',finaliter,unlimited);
      checkset('INPUT CYCLING PREVENTED',inputcycle,0);
      checkset('OUTPUT CYCLING PREVENTED',outputcycle,0);
      checkset('FINAL CYCLING PREVENTED',finalcycle,0);
      checkset('INPUT CYCLING UNLIMITED',inputcycle,unlimited);
      checkset('OUTPUT CYCLING UNLIMITED',outputcycle,unlimited);
      checkset('FINAL CYCLING UNLIMITED',finalcycle,unlimited);
      checksetstr('INPUT ITERATION UNDO LIMIT:',inputiter);
      checksetstr('OUTPUT ITERATION UNDO LIMIT:',outputiter);
      checksetstr('FINAL ITERATION UNDO LIMIT:',finaliter);
      checksetstr('INPUT CYCLING UNDO LIMIT:',inputcycle);
      checksetstr('OUTPUT CYCLING UNDO LIMIT:',outputcycle);
      checksetstr('FINAL CYCLING UNDO LIMIT:',finalcycle);
      yesundo(inputiter);
      yesundo(outputiter);
      yesundo(finaliter);
      yesundo(inputcycle);
      yesundo(outputcycle);
      yesundo(finalcycle)
     end;
    fixoptform2
   end {if '/C ' comment, with ControlForm do}
end; {procedure checkcomment}

function pushfile(f: string): boolean;
begin
 result:=false;
 if numreadfiles=maxreadfiles then
  inform('Cannot nest Script files more than '+IntToStr(maxreadfiles)+' deep')
 else
 if not(FileExists(f)) then
  inform('File "'+f+'" not found')
 else
  begin
   inc(numreadfiles);
   with filearray[numreadfiles] do
    begin
     fname:=f;
     linecount:=0;
     assignfile(filevar,f);
     {$I-}
      reset(filevar);
     {$I+}
     if ioresult=0 then
      result:=true
     else
      inform('Error opening file "'+f+'"')
    end
  end
end; {function pushfile}

function pullfile: boolean;
begin
 result:=(numreadfiles>0);
 if result then
  with filearray[numreadfiles] do
   begin
    fname:='';
    linecount:=0;
    closefile(filevar)
   end;
  dec(numreadfiles)
end; {function pullfile}

function getnextline(var s: string): boolean;
begin
 s:='';
 result:=true;
 if numreadfiles>0 then
  begin
   with filearray[numreadfiles] do
    begin
     if not(eof(filevar)) then
      repeat
       readln(filevar,s);
       inc(linecount);
       while copy(s,1,1)=' ' do
        delete(s,1,1);
       if copy(s,1,1)='/' then
        begin
         checkcomment(s);
         s:='';
        end
      until (s<>'') or eof(filevar);
     lastlineread:=IntToStr(linecount)+' of "'+fname+'"'
    end;
   if (s='') then
    begin
     pullfile;
     result:=getnextline(s)
    end
  end;
 if copy(uppercase(s),1,8)='#INCLUDE' then
  begin
   delete(s,1,8);
   while copy(s,1,1)=' ' do
    delete(s,1,1);
   while copy(s,length(s),1)=' ' do
    delete(s,length(s),1);
   result:=pushfile(s);
   if result then {if false, then s remains as filename}
    result:=getnextline(s)
  end
end; {function getnextline}

procedure loadscript(scriptname: string);
var origline,scriptline,nextline,actline: string; {current,next line,possible actline}
    countbrackets: integer;
    scripterror: boolean;
    errorcontext: string;

 function actstring(var actsofar,newline: string;init: boolean): boolean;
 type Tstate = (startampok,startcmd,amp,midline,rbkt);
 const state: Tstate = startampok; {preserved between calls}
 var posn: integer;
 begin
  result:=true; {false if error}
  if init then
   state:=startampok
  else
   begin
    actsofar:=actsofar+'|';
    case state of
     midline: state:=startampok; {command just ended}
     rbkt:    state:=startcmd    {action just ended}
    end
   end;
  while (newline<>'') and result do
   begin
    case state of
     startampok: case newline[1] of
                  ' ':     {ignore};
                  '{':     begin
                            inform('"{" can occur only after "&" in action specification after "'
                                        +origline+'" '+errorcontext);
                            result:=false
                           end;
                  '}':     begin
                            dec(countbrackets);
                            if countbrackets>0 then
                             actsofar:=actsofar+'}';
                            state:=rbkt
                           end;
                  '&':     state:=amp;
                  else     begin
                            actsofar:=actsofar+newline[1];
                            state:=midline
                           end
                 end;
     startcmd:   case newline[1] of
                  ' ':     {ignore};
                  '{':     begin
                            inform('"{" can occur only after "&" in action specification after "'
                                        +origline+'" '+errorcontext);
                            result:=false
                           end;
                  '}':     begin
                            dec(countbrackets);
                            if countbrackets>0 then
                             actsofar:=actsofar+'}';
                            state:=rbkt
                           end;
                  '&':     begin
                            inform('"&" where command expected in action specification after "'
                                        +origline+'" '+errorcontext);
                            result:=false
                           end
                   else     begin
                             actsofar:=actsofar+newline[1];
                             state:=midline
                            end
                 end;
     amp:        case newline[1] of
                  ' ': {ignore};
                  '{': begin
                        if countbrackets>0 then
                         actsofar:=actsofar+'& {';
                        inc(countbrackets);
                        state:=startcmd
                       end;
                  else begin
                        inform('"&" must be followed by " {" in action specification after "'
                                    +origline+'" '+errorcontext);
                        result:=false
                       end
                 end;
     midline:    case newline[1] of
                  '}':     begin
                            dec(countbrackets);
                            if countbrackets>0 then
                             actsofar:=actsofar+'}';
                            state:=rbkt
                           end;
                  '{':     begin
                            inform('"{" can occur only after "&" in action specification after "'
                                        +origline+'" '+errorcontext);
                            result:=false
                           end;
                  '&':     begin
                            inform('"&" can occur only at beginning of line in action specification after "'
                                        +origline+'" '+errorcontext);
                            result:=false
                           end;
                  else     actsofar:=actsofar+newline[1]
                 end;
     rbkt:       case newline[1] of
                  ' ': {ignore};
                  '}': begin
                        dec(countbrackets);
                        if countbrackets>0 then
                         actsofar:=actsofar+'}';
                        state:=rbkt
                       end;
                  else begin
                        inform('"}" should be followed by new line in action specification after "'
                                    +origline+'" '+errorcontext);
                        result:=false
                       end
                 end
    end; {case state}
    delete(newline,1,1);
    if countbrackets<0 then
     begin
      inform('Unmatched "}" in action specification after "'
                  +origline+'" '+errorcontext);
      result:=false
     end
   end; {while}
  posn:=pos('|}',actsofar);
  while posn>0 do
   begin
    delete(actsofar,posn,1);
    posn:=pos('|}',actsofar)
   end
 end; {function actstring}

 procedure checkscriptline(var s: string);
 begin
  replacechar(s,#145,'''');
  replacechar(s,#146,'''');
  replacechar(s,#147,'"');
  replacechar(s,#148,'"');
  charfilter(s,scriptset)
 end;

begin {procedure loadscript}
 loadingscript:=true;
 scripterror:=not(pushfile(scriptname));
 inittables;
 nextline:=''; {used to enable possible "&" lines to be read in anticipation}
 while ((numreadfiles>0) or (nextline<>'')) and not(scripterror) do
  begin
   if nextline='' then
    scripterror:=not(getnextline(scriptline)) {getnextline removes leading spaces}
   else
    begin
     scriptline:=nextline;
     nextline:=''
    end;
   actline:='';
   errorcontext:='at line '+lastlineread;
   origline:=duplampersand(scriptline); {for saving and display in error messages}
   checkscriptline(scriptline);
   if scriptline<>'' then
    begin
     if numreadfiles>0 then
      scripterror:=not(getnextline(nextline));
     if nextline<>'' then
      if nextline[1]='&' then
       begin
        countbrackets:=0;
        checkscriptline(nextline);
        scripterror:=not(actstring(actline,nextline,true));
        while (numreadfiles>0) and (countbrackets>0) and not(scripterror) do
         begin
          scripterror:=not(getnextline(nextline));
          checkscriptline(nextline);
          if not(scripterror) then
           scripterror:=not(actstring(actline,nextline,false))
         end; {check scripterror handling hereabouts}
        if (countbrackets>0) and not(scripterror) then
         begin
          inform('Unmatched "{" in action specification after "'
                                   +origline+'" '+errorcontext);
          scripterror:=true
         end
       end;
     if not(scripterror) then
      scripterror:=not(execute(scriptline,actline,errorcontext,false))
    end {if scriptline<>''}
  end; {while ((numreadfiles>0) or (nextline<>'')) and not(scripterror) do}
 while numreadfiles>0 do
  pullfile;
 if scripterror then
  inform('The rest of the script will be ignored');
{checkfixedsets; {include this for default fixed messages if no others specified}
 updategrids;
 loadingscript:=false
end; {procedure loadscript}

FUNCTION restart(fname: string;seed: longint;notfoundmsg: boolean): boolean;
var fullname: string;
begin
 result:=false;
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 if fname<>'' then
  begin
   fullname:=fullpath(fname);
   result:=FileExists(fullname);
   if result then
    with ElizaForm do
     begin
      randseed:=seed;
      if seed<0 then
       randomize; {used to have loop here until randseed>0 - but hung under Delphi7}
      condused:=false;
      condactheads;
      ElizaForm.BringToFront;
      initVsettings;
      initPsettings;
      fixoptform;
      initcontrol;
      fixoptform2;
      loadscript(fullname);
      mainscriptfile:=fname;
      ScriptLbl.Caption:='SCRIPT:  '+ampersand(mainscriptfile);
      Image1.Visible:=(ScriptLbl.Left>504);
      with ElizaForm.DialogueMemo.Lines do {identical for DialogueRichEdit}
       begin
        Clear;
        Add('<File='+mainscriptfile+'><RandomSeed='+IntToStr(randseed)+'>');
        Add('')
       end;
      numactions:=0;
      tracestep:=0;
      matchcount:=0;
      ElizaForm.TraceGrid.Rows:=0;
      numoutputs:=0;
      speak(choosefixed(welcomeset));
      doallactions;
      ElizaForm.InputEdit.SetFocus {might not need this here}
     end
   else
   if notfoundmsg then
    inform('File "'+fullname+'" not found')
  end
end;

end.
