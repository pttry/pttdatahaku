# Add Akava Works data

# Väestö
# ------
#
# - Väestön koulutusrakenne ([Väestön
#                                 koulutusrakenne](http://www.stat.fi/til/vkour/index.html))
# 12bs -- 15 vuotta täyttänyt väestö koulutusasteen, maakunnan, kunnan, sukupuolen ja ikäryhmän mukaan, 2007-2019
# pxweb_print_full_query(statfi_url("StatFin/kou/vkour/statfin_vkour_pxt_12bs.px"))
ptt_add_query("aw_db",
              "vkour_12bq",
              url = statfi_url("StatFin/kou/vkour/statfin_vkour_pxt_12bs.px"),
              query_list =
                list("Vuosi"=c("*"),
                   "Alue"=c("*"),
                   "Ikä"=c("SSS","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-"),
                   "Sukupuoli"=c("SSS","1","2"),
                   "Tiedot"=c("kaste100","kaste0","kaste10","kaste3","kaste4","kaste15","kaste5","kaste6","kaste7","kaste8","vktm")),
              call = "ptt_get_statfi(url, query, , check_classifications = FALSE)")

ptt_db_update("aw_db")

#
# -   Väestön ikärakenne
# ([Väestörakenne](http://tilastokeskus.fi/til/vaerak/index.html))
#
# -   Huoltosuhde
#
# -   Väestön/työikäisen väestön muutos viimeisen 5-vuoden aikana
# ([Väestön ennakkotilasto](http://www.stat.fi/til/vamuu/index.html))
#
# -   Lapsiperheet ([Perheet](http://www.stat.fi/til/perh/index.html))
