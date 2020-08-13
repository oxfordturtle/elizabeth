unit ElizaSetup;

interface

uses ElizaTypes;

procedure initfixed(setcount: integer);
procedure initiof(iof: Tiof);
procedure initkeysets;
procedure initmemory;
procedure inittables;
procedure condactheads;
procedure initgrids;
procedure updatefixed(fixedset: integer);
procedure updateiof(iof: Tiof);
procedure updatekeywords;
procedure updatememory;
procedure updategrids;

implementation

uses Classes, {needed for column alignment=taCenter}
     ElizaU, ElizaUtils, TSGrid, TSCommon {needed for htaLeft};

procedure initfixed(setcount: integer);
begin
 with fixedsetarray[setcount] do
  begin
   numresponses:=0;
   lastautonumf:=0;
   lastresponse:='';
   sequential:=seqdefault
  end
end;

procedure initiof(iof: Tiof);
var ioset: ^Tioset;
    i: integer;
begin
 case iof of
  iofi: ioset:=@inputtrans;
  iofo: ioset:=@outputtrans;
  ioff: ioset:=@finaltrans
 end;
 with ioset^ do
  begin
   for i:=1 to numtransforms do
    if transforms[i].inuse then
     selfdelIOF:=true;
   numtransforms:=0;
   lastautonumio:=0
  end
end;

procedure initkeysets;
begin
 numkeysets:=0;
 lastkeyset:='';
 lastautonumks:=0
end;

procedure initmemory;
begin
 nummemory:=0;
 lastautonumm:=0
end;

procedure inittables;
var setcount: integer;
begin
 tracestep:=0;
 ElizaForm.TraceGrid.Rows:=0;
 for setcount:=welcomeset to lastfixedset do
  initfixed(setcount);
 initiof(iofi);
 initiof(iofo);
 initiof(ioff);
 initkeysets;
 initmemory;
 haltmessage:='';
 haltaction:='';
 haltcondition:=''
end; {procedure inittables}

procedure condactheads;
var condactheader: string;
begin
 with ElizaForm do
  begin
   if condused and not(MenuAnalysisShowConds.Checked) then
    condactheader:='Cond/Act'
   else
    condactheader:='Action';
   MemoryGrid.Col[3].Heading:=condactheader;
   WelcomeGrid.Col[3].Heading:=condactheader;
   QuitGrid.Col[3].Heading:=condactheader;
   ExitGrid.Col[3].Heading:=condactheader;
   VoidGrid.Col[3].Heading:=condactheader;
   NoKeywordGrid.Col[3].Heading:=condactheader;
   KeywordGrid.Col[5].Heading:=condactheader;
   InputGrid.Col[4].Heading:=condactheader;
   OutputGrid.Col[4].Heading:=condactheader;
   FinalGrid.Col[4].Heading:=condactheader;
  end
end; {procedure condactheads}

procedure initgrids;

 procedure setupgrid(thisgrid: TtsGrid;tocentre: integer;col1head,col2head,col3head,col4head,col5head: string);
 begin
  with thisgrid do
   begin
    Col[1].Alignment:=taCenter;
    Col[1].Heading:=col1head;
    if col2head<>'' then
     Col[2].Heading:=col2head;
    if col3head<>'' then
     Col[3].Heading:=col3head;
    if col4head<>'' then
     Col[4].Heading:=col4head;
    if col5head<>'' then
     Col[5].Heading:=col5head;
    if tocentre<>0 then
     Col[tocentre].Alignment:=taCenter;
    Rows:=0
   end
 end;

begin {procedure initgrids}
 with ElizaForm do
  begin
   setupgrid(TraceGrid,2,'Step','Match','Processing Type','Processing Details and Results','');
   TraceGrid.Col[4].HeadingHorzAlignment:=htaLeft;
   setupgrid(WelcomeGrid,3,'Index','Welcome Message','Action','','');
   setupgrid(QuitGrid,3,'Index','Quitting Message','Action','','');
   setupgrid(ExitGrid,3,'Index','Exit (Prevention) Message','Action','','');
   setupgrid(VoidGrid,3,'Index','Response to Void Input','Action','','');
   setupgrid(NoKeywordGrid,3,'Index','No-Keyword Response','Action','','');
   setupgrid(InputGrid,4,'Index','Input Transformation Pattern','Replacement','Action','');
   setupgrid(KeywordGrid,5,'Set Index','Type','Index','Pattern','Action');
   setupgrid(OutputGrid,4,'Index','Output Transformation Pattern','Replacement','Action','');
   setupgrid(FinalGrid,4,'Index','Final Transformation Pattern','Replacement','Action','');
   setupgrid(MemoryGrid,3,'Index','Memorised Phrase','Action','','')
  end
end; {procedure initgrids}

procedure updatefixed(fixedset: integer);
var fixedgrid: TtsGrid;
    labelstr: string;
    i: integer;
begin
 with ElizaForm do
  case fixedset of
   welcomeset: begin fixedgrid:=WelcomeGrid;labelstr:='Welcome Message' end;
   voidset:    begin fixedgrid:=VoidGrid;labelstr:='Response to Void Input' end;
   nokeyset:   begin fixedgrid:=NoKeywordGrid;labelstr:='No-Keyword Response' end;
   quitset:    begin fixedgrid:=QuitGrid;labelstr:='Quitting Message' end;
   exitset:    begin fixedgrid:=ExitGrid;labelstr:='Exit (Prevention) Message' end
  end;
 with fixedsetarray[fixedset] do
  with fixedgrid do
   begin
    if sequential then
     Col[2].Heading:=labelstr+'  [sequential]'
    else
     Col[2].Heading:=labelstr+'  [randomised]';
    Rows:=numresponses;
    for i:=1 to numresponses do
     with fixedresps[i] do
      begin
       gridindex:=i;
       if selfdel then
        Cell[1,i]:=index+'\'
       else
        Cell[1,i]:=index;
       if ElizaForm.MenuAnalysisShowConds.Checked then
        begin
         Cell[2,i]:=condstr+'  :  '+msgstring;
         if (actstr='') then
          Cell[3,i]:=''
         else
          Cell[3,i]:='[Click]'
        end
       else
        begin
         Cell[2,i]:='  '+msgstring;
         if (condstr='') and (actstr='') then
          Cell[3,i]:=''
         else
          Cell[3,i]:='[Click]'
        end
      end
   end
end;

procedure updateiof(iof: Tiof);
var ioset: ^Tioset;
    iogrid: TtsGrid;
    i: integer;
    patstring: string;
begin
 with ElizaForm do
  case iof of
   iofi: begin
          ioset:=@inputtrans;
          iogrid:=InputGrid
         end;
   iofo: begin
          ioset:=@outputtrans;
          iogrid:=OutputGrid
         end;
   ioff: begin
          ioset:=@finaltrans;
          iogrid:=FinalGrid
         end
  end;
 with ioset^ do
  with iogrid do
   begin
    Rows:=numtransforms;
    for i:=1 to numtransforms do
     with transforms[i] do
      begin
       gridindex:=i;
       if selfdel then
        Cell[1,i]:=index+'\'
       else
        Cell[1,i]:=index;
       if ElizaForm.MenuAnalysisShowHidden.Checked then
        begin
         patstring:=pattern;
         Cell[3,i]:='  '+replace
        end
       else
        begin
         patstring:=fixendpattern(pattern,true);
         Cell[3,i]:='  '+fixendpattern(replace,false)
        end;
       if ElizaForm.MenuAnalysisShowConds.Checked then
        begin
         Cell[2,i]:=condstr+'  :  '+patstring;
         if (actstr='') then
          Cell[4,i]:=''
         else
          Cell[4,i]:='[Click]'
        end
       else
        begin
         Cell[2,i]:='  '+patstring;
         if (condstr='') and (actstr='') then
          Cell[4,i]:=''
         else
          Cell[4,i]:='[Click]'
        end
      end
   end
end;

procedure updatekeywords;
var setcount,krcount: integer;
    patstring: string;
    laststr: string;

 function seqchar(seq: boolean): string; {was previously char}
 begin
  if seq then
   result:=''
  else
   result:='? '
 end;

begin
 with ElizaForm.KeywordGrid do
  begin
   Rows:=0;
   for setcount:=1 to numkeysets do
    with keyarray[setcount] do
     begin
      Rows:=Rows+1;
      if index=lastkeyset then
       Cell[1,Rows]:=index+' '+seqchar(sequential)+'*'
      else
       Cell[1,Rows]:=index+' '+seqchar(sequential);
      for krcount:=1 to numkeys do
       with keywords[krcount] do
        begin
         if krcount>1 then
          Rows:=Rows+1;
         gridindex:=Rows;
         Cell[2,Rows]:='Keyword';
         if selfdel then
          Cell[3,Rows]:=index+'\'
         else
          Cell[3,Rows]:=index;
         if ElizaForm.MenuAnalysisShowHidden.Checked then
          patstring:=keystring
         else
          patstring:=fixendpattern(keystring,true);
         if ElizaForm.MenuAnalysisShowConds.Checked then
          begin
           Cell[4,Rows]:=condstr+'  :  '+patstring;
           if (actstr='') then
            Cell[5,Rows]:=''
           else
            Cell[5,Rows]:='[Click]'
          end
         else
          begin
           Cell[4,Rows]:='  '+patstring;
           if (condstr='') and (actstr='') then
            Cell[5,Rows]:=''
           else
            Cell[5,Rows]:='[Click]'
          end
        end;
      for krcount:=1 to numresp do
       with keyresps[krcount] do
        begin
         Rows:=Rows+1;
         gridindex:=Rows;
         Cell[2,Rows]:='Response';
         if index=lastresp then
          laststr:=' *'
         else
          laststr:='';
         if selfdel then
          Cell[3,Rows]:='     '+index+'\'+laststr
         else
          Cell[3,Rows]:='     '+index+laststr;
         if ElizaForm.MenuAnalysisShowHidden.Checked then
          patstring:=keystring
         else
          patstring:=fixendpattern(keystring,false);
         if ElizaForm.MenuAnalysisShowConds.Checked then
          begin
           Cell[4,Rows]:=condstr+'  :  '+patstring;
           if (actstr='') then
            Cell[5,Rows]:=''
           else
            Cell[5,Rows]:='[Click]'
          end
         else
          begin
           Cell[4,Rows]:='  '+patstring;
           if (condstr='') and (actstr='') then
            Cell[5,Rows]:=''
           else
            Cell[5,Rows]:='[Click]'
          end
        end
     end {with keyarray[setcount]}
  end
end;

procedure updatememory;
var i: integer;
begin
 with ElizaForm.MemoryGrid do
  begin
   Rows:=nummemory;
   for i:=1 to nummemory do
    with memoryarray[i] do
     begin
      gridindex:=i;
      Cell[1,i]:=index;

      if ElizaForm.MenuAnalysisShowConds.Checked then
       begin
        Cell[2,i]:=condstr+'  :  '+phrase;
        if (actstr='') then
         Cell[3,i]:=''
        else
         Cell[3,i]:='[Click]'
       end
      else
       begin
        Cell[2,i]:='  '+phrase;
        if (condstr='') and (actstr='') then
         Cell[3,i]:=''
        else
         Cell[3,i]:='[Click]'
       end
     end
  end
end;

procedure updategrids;
var countfixed: integer;
begin
 for countfixed:=1 to lastfixedset do
  updatefixed(countfixed);
 updateiof(iofi);
 updateiof(iofo);
 updateiof(ioff);
 updatekeywords;
 updatememory
end;

end.
