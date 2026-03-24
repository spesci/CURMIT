<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_viae">
       <querytext>
             select cod_via
               from coimviae
              where cod_comune  = :f_comune
                and descr_topo  = upper(:f_desc_topo)
                and descrizione = upper(:f_desc_via)
       </querytext>
    </fullquery>

    <fullquery name="sel_conta_aimp">
       <querytext>
           select count(*) as conta_num
             from coimaimp a
	     $sogg_join
   $citt_join_pos coimcitt b
               on b.cod_cittadino = a.cod_responsabile
   $gend_join_pos
   $join_bollino
            where 1 = 1
           $where_impianto
           $where_cogn
           $where_nome
           $where_comune
           $where_via
           $where_civico
	   $where_matricola
	   $where_modello
	   $where_costruttore
           $where_pdr
	   $where_bollino
	   $where_targa
	   $where_cod_fiscale --ric01
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_aimp">
       <querytext>
           select a.cod_impianto
             from coimaimp a
	     $sogg_join
   $citt_join_pos coimcitt b
               on b.cod_cittadino = a.cod_responsabile
   $gend_join_pos
   $join_bollino
            where 1 = 1
           $where_impianto
           $where_cogn
           $where_nome
           $where_comune
           $where_via
           $where_civico
	   $where_matricola
	   $where_modello
	   $where_costruttore
           $where_pdr
	   $where_bollino
	   $where_targa
	   $where_cod_fiscale --ric01
       </querytext>
    </fullquery>

    <partialquery name="sogg_join">
       <querytext>
        inner join coimcitt e on a.cod_responsabile = e.cod_cittadino
                              or a.cod_intestatario = e.cod_cittadino 
                              or a.cod_proprietario = e.cod_cittadino
                              or a.cod_occupante    = e.cod_cittadino
                              or a.cod_amministratore = e.cod_cittadino
       </querytext>
    </partialquery>

    <partialquery name="where_sogg">
       <querytext>
          and e.cod_cittadino = :cod_cittadino
       </querytext>
    </partialquery>

</queryset>
