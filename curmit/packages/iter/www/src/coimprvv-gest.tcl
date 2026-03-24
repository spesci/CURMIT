ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimprvv"
    @author          Adhoc
    @creation-date   07/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimprvv-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_provv, data_scad.
} {
    {cod_prvv         ""}
    {last_cod_prvv    ""}
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
set link_gest [export_url_vars cod_prvv cod_impianto url_aimp url_list_aimp last_cod_prvv nome_funz nome_funz_caller extra_par caller]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

#proc per la navigazione 
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

set current_date      [iter_set_sysdate]
db_1row sel_date ""

# Personalizzo la pagina
set link_list_script {[export_url_vars cod_impianto url_aimp url_list_aimp last_cod_prvv caller nome_funz_caller nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Provvedimento"
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
    #                     [list coimprvv-list?$link_list "Lista Provvedimento"] \
    #                     "$page_title"]
#}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimprvv"
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

element create $form_name cod_prvv \
    -label   "Codice" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 readonly {} class form_element" \
    -optional

element create $form_name causale \
    -label   "Causale" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {"Mancato pagamento" MC} {"Sanzione per inadempienze sull'impianto" SN} {"Generico" GE} {"Sollecito Messa a Norma dal Comune" CE}}

#but01 Aggiunto la classe ah-jquery-date ai campi:data_provv, data_scad.
element create $form_name data_provv \
    -label   "Data provvedimento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name cod_documento \
    -label   "Documento" \
    -widget   text \
    -datatype text \
    -html    "size 8 maxlength 8 readonly {} class form_element" \
    -optional

element create $form_name nota \
    -label   "Nota" \
    -widget   textarea \
    -datatype text \
    -html    "cols 50 rows 4 $readonly_fld {} class form_element" \
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

element create $form_name importo \
    -label   "Data provvedimento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_scad \
    -label   "Data limite pagamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_prvv -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name cod_impianto  -value $cod_impianto
    element set_properties $form_name url_list_aimp -value $url_list_aimp
    element set_properties $form_name url_aimp      -value $url_aimp
    element set_properties $form_name last_cod_prvv -value $last_cod_prvv

    if {$funzione == "I"} {
	element set_properties $form_name importo       -value 0        
    } else {
	# leggo riga
        if {[db_0or1row sel_prvv {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_prvv      -value $cod_prvv
        element set_properties $form_name causale       -value $causale
        element set_properties $form_name cod_impianto  -value $cod_impianto
        element set_properties $form_name data_provv    -value $data_provv
        element set_properties $form_name cod_documento -value $cod_documento
        element set_properties $form_name nota          -value $nota
        
	set flag_movi "F"
        set link_movi ""
        if {[db_0or1row get_cod_movi ""] != 0} {
	    set flag_movi "T"
	    set link_movi "[export_url_vars cod_movi cod_impianto url_aimp url_list_aimp nome_funz_caller caller]&nome_funz=[iter_get_nomefunz coimmovi-gest]"
	} 
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set cod_prvv      [element::get_value $form_name cod_prvv]
    set causale       [element::get_value $form_name causale]
    set data_provv    [element::get_value $form_name data_provv]
    set cod_documento [element::get_value $form_name cod_documento]
    set nota          [element::get_value $form_name nota]
    set importo       [element::get_value $form_name importo]
    set tipo_pag      [element::get_value $form_name tipo_pag]
    set data_scad     [element::get_value $form_name data_scad]

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
	||  $funzione == "M"
    } {

        if {[string equal $causale ""]} {
            element::set_error $form_name causale "Inserire Causale"
            incr error_num
        }

        if {[string equal $data_provv ""]} {
            element::set_error $form_name data_provv "Inserire Data provvedimento"
            incr error_num
        } else {
            set data_provv [iter_check_date $data_provv]
            if {$data_provv == 0} {
                element::set_error $form_name data_provv "Data non corretta"
                incr error_num
            } else {
		if {$data_provv > $current_date} {
		    element::set_error $form_name data_provv  "Deve essere inferiore alla data odierna"
		    incr error_num
		}
	    }
        }

	#        if {[string equal $nota ""]} {
	#            element::set_error $form_name nota "Inserire Nota"
	#            incr error_num
	#        }

	if {$funzione == "I"} {
	    
	    if {![string equal $importo ""]
	    } {
		set importo [iter_check_num $importo 2]
		if {$importo == "Error"} {
		    element::set_error $form_name importo "Deve essere numerico, max 2 dec"
		    incr error_num
		} else {
		    if {[iter_set_double $importo] >=  [expr pow(10,6)]
			||  [iter_set_double $importo] <= -[expr pow(10,6)]} {
			element::set_error $form_name importo "Deve essere inferiore di 1.000.000"
			incr error_num
		    }
		}
	    }
	    if {![string equal $data_scad ""]} {
		set data_scad [iter_check_date $data_scad]
		if {$data_scad == 0} {
		    element::set_error $form_name data_scad "Inserire correttamente la data"
		    incr error_num
		}
	    }
	}
    }

    if {$funzione == "I"
	&&  $error_num == 0
	&&  [db_0or1row sel_prvv_check {}] == 1
    } {
	# controllo univocita'/protezione da double_click
        element::set_error $form_name cod_prvv "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    with_catch error_msg {
	db_transaction {

	    switch $funzione {
		I {
		    if {[db_0or1row sel_aimp ""] == 0} {
			set indir ""
			set nome_resp ""
			set nome_prop ""
			set nome_occu ""
		    }
		    db_1row sel_docu_next ""
		    set tipo_documento "SO"
		    set data_documento $data_corrente

		    set stampa ""
		    append stampa "
            <table width=100%>
                  <tr>
                     <td align=center>NOTIFICA DI PROVVEDIMENTO</td>
                  </tr>
                  <tr>
                     <td>&nbsp;</td>
                  </tr>
                  <tr>
                     <td align=center>Comunicazione relativa all'impianto:</td>
                  </tr>
                  <tr>
                     <td align=center>Situato in $indir</td>
                  </tr>
                  <tr>
                     <td align=center>Responsabile $nome_resp</td>
                  </tr>
                  <tr>
                     <td align=center>Di propriet&agrave; di $nome_prop</td>
                  </tr>
                  <tr>
                     <td align=center>Occupante $nome_occu</td>
                  </tr>
                  <tr>
                     <td>&nbsp;</td>
                  </tr>
                  <tr>
                     <td>$nota</td>
                  </tr>
            </table>"

		    # imposto la directory degli spool ed il loro nome.
		    set spool_dir     [iter_set_spool_dir]
		    set spool_dir_url [iter_set_spool_dir_url]
		    set logo_dir      [iter_set_logo_dir]
		    
		    # imposto il nome dei file
		    set nome_file        "stampa notifica di provvedimento"
		    set nome_file        [iter_temp_file_name $nome_file]
		    set file_html        "$spool_dir/$nome_file.html"
		    set file_pdf         "$spool_dir/$nome_file.pdf"
		    set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

		    set file_id   [open $file_html w]
		    fconfigure $file_id -encoding iso8859-1
		    puts $file_id $stampa
		    close $file_id

		    # lo trasformo in PDF
		    iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

		    # Controllo se il Database e' Oracle o Postgres
		    set id_db     [iter_get_parameter database]

		    set sql_contenuto  "lo_import(:file_html)"
		    set tipo_contenuto [ns_guesstype $file_pdf]

		    set contenuto_tmpfile  $file_pdf

		    #	    db_1row sel_docu_next ""
		    #	    set tipo_documento "DI"
		    db_dml dml_sql_docu [db_map ins_docu]

		    if {$id_db == "postgres"} {
			if {[db_0or1row sel_docu_contenuto ""] == 1} {
			    if {![string equal $docu_contenuto_check ""]} {
				db_dml dml_sql2 [db_map upd_docu_2]
			    }
			}
			db_dml dml_sql3 [db_map upd_docu_3]
		    } else {
			db_dml dml_sql2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
		    }

		    ns_unlink $file_html

		    db_1row sel_prvv_next ""

		    set dml_sql [db_map ins_prvv]
		    
		    if {$importo > 0 && ![string equal $tipo_pag ""]} {
			db_1row sel_movi_next ""
			set tipo_movi "PR"
			if {![db_0or1row query "select id_caus from coimcaus where s.codice = 'PR')"]} {
			    set id_caus ""
			}
			set dml_sql_movi [db_map ins_movi]
		    }
		    if {$tipo_pag == "BO"} {
			db_1row sel_date ""
			set data_pag $data_corrente
		    } else {
			set data_pag ""
		    }
		}

		M {
		    set data_documento $data_corrente
		    if {[db_0or1row sel_aimp ""] == 0} {
			set indir ""
			set nome_resp ""
			set nome_prop ""
			set nome_occu ""
		    }

		    set stampa ""
		    append stampa "
            <table width=100%>
                  <tr>
                     <td align=center>NOTIFICA DI PROVVEDIMENTO</td>
                  </tr>
                  <tr>
                     <td>&nbsp;</td>
                  </tr>
                  <tr>
                     <td align=center>Comunicazione relativa all'impianto:</td>
                  </tr>
                  <tr>
                     <td align=center>Situato in $indir</td>
                  </tr>
                  <tr>
                     <td align=center>Responsabile $nome_resp</td>
                  </tr>
                  <tr>
                     <td align=center>Di propriet&agrave; di $nome_prop</td>
                  </tr>
                  <tr>
                     <td align=center>Occupante $nome_occu</td>
                  </tr>
                  <tr>
                     <td>&nbsp;</td>
                  </tr>
                  <tr>
                     <td>$nota</td>
                  </tr>
            </table>"

		    # imposto la directory degli spool ed il loro nome.
		    set spool_dir     [iter_set_spool_dir]
		    set spool_dir_url [iter_set_spool_dir_url]
		    set logo_dir      [iter_set_logo_dir]
		    
		    # imposto il nome dei file
		    set nome_file        "stampa notifica di provvedimento"
		    set nome_file        [iter_temp_file_name $nome_file]
		    set file_html        "$spool_dir/$nome_file.html"
		    set file_pdf         "$spool_dir/$nome_file.pdf"
		    set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

		    set file_id   [open $file_html w]
		    fconfigure $file_id -encoding iso8859-1
		    puts $file_id $stampa
		    close $file_id

		    # lo trasformo in PDF
		    iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

		    # Controllo se il Database e' Oracle o Postgres
		    set id_db     [iter_get_parameter database]

		    set sql_contenuto  "lo_import(:file_html)"
		    set tipo_contenuto [ns_guesstype $file_pdf]

		    set contenuto_tmpfile  $file_pdf

		    if {[db_0or1row sel_docu ""] == 0} {
			set flag_docu "N"
		    } else {
			set flag_docu "S"
		    }

		    if {[string equal $cod_documento ""]
			|| $flag_docu == "N"} {
			db_1row sel_docu_next ""
			#		set tipo_documento "DI"
			set tipo_documento "SO"
			db_dml dml_sql_docu [db_map ins_docu]
		    } else {
			db_dml dml_sql_docu [db_map upd_docu]
		    }

		    if {$id_db == "postgres"} {
			db_dml dml_sql2 [db_map upd_docu_2]
			db_dml dml_sql3 [db_map upd_docu_3]
		    } else {
			db_dml dml_sql2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
		    }

		    ns_unlink $file_html

		    set dml_sql [db_map upd_prvv]
		}
		D {
		    set dml_sql [db_map del_prvv]
		}
	    }

	    # Lancio la query di manipolazione dati contenute in dml_sql
	    if {[info exists dml_sql]} {
                db_dml dml_coimprvv $dml_sql
	    }
	    if {[info exists dml_sql_docu]} {
                db_dml dml_coimdocu $dml_sql_docu
	    }
	    if {[info exists dml_sql_movi]} {
                db_dml dml_coimmoviu $dml_sql_movi
	    }

	}} {
	    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
	}


    # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_cod_prvv $cod_prvv
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_prvv cod_impianto url_aimp url_list_aimp last_cod_prvv nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimprvv-gest?funzione=V&$link_gest"}
        D {set return_url   "coimprvv-list?$link_list"}
        I {set return_url   "coimprvv-gest?funzione=V&$link_gest"}
        V {set return_url   "coimprvv-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
