ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcitt"
    @author          Giulio Laurenzi
    @creation-date   06/02/2006

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimcitt-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom06 22/11/2024 Su richiesta di Frosinone ai non manutentori è stata data la possibilità
    rom06            di inserire soggetti senza il codice fiscale. Sandro ha detto che va bene
    rom06            per tutti gli enti questa modifica.

    rom05 18/06/2024 Corretto controllo sul C.A.P., veniva mostrato un messaggio di errore se
    rom05            il primo numero era uno 0

    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campo data_nas

    rom04 07/02/2023 Corretto intervento di ric01 sulla conferma dell'inserimento di soggetti
    rom04            con codice fiscale o partita iva gia' presenti.

    rom03 01/02/2023 Modificato intervento di ric01 per anomalie riscontrate su Ucit, aggiunto
    rom03            il campo cod_piva in visualizzazione, prima era hidden.

    ric01 21/12/2022 Gestito element cod_fiscale che valorizza cod_fiscale o cod_piva a seconda
    ric01            della natura giuridica, aggiunto i relativi controlli anche sulla non
    ric01            ripetibilità del dato.

    rom02 04/08/2020 Modificata la maxlenght del campo pec da 35 a 100 su richiesta di Sandro.

    rom01 01/07/2020 Modificata la maxlenght del campo mail da 35 a 100 su richiesta di Sandro.

    gab01 13/02/2017 Gestisco il nuovo campo pec della coimcitt.
    sandro 29/05/2017 inseriti controlli su cap, provincia e natura giuridica

} { 

   {funzione        "I"}
   {caller           ""}
   {cognome          ""}
   {nome             ""}
   {nome_funz        ""}
   {localita         ""}
   {descr_via        ""}
   {descr_topo       ""}
   {numero           ""}
   {cap              ""}
   {provincia        ""}
   {cod_comune       ""}
   {cod_cittadino    ""}
   {cod_manutentore  ""}
   {flag_ins_prop    ""}
   {flag_ins_terzi    ""}
   {receiving_element ""}
   {flag_java        ""}
   {flag_modello_h    ""}
   {nome_funz_caller ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


ns_log notice "prova   dob parametri: cognome $cognome nome $nome nome_funz $nome_funz localita $localita descr_via $descr_via descr_topo $descr_topo numero $numero cap $cap provincia $provincia cod_comune $cod_comune flag_ins_prop $flag_ins_prop receiving_element $receiving_element flag_modello_h $flag_modello_h"



# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

iter_get_coimtgen
set flag_ente     $coimtgen(flag_ente)
set denom_comune  $coimtgen(denom_comune)

set id_utente     [lindex [iter_check_login $lvl $nome_funz] 1]
iter_set_func_class $funzione
set id_utente_manu [iter_check_uten_manu $id_utente];#rom06
# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_gest [export_url_vars extra_par caller nome_funz receiving_element]
set link_list_script {[export_url_vars  caller nome_funz]}
set link_list        [subst $link_list_script]
set titolo           "Soggetto"

set js_function ""
switch $funzione {
    I {set button_label "Conferma Inserimento"
       set page_title   "Inserimento $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizzazione $titolo"


	##### SCRIPT PER IL RITORNO #######
	set receiving_element [split $receiving_element |]
	if {[string equal $localita ""]} {
	        set localita " "
	}
	if {[string equal $cap ""]} {
	        set cap " "
	}
	if {[string equal $numero ""]} {
	        set numero " "
	}
	if {[string equal $nome ""]} {
	        set nome " "
	}
	if {[string equal $descr_via ""]} {
	        set descr_via " "
	}
	if {[string equal $provincia ""]} {
	        set provincia " "
	}

	if {$flag_modello_h == "T"} {
	    set js_function [iter_selected_2 $caller [list [lindex $receiving_element 0] $cognome [lindex $receiving_element 1] $nome [lindex $receiving_element 2] $nome_funz [lindex $receiving_element 3] $cod_cittadino] [lindex $receiving_element 4] $flag_modello_h]
	} else {   
	    set js_function [iter_selected_2 $caller [list [lindex $receiving_element 0] $cognome [lindex $receiving_element 1] $nome [lindex $receiving_element 2] $nome_funz [lindex $receiving_element 3] $localita [lindex $receiving_element 4] $descr_via [lindex $receiving_element 5] $descr_topo [lindex $receiving_element 6] $numero [lindex $receiving_element 7] $cap [lindex $receiving_element 8] $provincia [lindex $receiving_element 9] $cod_comune [lindex $receiving_element 10] $cod_cittadino]]
	}

        ##################################
    }
}

set context_bar [iter_context_bar \
                [list "window.close()" "Chiudi Finestra"] \
                "$page_title"]


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimcitt"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""

set readonly_key \{\}
set readonly_fld \{\}
set disabled_fld \{\}

# 15/01/2007: Effettuata modifica sul controllo dei campi da tenere readonly:
#             Ora il controllo viene fatto non solo su flag_ins_prog ma anche su
#             flag_ins_terzi, poichè nella paginadi inserimento nuovo impianto è stata
#             aggiunta la possibilità di inserire un nuovo soggetto dal form dei terzi.
#             Se entrambi i campi sono "", allora gli attributi vengono mantenuti readonly.
#             In caso contrario i campi vengono resi editabili.
#if {[string equal $flag_ins_prop ""] && [string equal $flag_ins_terzi ""] && [string equal $cod_manutentore ""]} {
#    set readonly_occ "readonly"
#} else {
    set readonly_occ \{\}
#}
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
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {Fisica F} {Giuridica G}}

element create $form_name sesso \
-label   "Sesso" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {M M} {F F}}

element create $form_name cognome \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_occ {} class form_element" \
-optional

element create $form_name nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 100 $readonly_occ {} class form_element" \
-optional

element create $form_name indirizzo \
-label   "Indirizzo" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_occ {} class form_element" \
-optional

element create $form_name cap \
-label   "C.A.P." \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_occ {} class form_element" \
-optional

element create $form_name localita \
-label   "Localit&agrave;" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_occ {} class form_element" \
-optional

element create $form_name comune \
-label   "Comune" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_occ {} class form_element" \
-optional

#if {$funzione == "I"
#||  $funzione == "M"
#} {
#   set link_comune [iter_search  coimcitt [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 dummy search_word comune dummy_2 provincia dummy_3 cap]]
#} else {
    set link_comune ""
#}

element create $form_name provincia \
-label   "Provincia" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 $readonly_occ {} class form_element" \
-optional

element create $form_name cod_fiscale \
-label   "Cod. Fiscale" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
-optional

#rom03
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
-html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
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

element create $form_name email \
-label   "E-mail" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional
#but01  Aggiunto la classe ah-jquery-date ai campo data_nas
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

#gab01 aggiunto il campo pec
#rom01 Modificata la maxlenght del campo pec da 35 a 100.
element create $form_name pec \
-label   "Pec" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional

if {$funzione == "I"
||  $funzione == "M"
} {
    set link_comune_nas [iter_search coimcitt [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 dummy search_word comune_nas dummy_2 dummy dummy_3 dummy]]
} else {
    set link_comune_nas ""
}

element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 2 $readonly_fld {} class form_element" \
-optional

element create $form_name dummy     -widget hidden -datatype text -optional
element create $form_name numero     -widget hidden -datatype text -optional
element create $form_name flag_ins_prop -widget hidden -datatype text -optional
element create $form_name flag_confermato  -widget hidden -datatype text -optional;#rom04
element create $form_name cod_manutentore -widget hidden -datatype text -optional
element create $form_name flag_ins_terzi -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
#rom03element create $form_name cod_piva  -widget hidden -datatype text -optional
element create $form_name descr_via  -widget hidden -datatype text -optional
element create $form_name descr_topo -widget hidden -datatype text -optional
element create $form_name cod_comune -widget hidden -datatype text -optional
element create $form_name receiving_element -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name flag_modello_h -widget hidden -datatype text -optional


if {[form is_request $form_name]} {
    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name flag_ins_prop  -value $flag_ins_prop
    element set_properties $form_name cod_manutentore  -value $cod_manutentore
    element set_properties $form_name flag_ins_terzi  -value $flag_ins_terzi
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name cod_piva  -value ""
    element set_properties $form_name receiving_element -value $receiving_element
    element set_properties $form_name flag_modello_h    -value $flag_modello_h    
    element set_properties $form_name flag_confermato -value "f";#rom04

    if {![string equal cod_comune ""]
    &&  [db_0or1row sel_comu_desc ""] == 0
    } {
	set comu_denom ""
    }

    if {[string equal $coimtgen(flag_ente) "C"]} {
	#se l'ente è un comune assegno alcuni default con i dati di ambiente
	set cod_comune $coimtgen(cod_comu)
	set comu_denom $coimtgen(denom_comune)
    }

    if {![string equal $cod_manutentore ""]} {
	set cognome "Legale rapp. di $cognome"
    }

    element set_properties $form_name comune     -value $comu_denom
    element set_properties $form_name cognome          -value $cognome
    element set_properties $form_name nome             -value $nome
    element set_properties $form_name descr_via        -value $descr_via
    element set_properties $form_name descr_topo       -value $descr_topo
    element set_properties $form_name cod_comune       -value $cod_comune
    element set_properties $form_name indirizzo        -value "$descr_topo $descr_via, $numero"
    element set_properties $form_name numero           -value $numero
    element set_properties $form_name cap              -value $cap
    element set_properties $form_name localita         -value $localita
    element set_properties $form_name provincia        -value $provincia

}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

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
    set cod_piva         [string trim [element::get_value $form_name cod_piva]]
    set telefono         [string trim [element::get_value $form_name telefono]]
    set cellulare        [string trim [element::get_value $form_name cellulare]]
    set fax              [string trim [element::get_value $form_name fax]]
    set email            [string trim [element::get_value $form_name email]]
    set data_nas         [string trim [element::get_value $form_name data_nas]]
    set comune_nas       [string trim [element::get_value $form_name comune_nas]]
    set note             [string trim [element::get_value $form_name note]]
    set pec              [string trim [element::get_value $form_name pec]];#gab01    

    set cod_comune       [string trim [element::get_value $form_name cod_comune]]
    set descr_via        [string trim [element::get_value $form_name descr_via]]
    set descr_topo       [string trim [element::get_value $form_name descr_topo]]
    set flag_confermato  [string trim [element::get_value $form_name flag_confermato]];#rom04

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	if {[string equal $cognome ""]} {
	    element::set_error $form_name cognome "Inserire cognome/rag sociale"
	    incr error_num
	}

        if {[string equal $indirizzo ""]} {
	    element::set_error $form_name indirizzo "Inserire Indirizzo"
	    incr error_num
	}

        if {[string equal $comune ""]} {
	    element::set_error $form_name comune "Inserire comune"
	    incr error_num
	}

        if {![string equal $data_nas ""]} {
            set data_nas [iter_check_date $data_nas]
            if {$data_nas == 0} {
                element::set_error $form_name data_nas "Data di nascita deve essere una data"
                incr error_num
            }
        }
	#rom05 sostituito [string is integer $cap] con [string is digit $cap]
        if {![string equal $cap ""]
        &&  ![string is digit $cap]
	} {
	    element::set_error $form_name cap "Il C.A.P. deve essere un valore numerico"
	    incr error_num
	}        

	if {[regexp {[^A-Za-z0-9]+} $cod_fiscale] > 0 } {
	    element::set_error $form_name cod_fiscale "L'identificatore fiscale contiena caratteri non validi"
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

	if {![string equal $id_utente_manu ""]} {#rom06 Aggiunta if ma non il contenuto
	    if {[string equal $cod_fiscale ""] && [string equal $natura_giuridica "F"]} {
		element::set_error $form_name cod_fiscale "Inserire codice fiscale"
		incr error_num
	    }
	};#rom06

	if {[string equal $natura_giuridica "F"]} {#ric01 aggiunta if, else e loro contenuto
	    if {$cod_fiscale ne ""} {#ric01 controlli su codice fiscale
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
		
		if {$coimtgen(ente) eq "PPA"} {#ric01 aggiunti if, else e loro contenuto
		    set cod_fisc_error_msg "Attenzione, esiste un altro soggetto con lo stesso codice fiscale."
		    set cod_fisc_conf_value "f"
		} else {
		    set cod_fisc_error_msg "Attenzione, esiste un altro soggetto con lo stesso codice fiscale.<br>Confermi l'inserimento?"
		    set cod_fisc_conf_value "t"	
		};#ric01

		#ric01 controllo che il codice fiscale non sia già registrato per un altro soggetto
		#rom04 Aggiunte condizioni su error_num e flag_confermato
		if {[db_0or1row query "
                                       select 1
                                         from coimcitt
                                        where cod_fiscale = upper(:cod_fiscale)
                                          and stato_citt  = 'A'
                                           limit 1"]
		    && $error_num       == 0
		    && $flag_confermato eq "f"
		} {
		    element::set_error $form_name cod_fiscale $cod_fisc_error_msg;#ric01
		    incr error_num
		    
		    element set_properties $form_name flag_confermato -value $cod_fisc_conf_value;#ric01
		};#ric01
	    }
	    
	    #rom03set cod_fiscale $cod_fiscale
	    #rom03set cod_piva ""

	} else {#ric01 sono natura 'Giuridica' valorizzo la partita IVA
	    
	    #ric01 aggiunti controlli su cod_piva; copiati da coimcitt-gest
	    #rom03 Ora che mostro anche il campo cod_piva vado a usare la relativa variabile
	    if {$cod_piva ne ""} {
                set l [string length $cod_piva]
                if {$l != 11} {
                    element::set_error $form_name cod_piva "Lunghezza errata."
                    incr error_num
                } elseif {[iter::verifyvc -xcodfis $cod_piva] == 0} {
                    element::set_error $form_name cod_piva "Partita IVA errata."
                    incr error_num
                }
		
		if {$coimtgen(ente) eq "PPA"} {#ric01 aggiunti if, else e loro contenuto
		    set cod_piva_error_msg "Attenzione, esiste un altro soggetto con la stessa Partita IVA."
		    set cod_piva_conf_value "f"
		} else {
		    set cod_piva_error_msg "Attenzione, esiste un altro soggetto con la stessa Partita IVA.<br>Confermi l'inserimento?"
		    set cod_piva_conf_value "t"
		};#ric01

		#ric01 controllo che la Partita IVA non sia già registrata per un altro soggetto
                #rom04 Aggiunte condizioni su error_num e flag_confermato
		if {[db_0or1row query "
                                       select 1
                                         from coimcitt
                                        where cod_piva = upper(:cod_piva)
                                          and stato_citt  = 'A'
                                         limit 1"]
                    && $error_num       == 0
                    && $flag_confermato eq "f"
		} {
		    
		    element::set_error $form_name cod_piva $cod_piva_error_msg;#ric01		
		    incr error_num
		    
		    element set_properties $form_name flag_confermato -value $cod_piva_conf_value;#ric01
		}
		
	    }
	    
	    #rom03set cod_fiscale ""
            #rom03set cod_piva $cod_fiscale

	};#ric01
	
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set stato_citt "A";#Attivo

    db_1row sel_cod ""
    set dml_sql [db_map ins_citt]

    if {![string equal $cod_manutentore ""]} {
        set dml_sql_manu [db_map upd_manu]
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimcitt $dml_sql
		if {[info exists dml_sql_manu]} {
		    db_dml dml_coimmanu $dml_sql_manu
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
    set link_list      [subst $link_list_script]


    set link_gest      [export_url_vars nome_funz nome_funz_caller caller receiving_element cognome nome descr_via descr_topo localita numero cap provincia cod_comune cod_cittadino]
    #set link_gest      [export_url_vars nome_funz nome_funz_caller caller receiving_element cognome nome descr_via descr_topo localita cap provincia cod_comune cod_cittadino]


    switch $funzione {
        I {set return_url   "coimcitt-isrt?funzione=V&$link_gest"}
    }

#        V {set return_url   "coimcitt-list?$link_list"}

    ad_returnredirect $return_url
    ad_script_abort
}
ad_return_template
