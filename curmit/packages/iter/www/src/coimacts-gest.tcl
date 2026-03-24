ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimacts"
    @author          Katia Coazzoli Adhoc
    @creation-date   07/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimacts-gest.tcl
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 25/07/2023 Aggiunto la classe ah-jquery-date al campo "Data caricamento".

} {
    
   {cod_acts         ""}
   {last_cod_acts    ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
# Se il programma e' 'delicato', mettere livello 5 (amministratore).

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

set link_gest [export_url_vars cod_acts last_cod_acts nome_funz nome_funz_caller extra_par caller]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}


# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_acts caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Dichiarazione fornitore di energia"
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
#                     [list coimacts-list?$link_list "Lista Testate impianti potenziali"] \
#                     "$page_title"]
#}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimacts"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_key "disabled"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
   "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_key \{\}
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

element create $form_name cod_acts \
-label   "Codice" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_key {} class form_element" \
-optional

element create $form_name cod_distr \
-label   "Distributore" \
-widget   select \
-datatype text \
-html    "$disabled_key {} class form_element" \
-options  [iter_selbox_from_table coimdist cod_distr ragione_01] \
-optional

element create $form_name data_caric \
-label   "Data caricamento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
-optional

element create $form_name cod_documento \
-label   "Documento" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_key {} class form_element" \
-optional

element create $form_name caricati \
-label   "Caricati" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name scartati \
-label   "Scartati" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name totale \
-label   "Totale" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name invariati \
-label   "Invariati" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name da_analizzare \
-label   "Da analizzare" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name importati_aimp \
-label   "Importati aimp" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name chiusi_forzat \
-label   "Chiusura forzata" \
-widget   text \
-datatype text \
-html    "size 7 maxlength 7 $readonly_key {} class form_element" \
-optional

element create $form_name stato \
-label   "Stato" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{Interrotto I} {Annullato A} {Chiuso C} {{In lavorazione} E}}

element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 4 $readonly_fld {} class form_element" \
-optional

element create $form_name percorso_file \
-label   "Percorso file" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 46 $readonly_key {} class form_element" \
-optional


element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_acts -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_cod_acts -value $last_cod_acts

    if {$funzione == "I"} {
        
    } else {
      # leggo riga
        if {[db_0or1row sel_acts {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_acts       -value $cod_acts
        element set_properties $form_name cod_distr      -value $cod_distr
        element set_properties $form_name data_caric     -value $data_caric
        element set_properties $form_name cod_documento  -value $cod_documento
        element set_properties $form_name caricati       -value $caricati
        element set_properties $form_name scartati       -value $scartati
        element set_properties $form_name invariati      -value $invariati
        element set_properties $form_name da_analizzare  -value $da_analizzare
        element set_properties $form_name importati_aimp -value $importati_aimp
        element set_properties $form_name chiusi_forzat  -value $chiusi_forzat
        element set_properties $form_name stato          -value $stato
        element set_properties $form_name percorso_file  -value $percorso_file
        element set_properties $form_name note           -value $note
        element set_properties $form_name totale         -value $tot


	set link_docu [export_url_vars cod_acts last_cod_acts cod_documento nome_funz_caller extra_par caller]&nome_funz=docu
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_acts       [element::get_value $form_name cod_acts]
    set cod_distr      [element::get_value $form_name cod_distr]
    set data_caric     [element::get_value $form_name data_caric]
    set cod_documento  [element::get_value $form_name cod_documento]
    set caricati       [element::get_value $form_name caricati]
    set scartati       [element::get_value $form_name scartati]
    set invariati      [element::get_value $form_name invariati]
    set da_analizzare  [element::get_value $form_name da_analizzare]
    set importati_aimp [element::get_value $form_name importati_aimp]
    set chiusi_forzat  [element::get_value $form_name chiusi_forzat]
    set stato          [element::get_value $form_name stato]
    set percorso_file  [element::get_value $form_name percorso_file]
    set note           [element::get_value $form_name note]
    set totale         [element::get_value $form_name totale]

    set link_docu [export_url_vars cod_acts last_cod_acts cod_documento nome_funz_caller extra_par caller]&nome_funz=docu

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

        if {[string equal $cod_acts ""]} {
            element::set_error $form_name cod_acts "Inserire Codice"
            incr error_num
        }

        if {![string equal $data_caric ""]} {
            set data_caric [iter_check_date $data_caric]
            if {$data_caric == 0} {
                element::set_error $form_name data_caric "Data caricamento deve essere una data"
                incr error_num
            }
        }

        if {![string equal $caricati ""]} {
            set caricati [iter_check_num $caricati 0]
            if {$caricati == "Error"} {
                element::set_error $form_name caricati "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $caricati] >=  [expr pow(10,6)]
                ||  [iter_set_double $caricati] <= -[expr pow(10,6)]} {
                    element::set_error $form_name caricati "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $scartati ""]} {
            set scartati [iter_check_num $scartati 0]
            if {$scartati == "Error"} {
                element::set_error $form_name scartati "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $scartati] >=  [expr pow(10,6)]
                ||  [iter_set_double $scartati] <= -[expr pow(10,6)]} {
                    element::set_error $form_name scartati "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $invariati ""]} {
            set invariati [iter_check_num $invariati 0]
            if {$invariati == "Error"} {
                element::set_error $form_name invariati "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $invariati] >=  [expr pow(10,6)]
                ||  [iter_set_double $invariati] <= -[expr pow(10,6)]} {
                    element::set_error $form_name invariati "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $da_analizzare ""]} {
            set da_analizzare [iter_check_num $da_analizzare 0]
            if {$da_analizzare == "Error"} {
                element::set_error $form_name da_analizzare "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $da_analizzare] >=  [expr pow(10,6)]
                ||  [iter_set_double $da_analizzare] <= -[expr pow(10,6)]} {
                    element::set_error $form_name da_analizzare "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $importati_aimp ""]} {
            set importati_aimp [iter_check_num $importati_aimp 0]
            if {$importati_aimp == "Error"} {
                element::set_error $form_name importati_aimp "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $importati_aimp] >=  [expr pow(10,6)]
                ||  [iter_set_double $importati_aimp] <= -[expr pow(10,6)]} {
                    element::set_error $form_name importati_aimp "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }

        if {![string equal $chiusi_forzat ""]} {
            set chiusi_forzat [iter_check_num $chiusi_forzat 0]
            if {$chiusi_forzat == "Error"} {
                element::set_error $form_name chiusi_forzat "deve essere un numero intero"
                incr error_num
            } else {
                if {[iter_set_double $chiusi_forzat] >=  [expr pow(10,6)]
                ||  [iter_set_double $chiusi_forzat] <= -[expr pow(10,6)]} {
                    element::set_error $form_name chiusi_forzat "deve essere inferiore di 1.000.000"
                    incr error_num
                }
            }
        }
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        M {set dml_sql  [db_map upd_acts]}
        D {set dml_sql  [db_map del_acts]
	   set dml_docu [db_map del_docu]
	   set dml_aces [db_map del_aces]}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimacts $dml_sql
                if {$funzione == "D"
		&&  [info exists dml_docu]
		&&  [info exists dml_aces]} {
                    db_dml dml_coimacts $dml_docu
                    db_dml dml_coimacts $dml_aces
		}
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }


    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_acts last_cod_acts nome_funz nome_funz_caller extra_par caller]

    switch $funzione {
        M {set return_url   "coimacts-gest?funzione=V&$link_gest"}
        D {set return_url   "coimacts-list?$link_list"}
        V {set return_url   "coimacts-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
