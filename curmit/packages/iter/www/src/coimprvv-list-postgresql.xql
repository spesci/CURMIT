<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_prvv">
       <querytext>
select cod_prvv
     , case causale
       when 'MC' then 'Mancato pagamento'
       when 'SN' then 'Sanzione per inadempienze sull''impianto'
       when 'GE' then 'Generico'
       when 'CE' then 'Sollecito messa a norma del comune'
       else ''
       end as desc_causale
     , iter_edit_data(data_provv) as data_provv_edit
  from coimprvv
 where 1 = 1
   and cod_impianto = :cod_impianto
$where_last
$where_word
order by cod_prvv
       </querytext>
    </partialquery>

</queryset>
