unit ElizaProcess;

interface

procedure doallactions;
procedure processinput;

implementation

uses Controls, Dialogs, Forms, StdCtrls, SysUtils,
     ElizaU, ElizaTypes, ElizaUtils, ElizaAdd, ElizaExecute, ElizaMatch,
     ElizaMemFun, ElizaSetup;

procedure dodeletions;
var i,j: integer;
    fixedset: 1..lastfixedset;
    setcount: integer;
    updatekeys: boolean;

 procedure deliofs(iof: Tiof;iostring: string);
 var i,j: integer;
     ioset: ^Tioset;
 begin
  case iof of
   iofi: ioset:=@inputtrans;
   iofo: ioset:=@outputtrans;
   ioff: ioset:=@finaltrans
  end;
  with ioset^ do
   begin
    j:=0;
    for i:=1 to numtransforms do
     if (transforms[i].selfdel) and (transforms[i].used) then
      with transforms[i] do
       addtotrace(1,matchcount,'Self-deletion',
                  iostring+' Transformation '+index+':  "'
                  +fixendpattern(pattern,false)+' => '+fixendpattern(replace,false)+'"')
     else
      begin
       inc(j);
       if j<i then
        transforms[j]:=transforms[i]
      end;
    if j<numtransforms then
     begin
      numtransforms:=j;
      updateiof(iof)
     end
   end
 end;

begin
 for fixedset:=1 to lastfixedset do
  with fixedsetarray[fixedset] do
   begin
    j:=0;
    for i:=1 to numresponses do
     if (fixedresps[i].selfdel) and (fixedresps[i].used) then
      addtotrace(1,matchcount,'Self-deletion',
                 fixedtrace[fixedset]+' '+fixedresps[i].index+':  "'
                 +fixedresps[i].msgstring+'"')
     else
      begin
       inc(j);
       if j<i then
        fixedresps[j]:=fixedresps[i]
      end;
    if j<numresponses then
     begin
      numresponses:=j;
      updatefixed(fixedset)
     end
   end;
 updatekeys:=false;
 for setcount:=1 to numkeysets do
  with keyarray[setcount] do
   begin
    j:=0;
    for i:=1 to numkeys do
     if (keywords[i].selfdel) and (keywords[i].used) then
       addtotrace(1,matchcount,'Self-deletion',
                  'Keyword '+keyarray[setcount].index+' / '+keywords[i].index
                  +':  "'+fixendpattern(keywords[i].keystring,false)+'"')
     else
      begin
       inc(j);
       if j<i then
        keywords[j]:=keywords[i]
      end;
    if j<numkeys then
     begin
      numkeys:=j;
      updatekeys:=true
     end;
    j:=0;
    for i:=1 to numresp do
     if (keyresps[i].selfdel) and (keyresps[i].used) then
       addtotrace(1,matchcount,'Self-deletion',
                  'Keyword Response '+keyarray[setcount].index+' / '+keyresps[i].index
                  +':  "'+fixendpattern(keyresps[i].keystring,false)+'"')
     else
      begin
       inc(j);
       if j<i then
        keyresps[j]:=keyresps[i]
      end;
    if j<numresp then
     begin
      numresp:=j;
      updatekeys:=true
     end;
   end; {for setcount:=1 to numkeysets, with keyarray[setcount]}
 {if updatekeys then {do as a matter of course, so that last-used keys can be shown in table;
                      but might be worth having lookup table to restrict updates?}
  updatekeywords;
 deliofs(iofi,'Input');
 deliofs(iofo,'Output');
 deliofs(ioff,'Final')
end;

procedure doallactions;
var actiontodo: integer;
begin
 if numactions>maxactions then
  begin
   inform('Too many actions required - only '+IntToStr(maxactions)
               +' will be carried out');
   numactions:=maxactions
  end;
 actiontodo:=0;
 while numactions>actiontodo do
  begin
   inc(actiontodo);
   with actionlist[actiontodo] do
    execute(line,act,context,true);
  end;
 numactions:=0;
 dodeletions
end;

procedure processinput;
type Tkeyaction = (blank,nokey,keydone);
var anykeyaction: Tkeyaction;
    thiskeyaction: Tkeyaction;
    activetext: string;
    donetext: string;
    todotext: string;
    fromtype: char;
    fromindex: string;
    iternoact,cyclenoact: boolean; {whether any action performed in iteration/cycle}

 {maybe check for syntactic correctness when accepting transformations in the first place}
 procedure splittext(typecode: char;transindex: Tindexstring);
                     {'I','O','F'  ;minimum value of NEXT index in relevant set}
 var thisbit: string;
     i: integer;
     braces: boolean;

  procedure split(var s: string;braced: boolean);
  var posn: integer;
      index: string;
      iokfchar: char;
  begin
   delpadding(s);
   if (s<>'') or braced then {null text OK only if explicitly recursed}
    begin
     if braced then
      begin
       posn:=pos('=>',s);
       if posn>0 then
        begin
         index:=copy(s,posn+2,maxint);
         s:=copy(s,1,posn-1);
         {memiocheck(0,index,doapply,dotrace) is probably unnecessary}
         if index<>'' then {throw recursed text away if index=''}
          begin {Check what happens if ALL thrown away??}
           iokfchar:=upcase(index[1]);
           delete(index,1,1);
           if iokfchar in ['I','O','K','F'] then
            todotext:=#0+s+#1+iokfchar+index+todotext {recurse to specified index}
          end
        end
       else
        todotext:=#0+s+#1+'I'+todotext {recurse back to beginning of 'I's}
      end
     else
      todotext:=#0+s+#1+typecode+transindex+todotext;
     s:=''
    end
  end;

 begin
  braces:=false;
  thisbit:='';
  i:=length(activetext)+1;
  repeat
   dec(i);
   case activetext[i] of
    '}': begin
          split(thisbit,false); {NB - scanning BACKWARDS}
          braces:=true
         end;
    '{': begin
          split(thisbit,true);
          braces:=false
         end;
    else thisbit:=activetext[i]+thisbit
   end;
  until i=1;
  split(thisbit,braces);
  activetext:=nulltext
 end; {procedure splittext}

 function applyioftransform(thistransform: Tiotrans;VAR ifused: boolean;iof: Tiof;iostring: string): boolean;
 {returns TRUE if splitting/recursion takes place}
 {THISTRANSFORM is NOT a VAR parameter, in case the original is deleted en route,
  but IFUSED is set from USED, and feeds back to it}
 var iter,iterations: integer;
     origstring,oldstring,substlist,actstring,contextstring: string;
     workstring,newstring: string;
     thislist: string; {substlist for single repeatable transformation}
     matched,repeatmatch: boolean;
     iolabel: TLabel;
     nextindex: Tindexstring; {used for follow-on after splitting only}
     degentest,degencount: integer; {to test for degeneracy}
     memiostring: string; {pattern with MEM/I/O substituted}
 begin
  result:=false;
  selfdelIOF:=false; {used to record if transformation deletes itself}
  case iof of
   iofi: begin
          iter:=inputiter;
          iolabel:=ElizaForm.InputLbl
         end;
   iofo: begin
          iter:=outputiter;
          iolabel:=ElizaForm.OutputLbl
         end;
   ioff: begin
          iter:=finaliter;
          iolabel:=ElizaForm.FinalLbl
         end
  end;
  iterations:=iter;
  origstring:=activetext;
  degentest:=0;
  repeat
   activetext:=origstring; {to reinstate if iterations get past 10}
   memiostring:=thistransform.pattern;
   if memiocheck(0,memiostring,doapply,donttrace) then
    repeat
     dec(iterations);
     oldstring:=activetext;
     iternoact:=true;
     degencount:=0;
     matched:=false;
     substlist:=#0;
     if condok(iostring+' '+thistransform.index,thistransform.condstr) then
      begin
       if thistransform.repeatable then
        begin {repeatable transformation - with [X#1?] and [X#2?]}
         workstring:=activetext;
         newstring:='';
         repeat
          inc(degencount);
          thislist:=#0;
          repeatmatch:=callmatch(workstring,memiostring,thislist,false,iostring+' '+thistransform.index);
          if repeatmatch then
           begin
            matched:=true;
            newstring:=newstring+applysubst(thistransform.shortreplace,thislist)+' ';
            ifused:=true;
            workstring:=applysubst('[X#2?]',thislist);
            substlist:=substlist+copy(thislist,2,maxint)
           end
         until not(repeatmatch);
         activetext:=newstring+workstring;
        {if degentest=0 then
          degentest:=degencount;
         if degencount>degentest then
          it's degenerate, so do something!{only applies if degentest>0 - not yet implemented}
        end {if repeatable}
       else
        begin {not a repeatable transformation - try once only}
         matched:=callmatch(activetext,memiostring,substlist,false,iostring+' '+thistransform.index);
         if matched then
          begin
           activetext:=applysubst(thistransform.replace,substlist);
           ifused:=true
          end
        end
      end; {if condok(condstr)}
     if matched then
      begin
       fixfunctions(activetext); {deal with [upper: ], [lower: ] etc.}
       if memiocheck(0,activetext,dontapply,donttrace) then
        begin
         iolabel.Caption:=thistransform.index+':  "'+oldstring+'" => "'+activetext+'"';
         addtotrace(1,matchcount,iostring+' Transformation',thistransform.index+':  "'+oldstring+'"');
         addtotrace(0,0,'','  =>  "'+activetext+'"');
         actstring:=applysubst(thistransform.actstr,substlist);
         fixfunctions(actstring); {deal with [upper: ], [lower: ] etc.}
         spaceout(activetext);
         contextstring:='in command from '+lowercase(iostring)+' transformation "'
                        +fixendpattern(thistransform.pattern,true)+'=>'+fixendpattern(thistransform.replace,false)+'"';
         memiocheck(0,activetext,doapply,dotrace); {bound to give result TRUE}
         spaceout(activetext);
         if actstring<>'' then
          begin
           iternoact:=false;
           cyclenoact:=false;
           testexecute(actstring,contextstring)
          end;
         if pos('{',activetext)+pos('}',activetext)>0 then
          begin {indicates recursion/text splitting}
           if iter=0 then
            nextindex:=thistransform.index+' ' {lowest possible value of NEXT index}
           else
            nextindex:=thistransform.index; {iterate back to this transformation}
           case iof of
            iofi: splittext('I',nextindex);
            iofo: splittext('O',nextindex);
            ioff: splittext('F','') {final transformations always go from start - why??}
           end;
           iterations:=-1; {to force termination below}
           result:=true {to indicate that a recurse/split has taken place}
          end
        end
       else
        activetext:=oldstring
      end
    until ((activetext=oldstring) and iternoact)
          or (iterations<=0) or (matchcount>matchlimit) or memcheckexceeded
          or selfdelIOF; {if memiocheck then repeat}
   if iterations=0 then
    addtotrace(1,matchcount,iostring+' Transformation',IntToStr(iter)+' ITERATIONS, SO TRANSFORMATION APPLIED JUST ONCE')
  until (iterations<>0) or selfdelIOF {so after ITER iterations, goes back to do just 1}
 end; {procedure applyioftransform}

 procedure applytransformset(var iofset: Tioset;iof: Tiof;cyclelimit: integer;iostring: string;fromindex: string);
 var count,cycles: integer;
     origstring,oldstring,nextindex: string;
 begin
  cycles:=cyclelimit;
  origstring:=activetext;
  repeat
   activetext:=origstring; {to reinstate if cycles get past 10}
   repeat
    dec(cycles);
    oldstring:=activetext;
    cyclenoact:=true;
    nextindex:=fromindex;
    repeat
     count:=0;
     repeat
      inc(count)
     until (count>=iofset.numtransforms)
        or (iofset.transforms[count].index>=nextindex);
     if (count<=iofset.numtransforms)
        and (iofset.transforms[count].index>=nextindex) then
      begin
       nextindex:=iofset.transforms[count].index+' '; {lowest possible value of NEXT index}
       iofset.transforms[count].inuse:=true;
       if applyioftransform(iofset.transforms[count],
                            iofset.transforms[count].used,iof,iostring) then
        cycles:=-2; {to terminate on recurse/splitting}
       iofset.transforms[count].inuse:=false
      end
     else
      count:=0
    until (cycles=-2) or (count=0)
   until ((activetext=oldstring) and cyclenoact)
         or (cycles<=0) or (matchcount>matchlimit) or memcheckexceeded;
   if cycles=0 then
    addtotrace(1,matchcount,iostring+' Transform Cycle',IntToStr(cyclelimit)+' CYCLES, SO TRANSFORMATION CYCLE APPLIED JUST ONCE')
  until cycles<>0 {so after CYCLELIMIT cycles, goes back to do just 1}
 end; {procedure applytransformset}

 function applykeywordtransforms(fromindex: string): boolean; {true if keyword applied}
 var i,keysetcount,keycount,respnum,resptried,resplast,pass: integer;
     matched,respok: boolean;
     substlist,actstring1,from1,actstring2,from2,tempactive: string;
     memiostring: string; {keystring with MEM/I/O substituted}
 begin
  respnum:=0; {respnum>0 is test for working response found}
  keysetcount:=0;
  repeat
   inc(keysetcount)
  until (keysetcount>=numkeysets)
        or (keyarray[keysetcount].index>=fromindex);
  if (keysetcount<=numkeysets)
        and (keyarray[keysetcount].index>=fromindex) then
   begin
    dec(keysetcount);
    while (keysetcount<numkeysets) and (respnum=0) do
     begin
      inc(keysetcount);
      keycount:=0;
      with keyarray[keysetcount] do
       begin
        if (numkeys>0) and (numresp>0) then
         begin
          repeat
           inc(keycount);
           memiostring:=keywords[keycount].keystring;
           if memiocheck(0,memiostring,doapply,donttrace) then
            begin
             substlist:=#0;
             matched:=callmatch(activetext,memiostring,substlist,false,'Keyword '+index+'/'+keywords[keycount].index);
             if matched and (condok('Keyword '+index+'/'+keywords[keycount].index,
                                    keywords[keycount].condstr)) then
              begin
               resplast:=1; {default 1 is useful for case of only one response in set}
               respok:=false; {set TRUE if successful response found}
               if numresp>1 then
                begin {selection is necessary}
                 if sequential then
                  begin {sequential selection}
                   respnum:=0;
                   repeat
                    inc(respnum)
                   until (respnum=numresp) or (keyresps[respnum].index>lastresp);
                   if keyresps[respnum].index<=lastresp then
                    respnum:=1; {RESPNUM is now the first one to try out}
                   dec(respnum) {prepare to cycle through them}
                  end;
                 for i:=1 to numresp do
                  keyresps[i].tried:=false; {only needed for random choices}
                 resptried:=0; {count the number of responses tried}
                 repeat
                  if sequential then
                   begin {sequential selection}
                    inc(respnum);
                    if respnum>numresp then
                     respnum:=1; {cycle through responses}
                   end
                  else
                   begin {randomised selection}
                    repeat
                     respnum:=random(numresp)+1 {numresp is known to be >1}
                    until not(keyresps[respnum].tried);
                   end; {RESPNUM has now been selected}
                  keyresps[respnum].tried:=true;
                  inc(resptried);
                  if (keyresps[respnum].index=lastresp) and (resptried<numresp) then
                   begin
                    respok:=false;
                    resplast:=respnum {save this one to try again if all others fail}
                   end
                  else
                   begin
                    respok:=(condok('Response '+index+'/'+keyresps[respnum].index,
                                    keyresps[respnum].condstr));
                    if respok then
                     begin
                      tempactive:=applysubst(keyresps[respnum].keystring,substlist);
                      fixfunctions(tempactive); {deal with [upper: ], [lower: ] etc.}
                      spaceout(tempactive);
                      respok:=memiocheck(0,tempactive,dontapply,donttrace)
                     end
                   end
                 until respok or (resptried>=numresp)
                end;
               if not(respok) then
                begin
                 respnum:=resplast; {try previous response as last resort}
                 respok:=(condok('Response '+index+'/'+keyresps[respnum].index,
                                 keyresps[respnum].condstr));
                 if respok then
                  begin
                   tempactive:=applysubst(keyresps[respnum].keystring,substlist);
                   fixfunctions(tempactive); {deal with [upper: ], [lower: ] etc.}
                   spaceout(tempactive);
                   respok:=memiocheck(0,tempactive,dontapply,donttrace)
                  end
                end;
               if respok then
                lastresp:=keyresps[respnum].index
               else
                respnum:=0
              end {if matched}
            end {if memiocheck}
           else
            respnum:=0
          until (respnum>0) or (keycount=numkeys);
          if respnum>0 then {successful match and replacement}
           begin
            with keywords[keycount] do
             begin
              used:=true;
              ElizaForm.KeywordLbl1.Caption:=keyarray[keysetcount].index+' / '
                                            +index+':  "'+activetext+'"';
              addtotrace(1,matchcount,'Keyword Identified',keyarray[keysetcount].index+' / '
                           +index+':  "'+fixendpattern(keystring,true)+'"');
              actstring1:=applysubst(actstr,substlist);
              fixfunctions(actstring1); {deal with [upper: ], [lower: ] etc.}
              from1:='in command from keyword "'+fixendpattern(keystring,true)+'"'
             end;
            with keyresps[respnum] do
             begin
              used:=true;
              activetext:=applysubst(keystring,substlist);
              fixfunctions(activetext); {deal with [upper: ], [lower: ] etc.}
              spaceout(activetext);
              ElizaForm.KeywordLbl2.Caption:=keyarray[keysetcount].index+' / '
                                            +index+':  "'+activetext+'"';
              addtotrace(1,matchcount,'Response Selected',keyarray[keysetcount].index+' / '
                           +index+':  "'+fixendpattern(keystring,false)+'"');
              if activetext<>fixendpattern(keystring,false) then
               addtotrace(0,0,'','  =>  "'+activetext+'"');
              actstring2:=applysubst(actstr,substlist);
              fixfunctions(actstring2); {deal with [upper: ], [lower: ] etc.}
              from2:='in command from keyword response "'+fixendpattern(keystring,false)+'"'
             end;
            memiocheck(0,activetext,doapply,dotrace); {bound to give result TRUE}
            charfilter(activetext,transformset+['{','}']);
            spaceout(activetext);
            testexecute(actstring1,from1);
            testexecute(actstring2,from2);
            if pos('{',activetext)+pos('}',activetext)>0 then
             splittext('O','');
           end {if matched and (respnum>0)}
         end {if (numkeys>0) and (numresp>0)}
       end {with keyarray[keysetcount]}
     end {while (keysetcount<numkeysets) and (respnum=0)}
   end; {if there are keysets to be considered}
  result:=(respnum>0);
  if result then
   begin
    anykeyaction:=keydone;
    thiskeyaction:=keydone
   end
 end; {function applykeywordtransforms}

 procedure getnextpart;
 var posn: integer;
 begin
 {if donetext<>'' then
   if donetext[length(donetext)] in ['.'] then
    delete(donetext,length(donetext),1);{}
  if activetext<>nulltext then
   donetext:=donetext+' '+activetext;
  activetext:=nulltext;
  if length(todotext)>1 then
   begin
    delete(todotext,1,1);
    posn:=pos(#1,todotext);
    activetext:=copy(todotext,1,posn-1);
    delete(todotext,1,posn);
    posn:=pos(#0,todotext);
    fromindex:=copy(todotext,1,posn-1);
    delete(todotext,1,posn-1); {so list always starts with #0}
    if fromindex='' then
     fromtype:='I'
    else
     begin
      fromtype:=fromindex[1];
      delete(fromindex,1,1)
     end;
    if pos(' ',fromindex)>0 then
     addtotrace(1,matchcount,'Recursion/Split text',
                  'after '+fromtype+fromindex+': "'+activetext+'"')
    else
     addtotrace(1,matchcount,'Recursion/Split text',
                  'from '+fromtype+fromindex+' : "'+activetext+'"')
   end
 end; {procedure getnextpart}

begin {procedure processinput}
 if pending then
  begin
   inform('Please wait while I finish!');
   exit
  end;
 activetext:=ElizaForm.InputEdit.Text;
 imemarray[numoutputs].phrase:=activetext;
 with ElizaForm.DialogueMemo do {identical for DialogueRichEdit}
  begin
   if activetext='' then
    Lines.Add('<void input>')
   else
    Lines.Add(activetext);
   SelStart:=GetTextLen {note - HideSelection=false makes this scroll}
  end;
 Screen.Cursor:=crHourGlass;
 Application.ProcessMessages;
 numactions:=0;
 tracestep:=0;
 matchcount:=0;
 memcheckexceeded:=false;
 ElizaForm.TraceGrid.Rows:=0;
 addtotrace(1,matchcount,'User input','"'+activetext+'"');
 charfilter(activetext,inputoutputset);
 spaceout(activetext);
 if ElizaForm.MenuProcPunct.Checked then
  if activetext<>'' then
   if not(activetext[length(activetext)] in moodset) then
    activetext:=activetext+' .';
 activetext:=lowercase(activetext);
 addtotrace(1,matchcount,'Filtered and lower case','"'+activetext+'"');
 if activetext='' then
  anykeyaction:=blank
 else
  anykeyaction:=nokey; {used to record blank/keyword/nokey status}
 fromtype:='I';
 fromindex:='';
 processing:=ptrue;
 donetext:='';
 todotext:=#0;
 repeat {begin processing cycle}
  repeat {repeat I/K/O cycle prior to final transformations}
   thiskeyaction:=nokey;
   matchchar:='I';
   if (fromtype in ['I']) and (activetext<>nulltext) and (inputtrans.numtransforms>0) then
    applytransformset(inputtrans,iofi,inputcycle,'Input',fromindex); {nulltext is #0}
   matchchar:='K';
   if (fromtype in ['I','K']) and (activetext<>nulltext) and (numkeysets>0) then
    applykeywordtransforms(fromindex);
   if (thiskeyaction=nokey) and (activetext<>nulltext) then
    begin
     if echoblank then
      addtotrace(1,matchcount,'No keyword, so Echoing','"'+activetext+'"')
     else
      begin
       activetext:='';
       addtotrace(1,matchcount,'No keyword, so Blanking','"'+activetext+'"')
      end
    end;
   matchchar:='O';
   if fromtype='O' then
    begin
     if (activetext<>nulltext) and (outputtrans.numtransforms>0) then
    applytransformset(outputtrans,iofo,outputcycle,'Output',fromindex)
    end
   else
   if (fromtype in ['I','K']) and (activetext<>nulltext) and (outputtrans.numtransforms>0) then
    applytransformset(outputtrans,iofo,outputcycle,'Output','');
   matchchar:=' '; {is this necessary?}
   getnextpart {could have UNTIL NOT(getnextpart), and activetext='' on exit}
  until (activetext=nulltext) or (matchcount>matchlimit) or memcheckexceeded;
  if activetext=nulltext then
   activetext:=donetext
  else
   activetext:=donetext+' '+activetext; {Trace display todotext bits also?}
  case anykeyaction of {these are only invoked if NO keywords at all have been used}
   blank: activetext:=choosefixed(voidset); {now moved BEFORE final transformations}
   nokey: if fixedsetarray[nokeyset].numresponses>0 then
           activetext:=choosefixed(nokeyset)
  end; {leave active text unchanged if there are no no-keyword responses}
  memiocheck(0,activetext,doapply,dotrace); {maybe shift this into CHOOSEFIXED?}
  delpadding(activetext);
  donetext:='';
  todotext:=#0;
  fromtype:='F'; {probably not needed}
  fromindex:='';
  matchchar:='F';
  if (finaltrans.numtransforms>0) then
   applytransformset(finaltrans,ioff,finalcycle,'Final',fromindex);
  matchchar:=' ';
  getnextpart
 until (activetext=nulltext) or (matchcount>matchlimit) or memcheckexceeded;
 if activetext=nulltext then
  activetext:=donetext
 else
  activetext:=donetext+' '+activetext; {Trace display todotext bits also?}
 if matchlimit=0 then
  addtotrace(1,matchcount,'Processing Halted','User terminated processing using Halt button or Enter key')
 else
 if (matchcount>matchlimit) then
  begin
   addtotrace(1,matchcount,'Processing Halted','Too many calls to matching algorithm (see Control menu)');
   if haltmessage<>'' then
    begin
     activetext:=haltmessage;
     addtotrace(1,matchcount,'Halting message',haltmessage)
    end;
   if haltaction<>'' then
    testexecute(haltaction,'Halting action on exceeding match algorithm limit')
  end
 else
 if memcheckexceeded then
  begin
   addtotrace(1,matchcount,'Processing Halted','Too many calls to memory check algorithm (see Control menu)');
   if haltmessage<>'' then
    begin
     activetext:=haltmessage;
     addtotrace(1,matchcount,'Halting message',haltmessage)
    end;
   if haltaction<>'' then
    testexecute(haltaction,'Halting action on exceeding memory check limit')
  end;
 memiocheck(0,activetext,doapply,dotrace); {is there any point to this here?}
 spaceout(activetext);
 if ElizaForm.MenuProcPunct.Checked then
  if activetext<>'' then
   if not(activetext[length(activetext)] in moodset) then
    activetext:=activetext+' .';
 doallactions;
 Application.ProcessMessages;
 processing:=pfalse;
 Screen.Cursor:=crDefault;
 speak(activetext)
end;

end.
