
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

## Installation and set up

To install and start using the package:

``` r
install.packages("devtools")
devtools::install_github("https://github.com/pttry/pttdatahaku")
library(pttdatahaku)
```

Currently the databases are in teams folder “Pellervon taloustutkimus -
Datapankki/Tietokanta folder”. This folder must be synced.

## How to Use

## Browsing data bases

To list all data sets in the data base, use `ptt_search_data` without
arguments. To search, you can set a search term.

``` r
ptt_search_data()
#>  [1] "altp_12bc"         "altp_12bd"         "altp_12bf"        
#>  [4] "altp_12bg"         "aly_11yq"          "alyr_11ft"        
#>  [7] "asas_115y"         "ashi_112l"         "atp_11n1"         
#> [10] "kl_tverop"         "koulutus_103_2019" "kta_12ml"         
#> [13] "ntp_132h"          "perh_12c1"         "test_dat"         
#> [16] "test2"             "tkke_125t"         "tulot_102"        
#> [19] "tyokay_115h"       "tyokay_115h_agg"   "tyokay_115j"      
#> [22] "tyokay_115s"       "tyonv_1001"        "tyonv_1270"       
#> [25] "tyonv_12r5"        "tyonv_12ti"        "tyonv_12tk"       
#> [28] "tyonv_12tt"        "tyonv_12tv"        "tyonv_1310"       
#> [31] "tyonv_1370"        "tyonv_2205"        "tyti_11af"        
#> [34] "tyti_11ag"         "tyti_11c9"         "tyti_11pn"        
#> [37] "tyti_135y"         "tyti_135z"         "vaenn_128v"       
#> [40] "vaenn_128v_agg"    "vaerak_11ra"       "verot_maksut_102" 
#> [43] "vkour_12bq"        "vkour_12bs"
ptt_search_data("tyonv")
#>  [1] "tyonv_1001" "tyonv_1270" "tyonv_12r5" "tyonv_12ti" "tyonv_12tk"
#>  [6] "tyonv_12tt" "tyonv_12tv" "tyonv_1310" "tyonv_1370" "tyonv_2205"
```

## Reading data from a database

Use `ptt_read_data` to read data from a data base.

``` r
data <- ptt_read_data("tyonv_1001")
head(data)
#> # A tibble: 6 x 6
#>   time       alue_code tiedot_code alue_name tiedot_name                  values
#>   <date>     <fct>     <fct>       <fct>     <fct>                         <dbl>
#> 1 2006-01-01 SSS       HAKIJAT     KOKO MAA  Työnhakijoita laskentapäi~   5.01e5
#> 2 2006-01-01 SSS       TYOTTOMAT   KOKO MAA  Työttömät                    2.78e5
#> 3 2006-01-01 SSS       TYOVOIMA    KOKO MAA  Työvoima                     2.56e6
#> 4 2006-01-01 SSS       TYOTOSUUS   KOKO MAA  Työttömien osuus             1.09e1
#> 5 2006-01-01 SSS       TH2         KOKO MAA  Työttömät miehet             1.51e5
#> 6 2006-01-01 SSS       TH3         KOKO MAA  Työttömät naiset             1.28e5
```

## Saving Data

Do not save data to database manually/interactively but use the database
lists. See Section Creating Databases.

## Importing Data from Statistics Finland

To import data, you need an url. Function `statfi_parse_url` transforms
the addresses in the gui of pxweb to the addresses of api of the pxweb:

``` r
gui_url <- "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__kou__vkour/statfin_vkour_pxt_12bq.px/"
api_url <- statfi_parse_url(gui_url)
api_url
#> [1] "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px"
```

Given url, you can construct queries using `pxweb_print_full_query`:

``` r
my_url <- api_url
pxweb_print_full_query(my_url)
#> pxweb_query_list <- 
#>   list("Vuosi"=c("*"),
#>        "Alue"=c("SSS","KU020","KU005","KU009","KU010","KU016","KU018","KU019","KU035","KU043","KU046","KU047","KU049","KU050","KU051","KU052","KU060","KU061","KU062","KU065","KU069","KU071","KU072","KU074","KU075","KU076","KU077","KU078","KU079","KU081","KU082","KU086","KU111","KU090","KU091","KU097","KU098","KU099","KU102","KU103","KU105","KU106","KU108","KU109","KU139","KU140","KU142","KU143","KU145","KU146","KU153","KU148","KU149","KU151","KU152","KU165","KU167","KU169","KU170","KU171","KU172","KU176","KU177","KU178","KU179","KU181","KU182","KU186","KU202","KU204","KU205","KU208","KU211","KU213","KU214","KU216","KU217","KU218","KU224","KU226","KU230","KU231","KU232","KU233","KU235","KU236","KU239","KU240","KU320","KU241","KU322","KU244","KU245","KU249","KU250","KU256","KU257","KU260","KU261","KU263","KU265","KU271","KU272","KU273","KU275","KU276","KU280","KU284","KU285","KU286","KU287","KU288","KU290","KU291","KU295","KU297","KU300","KU301","KU304","KU305","KU312","KU316","KU317","KU318","KU398","KU399","KU400","KU407","KU402","KU403","KU405","KU408","KU410","KU416","KU417","KU418","KU420","KU421","KU422","KU423","KU425","KU426","KU444","KU430","KU433","KU434","KU435","KU436","KU438","KU440","KU441","KU475","KU478","KU480","KU481","KU483","KU484","KU489","KU491","KU494","KU495","KU498","KU499","KU500","KU503","KU504","KU505","KU508","KU507","KU529","KU531","KU535","KU536","KU538","KU541","KU543","KU545","KU560","KU561","KU562","KU563","KU564","KU309","KU576","KU577","KU578","KU445","KU580","KU581","KU599","KU583","KU854","KU584","KU588","KU592","KU593","KU595","KU598","KU601","KU604","KU607","KU608","KU609","KU611","KU638","KU614","KU615","KU616","KU619","KU620","KU623","KU624","KU625","KU626","KU630","KU631","KU635","KU636","KU678","KU710","KU680","KU681","KU683","KU684","KU686","KU687","KU689","KU691","KU694","KU697","KU698","KU700","KU702","KU704","KU707","KU729","KU732","KU734","KU736","KU790","KU738","KU739","KU740","KU742","KU743","KU746","KU747","KU748","KU791","KU749","KU751","KU753","KU755","KU758","KU759","KU761","KU762","KU765","KU766","KU768","KU771","KU777","KU778","KU781","KU783","KU831","KU832","KU833","KU834","KU837","KU844","KU845","KU846","KU848","KU849","KU850","KU851","KU853","KU857","KU858","KU859","KU886","KU887","KU889","KU890","KU892","KU893","KU895","KU785","KU905","KU908","KU092","KU915","KU918","KU921","KU922","KU924","KU925","KU927","KU931","KU934","KU935","KU936","KU941","KU946","KU976","KU977","KU980","KU981","KU989","KU992"),
#>        "Ikä"=c("SSS","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-"),
#>        "Sukupuoli"=c("SSS","1","2"),
#>        "Koulutusaste"=c("SSS","3T8","3","4","5","6","7","8","9"),
#>        "Tiedot"=c("vaesto"))
```

Given url, you can print a code that imports the data in the url:

``` r
pxweb_print_code_full_query(my_url)
#> dat_vkour_12bq <- ptt_get_statfi(
#>   url = "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px",
#>   query = 
#>     list("Vuosi"=c("*"),
#>        "Alue"=c("SSS","KU020","KU005","KU009","KU010","KU016","KU018","KU019","KU035","KU043","KU046","KU047","KU049","KU050","KU051","KU052","KU060","KU061","KU062","KU065","KU069","KU071","KU072","KU074","KU075","KU076","KU077","KU078","KU079","KU081","KU082","KU086","KU111","KU090","KU091","KU097","KU098","KU099","KU102","KU103","KU105","KU106","KU108","KU109","KU139","KU140","KU142","KU143","KU145","KU146","KU153","KU148","KU149","KU151","KU152","KU165","KU167","KU169","KU170","KU171","KU172","KU176","KU177","KU178","KU179","KU181","KU182","KU186","KU202","KU204","KU205","KU208","KU211","KU213","KU214","KU216","KU217","KU218","KU224","KU226","KU230","KU231","KU232","KU233","KU235","KU236","KU239","KU240","KU320","KU241","KU322","KU244","KU245","KU249","KU250","KU256","KU257","KU260","KU261","KU263","KU265","KU271","KU272","KU273","KU275","KU276","KU280","KU284","KU285","KU286","KU287","KU288","KU290","KU291","KU295","KU297","KU300","KU301","KU304","KU305","KU312","KU316","KU317","KU318","KU398","KU399","KU400","KU407","KU402","KU403","KU405","KU408","KU410","KU416","KU417","KU418","KU420","KU421","KU422","KU423","KU425","KU426","KU444","KU430","KU433","KU434","KU435","KU436","KU438","KU440","KU441","KU475","KU478","KU480","KU481","KU483","KU484","KU489","KU491","KU494","KU495","KU498","KU499","KU500","KU503","KU504","KU505","KU508","KU507","KU529","KU531","KU535","KU536","KU538","KU541","KU543","KU545","KU560","KU561","KU562","KU563","KU564","KU309","KU576","KU577","KU578","KU445","KU580","KU581","KU599","KU583","KU854","KU584","KU588","KU592","KU593","KU595","KU598","KU601","KU604","KU607","KU608","KU609","KU611","KU638","KU614","KU615","KU616","KU619","KU620","KU623","KU624","KU625","KU626","KU630","KU631","KU635","KU636","KU678","KU710","KU680","KU681","KU683","KU684","KU686","KU687","KU689","KU691","KU694","KU697","KU698","KU700","KU702","KU704","KU707","KU729","KU732","KU734","KU736","KU790","KU738","KU739","KU740","KU742","KU743","KU746","KU747","KU748","KU791","KU749","KU751","KU753","KU755","KU758","KU759","KU761","KU762","KU765","KU766","KU768","KU771","KU777","KU778","KU781","KU783","KU831","KU832","KU833","KU834","KU837","KU844","KU845","KU846","KU848","KU849","KU850","KU851","KU853","KU857","KU858","KU859","KU886","KU887","KU889","KU890","KU892","KU893","KU895","KU785","KU905","KU908","KU092","KU915","KU918","KU921","KU922","KU924","KU925","KU927","KU931","KU934","KU935","KU936","KU941","KU946","KU976","KU977","KU980","KU981","KU989","KU992"),
#>        "Ikä"=c("SSS","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-"),
#>        "Sukupuoli"=c("SSS","1","2"),
#>        "Koulutusaste"=c("SSS","3T8","3","4","5","6","7","8","9"),
#>        "Tiedot"=c("vaesto")))
pxweb_print_code_full_query_c(my_url)
```

where the latter copies the code to clipboard for you to add where ever
you wish simply by ctrl+V.

With a query and an url, you can import data. Let’s simplify the query a
bit:

``` r
my_query <-
     list("Vuosi"=c("1970","1975"),
          "Alue"=c("SSS","KU020","KU005"),
          "Ik\U00E4"=c("SSS","15-19"),
          "Sukupuoli"=c("SSS","1","2"),
          "Koulutusaste"=c("SSS","3T8"),
         "Tiedot"=c("vaesto"))
```

The function `ptt_get_statfi` accesses the API of Statistics Finland and
tidies the data.

``` r
ptt_get_statfi(my_url, my_query)
#> Updating:https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px
#> Without year-argument a general region classification including abolished municipalities got.
#> [1] "Checking region classifications..."
#> Region classification check: Classifications ok!
#> # A tibble: 72 x 12
#>    time       alue_code ika_code sukupuoli_code koulutusaste_code tiedot_code
#>  * <date>     <fct>     <fct>    <fct>          <fct>             <fct>      
#>  1 1970-01-01 SSS       SSS      SSS            SSS               vaesto     
#>  2 1970-01-01 SSS       SSS      SSS            3T8               vaesto     
#>  3 1970-01-01 SSS       SSS      1              SSS               vaesto     
#>  4 1970-01-01 SSS       SSS      1              3T8               vaesto     
#>  5 1970-01-01 SSS       SSS      2              SSS               vaesto     
#>  6 1970-01-01 SSS       SSS      2              3T8               vaesto     
#>  7 1970-01-01 SSS       15-19    SSS            SSS               vaesto     
#>  8 1970-01-01 SSS       15-19    SSS            3T8               vaesto     
#>  9 1970-01-01 SSS       15-19    1              SSS               vaesto     
#> 10 1970-01-01 SSS       15-19    1              3T8               vaesto     
#> # ... with 62 more rows, and 6 more variables: alue_name <fct>, ika_name <fct>,
#> #   sukupuoli_name <fct>, koulutusaste_name <fct>, tiedot_name <fct>,
#> #   values <dbl>
```

## Creating Databases

Database lists contain the code that accesses the Statistics Finland
data API and imports the data to the database. For each data set there
is a database list. Database lists can be used to create and update
databases. Database lists contains queries. Database lists are
list-objects.

Use function `ptt_save_db_list` to create a database list with a name
`test_db`. Note that we are adding an object to the data base. Thus,
first create the object and then use this object as an argument of
`ptt_save_db_list` without quotation marks.

``` r
test_db <- list()
ptt_save_db_list(test_db)
```

To retrieve a database list, use function `ptt_read_db_list`. Note that
we are fetching an object from the database by its name. Hence, use
quotation marks.

``` r
ptt_read_db_list("test_db")
#> list()
```

This database is still empty. Database lists store queries. A query is a
set of information that is required to import a dataset. To add a query,
you need the url of the data set,the query itself and a call. Query and
url are the objects that are also the arguments for the
`ptt_get_statfi`-function. The third element, the call, is the
expression to use `ptt_get_statfi`-function itself. The call may also
contain further operations as `ptt_get_statfi` cannot possibly handle
all data in the wild.

To add a query to a database list, use function `ptt_db_add_query` with
arguments that indicate the name of the database to which you wish to
add the query, the url, thr query and the call.

``` r
ptt_add_query("test_db", url = my_url, query = my_query, call = c("ptt_get_statfi(url, query)"))
#> vkour_12bq query added to test_db
```

Now our test database is not empty anymore:

``` r
ptt_read_db_list("test_db")
#> $vkour_12bq
#> $vkour_12bq$url
#> [1] "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px"
#> 
#> $vkour_12bq$query
#> $vkour_12bq$query$Vuosi
#> [1] "1970" "1975"
#> 
#> $vkour_12bq$query$Alue
#> [1] "SSS"   "KU020" "KU005"
#> 
#> $vkour_12bq$query$Ikä
#> [1] "SSS"   "15-19"
#> 
#> $vkour_12bq$query$Sukupuoli
#> [1] "SSS" "1"   "2"  
#> 
#> $vkour_12bq$query$Koulutusaste
#> [1] "SSS" "3T8"
#> 
#> $vkour_12bq$query$Tiedot
#> [1] "vaesto"
#> 
#> 
#> $vkour_12bq$call
#> [1] "ptt_get_statfi(url, query)"
```

Now the the database list has all information it needs to import the
data. To add the data to the database, use `ptt_db_update`- function. It
takes as argument the database list and imports and updates all data
sets on which the database list has information. E.g. update the
database according to the contents of a database list.

``` r
ptt_db_update("test_db")
#> Updating:https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px
#> Without year-argument a general region classification including abolished municipalities got.
#> [1] "Checking region classifications..."
#> Region classification check: Classifications ok!
#> Updated: vkour_12bq
```

## Data standardization

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

-   Datatiedostojen nimet table\_code: e.g. tyonv\_1001

## pxweb haut

-   Aika ja aluemuuttujista kaikki anonyymisti (\*)
-   Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)

Hakufunktio: *ptt\_get\_statfi* muuntaat tiedostot oikeaan muotoon

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
