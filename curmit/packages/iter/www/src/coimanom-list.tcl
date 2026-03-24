ad_page_contract {
    Lista tabella "coimanom"

    @author                  Paolo Formizzi Adhoc
    @creation-date           10/05/2004

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

    @cvs-id coimanom-list.tcl 

     USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 15/09/2025 Aggiunta la variabile flag_att_sosp per l'aggiunta di una nuova tipologia
    mat01            di attività sospesa

    but01 19/07/2023 Aggiunta class"link-button-2" nel actions"Selez"

} { 
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {extra_par         ""}
    {nome_funz         ""}
    {nome_funz_caller  ""} 
    {receiving_element ""}
    {cod_cimp_dimp     ""}
    {flag_origine      ""}
    {cod_impianto      ""}
    {url_aimp          ""}
    {url_list_aimp     ""}
    {gen_prog          ""}
    {flag_cimp         ""}
    {last_prog_anom    ""}
    {flag_inco           ""}
    {cod_inco            ""}
    {funz_inco           ""}
    {extra_par_inco      ""}
    {flag_att_sosp       ""}
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
#   set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set page_title      "Lista Anomalie"

set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto la proc per i link e per il dettaglio impianto
if {(   $flag_cimp == "S"
    &&  $flag_inco != "S")
||  $flag_origine == "MH"
} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp $flag_origine]
} else {
    set link_tab ""
    switch $flag_origine {
        "RV" { if {[db_0or1row sel_cimp2 ""] == 0} {
	          iter_return_complaint "Impianto non trovato"
	       }
	}
	"MH" {
	       if {[db_0or1row sel_dimp2 ""] == 0} {
	          iter_return_complaint "Impianto non trovato"
	       }
	}
    }
}

if {$flag_inco == "S"} {
    set link_inco [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz $funz_inco $extra_par_inco]
#   set cimp_funz "inco-cimp"
    set cimp_funz "cimp"
} else {
    set link_inco ""
    set cimp_funz "cimp"
}

set dett_tab [iter_tab_form $cod_impianto]

set link_cimp [export_url_vars cod_cimp_dimp flag_origine extra_par cod_impianto gen_prog nome_funz_caller caller url_aimp url_list_aimp flag_cimp  extra_par_inco cod_inco flag_inco]&nome_funz=$cimp_funz&cod_cimp=$cod_cimp_dimp


set link_dimp "[export_url_vars flag_origine extra_par cod_impianto gen_prog nome_funz_caller caller url_aimp url_list_aimp flag_cimp  extra_par_inco cod_inco flag_inco]&nome_funz=[iter_get_nomefunz coimdimp-gest]&cod_dimp=$cod_cimp_dimp"

switch $flag_origine {
    "RV" {set link_ritorna "coimcimp-gest?funzione=V&$link_cimp"}
    "MH" {set link_ritorna "coimdimp-gest?funzione=V&$link_dimp"}
}

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimanom-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
#ignoro eventuali extra par della lista anomalie per far navigare quelli
#dei rapporti di verifica
#set extra_par       [list rows_per_page     $rows_per_page \
#                          receiving_element $receiving_element]
#mat01 aggiunto flag_att_sosp al link aggiungi
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars flag_origine cod_cimp_dimp url_list_aimp url_aimp cod_impianto gen_prog last_prog_anom caller nome_funz extra_par nome_funz_caller flag_cimp extra_par_inco cod_inco flag_inco flag_att_sosp]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]


set link    "\[export_url_vars cod_cimp_dimp flag_origine url_list_aimp url_aimp cod_impianto gen_prog prog_anom last_prog_anom nome_funz nome_funz_caller extra_par flag_cimp extra_par_inco cod_inco flag_inco\]"
set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\" class=\" link-button-2\">Selez.</a></td>"
set js_function ""


# imposto la struttura della tabella
set table_def [list \
        [list actions     "Azioni"            no_sort $actions] \
	[list prog_anom   "Prog."             no_sort      {r}] \
	[list cod_tanom   "Cod."              no_sort      {l}] \
	[list descr_breve "Descrizione"       no_sort      {l}] \
	[list data_edit   "Data utile inter." no_sort      {c}] \
]

# imposto la query SQL 

# imposto la condizione per la prossima pagina
if {![string is space $last_prog_anom]} {
    set where_last " and prog_anom >= :last_prog_anom"
} else {
    set where_last ""
}

set sel_anom [db_map sel_anom]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_cimp_dimp flag_origine prog_anom url_list_aimp url_aimp cod_impianto gen_prog last_prog_anom nome_funz nome_funz_caller extra_par flag_cimp extra_par_inco cod_inco flag_inco} go $sel_anom $table_def]

# preparo url escludendo last_prog_anom che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_prog_anom]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_prog_anom $prog_anom
    append url_vars "&[export_url_vars last_prog_anom]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
