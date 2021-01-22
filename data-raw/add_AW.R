# Add Akava Works data

# Väestö
# ------
#
# - Väestön koulutusrakenne ([Väestön
#                                 koulutusrakenne](http://www.stat.fi/til/vkour/index.html))
# 12bs -- 15 vuotta täyttänyt väestö koulutusasteen, maakunnan, kunnan, sukupuolen ja ikäryhmän mukaan, 2007-2019
# pxweb_print_full_query(statfi_url("StatFin/kou/vkour/statfin_vkour_pxt_12bs.px"))
ptt_add_query(db_list_name = "aw_db",
              url = statfi_url("StatFin/kou/vkour/statfin_vkour_pxt_12bs.px"),
              query =
                list("Vuosi"=c("*"),
                   "Alue"=c("*"),
                   "Ikä"=c("SSS","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-"),
                   "Sukupuoli"=c("SSS","1","2"),
                   "Tiedot"=c("kaste100","kaste0","kaste10","kaste3","kaste4","kaste15","kaste5","kaste6","kaste7","kaste8","vktm")),
              call = "ptt_get_statfi(url, query, , check_classifications = FALSE)")

# ptt_db_update("aw_db", tables = "vkour_12bs")

#
# -   Väestön ikärakenne
# -   Huoltosuhde
# ([Väestörakenne](http://tilastokeskus.fi/til/vaerak/index.html))

# 11ra -- Tunnuslukuja väestöstä alueittain, 1990-2019
url_vaerak_11ra <- statfi_url("StatFin/vrm/vaerak/statfin_vaerak_pxt_11ra.px")
# pxweb_print_full_query(url_vaerak_11ra)
meta_vaerak_11ra <- pxweb::pxweb_get(url_vaerak_11ra)
alueet_kumk <- grep("KU|MK|SSS", meta_vaerak_11ra$variables[[1]]$values, value = TRUE)

ptt_add_query(db_list_name = "aw_db",
              url = url_vaerak_11ra,
              query =
                list("Vuosi" = c("*"),
                     "Alue" = alueet_kumk,
                     "Tiedot" = c("vaesto", "kokmuutos", "kokmuutos_p", "vaesto_alle15_p",
                                  "vaesto_15_64_p", "vaesto_yli64_p", "dem_huoltos", "tal_huoltos",
                                  "vaesto_keski_ika")))


# meta_vaerak_11ra$variables[[2]][c("values", "valueTexts")] %>% as.data.frame()
# meta_vaerak_11ra$variables[[2]][c("values")] %>% dput()

ptt_db_update("aw_db", tables = "vaerak_11ra")


#
# -   Väestön/työikäisen väestön muutos viimeisen 5-vuoden aikana
# ([Väestön ennakkotilasto](http://www.stat.fi/til/vamuu/index.html))
#
# -   Lapsiperheet ([Perheet](http://www.stat.fi/til/perh/index.html))



## Työmarkkinat

# 11pn -- Väestö työmarkkina-aseman ja maakunnan mukaan, 15-74-vuotiaat, 2011-2019
# pxweb_print_full_query(statfi_url("StatFin/tym/tyti/vv/statfin_tyti_pxt_11pn.px"))
ptt_add_query(db_list_name = "aw_db",
              url = statfi_url("StatFin/tym/tyti/vv/statfin_tyti_pxt_11pn.px"),
              query =
                list("Vuosi"=c("*"),
                     "Maakunta 2011"=c("*"),
                     "Tiedot"=c("Vaesto","Tyovoima","Tyolliset","Tyottomat","Tyollisyysaste_15_64","Tyottomyysaste","tyovoimaosuus")),
              call = "ptt_get_statfi(url, query, renames = c(Alue = \"Maakunta 2011\"), check_classifications = FALSE)")

ptt_db_update("aw_db", tables = "tyti_11pn")


## Tulot

#  Tulorakenne
# ([Verohallinnon tilastotietokanta](http://vero2.stat.fi/PXWeb/pxweb/fi/Vero/))

# 6.01 Yleisesti verovelvollisten merkittävimmät tuloerät alueittain
url_vero_tulot <- "http://vero2.stat.fi//PXWeb/api/v1/fi/Vero/Henkiloasiakkaiden_tuloverot/lopulliset/alue/tulot_102.px"
pxweb_print_full_query(url_vero_tulot)
ptt_add_query(db_list_name = "aw_db",
              url = url_vero_tulot,
              query =
                list("Verovuosi"=c("*"),
                     "Erä"=c("HVT_TULOT_10","HVT_TULOT_20","HVT_TULOT_50","HVT_TULOT_60","HVT_TULOT_70"),
                     "Alue"=c("*"),
                     "Tunnusluvut"=c("Sum","N")),
              call = "ptt_get_statfi(url, query, check_classifications = FALSE)")

ptt_db_update("aw_db", tables = "tyti_11pn")

k <- pxweb_interactive()
kk <- ptt_get_statfi(url, query, renames = c(Vuosi = "Verovuosi"), check_classifications = FALSE)
