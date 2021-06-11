##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
#
# Se generan las mascaras llamando a generaMascara(...)
# Entradas: Ninguna
# Salidas: Ninguna
##

#Cargamos los paquetes
pkg load image;
pkg load video;


function generaMascaras()
##Filtro nesquik 1
generaMascara (75, 195, 151, 181,"8", 1290, "nesquik", "1");
##Filtro nesquik 2
generaMascara (620, 245, 181, 201,"8", 5700, "nesquik", "2");
##Filtro nesquik 3
generaMascara (385, 260, 155, 199,"4", 2400, "nesquik", "3");

##Filtro Valentina 1
generaMascara (505, 45, 41, 95,"3", 900, "valentina", "1");
##Filtro Valentina 2
generaMascara (145, 175, 95, 209,"3", 3600, "valentina", "2");
##Filtro valentina 3
generaMascara (535, 75, 45, 135,"3", 6300, "valentina", "3");

##Filtro lata 1
generaMascara (420, 200, 65, 91,"2", 450, "lata", "1");
##Filtro lata 2
generaMascara (305, 75, 41, 61,"6", 450, "lata", "2");
##Filtro lata 3
generaMascara (145, 240, 95, 125,"6", 8100, "lata", "3");

##Filtro herdez 1
generaMascara (680, 245, 141, 195,"9", 6150, "herdez", "1");
##Filtro herdez 2
generaMascara (250, 35, 41, 71, "9", 2400, "herdez", "2");
##Filtro herdez 3
generaMascara (1, 225, 135, 205, "9", 900, "herdez", "3");

##Filtro costena 1
generaMascara (46, 280, 115, 141, "7", 1700, "costena", "1");
##Filtro costena 2
generaMascara (670, 286, 115, 145, "7", 4950, "costena", "2");
##Filtro costena 3
generaMascara (365, 185, 65, 107, "7", 3300, "costena", "3");

##Nuevos Filtros

##Filtro Atun 1
generaMascara(492,290,23,21,"filtros",600,"FiltroAtun","1");
##Filtro Atun 2
generaMascara(182,169,15,15,"filtros",1800,"FiltroAtun","2");
##Filtro Atun 3
generaMascara(298,122,11,11,"filtros",3000,"FiltroAtun","3");

##Filtro Tenedor 1
generaMascara(309,288,23,21,"filtros",600,"FiltroTenedor","1");
##Filtro Tenedor 2
generaMascara(424,172,15,15,"filtros",1800,"FiltroTenedor","2");
##Filtro Tenedor 3
generaMascara(219,116,11,11,"filtros",3000,"FiltroTenedor","3");

##Filtro Chiles 1
generaMascara(119,270,23,21,"filtros",600,"FiltroChile","1");
##Filtro Chiles 2
generaMascara(284,155,15,15,"filtros",1800,"FiltroChile","2");
##Filtro Chiles 3
generaMascara(388,114,11,11,"filtros",3000,"FiltroChile","3");

endfunction