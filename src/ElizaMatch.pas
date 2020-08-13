unit ElizaMatch;

interface

function applysubst(pattern: string;sublist: string): string;
function match(t,pattern: string;var sublist: string;applylist,doshow: boolean): boolean;
function callmatch(t,pattern: string;var sublist: string;applylist: boolean;display: string): boolean;
         {for external calls, increments matchcount}

implementation

uses SysUtils,
     ElizaTypes, ElizaUtils;

var matchdisplay: string = '(unspecified)'; {for trace display only}

function applysubst(pattern: string;sublist: string): string;
var posn: integer;
    find,repl: string;
begin
 if pattern<>'' then
  begin
   delete(sublist,1,1);
   while sublist<>'' do
    begin
     posn:=pos(#1,sublist);
     find:=copy(sublist,1,posn-1);
     delete(sublist,1,posn);
     posn:=pos(#0,sublist);
     repl:=copy(sublist,1,posn-1);
     delete(sublist,1,posn);
     posn:=pos(find,pattern);
     while posn>0 do
      begin
       pattern:=copy(pattern,1,posn-1)+repl+copy(pattern,posn+length(find),maxint);
       posn:=pos(find,pattern)
      end
    end;
   delpadding(pattern)
  end;
 result:=pattern
end; {function applysubst}

function matchword(t,pattern: string;var sublist: string;applylist: boolean): boolean;
var ptermend,tpos: integer;
    firstterm,restofpattern,passonlist: string;
    patterntype: char;
    possnull,minmatch,oksofar: boolean;
    bracket: Tpattype;
    extent: Tpextent;
    okset: Tcharset;
begin
 result:=false;
 okset:=transformset;
 if applylist then
  pattern:=applysubst(pattern,sublist); {to avoid inconsistent substitution}

 {1. DEAL WITH NULL PATTERN - CAN ONLY MATCH WITH NULL TEXT}

 if pattern='' then
  begin
   result:=(t='');
   exit
  end;

 {2. DEAL WITH ORDINARY FIRST CHARACTER IN PATTERN}

 if pattern[1]<>'[' then
  begin
   if t<>'' then
    begin
     if (t[1]=pattern[1]) or (upcase(t[1])=pattern[1]) then
      result:=matchword(copy(t,2,maxint),copy(pattern,2,maxint),sublist,false)
    end;
   exit
  end;

 {3. IDENTIFY FIRST TERM IN PATTERN, AND ITS PROPERTIES}

 ptermend:=pos(']',pattern);
 if ptermend=0 then
  begin
   inform('Unmatched "[" in parameter to MATCHWORD: "'+pattern+'"');
   exit
  end;
 firstterm:=copy(pattern,1,ptermend);
 restofpattern:=copy(pattern,ptermend+1,maxint);
 patterntype:=pattern[2];
 possnull:=pattern[ptermend-1]='?'; {ptermend must be >1}
 minmatch:=(patterntype in ['A'..'Z']);
 bracket:=ptbad;
 if upcase(patterntype) in ['A'..'Z'] then
  with patspec[upcase(patterntype)] do
   begin
    bracket:=pattype;
    extent:=pextent;
    okset:=pcharok
   end
 else
 if patterntype in [',','.',';','!'] then
  begin
   bracket:=ptnorm;
   if patterntype='!' then
    extent:=multi
   else
    extent:=indiv;
   case patterntype of
    ',': okset:=[',',';',';'];
    '.': okset:=['.','!','?'];
    ';': okset:=[',',';',';','.','!','?'];
    '!': okset:=[',',';',';','.','!','?',' '];
   end
  end;
 if bracket=ptbad then
  begin
   inform('Bad pattern parameter to MATCHWORD: "'+pattern+'"');
   exit
  end; {won't work with [,] and [;] etc}

 {4. IF (TEXT IS NULL AND FIRST TERM CAN MATCH NOTHING), OR
  (PATTERN IS MINIMALLY MATCHED), THEN TRY NULL MATCH}

 if possnull then
  begin
   if (t='') or minmatch then
    begin
     passonlist:=sublist+firstterm+#1#0;
     result:=matchword(t,restofpattern,passonlist,true);
     if result then
      begin
       sublist:=passonlist;
       exit
      end
    end
  end;

 {5. ELIMINATE CASE OF NULL TEXT}

 if t='' then
  exit;

 {6. MULTI-WORD PATTERNS ALWAYS WORK IF AND ONLY IF CHARACTERS ARE OK}

 {Should punctuation wildcards feature here too?}

 if extent=multi then
  begin
   if pattern<>firstterm then
    inform('"'+firstterm+'" must be entire parameter to MATCHWORD: "'+pattern+'"');
   sublist:=sublist+pattern+#1+t+#0;
   result:=true;
   for tpos:=1 to length(t) do
    if not(t[tpos] in okset) then
     result:=false;
  {if result and (bracket=ptbrak) then
    result:=bktmatch(t); {not necessary if brackets never occur within word}
   exit
  end;

 {7. DEAL WITH CONTIGUOUS PATTERNS, IN INCREASING/DECREASING ORDER
     DEPENDING ON WHETHER THEY'RE MINIMALLY/MAXIMALLY MATCHED}

 if extent=contig then
  if minmatch then
   begin
    tpos:=0;
    oksofar:=true;
    while (tpos<length(t)) and oksofar do
     begin
      inc(tpos);
      if t[tpos] in okset then
       begin
        passonlist:=sublist+firstterm+#1+copy(t,1,tpos)+#0;
        result:=matchword(copy(t,tpos+1,maxint),restofpattern,passonlist,true);
        if result then
         begin
          sublist:=passonlist;
          exit
         end
       end
      else
       oksofar:=false
     end
   end
  else
   begin {not(minmatch)}
    tpos:=0;
    repeat
     inc(tpos)
    until not(t[tpos] in okset) or (tpos=length(t));
    if not(t[tpos] in okset) then
     dec(tpos);
    while tpos>0 do
     begin
      passonlist:=sublist+firstterm+#1+copy(t,1,tpos)+#0;
      result:=matchword(copy(t,tpos+1,maxint),restofpattern,passonlist,true);
      if result then
       begin
        sublist:=passonlist;
        exit
       end;
      dec(tpos)
     end;
    if possnull then
     begin
      passonlist:=sublist+firstterm+#1#0;
      result:=matchword(t,restofpattern,passonlist,true);
      if result then
       begin
        sublist:=passonlist;
        exit
       end
     end
   end; {not minmatch}


 if extent=indiv then
  begin
   if t[1] in okset then
    begin
     passonlist:=sublist+firstterm+#1+t[1]+#0;
     result:=matchword(copy(t,2,maxint),restofpattern,passonlist,true);
     if result then
      begin
       sublist:=passonlist;
       exit
      end
    end;
   if possnull then
    begin
     passonlist:=sublist+firstterm+#1#0;
     result:=matchword(t,restofpattern,passonlist,true);
     if result then
      begin
       sublist:=passonlist;
       exit
      end
    end
  end;

end; {function matchword}


function match(t,pattern: string;var sublist: string;applylist,doshow: boolean): boolean;
{try to match text T against PATTERN, and build up substitution list in SUBLIST;
 APPLYLIST determines whether the existing SUBLIST is to apply to PATTERN first}
var tgap,tlen1,tfrom2,pgap,plen1,pfrom2,refnum: integer;
    patterntype: char;
    passonlist: string;
    badchar,possnull,minmatch: boolean;
    bracket: Tpattype; {from Tpatspec.pattype}
    extent: Tpextent;  {from Tpatspec.pextent}
    okset: Tcharset;   {from Tpatspec.pcharok}

 function nullcheck(s: string): boolean; {tests whether can be a null word}
 type Tstate = (start,endterm,interm,notnull);
 var state: Tstate;
     i: integer;
 begin
  state:=start;
  for i:=length(s) downto 1 do
   case state of
    start:   case s[i] of
              ']': state:=endterm;
              else state:=notnull
             end;
    endterm: case s[i] of
              '?': state:=interm; {doesn't deal with '[]'}
              else state:=notnull
             end;
    interm:  case s[i] of
              '[': state:=start
             end
   end;
  result:=not(state=notnull)
 end;

 procedure matchexit;
 begin
  if doshow and (matchchar in matchtrace) then
   begin
    if result then
     addtotrace(0,0,'  Result:',matchlevel+'| '+IntToStr(refnum)+' |  '+'TRUE')
    else
     addtotrace(0,0,'  Result:',matchlevel+'| '+IntToStr(refnum)+' |  '+'FALSE')
   end;
  delete(matchlevel,1,2);
 end;

begin
 refnum:=matchcount;
 matchlevel:='  '+matchlevel;
 result:=false;
 if doshow and (matchchar in matchtrace) then
  addtotrace(1,matchcount,'Match '+matchdisplay,matchlevel+'| '+IntToStr(refnum)+' |  /'+t+'/'+pattern+'/');
 if (copy(t,1,1)=' ') or (copy(t,length(t),1)=' ') then
  begin
   inform('Bad text parameter to MATCH: "'+t+'"');
   matchexit;
   exit
  end;
 if (copy(pattern,1,1)=' ') or (copy(pattern,length(pattern),1)=' ') then
  begin
   inform('Bad pattern parameter to MATCH: "'+pattern+'"');
   matchexit;
   exit
  end;
 if applylist then
  pattern:=applysubst(pattern,sublist); {to avoid inconsistent substitution}
  {can spacing be guaranteed to be OK after APPLYSUBST?}

 {1. DEAL WITH NULL PATTERN - CAN ONLY MATCH WITH NULL TEXT}

 if pattern='' then
  begin
   result:=(t='');
   matchexit;
   exit
  end;

 {2. IDENTIFY FIRST WORD IN PATTERN - SET PLEN1, PFROM2,
     PATTERNTYPE, AND POSSNULL ACCORDINGLY}

 {WHAT HAPPENS WITH [string1?][string2?], which can be null?}

 pgap:=pos(' ',pattern);
 if pgap=0 then
  pgap:=length(pattern);
 pfrom2:=pgap+1;
 if pattern[pgap]=' ' then
  plen1:=pgap-1
 else
  plen1:=pgap;
 patterntype:=#0;
 possnull:=false;
 minmatch:=false;
 bracket:=ptbad;
 if (pattern[1]='[') and (length(pattern)>1) then
  begin
   possnull:=nullcheck(copy(pattern,1,plen1));
   patterntype:=pattern[2];
   minmatch:=(patterntype in ['A'..'Z']);
   if upcase(patterntype) in ['A'..'Z'] then
    with patspec[upcase(patterntype)] do
     begin
      bracket:=pattype;
      extent:=pextent;
      okset:=pcharok+[' ']
     end
   else
   if patterntype in [',','.',';','!'] then
    begin
     bracket:=ptnorm;
     if patterntype='!' then
      extent:=multi
     else
      extent:=indiv;
     case patterntype of
      ',': okset:=[',',';',';'];
      '.': okset:=['.','!','?'];
      ';': okset:=[',',';',';','.','!','?'];
      '!': okset:=[',',';',';','.','!','?',' '];
     end
    end;
   if bracket=ptbad then
    begin
     inform('Bad pattern parameter to MATCH: "'+pattern+'"');
     matchexit;
     exit
    end
  end;

 {3. IF (TEXT IS NULL AND FIRST WORD IS A PATTERN THAT CAN MATCH NOTHING), OR
  (PATTERN IS MINIMALLY MATCHED), THEN TRY NULL MATCH. MAXIMAL MATCHES DONE LATER}

 if possnull then
  begin
   if (t='') or minmatch then
    begin
     passonlist:=sublist+copy(pattern,1,plen1)+#1#0; {try match of nothing}
     result:=match(t,copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
     if result then
      begin
       sublist:=passonlist;
       matchexit;
       exit
      end
    end
  end;

 {4. ELIMINATE CASE OF NULL TEXT}

 if t='' then
  begin
   matchexit;
   exit
  end;

 {5. DEAL WITH MAXIMALLY MATCHED MULTI-WORD PATTERNS, IN DIMINISHING ORDER}

 if (patterntype<>#0) and (extent=multi) and not(minmatch) then
  begin
   tgap:=0;
   repeat
    inc(tgap)
   until not(t[tgap] in okset) or (tgap=length(t));
   if not(t[tgap] in okset) and (tgap>1) then
    repeat
     dec(tgap)
    until (t[tgap]=' ') or (tgap=1);
   while tgap>1 do
    begin
     tfrom2:=tgap+1;
     if t[tgap]=' ' then
      tlen1:=tgap-1
     else
      tlen1:=tgap;
     if (bracket=ptbrak) and not(bktmatch(copy(t,1,tlen1))) then
      result:=false
     else
      begin
       passonlist:=sublist+copy(pattern,1,plen1)+#1+copy(t,1,tlen1)+#0;
       result:=match(copy(t,tfrom2,maxint),copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
      end;
     if result then
      begin
       sublist:=passonlist;
       matchexit;
       exit
      end;
     if tgap>1 then
      repeat
       dec(tgap)
      until (t[tgap]=' ') or (tgap=1)
    end; {while tgap>1}
   if possnull then
    begin
     passonlist:=sublist+copy(pattern,1,plen1)+#1#0; {try match of nothing}
     result:=match(t,copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
     if result then
      begin
       sublist:=passonlist;
       matchexit;
       exit
      end
    end
  end;

 {6. IDENTIFY FIRST WORD IN TEXT - SET TLEN1 and TFROM2 ACCORDINGLY}

 tgap:=pos(' ',t);
 if tgap=0 then
  tgap:=length(t);
 tfrom2:=tgap+1;
 if t[tgap]=' ' then
  tlen1:=tgap-1
 else
  tlen1:=tgap;

 {7. TRY MATCH OF FIRST WORDS WITH EACH OTHER, AND REMAINDERS WITH EACH OTHER}

 passonlist:=sublist;
 if matchword(copy(t,1,tlen1),copy(pattern,1,plen1),passonlist,false) then
  begin
   result:=match(copy(t,tfrom2,maxint),copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
   if result then
    begin
     sublist:=passonlist;
     matchexit;
     exit
    end
  end;

 {8. IF NULL MATCH IS STILL POSSIBLE, TRY IT}

 if possnull then
  begin
   passonlist:=sublist+copy(pattern,1,plen1)+#1#0; {try match of nothing}
   result:=match(t,copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
   if result then
    begin
     sublist:=passonlist;
     matchexit;
     exit
    end
  end;

 {9. DEAL WITH MINIMALLY MATCHED MULTI-WORD PATTERNS, IN INCREASING ORDER}

 badchar:=false;
 if (patterntype<>#0) and (extent=multi) and minmatch then
  while tgap<length(t) do
   begin
    repeat
     inc(tgap);
     if not(t[tgap] in okset) then badchar:=true
    until (t[tgap]=' ') or (tgap=length(t));
    tfrom2:=tgap+1;
    if t[tgap]=' ' then
     tlen1:=tgap-1
    else
     tlen1:=tgap;
    passonlist:=sublist+copy(pattern,1,plen1)+#1+copy(t,1,tlen1)+#0;
    if badchar then
     result:=false
    else
    if (bracket=ptbrak) and not(bktmatch(copy(t,1,tlen1))) then
     result:=false
    else
     result:=match(copy(t,tfrom2,maxint),copy(pattern,pfrom2,maxint),passonlist,true,deeptrace);
    if result then
     begin
      sublist:=passonlist;
      matchexit;
      exit
     end
   end;
 matchexit
end; {function match}

function callmatch(t,pattern: string;var sublist: string;applylist: boolean;display: string): boolean;
begin
 inc(matchcount);
 matchdisplay:=display;
 result:=match(t,pattern,sublist,applylist,true) {final TRUE is for DEEPTRACE}
end;


end.
