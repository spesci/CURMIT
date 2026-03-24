ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimdimp"
    @author          Adhoc
    @creation-date   13/03/2006

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimdimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =================================================================================
    rom10 25/11/2024 Su Frosinone se manca dfm i manutentori non possono inserire rcee.

    rom09 31/10/2024 Se siamo in ambiente demo non blocco inserimento rcee

    rom08 31/07/2024 Palermo ha chiesto che i manutentori con uno strumento analizzatore scaduto non
    rom08            possano inserire rcee. Sandro ha detto che deve valere solo per il caldo.

    rom07 23/05/2024 Per Terra di Lavoro di Caserta gestiti i programmi per i Ravvedimenti Operosi.

    but02 08/05/2024  Su richiesta di Sandro Per i soli impianti di teleriscaldamento al momento
    but02             dell'inserimento dell'RCEE la DFM non deve essere obbligatoria.
    
    rom06 20/09/2023 Su indicazione di Sandro anche Regione Campania non puo' inserire rcee se
    rom06            e' presente un avviso di ispezione con il flag blocca_rcee a t.

    rom05 19/06/2023 Corretto intervento di but01: per gli impianti del freddo il controllo va fatto solo
    rom05            sui generatori con potenza superiore ai 12 KW.
    
    but01 16/06/2023 Su richiesta di Sandro e della Regione marche metto bloccante se non esistono DFM
    
    mic01 28/07/2022 Allineato ucit a nuovo cvs e riportate modifiche fatte sul vecchio cvs:
    mic01            Riportata modifica rom02 da iter-dev:
    mic01            Se e' attiva la gestione della targa e questa manca sull'impianto non do
    mic01            la possibilita' di aggiungere l'RCEE ma blocco con un messaggio di errore.
    mic01            Il controllo non deve essere fatto per Regione Calabria.
    mic01            Riportata modifica rom01 da iter-dev:
    mic01            Modificate if e controlli fatti sulle varie Province di UCIT. Ora la
    mic01            condizione usata e' sulla regione Friuli.

    rom04 04/11/2022 Gestito per Palermo il no wallet del freddo.

    rom03 08/11/2021 Su indicazione di Sandro solo le Marche non possono inserire un RCEE se
    rom03            e' presente un avviso di ispezione con il flag blocca_rcee a t.

    rom02 12/01/2021 Le particolarita' della Provincia di Salerno ora sono sostituite dalla condizione
    rom02            su tutta la Regione Campania.

    sim10 02/04/2020 Le DAM per gli utenti amministratori non devo avere i controlli sulla Regione Marche

    sim09 20/01/2019 Deciso con Sandro che se l'ente è diverso dalle Marche e l'utente è un manutentore
    sim09            devo comunque entrare nel warninig.

    sim08 05/12/2019 Aggiunto solo per le Marche anche il no wallet del freddo
    
    gac01 20/11/2019 Ora il programmi degli rct prima di passare dal loro gest devono effettuare i
    gac01            controlli nel warning.

    sim07 10/06/2019 Se esite un appuntamento per una ispezione sull'impianto con il flag_blocca_rcee a
    sim07            true impedisco l'inserimento degli Rcee

    sim06 13/04/2018 Anche iterprug,iterprgo,iterprts e iterprpn devono avere momentaneamente
    sim06            la possibilità di inserire RCEE col bollino anche col wallet attivo

    sim05 05/05/2017 Solo per Firenze si può inserire sia un rct standard che un rct legna 

    sim04 05/04/2017 Se la dichiarazione è riferita ad un impianto con teleriscaldamento
    sim04            devo puntare al programma coimdimp-r3-gest.

    gab01 22/02/2017 Se la dichiarazione è riferita ad un generatore con combustibile a legna
    gab01            devo puntare al programma coimdimp-1b-gest (solo se il flag della tabella
    gab01            coimtgen per la gestione della legna è T).

    sim03 25/10/2016 Anche per gli amministratori di iterprrc sarà presente il flag_tracciato NW
    sim03            per inserire rct senza il portafoglio

    sim02 18/10/2016 Solo per taranto ci sarà anche il flag_tracciato NW che è rct senza
    sim02            il portafoglio

    sim01 17/03/2016 Per gli storni ho aggiunto la gestione del freddo.

    nic01 17/09/2015 Aggiunto link per gestione dichiarazioni di avvenuta manutenzione per
    nic01            la regione Marche.
} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {flag_no_link         "F"}
    {url_gage             ""}
    {cod_opma             ""}
    {data_ins             ""}
    {cod_impianto_est_new ""}
    {flag_tracciato       ""}
    {gen_prog             ""}
    {tabella              ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

if {[exists_and_not_null tabella]} {
    set stn "_stn"
} else {
    set stn " "
    set tabella ""
}


#sim03 scommentato id_utente
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]


iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]
set link_nw $link
set pack_key [iter_package_key]
set pack_dir [apm_package_url_from_key $pack_key]
append pack_dir "src"

set db_name [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""];#rom09

set directory ""
#switch $flag_ente {
#    "P" {set directory "$flag_ente$sigla_prov"}
#    "C" {set directory "$flag_ente$denom_comune"}
#    default {set directory "standard"}
#}

if {$funzione != "I" && ![exists_and_not_null tabella]} {
    if {[db_0or1row sel_dimp_flag_tracciato ""] == 0} {
	iter_return_complaint "Modello non trovato"
	return
    }
}

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} { #mic01 aggiunta if e suo contenuto
    set flag_gest_targa $coimtgen(flag_gest_targa)
    if {$flag_gest_targa eq "T"} {
	
	if {![db_0or1row q "select 1
                          from coimaimp
                         where cod_impianto = :cod_impianto
                           and targa is not null"]
	    && $coimtgen(regione) ne "CALABRIA"} {
	    
#	    iter_return_complaint "
#            Funzione impossibile per impianti senza targa."
#	    ad_script_abort
	}
	
    }
}

set cod_manu [iter_check_uten_manu $id_utente];#rom08
if {$coimtgen(ente) eq "PPA" && $cod_manu ne "" && $flag_tracciato eq "R1"} {#rom08 Aggiunta if e contenuto
    if {[db_0or1row q "select 1
                         from coimstru_manu
                        where cod_manutentore = :cod_manu
                          and dt_tar_strum    < to_char(current_date - interval '1 year', 'yyyy-mm-dd')::date
                          and dt_tar_strum    is not null
                          and tipo_strum      = '0'
                          and is_active_p     = 't'"]} {
	iter_return_complaint "Impossibile procedere all'inserimento del RCEE in quanto sono presenti uno o più analizzatori attivi scaduti."
	return
    }
}

#rom06 Modificata if per condizione su CAMPANIA
#rom09 Aggiunta parte su db_name
if {$coimtgen(regione) in [list "MARCHE" "CAMPANIA"] && $db_name ne "iter2019-portal-dev"} {#rom03 Aggiunta if ma non il suo contenuto
    if {$funzione == "I" && [db_0or1row q "select 1 
                                             from coiminco
                                            where cod_impianto     = :cod_impianto 
                                              and flag_blocca_rcee = 't' 
                                            limit 1"]} {
	iter_return_complaint "Impossibile procedere all'inserimento del RCEE sull'impianto in quanto è stato spedito un avviso di ispezione"
	return
    }
};#rom03

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

if {$flag_tracciato == "F" && [string equal $gen_prog ""] && $funzione == "I"} {

    set flag_conf "S"
    # set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

    set form_name "coimdimp"
    form create $form_name \
	
    set link_tab [iter_links_form $cod_impianto $tabella $nome_funz_caller $url_list_aimp $url_aimp $extra_par]
    set dett_tab [iter_tab_form $cod_impianto]
    
    set nome_funz "datigen"
    set link2     "nome_funz=$nome_funz&nome_funz_caller=impianti&cod_impianto=$cod_impianto&tabella=$tabella"

} else {

    set flag_conf "N"

    db_1row sel_aimp_potenza "select potenza
                                   , flag_tipo_impianto --sim01
                                from coimaimp
                               where cod_impianto = :cod_impianto"
    
    set cod_manu [iter_check_uten_manu $id_utente];#sim03

    #sim03 aggiunto || per PRC
    #sim06 aaggiunto || per PUD PGO PTS PPN
#mic01if {$coimtgen(ente) eq "PTA" || ($coimtgen(ente) eq "PRC" && $cod_manu eq "" ) ||
#	$coimtgen(ente) eq "PUD" ||
#	$coimtgen(ente) eq "PGO" ||
#	$coimtgen(ente) eq "PTS" ||
#	$coimtgen(ente) eq "PPN" 
#mic01} {};#sim02
    #mic01 Aggiunta condizione unica su regione Friuli.
    if {$coimtgen(ente) eq "PTA" || ($coimtgen(ente) eq "PRC" && $cod_manu eq "" ) ||
	$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"
    } {
	set tipologia_costo ""	    
	if {$cod_dimp ne ""} {
	    db_0or1row  q "select tipologia_costo
                       from coimdimp 
                      where cod_dimp = :cod_dimp"
	}

	if {$tipologia_costo ne "LM" && $flag_tracciato eq "R1" && $funzione ne "I"} {;#sim02
	    set flag_tracciato "NW"
	}
    }

    if {[exists_and_not_null tabella]} {
	if {$flag_tipo_impianto eq "F"} {#sim01: Aggiunta if e suo contenuto
	    set flag_tracciato "R2"
	} elseif {$flag_tipo_impianto eq "T"} {;#sim04
	    set flag_tracciato "R3"
	}  elseif {$flag_tipo_impianto eq "C"} {#rom01 
	    set flag_tracciato "R4"
	} else {
	    if {$flag_tracciato ne "1B"} {;#sim05
		set flag_tracciato "R1"
	    };#sim05
	}
	
	#sim01 if {$potenza >= 35} {
	#sim01    set flag_tracciato "F"
	#sim01    set flag_tracciato "R1"
	#sim01 } else {
	#sim01    set flag_tracciato "G"
	#sim01    set flag_tracciato "R1"
	#sim01 }
        
    }
    
    # ns_log notice "prova dob seleziona tracciato $nome_funz $nome_funz_caller "

    if {$coimtgen(flag_gest_rcee_legna) eq "T"} {;#gab01 aggiunta if e suo contenuto                       
	if {$funzione ne "I"} { 
	    db_0or1row q "select gen_prog 
                            from coimdimp 
                           where cod_dimp = :cod_dimp"
	}
    
	if {$gen_prog ne ""} {;#gab01
	    set cond_legna  [db_0or1row q "select gen_prog
                                             from coimgend
                                            where cod_impianto     = :cod_impianto
                                              and gen_prog         = :gen_prog
                                              and cod_combustibile in ('6','12','112','211')"]
	} else {
	    set cond_legna  [db_0or1row q "select gen_prog
                                             from coimgend
                                            where cod_impianto     = :cod_impianto
                                              and cod_combustibile in ('6','12','112','211') limit 1"]
	}
    
	if {$cond_legna} {;#gab01 
	    set tipo_r1 "coimdimp-1b-gest"
	} else {
	    set tipo_r1 "coimdimp-rct-gest"
	}
    } else {
	set tipo_r1 "coimdimp-rct-gest"
    }

    #sim02 aggiunto NW
    #gab01 "R1"    {set return_url $pack_dir/$directory/coimdimp-rct-gest?$link}
    #sim04 aggiunto R3
    #sim05 aggiunto 1B usato da Firenze
    #rom01 aggiunto R4 per cogenerazione
    #sim09 aggiunta if ($coimtgen(regione) ne "MARCHE" && $cod_manu ne "")
    if {$coimtgen(regione) eq "MARCHE" || ($coimtgen(regione) ne "MARCHE" && $cod_manu ne "")} {
	set link [export_url_vars link];#gac01
	set caller "dimp";#gac01

	#gac01 modificato tutti i return_url per passare attraverso il coimaimp-warning
	#sim08 aggiunto la gestione del nowallet del freddo con flag_tracciato=NF
	switch $flag_tracciato {
	    "H"     {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-h-gest&$link&funzione=$funzione&caller=$caller}
	    "HB"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-hb-gest&$link&funzione=$funzione&caller=$caller}
	    "G"     {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-g-gest&$link&funzione=$funzione&caller=$caller}
	    "F"     {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-f-gest&$link&funzione=$funzione&caller=$caller}
	    "R1"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=$tipo_r1&$link&funzione=$funzione&caller=$caller}
	    "1B"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-1b-gest&$link&funzione=$funzione&caller=$caller}
	    "R2"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-fr-gest&$link&funzione=$funzione&caller=$caller}
	    "R3"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-r3-gest&$link&funzione=$funzione&caller=$caller}
	    "R4"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-r4-gest&$link&funzione=$funzione&caller=$caller}
	    "DA"    {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-dam-gest&$link&funzione=$funzione&caller=$caller}
	    "NW"    {set return_url $pack_dir/$directory/coimdimp-rct-nowallet-gest?$link_nw}
	    "NF"    {set return_url $pack_dir/$directory/coimdimp-fr-nowallet-gest?$link_nw}
	    "O1"    {set return_url $pack_dir/$directory/coimdimp-rct-rv-op-gest?$link_nw}
	    "O2"    {set return_url $pack_dir/$directory/coimdimp-fr-rv-op-gest?$link_nw}
	    default {set return_url $pack_dir/$directory/coimaimp-warning?cod_impianto=$cod_impianto&redirect=coimdimp-g-gest&$link&funzione=$funzione&caller=$caller}
	}
    } else {
	switch $flag_tracciato {
	    "H"     {set return_url $pack_dir/$directory/coimdimp-h-gest?$link}
	    "HB"    {set return_url $pack_dir/$directory/coimdimp-hb-gest?$link}
	    "G"     {set return_url $pack_dir/$directory/coimdimp-g-gest?$link}
	    "F"     {set return_url $pack_dir/$directory/coimdimp-f-gest?$link}
	    "R1"    {set return_url $pack_dir/$directory/$tipo_r1?$link}
	    "1B"    {set return_url $pack_dir/$directory/coimdimp-1b-gest?$link}
	    "R2"    {set return_url $pack_dir/$directory/coimdimp-fr-gest?$link}
	    "R3"    {set return_url $pack_dir/$directory/coimdimp-r3-gest?$link}
	    "R4"    {set return_url $pack_dir/$directory/coimdimp-r4-gest?$link}
	    "DA"    {set return_url $pack_dir/$directory/coimdimp-dam-gest?$link}
	    "NW"    {set return_url $pack_dir/$directory/coimdimp-rct-nowallet-gest?$link}
	    "O1"    {set return_url $pack_dir/$directory/coimdimp-rct-rv-op-gest?$link_nw}
	    "O2"    {set return_url $pack_dir/$directory/coimdimp-fr-rv-op-gest?$link_nw}
	    default {set return_url $pack_dir/$directory/coimdimp-g-gest?$link}
	}

	#rom02if {$coimtgen(ente) eq "PSA" && $flag_tracciato eq "NF"} {}
	#rom04 Aggiunta condizione su PALERMO
	if {($coimtgen(regione) eq "CAMPANIA" || $coimtgen(ente) eq "PPA")  && $flag_tracciato eq "NF"} {#rom02 if ma non contenuto
	    set return_url $pack_dir/$directory/coimdimp-fr-nowallet-gest?$link
	}
	

    }

    if {$coimtgen(regione) eq "MARCHE" && [iter_check_uten_manu $id_utente] eq "" && $flag_tracciato eq "DA"} {#sim10 if e suo contenuto
	set return_url $pack_dir/$directory/coimdimp-dam-gest?$link_nw
    }

    #but01 Per regione marche se non esistono dfm mostro il messaggio bloccante: "Manca la DFM"
    #rom10 Aggiunta condizione su Provincia di Frosinone
    if {$coimtgen(regione) eq "MARCHE" || ($coimtgen(ente) in [list "PFR"] && $cod_manu ne "")} {#but01 aggiunta if e suo contenuto
	if {$funzione eq "I"} {

	    if {$flag_tipo_impianto != "F"} {#rom05 Aggiunta if ma non il suo contenuto
	    set ls_gen_att [db_list_of_lists q "select gen_prog
                                                     , gen_prog_est
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo  = 'S'"]
	    } else {#rom05 Aggiunta else e il suo contenuto

		set ls_gen_att [db_list_of_lists q "select gen_prog
                                                     , gen_prog_est
                                                  from coimgend
                                                 where cod_impianto = :cod_impianto
                                                   and flag_attivo  = 'S'
                                                   and greatest(pot_focolare_nom, pot_focolare_lib) >= '12'"]
	    }
		
	    foreach gen_att $ls_gen_att {
		util_unlist $gen_att gen_prog_att gen_prog_est_att
		
		if {![db_0or1row q "select 1 
                                      from coimdope_aimp a
                                         , coimdope_gend b
                                     where a.cod_impianto = :cod_impianto
                                       and a.cod_dope_aimp = b.cod_dope_aimp 
                                       and b.gen_prog     = :gen_prog_att
                                     limit 1"]} {
		    if {$flag_tipo_impianto != "T"} {#but02 aggiunto if e non suo contenuto
			
			iter_return_complaint "Manca la DFM sul generatore numero $gen_prog_est_att.
                                          Tornare indietro e aggiungere la DFM tramito l'apposito link."
		    };#but02
		}
	    }
	}
  };#but01

    
    ad_returnredirect $return_url
    # Claudio
    ad_script_abort
}
