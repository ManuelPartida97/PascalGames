program arcanoid;
uses crt,graph;
type bloque = record
x,y,status,tipo:integer;
end;
var
blocksNumber,finalScore:integer; score:integer; dificultad:integer;
playerx,playery,dirpx,dirpy,anchoPaleta,speedPaleta:integer;
pelotax,pelotay,dirx,diry,contador,speed,colorBall:integer;
blocks:array[1..80] of bloque;
continuar:boolean; comando:char; over,win:boolean;
(*Procedimiento para iniciar pantalla modo grafico*)
procedure startGraph(color,back:integer);
var gd,gm:integer;
begin
gd:=DETECT;
InitGraph(gd,gm,'c:/tp/bgi');
if graphResult<>grOk then
   begin
    textmode(co80); textcolor(4); textbackground(0); clrscr;
    gotoxy(30,10); write('Tu computadora no soporta modo grafico...');
    halt(0);
   end;
setColor(color); setBkColor(back); cleardevice;
end;
(*Procedimiento para comandos jugador*)
procedure readComando(comando:char);
begin
  if over then
  begin
    if comando='D' then playerx:=playerx+speedPaleta;
    if comando='A' then playerx:=playerx-speedPaleta;
  end;
  if comando=chr(27) then continuar:=false;
end;
(*Procedimiento para calcular la direccion de rebote de la pelota*)
procedure checkLado(aux:integer);
begin
if(pelotax+5=blocks[aux].x+100)then  dirx:=5;
if(pelotax+5=blocks[aux].x)then  dirx:=-5;
 if(diry=5)AND(pelotay+5=blocks[aux].y)then
    begin
      diry:=-5;
    end
  else
   begin
      if(diry=-5)AND(pelotay+5=blocks[aux].y+20)then diry:=5;
   end;
end;
(*Procedimiento para detectar la colision con bloques*)
procedure blockColision;
var aux:integer;
begin
for aux:=1 to blocksNumber do
  begin
  if(blocks[aux].status=1)AND(pelotax+5>=blocks[aux].x)AND(pelotay+5>=blocks[aux].y)then
  if(pelotax+5<=blocks[aux].x+100)AND(pelotay+5<=blocks[aux].y+20) then
    begin
      checkLado(aux);
  if(blocks[aux].tipo=1)then
  begin
      colorBall:=3; score:=score+100;
  end;
  if(blocks[aux].tipo=0)then
  begin
   colorBall:=7; score:=score+50;
  end;
  if(blocks[aux].tipo=2)then
  begin
  colorBall:=6; score:=score+150;
  end;
      setColor(0); setFillStyle(1,0);
      bar(blocks[aux].x,blocks[aux].y,blocks[aux].x+100,blocks[aux].y+15);
      setColor(7); setFillStyle(1,7);
      blocks[aux].status:=0;
    end;
  end;
end;
(*Procedimiento para detectar el lado de la colision en la paleta*)
procedure playerColision;
begin
if(pelotax+5>=playerx+(anchoPaleta/2))then dirx:=speed;
if(pelotax+5<=playerx+(anchoPaleta/2))then dirx:=-speed;
end;
(*Procedimiento para actualizar pelota*)
procedure pelota;
begin
     if score>=finalScore then
     begin
      setbkcolor(1); win:=false;
     end;
 if(pelotax+dirx>=640) then dirx:=-speed;
 if(pelotay+diry<=20) then
   begin
      diry:=speed;
      if not((dificultad-1)<1) then
         begin
          dificultad:=dificultad-1; speedPaleta:=speedPaleta+10;
          anchoPaleta:=anchoPaleta+10;
          speedPaleta:=speedPaleta+3;
         end;
   end;
 if(pelotax+dirx<=0) then dirx:=speed;
 if(pelotay+diry>=480) then
   begin
      setbkcolor(4); over:=false;
      diry:=-speed;
   end;
 if(pelotay+5>=playery)AND(pelotax+5>=playerx)AND(pelotay+5<=playery+10)AND(pelotax+5<=playerx+anchoPaleta) then
 begin
 playerColision;
 diry:=-speed;
 end;
 blockColision;
 if contador=dificultad then
 begin
  pelotax:=pelotax+dirx;
  pelotay:=pelotay+diry;
  contador:=0;
 end;
 contador:=contador+1;
end;
(*Procedimiento para imprimir los bloques*)
procedure printBlocks;
var aux,color:integer;
begin
for aux:=1 to blocksNumber do
  begin
  if(blocks[aux].tipo=1)then color:=3;
  if(blocks[aux].tipo=0)then color:=7;
  if(blocks[aux].tipo=2)then color:=6;
  if(blocks[aux].tipo=7)then color:=4;
  if(blocks[aux].status=1) then
    begin
      setcolor(color); rectangle(blocks[aux].x,blocks[aux].y,blocks[aux].x+100,blocks[aux].y+15);
    end;
  end;
end;
(*Procedimiento render*)
procedure render;
var scoreStr:string;
begin
printBlocks;
setFillStyle(1,0); setColor(0); bar(0,playery,640,playery+20);
setFillStyle(1,7); setColor(7); rectangle(playerx,playery,playerx+anchoPaleta,playery+10);
setFillStyle(1,0); setColor(0); fillEllipse(pelotax-dirx,pelotay-diry,5,5);
setFillStyle(1,colorBall); setColor(colorBall); fillEllipse(pelotax,pelotay,5,5);
if not(over) then
begin
   setColor(7);
   outTextXY(220,240,'Game_Over_Press_Esc');
end;
if not(win) then
begin
setcolor(7);
outTextXY(220,240,'Has_Ganado_Presiona_una_tecla');
readkey;
continuar:=false;
end;
setFillStyle(1,0); setColor(0); bar(0,0,640,20);
setFillStyle(1,7); setColor(7); str(score,scoreStr);
outTextXY(5,5,'Score: '+scoreStr);
end;
(*Procedimiento para colocar los bloques por filas*)
procedure setBlocksFile;
var columna,aux:integer;
begin
   for aux:=1 to 5 do
begin
blocks[aux].y:=50; blocks[aux].x:=(aux*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=2; finalScore:=finalScore+150;
end;
   for aux:=6 to 10 do
begin
blocks[aux].y:=50+(20); blocks[aux].x:=((aux-5)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=2; finalScore:=finalScore+150;
end;
   for aux:=11 to 15 do
begin
blocks[aux].y:=50+(20*2); blocks[aux].x:=((aux-10)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=1; finalScore:=finalScore+100;
end;
   for aux:=16 to 20 do
begin
blocks[aux].y:=50+(20*3); blocks[aux].x:=((aux-15)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=1; finalScore:=finalScore+100;
end;
    for aux:=21 to 25 do
begin
blocks[aux].y:=50+(20*4); blocks[aux].x:=((aux-20)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=1; finalScore:=finalScore+100;
end;
   for aux:=26 to 30 do
begin
blocks[aux].y:=50+(20*5); blocks[aux].x:=((aux-25)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=1; finalScore:=finalScore+100;
end;
   for aux:=31 to 35 do
begin
blocks[aux].y:=50+(20*6); blocks[aux].x:=((aux-30)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; finalScore:=finalScore+50;
end;
   for aux:=36 to 40 do
begin
blocks[aux].y:=50+(20*7); blocks[aux].x:=((aux-35)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; finalScore:=finalScore+50;
end;
   for aux:=41 to 45 do
begin
blocks[aux].y:=50+(20*8); blocks[aux].x:=((aux-40)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; finalScore:=finalScore+50;
end;
    for aux:=46 to 50 do
begin
blocks[aux].y:=50+(20*9); blocks[aux].x:=((aux-45)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=51 to 55 do
begin
blocks[aux].y:=50+(20*10); blocks[aux].x:=((aux-50)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=56 to 60 do
begin
blocks[aux].y:=50+(20*11); blocks[aux].x:=((aux-55)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=61 to 65 do
begin
blocks[aux].y:=50+(20*12); blocks[aux].x:=((aux-60)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=66 to 70 do
begin
blocks[aux].y:=50+(20*13); blocks[aux].x:=((aux-65)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=71 to 75 do
begin
blocks[aux].y:=50+(20*14); blocks[aux].x:=((aux-70)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;
    for aux:=76 to 80 do
begin
blocks[aux].y:=50+(20*15); blocks[aux].x:=((aux-75)*105)-50; blocks[aux].status:=1;
blocks[aux].tipo:=0; colorBall:=7; finalScore:=finalScore+50;
end;

end;

(*Bloque de inicio*)
begin
startGraph(7,0);
blocksNumber:=80; setTextStyle(2,0,2); score:=0;
finalScore:=0; setBlocksFile;
speed:=5;
playerx:=200; playery:=460; dirx:=speed; diry:=speed; anchoPaleta:=120; over:=true;
pelotax:=250; pelotay:=450; continuar:=true; contador:=0;
outTextXY(5,5,'Presiona_una_tecla_para_iniciar_juego'); speedPaleta:=10;
dificultad:=5; win:=true; readkey;
cleardevice;
   while continuar do
      begin
       if keypressed then
         begin
          comando:=upCase(readkey);
          readComando(comando);
         end;
       pelota; render;
       delay(10);
      end;
end.
