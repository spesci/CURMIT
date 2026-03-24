<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_boll">
       <querytext>
select a.cod_bollini
     , iter_edit_data(a.data_consegna)   as data_consegna_edit
     , coalesce (b.cognome, ' ') ||' '|| coalesce (b.nome, ' ') as manutentore
     , iter_edit_num(a.nr_bollini, 0)    as nr_bollini_edit
     , iter_edit_num(a.nr_bollini_resi, 0) as nr_bollini_resi_edit
     , a.data_consegna
     , a.matricola_da
     , a.matricola_a
     , iter_edit_num (a.costo_unitario, 2) as costo_unitario
     , a.cod_manutentore
     , case pagati
            when 'S' then 'Si'
            when 'N' then 'No'
            else ' '
       end as pagati
     , iter_edit_num (((coalesce(a.nr_bollini, 0) - coalesce(a.nr_bollini_resi, 0)) * coalesce(a.costo_unitario, 0)), 2) as importo
     , c.descr_tpbo
     , iter_edit_num(imp_pagato, 2) as imp_pagato
     , d.descrizione as tipologia
     , e.num_fatt
  from coimboll a
  left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
  left outer join coimtpbo c on c.cod_tpbo        = a.cod_tpbo
  left outer join coimtpbl d on d.cod_tipo_bol    = a.cod_tpbl
  left outer join coimfatt e on e.matr_da = a.matricola_da and e.matr_a = a.matricola_a
 where cod_bollini = :cod_bollini
       </querytext>
    </partialquery>

    <partialquery name="sel_boap">
       <querytext>
select a.cod_boap
     , coalesce (b.cognome, ' ') ||' '|| coalesce (b.nome, ' ') as manutentore_a
     , iter_edit_num(a.nr_bollini, 0)    as nr_bollini_edit
     , a.matr_da
     , a.matr_a
     , a.note
  from coimboap a
  left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore_a
 where a.cod_bollini = :cod_bollini
       $where_a_cod_manutentore --rom01
       </querytext>
    </partialquery>


</queryset>

