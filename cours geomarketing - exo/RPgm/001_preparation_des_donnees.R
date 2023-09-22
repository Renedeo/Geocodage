##################################################################################
# chemins d'accès et librairies
##################################################################################

source("cours geomarketing - exo/RPgm/000_initiation_session_carto.R")


##################################################################################
# chargement des données
##################################################################################


load("cours geomarketing - exo/RData/fr_obj_qlm_shp_2022.RData")
load("cours geomarketing - exo/RData/fr_obj_dpt_shp_2022.RData")
load("cours geomarketing - exo/RData/fr_obj_reg_shp_2022.RData")
load("cours geomarketing - exo/RData/donnees_sd.RData")


##################################################################################
# 1 - Préparation des fonds de carte
##################################################################################
### LEXIQUE DONNEES DE L'INSEE :

### A - Je récupère les variables de l'INSEE qui m'intérèssent ###
liste_variables <- c(
  "qlm", "menrp",
  "men_cs1", "men_cs2", "men_cs3", "men_cs4", "men_cs5", "men_cs6", "men_cs7", "men_cs8", # les CSP
  "pop0014", "pop1524", "pop2529", "pop3044", "pop4559", "pop6074", "pop75p", # les populations
  "rp_prop", "rp_loc", "rpappart", "rpmaison", # l'habitat
  "RFMMO" # le revenu
)

donnees_sd <- donnees_sd[, liste_variables]

### B - Ajout de variables calculées : ###
donnees_sd$cspplus <- donnees_sd$men_cs2 + donnees_sd$men_cs3 + donnees_sd$men_cs4 # nombre de ménage CSP+
donnees_sd$cspmoins <- donnees_sd$men_cs1 + donnees_sd$men_cs5 + donnees_sd$men_cs7 # nombre de ménage CSP-
donnees_sd$pop2559 <- donnees_sd$pop2529 + donnees_sd$pop3044 + donnees_sd$pop4559 # nombre de personne agé de 25 à 59 ans
donnees_sd$RFTOT <- donnees_sd$RFMMO * donnees_sd$menrp # revenu total du quartier

### EXO 1 - Crée 2 nouvelles tables puis supprime-les.
# une table_csp qui contient 9 variables (qlm et les 8 CSP) nommé ainsi : QLM, CSP1, CSP2, CSP3...
table_csp <- as.data.frame(cbind(
  donnees_sd$qlm,
  donnees_sd$men_cs1,
  donnees_sd$men_cs2,
  donnees_sd$men_cs3,
  donnees_sd$men_cs4,
  donnees_sd$men_cs5,
  donnees_sd$men_cs6,
  donnees_sd$men_cs7,
  donnees_sd$men_cs8
))
colnames(table_csp) <- c(
  "qlm",
  "CSP1",
  "CSP2",
  "CSP3",
  "CSP4",
  "CSP5",
  "CSP6",
  "CSP7",
  "CSP8"
)
# ou
names(table_csp) <- c(
  "qlm",
  "CSP1",
  "CSP2",
  "CSP3",
  "CSP4",
  "CSP5",
  "CSP6",
  "CSP7",
  "CSP8"
)

# une table_pop qui contient 8 variables (qlm et les 7 populations) nommé ainsi : QLM, POP1, POP2, POP3...
table_pop <- as.data.frame(cbind(
  donnees_sd$qlm,
  donnees_sd$pop0014,
  donnees_sd$pop1524,
  donnees_sd$pop2529,
  donnees_sd$pop3044,
  donnees_sd$pop4559,
  donnees_sd$pop6074,
  donnees_sd$pop75p
))
colnames(table_pop) <- c(
  "QLM",
  "POP1",
  "POP2",
  "POP3",
  "POP4",
  "POP5",
  "POP6",
  "POP7"
)
# names
names(table_pop) <- c(
  "QLM",
  "POP1",
  "POP2",
  "POP3",
  "POP4",
  "POP5",
  "POP6",
  "POP7"
)
# --> utilise names(), dput() et rm()
rm(table_csp, table_pop)

### EXO 2 - Ecris les commandes pour filtrer la table donnees_sd.
# afficher les quartiers où il y a plus de 3000 retraités
donnees_sd[donnees_sd$men_cs7 > 3000, ]
# afficher les quartiers où il n'y a aucun retraité et exactement 2 propriétaires
donnees_sd[donnees_sd$men_cs7 == 0 & donnees_sd$rp_prop == 2, ]
# afficher les quartiers où il n'y a aucun retraité OU aucun cadre
donnees_sd[donnees_sd$men_cs7 == 0 | donnees_sd$men_cs3 == 0, ]
# donnees_sd[xor(donnees_sd$men_cs7 == 0, donnees_sd$men_cs3 == 0) ,


### C - J'ajoute les variables de l'INSEE à mon fond de carte QLM ###
fr_obj_qlm_shp <- merge(fr_obj_qlm_shp, donnees_sd, by.x = "cod_entite", by.y = "qlm", all.y = F)
test <- as.data.frame(fr_obj_qlm_shp) # pour vérifier je le transforme en dataframe et l'affiche
# save(fr_obj_qlm_shp, file = "~/cours geomarketing/RData/fr_obj_qlm_shp.RData") # Je le sauvegarde
save(fr_obj_qlm_shp, file = "cours geomarketing - exo/RData/fr_obj_qlm_shp.RData") # Je le sauvegarde

### D - J'ajoute les variables de l'INSEE à mon fond de carte DEPARTEMENT ###

# Examination  du format de la colonne qlm
## on a Dpt [_ _] + Reg[_ _ _] + Num[_ _]
donnees_sd$dpt <- substr(donnees_sd$qlm, 0, 3)

fr_obj_dpt_shp <- merge(fr_obj_dpt_shp, donnees_sd, by.x = "cod_entite", by.y = "dpt", all.y = F)
test <- as.data.frame(fr_obj_dpt_shp) # pour vérifier je le transforme en dataframe et l'affiche
save(fr_obj_dpt_shp, file = "cours geomarketing - exo/RData/fr_obj_dpt_shp.RData") # Je le sauvegarde

### E - J'ajoute les variables de l'INSEE à mon fond de carte REGION ###
# rm(donnees_sd)
donnees_sd$reg <- substr(donnees_sd$qlm, 3, 5)

fr_obj_reg_shp <- merge(fr_obj_reg_shp, donnees_sd, by.x = "cod_entite", by.y = "reg", all.y = F)
test <- as.data.frame(fr_obj_reg_shp) # pour vérifier je le transforme en dataframe et l'affiche
save(fr_obj_reg_shp, file = "cours geomarketing - exo/RData/fr_obj_reg_shp.RData") # Je le sauvegarde

##################################################################################
# 2 - Préparation de la table des ventes (par clients)
##################################################################################

# fr_poi_zo_cli <- read.csv("~/cours geomarketing/Data/bqextract_geocli_2022.csv",header = TRUE, sep = ",", dec = ".")
fr_poi_zo_cli <- read.csv("cours geomarketing - exo/Data/bqextract_geocli_2022.csv", header = TRUE, sep = ",", dec = ".")
fr_poi_zo_cli_shp <- SpatialPointsDataFrame(
  data = fr_poi_zo_cli,
  coords = fr_poi_zo_cli[, c("LONG_CLIENT", "LAT_CLIENT")],
  proj4string = projection_wgs84
)

### A - Afficher les 10 000 premiers points avec un plot ###
plot(fr_poi_zo_cli[1:10000, ])

### B - Ajout du qlm (Quartier Leroy Merlin)
ov <- over(fr_poi_zo_cli_shp, fr_obj_qlm_shp)
fr_poi_zo_cli_shp$qlm <- ov$cod_entite
fr_poi_zo_cli_shp$qlm <- as.character(fr_poi_zo_cli_shp$qlm)
fr_poi_zo_cli_shp$lib_qlm <- ov$lib_entite
fr_poi_zo_cli_shp$lib_qlm <- as.character(fr_poi_zo_cli_shp$lib_qlm)

### C - Ajout de la région ###
ov <- over(fr_poi_zo_cli_shp, fr_obj_reg_shp)
fr_poi_zo_cli_shp$reg <- ov$cod_entite
fr_poi_zo_cli_shp$reg <- as.character(fr_poi_zo_cli_shp$reg)
fr_poi_zo_cli_shp$lib_reg <- ov$lib_entite
fr_poi_zo_cli_shp$lib_reg <- as.character(fr_poi_zo_cli_shp$lib_reg)

### D - Ajout du département ###

ov <- over(fr_poi_zo_cli_shp, fr_obj_dpt_shp)
fr_poi_zo_cli_shp$dpt <- ov$cod_entite
fr_poi_zo_cli_shp$dpt <- as.character(fr_poi_zo_cli_shp$dpt)
fr_poi_zo_cli_shp$lib_dpt <- ov$lib_entite
fr_poi_zo_cli_shp$lib_dpt <- as.character(fr_poi_zo_cli_shp$lib_dpt)


names(fr_poi_zo_cli_shp)
save(fr_poi_zo_cli_shp, file = "cours geomarketing/RData/fr_poi_zo_cli_shp.RData")
rm(ov)


### EXO 3
# Crée une table contenant le CA, la quantity vendue et le nombre de ticket pour chaque région.
# Même question pour les départements et les QLM.
# --> utiliser la fonction aggregate() suivi de merge() : CA  = aggregate(MNT_TTC ~ lib_reg, data = fr_poi_zo_cli_shp, FUN=sum)
# ******
# QLM
CA <- aggregate(MNT_TTC ~ lib_qlm, data = fr_poi_zo_cli_shp, FUN = sum)
q_sel <- aggregate(QTE_ART ~ lib_qlm, data = fr_poi_zo_cli_shp, FUN = sum)
nb_t <- aggregate(NB_TICKET ~ lib_qlm, data = fr_poi_zo_cli_shp, FUN = sum)

table_qlm <- merge(
  x = merge(
    x = as.data.frame(CA),
    y = as.data.frame(q_sel),
    by.x = "lib_qlm",
    by.y = "lib_qlm"
  ),
  y = nb_t,
  by.x = "lib_qlm",
  by.y = "lib_qlm"
)

# Departement
CA <- aggregate(MNT_TTC ~ lib_dpt, data = fr_poi_zo_cli_shp, FUN = sum)
q_sel <- aggregate(QTE_ART ~ lib_dpt, data = fr_poi_zo_cli_shp, FUN = sum)
nb_t <- aggregate(NB_TICKET ~ lib_dpt, data = fr_poi_zo_cli_shp, FUN = sum)

table_qlm <- merge(
  x = merge(
    x = as.data.frame(CA),
    y = as.data.frame(q_sel),
    by.x = "lib_dpt",
    by.y = "lib_dpt"
  ),
  y = nb_t,
  by.x = "lib_dpt",
  by.y = "lib_dpt"
)
# Region
CA <- aggregate(MNT_TTC ~ lib_reg, data = fr_poi_zo_cli_shp, FUN = sum)
q_sel <- aggregate(QTE_ART ~ lib_reg, data = fr_poi_zo_cli_shp, FUN = sum)
nb_t <- aggregate(NB_TICKET ~ lib_reg, data = fr_poi_zo_cli_shp, FUN = sum)

table_qlm <- merge(
  x = merge(
    x = as.data.frame(CA),
    y = as.data.frame(q_sel),
    by.x = "lib_reg",
    by.y = "lib_reg"
  ),
  y = nb_t,
  by.x = "lib_reg",
  by.y = "lib_reg"
)
