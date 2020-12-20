
# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->


### Haettavat tiedot muokataan seuraavaan muotoon:

- Pitkä tibble
     - kaikki muuttujanimet vain pieniä kirjaimia ilman hyvää syytä isoille kirjaimille
     - aikamuuttujat
       - "time"
       - Date -muodossa
     - kategoriset muuttujat
       - factor -muodossa
             - Minun tämänhetkinen kokemus on että alueet faktoreina. Oisko jotain hyviä syitä miksi char ois parempi?
       - Aluemuuttujat
           - sekä koodi että nimi sarakkeet ("*_code", "*_name")
           - Ei "Alue"-nimistä muuttujaa
           - Aluemuuttujalla alueen nimi, esim kunta_code ja kunta_name
     - numerosarake nimellä "values"
       - PITÄISIKÖ MUUNTAA KAIKKI PERUSLUVUIKSI?
             - mikä on "perusluku"? Double?

- TIEDOSTOMUOTO?
     - .rds?




### pxweb haut

- Aika ja aluemuuttujista kaikki anonyymisti (*)
- Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)
- pxweb haku template/yhteinäinen koodi

- TÄÄLLÄ KOODIT AINEISTOJEN HAKUUN JA PÄIVITTÄMISEEN?
      - minä olen kirjoittanut koodit kullekin tarvitsemalleni
        pxwebin aineistolle erikseen. Tuntuvat aina vaativan vähän oman 
        koodinsa. Nämä koodit nimettäisiin pxwebin aineistonumerojen mukaan.
        
 ### Apufunktiot
   - *filter_region_level* pxwebistä taulukot antavat tiedot suoraan eri tasoilla aggregoitua päälekkäin samassa tiedostossa. Mulla on ollut käytössä funktio, joka erottelee tällaisesta aineistosta eri aggregointitasot omiin data.frameihin. 
