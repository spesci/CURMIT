ad_page_contract {
    Lista tabella "coimgend"

    @author                  Katia Coazzoli Adhoc
    @creation-date           02/04/2004

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

    @cvs-id coimgend-list.tcl 

    USER  DATA       MODFIFICHE
    ===== ========== ==================================================================================================
    but01 14/07/2023 Aggiunta class"link-button-2" nel actions"Selez"
    sim01 04/02/2020 La gestione del numero progressivo in fase di sostituzione usato per la Regione Marche diventa standard

    rom02 21/09/2018 Nella lista per le Marche faccio vedere gen_prog_est e non più gen_prog; aggiunto anche nuovo campo 
    rom02            flag_sostituito

    gac01 13/07/2018 Aggiunto link_scheda3 
    
    rom01 12/07/2018 Aggiunta proc iter_get_coimtgen e link_scheda11.

} { 
   {search_word       ""}
   {rows_per_page     ""}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""} 
   {receiving_element ""}
    cod_impianto
   {last_gen_prog     ""}
   {url_list_aimp     ""}
   {url_aimp          ""}
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
#	ns_log Notice "********AUTH-CHECK-GENDLIST-KO-REFERER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } 
# if {$id_utente != $id_utente_loggato_vero} {
#	set login [ad_conn package_url]
#	ns_log Notice "********AUTH-CHECK-GENDLIST-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#	return 0
#    } else {
#	ns_log Notice "********AUTH-CHECK-GENDLIST-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    }
# ***

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

# controllo il parametro di "propagazione" per la navigation bar
#set nome_funz_context "impianti"
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
#    set nome_funz_caller "impianti"
}


set page_title      "Lista Generatori"


#if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar [iter_context_bar \
#                    [list "javascript:window.close()" "Torna alla Gestione"] \
#                    "$page_title"]
#}

#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

iter_get_coimtgen ;#rom01
set link_scheda11 [export_url_vars cod_impianto];#rom1
set link_scheda3 [export_url_vars cod_impianto last_cod_impianto];#gac01

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coimgend-gest"
set form_di_ricerca ""
set col_di_ricerca  ""
set extra_par       [list rows_per_page     $rows_per_page \
                          receiving_element $receiving_element]
set link_aggiungi   "<a href=\"$gest_prog?funzione=I&[export_url_vars cod_impianto last_gen_prog caller nome_funz url_list_aimp  url_aimp extra_par nome_funz_caller]\">Aggiungi</a>"
set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]


#if {$caller == "index"} {

    set link    "\[export_url_vars cod_impianto gen_prog last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par\]"
    set actions "
    <td nowrap><a href=\"$gest_prog?funzione=V&$link\"class=\"link-button-2\" >Selez.</a></td>"
    set js_function ""
#} else { 
#    set actions [iter_select [list column_name .... ]]
#    set receiving_element [split $receiving_element |]
#    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  column_name1 [lindex $receiving_element 1]  column_name2 .... .... ]]
#}

#sim01 if {$coimtgen(regione) eq "MARCHE"} {#rom02 aggiunto if, else e loro contenuto
    set num_gen "[list gen_prog_est        "Num"            no_sort {r}]" 
#sim01 } else {
#sim01    set num_gen "[list gen_prog            "Num"            no_sort {r}]" 
#sim01}

#rom02 aggiunti num_gen e flag_sostituito 
# imposto la struttura della tabella
set table_def [list \
		   [list actions             "Azioni"         no_sort $actions] \
		   $num_gen \
		   [list descrizione         "Descrizione"    no_sort {l}] \
		   [list matricola           "Matricola"      no_sort {l}] \
		   [list modello             "Modello"        no_sort {l}] \
		   [list descr_cost          "Costruttore"    no_sort {l}] \
		   [list descr_comb          "Combustibile"   no_sort {l}] \
		   [list data_installaz_edit "Data install"   no_sort {c}] \
		   [list flag_attivo         "Attivo"         no_sort {c}] \
		   [list flag_sostituito     "Sostituito"     no_sort {c}] \
]


# imposto la query SQL 

# imposto la condizione per la prossima pagina
if {![string is space $last_gen_prog]} {
    set where_last " and gen_prog_est >= :last_gen_prog"
} else {
    set where_last ""
}

set sel_gend [db_map sel_gend]

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {cod_impianto gen_prog gen_prog_est last_gen_prog nome_funz nome_funz_caller url_list_aimp url_aimp extra_par} go $sel_gend $table_def]

# preparo url escludendo last_gen_prog che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_gen_prog]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_gen_prog $gen_prog_est
    append url_vars "&[export_url_vars last_gen_prog]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head  $form_di_ricerca $col_di_ricerca \
              $link_aggiungi $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
