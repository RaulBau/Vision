##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
# Entradas:
# x: Coordenada X
# y: Coordenada Y
# xTam: Tamano en X
# yTam: Tamano en Y
# numVideo: Numero de video
# numFrame: Numero de frame
# nombre: Nombre del frame
# numFiltro: Numero de filtro
#
# Salidas: Ninguna
# Genera y guarda una mascara segun las corrdenadas que le llegan por parametro
##

#Cargamos los paquetes
pkg load image;
pkg load video;

function generaMascara(x, y, xTam, yTam, numVideo, numFrame, nombre, numFiltro)
  #Paso alto estricto laplaciano
  h=[-1 -1 -1;
  -1 8 -1;
  -1 -1 -1;];
  #laplacian
  h2=fspecial("average");
  ##Se obtiene la información del video
  info=aviinfo(cstrcat ("Videos/", numVideo, ".avi"));
  ##Obtenemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),numFrame));
  ##Modificamos el contraste
  frm .*= -1.6;
  ##Modificamos el brillo
  frm .+= 1.2;
  ##Recortamos la imagen
  printf("%d,%d,%d,%d,\n",x,y,xTam,yTam);
  imFiltro=imcrop(frm,[x,y,xTam,yTam]);
  ##Calculamos el extra que se agrega a la imagen
  padX=floor((359-xTam)/2);
  padY=floor((359-yTam)/2);
  ##Rellenamos la imagen
  imH=padarray(imFiltro,[padY,padX]);
  imwrite(imH,cstrcat ("Filtros/", nombre, numFiltro,".PNG"));
endfunction
