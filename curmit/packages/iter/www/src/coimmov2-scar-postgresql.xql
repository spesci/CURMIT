<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom02  13/02/2023 Aggiunti nuovi campi data e numero accertamento su richiesta di Palermo.
    rom02             Estraggo anche il tipo soggetto della sanzione.
    rom02             Sandro ha detto che vanno bene per tutti.

    rom01  09/02/2023 Aggiunti nuovi campi nell estrazione csv su richiesta di Sandro per Palermo.

    gab01 15/09/2017 Vado in join sulla tabella coimtp_pag per estrarre la descrizione del
    gab01            tipo pagamento senza usare la case when che andrebbe sempre aggiornata.
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>


    <partialquery name="sel_movi">
       <querytext>
select a.cod_movi
     , b.cod_impianto_est
     , d.descrizione as desc_movi
     --gab01 , case a.tipo_pag
     --gab01  when 'BO' then 'Bollettino prepagato'
     --gab01  when 'BP' then 'Bollettino postale'
     --gab01  when 'CN' then 'Contante a sportello dell''''ente gestore'
     --gab01  when 'BB' then 'Bonifico Bancario'
     --gab01  when 'CC' then 'Carta di Credito'
     --gab01  when 'PS' then 'POS'
     --gab01  else ''
     --gab01  end as desc_pag
     , t.descrizione as desc_pag --gab01
     , iter_edit_data(a.data_scad) as data_scad
     , iter_edit_num(a.importo, 2) as importo_edit
     , iter_edit_num(a.importo_pag, 2) as importo_pag_edit
     , iter_edit_data(a.data_pag) as data_pag
     , iter_edit_data(a.data_compet) as data_compet
     , iter_edit_data(a.data_incasso) as data_incasso
     , nota
     , flag_pagato
     , coalesce(c.cognome, '') as cognome
     , coalesce(c.nome, '') as nome
     , coalesce(c.indirizzo, '') as indirizzo
     , coalesce(c.cap, '') as cap
     , coalesce(c.comune, '') as comune
     , coalesce(c.cod_fiscale, '') as codice_fiscale
     , coalesce(k.descr_estesa, '') as sanzione                    --rom01
     , iter_edit_num(coalesce(k.importo_min, 0),2) as importo_min  --rom01
     , iter_edit_num(coalesce(k.importo_max, 0),2) as importo_max  --rom01
     , coalesce(j.cognome, '') as cognome_manu                     --rom01
     , coalesce(j.nome, '') as nome_manu                           --rom01
     , coalesce(j.indirizzo, '') as indirizzo_manu                 --rom01
     , coalesce(j.cap, '') as cap_manu                             --rom01
     , coalesce(j.comune, '') as comune_manu                       --rom01
     , coalesce(j.cod_piva, '') as codice_piva_manu                --rom01
     , cimp.last_data_controllo_ispe                               --rom01
     , cimp.last_verb_n_ispe                                       --rom01
     , iter_edit_data(a.data_accertamento) as data_accertamento    --rom02
     , a.numero_accertamento                                       --rom02
     , case k.tipo_soggetto
     when 'M' then 'Manutentore'
     when 'R' then 'Responsabile'
     else '' end as tipo_soggetto_edit                             --rom02
   from coimmovi a
       left outer join coimcaus d on a.id_caus = d.id_caus
       left outer join coimtp_pag t on a.tipo_pag = t.cod_tipo_pag --gab01
       left outer join coimsanz k on a.cod_sanzione_1 = k.cod_sanzione                            --rom01
       left outer join (select z.cod_impianto
                             , iter_edit_data(max(z.data_controllo)) as last_data_controllo_ispe
                             , max(z.verb_n)                         as last_verb_n_ispe
                          from coimcimp z
                         group by z.cod_impianto) as cimp on cimp.cod_impianto = a.cod_impianto   --rom01
     , coimaimp b
       left outer join coimmanu j on b.cod_manutentore = j.cod_manutentore --rom01
     , coimcitt c
 where 1 = 1
   and b.cod_impianto = a.cod_impianto
   and b.cod_responsabile = c.cod_cittadino
$where_id_caus
$where_tipo_pag
$where_data_pag
$where_data_scad
$where_importo
$where_data_incasso --san01
$where_data_compet  --sim01
order by cod_movi
       </querytext>
    </partialquery>

</queryset>
