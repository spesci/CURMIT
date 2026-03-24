<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom05 31/03/2022 Su richiesta di Giuliodori con mail "MEV rilasciata in produzione." del 28/03/2022
    rom05            vado a modificare/implementare l intervento di rom04 per la MEV Stato impianto "Rottamato".

    rom04 18/03/2022 Manutenzione evolutiva richiesta da regione Marche.
    rom04            25.  Stato impianto "Rottamato" in scheda 1.bis:
    rom04            Aggiunte query dis_gen e att_gen.

    rom03 17/03/2022 MEV Regione Marche punto 4. Allineamento responsabile su impianti con la stessa targa
    rom03            Leggo il campo targa che mi serve per andare a vedere gli impianti collegati
    rom03            da andare ad aggiornare.
    
    gac01 18/12/2018 Aggiunto campi data_installaz e anno_costruzione

    rom02 17/12/2018 Aggiunti in sola visualizzazione i campi cognome_inst e nome_inst
    rom02            dell'installatore.
    rom02            Aggiunti i campi data_rottamaz, data_attivaz e stato su richiesta della Regione

    rom01 01/12/2018 Aggiunti i campi pres_certificazione e certificazione.
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="get_cod_impianto_est_old">
       <querytext>
           select coalesce('ITER25'||lpad((max(to_number(substr(cod_impianto_est, 7, 14), '99999999999999999990') ) + 1), 14, '0'), 'ITER2500000000000001') as cod_impianto_est from coimaimp
       </querytext>
    </fullquery>

    <partialquery name="upd_aimp">
       <querytext>
                update coimaimp
                   set pod               = :pod
	     --rom02 , flag_resp         = :flag_resp
                     , pdr               = :pdr
                     , unita_immobiliari_servite = :unita_immobiliari_servite
                     , cod_tpim          = :cod_tpim
		     , cod_conduttore    = :cod_conduttore
                     , cod_responsabile  = :cod_responsabile
		     , pres_certificazione = :pres_certificazione --rom01
                     , certificazione      = :certificazione      --rom01
		     , data_installaz    = :data_installaz   --gac01
		     , anno_costruzione  = :anno_costruzione --gac01
		     , $volimetria_upd 
		     , data_attivaz      = :data_attivaz
		     , data_rottamaz      = :data_rottamaz
		     , stato             = :stato
		     , cod_intestatario  = :cod_intestatario
                 where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="del_aimp">
       <querytext>
                delete
                  from coimaimp
                 where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="dis_gen">
       <querytext>
                update coimgend
		   set flag_attivo           = 'N'
		     , motivazione_disattivo = 'A'
		     , data_rottamaz         = :data_rottamaz_gen --rom05 ora uso la variabile al posto di current_date
		     , data_mod              = current_date
                 where cod_impianto                    = :cod_impianto
		   and flag_attivo                     = 'S'
		   and coalesce(flag_sostituito, 'N') != 'S'
       </querytext>
    </partialquery>

    <partialquery name="att_gen">
       <querytext>
                update coimgend
		   set flag_attivo           = 'S'
		     , motivazione_disattivo = null
		     , data_rottamaz         = null
		     , data_mod              = current_date
                 where cod_impianto                    = :cod_impianto
		   and flag_attivo                     = 'N'
		   and coalesce(flag_sostituito, 'N') != 'S'
       </querytext>
    </partialquery>


    
    <fullquery name="sel_aimp">
       <querytext>
          select a.cod_impianto
	       , a.targa              --rom03
               , a.cod_tpim
               , a.pdr
               , a.pod
               , a.flag_resp
               , a.unita_immobiliari_servite
               , a.potenza_utile 
	       , a.pres_certificazione --rom01
	       , a.certificazione      --rom01
	       , i.cognome as cognome_inst --rom02
	       , i.nome    as nome_inst    --rom02
	       , iter_edit_data(a.anno_costruzione) as anno_costruzione --gac01
	       , iter_edit_data(a.data_installaz)  as data_installaz    --gac01
	       , iter_edit_num(a.volimetria_risc,2) as volimetria_risc
	       , iter_edit_num(a.volimetria_raff,2) as volimetria_raff
	       , a.flag_tipo_impianto
	       , iter_edit_data(a.data_rottamaz)  as data_rottamaz
	       , iter_edit_data(a.data_attivaz)   as data_attivaz
	       , iter_edit_data(a.data_ins)       as data_ins
	       , a.stato
	       , a.stato as stato_db --rom05
            from coimaimp a   
          left join coimpote b on b.cod_potenza  = a.cod_potenza
          left join coimcomu c on c.cod_comune   = a.cod_comune
          left join coimaimp d on d.cod_impianto = a.cod_impianto_princ
	  left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --rom02
              where a.cod_impianto = :cod_impianto
                
       </querytext>
    </fullquery>


    <partialquery name="ins_aimp">
       <querytext>
   insert into coimaimp
        ( flag_resp
        , cod_intestatario  
        , cod_responsabile  
        , cod_proprietario  
        , cod_occupante  
        , cod_amministratore  
        , cod_manutentore  
        , cod_installatore  
        , cod_distributore   
        , cod_progettista
        , cap
        , cod_tpim  
        , pdr  
        , pod    
        , unita_immobiliari_servite
	, pres_certificazione --rom01
        , certificazione      --rom01
	, data_installaz   --gac01
	, anno_costruzione --gac01
	, volimetria_risc
	, volimetria_raff
	, data_rottamaz
	, data_attivaz
	, stato
        )  
  (select :flag_resp               
        , cod_intestatario 
        , cod_responsabile
        , cod_proprietario  
        , cod_occupante  
        , cod_amministratore
        , cod_manutentore  
        , cod_installatore  
        , cod_distributore  
        , cod_progettista  
        , cap
        ,:cod_tpim  
        ,:pdr  
        ,:pod    
        ,:unita_immobiliari_servite
        , :pres_certificazione --rom01
        , :certificazione      --rom01
	,:data_installaz   --gac01
	,:anno_costruzione --gac01
	,:volimetria_risc
	,:volimetria_raff
	,:data_rottamaz
	,:data_attivaz
	,:stato
     from coimaimp  
    where cod_impianto = :cod_impianto) 
       </querytext>
    </partialquery>

    <fullquery name="sel_count_generatori">
       <querytext>
           select count(*) as count_generatori
	        , sum(pot_focolare_nom) as tot_pot_focolare_nom
                , sum(pot_utile_nom) as tot_pot_utile_nom
                , sum(pot_utile_nom_freddo) as tot_pot_utile_nom_freddo --sim11
                , sum(pot_focolare_lib) as tot_pot_focolare_lib --sim02 per il freddo è la potenza riscaldamento nominale 
                , sum(pot_utile_lib)    as tot_pot_utile_lib    --sim02 per il freddo è la potenza riscaldamento utile
             from coimgend
            where cod_impianto = :cod_impianto
              and flag_attivo  = 'S'
       </querytext>
    </fullquery>

   <fullquery name="sel_condu">
     <querytext>
       select a.cod_conduttore
            , a.nome as nome_condu
            , a.cognome as cognome_condu 
         from coimcondu a
            , coimaimp  b
        where a.cod_conduttore = b.cod_conduttore
          and cod_impianto  = :cod_impianto
     </querytext>
   </fullquery>

   <fullquery name="sel_citt">
     <querytext>
       select a.cod_cittadino
            , a.natura_giuridica 
            , a.nome
            , a.cognome
            from coimaimp  b
	     left join coimcitt a
        on a.cod_cittadino = b.cod_responsabile
          where cod_impianto  = :cod_impianto
     </querytext>
   </fullquery>

      <fullquery name="sel_inte">
     <querytext>
       select b.cod_intestatario
            , a.nome as nome_inte
            , a.cognome as cognome_inte
         from coimcitt a
            , coimaimp  b
        where a.cod_cittadino = b.cod_intestatario
          and cod_impianto  = :cod_impianto
     </querytext>
   </fullquery>


    <partialquery name="upd_citt">
       <querytext>
                update coimcitt
                   set natura_giuridica = :natura_giuridica
                 where cod_cittadino = :cod_cittadino
       </querytext>
    </partialquery>

---------------
    <partialquery name="upd_aimp_1_6">
       <querytext>
                update coimaimp
                   set cod_proprietario   = :cod_proprietario
                     , cod_occupante      = :cod_occupante   
                     , cod_amministratore = :cod_amministratore
                     , cod_responsabile   = :cod_responsabile
                     , flag_resp          = :flag_responsabile
                     , cod_intestatario   = :cod_intestatario
                     , data_mod           = current_date
                     , utente             = :id_utente                 
                 where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="del_aimp_1_6">
       <querytext>
                 update coimaimp
                   set cod_proprietario   = :cod_proprietario
                     , cod_occupante      = :cod_occupante   
                     , cod_amministratore = :cod_amministratore
                     , cod_responsabile   = :cod_responsabile
                     , flag_resp          = :flag_responsabile
                     , cod_intestatario   = :cod_intestatario
                     , data_mod           = current_date
                     , utente             = :id_utente                 
                 where cod_impianto = :cod_impianto
       </querytext>
    </partialquery>

    <partialquery name="ins_sogg">
       <querytext>
                insert
                  into coimrife 
                     ( cod_impianto
                     , ruolo
                     , data_fin_valid
                     , cod_soggetto
                     , data_ins           
                     , utente)             
                values
                     (:cod_impianto
                     ,:ruolo
                     ,:data_fin_valid
                     ,:db_cod_soggetto
                     , current_date        
                     ,:id_utente)   
       </querytext>
    </partialquery>

    <fullquery name="sel_rif_sogg">
       <querytext>
          select a.cod_impianto
               , a.cod_proprietario
               , a.cod_occupante
               , a.cod_amministratore
               , a.cod_responsabile
               , a.flag_resp as flag_responsabile
               , a.cod_intestatario
               , iter_edit_data(a.data_installaz)  as data_variaz
               , b.cognome as cognome_prop
               , b.nome    as nome_prop
               , b.cod_fiscale as cod_fiscale_prop
               , c.cognome as cognome_occ 
               , c.nome    as nome_occ 
               , c.cod_fiscale as cod_fiscale_occ
               , d.cognome as cognome_amm
               , d.nome    as nome_amm
               , d.cod_fiscale as cod_fiscale_amm
               , e.cognome as cognome_terzo
               , e.nome    as nome_terzo
               , e.cod_fiscale as cod_fiscale_terzo
               , f.cognome as cognome_inte
               , f.nome    as nome_inte
               , f.cod_fiscale as cod_fiscale_inte
            from coimaimp a
            left outer join coimcitt b on b.cod_cittadino = a.cod_proprietario
            left outer join coimcitt c on c.cod_cittadino = a.cod_occupante
            left outer join coimcitt d on d.cod_cittadino = a.cod_amministratore
            left outer join coimcitt e on e.cod_cittadino = a.cod_responsabile
            left outer join coimcitt f on f.cod_cittadino = a.cod_intestatario
           where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_citt_1_6">
       <querytext>
             select cod_cittadino
               from coimcitt
              where cognome   $eq_cognome
                and nome      $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_legale">
       <querytext>
             select a.cod_legale_rapp as cod_terzi
                  , b.cognome as cognome_terzi
                  , b.nome as nome_terzi
               from coimmanu a
                  , coimcitt b
              where a.cod_manutentore = :cod_terzi
                and a.cod_legale_rapp = b.cod_cittadino
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_1_6">
       <querytext>
          select flag_dichiarato
               from coimaimp 
              where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_db">
       <querytext>
          select cod_responsabile         as db_cod_responsabile
               , cod_intestatario         as db_cod_intestatario
               , cod_proprietario         as db_cod_proprietario
               , cod_occupante            as db_cod_occupante
               , cod_amministratore       as db_cod_amministratore
               from coimaimp 
              where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_sogg_check">
       <querytext>
        select '1'
          from coimrife
         where cod_impianto    = :cod_impianto
           and ruolo           = :ruolo
           and data_fin_valid  = :data_fin_valid
       </querytext>
    </fullquery>

    <fullquery name="recup_date">
       <querytext>
        select iter_edit_data (current_date)     as data_ini_valid
              ,               (current_date - 1) as data_fin_valid
       </querytext>
    </fullquery>

    <fullquery name="sel_max_data">
       <querytext>
             select to_char(max(data_fin_valid), 'YYYYMMDD')  as data_max_valid
               from coimrife
              where 1 = 1
                and cod_impianto  = :cod_impianto
                and (ruolo         = 'P'  or
                     ruolo         = 'O'  or
                     ruolo         = 'A'  or
                     ruolo         = 'R'  or
                     ruolo         = 'T')
       </querytext>
    </fullquery>

    <fullquery name="sottrai_data">
       <querytext>
        select to_date(:data_ini_valid, 'YYYYMMDD') - 1   as data_fin_valid
       </querytext>
    </fullquery>

    <fullquery name="aggiungi_data">
       <querytext>
        select iter_edit_data(to_date(:data_max_valid, 'yyyymmdd') + 1) as data_max_valid
       </querytext>
    </fullquery>

    <fullquery name="ultima_mod">
       <querytext>
        select iter_edit_data(max(data_fin_valid) + 1) as data_variaz 
          from coimrife 
         where cod_impianto = :cod_impianto
           and ruolo in ('P', 'O', 'A', 'R', 'T')
       </querytext>
    </fullquery>

    


    
 </queryset>
 
