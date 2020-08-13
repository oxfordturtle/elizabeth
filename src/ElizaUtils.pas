unit ElizaUtils;

interface

uses ElizaTypes;

(*function decindex(var index: Tindexstring;oldvalue: integer): boolean;
function incindex(var index: Tindexstring;oldvalue: integer): boolean;*)
function ampersand(s: string): string; {doubles up ampersands}
procedure speak(s: string);
function fullpath(s: string): string; {gives path expanded relative to BASEPATH}
function bktmatch(s: string): boolean;
procedure delpadding(var s: string);
function pickbar(var s: string): string;
procedure showaction(condstr,actstr: string);
procedure checkends2(var pattern,replace,shortreplace: Tpatternstring);
procedure checkends1(var keystring: Tpatternstring);
function fixendpattern(s: string;addnulls: boolean): string;
procedure addtotrace(addstep: integer;matchings: integer;string1,string2: string);
function duplampersand(s: string): string;
function threedig(n: integer): string;
function autoindex(var n: integer): string;
function nextindex(s: string): string;
procedure spaceout(var s: string); {replacing "filterpunct"}
procedure charfilter(var s: string;okset: Tcharset); {filter and delete padding}
procedure replacechar(var s: string;charin,charout: char);
procedure delay(n: integer);
procedure outputline(s: string);
procedure inform(s: string);
function query(s: string): boolean;

implementation

uses Forms, SysUtils, Dialogs {for showmessage}, Controls {for mrYes},
     ElizaU, ActionU, InformFU, QueryFU;

function ampersand(s: string): string; {doubles up ampersands}
var i: integer;
begin
 i:=length(s)+1;
 while i>1 do
  begin
   dec(i);
   if s[i]='&' then
    insert('&',s,i)
  end;
 result:=s
end;

procedure speak(s: string);
var i,sbefore,safter: integer;
    outstr: string;

 function spcafter(c: char): integer;
 {0=no space after; 1=maybe space after; 2=probably space after}
 begin
  if c in ['(','[','{'] then
   result:=0
  else
  if c in ['!',',','.',':',';','?',')',']','}'] then
   result:=2
  else
   result:=1
 end;

 function spcbefore(c: char): integer;
 {0=no space before; 1=maybe space before; 2=probably space before}
 begin
  if c in ['(','[','{'] then
   result:=2
  else
  if c in ['!',',','.',':',';','?',')',']','}'] then
   result:=0
  else
   result:=1
 end;

begin {procedure speak}
 if uppercaseonly then
  s:=uppercase(s);
 outstr:='';
 safter:=0;
 for i:=1 to length(s) do
  begin
   if s[i]=' ' then
    begin
     if safter=1 then
      safter:=2 {real space changes space-after value from 1 to 2}
    end
   else
    begin
     sbefore:=spcbefore(s[i]);
     if safter*sbefore>1 then
      outstr:=outstr+' '+s[i]
     else
      outstr:=outstr+s[i];
     safter:=spcafter(s[i])
    end
  end;
 inc(numoutputs);
 omemarray[numoutputs].phrase:=outstr;
 outputline(outstr);
 with ElizaForm.DialogueMemo do {identical for DialogueRichEdit}
  begin
   Lines.Add(outstr);
   SelStart:=GetTextLen {note - HideSelection=false makes this scroll}
  end;
 ElizaForm.InputEdit.Clear
end; {procedure speak}

procedure inform(s: string); {replacement for ShowMessage}
begin
 with InformDlg do
  begin
   InformLbl.Width:=409; {InformBevel.Width-16;}
   InformLbl.Caption:=ampersand(s);
   InformLbl.Width:=409; {InformBevel.Width-16;}
   Application.ProcessMessages;
   InformBevel.Height:=InformLbl.Height+16;
   InformOKBtn.Top:=InformBevel.Height+23; {121+23=144}
   Height:=InformBevel.Height+88;          {121+96=217 - why is 96 too wide here but OK with QueryDlg?}
   InformDlg.Position:=poOwnerFormCenter;
   case processing of {to handle case of repeated messages while processing}
    pfalse: begin
             Close; {is this right? what if it's not open?}
             ShowModal
            end;
    ptrue: begin
            Show;
            processing:=pmsg
           end
   end
  end
end;

function query(s: string): boolean; {like INFORM, but with YES/NO}
begin
 with QueryDlg do
  begin
   QueryLbl.Width:=345; {QueryBevel.Width-16;}
   QueryLbl.Caption:=ampersand(s);
   QueryLbl.Width:=345; {QueryBevel.Width-16;}
   QueryBevel.Height:=QueryLbl.Height+16;
   QueryYesBtn.Top:=QueryBevel.Height+23;
   QueryNoBtn.Top:=QueryBevel.Height+23; {121+23=144}
   Height:=QueryBevel.Height+96; {121+96=217 - why is 96 OK here but not with InformDlg?}
   InformDlg.Position:=poOwnerFormCenter;
   result:=(ShowModal<>mrNo)
  end
end;

(*
function decindex(var index: Tindexstring;oldvalue: integer): boolean;
begin
 result:=(index=threedig(oldvalue));
 if result then
  index:=threedig(oldvalue-1)
end;

function incindex(var index: Tindexstring;oldvalue: integer): boolean;
begin
 result:=(index=threedig(oldvalue));
 if result then
  index:=threedig(oldvalue+1)
end; *)

function fullpath(s: string): string; {gives path expanded relative to BASEPATH}
var storecurrent: string;
begin
 storecurrent:=GetCurrentDir;
 ChDir(basepath);
 result:=ExpandFileName(s);
 ChDir(storecurrent)
end;

function bktmatch(s: string): boolean;
var i: integer;
    stack: string;
begin
 result:=false;
 stack:=' ';
 for i:=1 to length(s) do
  case s[i] of
   '(':     stack:=')'+stack;
   '<':     stack:='>'+stack;
   ')','>': begin
             if stack[1]=s[i] then
              delete(stack,1,1)
             else
              exit
            end
  end;
 result:=(stack=' ')
end;

procedure delpadding(var s: string);
var posn: integer;
begin
 s:=trim(s);
 posn:=pos('  ',s);
 while posn>0 do
  begin
   delete(s,posn,1);
   posn:=pos('  ',s)
  end
end;

function pickbar(var s: string): string;
var posn: integer;
begin
 posn:=pos('|',s);
 if posn=0 then
  begin
   result:=s;
   s:=''
  end
 else
  begin
   result:=copy(s,1,posn-1);
   delete(s,1,posn)
  end
end;

procedure showaction(condstr,actstr: string);
begin
 with ActionForm do
  begin
   CondLbl.Caption:=duplampersand(condstr);
   ActionLbl.Caption:=duplampersand(actstr);
   Height:=ActionLbl.Height+188;
   Show {previously ShowModal}
  end
end;

procedure checkends2(var pattern,replace,shortreplace: Tpatternstring);

 function endpattern(s,p: string): boolean;
 var i: integer;
 begin
  i:=length(s);
  if copy(s,length(s),1)=']' then
   while (copy(s,i,1)<>'[') and (i>1) do
    dec(i);
  result:=(uppercase(copy(s,i,length(p)))=uppercase(p))
 end;

 function endpunct(s: string): boolean;
 begin
  if s='' then
   result:=true {arbitrary}
  else
  if (s[length(s)] in ['.','!','?']) then
   result:=true
  else
   result:=endpattern(s,'[;') or endpattern(s,'[.')
 end;

begin {procedure checkends2}
 if copy(pattern,1,2)='[]' then
  delete(pattern,1,3)
 else
 if (uppercase(copy(pattern,1,2))<>'[X') then
  begin
   pattern:='[X#1?] '+pattern;
   replace:='[X#1?] '+replace;
   shortreplace:='[X#1?] '+shortreplace;
  end;
 if endpattern(pattern,'[]') then
  begin
   delete(pattern,length(pattern)-2,3);
   if ElizaForm.MenuProcPunct.Checked then
    if not(endpattern(pattern,'[X'))
       and not(endpunct(pattern)) then
     begin
      pattern:=pattern+' [.#?]';
      replace:=replace+' [.#?]';
      shortreplace:=shortreplace+' [.#?]'
     end
  end
 else
 if (pattern<>'') and not(endpattern(pattern,'[X')) then
  begin
   pattern:=pattern+' [X#2?]';
   replace:=replace+' [X#2?]'
  end
end; {procedure checkends2}

procedure checkends1(var keystring: Tpatternstring);
var dummy1,dummy2: Tpatternstring;
begin
 dummy1:='';
 dummy2:='';
 checkends2(keystring,dummy1,dummy2)
end;

{check this all works correctly with e.g. [;] [] at end etc}

function fixendpattern(s: string;addnulls: boolean): string;
{fix, for display, the end patterns added by the system}
var posn: integer;
begin
 if addnulls then
  begin
   if s='' then
    s:='[]'
   else
    begin
     if copy(uppercase(s),1,2)<>'[X' then
      s:='[] '+s;
     posn:=pos(' [.#?]',s);
     if posn>0 then
      s:=copy(s,1,posn)+'[]'
     else
     if copy(s,length(s),1)<>']' then
      s:=s+' []'
    end
  end;
 posn:=pos('[X#1?] ',s);
 if posn>0 then
  delete(s,posn,7);
 posn:=pos(' [X#2?]',s);
 if posn>0 then
  delete(s,posn,7);
 posn:=pos(' [.#?]',s);
 if posn>0 then
  delete(s,posn,6);
 result:=s
end;

procedure addtotrace(addstep: integer;matchings: integer;string1,string2: string);
begin
 tracestep:=tracestep+addstep;
 with ElizaForm.TraceGrid do
  begin
   Rows:=Rows+1;
   if addstep>0 then
    begin
     Cell[1,Rows]:=IntToStr(tracestep);
     Cell[2,Rows]:=IntToStr(matchings)
    end;
   Cell[3,Rows]:=string1;
   Cell[4,Rows]:=string2
  end;
{ShowMessage('Trace step '+IntToStr(tracestep));{}
 Application.ProcessMessages
end;

function duplampersand(s: string): string;
var i,bkt,count: integer;
begin 
 if s<>'' then
  begin
   bkt:=0;
   i:=0;
   repeat
    inc(i);
    if s[i]='|' then
     begin
      s[i]:=#13;
      for count:=1 to bkt*5 do
       begin
        inc(i);
        insert(' ',s,i)
       end
     end
    else
    if s[i]='&' then
     begin
      insert('  &',s,i);
      i:=i+3
     end
    else
    if s[i]='{' then
     inc(bkt)
    else
    if s[i]='}' then
     dec(bkt)
   until i=length(s)
  end;
 result:=s 
end;

function threedig(n: integer): string;
begin
 result:=copy(IntToStr(1000+n mod 1000),2,3);
 if n>999 then
  result:=chr(64+n div 1000)+result
end;

function autoindex(var n: integer): string;
begin
 inc(n);
 result:=threedig(n)
end;

function nextindex(s: string): string;
var numdig,thisval,posn: integer;
    digbit: string;
begin
 if s='' then
  digbit:='000'
 else
  begin
   posn:=length(s)+1;
   repeat
    dec(posn)
   until (posn=1) or not(s[posn] in ['0'..'9']);
   if s[posn] in ['0'..'9'] then
    begin
     digbit:=copy(s,posn,maxint);
     delete(s,posn,maxint)
    end
   else
    begin
     digbit:=copy(s,posn+1,maxint);
     delete(s,posn+1,maxint);
     if digbit='' then
      digbit:='000'
    end
  end;
 numdig:=length(digbit);
 thisval:=StrToIntDef(digbit,0); {StrToInt would do}
 inc(thisval);
 digbit:=IntToStr(thisval);
 if length(digbit)>numdig then
  s:=s+'_'
 else
  while length(digbit)<numdig do
   digbit:='0'+digbit;
 result:=s+digbit
end;

function spaceit(s: string): string;
{spaces punctuation and curved brackets, but preserves everything in square brackets;
 should it delete spaces in square brackets?}
type Tstate = (start,normal,space,literal);
var i,brakcount: integer;
    state: Tstate;
begin
 result:='';
 if s='' then
  exit;
 brakcount:=0;
 state:=start;
 for i:=1 to length(s) do
  begin
   if (s[i]='[') then
    begin
     inc(brakcount);
     if state=space then
      result:=result+' ['
     else
      result:=result+'[';
     state:=literal
    end
   else
   if (s[i]=']') and (brakcount>0) then
    begin
     dec(brakcount);
     result:=result+']';
     if brakcount=0 then
      state:=normal
    end
   else {}
   case state of
    literal: result:=result+s[i];
    start:  if s[i] in puncset+bktset then
             begin
              result:=result+s[i];
              state:=space
             end
            else
            if s[i]<>' ' then
             begin
              result:=result+s[i]; {cannot start with space}
              state:=normal
             end;
    normal: if s[i]=' ' then
             state:=space
            else
            if s[i] in puncset+bktset then
             begin
              result:=result+' '+s[i];
              state:=space
             end
            else
             result:=result+s[i];
    space:  if s[i] in puncset+bktset then
             result:=result+' '+s[i]
            else
            if s[i]<>' ' then
             begin
              result:=result+' '+s[i];
              state:=normal
             end;
   end {case}
  end
end; {function spaceit}

procedure spaceout(var s: string);
var posn: integer;
    buildup: string;
begin
 buildup:='';
 posn:=pos('=>',s);
 while posn>0 do
  begin
   buildup:=buildup+spaceit(copy(s,1,posn-1))+'=>';
   delete(s,1,posn+1);
   posn:=pos('=>',s)
  end;
 s:=buildup+spaceit(s)
end;

procedure charfilter(var s: string;okset: Tcharset); {filter and delete padding}
type Tstate = (start,normal,space);
var i: integer;
    filtstr: string;
    state: Tstate;
begin
 if s='' then
  exit;
 filtstr:='';
 state:=start;
 for i:=1 to length(s) do
  case state of
   start:  if s[i] in okset then
            begin
             filtstr:=filtstr+s[i];
             state:=normal
            end;
   normal: if s[i]=' ' then
            state:=space
           else
           if s[i] in okset then
            filtstr:=filtstr+s[i];
   space:  if s[i] in okset then
            begin
             filtstr:=filtstr+' '+s[i];
             state:=normal
            end
  end;
 s:=filtstr 
end;

procedure replacechar(var s: string;charin,charout: char);
var i: integer;
begin
 for i:=1 to length(s) do
  if s[i]=charin then
   s[i]:=charout
end;

procedure delay(n: integer);
begin 
 with ElizaForm.TypingTimer do
  begin
   Interval:=n;
   timerup:=false;
   Enabled:=true;
   repeat
    Application.ProcessMessages
   until timerup
  end
end; {procedure delay}

procedure outputline(s: string);
var i: integer;
    tempstr: string;

 procedure writechar(c: char);
 begin
  if (dval>0) then
   delay(2*dval+random(3*dval));
  with ElizaForm.SpeakMemo do
   Text:=Text+c;
 end; {procedure writechar}

begin {procedure outputline}
 if pending then exit;
 pending:=true;
 with ElizaForm.SpeakMemo do
  begin
   Text:='';
   for i := 1 to length(s) do
    begin
     if random(50)=0 then
      begin
       tempstr:=Text;
       writechar(chr(random(26)+65));
       if (dval>0) then
        delay(4*dval+random(4*dval));
       Text:=tempstr
      end;
     writechar(s[i])
    end
  end;
 pending:=false
end; {procedure outputline}

end.
