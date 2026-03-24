<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 01/10/2024 Gestiti nuovo campo email_operator.
    
    gac01 19/02/2018 Gestiti nuovi campi patentino e patentino_fgas
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_manu">
       <querytext>
                 select cognome||' '||coalesce(nome,'') as nome_manu
                   from coimmanu
                  where cod_manutentore = :cod_manutentore
       </querytext>
    </partialquery>

    <partialquery name="ins_opma">
       <querytext>
                insert
                  into coimopma 
                     ( cod_opma
                     , cod_manutentore
                     , cognome
                     , nome
                     , matricola
                     , stato
		     , telefono
		     , cellulare
		     , recapito
		     , data_ins
		     , utente_ins
                     , codice_fiscale
                     , patentino              --gac01
                     , patentino_fgas         --gac01
                     , note
                     , flag_portafoglio_admin --sim01
		     , email_operator         --but01
                     )
                values 
                     (:cod_opma
                     ,:cod_manutentore
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
		     ,:patentino              --gac01
		     ,:patentino_fgas         --gac01
                     ,:note
                     ,:flag_portafoglio_admin --sim01
		     ,:email_operator         --but01
                     );
       </querytext>
    </partialquery>

    <partialquery name="upd_opma">
       <querytext>
                update coimopma
                   set cognome     = :cognome
                     , nome        = :nome
                     , matricola   = :matricola
                     , stato       = :stato
		     , telefono    = :telefono
		     , cellulare   = :cellulare
		     , recapito    = :recapito
		     , data_mod    = current_date
		     , utente_mod  = :id_utente
                     , codice_fiscale = :codice_fiscale
		     , patentino   = :patentino                --gac01
		     , patentino_fgas = :patentino_fgas        --gac01
                     , note        = :note
                     , flag_portafoglio_admin = :flag_portafoglio_admin --sim01
		     , email_operator       = :email_operator      --but01
                 where cod_opma  = :cod_opma
       </querytext>
    </partialquery>

    <partialquery name="del_opma">
       <querytext>
                delete
                  from coimopma
                 where cod_opma = :cod_opma
       </querytext>
    </partialquery>

    <fullquery name="sel_opma">
       <querytext>
             select cod_opma
                  , cod_manutentore
                  , cognome
                  , nome
                  , matricola
                  , stato
		  , telefono
		  , cellulare
		  , recapito
                  , codice_fiscale
		  , patentino              --gac01
                  , patentino_fgas         --gac01
                  , note
                  , flag_portafoglio_admin --sim01
		  , email_operator          --but01
               from coimopma
              where cod_opma = :cod_opma
       </querytext>
    </fullquery>

    <fullquery name="sel_opma_check">
       <querytext>
        select cod_manutentore as manu
          from coimopma
         where upper(cognome)   = upper(:cognome)
           and upper(nome)      = upper(:nome)
           and upper(matricola) = upper(:matricola)
           and stato = '0' -- aggiunto da Sandro il 26/11/2015
       </querytext>
    </fullquery>

    <fullquery name="sel_opma_s">
       <querytext>
         select :cod_manutentore||coalesce(trim(to_char(max(to_number(substr(cod_opma,(length(:cod_manutentore) + 1)),'9999999999999000')) + 1, '999000')), '001') as cod_opma 
             -- 15/07/2014 corretto calcolo del cod_opma (andava in errore per cod_manu lunghi
             -- 6 e suffisso del cod_opma di 3 cifre) riporto la query originale
             --:cod_manutentore||coalesce(trim(to_char(max(to_number(substr(cod_opma,6,3),'9999999999999000')) + 1, '999000')), '001') as cod_opma
           from coimopma
          where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

    <fullquery name="sel_opma_2dec_s">
       <querytext>
         select :cod_manutentore||coalesce(trim(to_char(max(to_number(substr(cod_opma,(length(:cod_manutentore) + 1)),'9999999999999000')) + 1, '99900')), '01') as cod_opma 
           from coimopma
          where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>


</queryset>
