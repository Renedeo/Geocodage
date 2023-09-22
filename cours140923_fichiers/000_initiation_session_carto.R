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


bibliotheque_logos <- function(grand,moyen,petit)
{
  # chem_logos <- "~/cours geomarketing/Data/Logo"
  chem_logos <- "H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours140923_fichiers/Logo"
  
  liste_logos <- iconList (
    "ACTION0"           = makeIcon(paste0(chem_logos,"/ACTION.png"),          paste0(chem_logos,"/ACTION.png"),          grand, grand)
    ,"CENTRAKOR"       = makeIcon(paste0(chem_logos,"/CENTRAKOR.png"),       paste0(chem_logos,"/CENTRAKOR.png"),       grand, grand)
    ,"FOIRFOUILLE"     = makeIcon(paste0(chem_logos,"/FOIRFOUILLE.png"),     paste0(chem_logos,"/FOIRFOUILLE.png"),     grand, grand)
    ,"GIFI"            = makeIcon(paste0(chem_logos,"/GIFI.png"),            paste0(chem_logos,"/GIFI.png"),            grand, grand)
    #############
    # ens principale 
    ,"ZODIO"           = makeIcon(paste0(chem_logos,"/ZODIO.png"),           paste0(chem_logos,"/ZODIO.png"),           grand, grand)
    #############
    #############
    # ens secondaire 
    #############
    ,"CASA"            = makeIcon(paste0(chem_logos,"/CASA.png"),            paste0(chem_logos,"/CASA.png"),            moyen, moyen)
    ,"IKEA"            = makeIcon(paste0(chem_logos,"/IKEA.png"),            paste0(chem_logos,"/IKEA.png"),            moyen, moyen)
    ,"JYSK"            = makeIcon(paste0(chem_logos,"/JYSK.png"),            paste0(chem_logos,"/JYSK.png"),            moyen, moyen)
    #############
    # ens Autre 
    #############
    ,"AUCHAN"          = makeIcon(paste0(chem_logos,"/AUCHAN.png"),          paste0(chem_logos,"/AUCHAN.png"),          petit, petit)
    ,"CARREFOUR"       = makeIcon(paste0(chem_logos,"/CARREFOUR.png"),       paste0(chem_logos,"/CARREFOUR.png"),       petit, petit)
    ,"LECLERC"         = makeIcon(paste0(chem_logos,"/LECLERC.png"),         paste0(chem_logos,"/LECLERC.png"),         petit, petit)
    #############
    ,"LEROY MERLIN"    = makeIcon(paste0(chem_logos,"/LM.png"),           paste0(chem_logos,"/LM.png"),           petit, petit)
    ,"MAISONS DU MONDE"= makeIcon(paste0(chem_logos,"/MAISONSDUMONDE.png"),  paste0(chem_logos,"/MAISONSDUMONDE.png"),  petit, petit)
    ,"SOSTRENE GRENE"  = makeIcon(paste0(chem_logos,"/SOSTRENEGRENE.png"),   paste0(chem_logos,"/SOSTRENEGRENE.png"),   moyen, moyen)
    ,"etoile"          = makeIcon(paste0(chem_logos,"/etoile.png"),          paste0(chem_logos,"/etoile.png"),          petit, petit)
    ,"plus"            = makeIcon(paste0(chem_logos,"/plus.png"),            paste0(chem_logos,"/plus.png"),            petit, petit)
    ,"pastille_verte"  = makeIcon(paste0(chem_logos,"/pastille_verte.png"),  paste0(chem_logos,"/pastille_verte.png"),  petit, petit)
    ,"pastille_rouge"  = makeIcon(paste0(chem_logos,"/pastille_rouge.png"),  paste0(chem_logos,"/pastille_rouge.png"),  petit, petit)
    ,"pastille_noire"  = makeIcon(paste0(chem_logos,"/pastille_noire.png"),  paste0(chem_logos,"/pastille_noire.png"),  petit, petit)
    ,"carre_bleu"      = makeIcon(paste0(chem_logos,"/carre_bleu.png"),      paste0(chem_logos,"/carre_bleu.png"),      petit, petit)
    ,"carre_bleu_ciel" = makeIcon(paste0(chem_logos,"/carre_bleu_ciel.png"), paste0(chem_logos,"/carre_bleu_ciel.png"), petit, petit)
    ,"carre_bordeaux"  = makeIcon(paste0(chem_logos,"/carre_bordeaux.png"),  paste0(chem_logos,"/carre_bordeaux.png"),  petit, petit)
    ,"carre_gris"      = makeIcon(paste0(chem_logos,"/carre_gris.png"),      paste0(chem_logos,"/carre_gris.png"),      petit, petit)
    ,"carre_jaune"     = makeIcon(paste0(chem_logos,"/carre_jaune.png"),     paste0(chem_logos,"/carre_jaune.png"),     petit, petit)
    ,"carre_noir"      = makeIcon(paste0(chem_logos,"/carre_noir.png"),      paste0(chem_logos,"/carre_noir.png"),      petit, petit)
    ,"carre_orange"    = makeIcon(paste0(chem_logos,"/carre_orange.png"),    paste0(chem_logos,"/carre_orange.png"),    petit, petit)
    ,"carre_rouge"     = makeIcon(paste0(chem_logos,"/carre_rouge.png"),     paste0(chem_logos,"/carre_rouge.png"),     petit, petit)
    ,"carre_vert"      = makeIcon(paste0(chem_logos,"/carre_vert.png"),      paste0(chem_logos,"/carre_vert.png"),      petit, petit)
    ,"carre_violet"    = makeIcon(paste0(chem_logos,"/carre_violet.png"),    paste0(chem_logos,"/carre_violet.png"),    petit, petit)
    ,"cercle_vert"     = makeIcon(paste0(chem_logos,"/cercle_vert.png"),     paste0(chem_logos,"/cercle_vert.png"),     petit, petit)
    ,"cercle_rouge"    = makeIcon(paste0(chem_logos,"/cercle_rouge.png"),    paste0(chem_logos,"/cercle_rouge.png"),    petit, petit)
    ,"cercle_noir"     = makeIcon(paste0(chem_logos,"/cercle_noir.png"),     paste0(chem_logos,"/cercle_noir.png"),     petit, petit)
  )  
  
  rm(chem_logos)
  list_enseignes <- c(
    "ACTION","AUCHAN","CARREFOUR","CASA","CENTRAKOR","FOIRFOUILLE","GIFI","IKEA","JYSK","LECLERC"
    ,"LEROY MERLIN","MAISONS DU MONDE","SOSTRENE GRENE","ZODIO","etoile","plus","pastille_verte"
    ,"pastille_rouge","pastille_noire","carre_bleu","carre_bleu_ciel","carre_bordeaux","carre_gris"
    ,"carre_jaune","carre_noir","carre_orange","carre_rouge","carre_vert","carre_violet"
    ,"cercle_vert","cercle_rouge","cercle_noir"
  )
  
  return(liste_logos)
}
