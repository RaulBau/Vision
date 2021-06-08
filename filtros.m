##
# Nombre: Bautista Robles Ra煤l
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
# Archivo principal.
# Lee la informaci髇 del video
# Genera las mascaras
# Inicializa el arreglo de mascaras
# Procesa el video
##

##Se limpia la consola
clc;
clear;

#Cargamos los paquetes
pkg load image;
pkg load video;

#Se generan las mascaras
generaMascaras();

#Paso alto estricto laplaciano
h=[-1 -1 -1;
-1 8 -1;
-1 -1 -1;];
#Average
h2=fspecial("average");

##Seleccionamos el n煤mero de video
numVideo="V2/4";
##Se obtiene la informaci贸n del videos
info=aviinfo(cstrcat ("Videos/", numVideo, ".avi"));
##Se genera el nombre del video resultado
nombre = cstrcat ("res_fv3_", "v2", ".avi"); 
##Se crea el video resultado
vidRes = avifile(nombre, "codec", "msmpeg4v2");

##Filtros
##Se guarda el total de filtros
totalFiltros=1;
##Se crea un arreglo con los filtros
filtros_arr(1:10) = struct();
ruta="Filtros/lata";
LK=0.4;
NImages=3;

filtros_arr(1).ruta="Filtros/FiltroAtun";
filtros_arr(1).nombre="FiltroAtun";
filtros_arr(1).h_filtro=filtroC_LK(LK,filtros_arr(1).ruta,NImages);
filtros_arr(1).detectado=0;
filtros_arr(1).cambio=false;
filtros_arr(1).x=0;
filtros_arr(1).y=0;
filtros_arr(1).maximo=0;

filtros_arr(2).ruta="Filtros/FiltroTenedor";
filtros_arr(2).nombre="FiltroTenedor";
filtros_arr(2).h_filtro=filtroC_LK(LK,filtros_arr(2).ruta,NImages);
filtros_arr(2).detectado=0;
filtros_arr(2).cambio=false;
filtros_arr(2).x=0;
filtros_arr(2).y=0;
filtros_arr(2).maximo=0;

filtros_arr(3).ruta="Filtros/FiltroChile";
filtros_arr(3).nombre="FiltroChile";
filtros_arr(3).h_filtro=filtroC_LK(LK,filtros_arr(3).ruta,NImages);
filtros_arr(3).detectado=0;
filtros_arr(3).cambio=false;
filtros_arr(3).x=0;
filtros_arr(3).y=0;
filtros_arr(3).maximo=0;

##Ejemplo de la estructura
##filtros_arr(5).ruta="Filtros/";
##filtros_arr(5).nombre="";
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
  arrCont=3;
  printf("Inicia procesamiento.\n");
  printf("Total frames:\n", info.NumFrames);
  for iCont=1:3:totalFrames
    ##Obtenemos el frame
    frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),iCont));
    ##Dependiendo del video se elige el fondo
    switch(numVideo)
      case "V2/1"
        fondo=rgb2gray(aviread("Videos/V2/1.avi",1));
      case "V2/2"
        fondo=rgb2gray(aviread("Videos/V2/2.avi",1));
      case "V2/3"
        fondo=rgb2gray(aviread("Videos/V2/4.avi",1));
      case "V2/6"
        fondo=rgb2gray(aviread("Videos/V2/6.avi",1));
      otherwise
        fondo=rgb2gray(aviread("Videos/V2/4.avi",1));
    endswitch
    ##Se elimina el fondo
    frm=fondo-frm;
    ##Recortamos la imagen
    frm=imcrop(frm,[155,1, 359, 359]);
    ##Creamos un respaldo del frame
    frmRes=frm;
    ##Sumamos el contenido del frame despues de la resta para saber si hay datos
    suma=sum(sum(frm));

    ##Si hubo datos
    if(suma>5)
    ##Aplicamos el filtro
      O_Filtro=kLawSpaceV(LK,frm);
      ##Se inicializa la bandera para imprimir
      imprimirDetectados=0;
      for iFiltro=1:totalFiltros
        ##filtros_arr(iFiltro).
        filtros_arr(iFiltro).resp=O_Filtro.*(conj(filtros_arr(iFiltro).h_filtro)./abs(filtros_arr(iFiltro).h_filtro));
        ##Creamos la correlaci贸n
        filtros_arr(iFiltro).corl=real(ifftshift(ifft2(filtros_arr(iFiltro).resp)));
        ##Obtenemos el valor m谩ximo de la correlaci贸n
        filtros_arr(iFiltro).maximo=max(filtros_arr(iFiltro).corl(:));
        ##Se obtienen las coordenadas del maximo
        [filtros_arr(iFiltro).y,filtros_arr(iFiltro).x]=find(filtros_arr(iFiltro).maximo==filtros_arr(iFiltro).corl);
        ##Creamos un arreglo con los datos de la correlaci髇
        vmax=reshape(filtros_arr(iFiltro).corl,[],1);        
        if(filtros_arr(iFiltro).maximo >= 0.08 && filtros_arr(iFiltro).detectado== false)
          ##Ordenamos los datos y obtenemos los 10 primeros
          vmax10=sort(vmax,'descend')(1:10);
          ##Se comparan los resultados para saber si son validos
          detectados=sum(vmax10(1:10)>=0.08);
          ##Los datos se guardan en la estructura
          filtros_arr(iFiltro).detectado = detectados;
          ##Revisamos si se encontraron objetos
          if(detectados>0)
            imprimirDetectados=detectados;
          endif
        else
          ##Reiniciamos el valor
          filtros_arr(iFiltro).detectado=0;
        endif
      endfor
      
      if(imprimirDetectados!=0)
        mensaje="Se encontraron: ";
        for iFiltro=1:totalFiltros
          if(filtros_arr(iFiltro).detectado!=0)
            mensaje=cstrcat (mensaje,mat2str (filtros_arr(iFiltro).detectado)," ", filtros_arr(iFiltro).nombre,", ");
          endif
        endfor
        mensaje=cstrcat (mensaje,"\n");
        printf(mensaje);
      endif
      
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
      
      ##Agregamos el frame al video
  ##    addframe(vidRes, frmRes);
    endif
    clear frm;
  endfor
  csvwrite("res_P.csv",arr_P);

  close(vidRes);
  clear vidRes;
else
  #Creamos una variable para obtener el frame
  numFrame=3500;
  #Leemos el frame
  frm=rgb2gray(aviread(cstrcat ("Videos/", numVideo, ".avi"),numFrame));
  ##Eliminamos el fondo segun el video
  switch(numVideo)
    case "V2/1"
      fondo=rgb2gray(aviread("Videos/V2/1.avi",1));
    case "V2/2"
      fondo=rgb2gray(aviread("Videos/V2/2.avi",1));
    case "V2/3"
      fondo=rgb2gray(aviread("Videos/V2/4.avi",1));
    case "V2/6"
      fondo=rgb2gray(aviread("Videos/V2/6.avi",1));
    otherwise
      fondo=rgb2gray(aviread("Videos/V2/4.avi",1));
  endswitch
  frm=fondo-frm;
  ##Recortamos la imagen
  frm=imcrop(frm,[155,1, 359, 359]);
  ##Creamos un respaldo del frame
  frmRes=frm;
  
  ##Aplicamos el filtro
  O_Filtro=kLawSpaceV(LK,frm);
  ##Se inicializa la bandera para imprimir
  imprimirDetectados=0;
  for iFiltro=1:totalFiltros
    ##filtros_arr(iFiltro).
    filtros_arr(iFiltro).resp=O_Filtro.*(conj(filtros_arr(iFiltro).h_filtro)./abs(filtros_arr(iFiltro).h_filtro));
    ##Creamos la correlaci贸n
    filtros_arr(iFiltro).corl=real(ifftshift(ifft2(filtros_arr(iFiltro).resp)));
    ##Obtenemos el valor m谩ximo de la correlaci贸n
    filtros_arr(iFiltro).maximo=max(filtros_arr(iFiltro).corl(:));
    ##Se obtienen la scoorenadas del maximo
    [filtros_arr(iFiltro).y,filtros_arr(iFiltro).x]=find(filtros_arr(iFiltro).maximo==filtros_arr(iFiltro).corl);
    ##Creamos un arreglo con los datos de la correlaci髇
    vmax=reshape(filtros_arr(iFiltro).corl,[],1);        
    if(filtros_arr(iFiltro).maximo >= 0.08 && filtros_arr(iFiltro).detectado== false)
      ##Ordenamos los datos y obtenemos los 10 primeros
      vmax10=sort(vmax,'descend')(1:10);
      ##Se comparan los resultados para saber si son validos
      detectados=sum(vmax10(1:3)>=0.08);
      ##Los datos se guardan en la estructura
      filtros_arr(iFiltro).detectado = detectados;
      ##Revisamos si se encontraron objetos
      if(detectados>0)
        imprimirDetectados=detectados;
      endif
    else
      filtros_arr(iFiltro).detectado=0;
    endif
  endfor
  
  if(imprimirDetectados!=0)
    mensaje="Se encontraron: ";
    for iFiltro=1:totalFiltros
      if(filtros_arr(iFiltro).detectado!=0)
        mensaje=cstrcat (mensaje,mat2str (filtros_arr(iFiltro).detectado)," ", filtros_arr(iFiltro).nombre,", ");
      endif
    endfor
    mensaje=cstrcat (mensaje,"\n");
    printf(mensaje);
  endif
  
  imshow(frm);
endif

printf("Fin\n");

