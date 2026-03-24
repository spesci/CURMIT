ad_page_contract {
    Add              form per la tabella "coimbatc"
                     Lancio batch di caricamento impianti da file esterno
    @author          Nicola Mortoni
    @creation-date   15/07/2004

    @param funzione  I=insert V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @cvs-id          coimbatc-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 20/06/2023 Aggiunto la classe ah-jquery-date al campo dat_prev.

} {
    {cod_batc         ""}
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    file_name:trim,optional
    file_name.tmpfile:tmpfile,optional
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
set nom       "Caricamento modelli G"
set link_head [iter_links_batc $nome_funz $nome_funz_caller $nom]

# reperisco le colonne della tabella parametri (serve una variabile nell'adp)
iter_get_coimtgen

# Personalizzo la pagina
set titolo              "Caricamento modelli G"
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
        set onsubmit_cmd "enctype {multipart/form-data}"
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
#but01 Aggiunto la classe ah-jquery-date al campo dat_prev
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


if {$funzione == "I"} {
    element create $form_name file_name \
    -label   "File da importare" \
    -widget   file \
    -datatype text \
    -html    "size 40 class form_element" \
    -optional
} else {
    element create $form_name file_name \
    -label   "File da importare" \
    -widget   text \
    -datatype text \
    -html    "size 40 readonly {} class form_element" \
    -optional
}

element create $form_name funzione     -widget hidden -datatype text -optional
element create $form_name caller       -widget hidden -datatype text -optional
element create $form_name nome_funz    -widget hidden -datatype text -optional
element create $form_name submit       -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name current_date -widget hidden -datatype text -optional
element create $form_name current_time -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione       -value $funzione
    element set_properties $form_name caller         -value $caller
    element set_properties $form_name nome_funz      -value $nome_funz

    if {$funzione == "I"} {
	set current_date [iter_set_sysdate]
	set current_time [iter_set_systime]
	set dat_prev     [iter_edit_date $current_date]
	set ora_prev     $current_time

        element set_properties $form_name dat_prev      -value $dat_prev
        element set_properties $form_name ora_prev      -value $ora_prev
	element set_properties $form_name current_date  -value $current_date
	element set_properties $form_name current_time  -value $current_time

   } else {
      # leggo riga
        if {[db_0or1row sel_batc {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name dat_prev      -value $dat_prev
        element set_properties $form_name ora_prev      -value $ora_prev

	foreach {key value} $par {
	    set $key $value
	}

	# visualizzo solo il nome del file senza le directory
	set file_name         [file tail $file_name]

        element set_properties $form_name file_name     -value $file_name

    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set current_date       [element::get_value $form_name current_date]
    set current_time       [element::get_value $form_name current_time]
    set dat_prev           [element::get_value $form_name dat_prev]
    set ora_prev           [element::get_value $form_name ora_prev]
    set file_name          [element::get_value $form_name file_name]

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


	if {[string equal $file_name ""]} {
	    element::set_error $form_name file_name "Inserire Nome File"
	    incr error_num
	} else {
	    set extension [file extension $file_name]
	    if {$extension != ".csv"} {
		if {$extension != ".txt"} {
		    element::set_error $form_name file_name "Il file non ha estensione csv o txt"
		    incr error_num
		}
	    } else {
		set tmpfile ${file_name.tmpfile}
		if {![file exists $tmpfile]} {
		    element::set_error $form_name file_name "File non trovato"
		    incr error_num
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
	set flg_stat       "A"
	set cod_uten_sch   $id_utente
	set nom_prog       "iter_cari_modelli"

	set par            ""
	lappend par         id_utente
	lappend par        $id_utente

	set permanenti_dir [iter_set_permanenti_dir]
	set file_name_orig $file_name
	set file_name      [string range $file_name [string last \\ $file_name] end]
	set file_name      [string trimleft $file_name \\]
	set file_name      "${permanenti_dir}/$file_name"
	# salvo il file temporaneo in modo permanente
	#exec mv ${file_name.tmpfile} $file_name
	file rename -force ${file_name.tmpfile} $file_name

	lappend par         file_name
	lappend par        $file_name

	set note           ""

	set dml_sql        [db_map ins_batc]
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
        I {set return_url   "coimcari-modelli-g-gest?funzione=V&$link_gest"}
        V {set return_url   ""}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
