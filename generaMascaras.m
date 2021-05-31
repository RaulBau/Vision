##
# Nombre: Bautista Robles Raúl
# Clave: 229563
#
# Nombre: Alejo Pizano Braulio
# Clave: 267036
#
#
# Se generan las mascaras
##

#Cargamos los paquetes
pkg load image;
pkg load video;

##Filtro nesquik 1
generaMascara(75, 195, 151, 181,"8", 1290, "nesquik", "1");
##Filtro nesquik 2
generaMascara(620, 245, 181, 201,"8", 5700, "nesquik", "2");
##Filtro nesquik 3
generaMascara(385, 260, 155, 199,"4", 2400, "nesquik", "3");

##Filtro Valentina 1
generaMascara(505, 45, 41, 95,"3", 900, "valentina", "1");
##Filtro Valentina 2
generaMascara(145, 175, 95, 209,"3", 3600, "valentina", "2");
##Filtro valentina 3
generaMascara(535, 75, 45, 135,"3", 6300, "valentina", "3");

##Filtro lata 1
generaMascara(420, 200, 65, 91,"2", 450, "lata", "1");
##Filtro lata 2
generaMascara(305, 75, 41, 61,"6", 450, "lata", "2");
##Filtro lata 3
