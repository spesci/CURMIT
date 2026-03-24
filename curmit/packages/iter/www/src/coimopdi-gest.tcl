ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimopdi"
    @author          Giulio Laurenzi
    @creation-date   23/09/2005

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimopdi-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==================================================================================
    rom01 20/11/2023 Modificato controllo che impedisce di creare disponibilita' con orari sovrapposti.

} {
    
   {cod_opve         ""}
   {prog_disp        ""}
   {last_prog_disp   ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
   {cod_enve         ""}
   {url_enve         ""}
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
set link_gest [export_url_vars cod_opve prog_disp last_prog_disp nome_funz nome_funz_caller extra_par caller cod_enve url_enve]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {[db_0or1row sel_opve_nome ""]== 0} {
    set nome_enve ""
    set nome_opve ""
}

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_opve last_prog_disp caller nome_funz_caller cod_enve url_enve nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set titolo           "disponibilit&agrave; giornaliera"
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
set form_name    "coimopdi"
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

form create $form_name \
-html    $onsubmit_cmd


element create $form_name ora_da \
-label   "Da ora" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional

element create $form_name ora_a \
-label   "A ora" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional


element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_prog_disp -widget hidden -datatype text -optional
element create $form_name cod_opve  -widget hidden -datatype text -optional
element create $form_name prog_disp -widget hidden -datatype text -optional
element create $form_name cod_enve  -widget hidden -datatype text -optional
element create $form_name url_enve  -widget hidden -datatype text -optional
if {[form is_request $form_name]} {

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name last_prog_disp        -value $last_prog_disp
    element set_properties $form_name cod_enve         -value $cod_enve
    element set_properties $form_name url_enve         -value $url_enve

    if {$funzione == "I"} {
        element set_properties $form_name cod_opve  -value $cod_opve
    } else {
      # leggo riga
        if {[db_0or1row sel_opdi {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_opve  -value $cod_opve
        element set_properties $form_name prog_disp -value $prog_disp
        element set_properties $form_name ora_da    -value $ora_da
        element set_properties $form_name ora_a     -value $ora_a

    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_opve  [element::get_value $form_name cod_opve]
    set prog_disp [element::get_value $form_name prog_disp]
    set ora_da    [element::get_value $form_name ora_da]
    set ora_a     [element::get_value $form_name ora_a]


  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	set flag_check_ora_da "f"
	if {![string equal $ora_da ""]} {
	    set ora_da [iter_check_time $ora_da]
	    if {$ora_da == 0} {
		element::set_error $form_name ora_da "Ora non corretta, deve essere hh:mm"
		incr error_num
	    } else {
		set flag_check_ora_da "t"
	    }
	}

	set flag_check_ora_a "f"
	if {![string equal $ora_a ""]} {
	    set ora_a [iter_check_time $ora_a]
	    if {$ora_a == 0} {
		element::set_error $form_name ora_a "Ora non corretta, deve essere hh:mm"
		incr error_num
	    } else {
		set flag_check_ora_a "t"
	    }
	}	

	if {$flag_check_ora_da == "t"
        &&  $flag_check_ora_a  == "t"
	} {
	    if {$funzione == "M"} {
		set where_condition "and prog_disp <> :prog_disp "
	    } else {
		set where_condition ""
	    }

	    set sovrapposizioni 0
	    db_foreach sel_opdi_ore "" {
		if {  (   $ora_da > $ora_da_db
                       && $ora_da < $ora_a_db)
                    ||(   $ora_a  > $ora_da_db
                       && $ora_a  <= $ora_a_db)
		} {
		    incr sovrapposizioni
		}
	    }
	    #rom01 Modificato controllo da $sovrapposizioni > 100 a $sovrapposizioni >= 1
	    if {$sovrapposizioni >= 1} {
		element::set_error $form_name ora_da "L'orario inserito &egrave; sovrapposto ad altri orari gi&agrave; inseriti"
		incr error_num
	    }
	}

    }

    if {$funzione == "I"
    &&  $error_num == 0
    &&  [db_0or1row sel_opdi_check {}] == 1
    } {
      # controllo univocita'/protezione da double_click
        element::set_error $form_name prog_disp "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {db_1row sel_opdi_prog_disp ""
           set dml_sql [db_map ins_opdi]}
        M {set dml_sql [db_map upd_opdi]}
        D {set dml_sql [db_map del_opdi]}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimopdi $dml_sql
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
        set last_prog_disp $prog_disp
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_opve prog_disp last_prog_disp nome_funz nome_funz_caller extra_par caller cod_enve url_enve]
    switch $funzione {
        M {set return_url   "coimopdi-gest?funzione=V&$link_gest"}
        D {set return_url   "coimopdi-list?$link_list"}
        I {set return_url   "coimopdi-gest?funzione=V&$link_gest"}
        V {set return_url   "coimopdi-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}


ad_return_template
