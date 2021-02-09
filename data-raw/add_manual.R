
# Kuntien tuloveroprosentit Kuntaliitto

library(dplyr)
library(tidyr)

url_kuntaliitto_verop <- "https://www.kuntaliitto.fi/sites/default/files/media/file/Liite5_Kuntien_veroprosentit_ja_efektiiviset%20veroasteet.xls"

temp_vero <- tempfile(fileext = ".xls")
download.file(url_kuntaliitto_verop, destfile = temp_vero, mode = "wb")

kl_tverop <- readxl::read_xls(temp_vero, sheet = "Tuloveroprosentti") %>%
  mutate(alue_code = statficlassifications::set_region_codes(Kuntanro, region_level = "kunta"),
         alue_name = statficlassifications::codes_to_names(alue_code),
         tiedot_code = "tverop",
         tiedot_name = "Tuloveroprosentti") %>%
  select(-Kuntanro, -Kunta) %>%
  pivot_longer(!c(alue_code, alue_name, tiedot_code, tiedot_name), names_to = "vuosi", values_to = "values") %>%
  statfitools::clean_times2() %>%
  relocate(time)

ptt_save_data(kl_tverop)
