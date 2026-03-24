<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    rom02 10/03/2023 Riportato vecchio controllo fatto sul vecchio cvs su query sel_ruolo_manu e sel_ruolo_inst:
    rom02            il flag_ruolo era gestito erronemante.

    rom01 11/12/2020 Per Regione Marche non vado a fare l'update su pod e pdr perche' sono stati spostati
    rom01            nella scheda 1-bis.
-->
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="upd_aimp_tecn">
       <querytext>
           update coimaimp
              set cod_manutentore     = :cod_manutentore
                , cod_installatore    = :cod_installatore
                , cod_distributore    = :cod_distributore
                , cod_progettista     = :cod_progettista 
                , cod_amag            = :cod_amag
                , data_mod            =  current_date
                , utente              = :id_utente
       --rom01  , pdr                 = :pdr
       --rom01  , pod                 = :pod
                $update_pod_pdr                            --rom01
                , cod_distributore_el = :cod_distributore_el
            where cod_impianto        = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="ins_rife">
       <querytext>
           insert
             into coimrife 
                ( cod_impianto
                , ruolo
                , data_fin_valid
                , cod_soggetto
                , data_ins           
                , utente)             
           values
                (:cod_impianto
                ,:ruolo
                ,:data_fin_valid
                ,:db_cod_soggetto
                , current_date        
                ,:id_utente)   
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_tecn">
       <querytext>
           select a.cod_impianto
                , a.cod_manutentore
                , a.cod_installatore
                , a.cod_distributore
                , a.cod_progettista
                , a.cod_amag
                , a.pdr
                , a.pod
                , a.cod_distributore_el
                , iter_edit_data(a.data_installaz)  as data_installaz
                , b.cognome as cognome_manu
                , b.nome    as nome_manu
                , c.cognome as cognome_inst
                , c.nome    as nome_inst
                , d.ragione_01 
                , e.cognome as cognome_prog
                , e.nome    as nome_prog
             from coimaimp a
  left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
  left outer join coimmanu c on c.cod_manutentore = a.cod_installatore
  left outer join coimdist d on d.cod_distr       = a.cod_distributore
  left outer join coimprog e on e.cod_progettista = a.cod_progettista
            where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_manu">
       <querytext>
           select cod_manutentore as cod_manu_db
             from coimmanu
            where cognome $eq_cognome
              and nome    $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_prog">
       <querytext>
           select cod_progettista
             from coimprog
            where cognome $eq_cognome
              and nome    $eq_nome
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_db">
       <querytext>
           select cod_manutentore     as db_cod_manutentore
                , cod_installatore    as db_cod_installatore
                , cod_distributore    as db_cod_distributore
                , cod_progettista     as db_cod_progettista
                , cod_amag            as db_cod_amag
                , cod_distributore_el as db_cod_distributore_el
                , pdr                 as db_pdr
                , pod                 as db_pod
             from coimaimp 
            where cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_rife_check">
       <querytext>
           select '1'
             from coimrife
            where cod_impianto   = :cod_impianto
              and ruolo          = :ruolo
              and data_fin_valid = :data_fin_valid
       </querytext>
    </fullquery>

    <fullquery name="sel_rife_max_data">
       <querytext>
           select to_char(max(data_fin_valid), 'yyyymmdd')
             from coimrife
            where cod_impianto  = :cod_impianto
              and ruolo        in ('M', 'I', 'D', 'G')
       </querytext>
    </fullquery>

    <fullquery name="sel_ruolo_manu">
       <querytext>
           select '1'
             from coimmanu
            where (cognome = upper(:cognome_manu) $eq_nome_manu)
    --rom02   and (flag_ruolo = 'M' or flag_ruolo = 'T' or flag_ruolo is null or flag_ruolo = 'E') 
              and (flag_ruolo is null or flag_ruolo != 'I') --rom02
             limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_ruolo_inst">
       <querytext>
           select '1'
             from coimmanu
            where (cognome = upper(:cognome_inst) $eq_nome_inst)
    --rom02   and (flag_ruolo = 'I' or flag_ruolo = 'T' or flag_ruolo is null or flag_ruolo = 'E')
              and (flag_ruolo is null or flag_ruolo != 'M') --rom02
             limit 1
       </querytext>
    </fullquery>

    <fullquery name="sel_cod_todo_dual">
       <querytext>
        select nextval('coimtodo_s') as cod_todo
        </querytext>
    </fullquery>

    <partialquery name="ins_todo">
       <querytext>
                insert
                  into coimtodo ( 
                       cod_todo
                     , cod_impianto
                     , cod_cimp_dimp
                     , tipologia
                     , note
                     , data_evento)
                values (
                      :cod_todo
                     ,:cod_impianto
                     ,' '
                     ,'4'
                     ,:note
                     ,current_date)
       </querytext>
    </partialquery>

    <fullquery name="sel_manu_todo">
       <querytext>
           select coalesce(cognome, '')||' '||coalesce(nome, '') as nominativo_manu 
             from coimmanu
            where cod_manutentore = :cod_manutentore
       </querytext>
    </fullquery>

</queryset>
