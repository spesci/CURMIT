<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sql_query">
        <querytext>
                   select cod_cittadino
                        , coalesce(cognome,'')||' '||coalesce(nome,'')     as nominativo
                        , cognome
                        , nome
                        , coalesce(indirizzo,'')||' '||coalesce(numero,'') as indirizzo
                        , comune
                        , cod_fiscale
                        , cod_piva --rom01
                        , case
                          when stato_citt = 'A' then
                               'Attivo'
                          when stato_citt = 'N' then
                               'Non attivo'
                          end as stato_citt
                     from coimcitt
                    where 1 = 1
                   $where_word
                   $where_nome
                   $where_cod_cittadino
                   $where_cod_fiscale
                   $where_cod_piva
                   $where_comune
                   $where_stato_citt
                   $where_key
                   $where_ammi
                 order by cognome
                        , nome
                        , cod_cittadino
       </querytext>
   </partialquery>

   <fullquery name="sel_conta_citt">
       <querytext>
           select iter_edit_num(count(*),0) as conta_num
             from coimcitt
           where 1=1
           $where_word
           $where_nome
           $where_cod_cittadino
           $where_cod_fiscale
           $where_cod_piva
	   $where_comune
       </querytext>
   </fullquery>

</queryset>
