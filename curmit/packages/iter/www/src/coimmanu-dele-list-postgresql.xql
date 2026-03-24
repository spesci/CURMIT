<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 27/01/2026 Modificata query perchè la paginazione andava in errore se il numero delle
    ric01            deleghe era maggiore delle righe per pagina dell'utente (T. 13356)

    -->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_manu">
       <querytext>
       select a.cod_manutentore as cod_manu_dele
            , coalesce(a.cognome,'')||' '||coalesce(a.nome,'') as rag_sociale_delegato
            , coalesce(a.cognome,'') as cognome  --ric01 
         from coimdele d
	    , coimmanu a
	where d.cod_manutentore = :cod_manutentore
	  and d.cod_manutentore_inst = a.cod_manutentore
	  and coalesce(d.delegation_state, 'D') = 'A'
	  and current_date between start_date and end_date
	  $where_last  --ric01
	  $where_word  --ric01
	  order by a.cod_manutentore, a.cognome	  --ric01
       </querytext>
    </partialquery>
    
</queryset>
