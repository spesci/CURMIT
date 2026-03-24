<?xml version="1.0"?>
/*
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 15/01/2024 Aguinto la colonna codice fiscale, e ho valorizzato il campo codice impianto
    but01                 con il codice_impianto_est.

    rom02 12/01/2024 Sandro ha chiesto di aggiungere le colonne stato e motivo annullamento
    rom02            al file di scarico, va bnee per tutti gli enti.

    rom01 21/07/2022 Su richiesta della Provincia di Salerno aggiunta la colonna flag_blocca_rcee.
    rom01            Sandro ha detto che va bene per tutti.
*/

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_inco_si_vie">
       <querytext>
        select a.cod_inco
             , c.cod_impianto
             , coalesce(b.indirizzo,'')||' '||
               coalesce(b.numero,'') as indirizzo_sogg
	     , coalesce(b.indirizzo,'')||' '||
               coalesce(b.numero,'') as indir
             , b.cap       as cap_sogg
             , b.comune    as comune_sogg
             , b.provincia as provincia_sogg
             , b.telefono  as telefono
             , b.note      as note
             , b.localita  as localita
             , coalesce(e.descr_topo,'')||' '||
               coalesce(e.descrizione,'')||' '||
               coalesce(c.numero,'') as indirizzo_ext
             , c.numero as numero
             , coalesce(b.cognome,'')||' '||
               coalesce(b.nome, '') as resp
             , c.cap    
             , d.denominazione as comune
	     , case a.flag_blocca_rcee
	       when 't' then 'Si'
	       when 'f' then 'No'
	       else ''  end as flag_blocca_rcee --rom01 case e contenuto
	     , i.descr_inst as des_stato        --rom02
	     , n.descr_noin                     --rom02  
             , b.cod_fiscale  as cod_fiscale                        --but01
	     , c.cod_impianto_est as cod_impianto_est                --but01
              from coiminco a  
	       inner join coimaimp c on c.cod_impianto  = a.cod_impianto
          left outer join coimcitt b on b.cod_cittadino = c.cod_responsabile
          left outer join coimcomu d on d.cod_comune    = c.cod_comune
          left outer join coimviae e on e.cod_comune    = c.cod_comune
                                    and e.cod_via       = c.cod_via
          left outer join coiminst i on i.cod_inst      = a.stato    --rom02
	  left outer join coimnoin n on n.cod_noin      = a.cod_noin --rom02
         where a.cod_cinc        = :cod_cinc
           and a.stato    = '0' 
	 $where_comb
         $where_anno_inst_da    	   
         $where_anno_inst_a
 	 $where_data
  	 $where_codice
	 $where_tecn
         $where_enve
	 $where_esito
	 $where_comune
	 $where_via
	 $where_tipo_estr
         order by b.cognome, b.nome, a.cod_inco
        $limit_pos 
       </querytext>
    </fullquery>

    <fullquery name="sel_inco_no_vie">
       <querytext>
        select a.cod_inco
             , c.cod_impianto
             , coalesce(b.indirizzo,'')||' '||
               coalesce(b.numero,'') as indirizzo_sogg
	     , coalesce(b.indirizzo,'')||' '||
               coalesce(b.numero,'') as indir
             , b.cap           as cap_sogg
             , b.comune        as comune_sogg
             , b.provincia     as provincia_sogg
             , b.telefono      as telefono
             , b.note          as note
             , b.localita      as localita
             , coalesce(c.toponimo,'')||' '||
               coalesce(c.indirizzo,'')||' '||
               coalesce(c.numero,'') as indirizzo_ext
             , c.numero as numero
             , coalesce(b.cognome,'')||' '||
               coalesce(b.nome, '') as resp
             , c.cap
             , d.denominazione as comune
	     , case a.flag_blocca_rcee
	       when 't' then 'Si'
	       when 'f' then 'No'
	       else ''  end as flag_blocca_rcee --rom01 case e contenuto
             , i.descr_inst as des_stato        --rom02
	     , n.descr_noin                     --rom02
	     , b.cod_fiscale  as cod_fiscale                        --but01
             , c.cod_impianto_est  as cod_impianto_est              --but01
          from coiminco a
	       inner join coimaimp c on c.cod_impianto    = a.cod_impianto
          left outer join coimcitt b on b.cod_cittadino = c.cod_responsabile
          left outer join coimcomu d on d.cod_comune    = c.cod_comune
          left outer join coiminst i on i.cod_inst      = a.stato    --rom02
	  left outer join coimnoin n on n.cod_noin      = a.cod_noin --rom02
         where a.cod_cinc = :cod_cinc
           and a.stato    = '0'    
	 $where_comb
         $where_anno_inst_da    	   
         $where_anno_inst_a
 	 $where_data
  	 $where_codice
         $where_enve
	 $where_tecn
	 $where_esito
	 $where_comune
         $where_via
	 $where_tipo_estr
        order by b.cognome, b.nome, a.cod_inco
        $limit_pos  
       </querytext>
    </fullquery>

    <partialquery name="upd_inco">
       <querytext>
                 update coiminco
                    set stato = '0'
                  where cod_inco in ($in_cod_inco)
       </querytext>
    </partialquery>

    <partialquery name="upd_inco2">
       <querytext>
                 update coiminco
                    set stato    = '2'
                      , cod_opve = :f_cod_tecn
                  where cod_inco in ($in_cod_inco)
       </querytext>
    </partialquery>

    <fullquery name="sel_tecn">
       <querytext>
             select nome    as nome_verif
                  , cognome as cogn_verif
               from coimopve
              where cod_enve       = :f_cod_enve
                and cod_opve       = :f_cod_tecn
       </querytext>
    </fullquery>

    <fullquery name="sel_enve">
       <querytext>
             select ragione_01
               from coimenve
              where cod_enve       = :f_cod_enve
       </querytext>
    </fullquery>

</queryset>
