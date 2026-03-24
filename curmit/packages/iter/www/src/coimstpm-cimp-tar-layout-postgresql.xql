<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="sel_desc_comu">
<querytext>
    select denominazione as desc_comune
      from coimcomu
     where cod_comune = :f_cod_comune
</querytext>
</fullquery>

<fullquery name="sel_cimp_tar">
<querytext>
   select distinct
          f.denominazione                                   as comune
        , g.ragione_01                                      as nome_ente
        , coalesce(c.cognome,'')||' '||coalesce(c.nome,' ') as nome_opve
        , e.cod_impianto_est
        , h.cognome||' '||coalesce(h.nome, '')              as responsabile
        , iter_edit_num(a.costo,2)                          as costo
        , tp.descrizione                                    as tipo_costo
        , (select iter_edit_num(r.importo, 2)
             from coimtari r
            where r.cod_potenza = e.cod_potenza
              and r.tipo_costo  = 2
              and r.cod_listino = '0'
              and r.data_inizio = (select max(r1.data_inizio)
                                     from coimtari r1
                                    where r1.cod_potenza  = e.cod_potenza
                                      and r1.tipo_costo   = 2
                                      and r1.cod_listino  = '0'
                                      and r1.data_inizio <= a.data_controllo)
          )                                                 as tariffa
        , t.descr_tpes                                      as tp_estr
        , a.numfatt
        , a.gen_prog
        , case a.esito_verifica
               when 'P' then 'Positivo'
               when 'N' then 'Negativo'
               else ''
          end                                               as esito
 
        , case 
              when data_scad_dich < current_date then 'Si'
              else 'No'
          end                                               as scaduta

        , coalesce(i.cod_inco,'')                           as cod_inco 

        , case e.stato
               when 'A' then 'Attivo'
               when 'L' then 'Annullato'
               when 'N' then 'Non Attivo'
               else 'Altro'
          end                                               as stat_imp
        , iter_edit_num(m.importo, 2) as importo_mov --rom01
        , case m.flag_pagato
          when 'S' then 'Si'
          when 'N' then 'No'
	  when 'R' then 'Rimborsato'
          else ''  end as flag_pagato_mov            --rom01
        , iter_edit_data(m.data_pag) as data_pag_mov --rom01
     from coimcimp   a
left join coimcitt   h  on h.cod_cittadino = a.cod_responsabile
left join coimtp_pag tp on tp.cod_tipo_pag = a.tipologia_costo
left join coiminco   i  on i.cod_inco      = a.cod_inco
left join coimmovi   m  on m.riferimento   = a.cod_cimp and m.data_compet= a.data_controllo--rom01
	, coimaimp e
        , coimcomu f
        , coimopve c
        , coimenve g
        , coimtpes t
    where 1                 = 1
   $where_data
   $where_opve
   $where_costo
      and a.flag_tracciato <> 'MA'
      and e.cod_impianto    = a.cod_impianto
   $where_comune
   $where_tipo_imp
      and f.cod_comune      = e.cod_comune
      and c.cod_opve        = a.cod_opve
      and g.cod_enve        = c.cod_enve
      and cod_tpes          = tipo_estrazione
      and a.flag_tracciato <> 'AC' --mic01
      order by comune
        , nome_ente
        , nome_opve
        , cod_impianto_est
</querytext>
</fullquery>

<fullquery name="sel_stat_ma">
<querytext>
select  iter_edit_data(a.data_controllo) as data_controllo
      , a.cod_cimp as codice_ma
      , e.cod_impianto_est as cod_impianto_est
      , coalesce(v.descr_topo,'')||' '||coalesce(v.descrizione,'')||
        case  when e.numero is null then ''
        else ', '||e.numero  end ||
        case  when e.esponente is null then ''
        else '/'||e.esponente  end ||
        case  when e.scala is null then ''
        else ' S.'||e.scala  end ||
        case  when e.piano is null then ''
        else ' P.'||e.piano  end ||
        case  when e.interno is null then ''
        else ' In.'||e.interno
        end	 as indirizzo
      , f.denominazione as comune
      , coalesce (h.cognome,'')||' '||coalesce(h.nome,' ') as nome_resp	
      , coalesce (a.cod_noin, '')    as cod_noin
      , coalesce (n.descr_noin, ' ') as descr_noin	
      , iter_edit_num(m.importo, 2) as importo_mov --rom01
      , case m.flag_pagato
        when 'S' then 'Si'
        when 'N' then 'No'
        else ''  end as flag_pagato_mov            --rom01
      , iter_edit_data(m.data_pag) as data_pag_mov --rom01
   from coimcimp a
   left outer join coimmovi m on a.cod_cimp = m.riferimento and m.data_compet = a.data_controllo
      , coimaimp e
      , coimviae v
      , coimcomu f
      , coimcitt h
      , coimnoin n
  where e.cod_impianto   = a.cod_impianto
    and v.cod_via        = e.cod_via
    and f.cod_comune     = e.cod_comune
    and h.cod_cittadino  = e.cod_responsabile
    and a.cod_noin       = n.cod_noin
    and a.flag_tracciato = 'MA'
    and a.flag_tracciato <> 'AC' --mic01
       $where_data
       $where_opve
       $where_costo
       $where_comune
       $where_tipo_imp
</querytext>
</fullquery>

<fullquery name="estrai_data">
<querytext>
select iter_edit_data(sysdate) as data_time
  from dual
</querytext>
</fullquery>

<fullquery name="edit_date_dual">
<querytext>
select iter_edit_data(:f_data_da) as data_da_e
     , iter_edit_data(:f_data_a)  as data_a_e
  from dual
</querytext>
</fullquery>

</queryset>



