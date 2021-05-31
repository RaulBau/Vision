##
# Nombre: Bautista Robles Raúl
# Clave: 229563
##

##Se limpia la consola
clc;
clear;

#Cargamos los paquetes
pkg load image;
pkg load video;

#Paso alto estricto laplaciano
h=[-1 -1 -1;
-1 8 -1;
-1 -1 -1;];
#Average
h2=fspecial("average");

##Seleccionamos el número de video
numVideo="2";
##Se obtiene la información del videos
info=aviinfo(cstrcat ("Videos/", numVideo, ".avi"));
##Se genera el nombre del video resultado
nombre = cstrcat ("res_fv2_", numVideo, ".avi"); 
##Se crea el video resultado
vidRes = avifile(nombre, "codec", "msmpeg4v2");

mascara=ones(3);
mascara=mascara*-1;
mascara(2,2)=10;

##Filtros
##Se guarda el total de filtros
totalFiltros=5;
##Se crea un arreglo con los filtros
filtros_arr(1:10) = struct();
ruta="Filtros/lata";
LK=0.4;
NImages=3;
H_Filtro=filtroC_LK(LK,ruta,NImages);
filtros_arr(1).ruta="Filtros/lata";
filtros_arr(1).nombre="lata";
filtros_arr(1).h_filtro=filtroC_LK(LK,filtros_arr(1).ruta,NImages);
filtros_arr(1).detectado=false;
filtros_arr(1).cambio=false;
filtros_arr(1).x=0;
filtros_arr(1).y=0;
filtros_arr(1).maximo=0;


rutaNesquik="Filtros/nesquik";
H_Filtro_Nesquik=filtroC_LK(LK,rutaNesquik,NImages);
filtros_arr(2).ruta="Filtros/nesquik";
filtros_arr(2).nombre="nesquik";
filtros_arr(2).h_filtro=filtroC_LK(LK,filtros_arr(2).ruta,NImages);
filtros_arr(2).detectado=false;
filtros_arr(2).cambio=false;
filtros_arr(2).x=0;
filtros_arr(2).y=0;
filtros_arr(2).maximo=0;


filtros_arr(3).ruta="Filtros/valentina";
filtros_arr(3).nombre="valentina";
filtros_arr(3).h_filtro=filtroC_LK(LK,filtros_arr(3).ruta,NImages);
filtros_arr(3).detectado=false;
filtros_arr(3).cambio=false;
filtros_arr(3).x=0;
filtros_arr(3).y=0;
filtros_arr(3).maximo=0;


filtros_arr(4).ruta="Filtros/herdez";
filtros_arr(4).nombre="herdez";
filtros_arr(4).h_filtro=filtroC_LK(LK,filtros_arr(4).ruta,NImages);
filtros_arr(4).detectado=false;
filtros_arr(4).cambio=false;
filtros_arr(4).x=0;
filtros_arr(4).y=0;
filtros_arr(4).maximo=0;


filtros_arr(5).ruta="Filtros/costena";
filtros_arr(5).nombre="costena";
filtros_arr(5).h_filtro=filtroC_LK(LK,filtros_arr(5).ruta,NImages);
filtros_arr(5).detectado=false;
filtros_arr(5).cambio=false;
filtros_arr(5).x=0;
filtros_arr(5).y=0;
filtros_arr(5).max=0;

##filtros_arr(5).ruta="Filtros/";
##filtros_arr(5).h_filtro=filtroC_LK(LK,filtros_arr(5).ruta,NImages);
##filtros_arr(5).detectado=false;
##filtros_arr(5).cambio=false;
##filtros_arr(5).x=0;
##filtros_arr(5).y=0;
##filtros_arr(5).max=0;
##FinFiltros


totalFrames=info.NumFrames-120;

##Creamos el arreglo de resultados del filtro P
arr_P=zeros(totalFrames, 16);
printf("Inicia procesamiento.\n");
for iCont=1:totalFrames
  ##Obtenemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),iCont));
  ##Recortamos la imagen
  frm=imcrop(frm,[187,1, 479, 479]);
  ##Creamos un respaldo del frame
  frmRes=frm;
  ##Aplicamos el primer filtro
  frmRes=imfilter(frm, h);
##  ##Aplicamos el segundo filtro
##  frmRes=imfilter(frmRes, h2);

  ##Aplicamos el filtro
  O_Filtro=kLawSpaceV(LK,frmRes);
  for iFiltro=1:totalFiltros
    ##filtros_arr(iFiltro).
    filtros_arr(iFiltro).resp=O_Filtro.*(conj(filtros_arr(iFiltro).h_filtro)./abs(filtros_arr(iFiltro).h_filtro));
    ##Creamos la correlación
    filtros_arr(iFiltro).corl=real(ifftshift(ifft2(filtros_arr(iFiltro).resp)));
    ##Obtenemos el valor máximo de la correlación
    filtros_arr(iFiltro).maximo=max(filtros_arr(iFiltro).corl(:));
    [filtros_arr(iFiltro).y,filtros_arr(iFiltro).x]=find(filtros_arr(iFiltro).maximo==filtros_arr(iFiltro).corl);
    
    if(filtros_arr(iFiltro).maximo >= 0.09 && filtros_arr(iFiltro).detectado== false)
      filtros_arr(iFiltro).detectado = true;
##      if(filtros_arr(iFiltro).detectado != filtros_arr(iFiltro).cambio)
        printf(cstrcat (filtros_arr(iFiltro).nombre, " detectado.", "\n"));
        filtros_arr(iFiltro).cambio = filtros_arr(iFiltro).detectado;
##      endif
    else
      filtros_arr(iFiltro).detectado=false;
##      if(filtros_arr(iFiltro).detectado!=filtros_arr(iFiltro).cambio)
##        printf(cstrcat ( "Ya no se detecta ", filtros_arr(iFiltro).nombre, "\n"));
##        filtros_arr(iFiltro).cambio=filtros_arr(iFiltro).detectado;
##      endif
    endif
  endfor
  
##  resp=O_Filtro.*(conj(H_Filtro)./abs(H_Filtro));
##  ##Creamos la correlación
##  corl=real(ifftshift(ifft2(resp)));
##  ##Obtenemos el valor máximo de la correlación
##  maximo1=max(corl(:));
##  [yy1,xx1]=find(maximo1==corl);
  
##  arr_P(iCont,1)=iCont;
##  arr_P(iCont,2)=xx1;
##  arr_P(iCont,3)=yy1;
##  arr_P(iCont,4)=maximo1;
  arr_P(iCont,  1)=iCont;
  arr_P(iCont,  2)=filtros_arr(1).x;
  arr_P(iCont,  3)=filtros_arr(1).y;
  arr_P(iCont,  4)=filtros_arr(1).maximo;
  arr_P(iCont,  5)=filtros_arr(2).x;
  arr_P(iCont,  6)=filtros_arr(2).y;
  arr_P(iCont,  7)=filtros_arr(2).maximo;
  arr_P(iCont,  8)=filtros_arr(3).x;
  arr_P(iCont,  9)=filtros_arr(3).y;
  arr_P(iCont, 10)=filtros_arr(3).maximo;
  arr_P(iCont, 11)=filtros_arr(4).x;
  arr_P(iCont, 12)=filtros_arr(4).y;
  arr_P(iCont, 13)=filtros_arr(4).maximo;
  arr_P(iCont, 14)=filtros_arr(5).x;
  arr_P(iCont, 15)=filtros_arr(5).y;
  arr_P(iCont, 16)=filtros_arr(5).maximo;
  
  ##Agregamos el frame al video
##  addframe(vidRes, frm);
##  if(mod(iCont,50)==0)
##    imshow(frm);
##    sleep(1);
##  endif

##  clc;
  printf("%f,\t%d-%d\n",(iCont*100)/totalFrames, iCont,totalFrames);
##  clear frm;
endfor

csvwrite("res_P.csv",arr_P);
printf("Fin\n");

close(vidRes);
clear vidRes;
