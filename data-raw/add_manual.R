
# Kuntien kiinteistöveroprosentit Kuntaliitto

url_kuntaliitto_verop <- "https://www.kuntaliitto.fi/sites/default/files/media/file/Liite5_Kuntien_veroprosentit_ja_efektiiviset%20veroasteet.xls"

temp_vero <- tempfile(fileext = ".xls")
download.file(url_kuntaliitto_verop, destfile = temp_vero, mode = "wb")

k <- readxl::read_xls(temp_vero, sheet = "Tuloveroprosentti") %>%
  mutate(alue_code = statficlassifications::set_region_codes(Kuntanro, "kunta_code"))
