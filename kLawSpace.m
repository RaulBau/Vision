function [imOr] = kLawSpace(L_K, nombreA, recorta)
  printf("%s\n", nombreA);
  ##Se lee la imagen
  img=imread(nombreA);
  ##Obtenemos el valor de un pixel 
  pixel=impixel(img, 10,10);
  ##Obtenemos el tamaño del pixel
  sPixel=size(pixel);
  ##Se revisa si el pixel es de 3x3
  if(sPixel(1)==3)
    ##Se convierte la imagen a escala de grises
    recI =rgb2gray(img);
  else
    ##Se iguala la imagen
    recI=img;
  endif
 
  YIni = fft2(double(recI));
 imOr = (abs(YIni).^L_K).*exp(j*angle(YIni));
endfunction