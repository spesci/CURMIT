<?xml version="1.0"?>
<!--
    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    mat01 12/03/2026 Punto 3 MEV 2026. Ordine 00084/2026. Aggiunto installatore alle schede 4.1bis,4.4 bis,4.5bis,
    mat01            4.6 bis.

    but06 26/11/2024 MEV per regione Marche ordine 63/2022 punto 36: Tolti i dati di recapito del Terzo responsabile
    but06            nella scheda 1Bis e mostrati quelli della ditta.

    rom32 14/03/2024 Su segnalazione di Regione Marche e Sandro ora per gli impianti del caldo
    rom32            tengo in considerazione solo i generatori con potenza >= di 10 kW.
    rom32            Per gli impianti del freddo tengo in considerazione solo i generatori che
    rom32            hanno la maggiore tra potenza in riscaldamento e raffrescamento >= di 12 Kw.

    but04 04/03/2024 Ho modificato la descrizione e il contenuto del campo Fluido frigorigeno.

    rom31 06/07/2023 Modificato case per il campo rif_uni_10389 del teleriscaldamento.

    rom30 27/06/2023 MEV REGIONE MARCHE "B. Impianti in stato Respinto": esclusi dalle query gli impianti
    rom30            in stato Respinto e Da Validare.

    rom29 03/04/2023 Aggiunte query sel_bruc_u_no_marche e sel_bruc_u_sost_comp_no_marche.
    rom29            Modificati i join delle query sugli impianti padre/figli per gli enti senza targa.

    rom28 13/03/2023 Leggo correttamente il campo per il fluido frigorigeno sui generatori del freddo.

    rom27 03/01/2023 Aggiunto campo data_libretto_pretty.

    rom26 10/08/2022 Corretta query sel_bruc_u_sost_comp.

    mic01 07/07/2022 Su segnalazione di Regione Marche e Sandro modificate query sel_gend_fr_bis e 
    mic01            sel_tot_gend_fr per fare in modo che vengano presi in considerazione solo i generatori
    mic01            che hanno la maggiore tra potenza in riscaldamento e raffrescamento maggiore di 12 Kw.
    mic01            Nelle stesse query modificati alcuni case per i campi tipo_climatizzazione e tot_tipo_climatizzazione
    mic01            mettendo '&nbsp;' al posto di '' perche il programma poteva andare in errore.

    rom25 31/05/2022 Modificate query sel_pomp_circ e sel_pomp_circ_sost_comp.

    rom24 06/04/2022 MEV Ibrido per Regione Marche.

    rom23 04/03/2022 Modificata la Scheda 4.2: Ora anche per i bruciatori viene gestita la parte della sostituzione
    rom23            dei componenti, per questa modifica serve la versione di I.Ter. 2.5.73.
    rom23bis         Corretto refuso su query sel_bruc_u.
    
    rom22 21/02/2022 Su segnalazione di Giuliodori di Regione Marche coretta anomalia su visualizzazione campo
    rom22            CO scheda 11.1. Corretta visualizzazione scheda 12. Corretta visualizzazione scheda 2.
    rom22            Corretta visualizzazione POD e PDR per regione Marche.

    rom21 24/01/2022 Modificate query sel_condu e sel_as_resp per fare in modo che nella stampa siano presenti
    rom21            i dati relativi a tutti gli impianti colegati tra loro (sia che si usino le targhe,
    rom21            sia che si usi il codice impianto principale.)

    rom20 27/12/2021 Regione Marche ha richiesto anche che i generatori vengano stampati anche se l'impianto e'
    rom20            non attivo. Sandro ha detto che per le Marche i generatori e sezione 1bis vanno stampati a
    rom20            prescindere dallo stato dell'impianto, per gli altri invece stampo solo se l'impianto è attivo.

    rom19 05/11/2021 Per regione Marche estraggo il combustile sui dimp in modo da esporlo nella scheda 11.1
    rom19            perche' potrebbe essere diverso dal combustibile del generatore.

    rom18 05/08/2021 Modificate le query delle sezioni 6.3, 6.4, 7 e 9.5 per fare in modo che vengano presi
    rom18            in considerazione i dati di tutti gli impianti associati in base la flag_gest_targa.

    sim06 30/06/2021 Corretto visualizzazione sugli impianti con generatori del freddo che hanno solo
    sim06            la potenza di riscaldamento.
    
    rom17 28/01/2021 Corretta anomalia presente nella sezione 4.2.

    rom16 25/01/2021 Corretta anomalia presente per gli RCEE appartenenti ad impianti diversi con la stessa targa.

    rom15 03/11/2020 Corretta anomalia nella query "sel_tot_gend".

    rom14 26/08/2020 Corretta anomalia nella query "sel_tot_gend_fr".

    rom13 03/08/2020 Su segnalazione di Giugliodori (Marche) vado ad esporre, per gli impianti del freddo,
    rom13            la maggiore tra la potenza frigorifera nominale e la potenza termica nominale dell'impianto 
    rom13            nella sezione della scheda 1 bis.

    rom12 15/02/2019 Aggiunte le query per le schede 4.4bis, 4.5bis e 4.6bis della Regione Marche.

    rom11 19/01/2019 Aggiunti nuovi campi per impianto del freddo 

    gac08 24/12/2018 Aggiunti campi per scheda 4.1bis per tabelle dei controlli di efficienza

    gac07 19/12/2018 Modificata potenza per scheda 4.1bis, devo prendere la potenza del singolo
    gac07            e non dell'impianto.'

    gac06 18/12/2018 Aggiunta data_installazione alla scheda 1bis

    rom10 05/12/2018 Aggiunti campi cod_fisc_resp e cod_piva_resp per shceda 3

    rom09 14/11/2018 Aggiunte query sel_sist_reg, sel_sist_reg_sost_comp, sel_valv_reg e
    rom09            sel_valv_reg_sost_comp per la Scheda 5.

    rom08 07/11/2018 aggiunto campo gt_collegato. Cambiata la gestione della Scheda 4.7:
    rom08            in base al valore del flag_sostituito gestisco
    rom08            la compilazione automatica della ""Variazione del campo solare termico".
    rom08            Aggiunti i nuovi campi della coimaimp: sistem_emis_radiatore, 
    rom08            sistem_emis_ventilconvettore, sistem_emis_pannello_radiante,
    rom08            sistem_emis_bocchetta, sistem_emis_striscia_radiante,
    rom08            sistem_emis_trave_fredda, sistem_emis_termoconvettore, sistem_emis_altro.
    rom08	     Gestisco in maniera differente i campi installato_uta_vmc_sost_comp e
    rom08            installato_uta_vmc della Scheda 9.6

    rom07 04/08/2018 aggiunta condizione where_data_inizio e campo flag_as_resp
    rom07            nella query sel_as_resp.

    rom06 05/09/2018 Cambiata la gestione delle Schede 4.3, 4.8, 6.4, 8, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 10.1
    rom06            su richiesta della Regione Marche: in base al valore del flag_sostituito gestisco
    rom06            la compilazione automatica dei "Sostituti del componente" che prima erano compilabili a mano.

    gac05 29/06/2018 Aggiunto campi integrazione, superficie_integrazione, nota_altra_integrazione
    gac05            e pot_utile_integrazione

    rom05 19/06/2018 Aggiunto campo tipologia_intervento

    gac04 08/06/2018 Aggiunti campi relativi all'elettricità'

    gac03 07/06/2018 Aggiunti campi tipologia_generatore e integrazione_per

    rom04 24/05/2018 Aggiunti campi data_rottamaz_bruc, campo_funzion_max, campo_funzion_min

    gac02 03/05/2018 Aggiunti campi acquisti, acquisti2, scorta_o_lett_iniz, scorta_o_lett_iniz2
    gac02            scorta_o_lett_fin, scorta_o_lett_fin2 a sel_dimp e sel_dimp_padre

    gac01 18/04/2018 Aggiunta sezione 1Bis Dati generali 

    rom03 16/04/2018 Aggunti campi della sezione 4.1 bis

    rom02 02/02/2018 Aggiunto sezioni 4.5 e 11.3 relativi al teleriscaldamento

    sim05 26/10/2016 Aggiunto dicitura in testa alla pagina se i contributi son stati pagati regolarmente

    gab04 24/10/2016 Aggiunta estrazione dei generatori padre anche per la sezione 4.4 (Freddo)

    gab03 16/09/2016 Aggiunte sezioni del libretto 9.5, 9.6 e 10.1

    sim04 06/09/2016 Se il parmetro flag_gest_targa è attivo,
    sim04            visualizzo il campo targa e non il cod impianto princ.

    gab02 17/08/2016 Gestita nuove pagine del libretto (7, 8.1, 9.1, 9.2, 9.3, 9.4 ).   
 
    gab01 14/07/2016 Gestita nuove pagine del libretto (4.3, 4.7, 4.8, 6).
-->

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="sel_aimp">
       <querytext>
    select a.cod_impianto_est
         , coalesce(a.cod_amag,'&nbsp;') as cod_amag
         , case a.flag_dichiarato
           when 'S' then 'SI'
           when 'N' then 'NO'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as desc_dich
         , case a.tariffa
           when '03' then 'Riscald. &gt; 100 KW'
           when '04' then 'Riscald. autonomo e acqua calda'
           when '05' then 'Riscald. centralizzato'
           when '07' then 'Riscald.central.piccoli condomini'
           else '&nbsp;'  
           end as desc_tariffa
         , coalesce(iter_edit_data(a.data_ultim_dich),'&nbsp;') as data_ult
         , coalesce(iter_edit_data(a.data_prima_dich),'&nbsp;') as data_pri
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_insta
         , coalesce(iter_edit_data(a.data_attivaz),'&nbsp;') as data_att
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;') as data_rott
         , coalesce(iter_edit_num(a.potenza, 2),'&nbsp;') as potenza
         , coalesce(iter_edit_num(a.potenza_utile, 2),'&nbsp;') as potenza_utile
         , coalesce(iter_edit_num(a.consumo_annuo, 2),'&nbsp;') as consumo_annuo
         , coalesce(iter_edit_num(a.n_generatori, 0),'&nbsp;') as n_generatori
         , coalesce(iter_edit_num(a.volimetria_risc, 2),'&nbsp;') as volimetria_risc
	 , coalesce(iter_edit_num(a.volimetria_raff, 2),'&nbsp;') as volimetria_raff --rom11
	 , coalesce(b.descr_cted,'&nbsp;') as descr_cted
         , b.cod_cted
         , coalesce(c.descr_comb,'&nbsp;') as comb
	 , coalesce(d.descr_tpim,'&nbsp;') as descr_tpim
	 , coalesce(e.descr_tppr,'&nbsp;') as descr_prov
         , f.descr_imst as desc_stato
         , coalesce(i.cognome, '')||' '||coalesce(i.nome, '') as nome_prog
         , coalesce(i.cognome, '')||' '||coalesce(i.nome, '') as nome_inst
         , a.cod_combustibile
         ,case a.circuito_primario
          when 'C' then 'Ad acqua calda (T&lt100&deg;C)'
          when 'S' then 'Ad acqua surriscaldata (T&gt100&deg;C)'
	  else ''
	  end as circuito_primario
         ,case a.distr_calore
          when 'D' then 'Distribuzione centralizzata'
          when 'S' then 'Scambiatori dedicati per ogni Unit&agrave; Abitativa'
          else ''
          end as distr_calore
         ,a.n_scambiatori
         ,iter_edit_num(a.potenza_scamb_tot, 2) as potenza_scamb_tot
         ,a.nome_rete
         , l.descr_alim
         , iter_edit_num(a.cop, 2) as cop
         , iter_edit_num(a.per, 2) as per
         , m.descr_fdc
         , a.data_scheda
         , coalesce(iter_edit_data(a.data_scheda), '') as data_sche
         , upper(a.pdr) as pdr
         , upper(a.pod) as pod
         , case when a.unita_immobiliari_servite = 'U' then 'unica'           --gac01
                when a.unita_immobiliari_servite = 'P' then 'più unità'       --gac01
	        else ''                                                       --gac01
	        end as unita_immobiliari_servite                              --gac01
	 , case when a.cod_tpim = 'A' then 'AUTONOMO'                   --gac01
	        when a.cod_tpim = 'C' then 'CENTRALIZZATO'              --gac01
		when a.cod_tpim = 'D' then 'CENTRALIZZATO CON TERMOV.'  --gac01
		when a.cod_tpim = '0' then 'NON NOTO'                   --gac01
		else ''                                                 --gac01
		end as cod_tpim                                         --gac01
         --sim,a.cod_impianto_princ
	 , o.cod_impianto_est                 as cod_impianto_princ --sim
         , a.targa                          --sim04
         , a.flag_tipo_impianto             --gab01
         , a.data_scad_dich                 --sim05
	 , a.cod_tpim                       --rom03
         , a.tipologia_generatore           --gac03
	 , a.integrazione_per               --gac03
	 , coalesce(a.tipologia_intervento, '') as tipologia_intervento   --rom05
	 , iter_edit_data(a.data_libretto) as data_libretto_pretty --rom27
	 , a.integrazione                   --gac05
	 , iter_edit_num(a.superficie_integrazione, 2) as superficie_integrazione --gac05
         , a.nota_altra_integrazione        --gac05
         , iter_edit_num(a.pot_utile_integrazione, 2) as pot_utile_integrazione   --gac05 
	 , a.sistem_emis_radiatore         --rom08
         , a.sistem_emis_termoconvettore   --rom08
         , a.sistem_emis_ventilconvettore  --rom08
         , a.sistem_emis_pannello_radiante --rom08
         , a.sistem_emis_bocchetta         --rom08
         , a.sistem_emis_striscia_radiante --rom08
         , a.sistem_emis_trave_fredda      --rom08
         , a.sistem_emis_altro             --rom08
         , a.sistem_dist_tipo               --gab01
         , a.sistem_dist_note_altro         --gab01
         , a.sistem_dist_coibentazione_flag --gab01
         , a.sistem_dist_note               --gab01
         , a.sistem_emis_tipo               --gab02
         , a.sistem_emis_note_altro         --gab02
	 , coalesce(a.altra_tipologia_generatore,'') as altra_tipologia_generatore --rom11
	 , case a.pres_certificazione
	   when 'S' then 'S&igrave;'
           when 'N' then 'No'
           else ''
	   end as pres_certificazione --rom11
         , coalesce(a.certificazione, '') as certificazione --rom11
	 , iter_edit_data(a.anno_costruzione) as anno_costruzione
	 , a.cod_installatore
	 , iter_edit_data(a.data_attivaz) as data_attivaz
	 , case a.stato
	   when 'A' then 'Attivo'
	   when 'R' then 'Rottamato'
	   when 'U' then 'Impianto Chiuso'
	   when 'N' then 'Non Attivo'
	   when 'L' then 'Annullato'
	   when 'D' then 'Da Accatastare'
	   else ''
	   end as stato
      from coimimst f
         , coimaimp a
           left outer join coimcted b on b.cod_cted         = a.cod_cted
           left outer join coimcomb c on c.cod_combustibile = a.cod_combustibile
           left outer join coimtpim d on d.cod_tpim         = a.cod_tpim
           left outer join coimtppr e on e.cod_tppr         = a.provenienza_dati
           left outer join coimmanu h on h.cod_manutentore  = a.cod_installatore
           left outer join coimprog i on i.cod_progettista  = a.cod_progettista
           left outer join coimalim l on l.cod_alim			= a.cod_alim
           left outer join coimfdc  m on m.cod_fdc			= a.cod_fdc
	   left outer join coimaimp o on o.cod_impianto     = a.cod_impianto_princ --sim 
          where a.cod_impianto = :cod_impianto
            and f.cod_imst     = a.stato
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_no_viae">
       <querytext>
    select coalesce(a.toponimo,'')||' '||coalesce(a.indirizzo,'')||' '||coalesce(a.numero,'')||' '||coalesce(a.esponente,'')||' '||coalesce(a.scala,'')||' '||coalesce(a.piano,'')||' '||coalesce(a.interno,'') as indir
         , a.cap
         , a.localita
         , c.denominazione as nome_comu
         , d.sigla
         , a.cod_impianto_est
         , coalesce(a.toponimo,'')||' '||coalesce(a.indirizzo,'') as via_imp
         , coalesce(a.numero,'')||' '||coalesce(a.esponente,'') as num_imp
         , a.scala as scala_imp
         , a.piano as piano_imp
         , a.interno as interno_imp
         , d.denominazione as prov
         , a.data_scheda
         , coalesce(iter_edit_data(data_scheda), '') as data_sche
         , a.pdr
         , a.pod
         , a.targa
	 , coalesce(iter_edit_data(a.data_installaz), '') as data_insta --gac06
      from coimaimp a
           left outer join coimcomu c on c.cod_comune    = a.cod_comune
           left outer join coimprov d on d.cod_provincia = a.cod_provincia
     where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_si_viae">
       <querytext>
    select coalesce(b.descr_topo,'')||' '||coalesce(b.descrizione,'')||' '||coalesce(a.numero,'')||' '||coalesce(a.esponente,'')||' '||coalesce(a.scala,'')||' '||coalesce(a.piano,'')||' '||coalesce(a.interno,'') as indir
         , a.cap
         , c.denominazione as nome_comu
         , a.localita
         , d.sigla
         , a.cod_impianto_est
         , coalesce(b.descr_topo,'')||' '||coalesce(b.descrizione,'') as via_imp
         , coalesce(a.numero,'')||' '||coalesce(a.esponente,'') as num_imp
         , a.scala as scala_imp
         , a.piano as piano_imp
         , a.interno as interno_imp
         , d.denominazione as prov
         , a.data_scheda
         , coalesce(iter_edit_data(data_scheda), '') as data_sche
         , a.targa
	 , coalesce(iter_edit_data(a.data_installaz), '') as data_insta --gac06
      from coimaimp a
           left outer join coimviae b on b.cod_via       = a.cod_via
                                     and b.cod_comune    = a.cod_comune
           left outer join coimcomu c on c.cod_comune    = a.cod_comune
           left outer join coimprov d on d.cod_provincia = a.cod_provincia
     where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_stub_si_viae">
       <querytext>
    select iter_edit_data(a.data_fin_valid) as data_fin_valid
         , coalesce(b.descr_topo,'')||' '||coalesce(b.descrizione,'')||' '||coalesce(a.numero,'')||' '||coalesce(a.esponente,'')||' '||coalesce(a.scala,'')||' '||coalesce(a.piano,'')||' '||coalesce(a.interno,'') as indir
         , coalesce(a.cap,'') as cap
         , c.denominazione as nome_comu_st
         , d.sigla
      from coimstub a
           left outer join coimviae b on b.cod_via       = a.cod_via
                                     and b.cod_comune    = a.cod_comune
           left outer join coimcomu c on c.cod_comune    = a.cod_comune
           left outer join coimprov d on d.cod_provincia = a.cod_provincia
     where a.cod_impianto = :cod_impianto
    order by a.data_fin_valid desc
       </querytext>
    </fullquery>

    <fullquery name="sel_stub_no_viae">
       <querytext>
    select iter_edit_data(a.data_fin_valid) as data_fin_valid
         , coalesce(a.toponimo,'')||' '||coalesce(a.indirizzo,'')||' '||coalesce(a.numero,'')||' '||coalesce(a.esponente,'')||' '||coalesce(a.scala,'')||' '||coalesce(a.piano,'')||' '||coalesce(a.interno,'') as indir
         , coalesce(a.cap,'') as cap
         , c.denominazione as nome_comu_st
         , d.sigla
      from coimstub a
           left outer join coimcomu c on c.cod_comune    = a.cod_comune
           left outer join coimprov d on d.cod_provincia = a.cod_provincia
     where a.cod_impianto = :cod_impianto
    order by a.data_fin_valid desc
       </querytext>
    </fullquery>

    <fullquery name="sel_resp">
       <querytext>
    select coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_resp
         , coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indir_r
         , coalesce(b.comune,'') as nome_comu_r
         , coalesce(b.provincia,'') as sigla_r
         , coalesce(b.cap,'') as cap_r
         , case when flag_resp = 'P' then 'PROPRIETARIO'         --gac01
	        when flag_resp = 'O' then 'OCCUPANTE'            --gac01
                when flag_resp = 'A' then 'AMMINISTRATORE'       --gac01
                when flag_resp = 'I' then 'INTESTATARIO'         --gac01
                when flag_resp = 'T' then 'TERZI'                --gac01
		else ''                                          --gac01
		end as flag_resp                                 --gac01
	 , case when b.natura_giuridica = 'F' then 'FISICA'      --gac01
                when b.natura_giuridica = 'G' then 'GIURIDICA'   --gac01
                else ''                                          --gac01
                end as natura_giuridica                          --gac01
         , coalesce(b.telefono,'')||'-'||coalesce(b.cellulare, '') as tel
         , coalesce(b.fax,'') as fax          --gac01
	 , coalesce(b.email,'') as email      --gac01
	 , coalesce(b.pec,'') as pec          --gac01
         , coalesce(b.cognome,'') as cgn_resp
         , coalesce(b.nome,'')    as nom_resp
         , coalesce(b.cod_fiscale,'') as cf_resp
         , coalesce(b.cod_piva,'')    as piva_resp
      from coimaimp a
           left outer join coimcitt b on b.cod_cittadino = a.cod_responsabile
     where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_3">
       <querytext>
    select coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_inte
         , coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indir_i
         , coalesce(b.comune,'') as nome_comu_i
         , coalesce(b.provincia,'') as sigla_i
         , coalesce(b.cap,'') as cap_i
         , coalesce(c.cognome,'')||' '||coalesce(c.nome,'') as nome_prop
         , coalesce(c.indirizzo,'')||' '||coalesce(c.numero,'') as indir_p
         , coalesce(c.comune,'') as nome_comu_p
         , coalesce(c.provincia,'') as sigla_p
         , coalesce(c.cap,'') as cap_p
         , coalesce(d.cognome,'')||' '||coalesce(d.nome,'') as nome_occu
         , coalesce(d.indirizzo,'')||' '||coalesce(d.numero,'') as indir_o
         , coalesce(d.comune,'') as nome_comu_o
         , coalesce(d.provincia,'') as sigla_o
         , coalesce(d.cap,'') as cap_o
         , coalesce(e.cognome,'')||' '||coalesce(e.nome,'') as nome_ammi
         , coalesce(e.indirizzo,'')||' '||coalesce(e.numero,'') as indir_a
         , coalesce(e.comune,'') as nome_comu_a
         , coalesce(e.provincia,'') as sigla_a
         , coalesce(e.cap,'') as cap_a
         , coalesce(f.cognome,'')||' '||coalesce(f.nome,'') as nome_resp
         , coalesce(f.indirizzo,'')||' '||coalesce(f.numero,'') as indir_r
         , coalesce(f.comune,'') as nome_comu_r
         , coalesce(f.provincia,'') as sigla_r
         , coalesce(f.cap,'') as cap_r
      from coimaimp a
           left outer join coimcitt b on b.cod_cittadino = a.cod_intestatario
           left outer join coimcitt c on c.cod_cittadino = a.cod_proprietario
           left outer join coimcitt d on d.cod_cittadino = a.cod_occupante
           left outer join coimcitt e on e.cod_cittadino = a.cod_amministratore
           left outer join coimcitt f on f.cod_cittadino = a.cod_responsabile
     where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_tratt_acqua">
      <querytext>
	select iter_edit_num(tratt_acqua_contenuto,2) as tratt_acqua_contenuto
	        , iter_edit_num(tratt_acqua_durezza,2) as tratt_acqua_durezza
	        , tratt_acqua_clima_tipo
	        , iter_edit_num(tratt_acqua_clima_addolc, 2) as tratt_acqua_clima_addolc
	        , tratt_acqua_clima_prot_gelo
	        , iter_edit_num(tratt_acqua_clima_prot_gelo_eti, 2) as tratt_acqua_clima_prot_gelo_eti
                , iter_edit_num(tratt_acqua_clima_prot_gelo_eti_perc, 2) as tratt_acqua_clima_prot_gelo_eti_perc
                , iter_edit_num(tratt_acqua_clima_prot_gelo_pro, 2) as tratt_acqua_clima_prot_gelo_pro
                , iter_edit_num(tratt_acqua_clima_prot_gelo_pro_perc, 2) as tratt_acqua_clima_prot_gelo_pro_perc
                , tratt_acqua_calda_sanit_tipo
                , iter_edit_num(tratt_acqua_calda_sanit_addolc, 2) as tratt_acqua_calda_sanit_addolc
                , tratt_acqua_raff_assente
                , tratt_acqua_raff_tipo_circuito
                , tratt_acqua_raff_origine
                , tratt_acqua_raff_filtraz_flag
                , tratt_acqua_raff_filtraz_1
                , tratt_acqua_raff_filtraz_2
                , tratt_acqua_raff_filtraz_3
                , tratt_acqua_raff_filtraz_4
                , tratt_acqua_raff_tratt_flag
                , tratt_acqua_raff_tratt_1
                , tratt_acqua_raff_tratt_2
                , tratt_acqua_raff_tratt_3
                , tratt_acqua_raff_tratt_4
                , tratt_acqua_raff_tratt_5
                , tratt_acqua_raff_cond_flag
                , tratt_acqua_raff_cond_1
                , tratt_acqua_raff_cond_2
                , tratt_acqua_raff_cond_3
                , tratt_acqua_raff_cond_4
                , tratt_acqua_raff_cond_5
                , tratt_acqua_raff_cond_6
                , tratt_acqua_raff_spurgo_flag
                , iter_edit_num(tratt_acqua_raff_spurgo_cond_ing, 2) as tratt_acqua_raff_spurgo_cond_ing
                , iter_edit_num(tratt_acqua_raff_spurgo_tara_cond, 2) as tratt_acqua_raff_spurgo_tara_cond
		, coalesce(tratt_acqua_raff_filtraz_note_altro, '') as tratt_acqua_raff_filtraz_note_altro --LucaR. 07/11/2018
                , coalesce(tratt_acqua_raff_tratt_note_altro, '') as tratt_acqua_raff_tratt_note_altro --LucaR. 07/11/2018
                , coalesce(tratt_acqua_raff_cond_note_altro, '') as tratt_acqua_raff_cond_note_altro --LucaR. 07/11/2018
		, cod_impianto_est as cod_impianto_est_tratt_acqua --rom22
          from coimaimp
         where cod_impianto in ('[join $lista_cod_impianti ',']')
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_rego">
       <querytext>
	 select regol_on_off                                           
           , regol_curva_integrata                         
           , regol_curva_indipendente                   
           , iter_edit_data(regol_curva_ind_iniz_data_inst)    as regol_curva_ind_iniz_data_inst   
           , iter_edit_data(regol_curva_ind_iniz_data_dism)    as regol_curva_ind_iniz_data_dism   
           , regol_curva_ind_iniz_fabbricante   
           , regol_curva_ind_iniz_modello           
           , regol_curva_ind_iniz_n_punti_reg   
           , regol_curva_ind_iniz_n_liv_temp     
           , regol_valv_regolazione                       
           , iter_edit_data(regol_valv_ind_iniz_data_inst)     as regol_valv_ind_iniz_data_inst    
           , iter_edit_data(regol_valv_ind_iniz_data_dism)     as regol_valv_ind_iniz_data_dism    
           , regol_valv_ind_iniz_fabbricante     
           , regol_valv_ind_iniz_modello             
           , regol_valv_ind_iniz_n_vie                 
           , regol_valv_ind_iniz_servo_motore   
           , regol_sist_multigradino                     
           , regol_sist_inverter                            
           , regol_altri_flag                                   
           , regol_altri_desc_sistema                   
           , regol_cod_tprg                                       
           , regol_valv_termostatiche                   
           , regol_valv_due_vie                               
           , regol_valv_tre_vie                               
           , regol_valv_note                                     
           , regol_telettura                                     
           , regol_telegestione                               
           , regol_desc_sistema_iniz                     
           , iter_edit_data(regol_data_sost_sistema)           as regol_data_sost_sistema          
           , regol_desc_sistema_sost                     
           , contab_si_no                                           
           , contab_tipo_contabiliz                       
           , contab_tipo_sistema                             
           , contab_desc_sistema_iniz                   
           , iter_edit_data(contab_data_sost_sistema)          as contab_data_sost_sistema         
           , contab_desc_sistema_sost
           , cod_impianto_est as cod_impianto_est_rego
	   , cod_impianto as cod_impianto_reg
           from coimaimp
	  where -- rom24 cod_impianto = :cod_impianto
	  $or_aimp_rego
	  order by cod_impianto --rom24
        
       </querytext>
    </fullquery>

    <fullquery name="sel_rife">
       <querytext>
    select iter_edit_data(a.data_fin_valid) as data_fin_valid
         , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_sogg
         , coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indir_s
         , coalesce(b.comune,'') as nome_comu_s
         , coalesce(b.provincia,'') as sigla_s
         , coalesce(b.cap,'') as cap_s
         , case a.ruolo
           when 'P' then 'Proprietario'
           when 'O' then 'Occupante'
           when 'A' then 'Amministratore'
           when 'R' then 'Responsabile'
           when 'I' then 'Intestatario'
           else ''
           end as desc_ruolo
      from coimrife a
           left outer join coimcitt b on b.cod_cittadino = a.cod_soggetto
     where a.cod_impianto = :cod_impianto
       and a.ruolo       in ('P', 'O', 'A', 'R', 'I')
    order by a.data_fin_valid desc
       </querytext>
    </fullquery>

    <fullquery name="sel_aimp_4">
       <querytext>
    select coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_manu
         , b.reg_imprese as reg_manu
         , coalesce(b.indirizzo,'') as indir_m
         , coalesce(b.comune,'') as nome_comu_m
         , coalesce(b.provincia,'') as sigla_m
         , coalesce(b.cap,'') as cap_m

	 , coalesce(b.telefono,'') as tel_m   --but06
	 , coalesce(b.fax,'')      as fax_m   --but06
	 , coalesce(b.email,'')    as email_m --but06
	 , coalesce(b.pec,'')      as pec_m   --but06
	 
         , coalesce(c.cognome,'')||' '||coalesce(c.nome,'') as nome_inst
         , c.reg_imprese as reg_inst
         , coalesce(c.indirizzo,'') as indir_i
         , coalesce(c.comune,'') as nome_comu_i
         , coalesce(c.provincia,'') as sigla_i
         , coalesce(c.cap,'') as cap_i
         , coalesce(d.ragione_01,'') as nome_dist
         , coalesce(d.indirizzo,'')||' '||coalesce(d.numero,'') as indir_d
         , coalesce(d.comune,'') as nome_comu_d
         , coalesce(d.provincia,'') as sigla_d
         , coalesce(d.cap,'') as cap_d
         , coalesce(e.cognome,'')||' '||coalesce(e.nome,'') as nome_prog
         , e.reg_imprese as reg_prog
         , coalesce(e.indirizzo,'') as indir_g
         , coalesce(e.comune,'') as nome_comu_g
         , coalesce(e.provincia,'') as sigla_g
         , coalesce(e.cap,'') as cap_g
         , a.cod_manutentore --rom04
      from coimaimp a
           left outer join coimmanu b on b.cod_manutentore = a.cod_manutentore
           left outer join coimmanu c on c.cod_manutentore = a.cod_installatore
           left outer join coimdist d on d.cod_distr       = a.cod_distributore
           left outer join coimprog e on e.cod_progettista = a.cod_progettista
     where a.cod_impianto = :cod_impianto
       </querytext>
    </fullquery>

    <fullquery name="sel_rife_2">
       <querytext>
    select iter_edit_data(a.data_fin_valid) as data_fin_valid
         , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_sogg
         , coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indir_s
         , coalesce(b.comune,'') as nome_comu_s
         , coalesce(b.provincia,'') as sigla_s
         , coalesce(b.cap,'') as cap_s
         , case a.ruolo
           when 'P' then 'Manutentore'
           when 'O' then 'Installatore'
           when 'A' then 'Distributore'
           when 'R' then 'Progettista'
           else ''
           end as desc_ruolo
      from coimrife a
           left outer join coimcitt b on b.cod_cittadino = a.cod_soggetto
     where a.cod_impianto = :cod_impianto
       and a.ruolo       in ('M', 'I', 'D', 'G')
    order by a.data_fin_valid desc
       </querytext>
    </fullquery>

    <fullquery name="sel_gend">
       <querytext>
    select a.gen_prog_est
         , a.gen_prog
         , coalesce(a.matricola,'&nbsp;') as matricola
         , coalesce(a.modello,'&nbsp;') as modello
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend
         , descr_emissione as scarico_fumi
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso
         , f.note_dest
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen
         , a.flag_attivo
          from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
    order by a.gen_prog_est
       </querytext>
    </fullquery>


    <fullquery name="sel_recu_cond"><!--gab01-->
       <querytext>
   select a.cod_recu_cond_aimp
        , a.num_rc
	, a.gt_collegato --rom08
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost
        , coalesce(a.modello,'&nbsp;') as modello
        , coalesce(a.matricola,'&nbsp;') as matricola
        , coalesce(iter_edit_num(a.portata_term_max, 2),'&nbsp;') as portata_term_max
        , coalesce(iter_edit_num(a.portata_term_min, 2),'&nbsp;') as portata_term_min
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost
     from coimrecu_cond_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito = 'f' --rom06
 order by a.num_rc
       </querytext>
    </fullquery>

    <fullquery name="sel_recu_cond_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_recu_cond_aimp as cod_recu_cond_aimp_sost_comp
        , a.num_rc as num_rc_sost_comp 
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;') as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;') as matricola_sost_comp
        , coalesce(iter_edit_num(a.portata_term_max, 2),'&nbsp;') as portata_term_max_sost_comp
        , coalesce(iter_edit_num(a.portata_term_min, 2),'&nbsp;') as portata_term_min_sost_comp
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost_sost_comp
     from coimrecu_cond_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito = 't' 
 order by a.num_rc
       </querytext>
    </fullquery>


    <fullquery name="sel_camp_sola"><!--gab01-->
       <querytext>
   select a.cod_camp_sola_aimp
        , a.num_cs
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(a.cod_cost,'&nbsp;')                       as cod_cost
        , coalesce(iter_edit_num(a.collettori, 0),'&nbsp;')   as collettori
        , coalesce(iter_edit_num(a.sup_totale, 2),'&nbsp;')   as sup_totale
        , coalesce(b.descr_cost, '&nbsp;')                    as descr_cost
     from coimcamp_sola_aimp a
left join coimcost b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito = 'f' --rom08
order by a.num_cs
       </querytext>
    </fullquery>

--rom08 inizio
    <fullquery name="sel_camp_sola_variaz"><!--rom08-->
       <querytext>
   select a.cod_camp_sola_aimp
        , a.num_cs as num_cs_variaz
        , coalesce(iter_edit_data(a.data_installaz_nuova_conf),'&nbsp;') as data_installaz_variaz
        , coalesce(a.cod_cost,'&nbsp;')                       as cod_cost_variaz
        , coalesce(iter_edit_num(a.collettori, 0),'&nbsp;')   as collettori_variaz
        , coalesce(iter_edit_num(a.sup_totale, 2),'&nbsp;')   as sup_totale_variaz
        , coalesce(b.descr_cost, '&nbsp;')                    as descr_cost_variaz
     from coimcamp_sola_aimp a
left join coimcost b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito = 't' 
order by a.num_cs
       </querytext>
    </fullquery>
--rom08fine

    <fullquery name="sel_altr_gend"><!--gab01-->
      <querytext>
   select a.cod_altr_gend_aimp
        , a.num_ag
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost
        , coalesce(a.modello,'&nbsp;') as modello
        , coalesce(a.matricola,'&nbsp;') as matricola
        , coalesce(a.tipologia,'&nbsp;') as tipologia
        , coalesce(iter_edit_num(a.potenza_utile, 2),'&nbsp;') as potenza_utile
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost
	, c.cod_impianto_est as cod_impianto_est_altr_gend  --rom22
	from coimaltr_gend_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
left join coimaimp c
       on c.cod_impianto = a.cod_impianto  --rom22
    where a.cod_impianto in ('[join $lista_cod_impianti ',']')
      and a.flag_sostituito ='f' --rom06
 order by a.num_ag
      </querytext>
    </fullquery>

    <fullquery name="sel_altr_gend_sost_comp"><!--rom06-->
      <querytext>
   select a.cod_altr_gend_aimp as cod_altr_gend_aimp_sost_comp
        , a.num_ag as num_ag_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;') as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;') as matricola_sost_comp
        , coalesce(a.tipologia,'&nbsp;') as tipologia_sost_comp
        , coalesce(iter_edit_num(a.potenza_utile, 2),'&nbsp;') as potenza_utile_sost_comp
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost_sost_comp
	, c.cod_impianto_est as cod_impianto_est_altr_gend_sost_comp  --rom22
     from coimaltr_gend_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
left join coimaimp c
       on c.cod_impianto = a.cod_impianto --rom22
    where a.cod_impianto in ('[join $lista_cod_impianti ',']')
      and a.flag_sostituito ='t'
 order by a.num_ag
      </querytext>
    </fullquery>

    <fullquery name="sel_vasi_espa"><!--gab01-->
      <querytext>
   select a.cod_vasi_espa_aimp
 --        , b.cod_impianto_est as cod_impianto_est_vasi_espa --rom18
        , a.num_vx
        , coalesce(iter_edit_num(a.capacita, 2),'&nbsp;') as capacita
        , a.flag_aperto
        , coalesce(iter_edit_num(a.pressione, 2),'&nbsp;') as pressione
     from coimvasi_espa_aimp a
left join coimaimp b on b.cod_impianto = a.cod_impianto --rom18
    where --rom18a.cod_impianto = :cod_impianto
          a.cod_impianto = :cod_impianto_vasi_espa --rom18
 order by a.cod_impianto, a.num_vx
      </querytext>
    </fullquery>

    <fullquery name="sel_pomp_circ"><!--gab01-->
      <querytext>
   select a.cod_pomp_circ_aimp
        , c.cod_impianto_est as cod_impianto_est_pomp_circ --rom18
        , a.num_po
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;')                  as cod_cost
        , coalesce(a.modello,'&nbsp;')                   as modello
        , case flag_giri_variabili
          when 'S' then
            'Si'
          when 'N' then
            'No'
          end                                            as flag_giri_variabili
        , coalesce(iter_edit_num(a.pot_nom, 2),'&nbsp;') as pot_nom
        , coalesce(b.descr_cost,'&nbsp;')                as descr_cost
     from coimpomp_circ_aimp a
left join coimcost b
       on b.cod_cost     = a.cod_cost
left join coimaimp  c
       on c.cod_impianto = a.cod_impianto --rom18
    where --rom18a.cod_impianto = :cod_impianto 
 --rom25 a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom18
          a.cod_impianto in ('[join $ls_aimp_pomp_circ ',']')   --rom25 
      and a.flag_sostituito ='f' --rom06
 order by a.cod_impianto,a.num_po
       </querytext>
    </fullquery>

    <fullquery name="sel_pomp_circ_sost_comp"><!--rom06-->
      <querytext>
   select a.cod_pomp_circ_aimp as cod_pomp_circ_aimp_sost_comp
        , c.cod_impianto_est as cod_impianto_est_pomp_circ_sost_comp --rom18
        , a.num_po as num_po_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;')                  as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;')                   as modello_sost_comp
        , case flag_giri_variabili
          when 'S' then
            'Si'
          when 'N' then
            'No'
          end                                            as flag_giri_variabili_sost_comp
        , coalesce(iter_edit_num(a.pot_nom, 2),'&nbsp;') as pot_nom_sost_comp
        , coalesce(b.descr_cost,'&nbsp;')                as descr_cost_sost_comp
     from coimpomp_circ_aimp a
left join coimcost b
       on b.cod_cost     = a.cod_cost
left join coimaimp  c
       on c.cod_impianto = a.cod_impianto --rom18
    where  --rom18a.cod_impianto = :cod_impianto 
 --rom25 a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom18
          a.cod_impianto in ('[join $ls_aimp_pomp_circ ',']')   --rom25 
      and a.flag_sostituito ='t' 
 order by a.cod_impianto,a.num_po
       </querytext>
    </fullquery>


    <fullquery name="sel_accu"><!--gab02-->
       <querytext>
   select a.cod_accu_aimp
        , a.num_ac
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;')                   as cod_cost
        , coalesce(a.modello,'&nbsp;')                    as modello
        , coalesce(a.matricola,'&nbsp;')                  as matricola
        , coalesce(iter_edit_num(a.capacita, 2),'&nbsp;') as capacita

        , case 
          when utilizzo = 'A' then 'Acqua Sanitaria'
          when utilizzo = 'R' then 'Riscaldamento'
          when utilizzo = 'F' then 'Raffreddamento'
          else                     '&nbsp;'
          end                                             as utilizzo
   
        , utilizzo as utilizzo_codice

--rom08 , case
--rom08	  when coibentazione = 'S' then 'Si'
--rom08   when coibentazione = 'N' then 'No'
--rom08   else                     '&nbsp;'
--rom08   end                                             as coibentazione
        , a.coibentazione --rom08

        , coalesce(b.descr_cost,'&nbsp;')                 as descr_cost
	, c.cod_impianto_est                              as cod_impianto_est_accu --rom24
     from coimaccu_aimp a
left join coimcost      b
       on b.cod_cost     = a.cod_cost
left join coimaimp      c
       on c.cod_impianto = a.cod_impianto --rom24
    where --rom24 a.cod_impianto = :cod_impianto
          $where_accu --rom24
      and a.flag_sostituito ='f' --rom06
 order by c.cod_impianto, a.num_ac
       </querytext>
    </fullquery>

    <fullquery name="sel_accu_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_accu_aimp as cod_accu_aimp_sost_comp
        , a.num_ac as num_ac_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;')                   as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;')                    as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;')                  as matricola_sost_comp
        , coalesce(iter_edit_num(a.capacita, 2),'&nbsp;') as capacita_sost_comp

        , case 
          when utilizzo = 'A' then 'Acqua Sanitaria'
          when utilizzo = 'R' then 'Riscaldamento'
          when utilizzo = 'F' then 'Raffreddamento'
          else                     '&nbsp;'
          end                                             as utilizzo_sost_comp
   
        , utilizzo as utilizzo_codice_sost_comp

--rom08 , case
--rom08	  when coibentazione = 'S' then 'Si'
--rom08   when coibentazione = 'N' then 'No'
--rom08   else                     '&nbsp;'
--rom08   end                                             as coibentazione_sost_comp
        , a.coibentazione as coibentazione_sost_comp --rom08

        , coalesce(b.descr_cost,'&nbsp;')                 as descr_cost_sost_comp
        , c.cod_impianto_est                              as cod_impianto_est_accu --rom24
     from coimaccu_aimp a
left join coimcost      b
       on b.cod_cost     = a.cod_cost
left join coimaimp      c
       on c.cod_impianto = a.cod_impianto --rom24
    where -- rom24 a.cod_impianto = :cod_impianto
          $where_accu --rom24
      and a.flag_sostituito = 't'
 order by c.cod_impianto, a.num_ac
       </querytext>
    </fullquery>

<fullquery name="sel_torr_evap_aimp"><!--gab02-->
       <querytext>
   select a.cod_torr_evap_aimp
        , a.num_te
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;')                   as cod_cost
        , coalesce(a.modello,'&nbsp;')                    as modello
        , coalesce(a.matricola,'&nbsp;')                  as matricola
        , coalesce(iter_edit_num(a.capacita, 2),'&nbsp;') as capacita
        , coalesce(a.num_ventilatori,'0')                 as num_ventilatori
        , coalesce(a.tipi_ventilatori,'&nbsp;')           as tipi_ventilatori
        , coalesce(b.descr_cost,'&nbsp;')                 as descr_cost
     from coimtorr_evap_aimp a
left join coimcost           b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='f' --rom06
 order by a.num_te
       </querytext>
    </fullquery>

<fullquery name="sel_torr_evap_aimp_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_torr_evap_aimp as cod_torr_evap_aimp_sost_comp
        , a.num_te as num_te_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;')                   as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;')                    as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;')                  as matricola_sost_comp
        , coalesce(iter_edit_num(a.capacita, 2),'&nbsp;') as capacita_sost_comp
        , coalesce(a.num_ventilatori,'0')                 as num_ventilatori_sost_comp
        , coalesce(a.tipi_ventilatori,'&nbsp;')           as tipi_ventilatori_sost_comp
        , coalesce(b.descr_cost,'&nbsp;')                 as descr_cost_sost_comp
     from coimtorr_evap_aimp a
left join coimcost           b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='t'
 order by a.num_te
       </querytext>
    </fullquery>

<fullquery name="sel_raff_aimp"><!--gab02-->
       <querytext>
   select a.cod_raff_aimp
        , a.num_rv
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;')                  as cod_cost
        , coalesce(a.modello,'&nbsp;')                   as modello
        , coalesce(a.matricola,'&nbsp;')                 as matricola
        , coalesce(a.num_ventilatori,'0')                as num_ventilatori
        , coalesce(a.tipi_ventilatori,'&nbsp;')          as tipi_ventilatori
        , coalesce(b.descr_cost,'&nbsp;')                as descr_cost
     from coimraff_aimp a
left join coimcost      b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='f' --rom06
 order by a.num_rv
       </querytext>
    </fullquery>

<fullquery name="sel_raff_aimp_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_raff_aimp as cod_raff_aimp_sost_comp
        , a.num_rv        as num_rv_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;')                  as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;')                   as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;')                 as matricola_sost_comp
        , coalesce(a.num_ventilatori,'0')                as num_ventilatori_sost_comp
        , coalesce(a.tipi_ventilatori,'&nbsp;')          as tipi_ventilatori_sost_comp
        , coalesce(b.descr_cost,'&nbsp;')                as descr_cost_sost_comp
     from coimraff_aimp a
left join coimcost      b
       on b.cod_cost     = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='t'
 order by a.num_rv
       </querytext>
    </fullquery>

<fullquery name="sel_scam_calo_aimp"><!--gab02-->
       <querytext>
   select a.cod_scam_calo_aimp
        , a.num_sc
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;')                         as cod_cost
        , coalesce(a.modello,'&nbsp;')                          as modello
	, c.cod_impianto_est                                    as cod_impianto_est_scam_calo  --rom24
     from coimscam_calo_aimp a
left join coimcost           b
       on b.cod_cost     = a.cod_cost
left join coimaimp           c
       on c.cod_impianto = a.cod_impianto --rom24       
    where -- rom24 a.cod_impianto = :cod_impianto
          $where_scam_calo --rom24
	  and a.flag_sostituito ='f' --rom06
 order by c.cod_impianto, a.num_sc
       </querytext>
    </fullquery>

<fullquery name="sel_scam_calo_aimp_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_scam_calo_aimp                                  as cod_scam_calo_aimp_sost_comp
        , a.num_sc                                              as num_sc_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;')                         as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;')                          as modello_sost_comp
	, c.cod_impianto_est                                    as cod_impianto_est_scam_calo  --rom24
     from coimscam_calo_aimp a
left join coimcost           b
       on b.cod_cost     = a.cod_cost
left join coimaimp           c
       on c.cod_impianto = a.cod_impianto --rom24
    where --rom24 a.cod_impianto = :cod_impianto
          $where_scam_calo --rom24
      and a.flag_sostituito ='t'
 order by c.cod_impianto, a.num_sc
       </querytext>
    </fullquery>


 <fullquery name="sel_circ_inte"><!--gab02-->
       <querytext>
   select a.cod_circ_inte_aimp
        , a.num_ci
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(iter_edit_num(a.lunghezza, 2),'&nbsp;')      as lunghezza
        , coalesce(iter_edit_num(a.superficie, 2),'&nbsp;')     as superficie
        , coalesce(iter_edit_num(a.profondita, 2),'&nbsp;')     as profondita 
     from coimcirc_inte_aimp a
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='f' --rom06
 order by a.num_ci
       </querytext>
    </fullquery>

 <fullquery name="sel_circ_inte_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_circ_inte_aimp as cod_circ_inte_aimp_sost_comp
        , a.num_ci             as num_ci_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(iter_edit_num(a.lunghezza, 2),'&nbsp;')      as lunghezza_sost_comp
        , coalesce(iter_edit_num(a.superficie, 2),'&nbsp;')     as superficie_sost_comp
        , coalesce(iter_edit_num(a.profondita, 2),'&nbsp;')     as profondita_sost_comp
     from coimcirc_inte_aimp a
    where a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='t'
 order by a.num_ci
       </querytext>
    </fullquery>

 <fullquery name="sel_trat_aria"><!--gab03-->
       <querytext>
   select a.cod_trat_aria_aimp
        , c.cod_impianto_est as cod_impianto_est_trat_aria --rom18	 
        , a.num_ut
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost
        , coalesce(a.modello,'&nbsp;') as modello
        , coalesce(a.matricola,'&nbsp;') as matricola
        , coalesce(iter_edit_num(a.portata_mandata, 2),'&nbsp;') as portata_mandata
        , coalesce(iter_edit_num(a.potenza_mandata, 2),'&nbsp;') as potenza_mandata
        , coalesce(iter_edit_num(a.portata_ripresa, 2),'&nbsp;') as portata_ripresa
        , coalesce(iter_edit_num(a.potenza_ripresa, 2),'&nbsp;') as potenza_ripresa
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost
     from coimtrat_aria_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
left join coimaimp c on c.cod_impianto = a.cod_impianto --rom18
    where --rom18a.cod_impianto = :cod_impianto
        a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom18
      and a.flag_sostituito ='f' --rom06
 order by a.cod_impianto,a.num_ut
       </querytext>
    </fullquery>

 <fullquery name="sel_trat_aria_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_trat_aria_aimp as cod_trat_aria_aimp_sost_comp
        , c.cod_impianto_est as cod_impianto_est_trat_aria_sost_comp --rom18	 
        , a.num_ut             as num_ut_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;') as modello_sost_comp
        , coalesce(a.matricola,'&nbsp;') as matricola_sost_comp
        , coalesce(iter_edit_num(a.portata_mandata, 2),'&nbsp;') as portata_mandata_sost_comp
        , coalesce(iter_edit_num(a.potenza_mandata, 2),'&nbsp;') as potenza_mandata_sost_comp
        , coalesce(iter_edit_num(a.portata_ripresa, 2),'&nbsp;') as portata_ripresa_sost_comp
        , coalesce(iter_edit_num(a.potenza_ripresa, 2),'&nbsp;') as potenza_ripresa_sost_comp
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost_sost_comp
     from coimtrat_aria_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
left join coimaimp c on c.cod_impianto = a.cod_impianto --rom18
    where --rom18a.cod_impianto = :cod_impianto
        a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom18
      and a.flag_sostituito ='t'
 order by a.cod_impianto,a.num_ut
       </querytext>
    </fullquery>


 <fullquery name="sel_recu_calo"><!--gab03-->
       <querytext>
   select a.cod_recu_calo_aimp
        , a.num_rc
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.tipologia,'&nbsp;')                        as tipologia
--rom08 , case
--rom08	  when installato_uta_vmc = 'U' then 'UTA'
--rom08   when installato_uta_vmc = 'V' then 'VMC'
--rom08   else                     '&nbsp;'
--rom08   end                                             as installato_uta_vmc
        , a.installato_uta_vmc --rom08
	  
         , case
          when indipendente = 'S' then 'Si'
          when indipendente = 'N' then 'No'
          else                     '&nbsp;'
          end                                                    as indipendente

        , coalesce(iter_edit_num(a.portata_mandata, 2),'&nbsp;') as portata_mandata
        , coalesce(iter_edit_num(a.potenza_mandata, 2),'&nbsp;') as potenza_mandata
        , coalesce(iter_edit_num(a.portata_ripresa, 2),'&nbsp;') as portata_ripresa
        , coalesce(iter_edit_num(a.potenza_ripresa, 2),'&nbsp;') as potenza_ripresa
	, c.cod_impianto_est                                     as cod_impianto_est_recu_calo --rom24
     from coimrecu_calo_aimp a
     left join coimaimp      c on c.cod_impianto = a.cod_impianto --rom18     
    where --rom24 a.cod_impianto = :cod_impianto
          $where_recu_calo --rom24
      and a.flag_sostituito = 'f' --rom06
 order by c.cod_impianto, a.num_rc
       </querytext>
    </fullquery>

 <fullquery name="sel_recu_calo_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_recu_calo_aimp                                  as cod_recu_calo_aimp_sost_comp
        , a.num_rc                                              as num_rc_sost_comp 
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;')   as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.tipologia,'&nbsp;')                        as tipologia_sost_comp
--rom08 , case
--rom08	  when installato_uta_vmc = 'U' then 'UTA'
--rom08   when installato_uta_vmc = 'V' then 'VMC'
--rom08   else                     '&nbsp;'
--rom08   end                                             as installato_uta_vmc_sost_comp
        , a.installato_uta_vmc                                   as installato_uta_vmc_sost_comp --rom08
         , case
          when indipendente = 'S' then 'Si'
          when indipendente = 'N' then 'No'
          else                     '&nbsp;'
          end                                                    as indipendente_sost_comp
        , coalesce(iter_edit_num(a.portata_mandata, 2),'&nbsp;') as portata_mandata_sost_comp
        , coalesce(iter_edit_num(a.potenza_mandata, 2),'&nbsp;') as potenza_mandata_sost_comp
        , coalesce(iter_edit_num(a.portata_ripresa, 2),'&nbsp;') as portata_ripresa_sost_comp
        , coalesce(iter_edit_num(a.potenza_ripresa, 2),'&nbsp;') as potenza_ripresa_sost_comp
        , c.cod_impianto_est                                     as cod_impianto_est_recu_calo --rom24
	from coimrecu_calo_aimp a
     left join coimaimp      c on c.cod_impianto = a.cod_impianto --rom18
    where --rom24 a.cod_impianto = :cod_impianto
          $where_recu_calo --rom24
	  and a.flag_sostituito = 't'
 order by c.cod_impianto, a.num_rc
       </querytext>
    </fullquery>

<fullquery name="sel_vent"><!--gab03-->
       <querytext>
   select a.cod_vent_aimp
        , a.num_vm
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost
        , coalesce(a.modello,'&nbsp;') as modello
--        , case
--	  when tipologia = 'S' then 'Sola Estrazione'
--          when tipologia = 'I' then 'Flusso doppio con recupero tramite scambiatore a flussi incrociati'
--          when tipologia = 'T' then 'Flusso doppio con recupero termodinamico'
--          when tipologia = 'A' then 'Altro'
--          else                     '&nbsp;'
--          end                          as tipologia
        , coalesce(a.tipologia,'&nbsp;') as tipologia      
        , coalesce(a.note_tipologia_altro,'&nbsp;') as note_tipologia_altro
        , coalesce(iter_edit_num(a.portata_aria, 2),'&nbsp;') as portata_aria
        , coalesce(iter_edit_num(a.rendimento_rec, 2),'&nbsp;') as rendimento_rec
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost
     from coimvent_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='f' --rom06
 order by a.num_vm
       </querytext>
    </fullquery>

<fullquery name="sel_vent_sost_comp"><!--rom06-->
       <querytext>
   select a.cod_vent_aimp as cod_vent_aimp_sost_comp
        , a.num_vm        as num_vm_sost_comp
        , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost_comp
        , coalesce(iter_edit_data(a.data_dismissione),'&nbsp;') as data_dismissione_sost_comp
        , coalesce(a.cod_cost,'&nbsp;') as cod_cost_sost_comp
        , coalesce(a.modello,'&nbsp;') as modello_sost_comp
--        , case
--	  when tipologia = 'S' then 'Sola Estrazione'
--          when tipologia = 'I' then 'Flusso doppio con recupero tramite scambiatore a flussi incrociati'
--          when tipologia = 'T' then 'Flusso doppio con recupero termodinamico'
--          when tipologia = 'A' then 'Altro'
--          else                     '&nbsp;'
--          end                          as tipologia
        , coalesce(a.tipologia,'&nbsp;') as tipologia_sost_comp      
        , coalesce(a.note_tipologia_altro,'&nbsp;') as note_tipologia_altro_sost_comp
        , coalesce(iter_edit_num(a.portata_aria, 2),'&nbsp;') as portata_aria_sost_comp
        , coalesce(iter_edit_num(a.rendimento_rec, 2),'&nbsp;') as rendimento_rec_sost_comp
        , coalesce(b.descr_cost,'&nbsp;') as descr_cost_sost_comp
     from coimvent_aimp a
left join coimcost b
       on b.cod_cost = a.cod_cost
    where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom30 a.cod_impianto = :cod_impianto 
      and a.flag_sostituito ='t'
 order by a.num_vm
       </querytext>
    </fullquery>

    <fullquery name="sel_bruc_u"><!--rom23-->
       <querytext>
	 select coalesce(a.numero_bruc,'1')                               as numero_bruc
	      , a.cod_impianto                                            as cod_impianto_bruc
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc
	      , a.gen_prog                                                as gen_prog_bruc
	      , a.gen_prog_est                                            as gen_prog_est_bruc
   	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else '&nbsp;'
		 end                                                      as flag_sostituito_bruc_edit
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc),'&nbsp;')   as data_rottamaz_bruc_edit
	      , a.data_installaz_bruc                                     as data_installazione_bruc
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
		end                                                      as tipo_bruciatore
	   from coimgend a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
 	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')
 --rom23bis and a.numero_bruc                 is not null
            and i.flag_tipo_impianto='R' --rom23bis
          order by a.cod_impianto, a.gen_prog, a.numero_bruc
       </querytext>
    </fullquery>

        <fullquery name="sel_bruc_u_no_marche"><!-- rom29 -->
       <querytext>
	 select coalesce(a.numero_bruc,'1')                               as numero_bruc
	      , a.cod_impianto                                            as cod_impianto_bruc
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc
	      , a.gen_prog                                                as gen_prog_bruc
	      , a.gen_prog_est                                            as gen_prog_est_bruc
   	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else '&nbsp;'
		 end                                                      as flag_sostituito_bruc_edit
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc),'&nbsp;')   as data_rottamaz_bruc_edit
	      , a.data_installaz_bruc                                     as data_installazione_bruc
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
		end                                                      as tipo_bruciatore
	   from coimgend a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
 	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')       
            and i.flag_tipo_impianto='R' --rom23bis
            and coalesce(a.flag_sostituito,'') !='S'

	    union all

	 select a.numero_bruc                                             as numero_bruc
	      , a.cod_impianto                                            as cod_impianto_bruc
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc
	      , a.gen_prog                                                as gen_prog_bruc
	      , g.gen_prog_est                                            as gen_prog_est_bruc
	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else ''
		end                                                       as flag_sostituito_bruc_edit
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc ),'&nbsp;')  as data_rottamaz_bruc_edit
	      , a.data_installaz_bruc                                     as data_installazione_bruc
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
 		 end                                                     as tipo_bruciatore
           from coimgend_bruc a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimgend g on g.cod_impianto = a.cod_impianto
	                       and g.gen_prog     = a.gen_prog
   	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')
	  and coalesce(g.flag_sostituito,'') !='S'
	  --    and (a.flag_sostituito_bruc = 't' or g.flag_sostituito_bruc ='t')
	  order by cod_impianto_bruc, gen_prog_bruc, numero_bruc
       </querytext>
    </fullquery>

    <fullquery name="sel_bruc_u_sost_comp"><!--rom23-->
       <querytext>
	 select a.numero_bruc                                             as numero_bruc_sost_comp
	      , a.cod_impianto                                            as cod_impianto_bruc_sost_comp
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc_sost_comp
	      , a.gen_prog                                                as gen_prog_bruc_sost_comp
	      , g.gen_prog_est                                            as gen_prog_est_bruc_sost_comp
	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else ''
		end                                                       as flag_sostituito_bruc_edit_sost_comp
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc_sost_comp
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit_sost_comp
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc ),'&nbsp;')  as data_rottamaz_bruc_edit_sost_comp
	      , a.data_installaz_bruc                                     as data_installazione_bruc_sost_comp
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc_sost_comp
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc_sost_comp
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit_sost_comp
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc_sost_comp
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
 		 end                                                     as tipo_bruciatore_sost_comp
           from coimgend_bruc a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimgend g on g.cod_impianto = a.cod_impianto
	                       and g.gen_prog     = a.gen_prog
   	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')
           and (a.flag_sostituito_bruc = 't' or g.flag_sostituito_bruc ='t') --rom26
	  order by a.cod_impianto, a.gen_prog, a.numero_bruc
       </querytext>
    </fullquery>
  
        <fullquery name="sel_bruc_u_sost_comp_no_marche"><!-- rom29 -->
       <querytext>
	 select coalesce(a.numero_bruc,'1')                               as numero_bruc_sost_comp
	      , a.cod_impianto                                            as cod_impianto_bruc_sost_comp
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc_sost_comp
	      , a.gen_prog                                                as gen_prog_bruc_sost_comp
	      , a.gen_prog_est                                            as gen_prog_est_bruc_sost_comp
   	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else '&nbsp;'
		 end                                                      as flag_sostituito_bruc_edit_sost_comp
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc_sost_comp
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit_sost_comp
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc),'&nbsp;')   as data_rottamaz_bruc_edit_sost_comp
	      , a.data_installaz_bruc                                     as data_installazione_bruc_sost_comp
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc_sost_comp
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc_sost_comp
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit_sost_comp
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc_sost_comp
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
		end                                                      as tipo_bruciatore_sost_comp
	   from coimgend a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
 	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')       
            and i.flag_tipo_impianto='R' --rom23bis
            and coalesce(a.flag_sostituito,'') ='S'

	    union all

	 select a.numero_bruc                                             as numero_bruc_sost_comp
	      , a.cod_impianto                                            as cod_impianto_bruc_sost_comp
	      , i.cod_impianto_est                                        as cod_impianto_est_bruc_sost_comp
	      , a.gen_prog                                                as gen_prog_bruc_sost_comp
	      , g.gen_prog_est                                            as gen_prog_est_bruc_sost_comp
	      , case a.flag_sostituito_bruc
	        when 't' then 'S&igrave;'
		when 'f' then 'No'
		else ''
		end                                                       as flag_sostituito_bruc_edit_sost_comp
	      , a.flag_sostituito_bruc                                    as flag_sostituito_bruc_sost_comp
	      , coalesce(iter_edit_data(a.data_installaz_bruc),'&nbsp;')  as data_installaz_bruc_edit_sost_comp
	      , coalesce(iter_edit_data(a.data_rottamaz_bruc ),'&nbsp;')  as data_rottamaz_bruc_edit_sost_comp
	      , a.data_installaz_bruc                                     as data_installazione_bruc_sost_comp
	      , a.data_rottamaz_bruc                                      as data_rottamazione_bruc_sost_comp
	      , coalesce(a.modello_bruc,'&nbsp;')                         as modello_bruc_sost_comp
	      , coalesce(a.matricola_bruc,'&nbsp;')                       as matricola_bruc_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_max, 2),'&nbsp;')  as campo_funzion_max_edit_sost_comp
	      , coalesce(iter_edit_num(a.campo_funzion_min, 2),'&nbsp;')  as campo_funzion_min_edit_sost_comp
	      , coalesce(b.descr_cost,'&nbsp;')                           as fabbricante_bruc_sost_comp_sost_comp
	      , case a.tipo_bruciatore
	        when 'A' then 'Atmosferico'
		when 'P' then 'Pressurizzato'
		when 'M' then 'Premiscelato'
		else '&nbsp;'
 		 end                                                     as tipo_bruciatore_sost_comp
           from coimgend_bruc a
	   left join coimaimp i on i.cod_impianto = a.cod_impianto
	   left join coimgend g on g.cod_impianto = a.cod_impianto
	                       and g.gen_prog     = a.gen_prog
   	   left join coimcost b on b.cod_cost = a.cod_cost_bruc
	  where a.cod_impianto                in ('[join $lista_cod_impianti ',']')
	  and coalesce(g.flag_sostituito,'') ='S'
	  --    and (a.flag_sostituito_bruc = 't' or g.flag_sostituito_bruc ='t')
	  order by cod_impianto_bruc_sost_comp, gen_prog_bruc_sost_comp, numero_bruc_sost_comp
       </querytext>
    </fullquery>


    <fullquery name="sel_bruc">
       <querytext>
	 select coalesce(iter_edit_data(data_installaz_bruc), '&nbsp;') as data_installaz_bruc
	       ,coalesce(iter_edit_data(data_rottamaz_bruc), '&nbsp;') as data_rottamaz_bruc --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_min, 2), '&nbsp;') as campo_funzion_min --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_max, 2), '&nbsp;') as campo_funzion_max --rom04
	       ,coalesce(c.descr_cost, '&nbsp;') as costruttore_bruc
	       ,coalesce(matricola_bruc, '&nbsp;') as matricola_bruc
	       ,coalesce(modello_bruc, '&nbsp;') as modello_bruc
	       ,case when tipo_bruciatore='A' then 'Atmosferico'
	             when tipo_bruciatore='P' then 'Pressurizzato'
                     when tipo_bruciatore='M' then 'Premiscelato'
                     else '&nbsp;' end as tipo_bruciatore
	       ,coalesce(b.descr_comb,'&nbsp;') as descr_comb
	       ,coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib
	       ,coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib
               ,coalesce(c.descr_cost, '&nbsp;') as descr_cost
	       ,a.gen_prog_est     as gen_prog_est_bruc     --rom17
	       ,f.cod_impianto_est as cod_impianto_est_bruc --rom17 
	 from coimgend a
	 left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
	 left outer join coimcost c on c.cod_cost         = a.cod_cost_bruc
	 left outer join coimaimp f on f.cod_impianto     = a.cod_impianto
	 where a.cod_impianto = :cod_impianto
	 and f.flag_tipo_impianto = 'R'
	 and (a.matricola_bruc is not null or modello_bruc is not null or c.cod_cost is not null)
	 order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_bruc_padre">
       <querytext>
         select coalesce(iter_edit_data(data_installaz_bruc), '&nbsp;') as data_installaz_bruc_padre
	      ,coalesce(iter_edit_data(data_rottamaz_bruc), '&nbsp;') as data_rottamaz_bruc_padre --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_min, 2), '&nbsp;') as campo_funzion_min_padre --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_max, 2), '&nbsp;') as campo_funzion_max_padre --rom04
              ,coalesce(c.descr_cost, '&nbsp;') as costruttore_bruc_padre
              ,coalesce(matricola_bruc, '&nbsp;') as matricola_bruc_padre
              ,coalesce(modello_bruc, '&nbsp;') as modello_bruc_padre
	      ,case when tipo_bruciatore='A' then 'Atmosferico'
                     when tipo_bruciatore='P' then 'Pressurizzato'
                     when tipo_bruciatore='M' then 'Premiscelato'
                     else '&nbsp;' end as tipo_bruciatore_padre
              ,coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre
              ,coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre
              ,coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_padre
              ,coalesce(c.descr_cost, '&nbsp;') as descr_cost_padre
              ,a.gen_prog_est     as gen_prog_est_bruc_padre     --rom17
              ,f.cod_impianto_est as cod_impianto_est_bruc_padre --rom17
         from coimgend a
         left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
         left outer join coimcost c on c.cod_cost         = a.cod_cost_bruc
         left outer join coimaimp f on f.cod_impianto         = a.cod_impianto 
         -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
         -- rom29 and f.cod_impianto != h.cod_impianto
       where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
         and f.cod_impianto != :cod_impianto
         and f.flag_tipo_impianto = 'R'
	 and (a.matricola_bruc is not null or modello_bruc is not null or c.cod_cost is not null)
	 and f.stato='A'
         order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_bruc_padre_targa"><!-- sim04 -->
       <querytext>
         select coalesce(iter_edit_data(data_installaz_bruc), '&nbsp;') as data_installaz_bruc_padre
              ,coalesce(iter_edit_data(data_rottamaz_bruc), '&nbsp;') as data_rottamaz_bruc_padre --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_min, 2), '&nbsp;') as campo_funzion_min_padre --rom04
               ,coalesce(iter_edit_num(a.campo_funzion_max, 2), '&nbsp;') as campo_funzion_max_padre --rom04
              ,coalesce(c.descr_cost, '&nbsp;') as costruttore_bruc_padre
              ,coalesce(matricola_bruc, '&nbsp;') as matricola_bruc_padre
              ,coalesce(modello_bruc, '&nbsp;') as modello_bruc_padre
	      ,case when tipo_bruciatore='A' then 'Atmosferico'
                     when tipo_bruciatore='P' then 'Pressurizzato'
                     when tipo_bruciatore='M' then 'Premiscelato'
                     else '&nbsp;' end as tipo_bruciatore_padre
              ,coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre
              ,coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre
              ,coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_padre
              ,coalesce(c.descr_cost, '&nbsp;') as descr_cost_padre
              ,a.gen_prog_est     as gen_prog_est_bruc_padre     --rom17
              ,f.cod_impianto_est as cod_impianto_est_bruc_padre --rom17
         from coimgend a
         left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
         left outer join coimcost c on c.cod_cost         = a.cod_cost_bruc
         inner join coimaimp f      on f.cod_impianto     = a.cod_impianto 
         where f.cod_impianto != :cod_impianto
           and upper(f.targa)         = upper(:targa)
         and f.flag_tipo_impianto = 'R'
	 and (a.matricola_bruc is not null or modello_bruc is not null or c.cod_cost is not null)
	 and f.stato='A'
         order by a.gen_prog_est
       </querytext>
    </fullquery>


    <fullquery name="sel_gend_con">
       <querytext>
    select a.gen_prog_est
         , a.gen_prog
         , coalesce(a.matricola,'&nbsp;') as matricola
         , coalesce(a.modello,'&nbsp;') as modello
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con
         , coalesce(c.descr_cost, '&nbsp;') as descr_cost
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min       
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max       
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min     
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max     
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min       
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max       
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max       
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione
	  , f.cod_impianto_est as cod_impianto_gend_co --rom16
     from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'C' --sim01
--rom20and f.stato='A'
       $and_st_imp --rom20
--     and coalesce(a.flag_sostituito,'') !='S' --rom11 
$where_gend_sost
order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_con_sost"><!--rom11-->
       <querytext>
    select a.gen_prog_est as gen_prog_est_sost
         , a.gen_prog as gen_prog_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_sost
         , coalesce(a.modello,'&nbsp;') as modello_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_sost
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con_sost
         , coalesce(c.descr_cost, '&nbsp;') as descr_cost_sost
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min_sost  
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max_sost  
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min_sost
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max_sost
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min_sost  
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max_sost  
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min_sost       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max_sost
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max_sost
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min_sost
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione_sost
     from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto 
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
     and f.flag_tipo_impianto = 'C' 
--     and a.flag_sostituito    = 'S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!-- Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_con_padre">
       <querytext>
    select a.gen_prog_est as gen_prog_est_con_padre
         , a.gen_prog_est as gen_prog_con_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_con_padre
         , coalesce(a.modello,'&nbsp;') as modello_con_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_con_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_con_padre
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_con_padre
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_con_padre
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min_con_padre       
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max_con_padre       
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min_con_padre     
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max_con_padre     
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min_con_padre       
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max_con_padre       
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min_con_padre       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max_con_padre       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min_con_padre       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max_con_padre       
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max_con_padre
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min_con_padre
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione_con_padre
	 , f.cod_impianto_est as cod_impianto_est_padre
 	 , f.cod_impianto_est as cod_impianto_est_co_padre --rom16
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'C' --sim01
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!--rom11 Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_con_padre_sost">
       <querytext>
    select a.gen_prog_est as gen_prog_est_con_padre_sost
         , a.gen_prog_est as gen_prog_con_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_con_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_con_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_con_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_con_padre_sost
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_con_padre_sost
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_con_padre_sost
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min_con_padre_sost     
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max_con_padre_sost     
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max_con_padre_sost       
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max_con_padre_sost
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min_con_padre_sost
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione_con_padre_sost
	 , f.cod_impianto_est as cod_impianto_est_padre
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
       and f.flag_tipo_impianto = 'C'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
       order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_con_padre_targa"><!-- sim04 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_con_padre
         , a.gen_prog_est as gen_prog_con_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_con_padre
         , coalesce(a.modello,'&nbsp;') as modello_con_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_con_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_con_padre
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_con_padre
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_con_padre
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min_con_padre       
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max_con_padre       
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min_con_padre     
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max_con_padre     
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min_con_padre       
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max_con_padre       
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min_con_padre       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max_con_padre       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min_con_padre       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max_con_padre       
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max_con_padre
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min_con_padre
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione_con_padre
	, f.cod_impianto_est as cod_impianto_est_padre
	, f.cod_impianto_est as cod_impianto_est_co_padre --rom16
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
       and f.flag_tipo_impianto = 'C'
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_con_padre_targa_sost"><!-- rom11 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_con_padre_sost
         , a.gen_prog     as gen_prog_con_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_con_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_con_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_con_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_con_padre_sost
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_con_padre_sost
         , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_con_padre_sost 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_con_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_con_padre_sost
         , coalesce(iter_edit_num(temp_h2o_uscita_min, 2),'0,00')          as temp_h2o_uscita_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_uscita_max, 2),'0,00')          as temp_h2o_uscita_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_ingresso_min, 2),'0,00')        as temp_h2o_ingresso_min_con_padre_sost     
         , coalesce(iter_edit_num(temp_h2o_ingresso_max, 2),'0,00')        as temp_h2o_ingresso_max_con_padre_sost     
         , coalesce(iter_edit_num(temp_h2o_motore_min, 2),'0,00')          as temp_h2o_motore_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_h2o_motore_max, 2),'0,00')          as temp_h2o_motore_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_valle_min, 2),'0,00')          as temp_fumi_valle_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_valle_max, 2),'0,00')          as temp_fumi_valle_max_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_min, 2),'0,00')          as temp_fumi_monte_min_con_padre_sost       
         , coalesce(iter_edit_num(temp_fumi_monte_max, 2),'0,00')          as temp_fumi_monte_max_con_padre_sost       
         , coalesce(iter_edit_num(emissioni_monossido_co_max, 2),'0,00')   as emissioni_monossido_co_max_con_padre_sost
         , coalesce(iter_edit_num(emissioni_monossido_co_min, 2),'0,00')   as emissioni_monossido_co_min_con_padre_sost
         , case
          when tipologia_cogenerazione = 'M' then 'Motore Endotermico'
          when tipologia_cogenerazione = 'C' then 'Caldaia Cogenerativa'
          when tipologia_cogenerazione = 'T' then 'Turbogas'
          when tipologia_cogenerazione = 'A' then 'Altro'
          else                     '&nbsp;'
          end                          as tipologia_cogenerazione_con_padre_sost
	 , f.cod_impianto_est as cod_impianto_est_padre
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
       and f.flag_tipo_impianto = 'C'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>


    <!-- Nuova query committata il 02/10/2014 -->
    <fullquery name="sel_gend_ri">
       <querytext>
    select a.gen_prog_est
         , a.gen_prog
         , coalesce(a.matricola,'&nbsp;') as matricola
         , coalesce(a.modello,'&nbsp;') as modello
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz
	 , coalesce(iter_edit_data(a.data_costruz_gen), '&nbsp;')  as data_costruz_gen  --rom11
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend
         , descr_emissione as scarico_fumi
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso
         , f.note_dest
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen
	,case a.flag_attivo
              when 'S' then 'S&igrave;'
              else 'No'
               end as attivo_si_no --rom11
         , a.flag_attivo
         , case a.locale                   --rom03
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
		else '&nbsp;'
                end as locale
	, case  a.dpr_660_96               --rom03
                when 'S' then 'Standard'
		when 'B' then 'Bassa temperatura'
		when 'G' then 'Gas a condensazione'
		else '&nbsp;'
		end as dpr_660_96 
        , case  a.flag_caldaia_comb_liquid  --rom03
	        when 'S' then 'Si'
		when 'N' then 'No'
		else '&nbsp;'
		end as flag_caldaia_comb_liquid
        , case  a.tipo_foco                --rom03
	        when 'A' then 'Aperta' 
		when 'C' then 'Stagna'
		else '&nbsp;'
		end as tipo_foco
	, a.funzione_grup_ter_note_altro --rom03
        , case  a.funzione_grup_ter        --rom03
                when 'P' then 'Prod. Acqua calda sanitaria'
		when 'I' then 'Climatiz. invernale'
		when 'E' then 'Climatiz. estiva'
		when 'A' then a.funzione_grup_ter_note_altro
		else '&nbsp;'
		end as funzione_grup_ter
        , case  a.tiraggio                 --rom03
                when 'N' then 'Naturale'
		when 'F' then 'Forzato'
                else '&nbsp;'
		end as tiraggio
        , case  a.cod_emissione            --rom03
                when 'C' then 'Camino Collettivo'
		when 'I' then 'camino Individuale'
		when 'P' then 'Scarico a Parete'
		else 'Non Noto' 
		end as cod_emissione
       , descr_fuge as fluido_termovettore
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max
       , a.cod_grup_term
       , a.rif_uni_10389
       , a.altro_rif
       , a.num_prove_fumi
       , f.cod_impianto_est as cod_impianto_gend --rom16
     from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
     where a.cod_impianto = :cod_impianto
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
     and f.flag_tipo_impianto = 'R' --sim01
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!--rom11 Ricavo i generatori sostituiti -->
    <fullquery name="sel_gend_ri_sost">
       <querytext>
    select a.gen_prog_est as gen_prog_est_sost
         , a.gen_prog     as gen_prog_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_sost
         , coalesce(a.modello,'&nbsp;') as modello_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_sost
         , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_sost 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_sost
         , descr_emissione as scarico_fumi_sost
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_sost
         , f.note_dest as note_dest_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_sost
         , a.flag_attivo as flag_attivo_sost
         , case a.locale                   
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
		else '&nbsp;'
                end as locale_sost
	, case  a.dpr_660_96               
                when 'S' then 'Standard'
		when 'B' then 'Bassa temperatura'
		when 'G' then 'Gas a condensazione'
		else '&nbsp;'
		end as dpr_660_96_sost 
        , case  a.flag_caldaia_comb_liquid 
	        when 'S' then 'Si'
		when 'N' then 'No'
		else '&nbsp;'
		end as flag_caldaia_comb_liquid_sost
        , case  a.tipo_foco                
	        when 'A' then 'Aperta' 
		when 'C' then 'Stagna'
		else '&nbsp;'
		end as tipo_foco_sost
	, a.funzione_grup_ter_note_altro as funzione_grup_ter_note_altro_sost 
        , case  a.funzione_grup_ter        
                when 'P' then 'Prod. Acqua calda sanitaria'
		when 'I' then 'Climatiz. invernale'
		when 'E' then 'Climatiz. estiva'
		when 'A' then a.funzione_grup_ter_note_altro
		else '&nbsp;'
		end as funzione_grup_ter_sost
        , case  a.tiraggio                 
                when 'N' then 'Naturale'
		when 'F' then 'Forzato'
                else '&nbsp;'
		end as tiraggio_sost
        , case  a.cod_emissione            
                when 'C' then 'Camino Collettivo'
		when 'I' then 'camino Individuale'
		when 'P' then 'Scarico a Parete'
		else 'Non Noto' 
		end as cod_emissione_sost
       , descr_fuge as fluido_termovettore_sost
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_sost
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max_sost
       , a.cod_grup_term as cod_grup_term_sost
       , a.rif_uni_10389 as rif_uni_10389_sost
       , a.altro_rif     as altro_rif_sost
       , a.num_prove_fumi as num_prove_fumi_sost
     from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto 
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
     and f.flag_tipo_impianto = 'R' 
--     and a.flag_sostituito    = 'S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!-- Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_ri_padre">
       <querytext>
    select a.gen_prog_est as gen_prog_est_padre
         , a.gen_prog as gen_prog_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_padre
         , coalesce(a.modello,'&nbsp;') as modello_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_padre
         , descr_emissione as scarico_fumi_padre
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_padre
         , f.note_dest as note_dest_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre
         , a.flag_attivo as flag_attivo_padre
         , case a.locale                   --rom03
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
                else '&nbsp;'
                end as locale_padre
        , case  a.dpr_660_96               --rom03
                when 'S' then 'Standard'
                when 'B' then 'Bassa temperatura'
                when 'G' then 'Gas a condensazione'
                else '&nbsp;'
                end as dpr_660_96_padre
        , case  a.flag_caldaia_comb_liquid --rom03
                when 'S' then 'Si'
                when 'N' then 'No'
                else '&nbsp;'
                end as flag_caldaia_comb_liquid_padre
        , case  a.tipo_foco                --rom03
                when 'A' then 'Aperta'
                when 'C' then 'Stagna'
                else '&nbsp;'
                end as tipo_foco_padre
        , a.funzione_grup_ter_note_altro
        , case  a.funzione_grup_ter        --rom03
                when 'P' then 'Prod. Acqua calda sanitaria'
                when 'I' then 'Climatiz. invernale'
                when 'E' then 'Climatiz. estiva'
                when 'A' then a.funzione_grup_ter_note_altro
                else '&nbsp;'
                end as funzione_grup_ter_padre
        , case  a.tiraggio                 --rom03
                when 'N' then 'Naturale'
                when 'F' then 'Forzato'
                else '&nbsp;'
                end as tiraggio_padre
        , case  a.cod_emissione            --rom03
                when 'C' then 'Camino Collettivo'
                when 'I' then 'camino Individuale'
                when 'P' then 'Scarico a Parete'
                else 'Non Noto'
                end as cod_emissione_padre
       , descr_fuge as fluido_termovettore_padre
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_padre
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max_padre
       , a.cod_grup_term as cod_grup_term_padre
       , a.rif_uni_10389 as rif_uni_10389_padre
       , a.altro_rif as altro_rif_padre
       , a.num_prove_fumi as num_prove_fumi_padre
       , f.cod_impianto_est as cod_impianto_est_padre
       , a.cod_impianto     as cod_impianto_padre --rom16
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'R' --sim01
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!--rom11 Ricavo i generatori dell'impianto padre sostituiti-->
     <fullquery name="sel_gend_ri_padre_sost">
       <querytext>
    select a.gen_prog_est as gen_prog_est_padre_sost
         , a.gen_prog as gen_prog_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_padre_sost
         , descr_emissione as scarico_fumi_padre_sost
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_padre_sost
         , f.note_dest as note_dest_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre_sost
         , a.flag_attivo as flag_attivo_padre_sost
         , case a.locale                
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
                else '&nbsp;'
                end as locale_padre_sost
        , case  a.dpr_660_96               
                when 'S' then 'Standard'
                when 'B' then 'Bassa temperatura'
                when 'G' then 'Gas a condensazione'
                else '&nbsp;'
                end as dpr_660_96_padre_sost
        , case  a.flag_caldaia_comb_liquid 
                when 'S' then 'Si'
                when 'N' then 'No'
                else '&nbsp;'
                end as flag_caldaia_comb_liquid_padre_sost
        , case  a.tipo_foco                
                when 'A' then 'Aperta'
                when 'C' then 'Stagna'
                else '&nbsp;'
                end as tipo_foco_padre
        , a.funzione_grup_ter_note_altro as funzione_grup_ter_note_altro_sost
        , case  a.funzione_grup_ter        
                when 'P' then 'Prod. Acqua calda sanitaria'
                when 'I' then 'Climatiz. invernale'
                when 'E' then 'Climatiz. estiva'
                when 'A' then a.funzione_grup_ter_note_altro
                else '&nbsp;'
                end as funzione_grup_ter_padre_sost
        , case  a.tiraggio                
                when 'N' then 'Naturale'
                when 'F' then 'Forzato'
                else '&nbsp;'
                end as tiraggio_padre_sost
        , case  a.cod_emissione            
                when 'C' then 'Camino Collettivo'
                when 'I' then 'camino Individuale'
                when 'P' then 'Scarico a Parete'
                else 'Non Noto'
                end as cod_emissione_padre_sost
       , descr_fuge as fluido_termovettore_padre_sost
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_padre_sost
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max_padre_sost
       , a.cod_grup_term as cod_grup_term_padre_sost
       , a.rif_uni_10389 as rif_uni_10389_padre_sost
       , a.altro_rif as altro_rif_padre_sost
       , a.num_prove_fumi as num_prove_fumi_padre_sost
       , f.cod_impianto_est as cod_impianto_est_padre 
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
     and f.flag_tipo_impianto = 'R'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_ri_padre_targa"><!-- sim04 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_padre
         , a.gen_prog as gen_prog_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_padre
         , coalesce(a.modello,'&nbsp;') as modello_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_padre
         , descr_emissione as scarico_fumi_padre
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_padre
         , f.note_dest as note_dest_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre
         , a.flag_attivo as flag_attivo_padre
         , case a.locale                   --rom03
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
                else '&nbsp;'
                end as locale_padre
        , case  a.dpr_660_96               --rom03
                when 'S' then 'Standard'
                when 'B' then 'Bassa temperatura'
                when 'G' then 'Gas a condensazione'
                else '&nbsp;'
                end as dpr_660_96_padre
        , case  a.flag_caldaia_comb_liquid --rom03
                when 'S' then 'Si'
                when 'N' then 'No'
                else '&nbsp;'
                end as flag_caldaia_comb_liquid_padre
        , case  a.tipo_foco                --rom03
                when 'A' then 'Aperta'
                when 'C' then 'Stagna'
                else '&nbsp;'
                end as tipo_foco_padre
        , a.funzione_grup_ter_note_altro
        , case  a.funzione_grup_ter        --rom03
                when 'P' then 'Prod. Acqua calda sanitaria'
                when 'I' then 'Climatiz. invernale'
                when 'E' then 'Climatiz. estiva'
                when 'A' then a.funzione_grup_ter_note_altro
                else '&nbsp;'
                end as funzione_grup_ter_padre
        , case  a.tiraggio                 --rom03
                when 'N' then 'Naturale'
                when 'F' then 'Forzato'
                else '&nbsp;'
                end as tiraggio_padre
        , case  a.cod_emissione            --rom03
                when 'C' then 'Camino Collettivo'
                when 'I' then 'camino Individuale'
                when 'P' then 'Scarico a Parete'
                else 'Non Noto'
                end as cod_emissione_padre
       , descr_fuge as fluido_termovettore_padre
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_padre
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max_padre
       , a.cod_grup_term as cod_grup_term_padre
       , a.rif_uni_10389 as rif_uni_10389_padre
       , a.altro_rif as altro_rif_padre
       , a.num_prove_fumi as num_prove_fumi_padre
       , f.cod_impianto_est as cod_impianto_est_padre
       , a.cod_impianto     as cod_impianto_padre --rom16
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'R'
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

   <fullquery name="sel_gend_ri_padre_targa_sost"><!--rom11--> 
      <querytext>
    select a.gen_prog_est as gen_prog_est_padre_sost
         , a.gen_prog as gen_prog_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_padre_sost
         , descr_emissione as scarico_fumi_padre_sost
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_padre_sost
         , f.note_dest as note_dest_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre_sost
         , a.flag_attivo as flag_attivo_padre_sost
         , case a.locale                
                when 'T' then 'Locale ad uso esclusivo'
                when 'I' then 'Interno'
                when 'E' then 'Esterno'
                else '&nbsp;'
                end as locale_padre_sost
        , case  a.dpr_660_96               
                when 'S' then 'Standard'
                when 'B' then 'Bassa temperatura'
                when 'G' then 'Gas a condensazione'
                else '&nbsp;'
                end as dpr_660_96_padre_sost
        , case  a.flag_caldaia_comb_liquid 
                when 'S' then 'Si'
                when 'N' then 'No'
                else '&nbsp;'
                end as flag_caldaia_comb_liquid_padre_sost
        , case  a.tipo_foco                
                when 'A' then 'Aperta'
                when 'C' then 'Stagna'
                else '&nbsp;'
                end as tipo_foco_padre_sost
        , a.funzione_grup_ter_note_altro as funzione_grup_ter_note_altro_padre_sost
        , case  a.funzione_grup_ter        
                when 'P' then 'Prod. Acqua calda sanitaria'
                when 'I' then 'Climatiz. invernale'
                when 'E' then 'Climatiz. estiva'
                when 'A' then a.funzione_grup_ter_note_altro
                else '&nbsp;'
                end as funzione_grup_ter_padre_sost
        , case  a.tiraggio                
                when 'N' then 'Naturale'
                when 'F' then 'Forzato'
                else '&nbsp;'
                end as tiraggio_padre_sost
        , case  a.cod_emissione            
                when 'C' then 'Camino Collettivo'
                when 'I' then 'camino Individuale'
                when 'P' then 'Scarico a Parete'
                else 'Non Noto'
                end as cod_emissione_padre_sost
       , descr_fuge as fluido_termovettore_padre_sost
       , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_padre_sost
       , coalesce(iter_edit_num(a.rend_ter_max, 2),'&nbsp;') as rend_ter_max_padre_sost
       , a.cod_grup_term as cod_grup_term_padre_sost
       , a.rif_uni_10389 as rif_uni_10389_padre_sost
       , a.altro_rif as altro_rif_padre_sost
       , a.num_prove_fumi as num_prove_fumi_padre_sost
       , f.cod_impianto_est as cod_impianto_est_padre
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fl on fl.cod_fuge        = a.mod_funz
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
       and f.flag_tipo_impianto = 'R'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr">
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr
         , a.gen_prog as gen_prog_fr
         , coalesce(a.matricola,'&nbsp;') as matricola_fr
         , coalesce(a.modello,'&nbsp;') as modello_fr
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr
         , coalesce(a.num_circuiti) as num_circuiti --rom04
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr
         , descr_emissione as scarico_fumi_fr
--sim09         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_fr
	 , coalesce(g.descr_utgi,'&nbsp;') as dest_uso_fr --sim09
         , f.note_dest
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr
         , a.flag_attivo
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr                                   --sim09
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr                                   --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr               --sim09
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr               --sim09
  --     , case a.mod_funz
  --            when '0' then 'Non noto'
  --            when '1' then 'Acqua calda'
  --            when '2' then 'Aria calda'
  --            when '3' then 'Altro'
  --            end as mod_funz
         , fu.descr_fuge               --rom28
	 , fl.sigla      as descr_flre --rom28
         , fl.fluido     as fluido_flre  --but04
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco
	 , a.sorgente_lato_esterno --rom11
	 , a.fluido_lato_utenze    --rom11
	 , f.cod_impianto_est as cod_impianto_gend_fr --rom16
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto --sim01 and f.flag_tipo_impianto = 'F'
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S' 
     and f.flag_tipo_impianto = 'F' --sim01
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr_sost">
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr_sost
         , a.gen_prog as gen_prog_fr_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_fr_sost
         , coalesce(a.modello,'&nbsp;') as modello_fr_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr_sost
         , coalesce(a.num_circuiti) as num_circuiti_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr_sost
         , descr_emissione as scarico_fumi_fr_sost
	 , coalesce(g.descr_utgi,'&nbsp;') as dest_uso_fr_sost
         , f.note_dest as note_dest_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr_sost
         , a.flag_attivo as flag_attivo_sost
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr_sost
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr_sost
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr_sost
--         , case a.mod_funz
--                when '0' then 'Non noto'
--                when '1' then 'Acqua calda'
--                when '2' then 'Aria calda'
--                when '3' then 'Altro'
--                end as mod_funz_sost
         , fu.descr_fuge as descr_fuge_sost --rom28
	 , fl.sigla      as descr_flre_sost --rom28
         , fl.fluido     as fluido_flre_sost --but04
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco_sost
	 , a.sorgente_lato_esterno as sorgente_lato_esterno_sost --rom11
	 , a.fluido_lato_utenze    as fluido_lato_utenze_sost    --rom11
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto	    = a.cod_impianto 
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
     where a.cod_impianto = :cod_impianto
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
     and f.flag_tipo_impianto = 'F'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!-- Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_fr_padre"> <!-- gab04 -->
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr_padre
         , a.gen_prog as gen_prog_fr_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_fr_padre
         , coalesce(a.modello,'&nbsp;') as modello_fr_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr_padre
         , coalesce(a.num_circuiti) as num_circuiti_fr_padre --rom04
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr_padre
         , descr_emissione as scarico_fumi_fr_padre
--sim09    , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_fr_padre
	 , coalesce(g.descr_utgi,'&nbsp;') as dest_uso_fr_padre     --sim09
         , f.note_dest as note_dest_fr_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre
         , a.flag_attivo as stato_gen_fr_padre
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr_padre                                   --sim09
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr_padre                                   --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr_padre --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr_padre               --sim09
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr_padre               --sim09
--         , case a.mod_funz
--                when '0' then 'Non noto'
--                when '1' then 'Acqua calda'
--                when '2' then 'Aria calda'
--                when '3' then 'Altro'
--                end as mod_funz_padre
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco_padre
         , a.sorgente_lato_esterno as sorgente_lato_esterno_padre --rom11
         , a.fluido_lato_utenze    as fluido_lato_utenze_padre    --rom11
	 , f.cod_impianto_est as cod_impianto_est_padre
	 , f.cod_impianto     as cod_impianto_fr_padre --rom16
         , fu.descr_fuge      as descr_fuge_padre      --rom28
	 , fl.sigla           as descr_flre_padre      --rom28
         , fl.fluido          as fluido_flre_padre     --but04
         from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'F' --sim01
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!--rom11 Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_fr_padre_sost"> 
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr_padre_sost
         , a.gen_prog as gen_prog_fr_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_fr_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_fr_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr_padre_sost
         , coalesce(a.num_circuiti) as num_circuiti_fr_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr_padre_sost
         , descr_emissione as scarico_fumi_fr_padre_sost
	 , coalesce(g.descr_utgi,'&nbsp;') as dest_uso_fr_padre_sost
         , f.note_dest as note_dest_fr_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre_sost
         , a.flag_attivo as stato_gen_fr_padre_sost
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr_padre_sost
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr_padre_sost
   --    , case a.mod_funz
   --           when '0' then 'Non noto'
   --           when '1' then 'Acqua calda'
   --           when '2' then 'Aria calda'
   --           when '3' then 'Altro'
   --           end as mod_funz_padre_sost
         , fu.descr_fuge as descr_fuge_padre_sost --rom28
	 , fl.sigla      as descr_flre_padre_sost --rom28
         , fl.fluido     as fluido_flre_padre_sost --but04
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco_padre_sost
         , a.sorgente_lato_esterno as sorgente_lato_esterno_padre_sost --rom11
         , a.fluido_lato_utenze    as fluido_lato_utenze_padre_sost    --rom11
	 , f.cod_impianto_est as cod_impianto_fr_est_padre_sost
          from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
     and f.flag_tipo_impianto = 'F' 
--     and a.flag_sostituito    = 'S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr_padre_targa"><!-- gab04 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_fr_padre	   
         , a.gen_prog as gen_prog_fr_padre		   
         , coalesce(a.matricola,'&nbsp;') as matricola_fr_padre
         , coalesce(a.modello,'&nbsp;') as modello_fr_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr_padre
         , coalesce(a.num_circuiti) as num_circuiti_fr_padre --rom04
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr_padre
         , descr_emissione as scarico_fumi_fr_padre
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_fr_padre
         , f.note_dest as note_dest_fr_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr_padre
         , a.flag_attivo as flag_attivo_fr_padre
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr_padre                                   --sim09
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr_padre                                   --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr_padre --sim09
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr_padre               --sim09
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr_padre               --sim09
   --    , case a.mod_funz
   --           when '0' then 'Non noto'
   --           when '1' then 'Acqua calda'
   --           when '2' then 'Aria calda'
   --           when '3' then 'Altro'
   --           end as mod_funz_padre 
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco_padre
         , fu.descr_fuge as descr_fuge_padre      --rom28	 
	 , fl.sigla      as descr_flre_padre      --rom28
         , fl.fluido     as fluido_flre_padre     --but04
         , a.sorgente_lato_esterno as sorgente_lato_esterno_padre  --rom11
         , a.fluido_lato_utenze    as fluido_lato_utenze_padre     --rom11
	 , f.cod_impianto_est as cod_impianto_est_padre
	 , f.cod_impianto     as cod_impianto_fr_padre --rom16
          from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
     and f.flag_tipo_impianto = 'F'
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
   order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr_padre_targa_sost"><!--rom11 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_fr_padre_sost	   
         , a.gen_prog as gen_prog_fr_padre_sost		   
         , coalesce(a.matricola,'&nbsp;') as matricola_fr_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_fr_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_fr_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_fr_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_fr_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_fr_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_gend_fr_padre_sost
         , coalesce(a.num_circuiti) as num_circuiti_fr_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_fr_padre_sost
         , descr_emissione as scarico_fumi_fr_padre_sost
         , coalesce(g.descr_e_utgi,'&nbsp;') as dest_uso_fr_padre_sost
         , f.note_dest as note_dest_fr_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr_padre_sost
         , a.flag_attivo as flag_attivo_fr_padre_sost
         , coalesce(iter_edit_num(a.cop, 2),'&nbsp;') as cop_fr_padre_sost                         
         , coalesce(iter_edit_num(a.per, 2),'&nbsp;') as per_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom_freddo, 2),'&nbsp;') as pot_utile_nom_freddo_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as pot_utile_nom_fr_padre_sost
	 , coalesce(iter_edit_num(a.pot_utile_lib, 2),'&nbsp;') as pot_utile_lib_fr_padre_sost
  --     , case a.mod_funz
  --            when '0' then 'Non noto'
  --            when '1' then 'Acqua calda'
  --            when '2' then 'Aria calda'
  --            when '3' then 'Altro'
  --            end as mod_funz_padre_sost    
         , fu.descr_fuge as descr_fuge_padre_sost --rom28	 
	 , fl.sigla      as descr_flre_padre_sost --rom28
         , fl.fluido     as fluido_flre_padre_sost --but04
         , a.sorgente_lato_esterno as sorgente_lato_esterno_padre_sost --rom11
         , a.fluido_lato_utenze    as fluido_lato_utenze_padre_sost    --rom11
	 , f.cod_impianto_est as cod_impianto_fr_est_padre_sost
         , coalesce(a.cod_tpco,'&nbsp;') as cod_tpco_padre_sost

          from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimfuge fu on fu.cod_fuge       = a.mod_funz --rom28
	   left outer join coimflre fl on fl.cod_flre       = a.cod_flre --rom28
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
     and f.flag_tipo_impianto = 'F'
--     and a.flag_sostituito    = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp">
       <querytext>
    select case a.flag_status
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_status
         , coalesce(a.n_prot,'&nbsp;') as n_prot
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
         , coalesce(iter_edit_data(a.data_prot),'&nbsp;') as data_prot
         , coalesce(a.riferimento_pag,'&nbsp;') as num_bollo
--         , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
	 , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
         , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
         , stagione_risc             
         , stagione_risc2               
	 , iter_edit_num(a.acquisti, 2)            as acquisti             --gac02
	 , iter_edit_num(a.acquisti2, 2)           as acquisti2            --gac02
	 , iter_edit_num(a.scorta_o_lett_iniz, 2)  as scorta_o_lett_iniz   --gac02
	 , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2  --gac02
	 , iter_edit_num(a.scorta_o_lett_fin, 2)   as scorta_o_lett_fin    --gac02
	 , iter_edit_num(a.scorta_o_lett_fin2, 2)  as scorta_o_lett_fin2   --gac02
         , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
         , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
         , iter_edit_num(a.temp_fumi, 2) as temp_fumi
         , iter_edit_num(a.temp_ambi, 2) as temp_ambi
         , iter_edit_num(a.o2, 2) as o2
         , iter_edit_num(a.co2, 2) as co2
         , iter_edit_num(a.bacharach, 0) as bacharach
         , a.co
         , iter_edit_num(a.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
         , iter_edit_num(a.rend_combust, 2) as rend_combust
	 , iter_edit_num(a.fr_surrisc, 2)        as fr_surrisc
         , iter_edit_num(a.fr_sottoraff, 2)      as fr_sottoraff
	 , iter_edit_num(a.fr_tcondens, 2)       as fr_tcondens
	 , iter_edit_num(a.fr_tevapor, 2)        as fr_tevapor
	 , iter_edit_num(a.fr_t_ing_lato_est, 2) as fr_t_ing_lato_est
	 , iter_edit_num(a.fr_t_usc_lato_est, 2) as fr_t_usc_lato_est
	 , iter_edit_num(a.fr_t_ing_lato_ute, 2) as fr_t_ing_lato_ute
	 , iter_edit_num(a.fr_t_usc_lato_ute, 2) as fr_t_usc_lato_ute
	 , a.fr_nr_circuito
	 , iter_edit_num(a.rct_rend_min_legge, 2) as rct_rend_min_legge  --gac03
	 , a.rct_modulo_termico          --gac03
	 , iter_edit_num(a.bacharach2, 0) as bacharach2                  --gac03
	 , iter_edit_num(a.bacharach3, 0) as bacharach3                  --gac03
	 , iter_edit_num(a.portata_comb, 2) as portata_comb              --gac03
         , case when a.rispetta_indice_bacharach = 'S' then 'SI'        --gac03
                when a.rispetta_indice_bacharach = 'N' then 'NO'        --gac03
                end as rispetta_indice_bacharach                        --gac03
         , case when a.co_fumi_secchi = 'S' then 'SI'                   --gac03
                when a.co_fumi_secchi = 'N' then 'NO'                   --gac03
                end as co_fumi_secchi                                   --gac03
         , case when a.rend_magg_o_ugua_rend_min = 'S' then 'SI'        --gac03
                when a.rend_magg_o_ugua_rend_min = 'N' then 'NO'        --gac03
                end as rend_magg_o_ugua_rend_min                        --gac03
         , coalesce(a.raccomandazioni,'') as raccomandazioni 
         , coalesce(a.prescrizioni,'')    as prescrizioni
         , a.cod_manutentore as cod_manutentore_dimp
         , a.flag_tracciato
         , a.gen_prog as gen_prog_dimp
         , a.cod_impianto as cod_impianto_dimp
         , iter_edit_num(a.cog_sovrafreq_soglia1,0) as cog_sovrafreq_soglia1 
         , iter_edit_num(a.cog_sovrafreq_tempo1 ,0) as cog_sovrafreq_tempo1  
         , iter_edit_num(a.cog_sottofreq_soglia1,0) as cog_sottofreq_soglia1 
         , iter_edit_num(a.cog_sottofreq_tempo1 ,0) as cog_sottofreq_tempo1  
         , iter_edit_num(a.cog_sovraten_soglia1 ,0) as cog_sovraten_soglia1  
         , iter_edit_num(a.cog_sovraten_tempo1  ,0) as cog_sovraten_tempo1   
         , iter_edit_num(a.cog_sottoten_soglia1 ,0) as cog_sottoten_soglia1  
         , iter_edit_num(a.cog_sottoten_tempo1  ,0) as cog_sottoten_tempo1   
         , iter_edit_num(a.cog_sovrafreq_soglia2,0) as cog_sovrafreq_soglia2 
         , iter_edit_num(a.cog_sovrafreq_tempo2 ,0) as cog_sovrafreq_tempo2  
         , iter_edit_num(a.cog_sottofreq_soglia2,0) as cog_sottofreq_soglia2 
         , iter_edit_num(a.cog_sottofreq_tempo2 ,0) as cog_sottofreq_tempo2  
         , iter_edit_num(a.cog_sovraten_soglia2 ,0) as cog_sovraten_soglia2  
         , iter_edit_num(a.cog_sovraten_tempo2  ,0) as cog_sovraten_tempo2   
         , iter_edit_num(a.cog_sottoten_soglia2 ,0) as cog_sottoten_soglia2  
         , iter_edit_num(a.cog_sottoten_tempo2  ,0) as cog_sottoten_tempo2   
         , iter_edit_num(a.cog_sovrafreq_soglia3,0) as cog_sovrafreq_soglia3 
         , iter_edit_num(a.cog_sovrafreq_tempo3 ,0) as cog_sovrafreq_tempo3  
         , iter_edit_num(a.cog_sottofreq_soglia3,0) as cog_sottofreq_soglia3 
         , iter_edit_num(a.cog_sottofreq_tempo3 ,0) as cog_sottofreq_tempo3  
         , iter_edit_num(a.cog_sovraten_soglia3 ,0) as cog_sovraten_soglia3  
         , iter_edit_num(a.cog_sovraten_tempo3  ,0) as cog_sovraten_tempo3   
         , iter_edit_num(a.cog_sottoten_soglia3 ,0) as cog_sottoten_soglia3  
         , iter_edit_num(a.cog_sottoten_tempo3  ,0) as cog_sottoten_tempo3  
	 , a.elet_esercizio_1         --gac04
         , a.elet_esercizio_2         --gac04
         , a.elet_esercizio_3         --gac04
         , a.elet_esercizio_4         --gac04
         , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac04
         , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac04
         , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac04
         , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac04
         , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac04
         , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac04
	 , a.cod_combustibile as cod_comb_dimp--rom26
 
      from coimdimp a
         , coimaimp b --rom30
     where a.cod_impianto = :cod_impianto
       and a.cod_impianto = b.cod_impianto --rom30
       and b.stato        not in ('E','F') --rom30
     $where_flag_tracciato --sim01
    order by a.data_controllo desc
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_padre">
       <querytext>
select * from (
      select case a.flag_status
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_status
         , coalesce(a.n_prot,'&nbsp;') as n_prot
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
	 , a.data_controllo as data_controllo_data
         , coalesce(iter_edit_data(a.data_prot),'&nbsp;') as data_prot
         , coalesce(a.riferimento_pag,'&nbsp;') as num_bollo
         , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
         , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
         , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
         , stagione_risc             
         , stagione_risc2               
	 , iter_edit_num(a.acquisti, 2)            as acquisti             --gac02
         , iter_edit_num(a.acquisti2, 2)           as acquisti2            --gac02
         , iter_edit_num(a.scorta_o_lett_iniz, 2)  as scorta_o_lett_iniz   --gac02
         , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2  --gac02
         , iter_edit_num(a.scorta_o_lett_fin, 2)   as scorta_o_lett_fin    --gac02
         , iter_edit_num(a.scorta_o_lett_fin2, 2)  as scorta_o_lett_fin2   --gac02
         , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
         , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
         , iter_edit_num(a.temp_fumi, 2) as temp_fumi
         , iter_edit_num(a.temp_ambi, 2) as temp_ambi
         , iter_edit_num(a.o2, 2) as o2
         , iter_edit_num(a.co2, 2) as co2
         , iter_edit_num(a.bacharach, 0) as bacharach
         , iter_edit_num(a.co, 2) as co --rom22
         , iter_edit_num(a.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
         , iter_edit_num(a.rend_combust, 2) as rend_combust 
         , iter_edit_num(a.fr_surrisc, 2)        as fr_surrisc
         , iter_edit_num(a.fr_sottoraff, 2)      as fr_sottoraff
	 , iter_edit_num(a.fr_tcondens, 2)       as fr_tcondens
	 , iter_edit_num(a.fr_tevapor, 2)        as fr_tevapor
	 , iter_edit_num(a.fr_t_ing_lato_est, 2) as fr_t_ing_lato_est
	 , iter_edit_num(a.fr_t_usc_lato_est, 2) as fr_t_usc_lato_est
	 , iter_edit_num(a.fr_t_ing_lato_ute, 2) as fr_t_ing_lato_ute
	 , iter_edit_num(a.fr_t_usc_lato_ute, 2) as fr_t_usc_lato_ute
	 , a.fr_nr_circuito
	 , a.flag_status as fr_flag_status_padre            -- rom29
         , 1 as progressivo_prova_fumi
         , a.tel_temp_est       as tel_temp_est             --rom02
         , a.tel_temp_mand_prim as tel_temp_mand_prim       --rom02
         , a.tel_temp_rit_prim  as tel_temp_rit_prim        --rom02
         , a.tel_temp_mand_sec  as tel_temp_mand_sec        --rom02
         , a.tel_temp_rit_sec   as tel_temp_rit_sec         --rom02
         , a.tel_potenza_compatibile_dati_prog              --rom02
    , case a.tel_potenza_compatibile_dati_prog
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_potenza_compatibile_dati_prog         --rom02
    , case a.tel_stato_coibent_idoneo_scamb
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_stato_coibent_idoneo_scamb            --rom02
    , case a.tel_disp_regolaz_controll_funzionanti
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_disp_regolaz_controll_funzionanti     --rom02
         , iter_edit_num(a.rct_rend_min_legge, 2) as rct_rend_min_legge  --gac03
         , a.rct_modulo_termico          --gac03
         , iter_edit_num(a.bacharach2, 0) as bacharach2                  --gac03
         , iter_edit_num(a.bacharach3, 0) as bacharach3                  --gac03
         , iter_edit_num(a.portata_comb, 2) as portata_comb              --gac03
         , case when a.rispetta_indice_bacharach = 'S' then 'SI'        --gac03
                when a.rispetta_indice_bacharach = 'N' then 'NO'        --gac03
                end as rispetta_indice_bacharach                        --gac03
         , case when a.co_fumi_secchi = 'S' then 'SI'                   --gac03
                when a.co_fumi_secchi = 'N' then 'NO'                   --gac03
                end as co_fumi_secchi                                   --gac03
         , case when a.rend_magg_o_ugua_rend_min = 'S' then 'SI'        --gac03
                when a.rend_magg_o_ugua_rend_min = 'N' then 'NO'        --gac03
                end as rend_magg_o_ugua_rend_min                        --gac03
         , a.cod_dimp                                                   --gac03
         , coalesce(iter_edit_num(a.portata_termica_effettiva,2), '/') as port_ter_eff
         , a.gen_prog
         , a.fr_assenza_perdita_ref
         , case when fr_prova_modalita = 'F' then 'Raff'
                when fr_prova_modalita = 'C' then 'Risc'
           end as fr_prova_modalita
         , iter_edit_num(cog_temp_aria_comburente,2)   as cog_temp_aria_comburente
         , iter_edit_num(cog_temp_h2o_uscita,2)        as cog_temp_h2o_uscita 
         , iter_edit_num(cog_temp_h2o_ingresso,2)      as cog_temp_h2o_ingresso
         , iter_edit_num(cog_temp_h2o_motore,2)        as cog_temp_h2o_motore
         , iter_edit_num(cog_temp_fumi_valle,2)        as cog_temp_fumi_valle
         , iter_edit_num(cog_temp_fumi_monte,2)        as cog_temp_fumi_monte
         , iter_edit_num(cog_potenza_morsetti_gen,2)   as cog_potenza_morsetti_gen
         , iter_edit_num(cog_emissioni_monossido_co,2) as cog_emissioni_monossido_co
         , coalesce(a.raccomandazioni,'') as raccomandazioni
         , coalesce(a.prescrizioni,'')    as prescrizioni
         , a.cod_manutentore as cod_manutentore_dimp
         , a.flag_tracciato
         , a.gen_prog as gen_prog_dimp
         , a.cod_impianto as cod_impianto_dimp
         , iter_edit_num(a.cog_sovrafreq_soglia1,0) as cog_sovrafreq_soglia1 
         , iter_edit_num(a.cog_sovrafreq_tempo1 ,0) as cog_sovrafreq_tempo1  
         , iter_edit_num(a.cog_sottofreq_soglia1,0) as cog_sottofreq_soglia1 
         , iter_edit_num(a.cog_sottofreq_tempo1 ,0) as cog_sottofreq_tempo1  
         , iter_edit_num(a.cog_sovraten_soglia1 ,0) as cog_sovraten_soglia1  
         , iter_edit_num(a.cog_sovraten_tempo1  ,0) as cog_sovraten_tempo1   
         , iter_edit_num(a.cog_sottoten_soglia1 ,0) as cog_sottoten_soglia1  
         , iter_edit_num(a.cog_sottoten_tempo1  ,0) as cog_sottoten_tempo1   
         , iter_edit_num(a.cog_sovrafreq_soglia2,0) as cog_sovrafreq_soglia2 
         , iter_edit_num(a.cog_sovrafreq_tempo2 ,0) as cog_sovrafreq_tempo2  
         , iter_edit_num(a.cog_sottofreq_soglia2,0) as cog_sottofreq_soglia2 
         , iter_edit_num(a.cog_sottofreq_tempo2 ,0) as cog_sottofreq_tempo2  
         , iter_edit_num(a.cog_sovraten_soglia2 ,0) as cog_sovraten_soglia2  
         , iter_edit_num(a.cog_sovraten_tempo2  ,0) as cog_sovraten_tempo2   
         , iter_edit_num(a.cog_sottoten_soglia2 ,0) as cog_sottoten_soglia2  
         , iter_edit_num(a.cog_sottoten_tempo2  ,0) as cog_sottoten_tempo2   
         , iter_edit_num(a.cog_sovrafreq_soglia3,0) as cog_sovrafreq_soglia3 
         , iter_edit_num(a.cog_sovrafreq_tempo3 ,0) as cog_sovrafreq_tempo3  
         , iter_edit_num(a.cog_sottofreq_soglia3,0) as cog_sottofreq_soglia3 
         , iter_edit_num(a.cog_sottofreq_tempo3 ,0) as cog_sottofreq_tempo3  
         , iter_edit_num(a.cog_sovraten_soglia3 ,0) as cog_sovraten_soglia3  
         , iter_edit_num(a.cog_sovraten_tempo3  ,0) as cog_sovraten_tempo3   
         , iter_edit_num(a.cog_sottoten_soglia3 ,0) as cog_sottoten_soglia3  
         , iter_edit_num(a.cog_sottoten_tempo3  ,0) as cog_sottoten_tempo3  
         , a.elet_esercizio_1         --gac04
         , a.elet_esercizio_2         --gac04
         , a.elet_esercizio_3         --gac04
         , a.elet_esercizio_4         --gac04
         , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac04
         , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac04
         , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac04
         , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac04
         , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac04
         , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac04
	 , a.cod_combustibile as cod_comb_dimp --rom26

      from coimdimp a
 -- rom29     inner join coimaimp b
 -- rom29     on a.cod_impianto = b.cod_impianto_princ
 -- rom29     and a.cod_impianto != b.cod_impianto
       left join coimaimp b on b.cod_impianto = a.cod_impianto   -- rom29
      where b.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
        and b.cod_impianto != :cod_impianto                      -- rom29
      and b.stato='A'
     $where_flag_tracciato --sim01
     union all
           select case a.flag_status
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_status
         , coalesce(a.n_prot,'&nbsp;') as n_prot
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
	 , a.data_controllo as data_controllo_data
         , coalesce(iter_edit_data(a.data_prot),'&nbsp;') as data_prot
         , coalesce(a.riferimento_pag,'&nbsp;') as num_bollo
         , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
         , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
         , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
         , stagione_risc             
         , stagione_risc2               
	 , iter_edit_num(a.acquisti, 2)            as acquisti             --gac02
         , iter_edit_num(a.acquisti2, 2)           as acquisti2            --gac02
         , iter_edit_num(a.scorta_o_lett_iniz, 2)  as scorta_o_lett_iniz   --gac02
         , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2  --gac02
         , iter_edit_num(a.scorta_o_lett_fin, 2)   as scorta_o_lett_fin    --gac02
         , iter_edit_num(a.scorta_o_lett_fin2, 2)  as scorta_o_lett_fin2   --gac02
         , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
         , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
         , iter_edit_num(f.temp_fumi, 2) as temp_fumi
         , iter_edit_num(f.temp_ambi, 2) as temp_ambi
         , iter_edit_num(f.o2, 2) as o2
         , iter_edit_num(f.co2, 2) as co2
         , iter_edit_num(f.bacharach, 0) as bacharach
         , iter_edit_num(f.co, 2) as co --rom22
         , iter_edit_num(f.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
         , iter_edit_num(f.rend_combust, 2) as rend_combust 
         , iter_edit_num(f.fr_surrisc, 2)        as fr_surrisc
         , iter_edit_num(f.fr_sottoraff, 2)      as fr_sottoraff
	 , iter_edit_num(f.fr_tcondens, 2)       as fr_tcondens
	 , iter_edit_num(f.fr_tevapor, 2)        as fr_tevapor
	 , iter_edit_num(f.fr_t_ing_lato_est, 2) as fr_t_ing_lato_est
	 , iter_edit_num(f.fr_t_usc_lato_est, 2) as fr_t_usc_lato_est
	 , iter_edit_num(f.fr_t_ing_lato_ute, 2) as fr_t_ing_lato_ute
	 , iter_edit_num(f.fr_t_usc_lato_ute, 2) as fr_t_usc_lato_ute
	 , f.fr_nr_circuito
         , a.flag_status as fr_flag_status_padre            -- rom29
         , f.progressivo_prova_fumi
         , a.tel_temp_est       as tel_temp_est             --rom02
         , a.tel_temp_mand_prim as tel_temp_mand_prim       --rom02
         , a.tel_temp_rit_prim  as tel_temp_rit_prim        --rom02
         , a.tel_temp_mand_sec  as tel_temp_mand_sec        --rom02
         , a.tel_temp_rit_sec   as tel_temp_rit_sec         --rom02
         , a.tel_potenza_compatibile_dati_prog              --rom02
    , case a.tel_potenza_compatibile_dati_prog              
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_potenza_compatibile_dati_prog         --rom02
    , case a.tel_stato_coibent_idoneo_scamb
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_stato_coibent_idoneo_scamb            --rom02
    , case a.tel_disp_regolaz_controll_funzionanti 
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_disp_regolaz_controll_funzionanti     --rom02 
         , iter_edit_num(f.rct_rend_min_legge,2) as rct_rend_min_legge --gac03
         , f.rct_modulo_termico          --gac03
         , iter_edit_num(f.bacharach2,0) as bacharach2                 --gac03
         , iter_edit_num(f.bacharach3,0) as bacharach3                 --gac03
         , iter_edit_num(f.portata_comb,2) as portata_comb             --gac03
         , case when a.rispetta_indice_bacharach = 'S' then 'SI'        --gac03
                when a.rispetta_indice_bacharach = 'N' then 'NO'        --gac03
                end as rispetta_indice_bacharach                        --gac03
         , case when a.co_fumi_secchi = 'S' then 'SI'                   --gac03
                when a.co_fumi_secchi = 'N' then 'NO'                   --gac03
                end as co_fumi_secchi                                   --gac03
         , case when a.rend_magg_o_ugua_rend_min = 'S' then 'SI'        --gac03
                when a.rend_magg_o_ugua_rend_min = 'N' then 'NO'        --gac03
                end as rend_magg_o_ugua_rend_min                        --gac03
         , a.cod_dimp                                                     --gac03
         , coalesce(iter_edit_num(a.portata_termica_effettiva,2), '/') as port_ter_eff
         , a.gen_prog
         , a.fr_assenza_perdita_ref
         , case when fr_prova_modalita = 'F' then 'Raff'
                when fr_prova_modalita = 'C' then 'Risc'
           end as fr_prova_modalita
         , iter_edit_num(cog_temp_aria_comburente,2)   as cog_temp_aria_comburente
         , iter_edit_num(cog_temp_h2o_uscita,2)        as cog_temp_h2o_uscita 
         , iter_edit_num(cog_temp_h2o_ingresso,2)      as cog_temp_h2o_ingresso
         , iter_edit_num(cog_temp_h2o_motore,2)        as cog_temp_h2o_motore
         , iter_edit_num(cog_temp_fumi_valle,2)        as cog_temp_fumi_valle
         , iter_edit_num(cog_temp_fumi_monte,2)        as cog_temp_fumi_monte
         , iter_edit_num(cog_potenza_morsetti_gen,2)   as cog_potenza_morsetti_gen
         , iter_edit_num(cog_emissioni_monossido_co,2) as cog_emissioni_monossido_co
         , coalesce(a.raccomandazioni,'') as raccomandazioni
         , coalesce(a.prescrizioni,'')    as prescrizioni
         , a.cod_manutentore as cod_manutentore_dimp
         , a.flag_tracciato
         , a.gen_prog as gen_prog_dimp
         , a.cod_impianto as cod_impianto_dimp
         , iter_edit_num(a.cog_sovrafreq_soglia1,0) as cog_sovrafreq_soglia1 
         , iter_edit_num(a.cog_sovrafreq_tempo1 ,0) as cog_sovrafreq_tempo1  
         , iter_edit_num(a.cog_sottofreq_soglia1,0) as cog_sottofreq_soglia1 
         , iter_edit_num(a.cog_sottofreq_tempo1 ,0) as cog_sottofreq_tempo1  
         , iter_edit_num(a.cog_sovraten_soglia1 ,0) as cog_sovraten_soglia1  
         , iter_edit_num(a.cog_sovraten_tempo1  ,0) as cog_sovraten_tempo1   
         , iter_edit_num(a.cog_sottoten_soglia1 ,0) as cog_sottoten_soglia1  
         , iter_edit_num(a.cog_sottoten_tempo1  ,0) as cog_sottoten_tempo1   
         , iter_edit_num(a.cog_sovrafreq_soglia2,0) as cog_sovrafreq_soglia2 
         , iter_edit_num(a.cog_sovrafreq_tempo2 ,0) as cog_sovrafreq_tempo2  
         , iter_edit_num(a.cog_sottofreq_soglia2,0) as cog_sottofreq_soglia2 
         , iter_edit_num(a.cog_sottofreq_tempo2 ,0) as cog_sottofreq_tempo2  
         , iter_edit_num(a.cog_sovraten_soglia2 ,0) as cog_sovraten_soglia2  
         , iter_edit_num(a.cog_sovraten_tempo2  ,0) as cog_sovraten_tempo2   
         , iter_edit_num(a.cog_sottoten_soglia2 ,0) as cog_sottoten_soglia2  
         , iter_edit_num(a.cog_sottoten_tempo2  ,0) as cog_sottoten_tempo2   
         , iter_edit_num(a.cog_sovrafreq_soglia3,0) as cog_sovrafreq_soglia3 
         , iter_edit_num(a.cog_sovrafreq_tempo3 ,0) as cog_sovrafreq_tempo3  
         , iter_edit_num(a.cog_sottofreq_soglia3,0) as cog_sottofreq_soglia3 
         , iter_edit_num(a.cog_sottofreq_tempo3 ,0) as cog_sottofreq_tempo3  
         , iter_edit_num(a.cog_sovraten_soglia3 ,0) as cog_sovraten_soglia3  
         , iter_edit_num(a.cog_sovraten_tempo3  ,0) as cog_sovraten_tempo3   
         , iter_edit_num(a.cog_sottoten_soglia3 ,0) as cog_sottoten_soglia3  
         , iter_edit_num(a.cog_sottoten_tempo3  ,0) as cog_sottoten_tempo3  
         , a.elet_esercizio_1         --gac04
         , a.elet_esercizio_2         --gac04
         , a.elet_esercizio_3         --gac04
         , a.elet_esercizio_4         --gac04
         , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac04
         , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac04
         , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac04
         , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac04
         , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac04
         , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac04
	 , a.cod_combustibile as cod_comb_dimp --rom26
      from coimdimp a
      inner join coimdimp_prfumi f
         on f.cod_dimp = a.cod_dimp   
 -- rom29     inner join coimaimp b
 -- rom29     on a.cod_impianto = b.cod_impianto_princ
 -- rom29     and a.cod_impianto != b.cod_impianto
       left join coimaimp b on b.cod_impianto = a.cod_impianto   -- rom29
      where a.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
        and a.cod_impianto != :cod_impianto                      -- rom29
      and b.stato='A'
     $where_flag_tracciato --sim01
) as q
      where gen_prog = $where_gen_prog_padre
        and cod_impianto_dimp = :where_cod_impianto_padre    --rom16
      order by data_controllo_data desc, progressivo_prova_fumi
       </querytext>
    </fullquery>

    <fullquery name="sel_dimp_padre_targa"><!-- sim04 -->
       <querytext>
       select * from (
      select case a.flag_status
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_status
         , coalesce(a.n_prot,'&nbsp;') as n_prot
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
	 , a.data_controllo as data_controllo_data
         , coalesce(iter_edit_data(a.data_prot),'&nbsp;') as data_prot
         , coalesce(a.riferimento_pag,'&nbsp;') as num_bollo
         , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
         , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
         , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
         , stagione_risc             
         , stagione_risc2      
         , iter_edit_num(a.acquisti, 2)            as acquisti             --gac02
         , iter_edit_num(a.acquisti2, 2)           as acquisti2            --gac02
         , iter_edit_num(a.scorta_o_lett_iniz, 2)  as scorta_o_lett_iniz   --gac02
         , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2  --gac02
         , iter_edit_num(a.scorta_o_lett_fin, 2)   as scorta_o_lett_fin    --gac02
         , iter_edit_num(a.scorta_o_lett_fin2, 2)  as scorta_o_lett_fin2   --gac02
         , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
         , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
         , iter_edit_num(a.temp_fumi, 2) as temp_fumi
         , iter_edit_num(a.temp_ambi, 2) as temp_ambi
         , iter_edit_num(a.o2, 2) as o2
         , iter_edit_num(a.co2, 2) as co2
         , iter_edit_num(a.bacharach, 0) as bacharach
         , iter_edit_num(a.co, 2) as co  --rom22
         , iter_edit_num(a.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
         , iter_edit_num(a.rend_combust, 2) as rend_combust 
         , iter_edit_num(a.fr_surrisc, 2)        as fr_surrisc
         , iter_edit_num(a.fr_sottoraff, 2)      as fr_sottoraff
	 , iter_edit_num(a.fr_tcondens, 2)       as fr_tcondens
	 , iter_edit_num(a.fr_tevapor, 2)        as fr_tevapor
	 , iter_edit_num(a.fr_t_ing_lato_est, 2) as fr_t_ing_lato_est
	 , iter_edit_num(a.fr_t_usc_lato_est, 2) as fr_t_usc_lato_est
	 , iter_edit_num(a.fr_t_ing_lato_ute, 2) as fr_t_ing_lato_ute
	 , iter_edit_num(a.fr_t_usc_lato_ute, 2) as fr_t_usc_lato_ute
	 , a.fr_nr_circuito
         , a.flag_status as fr_flag_status_padre            -- rom29
         , 1 as progressivo_prova_fumi
         , a.tel_temp_est       as tel_temp_est             --rom02
         , a.tel_temp_mand_prim as tel_temp_mand_prim       --rom02
         , a.tel_temp_rit_prim  as tel_temp_rit_prim        --rom02
         , a.tel_temp_mand_sec  as tel_temp_mand_sec        --rom02
         , a.tel_temp_rit_sec   as tel_temp_rit_sec         --rom02
         , a.tel_potenza_compatibile_dati_prog              --rom02
    , case a.tel_potenza_compatibile_dati_prog          
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_potenza_compatibile_dati_prog         --rom02
    , case a.tel_stato_coibent_idoneo_scamb
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_stato_coibent_idoneo_scamb            --rom02
    , case a.tel_disp_regolaz_controll_funzionanti
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_disp_regolaz_controll_funzionanti     --rom02
         , iter_edit_num(a.rct_rend_min_legge,2) as rct_rend_min_legge  --gac03
         , a.rct_modulo_termico          --gac03
         , iter_edit_num(a.bacharach2,0) as bacharach2                  --gac03
         , iter_edit_num(a.bacharach3,0) as bacharach3                  --gac03
         , iter_edit_num(a.portata_comb,2) as portata_comb              --gac03
         , case when a.rispetta_indice_bacharach = 'S' then 'SI'        --gac03
                when a.rispetta_indice_bacharach = 'N' then 'NO'        --gac03
                end as rispetta_indice_bacharach                        --gac03
         , case when a.co_fumi_secchi = 'S' then 'SI'                   --gac03
                when a.co_fumi_secchi = 'N' then 'NO'                   --gac03
                end as co_fumi_secchi                                   --gac03
         , case when a.rend_magg_o_ugua_rend_min = 'S' then 'SI'        --gac03
                when a.rend_magg_o_ugua_rend_min = 'N' then 'NO'        --gac03
                end as rend_magg_o_ugua_rend_min                        --gac03
         , a.cod_dimp                                                     --gac03
         , coalesce(iter_edit_num(a.portata_termica_effettiva,2), '/') as port_ter_eff
         , a.gen_prog
         , a.fr_assenza_perdita_ref
         , case when fr_prova_modalita = 'F' then 'Raff'
                when fr_prova_modalita = 'C' then 'Risc'
           end as fr_prova_modalita
         , iter_edit_num(cog_temp_aria_comburente,2)   as cog_temp_aria_comburente
         , iter_edit_num(cog_temp_h2o_uscita,2)        as cog_temp_h2o_uscita 
         , iter_edit_num(cog_temp_h2o_ingresso,2)      as cog_temp_h2o_ingresso
         , iter_edit_num(cog_temp_h2o_motore,2)        as cog_temp_h2o_motore
         , iter_edit_num(cog_temp_fumi_valle,2)        as cog_temp_fumi_valle
         , iter_edit_num(cog_temp_fumi_monte,2)        as cog_temp_fumi_monte
         , iter_edit_num(cog_potenza_morsetti_gen,2)   as cog_potenza_morsetti_gen
         , iter_edit_num(cog_emissioni_monossido_co,2) as cog_emissioni_monossido_co
         , coalesce(a.raccomandazioni,'') as raccomandazioni
         , coalesce(a.prescrizioni,'')    as prescrizioni
         , a.cod_manutentore as cod_manutentore_dimp
         , a.flag_tracciato
         , a.gen_prog as gen_prog_dimp
         , a.cod_impianto as cod_impianto_dimp
         , iter_edit_num(a.cog_sovrafreq_soglia1,0) as cog_sovrafreq_soglia1 
         , iter_edit_num(a.cog_sovrafreq_tempo1 ,0) as cog_sovrafreq_tempo1  
         , iter_edit_num(a.cog_sottofreq_soglia1,0) as cog_sottofreq_soglia1 
         , iter_edit_num(a.cog_sottofreq_tempo1 ,0) as cog_sottofreq_tempo1  
         , iter_edit_num(a.cog_sovraten_soglia1 ,0) as cog_sovraten_soglia1  
         , iter_edit_num(a.cog_sovraten_tempo1  ,0) as cog_sovraten_tempo1   
         , iter_edit_num(a.cog_sottoten_soglia1 ,0) as cog_sottoten_soglia1  
         , iter_edit_num(a.cog_sottoten_tempo1  ,0) as cog_sottoten_tempo1   
         , iter_edit_num(a.cog_sovrafreq_soglia2,0) as cog_sovrafreq_soglia2 
         , iter_edit_num(a.cog_sovrafreq_tempo2 ,0) as cog_sovrafreq_tempo2  
         , iter_edit_num(a.cog_sottofreq_soglia2,0) as cog_sottofreq_soglia2 
         , iter_edit_num(a.cog_sottofreq_tempo2 ,0) as cog_sottofreq_tempo2  
         , iter_edit_num(a.cog_sovraten_soglia2 ,0) as cog_sovraten_soglia2  
         , iter_edit_num(a.cog_sovraten_tempo2  ,0) as cog_sovraten_tempo2   
         , iter_edit_num(a.cog_sottoten_soglia2 ,0) as cog_sottoten_soglia2  
         , iter_edit_num(a.cog_sottoten_tempo2  ,0) as cog_sottoten_tempo2   
         , iter_edit_num(a.cog_sovrafreq_soglia3,0) as cog_sovrafreq_soglia3 
         , iter_edit_num(a.cog_sovrafreq_tempo3 ,0) as cog_sovrafreq_tempo3  
         , iter_edit_num(a.cog_sottofreq_soglia3,0) as cog_sottofreq_soglia3 
         , iter_edit_num(a.cog_sottofreq_tempo3 ,0) as cog_sottofreq_tempo3  
         , iter_edit_num(a.cog_sovraten_soglia3 ,0) as cog_sovraten_soglia3  
         , iter_edit_num(a.cog_sovraten_tempo3  ,0) as cog_sovraten_tempo3   
         , iter_edit_num(a.cog_sottoten_soglia3 ,0) as cog_sottoten_soglia3  
         , iter_edit_num(a.cog_sottoten_tempo3  ,0) as cog_sottoten_tempo3  
         , a.elet_esercizio_1         --gac04
         , a.elet_esercizio_2         --gac04
         , a.elet_esercizio_3         --gac04
         , a.elet_esercizio_4         --gac04
         , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac04
         , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac04
         , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac04
         , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac04
         , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac04
         , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac04
	 , a.cod_combustibile as cod_comb_dimp --rom26
	 
      from coimdimp a
      inner join coimaimp b
        on a.cod_impianto = b.cod_impianto
      where b.cod_impianto != :cod_impianto
      and upper(b.targa) = upper(:targa)
      and b.stato='A'
     $where_flag_tracciato --sim01
     union all
           select case a.flag_status
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_status
         , coalesce(a.n_prot,'&nbsp;') as n_prot
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
	 , a.data_controllo as data_controllo_data
         , coalesce(iter_edit_data(a.data_prot),'&nbsp;') as data_prot
         , coalesce(a.riferimento_pag,'&nbsp;') as num_bollo
         , iter_edit_num(a.volimetria_risc, 2) as volimetria_risc
         , iter_edit_num(a.consumo_annuo, 2) as consumo_annuo
         , iter_edit_num(a.consumo_annuo2, 2) as consumo_annuo2                
         , stagione_risc             
         , stagione_risc2               
	 , iter_edit_num(a.acquisti, 2)            as acquisti             --gac02
         , iter_edit_num(a.acquisti2, 2)           as acquisti2            --gac02
         , iter_edit_num(a.scorta_o_lett_iniz, 2)  as scorta_o_lett_iniz   --gac02
         , iter_edit_num(a.scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2  --gac02
         , iter_edit_num(a.scorta_o_lett_fin, 2)   as scorta_o_lett_fin    --gac02
         , iter_edit_num(a.scorta_o_lett_fin2, 2)  as scorta_o_lett_fin2   --gac02
         , iter_edit_num(a.pot_focolare_mis, 2) as pot_focolare_mis
         , iter_edit_num(a.portata_comb_mis, 2) as portata_comb_mis
         , iter_edit_num(f.temp_fumi, 2) as temp_fumi
         , iter_edit_num(f.temp_ambi, 2) as temp_ambi
         , iter_edit_num(f.o2, 2) as o2
         , iter_edit_num(f.co2, 2) as co2
         , iter_edit_num(f.bacharach, 0) as bacharach
         , iter_edit_num(f.co, 2) as co --rom22
         , iter_edit_num(f.co_fumi_secchi_ppm, 2) as co_fumi_secchi_ppm
         , iter_edit_num(f.rend_combust, 2) as rend_combust 
         , iter_edit_num(f.fr_surrisc, 2)        as fr_surrisc
         , iter_edit_num(f.fr_sottoraff, 2)      as fr_sottoraff
	 , iter_edit_num(f.fr_tcondens, 2)       as fr_tcondens
	 , iter_edit_num(f.fr_tevapor, 2)        as fr_tevapor
	 , iter_edit_num(f.fr_t_ing_lato_est, 2) as fr_t_ing_lato_est
	 , iter_edit_num(f.fr_t_usc_lato_est, 2) as fr_t_usc_lato_est
	 , iter_edit_num(f.fr_t_ing_lato_ute, 2) as fr_t_ing_lato_ute
	 , iter_edit_num(f.fr_t_usc_lato_ute, 2) as fr_t_usc_lato_ute
	 , f.fr_nr_circuito
         , a.flag_status as fr_flag_status_padre            -- rom29
         , f.progressivo_prova_fumi
         , a.tel_temp_est       as tel_temp_est             --rom02
         , a.tel_temp_mand_prim as tel_temp_mand_prim       --rom02
         , a.tel_temp_rit_prim  as tel_temp_rit_prim        --rom02
         , a.tel_temp_mand_sec  as tel_temp_mand_sec        --rom02
         , a.tel_temp_rit_sec   as tel_temp_rit_sec         --rom02
         , a.tel_potenza_compatibile_dati_prog              --rom02
    , case a.tel_potenza_compatibile_dati_prog
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_potenza_compatibile_dati_prog         --rom02
    , case a.tel_stato_coibent_idoneo_scamb
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_stato_coibent_idoneo_scamb            --rom02
    , case a.tel_disp_regolaz_controll_funzionanti
           when 'S' then 'Sì'
           when 'N' then 'No'
           when 'C' then 'N.C.'
           else '&nbsp;'
           end as tel_disp_regolaz_controll_funzionanti     --rom02
         , iter_edit_num(f.rct_rend_min_legge,2) as rct_rend_min_legge  --gac03
         , f.rct_modulo_termico          --gac03
         , iter_edit_num(f.bacharach2,0) as bacharach2                  --gac03
         , iter_edit_num(f.bacharach3,0) as bacharach3                  --gac03
         , iter_edit_num(f.portata_comb,2) as portata_comb              --gac03
         , case when a.rispetta_indice_bacharach = 'S' then 'SI'        --gac03
                when a.rispetta_indice_bacharach = 'N' then 'NO'        --gac03
                end as rispetta_indice_bacharach                        --gac03
         , case when a.co_fumi_secchi = 'S' then 'SI'                   --gac03
                when a.co_fumi_secchi = 'N' then 'NO'                   --gac03
                end as co_fumi_secchi                                   --gac03
         , case when a.rend_magg_o_ugua_rend_min = 'S' then 'SI'        --gac03
                when a.rend_magg_o_ugua_rend_min = 'N' then 'NO'        --gac03
                end as rend_magg_o_ugua_rend_min                        --gac03
         , a.cod_dimp                                                   --gac03
         , coalesce(iter_edit_num(a.portata_termica_effettiva,2), '/') as port_ter_eff
         , a.gen_prog
         , a.fr_assenza_perdita_ref
         , case when fr_prova_modalita = 'F' then 'Raff'
                when fr_prova_modalita = 'C' then 'Risc'
           end as fr_prova_modalita
         , iter_edit_num(cog_temp_aria_comburente,2)   as cog_temp_aria_comburente
         , iter_edit_num(cog_temp_h2o_uscita,2)        as cog_temp_h2o_uscita 
         , iter_edit_num(cog_temp_h2o_ingresso,2)      as cog_temp_h2o_ingresso
         , iter_edit_num(cog_temp_h2o_motore,2)        as cog_temp_h2o_motore
         , iter_edit_num(cog_temp_fumi_valle,2)        as cog_temp_fumi_valle
         , iter_edit_num(cog_temp_fumi_monte,2)        as cog_temp_fumi_monte
         , iter_edit_num(cog_potenza_morsetti_gen,2)   as cog_potenza_morsetti_gen
         , iter_edit_num(cog_emissioni_monossido_co,2) as cog_emissioni_monossido_co
         , coalesce(a.raccomandazioni,'') as raccomandazioni
         , coalesce(a.prescrizioni,'')    as prescrizioni
         , a.cod_manutentore as cod_manutentore_dimp
         , a.flag_tracciato
         , a.gen_prog as gen_prog_dimp
         , a.cod_impianto as cod_impianto_dimp
         , iter_edit_num(a.cog_sovrafreq_soglia1,0) as cog_sovrafreq_soglia1 
         , iter_edit_num(a.cog_sovrafreq_tempo1 ,0) as cog_sovrafreq_tempo1  
         , iter_edit_num(a.cog_sottofreq_soglia1,0) as cog_sottofreq_soglia1 
         , iter_edit_num(a.cog_sottofreq_tempo1 ,0) as cog_sottofreq_tempo1  
         , iter_edit_num(a.cog_sovraten_soglia1 ,0) as cog_sovraten_soglia1  
         , iter_edit_num(a.cog_sovraten_tempo1  ,0) as cog_sovraten_tempo1   
         , iter_edit_num(a.cog_sottoten_soglia1 ,0) as cog_sottoten_soglia1  
         , iter_edit_num(a.cog_sottoten_tempo1  ,0) as cog_sottoten_tempo1   
         , iter_edit_num(a.cog_sovrafreq_soglia2,0) as cog_sovrafreq_soglia2 
         , iter_edit_num(a.cog_sovrafreq_tempo2 ,0) as cog_sovrafreq_tempo2  
         , iter_edit_num(a.cog_sottofreq_soglia2,0) as cog_sottofreq_soglia2 
         , iter_edit_num(a.cog_sottofreq_tempo2 ,0) as cog_sottofreq_tempo2  
         , iter_edit_num(a.cog_sovraten_soglia2 ,0) as cog_sovraten_soglia2  
         , iter_edit_num(a.cog_sovraten_tempo2  ,0) as cog_sovraten_tempo2   
         , iter_edit_num(a.cog_sottoten_soglia2 ,0) as cog_sottoten_soglia2  
         , iter_edit_num(a.cog_sottoten_tempo2  ,0) as cog_sottoten_tempo2   
         , iter_edit_num(a.cog_sovrafreq_soglia3,0) as cog_sovrafreq_soglia3 
         , iter_edit_num(a.cog_sovrafreq_tempo3 ,0) as cog_sovrafreq_tempo3  
         , iter_edit_num(a.cog_sottofreq_soglia3,0) as cog_sottofreq_soglia3 
         , iter_edit_num(a.cog_sottofreq_tempo3 ,0) as cog_sottofreq_tempo3  
         , iter_edit_num(a.cog_sovraten_soglia3 ,0) as cog_sovraten_soglia3  
         , iter_edit_num(a.cog_sovraten_tempo3  ,0) as cog_sovraten_tempo3   
         , iter_edit_num(a.cog_sottoten_soglia3 ,0) as cog_sottoten_soglia3  
         , iter_edit_num(a.cog_sottoten_tempo3  ,0) as cog_sottoten_tempo3  
         , a.elet_esercizio_1         --gac04
         , a.elet_esercizio_2         --gac04
         , a.elet_esercizio_3         --gac04
         , a.elet_esercizio_4         --gac04
         , iter_edit_num(a.elet_lettura_iniziale, 2)   as elet_lettura_iniziale    --gac04
         , iter_edit_num(a.elet_lettura_finale, 2)     as elet_lettura_finale      --gac04
         , iter_edit_num(a.elet_consumo_totale, 2)     as elet_consumo_totale      --gac04
         , iter_edit_num(a.elet_lettura_iniziale_2, 2) as elet_lettura_iniziale_2  --gac04
         , iter_edit_num(a.elet_lettura_finale_2, 2)   as elet_lettura_finale_2    --gac04
         , iter_edit_num(a.elet_consumo_totale_2, 2)   as elet_consumo_totale_2    --gac04
	 , a.cod_combustibile as cod_comb_dimp --rom26

       from coimdimp a
      inner join coimdimp_prfumi f
         on f.cod_dimp = a.cod_dimp   
      inner join coimaimp b
         on a.cod_impianto = b.cod_impianto
      where b.cod_impianto != :cod_impianto
      and upper(b.targa) = upper(:targa)
      and b.stato='A'
     $where_flag_tracciato --sim01
) as q
      where gen_prog = $where_gen_prog_padre
        and cod_impianto_dimp = :where_cod_impianto_padre --rom16
      order by data_controllo_data desc, progressivo_prova_fumi
       </querytext>
    </fullquery>


    <fullquery name="sel_dimp_acq">
       <querytext>
    select case a.rct_tratt_in_risc
           when 'R' then 'Non Richiesta'
           when 'A' then 'Assente'
           when 'F' then 'Filtrazione'
           when 'D' then 'Addolcimento'
           when 'C' then 'Cond.Chimico'
           else '&nbsp;'
           end as rct_tratt_in_risc
         , case a.rct_tratt_in_acs
           when 'R' then 'Non Richiesta'
           when 'A' then 'Assente'
           when 'F' then 'Filtrazione'
           when 'D' then 'Addolcimento'
           when 'C' then 'Cond.Chimico'
           else '&nbsp;'
           end as rct_tratt_in_acs
         , iter_edit_num(a.rct_dur_acqua, 2) as durezza
       from coimdimp a
     where a.cod_impianto = :cod_impianto and a.flag_tracciato = 'R1'
    order by a.data_controllo desc
       </querytext>
    </fullquery>

    <fullquery name="sel_cimp">
       <querytext>
    select cod_cimp
         , case when a.esito_verifica = 'P' then 'Positivo'
                when a.esito_verifica = 'N' then 'Negativo'
                else '&nbsp;'
           end as desc_esito
         , coalesce(a.numfatt,'&nbsp;') as numfatt
         , coalesce(iter_edit_data(a.data_fatt),'&nbsp;') as data_fatt
         , coalesce(a.verb_n,'&nbsp;') as verb_n
         , coalesce(iter_edit_data(a.data_controllo),'&nbsp;') as data_controllo
         , coalesce(iter_edit_data(a.data_verb),'&nbsp;') as data_verb
         , coalesce(iter_edit_num(a.costo, 2),'&nbsp;') as costo_verifica
         , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_opve
      from coimcimp a
           left outer join coimopve b on b.cod_opve = a.cod_opve
     where a.cod_impianto = :cod_impianto
    order by a.data_controllo desc
       </querytext>
    </fullquery>

    <fullquery name="sel_anom">
       <querytext>
    select a.cod_tanom
         , b.descr_tano
      from coimanom a     
         , coimtano b
     where a.cod_cimp_dimp = :cod_cimp
       and a.flag_origine  = 'RV'
       and b.cod_tano      = a.cod_tanom
  order by to_number(a.prog_anom, '9999999')
       </querytext>
    </fullquery>

    <fullquery name="sel_inco">
       <querytext>
    select case a.esito
           when 'P' then 'Positivo'
           when 'N' then 'Negativo'
           else '&nbsp;'
           end as desc_esito
         , d.descr_inst as desc_stato
         , coalesce(iter_edit_data(a.data_verifica),'&nbsp;') as data_verifica
         , coalesce(substr(a.ora_verifica,1,5),'&nbsp;') as ora_verifica
         , coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_opve
         , coalesce(c.descrizione,'&nbsp;') as desc_camp
      from coiminco a
      left outer join coimopve b on b.cod_opve = a.cod_opve
           inner join coimcinc c on c.cod_cinc = a.cod_cinc
           inner join coiminst d on d.cod_inst = a.stato
     where a.cod_impianto = :cod_impianto
   order by c.data_inizio desc
       , a.data_verifica desc
       </querytext>
    </fullquery>

    <fullquery name="sel_movi">
       <querytext>
    select b.descrizione as desc_movi
         , coalesce(iter_edit_data(a.data_scad),'&nbsp;') as data_scad
         , coalesce(iter_edit_num(a.importo, 2),'&nbsp;') as importo
         , coalesce(iter_edit_data(a.data_pag),'&nbsp;') as data_pag
         , coalesce(iter_edit_num(a.importo_pag, 2),'&nbsp;') as importo_pag
         , case a.tipo_pag
           when 'BO' then 'Bollino prepagato'
           when 'BP' then 'Bollettino postale'
           when 'CN' then 'Contante a sportello ente gestore'
           else '&nbsp;'
           end as desc_pag
         , a.flag_pagato
      from coimmovi a
           left outer join coimcaus b on a.id_caus = b.id_caus
     where a.cod_impianto = :cod_impianto
   order by a.data_scad desc
       </querytext>
    </fullquery>

    <fullquery name="sel_prvv">
       <querytext>
    select case a.causale
           when 'MC' then 'Mancato pagamento'
           when 'SN' then 'Sanzione per inadempienza sull''impianto'
           when 'GE' then 'Generico'
           else '&nbsp;'
           end as desc_causale
         , coalesce(iter_edit_data(a.data_provv),'&nbsp;') as data_provv
      from coimprvv a
     where a.cod_impianto = :cod_impianto
   order by a.data_provv desc
       </querytext>
    </fullquery>

    <fullquery name="sel_todo">
       <querytext>
    select b.descrizione as desc_tipologia
         , case a.flag_evasione
           when 'E' then 'Evaso'
           when 'N' then 'Non Evaso'
           when 'A' then 'Annullato'
           else '&nbsp;'
           end as desc_evasione
         , coalesce(iter_edit_data(a.data_evasione),'&nbsp;') as data_evasione
	 , note
      from coimtodo a
         , coimtpdo b
     where a.cod_impianto = :cod_impianto
       and b.cod_tpdo = a.tipologia
       and b.cod_tpdo='2' --visualizzo solo Controllo di verifica
   order by a.data_evasione desc
       </querytext>
    </fullquery>

   <fullquery name="sel_noveb">
       <querytext>
           select coalesce(b.cognome,'') || ' ' || coalesce(b.nome,'') as manutentore
         , coalesce(iter_edit_data(a.data_consegna),'&nbsp;') as data_consegna
         from coimnoveb a
         , coimmanu b
     where a.cod_impianto = :cod_impianto and a.cod_manutentore = b.cod_manutentore
          </querytext>
    </fullquery>

    <fullquery name="sel_as_resp">
       <querytext>
             select  a.cod_legale_rapp
                     , a.cod_manutentore
                     , iter_edit_data(a.data_inizio) as data_inizio
		     , a.data_inizio as db_data_inizio
                     , iter_edit_data(a.data_fine) as data_fine
                     , case a.causale_fine
                        when 'R' then 'Revoca dell''incarico'
                        when 'D' then 'Dimissioni'
                        else ''
                       end as causale_fine
                     , a.toponimo
                     , a.indirizzo
                     , a.cod_via as f_cod_via
                     , a.localita
                     , a.numero
                     , a.esponente
                     , a.scala
                     , a.piano
                     , a.interno
                     , a.cod_comune
                     , a.cod_responsabile
                     , a.flag_tracciato
                     , a.committente
                     , iter_edit_num(a.potenza, 2) as potenza
                     , case
                        when a.data_inizio is null then 'fine'
                        else 'inizio'
                       end as swc_inizio_fine
                     , a.nome_condominio
                     , c.cod_impianto_est
                     , d.cognome as cognome_legale
                     , d.nome as nome_legale
                     , d.indirizzo as ind_legale
                     , d.telefono as tel_legale
                     , d.cellulare as cell_legale
		     , d.cod_fiscale as cod_fis_legale --rom06
		     , d.cod_piva    as p_iva_legale   --rom06
                     , d.fax as fax_legale
                     , d.email as email_legale
                     , e.cognome as cognome_resp
                     , e.nome as nome_resp
		     , e.cod_fiscale as cod_ficsc_resp --rom10
		     , e.cod_piva    as cod_piva_resp  --rom10
                     , f.denominazione as descr_comune
                     , g.descr_utgi as cod_utgi
                     , h.ragione_01 as forn_energia
                     , m.cognome as cognome_manu
                     , m.nome as nome_manu
                     , m.reg_imprese
                     , m.localita_reg
                     , replace(m.flag_a, 't', 'X') as flag_a
                     , replace(m.flag_b, 't', 'X') as flag_b
                     , replace(m.flag_c, 't', 'X') as flag_c
                     , replace(m.flag_d, 't', 'X') as flag_d
                     , replace(m.flag_e, 't', 'X') as flag_e
                     , replace(m.flag_f, 't', 'X') as flag_f
                     , replace(m.flag_g, 't', 'X') as flag_g
                     , m.cert_uni_iso
                     , m.cert_altro
		     , a.flag_as_resp --rom07
		     , c.cod_impianto_est as cod_impianto_est_as_resp --rom21
		     , a.cod_impianto as cod_impianto_as_resp --rom22
               from coim_as_resp a
    left outer join coimmanu m on m.cod_manutentore = a.cod_manutentore
    left outer join coimcitt d on d.cod_cittadino = a.cod_legale_rapp
    left outer join coimcitt e on e.cod_cittadino = a.cod_responsabile
    left outer join coimaimp c on c.cod_impianto    = a.cod_impianto
    left outer join coimcomu f on f.cod_comune      = a.cod_comune
    left outer join coimutgi g on g.cod_utgi        = a.cod_utgi
    left outer join coimdist h on h.cod_distr		= c.cod_distributore
              where a.cod_impianto in ('[join $lista_cod_impianti ',']') --rom21
	      $where_data_inizio --rom07
       </querytext>
    </fullquery>
    
    <fullquery name="sel_gend_tel">
      <querytext>
	   select a.gen_prog_est as gen_prog_est_tel
                , a.gen_prog as gen_prog_tel
                , coalesce(a.matricola,'&nbsp;') as matricola_tel
                , coalesce(a.modello,'&nbsp;') as modello_tel
                , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel
                , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel
		, coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel
	        , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel
                , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel
                , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel
                , descr_emissione as scarico_fumi_tel
                , f.note_dest
                , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_tel
                , a.flag_attivo
		, f.cod_impianto_est as cod_impianto_gend_te --rom16
   	     from coimgend a
                  left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
                  left outer join coimcost c on c.cod_cost         = a.cod_cost
                  left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
                  left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
                  left outer join coimaimp f on f.cod_impianto     = a.cod_impianto --sim01 and f.flag_tipo_impianto = 'F'
            where a.cod_impianto = :cod_impianto
              and f.stato not in ('E','F') --rom30 E Respinto F da Validare
       -- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S' 
              and f.flag_tipo_impianto = 'T'
--	      and coalesce(a.flag_sostituito,'') != 'S'--rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
            order  by a.gen_prog_est
      </querytext>
    </fullquery>

    <fullquery name="sel_gend_tel_sost"><!--rom11-->
      <querytext>
	   select a.gen_prog_est as gen_prog_est_tel_sost
                , a.gen_prog as gen_prog_tel_sost
                , coalesce(a.matricola,'&nbsp;') as matricola_tel_sost
                , coalesce(a.modello,'&nbsp;') as modello_tel_sost
                , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel_sost
                , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel_sost
		, coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel_sost
	        , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel_sost
                , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel_sost
                , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel_sost
                , descr_emissione as scarico_fumi_tel_sost
                , f.note_dest as note_dest_tel_sost
                , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_tel_sost
                , a.flag_attivo as flag_attivo_tel_sost
		, f.cod_impianto_est as cod_impianto_est_tel_sost
             from coimgend a
                  left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
                  left outer join coimcost c on c.cod_cost         = a.cod_cost
                  left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
                  left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
                  left outer join coimaimp f on f.cod_impianto     = a.cod_impianto 
            where a.cod_impianto = :cod_impianto
              and f.stato not in ('E','F') --rom30 E Respinto F da Validare
              and f.flag_tipo_impianto = 'T'
--	      and coalesce(a.flag_sostituito) = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
            order  by a.gen_prog_est
      </querytext>
    </fullquery>

    <!-- Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_tel_padre"> <!-- rom01 -->
       <querytext>
    select a.gen_prog_est as gen_prog_est_tel_padre
         , a.gen_prog as gen_prog_tel_padre
         , coalesce(a.matricola,'&nbsp;') as matricola_tel_padre
         , coalesce(a.modello,'&nbsp;') as modello_tel_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel_padre
-- rom29, coalesce(iter_edit_num(m.tel_potenza_termica, 0),'&nbsp;') as pot_termica_tel_padre
         , f.note_dest as note_dest_fr_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_tel_padre
         , a.flag_attivo as flag_attivo_tel_padre
         , f.cod_impianto_est as cod_impianto_est_tel_padre
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto -- sim01 and f.flag_tipo_impianto = 'R'
 -- rom29 left outer join coimdimp m on m.cod_impianto     = a.cod_impianto
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
       and f.flag_tipo_impianto = 'T'
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <!-- Ricavo i generatori dell'impianto padre -->
     <fullquery name="sel_gend_tel_padre_sost"> <!-- rom11 -->
       <querytext>
    select a.gen_prog_est as gen_prog_est_tel_padre_sost
         , a.gen_prog as gen_prog_tel_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_tel_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_tel_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel_padre_sost 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel_padre_sost
 -- rom29, coalesce(iter_edit_num(m.tel_potenza_termica, 0),'&nbsp;') as pot_termica_tel_padre_sost
         , f.note_dest as note_dest_fr_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_padre_tel_sost
         , a.flag_attivo as flag_attivo_tel_padre_sost
	 , f.cod_impianto_est as cod_impianto_est_tel_padre_sost
         from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto		= a.cod_impianto 
 -- rom29 left outer join coimdimp m on m.cod_impianto     = a.cod_impianto
 -- rom29 inner join coimaimp h on f.cod_impianto = h.cod_impianto_princ
 -- rom29 and f.cod_impianto != h.cod_impianto
   where f.cod_impianto in ('[join $lista_cod_impianti ',']') -- rom29
     and f.cod_impianto != :cod_impianto
     and f.flag_tipo_impianto = 'T'
--     and coalesce(a.flag_sostituito,'') = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_tel_padre_targa"><!-- rom01 -->
      <querytext>
    select a.gen_prog_est as gen_prog_est_tel_padre	   
         , a.gen_prog as gen_prog_tel_padre		   
         , coalesce(a.matricola,'&nbsp;') as matricola_tel_padre
         , coalesce(a.modello,'&nbsp;') as modello_tel_padre
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel_padre
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel_padre
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel_padre
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel_padre 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel_padre
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel_padre
         , f.note_dest as note_dest_fr_padre
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_tel_padre
         , a.flag_attivo as flag_attivo_tel_padre
         , f.cod_impianto_est as cod_impianto_est_tel_padre
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
-- 2014-06-10 (Standardizzata personalizzazione di Gorizia)      and a.flag_attivo    = 'S'
       and f.flag_tipo_impianto = 'T'
--     and coalesce(a.flag_sostituito,'') !='S' --rom11
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_tel_padre_targa_sost"><!--rom11-->
      <querytext>
    select a.gen_prog_est as gen_prog_est_tel_padre_sost
         , a.gen_prog as gen_prog_tel_padre_sost
         , coalesce(a.matricola,'&nbsp;') as matricola_tel_padre_sost
         , coalesce(a.modello,'&nbsp;') as modello_tel_padre_sost
         , coalesce(b.descr_comb,'&nbsp;') as descr_comb_tel_padre_sost
         , coalesce(iter_edit_data(a.data_installaz),'&nbsp;') as data_installaz_tel_padre_sost
	 , coalesce(iter_edit_data(a.data_rottamaz),'&nbsp;')  as data_rottamaz_tel_padre_sost
         , coalesce(iter_edit_num(a.pot_focolare_lib, 2),'&nbsp;') as pot_focolare_lib_tel_padre_sost 
         , coalesce(iter_edit_num(a.pot_focolare_nom, 2),'&nbsp;') as pot_foc_nom_tel_padre_sost
         , coalesce(c.descr_cost, '&nbsp;') as costruttore_gend_tel_padre_sost
         , f.note_dest as note_dest_fr_padre_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_tel_padre_sost
         , a.flag_attivo as flag_attivo_tel_padre_sost
	 , f.cod_impianto_est as cod_impianto_est_tel_padre_sost
         from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           inner join coimaimp f      on f.cod_impianto	     = a.cod_impianto 
     where f.cod_impianto != :cod_impianto
       and upper(f.targa)  = upper(:targa)
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
       and f.flag_tipo_impianto = 'T'
--     and coalesce(a.flag_sostituito,'')   = 'S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_condu"><!-- gac01 -->
      <querytext>
    select coalesce(b.cognome,'')||' '||coalesce(b.nome,'') as nome_condu
         , coalesce(b.cod_fiscale,'') as cod_fiscale_condu
         , coalesce(iter_edit_data(b.data_patentino),'&nbsp;') as data_patentino_condu
	 , coalesce(b.ente_rilascio_patentino,'') as ente_rilascio_patentino
         , coalesce(b.indirizzo,'')||' '||coalesce(b.numero,'') as indirizzo_condu
         , coalesce(b.comune,'') as nome_comu_condu
         , coalesce(b.provincia,'') as sigla_condu
         , coalesce(b.cap,'') as cap_condu
         , coalesce(b.telefono,'')||'-'||coalesce(b.cellulare, '') as tel_condu
         , coalesce(b.fax,'') as fax_condu
         , coalesce(b.email,'') as email_condu
         , coalesce(b.pec,'') as pec_condu    
      from coimaimp a
         , coimcondu b 
       where a.cod_impianto = :cod_impianto_condu --rom21 messo cod_impianto_condu al posto di cod_impianto
         and b.cod_conduttore = a.cod_conduttore
      </querytext>
    </fullquery>

    <partialquery name="sel_gend_bis">
       <querytext>
       select * 
            , $select_anni
         from (
           select a.gen_prog
                , a.gen_prog_est
                , a.descrizione    
                , c.descr_comb     
                , iter_edit_data(a.data_installaz) as data_installaz_edit
                , case a.flag_attivo
                       when 'S' then 'S&igrave;'
                       when 'N' then '<font color=red><b>No</b></font>'
                       else '&nbsp;'
                  end as flag_attivo
                , iter_edit_num(coalesce(a.pot_utile_nom,a.pot_focolare_nom),2) || ' (kW)' as potenza
                , f.cod_impianto_est
                , iter_edit_num(t.importo,2) as importo
                , a.pot_utile_nom as potenza_num
                , c.cod_combustibile as combustibile
                , f.flag_tipo_impianto
            from coimgend a
  left outer join coimcomb c
               on c.cod_combustibile = a.cod_combustibile
             inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
    left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                  where d.cod_potenza = f.cod_potenza
                                    and d.tipo_costo != 7 --escludo i contributi
                                    and d.cod_listino = '0'
                                    and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto_1bis
     --rom32  and coalesce(a.pot_utile_nom,a.pot_focolare_nom) >10
              and coalesce(a.pot_utile_nom,a.pot_focolare_nom) >=10 --rom32
              and flag_attivo = 'S' --rom01
              and f.flag_tipo_impianto !='F'
	      and f.stato='A'
           ) gen
         order by flag_attivo desc
                , cod_impianto_est
                , gen_prog_est
       </querytext>
    </partialquery>

    <partialquery name="sel_tot_gend">
       <querytext>
       select iter_edit_num(sum(potenza),2) || ' (kW)' as tot_potenza
            , case when tipo = 'G' then 'GASSOSO'
                   when tipo = 'L' then 'LIQUIDO'
                   when tipo = 'S' then 'SOLIDO'
                   when tipo = 'A' then 'ALTRO'
                   end as tipo_combustibile
	    , importo as tot_importo
	    , $select_anni_tot --rom15
	 from (
           select coalesce(a.pot_utile_nom,a.pot_focolare_nom) as potenza
                , c.tipo
	        , iter_edit_num(t.importo , 2) as importo
		, a.pot_utile_nom as potenza_num
                , c.cod_combustibile as combustibile
		, f.flag_tipo_impianto
             from coimgend a
  left outer join coimcomb c
               on c.cod_combustibile = a.cod_combustibile
       inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
  left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                     from coimtari d
                                    where d.cod_potenza = f.cod_potenza
                                      and d.tipo_costo != 7 --escludo i contributi
                                      and d.cod_listino = '0'
                                      and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto_1bis
	      and f.flag_tipo_impianto !='F'
     --rom32  and coalesce(a.pot_utile_nom,a.pot_focolare_nom) >10
              and coalesce(a.pot_utile_nom,a.pot_focolare_nom) >=10 --rom32
              and flag_attivo ='S' --rom01
	      and f.stato='A'
           ) gen
         group by tipo, importo, flag_tipo_impianto, combustibile 
       </querytext>
     </partialquery>

    <partialquery name="sel_gend_fr_bis">
       <querytext>
       select * 
            , $select_anni_fr
         from (
           select a.gen_prog
                , a.gen_prog_est
                , case a.flag_attivo
                       when 'S' then 'S&igrave;'
                       when 'N' then '<font color=red><b>No</b></font>'
                       else '&nbsp;'
                  end as flag_attivo
      --rom13  , iter_edit_num(a.pot_focolare_nom,2) || ' (kW)' as potenza
                , iter_edit_num(greatest(a.pot_focolare_nom, a.pot_focolare_lib),2) || ' (kW)' as potenza --rom13
                , f.cod_impianto_est
                , iter_edit_num(t.importo,2) as importo
                , greatest(a.pot_focolare_nom, a.pot_focolare_lib) as potenza_num_fr --rom13
                , f.flag_tipo_impianto
                , a.cod_tpco
                , coalesce(p.descr_tpco, '&nbsp;') as descr_tpco  --rom04
		, case when coalesce(a.flag_prod_acqua_calda,'N') = 'S'
		        and coalesce(a.flag_clima_invernale,'N')  = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Produzione ACS'
	               when coalesce(a.flag_clima_invernale,'N')  = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N') = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Climatizzazione invernale'
                       when coalesce(a.flag_clim_est,'N')         = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'N'
		       and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione estiva'
		      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'N' then 'Produzione ACS +<br>Climatizzazione invernale'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'N' then 'Produzione ACS +<br>Climatizzazione estiva'
         	      when coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S'
		       and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione invernale +<br>Climatizzazione estiva'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		       and coalesce(a.flag_clima_invernale,'N')   = 'S'
		       and coalesce(a.flag_clim_est,'N')          = 'S' then 'Produzione ACS +<br>Climatizzazione invernale +<br>Climatizzazione estiva'
                      when coalesce(a.flag_prod_acqua_calda,'N')  = 'N'
  		       and coalesce(a.flag_clima_invernale,'N')   = 'N'
		       and coalesce(a.flag_clim_est,'N')          = 'N' then '&nbsp;'
		      else '&nbsp;' end as tipo_climatizzazione --rom05
             from coimgend a
  left outer join coimtpco p              --rom04
               on p.cod_tpco = a.cod_tpco --rom04 
             inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
    left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                  from coimtari d
                                  where d.cod_potenza = f.cod_potenza
                                    and d.tipo_costo != 7 --escludo i contributi
                                    and d.cod_listino = '0'
                                    and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto_1bis
	      and f.flag_tipo_impianto = 'F'
   --mic01    and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 10 --sim06	      
   --rom32    and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 12 --mic01
	      and greatest(a.pot_focolare_nom, a.pot_focolare_lib) >= 12 --rom32
	      --sim06              and a.pot_focolare_nom >10
              and flag_attivo = 'S' --rom01
	      and f.stato='A'
           ) gen
         order by flag_attivo desc
                , cod_impianto_est
                , gen_prog_est
       </querytext>
    </partialquery>

    <partialquery name="sel_tot_gend_fr">
       <querytext>
       select iter_edit_num(sum(potenza),2) || ' (kW)' as tot_potenza
	    , importo as tot_importo
	    , $select_anni_tot_fr --rom14
	    , coalesce(descr_tpco,'&nbsp;') as tot_descr_tpco --rom04
	    , coalesce(tipo_climatizzazione,'&nbsp;') as tot_tipo_climatizzazione --rom05
	 from (
           select --rom13 a.pot_focolare_nom as potenza
                  greatest(a.pot_focolare_nom, a.pot_focolare_lib) as potenza --rom13
                , coalesce(p.descr_tpco, '&nbsp;') as descr_tpco  --rom04
	        , iter_edit_num(t.importo , 2) as importo
	--rom13 , a.pot_focolare_nom as potenza_num
		, greatest(a.pot_focolare_nom, a.pot_focolare_lib) as potenza_num_fr --rom13
		, f.flag_tipo_impianto
                , a.cod_tpco
		, case when coalesce(a.flag_prod_acqua_calda,'N') = 'S'
		        and coalesce(a.flag_clima_invernale,'N')  = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Produzione ACS'
	               when coalesce(a.flag_clima_invernale,'N')  = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N') = 'N'
			and coalesce(a.flag_clim_est,'N')         = 'N' then 'Climatizzazione invernale'
                       when coalesce(a.flag_clim_est,'N')         = 'S'
  		        and coalesce(a.flag_clima_invernale,'N')   = 'N'
		        and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione estiva'
		       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'N' then 'Produzione ACS +<br>Climatizzazione invernale'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'N' then 'Produzione ACS +<br>Climatizzazione estiva'
         	       when coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S'
		        and coalesce(a.flag_prod_acqua_calda,'N')  = 'N' then 'Climatizzazione invernale +<br>Climatizzazione estiva'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'S'
		        and coalesce(a.flag_clima_invernale,'N')   = 'S'
		        and coalesce(a.flag_clim_est,'N')          = 'S' then 'Produzione ACS +<br>Climatizzazione invernale +<br>Climatizzazione estiva'
                       when coalesce(a.flag_prod_acqua_calda,'N')  = 'N'
  		        and coalesce(a.flag_clima_invernale,'N')   = 'N'
		        and coalesce(a.flag_clim_est,'N')          = 'N' then ''
		       else '' end as tipo_climatizzazione --rom05
             from coimgend a
  left outer join coimtpco p              --rom04
               on p.cod_tpco = a.cod_tpco --rom04
       inner join coimaimp f      on f.cod_impianto      = a.cod_impianto
  left outer join coimtari t
               on t.cod_potenza = f.cod_potenza
              and tipo_costo != 7 --escludo i contributi
              and cod_listino = '0'
              and t.data_inizio = (select max(d.data_inizio)
                                     from coimtari d
                                    where d.cod_potenza = f.cod_potenza
                                      and d.tipo_costo != 7 --escludo i contributi
                                      and d.cod_listino = '0'
                                      and d.data_inizio <= current_date)
            where a.cod_impianto = :cod_impianto_1bis
	      and f.flag_tipo_impianto = 'F'
  --mic01     and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 10 --sim06
  --rom32     and greatest(a.pot_focolare_nom, a.pot_focolare_lib) > 12 --mic01
              and greatest(a.pot_focolare_nom, a.pot_focolare_lib) >= 12 --rom32
              --sim06 and a.pot_focolare_nom >10
              and flag_attivo ='S' --rom01
	      and f.stato='A'
           ) gen
         group by importo, descr_tpco, tipo_climatizzazione, cod_tpco
       </querytext>
     </partialquery>


    <partialquery name="sel_sist_reg"><!-- rom08 -->
           <querytext>
      		select a.regol_curva_ind_iniz_num_sr                    as num_sr
                     , iter_edit_data(a.regol_curva_ind_iniz_data_inst) as data_installazione_sr_edit
                     , iter_edit_data(a.regol_curva_ind_iniz_data_dism) as data_dismissione_sr_edit
		     , a.regol_curva_ind_iniz_data_inst                 as data_installazione_sr
                     , a.regol_curva_ind_iniz_data_dism                 as data_dismissione_sr
	             , a.regol_curva_ind_iniz_n_punti_reg               as num_punti_regolaz_sr
	             , a.regol_curva_ind_iniz_n_liv_temp                as num_lvl_temp_sr
	             , a.regol_curva_ind_iniz_fabbricante               as fabbricante_sr
	             , a.regol_curva_ind_iniz_modello                   as modello_sr
	          from coimaimp a
	         where a.cod_impianto = :cod_impianto_reg
		   and a.regol_curva_ind_iniz_num_sr is not null
		   and a.regol_curva_ind_iniz_flag_sostituito = 'f'
	         union all
	        select a.numero_sistema_regolazione          as num_sr
	             , iter_edit_data(a.data_installazione)  as data_installazione_sr_edit
	             , iter_edit_data(a.data_dismissione)    as data_dismissione_sr_edit
	             , a.data_installazione                  as data_installazione_sr
	             , a.data_dismissione                    as data_dismissione_sr
	             , a.numero_punti_regolazione            as num_punti_regolaz_sr
	             , a.numero_lvl_temperatura              as num_lvl_temp_sr
	             , a.fabbricante                         as fabbricante_sr
	             , a.modello                             as modello_sr
	          from coimaimp_sistemi_regolazione a
	         where a.cod_impianto = :cod_impianto_reg
		   and a.flag_sostituito = 'f'
	         order by num_sr
       </querytext>
           </partialquery>

    <fullquery name="sel_sist_reg_sost_comp"><!-- rom09 -->
           <querytext>
      		select a.regol_curva_ind_iniz_num_sr                    as num_sr_sost_comp
                     , iter_edit_data(a.regol_curva_ind_iniz_data_inst) as data_installazione_sr_edit_sost_comp
                     , iter_edit_data(a.regol_curva_ind_iniz_data_dism) as data_dismissione_sr_edit_sost_comp
		     , a.regol_curva_ind_iniz_data_inst                 as data_installazione_sr_sost_comp
                     , a.regol_curva_ind_iniz_data_dism                 as data_dismissione_sr_sost_comp
	             , a.regol_curva_ind_iniz_n_punti_reg               as num_punti_regolaz_sr_sost_comp
	             , a.regol_curva_ind_iniz_n_liv_temp                as num_lvl_temp_sr_sost_comp
	             , a.regol_curva_ind_iniz_fabbricante               as fabbricante_sr_sost_comp
	             , a.regol_curva_ind_iniz_modello                   as modello_sr_sost_comp
	          from coimaimp a
	         where a.cod_impianto = :cod_impianto_reg
		   and a.regol_curva_ind_iniz_num_sr is not null
		   and a.regol_curva_ind_iniz_flag_sostituito = 't'
	         union all
	        select a.numero_sistema_regolazione           as num_sr_sost_comp
	             , iter_edit_data(a.data_installazione)  as data_installazione_sr_edit_sost_comp
	             , iter_edit_data(a.data_dismissione)    as data_dismissione_sr_edit_sost_comp
	             , a.data_installazione                  as data_installazione_sr_sost_comp
	             , a.data_dismissione                    as data_dismissione_sr_sost_comp
	             , a.numero_punti_regolazione            as num_punti_regolaz_sr_sost_comp
	             , a.numero_lvl_temperatura              as num_lvl_temp_sr_sost_comp
	             , a.fabbricante                         as fabbricante_sr_sost_comp
	             , a.modello                             as modello_sr_sost_comp
	          from coimaimp_sistemi_regolazione a
	         where a.cod_impianto = :cod_impianto_reg
		   and a.flag_sostituito = 't'
	         order by num_sr_sost_comp
       </querytext>
           </fullquery>

    <fullquery name="sel_valv_reg">--rom09 aggiunta query "sel_valv_reg"
               <querytext>
       	       select a.regol_valv_ind_num_vr                         as num_vr
                    , iter_edit_data(a.regol_valv_ind_iniz_data_inst) as data_installazione_vr_edit
		    , iter_edit_data(a.regol_valv_ind_iniz_data_dism) as data_dismissione_vr_edit
                    , a.regol_valv_ind_iniz_data_inst                 as data_installazione_vr
		    , a.regol_valv_ind_iniz_data_dism                 as data_dismissione_vr
                    , a.regol_valv_ind_iniz_fabbricante               as fabbricante_vr
	            , a.regol_valv_ind_iniz_modello                   as modello_vr
     		    , a.regol_valv_ind_iniz_n_vie                     as num_vie_vr
     		    , a.regol_valv_ind_iniz_servo_motore              as servomotore_vr
  		 from coimaimp a
 		where a.cod_impianto = :cod_impianto_reg
                  and a.regol_valv_ind_num_vr is not null
		  and a.regol_valv_ind_flag_sostituito = 'f'
                union all
	       select a.numero_valvola_regolazione         as num_vr
     		    , iter_edit_data(a.data_installazione) as data_installazione_vr
     		    , iter_edit_data(a.data_dismissione)   as data_dismissione_vr_edit
     		    , a.data_installazione                 as data_installazione_vr
     		    , a.data_dismissione                   as data_dismissione_vr
      		    , a.fabbricante                        as fabbricante_vr
     		    , a.modello                            as modello_vr
     		    , a.numero_vie                         as num_vie_vr
     		    , a.servomotore                        as servomotore_vr
        	 from coimaimp_valvole_regolazione a
 	        where a.cod_impianto = :cod_impianto_reg
		  and a.flag_sostituito = 'f'
 		order by num_vr
               </querytext>
    </fullquery>

    <fullquery name="sel_valv_reg_sost_comp">--rom09 aggiunta query "sel_valv_reg_sost_comp"
               <querytext>
       	       select a.regol_valv_ind_num_vr                         as num_vr_sost_comp
                    , iter_edit_data(a.regol_valv_ind_iniz_data_inst) as data_installazione_vr_edit_sost_comp
		    , iter_edit_data(a.regol_valv_ind_iniz_data_dism) as data_dismissione_vr_edit_sost_comp
                    , a.regol_valv_ind_iniz_data_inst                 as data_installazione_vr_sost_comp
		    , a.regol_valv_ind_iniz_data_dism                 as data_dismissione_vr_sost_comp
                    , a.regol_valv_ind_iniz_fabbricante               as fabbricante_vr_sost_comp
	            , a.regol_valv_ind_iniz_modello                   as modello_vr_sost_comp
     		    , a.regol_valv_ind_iniz_n_vie                     as num_vie_vr_sost_comp
     		    , a.regol_valv_ind_iniz_servo_motore              as servomotore_vr_sost_comp
  		 from coimaimp a
 		where a.cod_impianto = :cod_impianto_reg
                  and a.regol_valv_ind_num_vr is not null
		  and a.regol_valv_ind_flag_sostituito = 't'
                union all
	       select a.numero_valvola_regolazione         as num_vr_sost_comp
     		    , iter_edit_data(a.data_installazione) as data_installazione_vr_edit_sost_comp
     		    , iter_edit_data(a.data_dismissione)   as data_dismissione_vr_edit_sost_comp
     		    , a.data_installazione                 as data_installazione_vr_sost_comp
     		    , a.data_dismissione                   as data_dismissione_vr_sost_comp
      		    , a.fabbricante                        as fabbricante_vr_sost_comp
     		    , a.modello                            as modello_vr_sost_comp
     		    , a.numero_vie                         as num_vie_vr_sost_comp
     		    , a.servomotore                        as servomotore_vr_sost_comp
        	 from coimaimp_valvole_regolazione a
 	        where a.cod_impianto = :cod_impianto_reg
		  and a.flag_sostituito = 't'
 		order by num_vr_sost_comp
               </querytext>
    </fullquery>

    <fullquery name="sel_inte_contr"><!--rom11-->
           <querytext>
		select coalesce(a.cognome, '') as cognome_inte_contr
		     , coalesce(a.nome   , '') as    nome_inte_contr
		  from coimcitt a
		     , coimaimp b
		 where a.cod_cittadino = b.cod_intestatario
		   and b.cod_impianto  = :cod_impianto
     	   </querytext>
    </fullquery>
								       
    <fullquery name="sel_gend_4_1bis"><!--rom11-->
             <querytext>
    select a.gen_prog_est as gen_prog_est_4_1bis
         , a.gen_prog     as gen_prog_4_1bis
         , case a.locale                  
           when 'T' then 'Locale ad uso esclusivo'
           when 'I' then 'Interno'
           when 'E' then 'Esterno'
           else '&nbsp;'
            end as locale_4_1bis
         , case  a.dpr_660_96              
           when 'S' then 'Standard'
           when 'B' then 'Bassa temperatura'
           when 'G' then 'Gas a condensazione'
           else '&nbsp;'
            end as dpr_660_96_4_1bis
         , case  a.flag_caldaia_comb_liquid 
           when 'S' then 'Si'
           when 'N' then 'No'
           else '&nbsp;'
            end as flag_caldaia_comb_liquid_4_1bis
         , case  a.tipo_foco                
           when 'A' then 'Aperta'
           when 'C' then 'Stagna'
           else '&nbsp;'
           end as tipo_foco_4_1bis
        , case  a.tiraggio                													       when 'N' then 'Naturale'
          when 'F' then 'Forzato'
          else '&nbsp;'
           end as tiraggio_4_1bis
        , case  a.cod_emissione  
          when 'C' then 'Camino Collettivo'
          when 'I' then 'camino Individuale'
          when 'P' then 'Scarico a Parete'
          else 'Non Noto'
           end as cod_emissione_4_1bis
        , coalesce(iter_edit_data(a.data_costruz_gen), '&nbsp;')  as data_costruz_gen_4_1bis
        , case a.flag_attivo
          when 'S' then 'Si'
          when 'N' then 'No'
          else '&nbsp;'
           end as attivo_si_no_4_1bis
        , a.flag_prod_acqua_calda as flag_prod_acqua_calda_4_1bis
        , a.flag_clima_invernale  as flag_clima_invernale_4_1bis
        , a.flag_clim_est         as flag_clim_est_4_1bis
        , a.flag_altro            as flag_altro_4_1bis
        , a.funzione_grup_ter_note_altro as funzione_grup_ter_note_altro_4_1bis
--gac07        , coalesce(iter_edit_num(f.potenza_utile, 2),'&nbsp;') as potenza_utile_4_1bis
        , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as potenza_utile_4_1bis --gac07
	, case a.motivazione_disattivo
	  when 'A' then 'Dichiarato tale mediante apposita comunicazione'
          when 'B' then 'Attivato solo in sostituzione di un altro'
          when 'C' then 'Inserito in immobile nuovo mai abitato'
          when 'D' then 'In edificio crollato/inagibile/sgomberato'
          when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	  else '' end as motivazione_disattivo_4_1bis
	, f.cod_impianto_est as cod_impianto_est_4_1bis
	, coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_1_bis --mat01
     from coimgend a
   left outer join coimmanu i  on i.cod_manutentore = a.cod_installatore --mat01
        , coimaimp f 
    where a.cod_impianto = f.cod_impianto
      and f.flag_tipo_impianto = 'R' --rom12
      and upper(f.targa)  = upper(:targa)
      and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--      and coalesce(a.flag_sostituito,'') !='S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est   
             </querytext>
    </fullquery>

    <fullquery name="sel_gend_4_1bis_sost"><!--rom11-->
             <querytext>
    select a.gen_prog_est as gen_prog_est_4_1bis_sost
         , a.gen_prog     as gen_prog_4_1bis_sost
         , case a.locale                  
           when 'T' then 'Locale ad uso esclusivo'
           when 'I' then 'Interno'
           when 'E' then 'Esterno'
           else '&nbsp;'
            end as locale_4_1bis_sost 
         , case  a.dpr_660_96              
           when 'S' then 'Standard'
           when 'B' then 'Bassa temperatura'
           when 'G' then 'Gas a condensazione'
           else '&nbsp;'
            end as dpr_660_96_4_1bis_sost
         , case  a.flag_caldaia_comb_liquid 
           when 'S' then 'Si'
           when 'N' then 'No'
           else '&nbsp;'
            end as flag_caldaia_comb_liquid_4_1bis_sost
         , case  a.tipo_foco                
           when 'A' then 'Aperta'
           when 'C' then 'Stagna'
           else '&nbsp;'
           end as tipo_foco_4_1bis_sost
        , case  a.tiraggio                													       when 'N' then 'Naturale'
          when 'F' then 'Forzato'
          else '&nbsp;'
           end as tiraggio_4_1bis_sost
        , case  a.cod_emissione  
          when 'C' then 'Camino Collettivo'
          when 'I' then 'camino Individuale'
          when 'P' then 'Scarico a Parete'
          else 'Non Noto'
           end as cod_emissione_4_1bis_sost
        , coalesce(iter_edit_data(a.data_costruz_gen), '&nbsp;')  as data_costruz_gen_4_1bis_sost
        , case a.flag_attivo
          when 'S' then 'Si'
          when 'N' then 'No'
          else '&nbsp;'
           end as attivo_si_no_4_1bis_sost
        , a.flag_prod_acqua_calda as flag_prod_acqua_calda_4_1bis_sost
        , a.flag_clima_invernale  as flag_clima_invernale_4_1bis_sost
        , a.flag_clim_est         as flag_clim_est_4_1bis_sost
        , a.flag_altro            as flag_altro_4_1bis_sost
        , a.funzione_grup_ter_note_altro as funzione_grup_ter_note_altro_4_1bis_sost
--gac07        , coalesce(iter_edit_num(f.potenza_utile, 2),'&nbsp;') as potenza_utile_4_1bis_sost
        , coalesce(iter_edit_num(a.pot_utile_nom, 2),'&nbsp;') as potenza_utile_4_1bis_sost --gac07
	, case a.motivazione_disattivo
	  when 'A' then 'Dichiarato tale mediante apposita comunicazione'
          when 'B' then 'Attivato solo in sostituzione di un altro'
          when 'C' then 'Inserito in immobile nuovo mai abitato'
          when 'D' then 'In edificio crollato/inagibile/sgomberato'
          when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	  else '' end as motivazione_disattivo_4_1bis_sost
	  , f.cod_impianto_est as cod_impianto_est_4_1bis_sost
	  , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_1_bis_sost --mat01
     from coimgend a
  left outer join coimmanu i  on i.cod_manutentore = a.cod_installatore --mat01
        , coimaimp f 
    where a.cod_impianto = f.cod_impianto
      and f.flag_tipo_impianto = 'R' --rom12
      and upper(f.targa)  = upper(:targa)
      and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--      and a.flag_sostituito ='S'
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
    order by a.gen_prog_est   
             </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr_4_4bis">--rom12--
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr_4_4bis
         , a.gen_prog as gen_prog_fr_4_4bis
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_fr_4_4bis
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr_4_4bis
         , a.flag_attivo as flag_attivo_4_4bis
	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else ''
	    end as motivazione_disattivo_fr_4_4bis
	 , case a.locale
	    when 'T' then 'Locale ad uso esclusivo'
	    when 'E' then 'Esterno'
	    when 'I' then 'Interno'
	    else '' end as locale_fr_4_4bis
	 , iter_edit_num(coalesce(a.carica_refrigerante,'0.00'),2) as carica_refrigerante_fr_4_4bis
	 , case a.sigillatura_carica
	   when 'S' then 'Si'
	   else 'No'end as sigillatura_carica_fr_4_4bis
	 , case a.rif_uni_10389
 	   when 'U' then 'norma UNI-10389-3'
	   when 'A' then 'Altro'
    	   else '' end as rif_uni_10389_fr_4_4bis
	 , a. altro_rif as altro_rif_fr_4_4bis
	 , a.flag_prod_acqua_calda as flag_prod_acqua_calda_fr_4_4bis
	 , a.flag_clima_invernale as flag_clima_invernale_fr_4_4bis
	 , a.flag_clim_est as flag_clim_est_fr_4_4bis
	 , iter_edit_num(coalesce(pot_focolare_nom, '0.00'),2) as pot_frig_nominale_fr_4_4bis
	 , iter_edit_num(coalesce(pot_focolare_lib, '0.00'),2) as pot_term_nominale_fr_4_4bis
--         , case when pot_focolare_nom > pot_focolare_lib then '1'
--                when pot_focolare_nom < pot_focolare_lib then '2'
--	        else '3' end as potenza_maggiore_fr_4_4bis
,'2' as potenza_maggiore_fr_4_4bis
, f.cod_impianto_est as cod_impianto_est_4_4bis
     , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_4_bis --mat01
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto 
	   left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
	   where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.flag_tipo_impianto = 'F' 
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--       and coalesce(a.flag_sostituito,'') !='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_fr_4_4bis_sost">--rom12
       <querytext>
    select a.gen_prog_est as gen_prog_est_fr_4_4bis_sost
         , a.gen_prog as gen_prog_fr_4_4bis_sost
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_fr_4_4bis_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_fr_4_4bis_sost
         , a.flag_attivo as flag_attivo_4_4bis_sost
 	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else '' end as motivazione_disattivo_fr_4_4bis_sost
	 , case a.locale
	    when 'T' then 'Locale ad uso esclusivo'
	    when 'E' then 'Esterno'
	    when 'I' then 'Interno'
	    end as locale_fr_4_4bis_sost
         , iter_edit_num(coalesce(a.carica_refrigerante ,'0.00'),2) as carica_refrigerante_fr_4_4bis_sost
	 , case a.sigillatura_carica
	   when 'S' then 'Si'
	   else '' end as sigillatura_carica_fr_4_4bis_sost
	 , case a.rif_uni_10389
	   when 'U' then 'norma UNI-10389-3'
	   when 'A' then 'Altro'
	   else '' end as rif_uni_10389_fr_4_4bis_sost
	 , a. altro_rif as altro_rif_fr_4_4bis_sost
         , a.flag_prod_acqua_calda as flag_prod_acqua_calda_fr_4_4bis_sost
         , a.flag_clima_invernale as flag_clima_invernale_fr_4_4bis_sost
         , a.flag_clim_est as flag_clim_est_fr_4_4bis_sost
	 , iter_edit_num(coalesce(pot_focolare_nom, '0.00'),2) as pot_frig_nominale_fr_4_4bis_sost
	 , iter_edit_num(coalesce(pot_focolare_lib, '0.00'),2) as pot_term_nominale_fr_4_4bis_sost
	 , case when pot_focolare_nom > pot_focolare_lib then '1'
	        when pot_focolare_nom < pot_focolare_lib then '2'
		else '3' end as potenza_maggiore_fr_4_4bis_sost
		, f.cod_impianto_est as cod_impianto_est_4_4bis_sost
	, coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_4_bis_sost --mat01
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto
	   left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
     where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.flag_tipo_impianto = 'F' 
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--       and coalesce(a.flag_sostituito,'') ='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_te_4_5bis">--rom12
       <querytext>
    select a.gen_prog_est as gen_prog_est_te_4_5bis
         , a.gen_prog as gen_prog_te_4_5bis
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_te_4_5bis
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_te_4_5bis
         , a.flag_attivo as flag_attivo_4_4bis
	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else ''
	    end as motivazione_disattivo_te_4_5bis
	 , case a.rif_uni_10389
 	   when 'U' then 'norma UNI-10389-4' -- rom31 'In attesa di definizione'
	   when 'A' then 'Altro'
    	   else '' end as rif_uni_10389_te_4_5bis
	 , a. altro_rif as altro_rif_te_4_5bis
	 , a.flag_prod_acqua_calda as flag_prod_acqua_calda_te_4_5bis
	 , a.flag_clima_invernale as flag_clima_invernale_te_4_5bis
	 , a.flag_clim_est as flag_clim_est_te_4_5bis
	 , iter_edit_num(coalesce(pot_focolare_nom, '0.00'),2) as pot_frig_nominale_te_4_5bis
	 , iter_edit_num(coalesce(pot_focolare_lib, '0.00'),2) as pot_term_nominale_te_4_5bis
	 , f.cod_impianto_est as cod_impianto_est_4_5bis
	 , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_5_bis --mat01
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto 
           left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
     where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.flag_tipo_impianto = 'T' 
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--       and coalesce(a.flag_sostituito,'') !='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_te_4_5bis_sost">--rom12
       <querytext>
    select a.gen_prog_est as gen_prog_est_te_4_5bis_sost
         , a.gen_prog as gen_prog_te_4_5bis_sost
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_te_4_5bis_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_te_4_5bis_sost
         , a.flag_attivo as flag_attivo_4_4bis_sost
 	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else '' end as motivazione_disattivo_te_4_5bis_sost
	 , case a.rif_uni_10389
	   when 'U' then 'norma UNI-10389-4' -- rom31 'In attesa di definizione'
	   when 'A' then 'Altro'
	   else '' end as rif_uni_10389_te_4_5bis_sost
	 , a. altro_rif as altro_rif_te_4_5bis_sost
         , a.flag_prod_acqua_calda as flag_prod_acqua_calda_te_4_5bis_sost
         , a.flag_clima_invernale as flag_clima_invernale_te_4_5bis_sost
         , a.flag_clim_est as flag_clim_est_te_4_5bis_sost
	 , iter_edit_num(coalesce(pot_focolare_nom, '0.00'),2) as pot_frig_nominale_te_4_5bis_sost
	 , iter_edit_num(coalesce(pot_focolare_lib, '0.00'),2) as pot_term_nominale_te_4_5bis_sost
         , f.cod_impianto_est as cod_impianto_est_4_5bis_sost
	 , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_5_bis_sost --mat01
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto
	   left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
     where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
       and f.flag_tipo_impianto = 'T' 
--       and coalesce(a.flag_sostituito,'') ='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_co_4_6bis">--rom12
       <querytext>
    select a.gen_prog_est as gen_prog_est_co_4_6bis
         , a.gen_prog as gen_prog_co_4_6bis
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_co_4_6bis
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_co_4_6bis
         , a.flag_attivo as flag_attivo_4_4bis
	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else ''
	    end as motivazione_disattivo_co_4_6bis
	 , case a.rif_uni_10389
 	   when 'U' then 'In attesa di definizione'
	   when 'A' then 'Altro'
    	   else '' end as rif_uni_10389_co_4_6bis
	 , a. altro_rif as altro_rif_co_4_6bis
	 , a.flag_prod_acqua_calda as flag_prod_acqua_calda_co_4_6bis
	 , a.flag_clima_invernale as flag_clima_invernale_co_4_6bis
	 , a.flag_clim_est as flag_clim_est_co_4_6bis
	 , f.cod_impianto_est as cod_impianto_est_4_6bis
         , iter_edit_num(coalesce(a.pot_utile_nom,'0.00'),2) as pot_utile_nom_co_4_6bis
	 , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_6_bis --mat01
      from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto
	   left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
     where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.flag_tipo_impianto = 'C' 
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--       and coalesce(a.flag_sostituito,'') !='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
     order by a.gen_prog_est
       </querytext>
    </fullquery>

    <fullquery name="sel_gend_co_4_6bis_sost">--rom12
       <querytext>
    select a.gen_prog_est as gen_prog_est_co_4_6bis_sost
         , a.gen_prog as gen_prog_co_4_6bis_sost
         , coalesce(iter_edit_data(a.data_costruz_gen),'&nbsp;') as data_costruz_gen_co_4_6bis_sost
         , case a.flag_attivo
                when 'S' then 'Attivo'
                else 'Non Attivo'
                end as stato_gen_co_4_6bis_sost
         , a.flag_attivo as flag_attivo_4_4bis_sost
 	 , case a.motivazione_disattivo
	   when 'A' then 'Dichiarato tale mediante apposita comunicazione'
	   when 'B' then 'Attivato solo in sostituzione di un altro'
	   when 'C' then 'Inserito in immobile nuovo mai abitato'
	   when 'D' then 'In edificio crollato/inagibile/sgomberato'
	   when 'E' then 'Distaccato dalla rete per motivi di sicurezza'
	   else '' end as motivazione_disattivo_co_4_6bis_sost
	 , case a.rif_uni_10389
	   when 'U' then 'In attesa di definizione'
	   when 'A' then 'Altro'
	   else '' end as rif_uni_10389_co_4_6bis_sost
	 , a. altro_rif as altro_rif_co_4_6bis_sost
         , a.flag_prod_acqua_calda as flag_prod_acqua_calda_co_4_6bis_sost
         , a.flag_clima_invernale as flag_clima_invernale_co_4_6bis_sost
         , a.flag_clim_est as flag_clim_est_co_4_6bis_sost
	 , iter_edit_num(coalesce(pot_focolare_nom, '0.00'),2) as pot_frig_nominale_co_4_6bis_sost
	 , iter_edit_num(coalesce(pot_focolare_lib, '0.00'),2) as pot_term_nominale_co_4_6bis_sost
         , f.cod_impianto_est as cod_impianto_est_te_sost
         , iter_edit_num(coalesce(a.pot_utile_nom,'0.00'),2) as pot_utile_nom_co_4_6bis_sost
	 , f.cod_impianto_est as cod_impianto_est_4_6bis_sost
	 , coalesce(i.cognome, '&nbsp;')||' '||coalesce(i.nome, '&nbsp;') as inst_4_6_bis_sost --mat01
	 from coimgend a
           left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
           left outer join coimcost c on c.cod_cost         = a.cod_cost
           left outer join coimtpem d on d.cod_emissione    = a.cod_emissione
           left outer join coimutgi g on g.cod_utgi         = a.cod_utgi
           left outer join coimaimp f on f.cod_impianto     = a.cod_impianto
	   left outer join coimmanu i on i.cod_manutentore = a.cod_installatore --mat01
     where a.cod_impianto = f.cod_impianto
       and upper(f.targa)  = upper(:targa)	
       and f.flag_tipo_impianto = 'C' 
       and f.stato not in ('E','F') --rom30 E Respinto F da Validare
--       and coalesce(a.flag_sostituito,'') ='S' 
$where_gend_sost
--rom20and f.stato='A'
       $and_st_imp --rom20
       order by a.gen_prog_est
       </querytext>
    </fullquery>

</queryset>
