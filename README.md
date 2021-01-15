
# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->


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



        
## Apufunktiot
  ### Olemassa
   - *clean_names*
   - *make_names*
   - *clean_times*
   - *statfi_url* 
      - Koko statfi osoite loppuosan perusteella.
      - statfi_url("StatFin", "kou/vkour/statfin_vkour_pxt_12bq.px")
   - *pxweb_print_full_query* 
      - Kirjoittaa hakulistan taulun kaikille tiedoille.
      - `pxweb_print_full_query(url = statfi_url("StatFin", "vrm/tyokay/statfin_tyokay_pxt_115u.px"))`
  ### Suunnitteilla
   - *filter_region_level* tällä hetkellä paketissa statfiLaborMarkets. pxwebistä taulukot antavat tiedot suoraan eri tasoilla aggregoitua päälekkäin samassa tiedostossa. Mulla on ollut käytössä funktio, joka erottelee tällaisesta aineistosta eri aggregointitasot omiin data.frameihin. 
   - Jos aineistot säilötään jollain palvelimella, tarvitaanko oma funktio, joka hakee aineistoja tältä palvelimelta?
   - Funktio joka hakee datalähteen kuvioihin. Pystyisikö datalähde kulkea datan mukana esimerkiksi attribuuttina. 
        - Datalähteen muoto? StatFin ja taulun numero?
        - voisi olla myös jotain mitä *ptt_get_statfi* automaattisesti aina tekee
        - ggptt voisi osata ottaa tämän attribuutin suoraan ggplot-funktioon syötetystä datasta ja luoda siitä captionin. 
