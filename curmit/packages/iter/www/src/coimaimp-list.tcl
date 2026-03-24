ad_page_contract {
    Lista tabella "coimaimp"

    @author                  Giulio Laurenzi
    @creation-date           18/03/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimaimp-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    ric02 26/11/2024 MEV per regione Marche ordine 63/2022 punti 21 e 32.

    rom11 29/10/2024 Ricevo e uso il filtro ls_cod_aimp se valorizzato.

    rom10 14/06/2024 Valorizzo pack_dir che viene utilizzata sull'adp per fare link allo scarico xml

    rom09 28/03/2024 Aggiunti filtri che arrivano dal cruscotto iniziale.

    rom08 15/11/2023 Aggiunta funzione di cancellazione logica di un impianto per Comune di Salerno.

    ric01 27/06/2023 Sviluppi per regione marche per aggiunta criteri aggiuntivi.

    rom07 13/01/2023 Sviluppo per Palermo Energia: aggiunto filro "Per Soggetto presente nello storico RCEE".

    rom06 05/05/2022 Per un caso segnalato da un ente di Regione Marche il campo f_matricola potrebbe
    rom06            contenere i caratteri < e > quindi devo trattare il campo come html altrimenti
    rom06            le proc di controllo di OpenAcs bloccano il programma.
    
    rom05 10/10/2021 Aggiunto campo f_pod su richiesta di Regione Marche.

    rom04 20/09/2021 Per Regione Marche le potenze da mostrare sono differenti dallo standard e
    rom04            cambia il ragionamento in base alla tipologia di impianto.

    rom03 05/03/2021 Su segnalazione di Regione Marche vado a mostrare la somma delle potenze nominali
    rom03            utili dei generatori per gli impianti del caldo e cogenerazione. Sandro ha detto
    rom03            che per il momento non modifichiamo la parte del freddo e e teleriscaldamento.

    sim03 05/12/2019 Corretto le potenze e modificato la legenda dei tipi impianto per le marche

    rom02 08/03/2019 Aggiunti campi f_impianto_inserito, f_impianto_modificato, f_soggetto_modificato
    rom02            e f_generatore_sostituito. I campi nuovi servono per filtrare l'estrazione non
    rom02            solo per impianti inseriti o modificati ma anche per soggetti modificati e
    rom02            per generatori sostituiti.

    rom01 02/11/2018 Cliccando sul link "Selez." non vengo più indirizzato direttamente sull'impianto
    rom01            ma in una pagina intermedia "coimaimp-gest-messaggio-intermedio".
    rom01            Per il momento lo faccio solo per la Regione Marche, va chiesto a Sandro se 
    rom01            può andare bene per tutti.

    gab02 25/07/2017 Se l'utente è un manutentore non mostro le actions nella lista per gli impianti 
    gab02            in stato Da controllare.
    gab02            Inoltre gestisco l'aspetto grafico degli stati nuovi: Da controllare, Respinto

    ale01 27/03/2017 Eliminati alcuni nowrap per migliorare la visualizzazione su iPad

    san01 24/02/2016 Il filtro f_cod_utenza ora filtrerà sul campo pdr

    sim02 06/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim02            visualizzo il campo targa e non il cod impianto princ.

    gab01 02/05/2016 Modificato where_matr in modo che il filtro per matricola cerchi tutti
    gab01            i generatori e non solo il primo.
    gab01            Sandro conferma che nella lista continui ad essere visualizzato il primo
    gab01            generatore.
    gab01            Nicola ha modificato la label sul filtro ed ha dovuto modificare anche
    gab01            la ricerca per cod_cost (costruttore).

    nic03 12/02/2016 Gestito parametro coimtgen(flag_potenza)

    nic02 14/01/2016 Per la regione marche va estratta la potenza utile

    sim01 10/09/2014 Aggiunta del nuovo campo cod_impianto_princ

    nic01 13/08/2014 Bisogna rendere coerente il filtro sui modelli scaduti con la colonna
    nic01            esposta (RCT). Sandro mi ha detto di usare sempre data_scad_dich e non più
    nic01            to_date(add_months(a.data_ultim_dich, :valid_mod_h),'yyyy-mm-dd')
    nic01            anche quando data_scad_dich è null.
 
} { 
    {search_word          ""}
    {rows_per_page        ""}
    {caller               "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {receiving_element    ""}
    {last_cod_impianto    ""}

    {f_cod_impianto_est   ""}
    {f_cod_impianto_princ ""}
    {f_targa              ""}
    {f_resp_cogn          ""} 
    {f_resp_nome          ""} 
    {f_resp_cogn_rcee     ""}
    {f_resp_nome_rcee     ""}
    
    {f_comune             ""}
    {f_quartiere          ""}
    {f_cod_via            ""}
    {f_desc_topo          ""}
    {f_desc_via           ""}
    {f_civico_da          ""}
    {f_civico_a           ""}

    {f_cod_manu           ""}
    {f_manu_cogn          ""}
    {f_manu_nome          ""}

    {f_data_mod_da        ""}
    {f_data_mod_a         ""}
    {f_utente             ""}

    {f_potenza_da         ""}
    {f_potenza_a          ""}
    {f_data_installaz_da  ""}
    {f_data_installaz_a   ""}
    {f_flag_dichiarato    ""}
    {f_stato_conformita   ""}
    {f_cod_combustibile   ""}
    {f_cod_cost           ""}
    {f_cod_tpim           ""}
    {f_cod_tpdu           ""}
    {f_stato_aimp         ""}
    {f_mod_h              ""}
    {f_dpr_412            ""}
    {f_cod_utenza         ""}
    {f_pod                ""}
    {f_cod_impianto_old   ""}
    {f_matricola:html     ""}
    {conta_flag           ""}
    {f_da_data_verifica   ""}
    {f_a_data_verifica    ""}

    {url_citt             ""}
    {cod_cittadino        ""}

    {url_manu             ""}
    {cod_manutentore      ""}
    {cod_amministratore   ""}
    {f_riferimento        ""}
    {cerca_multivie       ""}
    {f_prov_dati          ""}
    {f_bollino            ""}
    {f_flag_tipo_impianto ""}
    {f_impianto_inserito     ""}
    {f_impianto_modificato   ""}
    {f_soggetto_modificato   ""}
    {f_generatore_sostituito ""}

    {f_ibrido                ""}
    {f_pagato                ""}
    {f_tprc                  ""}
    
    {f_da_data_scad          ""}
    {f_a_data_scad           ""}
    {f_dimp_peric            ""}
    {f_dimp_da_dt_ins        ""}
    {f_dimp_a_dt_ins         ""}

    {f_ls_cod_aimp           ""}

    {f_dich_conformita       ""}
    {f_dfm_manu              ""}
    {f_dfm_resp_mod          ""}
    
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

# if {$referrer == ""} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-LIST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-LIST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-LIST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
#   set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

set id_ruolo [db_string sel_ruolo "select id_ruolo from coimuten where id_utente = :id_utente"];#rom08

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_viario       $coimtgen(flag_viario)
set valid_mod_h       $coimtgen(valid_mod_h)
set mesi_evidenza_mod $coimtgen(mesi_evidenza_mod)
set flag_gest_targa   $coimtgen(flag_gest_targa);#sim02
set page_title      "Lista Impianti"

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
if {$coimtgen(regione) eq "MARCHE"} {#rom01 aggiunta if e suo contenuto / aggiunta else ma non il contentuo
    set gest_prog       "coimaimp-gest-messaggio-intermedio"
} else {
    set gest_prog       "coimaimp-gest"
};#rom01

set list_prog       "coimaimp-list"
set stor_prog       "coimaimp-st-list"
set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "responsabile"
set extra_par       [list rows_per_page        $rows_per_page \
  			  receiving_element    $receiving_element]

if {$conta_flag != "t"} {
    set link_conta      "<a href=\"$list_prog?conta_flag=t&[export_ns_set_vars url]\">Conta</a>"
} else {
    set link_conta ""
}
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]
set link_filter     [export_ns_set_vars url]
#[export_url_vars nome_funz]
set link_scar   [export_ns_set_vars url]

#rom10  Valorizzo pack_dir che viene utilizzata sull'adp per fare link allo scarico xml
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"

set url_list_aimp        [list [ad_conn url]?[export_ns_set_vars url]]
set url_list_aimp        [export_url_vars url_list_aimp]

if {$caller == "index"} {
    set link    "\[export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par  \]"

    if {$coimtgen(flag_verifica_impianti) eq "t"} {;#gab02 aggiunta if e contenuto 
	if {![string is space $cod_manutentore]} {
	    set actions {[
			  iter_get_coimtgen
			  if {$coimtgen(regione) eq "MARCHE"} {#rom01 aggiunta if e suo contenuto / aggiunta else ma non il contentuo
			      set gest_prog   "coimaimp-gest-messaggio-intermedio"
			      set link [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par]&caller=seleziona
			  } else {
			      set gest_prog       "coimaimp-gest"
			      set link    [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par]
			  }
			  set stor_prog       "coimaimp-st-list"
			  if {$stato eq "F"} {
			      set azione_t "<td nowrap></td>"
			  } else {
			      set azione_t "<td nowrap><a href=\"$gest_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\" >Selez.</a> | <a href=\"$stor_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\">Storico</a></td>"
			  }
			  return $azione_t ]}
	} else {
	    set actions "
                        <td nowrap><a href=\"$gest_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\" >Selez.</a> | <a href=\"$stor_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\">Storico</a></td>"
	}
    } elseif {[string equal $id_ruolo "admin"] &&
	      $coimtgen(ente) in [list "CSALERNO"]} {#rom08 Aggiunta elseif e il suo contenuto
	set actions "<td nowrap><a href=\"$gest_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\" >Selez.</a> &nbsp; <a href=\"$stor_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\">Storico</a> &nbsp; <a href=\"coimaimp-log-del?$link&$url_list_aimp\" class=\"link-button-2\" title=\"Cancella l'impianto\" onClick=\"return(confirm('Confermi la cancellazione?'));\">Cancella</a></td>"
	
    } else {;#gab02 aggiunta else
	set actions "
                    <td nowrap><a href=\"$gest_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\" >Selez.</a> &nbsp; <a href=\"$stor_prog?funzione=V&$link&$url_list_aimp\" class=\"link-button-2\">Storico</a></td>"	
    }
    set js_function ""
} else { 
    
    
    #sim01 set actions    [iter_select [list cod_impianto resp indir]]
    set actions           [iter_select [list cod_impianto resp indir cod_impianto_est]]
    set receiving_element [split $receiving_element |]
    #sim01: aggiunto [lindex $receiving_element 3] cod_impianto_princ
    set js_function       [iter_selected $caller [list \
			  [lindex $receiving_element 0] cod_impianto       \
			  [lindex $receiving_element 1] resp               \
			  [lindex $receiving_element 2] indir              \
			  [lindex $receiving_element 3] cod_impianto_princ \
						     ]]
}

set stato_col {
   [set colorestato "white"
    set colorefont  "black"
    set vstato "non definito" 
    if {$stato == "At"} {
	set colorestato "green"
        set vstato "At" 
        set colorefont  "white"
    }
    if {$stato == "D"} {
        set colorestato "yellow"
        set vstato "D"
        set colorefont  "black"
    }

    if {$stato == "An"} {
        set colorestato "red"
        set vstato "An"
        set colorefont  "black"
    }

    if {$stato == "N"} {
        set colorestato "black"
        set vstato "N"
        set colorefont  "white"
    }

    if {$stato == "R"} {
        set colorestato "black"
        set vstato "R"
        set colorefont  "white"
    }

    if {$stato == "Ch"} {
        set colorestato "black"
        set vstato "Ch"
        set colorefont  "white"
    }

    #gab02 tolto su richiesta di Sandro
    #if {$stato == "C"} {
    #    set colorestato "white"
    #    set vstato "C"
    #    set colorefont  "black"
    #}

    if {$stato == "F"} {;#gab02
        set colorestato "white"
        set vstato "Contr"
        set colorefont  "black"
    }

    if {$stato == "E"} {;#gab02
        set colorestato "red"
        set vstato "Resp"
        set colorefont  "black"
    }

    return "<td align=center bgcolor=$colorestato title=\"stato dell'impianto ( At= attivo, , An = annullato . Contr = da controllare da parte dell'ente ..)\"><font color=$colorefont>$vstato</font></td>"]
}

#inizio dpr74
set stato_imp {
   [set coloretipo "AZURE"
    set tipoimp "nd"
    iter_get_coimtgen;#sim03

    if {$flag_tipo_impianto == "R"} {
	set coloretipo "MAGENTA"
	set tipoimp "Ri"

	if {$coimtgen(regione) eq "MARCHE"} {#sim03 if e suo contenuto
	    set tipoimp "GT"
	}
	
    }
    if {$flag_tipo_impianto == "F"} {
	set coloretipo "LIGHTSKYBLUE"
	set tipoimp "Fr"

	if {$coimtgen(regione) eq "MARCHE"} {#sim03  if e suo contenuto
	    set tipoimp "GF"
	}


    }
    if {$flag_tipo_impianto == "C"} {
	set coloretipo "BEIGE"
	set tipoimp "Co"
	if {$coimtgen(regione) eq "MARCHE"} {#sim03  if e suo contenuto
	    set tipoimp "CG"
	}

    }
    if {$flag_tipo_impianto == "T"} {
	set coloretipo "ORANGE"
	set tipoimp "Te"
	if {$coimtgen(regione) eq "MARCHE"} {#sim03 if e suo contenuto
	    set tipoimp "SC"
	}

    }
    if {$coimtgen(regione) ne "MARCHE"} {#sim03
	return "<td align=center bgcolor=$coloretipo title=\"tipo impianto (RI - riscaldamento,  FR-  Gruppo Frigo, TE teleriscaldamento, Co cogenerazione)\">$tipoimp</font></td>"
    } else {#sim03 else e suo contenuto
	return "<td align=center bgcolor=$coloretipo title=\"tipo impianto (GT - riscaldamento,  GF -  Gruppo Frigo, SC - teleriscaldamento, CG - cogenerazione)\">$tipoimp</font></td>"
    }
       ]
}

#fine dpr74

set potenza_calc {
    [
     iter_get_coimtgen
     if {$coimtgen(regione) eq "MARCHE"} {
	 
	 db_0or1row q "select cod_tpim from coimaimp where cod_impianto = :cod_impianto"
	
	 if {$flag_tipo_impianto eq "R" || $flag_tipo_impianto eq "C"} {
	     db_1row q "select --rom03 coalesce(sum(pot_utile_nom),'0.00') as potenza_utile
                    --rom03 , coalesce(sum(pot_focolare_nom),'0.00') as potenza
                              coalesce(sum(pot_utile_nom),'0.00')    as potenza  --rom03
                         from coimgend
                        where cod_impianto = :cod_impianto
                          and flag_attivo = 'S'"

	 }
	 
	 if {$flag_tipo_impianto eq "F"} {
	     db_1row q "select coalesce(sum(pot_focolare_lib),'0.00') as potenza_utile
                             , coalesce(sum(pot_focolare_nom),'0.00') as potenza
                          from coimgend
                         where cod_impianto = :cod_impianto
                           and flag_attivo = 'S'"

	     #Prendo la maggiore tra la Potenza ferigorifera nominale totale e la Potenza termica nominale totale 
	     if {$potenza_utile > $potenza} {
		 set potenza $potenza_utile
	     }
	 }

	 if {$flag_tipo_impianto eq "T"} {
	     db_1row q "select coalesce(sum(pot_focolare_nom),'0.00') as potenza
                          from coimgend
                         where cod_impianto = :cod_impianto
                           and flag_attivo = 'S'"
	 } 
	 
	 set potenza [db_string q "select iter_edit_num(coalesce(:potenza,0.00),2)"]
     }
     set potenza "<td nowrap align=center><font color=red><b>$potenza</b></font></td>"
    
     return $potenza    
   ]
};#sim3

set nome_funz_citt [iter_get_nomefunz coimcitt-gest]


if {$flag_gest_targa eq "F"} {#sim02: aggiunta if e suo contenuto
    set col_cod_impianto_princ [list cod_impianto_princ "Cod. imp. princ." no_sort  {l}]
} else {
    set col_cod_impianto_princ [list targa "Targa" no_sort  {l}]
}

if {$nome_funz_caller != $nome_funz_citt } {
    # imposto la struttura della tabella

    #sim01 aggiunto cod_impianto_princ
    #sim03 aggiunto la variabile al posto di <td nowrap align=center><font color=red><b>potenza</b></font></td>
    set table_def [list \
        [list action             "Azioni"           no_sort  $actions] \
        [list cod_impianto_est   "Codice"           no_sort  {l}] \
	$col_cod_impianto_princ \
        [list resp               "Responsabile"     no_sort  {<td align=centre><font color=black>$resp</font></td>}] \
	[list cod_fiscale        "Cod.Fisc./P.Iva"  no_sort  {l}] \
        [list matricola          "Matri.Gen."       no_sort  {<td align=centre><font color=red>$matricola</font></td>}] \
        [list comune             "Comune"           no_sort  {l}] \
        [list indir              "Indirizzo"        no_sort  {l}] \
        [list potenza            "Pot."             no_sort  $potenza_calc] \
        [list swc_mod_h          "RCT"              no_sort  {<td nowrap align=center title="rapporto di controllo tecnico (RCEE)">$swc_mod_h</td>}] \
        [list swc_rapp           "R.I."             no_sort  {<td nowrap align=center title="rapporto di ispezione">$swc_rapp</td>}] \
        [list swc_dichiarato     "Di"               no_sort  {<td nowrap align=center title="impianto dichiarato">$swc_dichiarato</td>}] \
        [list swc_conformita     "Co"               no_sort  {<td nowrap align=center title="Conforme">$swc_conformita</td>}] \
        [list swc_mod            "Mod."             no_sort  {<td nowrap align=center title="modificato da un utente">$swc_mod</td>}] \
        [list stato              "St"               no_sort  $stato_col] \
        [list flag_tipo_impianto "TI"               no_sort  $stato_imp] \
    ]
} else {

    set table_def [list \
        [list action             "Azioni"           no_sort  $actions] \
        [list cod_impianto_est   "Codice"           no_sort  {l}] \
        $col_cod_impianto_princ \
        [list resp               "Responsabile"     no_sort  {l}] \
	[list cod_fiscale        "Cod.Fisc./P.Iva"  no_sort  {l}] \
	[list ruolo              "Ruolo"            no_sort  {l}] \
        [list matricola          "Matr.Gen."        no_sort  {l}] \
        [list comune             "Comune"           no_sort  {l}] \
        [list indir              "Indirizzo"        no_sort  {l}] \
        [list potenza            "Pot."             no_sort  {r}] \
        [list swc_mod_h          "RCT"              no_sort  {<td nowrap align=center title="rapporto di controllo tecnico (RCEE)">$swc_mod_h</td>}] \
        [list swc_rapp           "R.I."             no_sort  {<td nowrap align=center title="rapporto di ispezione">$swc_rapp</td>}] \
        [list swc_dichiarato     "Di"               no_sort  {<td nowrap align=center title="impianto dichiarato">$swc_dichiarato</td>}] \
        [list swc_conformita     "Co"               no_sort  {<td nowrap align=center title="Conforme">$swc_conformita</td>}] \
        [list swc_mod            "Mod."             no_sort  {<td nowrap align=center title="modificato da un utente">$swc_mod</td>}] \
        [list stato              "St"               no_sort  $stato_col] \
        [list flag_tipo_impianto "TI"               no_sort  $stato_imp] \
    ]
}
# imposto la query SQL

#nic03 if {$coimtgen(regione) eq "MARCHE"} #nic02
if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#nic03 (cambiata if)
    set colonna_potenza "a.potenza_utile";#nic02
} else {#nic02
    set colonna_potenza "a.potenza"
};#nic02

if {![string equal $search_word ""]} {
    set f_resp_nome ""
} else {
    if {![string equal $f_resp_cogn ""]} {
	set search_word $f_resp_cogn
    }
}

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and b.cognome like upper(:search_word_1)"
}

if {[string equal $f_resp_nome ""]} {
    set where_nome ""
} else {
    set f_resp_nome_1 [iter_search_word $f_resp_nome]
    set where_nome  " and b.nome like upper(:f_resp_nome_1)"
}

#gab01 Per come sono state modificate le condizioni, ora devo usare una sola variabile
set where_gend "";#gab01

if {[string equal $f_matricola ""]} {
    set where_matr ""
} else {
    set f_matricola [iter_search_word $f_matricola]
    #gab01 set where_matr  " and upper(g.matricola) like upper(:f_matricola)"
    set where_matr  " and upper(matricola) like upper(:f_matricola)"
}

# imposto la condizione SQL per cod_costruttore
if {![string equal $f_cod_cost ""]} {
    #gab01 set where_cost " and g.cod_cost = :f_cod_cost"
    set where_cost " and cod_cost = :f_cod_cost"
} else {
    set where_cost ""
}

if {$where_matr ne "" || $where_cost ne ""} {#gab01: aggiunta if ed il suo contenuto
    #Nicola ha verificato che e' meglio andare sulla coimaimp (a.cod_impianto) perche'
    #la left join sulla coimgend fatta nella query isola solo i generatori attivi
    set where_gend " and a.cod_impianto in (select cod_impianto 
                                              from coimgend
                                             where 1 = 1
                                            $where_matr
                                            $where_cost
                                           )
                   "
}

if {![string equal $f_cod_impianto_est ""]} {
    set where_codimp_est " and a.cod_impianto_est = upper(:f_cod_impianto_est)"
} else {
    set where_codimp_est ""
}

if {![string equal $f_cod_impianto_princ ""]} {#sim01
    set where_codimp_princ " and h.cod_impianto_est = upper(:f_cod_impianto_princ)";#sim01
} else {;#sim01
    set where_codimp_princ "";#sim01
};#sim01

if {![string equal $f_targa ""]} {#sim02: aggiunta if e suo contenuto
    set where_targa " and upper(a.targa) = upper(:f_targa)"
} else {
    set where_targa ""
}

if {![string equal $f_mod_h ""]} {
    # se valorizzato con 1 seleziono gli impianti senza modello H
    # se valorizzato con 2 seleziono gli impianti con mod h scaduti
    switch $f_mod_h  {
	"1" {
	    set where_mod_h "and (select count(*)
                                    from coimdimp n
                                   where n.cod_impianto         = a.cod_impianto
                                  ) = 0" 
	}
	"2" {
	    #nic01 set where_mod_h "and to_char(add_months(a.data_ultim_dich, :valid_mod_h), 'yyyy-mm-dd') < to_char(current_date,'yyyy-mm-dd')" 
	    set where_mod_h "and a.data_scad_dich < current_date";#nic01
	}
	default {set where_mod_h ""}
    }
} else {
    set where_mod_h ""
}

if {![string equal $f_da_data_scad ""] || ![string equal $f_a_data_scad ""]} {#rom09 if, else e contenuto
    set where_data_scad "and a.data_scad_dich between :f_da_data_scad and :f_a_data_scad"
} else {
    set where_data_scad ""
}

set where_dimp_peric ""
if {[string equal $f_dimp_peric "t"]} {#rom09 if e contenuto
    set where_dimp_peric "and exists (select 1
                                        from coimdimp dimpp
                                       where a.cod_impianto = dimpp.cod_impianto
                                         and dimpp.data_ins between :f_dimp_da_dt_ins and :f_dimp_a_dt_ins
                                         and ( dimpp.prescrizioni is not null
                                            or dimpp.flag_status      = 'N')
                                     )"
}


if {![string equal $f_quartiere ""]} {
    set where_quartiere "and a.cod_qua = :f_quartiere"
} else {
    set where_quartiere ""
}

# imposto la condizione per gli impianti di un soggetto

if {![string equal $cod_cittadino ""]} {
    set nome_funz_citt [iter_get_nomefunz coimcitt-gest]
    set sogg_join   [db_map sogg_join]
    set where_sogg  [db_map where_sogg]
    set ruolo [db_map ruolo_citt]
} else {
    set nome_funz_citt ""
    set sogg_join  ""
    set where_sogg ""
    set ruolo          ""
}

# imposto la condizione SQL per il comune e la via
if {![string equal $f_comune ""]} {
    set where_comune "and a.cod_comune = :f_comune"
} else {
    set where_comune ""
}

if {![string equal $f_riferimento ""]} {
    set where_rife "and exists (select '1'
                                  from coimdimp f
                                 where f.riferimento_pag = :f_riferimento
                                   and f.cod_impianto = a.cod_impianto)"
} else {
    set where_rife ""
}

set col_numero  "lpad(a.numero, 8, '0')"
# se richiesta selezione per civico
if {![string equal $f_civico_da ""]} {
    set where_civico_da "and $col_numero >= lpad(:f_civico_da, 8, '0')"
} else {
    set where_civico_da ""
}
if {![string equal $f_civico_a ""]} {
    set where_civico_a "and $col_numero <= lpad(:f_civico_a, 8, '0')"
} else {
    set where_civico_a ""
}

set where_via ""
if {![string equal $f_cod_via ""]
&&  $flag_viario == "T"
} {
    set where_via "and a.cod_via = :f_cod_via $where_civico_da $where_civico_a"
    if {$cerca_multivie == "S"} {
	set col_numero_m  "lpad(m.numero, 8, '0')"
	if {![string equal $f_civico_da ""]} {
	    set where_civico_da_m "and $col_numero_m >= lpad(:f_civico_da, 8, '0')"
	} else {
	    set where_civico_da_m ""
	}
	if {![string equal $f_civico_a ""]} {
	    set where_civico_a_m "and $col_numero_m <= lpad(:f_civico_a, 8, '0')"
	} else {
	    set where_civico_a_m ""
	}
	set where_via "and ((a.cod_via = :f_cod_via and a.cod_comune = :f_comune $where_civico_da $where_civico_a) or :f_cod_via in (select m.cod_via from coim_multiubic m where m.cod_impianto = a.cod_impianto and m.cod_comune = :f_comune $where_civico_da_m $where_civico_a_m))"
	set where_comune ""
    }
} 

if {(![string equal $f_desc_via ""]
||   ![string equal $f_desc_topo ""])
&&  $flag_viario == "F"
} {
    set f_desc_via1  [iter_search_word $f_desc_via]
    set f_desc_topo1 [iter_search_word $f_desc_topo]
    set where_via "and a.indirizzo like upper(:f_desc_via1)
                   and a.toponimo  like upper(:f_desc_topo1) $where_civico_da $where_civico_a"
    if {$cerca_multivie == "S"} {
	set col_numero_m  "lpad(m.numero, 8, '0')"
	if {![string equal $f_civico_da ""]} {
	    set where_civico_da_m "and $col_numero_m >= lpad(:f_civico_da, 8, '0')"
	} else {
	    set where_civico_da_m ""
	}
	if {![string equal $f_civico_a ""]} {
	    set where_civico_a_m "and $col_numero_m <= lpad(:f_civico_a, 8, '0')"
	} else {
	    set where_civico_a_m ""
	}
	set where_via "and ((a.indirizzo like upper(:f_desc_via1)
                       and   a.toponimo  like upper(:f_desc_topo1)
                       and   a.cod_comune = :f_comune $where_civico_da $where_civico_a)) or upper(:f_desc_via1) in (select upper(m.indirizzo) from coim_multiubic m  where m.cod_impianto = a.cod_impianto and upper(m.toponimo) = upper(:f_desc_topo1) and m.cod_comune = :f_comune $where_civico_da_m $where_civico_a_m))"
	set where_comune ""
    }
}

# se richiesta selezione per data_mod
if {![string equal $f_data_mod_da ""] 
||  ![string equal $f_data_mod_a  ""]
} {
    if {[string equal $f_data_mod_da ""]} {
	set f_data_mod_da "18000101"
    }
    # dato che oracle memorizza anche l'ora, sono costretto a fare cosi':
    append f_data_mod_da " 00:00:00"

    if {[string equal $f_data_mod_a ""]} {
	set f_data_mod_a  "21001231"
    }
    # dato che oracle memorizza anche l'ora, sono costretto a fare cosi':
    append f_data_mod_a  " 23:59:59"

    #rom02 set where_data_mod "
    #rom02 and (   a.data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
    #rom02                        and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
    #rom02      or a.data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
    #rom02                        and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
    #rom02   )"
    set where_data_mod "and (";#rom02
    set sw_where_data_mod f;#rom02
    if {$f_impianto_inserito eq "S"} {#rom02 aggiunta if e suo contenuto
	set sw_where_data_mod t
	append where_data_mod "
              a.data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')"
    }
    if {$f_impianto_modificato eq "S"} {#rom02 aggiunta if e suo contenuto
    if {$sw_where_data_mod eq "t"} {#rom02 aggiunta if e suo contenuto
	set sw_where_data_mod f
	append where_data_mod "
           and "
    }
	set sw_where_data_mod t
	append where_data_mod "
               a.data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')"
    }
    if {$f_soggetto_modificato eq "S"} {#rom02 aggiunta if e suo contenuto
    if {$sw_where_data_mod eq "t"} {#rom02 aggiunta if e suo contenuto
	set sw_where_data_mod f
	        append where_data_mod "
           and "
    }
	set sw_where_data_mod t
#	append where_data_mod "
#               r.data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
#                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')"
	append where_data_mod "
               a.cod_impianto in (select cod_impianto
                                    from coimrife
                                   where data_ins between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                                     and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
                                  )"

    }
    if {$f_generatore_sostituito eq "S"} {#rom02 aggiunta if e suo contenuto
	if {$sw_where_data_mod eq "t"} {#rom02 aggiunta if e suo contenuto
	set sw_where_data_mod f
	append where_data_mod "
           and "
    }
	append where_data_mod "
                        a.cod_impianto in (select cod_impianto
                                             from coimgend 
                                            where flag_sostituito ='S'
                                              and data_mod between to_date(:f_data_mod_da,'yyyymmdd hh24:mi:ss')
                                              and to_date(:f_data_mod_a ,'yyyymmdd hh24:mi:ss')
                                          )"

    }
    append where_data_mod "
           )"

    if {$f_impianto_inserito eq "N" && $f_impianto_modificato eq "N" && $f_soggetto_modificato eq "N" && $f_generatore_sostituito eq "N"} {#rom02 aggiunta if e suo contenuto
	set where_data_mod ""
    };#rom02
} else {
    set where_data_mod ""
}

# se richiesta selezione per id_utente
if {![string equal $f_utente ""]} {
    set where_utente "and a.utente = :f_utente"
} else {
    set where_utente ""
}

# se richiesta selezione per potenza
if {![string equal $f_potenza_da ""] 
||  ![string equal $f_potenza_a ""]
} {
    if {[string equal $f_potenza_da ""]} {
	set f_potenza_da 0
    }
    if {[string equal $f_potenza_a ""]} {
	set f_potenza_a 9999999.99
    }

    if {$coimtgen(regione) eq "MARCHE"} {#rom04 Aggiunta if e suo contenuto
	set where_pot "
   and (
       case when a.flag_tipo_impianto in ('R','C')
            then (select coalesce(sum(pot_utile_nom),'0.00')    as potenza  --rom03
                    from coimgend w_gend
                   where w_gend.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                   group by a.cod_impianto)
            when a.flag_tipo_impianto ='F'
            then (select greatest(coalesce(sum(pot_focolare_lib),'0.00') , coalesce(sum(pot_focolare_nom),'0.00'))
                    from coimgend w_gend1
                   where w_gend1.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                    group by a.cod_impianto)
            when a.flag_tipo_impianto ='T'
            then (select coalesce(sum(pot_focolare_nom),'0.00') as potenza
                    from coimgend w_gend2
                   where w_gend2.cod_impianto = a.cod_impianto
                     and flag_attivo = 'S'
                   group by a.cod_impianto)
       end
    ) between :f_potenza_da and :f_potenza_a"

    } else {#rom04 Aggiunta else ma non il suo contenuto
	
	set where_pot "and $colonna_potenza between :f_potenza_da
                                           and :f_potenza_a"
	
    };#rom04
    
} else {
    set where_pot ""
}

# imposto la condizione SQL per cod_combustibile
if {![string equal $f_cod_combustibile ""]} {
    set where_comb "and a.cod_combustibile = :f_cod_combustibile"
} else {
    set where_comb ""
}

# se richiesta selezione per data_installazione
if {![string equal $f_data_installaz_da ""] || ![string equal $f_data_installaz_a ""]} {
   if {[string equal $f_data_installaz_da ""]} {
	set f_data_installaz_da "18000101"
   }
   if {[string equal $f_data_installaz_a ""]} {
	set f_data_installaz_a  "21001231"
   }
   set where_data_installaz "and a.data_installaz between :f_data_installaz_da
                                                      and :f_data_installaz_a"
} else {
   set where_data_installaz ""
}

# se richiesta selezione per data_verifica
if {![string equal $f_da_data_verifica ""] || ![string equal $f_a_data_verifica ""]} {
   if {[string equal $f_da_data_verifica ""]} {
	set f_da_data_verifica "18000101"
   }
   if {[string equal $f_a_data_verifica ""]} {
	set f_a_data_verifica  "21001231"
   }
   set from_clause " left outer join coimcimp e on e.cod_impianto  = a.cod_impianto"
    set where_data_verifica "and e.data_controllo between :f_da_data_verifica
                                                     and :f_a_data_verifica  and e.cod_cimp = (select max(o.cod_cimp)
                                                                            from coimcimp o
                                                                           where o.cod_impianto = a.cod_impianto
                                                  )"
} else {
    set from_clause ""
    set where_data_verifica ""
}

# imposto la condizione SQL per flag_dichiarato
if {![string is space $f_flag_dichiarato]} {
    set where_flag_dichiarato "and a.flag_dichiarato = :f_flag_dichiarato"
} else {
    set where_flag_dichiarato ""
}

# imposto la condizione SQL per tipologia
if {![string is space $f_cod_tpim]} {
    set where_cod_tpim "and a.cod_tpim = :f_cod_tpim"
} else {
    set where_cod_tpim ""
}

# imposto la condizione SQL per prov_dati
if {![string is space $f_prov_dati]} {
    set where_prov_dati "and a.provenienza_dati = :f_prov_dati"
} else {
    set where_prov_dati ""
}

# imposto la condizione SQL per stato_conformita
if {![string is space $f_stato_conformita]} {
    set where_stato_conformita "and a.stato_conformita = :f_stato_conformita"
} else {
    set where_stato_conformita ""
}

# imposto la condizione SQL per cod_tpdu
if {![string is space $f_cod_tpdu]} {
    set where_tpdu "and a.cod_tpdu = :f_cod_tpdu"
} else {
    set where_tpdu ""
}

# imposto la condizione SQL per stato
if {![string is space $f_stato_aimp]} {
    set where_stato_aimp "and a.stato = :f_stato_aimp"
} else {
    set where_stato_aimp ""
}

# imposto la condizione SQL per manutentore
if {![string is space $f_cod_manu]} {
    set where_manu "and a.cod_manutentore = :f_cod_manu"
} else {
    set where_manu ""
}

# imposto la condizione SQL per manutentore proveniente da vis. manutentori
if {![string is space $cod_manutentore]} {
    set where_manu "and (a.cod_manutentore = :cod_manutentore 
                            or  a.cod_installatore = :cod_manutentore)"
    set nome_funz_manu [iter_get_nomefunz coimmanu-gest]
} else {
    set where_manutentore ""
    set nome_funz_manu ""
}
set where_manutentore ""

if {![string is space $cod_amministratore]} {
    set where_ammin "and a.cod_amministratore = :cod_amministratore"
} else {
    set where_ammin ""
}


# imposto la condizione SQL per numero bollino
if {![string equal $f_bollino ""]} {
    set where_bollino "and exists (select '1' from coimdimp x where x.riferimento_pag = :f_bollino and x.cod_impianto = a.cod_impianto)"
} else {
    set where_bollino ""
}

# sf 11112013 comune utente

db_0or1row sel_cout_check " select count(*) as conta_cout
                                   from coimcout
                                   where id_utente = :id_utente
                                         "
	
if {$conta_cout > 0} {
    set where_cout "and a.cod_comune in (select ll.cod_comune from coimcout ll where ll.id_utente = :id_utente)"
} else {
    set where_cout ""
}

# sf fine


if {![string equal $f_ls_cod_aimp ""]} {#rom11 if e contenuto
    set where_ls_cod_aimp " and a.cod_impianto in ('[join $f_ls_cod_aimp ',']')"
} else {
    set where_ls_cod_aimp ""
}

#ric02 inizio
set where_dich_conformita ""
set where_dfm_manu ""
set where_dfm_resp_mod ""
if {$coimtgen(regione) eq "MARCHE"} {

    #ric02 imposto la condizione SQL per la dichiarazione di conformita sull'ultimo RCEE
    if {![string equal $f_dich_conformita ""]} {
	set  where_dich_conformita "  and a.cod_impianto in (select dimp2.cod_impianto
                                                               from 
                                                                    (select max(data_controllo) as max_dt_dimp2
                                                                          , cod_impianto as cod_impianto_dimp2
                                                                       from coimdimp max_dimp
                                                                   group by cod_impianto) as max_dimp2
                                                         
                                                         inner join coimdimp dimp2 on dimp2.cod_impianto   = max_dimp2.cod_impianto_dimp2
                                                                                  and dimp2.data_controllo = max_dimp2.max_dt_dimp2
                                                              
                                                              where dimp2.conformita = :f_dich_conformita
                                                                and dimp2.flag_tracciato in ('R1', 'R2', 'R3', 'R4')) "
    }  

    #ric02 imposto la condizione SQL per la dfm del manutentore
    if {![string equal $f_dfm_manu ""]} {
	if {![string is space $cod_manutentore]} {
	    if {$f_dfm_manu eq "S"} {
		set where_dfm_manu " and exists (select 1
                                                   from coimdope_aimp dope
                                                  where dope.cod_impianto    = a.cod_impianto
                                                    and dope.cod_manutentore = :cod_manutentore 
                                                  limit 1)"	    
	    } else {
		set where_dfm_manu " and not exists (select 1
                                                       from coimdope_aimp dope
                                                      where dope.cod_impianto    = a.cod_impianto
                                                        and dope.cod_manutentore = :cod_manutentore
                                                      limit 1)"
	    }	
	}
    }

    #ric02 imposto la condizione SQL per la dfm inserita se cambiato il responsabile
    if {![string equal $f_dfm_resp_mod ""]} {
	if {![string is space $cod_manutentore]} {
	    if {$f_dfm_resp_mod eq "S"} {
		set where_dfm_resp_mod " and exists (select 1
                                                       from coimdope_aimp dope
                                                      where dope.cod_impianto    = a.cod_impianto
                                                        and dope.cod_manutentore = :cod_manutentore
                                                        and dope.cod_responsabile in (select cod_responsabile 
                                                                                        from coimaimp aimp
                                                                                       where aimp.cod_impianto = a.cod_impianto)
                                                      limit 1)"
	    } else {
		set where_dfm_resp_mod " and not exists (select 1
                                                           from coimdope_aimp dope
                                                          where dope.cod_impianto    = a.cod_impianto
                                                            and dope.cod_manutentore = :cod_manutentore
                                                            and dope.cod_responsabile in (select cod_responsabile
                                                                                            from coimaimp aimp
                                                                                           where aimp.cod_impianto = a.cod_impianto)
                                                           limit 1)"
	    }
	}
    }
} 
#ric02 fine

# stabilisco l'ordinamento ed uso una inner join al posto di una outer join
# sulle tabelle dove uso un filtro (Ottimizzazione solo per postgres)
set citt_join_pos "left outer join"
set citt_join_ora "(+)"
if {![string equal $f_cod_impianto_est ""]} {
    set ordine ""
} else {
    if {![string equal $f_resp_cogn ""]
    ||  ![string equal $f_resp_nome ""]
    || (   [string equal $f_quartiere ""]
	&& [string equal $f_cod_via   ""]
	&& [string equal $f_desc_topo ""]
	&& [string equal $f_desc_via  ""])
    } {
	set ordine        "nome"
        set citt_join_pos "left outer join"
        set citt_join_ora ""
    } else {
	set ordine "via"
    }
}

switch $f_dpr_412 {
    "S" {set where_dpr "and a.flag_dpr412 = 'S'"}
    "N" {set where_dpr "and a.flag_dpr412 = 'N'"}
    default {set where_dpr ""}
}
if {![string equal $f_cod_impianto_old ""]} {
    set where_codimp_old " and a.cod_impianto_old = upper(:f_cod_impianto_old)"
} else {
    set where_codimp_old ""
}
if {![string equal $f_cod_utenza ""]} {
    #san01 set where_cod_utenza " and a.cod_amag = upper(:f_cod_utenza)"
    #rom05set where_cod_utenza " and a.pdr = upper(:f_cod_utenza)";#san01
    set where_cod_utenza " and upper(a.pdr) = upper(:f_cod_utenza)";#rom05
} else {
    set where_cod_utenza ""
}

if {![string equal $f_pod ""]} {#rom05 Aggiunte if, else e loro contenuti
    set where_pod " and upper(a.pod) = upper(:f_pod)"
} else {
    set where_pod ""
}

set where_sogg_rcee "";#rom07
set where_resp_rcee "";#rom07
if {$coimtgen(ente) eq "PPA"} {#rom07 Aggiunta if e il suo contenuto


    if {[string equal $f_resp_nome_rcee ""]} {
	set where_nome_rcee ""
    } else {
	set f_resp_nome_rcee_1 [iter_search_word $f_resp_nome_rcee]
	set where_nome_rcee  " and rcee.nome like upper(:f_resp_nome_rcee_1)"
    }

    if {[string equal $f_resp_cogn_rcee ""]} {
	set where_cogn_rcee ""
    } else {
	set f_resp_cogn_rcee_1 [iter_search_word $f_resp_cogn_rcee]
	set where_cogn_rcee  " and rcee.cognome like upper(:f_resp_cogn_rcee_1)"
    }

    if {$where_cogn_rcee ne "" || $where_nome_rcee ne ""} {

	set where_resp_rcee " and exists (select 1 
                                            from coimdimp dimp
                                               , coimcitt rcee
                                           where dimp.cod_responsabile = rcee.cod_cittadino 
                                             and dimp.cod_impianto = a.cod_impianto 
                                             $where_nome_rcee 
                                             $where_cogn_rcee 
                                           limit 1) "

    }

}

#ric01 inizio
if {[string equal $f_ibrido ""]} {
    set where_ibrido ""
} else {
    set where_ibrido  " and a.flag_ibrido = :f_ibrido"
}


set where_dimp ""
set where_pagato ""
set where_tprc ""

if {![string equal $f_pagato ""] || ![string equal $f_tprc ""]} { 

    
    if {![string equal $f_pagato ""]} {
	set where_pagato  " and dimp.flag_pagato = :f_pagato"
    }
    
    if {![string equal $f_tprc ""]} {   
	set where_tprc  " and dimp.cod_tprc = :f_tprc"
    }

    set where_dimp "
      and a.cod_impianto in (
      select cod_impianto_dimp
        from (select max(data_controllo) as max_dt_dimp
                       , cod_impianto as cod_impianto_dimp  
                    from coimdimp
                group by cod_impianto) as max_dimp
      inner join coimdimp dimp
              on dimp.cod_impianto=max_dimp.cod_impianto_dimp
             and max_dimp.max_dt_dimp = dimp.data_controllo
      where 1=1
         $where_pagato
         $where_tprc)"

}
    
#ric01 fine

# imposto l'ordinamento della query e la condizione per la prossima pagina
switch $ordine {
    "via" {
	switch $flag_viario {
	    "T" {set col_via "d.descrizione"}
	    "F" {set col_via "a.indirizzo" }
	    "N" {set col_via "a.indirizzo" }
	}

        set ordinamento "order by $col_via
                                , $col_numero
                                , a.cod_impianto_est"

	if {![string equal $last_cod_impianto ""]} {
	    set via              [lindex $last_cod_impianto 0]
	    set numero           [lindex $last_cod_impianto 1]
	    set cod_impianto_est [lindex $last_cod_impianto 2]

	    if {[string equal $via ""]} {
		set via_eq      "is null"
                set or_via      ""
	    } else {
		set via_eq      "= :via"
		set or_via      "or ($col_via > :via)"
	    }

	    if {[string equal $numero ""]} {
		set numero_eq   "is null"
                set or_numero   ""
	    } else {
		set numero_eq   "= lpad(:numero, 8, '0')"
                set or_numero   "or (    $col_via    $via_eq
                                     and $col_numero > lpad(:numero, 8, '0'))
                                 or $col_numero is null"
	    }
	    set where_last "and (
                                    (    $col_via   $via_eq
                                     and $col_numero $numero_eq
                                     and a.cod_impianto_est > :cod_impianto_est)
                                 $or_numero
                                 $or_via
                                )"
	} else {
	    set where_last ""
        }
    }

    "nome"   {
	set ordinamento "order by b.cognome, b.nome, a.cod_impianto_est"

	if {![string equal $last_cod_impianto ""]} {
	    set cognome          [lindex $last_cod_impianto 0]
	    set nome             [lindex $last_cod_impianto 1]
	    set cod_impianto_est [lindex $last_cod_impianto 2]
	    if {[string equal $cognome ""]} {
		set cognome_eq  "is null"
		set or_cognome  ""
	    } else {
		set cognome_eq  "= :cognome"
		set or_cognome  "or  (b.cognome > :cognome)"
	    }
	    
	    if {[string equal $nome ""]} {
		set nome_eq     "is null"
		set or_nome     ""
	    } else {
		set nome_eq     "= :nome"
		set or_nome     "or  (     b.cognome $cognome_eq
                                      and  b.nome    > :nome)"
	    }

	    set where_last "and (
                                     (    b.cognome  $cognome_eq
                                      and b.nome     $nome_eq
                                      and a.cod_impianto_est > :cod_impianto_est)
                                 $or_nome
                                 $or_cognome
                                )"
         } else {
             set where_last ""
         }
    }
    default {
	set ordinamento ""
	set where_last  ""
    }
}

#inizio dpr74
if {![string equal $f_flag_tipo_impianto ""]} {
    set where_tipo_impianto " and a.flag_tipo_impianto = upper(:f_flag_tipo_impianto)"
} else {
    set where_tipo_impianto ""
}
#fine dpr74

if {$conta_flag == "t"} {
    # estraggo il numero dei record estratti
    db_1row sel_conta_aimp ""
    set link_conta "Impianti selezionati: <b>$conta_num</b>"
}

if {$flag_viario == "T"} {
    set sel_aimp [db_map sel_aimp_vie]
} else {
    set sel_aimp [db_map sel_aimp_no_vie]
}

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto last_cod_impianto nome_funz extra_par provincia comune localita indir via numero cod_ubicazione cognome nome ordine descrizione cod_impianto cod_impianto_est url_list_aimp swc_dichiarato nome_funz_caller conta_num} go $sel_aimp $table_def]

# preparo url escludendo last_cod_impianto che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_impianto]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    switch $ordine {
	"nome" {set last_cod_impianto [list $cognome $nome $cod_impianto_est]}
        "via"  {set last_cod_impianto [list $via $numero $cod_impianto_est]}
    }
    append url_vars "&[export_url_vars last_cod_impianto]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_conta $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
