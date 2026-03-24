ad_library {
    Provides various functions for the package.

    @author Nicola Mortoni
    @cvs-id iter-adp-procs.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    rom07 24/11/2023 Modificata la proc iter_links_form per fare in modo che anche gli ispettori
    rom07            possano vedere il link Pagamenti. Fatto su richiesta di Armena Sviluppo per
    rom07            Citta' Metropolittana di Napoli.

    mic01 20/01/2023 Modificate label da "Rapp. Ispezione" a "Rapp. Ispezione/Accertamento".

    rom06 24/01/2022 Modificata la proc iter_links_form per fare in modo che anche gli ispettori
    rom06            possano vedere il link Documenti. Fatto su richiesta della Provincia di Salerno
    rom06            ma Sandro ha detto che va bene per tutti gli altri enti.
    rom06bis         Il link e' stato aggiunto per gli utenti opve e enve.

    rom05 12/01/2021 Le particolarita' della Provincia di Salerno da ora sono per tutta la 
    rom05            Regione Campania.

    rom04 10/07/2019 Modificato link Scheda 11 per la Provincia di Salerno: se ci sono errori 
    rom04            non mi manda sulla coimdimp-list ma sul warning, solo per i Manutentori

    gac03 20/11/2019 Non devo più fare il redirect alla coimaimp_warning perchè i manutentori
    gac03            e l'ente devono poter vedere lo storico degli allegati caricati anche se
    gac03            il manutentore non ha ancora completato la compilazione dei dati
    gac03            obbligatori del libretto

    sim05 12/03/2019 Modificato iter_return_complaint.
    sim05            Per questioni di sicurezza il messaggio di errore non viene più passato nel link
    sim05            alla pagina standard-error ma viene settato in una variabile di sessione.

    rom01 19/11/2018 Modificati i link resp e occup su richesta di Sandro: qualsiasi sia il tipo 
    rom01            di utente si andrà sempre in visualizzazione e non si potranno più modificare
    rom01            i soggetti.

    rom03 09/08/2018 Modificate le label per la targa e codice impianto su richiesta della Regione Marche.

    rom02 19/06/2018 Modificato link Stampa Libretto - Tipologia d'intervento in Stampa Libretto.
    rom02            Tolto il parametro f_tipo_inte perchè si usa il campo tipoogia_intervento della coimaimp
    rom02            Per le Marche modificato link dei generatori
  
    sim04 11/06/2018 Deciso con Sandro che se è presente la gestione della targa, nella barra dei menù
    sim04            non visualizziamo il codice utenza ma la targa.

    gac02 19/04/2018 Modificato link Scheda 11: se ci sono errori non mi manda sulla coimdimp-list 
    gac02            ma sul warning

    gac01 11/04/2018 Aggiunta voce menu "Scheda 1Bis Dati Generali"

    rom01 05/03/2018 Modificato Scheda Imp. con Stampa Libretto - Tipologia d'intervento.

    sim03 05/02/2018 Rivisto il menù dell'impianto per renderlo simile al libretto

    sim02 05/12/2017 Aggiunto l'help nel iter_tab_form.

    sim01 05/20/2017 Valorizzo nella stampa scheda impianto il tipo intervento in base al link
    sim01            selezionato dall'utente.

    ale01 22/02/2017 La mod_tab è stata modificata per permettere una migliore visualizzazione
    ale01            tablet

    nic01 17/09/2015 Modificata proc iter_links_form per evidenziare il link Dichiarazioni
    nic01            quando vengono usati i programmi coimdope-aimp-gest e coimdimp-dam-gest.
}


ad_proc -private iter_set_func_class {
    funzione
} {
    set func_v "func-menu"
    set func_m "func-menu"
    set func_d "func-menu"
    set func_i "func-menu"

    switch $funzione {
	"V" {set func_v "func-sel"}
	"M" {set func_m "func-sel"}
	"D" {set func_d "func-sel"}
	"I" {set func_i "func-sel"}
    }

    uplevel [list set func_v $func_v]
    uplevel [list set func_m $func_m]
    uplevel [list set func_d $func_d]
    uplevel [list set func_i $func_i]

    return
}

ad_proc -private iter_form_iniz {} {
    set html "
    <!-- Dark blue frame -->
    <table>
    "

    return $html
}

ad_proc -private iter_form_fine {} {
    set html "
    <!-- End of Form elements -->
    </table>

    "

    return $html
}

ad_proc -private iter_return_complaint {errore} {
    #set package_url [ad_conn package_url]
    set package_url "/iter";#Modificato il 31/03/2014 post z-customizatione di permission::require_permission

    #12/12/2013: nginx blocca tutto se la url è troppo lunga. Faccio una string range
    #12/12/2013: Ne approfitto anche per usare export_vars perchè la export_url_vars è deprecata
    #12/12/2013; ad_returnredirect "$package_url/standard-error?[export_url_vars errore]"
    set errore [string range $errore 0 3000];#12/12/2013

    #sim05 trasformo la stringa javascript in java_oasi che verrà poi ritrasformata dalla pagina standard-error.tcl
    regsub -all "javascript" $errore "java_oasi" errore
    
    ad_set_client_property iter errore_return_complaint $errore;#sim05

#sim05    ad_returnredirect  [export_vars -base $package_url/standard-error {errore}];#12/12/2013
    ad_returnredirect  [export_vars -base $package_url/standard-error];#sim05
    ad_script_abort
    #con ad_script_abort stoppo il task e torno al browser
    #nel frattempo e' partito il nuovo task verso /iter/standard-error.
}

ad_proc iter_context_bar {
    {-nome_funz {}}
     args
} {
    Costruisce la context bar
    Se non viene indicato nome funz costruisce la navigation bar in base
    agli argomenti passati.
    Se viene indicato nome funz mette la HOME, il menu' precedente,
    ed il nome della funzione.
} {
    if {[string is space $nome_funz]} {
        set context_bar $args
    } else {
        set main_directory [ad_conn package_url]
      # aggiungo alla context bar il menu' principale
        set link "${main_directory}main"
        set desc "Home"
        lappend context_bar [list $link $desc]

      # trovo la riga di menu' corrente
        set swc_ogg "f"
        db_foreach sel_ogg2 "" {
            set swc_ogg "t"
	}
        if {$swc_ogg == "t"} {
          # costruisco dinamicamente la where condition per cercare
          # il titolo dell'ultimo menu'
            set where_scelta ""
            set ind_livello 1
            while {$ind_livello <= 4} {
                if {$ind_livello >= $livello} {
                    set scelta_${ind_livello} 0
                }
                append where_scelta "
                and scelta_${ind_livello} = :scelta_${ind_livello}"
                incr ind_livello
            }

          # lancio la query per reperire il titolo dell'ultimo menu'
            if {[db_0or1row sel_ogg2_2 ""] == 1
            } {
              # aggiungo alla context bar il menu' precedente
                set link "${main_directory}main?[export_url_vars livello scelta_1 scelta_2 scelta_3 scelta_4]"
                set desc $desc_menu
                lappend context_bar [list $link $desc]
            }
	}
      # aggiungo alla context bar il titolo della funzione corrente
        lappend context_bar "$desc_funz"
    }

  # ora costruisco la context bar
    set index 0
    set choices ""
    foreach arg $context_bar {
	incr index
	if {$index == [llength $context_bar]} {
            if {$index == 1} {
		lappend choices $arg
	    }
	} else {
	    lappend choices "<a href=\"[lindex $arg 0]\">[lindex $arg 1]</a>"
	}
    }
    return [join $choices " : "]
}

ad_proc iter_list_head {form_di_ricerca des_col_ricerca link_per_azione
                      link_altre_pagine link_righe_per_pagina des_link_righe} {
    Restituisce un frammento html contenente una tabella con a sinistra una
    form di ricerca per le liste, al centro un link per Aggiungi e a destra
    un link per le righe per pagina.
} {
    if {![string is space $form_di_ricerca]} {
        set ricerca "Ricerca $des_col_ricerca"
    } else {
        set ricerca ""
        set form_di_ricerca "<form>&nbsp;</form>"
    }
    set html "
    <table border=0 cellspacing=0 cellpadding=0 width=\"100%\" class=ric_table> 
    <tr bgcolor=ececec>
        <td align=center width=32%><b>$ricerca</b></td>
        <td align=center width=38% nowrap>$link_altre_pagine</td>
        <td align=center width=30%><b>$des_link_righe</b></td>
    </tr> 
    <tr>
        <td align=center>$form_di_ricerca</td>
        <td align=center valign=top>$link_per_azione</td>
        <td align=center valign=top>$link_righe_per_pagina</td>
    </tr>
    </table>
    "
    return $html
}

ad_proc iter_rows_per_page {rows_per_page} {
    Restituisce un frammento html contenente i link standard per selezionare
    il numero di record da visualizzare in un programma di lista.
} {
#   set linked_rownum_list {
#	{rows_per_page "Righe per pagina" $rows_per_page {
#           {10  "10"  {}}
#           {30  "30"  {}}
#	    {50  "50"  {}}
#           {100 "100" {}}
#       }   }
#   }

#   set linked_rownum_list [subst $linked_rownum_list]

    set linked_rownum_list ""
    db_foreach sel_rgh "" {
        lappend linked_rownum_list [list $rgh_cde $rgh_cde ""]
    }

    set linked_rownum_list [list [list rows_per_page "Righe per pagina" $rows_per_page $linked_rownum_list]]

    set slider [iter_dimensional $linked_rownum_list]
    return $slider
}

ad_proc iter_set_rows_per_page {rows_per_page id_utente} {
    Restutisce rows_per_page se e' valorizzato, altrimenti restituisce
    il defalult dell'utente, altrimenti ancora restituisce il minimo della
    tabella coimrgh.
} {
    if {[string is space $rows_per_page]} {
        set rows_per_page [ad_get_cookie iter_rows_[ns_conn location]]
    }

    if {[string is space $rows_per_page]} {
        db_1row sel_rgh_2 ""
    }
    return $rows_per_page
}

ad_proc iter_search_form {caller search_word {list_var_da_escl ""}
} {
    Restituisce una form con un campo denominato 'search_word' da
    utilizzare come filtro in una query.
} {
  # reperisco tutte le variabili meno search_word, last_* (last_colonna_chiave)
  # usata per le liste ed eventualmente le col di list_var_da_escl
    lappend list_var_da_escl "search_word"
    lappend list_var_da_escl "last_*"
    set form_vars [iter_export_ns_set_vars "form" $list_var_da_escl]
    set widget    "
<form method=post action=\"$caller\">
 $form_vars
 <input type=text name=search_word size=20 value=\"[ad_quotehtml $search_word]\" class=ric_element>
 <input type=submit value=\"Cerca\" class=ric_submit>
</form>"

    return $widget
}



# Personalizzazione di ad_dimensional per estrarre solamente il frammento
# html conenente i link e non la table!!!
proc_doc iter_dimensional {option_list {url {}} {options_set ""} {optionstype url}} {
    Generate an option bar as in the ticket system; 
    <ul>
      <li> option_list -- the structure with the option data provided 
      <li> url -- url target for select (if blank we set it to ad_conn url).
      <li> options_set -- if not provided defaults to [ns_getform], for hilite of selected options.
      <li> optionstype -- only url is used now, was thinking about extending 
            so we get radio buttons and a form since with a slow select updating one 
            thing at a time would be stupid.
    </ul>
    
    <p>
    option_list structure is 
    <pre>
    { 
        {variable "Title" defaultvalue
            {
                {value "Text" {key clause}}
                ...
            }
        }
        ...
    }

    an example:

    set dimensional_list {
        {visited "Last Visit" 1w {
            {never "Never" {where "last_visit is null"}}
            {1m "Last Month" {where "last_visit + 30 > sysdate"}}
            {1w "Last Week" {where "last_visit + 7 > sysdate"}}
            {1d "Today" {where "last_visit > trunc(sysdate)"}}
        }}
        ..(more of the same)..
    }
    </pre>
} {
    set html {}

    if {[empty_string_p $option_list]} {
        return
    }

    if {[empty_string_p $options_set]} {
        set options_set [ns_getform]
    }
    
    if {[empty_string_p $url]} {
        set url [ad_conn url]
    }

#nm append html "<table border=0 cellspacing=0 cellpadding=3 width=100%>\n<tr>\n"

#nm foreach option $option_list { 
#nm      append html " <th bgcolor=\"#ECECEC\">[lindex $option 1]</th>\n"
#nm  }
#nm append html "</tr>\n"

#nm append html "<tr>\n"

    foreach option $option_list { 
#nm     append html " <td align=center>\["
        append html "\["

        # find out what the current option value is.
        # check if a default is set otherwise the first value is used
        set option_key [lindex $option 0]
        set option_val {}
        if { ! [empty_string_p $options_set]} {
            set option_val [ns_set get $options_set $option_key]
        }
        if { [empty_string_p $option_val] } {
            set option_val [lindex $option 2]
        }
        
        set first_p 1
        foreach option_value [lindex $option 3] { 
            set thisoption [lindex $option_value 0]
            if { $first_p } {
                set first_p 0
            } else {
                append html " | "
            } 
            
            if {[string compare $option_val $thisoption] == 0} {
                append html "<strong>[lindex $option_value 1]</strong>"
            } else {
                append html "<a href=\"$url?[export_ns_set_vars "url" $option_key $options_set]&[ns_urlencode $option_key]=[ns_urlencode $thisoption]\">[lindex $option_value 1]</a>"
            }
        }
#nm     append html "\]</td>\n"
        append html "\]"
    }
#nm append html "</tr>\n</table>\n"
return $html
}

# personalizzazione della proc originale per accettare in exclusion_list
# anche i caratteri jolly
ad_proc iter_export_ns_set_vars {{format "url"} {exclusion_list ""}  {setid ""}} {
    Returns all the params in an ns_set with the exception of those in
    exclusion_list. If no setid is provide, ns_getform is used. If format
    = url, a url parameter string will be returned. If format = form, a
    block of hidden form fragments will be returned.  
}  {

    if [empty_string_p $setid] {
	set setid [ns_getform]
    }

    set return_list [list]
    if ![empty_string_p $setid] {
        set set_size [ns_set size $setid]
        set set_counter_i 0
        while { $set_counter_i<$set_size } {
            set name [ns_set key $setid $set_counter_i]
            set value [ns_set value $setid $set_counter_i]
            if {![empty_string_p $name]} {
                set sw_trovato "f"
                foreach exclusion_el $exclusion_list {
                    if {[string match $exclusion_el $name]} {
                        set sw_trovato "t"
                        break
                    }
                }
                if {$sw_trovato == "f"} {
                    if {$format == "url"} {
                        lappend return_list "[ns_urlencode $name]=[ns_urlencode $value]"
                    } else {
                        lappend return_list " name=\"[ad_quotehtml $name]\" value=\"[ad_quotehtml $value]\""
		    }
                }
            }
            incr set_counter_i
        }
    }
    if {$format == "url"} {
        return [join $return_list "&"]
    } else {
        return "<input type=\"hidden\" [join $return_list ">\n <input type=\"hidden\" "] >"
    }
}

ad_proc iter_links_form {
    cod_impianto 
    nome_funz_caller 
    url_list_aimp
    url_aimp
    {extra_par ""}
    {flag_tracciato ""}
} {
    Restituisce una variabile contenente i link utilizzati dal programma
    di gestione degli impianti
} {

    set nome_funz_caller_cimp $nome_funz_caller

    if {$nome_funz_caller eq "cimp"} {
	set nome_funz_caller "impianti"
    }
    
    iter_get_coimtgen
    set flag_ente  $coimtgen(flag_ente)
    set sigla_prov $coimtgen(sigla_prov)

    # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]

    # imposto variabile uten per poi creare il tabella di link in base
    # al tipo di utente
    set uten "default"
    set nome_funz_impianti "impianti"

    # imposto la directory dei programmi
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    append pack_dir "src"

    # controllo se l'utente � un manutentore
    if {[iter_check_uten_manu $id_utente] != ""} {
	set uten "manu"
    }
    
    # controllo se l'utente e' il responsabile cooperativa 
    if {[iter_check_uten_coop_resp $id_utente] != ""} {
	set uten "coop_resp"
    }
    
    # controllo se l'utente e' l'addetto mod h cooperativa 
    if {[iter_check_uten_coop_modh $id_utente] != ""} {
	set uten "coop_modh"
    }
    # controllo se l'utente e' l'addetto rapp.ver. cooperativa 
    if {[iter_check_uten_coop_rappv $id_utente] != ""} {
	set uten "coop_rappv"
    }
    # controllo se l'utetne e' un ente verificatore o operatore
    set cod_tecn  [iter_check_uten_opve $id_utente]
    set cod_enve  [iter_check_uten_enve $id_utente]
    if {![string equal $cod_tecn ""]} {
	set uten "opve"
	set nome_funz_impianti "impianti-ver"
    }
   
    if {![string equal $cod_enve ""]} {
	set uten "enve"
	set nome_funz_impianti "impianti-ver"
    }

    set provenienza [ns_conn url]
    set prog [file tail $provenienza]

    set nome_funz [iter_get_nomefunz coimaimp-isrt-veloce]
    set nome_funz_inco "inco"

    if {$nome_funz_caller == $nome_funz} {
        set coimaimplist "
        <td width=\"12.5%\" nowrap class=func-menu-yellow>
           <a href=\"$pack_dir/coimaimp-isrt-veloce?[export_url_vars nome_funz]\" class=func-menu-link-yellow>Inserim. Imp.</a>
        </td>"
    } else {

	if {[string range $nome_funz_caller 0 3]== $nome_funz_inco
	||   $nome_funz_caller == "scar"
	} {
	    set coimaimplist "
             <td width=\"12.5%\" nowrap class=func-menu-yellow>
               <a href=\"$url_list_aimp\" class=func-menu-link-yellow>Appuntamento</a>
             </td>"
	} else {
	    if {$nome_funz_caller == [iter_get_nomefunz coimmai2-filter]} {
		set coimaimplist "
                 <td width=\"12.5%\" nowrap class=func-menu-yellow>
                   <a href=\"$url_list_aimp\" class=func-menu-link-yellow>Acquis. impianti</a>
                 </td>"
	    } else {
		set flag_controllo "f"
		db_foreach sel_funz_dimp_ins "select nome_funz as nome_funz_dimp_ins_check
                              from coimfunz
                             where dett_funz = 'coimdimp-ins-filter' 
                " {
		    if {$nome_funz_caller == $nome_funz_dimp_ins_check} {
			set nome_funz_dimp_ins $nome_funz_dimp_ins_check
			set flag_controllo  "t"
		    }
		}

		if {$flag_controllo == "t"} {
		    set coimaimplist "
                         <td width=\"12.5%\" nowrap class=func-menu-yellow>
                         <a href=coimdimp-ins-filter?nome_funz=$nome_funz_dimp_ins&cod_impianto_old=$cod_impianto&flag_tracciato=$flag_tracciato class=func-menu-link-yellow>Ritorna</a>
                         </td>"
		} else {
		    if {$nome_funz_caller == [iter_get_nomefunz coimbimp-filter]} {
			set coimaimplist "
                        <td width=\"12.5%\" nowrap class=func-menu-yellow>
                        <a href=coimbimp-filter?nome_funz=[iter_get_nomefunz coimbimp-filter]&cod_impianto_old=$cod_impianto class=func-menu-link-yellow>Ritorna</a>
                       </td>"
		    } else {
			if {[string length $url_list_aimp] == 0} {
			    if {$nome_funz_caller == "asresp-admin"} {
				set coimaimplist  "
							<td width=\"12.5%\" nowrap class=func-menu-yellow>
							   <a href=\"$pack_dir/coim_as_resp_admin-list?nome_funz=[iter_get_nomefunz coim_as_resp_admin-list]\" class=func-menu-link-yellow>Lista schede</a>
							</td>"
			    } else {
				set coimaimplist  "
							<td width=\"12.5%\" nowrap class=func-menu-yellow>
							   <a href=\"$pack_dir/coimaimp-filter?nome_funz=impianti\" class=func-menu-link-yellow>Filtro Impianti</a>
							</td>"
			    }
			} else {
			    set coimaimplist "
					<td width=\"12.5%\" nowrap class=func-menu-yellow>
					   <a href=\"$url_list_aimp\" class=func-menu-link-yellow>Lista Impianti</a>
					</td>"
			}
		    }
		}
	    }
	}
    }


    set coimdimp "$pack_dir/coimdimp-list?"
    set link_dimp "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimdimp-list]"

    set flag_cimp "S"
    set link_gage "[export_url_vars cod_impianto cod_manutentore url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimgage-gest]"

    set link_cimp "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp flag_cimp]&nome_funz=[iter_get_nomefunz coimcimp-list]"
    
    set link_tecn "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti" 

    set link_sogg "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    set link_todo "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimtodo-list]&flag_impianti=T"

    set link_essi "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimessi-gest]"

    set link_movi "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimmovi-gest]"

    set link_prvv "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimprvv-gest]"

    set link_maps "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti"

    set link_as_resp "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coim_as_resp-gest]"

    db_1row sel_count_gend ""
    switch $conta_gend {
	1 {set coimgend "$pack_dir/coimgend-gest?funzione=V&"
           db_1row sel_cod_gend ""
           set link_gend "[export_url_vars cod_impianto url_list_aimp nome_funz_caller gen_prog url_aimp]&nome_funz=[iter_get_nomefunz coimgend-gest]"
	}
	default {set coimgend "$pack_dir/coimgend-list?"
                 set link_gend "[export_url_vars cod_impianto url_list_aimp last_cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimgend-list]"
	}
    }

    set link_gest "$url_aimp&[export_url_vars url_list_aimp]"
    set link_docu "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimdocu-list]"

    set link_sche "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

#    set link_cont "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimcont-list]"

    set flag_aimp "S"
    set link_inco "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp flag_aimp]&nome_funz=incontro"

    set link_ubic "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    set link_stpm "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimstpm-menu]"

    if {$prog == "coimaimp-gest"} {
	set coimaimpgest "<td width=\"12.5%\" nowrap class=func-sel-yellow>
              <a href=\"$pack_dir/coimaimp-gest?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-sel-yellow>Scheda 1 <br> Dati Tecnici</a>
            </td>"
    } else {
	set coimaimpgest "<td width=\"12.5%\" nowrap class=func-menu-yellow>
              <a href=\"$pack_dir/coimaimp-gest?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-menu-link-yellow>Scheda 1 <br> Dati Tecnici</a>
              </td>"

    }

    if {$prog == "coimaimp-altre-schede-list"} {

	set coimaimp_altreschede "<td width=\"12.5%\" nowrap class=func-sel-yellow colspan=1>
              <a href=\"$pack_dir/coimaimp-altre-schede-list?[export_url_vars cod_impianto url_list_aimp url_aimp]&nome_funz=impianti&nome_funz_caller=impianti\" class=func-sel-yellow>Altre schede libretto</a>
              </td>"
    } else {
	set coimaimp_altreschede "<td width=\"12.5%\" nowrap class=func-menu-yellow colspan=1>
              <a href=\"$pack_dir/coimaimp-altre-schede-list?[export_url_vars cod_impianto url_list_aimp url_aimp]&nome_funz=impianti&nome_funz_caller=impianti\" class=func-menu-link-yellow>Altre schede libretto</a>
              </td>"
    }

    if {$uten == "manu"} {
	if {$prog == "coimgage-isrt"} {
	    set coimgage "<td width=\"12.5%\" nowrap class=func-sel-yellow>
                      <a href=\"$pack_dir/coimgage-isrt?$link_gage\" class=func-sel-yellow>Gestione Agenda</a></td>"
	} else {
	    set coimgage "<td width=\"12.5%\" nowrap class=func-menu-yellow>
                  <a href=\"$pack_dir/coimgage-isrt?$link_gage\" class=func-menu-link-yellow>Gestione Agenda</a></td>"
	}
    } else {
	set coimgage "<td width=\"12.5%\" nowrap class=func-menu-yellow>
                      &nbsp;
                      </td>"
    }

    if {$prog == "coimaimp-tecn"
    ||  $prog == "coimrift-list"
    } {
        set coimaimptecn "<td width=\"12.5%\" nowrap class=func-sel-yellow>
         <a href=\"$pack_dir/coimaimp-tecn?&$link_tecn\" class=func-sel-yellow>Ditte/Tecnici</a>
      </td>"
    } else {
        set coimaimptecn "<td width=\"12.5%\" nowrap class=func-menu-yellow>
         <a href=\"$pack_dir/coimaimp-tecn?&$link_tecn\" class=func-menu-link-yellow>Ditte/Tecnici</a>
      </td>"
    }
    if {$prog == "coimaimp-sogg"
    ||  $prog == "coimrifs-list"
    } {
	set coimaimpsogg "<td width=\"12.5%\" nowrap class=func-sel-yellow>
         <a href=\"$pack_dir/coimaimp-sogg?&$link_sogg\" class=func-sel-yellow>Scheda 1.6 <br> Soggetti resp.</a>         </td>"
    } else {
	set coimaimpsogg "<td width=\"12.5%\" nowrap class=func-menu-yellow>
         <a href=\"$pack_dir/coimaimp-sogg?&$link_sogg\" class=func-menu-link-yellow>Scheda 1.6 <br> Soggetti resp.</a>         </td>"
    }



    db_1row sel_multivie_count ""

    if {$count_multi > 0} {
	set ubicazione "<font color=red>Scheda 1.2 <br> Ubicazione</font>"
    } else {
	set ubicazione "Scheda 1.2 <br> Ubicazione"
    }

    if {$prog == "coimaimp-ubic"
    ||  $prog == "coimstub-list"
    } {
	set coimaimpubic "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimaimp-ubic?&$link_ubic\" class=func-sel-yellow>$ubicazione</a>
      </td>"
    } else {
	set coimaimpubic "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimaimp-ubic?&$link_ubic\" class=func-menu-link-yellow>$ubicazione</a>
      </td>"
    }
    if {$coimtgen(regione) eq "MARCHE"} {#rom02: if, else e loro contenuto
	if {$prog == "coimgend-gest"
	    ||  $prog == "coimgend-list"
	} {
	    set coimgend "<td width=\"12.5%\" nowrap class=func-sel-yellow>
              <a href=\"$coimgend$link_gend\" class=func-sel-yellow>Scheda 4 / 4.1 bis <br> Generatori</a>
              </td>"
	} else {
	    set coimgend "<td width=\"12.5%\" nowrap class=func-menu-yellow>
              <a href=\"$coimgend$link_gend\" class=func-menu-link-yellow>Scheda 4 / 4.1 bis <br> Generatori</a>
              </td>"
	}
    } else {
	if {$prog == "coimgend-gest"
            ||  $prog == "coimgend-list"
        } {
            set coimgend "<td width=\"12.5%\" nowrap class=func-sel-yellow>
              <a href=\"$coimgend$link_gend\" class=func-sel-yellow>Scheda 4 <br> Generatori</a>
              </td>"
        } else {
            set coimgend "<td width=\"12.5%\" nowrap class=func-menu-yellow>
              <a href=\"$coimgend$link_gend\" class=func-menu-link-yellow>Scheda 4 <br> Generatori</a>
              </td>"
        }
    };#rom02
    if {$prog == "coimprvv-gest"
    ||  $prog == "coimprvv-list"
    } {
	set coimprvv "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimprvv-list?$link_prvv\" class=func-sel-yellow>Provvedimenti</a>
      </td>"
    } else {
	set coimprvv "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimprvv-list?$link_prvv\" class=func-menu-link-yellow>Provvedimenti</a>
      </td>"
    }
    if {$prog == "coimmovi-gest"
    ||  $prog == "coimmovi-list"
    } {
	set coimmovi "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimmovi-list?$link_movi\" class=func-sel-yellow>Pagamenti</a>
      </td>"
    } else {
	set coimmovi "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimmovi-list?$link_movi\" class=func-menu-link-yellow>Pagamenti</a>
      </td>"
    }

    db_1row sel_docu_count ""

    if {$count_docu > 0} {
	set documenti "<font color=red>Documenti</font>"
    } else {
	set documenti "Documenti"
    }

    if {$prog == "coimdocu-gest"
    ||  $prog == "coimdocu-list"
    } {
	set coimdocu "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimdocu-list?$link_docu\" class=func-sel-yellow>$documenti</a>
      </td>"
    } else {
	set coimdocu "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimdocu-list?$link_docu\" class=func-menu-link-yellow>$documenti</a>
      </td>"
    }
        
    if {$coimtgen(regione) eq "MARCHE"} {

	set label_dichiarazioni "Inserisci moduli regionali"

    } else {

	#sim set label_dichiarazioni "Dichiarazioni"
	set label_dichiarazioni "RCEE"
    }
    
    #gac02 modificato link solo per regione marche
    #rom04 Aggiunta condizione per Provincia di Salerno
    #rom05if {$coimtgen(regione) eq "MARCHE" || ($coimtgen(ente) eq "PSA" && $uten eq "manu")} {}
    if {$coimtgen(regione) in [list "MARCHE" "CAMPANIA"]} {#rom05 aggiunta if ma non contenuto
	set coimaimp_warning "/iter/src/coimaimp-warning?"
	set link_scheda "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimdimp-list]&caller=dimp"
	    
	if {$prog == "coimdimp-gest"
	    ||  $prog == "coimdimp-list"
	    ||  $prog == "coimandi-list"
	    ||  $prog == "coimandi-gest"
	    ||  (  $prog == "coimanom-list"
		   && $extra_par == "MH")  
	    ||  (  $prog == "coimanom-gest"
		   && $extra_par == "MH")
	    ||  $prog == "coimdope-aimp-gest"
	    ||  $prog == "coimdimp-dam-gest"
	    ||  ($prog == "coimaimp-warning" && $nome_funz_caller_cimp ne "cimp")
	} {
	    #gac03 l'href veniva fatto con la variabile $coimaimp_warning
	    set coimdimp "<td width=\"12.5%\" nowrap class=func-sel-yellow>
         <a href=\"$coimdimp&$link_scheda\" class=func-sel-yellow>$label_dichiarazioni</a>
      </td>"
	} else {
	    #gac03 l'href veniva fatto con la variabile $coimaimp_warning
	    set coimdimp "<td width=\"12.5%\" nowrap class=func-menu-yellow>
         <a href=\"$coimdimp&$link_scheda\" class=func-menu-link-yellow>$label_dichiarazioni</a>
      </td>"
	}

    } else {
	if {$prog == "coimdimp-gest"
	    ||  $prog == "coimdimp-list"
	    ||  $prog == "coimandi-list"
	    ||  $prog == "coimandi-gest"
	    ||  (  $prog == "coimanom-list"
		   && $extra_par == "MH")  
	    ||  (  $prog == "coimanom-gest"
		   && $extra_par == "MH")
	    ||  $prog == "coimdope-aimp-gest"
	    ||  $prog == "coimdimp-dam-gest"
	} {
	    set coimdimp "<td width=\"12.5%\" nowrap class=func-sel-yellow>
         <a href=\"$coimdimp&$link_dimp\" class=func-sel-yellow>Scheda 11 <br> $label_dichiarazioni</a>
      </td>"
	} else {
	    set coimdimp "<td width=\"12.5%\" nowrap class=func-menu-yellow>
         <a href=\"$coimdimp&$link_dimp\" class=func-menu-link-yellow>Scheda 11 <br> $label_dichiarazioni</a>
      </td>"
	}
    }
    
    if {$prog == "coimcimp-list"
    ||  $prog == "coimcimp-gest"
    ||  $prog == "coimcimp-gend-list"
    ||  $prog == "coimcimp-manc-gest"
    ||  (   $prog == "coimanom-list"
        &&  $extra_par == "RV")
    ||  (   $prog == "coimanom-gest"
	&&  $extra_par == "RV")
    } {
	set coimcimp "<td width=\"12.5%\" nowrap class=func-sel-yellow>
         <a href=\"$pack_dir/coimcimp-list?&$link_cimp\" class=func-sel-yellow>Scheda 13 <br> Rapp. Ispezione/Accertamento</a>
      </td>"
    } else {
	set coimcimp "<td width=\"12.5%\" nowrap class=func-menu-yellow>
         <a href=\"$pack_dir/coimcimp-list?&$link_cimp\" class=func-menu-link-yellow>Scheda 13 <br> Rapp. Ispezione/Accertamento</a>
      </td>"
    }

    if  {$prog == "coiminco-list"
    ||   $prog == "coiminco-gest"
    } {
	set coiminco "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coiminco-list?&$link_inco\" class=func-sel-yellow>Appuntamenti</a>
      </td>"
    } else {
	set coiminco "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coiminco-list?&$link_inco\" class=func-menu-link-yellow>Appuntamenti</a>
      </td>"
    }
    db_1row sel_count_todo ""

    if {$conta_todo > 0} {
	set attivita_sospese "<font color=red>Attivit&agrave; sospese</font>"
    } else {
	set attivita_sospese "Attivit&agrave; sospese"
    }

    if {$prog == "coimtodo-gest"
    ||  $prog == "coimtodo-list"
    } {
	set coimtodo "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimtodo-list?&$link_todo\" class=func-sel-yellow>$attivita_sospese</a>
      </td>"
    } else {
	set coimtodo "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimtodo-list?&$link_todo\" class=func-menu-link-yellow>$attivita_sospese</a>
      </td>"
    }

    set msg_alert "Confermi la pianificazione?"
    set cmd_conf  [list "javascript:return(confirm('$msg_alert'))"]

    if {$prog == "coimessi-gest"} {
	set coimessi "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coimessi-gest?&$link_essi\" class=func-sel-yellow onclick=\"$cmd_conf\">Pianifica appun.</a>
      </td>"
    } else {
	set coimessi "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coimessi-gest?&$link_essi\" class=func-menu-link-yellow onclick=\"$cmd_conf\">Pianifica appun.</a>
      </td>"
    }

    set label_libretto "Stampa Libretto";#rom02
    
    if {$prog == "coimaimp-sche"} {
	#sim01 set coimsche "<td width=\"12.5%\" nowrap class=func-sel>
        #sim01  <a href=\"$pack_dir/coimaimp-sche?&$link_sche\" class=func-sel>Scheda Imp.</a>
	#sim01 </td>"

#rom02	set coimsche "<td width=\"12.5%\" nowrap class=func-sel-yellow>$label_libretto<br>
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=N\" class=func-menu-link-yellow-minus>Nuova</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=R\" class=func-menu-link-yellow-minus>Rist.</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=S\" class=func-menu-link-yellow-minus>Sost.</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=C\" class=func-menu-link-yellow-minus>Compil.</a>
#rom02 </td>"

	set coimsche "<td width=\"12.5%\" nowrap class=func-sel-yellow><a href=\"$pack_dir/coimaimp-sche?&$link_sche\" class=func-menu-link-yellow-minus>$label_libretto</a></td>";#rom02

    } else {
	#sim01 set coimsche "<td width=\"12.5%\" nowrap class=func-menu>
        #sim01   <a href=\"$pack_dir/coimaimp-sche?&$link_sche\" class=func-menu>Scheda Imp.</a>
	#sim01 </td>"
	#rom01  set coimsche "<td width=\"12.5%\" nowrap class=func-menu-yellow>Scheda Imp.<br>
#rom02	set coimsche "<td width=\"12.5%\" nowrap class=func-menu-yellow>Stampa Libretto - Tipologia d'intervento<br>
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=N\" class=func-menu-link-yellow-minus>Nuova</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=R\" class=func-menu-link-yellow-minus>Rist.</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=S\" class=func-menu-link-yellow-minus>Sost.</a> -
#rom02     <a href=\"$pack_dir/coimaimp-sche?&$link_sche&f_tipo_inte=C\" class=func-menu-link-yellow-minus>Compil.</a>
#rom02 </td>";#sim01

	set coimsche "<td width=\"12.5%\" nowrap class=func-menu-yellow><a href=\"$pack_dir/coimaimp-sche?&$link_sche\" class=func-menu-link-yellow-minus>$label_libretto</a></td>";#rom02

    }

    if  {$prog == "coim_as_resp-gest"
    ||   $prog == "coim_as_resp-list"
    } {
	set coim_as_resp "<td width=\"12.5%\" nowrap class=func-sel-yellow>
          <a href=\"$pack_dir/coim_as_resp-list?&$link_as_resp\" class=func-sel-yellow>Scheda 3 <br> As. terzo resp.</a>
      </td>"
    } else {
	set coim_as_resp "<td width=\"12.5%\" nowrap class=func-menu-yellow>
          <a href=\"$pack_dir/coim_as_resp-list?&$link_as_resp\" class=func-menu-link-yellow>Scheda 3 <br> As. terzo resp.</a>
      </td>"
    }

#    if  {$prog == "coimcont-list"
#    ||   $prog == "coimcont-gest"
#    } {
#	set coimcont "<td width=\"12.5%\" nowrap class=func-sel>
#          <a href=\"$pack_dir/coimcont-list?&$link_cont\" class=func-sel>Contratti</a>
#      </td>"
#    } else {
#	set coimcont "<td width=\"12.5%\" nowrap class=func-menu>
#          <a href=\"$pack_dir/coimcont-list?&$link_cont\" class=func-menu>Contratti</a>
#      </td>"
#    }
#    if {$prog == "coimstpm-menu"} {
#	set coimstpm "<td width=\"12.5%\" nowrap class=func-sel>
#          <a href=\"$pack_dir/coimstpm-menu?&$link_stpm\" class=func-sel>Seleziona Stampa</a>
#      </td>"
#    } else {
#	set coimstpm "<td width=\"12.5%\" nowrap class=func-menu>
#          <a href=\"$pack_dir/coimstpm-menu?&$link_stpm\" class=func-menu>Seleziona Stampa</a>
#      </td>"
#    }

    #gac01 aggiunta voce menu "Scheda 1bis Dati Generali"
    if {$prog == "coimaimp-bis-gest"} {
        set coimaimp_bis_gest "<td width=\"12.5%\" nowrap class=func-sel-yellow>
              <a href=\"$pack_dir/coimaimp-bis-gest?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-menu-link-yellow>Scheda 1Bis <br> Dati Generali</a>
            </td>"
    } else {
        set coimaimp_bis_gest "<td width=\"12.5%\" nowrap class=func-menu-yellow>
              <a href=\"$pack_dir/coimaimp-bis-gest?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-menu-link-yellow>Scheda 1Bis <br> Dati Generali</a>
              </td>"
    }

    if {$prog == "coimaimp-schede-libretto-list" 
	||  ($prog == "coimaimp-warning" && $nome_funz_caller_cimp eq "cimp")
    } {
        set coimaimp_schede_libretto "<td width=\"12.5%\" nowrap class=func-sel-yellow>
              <a href=\"$pack_dir/coimaimp-schede-libretto-list?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-menu-link-yellow>Schede principali<br> del libretto</a>
            </td>"
    } else {
        set coimaimp_schede_libretto "<td width=\"12.5%\" nowrap class=func-menu-yellow>
              <a href=\"$pack_dir/coimaimp-schede-libretto-list?[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti\" class=func-menu-link-yellow>Schede principali<br> del libretto</a>
              </td>"
    }

    if {$coimtgen(regione) eq "MARCHE"} {

	switch $uten {
	    "manu" { set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                    $coimaimplist
                    $coimaimp_schede_libretto
                    $coimaimp_altreschede
                    $coimsche
                    $coimdimp
                    $coimgage
                    $coimaimptecn
                    $coimdocu
<!--sim                    <td colspan=3 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                      " 
	    }
	    "enve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede
                     $coimsche
                     $coimdimp
                     $coimtodo
                     $coimaimptecn
                     $coimdocu <!--rom06bis -->
		     <if @coimtgen.ente@ eq \"PNA\">$coimmovi</if> <!-- rom07 -->
<!--sim                    <td colspan=7 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "opve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede                    
                     $coimsche
                     $coimdimp
                     $coimtodo
                     $coimaimptecn
                     $coimdocu <!--rom06 -->
		     <if @coimtgen.ente@ eq \"PNA\">$coimmovi</if> <!-- rom07 -->
<!--sim                    <td colspan=7 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "coop_resp" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede
                     $coimsche
                     $coimdimp
                     $coimaimptecn
<!--sim                     <td colspan=7 class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "coop_modh" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede
                     $coimsche
                     $coimdimp
                     $coimaimptecn
                 </tr>
                 </table>
                 " 
	    }
	    "coop_rappv" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede
                     $coimsche
                     $coimaimptecn
                 </tr>
                 </table>
                 " 
	    }
	    default {set links "
                 <table width=\"100%\" cellspacing=0>
                 <tr>
                     $coimaimplist
                     $coimaimp_schede_libretto
                     $coimaimp_altreschede
                     $coimsche                     
                     $coimdimp
                     $coimtodo
</tr>
<tr>
                     $coiminco
                     $coimessi
                     $coimprvv
                     $coimmovi
                     $coimaimptecn
                     $coimdocu
                 </tr>
                 </table>" 
	    }
	}
	return $links
	    
    } else {
	switch $uten {
	    "manu" { set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                    $coimaimplist
                    $coimaimpgest
                    $coimaimpubic
                    $coimaimpsogg
                    $coim_as_resp
                    $coimgend
                    $coimdimp
                    $coimaimp_altreschede
                 </tr>
                 <tr>
                    $coimcimp
                    $coimgage
                    $coimaimptecn
                    $coimdocu
                    $coimsche
<!--sim                    <td colspan=3 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "enve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coimgend
                     $coimdimp
                     $coimcimp
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimtodo
                     $coimaimptecn
                     $coimdocu <!--rom06bis -->
		     <if @coimtgen.ente@ eq \"PNA\">$coimmovi</if> <!-- rom07 -->
                     $coimsche
<!--sim                    <td colspan=7 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "opve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coimgend
                     $coimdimp
                     $coimcimp
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimtodo
                     $coimaimptecn
                     $coimdocu <!--rom06 -->
		     <if @coimtgen.ente@ eq \"PNA\">$coimmovi</if> <!-- rom07 -->
                     $coimsche
<!--sim                    <td colspan=7 nowrap class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "coop_resp" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coimgend
                     $coimdimp
                     $coimcimp
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimaimptecn
                     $coimsche
<!--sim                     <td colspan=7 class=func-menu>&nbsp;</td> -->
                 </tr>
                 </table>
                 " 
	    }
	    "coop_modh" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coimgend
                     $coimdimp
                     $coimaimptecn
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimsche
                 </tr>
                 </table>
                 " 
	    }
	    "coop_rappv" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coimgend
                     $coimcimp
                     $coimaimptecn
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimsche
                 </tr>
                 </table>
                 " 
	    }
	    default {set links "
                 <table width=\"100%\" cellspacing=0>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimaimpubic
                     $coimaimpsogg
                     $coim_as_resp
                     $coimgend
                     $coimdimp
                     $coimaimp_altreschede
                 </tr>
                 <tr>
                     $coimcimp
                     $coimtodo
                     $coiminco
                     $coimessi
                     $coimprvv
                     $coimmovi
                     $coimaimptecn
                     $coimdocu
                     $coimsche                     
                 </tr>
                 </table>
                 " 
	    }
	    return $links
	}
	
    }
    
}

    
ad_proc iter_tab_form {
    cod_impianto
} {
    Restituisce una variabile contenente i una tabella rappresentate i dati 
    principale dell'impianto
} {
    iter_get_coimtgen
    set flag_viario       $coimtgen(flag_viario)
    set mesi_evidenza_mod $coimtgen(mesi_evidenza_mod)  

    if {$flag_viario == "T"} {
	set get_dat_aimp "get_dat_aimp_si_vie"
    } else {
	set get_dat_aimp "get_dat_aimp_no_vie"
    }

    if {[db_0or1row $get_dat_aimp ""] == 0} {
#	iter_return_complaint "Record non trovato"
	set cod_impianto_est ""
        set cod_impianto     ""
        set localita         ""
        set comune           ""
        set via              ""
        set topo             ""
        set numero           ""
        set esponente        ""
        set scala            ""
        set piano            ""
        set interno          ""
        set cap              ""
        set occup            ""
        set resp             ""
        set cod_utenza       ""
        set svc_mod          "" 
	set cod_amag         ""
	set swc_mod          ""
#dpr74 
       set stato_imp       ""
	set targa            "";#sim04
   }

    if {[exists_and_not_null numero]
    &&  [exists_and_not_null topo]
    &&  [exists_and_not_null via]
    } {
	set virgola ","
    } else {
	set virgola ""
    }
    if {[exists_and_not_null numero]
    &&  [exists_and_not_null esponente]    
    } {
	set barra "/"
    } else {
	set barra ""
    }
    if {[exists_and_not_null scala]} {
	set sc " S."
    } else {
	set sc ""
    }
    if {[exists_and_not_null piano]} {
	set pi " P."
    } else {
	set pi ""
    }
    if {[exists_and_not_null interno]} {
	set int " In."
    } else {
	set int ""
    }
    if {[exists_and_not_null localita]} {
	set loc " Loc. "
    } else {
	set loc ""
    }
    set ubic "$topo $via$virgola $numero$barra$esponente$sc$scala$pi$piano$int$interno$loc$localita $cap $comune"

    if {$swc_mod == "T"} {
	if {[db_0or1row sel_uten ""] == 0} {
	    set uten_desc ""
	}
	set tab_mod "
            <td align=right>
            <table border=1 bordercolor=red>
            <tr>
                <td align=left nowrap class=func-menu2>Ultima modifica del:</td>
                <td align=left nowrap class=func-menu2>$data_mod_edit</td>
            </tr>
            <tr>   
                <td align=left nowrap class=func-menu2 colspan=2>dell'utente: $uten_desc</td> <!-- ale01 -->
            </tr>
            </table>
            </td>
        "
    } else {
	set tab_mod ""
    }

#rom01set resp "<a href=\"/iter/src/coimcitt-gest?funzione=M&nome_funz=cittadini&cod_cittadino=$cod_resp&caller=impianto&cod_impianto=$cod_impianto\">$resp</a>"
#rom01set occup "<a href=\"/iter/src/coimcitt-gest?funzione=M&nome_funz=cittadini&cod_cittadino=$cod_occup&caller=impianto&cod_impianto=$cod_impianto\">$occup</a>"
set resp "<a href=\"/iter/src/coimcitt-gest?funzione=V&nome_funz=cittadini&cod_cittadino=$cod_resp&caller=impianto&cod_impianto=$cod_impianto\">$resp</a>";#rom01
set occup "<a href=\"/iter/src/coimcitt-gest?funzione=V&nome_funz=cittadini&cod_cittadino=$cod_occup&caller=impianto&cod_impianto=$cod_impianto\">$occup</a>";#rom01

    set label_cod_utenza_targa "        
        <td align=left valign=top class=func-menu2>Cod.utenza:</td>
        <td align=left valign=top class=func-menu2>$cod_amag</td>";#sim04
    
    if {$coimtgen(flag_gest_targa)} {
	set label_cod_utenza_targa "        
<!--rom02        <td align=left valign=top class=func-menu2>Targa:</td>-->
        <td align=left valign=top class=func-menu2>Codice catasto (Targa)<!--rom02-->
        <td align=left valign=top class=func-menu2>$targa</td>";#sim04
    }

    set tab_aimp "
<table width=100% class=func-menu2>
<tr><td align=left>
    <table>
    <tr>
<!--rom02        <td align=left valign=top class=func-menu2>Codice</td>-->
        <td align=left valign=top class=func-menu2>Codice Impianto</td><!--rom02-->
        <td align=left valign=top class=func-menu2>$cod_impianto_est</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Ubicazione:</td>
        <td align=left valign=top class=func-menu2 colspan=4>$ubic</td>
<!--dpr74 -->
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2><font color=red>Tipo Imp.:</font></td>
        <td align=left valign=top class=func-menu2><font color=red>$stato_imp</font></td>
<!--dpr74 -->
    </tr>
    <tr>
        $label_cod_utenza_targa <!--sim04-->
<!--sim04        <td align=left valign=top class=func-menu2>Cod.utenza:</td>
        <td align=left valign=top class=func-menu2>$cod_amag</td> -->
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Responsabile:</td>
        <td align=left valign=top class=func-menu2>$resp</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Occupante:</td>
        <td align=left valign=top class=func-menu2>$occup</td>
    </tr>
    </table>
    </td>
    <td align=right>
        <a href=\"#\" onclick=\"javascript:window.open('coimaimp-gest-help', 'help', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)\"><b>Help</b></a><br>
        <a href=\"#\" onclick=\"javascript:window.open('coimaimp-warning?cod_impianto=$cod_impianto&caller=warning', 'warning', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)\"><b>Guida compilazione campi</b></a>

    $tab_mod
    </td><!--sim02-->

</tr>
</table>"
    return $tab_aimp
}


ad_proc iter_tab_area {
    cod_area 
} {
    Restituisce una variabile contenente i una tabella rappresentate i dati 
    principale dell'area
} {
  # db_1row get_dat_area ""
    if {[db_0or1row get_dat_area "" ] == 1} {
	if {[exists_and_not_null tipo_01]} {
	    set tp_01 "TIPO AREA:"
	} else {
	    set tp_01 ""
	}
	if {[exists_and_not_null tipo_02]} {
	    set tp_02 "TIPO GRUPPO:"
	} else {
	    set tp_02 ""
	}
	if {[exists_and_not_null descrizione]} {
	    set desc "DESCRIZIONE AREA:"
	} else {
	    set desc""
	}
    } else {
	set tp_01    ""
	set tp_02    ""
	set desc     ""
    }


    switch $tipo_01 {
	C {set tipo01 "Comuni"}
	Q {set tipo01 "Quartieri"}
	V {set tipo01 "Vie"}
	U {set tipo01 "Aree urbane"}
    }
    
    switch $tipo_02 {
	T {set tipo02 "Tecnico"}
	M {set tipo02 "Manutentore"}
    }
    

#    set area "$tp_01 $tipo01 &nbsp; &nbsp; $tp_02 $tipo02 &nbsp; &nbsp; $desc $descrizione"
    set area "$desc $descrizione"

    set tab_area "
<table width=100% celpadding=0 cellspacing=0 class=func-menu2>
<tr><td>
<table>
<tr>
   <td width=100% colspan=2 class=func-menu2>$area</td>
</tr>
</table></td>
</tr>
</table>"
    return $tab_area
}


ad_proc iter_links_aces {
    cod_aces
    nome_funz_caller
    url_coimaces_list
    {flag_call ""}
    {stato_01  ""}
} {
    Restituisce una variabile contenente i link utilizzati dal programma
    di gestione degli impianti potenziali (richiamato da coimaces-list).
} {
  # metto il colore giallo in corrispondenza del programma selezionato
  # valorizzando la classe a func-sel al posto di func-menu.
    set provenienza [ns_conn url]
    set prog [file tail $provenienza]
    set class_uten "func-menu"
    set class_inte "func-menu"
    set class_occu "func-menu"
    set class_prop "func-menu"
    set class_indi "func-menu"
    set class_piva "func-menu"
    set class_isrt "func-menu"
    
    if {$prog == "coimaimp-aces-list"} {
        switch $flag_call {
	    "uten" {set class_uten "func-sel"}
	    "inte" {set class_inte "func-sel"}
	    "occu" {set class_occu "func-sel"}
	    "prop" {set class_prop "func-sel"}
	    "indi" {set class_indi "func-sel"}
	    "piva" {set class_piva "func-sel"}
	}
    } else {
        if {$prog == "coimaimp-sche"
        ||  $prog == "coimaces-gest"} {
            switch $flag_call {
	        "uten" {set class_uten "func-sel"}
	        "inte" {set class_inte "func-sel"}
	        "occu" {set class_occu "func-sel"}
	        "prop" {set class_prop "func-sel"}
	        "indi" {set class_indi "func-sel"}
	        "piva" {set class_piva "func-sel"}
	    }
	} else {
            set class_isrt "func-sel"
	}
    }

  # preparo le url che uso per richiamare i vari programmi
    set parm_coimaimp_aces_list [export_url_vars cod_aces nome_funz_caller]&nome_funz=[iter_get_nomefunz "coimaimp-aces-list"]
    set url_coimaces_list_js [iter_DoubleApos $url_coimaces_list]
  # url scritta con sintassi javascript.
  # N.B.: uso i campi della form iter_tab_aces (cognome, nome, descr_topo...)
    set link_java {javascript:window.location.href='coimaimp-aces-list?$parm_coimaimp_aces_list&flag_call=$flag_call'
    + '&url_coimaces_list=' + urlencode($url_coimaces_list_js)
    + '&f_cognome='   + urlencode(document.iter_tab_aces.cognome.value)
    + '&f_nome='      + urlencode(document.iter_tab_aces.nome.value)
    + '&f_desc_topo=' + urlencode(document.iter_tab_aces.descr_topo.value)
    + '&f_desc_via='  + urlencode(document.iter_tab_aces.descr_via.value)
    }

    set flag_call "uten"
    set url_uten [subst $link_java]
    set flag_call "inte"
    set url_inte [subst $link_java]
    set flag_call "occu"
    set url_occu [subst $link_java]
    set flag_call "prop"
    set url_prop [subst $link_java]
    set flag_call "indi"
    set url_indi [subst $link_java]
    set flag_call "piva"
    set url_piva [subst $link_java]


    set flag_isrt "S"
  # preparo le url che uso per richiamare i vari programmi
    set parm_coimaimp_isrt [export_url_vars cod_aces nome_funz_caller stato_01]&nome_funz=[iter_get_nomefunz "coimaimp-isrt-veloce"]
  # url scritta con sintassi javascript.
  # N.B.: uso i campi della form iter_tab_aces (cognome, nome, descr_topo...)
    set link_java2 {javascript:window.location.href='coimaimp-isrt-veloce?$parm_coimaimp_isrt&flag_isrt=$flag_isrt&flag_call=$flag_call'
    + '&url_coimaces_list=' + urlencode($url_coimaces_list_js)
    + '&f_cognome='   + urlencode(document.iter_tab_aces.cognome.value)
    + '&f_nome='      + urlencode(document.iter_tab_aces.nome.value)
    + '&f_desc_topo=' + urlencode(document.iter_tab_aces.descr_topo.value)
    + '&f_desc_via='  + urlencode(document.iter_tab_aces.descr_via.value)
    }

    set url_carica  [subst $link_java2]

    set url_scarta "[export_url_vars cod_aces url_coimaces_list nome_funz_caller stato_01]&nome_funz=[iter_get_nomefunz coimaces-gest]"


  # valorizzo il frammento html da mettere nell'adp
    set links "
    <!-- function javascript per editare una variabile in formato url-->
    <script language=JavaScript>
    function urlencode(inString){
        inString=escape(inString);
        for(i=0;i<inString.length;i++){
             if(inString.charAt(i)=='+'){
                  inString=inString.substring(0,i) + \"%2B\" + inString.substring(i+1);
             }
        }
        return(inString);
    }
    </script>

    <table width=\"100%\" cellspacing=0  class=func-menu>
    <tr>
       <td width=\"20%\" nowrap class=func-menu>
          <a href=\"$url_coimaces_list\" class=func-menu>Ritorno alla Lista</a>
       </td>
       <td width=\"20%\" nowrap class=$class_uten>
          <a href=\"$url_uten\" class=$class_uten>Stessa utenza</a>
       </td>
       <td width=\"20%\" nowrap class=$class_inte>
          <a href=\"$url_inte\" class=$class_inte>Stesso intestatario</a>
       </td>
       <td width=\"20%\" nowrap class=$class_occu>
          <a href=\"$url_occu\" class=$class_occu>Stesso occupante</a>
       </td>
       <td width=\"20%\" nowrap class=$class_prop>
          <a href=\"$url_prop\" class=$class_prop>Stesso proprietario</a>
       </td>
    </tr>
    <tr>
       <td width=\"20%\" nowrap class=$class_indi>
          <a href=\"$url_indi\" class=$class_indi>Stesso indirizzo</a>
       </td>
       <td width=\"20%\" nowrap class=$class_piva colspan=2>
          <a href=\"$url_piva\" class=$class_piva>Stesso Cod.fiscale/P.iva</a>
       </td>
       <td width=\"20%\" nowrap class=$class_isrt>
          <a href=\"$url_carica\" class=$class_isrt>Carica</a>
       </td>
       <td width=\"20%\" nowrap class=func-menu>
          <a href=\"coimaces-gest?&$url_scarta\" class=func-menu>Scarta</a>
       </td>
   </tr>
   </table>"
   return $links
}

ad_proc iter_tab_aces {
    cod_aces
    f_cognome
    f_nome
    f_desc_topo
    f_desc_via 
} {
    Restituisce i dati principali della testata
} {
    if {[db_0or1row get_dat_test "" ] == 0} {
	set descr_distributore  ""
	set data_caric          ""
	set cod_documento       ""
        set descr_comb          ""
        set cod_utenza          ""
        set cognome             ""
        set nome                ""
        set cod_fiscale_piva    ""
        set natura_giuridica    ""
        set natura_giuridica_edit ""
        set stato_aces          ""
        set note                ""
        set localita            ""
        set comune              ""
        set indirizzo           ""
        set numero              ""
        set esponente           ""
        set scala               ""
        set piano               ""
        set interno             ""
        set cap                 ""
    }

    if {[db_0or1row get_dat_comu "" ] == 0} {
        set cod_comune   ""
    }

    if {[string equal $f_cognome ""]
    &&  [string equal $f_nome ""]
    } {
	# se f_cognome ed f_nome sono null, significa che la proc e'
	# richiamata per la prima volta e li devo valorizzare con i valori
	# di coimaces. Provo anche a separare il cognome dal nome se
	# sono eventualmente contenuti nel cognome.

	# separo il nome dal cognome solo per le persone fisiche con nome null
	if {$natura_giuridica == "F"
	&&  [string is space $nome]
	} {
	    set cog_nom_list [iter_separa_cog_nom $cognome]
	    set f_cognome      [lindex $cog_nom_list 0]
	    set f_nome         [lindex $cog_nom_list 1]
	} else {
	    set f_cognome $cognome
	    set f_nome    $nome
	}
    }

    if {[string equal $f_desc_topo ""]
    &&  [string equal $f_desc_via ""]
    } {
        if {![string equal $indirizzo ""]} {
            set indirizzo_str [string trim $indirizzo]
            set pos_space [string first " " $indirizzo_str]
            if {$pos_space > 0} {
                set f_desc_topo [string range $indirizzo_str 0 $pos_space]
                set f_desc_via  [string range $indirizzo_str $pos_space end]
                set f_desc_topo [string trim  $f_desc_topo]
                set f_desc_via  [string trim  $f_desc_via]
	    } else {
                set f_desc_via  $indirizzo
                set f_desc_via  [string trim  $f_desc_via]
	    }
	}
    }
    iter_get_coimtgen
    set flag_viario  $coimtgen(flag_viario)
    if {$flag_viario == "T"} {
        set cerca_viae [iter_search iter_tab_aces [ad_conn package_url]/tabgen/coimviae-filter [list dummy dummy dummy descr_via dummy descr_topo cod_comune cod_comune]]
        regsub {<a href} $cerca_viae {<a tabindex=7 href} cerca_viae
    } else {
        set cerca_viae ""
    }

    if {![string is space $descr_comb]} {
        append descr_distributore " - $descr_comb"
    }

    if {![string is space $numero]} {
        if {![string is space $indirizzo]} {
            append indirizzo ","
        }
        append indirizzo " $numero"

        if {![string is space $esponente]} {
            append indirizzo "/"
	}
    } else {
        append indirizzo " "
    }
    append indirizzo $esponente

    if {![string is space $scala]} {
        append indirizzo " S.$scala"
    }
    if {![string is space $piano]} {
        append indirizzo " P.$piano"
    }
    if {![string is space $interno]} {
	append indirizzo " In.$interno"
    }
    if {![string is space $localita]} {
	append indirizzo " Loc. $localita"
    }
    append indirizzo " $cap $comune"

    if {![string is space $note]} {
        set tr_note "
        <tr>
           <td colspan=4>Note: $note</td>
        </tr>"
    } else {
        set tr_note ""
    }

    set tab_aces "
    <table width=\"100%\" cellspacing=0 class=func-menu2>
    <tr>
        <td align=left>Distributore: $descr_distributore</td>
        <td align=left>Data Caricamento: $data_caric</td>
        <td align=left>Codice Documento: $cod_documento</td>
        <td align=left>Cod.Utenza: $cod_utenza</td>
    </tr>
    <tr>
        <td align=left colspan=4>Ubicazione: $indirizzo</td>
    </tr>
    <tr>
        <td align=left>Intestatario: $cognome $nome</td>
        <td align=left>Cod.Fiscale / P.Iva: $cod_fiscale_piva</td>
        <td align=left>Natura: $natura_giuridica_edit</td>
        <td align=left>Stato: $stato_aces</td>
    </tr>
    $tr_note
    </table>
    <table width=\"100%\" border=0>
        <form name=iter_tab_aces method=post>
        <tr><td valign=top width=10% align=right class=form_title>Cognome</td>
            <td valign=top width=25%>
               <input type=text name=cognome size=20 maxlength=100 class=form_element value=\"[ad_quotehtml $f_cognome]\">
            </td>
            <td valign=top width=10% align=right class=form_title>Nome</td>
            <td valign=top width=25%>
               <input type=text name=nome size=14 maxlength=100 class=form_element value=\"[ad_quotehtml $f_nome]\">
            </td> 
            <td valign=top width=10% align=right class=form_title>Indirizzo</td>
            <td valign=top width=20% nowrap>
                <input type=text name=descr_topo size=05 maxlength=10 class=form_element value=\"[ad_quotehtml $f_desc_topo]\">
                <input type=text name=descr_via  size=25 maxlength=40 class=form_element value=\"[ad_quotehtml $f_desc_via]\">$cerca_viae
            </td>
        </tr>
        <input type=hidden name=cod_comune value=\"[ad_quotehtml $cod_comune]\">
        <input type=hidden name=dummy>
        </form>
    </table>"

    return $tab_aces
}


ad_proc iter_tab_form_palm {cod_impianto 
} {
    Restituisce una variabile contenente i una tabella rappresentate i dati 
    principale dell'impianto
} {
    if {[db_0or1row get_dat_aimp ""] == 0} {
	set cod_impianto_est ""
        set cod_impianto     ""
        set localita         ""
        set comune           ""
        set via              ""
        set topo             ""
        set numero           ""
        set esponente        ""
        set scala            ""
        set piano            ""
        set interno          ""
        set cap              ""
        set resp             ""
        set occup            ""
        set cod_utenza       "" 
    }
    if {[exists_and_not_null numero]
    &&  [exists_and_not_null topo]
    &&  [exists_and_not_null via]
    } {
	set virgola ","
    } else {
	set virgola ""
    }
    if {[exists_and_not_null numero]
    &&  [exists_and_not_null esponente]    
    } {
	set barra "/"
    } else {
	set barra ""
    }
    if {[exists_and_not_null scala]} {
	set sc " S."
    } else {
	set sc ""
    }
    if {[exists_and_not_null piano]} {
	set pi " P."
    } else {
	set pi ""
    }
    if {[exists_and_not_null interno]} {
	set int " In."
    } else {
	set int ""
    }
    if {[exists_and_not_null localita]} {
	set loc " Loc. "
    } else {
	set loc ""
    }
    set ubic "$topo $via$virgola $numero$barra$esponente$sc$scala$pi$piano$int$interno$loc$localita $cap $comune"
    set tab_aimp "
<table width=240 class=func-menu2>
<tr><td align=center>
    <table>
    <tr>
        <td align=left valign=top class=func-menu2>Codice:</td>
        <td align=left valign=top class=func-menu2>$cod_impianto_est</td>
    </tr><tr> 
        <td align=left valign=top class=func-menu2>Cod.utenza:</td>
        <td align=left valign=top class=func-menu2>$cod_amag</td>
    </tr><tr>
        <td align=left valign=top class=func-menu2>Ubicazione:</td>
        <td align=left valign=top class=func-menu2 colspan=4>$ubic</td>
    </tr>
    <tr>
        <td align=left valign=top class=func-menu2>Responsabile:</td>
        <td align=left valign=top class=func-menu2>$resp</td>
    </tr><tr>
        <td align=left valign=top class=func-menu2>Occupante:</td>
        <td align=left valign=top class=func-menu2>$occup</td>
    </tr>
    </table>
    </td>
</tr>
</table>"
    return $tab_aimp
}

ad_proc iter_search_form_palm {caller search_word {outer_caller_name ""}
} {
    Restituisce una form con un campo denominato 'search_word' da
    utilizzare come filtro in una query.
} {
    # associo il nome della variabile al suo contenuto nel calling environment
    upvar $outer_caller_name outer_caller
    if {[exists_and_not_null outer_caller_name]} {
        set outer_caller_hidden "<input type=hidden name=$outer_caller_name value=\"[ad_quotehtml $outer_caller]\">"
    } else {
        set outer_caller_hidden ""
    }

  # reperisco tutte le variabili meno search_word, last_* (last_colonna_chiave)
  # usata per le liste ed eventualmente le col di outer_caller_name
    set form_vars [iter_export_ns_set_vars "form" "search_word last_* $outer_caller_name"]
    set widget    "
<form method=post action=\"$caller\">
 $form_vars
 $outer_caller_hidden
 <input type=text name=search_word size=8 value=\"[ad_quotehtml $search_word]\" class=ric_element>
 <input type=submit value=\"Cerca\" class=ric_submit>
</form>"

    return $widget
}

ad_proc iter_links_batc {
    nome_funz
    nome_funz_caller
    nom
} {
    Restituisce una variabile contenente i link utilizzati dai programmi
    di sottomissione lavori e di consultazione coda lavori
} {
    set prog [file tail [ns_conn url]]

    set class_ins  "func-menu"
    set class_batc "func-menu"
    set class_esit "func-menu"

    if {$prog == "coimbatc-list"
    ||  $prog == "coimbatc-gest"
    } {
	set class_batc "func-sel"
    } else {
	if {$prog == "coimesit-list"
	||  $prog == "coimesit-gest"
	} {
	    set class_esit "func-sel"
	} else {
	    set class_ins  "func-sel"
	}
    }

    set search_word $nom
    set links "
<table width=\"100%\" cellspacing=0  class=func-menu>
<tr>
    <td width=\"33%\" nowrap class=$class_ins>
        <a href=\"[iter_get_pgm $nome_funz_caller]\" class=$class_ins>Lancio lavori</a>
    </td>
    <td width=\"34%\" nowrap class=$class_batc>
        <a href=\"coimbatc-list?nome_funz=[iter_get_nomefunz coimbatc-list]&[export_url_vars nome_funz_caller search_word]\" class=$class_batc>Consultazione lavori in esecuzione</a>
    </td>
    <td width=\"33%\" nowrap class=$class_esit>
        <a href=\"coimesit-list?nome_funz=[iter_get_nomefunz coimesit-list]&[export_url_vars nome_funz_caller search_word]\" class=$class_esit>Consultazione lavori terminati</a>
    </td>
</tr>
</table>
"
   return $links
}

ad_proc iter_link_inco {
    cod_inco
    nome_funz_caller 
    url_list_aimp
    url_aimp
    nome_funz
    funzione
    {extra_par ""} 
} {
    Restituisce una variabile contenente i link per la funzione degli incontri

    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
    sim01  15/04/2015 Dato che ora c'è la possibilità di fare anche i coimcimp RI, anche se non
    sim01             sono presenti rapporti di ispezione il link deve andare alla lista e non
    sim01             direttamente sul dettaglio perchè non saprebbe su quale andare. (RI va bene per ogni potenza)

} {

    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    append pack_dir "src"

    iter_get_coimtgen
    set flag_avvisi $coimtgen(flag_avvisi)

    # per i 3 programmi esterni, devo valorizzare correttamente
    # il nome_funz utilizzato per richiamare coiminco-gest.
    set save_nome_funz $nome_funz
    set ritorna   "Visualizza"
    if {$save_nome_funz == "inco-stav"} {
	set ritorna   "Appuntamento"
	if {[string range $nome_funz_caller 0 3] == "inco"} {
	    set nome_funz $nome_funz_caller
	} else {
	    set nome_funz "incontro"
	}
    }

    if {$save_nome_funz == "cimp"
    ||  $save_nome_funz == "anom"
    } {
	set ritorna   "Appuntamento"
	if {[string range $nome_funz_caller 0 3] == "inco"} {
	    set nome_funz $nome_funz_caller
	} else {
	    set nome_funz "incontro"
	}
    }

    if {$save_nome_funz == "stpm-da-app"} {
	set ritorna   "Appuntamento"
	if {[string range $nome_funz_caller 0 3] == "inco"} {
	    set nome_funz $nome_funz_caller
	} else {
	    set nome_funz "incontro"
	}
    }

    if {$save_nome_funz == "stev"} {
	set ritorna   "Appuntamento"
	if {[string range $nome_funz_caller 0 3] == "inco"} {
	    set nome_funz $nome_funz_caller
	} else {
	    set nome_funz "incontro"
	}
    }

    # imposta le class css della barra delle funzioni
    set func_v "func-menu"
    set func_d "func-menu"
    set func_a "func-menu"
    set func_c "func-menu"
    set func_e "func-menu"
    set func_n "func-menu"
    set func_stav "func-menu"
    set func_cimp "func-menu"
    set func_stev "func-menu"
    
    switch $save_nome_funz {
	"inco-stav" {set func_stav "func-sel"}
	"cimp"      {set func_cimp "func-sel"}
	"anom"      {set func_cimp "func-sel"}
	"stpm-da-app" {
	    if {$funzione eq "esito"} {
		set func_stev "func-sel"
	    } else {
		if {$funzione eq "avvisi"} {
		    set func_stav "func-sel"
		}
	    }
	    
	}
	"stev"        {set funz_stev "funz_sel"} 
	default  {
	    switch $funzione {
		"V" {set func_v "func-sel"}
		"D" {set func_d "func-sel"}
		"A" {set func_a "func-sel"}
		"C" {set func_c "func-sel"}
		"E" {set func_e "func-sel"}
		"N" {set func_n "func-sel"}
	    }
	}
    }
    
    if {[db_0or1row sel_dati_inco ""] == 0} {
	set stato        ""
	set esito        ""
	set cod_impianto ""
	set stato_aimp   ""
    }

    set link_gest [export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp nome_funz extra_par]

    # Visualizza: sempre effettuabile
    # disabilitato se richiamato dal programma di gestione impianti.
    # in questo caso vi si puo' accedere, ma la url di questo link non sarebbe
    # corretta e quindi ne vieto il 'refresh'.
    # infatti la url di questo link dal menu' di gestione impianti
    # fa un salto al menu' di pianificazione appuntamenti.
    # il problema e' difficilmente risolvibile.
    if {[string is space $url_aimp]} {
	set link_inco_visu "
        <a href=\"$pack_dir/coiminco-gest?funzione=V&$link_gest\" class=$func_v>$ritorna</a>"
    } else {
	set link_inco_visu "$ritorna"
    }

    # Assegna: abilitato con la funzione di assegna
    # o di gestione se stato Estratto, Da assegnare, Assegnato, Annulllato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {(   $nome_funz == "inco-asse"
         || (   $nome_funz == "incontro"
             && (   $stato == "0" 
                 || $stato == "1"
                 || $stato == "2"
                 || $stato == "5"
                )
            )
        )
    &&  [string is space $url_aimp]
    } {
	set link_inco_asse "
	<a href=\"$pack_dir/coiminco-gest?funzione=A&$link_gest\" class=$func_a>Assegna</a>"
    } else {
	set link_inco_asse "Assegna"
    }

    # Stampa avviso: abilitato con la funzione di stampa avviso 
    # o di gestione se lo stato e' Assegnato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {$stato        == "2"
    && (   $nome_funz == "inco-stam"
        || $nome_funz == "inco-stav"
        || $nome_funz == "incontro"
       )
    && [string is space $url_aimp]
    } {
	if {$flag_avvisi eq "S"} {
	    set links_stav [export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par]&nome_funz=[iter_get_nomefunz coimstpm-menu-da-app]&flag_inco=S&do=avvisi
	    set link_stav "
             <a href=\"$pack_dir/coimstpm-menu-da-app?$links_stav&flag_avviso=S\" class=$func_stav>Stampa Avviso</a>"
	} else {
	    set links_stav [export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par]&nome_funz=inco-stav&flag_inco=S
	    set link_stav "
             <a href=\"$pack_dir/coimstav-list?$links_stav\" class=$func_stav>Stampa Avviso</a>"
	}
    } else {
	if {($stato          == "3")
	&&  ($save_nome_funz == "inco-stav")
	    ||  ($flag_avvisi eq "S" && $funzione eq "avvisi")
	} {
	    set link_stav "Stampa Avviso"
	} else {
	    set link_stav "Stampa Avviso"
	}
    }

    # Conferma: abilitato con la funzione di conferma
    # o di gestione se lo stato e' Spedito, confermato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {(    $nome_funz == "inco-conf"
         || (    $nome_funz == "incontro"
             && (   $stato  == "3"
                 || $stato  == "4"
                )
            )
        )
    &&  [string is space $url_aimp]
    } {
	set link_inco_conf "
        <a href=\"$pack_dir/coiminco-gest?funzione=C&$link_gest\" class=$func_c>Conferma</a>"
    } else {
	set link_inco_conf "Conferma"
    }

    # Effettua: abilitato con la funzione di effettuazione
    # o di gestione se lo stato e' Spedito, Confermato o Effettuato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {(   $nome_funz == "inco-effe"
         || (   $nome_funz == "incontro"
             && (   $stato == "3"
                 || $stato == "4"
                 || $stato == "8"
                )
            )
        )
    &&  [string is space $url_aimp]
    } {
	set link_inco_effe "
        <a href=\"$pack_dir/coiminco-gest?funzione=E&$link_gest\" class=$func_e>Effettua</a>"
    } else {
	set link_inco_effe "Effettua"
    }

    # Rapp di verifica: abilitato con la funzione di rapp ver
    # o di effettuazione con stato effettuato
    # o di gestione con qualsiasi stato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {(   $nome_funz    == "inco-cimp"
         ||  $nome_funz    == "cimp"
         ||  $nome_funz    == "anom"
         || (   $nome_funz == "inco-effe"
             && $stato     == "8"
            )
         ||  $nome_funz    == "incontro"
        )
    &&  [string is space $url_aimp]
    } {
	set extra_par_inco $extra_par
        #Richiesta di UCIT del 09/07/2012 e riportata a standard il 29/05/2014:
        #Togliamo la possibilità di bonifica su richiesta dell'utente
	#if {$stato_aimp != "D"} { 
	    #sim01 if {[db_string sel_cimp_count ""] > 0} {
		set links_cimp "$pack_dir/coimcimp-list?[export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par_inco]&nome_funz=[iter_get_nomefunz coimcimp-list]&flag_inco=S"
	    #sim01 } else {
		#sim01 set links_cimp "$pack_dir/coimcimp-gest?funzione=I&[export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par_inco]&nome_funz=[iter_get_nomefunz coimcimp-list]&flag_inco=S"
	    #sim01 }
	#} else {
	#    set links_cimp "$pack_dir/coimcimp-ins-list?[export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par_inco]&nome_funz=[iter_get_nomefunz coimcimp-ins-list]&flag_inco=S"
	#}
	set link_cimp "
        <a href=\"$links_cimp\" class=$func_cimp>Rapp. Ispezione/Accertamento</a>"
    } else {
        set link_cimp "Rapp. Ispezione/Accertamento"
    }

    # Stampa esito: abilitato con le funzioni di effettuazione,    
    # registrazione rapporto di veirifica e di gestione            
    # solo se lo stato e' effettuato e l'esito e' stato valorizzato
    # disabilitato se richiamato dal programma di gestione impianti.
    if {$esito     != ""
    &&  $stato     == "8"
    &&  $nome_funz != "inco-annu"
    &&  [string is space $url_aimp]
    } {
	if {$flag_avvisi eq "S"} {
	set links_stev [export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par]&nome_funz=[iter_get_nomefunz coimstpm-menu-da-app]&flag_inco=S&do=esito
	    set link_stev "  
             <a href=\"$pack_dir/coimstpm-menu-da-app?$links_stev&flag_avviso=N\" class=$func_stev>Stampa Esito</a>"
	} else {
	set links_stev [export_url_vars cod_inco cod_impianto stato esito nome_funz_caller url_list_aimp url_aimp extra_par]&nome_funz=[iter_get_nomefunz coimstev-list]&flag_inco=S
	    set link_stev "<a href=\"$pack_dir/coimstev-list?$links_stev\" class=$func_stev>Stampa Esito</a>"
	}
    } else {
	set link_stev "Stampa Esito"
    }

    # Annulla: sempre effettuabile
    # disabilitato se richiamato dal programma di gestione impianti.
    if {[string is space $url_aimp]} {
        set link_inco_annu "
        <a href=\"$pack_dir/coiminco-gest?funzione=N&$link_gest\" class=$func_n>Annulla</a>"
    } else {
	set link_inco_annu "Annulla"
    }

    set tab_link_inco "
   <table width=\"100%\" cellspacing=0 class=func-menu>
   <tr>
   <td width=\"12.5%\" nowrap class=$func_v>
        $link_inco_visu
   </td>
   <td width=\"12.5%\" nowrap class=$func_a>
        $link_inco_asse
   </td>

   <td width=\"12.5%\" nowrap class=$func_stav>
        $link_stav
   </td>

   <td width=\"12.5%\" nowrap class=$func_c>
        $link_inco_conf
   </td>

   <td width=\"12.5%\" nowrap class=$func_e>
        $link_inco_effe
   </td>

   <td width=\"12.5%\" nowrap class=$func_cimp>
        $link_cimp
   </td>

   <td width=\"12.5%\" nowrap class=$func_stev>
        $link_stev
   </td>

   <td width=\"12.5%\" nowrap class=$func_n>
        $link_inco_annu
   </td>
</tr>
</table>
"
    return $tab_link_inco
}

ad_proc iter_links_rgen {
    cod_rgen 
    nome_funz_caller 
    url_list_rgen
    url_rgen
    {extra_par ""}
} {
    Restituisce una variabile contenente i link utilizzati dal programma
    di gestione raggruppamento enti
} {

    set provenienza [ns_conn url]
    set prog [file tail $provenienza]

#    if {$prog == "coimrgen-gest"} {
        set coimrgenlist "<td width=\"12.5%\" nowrap class=func-menu>
         <a href=\"coimrgen-list?[iter_set_url_vars $extra_par]&nome_funz=[iter_get_nomefunz coimrgen-list]\" class=func-menu>Lista Raggruppamenti</a>
      </td>"
#    } else {
#        set coimrgenlist "<td width=\"12.5%\" nowrap class=func-menu>
#         <a href=\"$url_list_rgen\" class=func-menu>Lista Raggruppamenti</a>
#      </td>"
#    }

    set link_anrg "[export_url_vars cod_rgen url_list_rgen nome_funz_caller url_rgen]&nome_funz=[iter_get_nomefunz coimanrg-list]" 

    set link_enrg "[export_url_vars cod_rgen url_list_rgen nome_funz_caller url_rgen]&nome_funz=[iter_get_nomefunz coimenrg-list]"
 
    if {$prog == "coimrgen-gest"} {
	set coimrgengest "<td width=\"12.5%\" nowrap class=func-sel>
              <a href=\"$url_rgen&[export_url_vars url_list_rgen]\" class=func-sel>Gestione Raggruppamenti</a>
            </td>"
    } else {
	set coimrgengest "<td width=\"12.5%\" nowrap class=func-menu>
              <a href=\"$url_rgen&[export_url_vars url_list_rgen]\" class=func-menu>Gestione Raggruppamenti</a>
            </td>"
    }

    if {$prog == "coimanrg-list"
    ||  $prog == "coimanrg-gest"
    } {
        set coimanrg "<td width=\"12.5%\" nowrap class=func-sel>
         <a href=\"coimanrg-list?&$link_anrg\" class=func-sel>Anomalie Associate</a>
      </td>"
    } else {
        set coimanrg "<td width=\"12.5%\" nowrap class=func-menu>
         <a href=\"coimanrg-list?&$link_anrg\" class=func-menu>Anomalie Associate</a>
      </td>"
    }
    if {$prog == "coimenrg-list"
    ||  $prog == "coimenrg-gest"
    } {
	set coimenrg "<td width=\"12.5%\" nowrap class=func-sel>
         <a href=\"coimenrg-list?&$link_enrg\" class=func-sel>Tipologie Enti Associate</a> </td>"
    } else {
	set coimenrg "<td width=\"12.5%\" nowrap class=func-menu>
         <a href=\"coimenrg-list?&$link_enrg\" class=func-menu>Tipologe Enti Associate</a> </td>"
    }

    set links "
<table width=\"100%\" cellspacing=0  class=func-menu>
  <tr>
   $coimrgenlist
   $coimrgengest
   $coimanrg
   $coimenrg
  </tr>
</table>
"
    return $links
}

ad_proc iter_tab_rgen {
    cod_rgen
} {
    Restituisce una variabile contenente i una tabella rappresentate i dati 
    principale dell'area
} {
    if {[db_0or1row get_dat_rgen "" ] == 1} {
	if {[exists_and_not_null descrizione]} {
	    set desc "<b>Raggruppamento:</b>"
	} else {
	    set desc""
	}
    } else {
	set desc     ""
    }
    
    set rgen "$desc $descrizione"

    set tab_rgen "
<table width=100% celpadding=0 cellspacing=0 class=func-menu2>
<tr><td>
<table>
<tr>
   <td width=100% colspan=2 class=func-menu2>$rgen</td>
</tr>
</table></td>
</tr>
</table>"

    return $tab_rgen
}


##################### dob add ###########################
ad_proc iter_tab_st_form {
cod_impianto
st_progressivo
} {
    Restituisce una variabile contenente i una tabella rappresentate i dati
    principale dell'impianto
} {
    iter_get_coimtgen
    set flag_viario       $coimtgen(flag_viario)
    set mesi_evidenza_mod $coimtgen(mesi_evidenza_mod)

#ns_log notice "prova dob2 flag_viario=$flag_viario"


    if {$flag_viario == "T"} {
#ns_log notice "prova dob $cod_impianto"
        set get_dat_aimp "get_dat_aimp_si_vie"
    } else {
        set get_dat_aimp "get_dat_aimp_no_vie"
    }

    if {[db_0or1row $get_dat_aimp ""] == 0} {
#       iter_return_complaint "Record non trovato"
        set cod_impianto_est ""
        set cod_impianto     ""
        set localita         ""
        set comune           ""
        set via              ""
        set topo             ""
        set numero           ""
        set esponente        ""
        set scala            ""
        set piano            ""
        set interno          ""
        set cap              ""
        set resp             ""
        set occup            ""
        set cod_utenza       ""
        set svc_mod          ""
        set cod_amag         ""
        set swc_mod          ""
    }

    if {[exists_and_not_null numero]
	&&  [exists_and_not_null topo]
	&&  [exists_and_not_null via]
    } {
        set virgola ","
    } else {
        set virgola ""
    }
    if {[exists_and_not_null numero]
	&&  [exists_and_not_null esponente]
    } {
        set barra "/"
    } else {
        set barra ""
    }
    if {[exists_and_not_null scala]} {
        set sc " S."
    } else {
        set sc ""
    }
    if {[exists_and_not_null piano]} {
        set pi " P."
    } else {
        set pi ""
    }
    if {[exists_and_not_null interno]} {
        set int " In."
    } else {
        set int ""
    }
    if {[exists_and_not_null localita]} {
        set loc " Loc. "
    } else {
        set loc ""
    }
    set ubic "$topo $via$virgola $numero$barra$esponente$sc$scala$pi$piano$int$interno$loc$localita $cap $comune"

    if {$swc_mod == "T"} {
        if {[db_0or1row sel_uten ""] == 0} {
            set uten_desc ""
        }
        set tab_mod "
            <td align=right>
            <table border=1 bordercolor=red>
            <tr>
                <td align=left nowrap class=func-menu2>Ultima modifica del:</td>
                <td align=left nowrap class=func-menu2>$data_mod_edit</td>
            </tr>
            <tr>
                <td align=left nowrap class=func-menu2>dell'utente:</td>
                <td align=left nowrap class=func-menu2>$uten_desc</td>
            </tr>
            </table>
            </td>
        "
    } else {
        set tab_mod ""
    }

    set tab_aimp "
<table width=100% class=func-menu2>
<tr><td align=left>
    <table>
    <tr>
        <td align=left valign=top class=func-menu2>Codice:</td>
        <td align=left valign=top class=func-menu2>$cod_impianto_est</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Ubicazione:</td>
        <td align=left valign=top class=func-menu2 colspan=4>$ubic</td>
    </tr>
    <tr>
        <td align=left valign=top class=func-menu2>Cod.utenza:</td>
        <td align=left valign=top class=func-menu2>$cod_amag</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Responsabile:</td>
        <td align=left valign=top class=func-menu2>$resp</td>
        <td align=left valign=top class=func-menu2>&nbsp;</td>
        <td align=left valign=top class=func-menu2>Occupante:</td>
        <td align=left valign=top class=func-menu2>$occup</td>
    </tr>
    </table>
    </td>
    $tab_mod
</tr>
</table>"
    return $tab_aimp
}




ad_proc iter_links_st_form {
    cod_impianto
    st_progressivo
    nome_funz_caller
    url_list_aimp
    url_aimp
    st_data_validita
    {extra_par ""}
    {flag_tracciato ""}
} {
    Restituisce una variabile contenente i link utilizzati dal programma
    di gestione degli impianti
} {
    iter_get_coimtgen
    set flag_ente  $coimtgen(flag_ente)
    set sigla_prov $coimtgen(sigla_prov)

    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]

#ns_log notice "prova dob1 id_utente=$id_utente"

    # imposto variabile uten per poi creare il tabella di link in base
    # al tipo di utente
    set uten "default"
    set nome_funz_impianti "impianti"

    # imposto la directory dei programmi
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    append pack_dir "src"

    # controllo se l'utente ▒ un manutentore
    if {[iter_check_uten_manu $id_utente] != ""} {
        set uten "manu"
    }

    # controllo se l'utente e' il responsabile cooperativa
    if {[iter_check_uten_coop_resp $id_utente] != ""} {
        set uten "coop_resp"
    }

    # controllo se l'utente e' l'addetto mod h cooperativa
    if {[iter_check_uten_coop_modh $id_utente] != ""} {
        set uten "coop_modh"
    }
    # controllo se l'utente e' l'addetto rapp.ver. cooperativa
    if {[iter_check_uten_coop_rappv $id_utente] != ""} {
        set uten "coop_rappv"
    }
    # controllo se l'utetne e' un ente verificatore o operatore
    set cod_tecn  [iter_check_uten_opve $id_utente]
    set cod_enve  [iter_check_uten_enve $id_utente]
    if {![string equal $cod_tecn ""]} {
        set uten "opve"
        set nome_funz_impianti "impianti-ver"
    }

    if {![string equal $cod_enve ""]} {
        set uten "enve"
        set nome_funz_impianti "impianti-ver"
    }

    set provenienza [ns_conn url]
    set prog [file tail $provenienza]

    set nome_funz [iter_get_nomefunz coimaimp-isrt-veloce]
    set nome_funz_inco "inco"
    if {$nome_funz_caller == $nome_funz} {
        set coimaimplist "
        <td width=\"12.5%\" nowrap class=func-menu>
           <a href=\"$pack_dir/coimaimp-isrt-veloce?[export_url_vars nome_funz]\" class=func-menu>Inserim. Imp.</a>
        </td>"
    } else {

        if {[string range $nome_funz_caller 0 3]== $nome_funz_inco
        ||   $nome_funz_caller == "scar"
        } {
            set coimaimplist "
             <td width=\"12.5%\" nowrap class=func-menu>
               <a href=\"$url_list_aimp\" class=func-menu>Appuntamento</a>
             </td>"
        } else {
            if {$nome_funz_caller == [iter_get_nomefunz coimmai2-filter]} {
                set coimaimplist "
                 <td width=\"12.5%\" nowrap class=func-menu>
                   <a href=\"$url_list_aimp\" class=func-menu>Acquis. impianti</a>
                 </td>"
            } else {
                set flag_controllo "f"
                db_foreach sel_funz_dimp_ins "select nome_funz as nome_funz_dimp_ins_check
                              from coimfunz
                             where dett_funz = 'coimdimp-ins-filter'
                " {
                    if {$nome_funz_caller == $nome_funz_dimp_ins_check} {
                        set nome_funz_dimp_ins $nome_funz_dimp_ins_check
                        set flag_controllo  "t"
                    }
                }

                if {$flag_controllo == "t"} {
                    set coimaimplist "
                         <td width=\"12.5%\" nowrap class=func-menu>
                         <a href=coimdimp-ins-filter?nome_funz=$nome_funz_dimp_ins_check&cod_impianto_old=$cod_impianto&flag_tracciato=$flag_tracciato class=func-munu>Ritorna</a>
                         </td>"
                } else {
		    #                   if {$nome_funz_caller == [iter_get_nomefunz coimbimp-filter]} {
#                       set coimaimplist "
#                        <td width=\"12.5%\" nowrap class=func-menu>
		    #                        <a href=coimbimp-filter?nome_funz=[iter_get_nomefunz coimbimp-filter]&cod_impianto_old=$cod_impiant\
o class=func-menu>Ritorna</a>
#                       </td>"
#                   } else {
                        set coimaimplist "
                        <td width=\"12.5%\" nowrap class=func-menu>
                           <a href=\"$url_list_aimp\" class=func-menu>Lista Impianti</a>
                        </td>"
#                   }
}
            }
        }
    }


    set coimdimp "$pack_dir/coimdimp-list?"
    set link_dimp "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimdimp-list]"

    set flag_cimp "S"
    set link_gage "[export_url_vars cod_impianto cod_manutentore url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimgage-gest]"

    set link_cimp "[export_url_vars cod_impianto url_list_aimp st_progressivo st_data_validita nome_funz_caller url_aimp flag_cimp]&nome_funz=[iter_get_nomefunz coimcimp-list]"

    set link_tecn "[export_url_vars url_list_aimp st_progressivo st_data_validita cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    set link_sogg "[export_url_vars cod_impianto url_list_aimp st_progressivo st_data_validita nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    set link_todo "[export_url_vars cod_impianto st_progressivo st_data_validita url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimtodo-list]&flag_impianti=T"

    set link_essi "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimessi-gest]"

    set link_movi "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimmovi-gest]"

    set link_prvv "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimprvv-gest]"

    set link_maps "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=impianti"

    db_1row sel_count_gend ""
    switch $conta_gend {
        1 {set coimgend "$pack_dir/coimgend-st-gest?funzione=V&"
           db_1row sel_cod_gend ""
	    set link_gend "[export_url_vars cod_impianto url_list_aimp nome_funz_caller gen_prog url_aimp st_progressivo st_data_validita]&nome_funz=[iter_get_nomefunz coimgend-st-gest]"
        }
        default {set coimgend "$pack_dir/coimgend-st-list?"
	    set link_gend "[export_url_vars cod_impianto url_list_aimp last_cod_impianto nome_funz_caller url_aimp st_progressivo st_data_validita]&nome_funz=[iter_get_nomefunz coimgend-st-list]"
        }
    }

    set link_gest "$url_aimp&[export_url_vars url_list_aimp]"
    set link_docu "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimdocu-list]"

    set link_sche "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    #set link_cont "[export_url_vars url_list_aimp cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimcont-list]"

    set flag_aimp "S"
    set link_inco "[export_url_vars cod_impianto url_list_aimp st_progressivo st_data_validita nome_funz_caller url_aimp flag_aimp]&nome_funz=incontro"

    set link_ubic "[export_url_vars url_list_aimp st_progressivo st_data_validita cod_impianto nome_funz_caller url_aimp]&nome_funz=$nome_funz_impianti"

    set link_stpm "[export_url_vars cod_impianto url_list_aimp nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimstpm-menu]"

    if {$prog == "coimaimp-gest"} {
        set coimaimpgest "<td width=\"12.5%\" nowrap class=func-sel>
<a href=\"$url_aimp&[export_url_vars url_list_aimp]\" class=func-sel>Dati Tecnici</a>
            </td>"
    } else {
        set coimaimpgest "<td width=\"12.5%\" nowrap class=func-menu>
<a href=\"$url_aimp&[export_url_vars url_list_aimp]\" class=func-menu>Dati Tecnici</a>
              </td>"

    }

    if {$uten == "manu"} {
        if {$prog == "coimgage-isrt"} {
            set coimgage "<td width=\"12.5%\" nowrap class=func-sel>
                      <a href=\"$pack_dir/coimgage-isrt?$link_gage\" class=func-sel>Gestione Agenda</a></td>"
        } else {
            set coimgage "<td width=\"12.5%\" nowrap class=func-menu>
                  <a href=\"$pack_dir/coimgage-isrt?$link_gage\" class=func-menu>Gestione Agenda</a></td>"
        }
    } else {
        set coimgage "<td width=\"12.5%\" nowrap class=func-menu>
&nbsp;
                      </td>"
    }

    if {$prog == "coimaimp-tecn"
    ||  $prog == "coimrift-list"
    } {
        set coimaimptecn "<td width=\"12.5%\" nowrap class=func-sel>
         <a href=\"$pack_dir/coimaimp-tecn?&$link_tecn\" class=func-sel>Ditte/Tecnici</a>
      </td>"
    } else {
        set coimaimptecn "<td width=\"12.5%\" nowrap class=func-menu>
         <a href=\"$pack_dir/coimaimp-st-tecn?&$link_tecn\" class=func-menu>Ditte/Tecnici</a>
      </td>"
    }
    if {$prog == "coimaimp-sogg"
    ||  $prog == "coimrifs-list"
    } {
        set coimaimpsogg "<td width=\"12.5%\" nowrap class=func-sel>
         <a href=\"$pack_dir/coimaimp-st-sogg?&$link_sogg\" class=func-sel>Soggetti resp.</a>         </td>"
    } else {
        set coimaimpsogg "<td width=\"12.5%\" nowrap class=func-menu>
         <a href=\"$pack_dir/coimaimp-st-sogg?&$link_sogg\" class=func-menu>Soggetti resp.</a>         </td>"
    }
    if {$prog == "coimaimp-ubic"
    ||  $prog == "coimstub-list"
    } {
        set coimaimpubic "<td width=\"12.5%\" nowrap class=func-sel>
          <a href=\"$pack_dir/coimaimp-st-ubic?&$link_ubic\" class=func-sel>Ubicazione</a>
      </td>"
    } else {
        set coimaimpubic "<td width=\"12.5%\" nowrap class=func-menu>
          <a href=\"$pack_dir/coimaimp-st-ubic?&$link_ubic\" class=func-menu>Ubicazione</a>
      </td>"
    }
    if {$prog == "coimgend-gest"
    ||  $prog == "coimgend-list"
    } {
        set coimgend "<td width=\"12.5%\" nowrap class=func-sel>
          <a href=\"$coimgend$link_gend\" class=func-sel>Generatori</a>
      </td>"
    } else {
        set coimgend "<td width=\"12.5%\" nowrap class=func-menu>
          <a href=\"$coimgend$link_gend\" class=func-menu>Generatori</a>
      </td>"
    }

    switch $uten {
        "manu" { set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                    $coimaimplist
                    $coimaimpgest
                    $coimgend
                    $coimaimpubic
                    $coimaimpsogg
                    $coimaimptecn
                 </tr>
                 </table>
                 "
        }
        "enve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                 </tr>
                 </table>
                 "
        }
        "opve" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                 </tr>
                 </table>
                 "
        }
        "coop_resp" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                     $coimaimptecn
                 </tr>
                  </table>
                 "
        }
        "coop_modh" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                     $coimaimptecn
                  </tr>
                 </table>
                 "
        }
        "coop_rappv" {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                     $coimaimptecn
                  </tr>
                 </table>
                 "
        }
        default {set links "
                 <table width=\"100%\" cellspacing=0  class=func-menu>
                 <tr>
                     $coimaimplist
                     $coimaimpgest
                     $coimgend
                     $coimaimpubic
                     $coimaimpsogg
                     $coimaimptecn
                  </tr>
                  </table>
                 "
        }
        return $links
    }
}
