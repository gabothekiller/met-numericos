clc;
clear all;
pkg load symbolic
warning('off','all');

syms x;

#Input de los usuarios

%Grado del polinomio
ok = false;
while (~ok)
  try
    n=input('Ingrese el grado n del polinomio que generara este programa: ');#La variable 'n' representa el grado del polinomio.
    ok = true;
  catch
    printf("Por favor, ingrese un numero v�lido.\n\n");#Esta funci�n try-catch es para que el usuario solo pueda ingresar n�meros, ya que n es una variable num�rica. Esta funci�n se ve frecuentemente en este c�digo.
  end_try_catch
endwhile


disp(['Usted ingres� el n�mero ',num2str(n),' por lo que deber� ingresar como minimo ',num2str(n+1),' datos.'])#Esto le indica al usuario que debe ingresar n+1 nodos.



ok = false;
while (~ok) 
	try 	
	puntos_size = input("Ingrese la cantidad de datos: ");
	if puntos_size >= n+1 
		ok = true;
	else
		disp(['Recuerde que usted ingres� el n�mero ',num2str(n),' por lo que deber� ingresar como minimo ',num2str(n+1)," datos.\n\n"])#Esto le indica al usuario que debe ingresar n+1 nodos.
	endif	
	catch
	printf("Por favor, ingrese un numero entero.\n\n");
	end_try_catch
endwhile

ok = false;
while !ok	
	try 
	h = input("Ingrese la distancia constante entre los datos: ");	
	if h > 0	
		ok = true;
	else 
			printf("Debe ingresar un numero positivo.\n\n");
	endif
	catch
	printf("Por favor, ingrese un numero real.\n\n");
	end_try_catch
endwhile


ok = false;
while !ok	
	try 
	valor_inicial = input("Ingrese el valor inicial: ");
	ok = true;
	catch
	printf("Por favor, ingrese un numero real.\n\n");
	end_try_catch
endwhile

#imprimiendo la matriz inicial
printf("%30s","\nTabla de valores de grados\n");
printf("%10s","puntos");
for	i=1 : puntos_size
	printf("%10d ",i-1);
endfor
printf("\n");
printf("%10s","");
for	i=1 : puntos_size
	valor = valor_inicial+(i-1)*h;
	printf("%10d ",valor);
endfor
printf("\n");
printf("%10s ","f()");
for	i=1 : puntos_size
	printf("%10s ","--");
endfor
printf("\n\n");
%%%%

#Ingresando los valores f()
ok = false;
while !ok
	try
		f_ = input("Ingrese los valores de f() correspondientes a cada punto:\n","s");
		f_ = cellfun("str2num",strsplit(f_," "));
		if size(f_)(2) == puntos_size
			ok = true;
		else
			printf("%s",strcat("Debe ingresar: ", num2str(puntos_size), " datos.\n\n"));
		endif
	catch
		printf("Debe ingresar numeros.\n\n");
	end_try_catch
endwhile

#imprimiendo la matriz inicial completa
printf("%30s","\nTabla de valores de grados\n");
printf("%10s","puntos");
for	i=1 : puntos_size
	printf("%10d ",i-1);
endfor
printf("\n");
printf("%10s","");
for	i=1 : puntos_size
	valor = valor_inicial+(i-1)*h;
	printf("%10d ",valor);
endfor
printf("\n");
printf("%10s ","f()");
for	i=1 : puntos_size
	printf("%10d ",f_(i));
endfor
printf("\n\n");
%%%

#Matriz de diferencias finitas hacia adelante
#Se a�aden los primeros valores
printf("Tabla de diferencias finitas hacia adelante \n");
for i=1 : puntos_size
	dif_fin(i,1) = i-1;
	dif_fin(i,2) = valor_inicial+(i-1)*h;;
endfor

#Se calculan los nuevos valores apartir de los ya conocidos
dif_fin = [dif_fin f_'];
for i=4 : puntos_size+3-1
	for j=i-3+1: puntos_size
		dif_fin(j,i) = dif_fin(j,i-1) - dif_fin(j-1,i-1);
 endfor
endfor

#Se imprime el titulo
printf("%15s %15s %15s","puntos","i","f(i)");
for i=1: puntos_size-1
	printf("%15s ",strcat("d^", num2str(i), " f(i)"));
endfor
printf("\n");
#Se imprime la matriz con todos los valores
for i=1: size(dif_fin)(1)
		for j=1: size(dif_fin)(2)
			printf("%15d ", dif_fin(i,j));
		endfor
		printf("\n");
endfor
printf("\n");

#Realizando una aproimacion inicial, puede ser etrapolada
ok = false;
while !ok
	try	
		apro = input("Ingrese el valor al cual le desea realizar la aproimacion: ");
		ok = true;
	catch
		printf("Debe ingresar un numero.\n\n");
	end_try_catch
endwhile

#Calculado el valor de s
s = (apro - dif_fin(1,2))/h;

printf("Al realizar la aproimacion con el polinomio de grado %d se tiene la aproimacion de:",n);
#Aproimacion con el polinomio pedido por el usuario
sum = 0;
fact = 1;
s_value = 1;
for i = 1 : n+1
	if i==1 
		sum = sum + dif_fin(i,i+2);
	else
		s_value = s_value * (s-(i-2));
		fact = fact * (i-1);	
		sum = sum + (s_value*dif_fin(i,i+2))/fact;
	endif
endfor
printf("%10f \n",sum);

#Viendo si se puede interpolar
puede_interpolar = 0;
for i=1 : puntos_size-1
	if dif_fin(i,2)<=apro && apro<=dif_fin(i+1,2)
		pos_interpolar = i;
		puede_interpolar = 1;
 endif
endfor

#Comprobando si es posible interpolar
if puede_interpolar==1
	printf("Es posible interpolar\n");
	
	#Se verifica si posible interpolar hasta el grado del usuario	
	grado_ma_interpolar = puntos_size - (pos_interpolar-1) - 1;
	if  grado_ma_interpolar < n 
			printf("Pero no es posible interpolar con un polinomio de grado %d asi que se interpolara hasta el grado mas grande posible %d \n",n,grado_ma_interpolar);
	endif	
	
  
	#Calculando el nuevo s
	s = (apro-dif_fin(pos_interpolar,2))/h;
	
	#Realizando la interpolacion
	sum = 0;
	fact = 1;
	s_value = 1;
	for i = 1 : n+1
		#Ajustando a la interpolacion
		i_inter = i + pos_interpolar-1;
		if i==1 
			sum = sum + dif_fin(i_inter,i+2);
		else
			s_value = s_value * (s-(i-2));
			fact = fact * (i-1);	
			sum = sum + (s_value*dif_fin(i_inter,i+2))/fact;
		endif
	endfor
	printf("La aproimacion por medio de interpolacion es de: %10f \n",sum);
  
  
  k(x) = (x-dif_fin(pos_interpolar,2))/h;
  
  sumk(x) = 0*x;
	fact = 1;
	s_value = 1;
  
  for i = 1 : n+1
		#Ajustando a la interpolacion
		i_inter = i + pos_interpolar-1;
		if i==1 
			sumk(x) = sumk(x) + dif_fin(i_inter,i+2);
		else
			s_value = s_value * (k(x)-(i-2));
			fact = fact * (i-1);	
			sumk(x) = sumk(x) + (s_value*dif_fin(i_inter,i+2))/fact;
		endif
	endfor
  
  printf("El polinomio interpolado es: \n");
  sumk
else
	printf("No es posible interpolar\n");
endif