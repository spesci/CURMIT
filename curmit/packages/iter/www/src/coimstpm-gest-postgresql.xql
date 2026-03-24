<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_stpm_s">
        <querytext>
          select nextval('coimstpm_s') as id_stampa
       </querytext>
    </fullquery>

    <partialquery name="ins_stpm">
       <querytext>
             insert
                  into coimstpm 
                     ( id_stampa
                     , descrizione
                     , testo
                     , campo1
                     , campo1_testo
                     , campo2
                     , campo2_testo
                     , campo3
                     , campo3_testo
                     , campo4
                     , campo4_testo
                     , campo5
                     , campo5_testo
                     , var_testo
                     , allegato
                     , tipo_foglio
                     , orientamento
                     , tipo_documento
                     , margine_alto        --but01
                     , margine_basso       --but01
                     , margine_destro      --but01
                     , margine_sinistro    --but01
		     )   
                values 
                     (:id_stampa
                     ,:descrizione
                     ,:testo
                     ,:campo1
                     ,:campo1_testo
                     ,:campo2
                     ,:campo2_testo
                     ,:campo3
                     ,:campo3_testo
                     ,:campo4
                     ,:campo4_testo
                     ,:campo5
                     ,:campo5_testo
                     ,:var_testo
                     ,:allegato
                     ,:tipo_foglio
                     ,:orientamento
                     ,:tipo_documento
		     ,:margine_alto         --but01
                     ,:margine_basso        --but01
                     ,:margine_destro       --but01
                     ,:margine_sinistro     --but01
		     )
       </querytext>
    </partialquery>

    <partialquery name="upd_stpm">
       <querytext>
                update coimstpm
                   set descrizione       = :descrizione
                     , testo             = :testo
                     , campo1            = :campo1
                     , campo1_testo      = :campo1_testo
                     , campo2            = :campo2
                     , campo2_testo      = :campo2_testo
                     , campo3            = :campo3
                     , campo3_testo      = :campo3_testo
                     , campo4            = :campo4
                     , campo4_testo      = :campo4_testo
                     , campo5            = :campo5
                     , campo5_testo      = :campo5_testo
                     , var_testo         = :var_testo
                     , allegato          = :allegato
                     , tipo_foglio       = :tipo_foglio
                     , orientamento      = :orientamento
                     , tipo_documento    = :tipo_documento
		     , margine_alto      = :margine_alto       --but01
                     , margine_basso     = :margine_basso      --but01
                     , margine_destro    = :margine_destro     --but01
                     , margine_sinistro  = :margine_sinistro   --but01
                 where id_stampa         = :id_stampa
       </querytext>
    </partialquery>

    <partialquery name="del_stpm">
       <querytext>
                delete
                  from coimstpm
                 where id_stampa = :id_stampa
       </querytext>
    </partialquery>

    <fullquery name="sel_stpm">
       <querytext>
       select id_stampa
	    , testo
	    , descrizione
	    , campo1
	    , campo1_testo
	    , campo2
            , campo2_testo
	    , campo3
            , campo3_testo
	    , campo4
            , campo4_testo
            , campo5
            , campo5_testo
            , var_testo
            , allegato
            , tipo_foglio
            , orientamento
            , tipo_documento
	    , iter_edit_num(margine_alto,2)      as margine_alto     --but01
            , iter_edit_num(margine_basso,2)     as margine_basso    --but01
            , iter_edit_num(margine_destro ,2)   as margine_destro   --but01
            , iter_edit_num(margine_sinistro ,2) as margine_sinistro --but01
         from coimstpm
        where id_stampa = :id_stampa
       </querytext>
    </fullquery>

    <fullquery name="check_exists">
       <querytext>
        select '1'
          from coimstpm
         where id_stampa = :id_stampa
       </querytext>
    </fullquery>
    
</queryset>
