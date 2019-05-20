clc #Limpia todo el texto de la ventana de comando
clear all #Limpia todas las variables antes de entrar al programa.

#Se le pide al usuario que ingrese el grado del polinomio intepolador que generar� el programa
# de acuerdo al n�mero de nodos que �ste entrar�.
ok = false;
while (~ok)
  try
    n=input('Ingrese el grado n del polinomio que generar� �ste programa ');#La variable 'n' representa el grado del polinomio.
    ok = true;
  catch
    printf("Por favor, ingrese un numero v�lido.\n\n");#Esta funci�n try-catch es para que el usuario solo pueda ingresar n�meros, ya que n es una variable num�rica. Esta funci�n se ve frecuentemente en este c�digo.
  end_try_catch
endwhile



disp(['Usted ingres� el n�mero ',num2str(n),' por lo que deber� ingresar ',num2str(n+1),' nodos.'])#Esto le indica al usuario que debe ingresar n+1 nodos.

ok2 = false; #Esta variable sirve para que el usuario solo ingrese los n+1 elementos x necesarios para los n+1 nodos, ya que si ingresa otro numero no corresponder�a al n�mero de nodos que �ste quiso ingresar.
while ~ok2
   x = [];
   indice = '';
   xIN = input('Por favor ingrese los elementos x de todos los nodos. ','s');
   expression = '[-0123456789.]+';
   indice= regexp(xIN,expression);
   for i=1:length(indice)#Este for asigna los n�meros presentes en el string ingresados por el usuario para luego pasarlos a un arreglo num�rico.
     if i < length(indice)
        x(i) = str2num(xIN(indice(i):indice(i+1)-2));
     else
        x(i) = str2num(xIN(indice(i):length(xIN)));
     endif   
   endfor
   if length(x) ~= n+1#Se confirma que se ingresaron n+1 n�meros por lo explicado arriba.
     disp(['Debes ingresar ',num2str(n+1),' elementos. Por favor vuelvelo a intentar.']);
   else
      for u=1:n #Estos ciclos se usan para confirmar que no se ingrese el mismo n�mero m�s de una vez en el arreglo de x, ya que se supone que los nodos corresponden a una funci�n.
        for t=u+1:n+1
          if x(u) == x(t)
            disp(['No puedes ingresar el mismo valor m�s de una vez. Intentalo de nuevo']);
            break;
          endif  
        endfor 
        if t ~= n+1 || x(u) == x(t)
           break;
        endif  
      endfor
      if u == n && x(u) ~= x(t)
        ok2 = true;
      endif        
   endif   
endwhile

#Aqu� abajo se hace b�sicamente lo mismo para ingresar las coordenadas y de los nodos.
ok2 = false;
while ~ok2
   y = []; 
   indice2 = '';  
   yIN = input('Por favor ingrese los elementos y de todos los nodos. ','s');
   indice2= regexp(yIN,expression);
   for i=1:length(indice2)
        if i < length(indice2)
           y(i) = str2num(yIN(indice2(i):indice2(i+1)-2));
        else
           y(i) = str2num(yIN(indice2(i):length(yIN)));
        endif   
   endfor
   if length(y) ~= n+1
     disp(['Debes ingresar ',num2str(n+1),' elementos. Por favor vuelvelo a intentar.']);
   else
      ok2 = true;
   endif   
endwhile   

#Ciclo para mostrar los nodos ingresados por el usuario.
for j=0:n
  disp(['Nodo #',num2str(j+1),': ',num2str(x(j+1)),',',num2str(y(j+1))]);
endfor

#Estos strings son para que se muestre como es la funci�n de interpolaci�n de Lagrange.
str2 = '';
strLNK = '';
strStart = 'La funci�n de interpolaci�n de Lagrange es: P(x)=';

#Ciclos para crear el string que muestra como es la funci�n.
for w=0:n
   for v=0:n
      if w ~= v
         S = {strLNK,'(x-',num2str(x(v+1)),')/(',num2str(x(w+1)),'-',num2str(x(v+1)),')'};
         strLNK = strjoin(S);
      endif   
   endfor
   if w < n
      S = {str2,num2str(y(w+1)),'*',strLNK,'+'};
      str2 = strjoin(S);
      strLNK = '';
   else
      S = {str2,num2str(y(w+1)),'*',strLNK};
      str2 = strjoin(S); #Se van uniendo los t�rminos que se mostrar�n en la ventana de comandos.
      strLNK = '';
   endif   
endfor

S = {strStart,str2};
str2 = strjoin(S);
disp([str2]); #Se muestra la funci�n de interpolaci�n como un string.

#Ciclos para crear la funci�n que se graficar�
xF=min(x):(max(x)-min(x))/20:max(x);
f=0;
for a=0:n
  fLNK = 1;
  for b=0:n
    if a~=b
      fLNK = fLNK .* (xF - x(b+1))/(x(a+1)-x(b+1));  
    endif  
  endfor
  f = f + y(a+1) * fLNK;
endfor  

#Intrucci�n para graficar la funci�n de interpolaci�n lineal (f).
plot(xF,f); title('Gr�fica polinomio de interpolaci�n lineal.');

#Aqu� se le pide al usuario que ingrese el n�mero que desea aproximar
disp(['Qu� valor desea aproximar? ']);
ok = false;
while (~ok)
     try
         ValorDeInterpolacion = input('');
         ok = true;
      catch
         printf("Por favor, ingrese un numero v�lido.\n\n");
      end_try_catch   
endwhile
   

Resultadofuncion = 0;
ResultadoLNK = 0;

#El ciclo(for) exterior sirve para hacer la sumatoria del polinomio interpolador.
for k=0:n
   Numerador = 1;
   Denominador = 1;
   #Este ciclo(for) interior sirve para hacer todas las multiplicaciones que va a tener cada t�rmino del polinomio interpolador.
   for l=0:n
      if l ~= k   
         Numerador = Numerador * (ValorDeInterpolacion - x(l+1));
         Denominador = Denominador * (x(k+1) - x(l+1));
      endif 
   endfor
   ResultadoLNK = Numerador/Denominador;#La variable ResultadoLNK representa el LNK que multiplica al valor de la funci�n en cada uno de los nodos ingresados.   
   Resultadofuncion += y(k+1)* ResultadoLNK; 
endfor

#Instrucci�n que muestra la funci�n aproximada al punto que ingres� el usuario.
disp(['La funci�n en el punto ', num2str(ValorDeInterpolacion),' es aproximadamente ',num2str(Resultadofuncion)]);