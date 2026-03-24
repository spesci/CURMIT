<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_opma">
       <querytext>
select cod_opma
     , cod_manutentore
     , cognome
     , nome
     , matricola
     , case stato
       when '0' then 'Attivo'
       when '1' then 'Non attivo'
       else ''
       end as desc_stato
     , email_operator  --but01
  from coimopma
 where 1 = 1
   and cod_manutentore = :cod_manutentore
$where_last
$where_word
$where_stato
order by cod_opma
       </querytext>
    </partialquery>

    <fullquery name="sel_manu">
       <querytext>
                 select cognome||' '||coalesce(nome,'') as nome_manu
                   from coimmanu
                  where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

</queryset>
