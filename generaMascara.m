##
# Nombre: Bautista Robles Raúl
# Clave: 229563
# Fecha: 23/03/2021
#
# x: Coordenada X
# y: Coordenada Y
# xTam: Tamaño en X
# yTam: Tamaño en Y
# numVideo: Número de video
# numFrame: Número de frame
# nombre: Nombre del video
# numFiltro: Número de filtro
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
  ##Aplicamos el primer filtro
  frm=imfilter(frm, h);
  ##Aplicamos el segundo filtro
  frm=imfilter(frm, h2);
  ##Recortamos la imagen
  imFiltro=imcrop(frm,[x,y,xTam,yTam]);
  ##Calculamos el extra que se agrega a la imagen
  padX=floor((479-xTam)/2);
  padY=floor((479-yTam)/2);
  ##Rellenamos la imagen
  imH=padarray(imFiltro,[padY,padX]);
  imwrite(imH,cstrcat ("Filtros/", nombre, numFiltro,".PNG"));
endfunction
