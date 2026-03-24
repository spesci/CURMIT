ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimmovi"
    @author          Paolo Formizzi Adhoc
    @creation-date   07/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimmovi-gest.tcl

    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
    rom01  10/07/2024 Modifiche per Caserta.
    
    but01  21/06/2023 Aggiunto la classe ah-jquery-date ai campi:ata_scad,data_pag, data_incasso,data_compet 

    san01  30/08/2017 Gestito il nuovo campo data_incasso

} {
    {cod_movi         ""}
    {last_cod_movi    ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {cod_impianto     ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
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
set link_gest [export_url_vars cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen;#rom01

#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

db_1row sel_date ""

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_movi caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Pagamento"
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

#if {$caller == "index"} {
set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar  [iter_context_bar \
    #                     [list "javascript:window.close()" "Torna alla Gestione"] \
    #                     [list coimmovi-list?$link_list "Lista Pagamenti"] \
    #                     "$page_title"]
#}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimmovi"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_fld_canc "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set readonly_fld_canc \{\}
    }
    "M" {set readonly_fld \{\}
        set disabled_fld \{\}
	set readonly_fld_canc \{\}
    }
    "D" {set readonly_fld_canc \{\}
    }
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name cod_movi \
    -label   "Codice" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional


if {$coimtgen(ente) eq "PCE"} {#rom01 Aggiunta if e contenuto

    set l_of_l_caus [db_list_of_lists query "select descrizione, id_caus from coimcaus where id_caus != 2 order by descrizione"]
    set l_of_l_caus [linsert $l_of_l_caus 0 [list "Pagamento onere visita di controllo" "2"]]

} else {#rom01 Aggiunta else ma non il contenuto
    
    set l_of_l_caus [db_list_of_lists query "select descrizione, id_caus from coimcaus order by descrizione"]
    set l_of_l_caus [linsert $l_of_l_caus 0 [list "" ""]]
};#rom01

element create $form_name id_caus \
    -label   "Causale pagamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $l_of_l_caus
#but01 Aggiunto la classe ah-jquery-date al campo data_scad
element create $form_name data_scad \
    -label   "Data scadenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name importo \
    -label   "Importo" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name importo_pag \
    -label   "Importo pagato" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_pag, data_incasso,data_compet
element create $form_name data_pag \
    -label   "Data pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld_canc {} class form_element $jq_date" \
    -optional

#san01 aggiunto data_incasso
element create $form_name data_incasso \
    -label   "Data Incasso" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

set l_of_l [db_list_of_lists sel_lol "select descrizione, cod_tipo_pag from coimtp_pag order by ordinamento"]
set options_cod_tp_pag [linsert $l_of_l 0 [list "" ""]]

element create $form_name tipo_pag \
    -label   "Tipo pagamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options $options_cod_tp_pag

element create $form_name nota \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_compet \
    -label   "Data competenza" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional 

set options_flag_pagato {{{} {}} {S&igrave; S} {No N}}

if {$coimtgen(ente) eq "PCE"} {#rom01 Aggiunta if e il suo contenuto
    set options_flag_pagato {{{} {}} {S&igrave; S} {No N} {Rimborsato R}}
}

element create $form_name flag_pagato \
    -label   "flag_pagato" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options $options_flag_pagato

 element create $form_name riferimento \
    -label   "riferimento" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 $disabled_fld {} class form_element" \
    -optional 
   

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name url_list_aimp    -widget hidden -datatype text -optional
element create $form_name url_aimp         -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_movi    -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name cod_impianto     -value $cod_impianto
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name url_aimp         -value $url_aimp
    element set_properties $form_name last_cod_movi    -value $last_cod_movi

    if {$funzione == "I"} {
        db_1row sel_current_date ""
	element set_properties $form_name data_compet  -value $current_date
    } else {
	# leggo riga
        if {[db_0or1row sel_movi {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_movi     -value $cod_movi
        element set_properties $form_name id_caus      -value $id_caus
        element set_properties $form_name cod_impianto -value $cod_impianto
        element set_properties $form_name data_scad    -value $data_scad
        element set_properties $form_name importo      -value $importo
        element set_properties $form_name importo_pag  -value $importo_pag
        element set_properties $form_name data_pag     -value $data_pag
        element set_properties $form_name tipo_pag     -value $tipo_pag
        element set_properties $form_name nota         -value $nota
        element set_properties $form_name data_compet  -value $data_compet
        element set_properties $form_name flag_pagato  -value $flag_pagato
        element set_properties $form_name riferimento  -value $riferimento
        element set_properties $form_name data_incasso -value $data_incasso;#san01
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_movi     [element::get_value $form_name cod_movi]
    set id_caus      [element::get_value $form_name id_caus]
    set data_scad    [element::get_value $form_name data_scad]
    set importo      [element::get_value $form_name importo]
    set importo_pag  [element::get_value $form_name importo_pag]
    set data_pag     [element::get_value $form_name data_pag]
    set tipo_pag     [element::get_value $form_name tipo_pag]
    set nota         [element::get_value $form_name nota]
    set data_compet  [element::get_value $form_name data_compet]
    set flag_pagato  [element::get_value $form_name flag_pagato]
    set riferimento  [element::get_value $form_name riferimento]
    set data_incasso [element::get_value $form_name data_incasso];#san01

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I" || $funzione == "M"} {

        if {[string equal $id_caus ""]} {
            element::set_error $form_name id_caus "Inserire Causale"
            incr error_num
	    set flag_scad "N"
        }



	set flag_scad "S"
        if {[string equal $data_scad ""]} {
            element::set_error $form_name data_scad "Inserire Data scadenza"
            incr error_num
	    set flag_scad "N"
        } else {
            set data_scad [iter_check_date $data_scad]
            if {$data_scad == 0} {
                element::set_error $form_name data_scad "Data non corretta"
                incr error_num
		set flag_scad "N"
            }
        }

	set flag_imp "S"
        if {[string equal $importo ""]} {
	    element::set_error $form_name importo "Inserire importo"
	    incr error_num
	    set flag_imp "N"
	} else {
            set importo [iter_check_num $importo 2]
            if {$importo == "Error"} {
                element::set_error $form_name importo "Deve essere numerico, max 2 dec"
                incr error_num
		set flag_imp "N"
            } else {
                if {[iter_set_double $importo] >=  [expr pow(10,13)]
		    ||  [iter_set_double $importo] <= -[expr pow(10,13)]} {
                    element::set_error $form_name importo "Deve essere inferiore di 10.000.000.000.000"
                    incr error_num
		    set flag_imp "N"
                }
            }
        }

        if {![string equal $importo_pag ""]} {
            set importo_pag [iter_check_num $importo_pag 2]
            if {$importo_pag == "Error"} {
                element::set_error $form_name importo_pag "Deve essere numerico, max 2 dec"
                incr error_num
            } else {
                if {[iter_set_double $importo_pag] >=  [expr pow(10,13)]
		    ||  [iter_set_double $importo_pag] <= -[expr pow(10,13)]} {
                    element::set_error $form_name importo_pag "Deve essere inferiore di 10.000.000.000.000"
                    incr error_num
                } else {
		    if {$flag_imp == "S" && $importo_pag > $importo} {
			# element::set_error $form_name importo_pag "Non deve essere maggiore di importo"
			# incr error_num
		    }
		}
            }
        }

        if {![string equal $data_pag ""]} {
            set data_pag [iter_check_date $data_pag]
            if {$data_pag == 0} {
                element::set_error $form_name data_pag "Data non corretta"
                incr error_num
            } else {
		if {$flag_scad == "S" && $data_pag > $data_scad} {
		    # element::set_error $form_name data_pag "Non deve essere maggiore di data scad"
		    # incr error_num
		}
	    }
        }

	if {![string equal $data_incasso ""]} {#san01 if e suo contenuto
            set data_incasso [iter_check_date $data_incasso]
            if {$data_incasso == 0} {
                element::set_error $form_name data_incasso "Data non corretta"
                incr error_num
	    }
	}

        if {![string equal $data_compet ""]} {
            set data_compet [iter_check_date $data_compet]
            if {$data_compet == 0} {
                element::set_error $form_name data_compet "Data non corretta"
                incr error_num
            } 
        }
    }

    if {$funzione == "I" &&  $error_num == 0 &&  [db_0or1row sel_movi_check {}] == 1} {
	# controllo univocita'/protezione da double_click
        element::set_error $form_name cod_movi "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$funzione == "D" && ![string equal $data_pag ""]} {
        element::set_error $form_name data_pag "Il pagamento che stai tentando di cancellare &egrave; gi&agrave; stato effettuato.
                                                Per eliminarlo sbiancare la data pagamento."
        incr error_num
    }



    if {![db_0or1row query "select codice as tipo_movi from coimcaus where id_caus = :id_caus"]} {
	set tipo_movi ""
    }

#controllo 

  set num_rif 0

  if {![string equal $riferimento ""]} {
     if {$tipo_movi == "VC"} {
     if {[db_0or1row query "select count(*) as num_rif from  coimcimp  where cod_impianto = :cod_impianto"]} {
        if {$num_rif == 0} {
	   element::set_error $form_name riferimento  "Riferimento pagamento inesistente per l'impianto specificato "
                incr error_num
       }
     }
   }
}
# fine controllo

    if {$error_num > 0} {
        ad_return_template
        return
    }
   
    switch $funzione {
        I {db_1row sel_movi_next ""
	    set dml_sql [db_map ins_movi]}
        M {set dml_sql [db_map upd_movi]}
        D {set dml_sql [db_map del_movi]}
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimmovi $dml_sql
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
        set last_cod_movi $cod_movi
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_movi cod_impianto url_aimp url_list_aimp last_cod_movi nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimmovi-gest?funzione=V&$link_gest"}
        D {set return_url   "coimmovi-list?$link_list"}
        I {set return_url   "coimmovi-gest?funzione=V&$link_gest"}
        V {set return_url   "coimmovi-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
