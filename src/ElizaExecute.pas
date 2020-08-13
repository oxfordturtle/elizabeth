unit ElizaExecute;

interface

function execute(scriptline,actline,errorcontext: string;update: boolean): boolean;forward;
procedure testexecute(actionline,errorcontext: string);
procedure actiontolist(thisline,thisact,errorcontext: string); {needed for addsave only}

implementation

uses Forms, SysUtils, {for uppercase}
     ElizaAdd, ElizaMemFun, ElizaSetup, ElizaTypes, ElizaUtils;

function execute(scriptline,actline,errorcontext: string;update: boolean): boolean;
{true here means that no error was generated - does not imply execution}
var keychar: char;
    addflag,starred: boolean;
    thisindex,origsline,condition,pausemessage: string;
    exeresult: Texeresult;
    posn,i: integer;
begin
 if scriptline='' then
  begin
   result:=true;
   exit
  end;
 if pos('aard',scriptline)>0 then
  scriptline:='\'+scriptline;
 origsline:=scriptline;
 condition:='';
 if scriptline[1]='<' then
  begin
   posn:=pos('>:',scriptline);
   if posn>0 then
    begin
     condition:=copy(scriptline,2,posn-2);
     delete(scriptline,1,posn+1);
     while copy(scriptline,1,1)=' ' do
      delete(scriptline,1,1)
    end
   else
    begin
     inform('Condition must be enclosed in "< ... >:" '+errorcontext
                    +': "'+duplampersand(origsline)+'"');
     result:=false;
     exit
    end
  end;
 if (condition<>'') and not(condused) then
  begin
   condused:=true;
   condactheads
  end;
 starred:=(copy(scriptline,1,1)='\');
 if starred then
  begin
   delete(scriptline,1,1);
   while copy(scriptline,1,1)=' ' do
    delete(scriptline,1,1)
  end;
 if scriptline='' then
  begin
   inform('No script command '+errorcontext+': "'+duplampersand(origsline)+'"');
   exeresult:=exerror;
   result:=false;
   exit
  end;
 keychar:=upcase(scriptline[1]);
 if starred and not(keychar in ['W','V','Q','X','I','K','R','N','O','F']) then
  inform('"\" has no effect before "'+keychar+'" '+errorcontext
         +': "'+duplampersand(origsline)+'"');
 if keychar='P' then
  pausemessage:=scriptline;
 delete(scriptline,1,1);
 thisindex:='';
 if keychar='S' then {if index code is filepath, allow '\' to be included}
  while (copy(scriptline,1,1)<>' ') and (scriptline<>'') do
   begin
    thisindex:=thisindex+scriptline[1];
    delete(scriptline,1,1)
   end
 else
  while (copy(scriptline,1,1)<>' ') and (copy(scriptline,1,1)<>'\') and (scriptline<>'') do
   begin
    thisindex:=thisindex+scriptline[1];
    delete(scriptline,1,1)
   end;
 if keychar in ['K','R'] then
  begin
   charfilter(thisindex,indexset+['/']);
   posn:=pos('/',thisindex);
   if posn>0 then
    for i:=length(thisindex) downto posn+1 do
     if thisindex[i]='/' then
      delete(thisindex,i,maxint) {if two '/'s, delete from second one onwards}
  end
 else
 if keychar='S' then
  begin
   charfilter(thisindex,filenameset);
   thisindex:=StringReplace(thisindex,'*',' ',[rfReplaceAll]);
   if copy(thisindex,length(thisindex),1)='\' then
    begin
     delete(thisindex,length(thisindex),1);
     scriptline:='\'+scriptline
    end
  end
 else
  charfilter(thisindex,indexset); {is INDEXSET the right one to use here??}
 addflag:=(copy(scriptline,1,1)<>'\');
 if not(addflag) then
  delete(scriptline,1,1);
 while copy(scriptline,1,1)=' ' do
  delete(scriptline,1,1);
 case keychar of
  'W': exeresult:=addfixed(welcomeset,scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'V': exeresult:=addfixed(voidset,scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'Q': exeresult:=addfixed(quitset,scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'X': exeresult:=addfixed(exitset,scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'I': exeresult:=addiof(iofi,scriptline,thisindex,condition,actline,'Input',errorcontext,addflag,starred);
  'K': exeresult:=addkeyword(scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'R': exeresult:=addresponse(scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'N': exeresult:=addfixed(nokeyset,scriptline,thisindex,condition,actline,errorcontext,addflag,starred);
  'O': exeresult:=addiof(iofo,scriptline,thisindex,condition,actline,'Output',errorcontext,addflag,starred);
  'F': exeresult:=addiof(ioff,scriptline,thisindex,condition,actline,'Final',errorcontext,addflag,starred);
  'M': exeresult:=addmemory(scriptline,thisindex,condition,actline,errorcontext,addflag);
  'S': exeresult:=addsave(scriptline,thisindex,condition,actline,errorcontext,addflag);
  'H': exeresult:=addhalt(scriptline,condition,actline,errorcontext,addflag);
  '/': exeresult:=exetried;
  '&': begin
        inform('Action specified at inappropriate place: "'
                    +duplampersand(origsline)+'" not accepted '+errorcontext);
        exeresult:=exerror
       end;
  'P': begin {pause instruction}
        Application.ProcessMessages;
        exeresult:=exedone;
        delpadding(pausemessage);
        if (uppercase(pausemessage)='P') or (uppercase(pausemessage)='PAUSE') then
         pausemessage:='Pausing ...  Do you wish to continue?'
        else
         pausemessage:=pausemessage+' ... Do you wish to continue?';
        if not(query(pausemessage)) then
         begin
          matchlimit:=0;
          doactions:=false {remove pending actions from buffer}
         end
       end;
  else begin
        inform('Code "'+keychar+'" not understood '+errorcontext
                    +': "'+duplampersand(origsline)+'"');
        exeresult:=exerror
       end
 end; {case}
 if update then
  begin
   case keychar of
    'W': updatefixed(welcomeset);
    'V': updatefixed(voidset);
    'N': updatefixed(nokeyset);
    'Q': updatefixed(quitset);
    'X': updatefixed(exitset);
    'I': updateiof(iofi);
    'K': updatekeywords;
    'R': updatekeywords;
    'O': updateiof(iofo);
    'F': updateiof(ioff);
    'M': updatememory
   end;
   if not(addflag) then
    thisindex:=thisindex+'\';
   if pos('in command ',errorcontext)=1 then
    delete(errorcontext,1,11);
   case exeresult of
    exedone:  addtotrace(1,matchcount,'Action Performed','     '+keychar+thisindex+' '+scriptline+'     {'+errorcontext+'}');
    exetried: addtotrace(1,matchcount,'Action Attempted','     '+keychar+thisindex+' '+scriptline+'     {'+errorcontext+'}')
   end
  end;
 result:=(exeresult<>exerror)
end; {function execute}

procedure actiontolist(thisline,thisact,errorcontext: string);
begin
 if numactions<=maxactions then
  begin
   inc(numactions); {numactions=maxactions+1 is condition for overflow}
   if numactions<=maxactions then
    with actionlist[numactions] do
     begin
      line:=thisline;
      act:=thisact;
      context:=errorcontext
     end
  end
end; {procedure actiontolist}

procedure testexecute(actionline,errorcontext: string);
var posn,countbkt: integer;
    thisact,thisline: string;
begin
 doactions:=true;
 while (actionline<>'') and doactions do
  begin
   thisact:='';
   thisline:=pickbar(actionline);
   memiocheck(0,thisline,doapply,dotrace);
   if length(thisline)>1 then
    begin
     posn:=length(thisline);
     repeat
      dec(posn);
      if copy(thisline,posn,2)='[''' then
       delete(thisline,posn+1,1)
     until posn=1
    end;
   delpadding(thisline);
   delpadding(actionline);
   if copy(actionline,1,1)='&' then
    begin
     posn:=pos('{',actionline); {should always be 3}
     delete(actionline,1,posn);
     countbkt:=1;
     repeat
      if actionline[1]='{' then
       inc(countbkt)
      else
      if actionline[1]='}' then
       dec(countbkt);
      if countbkt>0 then
       thisact:=thisact+actionline[1];
      delete(actionline,1,1)
     until countbkt=0;
     pickbar(actionline)
    end;
   if thisline<>'' then
    begin
     if thisline[1]='!' then
      begin
       delete(thisline,1,1);
       if thisline<>'' then
        execute(thisline,thisact,errorcontext,true)
      end
     else
      actiontolist(thisline,thisact,errorcontext)
    end
  end;
end; {procedure testexecute}

end.
