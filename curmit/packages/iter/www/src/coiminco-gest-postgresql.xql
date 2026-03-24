<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="upd_inco">
       <querytext>
                update coiminco
                   set data_assegn       = :data_assegn
                     , cod_opve          = :cod_opve
                     , data_verifica     = :data_verifica
                     , ora_verifica      = :ora_verifica
                     , data_avviso_01    = :data_avviso_01
                     , cod_documento_01  = :cod_documento_01
                     , data_avviso_02    = :data_avviso_02
                     , cod_documento_02  = :cod_documento_02
                     , stato             = :stato
                     , cod_noin          = :cod_noin
                     , note              = :note
                     , data_mod          = :current_date
                     , utente            = :id_utente
		     , flag_blocca_rcee  = :flag_blocca_rcee --sim01
                 where cod_inco          = :cod_inco
       </querytext>
    </partialquery>

    <partialquery name="del_inco">
       <querytext>
                delete
                  from coiminco
                 where cod_inco = :cod_inco
       </querytext>
    </partialquery>

    <fullquery name="sel_inco">
       <querytext>
             select a.cod_inco
                  , a.cod_cinc
                  , a.tipo_estrazione
                  , a.cod_impianto
                  , iter_edit_data(a.data_estrazione) as data_estrazione
                  , iter_edit_data(a.data_assegn)     as data_assegn
                  , a.cod_opve
                  , iter_edit_data(a.data_verifica)   as data_verifica
                  , iter_edit_time(a.ora_verifica)    as ora_verifica
                  , iter_edit_data(a.data_avviso_01)  as data_avviso_01
                  , a.cod_documento_01
                  , iter_edit_data(a.data_avviso_02)  as data_avviso_02
                  , a.cod_documento_02
                  , a.stato
                  , a.esito
                  , b.descr_inst                    as des_stato
                  , a.note
                  , a.cod_noin
		  , a.flag_blocca_rcee --sim01
                  , a.utente                               -- rom03
                  , iter_edit_data(a.data_mod) as data_mod -- rom03
               from coiminco a
                  , coiminst b
              where   cod_inco = :cod_inco
                and b.cod_inst = a.stato
       </querytext>
    </fullquery>

    <fullquery name="sel_cinc">
       <querytext>
                   select descrizione as desc_camp
                        , to_char(data_inizio, 'yyyymmdd') as dt_inizio_cinc
                        , to_char(data_fine, 'yyyymmdd') as dt_fine_cinc
                     from coimcinc
                    where cod_cinc = :cod_cinc
       </querytext>
    </fullquery>

    <fullquery name="sel_opve">
       <querytext>
             select cognome as cog_tecn
                  , nome    as nom_tecn
                  , cod_enve
               from coimopve
              where cod_opve = :cod_opve
       </querytext>
    </fullquery>

    <fullquery name="sel_opve_nom">
       <querytext>
             select cod_opve as cod_opve_db
               from coimopve
              where cod_enve       = :cod_enve
                and upper(nome)    = upper(:nom_tecn)
                and upper(cognome) = upper(:cog_tecn)
       </querytext>
    </fullquery>

    <fullquery name="sel_docu">
       <querytext>
             select '1'
               from coimdocu
              where cod_documento = :cod_documento
                and tipo_contenuto is not null
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_enve">
       <querytext>
             select cod_enve
               from coimopve
              where cod_opve = :cod_tecn
       </querytext>
    </fullquery>

    <fullquery name="sel_ragione_enve">
        <querytext>
	   select ragione_01
             from coimenve
            where cod_enve = :cod_enve
	</querytext>
    </fullquery>

    <fullquery name="sel_inco_disp">
        <querytext>
	   select a.cod_inco as cod_inco_disp
             from coiminco a
            where cod_opve = :cod_opve
	      and a.data_verifica = :data_verifica
              and a.cod_impianto  is null
              and a.ora_verifica  = (select b.ora_da
                                     from coimopdi b
                                    where b.cod_opve = :cod_opve
                                      and b.ora_da  <= :ora_verifica
                                      and b.ora_a    > :ora_verifica limit 1)limit 1
	</querytext>
    </fullquery>

    <partialquery name="del_disp">
       <querytext>
                delete
                  from coiminco
                 where cod_inco = :cod_inco_disp
       </querytext>
    </partialquery>

    <fullquery name="sel_opdi_fascia">
       <querytext>
        select ora_da 
          from coimopdi
         where ora_da  <= :ora_verifica_old
           and ora_a   >  :ora_verifica_old
           and cod_opve = :cod_opve_old limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_inco_dual">
       <querytext>
           select nextval('coiminco_s') as cod_inco_crea
       </querytext>
    </fullquery>

    <partialquery name="crea_disp">
       <querytext>
           insert into 
           coiminco(cod_inco
                  , cod_cinc
                  , data_estrazione 
                  , cod_opve
                  , data_verifica
                  , ora_verifica
                  , data_ins
                  , utente
              ) values (
                   :cod_inco_crea
                  ,:cod_cinc
                  , current_date
                  ,:cod_opve_old
                  ,:data_verifica_old
                  ,:ora_da
                  , current_date
                  ,:id_utente
              )
       </querytext>
    </partialquery>


    <partialquery name="sel_inco_disp_count">
       <querytext>
	   select count(*) as inco_disp
             from coiminco a
            where cod_opve = :cod_opve
	      and a.data_verifica = :data_verifica
              and a.ora_verifica  = (select b.ora_da
                                     from coimopdi b
                                    where b.cod_opve = :cod_opve
                                      and b.ora_da  <= :ora_verifica
                                      and b.ora_a    > :ora_verifica limit 1)
       </querytext>
    </partialquery>

    <fullquery name="sel_comune">
       <querytext>
                   select a.cod_comune,
                          b.denominazione as nome_comu
                     from coimaimp a
                        , coimcomu b
                    where a.cod_impianto = :cod_impianto
                      and b.cod_comune = a.cod_comune
       </querytext>
    </fullquery>

    <fullquery name="sel_effettivi">
       <querytext>
                   select count(*) as conta_effettivi
                     from coiminco a
                        , coimaimp b
                    where a.stato = '2'
                      and a.cod_impianto = b.cod_impianto
                      and b.cod_comune = :cod_comune
                      and a.data_verifica is not null
                      and a.ora_verifica is not null
       </querytext>
    </fullquery>

    <fullquery name="sel_riserve">
       <querytext>
                   select count(*) as conta_riserve
                     from coiminco a
                        , coimaimp b
                    where a.stato = '2'
                      and a.cod_impianto = b.cod_impianto
                      and b.cod_comune = :cod_comune
                      and a.data_verifica is not null
                      and a.ora_verifica is null
       </querytext>
    </fullquery>

    <fullquery name="sel_tpes">
       <querytext>
                   select descr_tpes
                     from coimtpes
                    where cod_tpes = :tipo_estrazione
       </querytext>
    </fullquery>

    <fullquery name="upd_stato_imp">
       <querytext>
             update coimaimp
                set stato = :stato_imp
              where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

</queryset>
