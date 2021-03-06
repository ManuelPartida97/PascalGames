program spaceInvaders;
uses crt;
type bala=record
   y,x:integer;
 end;
type player=record
   x,y:integer;
   bala:boolean;
 end;
type enemy=record
   x,y,vc:integer;
   isDead,wall,canDead:boolean;
   rebX,rebY:integer;
{----------------------------
tipos:
1 normal
2 especial
-----------------------------}
   tipo:integer;
 end;
type count=record
   c:array[3..20] of integer;
   der:boolean;
 end;
var
titleLevel:String;level:integer;score:integer;
tecla:char;
ply:player;continuar:boolean;disp:bala;
aux:integer;countLoop:count;
ene1,ene2,ene3,ene4,ene5,ene6,ene7,ene8,ene9,ene10,ene11,ene12,
ene13,ene14:enemy;
scr:array[1..25,1..40] of integer;posY,posX:integer;
bff:array[1..25,1..40] of integer;
enemies:array[3..20] of enemy;
{Variables de dificultad}
velocidadEne,yposEne:integer;

{--------------------I pdr pantallas Info--------------------}

procedure startGame;
 begin
   clrscr;
   textcolor(10);
   for aux:=5 to 27 do
   begin
     gotoxy(aux,3);write('+');
     gotoxy(aux,23);write('+');
   end;
   for aux:=3 to 23  do
   begin
     gotoxy(5,aux);write('+');
     gotoxy(27,aux);write('+');
   end;
   textcolor(11);
   gotoxy(12,5);write('Bienvenido');
   textcolor(14);
   gotoxy(13,6);write('CharWar');
   textcolor(11);
   gotoxy(6,22);write('-Por: Manuel Partida-');
   gotoxy(6,8);write('--Controles-jugador--');
   gotoxy(7,10);write('Tecla a: izquierda');
   gotoxy(7,11);write('Tecla b: derecha');
   gotoxy(7,12);write('Tecla m: disparar');
   gotoxy(7,13);write('Tecla p:');
   gotoxy(11,14);write('Terminar Juego');
   gotoxy(7,15);write('Tecla o:');
   gotoxy(11,16);write('Siguiente Nivel');
   gotoxy(7,17);write('Tecla h:');
   gotoxy(10,18);write('Ayuda/Invitacion');
   textcolor(14);
   gotoxy(7,20);write('Pulsa una tecla...');
   score:=0;readkey;
 end;

procedure helpScr;
  begin
  clrscr;
  textcolor(WHITE);
  writeln('Ayuda CharWar:');
  writeln('Esta es una pagina hecha para proveer   ');
  writeln('informacion sobre este juego "CharWar"  ');
  writeln('Tipos de enemigos:                      ');
  textcolor(9);
  writeln('# Enemigo normal1                       ');
  writeln('Se mueve horizontalmente dando 100      ');
  writeln('puntos/kill mas el bonus por nivel.     ');
  textcolor(10);
  writeln('# Enemigo normal2                       ');
  writeln('Se mueve horizontalmente dando 400      ');
  writeln('mas puntos/kill el bonus por nivel.     ');
  textcolor(11);
  writeln('# Enemigo especial/1                    ');
  writeln('Rebota por la pantalla no puede ser ani-');
  writeln('quilado hasta que no haya otro tipo de  ');
  writeln('enemigo vivo en pantalla.               ');
  textcolor(14);
  writeln('# Enemigo especial/2                    ');
  writeln('Transformacion especial1 dando 750      ');
  writeln('puntos/kill mas el bonus por nivel.     ');
  textcolor(WHITE);
  writeln('Controles: ');
  textcolor(11);
  writeln('Tecla a: derecha');
  writeln('Tecla b: izquierda');
  writeln('Tecla m: disparar');
  writeln('Tecla p: Terminar Juego');
  writeln('Tecla o: Siguiente Nivel(solo hasta l12)');
  writeln('Tecla h: Info Juego/Ayuda');
  textcolor(WHITE);
  writeln('(Espacio=salir/Enter=invitacion club)');tecla:=readkey;
  while not(tecla=chr(32))and not(tecla=chr(13)) do tecla:=readkey;
  if tecla=chr(13) then
   begin
     clrscr;
     textcolor(WHITE);
     writeln('       Objetivo de CharWar: ');writeln(' ');
     writeln('Un juego sencillo en pascal, solo');
     writeln('consigue puntaje disparando a chars,');
     writeln('Es una invitacion para entrar al club');
     writeln('de desarrollo de videojuegos que');
     writeln('seguramente se abrira el proximo');
     writeln('semestre(2014).');
     writeln('Este es una muestra de que el algoritmo');
     writeln('generico que se utiliza para crear');
     writeln('videojuegos es aplicable en cualquier');
     writeln('lenguaje, y por supuesto, con la');
     writeln('complejidad que uno desee, ya sea un');
     writeln('juego tan sencillo como este o un GTA4,');
     writeln('bueno, eso si estas decidido a gastar');
     writeln('de 36 a 60 meses de tu vida programando.');
     writeln('Gracias por jugar, de parte de Manny ;D');
     writeln('asi que..., ya estas invitado...');
     writeln('Te reto a llegar al nivel 20, y pasarme');
     writeln('una captura de pantalla ;D, imposible...');writeln(' ');
     writeln('  (Barra espaciadora para salir)');tecla:=readkey;
     while not(tecla=chr(32)) do tecla:=readkey;
     tecla:=chr(13);
   end
  else tecla:=chr(13);
  clrscr;
  end;
{--------------------T pdr pantallas Info--------------------}

{--------------------I pdr conf--------------------}
procedure startScr;
 begin
   for posY:=1 to 25 do
   begin
     for posX:=1 to 40 do
     begin
      scr[posY][posX]:=0;
      bff[posY][posX]:=0;
     end;
   end;
 end;

procedure cleanScr(val:integer);
 begin
   for posY:=1 to 25 do
   begin
     for posX:=1 to 40 do
     begin
      if scr[posY][posX]=val then scr[posY][posX]:=0;
     end;
   end;
 end;

procedure scrAct(xpos,ypos,val:integer);
{---------
0 Espacio vacio
1 Jugador
2 Bala
3 Enemigo No.1
4 Enemigo No.2
...
n Enemigo n
----------}
 begin
   scr[ypos][xpos]:=val;
 end;

procedure exitGame;
 begin
   continuar:=false;
   clrscr;
   textcolor(14);
   gotoxy(15,13);
   write('Gracias por jugar ;D');
   gotoxy(15,14);
   write('Tu score fue: ',score,' puntos');
   gotoxy(9,15);
   write('(Barra espaciadora para terminar)');
   while not(tecla=chr(32)) do tecla:=readkey;
   tecla:=chr(13);
 end;

procedure configEne;
 begin
   countLoop.c[3]:=0;
   countLoop.c[4]:=0;
   countLoop.c[5]:=0;
   countLoop.c[6]:=0;
   countLoop.c[7]:=0;
   countLoop.c[8]:=0;
   countLoop.c[9]:=0;
   countLoop.c[10]:=0;
   countLoop.c[11]:=0;
   countLoop.c[12]:=0;
   countLoop.c[13]:=0;
   countLoop.c[14]:=0;
   countLoop.c[15]:=0;
   countLoop.c[16]:=0;
   countLoop.der:=false;
   {--------Inicializacion de enemigos}
   {Enemigos normales Inicializacion}
   ene1.y:=yposEne;ene1.x:=4;enemies[3]:=ene1;
   ene2.y:=yposEne+1;ene2.x:=6;enemies[4]:=ene2;
   ene3.y:=yposEne;ene3.x:=8;enemies[5]:=ene3;
   ene4.y:=yposEne+1;ene4.x:=10;enemies[6]:=ene4;
   ene5.y:=yposEne;ene5.x:=12;enemies[7]:=ene5;
   ene6.y:=yposEne+1;ene6.x:=14;enemies[8]:=ene6;
   ene7.y:=yposEne;ene7.x:=16;enemies[9]:=ene7;
   ene8.y:=yposEne+1;ene8.x:=18;enemies[10]:=ene8;
   ene9.y:=yposEne;ene9.x:=20;enemies[11]:=ene9;
   ene10.y:=yposEne-1;ene10.x:=8;enemies[12]:=ene10;
   ene11.y:=yposEne-1;ene11.x:=16;enemies[13]:=ene11;
   {Enemigos especiales Inicializacion}
    ene12.rebX:=1;ene12.rebY:=1;
   ene12.y:=2;ene12.x:=3;enemies[14]:=ene12;
    ene13.rebX:=-1;ene13.rebY:=1;
   ene13.y:=7;ene13.x:=6;enemies[15]:=ene13;
    ene14.rebX:=1;ene14.rebY:=-1;
   ene14.y:=3;ene14.x:=9;enemies[16]:=ene14;
   {Enemigos normales1}
   for aux:=3 to 20 do
     begin
      if enemies[aux].y>=1 then
       begin
        enemies[aux].isDead:=false;
        enemies[aux].vc:=aux;
        enemies[aux].wall:=false;
        enemies[aux].canDead:=true;
        scrAct(enemies[aux].x,enemies[aux].y,aux);
        if aux<14 then
         begin
          enemies[aux].tipo:=1;
         end;
        if (aux>13) and (aux<17) then
         begin
          enemies[aux].canDead:=false;
          enemies[aux].tipo:=2;
         end;
       end;
     end;
   {--------Termina inicializacion de enemigos}
 end;

procedure config;
 begin
   textmode(CO40);textbackground(0);
   clrscr;
   if not(level>=1) then level:=0;
   yposEne:=16-level;
   if yposEne-1<3 then yposEne:=3;
   startScr;
   continuar:=true;
   ply.x:=2;
   ply.y:=23;
   scrAct(ply.x,ply.y,1);
   scrAct(ply.x+1,ply.y,1);
   scrAct(ply.x-1,ply.y,1);
   scrAct(ply.x,ply.y-1,1);
   ply.bala:=false;
   disp.y:=0;
   disp.x:=0;
   textcolor(14);
   gotoxy(5,13);
   write('Nivel ',level,': barra espaciadora para iniciar...');
   gotoxy(5,14);
   if level>1 then
   write('Tu score hasta level ',level,': ',score,' puntos');;
   while not(tecla=chr(32)) do tecla:=readkey;
   tecla:=chr(13);
   velocidadEne:=22-(level*2);
   clrscr;
 end;

procedure newLevel;
 begin
  for aux:=3 to 16 do
    begin
     enemies[aux].isDead:=false;
     if(enemies[aux].canDead=true)and(enemies[aux].tipo=2) then
     enemies[aux].canDead:=false;
    end;
  level:=level+1;
  config;configEne;
 end;

procedure gameOver;
 begin
   clrscr;
   textcolor(14);
   gotoxy(21,13);
   write('Game Over');
   gotoxy(15,14);
   write('Tu score fue: ',score,' puntos');
   gotoxy(9,15);
   write('(Barra espaciadora para terminar)');
   while not(tecla=chr(32)) do tecla:=readkey;
   tecla:=chr(13);
   level:=0;startGame;newLevel;
 end;
{--------------------T pdr conf--------------------}

{--------------------I pdr Score----------------------}
procedure addScore(tipoEne:integer);
  begin
    if (tipoEne>=3) and (tipoEne<=11) then
       begin
        score:=score+100+(level*10);
       end
      else if (tipoEne>11) and (tipoEne<=13) then
       begin
        score:=score+400+(level*10);
       end
      else if (tipoEne>13) and (tipoEne<=16) then
      begin
        score:=score+750+(level*10)
      end;
  end;

procedure printScore;
  begin
  textColor(WHITE);
    gotoxy(2,25);write('Score: ',score);
  end;
{--------------------I pdr Score----------------------}

{--------------------Loop principal--------------------}
procedure bffToScr(ypos,xpos:integer);
 begin
      bff[ypos][xpos]:=scr[ypos][xpos];
 end;

procedure loopPrincipal;
 var varX,varY:integer;
 begin
  for varY:=1 to 25 do
   begin
     for varX:=1 to 40 do
     begin
     if not(bff[varY][varX]=scr[varY][varX]) then
     begin
      bffToScr(varY,varX);
      if scr[varY][varX]=0 then
       begin
        gotoxy(varX,varY);write(' ');
       end
      else if scr[varY][varX]=1 then
       begin
        textcolor(8);
        gotoxy(varX,varY);write('@');
       end
      else if scr[varY][varX]=2 then
       begin
        textcolor(14);
        gotoxy(varX,varY);write('*');
       end
      else if (scr[varY][varX]>=3) and (scr[varY][varX]<=11) then
       begin
        textcolor(9);
        gotoxy(varX,varY);write('#');
       end
      else if (scr[varY][varX]>11) and (scr[varY][varX]<=13) then
       begin
        textcolor(10);
        gotoxy(varX,varY);write('#');
       end
      else if (scr[varY][varX]>13) and (scr[varY][varX]<=16) then
       begin
        if enemies[scr[varY][varX]].canDead=false then
        textcolor(11);
        if enemies[scr[varY][varX]].canDead=true then
        textcolor(14);
        gotoxy(varX,varY);write('#');
       end;
     end;
     end;
   end;
   printScore;
 end;

 procedure checkWin;
  var win:boolean;
  begin
   win:=true;
    for aux:=3 to 16 do
     begin
       if enemies[aux].isDead=false then win:=false;
     end;
    if win=true then newLevel;
  end;
{--------------------Termina loop principal--------------------}

{--------------------I pdr enmg--------------------}
{NOTA: esta seccion esta reservada para
los procedimientos de actualizacion de cada enemigo;}

procedure actEne;
  begin
   for aux:=20 downto 3 do
   begin
      if(enemies[aux].isDead=true)then
       begin
         cleanScr(enemies[aux].vc);
       end
      else
       begin
         if (enemies[aux].tipo=1) and (enemies[aux].y>=1) and (countLoop.c[aux]>=velocidadEne) then
          begin
            if enemies[aux].x+1>=39 then countLoop.der:=false;
             if enemies[aux].x-1<=1 then
              begin
               countLoop.der:=true;
               enemies[aux].wall:=true;
              end;
            if countLoop.der=true then
               begin
                enemies[aux].x:=enemies[aux].x+1;
                enemies[aux].wall:=false;
               end
            else if enemies[aux].wall=false then
               begin
                enemies[aux].x:=enemies[aux].x-1;
               end;
            cleanScr(enemies[aux].vc);
            scrAct(enemies[aux].x,enemies[aux].y,enemies[aux].vc);
            countLoop.c[aux]:=0;
           if enemies[aux].x-1<=1 then countLoop.der:=true;
           end
         else if (enemies[aux].tipo=2) and (enemies[aux].y>=1) and (countLoop.c[aux]>=velocidadEne) then
          begin
            if(scr[enemies[aux].y+1][enemies[aux].x+1]=1)
                   or(scr[enemies[aux].y+1][enemies[aux].x-1]=1) then gameOver;
            if enemies[aux].x+1>=39 then enemies[aux].rebX:=-1;
            if enemies[aux].x-1<=1 then enemies[aux].rebX:=1;
            if enemies[aux].y+1>=24 then enemies[aux].rebY:=-1;
            if enemies[aux].y-1<=1 then enemies[aux].rebY:=1;
            enemies[aux].x:=enemies[aux].x+enemies[aux].rebX;
            enemies[aux].y:=enemies[aux].y+enemies[aux].rebY;
            cleanScr(enemies[aux].vc);
            scrAct(enemies[aux].x,enemies[aux].y,enemies[aux].vc);
            countLoop.c[aux]:=0;
          end
         else
          begin
           countLoop.c[aux]:=countLoop.c[aux]+1;
          end;
       end;
   end;
   {debo colocar esto en algun lugar: "else if enemies[aux].tipo=2 then readkey;"}
  end;

procedure eneCanDead;
var dead:boolean;
 begin
 dead:=true;
 for aux:=3 to 12 do
  begin
    if enemies[aux].isDead=false then dead:=false;
  end;
 if dead=true then for aux:=13 to 16 do enemies[aux].canDead:=true;
 end;

{--------------------T pdr enmg--------------------}


{--------------------I pdr dsp--------------------}
procedure disparo;
 begin
 cleanScr(2);
 if ply.bala=true then
 begin
  if (disp.y<=1) then
  begin
   ply.bala:=false;
   end
  else
   if scr[disp.y-1][disp.x]>=3 then
    begin
     if enemies[scr[disp.y-1][disp.x]].canDead=true then
     begin
      enemies[scr[disp.y-1][disp.x]].isDead:=true;
      addScore(scr[disp.y-1][disp.x]);
     end;
     ply.bala:=false;
    end
   else
    begin
     disp.y:=disp.y-1;
     scrAct(disp.x,disp.y,2);
    end;
  end;
 end;
{--------------------T pdr dsp--------------------}

{--------------------I prd jdr--------------------}
procedure movPly;
 var varChar:char;
 begin
   if keypressed then
   begin
      varChar:=upcase(readkey);
      if (varChar='A') and not(ply.x<=2) then
      begin
        cleanScr(1);
        ply.x:=ply.x - 1;
        scrAct(ply.x,ply.y,1);
        scrAct(ply.x+1,ply.y,1);
        scrAct(ply.x-1,ply.y,1);
        scrAct(ply.x,ply.y-1,1);
      end;
      if (varChar='D') and not(ply.x>=39) then
      begin
       cleanScr(1);
        ply.x:=ply.x + 1;
        scrAct(ply.x,ply.y,1);
        scrAct(ply.x+1,ply.y,1);
        scrAct(ply.x-1,ply.y,1);
        scrAct(ply.x,ply.y-1,1);
      end;
      if (varChar='M') and not(ply.bala=true) then
         begin
            disp.x:=ply.x;
            disp.y:=ply.y-2;
            scrAct(disp.x,disp.y,2);
            ply.bala:=true;
         end;
      if (varChar='P') then exitGame;
      if (varChar='H') then helpScr;
      if varChar='O' then
       begin
       if (level<12) then
       begin
         for aux:=3 to 16 do
         begin
         enemies[aux].isDead:=true;
         scrAct(enemies[aux].x,enemies[aux].y,0);
         cleanScr(aux);
         end;
       end;
       end;
   end;
 end;

{--------------------T prd jdr--------------------}

begin

 startGame;newLevel;

 while continuar=true do
   begin
      movPly;
      disparo;
      actEne;
      loopPrincipal;
      delay(50);
      eneCanDead;checkWin;
   end;

end.
