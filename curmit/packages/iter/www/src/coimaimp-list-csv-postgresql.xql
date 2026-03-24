<?xml version="1.0"?>
<!--
  USER  DATA       MODIFICHE
  ===== ========== =========================================================================
  ric03 26/11/2024 MEV per regione Marche ordine 63/2022 punti 21 e 32.

  rom03 16/04/2024 Aggiunti campi tipo pompa di calore per il freddo e combustibile su richiesta di Ucit.
  rom03            Sandro ha detto che va bene per tutti gli enti.

  rom02 14/11/2023 Vanno estratti gli impianti diversi dallo stato K

  ric02 13/06/2023 Per gli impianti del freddo prendo sempre la maggiore tra potenza e potenza_utile.

  ric01 09/06/2023 Aggiunto filtri per criteri aggiuntivi.

  rom01 17/01/2023 Sviluppo per Palermo Energia: aggiunto filro "Per Soggetto presente nello storico RCEE".

  mic01 13/05/2022 Corretta anomalia, l estrazione del file csv non teneva conto del filtro
  mic01            per targa o cod_impianto_princ.
  mic01            Corretta anomalia sul conteggio delle DAM, il campo swc_dam deve restituire NO
  mic01            se non ho record sulla coimdimp con flag_tracciato = 'DA'.
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_dat_check_mod_h">
       <querytext>
            select to_char(add_months(current_date, -to_number(:valid_mod_h,'99999990')), 'yyyy-mm-dd') as dat_check_mod_h
       </querytext>
    </fullquery>

    <partialquery name="sel_aimp_vie">
       <querytext>
           select a.cod_impianto_est
                , h.cod_impianto_est    as cod_impianto_princ --mic01
                , a.flag_tipo_impianto
                , a.cod_impianto
                , a.data_libretto
                , a.flag_tipo_impianto
                , a.targa --san02
                , a.pod --san02
                , a.pdr --san02
                , a.numero
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
                , lpad(a.cap,5,'0') as cap
		, case a.stato 
                    when 'A' then 'AT'
                    when 'N' then 'N'
                    when 'L' then 'AN'
                    when 'D' then 'D'
                    when 'R' then 'R'
                    when 'U' then 'Ch'
                    else a.stato
                  end as stato
                , case a.cod_potenza
                     when 'B' then ' '
                     when 'C'  then ' '
                     when 'D'  then ' '
                     when 'E'  then ' '
                     when 'F'  then ' '
                     when 'G'  then ' '
                     when 'H'  then ' '
                     when 'I'  then ' '
                     when 'L'  then ' '
                     when 'A'  then  ' '
                     else ''
                     end as imp_boll
                , case a.stato_conformita
                    when 'S' then 'SI'
                    when 'N' then 'NO'
                    else ''
                  end as swc_conformita
	        , case
                  when (
                      select count(*)
                        from coimdimp n
                       where n.cod_impianto         = a.cod_impianto
                        ) = 0
                  then 'NO'
                  else case
                  --when a.data_ultim_dich < :dat_check_mod_h --modificato Simone per e-mail di UCIT del 09/07/2014 (ora è coerente con coimaimp-list)
                    when a.data_scad_dich < current_date
                    then 'SC'
                    else 'SI'  end
                    end as swc_mod_h 
                , a.data_ultim_dich as data_ultima_dich
                , a.data_scad_dich  as data_scadenza
		, case
                  when (
                      select count(*)
                        from coimcimp r
                       where a.cod_impianto = r.cod_impianto
                         and flag_tracciato <> 'MA'
                        ) = 0
                  then 'NO'
                  else 'SI'
                  end as swc_rapp

                 , case
                  when (
                      select count(*)
                        from coimdimp hj
                       where a.cod_impianto = hj.cod_impianto
                 --mic01 and flag_tracciato <> 'DA'
                         and flag_tracciato = 'DA' --mic01
                        ) = 0
                  then 'NO'
                  else 'SI'
                  end as swc_dam
                 ,case
                    when (
                      select count(*)
                        from coimdope_aimp lk
                       where a.cod_impianto = lk.cod_impianto
                                               ) = 0
                  then 'NO'
                  else 'SI'
                  end as swc_freq
              
                   , (select iter_edit_num(coalesce(w.costo,0),2) as costo_d
                        from coimdimp w
                        where a.cod_impianto = w.cod_impianto and w.gen_prog = 1
                        and w.data_controllo = (select max(w1.data_controllo) from coimdimp w1 where w.cod_impianto = w1.cod_impianto and flag_tracciato like 'R%') limit 1) as costo_d
                     , (select data_prox_manut
                        from coimdimp www
                        where a.cod_impianto = www.cod_impianto and www.gen_prog = 1
                        and www.data_controllo = (select max(www1.data_controllo) from coimdimp www1 where www.cod_impianto = www1.cod_impianto and flag_tracciato like 'R%') limit 1) as prox_manut
                       , case
                  when (
                      select count(*)
                        from coimgend t , coimaimp l where t.cod_impianto = l.cod_impianto and stato = 'A'
                        limit 1
                        ) = 0
                  then ''
                  else g.matricola
                  end as swc_matrd
                , coalesce(g.matricola, '') as matricola_gen1
                , coalesce(b.cognome,' ')||' '||coalesce(b.nome,' ')   as resp
                , coalesce(b.indirizzo,' ')as ind_resp
                , coalesce(b.cap,' ')||' '||coalesce(b.comune,' ')   as ind_resp_2
                , coalesce(b.email,' ')  as email_resp -- Sandro 12/03/2018
                , coalesce(b.cellulare,' ')||'- '||coalesce(b.telefono,' ')  as telefono_resp --Sandro 12/03/2018
                , b.cognome 
                , b.nome
                , b.cod_fiscale    as cod_fiscale 
                , iter_edit_num(coalesce(a.potenza,0),2) as potenza
		
                --ric02 , iter_edit_num(coalesce(a.potenza_utile,0),2) as potenza_u
		
		, case when a.flag_tipo_impianto ='F'
           	       then (select greatest(iter_edit_num(coalesce(a.potenza,0),2),
		                             iter_edit_num(coalesce(a.potenza_utile,0),2)))
		       else (select iter_edit_num(coalesce(a.potenza_utile,0),2))
		        end as potenza_u
		--ric02

		, case a.flag_dichiarato
                  when 'S' then 'SI'
                  when 'N' then 'NO'
                  when 'C' then 'N.C.'
                  end as swc_dichiarato
                , case
                  when (select to_date(add_months(current_date, :mesi_evidenza_mod), 'yyyy-mm-dd')                        
                       ) > a.data_mod
                  then 'NO'
                  else case when (a.data_ins < a.data_mod)
                    then 'SI'
                    else 'NO' end
                  end as swc_mod
                , coalesce(kk.cognome,' ')||' '||coalesce(kk.nome,' ') as manu -- Sandro 28/07/2014
                , coalesce(kk.cod_manutentore,' ') as cod_man -- Sandro 28/07/2014
                , coalesce(kk.email,' ') as email_man -- Sandro 12/03/2018
                , coalesce(kk.pec,' ') as pec_man -- Sandro 12/03/2018
                , coalesce(kk.telefono,' ') as telefono_man -- Sandro 12/03/2018
                , coalesce(kk.indirizzo,' ') as indirizzo_man -- Sandro 12/03/2018
                , coalesce(kk.cap,' ')||' '||coalesce(kk.comune,' ') as comune_man -- Sandro 12/03/2018
                  $ruolo
                , tp.descr_tpco as sist_azio_gen1 --rom03
                , cb.descr_comb as desc_comb_aimp --rom03
	     from coimaimp a
		  $sogg_join
		  $citt_join_pos coimcitt b  on b.cod_cittadino = a.cod_responsabile
		  $from_clause
   	     left outer join coimcomu c  on c.cod_comune    = a.cod_comune
	     left outer join coimviae d  on d.cod_comune    = a.cod_comune	
	                                and d.cod_via       = a.cod_via
    	     left outer join coimgend g  on g.cod_impianto  = a.cod_impianto
	     	                        and g.gen_prog = (select min(o.gen_prog)
                                                            from coimgend o
                                                           where o.cod_impianto = a.cod_impianto
                                                             and o.flag_attivo = 'S'
                                                             and o.data_rottamaz is null)   
	     left outer join coimmanu kk on kk.cod_manutentore = a.cod_manutentore   -- Sandro 28/07/2014
             left outer join coimaimp h on h.cod_impianto  = a.cod_impianto_princ --mic01
             left outer join coimcomb cb on cb.cod_combustibile = a.cod_combustibile --rom03
             left outer join coimtpco tp on tp.cod_tpco = g.cod_tpco                 --rom03
            where 1 = 1
 	      and a.stato != 'K' --rom02
           $where_matr
           $where_sogg
	   $where_resp_rcee --rom01
           $where_amministratore
           $where_word
           $where_nome
           $where_comune
           $where_quartiere
           $where_via
           $where_civico_da
	   $where_civico_a
           $where_manu
           $where_manutentore
           $where_data_verifica
	   $where_data_mod
	   $where_utente
           $where_pot
           $where_codimp_est
           $where_comb
           $where_data_installaz
           $where_flag_dichiarato
           $where_cod_tpim
           $where_stato_conformita
           $where_tpdu
           $where_stato_aimp
           $where_last
           $where_mod_h
	   $where_data_scad
           $where_rife
           $where_codimp_old
           $where_cod_utenza
           $where_dpr
           $where_prov_dati
              $where_ammin
           $where_cost
           $where_pod
           $where_bollino
           $where_tipo_impianto
           $where_cout
	   $where_codimp_princ --mic01
	   $where_targa        --mic01
	   $where_ibrido       --ric01
	   $where_dimp         --ric01
	   $where_dich_conformita   --ric03
	   $where_dfm_manu          --ric03
	   $where_dfm_resp_mod      --ric03
           $ordinamento

       </querytext>
    </partialquery>


    <partialquery name="sel_aimp_no_vie">
       <querytext>
           select
                  a.cod_impianto_est
                , h.cod_impianto_est    as cod_impianto_princ --mic01		  
                , a.flag_tipo_impianto
                , a.cod_impianto
                , a.targa --san02
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
                    when 'A' then 'AT'
                    when 'N' then 'N'
                    when 'L' then 'AN'
                    when 'D' then 'D'
                    when 'R' then 'R'
                    when 'U' then 'Ch'
                    else a.stato
                  end as stato
                , case a.stato_conformita
                    when 'S' then 'SI'
                    when 'N' then 'NO'
                    else ''
                  end as swc_conformita
                , case
                  when (
                      select count(*)
                        from coimdimp n
                       where n.cod_impianto         = a.cod_impianto
                        ) = 0
                  then 'NO'
                  else case
                     --when a.data_ultim_dich < :dat_check_mod_h --modificato Simone per e-mail di UCIT del 09/07/2014 (ora è coerente con coimaimp-list)
                       when a.data_scad_dich < current_date
                       then 'SC'
                       else 'SI' end
                       end as swc_mod_h
                , case
                  when (
                      select count(*)
                        from coimcimp r
                       where a.cod_impianto = r.cod_impianto
                         and flag_tracciato <> 'MA'
                       ) = 0
                  then 'NO'
                  else 'SI'
                  end as swc_rapp

                , coalesce(b.cognome)||' '||coalesce(b.nome,' ')   as resp
                , b.cognome 
                , b.nome 
                , b.cod_fiscale   as cod_fiscale
                , iter_edit_num(coalesce(a.potenza,0),2) as potenza
                , case a.flag_dichiarato
                  when 'S' then 'SI'
                  when 'N' then 'NO'
                  when 'C' then 'N.C.'
                  end as swc_dichiarato
                , case
                  when (select to_date(add_months(current_date, :mesi_evidenza_mod), 'yyyy-mm-dd')                        
                       ) > a.data_mod
                  then 'NO'
                  else case when (a.data_ins < a.data_mod)
                    then 'SI'
                    else 'NO' end
                  end as swc_mod
                , coalesce(kk.cognome,' ')||' '||coalesce(kk.nome,' ') as manu -- Sandro 28/07/2014
                , coalesce(kk.cod_manutentore,' ') as cod_man -- Sandro 28/07/2014
                $ruolo
                , tp.descr_tpco as sist_azio_gen1 --rom03
                , cb.descr_comb as desc_comb_aimp --rom03
             from coimaimp a
            $sogg_join
   $citt_join_pos coimcitt b  on b.cod_cittadino = a.cod_responsabile
  left outer join coimcimp e  on e.cod_impianto  = a.cod_impianto
  left outer join coimcomu c  on c.cod_comune    = a.cod_comune
  left outer join coimgend g  on g.cod_impianto  = a.cod_impianto
                             and g.gen_prog = '1'
  left outer join coimmanu kk on kk.cod_manutentore = a.cod_manutentore -- Sandro 28/07/2014
  left outer join coimaimp h on h.cod_impianto  = a.cod_impianto_princ --mic01
  left outer join coimcomb cb on cb.cod_combustibile = a.cod_combustibile --rom03
  left outer join coimtpco tp on tp.cod_tpco = g.cod_tpco                 --rom03

            where 1 = 1
           $where_matr
           $where_sogg
	   $where_resp_rcee --rom01
           $where_amministratore
           $where_word
           $where_nome
           $where_comune
           $where_quartiere
           $where_via
           $where_civico_da
	   $where_civico_a
           $where_manu
           $where_manutentore
           $where_data_verifica
	   $where_data_mod
	   $where_utente
           $where_pot
           $where_codimp_est
           $where_comb
           $where_data_installaz
           $where_flag_dichiarato
           $where_cod_tpim
           $where_stato_conformita
           $where_tpdu
           $where_stato_aimp
           $where_last
           $where_mod_h
	   $where_data_scad
           $where_rife
           $where_codimp_old
           $where_cod_utenza
           $where_pod
           $where_dpr
           $where_prov_dati
           $where_bollino
           $where_tipo_impianto
           $where_cout
	   $where_codimp_princ   --mic01
	   $where_targa          --mic01
	   $where_ibrido         --ric01
	   $where_dimp           --ric01
	   $where_dich_conformita   --ric03
	   $where_dfm_manu          --ric03
	   $where_dfm_resp_mod      --ric03
           $ordinamento

       </querytext>
    </partialquery>

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

