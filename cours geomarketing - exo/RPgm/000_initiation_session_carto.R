# Pour des traitements cartographiques
library("sp")
library("rgdal")
library("rgeos")
library("maptools")

# Pour faire des cartes
library("leaflet")
library("htmlwidgets")
library("webshot")
library("RColorBrewer")
library("mapview")
library("osrm")

# Projections
projection_lambert2 <- CRS("+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2
                           +b=6356514.999978254 +pm=2.337229167 +units=m +no_defs")

projection_wgs84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")


projection_lambert93 <- CRS("+init=epsg:2154 +proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000
                             +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")


### LEXIQUE DONNEES DE L'INSEE :

# "qlm"      : quartier Leroy Merlin
# "menrp"    : nombre de ménages
# "men_cs1"  : nombre de ménages dont la personne de référence est agriculteur              (CSP-)
# "men_cs2"  : nombre de ménages dont la personne de référence est artisan, commerçant      (CSP+)
# "men_cs3"  : nombre de ménages dont la personne de référence est cadre                    (CSP+)
# "men_cs4"  : nombre de ménages dont la personne de référence est profession intermédiaire (CSP+)
# "men_cs5"  : nombre de ménages dont la personne de référence est employé                  (CSP-)
# "men_cs6"  : nombre de ménages dont la personne de référence est ouvrier                  (CSP-)
# "men_cs7"  : nombre de ménages dont la personne de référence est retraité
# "men_cs8"  : nombre de ménages dont la personne de référence est sans emploi
# "pop0014"  : nombre de personnes de 0 à 14 ans
# "pop1524"  : nombre de personnes de 15 à 24 ans
# "pop2529"  : nombre de personnes de 25 à 29 ans
# "pop3044"  : nombre de personnes de 30 à 44 ans
# "pop4559"  : nombre de personnes de 45 à 59 ans
# "pop6074"  : nombre de personnes de 60 à 74 ans
# "pop75p"   : nombre de personnes de plus de 75 ans
# "rp_prop"  : nombre de ménages propriétaires
# "rp_loc"   : nombre de ménages en location
# "rpappart" : nombre de ménages habitant en appartement
# "rpmaison" : nombre de ménages habitant dans une maison
# "RFMMO"    : revenu moyen annuel net par ménage
# "RFTOT"    : revenu total annuel net