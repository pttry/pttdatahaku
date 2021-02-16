
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
            - muuttujat, jossa vain yhtä aluetasoa, nimetään aluetason mukaan, esim. _seutukunta_name_. Muuttujat
              joissa useampaa aluetasoa nimetään _alue_name_ ja _alue_code_. Näin koska, jos muuttujassa on useita
              aluetasoja, sitä ei ole mieltä nimetä yhden aluetason mukaan. Tällöin _alue_ muuttujan nimessä myös
              kertoo käyttäjälle, että muuttujassa useita aluetasoja. Tiettyjen aluetasojen nimiä käytetään, koska
              jos muuttujassa vain yhtä aluetasoa, käyttäjä voi haluta lisätä muita aluetasoja omiin muuttujiin.
              Tällöin muuttujat on pystyttävä erottamaan toisistaan.
            - Aluekoodit etuliitteineen. Aluekoodit, jotta 1) koodista välittömästi näkee aluetason, 2) koodit ovat 
              yksiselitteisiä ja 3) koodit eivät koskaan eksy dataan muodossa double.
           
     - numerosarake nimellä "values"
  - muuttujatyypit
      - aikamuuttujat
            - "time"
            - Date -muodossa
      - kategoriset muuttujat
            - factor -muodossa
            - values sarakkeen selityssarake myös factor-muodossa.
      - ei lyhennetä numeerisia muuttujia esim. tuhansiksi, milj. 
  - missing values merkataan NA


## pxweb haut

- Aika ja aluemuuttujista kaikki anonyymisti (*)
- Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)
        
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
   - *pxweb_print_full_query* 
      - Kirjoittaa hakulistan taulun kaikille tiedoille.
      - `pxweb_print_full_query(url = statfi_url("StatFin", "vrm/tyokay/statfin_tyokay_pxt_115u.px"))`

