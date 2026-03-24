ad_page_contract {
    Lista tabella ""

    @author                  Giulio Laurenzi
    @creation-date           30/08/2004

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

    @cvs-id coimstav-list.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Mod sogg."

} { 
    {cod_inco          ""}
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {f_data            ""}
    {f_tipo_data       ""}
    {f_cod_impianto    ""}
    {f_cod_tecn        ""}
    {f_cod_enve        ""}
    {f_cod_comb        ""}
    {f_anno_inst_da    ""}
    {f_anno_inst_a     ""}
    {f_cod_esito       ""}
    {f_cod_comune      ""}
    {f_cod_via         ""}
    {f_tipo_estrazione ""}
    {f_cod_comb        ""}
    {flag_inco         ""}
    {extra_par         ""}
    {cod_impianto      ""}
    {url_list_aimp     ""}
    {url_aimp          ""}   
    {conta_flag        ""}
    {flag_inco         ""}
    {extra_par         ""}
    {f_num_max         ""}
    {f_cod_area        ""}

    {id_stampa         ""}
    {flag_richiesta    ""}
    {flag_tipo_impianto  ""}
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
    # se la lista viene chiamata da un cerca, nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

set nome_funz_coimcitt [iter_get_nomefunz "coimcitt-gest"]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {[db_0or1row sel_cinc_count ""] == 0} {
    set conta 0
}
if {$conta == 0} {
    iter_return_complaint "Non ci sono campagne aperte"
}
if {$conta > 1} {
    iter_return_complaint "C'&egrave; pi&ugrave; di una campagna aperta"
}
if {$conta == 1} {
    if {[db_0or1row sel_cinc ""] == 0} {
	iter_return_complaint "Campagna non trovata"
    }
}



set context_bar [iter_context_bar -nome_funz $nome_funz_caller]

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set layout_prog     "coimstav-layout"

set form_di_ricerca ""
set col_di_ricerca  ""
set form_name       "coimstav"

set page_title      "Lista appuntamenti estratti per richiesta documentazione"

set link_righe      ""
set link_aggiungi   ""
set link_filter     [export_ns_set_vars url]
set link_anteprima  "[export_ns_set_vars url]&flag_anteprima=T&[export_url_vars id_protocollo protocollo_dt]"
set extra_par        [list]

if {$conta_flag != "t"} {
    set link_conta      "<a href=\"$curr_prog?conta_flag=t&[export_ns_set_vars url]\">Conta</a>"
} else {
    set link_conta ""
}

set actions ""
set js_function ""

#set checked ""
set url_vars        [export_ns_set_vars "url" "flag_sel"]

# imposto la struttura della tabella
#but01 Aggiunta class"link-button-2" nel actions"Mod sogg."
set link    "\[export_url_vars cod_cittadino\]"
set actions "
    <td nowrap><a target=citt href=\"coimcitt-gest?funzione=M&flag_mod=t&nome_funz_caller=$nome_funz_caller&nome_funz=$nome_funz_coimcitt&$link\"class=\"link-button-2\">Mod sogg.</a></td>"

set table_def [list \
	[list actions          "Azioni"           no_sort $actions] \
	[list cod_impianto_est "Codice"           no_sort      {l}] \
	[list indir            "Ubicazione imp."  no_sort      {l}] \
	[list nom_resp         "Responsabile"     no_sort      {l}] \
	[list indirizzo_resp   "Ind. Resp."       no_sort      {l}] \
	[list numero_resp      "Num."             no_sort      {l}] \
	[list cap_resp         "Cap"              no_sort      {l}] \
	[list comune_resp      "Comune"           no_sort      {l}] \
	[list provincia_resp   "Provincia"        no_sort      {l}] \
]



# imposto la query SQL

iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set flag_viario      $coimtgen(flag_viario)
set gg_conferma_inco $coimtgen(gg_conferma_inco)
set flag_avvisi      $coimtgen(flag_avvisi)
set flag_stp_presso_terzo_resp $coimtgen(flag_stp_presso_terzo_resp);#13/11/2013
set data_corrente [iter_set_sysdate]

if {$flag_ente == "C"} {
    set luogo $coimtgen(denom_comune)
} else {
    set cod_prov $coimtgen(cod_provincia)
    if {[db_0or1row get_desc_prov ""] == 0} {
	set luogo ""
    } else {
	set luogo $desc_prov
    }
}

# imposto il filtro per incontro
if {![string equal $cod_inco ""]} {
    set where_inco "and a.cod_inco = :cod_inco"
} else {
    set where_inco ""
}

# imposto il filtro per numero massimo
if {![string equal $f_num_max ""]} {
    set limit_ora "where rownum <= $f_num_max"
    set limit_pos "limit $f_num_max"
} else {
    set limit_ora ""
    set limit_pos ""
}


# imposto filtro per data
if {![string equal $f_data ""]} {
    switch $f_tipo_data {
	"A" {set where_data "and a.data_assegn       = :f_data"}
	"E" {set where_data "and a.data_estrazione   = :f_data"}
	"I" {set where_data "and a.data_verifica     = :f_data"}
    }
} else {
    set where_data ""
}

if {![string equal $f_cod_impianto ""]} {
    set where_codice "and b.cod_impianto_est = upper(:f_cod_impianto)"
} else {
    set where_codice ""
}

# imposto il filtro per il tecnico
if {![string equal $f_cod_tecn ""]} {
    set where_tecn "and a.cod_opve = :f_cod_tecn"
} else {
    set where_tecn ""
}

# imposto il filtro per comune
if {![string equal $f_cod_comune ""]} {
    set where_comune "and b.cod_comune = :f_cod_comune"
} else {
    set where_comune ""
}

# imposto filtro per via
if {![string equal $f_cod_via ""]} {
    set where_via "and b.cod_via = :f_cod_via"
} else {
    set where_via ""
}

# imposto filtro per tipo estrazione
if {![string equal $f_tipo_estrazione ""]} {
    set where_tipo_estr "and a.tipo_estrazione = :f_tipo_estrazione"
} else {
    set where_tipo_estr ""
}

# imposto filtro per combustibile
if {![string equal $f_cod_comb ""]} {
    set where_comb "and b.cod_combustibile = :f_cod_comb"
} else {
    set where_comb ""
}

# imposto filtro per data
if {![string equal $f_anno_inst_da ""]} {
    set where_anno_inst_da "and substr(b.data_installaz,1,4) >= :f_anno_inst_da"
} else {
    set where_anno_inst_da ""
}

if {![string equal $f_anno_inst_a ""]} {
    set where_anno_inst_a  "and substr(b.data_installaz,1,4) <= :f_anno_inst_a"
} else {
    set where_anno_inst_a ""
}

#inizio dpr74
# imposto filtro per tipo impianto
if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp "and b.flag_tipo_impianto = :flag_tipo_impianto"
} else {
    set where_tipo_imp ""
}
#fine dpr74

# imposto filtro per area. ricordo che per questa estrazione si considerano
# solo le aree come raggruppamenti di comuni.
if {![string equal $f_cod_area ""]} {

    if {[db_0or1row sel_area_tipo_01 ""] == 0} {
	set tipo_01 ""
    }

    set lista_comu "("
    set conta_comu 0
    db_foreach sel_cmar "" {
	incr conta_comu
	append lista_comu "$cod_comune,"
    }
    if {$conta_comu > 0} {
	set lung_lista_comu [string length $lista_comu]
	set lista_comu [string range $lista_comu 0 [expr $lung_lista_comu -2]]
	append lista_comu ")"

	set where_cod_area "and b.cod_comune in $lista_comu"
    } else {
	set where_cod_area ""
    }
} else {
    set where_cod_area ""
}

# imposto il filtro per ente verificatore
if {![string equal $f_cod_enve ""]} {
    set where_enve "and a.cod_opve in (select z.cod_opve 
                                         from coimopve z
                                        where z.cod_enve = :f_cod_enve)"
} else {
    set where_enve ""
}

if {$conta_flag == "t"} {
#     il numero dei record estratti
    if {$flag_viario == "T"} {
	db_1row sel_conta_inco_si_viae ""
    } else {
	db_1row sel_conta_inco_no_viae ""
    }
    if {$f_num_max > 0} {
	set conta_inco $f_num_max
    }
    set link_conta "Avvisi estratti: <b>$conta_inco</b>"
}


if {$flag_viario == "T"} {
    set sql_query [db_map sel_inco_si_viae]
} else {
    set sql_query [db_map sel_inco_no_viae]
}

set table_result [ad_table  -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {} go $sql_query $table_def]

# preparo url escludendo last_cod_impianto che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" last_cod_impianto]

set link_altre_pagine ""

# creo testata della lista
set list_head [iter_list_head $form_di_ricerca   $col_di_ricerca \
	       $link_conta    $link_altre_pagine $link_righe ""]




db_release_unused_handles
ad_return_template 
