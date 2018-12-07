program gravity;
uses crt,graph;
type play=record
x,y:integer;
end;
type block=record
x,y,tipo:integer;
end;
{*
tipo 1: normal/suelo
tipo 2: agua
tipo 3: ganar
*}
var
gd,gm:integer; continuar:boolean; comando:char; gravedad:integer;
player:play; escenario:array[1..100] of block; contar:integer;
win:boolean; winBlock:integer; score:integer;

function detectarColision:boolean;
var bloques:integer; colision:boolean;
begin
colision:=false;
for bloques:=1 to 100 do
    begin
     if(player.y=escenario[bloques].y-10)AND((player.x>=escenario[bloques].x)AND(player.x<=escenario[bloques].x+20))then
       begin
         colision:=true;
         if(escenario[bloques].tipo=3)then
            begin
             win:=true;
            end;
       end;
     if(player.y=escenario[bloques].y-10)AND((player.x+10>=escenario[bloques].x)AND(player.x+10<=escenario[bloques].x+20))then
       begin
         colision:=true;
         if(escenario[bloques].tipo=3)then
            begin
             win:=true;
            end;
       end;
    end;
detectarColision:=colision;
end;

procedure gravedadPlayer;
var colision:boolean;
begin
colision:=detectarColision;
    if contar>0 then
      begin
         contar:=contar-1; player.y:=player.y-gravedad;
      end;
if(contar=0)and(not(colision)) then player.y:=player.y+gravedad;
end;

procedure printPlayer;
begin
{*Actualizacion del player*}
setFillStyle(1,0);
bar(player.x,player.y,player.x+10,player.y+10);
gravedadPlayer;
{*Print del player*}
setFillStyle(1,7);
bar(player.x,player.y,player.x+10,player.y+10);
end;

procedure generarEscenario;
var aux:integer;
begin
player.x:=130; player.y:=400;
escenario[1].x:=130; escenario[1].y:=460;
for aux:=2 to 100 do
begin
escenario[aux].x:=random(32)*20;
escenario[aux].y:=(random(44)*10)+20;
escenario[aux].tipo:=1;
end;
escenario[100].x:=340;
escenario[100].y:=40;
escenario[winBlock].tipo:=3;
end;


procedure printBlocks;
var bloques:integer;
begin
setFillStyle(1,14);
if(win)then
   begin

   winBlock:=random(98)+2;
   cleardevice; generarEscenario;
   score:=score+100;
{*   if gravedad+1<11 then gravedad:=gravedad+1;*}
   win:=false;

   end;
for bloques:=1 to 100 do
    begin
        if(escenario[bloques].tipo=1)then setFillStyle(1,14);
        if(escenario[bloques].tipo=3)then setFillStyle(1,3);
        bar(escenario[bloques].x,escenario[bloques].y,escenario[bloques].x+20,escenario[bloques].y+10);
    end;
end;

procedure printScore;
var scoreStr:string;
begin
str(score,scoreStr);
outTextXY(0,0,'Score: '+scoreStr);
end;

procedure readComando(comando:char);
var colision:boolean;
begin
if(comando='S')or(comando=chr(32)) then continuar:=false;
setFillStyle(1,0); bar(player.x,player.y,player.x+10,player.y+10);
colision:=detectarColision;
if not(win)then
   begin
if (comando='W')and(colision) then contar:=40;
if comando='D' then player.x:=player.x+5;
if comando='A' then player.x:=player.x-5;
   end;
end;

begin
gd:=detect;
InitGraph(gd,gm,'c:/tp/bgi');
if graphResult<>grOk then
begin
textmode(co80); textcolor(14); textbackground(0); clrscr;
gotoxy(5,5); write('Tu PC no soporta modo grafico'); readkey;
halt(1);
end;
setColor(7); setBkColor(0); cleardevice;
setTextStyle(2,0,2);
outtextxy(0,0,'Presiona_una_tecla_para_continar');
outTextXY(0,15,'El objetivo es sencillo, saltar hasta el punto azul...');
outTextXy(0,30,'W para saltar');
outTextXy(0,45,'S/Space para salir');
outTextXy(0,60,'A/D para moverte');
setFillStyle(1,3);
bar(550,20,570,30);
readkey;
winBlock:=100; cleardevice; score:=0;
continuar:=true; gravedad:=1; win:=false;

generarEscenario;

while(continuar)do
begin
if (keypressed) then
   begin
   comando:=upcase(readkey);
   readComando(comando);
   end;
printPlayer; printBlocks; printScore; delay(20);
end;
clearDevice;
outTextXY(50,50,'Gracias_por_jugar'); readkey;

end.




