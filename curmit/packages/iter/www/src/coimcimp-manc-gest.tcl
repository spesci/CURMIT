ad_page_contract {
    Add/Edit/Delete  form per la tabella "Rapporti di verifica" (coimcimp)
    @author          Giulio Laurenzi
    @creation-date   21/04/2005

    @param cod_cimp         E' la chiave della tabella
    @last_cod_cimp          E' l'ultima chiave della lista rapporti di verifica
    @param funzione         I=insert M=edit D=delete V=view
    @param caller           caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz        identifica l'entrata di menu,
    serve per le autorizzazioni
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par        Variabili extra da restituire alla lista
    @param cod_impianto     Codice impianto cui si riferisce il rapporto di v
    (E' indispensabile per l'inserimento).
    @param gen_prog         Numero del generatore cui si riferice.
    (E' indispensabile per l'inserimento).
    @param url_aimp         Url da restituire a coimaimp-gest
    @param url_list_aimp    Url da restituire a coimaimp-list
    @param flag_cimp        Se vale "S" significa che il programma e' stato
    richiamato dalla gestione impianti.
    @param flag_inco        Se vale "S" significa che il programma e' stato
    richiamato dalla gestione appuntamenti.
    @param extra_par_inco   Parametri da restituire alla gestione appuntamenti.
    @param cod_inco         Codice appuntamento (tabella coiminco).
    @param flag_modifica    Parametro che viene valorizzato da questo programma
    ed utilizzato dall'adp per vietare la modifica
    se e' gia' stato inserito da piu' di un certo
    numero di giorni specificati nella tabella coimtgen

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_controllo, data_scad_pagamento. 
    rom01 11/06/2021 Aggiunto link_prnt e link_prn2.

    sim01 18/11/2016 Gestito la potenza in base al flag_tipo_impianto

    @cvs-id                 coimcimp-gest.tcl
} {
    
    {cod_cimp         ""}
    {last_cod_cimp    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {cod_impianto     ""}
    {gen_prog         ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
    {flag_cimp        ""}
    {flag_inco        ""}
    {extra_par_inco   ""}
    {cod_inco         ""}
    {flag_modifica    ""}
    {flag_tipo_impianto   "R"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# bisogna reperire id_utente dai cookie perche' il controllo di autorizzazione
# e' gia' stato effettuato dal programma che si trova sotto src
# e che indirizza la richiesta alle sottodirectory di srcpers.

#set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente [iter_get_id_utente]

#if {$id_utente  == ""} {
#    set login [ad_conn package_url]
#    iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
#    return 0
#}

# valorizzo pack_dir che sara' utilizzata sull'adp per fare i link.
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"

# verifico se sono un tecnico o un operatore
set cod_enve   [iter_check_uten_enve $id_utente]
set cod_tecn   [iter_check_uten_opve $id_utente]

if {![string equal $cod_enve ""]} {
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}

if {![string equal $cod_tecn ""]} {
    set flag_cod_tecn "t"  
} else {
    set flag_cod_tecn "f"
}

# preparo alcune variabili utilizzate nel programma
iter_get_coimtgen
set flag_agg_da_verif $coimtgen(flag_agg_da_verif)
set flag_dt_scad      $coimtgen(flag_dt_scad)
set flag_gg_modif_rv  $coimtgen(flag_gg_modif_rv)
set gg_scad_pag_rv    $coimtgen(gg_scad_pag_rv)
set flag_ente         $coimtgen(flag_ente)
set sigla_prov        $coimtgen(sigla_prov)
set current_date      [iter_set_sysdate]
set note_verificatore ""

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# preparo il link da usare per richiamare questo programma con tutti i
# i parametri ricevuti e cambiando solo la funzione
set link_gest [export_url_vars cod_cimp last_cod_cimp nome_funz nome_funz_caller extra_par cod_impianto url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]

#rom01 preparo i link per richiamare la stampa e l'inserimento del documento.
set link_prnt [export_url_vars cod_cimp cod_impianto nome_funz nome_funz_caller caller];#rom01
set link_prn2 [export_url_vars cod_cimp cod_impianto nome_funz nome_funz_caller caller];#rom01


# preparo il link da usare per tornare alla lista rapporti di verifica;
# e' diverso a seconda se il programma e' stato richiamato o meno
# dalla gestione impianti
if {$flag_cimp == "S"} {
    set link_list_script {[export_url_vars cod_impianto last_cod_cimp nome_funz_caller nome_funz url_aimp url_list_aimp flag_cimp]&[iter_set_url_vars $extra_par]}
} else {
    set link_list_script {[export_url_vars cod_impianto last_cod_cimp nome_funz_caller nome_funz flag_cimp flag_inco cod_inco extra_par_inco]&[iter_set_url_vars $extra_par]}
}
set link_list        [subst $link_list_script]

# imposto la proc per i link e per il dettaglio impianto
if {$flag_cimp == "S"} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
} else {
    set link_tab ""
    if {$funzione != "I"
	&&  [db_0or1row sel_cimp_cod_impianto ""] == 0
    } {
	iter_return_complaint "Rapporto di ispezione non trovato"
    }
}

# se il programma e' stato richiamato dalla gestione appuntamenti,
# preparo l'html di testata degli appuntamenti da usare nell'adp.
if {$flag_inco == "S"} {
    set link_inc [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz "" $extra_par_inco]
} else {
    set link_inc ""
}

# preparo l'html con i dati identificativi dell'impianto.
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set titolo           "Rapporto di ispezione"
switch $funzione {
    M {set button_label "Conferma Modifica" 
	set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
	set page_title   "Cancellazione $titolo"}
    I {set button_label "Conferma Inserimento"
	set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
	set page_title   "Visualizzazione $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcimp"
set readonly_key "readonly"
set disabled_key "disabled"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set disabled_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
    }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

set disabled_opve $disabled_fld
if {$flag_cod_tecn == "t"} {
    # disabilito tecnico verificatore se utente e' tecnico verificatore
    set disabled_opve "disabled"
}

form create $form_name \
    -html    $onsubmit_cmd

if {$flag_inco   != "S"
    && (   $funzione == "I"
	   || $funzione == "M")
} {
    set readonly_inco \{\}
    set link_inco     [iter_search $form_name [ad_conn package_url]/src/coiminco-list [list dummy_1 cod_inco cod_impianto cod_impianto]]
} else {
    set readonly_inco "readonly"
    set link_inco     ""
}

element create $form_name cod_inco \
    -label   "Cod.inc." \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $readonly_inco {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_controllo, 
element create $form_name data_controllo \
    -label   "Data controllo" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name verb_n \
    -label   "Num. verbale" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 20 $readonly_fld {} class form_element" \
    -optional

if {$disabled_opve != "disabled"} {

    # se il verificatore e' valorizzabile, uso un selection box
    # che propone ente verificatore - tecnico verificatore.
    # nel caso in cui l'utente e' un ente-verificatore
    # allora vengono proposti solamente i suoi tecnici.
    if {$flag_cod_enve == "t"} {
	set where_enve_opve " and o.cod_enve = :cod_enve"
    } else {
	set where_enve_opve ""
    }
    set lista_opve [db_list_of_lists sel_enve_opve ""]
    set lista_opve [linsert $lista_opve 0 [list "" ""]]

    element create $form_name cod_opve \
	-label   "Verificatore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options  $lista_opve
} else {
    # se il verificatore e' protetto,
    # metto il cod_opve in un campo hidden
    # e visualizzo ente - tecnico verificatore.

    element create $form_name cod_opve -widget hidden -datatype text -optional

    element create $form_name des_opve \
	-label   "Verificatore" \
	-widget   text \
	-datatype text \
	-html    "size 47 maxlegth 100 readonly {} class form_element" \
	-optional
}

element create $form_name costo \
    -label   "Costo verifica" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

if {$flag_ente  == "P"
    &&  $sigla_prov == "MN"
} {
    element create $form_name tipologia_costo \
	-label   "Tipo pagamento" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {{Bollettino postale} BP}}
} else {
    element create $form_name tipologia_costo \
	-label   "Tipo pagamento" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {{Bollettino postale} BP} {{Contante a sportello dell'ente gestore} CN} {{Bonifico Bancario} BB} {{Carta di Credito} CC} {{POS} PS}}
}

element create $form_name flag_pagato \
    -label   "Pagato" \
    -widget   select \
    -options  {{{} {}} {No N} {S&igrave; S}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_scad_pagamento
element create $form_name data_scad_pagamento \
    -label   "Data scadenza pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name riferimento_pag \
    -label   "Riferimento_pag" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_noin \
    -label   "Anomalia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimnoin cod_noin descr_noin "" "where  data_fine_valid is null"]
#    -options [iter_selbox_from_table coimnoin cod_noin descr_noin]

element create $form_name note_verificatore \
    label   "note_verificatore" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_cimp      -widget hidden -datatype text -optional
element create $form_name last_cod_cimp -widget hidden -datatype text -optional
element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name gen_prog      -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional

element create $form_name flag_cimp     -widget hidden -datatype text -optional
element create $form_name flag_inco     -widget hidden -datatype text -optional
element create $form_name extra_par_inco -widget hidden -datatype text -optional
element create $form_name cod_inco_old  -widget hidden -datatype text -optional
element create $form_name flag_modifica -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"


if {[form is_request $form_name]} {

    element set_properties $form_name last_cod_cimp  -value $last_cod_cimp
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par      -value $extra_par
    element set_properties $form_name cod_impianto   -value $cod_impianto
    element set_properties $form_name gen_prog       -value $gen_prog
    element set_properties $form_name url_list_aimp  -value $url_list_aimp
    element set_properties $form_name url_aimp       -value $url_aimp
    element set_properties $form_name flag_cimp      -value $flag_cimp   
    element set_properties $form_name flag_inco      -value $flag_inco
    element set_properties $form_name note_verificatore   -value $note_verificatore

    #   cod_inco viene valorizzato col default in inserimento oppure con
    #   quello letto dalla coimcimp.
    #   element set_properties $form_name cod_inco       -value $cod_inco
    element set_properties $form_name extra_par_inco -value $extra_par_inco

    # reperisco i dati dell'impianto
    if {[db_0or1row sel_aimp ""] == 0} {
	iter_return_complaint "Impianto non trovato"
    }
    

    if {$funzione == "I"} {
	# estraggo cod_potenza della pot_focolare_nom
	# che serve per ricavare la tariffa da applicare alla verifica
	set h_potenza $aimp_pot_focolare_nom
        if {[db_0or1row sel_pote_cod_potenza ""] == 0} {
	    set cod_potenza ""
	}

	set tipo_costo "5"
	# determinare la tariffa
	if {[db_0or1row sel_tari ""] == 1} {
	    set costo [iter_edit_num $importo 2]
	} else {
	    set costo ""
	}

	# nel caso provenga dagli incontri, cod_inco e' gia' valorizzato
	# correttamente.
	# nel caso provenga dalla gestione impianto, valorizzo cod_inco
	# con l'eventuale incontro dell'impianto e campagna correnti.
	if {$flag_inco != "S"} {
	    db_foreach sel_inco_default "" {
		# se ho piu' di una campagna aperta (evento funzionalmente
		# impossibile, seleziono l'appuntamento piu' recente)
		break
	    }
	    # se l'appuntamento e' gia' stato associato ad un rapporto
	    # di verifica, evito di usarlo come default
	    set ctr_cimp_inco [db_string sel_cimp_inco_count ""]
	    if {$ctr_cimp_inco > 0} {
		set cod_inco ""
	    }
	}

	# estraggo i dati dell'appuntamento da usare come default
	set inco_cod_opve      ""
	set inco_data_verifica ""
	if {![string equal $cod_inco ""]} {
	    if {[db_0or1row sel_inco ""] == 0} {
		iter_return_complaint "Appuntamento non trovato"
	    }
	}

	# se cod_opve non e' stato valorizzato con quello dell'appuntamento
	# e se l'utente e' un tecnico, lo valorizzo col codice del tecnico.
        set cod_opve $inco_cod_opve
	if {[string equal $cod_opve ""]} {
	    set cod_opve $cod_tecn
	}

	# se ho l'incontro, valorizzo i default di data controllo e tecnico.
	element set_properties $form_name cod_inco              -value $cod_inco
	element set_properties $form_name data_controllo        -value $inco_data_verifica
	element set_properties $form_name cod_opve              -value $cod_opve

        element set_properties $form_name costo                 -value $costo
        element set_properties $form_name tipologia_costo       -value "BP"
    } else {

	# leggo riga
        if {[db_0or1row sel_cimp ""] == 0} {
            iter_return_complaint "Mancata ispezione non trovata"
	}

        set data_scad_mod [clock format [clock scan "$data_ins $flag_gg_modif_rv day"] -f %Y%m%d]
        if {$data_scad_mod >= $current_date} {
	    set flag_modifica "T" 
        } else {
	    set flag_modifica "F"
        }

        element set_properties $form_name flag_modifica       -value $flag_modifica
        element set_properties $form_name cod_cimp            -value $cod_cimp
        element set_properties $form_name cod_inco            -value $cod_inco
        element set_properties $form_name data_controllo      -value $data_controllo
        element set_properties $form_name cod_opve            -value $cod_opve
        element set_properties $form_name costo               -value $costo
        element set_properties $form_name tipologia_costo     -value $tipologia_costo
	 element set_properties $form_name flag_pagato         -value $flag_pagato
	 element set_properties $form_name data_scad_pagamento -value $data_scad
	 element set_properties $form_name riferimento_pag     -value $riferimento_pag
	 element set_properties $form_name cod_noin            -value $cod_noin
	 element set_properties $form_name verb_n              -value $verb_n
        element set_properties $form_name note_verificatore   -value $note_verificatore
   
     
    }

    # sia in inserimento che in modifica:
    # se opve e' disabled di conseguenza cod_opve e' hidden
    # e bisogna visualizzare des_opve
    if {$disabled_opve == "disabled"
	&& ![string equal $cod_opve ""]
    } {
	set where_enve_opve " and o.cod_opve = :cod_opve"
	if {[db_0or1row sel_enve_opve ""] == 0} {
	    set des_opve ""
	}
	element set_properties $form_name des_opve     -value $des_opve
    }  
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_cimp                [element::get_value $form_name cod_cimp]
    set cod_inco                [element::get_value $form_name cod_inco]
    set cod_inco_old            [element::get_value $form_name cod_inco_old]
    set data_controllo          [element::get_value $form_name data_controllo]
    set cod_opve                [element::get_value $form_name cod_opve]
    set costo                   [element::get_value $form_name costo]
    set tipologia_costo         [element::get_value $form_name tipologia_costo]
    set flag_pagato             [element::get_value $form_name flag_pagato]
    set data_scad_pagamento     [element::get_value $form_name data_scad_pagamento]
    set riferimento_pag         [element::get_value $form_name riferimento_pag]
    set cod_noin                [element::get_value $form_name cod_noin]
    set verb_n                  [element::get_value $form_name verb_n]
    set note_verificatore       [element::get_value $form_name note_verificatore]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    set flag_errore_pot_focolare_nom_ok "f"

    if {$funzione == "I"
	||  $funzione == "M"
    } {

	set cinc_data_inizio ""
	set cinc_data_fine   ""
	set data_assegn      ""
	if {![string equal $cod_inco ""]} {
	    if {[db_0or1row sel_inco ""] == 0} {
		element::set_error $form_name cod_inco "Appuntamento non esistente"
		incr error_num
	    } else {
		if {$inco_cod_impianto != $cod_impianto} {
		    element::set_error $form_name cod_inco "Appuntamento relativo ad un altro impianto"
		    incr error_num
		}

		if {![string equal $cod_cinc  ""]} {
		    # estraggo, cinc_data_inizio e cinc_data_fine, default ""
		    db_0or1row sel_cinc ""
		}
	    }
	}

	set sw_data_controllo_ok "f"
        if {[string equal $data_controllo ""]} {
            element::set_error $form_name data_controllo "Inserire data mancata ispezione"
            incr error_num
        } else {
            set data_controllo [iter_check_date $data_controllo]
            if {$data_controllo == 0} {
                element::set_error $form_name data_controllo "Data non corretta"
                incr error_num
            } else {
		if {$data_controllo > $current_date} {
		    element::set_error $form_name data_controllo "Data deve essere anteriore alla data odierna"
		    incr error_num
		} else {
		    if {![string is space $cinc_data_inizio]
			&&  ![string is space $cinc_data_fine]
			&&  (   $data_controllo < $cinc_data_inizio
				|| $data_controllo > $cinc_data_fine)
		    } {
			element::set_error $form_name data_controllo "Data non compresa nella campagna dell'appuntamento (fra il [iter_edit_date $cinc_data_inizio] ed il [iter_edit_date $cinc_data_fine]"
			incr error_num
		    } else {
			if {$funzione == "M"} {
			    set where_cod_cimp "and cod_cimp <> :cod_cimp"
			} else {
			    set where_cod_cimp ""
			}
			
			if {[db_string sel_cimp_count_dup ""] > 0} {
			    element::set_error $form_name data_controllo "Esiste gi&agrave; una mancata ispezione in questa data"
			    incr error_num
			} else {
			    set sw_data_controllo_ok "t"
			    if {[string equal $data_assegn ""]} {
				set data_assegn $data_controllo
			    }
			}
		    }
		}
	    }
	}

	if {[string equal $cod_opve ""]} {
	    element::set_error $form_name cod_opve "Inserire l'ispettore"
	    incr error_num
	}
	
	set sw_costo_null "f"
        if {![string equal $costo ""]} {
            set costo [iter_check_num $costo 2]
            if {$costo == "Error"} {
                element::set_error $form_name costo "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
                if {[iter_set_double $costo] >=  [expr pow(10,7)]
		    ||  [iter_set_double $costo] <= -[expr pow(10,7)]} {
                    element::set_error $form_name costo "Deve essere inferiore di 10.000.000"
                    incr error_num
                } else {
		    if {$costo == 0} {
			set sw_costo_null "t"
		    }
		}
            }
        } else {
	    set sw_costo_null "t"
	}

	# costo e' obbligatorio se sono stati indicati gli altri estremi
	# del pagamento
	if {$sw_costo_null == "t"} {
	    if {![string equal $tipologia_costo ""]
		||   $flag_pagato == "S"
	    } {
		element::set_error $form_name costo "Inserire il costo"
		incr error_num
	    }
	}

	# tipologia costo e' obbligatoria se sono stati indicati
	# gli altri estremi del pagamento
	if {[string equal $tipologia_costo ""]} {
	    if {$sw_costo_null == "f"
		||  $flag_pagato   == "S"
	    } {
		element::set_error $form_name tipologia_costo "Inserire la tipologia del costo"
		incr error_num
	    }
	}

	if {![string equal $data_scad_pagamento ""]} {
	    set data_scad_pagamento [iter_check_date $data_scad_pagamento]
	    if {$data_scad_pagamento == 0} {
		element::set_error $form_name data_scad_pagamento "Data scadenza pagamento deve essere una data"
		incr error_num
	    }
	} else {
	    # se non e' stata compilata la data scadenza pagamento
	    # ed esistono gli altri estremi del pagamento
	    # devo calcolarla in automatico:
	    # se il pagamento e' effettuato,               con data controllo
	    # se il pagamento e' avvenuto tramite bollino, con data controllo
	    # negli altri casi con data controllo + gg_scad_pag_rv
	    # che e' un parametro di procedura.
	    if {![string equal $tipologia_costo ""]
		||  $sw_costo_null == "f"
		||  $flag_pagato   == "S"
	    } {
		if {$tipologia_costo == "BO"
		    ||  $flag_pagato     == "S"
		    ||  [string equal $gg_scad_pag_rv ""]
		} {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento $data_controllo
		    }
		} else {
		    # se data_controllo non e' corretta, viene gia' segnalato
		    # l'errore sulla data_controllo.
		    if {$sw_data_controllo_ok == "t"} {
			set data_scad_pagamento [clock format [clock scan "$gg_scad_pag_rv day" -base [clock scan $data_controllo]] -f "%Y%m%d"]
		    }
		}
	    }
	}

	set sw_movi     "f"
	set data_pag    ""
	set importo_pag ""
	if {$sw_costo_null == "f" && ![string equal $tipologia_costo ""]} {
	    set sw_movi "t"
	    if {$flag_pagato == "S"} {
		set data_pag    $data_scad_pagamento
		set importo_pag $costo
	    }
	}
    }


    if {$funzione == "I"
    ||  $funzione == "M"
    } {
	#sandro 170713
	db_1row sel_cod_cinc "select cod_cinc as cod_camp from coimcinc where stato = '1'"
	db_1row sel_contr_cimp "select count(*) as cont_cimp from coimcimp a,  coiminco b where a.cod_impianto = b.cod_impianto and b.cod_cinc = :cod_camp and a.cod_cimp = :cod_cimp"
	
	if {$cont_cimp > 1 } {
            element::set_error $form_name cod_inco  "Non si possono inserire più rapporti di controllo per la stesso appuntamento"
	    incr error_num
	}
    }


    if {$error_num > 0} {
	# segnalo la presenza di errori nella pagina
        ad_return_template
        return
    }
    
    switch $funzione {
        I {
	    db_1row sel_dual_cod_cimp ""
	    set dml_sql [db_map ins_cimp]

	    if {$sw_movi == "t"} {
		db_1row sel_dual_cod_movi ""
		set dml_movi [db_map ins_movi]
	    }

	    if {![string equal $cod_inco ""]} {
		set dml_inco [db_map upd_inco]
	    }

	}
        M {
	    set dml_sql [db_map upd_cimp]

	    if {$sw_movi == "t"} {
		if {[db_0or1row sel_movi_check ""] == 0} {
		    db_1row sel_dual_cod_movi ""
		    set dml_movi  [db_map ins_movi]
		} else {
		    set dml_movi  [db_map upd_movi]
		}
	    } else {
		set dml_movi      [db_map del_movi]
	    }

	    if {![string equal $cod_inco_old ""]
		&&  $cod_inco_old != $cod_inco
		&&  [db_string sel_cimp_inco_count ""] <= 1
	    } {
		# annullo l'esito di cod_inco_old (esito diventa null)
		set dml_inco_old [db_map upd_inco_old]
	    }

	    if {![string equal $cod_inco ""]} {
		set dml_inco [db_map upd_inco]
	    }
	}
        D { set dml_sql           [db_map del_cimp]
	    set dml_movi          [db_map del_movi]

	    if {![string equal $cod_inco_old ""]} {
		# uso la query sel_cimp_inco_count
		set save_cod_inco     $cod_inco
		set cod_inco          $cod_inco_old
		if {[db_string sel_cimp_inco_count ""] <= 1} {
		    # annullo l'esito di cod_inco_old (esito diventa null)
		    set dml_inco_old [db_map upd_inco_old]
		}
		set cod_inco          $save_cod_inco
	    }
	}
    }
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimcimp $dml_sql
		if {[info exists dml_movi]} {
		    db_dml dml_coimmovi $dml_movi
		}

		if {[info exists dml_inco_old]} {
		    db_dml dml_coiminco_old $dml_inco_old
		}

		if {[info exists dml_inco]} {
		    db_dml dml_coiminco $dml_inco
		}
	    }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_cod_cimp $cod_cimp
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto gen_prog cod_cimp last_cod_cimp nome_funz nome_funz_caller extra_par url_aimp url_list_aimp flag_cimp flag_inco extra_par_inco cod_inco]
    switch $funzione {
        M {set return_url "[ad_conn package_url]src/coimcimp-manc-gest?funzione=V&$link_gest"}
        D {set return_url "[ad_conn package_url]src/coimcimp-list?$link_list"}
        I {set return_url "[ad_conn package_url]src/coimcimp-manc-gest?funzione=V&$link_gest"}
        V {set return_url "[ad_conn package_url]src/coimcimp-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}
ad_return_template
