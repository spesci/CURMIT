ad_page_contract {
    Pagina di sfondo.

    @author Romitti Luca
    @date   05/02/2018

    @cvs_id coimaimp-warning.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    ric01 24/02/2025 Aggiunta condizione per Regione Marche per consentire l'inserimento di un RCEE nonostante
    ric01            la persona giuridica responsabile non abbia il nome valorizzato (T. 11611)

    rom25 25/10/2024 Sistemati per tutti gli enti controlli su poteze generatori degli impianti del freddo come
    rom25            viene gia' fatto per alcuni enti come Regione Marche o Regione Friuli.

    rom24 17/05/2024 CASERTA HA CHIESTO DI TOGLIERE I CONTROLLI SU POD E PDR FINO AL 31/08/2024

    rom23 19/12/2023 Rieti ha chiesto di togliere sempre l'obbligatorieta' sui campi POD e PDR.

    rom22 27/11/2023 Napoli ha richiesto di togliere sempre l'obbligatorieta' sui campi POD e PDR.

    rom21 28/07/2023 Palermo sulle potenze del generatore per il freddo ha gli stessi controlli di Marche, Ucit e Basilicata.
    rom21bis         Palermo non ha obbligatorio il campo fluido_lato_utenze, copiata modifica gia' fatta su coimgend-gest.

    rom20 08/06/2023 MEV "Impianti condominiali con pompa di calore": i campi Unita' immobiliari servite e
    rom20            Tipologia impianto sono obbligatori anche per il freddo. Vale solo per regione Marche.

    rom19 08/03/2023 Modificato intervento di rom 18 su indicazione di Sandro, per Regione Friuli i soggetti
    rom19            responsabili devono avere uno tra partita iva e codice fiscale senza tenere in considerazione
    rom19            la natura giuridica del soggetto.

    rom18 07/03/2023 Il controllo su cod_piva e cod_fiscale non va fatto per tutta Regione Friuli. Prima non
    rom18            venivano fatti solo per Provincia di Udine e Gorizia.

    rom17 03/02/2023 Ucit sulle potenze del generatore per il freddo ha gli stessi controlli di Marche e Basilicata.

    rom16 02/02/2023 Regione Campania e Palermo hanno i campi sorgente_lato_esterno, cod_flre e cod_tpco
    rom16            obbligatori per gli impianti del freddo.

    rom15 24/01/2023 Per UCIT sugli impianti del freddo la potenza utile in rafrescamento non e' piu' visualizzata
    rom15            quindi oer loro devo saltare il controllo

    rom14 17/01/2023 Per Benevento se il soggetto responsabile non ha pec e telefono non si possono inserire RCEE.

    rom13 26/07/2022 I controlli su data_libretto e tipologia_generatore vanno fatti per tutti gli enti e non solo
    rom13            per Regione Marche.

    mic01 30/05/2022 Per regione Marche nrl caso di combustibili non solidi, il dpr 660 e' obbligatorio.
    
    rom12 03/05/2022 Regione Basilicata gestisce come le Marche le potenze dei generatori per il freddo.

    rom11 27/04/2022 MEV Regione Marche per Sistemi Ibridi: ora il campo flag_ibrido della coimaimp e' obbligatorio
    rom11            per gli impianti del caldo e del freddo quindi se il campo non e' valorizzato non e'
    rom11            possibile inserire gli RCEE. Aggiunto stesso controllo per il campo tipologia_generatore
    rom11            che pero e' obbligatorio per tutte le tipologie di impianto.
    
    rom10 13/01/2022 Su segnalazione di Sandro e Regione Marche il pod e' sempre obbligatorio
    rom10            se il combustibile e' GPL o GNL.
    
    rom09 09/11/2021 Regione Basilicata deve avere gli stessi controlli su pod e pdr come Regione Campania.

    sim05 12/04/2021 Ora è possibile anche inserire solo le potenze di riscaldamento o solo le potenze di raffrescamento.

    rom08 12/01/2021 Le particolarita' della Provincia di Salerno ora sono sostituite dalla condizione
    rom08            su tutta la Regione Campania.

    rom07 03/12/2020 Per Regione Marche: modificati i controlli per pod e pdr uniformandoli a quelli fatti in 
    rom07            fase di inserimento di un nuovo impianto e a quelli della scheda 1bis. 
    rom07            I vecchi controlli sono stati commentati.
    
    sim04 10/11/2020 Aggiunto il default per la variabile messaggio_iniziale per evitare errori.

    sim03 23/01/2020 Aggiunto il contollo sui dati catastali nel caso sia attivo l'apposito parametro.

    gac05 22/11/2019 Per regione marche ho una gestione del redirect diversa: se ho delle anomalie ed
    gac05            entro in inserimento devo essere bloccato dai controlli, mentre se clicco su Selez. posso
    gac05            entrare in visualizzazione.

    sim02 18/11/2019 Nel caso dei rapporti  di ispezione, non devo fare i controlli su pod,pdr,data intervento e
    sim02            tipo intervento

    sim01 11/11/2019 In data 06/11/2019 attraverso una email, la Regione ha richiesto di togliere
    sim01            il controllo relativo al conduttore sugli impianti di potenza maggiore a 232 KW

    rom06 06/08/2019 Gestito il redirect ai Rapporti d'Ispezione in modo analogo agli RCEE.

    rom05 30/04/2019 Aggiunti i controlli per i campi obbligatori su RCEE del Teleriscaldamento per le Marche.

    rom04 29/04/2019 Aggiunto controllo per le Marche sul campo cod_proprietario che è sempre obbligatorio.
    rom04            Copiati dal programma coimaimp-bis-gest i controlli su pod e pdr.
    
    rom03 15/01/2019 Le marche non vedono più il campo scarico fumi sui generatori del freddo.

    gac04 17/12/2018 Aggiunto controllo campi flag_clima_invernale-flag_prod_acqua_calda-flag_clim_est e flag_altro

    gac03 06/11/2018 Commentato controllo Destinazione d'usp in quanto è stato nascosto il campo

    rom02 08/06/2018 Aggiunto controllo per campo rend_ter_max e il messaggio_iniziale in caso di anomalie.

    rom01 24/04/2018 Aggiunta variabile per la frase iniziale

    gac02 19/04/2018 Aggiunti controlli per i campi della scheda 1bis

    gac01 20/02/2018 Aggiunta if se tipo impianto è cogeneratore non devo inserire fluido termovettore

} {
    cod_impianto
    {cod_dimp ""}
    {cod_dope_aimp ""}
    {cod_noveb ""}
    {gen_prog ""}       
    {caller   ""}
    {url_list_aimp    ""}
    {url_aimp         ""}
    {nome_funz_caller "impianti"}
    {redirect ""}
    {link     ""}
    {funzione ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

set redirect $redirect?$link

set coimcimp "coimcimp-list?";#rom06
set flag_cimp "S";#rom06
#set link_cimp "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp flag_cimp]&nome_funz=[iter_get_nomefunz coimcimp-list]";#rom06

iter_get_coimtgen
set flag_ente   $coimtgen(flag_ente)
set flag_viario $coimtgen(flag_viario)
set flag_obbligo_dati_catastali $coimtgen(flag_obbligo_dati_catastali);#sim03

# posso valorizzare eventuali variabili tcl a disposizione del master
set logo_url [iter_set_logo_dir_url]
set css_url  [iter_set_css_dir_url]

set page_title "Guida compilazione campi"
set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

#gac02 proc per la navigazione

if {$caller eq "cimp"} {
    set nome_funz_caller_cimp "cimp"
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller_cimp $url_list_aimp $url_aimp]
} else {
    
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]

}
set dett_tab [iter_tab_form $cod_impianto]


set elenco_anomalie ""


set flag_gest_targa  $coimtgen(flag_gest_targa)
if {$flag_gest_targa eq "T" } {
    if {![db_0or1row query "
            select targa
              from coimaimp
             where cod_impianto = :cod_impianto
               and coalesce(targa,'') != ''"] 
    } {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Targa</b> su Scheda 1: Dati tecnici</td></tr>"
    }
}



#rom01 aggiunto controllo sul Codice fiscale.
set data_controllo [db_string q "select current_date"  ] 

set flag_errore_data_controllo "f"

set cod_responsabile [db_string q "select cod_responsabile
                                     from coimaimp 
                                    where cod_impianto = :cod_impianto
                                    limit 1" -default ""]

set cod_intestatario [db_string q "select cod_intestatario
                                     from coimaimp
                                    where cod_impianto = :cod_impianto
                                    limit 1" -default ""]


if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom19 Aggiunta if e contenuto

    if {$flag_errore_data_controllo == "f" && $data_controllo >= "20090801"} {
	if {[db_0or1row query "select 1
                                 from coimcitt
                                where cod_cittadino = :cod_responsabile
                                  and cod_fiscale   is null
                                  and cod_piva      is null"]} {
	    append elenco_anomalie "<tr><td>Il responsabile deve avere uno tra il <b>Codice Fiscale</b> e <b>Partita IVA:</b> andare su Scheda 1.6 soggetti resp.</tr></td>"
	}
    }

} elseif {$coimtgen(ente) eq "CCARRARA"} { 
    # Per Udine e Gorizia e carrara non va fatto il controllo sul codice fiscale
} elseif {($coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CANCONA")  && $data_controllo < "20170516"} {
    # Per ancona non va fatto il controllo sul codice fiscale se pima del 15 maggio 2017
} else {
# Caso Standard

    if {$flag_errore_data_controllo == "f" && $data_controllo >= "20090801"} {
	if {[db_0or1row query "select natura_giuridica as natura_r
                                , cod_fiscale as fisc_r
                                , cod_piva as piva_r
                                , coalesce(stato_nas,'1') as stato_nas 
                             from coimcitt where cod_cittadino = :cod_responsabile"]} {
	    set fisc_r [string trim $fisc_r]
	    if {$stato_nas eq "1"} {
		if {$natura_r eq "F" && $fisc_r eq ""} {
		    append elenco_anomalie "<tr><td>Il responsabile non ha il <b>Codice Fiscale:</b> andare su Scheda 1.6 soggetti resp.</tr></td>"
		}
		if {$natura_r eq "G" && $piva_r eq ""} {
		    append elenco_anomalie "<tr><td>Il responsabile non ha la <b>Partita IVA:</b> andare su Scheda 1.6 soggetti resp.</tr></td>"
		}
	    }
	}
    }
}

if {$coimtgen(ente) eq "PFI" && $data_controllo >= "20160428"} {
    
    if {[db_0or1row query "
                 select locale
                   from coimgend
                  where cod_impianto = :cod_impianto
                    and flag_attivo = 'S'
                    and coalesce(locale,'') = '' 
                  limit 1"]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Tipo locale</b> su Scheda 4: Generatori</td></tr>"
    }
    
}

#if {($coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CJESI"  || $coimtgen(ente) eq "CSENIGALLIA") && $id_ruolo ==  "manutentore"} {
    
#    if { $data_controllo >= "20150101" &&
#	 [db_0or1row query "select a.locale
#                                , a.dpr_660_96
#                             from coimgend a
#                            where a.cod_impianto = :cod_impianto
#                              and (coalesce(locale,'') = '' or
#                                   coalesce(a.dpr_660_96,'') = '' )
#                              and flag_attivo = 'S'
#                              limit 1"]} { 
#	append elenco_anomalie "<tr><td>Inserire i campi <b>Tipo locale e Classif. DPR 660/96</b> su Scheda 4: Generatori</td></tr>"
	
#    }
#}

#rom08if {$coimtgen(ente) eq "PSA"} {}
#rom09if {$coimtgen(regione) eq "CAMPANIA"} {}#rom08 if ma non contenuto
#rom22 Aggiunta condizione su Napoli
#rom23 Aggiunta condizione su Rieti
#rom24 AGGIUNTA CONDIZIONE SU CASERTA
if {$coimtgen(regione) in [list "CAMPANIA" "BASILICATA"] && $coimtgen(ente) ni [list "PNA" "PRI" "PCE"]} {#rom09 Aggiunta if ma non il suo contenuto
    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"	

    if { [db_0or1row q "
                select 1 
                  from coimgend 
                 where cod_combustibile ='5' 
                   and cod_impianto = :cod_impianto 
                   and flag_attivo= 'S' 
                 limit 1"]} {	
	
	if {[string is space $pdr]
	    ||  [string is space $pod]
	} {
	    append elenco_anomalie "<tr><td>Inserire i campi <b>PDR e POD</b> in Ditte/Tecnici</tr></td>"
	}
	
    } else {
	
	if {[string is space $pod]
	} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>POD</b> in Ditte/Tecnici</td></tr>"
	}
    }
}
if {$coimtgen(ente) eq "PBT" && $data_controllo >= "20170320"} {
    
    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"
     
    
    if { [db_0or1row q "select 1 
                          from coimgend 
                         where cod_combustibile ='5' 
                           and cod_impianto = :cod_impianto 
                           and flag_attivo= 'S' 
                         limit 1"]} {
	
	if {[string is space $pdr]
	    ||  [string is space $pod]
	} {
	    append elenco_anomalie "<tr><td>Inserire i campi <b>PDR e POD</b> in Ditte/Tecnici>/td></tr>"
	}
    } else {
	
	if {[string is space $pod]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>POD</b> in Ditte/Tecnici</td></tr>"
	}
    }
}

#if {$coimtgen(ente) eq "CANCONA"} {
#    if {$data_controllo >= "20160101" && [db_0or1row q "select 1 
#                                                          from coimgend 
#                                                         where cod_combustibile ='5' 
#                                                           and cod_impianto = :cod_impianto 
#                                                           and flag_attivo= 'S' 
#                                                         limit 1"]} {
#	db_1row query "
#             select pdr, pod, foglio, mappale, subalterno
#               from coimaimp
#              where cod_impianto = :cod_impianto"
	
#	if {[string is space $pdr]
#	} {
#	    append elenco_anomalie "<tr><td>Inserire il campo <b>PDR</b> in Ditte/Tecnici</td></tr>"
#	}
#    }
#}

if {$coimtgen(regione) eq "CALABRIA" && $data_controllo >= "20160101"} {
 
    db_1row query "
             select pdr, pod, foglio, mappale, subalterno
               from coimaimp
              where cod_impianto = :cod_impianto"
	

    if {[db_0or1row q "select 1 
                         from coimgend 
                        where cod_combustibile ='5' 
                          and cod_impianto = :cod_impianto 
                          and flag_attivo= 'S' 
                        limit 1"]} {
	
	if {[string is space $pdr]
	    ||  [string is space $pod]
	} {
	    append elenco_anomalie "<tr><td>Inserire i campi <b>PDR e POD</b> in Ditte/Tecnici</td></tr>"	
	}
    } else {
	
	if {[string is space $pod]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>POD</b> in Ditte/Tecnici</td></tr>"
	}
    }
}


if {$coimtgen(ente) eq "PTA" && $data_controllo >= "20160101" } {
    
    db_1row query "
             select pdr
                  , pod
                  , foglio
                  , mappale
                  , subalterno
                  , cod_intestatario   as cod_int_contr
               from coimaimp
              where cod_impianto = :cod_impianto"
    
    if { [db_0or1row q "select 1 
                          from coimgend 
                         where cod_combustibile ='3' 
                           and cod_impianto = :cod_impianto 
                           and flag_attivo= 'S' 
                         limit 1"]} {
	
	if {[string is space $cod_int_contr]} {
	    append elenco_anomalie "<tr><td>Inserire il campo<b>Intestatario Contratto</b></td></tr>"
	}

	if {[string is space $pdr] ||  
	    [string is space $pod]} {
	    append elenco_anomalie "<tr><td>Inserire i campi <b>PDR e POD</b> in Ditte/Tecnici, <b>Intestatario</b> in Scheda 1.6 Soggetti resp.</td></tr>"
	} 
    } else { 
	
	if {[string is space $cod_int_contr]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Intestatario Contratto</b></td></tr>"
	}

	if {[string is space $pod]} {
	    append elenco_anomalie "<tr><td>Inserire il capo<b>POD</b> in  Ditte/Tecnici</td></tr>"
	}
    }
}
set flag_tipo_impianto [db_string q "select flag_tipo_impianto from coimaimp where cod_impianto = :cod_impianto"]

if {[db_0or1row query "select a.locale          
                            , a.dpr_660_96      
                            , a.cod_cost        
                            , a.data_costruz_gen
                            , a.cod_combustibile
                            , a.cod_utgi        
                            , a.tipo_foco       
                            , a.num_prove_fumi  
                            , a.pot_focolare_nom
                            , a.pot_focolare_lib
                            , a.pot_utile_lib
                            , a.pot_utile_nom   
                            , a.modello         
                            , a.data_installaz  
                            , a.cod_emissione   
                            , a.tiraggio        
                            , a.matricola       
                            , a.mod_funz
                            , a.num_circuiti
                            , a.pot_utile_nom_freddo
                            , a.rend_ter_max --rom02     
                            , a.flag_clima_invernale  --gac04
                            , a.flag_prod_acqua_calda --gac04
                            , a.flag_clim_est         --gac04
                            , flag_altro              --gac04
                            , a.tel_alimentazione     --rom05
                            , a.sorgente_lato_esterno --rom06
                            , a.fluido_lato_utenze    --rom06
                            , a.cod_flre              --rom06
                            , a.cod_tpco              --rom06
                         from coimgend a
                        where a.cod_impianto = :cod_impianto
                      --  and a.gen_prog = :gen_prog
                          and a.flag_attivo = 'S'
                        limit 1 "]} {
    if {($flag_clima_invernale eq "N" || $flag_clima_invernale eq "") && ($flag_prod_acqua_calda eq "N" || $flag_prod_acqua_calda eq "") && ($flag_clim_est eq "N" || $flag_clim_est eq "") && ($flag_altro eq "N" || $flag_altro eq "")} {#gac04 ggiunta if e suo contenuto
	append elenco_anomalie "<tr><td>Valorizzare a S&igrave; almeno uno dei seguenti campi <b>Produzione Acqua calda sanitaria, Climatizzazione invernale, Climatizzazione estiva, Altro</b> su Scheda 4: Generatori</td></tr>"
    }
    
    if {[string is space $flag_prod_acqua_calda] || [string is space $flag_clima_invernale]|| [string is space $flag_clim_est]} {
	append elenco_anomalie "<tr><td>Valorizzare ognuno dei seguenti campi <b>Produzione Acqua calda sanitaria, Climatizzazione invernale, Climatizzazione estiva, Altro</b> su Scheda 4: Generatori</td></tr>"
    }
    if {$flag_tipo_impianto == "R"} {
	if {[db_0or1row q "select 1 
                             from coimcomb
                            where upper(tipo) != 'S'
                              and cod_combustibile = :cod_combustibile"] && $dpr_660_96 eq ""} {#mic01 Aggiunta if e il suo contenuto
	    # Il campo DPR 660 è obbligatorio solo se il tipo combustibile non è solido
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Classif. DPR 660/96</b> su Scheda 4: Generatori</td></tr>"
	}
	#rom08if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PSA"} {}
	if {$coimtgen(regione) in [list "MARCHE" "CAMPANIA"]} {#rom08 if ma non il contenuto
	    set label_tipo_foco "Camera di combustione"
	    
	} else {
	    set label_tipo_foco "Tipo generatore"
	}

	if {[string is space $tipo_foco]} {                    
	    append elenco_anomalie "<tr><td>Inserire il campo <b>$label_tipo_foco</b> su Scheda 4: Generatori</td></tr>"
	}
	if {[string is space $num_prove_fumi]} {               
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Num. prove fumi</b> su Scheda 4: Generatori</td></tr>"
	}
	if {[string is space $pot_focolare_nom]} {              
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza nominale: focolare (kW)</b> su Scheda 4: Generatori</td></tr>"
	}
	if {[string is space $pot_utile_nom]} {                  
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza nominale: Utile (kW)</b> su Scheda 4: Generatori</td></tr>"
	}
	
	if {$coimtgen(regione) eq "MARCHE"} {
	    set label_tiraggio  "Evacuazione fumi"
	} else {
	    set label_tiraggio  "Tiraggio"
	}

	if {[string is space $tiraggio]} {                       
	    append elenco_anomalie "<tr><td>Inserire il campo <b>$label_tiraggio</b> su Scheda 4: Generatori</td></tr>"
	}
	if {[string is space $locale]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Tipo Locale</b> su Scheda 4: Generatori</td></tr>"
	}
#	if {[string is space $dpr_660_96]} {
#	    append elenco_anomalie "<tr><td>Inserire il campo <b>Classif. DPR 660/96</b> su Scheda 4: Generatori</td></tr>" 
#	}
	if {[string is space $cod_emissione]} {                 
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Scarico fumi</b> su Scheda 4: Generatori</td></tr>"
	}
	if {[string is space $rend_ter_max]} {#rom02 if e contenuto
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Rendimento termico utile a Pn max (%)</b> su Scheda 4: Generatori</td></tr>"
	};#rom02
    }
    if {$flag_tipo_impianto == "F"} {
	if {[string is space $num_circuiti]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Numero circuiti</b> su Scheda 4: Generatori</td></tr>"
	}
	#rom12if {$coimtgen(regione) ne "MARCHE"} {}
	#rom17 Aggiunta condizione su "FRIULI-VENEZIA GIULIA"
	#rom21 Aggiunta condizione su Palermo.
	if {!($coimtgen(regione) in [list "MARCHE" "BASILICATA" "FRIULI-VENEZIA GIULIA"]) && !($coimtgen(ente) in [list "PPA"])} {#rom12 Aggiunta if ma non il suo contenuto
	    #rom17if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {}#rom15 Aggiunta if ma non il suo contenuto
	    #rom25if {[string is space $pot_utile_nom_freddo]} {
	    #rom25append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza frigorifera: utile (kW)</b> su Scheda 4: Generatori</td></tr>"
	    #rom25}
	    #rom17{};#rom15
	    #rom25if {[string is space $pot_utile_nom]} {
	    #rom25append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza frigorifera: assorb.(kW)</b> su Scheda 4: Generatori</td></tr>"
	    #rom25}
	    #rom25if {[string is space $pot_focolare_nom]} {
	    #rom25append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza frigorifera: nominale (kW)</b> su Scheda 4: Generatori</td></tr>" 
	    #rom25}

	    if {[string is space $pot_utile_nom_freddo] &&
		[string is space $pot_focolare_nom]     &&
		[string is space $pot_focolare_lib]     &&
		[string is space $pot_utile_lib]} {#rom25 Aggiunta if e il suo contenuto
		append elenco_anomalie "<tr><td>Inserire i campi delle <b>Potenze frigorifere e/o Potenze termiche (kW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"
	    }

	    if {$coimtgen(regione) in [list "CAMPANIA"] || $coimtgen(ente) eq "PPA"} {#rom16 Aggiunta if e il suo contenuto
		if {[string is space $sorgente_lato_esterno]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Sorgente lato esterno</b> su Scheda 4: Generatori</td></tr>"
		}
		if {[string is space $cod_flre]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Fluido refrigerante</b> su Scheda 4: Generatori</td></tr>"
		}
		if {[string is space $cod_tpco]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Sistema di azionemento</b> su Scheda 4: Generatori</td></tr>"
		}	
	    }
	} else {

	    if {[string is space $pot_utile_nom_freddo] &&
		[string is space $pot_focolare_nom]     &&
		[string is space $pot_focolare_lib]     &&
		[string is space $pot_utile_lib]} {#sim05 if e suo contenuto

		append elenco_anomalie "<tr><td>Inserire i campi delle <b>Potenze frigorifere e/o Potenze termiche (kW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"

	    }
	    
#sim05	    if {[string is space $pot_utile_nom_freddo]} {
#sim05		append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza assorbita nominale (KW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"
#sim05	    }
#sim05	    if {[string is space $pot_focolare_nom]} {
#sim05		append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza frigorifera nominale (kW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"
#sim05	    }
#sim05	    if {[string is space $pot_focolare_lib]} {
#sim05		append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza termica nominale (kW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"
#sim05	    }
#sim05	    if {[string is space $pot_utile_lib]} {
#sim05		append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza assorbita nominale (kW)</b> su Scheda 4.4: Macchine frigorifere / Pompe di calore"
#sim05	    }
	    if {$coimtgen(regione) ne "FRIULI-VENEZIA GIULIA"} {#rom17 Aggiunta if ma non il suo contenuto
		if {[string is space $sorgente_lato_esterno]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Sorgente lato esterno</b> su  Scheda 4.4: Macchine frigorifere / Pompe di calore"
		}
		if {$coimtgen(ente) ne "PPA"} {#rom21bis
		    if {[string is space $fluido_lato_utenze]} {#rom06 aggiunta if e suo contenuto
			append elenco_anomalie "<tr><td>Inserire il campo <b>Fluido lato utenze</b> su  Scheda 4.4: Macchine frigorifere / Pompe di calore"
		    }
		};#rom21bis
		if {[string is space $cod_flre]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Fluido frigorigeno</b> su  Scheda 4.4: Macchine frigorifere / Pompe di calore"
		}
		if {[string is space $cod_tpco]} {#rom06 aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire il campo <b>Sistema di azionemento</b> su  Scheda 4.4: Macchine frigorifere / Pompe di calore"
		}
	    };#rom17
	}
	if {[string is space $locale]} {
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Tipo Locale</b> su Scheda 4: Generatori</td></tr>"
	}
#	if {[string is space $dpr_660_96]} {
#	    append elenco_anomalie "<tr><td>Inserire il campo <b>Classif. DPR 660/96</b> su Scheda 4: Generatori</td></tr>" 
#	}
	#if {[string is space $cod_emissione] && $coimtgen(regione) ne "MARCHE"} {#rom03 condizione su marche
	#    append elenco_anomalie "<tr><td>Inserire il campo <b>Scarico fumi</b> su Scheda 4: Generatori</td></tr>"
	#}
    }
    if {$flag_tipo_impianto == "T"} {
	if {[string is space $pot_focolare_nom]} {              
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza nominale: focolare (kW)</b> su Scheda 4.5bis</td></tr>"
	}
#	if {[string is space $pot_utile_nom]} {                  
#	    append elenco_anomalie "<tr><td>Inserire il campo <b>Potenza nominale: Utile (kW)</b> su Scheda 4: Generatori</td></tr>"
#	}
	if {[string is space $tel_alimentazione]} {#rom05 aggiunta if e suo contenuto
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Alimentazione</b> su Scheda 4: Generatori</td></tr>"
	}
    }
    if {[string is space $cod_cost]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Costruttore</b> su Scheda 4: Generatori</td></tr>"
    }
#    if {[string is space $data_costruz_gen]} {       
#	append elenco_anomalie "<tr><td>Inserire il campo <b>Data costruzione</b> su Scheda 4: Generatori</td></tr>"
#    }
    if {[string is space $cod_combustibile]} {          
	append elenco_anomalie "<tr><td>Inserire il campo <b>Combustibile</b> su Scheda 4: Generatori</td></tr>"
    }
#gac03    if {[string is space $cod_utgi]} {                    
#gac03	append elenco_anomalie "<tr><td>Inserire il campo <b>Dest. d'uso</b> su Scheda 4: Generatori</td></tr>"
#gac03    }
    if {[string is space $modello]} {                      
	append elenco_anomalie "<tr><td>Inserire il campo <b>Modello</b> su Scheda 4: Generatori</td></tr>"
    }
    if {[string is space $data_installaz]} {                
	append elenco_anomalie "<tr><td>Inserire il campo <b>Data install</b> su Scheda 4: Generatori</td></tr>"
    }
    if {[string is space $matricola]} {                     
	append elenco_anomalie "<tr><td>Inserire il campo <b>Matricola</b> su Scheda 4: Generatori</td></tr>"
    }
    #gac01 aggiunta if se il tipo impianto è cogeneratore non devo inserire il campo fluido termovettore
    #rom05 tolta condizione su Teleriscalamento
    if {$flag_tipo_impianto ne "F"} {#gac01
	if {[string is space $mod_funz]} {                       
	    append elenco_anomalie "<tr><td>Inserire il campo <b>Fluido termovettore </b> su Scheda 4: Generatori</td></tr>"
	}
    };#gac01


    db_0or1row q "select b.cod_tpim
                       , b.unita_immobiliari_servite
                       , b.pdr
                       , b.pod 
                       , a.nome
                       , a.cognome
                       , a.natura_giuridica
                       , flag_resp
                       , a.indirizzo 
                       , a.comune
                       , a.provincia
                       , a.cap
                       , a.telefono
                       , a.cellulare
                       , a.fax
                       , a.email
                       , a.pec
                       , b.data_libretto
                       , b.cod_proprietario --rom04
                       , b.tipologia_generatore --rom11
                       , b.flag_ibrido          --rom11
                    from coimaimp      b
                    left join coimcitt a
                      on a.cod_cittadino = b.cod_responsabile
                   where b.cod_impianto  = :cod_impianto";#rom13


    
    #gac02 aggiunti campi scheda 1bis: Dati generali
    if {$coimtgen(regione) eq "MARCHE"} {
	#conduttore
	#sim01 if {[db_string q "select potenza_utile from coimaimp where cod_impianto = :cod_impianto" -default "0"] > "232"} {
	#sim01    set conduttore [db_0or1row q "select 1
        #sim01                                    from coimcondu a
        #sim01                               left join coimaimp  b on b.cod_conduttore = a.cod_conduttore
        #sim01                                   where b.cod_impianto = :cod_impianto"]
	#sim01    if {$conduttore == "0"} {
	#sim01	append elenco_anomalie "<tr><td>Inserire dati del <b>Conduttore</b> su Scheda 1Bis: Dati Generali</td></tr>"
	#sim01    }
	#sim01 }

	#responsabile
#rom13	db_0or1row q "select b.cod_tpim
#rom13                    , b.unita_immobiliari_servite
#rom13                    , b.pdr
#rom13                    , b.pod 
#rom13                    , a.nome
#rom13                    , a.cognome
#rom13                    , a.natura_giuridica
#rom13                    , flag_resp
#rom13                    , a.indirizzo 
#rom13                    , a.comune
#rom13                    , a.provincia
#rom13                    , a.cap
#rom13                    , a.telefono
#rom13                    , a.cellulare
#rom13                    , a.fax
#rom13                    , a.email
#rom13                    , a.pec
#rom13                    , b.data_libretto
#rom13                    , b.cod_proprietario --rom04
#rom13                    , b.tipologia_generatore --rom11
#rom13                    , b.flag_ibrido          --rom11
#rom13	                from coimaimp b
#rom13                 left join coimcitt a
#rom13                   on a.cod_cittadino = b.cod_responsabile
#rom13                where b.cod_impianto = :cod_impianto"

	#rom20 Tolta condizione su && $flag_tipo_impianto ne "F"
	if {[string is space $cod_tpim]} {
	    append elenco_anomalie "<tr><td>Inserire <b>Tipologia impianto</b> su Scheda 1Bis: Dati Generali</td></tr>"
	}
	#rom20 Tolta condizione su && $flag_tipo_impianto ne "F"
	if {[string is space $unita_immobiliari_servite]} {
	    append elenco_anomalie "<tr><td>Inserire campo <b>Unità immobiliari servite</b> su Scheda 1Bis: Dati Generali</td></tr>"
	}
	
#	if {[string is space $pdr] && $flag_tipo_impianto ne "F"} {
#	    if {$cod_combustibile ne "3"} {#gli impianti a gasolio o del freddo non hanno il pdr obbligatorio
#		append elenco_anomalie "<tr><td>Inserire campo <b>PDR</b> su Scheda 1Bis: Dati Generali</td></tr>"
#	    }	
#	}
#	if {[string is space $pod]} {
#	    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
#       }

	if {$caller ne "cimp"} {#sim02
#rom07	if {![string equal $pdr ""]} {
#	    if {[db_0or1row query "select 1
#                                     from coimaimp
#                                     where pdr = :pdr
#                                       and cod_impianto != :cod_impianto --deve essere un pdr diverso da se stesso
#                                     limit 1"] == 1} {
#		if {[string equal $pod ""]} {
#		    if {[db_0or1row q "select 1
#                                            from coimcomb
#                                            where tipo = 'G'
#                                              and cod_combustibile = :cod_combustibile"] == 1} {
#			append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
#		    }		    
#		    if {$flag_tipo_impianto eq "F"} {
#			append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
#		    }
#		}
#	    }
#rom07	}
	    
	    if {![string equal $pdr ""]} {#rom07 if e suo contenuto
		if {[db_0or1row query "select 1
                                         from coimaimp
                                        where pdr = :pdr
                                          and cod_impianto != :cod_impianto --deve essere un pdr diverso da se stesso
                                        limit 1"] == 1} {
		    if {[string equal $pod ""]} {
			if {[db_0or1row q "select 1
                                             from coimcomb
                                            where tipo = 'G'
                                              and cod_combustibile = :cod_combustibile"] == 1} {
			    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
			}
			if {$flag_tipo_impianto eq "F"} {
			    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
			}
		    }
		}
	    }
	    
	    if {[string equal $pdr ""]} {#rom07 if e suo contenuto
		if {[string equal $cod_combustibile "5"]} {
		    append elenco_anomalie "<tr><td>Inserire campo <b>PDR</b> su Scheda 1Bis: Dati Generali</td></tr>"
		}
	    }
	    
	    if {[string equal $pod ""]} {#rom07 if e suo contenuto
		if {![db_0or1row q "select 1
                              from coimcomb
                             where tipo = 'G'
                               and cod_combustibile = :cod_combustibile"]} {
		    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
		}
		if {$cod_combustibile in [list "4" "21"]} {#rom10 Aggiunta if e suo contenuto
		    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
		}
		if {$flag_tipo_impianto eq "F"} {
		    append elenco_anomalie "<tr><td>Inserire campo <b>POD</b> su Scheda 1Bis: Dati Generali</td></tr>"
		}
	    }

	};#sim02

	#ric01 Aggiunta condizione su natura_giuridica
	if {[string is space $nome] && $natura_giuridica ne "G"} {
            append elenco_anomalie "<tr><td>Il responsabile non ha il <b>Nome</b> andare su Scheda 1Bis: Dati Generali</td></tr>"
        }
        if {[string is space $cognome]} {
            append elenco_anomalie "<tr><td>Il responsabile non ha il <b>Cognome</b> andare su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $natura_giuridica]} {
            append elenco_anomalie "<tr><td>Inserire campo <b>Natura Giuridica</b> su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $indirizzo]} {
            append elenco_anomalie "<tr><td>Inserire campo <b>Indirizzo</b> su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $comune]} {
            append elenco_anomalie "<tr><td>Inserire campo <b>Comune</b> su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $provincia]} {
            append elenco_anomalie "<tr><td>Inserire campo <b>Provincia</b> su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $cap]} {
	    append elenco_anomalie "<tr><td>Inserire campo <b>C.A.P.</b> su Scheda 1Bis: Dati Generali</td></tr>"
        }
	if {[string is space $telefono] && [string is space $cellulare] && [string is space $fax] && [string is space $email] && [string is space $pec]} {
#            append elenco_anomalie "<tr><td>Inserire almeno uno dei seguenti campi  <b>Telefono, Cellulare, Fax, Email e Pec</b> su Scheda 1Bis: Dati Generali</td></tr>"
            append elenco_anomalie "<tr><td>Inserire su Scheda 1Bis: Dati Generali almeno uno dei seguenti campi <b>numero di telefono, Cellulare, Fax, Email e Pec</b> del responsabile utilizzando il menù cerca</td></tr>"

        }
	
	if {$caller ne "cimp"} {#sim02
	    if {[string is space $data_libretto]} {
		append elenco_anomalie "<tr><td>Inserire campo <b>Data e Tipologia  intervento</b> su Scheda 1.1</td></tr>"
	    }

	    if {[string is space $tipologia_generatore]} {#rom11 Aggiunta if e il suo contenuto
		append elenco_anomalie "<tr><td>Inserire campo <b>Tipologia generatore</b> su Scheda 1.5"
	    }
	    
	    if {$flag_tipo_impianto in [list "R" "F"] && [string is space $flag_ibrido]} {#rom11 Aggiunta if e il suo contenuto
		append elenco_anomalie "<tr><td>Inserire campo <b>Ibrido / Policombustibile / Generatori misti</b> su Scheda 1.5"
	    }
	    
	};#sim02
	if {[string is space $cod_proprietario]} {
	    append elenco_anomalie "<tr><td>Inserire campo <b>Proprietario</b> su Scheda 1Bis: Dati Generali</td></tr>"
	}
    } else {#rom13 Aggiunta else e il suo contenuto
	
	if {$caller ne "cimp"} {#rom13 copio i controlli fatti da sim02 per le Marche per data_libretto e tipologia_generatore
	    if {[string is space $data_libretto]} {
		append elenco_anomalie "<tr><td>Inserire campo <b>Data e Tipologia  intervento</b> su Scheda 1.1</td></tr>"
	    }

	    if {[string is space $tipologia_generatore]} {
		append elenco_anomalie "<tr><td>Inserire campo <b>Tipologia generatore</b> su Scheda 1.5"
	    }
	    
	    if {$coimtgen(ente) eq "CBENEVENTO"} {#rom14 Aggiunta if e contenuto
		if {[string is space $telefono] &&
		    [string is space $cellulare] &&
		    [string is space $fax] &&
		    [string is space $email] &&
		    [string is space $pec]} {
		    append elenco_anomalie "<tr><td>Inserire su Scheda 1.6: Soggeti resp. almeno uno dei seguenti campi <b>numero di telefono, Cellulare, Fax, Email e Pec</b> del responsabile utilizzando il menù cerca</td></tr>"

		}
	    }

	}
    }

} else {
    append elenco_anomalie "<tr><td>Inserire almeno un Generatore attivo su <b>Scheda 4: Generatori</b></td></tr>"
}

if {$flag_obbligo_dati_catastali eq "T"} {#sim03 if e suo contenuto

    db_0or1row q "select foglio
                       , mappale
                       , subalterno
                       , cat_catastale
                       , sezione
                    from coimaimp 
                   where cod_impianto = :cod_impianto"

    if {[string is space $foglio]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Foglio</b> su Scheda 1.2: Ubicazione</td></tr>"
    }

    if {[string is space $mappale]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Mappale</b> su Scheda 1.2: Ubicazione</td></tr>"
    }

    if {[string is space $subalterno]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Subalterno</b> su Scheda 1.2: Ubicazione</td></tr>"
    }

    if {[string is space $cat_catastale]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Tipo Catasto</b> su Scheda 1.2: Ubicazione</td></tr>"
    }

    if {[string is space $sezione]} {
	append elenco_anomalie "<tr><td>Inserire il campo <b>Sezione</b> su Scheda 1.2: Ubicazione</td></tr>"
    }
}

set id_utente [iter_get_id_utente]

#if {$id_utente eq "sandro"} {
#    set elenco_anomalie ""
#}


if { $caller == "cimp"} {
    iter_get_coimtgen
    set flag_ente    $coimtgen(flag_ente)
    set denom_comune $coimtgen(denom_comune)
    set sigla_prov   $coimtgen(sigla_prov)
    
    switch $flag_ente {
	"P" {set directory "$flag_ente$sigla_prov"}
	"C" {
	    regsub -all " " $denom_comune "" denom_comune
	    set directory "$flag_ente$denom_comune"
	}
	default {set directory "standard"}
    }
    set redirect ../srcpers/$directory/$redirect
}

set messaggio_iniziale "";#sim04
if {$elenco_anomalie eq ""} {
    if {$caller == "dimp" || $caller == "cimp" || $caller == "dope"} {
	    
	if { $caller == "cimp" || $caller == "dope"} {
	    set redirect $redirect&is_controllo_ok=t
	}
	ad_returnredirect -html "$redirect"
    } else {
	set messaggio_iniziale "<tr><td></td></tr>";#rom02
	append elenco_anomalie "<tr><td>Tutti i <b>campi obbligatori</b> sono stati compilati.</td></tr>"
    }    
} else {
    
    if {$funzione eq "I" || $caller eq "warning"} { 
	if {$caller eq "dimp" || $caller eq "dope"} {
	    set messaggio_iniziale "<tr><td align=center><font size=2 color=red><b>Prima di inserire RCEE o moduli regionali bisogna inserire i seguenti campi:<b></font></td><tr>"
	} elseif {$caller eq "cimp"} {
	    set cod_manutentore [iter_check_uten_manu $id_utente]
	    set gest_prog       "coimcimp-gest"
	    if {$cod_manutentore ne ""} {
		set link_aggiungi ""
	    } else {
		set link_aggiungi "<tr><td align=center>aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&nome_funz=cimp&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto extra_par nome_funz_caller flag_cimp]\">Mancata ispezione</a></td><tr>"
	    }
	    
	    set messaggio_iniziale "$link_aggiungi<tr><td align=center><font size=2 color=red><b>Prima di inserire Rapporti di Ispezione bisogna inserire i seguenti campi:<b></font></td><tr>"
	} else {
	    set messaggio_iniziale "<tr><td align=center><font size=2 color=red><b>Prima di inserire RCEE o moduli regionali e Rapporti di Ispezione bisogna inserire i seguenti campi:<b></font></td><tr>"
	}
	
    } else {
	if { $caller == "cimp"  || $caller == "dope"} {
	    set redirect $redirect&is_controllo_ok=t
	}
	ad_returnredirect -html "$redirect&is_only_view=t"
    }
} 

ad_return_template


