ad_page_contract {
    Lista tabella "coimaimp"

    @author                  Katia Coazzoli
    @creation-date           17/05/2004

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
    ===== ========== =======================================================================
     but01 19/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
} { 
    {search_word          ""}
    {rows_per_page        ""}
    {caller               "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {receiving_element    ""}
    {last_cod_impianto    ""}
    {url_coimaces_list    ""}

    {f_desc_topo          ""}
    {f_desc_via           ""}
    {f_cognome            ""}
    {f_nome               ""}

    {cod_aces             ""}
    {flag_call            ""}
    {stato_01             ""}

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
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set link_tab [iter_links_aces $cod_aces $nome_funz_caller $url_coimaces_list $flag_call $stato_01]
set dett_tab [iter_tab_aces $cod_aces $f_cognome $f_nome $f_desc_topo $f_desc_via]

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

set page_title      "Ricerca esistenza impianto"

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimaimp-sche"
set form_di_ricerca ""
set col_di_ricerca  "via"
set extra_par       [list rows_per_page        $rows_per_page \
                          receiving_element    $receiving_element \
			  f_cognome            $f_cognome \
			  f_nome               $f_nome \
			  f_desc_topo          $f_desc_topo \
         		  f_desc_via           $f_desc_via ]

set link_aggiungi ""
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]
set link_filter     [export_url_vars nome_funz]

set flag_aces "S"
if {$caller == "index"} {
    set link    "\[export_url_vars cod_impianto last_cod_impianto nome_funz_caller extra_par flag_aces cod_aces url_coimaces_list flag_call stato_01 f_cognome f_nome f_desc_topo f_desc_via\]&nome_funz=impianti"

    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"  class=\" link-button-2\">Selez.</a></td>"
    set js_function ""
} else { 
    set actions           [iter_select [list cod_impianto resp indir]]
    set receiving_element [split $receiving_element |]
    set js_function       [iter_selected $caller [list [lindex $receiving_element 0] cod_impianto [lindex $receiving_element 1] resp [lindex $receiving_element 2] indir]
}

# imposto la struttura della tabella
set table_def [list \
        [list action           "Azioni"              no_sort    $actions] \
	[list cod_impianto_est "Codice"              no_sort         {l}] \
        [list resp             "Responsabile"        no_sort         {l}] \
        [list comune           "Comune"              no_sort         {l}] \
        [list indir            "Indirizzo"           no_sort         {l}] \
        [list potenza          "Potenza"             no_sort         {r}] \
        [list swc_mod_h        "Autocert."           no_sort         {c}] \
        [list swc_rapp         "R.V."                no_sort         {c}] \
        [list swc_dichiarato   "Dich."               no_sort         {c}] \
]

#recupero record aces
db_0or1row sel_aces ""

set where_codaces_est ""
set where_citt        ""
set where_via         ""
set where_piva        ""
set citt_join2        ""
set tab_join_ora      ""
set on_cond           ""
set on_cond_ora       ""
set tab_join          ""

set errore            ""


set prep_cogn_nome {
    set cogn [string trim [iter_search_word $f_cognome]]
    set nome [string trim [iter_search_word $f_nome]]

    if {[string equal $cogn ""]} {
	set errore "Inserire il Cognome prima di effettuare la selezione per:<br> 'Stessto intestatario', 'Stesso occupante', 'Stesso proprietario'"

    } else {
	if {![string equal $nome ""]} {
	    set cogn_nome "$cogn $nome"
	} else {
	    set cogn_nome "$cogn %"
	}
    }
}


switch $flag_call {
    "uten" { if {[string equal $cod_distributore "" ]} {
                 set where_codaces_est "
                     and a.cod_amag         = upper(:cod_aces_est)
                     and a.cod_distributore is null"
             } else { 
                 set where_codaces_est "
                     and a.cod_amag         = upper(:cod_aces_est)
                     and a.cod_distributore = :cod_distributore"
             }
    }
    "inte" { eval $prep_cogn_nome
	     set citt_join2  " inner join "
             set tab_join    " coimcitt e"
             set on_cond     " on  e.cod_cittadino = a.cod_intestatario"
             set tab_join_ora " , coimcitt e"
             set on_cond_ora " and e.cod_cittadino = a.cod_intestatario"
	     set where_citt  [db_map set_where_citt]

    }
    "occu" { eval $prep_cogn_nome
             set citt_join2  " inner join " 
             set tab_join    " coimcitt e"
             set on_cond     " on  e.cod_cittadino = a.cod_occupante"
             set tab_join_ora " , coimcitt e"
             set on_cond_ora " and e.cod_cittadino = a.cod_occupante"
	     set where_citt  [db_map set_where_citt]
	     if {[db_0or1row sel_cod_comu "" ] == 0} {
		 set cod_comu_filt ""
	     }
	     append where_citt "and a.cod_comune = :cod_comu_filt"
    }
    "prop" { eval $prep_cogn_nome
             set citt_join2  " inner join "
             set tab_join    " coimcitt e" 
             set on_cond     " on  e.cod_cittadino = a.cod_proprietario"
             set tab_join_ora " , coimcitt e"
             set on_cond_ora " and e.cod_cittadino = a.cod_proprietario"
	     set where_citt  [db_map set_where_citt]
    }
    "indi"   { set f_desc_via1  [iter_search_word $f_desc_via]
               set f_desc_topo1 [iter_search_word $f_desc_topo]
	       if {[db_0or1row sel_cod_comu "" ] == 0} {
		   set cod_comu_filt ""
	       }
               if {(![string equal $f_desc_via  ""]
               ||   ![string equal $f_desc_topo ""])} {
		   if {$flag_viario == "T"} {
		       set where_via " and d.descr_topo like upper (:f_desc_topo1)
                                   and d.descr_estesa like upper (:f_desc_via1)
                                   and a.cod_comune = :cod_comu_filt"
		   } else {
		       set where_via "and a.indirizzo like upper(:f_desc_via1)
                                   and a.toponimo  like upper(:f_desc_topo1)"
		   }
               } else {
                   set errore    "Digitare un indirizzo prima di effettuare la selezione per 'Stesso indirizzo'"
	       }
    }
    "piva"   {
	set citt_join2 " left outer join coimcitt e 
                           on e.cod_cittadino = a.cod_intestatario
                           or e.cod_cittadino = a.cod_proprietario
                           or e.cod_cittadino = a.cod_occupante"
	set where_citt " and (e.cod_fiscale = upper (:piva)
                          or  e.cod_piva    = upper (:piva))"
	set tab_join_ora ", coimcitt e"
	set on_cond_ora " and (e.cod_cittadino = a.cod_intestatario
                           or  e.cod_cittadino = a.cod_proprietario
                           or  e.cod_cittadino = a.cod_occupante)"
    }
}

# stabilisco l'ordinamento ed uso una inner join al posto di una outer join
# sulle tabelle dove uso un filtro (Ottimizzazione solo per postgres)

set ordine "via"


# imposto l'ordinamento della query e la condizione per la prossima pagina
switch $ordine {
    "via" {
	set ordinamento "order by c.denominazione"
	if {$flag_viario == "T"} {
            append ordinamento ", d.descrizione"
            set viae        "d.descrizione"
        } else {
            append ordinamento ", a.indirizzo"
            set viae        "a.indirizzo"
        }
        append ordinamento ", to_number(a.numero,'99999999')
                            , a.cod_impianto_est"

	if {![string equal $last_cod_impianto ""]} {
	    set via              [lindex $last_cod_impianto 0]
	    set numero           [lindex $last_cod_impianto 1]
	    set cod_impianto_est [lindex $last_cod_impianto 2]
	    set comune           [lindex $last_cod_impianto 3]

	    if {[string equal $comune ""]} {
		set comune_eq "is_null"
		set or_comune ""
	    } else {
		set comune_eq "= :comune"
		set or_comune "or (c.denominazione > :comune)"
	    }

	    if {[string equal $via ""]} {

		set via_eq  "is null"
		set or_viae ""
	    } else {
		set via_eq  "= :via"
                set or_viae "or (    c.denominazione $comune_eq
                                 and $viae > :via)"
	    }
	    if {[string equal $numero ""]} {
		set numero_eq  "is null"
		set or_numero ""
	    } else {
		set numero_eq  "= :numero"
                set or_numero "or (    c.denominazione $comune_eq
                                   and $viae          $via_eq
                                   and to_number(a.numero,'99999999') > :numero )"
	    }

	    set where_last "and (
                                 (    c.denominazione $comune_eq
                                  and $viae           $via_eq
                                  and to_number(a.numero,'99999999') $numero_eq
                                  and a.cod_impianto_est > upper(:cod_impianto_est))
                                 $or_numero
                                 $or_viae 
                                 $or_comune
                           )"

	} else {
	    set where_last ""
        }
    }

  default {set ordinamento ""
           set where_last ""
  }
}

db_1row sel_anno_dat_ver ""
append dat_ini_ver "0101"


if {$flag_viario == "T"} {
    set sel_aimp [db_map sel_aimp_vie]
} else {
    set sel_aimp [db_map sel_aimp_no_vie]
}
if {![string is space $errore]} {
    set table_result $errore
} else {
    set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto last_cod_impianto nome_funz extra_par provincia comune localita indir via numero cod_ubicazione cognome nome ordine descrizione cod_impianto cod_impianto_est swc_dichiarato f_desc_topo f_desc_via f_cognome f_nome cod_aces flag_call stato_01 nome_funz_caller flag_aces url_coimaces_list comune} go $sel_aimp $table_def]
}

# preparo url escludendo last_cod_impianto che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_impianto]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"


# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    switch $ordine {
	"nome" {set last_cod_impianto [list $cognome $nome $cod_impianto_est $comune]}
        "via"  {set last_cod_impianto [list $via $numero $cod_impianto_est $comune]}
    }
    append url_vars "&[export_url_vars last_cod_impianto]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
