<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_date">
       <querytext>
                   select to_char(current_date, 'yyyymmdd') as data_corrente
       </querytext>
    </fullquery>

    <partialquery name="ins_movi">
       <querytext>
                insert
                  into coimmovi 
                     ( cod_movi
                     , tipo_movi
                     , cod_impianto
                     , data_scad
                     , data_compet
                     , importo
                     , importo_pag
                     , data_pag
                     , tipo_pag
                     , nota
                     , data_ins
                     , data_mod
                     , utente
                     , tipo_soggetto
                     , cod_soggetto
                     , riduzione_importo
                     , cod_sanzione_1
                     , cod_sanzione_2
                     , data_rich_audiz
                     , note_rich_audiz
                     , data_pres_deduz
                     , note_pres_deduz
                     , data_ric_giudice
                     , note_ric_giudice
                     , data_ric_tar
                     , note_ric_tar
                     , data_ric_ulter
                     , note_ric_ulter
                     , data_ruolo
                     , note_ruolo
		     , data_accertamento   --rom01
		     , numero_accertamento --rom01
                     , id_caus)
                values 
                     (:cod_movi
                     ,:tipo_movi
                     ,:cod_impianto
                     ,:data_scad
                     ,:data_compet
                     ,:importo
                     ,:importo_pag
                     ,:data_pag
                     ,:tipo_pag
                     ,:nota
                     ,:data_corrente
                     ,:data_corrente
                     ,:id_utente
                     ,:tipo_soggetto
                     ,:cod_soggetto
                     ,:riduzione_importo
                     ,:cod_sanzione_1
                     ,:cod_sanzione_2
                     ,:data_rich_audiz
                     ,:note_rich_audiz
                     ,:data_pres_deduz
                     ,:note_pres_deduz
                     ,:data_ric_giudice
                     ,:note_ric_giudice
                     ,:data_ric_tar
                     ,:note_ric_tar
                     ,:data_ric_ulter
                     ,:note_ric_ulter
                     ,:data_ruolo
                     ,:note_ruolo
		     ,:data_accertamento   --rom01
		     ,:numero_accertamento --rom01
                     ,:id_caus)
       </querytext>
    </partialquery>

    <partialquery name="upd_movi">
       <querytext>
                update coimmovi
                   set tipo_movi         = :tipo_movi
                     , data_scad         = :data_scad
                     , data_compet       = :data_compet
                     , importo           = :importo
                     , importo_pag       = :importo_pag
                     , data_pag          = :data_pag
                     , tipo_pag          = :tipo_pag
                     , nota              = :nota
                     , data_mod          = :data_corrente
                     , utente            = :id_utente
                     , riduzione_importo = :riduzione_importo
                     , data_rich_audiz   = :data_rich_audiz
                     , note_rich_audiz   = :note_rich_audiz
                     , data_pres_deduz   = :data_pres_deduz
                     , note_pres_deduz   = :note_pres_deduz
                     , data_ric_giudice  = :data_ric_giudice
                     , note_ric_giudice  = :note_ric_giudice
                     , data_ric_tar      = :data_ric_tar
                     , note_ric_tar      = :note_ric_tar
                     , data_ric_ulter    = :data_ric_ulter
                     , note_ric_ulter    = :note_ric_ulter
                     , data_ruolo        = :data_ruolo
                     , note_ruolo        = :note_ruolo
		     , data_accertamento    = :data_accertamento   --rom01
		     , numero_accertamento  = :numero_accertamento --rom01
                     , id_caus           = :id_caus
                 where cod_movi          = :cod_movi
       </querytext>
    </partialquery>

    <partialquery name="del_movi">
       <querytext>
                delete
                  from coimmovi
                 where cod_movi = :cod_movi
       </querytext>
    </partialquery>

    <fullquery name="sel_movi">
       <querytext>
             select cod_movi
                  , tipo_movi
                  , id_caus
                  , cod_impianto
                  , iter_edit_data(data_scad) as data_scad
                  , iter_edit_num(importo, 2) as importo
                  , iter_edit_data(data_compet) as data_compet
                  , iter_edit_num(importo_pag, 2) as importo_pag
                  , iter_edit_data(data_pag) as data_pag
                  , tipo_pag
                  , nota
                  , tipo_soggetto
                  , cod_soggetto
                  , iter_edit_num(riduzione_importo, 2) as riduzione_importo
                  , cod_sanzione_1
                  , cod_sanzione_2
                  , iter_edit_data(data_rich_audiz) as data_rich_audiz
                  , note_rich_audiz
                  , iter_edit_data(data_pres_deduz) as data_pres_deduz
                  , note_pres_deduz
                  , iter_edit_data(data_ric_giudice) as data_ric_giudice
                  , note_ric_giudice
                  , iter_edit_data(data_ric_tar) as data_ric_tar
                  , note_ric_tar
                  , iter_edit_data(data_ric_ulter) as data_ric_ulter
                  , note_ric_ulter
                  , iter_edit_data(data_ruolo) as data_ruolo
		  , iter_edit_data(data_accertamento) as data_accertamento --rom01
		  , numero_accertamento                                    --rom01
                  , note_ruolo
               from coimmovi
              where cod_movi = :cod_movi
       </querytext>
    </fullquery>

    <fullquery name="sel_movi_check">
       <querytext>
        select '1'
          from coimmovi
         where cod_movi = :cod_movi
       </querytext>
    </fullquery>

    <fullquery name="sel_sanz1">
       <querytext>
        select tipo_soggetto as tipo_soggetto1
          from coimsanz
         where cod_sanzione = :cod_sanzione_1
       </querytext>
    </fullquery>

    <fullquery name="sel_sanz2">
       <querytext>
        select tipo_soggetto as tipo_soggetto2
          from coimsanz
         where cod_sanzione = :cod_sanzione_2
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_resp">
       <querytext>
        select cod_responsabile as cod_soggetto
          from coimaimp
         where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_manu">
       <querytext>
        select cod_manutentore as cod_soggetto
          from coimaimp
         where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_dist">
       <querytext>
        select cod_distributore as cod_soggetto
          from coimaimp
         where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_nome_resp">
       <querytext>
        select cognome
             , nome
          from coimcitt
         where cod_cittadino = :cod_soggetto
       </querytext>
    </fullquery>

    <fullquery name="sel_nome_manu">
       <querytext>
        select cognome
             , nome
          from coimmanu
         where cod_manutentore = :cod_soggetto
       </querytext>
    </fullquery>

    <fullquery name="sel_nome_dist">
       <querytext>
        select ragione_01 as cognome
             , ragione_02 as nome
          from coimdist
         where cod_distr = :cod_soggetto
       </querytext>
    </fullquery>

    <fullquery name="sel_movi_next">
        <querytext>
           select nextval('coimmovi_s') as cod_movi
       </querytext>
    </fullquery>

    <fullquery name="sel_current_date">
        <querytext>
           select to_char(current_date, 'dd/mm/yyyy') as current_date
       </querytext>
    </fullquery>

</queryset>
