
# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->


### Haettavat tiedot muokataan seuraavaan muotoon:

- Pitkä tibble
     - kaikki muuttujanimet vain pieniä kirjaimia ilman hyvää syytä isoille kirjaimille
     - muuttujatnimissä ei tyhjää välimerkkiä, sen sijaan alaviiva
     - aikamuuttujat
       - "time"
       - Date -muodossa
     - kategoriset muuttujat
       - factor -muodossa
             - Minun tämänhetkinen kokemus on että alueet faktoreina. Oisko jotain hyviä syitä miksi char ois parempi?
       - Aluemuuttujat
           - sekä koodi että nimi sarakkeet ("*_code", "*_name_")
           - Ei "Alue"-nimistä muuttujaa
           - Aluemuuttujalla alueen nimi, esim kunta_code ja kunta_name
     - numerosarake nimellä "values"
       - PITÄISIKÖ MUUNTAA KAIKKI PERUSLUVUIKSI?
             - mikä on "perusluku"? Double?
             - Mittayksikkö tässä hain. Ettei käytettäisi miljoonia, tuhansia, ym, vaan muunnettaisiin haun yhteydessä, niin että ei tarvisi arvailla yksikköä. 


### pxweb haut

- Aika ja aluemuuttujista kaikki anonyymisti (*)
- Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)
- pxweb haku template/yhteinäinen koodi

- TÄÄLLÄ KOODIT AINEISTOJEN HAKUUN JA PÄIVITTÄMISEEN?
      - minä olen kirjoittanut koodit kullekin tarvitsemalleni
        pxwebin aineistolle erikseen. Tuntuvat aina vaativan vähän oman 
        koodinsa. Nämä koodit nimettäisiin pxwebin aineistonumerojen mukaan.
        
Hakufuktion:
  *ptt_get_statfi* muuntaat tiedostot oikeaan muotoon
        
 ### Apufunktiot
   - *filter_region_level* tällä hetkellä paketissa statfiLaborMarkets. pxwebistä taulukot antavat tiedot suoraan eri tasoilla aggregoitua päälekkäin samassa tiedostossa. Mulla on ollut käytössä funktio, joka erottelee tällaisesta aineistosta eri aggregointitasot omiin data.frameihin. 
   - *clean_names*
   - *make_names*
   - *clean_times*
   - Jos aineistot säilötään jollain palvelimella, tarvitaanko oma funktio, joka hakee aineistoja tältä palvelimelta?
