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


ptt_db_update("aw_db", tables = "vaerak_11ra")


#
# -   Väestön/työikäisen väestön muutos viimeisen 5-vuoden aikana
# ([Väestön ennakkotilasto](http://www.stat.fi/til/vamuu/index.html))

## Väestöennuste
# 128v -- Väestöennuste 2019: Väestö iän ja sukupuolen mukaan alueittain, 2019-2040
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__vaenn/statfin_vaenn_pxt_128v.px/
url_vaenn_128v <- statfi_url("StatFin/vrm/vaenn/statfin_vaenn_pxt_128v.px")
# pxweb_print_full_query(url_vaenn_128v)

ptt_add_query(db_list_name = "aw_db",
              url = url_vaenn_128v,
              query =
                list("Vuosi" = c("*"),
                     "Alue" = c("*"),
                     "Sukupuoli"=c("SSS"),
                     "Ikä"=c("*"),
                     "Tiedot"=c("vaesto_e19")),
              call = "ptt_get_statfi(url, query) %>% add_regional_agg()")


ptt_db_update("aw_db", tables = "vaenn_128v")

# Ika aggregoitu
ptt_read_data("vaenn_128v") %>%
  mutate(ika2 = readr::parse_number(as.character(ika_code), na = "SSS"),
         ika_name = case_when(
           is.na(ika2) ~ "Yhteensä",
           ika2 < 15   ~ "0-14",
           ika2 < 65   ~ "15-64",
           TRUE        ~ "65-"
           ),
         ika_name = forcats::as_factor(ika_name),
         ika_code = recode(ika_name, "Yhteensä" = "SSS")
         ) %>%
  select(-ika2) %>%
  group_by(across(!values)) %>%
  summarise(values = sum(values), .groups = "drop") %>%
  ptt_save_data("vaenn_128v_agg")


#
# -   Lapsiperheet ([Perheet](http://www.stat.fi/til/perh/index.html))
# http://www.stat.fi/til/perh/index.html
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__perh/statfin_perh_pxt_12c1.px/
url_perh_12c1 <- statfi_url("StatFin/vrm/perh/statfin_perh_pxt_12c1.px")
# pxweb_print_full_query(url_perh_12c1)

ptt_add_query(db_list_name = "aw_db",
              url = url_perh_12c1,
              query =
                list("Vuosi" = c("*"),
                     "Alue" = alueet_kumk,
                     "Perhetyyppi"=c("SSS"),
                     "Tiedot"=c("perhlkm","hloperh","perhkoko","lapsiperhe","hloperh_a18","perhkoko_a18")),
              call = "ptt_get_statfi(url, query)")


ptt_db_update("aw_db", tables = "perh_12c1")



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


# -   Työllisyyden ja työpaikkojen rakenne
# ([Työssäkäynti](http://www.tilastokeskus.fi/til/tyokay/index.html))
#
# -   Ammattirakenne
#
# -   Koulutusrakenne
#
# -   Elinkeinorakenne
#
# -   Teollisuus / palvelut
# 115h -- Alueella työssäkäyvät (työpaikat) alueen, toimialan (TOL 2008), sukupuolen ja vuoden mukaan, 2007-2018
url_tyokay_115h <- statfi_url("StatFin/vrm/tyokay/statfin_tyokay_pxt_115h.px")
# pxweb_print_full_query(url_tyokay_115h)

ptt_add_query(db_list_name = "aw_db",
              url = url_tyokay_115h,
              query =
                list("Vuosi" = c("*"),
                     "Työpaikan alue" = c("*"),
                     "Toimiala"=c("SSS","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","X"),
                     "Sukupuoli"=c("SSS"),
                     "Tiedot"=c("tyolliset3")),
              call = "ptt_get_statfi(url, query, renames = c(Alue = \"Työpaikan alue\")) %>% add_regional_agg()")


ptt_db_update("aw_db", tables = "tyokay_115h")

# toimila aggregoitu
ptt_read_data("tyokay_115h") %>%
  mutate(toimiala_code =
           case_when(
             toimiala_code == "SSS"  ~ "SSS",
             toimiala_code %in% c("A","B")   ~ "A_B",
             toimiala_code %in% c("C")   ~ "C",
             toimiala_code %in% c("F")   ~ "F",
             toimiala_code %in% c("O", "P", "Q")   ~ "O_Q",
             TRUE        ~ "S"
         ),
         toimiala_code = forcats::as_factor(toimiala_code),
         toimiala_name = forcats::fct_recode(toimiala_code,
                                             "Yhteensä" = "SSS",
                                             "Alkutuotanto" = "A_B",
                                             "Teollisuus" = "C",
                                             "Rakentaminen" = "F",
                                             "Julk. hallinto, koulutus ja sote" = "O_Q",
                                             "Muut palvelut" = "S"),

  ) %>%
  group_by(across(!values)) %>%
  summarise(values = sum(values), .groups = "drop") %>%
  ptt_save_data("tyokay_115h_agg")

#
# -   Yksityinen / julkinen
#  115j -- Alueella työssäkäyvät (työpaikat) alueen, työnantajasektorin, sukupuolen ja vuoden mukaan, 1987-2018
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__tyokay/statfin_tyokay_pxt_115j.px/

url_tyokay_115j <- statfi_url("StatFin/vrm/tyokay/statfin_tyokay_pxt_115j.px")
# pxweb_print_full_query(url_tyokay_115j)

ptt_add_query(db_list_name = "aw_db",
              url = url_tyokay_115j,
              query =
                list("Vuosi" = c("*"),
                     "Työpaikan alue" = c("*"),
                     "Työnantajasektori"=c("S","1","2","3","7","8","9"),
                     "Sukupuoli"=c("SSS"),
                     "Tiedot"=c("tyolliset3")),
              call = "ptt_get_statfi(url, query, renames = c(Alue = \"Työpaikan alue\")) %>% add_regional_agg()")


ptt_db_update("aw_db", tables = "tyokay_115j")

#
# -   Avoimet työpaikat ([Työvälitystilasto,
#                         TEM](https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__tym__tyonv/))




## Tulot

#  Tulorakenne
# ([Verohallinnon tilastotietokanta](http://vero2.stat.fi/PXWeb/pxweb/fi/Vero/))

# 6.01 Yleisesti verovelvollisten merkittävimmät tuloerät alueittain
url_vero_tulot_102 <- "http://vero2.stat.fi//PXWeb/api/v1/fi/Vero/Henkiloasiakkaiden_tuloverot/lopulliset/alue/tulot_102.px"
# meta_vero_tulot_102 <- pxweb::pxweb_get(url_vero_tulot_102)
# meta_vero_tulot_102$variables[[2]][c("values", "valueTexts")] %>% as.data.frame()
# pxweb_print_full_query(url_vero_tulot_102)
ptt_add_query(db_list_name = "aw_db",
              url = url_vero_tulot_102,
              query =
                list("Verovuosi"=c("*"),
                     "Erä"=c("HVT_TULOT_10","HVT_TULOT_20","HVT_TULOT_50","HVT_TULOT_60","HVT_TULOT_70", "HVT_TULOT_80", "HVT_TULOT_270", "HVT_TULOT_280"),
                     "Alue"=c("*"),
                     "Tunnusluvut"=c("Sum","N")),
              call = "ptt_get_statfi(url, query, check_classifications = FALSE,
                      renames = c(Vuosi = \"Verovuosi\")) %>%
                      statficlassifications::set_region_codes(\"alue_code\") %>%
                      agg_abolished_mun()")

ptt_db_update("aw_db", tables = "tulot_102")



# -   Keskimääräisten tulojen kehitys
#  ([Verohallinnon tilastotietokanta](http://vero2.stat.fi/PXWeb/pxweb/fi/Vero/))

# Koulutusasteittain
# 6.08 (Verovuosi 2019) Yleisesti verovelvollisten tulot, vähennykset ja verot alueittain ja koulutustason mukaan
# http://vero2.stat.fi/PXWeb/pxweb/fi/Vero/Vero__Henkiloasiakkaiden_tuloverot__lopulliset__alue__Verovuosi%202019/koulutus_103_2019.px/
url_vero_koulutus_103_2019 <- "http://vero2.stat.fi//PXWeb/api/v1/fi/Vero/Henkiloasiakkaiden_tuloverot/lopulliset/alue/Verovuosi%202019/koulutus_103_2019.px"
# meta_vero_tulot_102 <- pxweb::pxweb_get(url_vero_koulutus_103_2019)

# pxweb_print_full_query(url_vero_koulutus_103_2019)
ptt_add_query(db_list_name = "aw_db",
              url = url_vero_koulutus_103_2019,
              query =
                list("Verovuosi"=c("*"),
                     "Erä"=c("HVT_TULOT_10","HVT_TULOT_20","HVT_TULOT_50","HVT_TULOT_60","HVT_TULOT_70", "HVT_TULOT_80"),
                     "Alue"=c("*"),
                     "Koulutusaste"=c("SSS","X","9","3-8","3","4","5","6","7","8"),
                     "Tunnusluvut"=c("Sum","N", "Mean","Median")),
              call = "ptt_get_statfi(url, query, check_classifications = FALSE,
                      renames = c(Vuosi = \"Verovuosi\")) %>%
                      statficlassifications::set_region_codes(\"alue_code\") %>%
                      agg_abolished_mun()")

ptt_db_update("aw_db", tables = "koulutus_103_2019")



#
# -   Kotitalouksien käytettävissä olevat tulot
# ([Aluetilinpito](http://www.stat.fi/til/altp/index.html))

## 12bf -- Kotitalouksien tulot ja menot alueittain, vuosittain, 2000-2018
url_altp_12bf <- statfi_url("StatFin/kan/altp/statfin_altp_pxt_12bf.px/")
# pxweb_print_full_query(url_altp_12bf)
ptt_add_query(db_list_name = "aw_db",
              url = url_altp_12bf,
              query =
                list("Alue"=c("*"),
                     "Vuosi"=c("*"),
                     "Taloustoimi"=c("B6N"),
                     "Tiedot"=c("CP"),
                     "Sektori"=c("S14")),
              call = "ptt_get_statfi(url, query)")

ptt_db_update("aw_db", tables = "altp_12bf")

# Yritykset ja tuotanto
# ---------------------
#
#   -   Yritysdynamiikka ([Aloittaneet ja lopettaneet
#                          yritykset](http://www.stat.fi/til/aly/index.html))
# 11yq -- Aloittaneet ja lopettaneet yritykset kunnittain ja toimialaluokituksen TOL 2008 mukaisesti, 2013Q1-2020Q4
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__yri__aly/statfin_aly_pxt_11yq.px/
url_aly_11yq <- statfi_url("StatFin/yri/aly/statfin_aly_pxt_11yq.px/")
# pxweb_print_full_query(url_aly_11yq)
ptt_add_query(db_list_name = "aw_db",
              url = url_aly_11yq,
              query =
                list("Kunta"=c("*"),
                     "Vuosineljännes"=c("*"),
                     "Toimiala" =c ("SSS"),
                     "Tiedot"=c("aloittaneita","lopettaneita","yrityskanta")),
              call = "ptt_get_statfi(url, query, renames = c(Alue = \"Kunta\")) %>%
                        agg_yearly() %>%
                        add_regional_agg()")

ptt_db_update("aw_db", tables = "aly_11yq")



#
# -   Yritystoiminnan rakenne ([Alueellinen
#                               yritystoimintatilasto](http://www.stat.fi/til/alyr/index.html))
#
# -   Tutkimus ja kehitysmenot / -henkilöstö ([Tutkimus- ja
#                                              kehittämistoiminta](http://www.stat.fi/til/tkke/index.html))
# 125t -- Tutkimus- ja kehittämistoiminnan menot, henkilöstö ja työvuodet alueittain, 1995-2019
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__ttt__tkke__yht/statfin_tkke_pxt_125t.px/
# Vain Maakunnat epätavallisten aluekoodien takia

url_tkke_125t <- statfi_url("StatFin/ttt/tkke/yht/statfin_tkke_pxt_125t.px/")
# pxweb_print_full_query(url_tkke_125t)
ptt_add_query(db_list_name = "aw_db",
              url = url_tkke_125t,
              query =
                list("Alue"=c("*"),
                     "Vuosi"=c("*"),
                     "Sektori"=c("SSS","yri","julk_yvt","korkeak"),
                     "Tiedot"=c("tk_menot","tk_hlomaara","tk_htv")),
              call = "ptt_get_statfi(url, query, check_classifications = FALSE) %>%
                        select(-alue_code) %>%
                        mutate(alue_name = tolower(alue_name)) %>%
                        left_join(statficlassifications::nonstandard_region_names_key, by = \"alue_name\") %>%
                        mutate(alue_name = statficlassifications::codes_to_names(alue_code)) %>%
                        filter(!is.na(alue_code)) %>%
                        relocate(alue_code, .after = time)")

ptt_db_update("aw_db", tables = "tkke_125t")




#
# -   Tuotannon taso
# ([Aluetilinpito](http://www.stat.fi/til/altp/index.html))

## BKT per asukas
url_altp_12bc <- statfi_url("StatFin/kan/altp/statfin_altp_pxt_12bc.px/")
# pxweb_print_full_query(url_altp_12bc)
ptt_add_query(db_list_name = "aw_db",
              url = url_altp_12bc,
              query =
                list("Alue"=c("*"),
                          "Vuosi"=c("*"),
                          "Tiedot"=c("GDPcap","GDPind","GDPind15","GDPind28","GDPvv2010","EP","GDPvv2015")),
              call = "ptt_get_statfi(url, query)")

ptt_db_update("aw_db", tables = "altp_12bc")

## Arvonlisäys

url_altp2 <- statfi_url("StatFin/kan/altp/statfin_altp_pxt_12bd.px/")
# pxweb_print_full_query(url_altp2)
ptt_add_query(db_list_name = "aw_db",
              url = url_altp2,
              query =
                list("Alue"=c("*"),
                     "Vuosi"=c("*"),
                     "Taloustoimi"=c("B1GPH"),
                     "Toimiala"=c("SSS"),
                     "Sektori"=c("S1"),
                     "Tiedot"=c("CP","FP")),
              call = "{dat0 <- ptt_get_statfi(url, query)

                        dat <- dat0 %>%
                          select(!tiedot_name) %>%
                          pivot_wider(names_from = tiedot_code, values_from = values) %>%
                          group_by(across(where(is.factor))) %>%
                          mutate(VV15 = statfitools::fp(CP, FP, lubridate::year(time), 2015)) %>%
                          ungroup() %>%
                          pivot_longer(c(CP, FP, VV15), names_to = \"tiedot\", values_to = \"values\") %>%
                          codes2names(codes_names = attr(dat0, \"codes_names\")) %>%
                          mutate(tiedot_name = forcats::fct_explicit_na(tiedot_name, \"Vuoden 2015 hinnoin, miljoonaa euroa\")) %>%
                          relocate(values, .after = last_col())

                        attr(dat, \"citation\") <- attr(dat0, \"citation\")
                        attr(dat, \"codes_names\") <- attr(dat0, \"codes_names\")
                        dat}")

ptt_db_update("aw_db", tables = "altp_12bd")


# Asuntomarkkinat
# ---------------
#
#   -   Asuntomarkkinat ([Osakeasuntojen
#                         hinnat](http://www.stat.fi/til/ashi/index.html))
#
# -   Hinnat
#
# -   Kauppamäärät
# 112l -- Vanhojen osakeasuntojen hintaindeksi (2015=100) ja kauppojen lukumäärät, vuositasolla, 2015-2019
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__asu__ashi__vv/statfin_ashi_pxt_112l.px/
url_ashi_112l <- statfi_url("StatFin/asu/ashi/vv/statfin_ashi_pxt_112l.px")
# pxweb_print_full_query(url_ashi_112l)
ptt_add_query(db_list_name = "aw_db",
              url = url_ashi_112l,
              query =
                list("Alue"=c("*"),
                     "Vuosi"=c("*"),
                     "Talotyyppi"=c("0","1","3"),
                     "Huoneluku"=c("00","01","02","03"),
                     "Tiedot"=c("keskihinta","ketjutettu_lv","vmuutos_lv","realind_lv","vmuutos_realind_lv","lkm_julk")),
              call = "ptt_get_statfi(url, query)")

ptt_db_update("aw_db", tables = "ashi_112l")

#
# -   Asumisen rakenne ([Asunnot ja
#                        asuinolot](http://www.stat.fi/til/asas/index.html))
#
# -   Kerros/omakoti/rivitalo
#
# -   Omistus/vuokra
# 115y -- Asuntokunnat ja asuntoväestö hallintaperusteen, talotyypin ja huoneluvun mukaan, 2005-2019
# http://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__asu__asas/statfin_asas_pxt_115y.px/
url_asas_115y <- statfi_url("StatFin/asu/asas/statfin_asas_pxt_115y.px/")
# pxweb_print_full_query(url_asas_115y)
ptt_add_query(db_list_name = "aw_db",
              url = url_asas_115y,
              query =
                list("Alue"=c("*"),
                     "Vuosi"=c("*"),
                     "Talotyyppi"=c("S","1","2","3","4"),
                     "Huoneiden lkm keittiö pl."=c("S"),
                     "Tiedot"=c("Lkm","asuntovaestoa"),
                     "Hallintaperuste"=c("s","1-2","3-5","3-4","5","6","7-9")),
              call = "ptt_get_statfi(url, query)")

ptt_db_update("aw_db", tables = "asas_115y")

#
# -   Asuntojen koko


