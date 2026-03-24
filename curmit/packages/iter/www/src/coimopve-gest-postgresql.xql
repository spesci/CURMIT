<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    but01 29/03/2024  Modificato la query "sel_opve_check" nel qui poter inserire lo stesso operatore su un ente
    but01            verificatore diverso e non nell ostessa ente.  

    rom02 15/09/2021 Modifiche per targatura Ispettori: Aggiunto il campo cod_portale, va valorizzato con lo stesso
    rom02            valore dell'omonimo campo del portale (iter_inspectors) dopo che viene registrato l'ispettore.

    rom01 13/09/2018 Aggiunto campo email
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_strum">
       <querytext>
              select tipo_strum
                   , marca_strum as marca_strumento
                   , modello_strum as modello_strumento
                   , matr_strum as matr_strumento
                   , iter_edit_data(dt_tar_strum) as dt_tar_strumento
                   , iter_edit_data(dt_inizio_att) as dt_inizio_attivita
                   , iter_edit_data(dt_fine_att) as dt_fine_attivita
                   , strum_default as strum_def
                from coimstru
               where cod_enve = :cod_enve
                 and cod_opve = :cod_opve
       </querytext>
    </partialquery>

    <partialquery name="del_strum">
       <querytext>
         delete from coimstru where cod_opve = :cod_opve and cod_enve = :cod_enve
       </querytext>
    </partialquery>

    <partialquery name="ins_strum">
       <querytext>
             insert into coimstru
                       ( cod_strumento
                       , cod_opve
                       , cod_enve
                       , tipo_strum
                       , marca_strum
                       , modello_strum
                       , matr_strum
                       , dt_tar_strum
                       , dt_inizio_att
                       , dt_fine_att 
                       , strum_default )
                         values
                       ( nextval('coimstru_s')
                       , :cod_opve
                       , :cod_enve
                       , :strumento_db
                       , upper(:marca_strum_db)
                       , upper(:modello_strum_db)
                       , upper(:matr_strum_db)
                       , :dt_tar_strum_db
                       , :dt_inizio_att_db
                       , :dt_fine_att_db 
                       , :strum_default_db)
       </querytext>
    </partialquery>

    <partialquery name="sel_enve">
       <querytext>
                 select ragione_01||' '||coalesce(ragione_02,'') as nome_enve
                   from coimenve
                  where cod_enve = :cod_enve
       </querytext>
    </partialquery>

    <partialquery name="ins_opve">
       <querytext>
                insert
                  into coimopve 
                     ( cod_opve
                     , cod_enve
                     , cognome
                     , nome
                     , matricola
                     , stato
		     , telefono
		     , cellulare
		     , recapito
		     , data_ins
		     , utente
                     , codice_fiscale
                     , cod_portale --rom02
                     , note
		     , email --rom01
                     , cod_listino)
                values 
                     (:cod_opve
                     ,:cod_enve
                     ,:cognome
                     ,:nome
                     ,:matricola
                     ,:stato
		     ,:telefono
		     ,:cellulare
		     ,:recapito
		     ,current_date
		     ,:id_utente
                     ,:codice_fiscale
                     ,:cod_portale --rom02
                     ,:note
		     ,:email --rom01
                     ,:cod_listino)
       </querytext>
    </partialquery>

    <partialquery name="upd_opve">
       <querytext>
                update coimopve
                   set cognome   = :cognome
                     , nome      = :nome
                     , matricola = :matricola
                     , stato     = :stato
		     , telefono  = :telefono
		     , cellulare = :cellulare
		     , recapito  = :recapito
		     , data_mod  = current_date
		     , utente    = :id_utente
                     , codice_fiscale = :codice_fiscale
                     , cod_portale    = :cod_portale --rom02
                     , note      = :note
		     , email     = :email --rom01 
                     , cod_listino = :cod_listino
                 where cod_opve  = :cod_opve
       </querytext>
    </partialquery>

    <partialquery name="del_opve">
       <querytext>
                delete
                  from coimopve
                 where cod_opve = :cod_opve
               </querytext>
    </partialquery>

    <fullquery name="sel_opve">
       <querytext>
             select cod_opve
                  , cod_enve
                  , cognome
                  , nome
                  , matricola
                  , stato
		  , telefono
		  , cellulare
		  , recapito
                  , codice_fiscale
                  , cod_portale --rom02
                  , note
		  , email --rom01
                  , cod_listino
               from coimopve
              where cod_opve = :cod_opve
       </querytext>
    </fullquery>

    <fullquery name="sel_opve_check">
       <querytext>
        select '1'
          from coimopve
         where upper(cognome)   = upper(:cognome)
           and upper(nome)      = upper(:nome)
           and upper(matricola) = upper(:matricola)
	   and cod_enve         = :cod_enve   --but01
       </querytext>
    </fullquery>

    <fullquery name="sel_opve_s">
       <querytext>
         select :cod_enve||trim(to_char(max(to_number(substr(cod_opve,4,3),'999000')) + 1, '999000')) as cod_opve 
           from coimopve 
          where cod_enve = :cod_enve;
       </querytext>
    </fullquery>

    <fullquery name="sel_inco_count">
       <querytext>
         select count(*) as conta_inco
           from coiminco
          where cod_opve = :cod_opve
            and cod_impianto is not null
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp_count">
       <querytext>
         select count(*) as conta_cimp
           from coimcimp
          where cod_opve = :cod_opve
       </querytext>
    </fullquery>

    <fullquery name="sel_stru_count">
       <querytext>
         select count(*) as conta_stru
           from coimstru
          where cod_opve = :cod_opve
       </querytext>
    </fullquery>

    <fullquery name="sel_uten_count">
       <querytext>
         select count(*) as conta_uten
           from coimuten
          where id_utente = :cod_opve
       </querytext>
    </fullquery>

    <partialquery name="del_disp">
       <querytext>
                delete
                  from coiminco
                 where cod_opve = :cod_opve
		   and cod_impianto is null
       </querytext>
    </partialquery>

</queryset>
