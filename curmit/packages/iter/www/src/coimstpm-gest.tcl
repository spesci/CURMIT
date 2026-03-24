ad_page_contract {
    Add/Edit/Delete         form per la tabella "coimstpm"
    @author                 Tania Masullo Adhoc
    @creation-date          16/08/2005

    @param funzione         I=insert E=edit D=delete V=view
    @param caller           caller della lista da restituire alla lista:
                            serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz        identifica l'entrata di menu, server per le autorizzazioni
                            serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                            navigazione con navigation bar
    @param extra_par        Variabili extra da restituire alla lista
    @cvs-id                 coimstpm-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 22/12/2023  aggiunto i campi  margine_alto, margine_basso, margine_sinistro, margine_destro.
} {
   {id_stampa        ""}
   {last_id_stampa   ""}
   {funzione         "V"}
   {caller           "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
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
set link_gest [export_url_vars id_stampa last_id_stampa nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_id_stampa caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Modello Stampa"
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
set form_name    "coimstpm"
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

element create $form_name descrizione \
-label   "Descrizione" \
-widget   text \
-datatype text \
-html    "size 50 maxlength 50 $readonly_fld {} class form_element" \
-optional

element create $form_name testo \
-label   "Testo" \
-widget   textarea \
-datatype text \
-html    "cols 80 rows 12 $readonly_fld {} class form_element_times" \
-optional

element create $form_name campo1_testo \
-label   "Nome variabile 1" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo1 \
-label   "Dicitura variabile 1" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo2_testo \
-label   "Nome variabile 2" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo2 \
-label   "Dicitura variabile 2" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo3_testo \
-label   "Nome variabile 3" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo3 \
-label   "Dicitura variabile 3" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo4_testo \
-label   "Nome variabile 4" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo4 \
-label   "Dicitura variabile 4" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo5_testo \
-label   "Nome variabile 5" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name campo5 \
-label   "Dicitura variabile 5" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 30 $readonly_fld {} class form_element" \
-optional

element create $form_name var_testo \
-label   "Testo" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{No N} {Si S}}

element create $form_name allegato \
-label   "Allegato" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{"Solo se protocollata" N} {"Sempre" S}}

element create $form_name tipo_foglio \
-label   "Tipo foglio" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{A4 4} {A3 3}}

element create $form_name orientamento \
-label   "Orientamento carta" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{Verticale P} {Orizzontale L}}

element create $form_name tipo_documento \
-label   "tipo_documento" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimtdoc tipo_documento descrizione]

element create $form_name margine_alto \
    -label   "Margine alto" \
    -widget   text \
    -datatype text \
    -html    "size 13 maxlength 13 $readonly_fld {} class form_element" \
    -optional

element create $form_name margine_basso \
    -label   "Margine basso" \
    -widget   text \
    -datatype text \
    -html    "size 13 maxlength 13 $readonly_fld {} class form_element" \
    -optional

element create $form_name margine_destro \
    -label   "Margine destro" \
    -widget   text \
    -datatype text \
    -html    "size 13 maxlength 13 $readonly_fld {} class form_element" \
    -optional

element create $form_name margine_sinistro \
    -label   "Margine sinistro" \
    -widget   text \
    -datatype text \
    -html    "size 13 maxlength 13 $readonly_fld {} class form_element" \
    -optional

element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name last_id_stampa   -widget hidden -datatype text -optional
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {$funzione != "I"} {
    element create $form_name id_stampa    -widget hidden -datatype text -optional
}


if {[form is_request $form_name]} {
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name last_id_stampa   -value $last_id_stampa
    if {$funzione == "I"} {
        
    } else {
	if {[db_0or1row sel_stpm {}] == 0} {
            iter_return_complaint "Record non trovato"
	}
	element set_properties $form_name id_stampa         -value $id_stampa
        element set_properties $form_name descrizione       -value $descrizione
        element set_properties $form_name testo             -value $testo
        element set_properties $form_name campo1            -value $campo1
        element set_properties $form_name campo1_testo      -value $campo1_testo
        element set_properties $form_name campo2            -value $campo2
        element set_properties $form_name campo2_testo      -value $campo2_testo
        element set_properties $form_name campo3            -value $campo3
        element set_properties $form_name campo3_testo      -value $campo3_testo
        element set_properties $form_name campo4            -value $campo4
        element set_properties $form_name campo4_testo      -value $campo4_testo
        element set_properties $form_name campo5            -value $campo5
        element set_properties $form_name campo5_testo      -value $campo5_testo
        element set_properties $form_name var_testo         -value $var_testo
        element set_properties $form_name allegato          -value $allegato
        element set_properties $form_name tipo_foglio       -value $tipo_foglio
        element set_properties $form_name orientamento      -value $orientamento
        element set_properties $form_name tipo_documento    -value $tipo_documento
        element set_properties $form_name margine_alto      -value $margine_alto;#but01
	element set_properties $form_name margine_basso     -value $margine_basso;#but01
	element set_properties $form_name margine_destro    -value $margine_destro;#but01
	element set_properties $form_name margine_sinistro  -value $margine_sinistro;#but01
       
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system
    set descrizione       [element::get_value $form_name descrizione]
    set testo             [element::get_value $form_name testo]
    set campo1            [element::get_value $form_name campo1]
    set campo1_testo      [element::get_value $form_name campo1_testo]
    set campo2            [element::get_value $form_name campo2]
    set campo2_testo      [element::get_value $form_name campo2_testo]
    set campo3            [element::get_value $form_name campo3]
    set campo3_testo      [element::get_value $form_name campo3_testo]
    set campo4            [element::get_value $form_name campo4]
    set campo4_testo      [element::get_value $form_name campo4_testo]
    set campo5            [element::get_value $form_name campo5]
    set campo5_testo      [element::get_value $form_name campo5_testo]
    set var_testo         [element::get_value $form_name var_testo]
    set allegato          [element::get_value $form_name allegato]
    set tipo_foglio       [element::get_value $form_name tipo_foglio]
    set orientamento      [element::get_value $form_name orientamento]
    set tipo_documento    [element::get_value $form_name tipo_documento]

    set margine_alto      [element::get_value $form_name margine_alto];#but01
    set margine_basso     [element::get_value $form_name margine_basso];#but01
    set margine_destro    [element::get_value $form_name margine_destro];#but01
    set margine_sinistro  [element::get_value $form_name margine_sinistro];#but01
    if {$funzione != "I"} {
	set id_stampa     [element::get_value $form_name id_stampa]
    }

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if  { $funzione == "I"
	  ||$funzione == "M"} {

	if {![string equal $margine_alto ""]} {;#but01 aggiunto if e suo contenuto
	    set margine_alto [iter_check_num $margine_alto 2]
	    if {$margine_alto eq "Error"} {
		element::set_error $form_name margine_alto "Deve essere numerico, max 2 dec"
		incr error_num
	    }
	}

	if {![string equal $margine_basso ""]} {;#but01 aggiunto if e suo contenuto
	    set margine_basso [iter_check_num $margine_basso 2]
	    if {$margine_basso eq "Error"} {
		element::set_error $form_name margine_basso "Deve essere numerico, max 2 dec"
		incr error_num
	    }
	}

	if {![string equal $margine_destro ""]} {;#but01 aggiunto if e suo contenuto
	    set margine_destro [iter_check_num $margine_destro 2]
	    if {$margine_destro eq "Error"} {
		element::set_error $form_name margine_destro "Deve essere numerico, max 2 dec"
		incr error_num
	    }
	}

	if {![string equal $margine_sinistro ""]} {;#but01 aggiunto if e suo contenuto
	    set margine_sinistro [iter_check_num $margine_sinistro 2]
	    if {$margine_sinistro eq "Error"} {
		element::set_error $form_name margine_sinistro "Deve essere numerico, max 2 dec"
		incr error_num
	    }
	}
	
	if {[string equal $descrizione ""]} {
            element::set_error $form_name descrizione "Inserire Descrizione Stampa"
            incr error_num
        } 
        if {[string equal $tipo_documento ""]} {
            element::set_error $form_name tipo_documento "Inserire il tipo documento"
            incr error_num
        } 
    }

    if {$funzione == "I"
    &&  $error_num == 0
	&&  [db_0or1row check_exists {}] == 1} {
      # controllo univocita'/protezione da double_click
        element::set_error $form_name descrizione "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {set id_stampa [db_string sel_stpm_s ""]
           set dml_sql   [db_map ins_stpm]}
        M {set dml_sql   [db_map upd_stpm]}
        D {set dml_sql   [db_map del_stpm]}
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimstpm $dml_sql
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
        set last_id_stampa $id_stampa
    }
    
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars id_stampa last_id_stampa nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimstpm-gest?funzione=V&$link_gest"}
        D {set return_url   "coimstpm-list?$link_list"}
        I {set return_url   "coimstpm-gest?funzione=V&$link_gest"}
        V {set return_url   "coimstpm-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
