<?xml version="1.0"?>
/*
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 21/07/2022 Su richiesta della Provincia di Salerno aggiunta la colonna flag_blocca_rcee.
    rom01            Sandro ha detto che va bene per tutti.
*/

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_cinc_count">
       <querytext>
                   select count(*) as conta
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <fullquery name="sel_cinc">
       <querytext>
                   select cod_cinc
                        , descrizione as desc_camp
                     from coimcinc
                    where stato = '1'
       </querytext>
    </fullquery>

    <fullquery name="sel_inco">
       <querytext>
                    select 1
                      from coiminco
                     where cod_inco = :cod_inco
       </querytext>
    </fullquery>

    <fullquery name="sel_count_enve">
       <querytext>
                        select count(*) as conta_enve
                          from coimenve
                         where upper(ragione_01) = upper(:ragione_01)
        </querytext>
    </fullquery>

    <fullquery name="sel_enve2">
       <querytext>
                        select cod_enve
                          from coimenve
                         where upper(ragione_01) = upper(:ragione_01)
        </querytext>
    </fullquery>

    <fullquery name="sel_opve">
       <querytext>
                        select count(*) as conta
                          from coimopve
                         where cod_enve       = :cod_enve
                           and upper(cognome) = upper(:cogn_verif)
                           and upper(nome)    = upper(:nome_verif)
        </querytext>
    </fullquery>

    <fullquery name="sel_opve2">
       <querytext>
                        select cod_opve
			     , cod_enve as cod_enve_opve
                          from coimopve
                         where cod_enve       = :cod_enve
                           and upper(cognome) = upper(:cogn_verif)
                           and upper(nome)    = upper(:nome_verif)
        </querytext>
    </fullquery>

    <fullquery name="sel_stato_inco">
       <querytext>
                select stato as stato_inco
                  from coiminco
                 where cod_inco = :cod_inco
        </querytext>
    </fullquery>

    <partialquery name="upd_inco">
       <querytext>
                 update coiminco
                    set stato         = '2'
                      , data_verifica = :data_verifica_db
                      , ora_verifica  = :ora_verifica
                      , cod_opve      = :cod_opve
		      , flag_blocca_rcee = :upd_flag_blocca_rcee --rom01
                  where cod_inco      = :cod_inco
       </querytext>
    </partialquery>

</queryset>
