##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
#
##

function [H1]=filtroC_LK(L_K, ruta, Nim)
  X = [];
  ##Se itera desde 1 hasta el n�mero de imagenes
  for i=1:Nim
    B=kLawSpace(L_K, [ruta,num2str(i),'.PNG'],0);
    ##Forma Vectorial de la imagen
    x=reshape(B',[],1);
    ##X Con todas las imagenes de entrenamiento
    X = [X x];
  endfor
  ##Se crea una matriz llena de 1
  vectorU = double(ones(Nim,1));
  H1 = makeSDFX(X,vectorU);
endfunction
