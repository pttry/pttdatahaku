
# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->


## Asennus

devtools::install_github("https://github.com/pttry/pttdatahaku")

## Haettavat tiedot muokataan seuraavaan muotoon:

 - Pitkä tibble
 - muuttujanimet
     - vain pieniä kirjaimia ilman hyvää syytä isoille kirjaimille
     - ei tyhjää välimerkkiä, sen sijaan alaviiva
     - Aluemuuttujat
            - sekä koodi että nimi sarakkeet ("*_code", "*_name_"), e.g. _(seutu)kunta_code_, _(maa)kunta_name_. 
            - ei "Alue"-nimistä muuttujaa, aluemuuttujalla alueen nimi
            - numerosarake nimellä "values"
  - muuttujatyypit
      - aikamuuttujat
            - "time"
            - Date -muodossa
      - kategoriset muuttujat
            - factor -muodossa
            - values sarakkeen selityssarake kanssa? Se sarake ei ole periaatteessa kategorinen muuttuja, joten sanoisin ei.
      - ei lyhennetä numeerisia muuttujia esim. tuhansiksi, milj. 
  - missing values merkataan NA


## pxweb haut

- Aika ja aluemuuttujista kaikki anonyymisti (*)
- Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)

- Täällä koodit aineistojen hakuun ja päivittämiseen?
      - kullekin pxwebin taululle oma valmis hakukoodi?
      - Nämä koodit nimettäisiin pxwebin aineistonumerojen mukaan.
        
Hakufunktio:
  *ptt_get_statfi* muuntaat tiedostot oikeaan muotoon
  
## Tietojen tallentaminen ja lukeminen

- Tulevaisuudessa tietokanta? Nyt projektin data-kansioon
- Funktiot:
   - ptt_save_data()
   - ptt_read_data()
- Datatiedostojen nimet table_code: e.g. tyonv_1001



        
## Apufunktiot
  ### Olemassa
   - *statfi_url* 
      - Koko statfi osoite loppuosan perusteella.
      - statfi_url("StatFin", "kou/vkour/statfin_vkour_pxt_12bq.px")
   - *statfi_parse_url*
      - Statfi api:n osoite taulun web sivun osoitteen perusteella.
      - statfi_parse_url("https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
   - *pxweb_print_full_query* 
      - Kirjoittaa hakulistan taulun kaikille tiedoille.
      - pxweb_print_full_query(url = statfi_url("StatFin", "vrm/tyokay/statfin_tyokay_pxt_115u.px"))`
   - *pxweb_print_code_full_query*, *pxweb_print_code_full_query_c*
      - Kirjoittaa hakukoodin taulun kaikille tiedoille.
      - Toimii sekä api että web osoitteella
      - pxweb_print_code_full_query("https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
      - _c-versio kirjottaa leikepöydälle
      

