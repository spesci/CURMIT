<?xml version="1.0"?>

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

    <fullquery name="sel_campagna">
       <querytext>
                   select descrizione as desc_camp
                     from coimcinc
                    where cod_cinc = :f_campagna
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
              , c.flag_tipo_impianto
              , c.n_generatori 
              , iter_edit_data(a.data_verifica) as data_verifica_teo_edit
	      , iter_edit_data(a.data_verifica) as data_verifica
              , a.ora_verifica
              , i.descr_inst    as desc_stato
              , d.denominazione as comune
              , coalesce(e.descr_topo,'')||' '||coalesce(e.descrizione,'')||' '||coalesce(c.numero,'') as indirizzo_ext
              --mat01 , coalesce(b.cognome, '')||' '||coalesce(b.nome, '') as resp
              , $subquery_resp --mat01  
	      , coalesce(e.descrizione,'') as indirizzo
              , lpad(c.numero, 8, '0') as numero
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
                                                         when a.ora_verifica is null then '<font color=red><b>Riserva</b></font>'
                                                         else 'Effettivo'
                                                     end )
                                           end )
                    else ''
                end as tipo_app
              , f.descrizione as descr_camp
	      , a.stato as stato
               $desc_enve 
           from coiminco a
     inner join coimaimp c on c.cod_impianto  = a.cod_impianto
                          $where_area
     inner join coimcinc f on f.cod_cinc      = a.cod_cinc
      $pos_join_coimcitt b on b.cod_cittadino = c.cod_responsabile
      $pos_join_coimopve g on g.cod_opve      = a.cod_opve
      $pos_join_coimenve h on h.cod_enve      = g.cod_enve
left outer join coimcomu d on d.cod_comune    = c.cod_comune
left outer join coimviae e on e.cod_comune    = c.cod_comune
                          and e.cod_via       = c.cod_via
     inner join coiminst i on i.cod_inst      = a.stato
          where 1 = 1
         $where_cond
         $where_last_si_vie
       order by d.denominazione, e.descrizione, lpad(c.numero, 8, '0'), a.cod_inco
          limit $rows_per_page
       </querytext>
    </partialquery>

    <partialquery name="sel_inco_no_vie">
       <querytext>
         select a.cod_inco
              , a.cod_impianto
              , c.cod_impianto_est
              , c.flag_tipo_impianto
              , c.n_generatori 
              , iter_edit_data(a.data_verifica) as data_verifica_teo_edit
	      , iter_edit_data(a.data_verifica) as data_verifica
              , a.ora_verifica
              , i.descr_inst    as desc_stato
              , d.denominazione as comune
              , coalesce(c.toponimo,'')||' '||coalesce(c.indirizzo,'')||' '||coalesce(c.numero,'') as indirizzo_ext
              --mat01 , coalesce(b.cognome, '')||' '||coalesce(b.nome, '') as resp
              , $subquery_resp --mat01
	      , coalesce(c.indirizzo,'') as indirizzo
              , lpad(c.numero, 8, '0') as numero
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
                                                         when a.ora_verifica is null then '<font color=red><b>Riserva</b></font>'
                                                         else 'Effettivo'
                                                     end )
                                           end )
                    else ''
                end as tipo_app
              , f.descrizione as descr_camp
	      , a.stato as stato
              $desc_enve
           from coiminco a
     inner join coimaimp c on c.cod_impianto  = a.cod_impianto
                           $where_area
     inner join coimcinc f on f.cod_cinc      = a.cod_cinc
      $pos_join_coimcitt b on b.cod_cittadino = c.cod_responsabile
      $pos_join_coimopve g on g.cod_opve      = a.cod_opve
      $pos_join_coimenve h on h.cod_enve      = g.cod_enve
left outer join coimcomu d on d.cod_comune    = c.cod_comune
     inner join coiminst i on i.cod_inst      = a.stato
          where 1 = 1
         $where_cond
         $where_last_no_vie
       order by d.denominazione
               ,e.descrizione
              , lpad(c.numero, 8, '0')
              , a.cod_inco
          limit $rows_per_page
       </querytext>
    </partialquery>

    <fullquery name="sel_inco_count">
       <querytext>
         select iter_edit_num(count(*),0) as num_rec
           from coiminco a
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
