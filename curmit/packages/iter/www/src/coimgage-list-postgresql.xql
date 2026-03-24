<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_gage_si_vie">
       <querytext>
select a.cod_opma
     , a.cod_impianto
     , case
         when a.stato = '1' then 'Da Eseg.'
         when a.stato = '2' then 'Eseguito'
       end                               as stato_ed
     , a.stato
     , iter_edit_data(a.data_prevista)   as data_prevista_edit
     , iter_edit_data(a.data_esecuzione) as data_esecuzione_edit
     , a.data_prevista
     , a.data_esecuzione
     , a.data_ins
     , c.denominazione       as comune
     , coalesce(d.descr_topo,'')||' '||
       coalesce(d.descrizione,'')||' '||
       coalesce(b.numero,'') as indir
     , d.descrizione         as via
     , b.numero
     , b.cod_impianto_est
     , coalesce(e.cognome,' ')||' '||coalesce(e.nome,' ')   as resp
     , coalesce(e.telefono, '/')||' '|| coalesce(e.cellulare, '/') as tel
     , coalesce(substr(a.note,1,20), '/') as not
  from coimgage a
       inner join coimaimp b on b.cod_impianto  = a.cod_impianto
                            and b.stato         = 'A'
  left outer join coimcomu c on c.cod_comune    = b.cod_comune
  left outer join coimviae d on d.cod_comune    = b.cod_comune
                            and d.cod_via       = b.cod_via
  left outer join coimcitt e on e.cod_cittadino = b.cod_responsabile
 where 1 = 1
   and a.cod_opma          = :cod_manutentore
$where_last
$where_word
$where_stato
$where_data_iniz
$where_data_fine
$ordinamento
limit $rows_per_page
       </querytext>
    </partialquery>

    <partialquery name="sel_gage_no_vie">
       <querytext>
select a.cod_opma
     , a.cod_impianto
     , case
         when a.stato = '1' then 'Da eseguire'
         when a.stato = '2' then 'Eseguito'
       end                               as stato_ed
     , a.stato
     , iter_edit_data(a.data_prevista)   as data_prevista_edit
     , iter_edit_data(a.data_esecuzione) as data_esecuzione_edit
     , a.data_prevista
     , a.data_esecuzione
     , a.data_ins
     , c.denominazione       as comune
     , coalesce(b.toponimo,'')||' '||
       coalesce(b.indirizzo,'')||' '||
       coalesce(b.numero,'') as indir
     , b.indirizzo           as via
     , b.numero
     , b.cod_impianto_est
     , coalesce(e.cognome,' ')||' '||coalesce(e.nome,' ')   as resp
     , coalesce(e.telefono, '/')||' '|| coalesce(e.cellulare, '/') as tel
     , coalesce(substr(a.note,1,20), '/') as not
  from coimgage a 
       inner join coimaimp b on b.cod_impianto  = a.cod_impianto
                            and b.stato         = 'A'
  left outer join coimcomu c on c.cod_comune    = b.cod_comune
  left outer join coimcitt e on e.cod_cittadino = b.cod_responsabile
 where 1 = 1
   and a.cod_opma  = :cod_manutentore
$where_last
$where_word
$where_stato
$where_data_iniz
$where_data_fine
$ordinamento
limit $rows_per_page
       </querytext>
    </partialquery>

</queryset>
