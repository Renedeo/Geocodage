source("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours140923_fichiers/000_initiation_session_carto.R")

load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_obj_qlm_shp.RData") # le découpage de la france
load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_mag_conc_shp.RData") # les concurrents
load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_zo_ouverts_shp.RData") # les magasins Zôdio
# load("H:/Mon Drive/cv_Rene/Univ-Lille/M2 - WA/Seminaire Professionnel- Geocodage/cours geomarketing - exo/RData/fr_poi_zo_cli_shp.RData")     # les données de ventes


##################################################################################
# paramètres de la carte
##################################################################################

# la version
cod_version <- "2023"



# l'attribut de la carte
pied_de_page <- "Carte Zôdio (version géographique septembre2023) "

# le fond de cartes
fond_de_carte1 <- providers$OpenStreetMap
fond_de_carte2 <- providers$Esri.WorldImagery
# fond_de_carte3 <- providers$Stamen.TonerLite

# nom d'export
nomexport <- "carte_basique"

# position de la légende
positionlegende <- "bottomright" # "bottomleft"

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
carte <- leaflet() %>%
  addTiles(
    attribution = paste0(pied_de_page, Sys.Date()) # Ajouter un pied de page à la carte
  ) %>%
  addProviderTiles(fond_de_carte1, group = "Carte_routière") %>%
  addProviderTiles(fond_de_carte2, group = "Carte_épurée") %>%
  addScaleBar(
    position = "bottomleft",
    # units = "metric",
    options = scaleBarOptions(maxWidth = 200)
  )



############################################## Enseignes
#######################################################
ens <- c(
  "Zôdio",
  "CASA",
  "IKEA",
  "JYSK",
  "AUCHAN",
  "CARREFOUR",
  "LECLERC"
)
ens_princ <- "Zôdio"
ens_sec <- c(
  "CASA",
  "IKEA",
  "JYSK"
)
ens_autre <- c(
  "AUCHAN",
  "CARREFOUR",
  "LECLERC"
)

# les logos
liste_logos <- bibliotheque_logos(26, 22, 17)
# Zodio (enseigne principale)
carte <- carte %>%
  addMarkers(
    data = fr_poi_zo_ouverts_shp,
    group = ens_princ # nom qui sera affiché dans la légende
    , popup = ~ paste0(
      "Enseigne principale",
      "<br>",
      ens_princ,
      "-",
      lib_mag,
      "<br>",
      substr(qlm, 0, 5)
    ) # s'affiche au clic
    , icon = ~ liste_logos[cod_ens] # ajout du logo
    , label = ~ paste0(
      ens_princ,
      " ",
      lib_mag
    ) # ajout de l'info-bulle
    , labelOptions = labelOptions(
      noHide = F # si True affiche l'info-bulle sur la carte
      , textOnly = F # si True alors pas de box
      # ,style = color # couleur du texte
      , style = list(color = "black") # couleur du texte
      , direction = "right" # direction de l'info-bulles (bottom, left, right, top, center)
      , fontsize = "13px", ,
      offset = c(0, -10) # font size = 13px
      , "opacity" = 0.75
    )
  ) %>%
  addCircles(
    data = fr_poi_zo_ouverts_shp,
    color = color,
    radius = ~1000,
    fillOpacity = 0,
    label = ~ paste0(
      ens_princ,
      "-",
      lib_mag
    ),
    group = ~ paste0("CERCLE_",
      ens_princ,
      sep = ""
    )
  )

######################################### Icone Carte
# info-bulles
# Popup
# logos
# Cercles
########################################
for (mag in ens) {
  color <- ifelse(mag %in% ens_sec,
    "red",
    "green"
  )
  if (mag != ens_princ) {
    conc <- fr_poi_mag_conc_shp[fr_poi_mag_conc_shp$cod_ens_conc == mag, ]
    carte <- carte %>%
      addMarkers(
        data = conc,
        group = mag # nom qui sera affiché dans la légende
        , popup = ~ paste0(
          ifelse(mag %in% ens_sec,
            "Enseigne secondaire ",
            "Autre enseigne"
          ),
          "<br>",
          mag,
          "-",
          lib_vil,
          "<br>",
          cod_pst,
          "<br>",
          nbr_surf_tot_mag,
          "m²"
        ) # s'affiche au clic
        , icon = ~ liste_logos[cod_ens_conc] # ajout du logo
        , label = ~ paste0(
          mag,
          " ",
          lib_vil
        ),
        labelOptions = labelOptions(
          noHide = F # si True affiche l'info-bulle sur la carte
          , textOnly = F # si True alors pas de box
          # ,style = color # couleur du texte
          , style = list(color = color) # couleur du texte
          , direction = "right" # direction de l'info-bulles (bottom, left, right, top, center)
          , fontsize = "13px", ,
          offset = c(0, -10) # font size = 13px
          , "opacity" = 0.75
        )
      ) %>%
      addCircles(
        data = conc,
        color = color,
        radius = ~ nbr_surf_tot_mag * 15,
        fillOpacity = 0,
        label = ~ paste0(
          mag,
          "-",
          lib_vil,
          "-",
          nbr_surf_tot_mag
        ),
        group = ~ paste0("CERCLE_",
          mag,
          sep = ""
        )
      )
  }
}
######################### Carré
#############################################################
# Limite
llat_corner <- 45.0 # Limite de séparation à la 45' parallele
############################## Nord
nlat_corner_haut <- 52
nlng_corner_haut <- -5.0
nlng_corner <- 8.0
############################## Sud
slat_corner_bas <- 38
slng_corner_bas <- -2.0
slng_corner <- 8.0
######################### Nombre de magasin zodio par carré
#############################################################
nb_mag_zod_Nord <- nrow(fr_poi_zo_ouverts_shp[fr_poi_zo_ouverts_shp@data$lat_wgs84 > llat_corner, ]@data)
nb_mag_zod_Sud <- nrow(fr_poi_zo_ouverts_shp[fr_poi_zo_ouverts_shp@data$lat_wgs84 < llat_corner, ]@data)

######################### Ajout des rectangle
# Pour les rectangle on doit donnée les coordonnées de la diag
#   et R s'occupe de tracer le rectangle correspondant
# Par contre les carrée sont trop grand et
#   prenne plus que la France
#############################################################
carte <- carte %>%
  addRectangles(
    lat2 = nlat_corner_haut,
    lng2 = nlng_corner_haut,
    lat1 = llat_corner,
    lng1 = nlng_corner,
    label = paste("Nord/Sud de la France: ",
      nb_mag_zod_Nord,
      sep = " "
    ),
    group = "NORD"
  ) %>%
  addRectangles(
    lat1 = slat_corner_bas,
    lng1 = slng_corner_bas,
    lat2 = llat_corner,
    lng2 = slng_corner,
    label = paste("Nord/Sud de la France: ",
      nb_mag_zod_Sud,
      sep = " "
    ),
    group = "SUD"
  )


######################################## Gestion du contrôle des couches
# Groupe des cercles
group_cercle <- paste("CERCLE_",
  ens,
  sep = ""
)
##################################################################################
# "topright", "bottomright", "bottomleft", "topleft"
# permet de lier la legende aux analyse de type "choix"
# permet de nommer les box (choix multiples / choix simple)
# Ajustement au rectangle d'affichage calculé sur l'emprise des isochrones

carte <- addLayersControl(
  map = carte,
  overlayGroups = c(
    ens,
    group_cercle,
    "NORD",
    "SUD"
  ),
  baseGroups = c(
    "Carte_Routière",
    "Carte_épurée"
  ),
  options = layersControlOptions(collapsed = F),
  position = "topright"
) %>%
  htmlwidgets::onRender("
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
                        }") %>%
  htmlwidgets::onRender("
                        function() {
                          $('.leaflet-control-layers-overlays').prepend('Magasins');
                          $('.leaflet-control-layers-list').prepend('Fond de carte');
                        }") %>%
  fitBounds(
    lng1 = zoom[1],
    lat1 = zoom[2],
    lng2 = zoom[3],
    lat2 = zoom[4]
  ) %>%
  hideGroup(c(
    ens_sec,
    ens_autre,
    group_cercle[-1],
    "NORD",
    "SUD"
  )) # Décoche les cases sélectionnées

carte
