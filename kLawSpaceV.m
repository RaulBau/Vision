##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
#
##

function [imOr] = kLawSpaceV(L_K, nombreI)  
  YIni = fft2(double(nombreI));
  imOr = (abs(YIni).^L_K).*exp(j*angle(YIni));
endfunction
