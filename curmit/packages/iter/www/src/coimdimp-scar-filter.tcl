ad_page_contract {
    Filtro Modelli H da esportare
    @author          Nicola Mortoni Adhoc
    @creation-date   15/05/2006

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, serve per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimdimp-scar-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 23/06/2023 Aggiunto la classe ah-jquery-date ai campi:f_data_ins_iniz, f_data_ins_fine, f_data_controllo_iniz, f_data_controllo_fine.   

} {
   {cod_batc         ""}    
   {funzione         "I"}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""}
   {receiving_element ""}

   {f_manu_cogn       ""}
   {f_manu_nome       ""}
   {f_data_ins_iniz   ""}
   {f_data_ins_fine   ""}
   {f_data_controllo_iniz ""}
   {f_data_controllo_fine ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se il filtro viene chiamato da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}

# Controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set nom  "Esportazione Dichiarazioni"
set link_head [iter_links_batc $nome_funz $nome_funz_caller $nom]
# Controllo se l'utente è un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# Personalizzo la pagina
set titolo   "Esportazione Dichiarazioni"
switch $funzione {
    I {set button_label "Conferma lancio"
       set page_title   "Lancio $titolo "}
    V {set button_label "Torna al menu"
       set page_title   "$titolo lanciato"}
}

if {$caller == "index"} {
    set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimdimp_scar"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_fld2 "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set cerca_manu ""
switch $funzione {
   "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
if {[string equal $cod_manutentore ""]} {
    set readonly_fld2 \{\}
    set cerca_manu    [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
} else {
    set readonly_fld2 "readonly"
    set cerca_manu    ""
}
       }
   "M" {set readonly_fld \{\}
        set disabled_fld \{\}
if {[string equal $cod_manutentore ""]} {
    set readonly_fld2 \{\}
    set cerca_manu    [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]]
} else {
    set readonly_fld2 "readonly"
    set cerca_manu    ""
} 
      }
}

form create $form_name \
-html    $onsubmit_cmd

element create $form_name f_manu_cogn \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld2 {} class form_element" \
-optional

element create $form_name f_manu_nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld2 {} class form_element"\
-optional
#but01
element create $form_name f_data_ins_iniz \
-label   "Da data inserimento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional
#but01
element create $form_name f_data_ins_fine \
-label   "A data inserimento" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional
#but01
element create $form_name f_data_controllo_iniz \
-label   "Da data controllo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional
#but01
element create $form_name f_data_controllo_fine \
-label   "A data controllo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element class ah-jquery-date" \
-optional

element create $form_name funzione          -widget hidden -datatype text -optional
element create $form_name caller            -widget hidden -datatype text -optional
element create $form_name nome_funz         -widget hidden -datatype text -optional
element create $form_name nome_funz_caller  -widget hidden -datatype text -optional
element create $form_name receiving_element -widget hidden -datatype text -optional
element create $form_name submit            -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name f_cod_manu        -widget hidden -datatype text -optional
element create $form_name dummy             -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    # solo se l'utente e' un manutentore valorizzo il relativo campo.
    if {![string equal $cod_manutentore ""]} {
	element set_properties $form_name f_cod_manu    -value $cod_manutentore
	if {[db_0or1row sel_manu_nome ""] == 0} {
	    set f_manu_cogn ""
	    set f_manu_nome ""
	}
    }

    if {$funzione == "I"} {
	set current_date [iter_set_sysdate]
	set current_time [iter_set_systime]
	set dat_prev [iter_edit_date $current_date]
	set ora_prev $current_time

	element set_properties $form_name f_manu_cogn       -value $f_manu_cogn
	element set_properties $form_name f_manu_nome       -value $f_manu_nome
	element set_properties $form_name f_data_ins_iniz   -value [iter_edit_date $f_data_ins_iniz]
	element set_properties $form_name f_data_ins_fine   -value [iter_edit_date $f_data_ins_fine]
	element set_properties $form_name f_data_controllo_iniz -value [iter_edit_date $f_data_controllo_iniz]
	element set_properties $form_name f_data_controllo_fine -value [iter_edit_date $f_data_controllo_fine]
	element set_properties $form_name funzione          -value $funzione
	element set_properties $form_name caller            -value $caller
	element set_properties $form_name nome_funz         -value $nome_funz
	element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
	element set_properties $form_name receiving_element -value $receiving_element
    } else {
      # leggo riga
        if {[db_0or1row sel_batc {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

#        element set_properties $form_name dat_prev           -value $dat_prev
#        element set_properties $form_name ora_prev           -value $ora_prev

	foreach {key value} $par {
	    set $key $value
	}
	element set_properties $form_name f_cod_manu    -value $cod_manutentore
	element set_properties $form_name f_data_ins_iniz   -value $f_data_ins_iniz
	element set_properties $form_name f_data_ins_fine   -value $f_data_ins_fine
	element set_properties $form_name f_data_controllo_iniz -value $f_data_controllo_iniz
	element set_properties $form_name f_data_controllo_fine -value $f_data_controllo_fine
   }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_cod_manu      [string trim [element::get_value $form_name f_cod_manu]]
    set f_manu_cogn     [string trim [element::get_value $form_name f_manu_cogn]]
    set f_manu_nome     [string trim [element::get_value $form_name f_manu_nome]]
    set f_data_ins_iniz [string trim [element::get_value $form_name f_data_ins_iniz]]
    set f_data_ins_fine [string trim [element::get_value $form_name f_data_ins_fine]]
    set f_data_controllo_iniz [string trim [element::get_value $form_name f_data_controllo_iniz]]
    set f_data_controllo_fine [string trim [element::get_value $form_name f_data_controllo_fine]]

  # controlli
    set error_num 0

    if {$funzione == "I"} {
	if {[string equal $f_manu_cogn ""]
	    && ![string equal $f_manu_nome ""]
	} {
	    element::set_error $form_name f_manu_cogn "Indicare anche il cognome"
	    incr error_num
	}

	# routine generica per controllo codice manutentore
	set check_cod_manu {
	    set chk_out_rc       0
	    set chk_out_msg      ""
	    set chk_out_cod_manu ""
	    set ctr_manu         0
	    if {[string equal $chk_inp_cognome ""]} {
		set eq_cognome "is null"
	    } else {
		set eq_cognome "= upper(:chk_inp_cognome)"
	    }
	    if {[string equal $chk_inp_nome ""]} {
		set eq_nome    "is null"
	    } else {
		set eq_nome    "= upper(:chk_inp_nome)"
	    }
	    db_foreach sel_manu "" {
		incr ctr_manu
		if {$cod_manu_db == $chk_inp_cod_manu} {
		    set chk_out_cod_manu $cod_manu_db
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_manu {
		0 { set chk_out_msg "Soggetto non trovato"}
		1 { set chk_out_cod_manu $cod_manu_db
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
		}
	    }
	}
	
	if {[string equal $f_manu_cogn ""]
	    &&  [string equal $f_manu_nome ""]
	} {
	    set cod_manutentore ""
	} else {
	    set chk_inp_cod_manu $f_cod_manu
	    set chk_inp_cognome  $f_manu_cogn
	    set chk_inp_nome     $f_manu_nome
	    eval $check_cod_manu
	    set f_cod_manu  $chk_out_cod_manu
	    if {$chk_out_rc == 0} {
		element::set_error $form_name f_manu_cogn $chk_out_msg
		incr error_num
	    }
	}
	
	set check_data_ins_iniz "f"
	if {![string equal $f_data_ins_iniz ""]} {
	    set f_data_ins_iniz [iter_check_date $f_data_ins_iniz]
	    if {$f_data_ins_iniz == 0} {
		element::set_error $form_name f_data_ins_iniz "Inserire correttamente la data" 
		incr error_num
	    } else {
		set check_data_ins_iniz "t"
	    }
	}
	
	set check_data_ins_fine "f"
	if {![string equal $f_data_ins_fine ""]} {
	    set f_data_ins_fine [iter_check_date $f_data_ins_fine]
	    if {$f_data_ins_fine == 0} {
		element::set_error $form_name f_data_ins_fine "Inserire correttamente la data"
		incr error_num
	    } else {
		set check_data_ins_fine "t"
	    }
	}
	
	if {$check_data_ins_iniz == "t"
	    &&  $check_data_ins_fine == "t"
	    &&  $f_data_ins_iniz     >  $f_data_ins_fine
	} {
	    element::set_error $form_name f_data_ins_iniz "Data Inizio deve essere minore di Data Fine"
	    incr error_num
	}
	
	set check_data_controllo_iniz "f"
	if {![string equal $f_data_controllo_iniz ""]} {
	    set f_data_controllo_iniz [iter_check_date $f_data_controllo_iniz]
	    if {$f_data_controllo_iniz == 0} {
		element::set_error $form_name f_data_controllo_iniz "Inserire correttamente la data" 
		incr error_num
	    } else {
		set check_data_controllo_iniz "t"
	    }
	}
	
	set check_data_controllo_fine "f"
	if {![string equal $f_data_controllo_fine ""]} {
	    set f_data_controllo_fine [iter_check_date $f_data_controllo_fine]
	    if {$f_data_controllo_fine == 0} {
		element::set_error $form_name f_data_controllo_fine "Inserire correttamente la data"
		incr error_num
	    } else {
		set check_data_controllo_fine "t"
	    }
	}
	
	if {$check_data_controllo_iniz == "t"
	    &&  $check_data_controllo_fine == "t"
	    &&  $f_data_controllo_iniz > $f_data_controllo_fine
	} {
	    element::set_error $form_name f_data_controllo_iniz "Data Inizio deve essere minore di Data Fine"
	    incr error_num
	}
    }
	
    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {$funzione == "I"} {
	set current_date [iter_set_sysdate]
	set current_time [iter_set_systime]
	set dat_prev $current_date
	set ora_prev $current_time

	# set cod_batc
	db_1row sel_batc_next ""
	set flg_stat     "A"
	set cod_uten_sch $id_utente
	set nom_prog     "iter-scar-manu"
	set par          ""
	lappend par       f_cod_manu
	lappend par      $f_cod_manu
	lappend par       f_data_ins_iniz
	lappend par      $f_data_ins_iniz
	lappend par       f_data_ins_fine
	lappend par      $f_data_ins_fine
	lappend par       f_data_controllo_iniz
	lappend par      $f_data_controllo_iniz
	lappend par       f_data_controllo_fine
	lappend par      $f_data_controllo_fine
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
        I {set return_url   "coimdimp-scar-filter?funzione=V&$link_gest"}
        V {set return_url   ""}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
