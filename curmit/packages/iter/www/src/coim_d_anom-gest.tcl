ad_page_contract {
    Add/Edit/Delete  form per la tabella "coim_d_anom"
    @author          Paolo Formizzi
    @creation-date   10/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coim_d_anom-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 21/06/2023 Aggiunto la classe ah-jquery-date al campo dat_utile_inter.


} {
    {cod_cimp_dimp    ""}
    {flag_origine     ""}
    {prog_anom        ""}
    {last_prog_anom   ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {extra_par        ""}
    {cod_impianto     ""}
    {url_aimp         ""}
    {url_list_aimp    ""}
    {gen_prog         ""}
    {flag_cimp        ""}
    {flag_origine     ""}
   {extra_par_inco   ""}
   {cod_inco         ""}
   {flag_inco        ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $flag_origine {
    "RV" {set tipologia "2"}
    "MH" {set tipologia "1"}
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_cimp_dimp flag_origine url_list_aimp url_aimp cod_impianto gen_prog flag_cimp prog_anom last_prog_anom nome_funz nome_funz_caller extra_par caller extra_par_inco cod_inco flag_inco]
# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set flag_ente  $coimtgen(flag_ente)
set sigla_prov $coimtgen(sigla_prov)

# questo if e' utilizzato per visualizzare la barra dei link in caso che si 
# provenga dalla gestione degli appuntamenti o da modilli h/rapporti di ver.
if {$flag_cimp == "S"
||  $flag_origine == "MH"
} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp $flag_origine]
} else {
    set link_tab ""
}
set dett_tab [iter_tab_form $cod_impianto]

if {$flag_inco == "S"} {
    set link_inc [iter_link_inco $cod_inco $nome_funz_caller $url_list_aimp $url_aimp $nome_funz "" $extra_par_inco]
} else {
    set link_inc ""
}

# Personalizzo la pagina
# metto le extra_par in modo normale perche' in realta' sono quelle della lista
# rapporti di verifica
set link_list_script {[export_url_vars cod_cimp_dimp flag_origine extra_par url_list_aimp url_aimp cod_impianto gen_prog flag_cimp last_prog_anom caller nome_funz_caller nome_funz extra_par_inco flag_inco cod_inco]}
set link_list        [subst $link_list_script]
set titolo           "Anomalia da dichiarazione"
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
set form_name    "coim_d_anom"
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
form create $form_name \
-html    $onsubmit_cmd

element create $form_name cod_cimp_dimp \
-label   "Cod." \
-widget   hidden \
-datatype text \
-optional

element create $form_name prog_anom \
-label   "Prog." \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 readonly {} class form_element" \
-optional

if {$funzione == "I"} {
    element create $form_name cod_tanom \
    -label   "Codice anomalia" \
    -widget   select \
    -datatype text \
    -html    "$disabled_key {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coim_d_tano cod_tano "cod_tano||' - '||descr_breve"]
} else {
    element create $form_name cod_tanom  -widget hidden -datatype text -optional
    element create $form_name desc_tano \
    -label    "desc tanom" \
    -widget   text \
    -datatype text \
    -html     "size 80  readonly {} class form_element" \
    -optional
}
#but01 Aggiunto la classe ah-jquery-date al campo dat_utile_inter
element create $form_name dat_utile_inter \
-label   "Data utile inter." \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name extra_par_inco -widget hidden -datatype text -optional
element create $form_name flag_origine  -widget hidden -datatype text -optional
element create $form_name cod_inco      -widget hidden -datatype text -optional
element create $form_name flag_inco     -widget hidden -datatype text -optional
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
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_prog_anom -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name flag_inco      -value $flag_inco
    element set_properties $form_name flag_origine   -value $flag_origine
    element set_properties $form_name cod_inco       -value $cod_inco
    element set_properties $form_name extra_par_inco -value $extra_par_inco
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
    element set_properties $form_name last_prog_anom -value $last_prog_anom

    if {$funzione == "I"} {
        element set_properties $form_name cod_cimp_dimp   -value $cod_cimp_dimp
        
    } else {
      # leggo riga
        if {[db_0or1row sel_d_anom {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_cimp_dimp   -value $cod_cimp_dimp
        element set_properties $form_name prog_anom       -value $prog_anom
        element set_properties $form_name cod_tanom       -value $cod_tanom
        element set_properties $form_name dat_utile_inter -value $dat_utile_inter
	element set_properties $form_name desc_tano       -value $desc_tano

    }

}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set prog_anom       [element::get_value $form_name prog_anom]
    set cod_tanom       [element::get_value $form_name cod_tanom]
    set dat_utile_inter [element::get_value $form_name dat_utile_inter]

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	if {$funzione == "I"} {
	    if {[string equal $cod_tanom ""]} {
		element::set_error $form_name cod_tanom "Inserire Cod. tipo anomalia da dichiarazione"
		incr error_num
	    }
	}

	switch $tipologia {
	    "1" { if {[db_0or1row sel_dimp_data_controllo ""] == 0} {
	  	       set data_controllo ""
	          }
	    }
	    "2" { if {[db_0or1row sel_cimp_data_controllo ""] == 0} {
		       set data_controllo ""
	          }  
	    }
	}

        if {![string equal $dat_utile_inter ""]} {
            set dat_utile_inter [iter_check_date $dat_utile_inter]
            if {$dat_utile_inter == 0} {
                element::set_error $form_name dat_utile_inter "Data non corretta"
                incr error_num
            } else {
		if {$data_controllo > $dat_utile_inter} {
		    element::set_error $form_name dat_utile_inter "Data precedente al controllo"
		    incr error_num
		}
		
	    }
        } else {
	    # se la data non è valorizzata e l'ente è Provincidi di LIvorno
	    # calcolo la data in automatico considerando i giorni di adattamento
	    # inseirti sulle anomalie.
	    if {$flag_ente  == "P"
            &&  $sigla_prov == "LI"
	    &&  $funzione   == "I"
	    } {
		if {[db_0or1row sel_d_tano_gg_adattamento ""]== 0} {
		    set gg_adattamento 0
		}
		set dat_utile_inter [clock format [clock scan "$gg_adattamento day" -base [clock scan $data_controllo]] -f "%Y%m%d"]
	    }
	}
    }

    if {$funzione == "I"
    &&  $error_num == 0
    &&  [db_0or1row sel_d_anom_check {}] == 1
    } {
      # controllo univocita'/protezione da double_click
        element::set_error $form_name cod_tanom "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }
    if {[db_0or1row sel_d_tano ""] == 0} {
	set descr_tano ""
	set flag_scatenante ""
    }

    set esito "N"
    if {$funzione == "I"
    ||  $funzione == "M"
    } {    
	# in base al flag origine e al flag scatenate dell'anomalia, verifico
	# se il cimp/dimp non hanno gia' il flag_pericolosita' attivo e di 
	# conseguenza lo aggiorno nel modo corretto
	switch $flag_origine {
	    "MH" {
		if {[db_0or1row sel_dimp_pericolosita ""] == 0} {
		    set flag_pericolosita "F"
		}
		if {$flag_pericolosita == "F"
		    &&  $flag_scatenante  == "T"
		} {
		    set flag_pericolosita "T"
		}
		set dml_dimp [db_map upd_dimp]
	    }
	    "RV" {  
		if {[db_0or1row sel_cimp_pericolosita ""] == 0} {
		    set flag_pericolosita "F"
		}
		if {$flag_pericolosita == "F"
		    &&  $flag_scatenante   == "T"
		} {
		    set flag_pericolosita "T"
		}
#		set dml_cimp [db_map upd_cimp]
	    }
	}
    }
    
    if {$funzione == "D"} {
	set flag_pericolosita "F"
	db_foreach sel_d_tano_scatenante "" {
	    if {$flag_scatenante == "T"} {
		set flag_pericolosita "T"
	    } 
	} if_no_rows {
	    set flag_pericolosita "F"
	}
	switch $flag_origine {
	    "MH" { set dml_dimp [db_map upd_dimp] }
	    "RV" { set dml_cimp [db_map upd_cimp] }
	}
    }

    switch $funzione {
        I {db_1row sel_d_prog ""
	    set tipo_anom "C"
	    set dml_sql [db_map ins_d_anom]

	    if {[db_0or1row sel_todo_count ""] == 0} {
		set conta 0
	    }
	    if {$conta > 0} {
		if {[db_0or1row sel_todo ""] == 0} {
		    db_1row sel_todo_next ""
 		    # set cod_cimp_dimp $cod_cimp_dimp
		    set note "$cod_tanom $descr_tano"
		    set flag_evasione "N"
		    set dml_sql2 [db_map ins_todo]
		} else {
		    append note " $cod_tanom $descr_tano"
		    set dml_sql2 [db_map upd_todo]
		}
	    }
	    if {$conta == 0} {
		db_1row sel_todo_next ""
	#	set cod_cimp_dimp $cod_cimp
		set note "$cod_tanom $descr_tano"
		set flag_evasione "N"
		set dml_sql2 [db_map ins_todo]
	    }
	}
        M {set dml_sql [db_map upd_d_anom]
	    if {[db_0or1row check_todo ""] == 1} {
		set dml_sql2 [db_map upd_todo]
	    }
	}
        D {set dml_sql [db_map del_d_anom]
	    if {[db_0or1row check_todo ""] == 1} {
		set dml_sql2 [db_map del_todo]
	    }
	}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coim_d_anom $dml_sql
		if {[info exists dml_sql2]} {
		    db_dml dml_coimtodo $dml_sql2
		}
		if {[info exists dml_cimp]} {
		    db_dml dml_coimcimp $dml_cimp
		}
		if {[info exists dml_dimp]} {
		    db_dml dml_coimdimp $dml_dimp
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
        set last_prog_anom $prog_anom
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_cimp_dimp flag_origine prog_anom url_list_aimp url_aimp cod_impianto gen_prog flag_cimp last_prog_anom nome_funz nome_funz_caller extra_par caller extra_par_inco flag_inco cod_inco]

    switch $funzione {
        M {set return_url   "coim_d_anom-gest?funzione=V&$link_gest"}
        D {set return_url   "coim_d_anom-list?$link_list"}
        I {set return_url   "coim_d_anom-gest?funzione=V&$link_gest"}
        V {set return_url   "coim_d_anom-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
