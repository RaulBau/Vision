##
# Nombre: Bautista Robles Raúl
# Clave: 229563
# Fecha: 23/03/2021
##

##Se limpia la consola
clc;
clear;

#Cargamos los paquetes
pkg load image;
pkg load video;

h=[-1 -1 -1;
-1 8 -1;
-1 -1 -1;];#Paso alto estricto laplaciano
h2=fspecial("average");#laplacian

##Seleccionamos el número de video
numVideo="1";
##Se obtiene la información del video
info=aviinfo(cstrcat ("Videos/", numVideo, ".avi"));
##Se genera el nombre del video resultado
nombre = cstrcat ("res", numVideo, ".avi"); 
##Se crea el video resultado
vidRes = avifile(nombre, "codec", "msmpeg4v2");

mascara=ones(3);
mascara=mascara*-1;
mascara(2,2)=10;

##Filtros
ruta="Filtros/lata";
LK=0.4;
NImages=2;
H_Filtro=filtroC_LK(LK,ruta,NImages);
##FinFiltros

for iCont=1:info.NumFrames-120
  ##Obtenemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),iCont));
  ##Recortamos la imagen
  frm=imcrop(frm,[187,1, 479, 479]);
  ##Creamos un respaldo del frame
  frmRes=frm;
  ##Aplicamos el primer filtro
  frmRes=imfilter(frm, h);
  ##Aplicamos el segundo filtro
  frmRes=imfilter(frmRes, h2);
  
  ##Aplicamos el filtro
  O_Filtro=kLawSpaceV(LK,frmRes);
  resp=O_Filtro.*(conj(H_Filtro)./abs(H_Filtro));
  ##Creamos la correlación
  corl=real(ifftshift(ifft2(resp)));
  ##Obtenemos el valor máximo de la correlación
  maximo1=max(corl(:));
  [yy1,xx1]=find(maximo1==corl);
  corl2=imfilter(corl,mascara);
  maximo2=max(corl2(:));
  [yy2,xx2]=find(maximo2==corl2);
  ##Creamos un arreglo con los datos de la correlación
  vmax=reshape(corl,[],1);
  ##Ordenamos los datos
  vmax10=sort(vmax,'descend');

  ##  mesh(corl);
##  media=mean(corl);
##  media2=mean(corl2);
  ##Obtenemos la media
  media=mean(std(std(corl)));
  media2=mean(std(std(corl2)));
  printf("media: %f\n",media);
  
  ##Verificamos que el punto estï¿½ en el rango correcto
  if((yy1>=2&&yy1<=478)&&(xx1>=2&&xx1<=478))
    ##Marcamos el punto en el frame
    frm(yy1-2:yy1+2,xx1-2:xx1+2)=1;
  endif
##  if((yy2>=2&&yy2<=478)&&(xx2>=2&&xx2<=478))
##    ##Marcamos el punto en el frame
##    frm(yy2-2:yy2+2,xx2-2:xx2+2)=1;
##  endif
  ##Agregamos el frame al video
  addframe(vidRes, frm);
##  if(mod(iCont,50)==0)
##    imshow(frm);
##    sleep(1);
##  endif

##  clc;
  printf("%f,\t%d-%d\n",(iCont*100)/info.NumFrames, iCont,info.NumFrames);
  clear frm;
endfor

close(vidRes);
clear vidRes;
