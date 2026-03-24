ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Giulio Laurenzi / Katia Coazzoli
    @creation-date   02/04/2004

    @param funzione  M=edit A=Acquisizione impianto V=View
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimaimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================================
    ric01 10/09/2025 Punto 33 MEV regione Marche: il campo manutentore non può essere sbiancabile, per il manutentore
    ric01            non deve essere modificabile. Modifica solo per regione Marche.

    rom08 17/05/2024 CASERTA HA CHIESTO DI TOGLIERE I CONTROLLI SU POD E PDR FINO AL 31/08/2024

    rom07 19/12/2023 Rieti ha chiesto di togleire sempre l'obbligatorietà sui campi POD e PDR.

    rom06 27/11/2023 Napoli ha richiesto di togliere sempre l'obbligatorieta' sui campi POD e PDR.

    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid.

    rom05 24/01/2023 UCIT non deve avere pod e pdr obbligatori come Palermo.

    rom04 05/12/2022 Sandro ha chiesto che pod e pdr non siano mai obbligatori per la Citta Metropolitana di Palermo.

    rom03 03/02/2021 Aggiunto controllo su PDR per il Comune di Salerno: deve iniziare per 1534.

    rom02 11/12/2020 Per Regione Marche non vado a fare l'update su pod e pdr perche' sono stati spostati
    rom02            nella scheda 1-bis.

    sim02 04/02/2020 Corretto update su POD e PDR. Se non erano mai stati valorizzati, per qualche ragione non chiara
    sim02            il programma non ne permetteva la modifica.

    sim01 20/01/2019 Per tutti gli enti che non sono le Marche il POD e PDR devono essere obbligatori

    rom01 14/05/2018 Aggiunta proc iter_get_coimtgen. Su ichiesta di Sandro non faccio visualizzare i campi
    rom01            POD e PDR perchè sono stati aggiunti in coimaimp-bis-gest.

} {
    
   {cod_impianto      ""}
   {last_cod_impianto ""}
   {funzione         "V"}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""}
   {extra_par         ""}
   {url_aimp          ""}
   {url_list_aimp     ""}
   {flag_assegnazione ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "A" {set lvl 1}
    "M" {set lvl 3}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]

#rom01 aggiunto iter_get_coimtgen
iter_get_coimtgen

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# preparo la routine che serve in fase di aggiornamento
set elabora_agg {
    set data_fin_valid [iter_calc_date $data_ini_valid - 1]

    if {$funzione == "M"
    ||  $funzione == "A"
    } {

	# leggo il record originale (prima delle modifiche)
	# dalla tabella coimaimp (serve per la storicizzazione)
	if {[db_0or1row sel_aimp_db {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

	if {$funzione == "A"} {
	    # in questo caso devo cambiare solo il manutentore
	    set cod_installatore    $db_cod_installatore
	    set cod_distributore    $db_cod_distributore
	    set cod_progettista     $db_cod_progettista
	    set cod_amag            $db_cod_amag
	    set cod_distributore_el $db_cod_distributore_el
	    set pdr                 $db_pdr
	    set pod                 $db_pod
      	}

	# Lancio la query di manipolazione dati
	with_catch error_msg {
	    db_transaction {

		# per ogni tecnico che e' stato modificato rispetto al record
		# originale (tranne il caso in cui l'originale fosse = ""),
		# viene storicizzato il record pre-modifica.

		if {![string equal $db_cod_manutentore ""] 
		&&  $db_cod_manutentore != $cod_manutentore
		} {
		    set ruolo "M"
		    set db_cod_soggetto $db_cod_manutentore 
		    if {[db_0or1row sel_rife_check ""] == 0} {
			db_dml ins_rife {}
		    }
		}

		if {![string equal $db_cod_installatore ""]
		&&   $db_cod_installatore != $cod_installatore
		} {
		    set ruolo "I"
		    set db_cod_soggetto $db_cod_installatore
		    if {[db_0or1row sel_rife_check ""] == 0} {
			db_dml ins_rife {}
		    }
		}

		if {![string equal $db_cod_distributore ""]
		&&   $db_cod_distributore != $cod_distributore
		} {
		    set ruolo "D"
		    set db_cod_soggetto $db_cod_distributore
		    if {[db_0or1row sel_rife_check ""] == 0} {
			db_dml ins_rife {}
		    }
		}

   		if {![string equal $db_cod_distributore_el ""]
		&&   $db_cod_distributore_el != $cod_distributore_el
		} {
		    set ruolo "D"
		    set db_cod_soggetto $db_cod_distributore_el
		    if {[db_0or1row sel_rife_check ""] == 0} {
			db_dml ins_rife {}
		    }
		}

		if {![string equal $db_cod_progettista ""]
		&&  $db_cod_progettista != $cod_progettista
		} {
		    set ruolo "G"
		    set db_cod_soggetto $db_cod_progettista
		    if {[db_0or1row sel_rife_check ""] == 0} {
			db_dml ins_rife {}
		    }
		}

#sim02		if {[string equal $db_pod ""]} {
#sim02		    set pod $db_pod
#sim02		}
#sim02		if {[string equal $db_pdr ""]} {
#sim02		    set pdr $db_pdr
#sim02		}
		# faccio l'aggiornamento vero e proprio sui tecnici
		# dell'impianto

		if {$coimtgen(regione) ne "MARCHE"} {#rom02 Aggiunte if, else e loro contenuto
		    set update_pod_pdr "
                , pdr                 = '$pdr'
                , pod                 = '$pod'"
		} else {
		    set update_pod_pdr ""
		}
		
		db_dml upd_aimp_tecn {}
		if {$flag_assegnazione == "t"} {
		    db_1row sel_cod_todo_dual ""
		    db_1row sel_manu_todo ""
		    set note "Aquisito impianto dal manutentore $nominativo_manu ($cod_manutentore)"
		    db_dml ins_todo ""
		}
	    }
	} {
	    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
	}

    }
}

# in caso di Acquisizione, va fatto subito l'aggiornamento
if {$funzione == "A"} {
    # controllo se l'utente e' un manutentore
    set cod_manutentore [iter_check_uten_manu $id_utente]
    if {[string equal $cod_manutentore ""]} {
	iter_return_complaint "Spiacente, ma l'utente utilizzato non &egrave; un manutentore"
    }

    set data_ini_valid [iter_set_sysdate]
    eval $elabora_agg

    set return_url   "coimaimp-tecn?funzione=V&$link_gest"

    ad_returnredirect $return_url
    ad_script_abort
}

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina

set link_list_script {[export_url_vars last_cod_impianto caller nome_funz nome_funz_caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "tecnici coinvolti"
switch $funzione {
    M {set button_label "Conferma modifica" 
       set page_title   "Modifica $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizza $titolo"}
}

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
                     [list "javascript:window.close()" "Torna alla Gestione"] \
                     [list coimaimp-list?$link_list "Lista Impianti"] \
                     "$page_title"]
}

# preparo il link al programma storico tecnici (usato nell'adp)
set link_rife [export_url_vars cod_impianto nome_funz_caller url_list_aimp url_aimp]&nome_funz=[iter_get_nomefunz coimrift-list]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp_tecn"
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

#ric01 spostato il cerca qua, prima era dopo nome_manu
if {$funzione == "I"
||  $funzione == "M"
} {
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]
} else {
    set cerca_manu ""
}

#ric01 spostato il cerca qua, prima era dopo nome_inst
if {$funzione == "I"
||  $funzione == "M"
} {
    set cerca_inst [iter_search $form_name coimmanu-list [list dummy cod_installatore dummy cognome_inst dummy nome_inst] [list f_ruolo "I"]]
} else {
    set cerca_inst ""
}

set widget_manu_inst "text";#ric01
if {$coimtgen(regione) eq "MARCHE"} {#ric01 aggiunta if e contenuto
    if {![string equal [iter_check_uten_manu $id_utente] ""]} {
	set widget_manu_inst "inform"
	set cerca_manu ""
	set cerca_inst ""
    } 
}

#ric01 aggiunto widget_manu_inst
element create $form_name cognome_manu \
-label   "Cognome manutentore" \
-widget   $widget_manu_inst \
-datatype text \
-html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
-optional

#ric01 aggiunto widget_manu_inst
element create $form_name nome_manu \
-label   "Nome manutentore" \
-widget  $widget_manu_inst \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

#ric01 aggiunto widget_manu_inst
element create $form_name cognome_inst \
-label   "Cognome installatore" \
-widget   $widget_manu_inst \
-datatype text \
-html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
-optional

#ric01 aggiunto widget_manu_inst
element create $form_name nome_inst \
-label   "Nome installatore" \
-widget   $widget_manu_inst \
-datatype text \
-html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name cod_distributore \
-label   "Distributore" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimdist cod_distr ragione_01] \

element create $form_name cognome_prog \
-label   "Cognome progettista" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name nome_prog \
-label   "Nome progettista" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

if {$funzione == "I"
||  $funzione == "M"
} {
    set cerca_prog  [iter_search $form_name coimprog-list   [list dummy cod_progettista dummy cognome_prog dummy nome_prog]]
} else {
    set cerca_prog ""
}
#but01 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid. 
element create $form_name data_variaz \
-label   "data_variaz" \
-widget   text \
-datatype text \
 -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
-optional

element create $form_name cod_amag \
-label   "codice utenza" \
-widget   text \
-datatype text \
 -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name cod_distributore_el \
-label   "Distributore el." \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimdist cod_distr ragione_01] \

if {$coimtgen(regione) ne "MARCHE"} {#rom01 aggiunta if, aggiunta else e suo contenuto

    #rom06 Aggiunta condizione su Napoli modificando intervento di rom04
    #rom08 AGGIUNTA CONDIZIONE SU CASERTA
    if {$coimtgen(ente) in [list "PPA" "PNA" "PRI" "PCE"] || $coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom04 Aggiunta if e il suo contenuto
	
	#Sandro ha chiesto che per Palermo pod e pdr non siano mai obbligatori.
	
	element create $form_name pdr \
	    -label   "PDR" \
	    -widget   text \
	    -datatype text \
	    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
	    -optional
	
	element create $form_name pod \
	    -label   "PDR" \
	    -widget   text \
	    -datatype text \
	    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
	    -optional    
	
    } else {#rom04 Aggiunta else ma non il suo contenuto

    
	#sim01 tolto optional
	if {![db_0or1row q "
                select 1 
                  from coimgend 
                 where cod_combustibile ='5' 
                   and cod_impianto = :cod_impianto 
                   and flag_attivo= 'S' 
                 limit 1"]} {	
	    
	    element create $form_name pod \
		-label   "POD" \
		-widget   text \
		-datatype text \
		-html    "size 20 maxlength 20 $readonly_fld {} class form_element"
	    
	} else {
	    
	    element create $form_name pod \
		-label   "POD" \
		-widget   text \
	    -datatype text \
		-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
		-optional
	}
	element create $form_name pdr \
	-label   "PDR" \
	    -widget   text \
	    -datatype text \
	    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" 

    };#rom04
	
} else {
    element create $form_name pod      -widget hidden -datatype text -optional
    element create $form_name pdr      -widget hiddeb -datatype text -optional
};#rom01

if {$funzione == "M"} {
    element create $form_name data_ini_valid \
    -label   "data_ini_valid" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
} else {
    element create $form_name data_ini_valid -widget hidden -datatype text -optional
}

element create $form_name cod_impianto      -widget hidden -datatype text -optional
element create $form_name cod_manutentore   -widget hidden -datatype text -optional
element create $form_name cod_installatore  -widget hidden -datatype text -optional
element create $form_name cod_progettista   -widget hidden -datatype text -optional
element create $form_name url_list_aimp     -widget hidden -datatype text -optional
element create $form_name url_aimp          -widget hidden -datatype text -optional
element create $form_name funzione          -widget hidden -datatype text -optional
element create $form_name caller            -widget hidden -datatype text -optional
element create $form_name nome_funz         -widget hidden -datatype text -optional
element create $form_name nome_funz_caller  -widget hidden -datatype text -optional
element create $form_name extra_par         -widget hidden -datatype text -optional
element create $form_name submit            -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_impianto -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    set data_ini_valid     [iter_edit_date [iter_set_sysdate]]
    element set_properties $form_name data_ini_valid    -value $data_ini_valid

    # leggo riga
    if {[db_0or1row sel_aimp_tecn {}] == 0} {
	iter_return_complaint "Record non trovato"
    }

    # recupero la data dell'ultima variazione effettuata, altrimenti
    # da data_installaz
    set data_variaz    [db_string sel_rife_max_data ""]
    if {![string equal $data_variaz ""]} {
	set data_variaz    [iter_edit_date $data_variaz]
    } else {
	set data_variaz    $data_installaz
    }

    element set_properties $form_name cod_impianto        -value $cod_impianto
    element set_properties $form_name cod_manutentore     -value $cod_manutentore
    element set_properties $form_name cod_installatore    -value $cod_installatore
    element set_properties $form_name cod_distributore    -value $cod_distributore
    element set_properties $form_name cod_progettista     -value $cod_progettista
    element set_properties $form_name nome_manu           -value $nome_manu
    element set_properties $form_name cognome_manu        -value $cognome_manu
    element set_properties $form_name nome_inst           -value $nome_inst
    element set_properties $form_name cognome_inst        -value $cognome_inst
    element set_properties $form_name nome_prog           -value $nome_prog
    element set_properties $form_name cognome_prog        -value $cognome_prog
    element set_properties $form_name cod_amag            -value $cod_amag
    element set_properties $form_name data_variaz         -value $data_variaz
    element set_properties $form_name cod_distributore_el -value $cod_distributore_el
    element set_properties $form_name pdr                 -value $pdr
    element set_properties $form_name pod                 -value $pod

}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system
    set cod_manutentore     [element::get_value $form_name cod_manutentore]
    set cod_installatore    [element::get_value $form_name cod_installatore]
    set cod_distributore    [element::get_value $form_name cod_distributore]
    set cod_progettista     [element::get_value $form_name cod_progettista]
    set cognome_manu        [element::get_value $form_name cognome_manu]
    set nome_manu           [element::get_value $form_name nome_manu]
    set cognome_inst        [element::get_value $form_name cognome_inst ]
    set nome_inst           [element::get_value $form_name nome_inst]
    set cognome_prog        [element::get_value $form_name cognome_prog]
    set nome_prog           [element::get_value $form_name nome_prog ]
    set url_list_aimp       [element::get_value $form_name url_list_aimp ]
    set url_aimp            [element::get_value $form_name url_aimp ]
    set data_ini_valid      [element::get_value $form_name data_ini_valid]
    set data_variaz         [element::get_value $form_name data_variaz]
    set cod_amag            [element::get_value $form_name cod_amag]  
    set cod_distributore_el [element::get_value $form_name cod_distributore_el] 
    set pdr                 [element::get_value $form_name pdr]
    set pod                 [element::get_value $form_name pod]

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {$funzione == "M"} {

	#Sandro, 2014-06-30
	#if {[string equal $cod_amag ""]
       # && ![string equal $cod_distributore ""]
	#} {
	#    element::set_error $form_name cod_amag "Inserire il codice utenza termica"
	#    incr error_num
	#}
	if {![string equal $cod_amag ""]
        &&   [string equal $cod_distributore ""]
	} {
	    element::set_error $form_name cod_distributore "Inserire il fornitore di energia termica"
	    incr error_num
	};#Sandro, 2014-06-30

	#routine generica per controllo codice manutentore
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

	#leggo lo storico
	db_0or1row sel_aimp_db {};#ric01
	
        if {[string equal $cognome_manu ""]
	&&  [string equal $nome_manu    ""]
	} {
	    if {$coimtgen(regione) eq "MARCHE"&& ![string equal $db_cod_manutentore ""]} {#ric01 aggiunta if e contenuto
		element::set_error $form_name cognome_manu "Non è possibile rimuovere il manutentore."
		incr error_num
	    } else {
		set cod_manutentore ""
	    }
	} else {
	    set chk_inp_cod_manu $cod_manutentore
	    set chk_inp_cognome  $cognome_manu
	    set chk_inp_nome     $nome_manu
	    eval $check_cod_manu
            set cod_manutentore  $chk_out_cod_manu
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_manu $chk_out_msg
                incr error_num
	    }
	}

	if {[string equal $cognome_inst ""]
	&&  [string equal $nome_inst    ""]
	} {
	    if {$coimtgen(regione) eq "MARCHE" && ![string equal $db_cod_installatore ""]} {#ric01 aggiunta if e contenuto
		element::set_error $form_name cognome_inst "Non è possibile rimuovere l'installatore."
		incr error_num
	    } else {
		set cod_installatore ""
	    }
	} else {
	    set chk_inp_cod_manu $cod_installatore
	    set chk_inp_cognome  $cognome_inst
	    set chk_inp_nome     $nome_inst
	    eval $check_cod_manu
	    set cod_installatore $chk_out_cod_manu
	    if {$chk_out_rc == 0} {
		element::set_error $form_name cognome_inst $chk_out_msg
		incr error_num
	    }
	}

	# routine per controllo codice progettista
	set check_cod_prog {
	    set chk_out_rc       0
	    set chk_out_msg      ""
	    set chk_out_cod_prog ""
	    set ctr_prog         0
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
	    db_foreach sel_prog "" {
		incr ctr_prog
		if {$cod_progettista == $chk_inp_cod_prog} {
		    set chk_out_cod_prog $cod_progettista
		    set chk_out_rc       1
		}
	    }
	    switch $ctr_prog {
		0 { set chk_out_msg "Soggetto non trovato"}
		1 { set chk_out_cod_prog $cod_progettista
		    set chk_out_rc       1 }
		default {
		    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
		}
	    }
	}

	if {[string equal $cognome_prog ""]
	&&  [string equal $nome_prog    ""]
	} {
	    set cod_progettista ""
	} else {
	    set chk_inp_cod_prog $cod_progettista
	    set chk_inp_cognome  $cognome_prog
	    set chk_inp_nome     $nome_prog
	    eval $check_cod_prog
	    set cod_progettista  $chk_out_cod_prog
	    if {$chk_out_rc == 0} {
		element::set_error $form_name cognome_prog $chk_out_msg
		incr error_num
	    }
	}

	if {[string equal $data_ini_valid ""]} {
	    element::set_error $form_name data_ini_valid "Inserire data"
	    incr error_num
	} else {
	    set data_ini_valid [iter_check_date $data_ini_valid]
	    if {$data_ini_valid == 0} {
		element::set_error $form_name data_ini_valid "data inizio validit&agrave; deve essere una data"
		incr error_num
	    } else {
		# non e' possibile usare una data_validita' inferiore
		# alla data validita' piu' recente
		set data_max_valid [db_string sel_rife_max_data ""]
		if {![string equal $data_max_valid ""]} {
		    set data_max_valid [iter_calc_date $data_max_valid + 1]
		    if {$data_ini_valid < $data_max_valid} {
			set data_max_valid [iter_edit_date $data_max_valid]
			element::set_error $form_name data_ini_valid "data validit&agrave; non accettata: situazione attuale valida dal $data_max_valid"
			incr error_num
		    }
		}
	    }
	}
    }

    if {![string equal $cognome_manu ""]} {
	if {[string equal $nome_manu ""]} {	
	    set eq_nome_manu "and nome is null"
	} else {
	    set eq_nome_manu "and nome = upper(:nome_manu)"
	}
	if {[db_0or1row sel_ruolo_manu {}] == 0} {
	    element::set_error $form_name cognome_manu "Manutentore non trovato"
	    incr error_num
	}
    }

    if {![string equal $cognome_inst ""]} {
	if {[string equal $nome_inst ""]} {	
	    set eq_nome_inst "and nome is null"
	} else {
	    set eq_nome_inst "and nome = upper(:nome_inst)"
	}
	if {[db_0or1row sel_ruolo_inst {}] == 0} {
	    element::set_error $form_name cognome_inst "Installatore non trovato"
	    incr error_num
	}
    }

    #21102014
    if {$coimtgen(regione) ne "MARCHE"} {#rom01
	if {![string equal $pdr ""]} {
	    set pdr [string trim $pdr]
	    if {[string length $pdr] != 14} {
		element::set_error $form_name pdr "PDR deve essere di 14 caratteri"
		incr error_num
	    } else {#rom03 aggiunta else e contenuto
		if {$coimtgen(ente) eq "CSALERNO"} {
		    set controllo_cifre_iniziali_pdr [string range $pdr 0 3]
		    if {![string equal $controllo_cifre_iniziali_pdr "1534"]} {
			element::set_error $form_name pdr "PDR deve iniziare per 1534..."
			incr error_num
		    }
		}
	    };#rom03
	}
	
	if {![string equal $pod ""]} {
	    set pod [string trim $pod]
	    if {[string length $pod] < 14 || [string length $pod] > 15 } {
		element::set_error $form_name pod "POD deve essere di 14 o 15 caratteri"
		incr error_num
	    }
	}
    };#rom01
    #fine 211014


    if {$error_num > 0} {
	ad_return_template
	return
    }
    
    eval $elabora_agg

    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto last_cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
	M {set return_url   "coimaimp-tecn?funzione=V&$link_gest"}
	V {set return_url   "$url_aimp&[export_url_vars url_list_aimp]"}
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
