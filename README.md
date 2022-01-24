
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pttdatahaku

<!-- badges: start -->
<!-- badges: end -->

`pttdatahaku` provides tools for creating, managing and maintaining
PTT’s data bases. This package is for PTT’s internal use.

To use standardized analysis tools, the data has to be in standardized
form. Unfortunately the data available from Statistics Finland and other
sources vary in its form. This package gives the tools to create a data
bases and provides the tools and default ways of tidying the data into a
standard form.

## Installation and set up

To install and start using the package:

``` r
install.packages("devtools")
devtools::install_github("https://github.com/pttry/pttdatahaku")
library(pttdatahaku)
```

Currently the databases are in teams folder “Pellervon taloustutkimus -
Datapankki/Tietokanta folder”. This folder must be synced.

## Browsing data bases

To list all data sets in the data base, use `ptt_search_data` without
arguments. To search, you can set a search term.

``` r
ptt_search_data()
#>  [1] "altp_12bc"                "altp_12bd"               
#>  [3] "altp_12bf"                "altp_12bg"               
#>  [5] "aly_11yq"                 "alyr_11ft"               
#>  [7] "asas_115y"                "ashi_112l"               
#>  [9] "atp_11n1"                 "data_statfi"             
#> [11] "kl_tverop"                "koulutus_103_2019"       
#> [13] "kta_12ml"                 "lmp_expenditures"        
#> [15] "lmp_participants"         "lmp_STK_kk_ka"           
#> [17] "ntp_132h"                 "perh_12c1"               
#> [19] "statfi_participants"      "statfi_participants_orig"
#> [21] "statfi_participants2"     "test_dat"                
#> [23] "test_df"                  "test2"                   
#> [25] "tkke_125t"                "tulot_102"               
#> [27] "tyokay_115h"              "tyokay_115h_agg"         
#> [29] "tyokay_115j"              "tyokay_115s"             
#> [31] "tyonv_1001"               "tyonv_1270"              
#> [33] "tyonv_12r5"               "tyonv_12ti"              
#> [35] "tyonv_12tk"               "tyonv_12tt"              
#> [37] "tyonv_12tv"               "tyonv_12tw"              
#> [39] "tyonv_12u1"               "tyonv_12u2"              
#> [41] "tyonv_12u3"               "tyonv_12u3_kaikki"       
#> [43] "tyonv_12u3_SSS"           "tyonv_12u4"              
#> [45] "tyonv_12u5"               "tyonv_12u6"              
#> [47] "tyonv_12u8"               "tyonv_12u9"              
#> [49] "tyonv_12ur"               "tyonv_12us"              
#> [51] "tyonv_12uu"               "tyonv_12uv"              
#> [53] "tyonv_12v5"               "tyonv_12v6"              
#> [55] "tyonv_12v7"               "tyonv_12v7_kaikki"       
#> [57] "tyonv_12v8"               "tyonv_12v9"              
#> [59] "tyonv_12va"               "tyonv_1310"              
#> [61] "tyonv_135e"               "tyonv_1370"              
#> [63] "tyonv_2205"               "tyti_11af"               
#> [65] "tyti_11ag"                "tyti_11c9"               
#> [67] "tyti_11pn"                "tyti_135y"               
#> [69] "tyti_135z"                "tyti_137h"               
#> [71] "tyti_137i"                "tyti_137k"               
#> [73] "tyti_137l"                "tyti_137m"               
#> [75] "vaenn_128v"               "vaenn_128v_agg"          
#> [77] "vaerak_11ra"              "verot_maksut_102"        
#> [79] "vkour_12bq"               "vkour_12bs"
ptt_search_data("tyonv")
#>  [1] "tyonv_1001"        "tyonv_1270"        "tyonv_12r5"       
#>  [4] "tyonv_12ti"        "tyonv_12tk"        "tyonv_12tt"       
#>  [7] "tyonv_12tv"        "tyonv_12tw"        "tyonv_12u1"       
#> [10] "tyonv_12u2"        "tyonv_12u3"        "tyonv_12u3_kaikki"
#> [13] "tyonv_12u3_SSS"    "tyonv_12u4"        "tyonv_12u5"       
#> [16] "tyonv_12u6"        "tyonv_12u8"        "tyonv_12u9"       
#> [19] "tyonv_12ur"        "tyonv_12us"        "tyonv_12uu"       
#> [22] "tyonv_12uv"        "tyonv_12v5"        "tyonv_12v6"       
#> [25] "tyonv_12v7"        "tyonv_12v7_kaikki" "tyonv_12v8"       
#> [28] "tyonv_12v9"        "tyonv_12va"        "tyonv_1310"       
#> [31] "tyonv_135e"        "tyonv_1370"        "tyonv_2205"
```

To list all data bases, use `ptt_search_database` without arguments

``` r
ptt_search_db()
#>  [1] "avoimet_tyopaikat_db" "aw_db"                "aw_tyo"              
#>  [4] "kohtaanto_db"         "kohtaantoindeksit_db" "my_new_db_list"      
#>  [7] "test_db"              "tp_db"                "tyo_db"              
#> [10] "tyonhakijat_db"       "tyovoimakoulutus_db"  "tyovoimapalvelut_db" 
#> [13] "x"
```

## Saving Data

Preferably do not save data to database manually/interactively but use
the database lists for reproducibility and updating. See Section
Creating Databases. Sometimes you need to save manually however, for
this, use `ptt_save_data`:

``` r
test_df <- data.frame(x = letters[1:5], y = rnorm(5))
ptt_save_data(test_df)
```

## Reading data

Use `ptt_read_data` with the name of data set to read data from a data
base.

``` r
data <- ptt_read_data("test_df")
data
#>   x          y
#> 1 a -0.7629907
#> 2 b -0.2543767
#> 3 c  0.6287206
#> 4 d  0.8892082
#> 5 e  0.2647567
```

## Importing Data from Statistics Finland

To import data, you need an url that tells you where the data is.
Function `statfi_parse_url` transforms the addresses in the GUI of pxweb
to the addresses of API of pxweb:

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
#>        "Alue"=c("SSS","KU020","KU005","KU009","KU010","KU016","KU018","KU019","KU035","KU043","KU046","KU047","KU049","KU050","KU051","KU052","KU060","KU061","KU062","KU065","KU069","KU071","KU072","KU074","KU075","KU076","KU077","KU078","KU079","KU081","KU082","KU086","KU111","KU090","KU091","KU097","KU098","KU102","KU103","KU105","KU106","KU108","KU109","KU139","KU140","KU142","KU143","KU145","KU146","KU153","KU148","KU149","KU151","KU152","KU165","KU167","KU169","KU170","KU171","KU172","KU176","KU177","KU178","KU179","KU181","KU182","KU186","KU202","KU204","KU205","KU208","KU211","KU213","KU214","KU216","KU217","KU218","KU224","KU226","KU230","KU231","KU232","KU233","KU235","KU236","KU239","KU240","KU320","KU241","KU322","KU244","KU245","KU249","KU250","KU256","KU257","KU260","KU261","KU263","KU265","KU271","KU272","KU273","KU275","KU276","KU280","KU284","KU285","KU286","KU287","KU288","KU290","KU291","KU295","KU297","KU300","KU301","KU304","KU305","KU312","KU316","KU317","KU318","KU398","KU399","KU400","KU407","KU402","KU403","KU405","KU408","KU410","KU416","KU417","KU418","KU420","KU421","KU422","KU423","KU425","KU426","KU444","KU430","KU433","KU434","KU435","KU436","KU438","KU440","KU441","KU475","KU478","KU480","KU481","KU483","KU484","KU489","KU491","KU494","KU495","KU498","KU499","KU500","KU503","KU504","KU505","KU508","KU507","KU529","KU531","KU535","KU536","KU538","KU541","KU543","KU545","KU560","KU561","KU562","KU563","KU564","KU309","KU576","KU577","KU578","KU445","KU580","KU581","KU599","KU583","KU854","KU584","KU588","KU592","KU593","KU595","KU598","KU601","KU604","KU607","KU608","KU609","KU611","KU638","KU614","KU615","KU616","KU619","KU620","KU623","KU624","KU625","KU626","KU630","KU631","KU635","KU636","KU678","KU710","KU680","KU681","KU683","KU684","KU686","KU687","KU689","KU691","KU694","KU697","KU698","KU700","KU702","KU704","KU707","KU729","KU732","KU734","KU736","KU790","KU738","KU739","KU740","KU742","KU743","KU746","KU747","KU748","KU791","KU749","KU751","KU753","KU755","KU758","KU759","KU761","KU762","KU765","KU766","KU768","KU771","KU777","KU778","KU781","KU783","KU831","KU832","KU833","KU834","KU837","KU844","KU845","KU846","KU848","KU849","KU850","KU851","KU853","KU857","KU858","KU859","KU886","KU887","KU889","KU890","KU892","KU893","KU895","KU785","KU905","KU908","KU092","KU915","KU918","KU921","KU922","KU924","KU925","KU927","KU931","KU934","KU935","KU936","KU941","KU946","KU976","KU977","KU980","KU981","KU989","KU992"),
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
#>        "Alue"=c("SSS","KU020","KU005","KU009","KU010","KU016","KU018","KU019","KU035","KU043","KU046","KU047","KU049","KU050","KU051","KU052","KU060","KU061","KU062","KU065","KU069","KU071","KU072","KU074","KU075","KU076","KU077","KU078","KU079","KU081","KU082","KU086","KU111","KU090","KU091","KU097","KU098","KU102","KU103","KU105","KU106","KU108","KU109","KU139","KU140","KU142","KU143","KU145","KU146","KU153","KU148","KU149","KU151","KU152","KU165","KU167","KU169","KU170","KU171","KU172","KU176","KU177","KU178","KU179","KU181","KU182","KU186","KU202","KU204","KU205","KU208","KU211","KU213","KU214","KU216","KU217","KU218","KU224","KU226","KU230","KU231","KU232","KU233","KU235","KU236","KU239","KU240","KU320","KU241","KU322","KU244","KU245","KU249","KU250","KU256","KU257","KU260","KU261","KU263","KU265","KU271","KU272","KU273","KU275","KU276","KU280","KU284","KU285","KU286","KU287","KU288","KU290","KU291","KU295","KU297","KU300","KU301","KU304","KU305","KU312","KU316","KU317","KU318","KU398","KU399","KU400","KU407","KU402","KU403","KU405","KU408","KU410","KU416","KU417","KU418","KU420","KU421","KU422","KU423","KU425","KU426","KU444","KU430","KU433","KU434","KU435","KU436","KU438","KU440","KU441","KU475","KU478","KU480","KU481","KU483","KU484","KU489","KU491","KU494","KU495","KU498","KU499","KU500","KU503","KU504","KU505","KU508","KU507","KU529","KU531","KU535","KU536","KU538","KU541","KU543","KU545","KU560","KU561","KU562","KU563","KU564","KU309","KU576","KU577","KU578","KU445","KU580","KU581","KU599","KU583","KU854","KU584","KU588","KU592","KU593","KU595","KU598","KU601","KU604","KU607","KU608","KU609","KU611","KU638","KU614","KU615","KU616","KU619","KU620","KU623","KU624","KU625","KU626","KU630","KU631","KU635","KU636","KU678","KU710","KU680","KU681","KU683","KU684","KU686","KU687","KU689","KU691","KU694","KU697","KU698","KU700","KU702","KU704","KU707","KU729","KU732","KU734","KU736","KU790","KU738","KU739","KU740","KU742","KU743","KU746","KU747","KU748","KU791","KU749","KU751","KU753","KU755","KU758","KU759","KU761","KU762","KU765","KU766","KU768","KU771","KU777","KU778","KU781","KU783","KU831","KU832","KU833","KU834","KU837","KU844","KU845","KU846","KU848","KU849","KU850","KU851","KU853","KU857","KU858","KU859","KU886","KU887","KU889","KU890","KU892","KU893","KU895","KU785","KU905","KU908","KU092","KU915","KU918","KU921","KU922","KU924","KU925","KU927","KU931","KU934","KU935","KU936","KU941","KU946","KU976","KU977","KU980","KU981","KU989","KU992"),
#>        "Ikä"=c("SSS","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-"),
#>        "Sukupuoli"=c("SSS","1","2"),
#>        "Koulutusaste"=c("SSS","3T8","3","4","5","6","7","8","9"),
#>        "Tiedot"=c("vaesto")))
pxweb_print_code_full_query_c(my_url)
```

where the latter copies the code to clipboard for you to add where ever
you wish simply by ctrl+V. With a query and an url, you can import data.
Let’s simplify the query a bit:

``` r
my_query <-
     list("Vuosi"=c("1970","1975"),
          "Alue"=c("SSS","KU020","KU005"),
          "Ik\U00E4"=c("SSS","15-19"),
          "Sukupuoli"=c("SSS","1","2"),
          "Koulutusaste"=c("SSS","3T8"),
         "Tiedot"=c("vaesto"))
```

Use function `ptt_get_statfi` to import data:

``` r
ptt_get_statfi(my_url, my_query)
#> Updating: https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px
#> Region classification check: passed.
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

Each database has a database list. Database lists contain the code that
accesses the Statistics Finland data API and imports the data to the
database. For each data set there is an entry in a database list.
Database lists are used to create and update databases.

Use function `ptt_save_db_list` to create a database list. Note that we
are adding an object to the data base. Thus, first create the object and
then use this object as an argument of `ptt_save_db_list` without
quotation marks. Database lists are list-objects.

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
set of information that is required to import a data set. To add a
query, you need the url of the data set, the query itself and a call.
Query and url are the objects that are also the arguments to the
`ptt_get_statfi`-function. The third element, the call, is the
expression to use `ptt_get_statfi`-function itself. The call may also
contain further operations as `ptt_get_statfi` cannot possibly handle
all data in the wild.

To add a query to a database list, use function `ptt_db_add_query` with
arguments that indicate the name of the database to which you wish to
add the query, the url, and the call.

``` r
ptt_add_query("test_db", url = my_url, query = my_query, call = c("ptt_get_statfi(url, query)"))
#> vkour_12bq query added to test_db
```

Now our test database is not empty anymore:

``` r
db_list <- ptt_read_db_list("test_db")
db_list
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

Use R base `names`-function to see all the data sets that the database
list manages:

``` r
names(db_list)
#> [1] "vkour_12bq"
```

Now the the database list has all information it needs to import the
data. To add the data to the database, use `ptt_db_update`-function. It
takes as argument the name of the database list and imports and updates
all data sets on which the database list has information.

``` r
ptt_db_update("test_db")
#> Updating: https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px
#> Region classification check: passed.
#> Updated: vkour_12bq
```

To keep better track of your data you might want to add information
about your data to your database. To add metadata information from SF:

``` r
ptt_add_pxweb_metadata("test_db")
#> pxweb metadata added to table vkour_12bq in database test_db
ptt_read_db_list("test_db")$vkour_12bq$pxweb_metadata
#> PXWEB METADATA
#> 15 vuotta täyttänyt väestö koulutusasteen, kunnan, sukupuolen ja ikäryhmän mukaan muuttujina Vuosi, Alue, Ikä, Sukupuoli, Koulutusaste ja Tiedot 
#> variables:
#>  [[1]] Vuosi: Vuosi
#>  [[2]] Alue: Alue
#>  [[3]] Ikä: Ikä
#>  [[4]] Sukupuoli: Sukupuoli
#>  [[5]] Koulutusaste: Koulutusaste
#>  [[6]] Tiedot: Tiedot
```

You can also create complete databases using simple the url locations of
required data:

``` r
my_new_db_list <- c("StatFin__tym__atp__nj/statfin_atp_pxt_11my.px/",
                    "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px")
ptt_create_db_list(my_new_db_list, overwrite = TRUE)
names(ptt_read_db_list("my_new_db_list"))
```

To summarize a data base list:

``` r
ptt_glimpse_db("my_new_db_list")
#> # A tibble: 2 x 4
#>   table      title                           variables                time_var  
#>   <chr>      <chr>                           <chr>                    <chr>     
#> 1 atp_11my   Avoimet työpaikat toimipaikan ~ Toimipaikan henkilöstöm~ vuosinelj~
#> 2 vkour_12bq 15 vuotta täyttänyt väestö kou~ Vuosi, Alue, Ikä, Sukup~ vuosi
```

## Codes and names

``` r
df <- ptt_read_data("tyonv_12u4")
df
#> # A tibble: 28,466,640 x 6
#>    alue  sukupuoli ikaryhmat tiedot              time          value
#>    <fct> <fct>     <fct>     <fct>               <date>        <dbl>
#>  1 SSS   SSS       SSS       AKTASTE             2006-01-01     22.7
#>  2 SSS   SSS       SSS       TYOTTOMATLOPUSSA    2006-01-01 278486  
#>  3 SSS   SSS       SSS       PALVELUISSAYHTEENSA 2006-01-01  81888  
#>  4 SSS   SSS       SSS       TVKOULUTUSLOP       2006-01-01  26050  
#>  5 SSS   SSS       SSS       VALMENNUSLOP        2006-01-01      0  
#>  6 SSS   SSS       SSS       TYOLLISTETTYLOP     2006-01-01  47763  
#>  7 SSS   SSS       SSS       KOKEILULOP          2006-01-01      0  
#>  8 SSS   SSS       SSS       VUORVAPLOP          2006-01-01   4942  
#>  9 SSS   SSS       SSS       KUNTTYOLOP          2006-01-01   3133  
#> 10 SSS   SSS       SSS       OMAEHTLOP           2006-01-01      0  
#> # ... with 28,466,630 more rows
```

``` r
label_key <- get_codes_names("tyonv_12u4", "tyovoimapalvelut_db")
df <- statficlassifications::key_recode(df, label_key)
#> Input time not recoded.
#> Input value not recoded.
df
#> # A tibble: 28,466,640 x 6
#>    alue     sukupuoli ikaryhmat tiedot                         time        value
#>    <fct>    <fct>     <fct>     <fct>                          <date>      <dbl>
#>  1 KOKO MAA Yhteensä  Yhteensä  Aktivointiaste laskentapäivän~ 2006-01-01 2.27e1
#>  2 KOKO MAA Yhteensä  Yhteensä  Työttömät työnhakijat laskent~ 2006-01-01 2.78e5
#>  3 KOKO MAA Yhteensä  Yhteensä  Palveluissa yhteensä (lkm.)    2006-01-01 8.19e4
#>  4 KOKO MAA Yhteensä  Yhteensä  Työvoimakoulutuksessa olevat ~ 2006-01-01 2.60e4
#>  5 KOKO MAA Yhteensä  Yhteensä  Valmennuksessa olevat laskent~ 2006-01-01 0     
#>  6 KOKO MAA Yhteensä  Yhteensä  Työllistettynä olevat laskent~ 2006-01-01 4.78e4
#>  7 KOKO MAA Yhteensä  Yhteensä  Työ- ja koulutuskokeilussa ol~ 2006-01-01 0     
#>  8 KOKO MAA Yhteensä  Yhteensä  Vuorotteluvapaasijaiset laske~ 2006-01-01 4.94e3
#>  9 KOKO MAA Yhteensä  Yhteensä  Kuntouttavassa työtoiminnassa~ 2006-01-01 3.13e3
#> 10 KOKO MAA Yhteensä  Yhteensä  Omaehtoisessa opiskelussa las~ 2006-01-01 0     
#> # ... with 28,466,630 more rows
```

Switching between codes and names is straightforward

``` r
df <- statficlassifications::key_recode(df, label_key)
#> Input time not recoded.
#> Input value not recoded.
df
#> # A tibble: 28,466,640 x 6
#>    alue  sukupuoli ikaryhmat tiedot              time          value
#>    <fct> <fct>     <fct>     <fct>               <date>        <dbl>
#>  1 SSS   SSS       SSS       AKTASTE             2006-01-01     22.7
#>  2 SSS   SSS       SSS       TYOTTOMATLOPUSSA    2006-01-01 278486  
#>  3 SSS   SSS       SSS       PALVELUISSAYHTEENSA 2006-01-01  81888  
#>  4 SSS   SSS       SSS       TVKOULUTUSLOP       2006-01-01  26050  
#>  5 SSS   SSS       SSS       VALMENNUSLOP        2006-01-01      0  
#>  6 SSS   SSS       SSS       TYOLLISTETTYLOP     2006-01-01  47763  
#>  7 SSS   SSS       SSS       KOKEILULOP          2006-01-01      0  
#>  8 SSS   SSS       SSS       VUORVAPLOP          2006-01-01   4942  
#>  9 SSS   SSS       SSS       KUNTTYOLOP          2006-01-01   3133  
#> 10 SSS   SSS       SSS       OMAEHTLOP           2006-01-01      0  
#> # ... with 28,466,630 more rows
```

## Data standardization

Haettavat tiedot muokataan seuraavaan muotoon:

-   Pitkä tibble
-   muuttujanimet
    -   vain pieniä kirjaimia ilman hyvää syytä isoille kirjaimille
    -   ei tyhjää välimerkkiä, sen sijaan alaviiva
    -   Aluemuuttujat - sekä koodi että nimi sarakkeet (“\*\_code”,
        “\**name*”), e.g. *(seutu)kunta_code*, *(maa)kunta_name*. - ei
        “Alue”-nimistä muuttujaa, aluemuuttujalla alueen nimi -
        numerosarake nimellä “values”
-   muuttujatyypit
    -   aikamuuttujat - “time” - Date -muodossa
    -   kategoriset muuttujat
    -   ei lyhennetä numeerisia muuttujia esim. tuhansiksi, milj.
-   missing values merkataan NA

### Naming

-   Datatiedostojen nimet table_code: e.g. tyonv_1001

### pxweb haut

-   Aika ja aluemuuttujista kaikki anonyymisti (\*)
-   Muista muuttujista haettavat merkataan (YLEENSÄ KAIKKI ?)

Hakufunktio: *ptt_get_statfi* muuntaat tiedostot oikeaan muotoon

## Apufunktiot

### Olemassa - *statfi_url* - Koko statfi osoite loppuosan perusteella.
- statfi_url(“StatFin”, “kou/vkour/statfin_vkour_pxt_12bq.px”) -
*statfi_parse_url* - Statfi api:n osoite taulun web sivun osoitteen
perusteella. -
statfi_parse_url(“<https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/>”)
- *pxweb_print_full_query* - Kirjoittaa hakulistan taulun kaikille
tiedoille. - pxweb_print_full_query(url = statfi_url(“StatFin”,
“vrm/tyokay/statfin_tyokay_pxt_115u.px”))\` -
*pxweb_print_code_full_query*, *pxweb_print_code_full_query_c* -
Kirjoittaa hakukoodin taulun kaikille tiedoille. - Toimii sekä api että
web osoitteella -
pxweb_print_code_full_query(“<https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/>”)
- \_c-versio kirjottaa leikepöydälle - *conc* - Kopioi objektin
työpöydälle - *alevels* - Antaa kaikkien factor-muuttujien levelit -
*factor_all* - Tekee kaikista character-muuttujista factoreita - *pc* -
Laskee prosenttimuutokset - *filter_recode* Easy filtering and recoding
data

### Aggregointi

-   agg_key
-   agg_regions
-   add_agg
-   agg_abolished_mun
-   agg_yearly

## Filosofiaa

Aineistossa ei tulisi olla kerrallaan sekä code että name muuttujia.
Niiden yhtäaikaisuus vaikeuttaa aineiston kääntämistä.
