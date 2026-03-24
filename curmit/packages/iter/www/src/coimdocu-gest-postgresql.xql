<?xml version="1.0"?>
<!--
    USER   DATA       MODIFICHE
    ===== ========== ================================================================================
    ric01 18/11/2025 Aggiunta gestione dei campi data_prot_03, protocollo_03 (Punto 17 MEV Regione Marche)
    
    rom01 01/12/2020 Aggiunto il campo utente_ins alle query ins_dimp e ins_dimpr. Va bene per tutti.
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_docu_next">
        <querytext>
           select nextval('coimdocu_s') as cod_documento
       </querytext>
    </fullquery>

    <partialquery name="ins_docu">
       <querytext>
                insert
                  into coimdocu 
                     ( cod_documento
                     , tipo_documento
                     , cod_impianto
                     , data_stampa
                     , data_documento
                     , data_prot_01
                     , protocollo_01
                     , data_prot_02
                     , protocollo_02
                     , flag_notifica
                     , descrizione
                     , note
                     , cod_soggetto
                     , data_notifica
                     , tipo_soggetto
		     , data_prot_03  --ric01
		     , protocollo_03 --ric01
		     )
                values 
                     (:cod_documento
                     ,:tipo_documento
                     ,:cod_impianto
                     ,:data_stampa
                     ,:data_documento
                     ,:data_prot_01
                     ,:protocollo_01
                     ,:data_prot_02
                     ,:protocollo_02
                     ,:flag_notifica
                     ,:descrizione
                     ,:note
                     ,:cod_soggetto
                     ,:data_notifica
                     ,:tipo_soggetto
		     , :data_prot_03  --ric01
		     , :protocollo_03 --ric01
		     )
       </querytext>
    </partialquery>

    <partialquery name="upd_docu">
       <querytext>
                update coimdocu
                   set tipo_documento = :tipo_documento
                     , data_stampa    = :data_stampa
                     , data_documento = :data_documento
                     , data_prot_01   = :data_prot_01
                     , protocollo_01  = :protocollo_01
                     , data_prot_02   = :data_prot_02
                     , protocollo_02  = :protocollo_02
                     , flag_notifica  = :flag_notifica
                     , descrizione    = :descrizione
                     , note           = :note
                     , data_notifica  = :data_notifica
		     , data_prot_03   = :data_prot_03   --ric01
		     , protocollo_03  = :protocollo_03  --ric01
                 where cod_documento  = :cod_documento
       </querytext>
    </partialquery>

    <partialquery name="sel_docu_del_alle">
       <querytext>
                select lo_unlink(coimdocu.contenuto)
                  from coimdocu
                 where cod_documento = :cod_documento
       </querytext>
    </partialquery> 

    <partialquery name="upd_docu_del_alle">
       <querytext>
                update coimdocu
                   set tipo_contenuto = null
                     , contenuto      = null
                 where cod_documento  = :cod_documento
       </querytext>
    </partialquery> 

    <partialquery name="upd_docu_ins_alle">
       <querytext>
                update coimdocu
                   set tipo_contenuto = :tipo_contenuto
                     , contenuto      = lo_import(:contenuto_tmpfile)
                 where cod_documento  = :cod_documento
       </querytext>
    </partialquery> 

    <partialquery name="del_docu">
       <querytext>
                delete
                  from coimdocu
                 where cod_documento = :cod_documento
       </querytext>
    </partialquery>

    <fullquery name="sel_docu">
       <querytext>
             select cod_documento
                  , tipo_documento
                  , iter_edit_data(data_stampa) as data_stampa
                  , iter_edit_data(data_documento) as data_documento
                  , iter_edit_data(data_notifica) as data_notifica
                  , iter_edit_data(data_prot_01) as data_prot_01
                  , protocollo_01
                  , iter_edit_data(data_prot_02) as data_prot_02
                  , protocollo_02
                  , flag_notifica
                  , contenuto
                  , descrizione
                  , note
                  , cod_impianto
		  , iter_edit_data(data_prot_03) as data_prot_03  --ric01 
		  , protocollo_03                                 --ric01
               from coimdocu
              where cod_documento = :cod_documento
       </querytext>
    </fullquery>

    <fullquery name="sel_docu_tipo_contenuto">
       <querytext>
          select tipo_contenuto
            from coimdocu
           where cod_documento = :cod_documento
       </querytext>
    </fullquery>

    <fullquery name="sel_docu_alle">
       <querytext>
          select lo_export(coimdocu.contenuto, :file_name)
            from coimdocu
           where cod_documento = :cod_documento
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_cod_est">
       <querytext>
       select cod_impianto_est
         from coimaimp
        where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_cod">
       <querytext>
       select cod_impianto
         from coimaimp
        where cod_impianto_est = :cod_impianto_est
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_resp">
       <querytext>
       select cod_responsabile as cod_soggetto
         from coimaimp
        where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <partialquery name="upd_aimp">
       <querytext>
	update coimaimp 
           set data_ultim_dich = :data_documento
             , data_mod        =  current_date
             , utente          = :id_utente
         where cod_impianto    = :cod_impianto
       </querytext>
    </partialquery> 

    <fullquery name="sel_check_modh">
        <querytext>
           select count(*) as conta_mh
             from coimdimp 
            where cod_impianto = :cod_impianto
              and substr(data_controllo,1,4) = :anno_doc
       </querytext>
    </fullquery>

    <fullquery name="sel_dual_cod_dimp">
       <querytext>
        select nextval('coimdimp_s') as cod_dimp
       </querytext>
    </fullquery>

    <partialquery name="ins_dimp">
       <querytext>
	insert into 
           coimdimp ( cod_dimp 
                    , cod_impianto
                    , data_controllo
                    , cod_documento
                    , n_prot
                    , data_prot
                    , osservazioni
                    , data_ins
                    , utente
                    , utente_ins --rom01
                  ) values (
		     :cod_dimp
                    ,:cod_impianto
                    ,:data_documento
                    ,:cod_documento
                    ,:protocollo_02
                    ,:data_prot_02
                    ,'Modello  inserito attraverso acquisizione del documento originale'
                    ,current_date
                    ,:id_utente
                    ,:id_utente --rom01
		  )
       </querytext>
    </partialquery> 

 <partialquery name="ins_dimpr">
       <querytext>
	insert into 
           coimdimp ( cod_dimp 
                    , cod_impianto
                    , data_controllo
                    , cod_documento
                    , n_prot
                    , data_prot
                    , osservazioni
                    , data_ins
                    , utente
                    , utente_ins --rom01
                    , flag_tracciato
                  ) values (
		     :cod_dimp
                    ,:cod_impianto
                    ,:data_documento
                    ,:cod_documento
                    ,:protocollo_02
                    ,:data_prot_02
                    ,'Modello inserito attraverso acquisizione del documento originale'
                    ,current_date
                    ,:id_utente
                    ,:id_utente --rom01
                    ,'R1'
		  )
       </querytext>
    </partialquery> 


    <fullquery name="sel_cimp">
       <querytext>
	select b.flag_uso
             , b.cod_cimp
	  from coimdocu a
             , coimcimp b
             , coiminco c
	 where a.cod_documento = :cod_documento
           and c.cod_documento_02 = a.cod_documento
           and c.cod_inco = b.cod_inco
       </querytext>
    </fullquery>

    <fullquery name="sel_tano_gg_adattamento">
        <querytext>
              select gg_adattamento
                from coimtano
	       where cod_tano = :cod_tanom
        </querytext>
    </fullquery>

    <fullquery name="sel_anom">
       <querytext>
            select cod_tanom
              from coimanom
             where cod_cimp_dimp = :cod_cimp
	       and flag_origine  = 'RV'
       </querytext>
    </fullquery>

    <partialquery name="upd_anom">
       <querytext>
                   update coimanom
                      set dat_utile_inter = date_pli(:data_notifica, :gg_adattamento)
                    where cod_cimp_dimp   = :cod_cimp
                      and cod_tanom       = :cod_tanom    
       </querytext>
    </partialquery>

</queryset>
