ad_page_contract {
    Lista tabella "coimcimp"

    @author                  Paolo Formizzi Adhoc
    @creation-date           03/05/2004

    @param search_word       parola da ricercare con una query
    @param rows_per_page     una delle dimensioni della tabella  
    @param caller            se diverso da index rappresenta il nome del form 
                             da cui e' partita la ricerca ed in questo caso
                             imposta solo azione "sel"
    @param nome_funz         identifica l'entrata di menu,
                             serve per le autorizzazioni
    @param nome_funz_caller  identifica l'entrata di menu,
                             serve per la navigation bar
    @param receiving_element nomi dei campi di form che riceveranno gli
                             argomenti restituiti dallo script di zoom,
                             separati da '|' ed impostarli come segue:

    @cvs-id coimcimp-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but03 03/12/2024  Modificato label di Data verbale con Data Compilazione<br> RCEE

    but02 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

    but01 31/03/2023   Modificata label di num_fat e data_fatt per regione Friuli.

    mic01 20/01/2023 Aggiunti link per inserire i rapporti di accertamento e aggiunta colonna
    mic01            tipo verbale (flag_tracciato) alla lista dei rapporti.

    rom04 13/12/2022 Le colonne num_fatt e data_fatt_edit vanno visualizzate su tutta la Regione Fiuli
    rom04            e non solo le Province di Udine e Gorizia.

    rom03 08/04/2022 Corretto errore di rom02: se si inseriva un rapporto di ispezione dalla
    rom03            gestione del singolo appuntamento non si teneva conto degli impianti
    rom03            del freddo che hanno un rapporto diverso da quelli del caldo.

    rom02 07/02/2022 Regione Marche ha richiesto che per gli impianti del freddo venga inserito
    rom02            un rapporto di ispezione diverso che per gli impianti del caldo.

    gac01 13/07/2018 Aggiunta link_scheda11.

    rom01 07/06/2018 Modificato link Aggiungi rapporto di ispezione per le marche.

    sim03 16/02/2017 Livorno ha il coimcimp-gest personalizzato quindi solo per lui faccio
    sim03            puntare direttamente al coimcimp-re-gest

    sim02 15/02/2017 il rapporto di ispezione RE va usato su tutta la Regione toscana 

    san01 12/08/2016 Gestito il nuovo rapporto di ispezione RE usato solo da A.F.E.

    sim01 15/04/2015 Gestito il nuovo rapporto di ispezione RI

} { 
    {search_word         ""}
    {rows_per_page       ""}
    {caller         "index"}
    {nome_funz           ""}
    {nome_funz_caller    ""} 
    {receiving_element   ""}
    {last_cod_cimp       ""}
    {cod_impianto        ""}
    {url_aimp            ""}
    {url_list_aimp       ""}
    {f_cod_enve          ""}
    {f_cod_tecn          ""}
    {f_data_controllo_da ""}
    {f_data_controllo_a  ""}
    {f_anno_inst_da      ""}
    {f_anno_inst_a       ""}
    {f_cod_comb          ""}
    {f_cod_comune        ""}
    {f_cod_via           ""}
    {flag_cimp           ""}
    {f_descr_topo        ""}
    {f_descr_via         ""}
    {f_verb_n            ""}
    {flag_inco           ""}
    {cod_inco            ""}
    {flag_tipo_impianto  ""}
    {extra_par_inco      ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

# leggo i parametri
iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)


# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimcimp-gest"
set gest_prog_re $gest_prog;#sim03

set link_scheda11 [export_url_vars cod_impianto];#gac01

# determino il tipo di utente
if {[db_0or1row sel_prof_nome_menu ""] == 0} {
    set nome_menu ""
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


if {$coimtgen(regione) eq "MARCHE"} {#rom01 if e suo contenuto

    set dicitura_link_reg "alle leggi della Regione Marche"
    set link_vecchio_formato ""

} else {

    set dicitura_link_reg "al dpr 74/2013"

    if {$flag_cimp != "S"} {
	set link_vecchio_formato "<br>Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di ispezione nel vecchio formato</a>
"       
    } else {
	set link_vecchio_formato "<br>Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di ispezione nel vecchio formato</a>
"
    }
    #se non è Regione marche non va più visualizzato il vecchio formato
    set link_vecchio_formato ""

}

#13012014
set conta 0
#
set link_scar_csv     [export_ns_set_vars url]
#set link_scar_csv     [coimcimp-list-csv]
#fine 13012014


if {$flag_cimp == "S"} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
    set dett_tab [iter_tab_form $cod_impianto]
} else {
    set link_tab ""
    if {$flag_inco == "S"} {
	set dett_tab [iter_tab_form $cod_impianto]
    } else {
	set dett_tab ""
    }
}

if {$flag_inco == "S"} {
    # setto l'extra_par_inco per poterla passare al gest
    set link_inco [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz "" $extra_par_inco]
} else {
    set link_inco ""
}

set link_filt  [export_ns_set_vars url]
set page_title "Lista Rapporti di ispezione"
set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

if {$coimtgen(ente) eq "PLI"} {;#sim03 if e suo contenuto
    set gest_prog_re "../srcpers/PLI/coimcimp-re-gest"
}

set form_di_ricerca [iter_search_form $curr_prog $search_word]
set col_di_ricerca  "Codice"
if {$flag_cimp == "S"
||  $flag_inco == "S"
} {
    set extra_par   [list rows_per_page       $rows_per_page \
			 receiving_element   $receiving_element]
} else {
    set extra_par   [list rows_per_page       $rows_per_page \
			receiving_element   $receiving_element \
			f_data_controllo_da $f_data_controllo_da \
			f_data_controllo_a  $f_data_controllo_a \
			f_anno_inst_da      $f_anno_inst_da \
			f_anno_inst_a       $f_anno_inst_a \
			f_cod_comb          $f_cod_comb \
			f_cod_enve          $f_cod_enve \
			f_cod_tecn          $f_cod_tecn \
			f_cod_comune        $f_cod_comune \
			f_cod_via           $f_cod_via \
			f_descr_topo        $f_descr_topo \
			f_descr_via         $f_descr_via \
			f_verb_n            $f_verb_n \
		       ]
}

if {[string equal $cod_impianto ""]} {
    # consultazione rapporti di verifica da menu'
    set link_aggiungi ""
} else {

    if {$flag_cimp != "S"} {
	#sim02 cambiato if. prima c'era $coimtgen(ente) eq "PFI"
	if {$coimtgen(regione) eq "TOSCANA"} {#san01: aggiunta if e suo contenuto
	    set link_aggiungi_re "Aggiungi un <a href=\"$gest_prog_re?funzione=I&flag_tracciato=RE&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di ispezione conforme alla DGR reg.</a>
<br>"
	} else {
	    set link_aggiungi_re ""
	}

        if {[db_0or1row q "select 1
                             from coimaimp
                            where cod_impianto = :cod_impianto
                              and flag_tipo_impianto = 'F'"]} {#rom03 Aggiunte if, else e loro contenuto
	    set flg_trc "FR"
	} else {
	    set flg_trc "RI"
	}	

	#san01: aggiunto $link_aggiungi_re
	#rom03 Sostituito flag_tracciato RI con nuova variabile $flg_trc
	#mic01 Aggiunto link per Rapporto di accertamento con tracciato AC
	set link_aggiungi   "$link_aggiungi_re
    Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=$flg_trc&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di ispezione conforme $dicitura_link_reg</a>
<br>Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=AC&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di accertamento</a>
$link_vecchio_formato
<br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">mancata ispezione</a>";#sim01

	#sim01 set link_aggiungi   "Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di ispezione</a> <br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">mancata ispezione</a>"
    } else {
	#sim02 cambiato if. prima c'era $coimtgen(ente) eq "PFI"
	if {$coimtgen(regione) eq "TOSCANA"} {#san01: aggiunta if e suo contenuto
	    #mic01 Aggiunto link per Rapporto di accertamento con tracciato AC
	    set link_aggiungi_re "Aggiungi un <a href=\"$gest_prog_re?funzione=I&flag_tracciato=RE&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di ispezione conforme alla DGR reg.</a>
<br>
Aggiungi un <a href=\"$gest_prog_re?funzione=I&flag_tracciato=AC&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_\
par nome_funz_caller flag_cimp]\">Rapporto di accertamento</a>"
	} else {
	    set link_aggiungi_re ""
	}


	if {[db_0or1row q "select 1
                             from coimaimp
                            where cod_impianto = :cod_impianto
                              and flag_tipo_impianto = 'F'"]} {#rom02 Aggiunte if, else e loro contenuto
	    set flg_trc "FR"
	} else {
	    set flg_trc "RI"
	}
	    
	#san01: aggiunto $link_aggiungi_re
	#rom02 Sostituito flag_tracciato RI con nuova variabile $flg_trc
	#mic01 Aggiunto link per Rapporto di accertamento con tracciato AC
	set link_aggiungi  "$link_aggiungi_re
    Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=$flg_trc&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di ispezione conforme $dicitura_link_reg</a>
<br> Aggiungi un <a href=\"$gest_prog?funzione=I&flag_tracciato=AC&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di accertamento</a>
$link_vecchio_formato
<br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Mancata ispezione</a>"
	#sim01 set link_aggiungi  "   Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di ispezione</a>                       <br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Mancata ispezione</a>"
	

    }
}

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link        "\[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto cod_cimp nome_funz extra_par nome_funz_caller gen_prog flag_cimp flag_inco cod_inco extra_par_inco\]"
#but02
set actions "
 <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\"link-button-2\">Selez.</a></td>"

set js_function ""


set td_esito {[
    if {$flag_tracciato == "MA"} {
        set esit "Mancata ispezione"
    } else {
	switch $esito_verifica {
	    "P" {set esit "Positivo"}
	    "N" {set esit "<font color=red><b>Negativo</b></font>"}
	default {set esit ""}
	}
	if {$flag_pericolosita == "T"} {
	    if {![string equal $esit ""]} {
		append esit ", "
	    }
	    append esit "<font color=red><b>impianto pericoloso</b></font>"
	}
    }
    return "<td align=\"left\">$esit</td>"]
}

#200114
set flag_vis "S"

if {$nome_funz_caller == "impianti"} {
    set flag_tipo_impianto ""
    set flag_vis "N"
 }
#fine 200114


#inizio dpr74
set stato_imp {
   [set coloretipo "AZURE"
    set tipoimp "Tutti"
    if {$flag_tipo_impianto == "R"} {
	set coloretipo "MAGENTA"
	set tipoimp "Ri"
    }
    if {$flag_tipo_impianto == "F"} {
	set coloretipo "LIGHTSKYBLUE"
	set tipoimp "Fr"
    }
    if {$flag_tipo_impianto == "C"} {
	set coloretipo "BEIGE"
	set tipoimp "Co"
    }
    if {$flag_tipo_impianto == "T"} {
	set coloretipo "ORANGE"
	set tipoimp "Te"
    }
    
    return "<td nowrap align=centre bgcolor=$coloretipo>$tipoimp</font></td>"]
}

#fine dpr74

# imposto la struttura della tabella
if {$flag_cimp == "S"
||  $flag_inco == "S"
} {
    #mic01 Aggiunta colonna flag_tracciato
    #but03  Modificato label di Data verbale con Data Compilazione<br> RCEE
    set table_def [list \
        [list actions             "Azioni"                no_sort $actions] \
    	[list cod_cimp            "Cod."                  no_sort      {l}] \
	[list gen_prog_est        "Gen."                  no_sort      {r}] \
	[list data_controllo_edit "Data controllo"        no_sort      {c}] \
	[list verb_n              "N.verbale"             no_sort      {l}] \
	[list data_verb_edit      "Data Compilazione<br> RCEE"          no_sort      {c}] \
	[list costo_verifica_edit "Costo ispezione"       no_sort      {r}] \
	[list desc_esito          "Esito"                 no_sort $td_esito] \
	[list flag_tipo_impianto  "TI"                    no_sort $stato_imp]\
	[list flag_tracciato      "Tipo verbale"          no_sort      {c}      ]
	          ]
} else {
    #mic01 Aggiunta colonna flag_tracciato
    #but03 Modificato label di Data verbale con Data Compilazione<br> RCEE
    set table_def [list \
        [list actions             "Azioni"                no_sort $actions] \
    	[list cod_cimp            "Cod."                  no_sort      {l}] \
	[list cod_impianto_est    "Cod.Imp."              no_sort      {r}] \
	[list gen_prog_est        "Gen."                  no_sort      {c}] \
	[list comune              "Comune"                no_sort      {l}] \
	[list indir               "Indirizzo"             no_sort      {l}] \
	[list resp                "Responsabile"          no_sort      {l}] \
	[list data_controllo_edit "Data controllo"        no_sort      {c}] \
	[list verb_n              "N.verbale"             no_sort      {l}] \
	[list data_verb_edit      "Data Compilazione<br> RCEE"          no_sort      {c}] \
	[list desc_esito          "Esito"                 no_sort $td_esito] \
        [list flag_tipo_impianto  "TI"                    no_sort $stato_imp] \
	[list flag_tracciato      "Tipo verbale"          no_sort      {c}      ]
		  ]
}

#rom04if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {}
if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom04 Aggiunta if ma non il suo contenuto. #but01 modifica di label di num_fat e data_fatt
    lappend table_def [list num_fatt       "N.IDP"    no_sort      {l}]
    lappend table_def [list data_fatt_edit "IDP" no_sort      {c}]

    if {[string range $id_utente 0 1] eq "VE"} {
	set link_mod "<td>&nbsp;</td>"
    } else {
	set link_mod_fatt "\[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto cod_cimp nome_funz extra_par nome_funz_caller flag_cimp flag_inco cod_inco extra_par_inco\]"
	set link_mod "<td nowrap><a href=\"coimcimp-mod-fatt?funzione=M&id_utente=$id_utente&$link_mod_fatt\">Mod.</a></td>"
    }

    lappend table_def [list link_mod       ""             no_sort $link_mod]

}

# imposto la query SQL 
if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cod_cimp) like upper(:search_word_1)"
}

# imposto la condizione per la prossima pagina
if {![string is space $last_cod_cimp]} {
    set where_last " and cod_cimp >= :last_cod_cimp"
} else {
    set where_last ""
}

# cod_impianto viene considerato solo se questo programma viene richiamato
# dalla gestione impianti
if {![string equal $cod_impianto ""]
&& (   $flag_cimp == "S"
    || $flag_inco == "S")
} {
    set where_impianto " and a.cod_impianto = :cod_impianto"
} else {
    set where_impianto ""
}

set coimaimp_pos ""
set denom_comune ""
set coimcomu_pos ""
set coimaimp_ora ""
set coimcitt_pos ""
set coimcitt_ora ""
set coimviae_pos ""
set coimviae_ora ""
set coiminco_pos ""
set coiminco_ora ""
set where_aimp_ora ""
set where_aimp_pos ""
set where_citt_ora ""
set where_citt_pos ""
set where_viae_ora ""
set where_viae_pos ""
set where_inco_pos ""
set where_inco_ora ""


set flag_sel_aimp  "f"
set where_aimp     ""

if {![string equal $f_data_controllo_da ""]} {
    set where_data_cont_da " and a.data_controllo >= :f_data_controllo_da"
} else {
    set where_data_cont_da ""
}

if {![string equal $f_data_controllo_a ""]} {
    set where_data_cont_a " and a.data_controllo <= :f_data_controllo_a"
} else {
    set where_data_cont_a ""
}

# imposto il filtro per anno installazione compresa negli anni indicati
if {![string equal $f_anno_inst_da ""]} {
    append where_aimp " and to_char(b.data_installaz,'yyyy') >= :f_anno_inst_da"
}

if {![string equal $f_anno_inst_a ""]} {
    append where_aimp " and to_char(b.data_installaz,'yyyy') <= :f_anno_inst_a"
}

#dpr74
if {![string equal $flag_tipo_impianto ""]} {
    append where_aimp  " and b.flag_tipo_impianto = :flag_tipo_impianto"
}

if {![string equal $f_cod_comb ""]} {
    append where_aimp " and b.cod_combustibile = :f_cod_comb"
}

if {![string equal $f_verb_n ""]} {
    set where_verb " and a.verb_n = :f_verb_n"
} else {
    set where_verb ""
}
# imposto il filtro per tecnico o per ente verificatore
if {![string equal $f_cod_tecn ""]} {
    set where_opve " and a.cod_opve = :f_cod_tecn"
} else {
    if {![string equal $f_cod_enve ""]} {
	set where_opve " and a.cod_opve in (select z.cod_opve 
                                              from coimopve z
                                             where z.cod_enve = :f_cod_enve)"
    } else {
	set where_opve ""
    }
}

if {![string equal $cod_inco ""]
&&  $flag_inco == "S"
} {
    set coiminco_ora   ", coiminco c"
    set where_inco_ora " and c.cod_inco = a.cod_inco
                         and c.cod_inco =  :cod_inco"
    set coiminco_pos   "inner join coiminco c"
    set where_inco_pos "  on c.cod_inco = a.cod_inco
                         and c.cod_inco =  :cod_inco"
}

if {![string equal $f_cod_comune ""]} {
    append where_aimp " and b.cod_comune   = :f_cod_comune"
}

if {![string equal $f_cod_via ""]} {
    append where_aimp " and b.cod_via = :f_cod_via"
} else {
    if {(![string equal $f_descr_via ""]
    ||   ![string equal $f_descr_topo ""])
    &&   [string equal $f_cod_via ""]
    } {
	set f_descr_via1  [iter_search_word $f_descr_via]
	set f_descr_topo1 [iter_search_word $f_descr_topo]
	append where_aimp "
        and b.indirizzo like upper(:f_descr_via1)
        and b.toponimo  like upper(:f_descr_topo1)"
    }
}

if {$flag_cimp != "S"} {
    set sel_imp        ", b.cod_impianto_est , b.flag_tipo_impianto"
    set flag_sel_aimp  "t"
    set sel_resp       [db_map sel_resp]
    set coimcitt_ora   ", coimcitt d"
    set where_citt_ora "and d.cod_cittadino (+) = b.cod_responsabile"
    set coimcitt_pos   "left outer join coimcitt d"
    set where_citt_pos " on d.cod_cittadino = b.cod_responsabile"

    iter_get_coimtgen
    set flag_viario $coimtgen(flag_viario)
    if {$flag_viario == "T"} {
	set sel_ind    [db_map sel_ind]
	set coimviae_ora   ", coimviae e"
	set where_viae_ora "and e.cod_via    (+) = b.cod_via
                            and e.cod_comune (+) = b.cod_comune"
	set coimviae_pos   "left outer join coimviae e"
	set where_viae_pos " on e.cod_via    = b.cod_via
                            and e.cod_comune = b.cod_comune"
    } else {
	set sel_ind    [db_map sel_ind2]
    }
} else {
    set sel_imp    ""
    set sel_resp   ""
    set sel_ind    ""
    set where_viae ""
}

if {$flag_sel_aimp == "t"
|| ![string is space $where_aimp]
} {
    set coimaimp_ora   ", coimaimp b"
    set where_aimp_ora "and b.cod_impianto = a.cod_impianto
                       $where_aimp"
    set coimaimp_pos   "inner join coimaimp b"
    set where_aimp_pos "   on b.cod_impianto = a.cod_impianto
                         $where_aimp"
    set coimcomu_pos "left outer join coimcomu g on g.cod_comune = b.cod_comune"
    set denom_comune "         , g.denominazione as comune"
}

set conta [db_string sel_cimp_conta ""]
set sel_cimp     [db_map sel_cimp]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_cimp cod_impianto last_cod_cimp nome_funz nome_funz_caller extra_par flag_inco cod_inco flag_tipo_impianto extra_par_inco url_list_aimp url_aimp flag_cimp} go $sel_cimp $table_def]

# preparo url escludendo last_cod_cimp che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_cimp]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_cimp $cod_cimp
    append url_vars "&[export_url_vars last_cod_cimp]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

#sandro ha detto che i manutentori hanno solo la visualizzazione
set cod_manutentore [iter_check_uten_manu $id_utente]
if {$cod_manutentore ne ""} {
    set link_aggiungi ""
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles

ad_return_template 
