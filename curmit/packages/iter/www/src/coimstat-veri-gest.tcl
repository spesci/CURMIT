ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimbatc"
    @author          Giulio Laurenzi
    @creation-date   15/07/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @cvs-id          coimbatc-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi dat_prev, data_verifica_fine, data_verifica_fine.
} {
    {cod_batc         ""}
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set link_gest [export_url_vars cod_batc nome_funz nome_funz_caller caller]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# preparo i link di testata della pagina per consultazione coda lavori
set nom       "Statistica Verifiche"
set link_head [iter_links_batc $nome_funz $nome_funz_caller $nom]

# Personalizzo la pagina
set titolo              "Statistica Verifiche"
switch $funzione {
    I {set button_label "Conferma lancio"
       set page_title   "Lancio $titolo "}
    V {set button_label "Torna al menu"
       set page_title   "$titolo lanciato"}
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name     "coimbatc"
set readonly_key  "readonly"
set readonly_fld  "readonly"
set disabled_fld  "disabled"
set onsubmit_cmd  ""
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
#but01 Aggiunto la classe ah-jquery-date ai campi dat_prev, data_verifica_fine, data_verifica_fine.
element create $form_name dat_prev \
-label   "Data partenza" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name ora_prev \
-label   "Ora partenza" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional


element create $form_name cod_cinc \
-label   "Della campagna" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimcinc cod_cinc descrizione]

element create $form_name data_verifica_iniz \
-label   "Effettuate dal" \
-widget   text \
-datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name data_verifica_fine \
-label   "Fino al" \
-widget   text \
-datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name funzione     -widget hidden -datatype text -optional
element create $form_name caller       -widget hidden -datatype text -optional
element create $form_name nome_funz    -widget hidden -datatype text -optional
element create $form_name submit       -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name current_date -widget hidden -datatype text -optional
element create $form_name current_time -widget hidden -datatype text -optional

if {[db_0or1row sel_cinc_att ""] == 0} {
    set cod_cinc_att ""
}
#element set_properties $form_name cod_cinc     -value $cod_cinc_att


if {[form is_request $form_name]} {
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz

    if {$funzione == "I"} {
	set current_date [iter_set_sysdate]
	set current_time [iter_set_systime]
	set dat_prev [iter_edit_date $current_date]
	set ora_prev $current_time

        element set_properties $form_name dat_prev     -value $dat_prev
        element set_properties $form_name ora_prev     -value $ora_prev
	element set_properties $form_name current_date -value $current_date
	element set_properties $form_name current_time -value $current_time
    } else {
      # leggo riga
        if {[db_0or1row sel_batc {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name dat_prev           -value $dat_prev
        element set_properties $form_name ora_prev           -value $ora_prev

	foreach {key value} $par {
	    set $key $value
	}
	set data_verifica_iniz [iter_edit_date $data_verifica_iniz]
	set data_verifica_fine [iter_edit_date $data_verifica_fine]

        element set_properties $form_name cod_cinc           -value $cod_cinc
        element set_properties $form_name data_verifica_iniz -value $data_verifica_iniz
        element set_properties $form_name data_verifica_fine -value $data_verifica_fine
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set current_date       [element::get_value $form_name current_date]
    set current_time       [element::get_value $form_name current_time]
    set dat_prev           [element::get_value $form_name dat_prev]
    set ora_prev           [element::get_value $form_name ora_prev]
    set cod_cinc           [element::get_value $form_name cod_cinc]
    set data_verifica_iniz [element::get_value $form_name data_verifica_iniz]
    set data_verifica_fine [element::get_value $form_name data_verifica_fine]

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"} {

	set data_prev_ok "f"
	if {[string equal $dat_prev ""]} {
	    element::set_error $form_name dat_prev "Inserire data partenza"
	    incr error_num
	} else {
	    set dat_prev [iter_check_date $dat_prev]
	    if {$dat_prev == 0} {
		element::set_error $form_name dat_prev "Data partenza non corretta"
		incr error_num
	    } else {
		if {$dat_prev < $current_date} {
		    element::set_error $form_name dat_prev "Data partenza deve essere presente o futura"
		    incr error_num
		} else {
		    set data_prev_ok "t"
		}
	    }
	}

	if {[string equal $ora_prev ""]} {
	    element::set_error $form_name ora_prev "Inserire ora partenza"
	    incr error_num
	} else {
	    set ora_prev [iter_check_time $ora_prev]
	    if {$ora_prev == 0} {
		element::set_error $form_name ora_prev "Ora partenza non corretta"
		incr error_num
	    } else {
		if {$data_prev_ok == "t"
		&&  $dat_prev == $current_date
		&&  $ora_prev  < $current_time
		} {
		    element::set_error $form_name ora_prev "Ora partenza deve essere presente o futura"
		    incr error_num
		} else {
		    set ora_prev "$ora_prev:00"
		}
	    }
	}

	if {![string equal $cod_cinc ""]} {
	    if {[db_0or1row sel_date_cinc ""] == 0} {
		set data_inizio ""
		set data_fine ""
	    }
	} else {
	    # Il valore per la campagna di verifica non puo essere null
	    element::set_error $form_name cod_cinc "Inserire un valore per la campagna di ispezione"
	    set data_inizio ""
	    set data_fine ""
	    incr error_num
	}

	set data_verifica_iniz_ok "f"
	if {![string equal $data_verifica_iniz ""]} {
	    set data_verifica_iniz [iter_check_date $data_verifica_iniz]
	    if {$data_verifica_iniz == 0} {
		element::set_error $form_name data_verifica_iniz "Data non corretta"
		incr error_num
	    } else {
		set data_verifica_iniz_ok "t"
		if {![string equal cod_cinc ""]
		&&  $data_verifica_iniz < $data_inizio
		} {
		    element::set_error $form_name data_verifica_iniz "La data inserita non &egrave; compresa all'interno della campagna"
		    incr error_num
		}
	    }
	} 

	if {![string equal $data_verifica_fine ""]} {
	    set data_verifica_fine [iter_check_date $data_verifica_fine]
	    if {$data_verifica_fine == 0} {
		element::set_error $form_name data_verifica_fine "Data non corretta"
		incr error_num
	    } else {
		if {$data_verifica_iniz_ok == "t"
		&&  $data_verifica_fine < $data_verifica_iniz
		} {
		    element::set_error $form_name data_verifica_fine "Deve verifica di fine deve essere maggiore della data verifica di inizio"
		    incr error_num
		} else {
		    if {![string equal cod_cinc ""]
		    &&  $data_verifica_fine > $data_fine
		    } {
			element::set_error $form_name data_verifica_fine "La data inserita non &egrave; compresa all'interno della campagna"
		    incr error_num
		    }
		}
	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {$funzione == "I"} {
	# set cod_batc
	db_1row sel_batc_next ""
	set flg_stat     "A"
	set cod_uten_sch $id_utente
	set nom_prog     "iter_stat_veri"
	set par          ""
	lappend par       cod_cinc
	lappend par      $cod_cinc
	lappend par       data_verifica_iniz
	lappend par      $data_verifica_iniz
	lappend par       data_verifica_fine
	lappend par      $data_verifica_fine
	set note          ""

	set dml_sql      [db_map ins_batc]
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimbatc $dml_sql
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }

    set link_gest [export_url_vars cod_batc nome_funz nome_funz_caller caller]

    switch $funzione {
        I {set return_url   "coimstat-veri-gest?funzione=V&$link_gest"}
        V {set return_url   ""}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
