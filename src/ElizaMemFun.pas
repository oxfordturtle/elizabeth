unit ElizaMemFun;

interface

function condok(condref,condition: string): boolean; {tests condition}
function memiocheck(add: integer;var origs: string; doit,traceit: boolean): boolean;
function choosefixed(fixedset: integer): string;
function fixfunctions(var s: string): boolean;

implementation

uses stdctrls, SysUtils, ElizaU, ElizaTypes, ElizaUtils, ElizaExecute;

function condok(condref,condition: string): boolean; {tests condition}
var posn: integer;
    lhs,rhs: string; {could do with checking these have desired effect}
    mempresent: boolean;
begin
 if condition='' then
  result:=true
 else
  begin
   if 'E' in matchtrace then
    addtotrace(1,matchcount,condref,'Condition is: "'+condition+'"');
   mempresent:=memiocheck(1,condition,doapply,donttrace);
   if 'E' in matchtrace then
    addtotrace(0,0,'     memory substitution','                   "'+condition+'"');
   if (condition<>'') and (condition[length(condition)]='?') then
    begin {note that MEMIOCHECK could make CONDITION null}
     delete(condition,length(condition),1);
     if ('E' in matchtrace) and not(mempresent) then
      addtotrace(0,0,'','Non-existent memory, so TRUE');
     result:=true
    end
   else
    begin
     if ('E' in matchtrace) and not(mempresent) then
      addtotrace(0,0,'','Non-existent memory, so FALSE');
     result:=mempresent
    end;
   if mempresent then {result is TRUE on entry here}
    begin
     posn:=pos('==',condition);
     if posn>0 then
      begin
       lhs:=copy(condition,1,posn-1);
       rhs:=copy(condition,posn+2,maxint);
       delpadding(lhs);
       delpadding(rhs);
      {if 'E' in matchtrace then
        addtotrace(0,0,'','Testing "'+lhs+'" for equality with "'+rhs+'"');{}
       result:=(lhs=rhs)
      end
     else
      begin
       posn:=pos('!=',condition);
       if posn>0 then
        begin
         lhs:=copy(condition,1,posn-1);
         rhs:=copy(condition,posn+2,maxint);
         delpadding(lhs);
         delpadding(rhs);
        {if 'E' in matchtrace then
          addtotrace(0,0,'','Testing "'+lhs+'" for inequality with "'+rhs+'"');{}
         result:=(lhs<>rhs)
        end
      end;
     if 'E' in matchtrace then
      begin
       if result then
        addtotrace(0,0,'',condition+' evaluated as TRUE')
       else
        addtotrace(0,0,'',condition+' evaluated as FALSE')
      end
    end
  end
end;

function memiocheck(add: integer;var origs: string; doit,traceit: boolean): boolean;
{returns TRUE if all [M]s, [I]s and [O]s are eliminated}
var s: string; {S stores the string as it's progressively modified}

 function memcheck: boolean;
 var previous,mcode: string;
     mnum,i: integer;

  procedure testmem(orwith: byte);
  var posn: integer;
  begin
   posn:=pos(mcode,uppercase(s));
   if posn>0 then
    if condok(mcode,memoryarray[mnum].condstr) then
     repeat
      s:=copy(s,1,posn-1)+memoryarray[mnum].phrase+copy(s,posn+length(mcode),maxint);
      memoryarray[mnum].used:=memoryarray[mnum].used or orwith;
      posn:=pos(mcode,uppercase(s))
     until posn=0
  end;

 begin {function memcheck}
  for i:=1 to nummemory do
   memoryarray[i].used:=0;
  previous:='';
  while (s<>previous) and (pos('[M',uppercase(s))>0) do
   begin
    previous:=s;
    for i:=1 to nummemory do
     begin
      mnum:=i;
      mcode:='[M'+uppercase(memoryarray[i].index)+']';
      testmem(1)
     end;
    for i:=1 to nummemory do
     begin
      mnum:=i;
      mcode:='[M+'+IntToStr(i)+']';
      testmem(2)
     end;
    for i:=0 downto 1-nummemory do
     begin
      mnum:=nummemory+i;
      if i=0 then
       mcode:='[M]'
      else
       mcode:='[M'+IntToStr(i)+']';
      testmem(4)
     end
   end;
  result:=(pos('[M',uppercase(s))=0)
 end; {end function memcheck}

 procedure memactreport;
 var mcode,report: string;
     mnum,i: integer;
 begin
  for mnum:=1 to nummemory do
   begin
    i:=mnum-nummemory;
    with memoryarray[mnum] do
     begin
      if traceit then
       begin
        if (used and 1)>0 then
         begin
          report:='[M'+uppercase(memoryarray[mnum].index)+'] => '+phrase;
          addtotrace(1,matchcount,'Memorised phrase',report);
          ElizaForm.MemoryLbl.Caption:=report+':  "'+origs+'"'
         end;
        if (used and 2)>0 then
         begin
          report:='[M+'+IntToStr(mnum)+'] => '+phrase;
          addtotrace(1,matchcount,'Memorised phrase',report);
          ElizaForm.MemoryLbl.Caption:=report+':  "'+origs+'"'
         end;
        if (used and 4)>0 then
         begin
          if i=0 then
           report:='[M] => '+phrase
          else
           report:='[M'+IntToStr(i)+'] => '+phrase;
          addtotrace(1,matchcount,'Memorised phrase',report);
          ElizaForm.MemoryLbl.Caption:=report+':  "'+origs+'"'
         end
       end; {if dotrace}
      if used>0 then
       testexecute(actstr,'in command from memorised phrase "'+phrase+'"')
     end
   end
 end; {procedure memactreport}

 function iocheck(iochar: char; iomemarray: Tiomemarray): boolean;
 var iocode: string;
     ionum,i: integer;

  procedure testio(orwith: byte);
  var posn: integer;
  begin
   posn:=pos(iocode,uppercase(s));
   if posn>0 then
    repeat
     s:=copy(s,1,posn-1)+iomemarray[ionum].phrase+copy(s,posn+length(iocode),maxint);
     iomemarray[ionum].used:=iomemarray[ionum].used or orwith;
     posn:=pos(iocode,uppercase(s))
    until posn=0
  end; {maybe include check that this can't go on forever? likewise in memory case}

 begin {function iocheck}
  for i:=1 to numoutputs do
   iomemarray[i].used:=0;
  for i:=1 to numoutputs do
   begin
    ionum:=i;
    iocode:='['+iochar+'+'+IntToStr(i)+']';
    testio(2) {no need for testio(1), because no index code}
   end;
  for i:=0 downto 1-numoutputs do
   begin
    ionum:=numoutputs+i;
    if i=0 then
     iocode:='['+iochar+']'
    else
     iocode:='['+iochar+IntToStr(i)+']';
    testio(4)
   end;
  result:=(pos('['+iochar,uppercase(s))=0)
 end; {end function iocheck}

 procedure ioreport(iochar: char; iomemarray: Tiomemarray; ioword: string);
 var iocode,report: string;
     ionum,i: integer;
 begin
  for ionum:=1 to numoutputs do
   begin
    i:=ionum-numoutputs;
    with iomemarray[ionum] do
     begin
      if traceit then
       begin
        if (used and 2)>0 then
         begin
          report:='['+iochar+IntToStr(ionum)+'] => '+phrase;
          addtotrace(1,matchcount,'Recalled '+ioword,report);
          ElizaForm.MemoryLbl.Caption:=report+':  "'+origs+'"'
         end;
        if (used and 4)>0 then
         begin
          if i=0 then
           report:='['+iochar+'] => '+phrase
          else
           report:='['+iochar+IntToStr(i)+'] => '+phrase;
          addtotrace(1,matchcount,'Recalled '+ioword,report);
          ElizaForm.MemoryLbl.Caption:=report+':  "'+origs+'"'
         end
       end {if traceit}
     end
   end
 end; {procedure ioreport}

begin {function memiocheck}
 if add=0 then
  memcheckcount:=0
 else
  memcheckcount:=memcheckcount+add;
 if memcheckcount>memchecklimit then
  begin
   memcheckexceeded:=true;
   result:=false;
   exit
  end;
 s:=origs;
 result:=memcheck;
 if result then
  result:=iocheck('I',imemarray);
 if result then
  result:=iocheck('O',omemarray);
 if doit and result and (s<>origs) then
  begin
   origs:=s;
   memactreport;
   ioreport('I',imemarray,'Input');
   ioreport('O',omemarray,'Output')
  end
end;

function choosefixed(fixedset: integer): string;
var i,respnum,resptried,resplast: integer;
    respok: boolean;
    tempactive,tracestring: string;
    fixedlabel: Tlabel;
begin
 with fixedsetarray[fixedset] do
  begin
   if numresponses=0 then {To fix a bug - the code below could do with checking}
    begin
     result:='I CAN''T THINK OF ANYTHING TO SAY';
     tracestring:='No suitable messages available:  "'+result+'"';
     respnum:=0
    end
   else
    begin
     resplast:=1; {default 1 is useful for case of only one response in set}
     respok:=false; {set TRUE if successful response found}
     if numresponses>1 then
      begin {selection is necessary}
       if sequential then
        begin {sequential selection}
         respnum:=0;
         repeat
          inc(respnum)
         until (respnum=numresponses) or (fixedresps[respnum].index>lastresponse);
         if fixedresps[respnum].index<=lastresponse then
          respnum:=1; {RESPNUM is now the first one to try out}
         dec(respnum) {prepare to cycle through them}
        end;
       for i:=1 to numresponses do
        fixedresps[i].tried:=false; {only needed for random choices}
       resptried:=0; {count the number of responses tried}
       repeat
        if sequential then
         begin {sequential selection}
          inc(respnum);
          if respnum>numresponses then
           respnum:=1; {cycle through responses}
         end
        else
         begin {randomised selection}
          repeat
           respnum:=random(numresponses)+1 {numresponses is known to be >1}
          until not(fixedresps[respnum].tried);
         end; {RESPNUM has now been selected}
        fixedresps[respnum].tried:=true;
        inc(resptried);
        if (fixedresps[respnum].index=lastresponse) and (resptried<numresponses) then
         begin
          respok:=false;
          resplast:=respnum {save this one to try again if all others fail}
         end
        else
         begin
          tempactive:=fixedresps[respnum].msgstring;
          respok:=(condok(fixedcodes[fixedset,1]+' '+fixedresps[respnum].index,
                     fixedresps[respnum].condstr))
                  and (memiocheck(1,tempactive,dontapply,donttrace))
         end
       until respok or (resptried>=numresponses)
      end;
     if not(respok) then
      begin
       respnum:=resplast; {try previous response as last resort}
       respok:=(condok(fixedcodes[fixedset,1]+' '+fixedresps[respnum].index,
                  fixedresps[respnum].condstr))
               and (memiocheck(1,tempactive,dontapply,donttrace))
      end;
     if respok then
      begin
       lastresponse:=fixedresps[respnum].index;
       fixedresps[respnum].used:=true;
       result:=fixedresps[respnum].msgstring; {shouldn't this be substituted if appropriate??}
       tracestring:=fixedresps[respnum].index+':  "'+result+'"'
      end
     else
      begin
       result:='I CAN''T THINK OF ANYTHING TO SAY';
       tracestring:='No suitable messages available:  "'+result+'"'
      end
    end;
   with ElizaForm do
    case fixedset of
     welcomeset: fixedlabel:=WelcomeLbl;
     voidset:    fixedlabel:=VoidLbl;
     nokeyset:   fixedlabel:=NoKeywordLbl;
     quitset:    fixedlabel:=QuitLbl;
     exitset:    fixedlabel:=ExitLbl
    end;
   fixedlabel.Caption:=tracestring;
   addtotrace(1,matchcount,fixedtrace[fixedset],tracestring);
   if respnum>0 then
    testexecute(fixedresps[respnum].actstr,'in command from '+fixedtrace[fixedset]+' "'+result+'"')
  end;
end; {function choosefixed}

type Tstringfn = function(s: string): string;

function fnupper(s: string): string;
begin
 result:=uppercase(s)
end;

function fnlower(s: string): string;
begin
 result:=lowercase(s)
end;

function fnincrement(s: string): string;
var alphabit,numbit: string;
    i,value: integer;
begin
 if s='' then
  result:='1'
 else
  begin
   i:=length(s)+1;
   repeat
    dec(i)
   until not(s[i] in ['0'..'9']) or (i=1);
   if s[i] in ['0'..'9'] then {implies i=1}
    begin
     alphabit:='';
     numbit:=s
    end
   else
    begin
     if s[i]='-' then
      dec(i);
     alphabit:=copy(s,1,i);
     numbit:=copy(s,i+1,maxint)
    end;
   if numbit='' then
    result:=s+'1'
   else
    begin
     value:=StrToIntDef(numbit,0)+1;
     result:=alphabit+IntToStr(value)
    end;
  end
end;

function fndecrement(s: string): string;
var alphabit,numbit: string;
    i,value: integer;
begin
 if s='' then
  result:='-1'
 else
  begin
   i:=length(s)+1;
   repeat
    dec(i)
   until not(s[i] in ['0'..'9']) or (i=1);
   if s[i] in ['0'..'9'] then {implies i=1}
    begin
     alphabit:='';
     numbit:=s
    end
   else
    begin
     if s[i]='-' then
      dec(i);
     alphabit:=copy(s,1,i);
     numbit:=copy(s,i+1,maxint)
    end;
   if numbit='' then
    result:=s+'-1'
   else
    begin
     value:=StrToIntDef(numbit,0)-1;
     result:=alphabit+IntToStr(value)
    end;
  end
end;

function checkfn(var s: string;fnname: string;stringfn: Tstringfn): boolean;
var posn,i,j,brakcount: integer;
    s1,s2,s3: string;
begin
 result:=true; {made false if error}
 posn:=pos('['+fnname+':',uppercase(s));
 while posn>0 do
  begin
   delete(s,posn,length(fnname)+2);
   brakcount:=1;
   i:=posn-1;
   while (i<length(s)) and (brakcount>0) do
    begin
     inc(i);
     case s[i] of
      '[': inc(brakcount);
      ']': dec(brakcount)
     end
    end;
   if brakcount=0 then
    begin
     delete(s,i,1);
     dec(i)
    end
   else
    result:=false;
   s1:=copy(s,1,posn-1);
   s2:=copy(s,posn,i+1-posn);
   s3:=copy(s,i+1,maxint);
   memiocheck(1,s2,doapply,dotrace);
   s:=s1+stringfn(s2)+s3;
   posn:=pos('['+fnname+':',uppercase(s))
  end;
 if not(result) then
  inform('No closing bracket for function "'+fnname+'[...]"')
end;

function fixfunctions(var s: string): boolean;
begin
 checkfn(s,'UPPER',fnupper);
 checkfn(s,'LOWER',fnlower);
 checkfn(s,'INC',fnincrement);
 checkfn(s,'DEC',fndecrement)
end;

end.
