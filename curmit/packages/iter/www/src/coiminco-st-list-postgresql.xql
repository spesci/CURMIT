<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =====================================================================================
    rom01 27/03/2023 I vari campi estratti con la substr ora vengono letti con la funzione iter_edit_data

-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_cinc_count">
       <querytext>
                   select count(*) as conta
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <fullquery name="sel_cinc">
       <querytext>
                   select cod_cinc
                        , descrizione as desc_camp
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <partialquery name="descrizione_enve_opve">
        <querytext>
         , h.ragione_01||' - '||g.cognome||' '||coalesce(g.nome,'')  as descr_enve	
	</querytext>
    </partialquery>

    <partialquery name="descrizione_opve">
        <querytext>
         ,  g.cognome||' '||coalesce(g.nome,'')  as descr_enve	
	</querytext>
    </partialquery>

    <partialquery name="sel_inco_si_vie">
       <querytext>
         select a.cod_inco
              , a.cod_impianto
              , c.cod_impianto_est
              , iter_edit_data(a.data_verifica) as data_verifica_teo_edit
              , a.ora_verifica
              , i.descr_inst    as desc_stato
              , d.denominazione as comune
              , coalesce(e.descr_topo,'')||' '||
                coalesce(e.descrizione,'')||' '||
                coalesce(c.numero,'') as indirizzo_ext
              , coalesce(b.cognome, '')||' '||coalesce(b.nome, '') as resp
              , coalesce(e.descrizione,'') as indirizzo
              , b.cognome
              , b.nome
              , b.telefono
              , case a.tipo_lettera
                    when 'A' then 'Aperta'
                    when 'C' then 'Chiusa'
		    else ''
                end as tipo_lettera_desc
              , case a.stato
                    when '2' then (case
                                               when a.data_verifica is null then ''
                                               else (case
                                                         when a.ora_verifica is null then 'Riserva'
                                                         else 'Effettivo'
                                                     end )
                                           end )
                    else ''
                end as tipo_app
              , f.descrizione as descr_camp
	      , substr(z.descr_tpes,1,40)||'...' as tipo_estrazione
              , a.st_utente
     -- rom01 , substr(a.st_data_validita, 9, 2)||'/'||substr(a.st_data_validita, 6, 2)||'/'||substr(a.st_data_validita, 1, 4) as st_data_validita
     -- rom01 , substr(a.st_data_validita, 12, 8) as st_ora_validita
              , iter_edit_data(date(a.st_data_validita)) as st_data_validita -- rom01
              , to_char(a.st_data_validita,'HH24:MI:SS') as st_ora_validita  -- rom01
              , a.st_progressivo                                             -- rom01
	      , z.descr_tpes as tipo_estrazione_long
               $desc_enve 
           from coiminco_st a
     inner join coimaimp c on c.cod_impianto  = a.cod_impianto
     inner join coimcinc f on f.cod_cinc      = a.cod_cinc
      $pos_join_coimcitt b on b.cod_cittadino = c.cod_responsabile
      $pos_join_coimopve g on g.cod_opve      = a.cod_opve
      $pos_join_coimenve h on h.cod_enve      = g.cod_enve
left outer join coimcomu d on d.cod_comune    = c.cod_comune
left outer join coimviae e on e.cod_comune    = c.cod_comune
                          and e.cod_via       = c.cod_via
     inner join coiminst i on i.cod_inst      = a.stato
     left outer join coimtpes z on z.cod_tpes = a.tipo_estrazione
          where 1 = 1
         $where_cond
         $where_last_si_vie
       order by st_progressivo desc
          limit $rows_per_page
       </querytext>
    </partialquery>

    <partialquery name="sel_inco_no_vie">
       <querytext>
         select a.cod_inco
              , a.cod_impianto
              , c.cod_impianto_est
              , iter_edit_data(a.data_verifica) as data_verifica_teo_edit
              , a.ora_verifica
              , i.descr_inst    as desc_stato
              , d.denominazione as comune
              , coalesce(c.toponimo,'')||' '||
                coalesce(c.indirizzo,'')||' '||
                coalesce(c.numero,'') as indirizzo_ext
              , coalesce(b.cognome, '')||' '||coalesce(b.nome, '') as resp
              , coalesce(c.indirizzo,'') as indirizzo
              , b.cognome
              , b.nome
              , b.telefono
              , case a.tipo_lettera
                    when 'A' then 'Aperta'
                    when 'C' then 'Chiusa'
		    else ''
                end as tipo_lettera_desc
              , case a.stato
                    when '2' then (case
                                               when a.data_verifica is null then ''
                                               else (case
                                                         when a.ora_verifica is null then 'Riserva'
                                                         else 'Effettivo'
                                                     end )
                                           end )
                    else ''
                end as tipo_app
              , a.st_utente
   -- rom01   , substr(a.st_data_validita, 9, 2)||'/'||substr(a.st_data_validita, 6, 2)||'/'||substr(a.st_data_validita, 1, 4) as st_data_validita
   -- rom01   , substr(a.st_data_validita, 12, 8) as st_ora_validita
              , iter_edit_data(date(a.st_data_validita)) as st_data_validita -- rom01
              , to_char(a.st_data_validita,'HH24:MI:SS') as st_ora_validita  -- rom01
              , a.st_progressivo                                             -- rom01
              , f.descrizione as descr_camp
              $desc_enve
           from coiminco_st a
     inner join coimaimp c on c.cod_impianto  = a.cod_impianto
     inner join coimcinc f on f.cod_cinc      = a.cod_cinc
      $pos_join_coimcitt b on b.cod_cittadino = c.cod_responsabile
      $pos_join_coimopve g on g.cod_opve      = a.cod_opve
      $pos_join_coimenve h on h.cod_enve      = g.cod_enve
left outer join coimcomu d on d.cod_comune    = c.cod_comune
     inner join coiminst i on i.cod_inst      = a.stato
          where 1 = 1
         $where_cond
         $where_last_no_vie
       order by st_progressivo desc
          limit $rows_per_page
       </querytext>
    </partialquery>

    <fullquery name="sel_inco_count">
       <querytext>
         select iter_edit_num(count(*),0) as num_rec
           from coiminco_st a
     inner join coimaimp c on c.cod_impianto  = a.cod_impianto
      $pos_join_coimcitt b on b.cod_cittadino = c.cod_responsabile
      $pos_join_coimopve g on g.cod_opve      = a.cod_opve
      $pos_join_coimenve h on h.cod_enve      = g.cod_enve
          where 1 = 1
         $where_cond
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_enve">
        <querytext>
	   select cod_enve 
             from coimopve 
	    where cod_opve = :f_cod_tecn
	</querytext>
    </fullquery>

    <fullquery name="sel_cmar">
       <querytext>
           select cod_comune
             from coimcmar
            where cod_area = :f_cod_area
       </querytext>
    </fullquery>

    <fullquery name="sel_area_tipo_01">
       <querytext>
               select tipo_01
                 from coimarea 
                where cod_area = :f_cod_area
       </querytext>
    </fullquery>


</queryset>
