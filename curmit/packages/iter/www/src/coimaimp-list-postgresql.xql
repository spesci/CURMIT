<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    ric02 26/11/2024 MEV per regione Marche ordine 63/2022 punti 21 e 32.

    rom05 31/10/2024 Ricevo e uso ls_cod_aimp

    rom04 27/08/2024 Riportate nella query sel_conta_aimp le condizioni di sim01 e sim02.

    rom03 14/11/2023 Vanno estratti gli impianti diversi dallo stato K

    ric01 09/06/2023 Aggiunti criteri aggiuntivi per estrazione impianti.

    rom02 17/01/2023 Sviluppo per Palermo Energia: aggiunto filro "Per Soggetto presente nello storico RCEE".

    rom01 10/01/2021 Aggiunta variabile where_pod per filtrare gli impianti per campo pod.

    sim02 06/09/2016 Se il parmetro flag_gest_targa e attivo,
    sim02            visualizzo il campo targa e non il cod impianto princ.

    gab01 02/05/2016 Per fare in modo che il filtro per matricola e per costruttore cerchi
    gab01            tutti i generatori e non solo il primo, ho aggiunto where_gend e
    gab01            cancellato where_cost e where_matr (altrimenti dava problemi).

    sim01 10/09/2014 Aggiunto nuovo campo cod_impianto_princ
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <partialquery name="sel_aimp_vie">
       <querytext>
           select
                  replace(a.cod_impianto_est, ' ', '&nbsp;') as cod_impianto_est
                , a.cod_impianto
		, h.cod_impianto_est    as cod_impianto_princ --sim01
                , a.targa --sim02
                , a.numero
                , a.flag_tipo_impianto
                , c.denominazione       as comune
                , coalesce(d.descr_topo,'')||' '||
                  coalesce(d.descrizione,'')||
                  case
                    when a.numero is null then ''
                    else ', '||a.numero
                  end ||
                  case
                    when a.esponente is null then ''
                    else '/'||a.esponente
                  end ||
                  case
                    when a.scala is null then ''
                    else ' S.'||a.scala
                  end ||
                  case
                    when a.piano is null then ''
                    else ' P.'||a.piano
                  end ||
                  case
                    when a.interno is null then ''
                    else ' In.'||a.interno
                  end
                                        as indir
                , d.descrizione as via
		, case a.stato 
                    when 'A' then 'At'
                    when 'N' then 'N'
                    when 'L' then 'An'
                    when 'D' then 'D'
                    when 'R' then 'R'
                    when 'U' then 'Ch'
                    else a.stato
                  end as stato
                , case a.stato_conformita
                    when 'S' then 'S&igrave;'
                    when 'N' then 'No'
                    else ''
                  end as swc_conformita
	        , case
                      when (
                          select count(*)
                            from coimdimp n
                           where n.cod_impianto         = a.cod_impianto
                      ) = 0
                      then '<font color=red><b>No</b></font>'
                      else case 
                               when a.data_scad_dich < current_date 
                               then '<font color=red><b>Sc</b></font>'
                               else 'S&igrave;'  
                           end
                  end as swc_mod_h
                 , case
                  when (
                      select count(*)
                        from coimcimp r
                       where a.cod_impianto = r.cod_impianto
                         and flag_tracciato <> 'MA'
                        ) = 0
                  then 'No'
                  else 'S&igrave;'
                  end as swc_rapp

                , coalesce(b.cognome,' ')||' '||coalesce(b.nome,' ')   as resp
                , b.cognome 
                , b.nome
                , b.cod_fiscale    as cod_fiscale 
                , coalesce(g.matricola,' ') as matricola
                , iter_edit_num(coalesce($colonna_potenza,0),2) as potenza
                , case a.flag_dichiarato
                  when 'S' then 'S&igrave;'
                  when 'N' then 'No'
                  when 'C' then 'N.C.'
                  end as swc_dichiarato
                , case
                  when (select to_date(add_months(current_date, :mesi_evidenza_mod), 'yyyy-mm-dd')                        
                       ) > a.data_mod
                  then 'No'
                  else case when (a.data_ins < a.data_mod)
                    then '<font color=red><b>S&igrave</b></font>'
                    else 'No' end
                  end as swc_mod
                $ruolo
             from coimaimp a
	     $sogg_join
   $citt_join_pos coimcitt b on b.cod_cittadino = a.cod_responsabile
   $from_clause
   left outer join coimcomu c on c.cod_comune    = a.cod_comune
   left outer join coimviae d on d.cod_comune    = a.cod_comune	
                             and d.cod_via       = a.cod_via
   left outer join coimgend g on g.cod_impianto  = a.cod_impianto
                             and g.gen_prog = (select min(o.gen_prog)
                                                 from coimgend o
                                                where o.cod_impianto = a.cod_impianto
                                                  and o.flag_attivo = 'S'
                                                  and o.data_rottamaz is null)            
   left outer join coimaimp h on h.cod_impianto  = a.cod_impianto_princ --sim01
   where 1 = 1
     and a.stato != 'K' --rom03
           $where_ammin
           $where_gend -- gab01
           $where_sogg
	   $where_resp_rcee --rom02
           $where_word
           $where_nome
           $where_comune
           $where_quartiere
           $where_via
           $where_manu
           $where_manutentore
	   $where_data_mod
	   $where_data_verifica
	   $where_utente
           $where_pot
           $where_codimp_est
	   $where_ls_cod_aimp -- rom05
           $where_comb
           $where_data_installaz
           $where_flag_dichiarato
           $where_cod_tpim
           $where_stato_conformita
           $where_tpdu
           $where_stato_aimp
           $where_last
           $where_mod_h
	   $where_dimp_peric
	   $where_data_scad
           $where_rife
           $where_codimp_old
           $where_cod_utenza
           $where_dpr
	   $where_pod --rom01
           $where_prov_dati
           $where_bollino
           $where_tipo_impianto
           $where_cout
	   $where_codimp_princ --sim01
	   $where_targa --sim02
	   $where_ibrido   --ric01
	   $where_dimp     --ric01
	   $where_dich_conformita  --ric02
	   $where_dfm_manu         --ric02
	   $where_dfm_resp_mod     --ric02
           $ordinamento
            limit $rows_per_page
       </querytext>
    </partialquery>


    <partialquery name="sel_aimp_no_vie">
       <querytext>
           select
                  replace(a.cod_impianto_est, ' ', '&nbsp;') as cod_impianto_est
                , a.cod_impianto
                , h.cod_impianto_est    as cod_impianto_princ --sim01
                , a.targa --sim02
                , a.numero
                , a.flag_tipo_impianto
                , c.denominazione       as comune
                , coalesce(a.toponimo,'')||' '||
                  coalesce(a.indirizzo,'')||
                  case
                    when a.numero is null then ''
                    else ', '||a.numero
                  end ||
                  case
                    when a.esponente is null then ''
                    else '/'||a.esponente
                  end ||
                  case
                    when a.scala is null then ''
                    else ' S.'||a.scala
                  end ||
                  case
                    when a.piano is null then ''
                    else ' P.'||a.piano
                  end ||
                  case
                    when a.interno is null then ''
                    else ' In.'||a.interno
                  end
                              as indir
                , a.indirizzo as via
		, case a.stato 
                    when 'A' then 'At'
                    when 'N' then 'N'
                    when 'L' then 'An'
                    when 'D' then 'D'
                    when 'R' then 'R'
                    when 'U' then 'Ch'
                    else a.stato
                  end as stato
                , case a.stato_conformita
                    when 'S' then 'S&igrave;'
                    when 'N' then 'No'
                    else ''
                  end as swc_conformita
	        , case
                      when (
                          select count(*)
                            from coimdimp n
                           where n.cod_impianto         = a.cod_impianto
                      ) = 0
                      then 'No'
                      else case 
                               when a.data_scad_dich < current_date 
                               then '<font color=red><b>Sc</b></font>'
                               else 'S&igrave;'  
                           end
                  end as swc_mod_h
                            ,case
                  when (
                      select count(*)
                        from coimcimp r
                       where a.cod_impianto = r.cod_impianto
                         and flag_tracciato <> 'MA'
                       ) = 0
                  then 'No'
                  else 'S&igrave;'
                  end as swc_rapp


                , coalesce(b.cognome)||' '||coalesce(b.nome,' ')   as resp
                , b.cognome 
                , b.nome
                , b.cod_fiscale   as cod_fiscale
                , coalesce(g.matricola,' ') as matricola
                , iter_edit_num(coalesce($colonna_potenza,0),2) as potenza
                , case a.flag_dichiarato
                  when 'S' then 'S&igrave;'
                  when 'N' then 'No'
                  when 'C' then 'N.C.'
                  end as swc_dichiarato
                , case
                  when (select to_date(add_months(current_date, :mesi_evidenza_mod), 'yyyy-mm-dd')                        
                       ) > a.data_mod
                  then 'No'
                  else case when (a.data_ins < a.data_mod)
                    then '<font color=red><b>S&igrave</b></font>'
                    else 'No' end
                  end as swc_mod
                $ruolo
             from coimaimp a
	     $sogg_join
   $citt_join_pos coimcitt b on b.cod_cittadino = a.cod_responsabile
   $from_clause
   left outer join coimcimp e on e.cod_impianto  = a.cod_impianto
   left outer join coimcomu c on c.cod_comune    = a.cod_comune
   left outer join coimgend g on g.cod_impianto  = a.cod_impianto
                             and g.gen_prog = (select min(o.gen_prog)
                                                 from coimgend o
                                                where o.cod_impianto = a.cod_impianto
                                                  and o.flag_attivo = 'S'
                                                  and o.data_rottamaz is null)
   left outer join coimaimp h on h.cod_impianto  = a.cod_impianto_princ --sim01
   where 1 = 1
           $where_ammin
           $where_gend -- gab01
           $where_sogg
	   $where_resp_rcee --rom02
           $where_word
           $where_nome
           $where_comune
           $where_quartiere
           $where_via
           $where_manu
           $where_manutentore
	   $where_data_verifica
	   $where_data_mod
	   $where_utente
           $where_pot
           $where_codimp_est
	   $where_ls_cod_aimp -- rom05
           $where_comb
           $where_data_installaz
           $where_flag_dichiarato
           $where_cod_tpim
           $where_stato_conformita
           $where_tpdu
           $where_stato_aimp
           $where_last
           $where_mod_h
	   $where_dimp_peric
	   $where_data_scad
           $where_rife
           $where_codimp_old
           $where_cod_utenza
           $where_dpr
	   $where_pod --rom01
           $where_prov_dati
           $where_bollino
           $where_tipo_impianto
           $where_cout
           $where_codimp_princ --sim01
	   $where_targa --sim02
	   $where_ibrido   --ric01
	   $where_dimp     --ric01
	   $where_dich_conformita  --ric02
	   $where_dfm_manu         --ric02
	   $where_dfm_resp_mod     --ric02
           $ordinamento
           limit $rows_per_page
       </querytext>
    </partialquery>

    <fullquery name="sel_conta_aimp">
       <querytext>
           select iter_edit_num(count(*),0) as conta_num
             from coimaimp a
	     $sogg_join
   $citt_join_pos coimcitt b on b.cod_cittadino = a.cod_responsabile
  $from_clause
  left outer join coimgend g on g.cod_impianto  = a.cod_impianto
                             and g.gen_prog = '1'
            where 1 = 1
           $where_ammin
           $where_gend -- gab01
           $where_sogg
	   $where_resp_rcee --rom02
           $where_word
           $where_nome
           $where_comune
           $where_quartiere
           $where_via
           $where_manu
           $where_manutentore
	   $where_data_mod
	   $where_data_verifica
	   $where_utente
           $where_pot
           $where_codimp_est
	   $where_ls_cod_aimp -- rom05
           $where_comb
           $where_data_installaz
           $where_flag_dichiarato
           $where_cod_tpim
           $where_stato_conformita
           $where_tpdu
           $where_stato_aimp
           $where_mod_h
	   $where_dimp_peric
	   $where_data_scad
           $where_rife
           $where_codimp_old
           $where_cod_utenza
           $where_dpr
	   $where_pod --rom01
           $where_prov_dati
           $where_bollino
           $where_tipo_impianto
           $where_cout
	   $where_ibrido    --ric01
	   $where_dimp      --ric01
           $where_codimp_princ --rom04
           $where_targa        --rom04
	   $where_dich_conformita  --ric02
	   $where_dfm_manu         --ric02
	   $where_dfm_resp_mod     --ric02
       </querytext>
    </fullquery>

    <partialquery name="ruolo_citt">
       <querytext>
           , case a.cod_intestatario 
                when :cod_cittadino then 'I '
                else '' 
             end
           ||case a.cod_proprietario 
                when :cod_cittadino then 'P '
                else ''
             end
           ||case a.cod_occupante 
                when :cod_cittadino then 'O '
                else ''
             end
           ||case a.cod_amministratore 
                when :cod_cittadino then 'A '
                else ''
             end
           ||case a.cod_responsabile 
                when :cod_cittadino then case a.flag_resp 
                                            when 'T' then 'T'
                                            else  '' 
					  end
                else ''
             end as ruolo
       </querytext>
    </partialquery>

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
