ad_page_contract {
    Lista tabella "coiminco"

    @author                  Mortoni Nicola/Formizzi Paolo Adhoc
    @creation-date           19/08/2004

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

    @cvs-id coiminco-list.tcl 

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mat01 12/03/2026 Aggiunta la storicizzazione del soggetto. Non prendo il soggetto responsabile
    mat01            oggi ma quello responsabile alla data dell'appuntamento.
    
    rom01 12/03/2024 Ricevo e gestisco il filtro f_con_data_app

    but01 13/07/2023 Aggiunta class"link-button-2" nel actions"Selez","Storico"

} {
    {search_word       ""}
    {rows_per_page     ""}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""} 
    {receiving_element ""}
    {last_cod_inco     ""}

    {f_tipo_data       ""}
    {f_da_data         ""}
    {f_a_data          ""}
    {f_cod_impianto    ""}
    {f_tipo_estrazione ""}
    {f_anno_inst_da    ""}
    {f_anno_inst_a     ""}
    {f_cod_comb        ""}
    {f_cod_enve        ""}
    {f_cod_tecn        ""}
    {f_cod_comune      ""}
    {f_cod_via         ""}
    {f_descr_topo      ""}
    {f_descr_via       ""}
    {f_stato           ""}

    {flag_aimp         ""}
    {cod_impianto      ""}
    {url_aimp          ""}
    {url_list_aimp     ""}

    {num_rec           ""}
    {flag_scar         ""}
    {flag_scar2        ""}
    {f_cod_area        ""}
    {f_tipo_lettera    ""}
    {f_campagna        ""}
    {f_resp_cogn       ""}
    {f_resp_nome       ""}
    {f_civico_da       ""}
    {f_civico_a        ""}
    {f_cod_noin        ""}
    {f_da_data_verifica ""}
    {f_a_data_verifica  ""}
    {flag_tipo_impianto ""}
    {f_con_data_app     ""}
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

set desc_enve [db_map descrizione_enve_opve]
set title_enve "Ente verif"
# controllo se l'utente è il responsabile dell'ente verificatore
set cod_tecn   [iter_check_uten_opve $id_utente]
set cod_enve   [iter_check_uten_enve $id_utente]
if {![string equal $cod_tecn ""]} {
    set flag_cod_tecn "t"
    set desc_enve ", '' as descr_enve"
    set title_enve ""
} else {
    set flag_cod_tecn "f"
}

if {![string equal $cod_enve ""]} {
    set flag_cod_enve "t"
    set desc_enve [db_map descrizione_opve]
    set title_enve "Tecn.Verif"
} else {
    set flag_cod_enve "f"
}


if {$flag_aimp == "S"} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
    set dett_tab [iter_tab_form $cod_impianto]
} else {
    set link_tab ""
    set dett_tab ""
}

# imposto filtro per data appuntamento
if {![string equal $f_da_data_verifica ""] || ![string equal $f_a_data_verifica ""]} {
    if {[string equal $f_da_data_verifica ""]} {
	set f_da_data_verifica "18000101"
    }
    if {[string equal $f_a_data_verifica ""]} {
	set f_a_data_verifica  "21001231"
    }
    set where_data_verifica "and a.data_verifica between :f_da_data_verifica and :f_a_data_verifica"
} else {
    set where_data_verifica ""
}

if {![string equal $f_campagna ""]} {
    if {[db_0or1row sel_campagna ""] == 0} {
	iter_return_complaint "Campagna non trovata"
    }
} else {
    if {$flag_aimp == "S" || $caller != "index"} {
	set where_cinc ""
    } else {
	set conta [db_string sel_cinc_count ""]
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
	set where_cinc "and a.cod_cinc = :cod_cinc"
    }
}

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)

# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
switch $nome_funz {
    "inco-asse" {set evento "assegnazione"
	set funz "A"}
    "inco-stam" {set evento "stampa avviso"
	set funz "V"}
    "inco-conf" {set evento "conferma"
	set funz "C"}
    "inco-effe" {set evento "effettuazione"
	set funz "E"}
    "inco-annu" {set evento "annullamento"
	set funz "N"}
    "inco-cimp" {set evento "registr. rapp. di verifica"
	set funz "V"}
    default     {set evento "gestione"
	set funz "V"}
}

set page_title "Lista appuntamenti per $evento"
if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar [iter_context_bar \
			 [list "javascript:window.close()" "Torna alla Gestione"] \
			 "$page_title"]
}
#se esiste prendo quello dello storico, altrimenti quello attuale
set subquery_resp "
 coalesce (
         (select coalesce(b_sub.cognome, '')||' '||coalesce(b_sub.nome, '') 
           from coimrife r_sub
              , coimcitt b_sub
          where a.data_verifica <= r_sub.data_fin_valid
            and r_sub.cod_soggetto = b_sub.cod_cittadino
            and r_sub.ruolo = 'R'
            and r_sub.cod_impianto = a.cod_impianto
          order by r_sub.data_fin_valid asc 
          limit 1) 
    ,   
    coalesce(b.cognome, '')||' '||coalesce(b.nome, '') ) as resp
";#mat01

# imposto le variabili da usare nel frammento html di testata della lista.
set curr_prog       [file tail [ns_conn url]]
set gest_prog       "coiminco-gest"
set stor_prog       "coiminco-st-list"
# escludo num_rec dalla form di ricerca per rieffettuare il conteggio
set form_di_ricerca [iter_search_form $curr_prog $search_word num_rec]
set col_di_ricerca  "cognome"
set extra_par       [list rows_per_page     $rows_per_page \
			 receiving_element  $receiving_element \
			 f_tipo_data	    $f_tipo_data \
			 f_da_data          $f_da_data \
			 f_a_data           $f_a_data \
			 f_da_data_verifica $f_da_data_verifica \
			 f_a_data_verifica  $f_a_data_verifica \
			 f_cod_impianto     $f_cod_impianto \
			 f_tipo_estrazione  $f_tipo_estrazione \
			 f_anno_inst_da     $f_anno_inst_da \
			 f_anno_inst_a      $f_anno_inst_a \
			 f_cod_comb         $f_cod_comb \
			 f_cod_enve	    $f_cod_enve \
			 f_cod_tecn         $f_cod_tecn \
			 f_cod_comune       $f_cod_comune \
			 f_cod_via	    $f_cod_via \
			 f_civico_da	    $f_civico_da \
			 f_civico_a	    $f_civico_a \
			 f_resp_cogn	    $f_resp_cogn \
			 f_resp_nome	    $f_resp_nome \
			 f_cod_noin	    $f_cod_noin \
			 f_descr_topo	    $f_descr_topo \
			 f_descr_via        $f_descr_via \
			 f_campagna         $f_campagna \
			 f_stato	    $f_stato \
			 num_rec            $num_rec \
			 flag_scar          $flag_scar \
			 flag_scar2         $flag_scar2 \
			 f_con_data_app     $f_con_data_app \
                      flag_tipo_impianto         $flag_tipo_impianto]

set rows_per_page   [iter_set_rows_per_page $rows_per_page $id_utente]
set link_righe      [iter_rows_per_page     $rows_per_page]
set link_filter     [export_ns_set_vars url]
set link_asse       "[export_ns_set_vars url \"nome_funz\"]&nome_funz=[iter_get_nomefunz coiminco-asse-filter]"

#but01 Aggiunta class"link-button-2" nel actions"Selez","Storico"
if {$caller == "index"} {
    set link    "\[export_url_vars cod_inco last_cod_inco nome_funz nome_funz_caller extra_par flag_aimp cod_impianto url_aimp url_list_aimp\]"

    db_1row sel_ruolo "select id_settore, id_ruolo from coimuten where id_utente = :id_utente"
    if {$id_settore == "system" || $id_settore == "ente"} {
	if {$id_ruolo == "admin" || $id_ruolo == "utente"} {
	    set actions "<td nowrap><a href=\"$gest_prog?funzione=$funz&$link\" class=\"link-button-2\">Selez.</a> | <a href=\"$stor_prog?funzione=V&$link\" class=\"link-button-2\">Storico</a></td>"
	} else {
	    set actions "<td nowrap><a href=\"$gest_prog?funzione=$funz&$link\"class=\"link-button-2\">Selez.</a></td>"
	}
    } else {
        set actions " <td nowrap><a href=\"$gest_prog?funzione=$funz&$link\"class=\"link-button-2\" >Selez.</a></td>"
    }

    set js_function ""

    set modifica { [
		    set link_data_ora "[export_url_vars cod_inco nome_funz nome_funz_caller cod_cinc]"
		    if {$stato eq "2" || $stato eq "3"} {
			return "<td nowrap align=center><a href=\"\javascript:void(0)\" onclick=\"javascript:window.open('/iter//src/coiminco-data-ora?$link_data_ora','coimincomoddataora','scrollbars=no,resizable=no, width=400,height=50,status=no,location=no,toolbar=no,screenX='+ xMousePos + ',screenY=' + yMousePos +',top='+ yMousePos +',left='+ xMousePos);\">Mod.</a>"
		    } else {
			return "<td nowrap>&nbsp;</td>"
		    } ]
    }
} else { 
    set actions [iter_select [list cod_inco cod_impianto]]
    set receiving_element [split $receiving_element |]
    set js_function [iter_selected $caller [list [lindex $receiving_element 0]  cod_inco [lindex $receiving_element 1] cod_impianto]]
    
    set modifica { [
		    set link_data_ora "[export_url_vars cod_inco nome_funz nome_funz_caller cod_cinc]"
		    if {$stato eq "2" || $stato eq "3"} {
			return "<td nowrap align=center><a href=\"\javascript:void(0)\" onclick=\"javascript:window.open('/iter//src/coiminco-data-ora?$link_data_ora','coimincomoddataora','scrollbars=no,resizable=no, width=400,height=50,status=no,location=no,toolbar=no,screenX='+ xMousePos + ',screenY=' + yMousePos +',top='+ yMousePos +',left='+ xMousePos);\">Mod.</a>"
		    } else {
			return "<td nowrap>&nbsp;</td>"
		    } ]
    }
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

# imposto la struttura della tabella
if {$flag_ente == "P" &&  $sigla_prov == "LI"} {
    if {$flag_aimp != "S" && $caller == "index"} {

	if {$flag_cod_tecn == "t"} {
	    set table_def [list \
			       [list actions           "Azioni"        no_sort $actions] \
			       [list cod_inco          "Cod.app."      no_sort      {r}] \
			       [list cod_impianto_est  "Cod.imp."      no_sort      {l}] \
			       [list resp              "Responsabile"  no_sort      {l}] \
			       [list comune            "Comune"        no_sort      {l}] \
			       [list indirizzo_ext     "Indirizzo"     no_sort      {l}] \
			       [list telefono          "Telefono"      no_sort      {l}] \
			       [list desc_stato        "Stato"         no_sort      {<td nowrap align=centre><font color=green><b>$desc_stato</b></font></td>}] \
			       [list data_verifica     "Data app."     no_sort      {<td nowrap align=centre><font color=red><b>$data_verifica</b></font></td>}] \
			       [list ora_verifica      "Ora app."      no_sort      {l}] \
			       [list tipo_lettera_desc "Tipo lettera." no_sort     {c}] \
			      ]
	} else {
	    set table_def [list \
			       [list actions           "Azioni"        no_sort $actions] \
			       [list cod_inco          "Cod.app."      no_sort      {r}] \
			       [list cod_impianto_est  "Cod.imp."      no_sort      {l}] \
			       [list resp              "Responsabile"  no_sort      {l}] \
			       [list comune            "Comune"        no_sort      {l}] \
			       [list indirizzo_ext     "Indirizzo"     no_sort      {l}] \
			       [list desc_stato        "Stato"         no_sort      {<td nowrap align=centre><font color=green><b>$desc_stato</b></font></td>}] \
			       [list tipo_lettera_desc "Tipo lettera." no_sort      {c}] \
			       [list data_verifica     "Data app."     no_sort      {<td nowrap align=centre><font color=red><b>$data_verifica</b></font></td>}] \
			       [list ora_verifica      "Ora app."      no_sort      {l}] \
			       [list descr_enve       $title_enve      no_sort      {l}] \
			      ]
	}
    } else {
	set table_def [list \
			   [list actions           "Azioni"        no_sort $actions] \
			   [list cod_inco          "Cod.app."      no_sort      {r}] \
			   [list cod_impianto_est  "Cod.imp."      no_sort      {l}] \
			   [list resp              "Responsabile"  no_sort      {l}] \
			   [list comune            "Comune"        no_sort      {l}] \
			   [list indirizzo_ext     "Indirizzo"     no_sort      {l}] \
			   [list desc_stato        "Stato"         no_sort      {<td nowrap align=centre><font color=green><b>$desc_stato</b></font></td>}] \
			   [list descr_camp        "Campagna"      no_sort      {l}] \
			   [list tipo_lettera_desc "Tipo lettera." no_sort      {c}] \
			   [list data_verifica     "Data app."     no_sort      {<td nowrap align=centre><font color=red><b>$data_verifica</b></font></td>}] \
			   [list ora_verifica      "Ora app."      no_sort      {l}] \
			   [list descr_enve        $title_enve     no_sort      {l}] \
			  ]
    }
} else {

    if {$flag_aimp != "S" && $caller == "index"} {
	if {$flag_cod_tecn == "t"} {
	    set table_def [list \
			       [list actions          "Azioni"       no_sort $actions] \
			       [list cod_inco         "Cod.app."     no_sort      {r}] \
			       [list cod_impianto_est "Cod.imp."     no_sort      {l}] \
			       [list resp             "Responsabile" no_sort      {l}] \
			       [list comune           "Comune"       no_sort      {l}] \
			       [list indirizzo_ext    "Indirizzo"    no_sort      {l}] \
			       [list telefono         "Telefono"     no_sort      {l}] \
			       [list desc_stato       "Stato"        no_sort      {<td nowrap align=centre><font color=green><b>$desc_stato</b></font></td>}] \
			       [list tipo_app         "Tipo"         no_sort      {l}] \
			       [list data_verifica    "Data app."    no_sort      {<td nowrap align=centre><font color=red><b>$data_verifica</b></font></td>}] \
			       [list ora_verifica     "Ora app."     no_sort      {l}] \
                            [list n_generatori     "N.G."         no_sort      {<td nowrap align=centre><font color=red><b>$n_generatori</b></font></td>}] \
                            [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
			       [list modifica         "Mod."         no_sort $modifica] \
			      ]
	} else {
	    set table_def [list \
			       [list actions          "Azioni"       no_sort $actions] \
			       [list cod_inco         "Cod.App."     no_sort      {r}] \
			       [list cod_impianto_est "Cod.Imp."     no_sort      {l}] \
			       [list resp             "Responsabile" no_sort      {l}] \
			       [list comune           "Comune"       no_sort      {l}] \
			       [list indirizzo_ext    "Indirizzo"    no_sort      {l}] \
			       [list desc_stato       "Stato"        no_sort      {<td nowrap align=centre><font color=green><b>$desc_stato</b></font></td>}] \
			       [list tipo_app         "Tipo"         no_sort      {l}] \
			       [list data_verifica    "Data App."    no_sort      {<td nowrap align=centre><font color=red><b>$data_verifica</b></font></td>}] \
			       [list ora_verifica     "Ora App."     no_sort      {l}] \
			       [list descr_enve       $title_enve    no_sort      {l}] \
                            [list n_generatori     "N.G."         no_sort      {<td nowrap align=centre><font color=red><b>$n_generatori</b></font></td>}] \
                            [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
			       [list modifica         "Mod."         no_sort $modifica] \
                          			      ]
	}
    } else {
	set table_def [list \
			   [list actions          "Azioni"       no_sort $actions] \
			   [list cod_inco         "Cod.app."     no_sort      {r}] \
			   [list cod_impianto_est "Cod.imp."     no_sort      {l}] \
			   [list resp             "Responsabile" no_sort      {l}] \
			   [list comune           "Comune"       no_sort      {l}] \
			   [list indirizzo_ext    "Indirizzo"    no_sort      {l}] \
			   [list desc_stato       "Stato"        no_sort      {l}] \
			   [list descr_camp       "Campagna"     no_sort      {l}] \
			   [list tipo_app         "Tipo"         no_sort      {l}] \
			   [list data_verifica    "Data app."    no_sort      {l}] \
			   [list ora_verifica     "Ora app."     no_sort      {l}] \
			   [list descr_enve       $title_enve    no_sort      {l}] \
                        [list n_generatori     "N.G."         no_sort      {<td nowrap align=centre><font color=red><b>$n_generatori</b></font></td>}] \
                        [list flag_tipo_impianto  "TI"          no_sort  $stato_imp] \
			   [list modifica         "Mod."         no_sort $modifica] \
			  ]
    }
}

# imposto la query SQL 
set where_cond ""

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
    set where_word  " and b.cognome like upper(:search_word_1)
                    "
}
append where_cond " $where_word"

if {[string equal $f_resp_nome ""]} {
    set where_nome ""
} else {
    set f_resp_nome_1 [iter_search_word $f_resp_nome]
    set where_nome  " and b.nome like upper(:f_resp_nome_1) "
}
append where_cond " $where_nome"

if {![string equal $f_campagna ""]} {
    set where_cinc "and a.cod_cinc = :f_campagna "
}

append where_cond " $where_cinc"

#dpr74
if {![string equal $flag_tipo_impianto ""]} {
    set where_tipo_imp  "and c.flag_tipo_impianto = :flag_tipo_impianto"
} else {
set where_tipo_imp ""
}

append where_cond " $where_tipo_imp"
#dpr74

# imposto filtro per data appuntamento
if {![string equal $f_da_data_verifica ""] || ![string equal $f_a_data_verifica ""]} {
    if {[string equal $f_da_data_verifica ""]} {
	set f_da_data_verifica "18000101"
    }
    if {[string equal $f_a_data_verifica ""]} {
	set f_a_data_verifica  "21001231"
    }
    set where_data_installaz "and a.data_verifica between :f_da_data_verifica and :f_a_data_verifica"
} else {
    set where_data_installaz ""
}

# imposto filtro per data
if {![string equal $f_da_data ""]} {
    switch $f_tipo_data {
	"E" {set var_data "a.data_estrazione"}
	"I" {set var_data "a.data_verifica  "}
	"A" {set var_data "a.data_assegn    "}
	default {set var_data ""}
    }
    if {$var_data ne ""} {
	if {![string equal $f_da_data ""] || ![string equal $f_a_data ""]} {
	    if {[string equal $f_da_data ""]} {
		set f_da_data "19000101"
	    }
	    if {[string equal $f_a_data ""]} {
		set f_a_data  "21001231"
	    }
	    set where_data "and $var_data between :f_da_data and :f_a_data"
	} else {
	    set where_data ""
	}
    } else {
	set where_data ""
    }
    append where_cond " $where_data"
}

# imposto filtro per codice impianto
# solo se si viene richiamati dalla gestione impianti
# oppure dal cerca
if {$flag_aimp == "S" || $caller != "index"} {
    if {![string equal $cod_impianto ""]} {
	append where_cond " and c.cod_impianto = :cod_impianto"
    }
}

if {![string equal $f_cod_impianto ""]} {
    append where_cond " and c.cod_impianto_est = :f_cod_impianto"
}

# imposto filtro per tipo estrazione
if {![string equal $f_tipo_estrazione ""]} {
    append where_cond " and a.tipo_estrazione = :f_tipo_estrazione"
}

# imposto il filtro per data installazione compresa negli anni indicati
if {![string equal $f_anno_inst_da ""]} {
    append where_cond " and to_char(c.data_installaz,'yyyy') >= :f_anno_inst_da"
}
if {![string equal $f_anno_inst_a ""]} {
    append where_cond " and to_char(c.data_installaz,'yyyy') <= :f_anno_inst_a"
}

# imposto la condizione SQL per cod_combustibile
if {![string equal $f_cod_comb ""]} {
    append where_cond " and c.cod_combustibile = :f_cod_comb"
}

# imposto la condizione SQL per cod_noin
if {![string equal $f_cod_noin ""]} {
    append where_cond " and a.cod_noin = :f_cod_noin"
}

# imposto il filtro per tecnico ed ente verificatore
set pos_join_coimopve "left outer join coimopve"
set pos_join_coimenve "left outer join coimenve"
set ora_join_coimopve "(+)"
set ora_join_coimenve "(+)"

if {![string equal $f_cod_tecn ""]} {
    set pos_join_coimopve "inner join coimopve"
    set ora_join_coimopve ""
    append where_cond " and a.cod_opve = :f_cod_tecn"
} else {
    if {![string equal $f_cod_enve ""]} {
	set pos_join_coimenve " inner join coimenve"
	set ora_join_coimenve ""
	append where_cond " and h.cod_enve = :f_cod_enve"
    }
}

# imposto il filtro per comune
if {![string equal $f_cod_comune ""] && $coimtgen(flag_ente) == "P"} {
    append where_cond " and c.cod_comune = :f_cod_comune"
}

# filtro per tipo_lettera
if {![string equal $f_tipo_lettera ""]} {
    append where_cond " and a.tipo_lettera = :f_tipo_lettera"
}

# imposto filtro per via
if {![string equal $f_cod_via ""] &&  $flag_viario == "T"} {
    append where_cond " and c.cod_via = :f_cod_via"
} else {
    if {(![string equal $f_descr_via ""]
	 ||   ![string equal $f_descr_topo ""])
	&&  $flag_viario == "F"} {
	set f_descr_via1  [iter_search_word $f_descr_via]
	set f_descr_topo1 [iter_search_word $f_descr_topo]
	append where_cond "
        and c.indirizzo like upper(:f_descr_via1)
        and c.toponimo  like upper(:f_descr_topo1) "
    }
}

set col_numero  "lpad(c.numero, 8, '0')"
if {![string equal $f_civico_da ""]} {
    set where_civico_da " and $col_numero >= lpad(:f_civico_da, 8, '0') "
} else {
    set where_civico_da ""
}
append where_cond "$where_civico_da"

if {![string equal $f_civico_a ""]} {
    set where_civico_a " and $col_numero <= lpad(:f_civico_a, 8, '0')"
} else {
    set where_civico_a ""
}
append where_cond "$where_civico_a"

# imposto filtro per stato
switch $nome_funz {
    "inco-asse" {
	if {$flag_cod_enve == "t"} {
	    append where_cond "
            and a.stato in ('0','1','2','5') -- Estratto, Da assegnare, Assegnato,  Annullato"
	} else {
	    append where_cond "
            and a.stato in ('0','1','5') -- Estratto, Da assegnare, Annullato"
	}
    }
    "inco-stam" {
	append where_cond "
        and a.stato = '2'            -- Assegnato"
    }
    "inco-conf" {
	append where_cond "
        and a.stato = '3'            -- Stampato"
    }
    "inco-effe" {
	append where_cond "
        and a.stato in ('3','4','6') -- Stampato, Confermato, Da effettuare"
    }
    "inco-annu" {
	append where_cond "
        and a.stato <> '5'           -- Tutti meno che annullato"
    }
    default     {
	# include sia nome_funz = 'inco-cimp' che 'incontro'
	set where_stat ""
	if {![string equal $f_stato ""]} {
	    set where_stat "
             and a.stato = :f_stato "
        }

	if {$flag_scar == "S" || $flag_scar == "A"} {
	    set where_stat " 
             and a.stato = '0' "
	}
	if {$flag_scar2 == "S"} {
	    set where_stat " 
             and a.stato in ('2', '3', '4') "
	}
	append where_cond $where_stat
    }
}

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

	set where_area "and c.cod_comune in $lista_comu"
    } else {
	set where_area ""
    }
    append where_cond $where_area
} else {
    set where_area ""
}

if {$f_con_data_app eq "S"} {#rom01 Aggiunte if, elseif, else e il loro contenuto
    append where_cond " and a.data_verifica is not null"
} elseif {$f_con_data_app eq "N"} {
    append where_cond  " and a.data_verifica is null"
} else {
    append where_cond ""
}

# se entro come verificatore e sono provincia di mantoav o provincia di padova 
# visualizzo solo gli incontri dallo stato assegnato in poi.
if {$flag_ente == "P"
    &&  ($sigla_prov == "MN" || $sigla_prov == "PD")
    && ![string equal $cod_tecn ""]} {
    append where_cond " and a.stato >= 3"
}

# filtro per parola di ricerca
set pos_join_coimcitt "left outer join coimcitt"
set ora_join_coimcitt "(+)"
if {![string equal $search_word ""]} {
    set search_word_1 [iter_search_word $search_word]
    set pos_join_coimcitt "     inner join coimcitt"
    set ora_join_coimcitt ""
    append where_cond  "
    and b.cognome like upper(:search_word_1)"
}

# posizionatore per pagina successiva
set where_last ""
if {$last_cod_inco ne ""} {
    set last_comune     [lindex $last_cod_inco 0]
    set last_indirizzo  [lindex $last_cod_inco 1]
    set last_numero     [lindex $last_cod_inco 2]
    set last_inco       [lindex $last_cod_inco 3]

#    if {$indirizzo ne ""} {
#	set indirizzo_eq  "and e.descrizione >= :indirizzo"
#    } else {
#	set indirizzo_eq  ""
#    }
    set where_last_si_vie "and ( (d.denominazione = :last_comune and e.descrizione = :last_indirizzo and lpad(c.numero, 8, '0') = :last_numero and a.cod_inco > :last_inco)
                              or (d.denominazione = :last_comune and e.descrizione = :last_indirizzo and lpad(c.numero, 8, '0') > :last_numero)
                              or (d.denominazione = :last_comune and e.descrizione > :last_indirizzo)
                              or (d.denominazione > :last_comune) )"
    set where_last_no_vie "and ( (d.denominazione = :last_comune and e.descrizione = :last_indirizzo and lpad(c.numero, 8, '0') = :last_numero and a.cod_inco > :last_inco)
                              or (d.denominazione = :last_comune and e.descrizione = :last_indirizzo and lpad(c.numero, 8, '0') > :last_numero)
                              or (d.denominazione = :last_comune and e.descrizione > :last_indirizzo)
                              or (d.denominazione > :last_comune) )"
} else {
    set where_last_si_vie ""
    set where_last_no_vie ""
}

if {$flag_aimp != "S" && $caller == "index"} {
    if {[string equal $num_rec ""]} {
	set num_rec [db_string sel_inco_count ""]
    }
    set dett_num_rec "Appuntamenti selezionati: $num_rec"
} else {
    set dett_num_rec "&nbsp;"
}

if {$flag_viario == "T"} {
    set sel_inco [db_map sel_inco_si_vie]
} else {
    set sel_inco [db_map sel_inco_no_vie]
}

set table_result [ad_table -Tmax_rows $rows_per_page -Tmissing_text "Nessun dato corrisponde ai criteri impostati." -Textra_vars {last_cod_inco cod_inco cognome nome indirizzo comune numero nome_funz nome_funz_caller extra_par flag_aimp cod_impianto url_aimp url_list_aimp} go $sel_inco $table_def]

# preparo url escludendo last_cod_inco che viene passato esplicitamente
# per poi preparare il link alla prima ed eventualmente alla prossima pagina
set url_vars [export_ns_set_vars "url" "last_cod_inco num_rec"]&[export_url_vars num_rec]
set link_altre_pagine "Vai alla <a href=\"$curr_prog?$url_vars\">prima pagina</a>"

# preparo link a pagina successiva
set ctr_rec [expr [regsub -all <tr $table_result <tr comodo] -1]
if {$ctr_rec == $rows_per_page} {
    set last_cod_inco [list $comune $indirizzo $numero $cod_inco]
    append url_vars          "&[export_url_vars last_cod_inco]"
    append link_altre_pagine " o alla <a href=\"$curr_prog?$url_vars\">pagina successiva</a>"
}

# creo testata della lista
set list_head [iter_list_head $form_di_ricerca   $col_di_ricerca \
		   $dett_num_rec   $link_altre_pagine $link_righe "Righe per pagina"]

db_release_unused_handles
ad_return_template 
