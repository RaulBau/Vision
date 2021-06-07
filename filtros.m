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

generaMascaras();

#Paso alto estricto laplaciano
h=[-1 -1 -1;
-1 8 -1;
-1 -1 -1;];
#Average
h2=fspecial("average");

##Seleccionamos el número de video
numVideo="V2/2";
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
totalFiltros=3;
##Se crea un arreglo con los filtros
filtros_arr(1:10) = struct();
ruta="Filtros/lata";
LK=0.4;
NImages=3;
H_Filtro=filtroC_LK(LK,ruta,NImages);

filtros_arr(1).ruta="Filtros/FiltroAtun";
filtros_arr(1).nombre="FiltroAtun";
filtros_arr(1).h_filtro=filtroC_LK(LK,filtros_arr(1).ruta,NImages);
filtros_arr(1).detectado=false;
filtros_arr(1).cambio=false;
filtros_arr(1).x=0;
filtros_arr(1).y=0;
filtros_arr(1).max=0;

filtros_arr(2).ruta="Filtros/FiltroTenedor";
filtros_arr(2).nombre="FiltroTenedor";
filtros_arr(2).h_filtro=filtroC_LK(LK,filtros_arr(2).ruta,NImages);
filtros_arr(2).detectado=false;
filtros_arr(2).cambio=false;
filtros_arr(2).x=0;
filtros_arr(2).y=0;
filtros_arr(2).max=0;

filtros_arr(3).ruta="Filtros/FiltroChile";
filtros_arr(3).nombre="FiltroChile";
filtros_arr(3).h_filtro=filtroC_LK(LK,filtros_arr(3).ruta,NImages);
filtros_arr(3).detectado=false;
filtros_arr(3).cambio=false;
filtros_arr(3).x=0;
filtros_arr(3).y=0;
filtros_arr(3).max=0;

##filtros_arr(5).ruta="Filtros/";
##filtros_arr(5).h_filtro=filtroC_LK(LK,filtros_arr(5).ruta,NImages);
##filtros_arr(5).detectado=false;
##filtros_arr(5).cambio=false;
##filtros_arr(5).x=0;
##filtros_arr(5).y=0;
##filtros_arr(5).max=0;
##FinFiltros

#Variable para procesar todo el video o un frame en especifico
procesaVideo=false;


if(procesaVideo==true)
  #Obtenemos el total de frames
  totalFrames=info.NumFrames-120;

  ##Creamos el arreglo de resultados del filtro P
  arr_P=zeros(totalFrames/3, 10);
  #Creamos un contador para manejar el arreglo de resultados
  arrCont=1;
  printf("Inicia procesamiento.\n");
  printf("Total frames:\n", info.NumFrames);
  for iCont=1:3:totalFrames
  ##  printf("Frame: %d\n", iCont);
    ##Obtenemos el frame
    frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),iCont));
    ##Recortamos la imagen
    frm=imcrop(frm,[155,1, 359, 359]);
    ##Creamos un respaldo del frame
    frmRes=frm;

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
          printf(cstrcat (filtros_arr(iFiltro).nombre, " detectado. Frame: %d", "\n"), iCont);
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
    
    #Se llena el arreglo de resultados
    arr_P(arrCont,  1)=iCont;
    arr_P(arrCont,  2)=filtros_arr(1).x;
    arr_P(arrCont,  3)=filtros_arr(1).y;
    arr_P(arrCont,  4)=filtros_arr(1).maximo;
    arr_P(arrCont,  5)=filtros_arr(2).x;
    arr_P(arrCont,  6)=filtros_arr(2).y;
    arr_P(arrCont,  7)=filtros_arr(2).maximo;
    arr_P(arrCont,  8)=filtros_arr(3).x;
    arr_P(arrCont,  9)=filtros_arr(3).y;
    arr_P(arrCont, 10)=filtros_arr(3).maximo;
    arrCont++;
    
    clear frm;  
  endfor
  csvwrite("res_P.csv",arr_P);
else
  #Creamos una variable para obtener el frame
  numFrame=7200;
  #Leemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),numFrame));
  ##Recortamos la imagen
  frm=imcrop(frm,[155,1, 359, 359]);
  ##Creamos un respaldo del frame
  frmRes=frm;

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
        printf(cstrcat (filtros_arr(iFiltro).nombre, " detectado. Frame: %d", "\n"), numFrame);
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
endif

printf("Fin\n");

close(vidRes);
clear vidRes;
