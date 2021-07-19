
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->

`pttdatahaku` contains tools to import data from various sources, to
modify data to a standardized form and to construct data bases that can
be updated automatically.

To use standardized analysis tools, the data has to be in standardized
form. Unfortunately the data available from Statistics Finland and other
sources vary in its form. This package gives the tools to create a data
base with specified data sets and provides the tools and default ways of
tidying the data in a standard form. Special emphasis is on region
classifications.

## Installation

To install and start using the package:

``` r
install.packages("devtools")
devtools::install_github("https://github.com/pttry/pttdatahaku")
library(pttdatahaku)
```

## Data standardization

``` r
library(pttdatahaku)
```

## Haettavat tiedot muokataan seuraavaan muotoon:

-   Pitkä tibble
-   muuttujanimet
    -   vain pieniä kirjaimia ilman hyvää syytä isoille kirjaimille
    -   ei tyhjää välimerkkiä, sen sijaan alaviiva
    -   Aluemuuttujat - sekä koodi että nimi sarakkeet
        ("\*\_code“,”\**name*“), e.g. *(seutu)kunta\_code*,
        *(maa)kunta\_name*. - ei”Alue“-nimistä muuttujaa,
        aluemuuttujalla alueen nimi - numerosarake nimellä”values"
-   muuttujatyypit
    -   aikamuuttujat - “time” - Date -muodossa
    -   kategoriset muuttujat - factor -muodossa - values sarakkeen
        selityssarake kanssa? Se sarake ei ole periaatteessa kategorinen
        muuttuja, joten sanoisin ei.
    -   ei lyhennetä numeerisia muuttujia esim. tuhansiksi, milj.
-   missing values merkataan NA

## Naming

## pxweb haut

-   Aika ja aluemuuttujista kaikki anonyymisti (\*)

-   Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)

-   Täällä koodit aineistojen hakuun ja päivittämiseen? - kullekin
    pxwebin taululle oma valmis hakukoodi? - Nämä koodit nimettäisiin
    pxwebin aineistonumerojen mukaan.

Hakufunktio: *ptt\_get\_statfi* muuntaat tiedostot oikeaan muotoon

## Tietojen tallentaminen ja lukeminen

-   Tulevaisuudessa tietokanta? Nyt projektin data-kansioon
-   Funktiot:
    -   ptt\_save\_data()
    -   ptt\_read\_data()
-   Datatiedostojen nimet table\_code: e.g. tyonv\_1001

## Apufunktiot

\#\#\# Olemassa - *statfi\_url* - Koko statfi osoite loppuosan
perusteella. - statfi\_url(“StatFin”,
“kou/vkour/statfin\_vkour\_pxt\_12bq.px”) - *statfi\_parse\_url* -
Statfi api:n osoite taulun web sivun osoitteen perusteella. -
statfi\_parse\_url(“<https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/>”)
- *pxweb\_print\_full\_query* - Kirjoittaa hakulistan taulun kaikille
tiedoille. - pxweb\_print\_full\_query(url = statfi\_url(“StatFin”,
“vrm/tyokay/statfin\_tyokay\_pxt\_115u.px”))\` -
*pxweb\_print\_code\_full\_query*, *pxweb\_print\_code\_full\_query\_c*
- Kirjoittaa hakukoodin taulun kaikille tiedoille. - Toimii sekä api
että web osoitteella -
pxweb\_print\_code\_full\_query(“<https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/>”)
- \_c-versio kirjottaa leikepöydälle
