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
  

    <fullquery name="sel_stat_ma">
       <querytext>
select to_char(a.data_controllo, 'dd/mm/yyyy') as data_controllo_edit
   , a.data_controllo as data_controllo
  , a.cod_cimp as codice_ma
  , b.cod_impianto_est as cod_impianto_est
  , coalesce(d.descr_topo,'')||' '||coalesce(d.descrizione,'')||
  case  when b.numero is null then ''
  else ', '||b.numero  end ||
  case  when b.esponente is null then ''
  else '/'||b.esponente  end ||
  case  when b.scala is null then ''
  else ' S.'||b.scala  end ||
  case  when b.piano is null then ''
  else ' P.'||b.piano  end ||
  case  when b.interno is null then ''
  else ' In.'||b.interno
  end	 as indirizzo
, c.denominazione as comune
, coalesce (e.cognome,'')|| ' ' ||coalesce(e.nome,' ') as nome_resp	
, coalesce (a.cod_noin, '') as cod_noin
, coalesce (f.descr_noin, ' ') as descr_noin	
, coalesce (a.cod_opve, '') as cod_opve
, note_verificatore 
, coalesce (g.cod_inco, '') as cod_inco
, case g.stato 
               when '8' then 'Effettuato'
               when '5' then 'Annullato'
               when '3' then 'Spedito'
               when '4' then 'Confermato' 
               when '2' then 'Assegnato'
           else ''
         end  as stato_inco
, iter_edit_num(coalesce(m.importo, '0'), 2) as importo_mov --rom01
, case m.flag_pagato
  when 'S' then 'Si'
  when 'N' then 'No'
  when 'R' then 'Rimborsato'
  else ''  end as flag_pagato_mov            --rom01
, iter_edit_data(m.data_pag) as data_pag_mov --rom01
from coimcimp a
left outer join coiminco g on g.cod_inco = a.cod_inco
left outer join coimnoin f on f.cod_noin = a.cod_noin
left outer join coimmovi m on m.riferimento = a.cod_cimp and m.data_compet = a.data_controllo --rom01
,coimaimp b
,coimviae d
,coimcomu c
,coimcitt e
where b.cod_impianto  = a.cod_impianto
and d.cod_via  = b.cod_via
and c.cod_comune  = b.cod_comune
and e.cod_cittadino  = b.cod_responsabile
and a.flag_tracciato = 'MA'
$where_data
$where_tecn
$where_tipo_imp
       </querytext>
    </fullquery>


    <fullquery name="sel_movi">
       <querytext>
    select case a.tipo_movi 
               when 'MH' then 'Pagamento per mod.G'
               when 'VC' then 'Pagamento onere visita di controllo'
               when 'ST' then 'Sanzione tecnica'
               when 'SA' then 'Sanzione amministrativa' 
           end as tipo_movi
         , b.cod_impianto_est
         , iter_edit_data(a.data_scad) as data_scad
         , iter_edit_num(a.importo, 2) as importo
         , coalesce(c.cognome, '')||' '||coalesce(c.nome, '') as resp
         , d.denominazione as comune
      from coimmovi a 
           inner join coimaimp b on b.cod_impianto  = a.cod_impianto 
                                and b.stato = 'A'
      left outer join coimcitt c on c.cod_cittadino = b.cod_responsabile 
      left outer join coimcomu d on d.cod_comune    = b.cod_comune
     where a.data_scad < current_date
       and a.data_pag is null
     $where_data
     $where_tipo
     $where_comune
     $where_tipo_imp
     order by d.denominazione
       </querytext>
    </fullquery>

    <fullquery name="estrai_data">
       <querytext>
       select iter_edit_data(current_date) as data_time
       </querytext>
    </fullquery>

    <fullquery name="edit_date_dual">
       <querytext>
        select iter_edit_data(:f_data_da) as data_da_e
             , iter_edit_data(:f_data_a) as data_a_e
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_enve">
       <querytext>
	  select cod_enve
            from coimopve
           where cod_opve = :cod_tecn
       </querytext>
    </fullquery>

    <fullquery name="sel_tecn">
       <querytext>
             select cognome as f_cog_tecn
                  , nome    as f_nom_tecn
               from coimopve
              where cod_opve = :f_cod_tecn
       </querytext>
    </fullquery>

    <fullquery name="sel_tecn_nom">
       <querytext>
             select cod_opve as cod_tecn_db
               from coimopve
              where cod_enve       = :f_cod_enve
                and upper(nome)    = upper(:f_nom_tecn)
                and upper(cognome) = upper(:f_cog_tecn)
       </querytext>
    </fullquery>

</queryset>
