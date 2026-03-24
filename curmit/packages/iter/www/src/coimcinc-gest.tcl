ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcinc"
    @author          Giulio Laurenzi
    @creation-date   10/02/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimcinc-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi Data inizio e data_fine.
} {
    
   {cod_cinc ""}
   {last_cod_cinc ""}
   {funzione  "V"}
   {caller    "index"}
   {nome_funz ""}
   {extra_par ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest      [export_url_vars cod_cinc last_cod_cinc nome_funz extra_par caller]

iter_set_func_class $funzione

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_cinc caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Campagna appuntamenti"

set msg_att ""
switch $funzione {
    M {set button_label "Conferma Modifica" 
       set page_title   "Modifica $titolo"}
    D {set button_label "Conferma Cancellazione"
       set page_title   "Cancellazione $titolo"
       set msg_att "<br><font color=red><b>Attenzione cancellando la campagna eliminerà tutti gli incontri ad essa collegati</b></font><br>"}
    I {set button_label "Conferma Inserimento"
       set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizzazione $titolo"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz]

iter_get_coimtgen
set flag_stat_estr_calc $coimtgen(flag_stat_estr_calc)

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcinc"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
   "I" {set readonly_key \{\}
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

form create $form_name \
-html    $onsubmit_cmd

# inizio dpr74
element create $form_name flag_tipo_impianto \
    -label   "flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}

# fine dpr74
element create $form_name cod_cinc \
-label   "Codice" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_key {} class form_element" \
-optional


element create $form_name descrizione \
-label   "Descrizione" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name stato\
-label   "Stato" \
-widget   select \
-options  {{{} {}} {Aperta 1} {Chiusa 2} {Preventivata 3}} \
-datatype text \
-html    "class form_element $disabled_fld {}" \
-optional
#but01 Aggiunto la classe ah-jquery-date ai campi Data inizio e data_fine.
element create $form_name data_inizio \
-label   "Data inizio" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name data_fine \
-label   "Data fine" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name controlli_prev \
-label   "Controlli previsti" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 4 $readonly_fld {} class form_element" \
-optional


element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_cinc -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name extra_par -value $extra_par
    element set_properties $form_name last_cod_cinc -value $last_cod_cinc

    if {$funzione == "I"} {
        
    } else {
      # leggo riga
        if {[db_0or1row sel_cinc ""] == 0
        } {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_cinc    -value $cod_cinc
        element set_properties $form_name stato       -value $stato
        element set_properties $form_name descrizione -value $descrizione
        element set_properties $form_name data_inizio -value $data_inizio
        element set_properties $form_name data_fine   -value $data_fine
        element set_properties $form_name note        -value $note
        element set_properties $form_name controlli_prev -value $controlli_prev
        # inizio dpr74
        element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
        # fine dpr74
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_cinc       [element::get_value $form_name cod_cinc]
    set stato          [element::get_value $form_name stato]
    set descrizione    [element::get_value $form_name descrizione]
    set data_inizio    [element::get_value $form_name data_inizio]
    set data_fine      [element::get_value $form_name data_fine]
    set controlli_prev [element::get_value $form_name controlli_prev]
    set note           [element::get_value $form_name note]
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	set err "N"
        if {[string equal $data_inizio ""]} {
            element::set_error $form_name data_inizio "Inserire data inizio"
            incr error_num
	    set err "S"
        } else {
            set data_inizio [iter_check_date $data_inizio]
            if {$data_inizio == 0} {
                element::set_error $form_name data_inizio "Data non corretta"
                incr error_num
		set err "S"
            }
        }

	if {$funzione == "I"} {
	    set where_cod ""
	} else {
	    set where_cod " and cod_cinc <> :cod_cinc"
	}

        if {[string equal $stato ""]} {
            element::set_error $form_name stato "Inserire lo stato"
            incr error_num
        } else {
	    if {[db_0or1row sel_cinc_count ""] == 0} {
		set conta 0
	    }
	    if {$conta > 0
	    && $stato == 1
	    } {
		element::set_error $form_name stato "Esiste gi&agrave; una campagna aperta"
		incr error_num
	    }
	}

        if {[string equal $data_fine ""]} {
            element::set_error $form_name data_fine "Inserire data fine"
            incr error_num
        } else {
            set data_fine [iter_check_date $data_fine]
            if {$data_fine == 0} {
                element::set_error $form_name data_fine "Data non corretta"
                incr error_num
            } else {
		if {$err == "N"
		    && $data_fine < $data_inizio} {
		    element::set_error $form_name data_fine "Non deve essere minore di data inizio"
		    incr error_num
		}
	    }   
        }

	if {[string equal $descrizione ""]} {
	    element::set_error $form_name descrizione "Inserire descrizione"
            incr error_num
	} else {
	    switch $funzione {
		"I" {set where_cod ""}
		"M" {set where_cod "and cod_cinc <> :cod_cinc"}
	    }
	    if {[db_0or1row sel_desc ""] == 1
	    } {
		element::set_error $form_name descrizione "Descrizione gi&agrave; presente"
		incr error_num
	    }
	}


	
	if {[string equal $controlli_prev ""]} {
	    if {$flag_stat_estr_calc == "T"} {
		element::set_error $form_name controlli_prev "Inserire i controlli previsti"
                incr error_num
	    }
	} else {
            set controlli_prev [iter_check_num $controlli_prev 0]
            if {$controlli_prev == "Error"} {
                element::set_error $form_name controlli_prev "Deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $controlli_prev] >=  [expr pow(10,7)]
		||  [iter_set_double $controlli_prev] <= -[expr pow(10,7)]} {
                    element::set_error $form_name controlli_prev "Deve essere inferiore di 10.000.000"
                    incr error_num
                }
            }
        }

    }

    if {$funzione == "D"} {

	if {[db_0or1row sel_cinc_2 ""] == 0} {
	    set stato ""
	}

	if {$stato == "2"} {
	    element::set_error $form_name cod_cinc "Cancallazione impossibile: campagna chiusa"
	    incr error_num
# nuova modifica, ma sembra troppo restrittiva.
# attualmente cancellando una campagna aperta o preventivata vengono cancellati
# tutti i relativi controlli indipendentemente dal loro stato.
#	} else {
#	    db_1row sel_inco_count ""
#	    if {$ctr_inco > 0} {
#		element::set_error $form_name cod_cinc "Cancellazione impossibile: sono presenti incontri con stato differente da \"Estratto\" e \"Annullato\""
#		incr error_num
#	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {
	    db_1row sel_dual_cod ""
	    set dml_sql  [db_map ins_cinc]
        }
        M {
	    set dml_sql  [db_map mod_cinc] 
        }
        D {
	    set dml_sql  [db_map del_cinc]
	    set dml_sql2 [db_map del_inco]
        }
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimcinc $dml_sql
		if {[info exists dml_sql2]} {
		    db_dml dml_coiminco $dml_sql2
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
        set last_cod_cinc [list $data_inizio $cod_cinc]
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_cinc last_cod_cinc nome_funz extra_par caller]
    switch $funzione {
        M {set return_url   "coimcinc-gest?funzione=V&$link_gest"}
        D {set return_url   "coimcinc-list?$link_list"}
        I {set return_url   "coimcinc-gest?funzione=V&$link_gest"}
        V {set return_url   "coimcinc-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
