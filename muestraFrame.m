##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
#
# numVideo: Número de video
# numFrame: Número de frame
##

#Cargamos los paquetes
pkg load image;
pkg load video;

function muestraFrame(numVideo, numFrame)
  ##Obtenemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),numFrame));
  ##Mostramos el frame
  imshow(frm);
endfunction
