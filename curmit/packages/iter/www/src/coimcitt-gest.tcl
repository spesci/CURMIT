ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcitt"
    @author          Giulio Laurenzi
    @creation-date   26/02/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimcitt-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom10 16/04/2024 Sandro ha chiesto di rendere modificabile per i manutentori il campo cap.

    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campo data.

    rom09 07/03/2023 Anche Regione Marche ha chiesto di togliere i controlli di congruenza tra
    rom09            natura giuridica, cod_fiscale e cod_piva come Ucit.

    rom08 24/01/2023 Per ucit tolti controlli su congruenza tra natura giuridica e cod_fiscale
    rom08            e cod_piva perche' quando inseriscono le associazioni hanno natura giuridica
    rom08            ma solo codice fiscale.

    ric01 06/12/2022 Solo per Palermo, aggiunto controllo bloccante in caso PIVA o codice
    ric01            fiscale siano già esistenti ed associati ad altre persone.
    ric01            Per tutti gli enti aggiunto controllo su congruenza tra natura giuridica e
    ric01            cod_fiscale e cod_piva.
    
    rom07 25/11/2020 Sandro ha detto che cod_fisc e cod_piva possono essere lasciati vuoti
    rom07            dagli utenti con ruolo admin e utente.

    rom06 04/08/2020 Su richiesta di Salerno Sandro ha detto che anche il campo pec deve 
    rom06            avere la maxlenght a 100 come nel db. Sandro ha detto che va bene per tutti.

    rom05 22/06/2020 Sandro ha detto che il campo mail deve avere la maxlenght di 100 come
    rom05            il rispettivo campo del db. Ha detto che va bene per tutti gli enti.

    gac01 19/02/2018 Gestiti nuovi campi patentino e patentino_fgas

    rom04 05/02/2019 Corretto intervento di rom02 su il messaggio di errore in fase di cancellazione.

    rom03 01/02/2019 Su richiesta di Sandro metto il link "Impianti" non cliccabile se sono
    rom03            loggato come manutentore.

    rom02 30/01/2019 Prima di eliminare il soggetto controllo che non sia il Responsabile 
    rom02            associato a una DFM, a un Rapporto di ispezione o che non sia associato
    rom02            come Responsabile, Proprietario o Occupante su un RCEE

    rom01 11/10/2018 Aggiunto il campo cod_piva in visualizzazione, prima era hidden

    gab01 13/02/2017 Gestisco il nuovo campo pec della coimcitt.

    san01 21/07/2016 Aggiunto warning per avvisare l'esistenza di un altro soggetto con lo
    san01            stesso codice fiscale. Aggiunto campo flag_confermato.

    sim01 05/11/2014 Corretto errore su link ritorna

    nic01 13/10/2014 Per Ucit, la Paravan vuole che questo programma non possa essere usato
    nic01            per modificare i soggetti dell'impianto se richiamato dal link dei dati
    nic01            di testata dell'impianto dagli utenti con id_ruolo manutentore o
    nic01            verificatore.
    san01 29/05/2018 Inserito controlli su cap e provincia

} { 
   {cod_cittadino    ""}
   {last_concat_key  ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
   {url_citt         ""}
   {flag_java        ""}
   {flag_mod         ""}
   {flag_ins_manu    ""}
   {cod_impianto     ""}
   
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

set current_date  [iter_set_sysdate]
iter_get_coimtgen
set flag_ente     $coimtgen(flag_ente)
set denom_comune  $coimtgen(denom_comune)
set link_cap      $coimtgen(link_cap)

if {![string is space $nome_funz]} {
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

db_1row query "select id_ruolo from coimuten where id_utente = :id_utente";#nic01
set sw_esponi_tasto_submit "t";#nic01
if {   ($coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO")
    &&  $caller   eq "impianto"
    && ($id_ruolo eq "manutentore" || $id_ruolo eq "verificatore")
} {#nic01
    set sw_esponi_tasto_submit "f";#nic01
};#nic01

if {$id_ruolo eq "manutentore"} {#rom03 aggiunte if, else e loro contenuto
    set link_impianti "f"
} else {
    set link_impianti "t"
};#rom03

iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {$funzione != "I"
&&  [string equal $url_citt ""]
} {
    set url_citt [list [ad_conn url]?[export_ns_set_vars url ]]
}

set prime_2 [string range $cod_cittadino 0 1]

#sim01 set link_gest [export_url_vars cod_cittadino flag_mod last_concat_key caller nome_funz extra_par url_citt]
set link_gest [export_url_vars cod_cittadino cod_impianto flag_mod last_concat_key caller nome_funz extra_par url_citt];#sim01
set link_aimp "coimaimp-list?nome_funz=impianti&[export_url_vars nome_funz_caller cod_cittadino url_citt]"

# Personalizzo la pagina
set link_list_script {[export_url_vars last_concat_key caller flag_ins_manu nome_funz]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Soggetto"
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

if {$flag_java != "t"} {
    if {$flag_mod == "t"} {
	set context_bar [iter_context_bar \
 		        [list "javascript:window.close()" "Chiudi Finestra"] \
                        "$page_title"]
    } else {
	if {$caller == "index"} {
	    set context_bar  [iter_context_bar -nome_funz $nome_funz]
	} else {
	    set context_bar  [iter_context_bar \
			     [list "javascript:window.close()" "Torna alla Gestione"] \
                             [list coimcitt-list?$link_list "Lista Soggetti"] \
                             "$page_title"]
	}
    }
} else {
    set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Chiudi Finestra"] \
                    "$page_title"]
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcitt"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set readonly_man "readonly"
set disabled_man "disabled"
set onsubmit_cmd ""
switch $funzione {
    "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set disabled_fld \{\}
	set readonly_man \{\}
	set disabled_man \{\}
    }
    "M" {
	set readonly_fld \{\}
	set disabled_fld \{\}
	if {![string equal $flag_ins_manu ""]} {
	    set readonly_man "readonly"
	    set disabled_man "disabled"
	} else {
	    set readonly_man \{\}
	    set disabled_man \{\}
	}
    }
}
    
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}


form create $form_name \
-html    $onsubmit_cmd

element create $form_name natura_giuridica \
-label   "Natura giuridica" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {Fisica F} {Giuridica G}}

element create $form_name sesso \
-label   "Sesso" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {M M} {F F}}


element create $form_name cognome \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_man {} class form_element" \
-optional

element create $form_name nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_man {} class form_element" \
-optional

element create $form_name indirizzo \
-label   "Indirizzo" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_man {} class form_element" \
-optional

element create $form_name numero \
-label   "Nr. civico" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_man {} class form_element" \
-optional

#rom10 Messo readonly_fld al posto di readonly_man
element create $form_name cap \
-label   "C.A.P." \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional

element create $form_name localita \
-label   "Localit&agrave;" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_man {} class form_element" \
-optional

element create $form_name comune \
-label   "Comune" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_man {} class form_element" \
-optional

if {$funzione == "I"
||  $funzione == "M"
} {
   set link_comune [iter_search  coimcitt [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 dummy search_word comune dummy_2 provincia dummy_3 cap]]
} else {
    set link_comune ""
}

element create $form_name provincia \
-label   "Provincia" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 $readonly_man {} class form_element" \
-optional

element create $form_name cod_fiscale \
-label   "Cod. Fiscale" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
-optional
#rom01
element create $form_name cod_piva  \
    -label "P. IVA" \
    -widget text\
    -datatype text \
    -html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
    -optional

element create $form_name telefono \
-label   "Telefono" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name cellulare \
-label   "Cellulare" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name fax \
-label   "Fax" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 15 $readonly_fld {} class form_element" \
-optional
#rom05 modificata la maxlength del campo mail, prima era di 35, ora e' di 100
element create $form_name email \
-label   "E-mail" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional
#but01 Aggiunto la classe ah-jquery-date ai campo data.
element create $form_name data_nas \
-label   "Data di nascita" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name comune_nas \
    -label   "Comune di nascita" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I"
    ||  $funzione == "M"
} {
    set link_comune_nas [iter_search coimcitt [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 dummy search_word comune_nas dummy_2 dummy dummy_3 dummy]]
} else {
    set link_comune_nas ""
}

element create $form_name denominazione \
    -label   "Stato di nascita" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "I"
    ||  $funzione == "M"
} {
    set link_stato_nas [iter_search  coimcitt [ad_conn package_url]/tabgen/coimstat-list [list cod_stato cod_stato search_word denominazione ] ]
} else {
    set link_stato_nas ""
}


element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 2 $readonly_fld {} class form_element" \
-optional

element create $form_name stato_citt \
-label   "Stato utente" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{"Attivo" A} {"Non Attivo" N}}

#gab01 aggiunto il campo pec
#rom06 Modificata la maxlength del campo pec da 35 a 100
element create $form_name pec \
-label   "Pec" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional

if {[db_0or1row q "select 1 
                     from coimmanu
                    where cod_legale_rapp = :cod_cittadino
                    limit 1"]} {

    set flg_visualizza_patentino "t"

} else {

    set flg_visualizza_patentino "f"
}

#gac01 aggiunta if else e suo contenuto
if {$coimtgen(regione) eq "MARCHE" && $flg_visualizza_patentino eq "t"} {
    element create $form_name patentino \
        -label   "Patentino" \
        -widget   select \
        -datatype text \
        -html    "$disabled_fld {} class form_element" \
	-optional \
        -options {{Si t} {No f}}

    element create $form_name patentino_fgas \
        -label   "Patentino Fgas" \
        -widget   select \
        -datatype text \
        -html    "$disabled_fld {} class form_element" \
	-optional \
        -options {{{Si} {t}} {{No} {f}}}
} else {
    element create $form_name patentino -widget hidden -datatype text -optional
    element create $form_name patentino_fgas -widget hidden -datatype text -optional
    if {$funzione eq "I"} {#altrimenti andava in errore per il not null constraint
	set patentino      "f"
	set patentino_fgas "f"
        element set_properties $form_name patentino        -value $patentino
        element set_properties $form_name patentino_fgas   -value $patentino_fgas
    }
}

element create $form_name cod_cittadino    -widget hidden -datatype text -optional
element create $form_name flag_mod         -widget hidden -datatype text -optional
element create $form_name url_citt         -widget hidden -datatype text -optional
element create $form_name dummy            -widget hidden -datatype text -optional
element create $form_name funzione         -widget hidden -datatype text -optional
element create $form_name caller           -widget hidden -datatype text -optional
element create $form_name nome_funz        -widget hidden -datatype text -optional
element create $form_name extra_par        -widget hidden -datatype text -optional
element create $form_name last_concat_key  -widget hidden -datatype text -optional
#rom01element create $form_name cod_piva         -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name flag_ins_manu    -widget hidden -datatype text -optional
element create $form_name cod_stato        -widget hidden -datatype text -optional
element create $form_name cod_fiscale_orig -widget hidden -datatype text -optional;#san01
element create $form_name flag_confermato  -widget hidden -datatype text -optional;#san01
element create $form_name cod_piva_orig    -widget hidden -datatype text -optional;#rom01
element create $form_name submit           -widget submit -datatype text -label "$button_label" -html "class form_submit"

element set_properties $form_name flag_mod            -value $flag_mod     

if {[form is_request $form_name]} {
    element set_properties $form_name url_citt        -value $url_citt
    element set_properties $form_name funzione        -value $funzione
    element set_properties $form_name caller          -value $caller
    element set_properties $form_name nome_funz       -value $nome_funz
    element set_properties $form_name extra_par       -value $extra_par
    element set_properties $form_name flag_ins_manu   -value $flag_ins_manu
    element set_properties $form_name last_concat_key -value $last_concat_key
    element set_properties $form_name cod_piva        -value ""
    element set_properties $form_name cod_impianto    -value $cod_impianto
    element set_properties $form_name flag_confermato -value "f";#san01

    if {$funzione == "I"} {
        if {$flag_ente == "C"} {
	    element set_properties $form_name comune     -value $denom_comune
	}
    } else {
      # leggo riga
        if {[db_0or1row sel_citt ""] == 0} {
            iter_return_complaint "Record non trovato"
	} else {
	    if {[db_0or1row query "select denominazione, cod_stato from coimstat where cod_stato = :stato_nas"] == 0} {
		set denominazione ""
                set cod_stato ""
	    }
	}
    
        element set_properties $form_name cod_cittadino    -value $cod_cittadino
        element set_properties $form_name natura_giuridica -value $natura_giuridica
        element set_properties $form_name sesso             -value $sesso
        element set_properties $form_name cognome          -value $cognome
        element set_properties $form_name nome             -value $nome
        element set_properties $form_name indirizzo        -value $indirizzo
        element set_properties $form_name numero           -value $numero
        element set_properties $form_name cap              -value $cap
        element set_properties $form_name localita         -value $localita
        element set_properties $form_name comune           -value $comune
        element set_properties $form_name provincia        -value $provincia
        element set_properties $form_name cod_fiscale      -value $cod_fiscale
        element set_properties $form_name cod_fiscale_orig -value $cod_fiscale;#san01
        element set_properties $form_name cod_piva         -value $cod_piva
        element set_properties $form_name cod_piva_orig    -value $cod_piva;#rom01
        element set_properties $form_name telefono         -value $telefono
        element set_properties $form_name cellulare        -value $cellulare
        element set_properties $form_name fax              -value $fax
        element set_properties $form_name email            -value $email
        element set_properties $form_name data_nas         -value $data_nas
        element set_properties $form_name comune_nas       -value $comune_nas
        element set_properties $form_name cod_stato        -value $cod_stato
        element set_properties $form_name denominazione    -value $denominazione
        element set_properties $form_name note             -value $note
        element set_properties $form_name stato_citt       -value $stato_citt
        element set_properties $form_name cod_impianto     -value $cod_impianto
        element set_properties $form_name pec              -value $pec;#gab01
        element set_properties $form_name patentino        -value $patentino;#gac01
        element set_properties $form_name patentino_fgas   -value $patentino_fgas;#gac01
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_cittadino    [string trim [element::get_value $form_name cod_cittadino]]
    set natura_giuridica [string trim [element::get_value $form_name natura_giuridica]]
    set sesso            [string trim [element::get_value $form_name sesso]]
    set cognome          [string trim [element::get_value $form_name cognome]]
    set nome             [string trim [element::get_value $form_name nome]]
    set indirizzo        [string trim [element::get_value $form_name indirizzo]]
    set numero           [string trim [element::get_value $form_name numero]]
    set cap              [string trim [element::get_value $form_name cap]]
    set localita         [string trim [element::get_value $form_name localita]]
    set comune           [string trim [element::get_value $form_name comune]]
    set provincia        [string trim [element::get_value $form_name provincia]]
    set cod_fiscale      [string trim [element::get_value $form_name cod_fiscale]]
    set cod_fiscale_orig [string trim [element::get_value $form_name cod_fiscale_orig]];#san01
    set cod_piva         [string trim [element::get_value $form_name cod_piva]]
    set cod_piva_orig    [string trim [element::get_value $form_name cod_piva_orig]];#rom01
    set telefono         [string trim [element::get_value $form_name telefono]]
    set cellulare        [string trim [element::get_value $form_name cellulare]]
    set fax              [string trim [element::get_value $form_name fax]]
    set email            [string trim [element::get_value $form_name email]]
    set data_nas         [string trim [element::get_value $form_name data_nas]]
    set comune_nas       [string trim [element::get_value $form_name comune_nas]]
    set stato_nas        [string trim [element::get_value $form_name cod_stato]]
    set cod_stato        [string trim [element::get_value $form_name cod_stato]]
    set note             [string trim [element::get_value $form_name note]]
    set cod_impianto     [string trim [element::get_value $form_name cod_impianto]]
    set flag_mod         [string trim [element::get_value $form_name flag_mod]]
    set stato_citt       [string trim [element::get_value $form_name stato_citt]]
    set flag_confermato  [string trim [element::get_value $form_name flag_confermato]];#san01
    set pec              [string trim [element::get_value $form_name pec]];#gab01
    set patentino        [string trim [element::get_value $form_name patentino]];#gac01
    set patentino_fgas   [string trim [element::get_value $form_name patentino_fgas]];#gac01

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {
	
	if {$funzione == "M"} {
	    db_1row sel_manu_count ""
	    if {$conta_manu < 0} {
		element::set_error $form_name cognome "Impossibile Modificare il soggetto: è legale rappresentante di una ditta di Manutenzione. Il dato è aggiornato direttamente dall'Ente"
		incr error_num
	    }
	}
	
	if {[string equal $cognome ""]} {
	    element::set_error $form_name cognome "Inserire cognome/rag sociale"
	    incr error_num
	}
	
        if {![string equal $data_nas ""]} {
            set data_nas [iter_check_date $data_nas]
            if {$data_nas == 0} {
                element::set_error $form_name data_nas "Data di nascita deve essere una data"
                incr error_num
            } else {
		if {$data_nas > $current_date} {
		    element::set_error $form_name data_nas "Data di nascita deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }

        if {[string equal $comune ""]} {
	    element::set_error $form_name comune "Inserire comune"
	    incr error_num
	}

	if {$coimtgen(regione) eq "MARCHE"} {	
	    #rom100 il codice fiscale e' obbligatorio se il soggetto e' un responsabile. Solo per le Marche-- aggiunta if regione marche da sandro in quanto mancante
	    if {[db_0or1row q "select 1
                             from coimaimp
                            where cod_responsabile = :cod_cittadino
                           having count(*) >= 1"] == 1
		&& $cod_fiscale eq "" && $natura_giuridica eq "F"} {#rom100 aggiunta if e suo contenuto
		element::set_error $form_name cod_fiscale "Inserire il Codice Fiscale.<br>Il soggetto &egrave; il Responsabile di almeno un Impianto"
		incr error_num
	    }
		
	    if {[db_0or1row q "select 1
                             from coimaimp
                            where cod_responsabile = :cod_cittadino
                           having count(*) >= 1"] == 1
		&& $cod_piva eq "" && $natura_giuridica eq "G"} {
		element::set_error $form_name cod_piva "Inserire la Partita Iva.<br>Il soggetto &egrave; il Responsabile di almeno un Impianto"
		incr error_num
	    }
	
	}

	if {$stato_nas == 1} {
	    set id_belfiore  [db_string query "select id_belfiore from coimcomu where denominazione = :comune_nas" -default ""]
	    if {$cod_fiscale == "" && $cognome != "" && $nome != "" && $data_nas != "" && $comune_nas != "" && $sesso != ""} {
		ns_log notice "coimcitt-gest;$cognome $nome $sesso $data_nas $id_belfiore $cod_fiscale"
		if {$id_belfiore != ""} { 
		    set cod_fiscale [iter_creacf $cognome $nome $sesso $data_nas $id_belfiore]
		}
	    }
	    ns_log notice "coimcitt-gest;$cod_fiscale $sesso"
	    
	    if {[regexp {[^A-Za-z0-9]+} $cod_fiscale] > 0 } {
		element::set_error $form_name cod_fiscale "L'identificatore fiscale contiena caratteri non validi"
		incr error_num
	    }
	    
	    set cod_fiscale [string toupper $cod_fiscale]
	    
	    if {[string equal $cod_fiscale "XXXXXXXXXXXXXXXX"]} {
		element::set_error $form_name cod_fiscale "Inserire codice fiscale corretto"
		incr error_num
	    }
	    
	    if {[string equal $cod_fiscale ""]} {
		db_1row query "select id_ruolo from coimuten where id_utente =:id_utente" 
		#rom07 modificata if per aggiungere il ruolo utente.
		if {!($id_ruolo in [list "admin" "utente"])} {
		    element::set_error $form_name cod_fiscale "Inserire codice fiscale o partita iva"
		    incr error_num
		}
	    } else {
		set lcf [string length $cod_fiscale]
		if {$lcf != 16 && $lcf != 11} {
		    element::set_error $form_name cod_fiscale "Lunghezza errata"
		    incr error_num
		} elseif {$lcf == 16 && [iter::verifyfc -xcodfis $cod_fiscale] == 0} {
		    element::set_error $form_name cod_fiscale "Codice fiscale errato"
		    incr error_num
		} elseif {$lcf == 11 && [iter::verifyvc -xcodfis $cod_fiscale] == 0} {
		    element::set_error $form_name cod_fiscale "Codice fiscale errato"
		    incr error_num
		}
	    }
	    #rom01 aggiunti controlli su cod_piva; copiati da iter-portal-dev.
	    if {$cod_piva ne ""} {
		set l [string length $cod_piva]
		if {$l != 11} {
		    element::set_error $form_name cod_piva "Lunghezza errata."
		    incr error_num
		} elseif {[iter::verifyvc -xcodfis $cod_piva] == 0} {
		    element::set_error $form_name cod_piva "Partita IVA errata."
		    incr error_num
		}
	    }
	}

        if {[string equal $indirizzo ""]} {
	    element::set_error $form_name indirizzo "Inserire Indirizzo"
	    incr error_num
	}

        if {[string equal $cap ""]} {
	    element::set_error $form_name cap "Inserire cap"
	    incr error_num
	}


        if {[string equal $provincia ""]} {
	    element::set_error $form_name provincia "Inserire provincia"
	    incr error_num
	}

        if {[string equal $natura_giuridica ""]} {
	    element::set_error $form_name natura_giuridica "Inserire Natura Giuridica"
	    incr error_num
	}

	#rom09 Modificata if per aggiungere regione Marche
	if {!($coimtgen(regione) in [list "FRIULI-VENEZIA GIULIA" "MARCHE"])} {#rom08 Aggiunta if ma non il suo contenuto

	    if {[string equal $natura_giuridica "F"] && ![string equal $cod_piva ""]} {#ric01 Aggiunta if e contenuto
		element::set_error $form_name cod_piva "Per le persone fisiche non va indicata la P.IVA"
		incr error_num
	    }
	    
	    if {[string equal $natura_giuridica "G"] && ![string equal $cod_fiscale ""]} {#ric01 Aggiunta if e contenuto
		element::set_error $form_name cod_fiscale "Per le persone giuridiche non va indicato il Cod.Fisc."
		incr error_num
	    }
	    
	};#rom08
	
	if {$error_num       == 0
	&&  $cod_fiscale     ne ""
	&&  $flag_confermato eq "f"
        && ($funzione eq "I" || ($funzione eq "M" && $cod_fiscale ne $cod_fiscale_orig))
	} {#san01: aggiunta if e suo contenuto
	    if {$funzione eq "I"} {
		set and_cod_cittadino      ""
		set inserimento_o_modifica "l'inserimento"
	    } else {
		set and_cod_cittadino           "and cod_cittadino <> :cod_cittadino"
		set inserimento_o_modifica "la modifica"
	    }
	    
	    if {$coimtgen(ente) eq "PPA"} {#ric01 aggiunti if, else e loro contenuto
		set cod_fisc_error_msg "Attenzione, esiste un altro soggetto con lo stesso codice fiscale."
		set cod_fisc_conf_value "f"
	    } else {
		set cod_fisc_error_msg "Attenzione, esiste un altro soggetto con lo stesso codice fiscale.<br>Confermi $inserimento_o_modifica?"
		set cod_fisc_conf_value "t"	
	    };#ric01
	    
	    if {[db_0or1row query "
                select 1
                  from coimcitt
                 where cod_fiscale = upper(:cod_fiscale)
                   and stato_citt  = 'A'
                  $and_cod_cittadino
                 limit 1"]
	    } {
		#ric01 element::set_error $form_name cod_fiscale "Attenzione, esiste un altro soggetto con lo stesso codice fiscale.<br>Confermi $inserimento_o_modifica?"
		element::set_error $form_name cod_fiscale $cod_fisc_error_msg;#ric01
		incr error_num
		
		#ric01 element set_properties $form_name flag_confermato -value "t"
		element set_properties $form_name flag_confermato -value $cod_fisc_conf_value;#ric01
	    }
	}
	if {$error_num       == 0   &&
	    $cod_piva        ne ""  &&
	    $flag_confermato eq "f" &&
	    ($funzione eq "I" || ($funzione eq "M" && $cod_piva ne $cod_piva_orig))
        } {#rom01: aggiunta if e suo contenuto
            if {$funzione eq "I"} {
                set and_cod_cittadino      ""
                set inserimento_o_modifica "l'inserimento"
            } else {
                set and_cod_cittadino           "and cod_cittadino <> :cod_cittadino"
                set inserimento_o_modifica "la modifica"
            }

	    if {$coimtgen(ente) eq "PPA"} {#ric01 aggiunti if, else e loro contenuto
		set cod_piva_error_msg "Attenzione, esiste un altro soggetto con la stessa Partita IVA."
		set cod_piva_conf_value "f"
	    } else {
		set cod_piva_error_msg "Attenzione, esiste un altro soggetto con la stessa Partita IVA.<br>Confermi $inserimento_o_modifica?"
		set cod_piva_conf_value "t"
	    };#ric01
	    
            if {[db_0or1row query "
                select 1
                  from coimcitt
                 where cod_piva = upper(:cod_piva)
                   and stato_citt  = 'A'
                  $and_cod_cittadino
                 limit 1"]
            } {
                #ric01 element::set_error $form_name cod_piva "Attenzione, esiste un altro soggetto con la stessa Partita IVA.<br>Confermi $inserimento_o_modifica?"
		element::set_error $form_name cod_piva $cod_piva_error_msg;#ric01		
                incr error_num

		#ric01 element set_properties $form_name flag_confermato -value "t"
		element set_properties $form_name flag_confermato -value $cod_piva_conf_value;#ric01
            }
        }
    }

    if {$funzione == "I"
    &&  $error_num == 0
    &&  [db_0or1row sel_citt_chk ""] == 1
    } {
      # controllo univocita'/protezione da double_click
        element::set_error $form_name cognome "Il record che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base."
        incr error_num
    }

    if {$funzione == "D"} {
	db_1row sel_aimp_count ""
	db_1row sel_manu_count ""

	set conta_dope 0;#rom02
	db_1row a "select count(*) as conta_dope
                     from coimdope_aimp
                    where cod_responsabile = :cod_cittadino";#rom02
	set conta_cimp 0;#rom02
	db_1row a "select count(*) as conta_cimp
                     from coimcimp
                    where cod_responsabile = :cod_cittadino";#rom02
	set conta_dimp 0;#rom02
	 db_1row a "select count(*) as conta_dimp
                     from coimdimp
                    where cod_responsabile   = :cod_cittadino
                       or cod_proprietario   = :cod_cittadino
                       or cod_occupante      = :cod_cittadino";#rom02
	set sw_msg_error f;#rom04
	set msg_error "Impossibile cancellare il soggetto:<br>";#rom02
	if {$conta_aimp > 0
	    || $conta_manu > 0} {
	    #rom02element::set_error $form_name cognome "Impossibile cancellare il soggetto: ha degli impianti collegati o &egrave; legato a una ditta come legale rappresentante"
	    set sw_msg_error t;#rom04 
	    append msg_error "Ha degli impianti collegati o &egrave; legato a una ditta come legale rappresentante.<br>"
	    incr error_num
	}
	if {$conta_dope > 0} {#rom02 aggiunta if e suo contenuto
            set sw_msg_error t;#rom04
	    append msg_error "&Egrave; stato inserito come responsabile su delle DFM.<br>"
	    incr error_num
	}
	if {$conta_cimp > 0} {#rom02 aggiunta if e suo contenuto
            set sw_msg_error t;#rom04
	    append msg_error  "&Egrave; stato inserito come responsabile su dei Rapporti di Ispezione.<br>"
	    incr error_num
        }
        if {$conta_dimp  > 0} {#rom02 aggiunta if e suo contenuto
            set sw_msg_error t;#rom04
            append msg_error "Ha degli RCEE collegati.<br>"
	    incr error_num
	}
	if {$sw_msg_error eq "t"} {#rom04: aggiunta if e suo contenuto
	    element::set_error $form_name cognome "$msg_error"
	}
    }

    if {$error_num > 0} {
	#rom04element::set_error $form_name cognome "$msg_error"
        ad_return_template
        return
    }

    if {[string equal $stato_nas ""]} {
	set stato_nas "1"
    }

    switch $funzione {
        I { db_1row sel_cod ""
           set dml_sql [db_map ins_citt]
        }
        M { set dml_sql [db_map mod_citt] }
        D { set dml_sql [db_map del_citt] }
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {

        with_catch error_msg {
            db_transaction {

                db_dml dml_coimcitt $dml_sql
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
	#     per ora evito di fare il posizionamento perche' a causa del filtro
	#     non troverei nulla
	#     set last_concat_key  [list $cognome $nome $cod_cittadino]
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_cittadino flag_mod flag_ins_manu cod_impianto last_concat_key nome_funz caller extra_par url_citt]
    switch $funzione {
        M {
	    if {[string equal $flag_ins_manu ""]} {
		set return_url   "coimcitt-gest?funzione=V&$link_gest"
	    } else {
		set return_url   "coimcitt-list?funzione=V&$link_list"
	    }
	}
        D {set return_url   "coimcitt-list?$link_list"}
        I {set return_url   "coimcitt-gest?funzione=V&$link_gest"}
        V {set return_url   "coimcitt-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
