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
    ===== ========== ============================================================================================
    but01 03/04/2023   Aggiunto il rapporto di esito "Mancata ispezione" visualizzato a video su tutti gli enti.

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
    {esito_verifica      ""}
    {flag_pericolosita   ""}
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

# determino il tipo di instalazione
iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)

# determino il tipo di utente
if {[db_0or1row sel_prof_nome_menu ""] == 0} {
    set nome_menu ""
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

#
#13012014
set conta 0
#
# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

set permanenti_dir [iter_set_permanenti_dir]

# imposto il nome dei file
set nome_file        "stampa_elenco_ispezioni"
set nome_file        [iter_temp_file_name -permanenti $nome_file]
set file_html        "$permanenti_dir/$nome_file.html"
set file_pdf         "$permanenti_dir/$nome_file.pdf"
set file_csv_name    "$permanenti_dir/$nome_file.csv"

set file_pdf_url     "../permanenti/$nome_file.pdf"
set file_csv_url     "../permanenti/$nome_file.csv"

set file_id  [open $file_html w]
set file_csv [open $file_csv_name w]
fconfigure $file_id -encoding iso8859-1
fconfigure $file_csv -encoding iso8859-1
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

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimcimp-gest"
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
	set link_aggiungi   "Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">Rapporto di ispezione</a>
<br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco]\">mancata ispezione</a>"
    } else {
	
	set link_aggiungi  "   Aggiungi un <a href=\"$gest_prog?funzione=I&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Rapporto di ispezione</a>
                       <br> o aggiungi una <a href=\"$gest_prog?funzione=I&flag_tracciato=MA&[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto nome_funz extra_par nome_funz_caller flag_cimp]\">Mancata ispezione</a>"

    }
}

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]

set link        "\[export_url_vars last_cod_cimp caller url_list_aimp url_aimp cod_impianto cod_cimp nome_funz extra_par nome_funz_caller gen_prog flag_cimp flag_inco cod_inco extra_par_inco\]"
set actions "
<td nowrap><a href=\"$gest_prog?funzione=V&$link\">Selez.</a></td>"
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

#inizio dpr74
set stato_imp {
   [set coloretipo "AZURE"
    set tipoimp "nd"
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
set desc_esito ""

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

# imposto la struttura della tabella
if {$flag_cimp == "N"
||  $flag_inco == "S"
} {
    set table_def [list \
        [list actions             "Azioni"                no_sort $actions] \
    	[list cod_cimp            "Cod."                  no_sort      {l}] \
	[list gen_prog_est        "Gen."                  no_sort      {r}] \
	[list data_controllo_edit "Data controllo"        no_sort      {c}] \
	[list verb_n              "N.verbale"             no_sort      {l}] \
	[list data_verb_edit      "Data verbale"          no_sort      {c}] \
	[list costo_verifica_edit "Costo ispezione"       no_sort      {r}] \
	[list desc_esito          "Esito"                 no_sort $td_esito] \
       [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
   ]
} else {
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
	[list data_verb_edit      "Data verbale"          no_sort      {c}] \
	[list desc_esito          "Esito"                 no_sort $td_esito] \
       [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
   ]
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

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_cimp cod_impianto last_cod_cimp nome_funz nome_funz_caller extra_par flag_inco cod_inco extra_par_inco url_list_aimp url_aimp flag_cimp} go $sel_cimp $table_def]

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

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles



set current_datetime [clock format [clock seconds] -f "%Y-%m-%d %H:%M:%S"]
set nome_file        "Esporta_ispezioni"
set nome_file         [iter_temp_file_name -permanenti $nome_file]
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]
set file_csv         "$permanenti_dir/$nome_file.csv"
set file_csv_url     "$permanenti_dir_url/$nome_file.csv"

set file_id [open $file_csv w]
fconfigure $file_id -encoding iso8859-1


set     head_cols ""
lappend head_cols "Num.Ispez."
lappend head_cols "Codice Impianto"
lappend head_cols "Gen."
lappend head_cols "Comune"
lappend head_cols "Indirizzo"
lappend head_cols "Responsabile"
lappend head_cols "Data_controllo"
lappend head_cols "Num.Verbale"
lappend head_cols "Data_verbale"
lappend head_cols "Esito"
lappend head_cols "Tipo-impianto"

# imposto la prima riga del file csv
   
# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "cod_cimp"
lappend file_cols "cod_impianto_est"
lappend file_cols "gen_prog_est"
lappend file_cols "comune"
lappend file_cols "indir"
lappend file_cols "resp"
lappend file_cols "data_controllo_edit"
lappend file_cols "verb_n"
lappend file_cols "data_verb_edit"
lappend file_cols "esit"
lappend file_cols "flag_tipo_impianto"

set sw_primo_rec "t"

if {$flag_viario == "T"} {
    set sel_aimp [db_map sel_aimp_vie]
} else {
    set sel_aimp [db_map sel_aimp_no_vie]
}

db_foreach sel_cimp $sel_cimp {
    set file_col_list ""

    regsub {,} $indir { n.} indir
#    regsub {,} $potenza {.} potenza
    if {$flag_tracciato == "MA"} {#but01 Aggiunte if, else e il loro contenuto
        set esit "Mancata ispezione"
    } else {
	switch $esito_verifica {
	    "P" {set esit "Positivo"}
	    "N" {set esit "Negativo"}
	    default {set esit ""}
	}
	if {$flag_pericolosita == "T"} {
	    if {![string equal $esit ""]} {
                append esit ""
	    }
            append esit " pericoloso"
	}
    }



    if {$sw_primo_rec == "t"} {
	set sw_primo_rec "f"
	iter_put_csv $file_id head_cols
    }

    foreach column_name $file_cols {
	lappend file_col_list [set $column_name]
    }
    iter_put_csv $file_id file_col_list
    
} if_no_rows {
    set msg_err      "Nessun impianto selezionato con i criteri utilizzati"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list
}

ad_returnredirect $file_csv_url
ad_script_abort
