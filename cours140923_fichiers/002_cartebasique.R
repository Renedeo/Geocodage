##################################################################################
# chemins d'accès et librairies
##################################################################################

# source("~/cours geomarketing/RPgm/000_initiation_session_carto.R")
source("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours140923_fichiers/000_initiation_session_carto.R")

##################################################################################
# chargement des donnees
##################################################################################
 
# load("~/cours geomarketing/RData/fr_obj_qlm_shp.RData")        # le découpage de la france
# load("~/cours geomarketing/RData/fr_poi_mag_conc_shp.RData")   # les concurrents
# load("~/cours geomarketing/RData/fr_poi_zo_ouverts_shp.RData") # les magasins Zôdio
# load("~/cours geomarketing/RData/fr_poi_zo_cli_shp.RData")     # les données de ventes

load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_obj_qlm_shp.RData")        # le découpage de la france
load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_mag_conc_shp.RData")   # les concurrents
load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_zo_ouverts_shp.RData") # les magasins Zôdio
load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_zo_cli_shp.RData")     # les données de ventes


##################################################################################
# paramètres de la carte
##################################################################################

# la version
cod_version = "2023"

# les logos
liste_logos <- bibliotheque_logos(23,23,23)

# l'attribut de la carte
pied_de_page <- "Carte Zôdio (version géographique septembre2023) "

# le fond de cartes
fond_de_carte1 <- providers$OpenStreetMap
fond_de_carte2 <- providers$Esri.WorldImagery
fond_de_carte3 <- providers$Stamen.TonerLite

# nom d'export
nomexport <- "carte_basique"

# position de la légende
positionlegende <- "bottomright" #"bottomleft"

# zoom de la carte
temp_met <- fr_poi_mag_conc_shp
zoom <- bbox(temp_met)
zoom
lng1 <- zoom[1]
lat1 <- zoom[2]
lng2 <- zoom[3]
lat2 <- zoom[4]

##################################################################################
# Création de la carte
##################################################################################

# Suppression de la carte pour repartir de 0
rm(carte)

# Création de la carte avec les fonds de cartes (couches fixes)
carte <- leaflet(
  ) %>% addTiles(attribution = paste0(pied_de_page,Sys.Date()) # Ajouter un pied de page à la carte 
  ) %>% addProviderTiles(fond_de_carte1, group = "fond1"
  ) %>% addProviderTiles(fond_de_carte2, group = "fond2"
  ) %>% addProviderTiles(fond_de_carte3, group = "fond3"
)


##################################################################################
# Ajout des couches de type "case à cocher" (=overlayGroups)
##################################################################################           

# Couche des magains Zodio ouverts en France
carte <-  addMarkers(map=carte
                     ,data = fr_poi_zo_ouverts_shp
                     ,group = "Zôdio"                                                # nom qui sera affiché dans la légende
                     #,clusterOptions = markerClusterOptions()                        # pour faire des clusters
                     ,popup = ~ paste0("Zôdio","<br>",fr_poi_zo_ouverts_shp$lib_mag) # s'affiche au clic
                     ,icon = ~ liste_logos[cod_ens] # ajout du logo
                     ,label = ~ lib_mag             # ajout de l'info-bulle
                     ,labelOptions = labelOptions(noHide = F                   # si True affiche l'info-bulle sur la carte
                                                  ,textOnly = F                # si True alors pas de box
                                                  ,style = list(color = "red") # couleur du texte
                                                  ,direction = "top"           # direction de l'info-bulles (bottom, left, right, top, center)
                                                  ,offset = c(0,-10)           # décalage de l'info-bulle
                                                  ,"opacity" = 0.75)           # l'opacité
)

# Couche Leroy Merlin
conc = fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc=="LEROY MERLIN",]
carte <-  addMarkers(map=carte
                     ,data = conc
                     ,group = "Leroy Merlin"
                     #,clusterOptions = markerClusterOptions()
                     ,popup = ~ paste0(conc$cod_ens_conc,"<br>",conc$lib_vil)
                     ,icon = ~ liste_logos[cod_ens_conc]
                     ,label = ~ lib_mag
                     ,labelOptions = labelOptions(noHide = F
                                                  ,textOnly = F
                                                  # ,style = list(color = "red")
                                                  ,style = list(color = "green")
                                                  ,direction = "top"
                                                  ,offset = c(0,-10)
                                                  ,"opacity" = 0.75)
)

# Couche IKEA
# ******
conc = fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc=="IKEA",]
carte <-  addMarkers(map=carte
                     ,data = conc
                     ,group = "IKEA"
                     #,clusterOptions = markerClusterOptions()
                     ,popup = ~ paste0(conc$cod_ens_conc,"<br>",conc$lib_vil)
                     ,icon = ~ liste_logos[cod_ens_conc]
                     ,label = ~ lib_mag
                     ,labelOptions = labelOptions(noHide = F
                                                  ,textOnly = F
                                                  ,style = list(color = "blue")
                                                  ,direction = "top"
                                                  ,offset = c(0,-10)
                                                  ,"opacity" = 0.75))

# Couche du concurrent MAISONS DU MONDE
# ******
conc = fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc=="MAISONS DU MONDE",]
carte <-  addMarkers(map=carte
                     ,data = conc
                     ,group = "MAISONS DU MONDE"
                     #,clusterOptions = markerClusterOptions()
                     ,popup = ~ paste0(conc$cod_ens_conc,"<br>",conc$lib_vil)
                     ,icon = ~ liste_logos[cod_ens_conc]
                     ,label = ~ lib_mag
                     ,labelOptions = labelOptions(noHide = F
                                                  ,textOnly = F
                                                  ,style = list(color = "black")
                                                  ,direction = "top"
                                                  ,offset = c(0,-10)
                                                  ,"opacity" = 0.75))

# Couche du concurrent SOSTRENE GRENE
# ******
conc = fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc=="SOSTRENE GRENE",]
carte <-  addMarkers(map=carte
                     ,data = conc
                     ,group = "SOSTRENE GRENE"
                     #,clusterOptions = markerClusterOptions()
                     ,popup = ~ paste0(conc$cod_ens_conc,"<br>",conc$lib_vil)
                     ,icon = ~ liste_logos[cod_ens_conc]
                     ,label = ~ lib_mag
                     ,labelOptions = labelOptions(noHide = F
                                                  ,textOnly = F
                                                  ,style = list(color = "white",
                                                                "background-color" = "black")
                                                  ,direction = "top"
                                                  ,offset = c(0,-10)
                                                  ,"opacity" = 0.75))

##################################################################################
# Cluster 
################################################################################## 
# rm(carte)

# Création de la carte avec les fonds de cartes (couches fixes)
# carte <- leaflet(
# ) %>% addTiles(attribution = paste0(pied_de_page,Sys.Date()) # Ajouter un pied de page à la carte 
# ) %>% addProviderTiles(fond_de_carte1, group = "fond1"
# ) %>% addProviderTiles(fond_de_carte2, group = "fond2"
# ) %>% addProviderTiles(fond_de_carte3, group = "fond3"
# )
# 
# 
# conc = fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc=="SOSTRENE GRENE",]
# carte2 <-  addMarkers(map=carte
#                      ,data = conc
#                      ,group = "SOSTRENE GRENE"
#                      ,clusterOptions = markerClusterOptions()
#                      ,popup = ~ paste0(conc$cod_ens_conc,"<br>",conc$lib_vil)
#                      ,icon = ~ liste_logos[cod_ens_conc]
#                      ,label = ~ lib_mag
#                      ,labelOptions = labelOptions(noHide = F
#                                                   ,textOnly = F
#                                                   ,style = list(color = "white",
#                                                                 "background-color" = "black")
#                                                   ,direction = "top"
#                                                   ,offset = c(0,-10)
#                                                   ,"opacity" = 0.75))

##################################################################################
# Gestion du contrôle des couches
################################################################################## 
# permet de lier la legende aux analyse de type "choix"
  # permet de nommer les box (choix multiples / choix simple)                  
  # Ajustement au rectangle d'affichage calculé sur l'emprise des isochrones
# "topright", "bottomright", "bottomleft", "topleft"

carte <- addLayersControl(map=carte
                          ,overlayGroups = c("Zôdio","Leroy Merlin","IKEA","MAISONS DU MONDE","SOSTRENE GRENE")
                          ,baseGroups  = c("fond1","fond2","fond3")
                          ,options = layersControlOptions(collapsed = F)
                          ,position = "topright") %>% htmlwidgets::onRender("
                        function(el, x) {
                        var updateLegend = function () {
                        var selectedGroup = document.querySelectorAll('input:checked')[0].nextSibling.innerText.substr(1);
                        var selectedClass = selectedGroup.replace(' ', '');
                        document.querySelectorAll('.legend').forEach(a => a.hidden=true);
                        document.querySelectorAll('.legend').forEach(l => {
                        if (l.classList.contains(selectedClass)) l.hidden=false;
                        });
                        };
                        updateLegend();
                        this.on('baselayerchange', el => updateLegend());
                        }")%>% htmlwidgets::onRender("
                        function() {
                        $('.leaflet-control-layers-overlays').prepend('Magasins');
                        $('.leaflet-control-layers-list').prepend('Fond de carte');
                        }") %>%  fitBounds(lng1 = zoom[1], lat1 = zoom[2],lng2 = zoom[3],lat2 = zoom[4])

# essayer avec et sans la commande ci-dessous pour comprendre ce qu'elle fait :
#  %>% hideGroup(c("Leroy Merlin","IKEA","Maisons du monde","SOSTRENE GRENE"))

carte



##################################################################################
# Export en .html
# saveWidget(carte,paste0("~/cours geomarketing/ResultatsR/",nomexport,"_",cod_version,".html"),selfcontained = FALSE)
