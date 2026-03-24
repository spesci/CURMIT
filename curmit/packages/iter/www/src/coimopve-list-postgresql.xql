<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ==================================================================================================================
    mic01 28/07/2022 Riportata sul nuovo CVS la modifica rom01 fatta su iter-dev per la gestione della targatura solo su regione Friuli
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_opve">
       <querytext>
select cod_opve
     , cod_enve
     , coalesce(cod_portale, '') as cod_portale --mic01 28/07/2022
     , cognome
     , nome
     , matricola
     , case stato
       when '0' then 'Attivo'
       when '1' then 'Non attivo'
       else ''
       end as desc_stato
  from coimopve
 where 1 = 1
   and cod_enve = :cod_enve
$where_last
$where_word
order by cod_opve
       </querytext>
    </partialquery>

    <fullquery name="sel_enve">
       <querytext>
                 select ragione_01||' '||coalesce(ragione_02,'') as nome_enve
                   from coimenve
                  where cod_enve = :cod_enve
       </querytext>
    </fullquery>

</queryset>
