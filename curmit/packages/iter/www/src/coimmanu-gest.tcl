ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimmanu"
    @author          Giulio Laurenzi
    @creation-date   27/02/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimmanu-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom02 21/04/2023 Regione Friuli aggiunta opzione Manut/Inst solo Clim.Estiva/Biomassa Legnosa nel campo Ruolo

    rom01 05/05/2019 Aggiunto link link_tpin per la gestione delle tipologie d'Impianto su
    rom01            cui l'Impresa e' abilitata a lavorare.

    sim05 03/07/2017 Per il comune di trieste il codice dei manutentori deve essere paddato
    sim05            con gli zeri per seguire il formato presente su Udine anche se non ererdita
    sim05            i manutentori dal portale

    sim04 10/03/2017 Aggiunto campo patentino_fgas

    sim03 08/03/2017 Aggiunto opzioni Manut/Inst solo Clim.Estiva e Manut/Inst solo Biomassa Legnosa nel 
    sim03            campo Ruolo.

    sim02 28/06/2016 Aggiunto campo patentino

    sim01 07/02/2016 Aggiunta gestione del portafoglio

} {
    
   {cod_manutentore ""}
   {cod_legale_rapp_old ""}
   {last_cognome ""}
   {funzione  "V"}
   {caller    "index"}
   {nome_funz ""}
   {nome_funz_caller ""}
   {extra_par ""}
   {url_manu      ""}
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
set current_date      [iter_set_sysdate]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

iter_get_coimtgen
set link_cap      $coimtgen(link_cap)
set flag_ente     $coimtgen(flag_ente)
set sigla_prov    $coimtgen(sigla_prov)
set flag_portafoglio $coimtgen(flag_portafoglio)
set ente          $coimtgen(ente);#sim05

if {$funzione != "I"
&&  [string equal $url_manu ""]
} {
    set url_manu [list [ad_conn url]?[export_ns_set_vars url]]
}
if {$funzione != "I"} {
    set lung_man [string length $cod_manutentore]
}
set link_gest [export_url_vars cod_manutentore last_cognome nome_funz nome_funz_caller extra_par caller url_manu]
set link_opma [export_url_vars cod_manutentore nome_funz_caller]&nome_funz=opma&[export_url_vars url_manu]
set link_tpin [export_url_vars cod_manutentore nome_funz_caller]&nome_funz=manutentori&[export_url_vars url_manu];#rom01

iter_set_func_class $funzione

set url_manu [list [ad_conn url]?[export_ns_set_vars url ]]
set url_manu [export_url_vars url_manu]
set link_aimp "coimaimp-list?nome_funz=[iter_get_nomefunz coimaimp-list]&$url_manu&[export_url_vars nome_funz_caller cod_manutentore]"
set link_area "../tabgen/coimmtar-list?nome_funz=[iter_get_nomefunz coimmtar-list]&[export_url_vars cod_manutentore]"
set link_docu "coimdocu-list?nome_funz=[iter_get_nomefunz coimdocu-list]&[export_url_vars cod_manutentore nome_funz_caller]"

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cognome caller nome_funz nome_funz_caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "Manutentore"
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

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
                     [list "javascript:window.close()" "Torna alla Gestione"] \
                     [list coimmanu-list?$link_list "Lista Manutentori"] \
                     "$page_title"]
}



#preparo il link al programma di gestione dei bollini
set link_bollini    [export_url_vars cod_manutentore nome_funz_caller]&nome_funz=[iter_get_nomefunz coimboll-list]

#preparo il link al programma di gestione dei contratti
#set link_contratti  [export_url_vars cod_manutentore nome_funz_caller]&nome_funz=[iter_get_nomefunz coimcoma-list]


set url_manu        [list [ad_conn url]?[export_ns_set_vars url]]
set url_manu        [export_url_vars url_manu]


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimmanu"
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

element create $form_name cod_manutentore \
-label   "Codice" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_key {} class form_element" \
-optional

element create $form_name cognome \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name indirizzo \
-label   "Indirizzo" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name localita \
-label   "Localita" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name provincia \
-label   "Provincia" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 $readonly_fld {} class form_element" \
-optional

element create $form_name cap \
-label   "C.A.P." \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional

element create $form_name comune \
-label   "Comune" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name cod_fiscale \
-label   "Cod. Fiscale" \
-widget   text \
-datatype text \
-html    "size 16 maxlength 16 $readonly_fld {} class form_element" \
-optional

element create $form_name cod_piva \
-label   "P. IVA" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 11 $readonly_fld {} class form_element" \
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
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name fax \
-label   "Fax" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name email \
-label   "E-mail" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name pec \
-label   "Pec" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name reg_imprese \
-label   "Reg. Imprese" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name localita_reg \
-label   "localit&agrave;  reg imp." \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name rea \
-label   "Rea" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name localita_rea \
-label   "Localit&agrave; Rea" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name capit_sociale \
-label   "Capitale sociale" \
-widget   text \
-datatype text \
-html    "size 14 maxlength 14 $readonly_fld {} class form_element" \
-optional

element create $form_name note \
-label   "Note" \
-widget   textarea \
-datatype text \
-html    "cols 50 rows 2 $readonly_fld {} class form_element" \
-optional

element create $form_name flag_convenzionato \
-label   "flag convenzionato" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N} }

element create $form_name prot_convenzione \
-label   "Protocollo convenzione" \
-widget   text \
-datatype text \
-html    "size 14 maxlength 14 $readonly_fld {} class form_element" \
-optional

element create $form_name prot_convenzione_dt \
-label   "Data protocollo convenzione" \
-widget   text \
-datatype text \
-html    "size 14 maxlength 14 $readonly_fld {} class form_element" \
-optional

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {#rom02 Aggiunta if, else e il loro contenuto

    set options_flag_ruolo [list {{} {}} {Manutentore M} {Installatore I} {Manutentore/Installatore T} {"Manut/Inst solo Clim.Estiva" E} {"Manut/Inst solo Biomassa Legnosa" L} {"Manut/Inst solo Clim.Estiva/Biomassa Legnosa" B}]

} else {

    set options_flag_ruolo [list {{} {}} {Manutentore M} {Installatore I} {Manutentore/Installatore T} {"Manut/Inst solo Clim.Estiva" E} {"Manut/Inst solo Biomassa Legnosa" L}]

}

element create $form_name flag_ruolo \
-label   "flag ruolo" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options $options_flag_ruolo

element create $form_name data_inizio \
-label   "Data inizio attivita" \
-widget   text \
-datatype text \
-html    "size 14 maxlength 14 $readonly_fld {} class form_element" \
-optional

element create $form_name data_fine \
-label   "Data fine attivita" \
-widget   text \
-datatype text \
-html    "size 14 maxlength 14 $readonly_fld {} class form_element" \
-optional

element create $form_name cognome_rapp \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 30 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name nome_rapp \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name patentino \
    -label   "patentino" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{S&igrave; t} {No f}} 

element create $form_name patentino_fgas \
    -label   "patentino Fgas" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{S&igrave; t} {No f}} 

element create $form_name flag_attivo \
-label   "flag attivo" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N} }

if {$funzione == "I"
||  $funzione == "M"
} {
   set link_comune [iter_search  coimmanu [ad_conn package_url]/tabgen/coimcomu-list [list dummy_1 cod_comune search_word comune dummy_2 provincia dummy_3 cap]]

    set cerca_citt  [iter_search $form_name coimcitt-filter [list dummy cod_legale_rapp   f_cognome cognome_rapp f_nome nome_rapp]]
} else {
    set link_comune ""
    set cerca_citt ""
}

element create $form_name cod_comune -widget hidden -datatype text -optional
element create $form_name cod_legale_rapp     -widget hidden -datatype text -optional
element create $form_name cod_legale_rapp_old -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cognome -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione  -value $funzione
    element set_properties $form_name caller    -value $caller
    element set_properties $form_name nome_funz -value $nome_funz
    element set_properties $form_name extra_par -value $extra_par
    element set_properties $form_name last_cognome -value $last_cognome

    if {$funzione == "I"} {
      # TODO: settare eventuali default!!

        element set_properties $form_name patentino  -value f
	element set_properties $form_name patentino_fgas -value f
    
    } else {
      # leggo riga
        if {[db_0or1row sel_manu ""] == 0
        } {
            iter_return_complaint "Record non trovato"
	}
	set cod_legale_rapp_old $cod_legale_rapp

        element set_properties $form_name cod_manutentore -value $cod_manutentore
        element set_properties $form_name cognome        -value $cognome
        element set_properties $form_name nome           -value $nome
        element set_properties $form_name indirizzo      -value $indirizzo
        element set_properties $form_name localita       -value $localita
        element set_properties $form_name provincia      -value $provincia
        element set_properties $form_name cap            -value $cap
        element set_properties $form_name comune         -value $comune
        element set_properties $form_name cod_fiscale    -value $cod_fiscale
        element set_properties $form_name cod_piva       -value $cod_piva
        element set_properties $form_name telefono       -value $telefono
        element set_properties $form_name cellulare      -value $cellulare
        element set_properties $form_name fax            -value $fax
        element set_properties $form_name email          -value $email
        element set_properties $form_name reg_imprese    -value $reg_imprese
        element set_properties $form_name localita_reg   -value $localita_reg
        element set_properties $form_name rea            -value $rea
        element set_properties $form_name localita_rea   -value $localita_rea
        element set_properties $form_name capit_sociale  -value $capit_sociale
        element set_properties $form_name note           -value $note
        element set_properties $form_name flag_convenzionato -value $flag_convenzionato
        element set_properties $form_name flag_attivo    -value $flag_attivo
	element set_properties $form_name prot_convenzione    -value $prot_convenzione
	element set_properties $form_name prot_convenzione_dt -value $prot_convenzione_dt
        element set_properties $form_name flag_ruolo          -value $flag_ruolo
	element set_properties $form_name data_inizio         -value $data_inizio
        element set_properties $form_name data_fine           -value $data_fine
        element set_properties $form_name cod_legale_rapp     -value $cod_legale_rapp
        element set_properties $form_name cod_legale_rapp_old -value $cod_legale_rapp_old
        element set_properties $form_name cognome_rapp        -value $cognome_rapp
        element set_properties $form_name nome_rapp           -value $nome_rapp
        element set_properties $form_name pec                 -value $pec
	element set_properties $form_name patentino           -value $patentino;#sim02
	element set_properties $form_name patentino_fgas      -value $patentino_fgas;#sim04

    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set cod_manutentore       [string trim [element::get_value $form_name cod_manutentore]]
    set cognome               [string trim [element::get_value $form_name cognome]]
    set nome                  [string trim [element::get_value $form_name nome]]
    set indirizzo             [string trim [element::get_value $form_name indirizzo]]
    set localita              [string trim [element::get_value $form_name localita]]
    set provincia             [string trim [element::get_value $form_name provincia]]
    set cap                   [string trim [element::get_value $form_name cap]]
    set comune                [string trim [element::get_value $form_name comune]]
    set cod_fiscale           [string trim [element::get_value $form_name cod_fiscale]]
    set cod_piva              [string trim [element::get_value $form_name cod_piva]]
    set telefono              [string trim [element::get_value $form_name telefono]]
    set cellulare             [string trim [element::get_value $form_name cellulare]]
    set fax                   [string trim [element::get_value $form_name fax]]
    set email                 [string trim [element::get_value $form_name email]]
    set reg_imprese           [string trim [element::get_value $form_name reg_imprese]]
    set localita_reg          [string trim [element::get_value $form_name localita_reg]]
    set rea                   [string trim [element::get_value $form_name rea]]
    set localita_rea          [string trim [element::get_value $form_name localita_rea]]
    set capit_sociale         [string trim [element::get_value $form_name capit_sociale]]
    set note                  [string trim [element::get_value $form_name note]]
    set flag_convenzionato    [string trim [element::get_value $form_name flag_convenzionato]]
    set flag_attivo           [string trim [element::get_value $form_name flag_attivo]]
    set prot_convenzione      [string trim [element::get_value $form_name prot_convenzione]]
    set prot_convenzione_dt   [string trim [element::get_value $form_name prot_convenzione_dt]]
    set flag_ruolo            [string trim [element::get_value $form_name flag_ruolo]]
    set data_inizio           [string trim [element::get_value $form_name data_inizio]]
    set data_fine             [string trim [element::get_value $form_name data_fine]]
    set cod_legale_rapp       [string trim [element::get_value $form_name cod_legale_rapp]]
    set cognome_rapp          [string trim [element::get_value $form_name cognome_rapp]]
    set nome_rapp             [string trim [element::get_value $form_name nome_rapp]]
    set pec                   [string trim [element::get_value $form_name pec]]
    set patentino             [string trim [element::get_value $form_name patentino]];#sim02
    set patentino_fgas        [string trim [element::get_value $form_name patentino_fgas]];#sim04

  # data corrente
    db_1row sel_dual_date ""

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	if {[string equal $email ""]} {#sim01: Sandro ha detto di metterlo obbligatorio su tutti i clienti
            element::set_error $form_name email "Inserire Email"
            incr error_num
        }
	
	if {[string equal $cod_legale_rapp ""]} {#sim01: Sandro ha detto di metterlo obbligatorio su tutti i clienti
	    element::set_error $form_name cognome_rapp "Inserire Legale rappresentante"
	    incr error_num
	}

	if {[string equal $cognome ""]} {
	    element::set_error $form_name cognome "Inserire il Cognome/Ragione sociale"
	    incr error_num
	}

        if {[string equal $indirizzo ""]} {
	    element::set_error $form_name indirizzo "Inserire Indirizzo"
	    incr error_num
	}

        if {[string equal $comune ""]} {
	    element::set_error $form_name comune "Inserire Comune"
	    incr error_num
	}

        if {![string equal $capit_sociale ""]} {
            set capit_sociale [iter_check_num $capit_sociale 2]
            if {$capit_sociale == "Error"} {
                element::set_error $form_name capit_sociale "Capitale sociale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
                incr error_num
            } else {
                if {[iter_set_double $capit_sociale] >=  [expr pow(10,9)]
                ||  [iter_set_double $capit_sociale] <= -[expr pow(10,9)]} {
                    element::set_error $form_name capit_sociale "Capitale sociale deve essere inferiore di 1.000.000.000"
                    incr error_num
                }
            }
        }

	if {[string equal $cap ""]} {
	    element::set_error $form_name cap "Il C.A.P. deve essere un valore numerico"
	    incr error_num
	}
	
	if {![string equal $prot_convenzione_dt ""]} {
	    set prot_convenzione_dt [iter_check_date $prot_convenzione_dt]
	    if {$prot_convenzione_dt == 0} {
		element::set_error $form_name prot_convenzione_dt "Data non corretta"
		incr error_num
	    } else {
		if {$prot_convenzione_dt > $current_date} {
		    element::set_error $form_name prot_convenzione_dt "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	}

	if {![string equal $data_inizio ""]} {
	    set data_inizio [iter_check_date $data_inizio]
	    if {$data_inizio == 0} {
		element::set_error $form_name data_inizio "Data non corretta"
		incr error_num
	    } else {
		if {$data_inizio > $current_date} {
		    element::set_error $form_name data_inizio "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	}

	if {![string equal $data_fine ""]} {
	    set data_fine [iter_check_date $data_fine]
	    if {$data_fine == 0} {
		element::set_error $form_name data_fine "Data non corretta"
		incr error_num
	    } else {
		if {$data_fine > $current_date} {
		    element::set_error $form_name data_fine "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	    set flag_attivo "N"
	} else {
	    if {[string equal $flag_attivo "N"]} {
		element::set_error $form_name data_fine "Inserire data fine"
		incr error_num
	    }
	}
    }

    if {$funzione == "M"
    } {
	if {![string equal $cod_legale_rapp_old ""]} {
#11/12/2013 if {$cod_legale_rapp != $cod_legale_rapp_old
#11/12/2013 || [string equal $cod_legale_rapp ""]} 
	    if {[string equal $cod_legale_rapp ""]} {;#11/12/2013

		db_1row sel_legale ""
		if {$conta_legale > 0} {
		    element::set_error $form_name cognome_rapp "Impossibile modificare il legale rappresentante in quanto collegato a degli impianti"
		    incr error_num
		}
	    }
	}
    }

    if {$funzione == "D"
    } {
	set conta 0

	if {[db_1row sel_legale ""] == 1} {
	    element::set_error $form_name cognome_rapp "Impossibile cancellare il manutentore: il legale rappresentante &egrave; collegato a degli impianti"
	    incr error_num
	}

	db_1row sel_aimp ""
	if {$conta_aimp > 0} {
	    set msg_canc_manu "Impossibile cancellare il manutentore: ha degli impianti collegati"
            incr conta
            incr error_num
	}

	db_1row sel_boll ""
	if {$conta_boll > 0} {
	    set msg_canc_manu "Impossibile cancellare il manutentore: ha dei bollini collegati"
            incr conta
            incr error_num
	}

	db_1row sel_coma ""
	if {$conta_coma > 0} {
	    set msg_canc_manu "Impossibile cancellare il manutentore: ha degli impianti collegati"
            incr conta
            incr error_num
	}

	db_1row sel_dimp ""
	if {$conta_dimp > 0} {
	    set msg_canc_manu "Impossibile cancellare il manutentore: ha dei modelli h collegati"
            incr conta
            incr error_num
	}

	db_1row sel_mtar ""
	if {$conta_mtar > 0} {
	    set msg_canc_manu "Impossibile cancellare il manutentore: ha delle aree territoriali collegate"
            incr conta
            incr error_num
	}

	if {$conta > 1} {
	    append msg_canc_manu " ed altre informazioni collegate"
	    element::set_error $form_name cod_manutentore $msg_canc_manu
	} else {
	    if {$conta > 0} {
		element::set_error $form_name cod_manutentore $msg_canc_manu
	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {
	    if {$ente eq "CTRIESTE"} {#sim05
		db_1row sel_manu_lpad_s "";#sim05
	    } else {#sim05
		db_1row sel_manu_s ""
	    };#sim05

           set dml_sql [db_map ins_manu]}
        M {set dml_sql [db_map upd_manu]}
        D {set dml_sql [db_map del_manu]}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimmanu $dml_sql

		#sim01 Se sto inseredo creo i dati relativi al portafoglio ed il codice portafoglio
		if {$flag_portafoglio eq "T" && $funzione eq "I"} {#sim01: Aggiunta if e suo contenuto

		    # imposto provenienza e prefix per manutentori
		    db_1row source_man "
                    select source_id as maintainers_source_id
                         , prefix as maintainers_prefix 
                      from wal_sources 
                     where source_name = 'CURIT MAN'"

		    set id [db_string query "select substr(:cod_manutentore,3,6)"]

		    # genero identificativo univoco di 18 digit per Lottomatica
		    set wallet_id ${maintainers_prefix}${id}[randomRange 99999999]
		    
		    # inspiegabilmente ogni tanto la funzione randomRange restituisce un numero di 7 cifre
		    # invece che di 8: mi cautelo con rpad
                    set wallet_id [db_string query "select rpad(:wallet_id,18,9)"]
		    
		    #essendo holder_id un interger salvo solo la parte numerica del cod_manutentore
		    set holder_id [db_string query "select substr(:cod_manutentore,3,length(:cod_manutentore))"]

		    # aggiungo riga titolari
		    db_dml new_holder "
                    insert
                      into wal_holders
                         ( holder_id
                         , wallet_id
                         , source_id
                         , filename
                         , sisal_filename
                         , name
                         , fiscal_code
                         , iva_code
                         , city
                         )
                  values (:holder_id
                         ,:wallet_id
                         ,:maintainers_source_id
                         ,null
                         ,null
                         ,upper(:cognome)
                         ,upper(:cod_fiscale)
                         ,:cod_piva
                         ,upper(:comune)
                         )"
		    
		    db_dml query "
                    update coimmanu 
                       set wallet_id       = :wallet_id
                     where cod_manutentore = :cod_manutentore"
		    
		}

		if {$funzione eq "M"
		&& ![string equal $cod_legale_rapp_old ""]
		&& ![string equal $cod_legale_rapp     ""]
                && $cod_legale_rapp != $cod_legale_rapp_old
		} {;#11/12/2013 (aggiunta questa if ed il suo contenuto)

		    # Storicizzo il vecchio rappresentante legale del manutentore
                    # esattamente come viene fatto anche da iter::representatives_update
                    # di iter-portal/tcl/update-procs.tcl

		    # Non posso inserire sullo storico due record con la stessa data di fine
		    # validità: prima devo leggere se esiste già.
		    set data_fin_valid [db_string query "select current_date - 1 from dual"]
		    if {[db_0or1row query "
                         select cod_strl
                           from coimstrl
                          where cod_manutentore = :cod_manutentore
                            and data_fin_valid  = :data_fin_valid"]
		    } {
			# Se esiste già, non faccio niente perchè così rimane nello storico
			# il record che era in vigore fino a quella data di fine validità
		    } else {
			# In questo caso, inserisco il record

			db_1row query "
                        select coalesce(max(cod_strl),0) + 1 as cod_strl
                          from coimstrl"

			set cod_soggetto $cod_legale_rapp_old

			db_dml ins_coimstrl "
                        insert
                          into coimstrl
                             ( cod_strl
                             , cod_manutentore
                             , data_fin_valid
                             , cod_soggetto
                             , utente_ins
                             , timestamp_ins
                             )
                      values (:cod_strl
                             ,:cod_manutentore
                             ,:data_fin_valid
                             ,:cod_soggetto
                             ,:id_utente
                             , current_timestamp
                             )"
		    }

		    # Cerco tutti gli impianti in cui cod_legale_rapp_old era responsabile
		    set list_cod_impianto [db_list sel_coimaimp "
                        select cod_impianto
                          from coimaimp
                         where cod_responsabile = :cod_legale_rapp_old
                           and flag_resp        = 'T' -- terzo
                           and stato            = 'A' -- attivo"]

		    foreach cod_impianto $list_cod_impianto {
                    # per prima cosa, storicizzo il responsabile originale sulla coimrife

			set ruolo "T"
			# Prima controllo se esiste già il record:
			if {[db_0or1row sel_rife "
                             select '1'
                               from coimrife
                              where cod_impianto    = :cod_impianto
                                and ruolo           = :ruolo
                                and data_fin_valid  = :data_fin_valid"]
			} {
			    # Se esiste già, non faccio niente perchè così rimane nello storico
			    # quello che era in vigore fino a quella data di fine validità
			} else {
			    # In questo caso, inserisco il record
			    set cod_soggetto $cod_legale_rapp_old

			    db_dml ins_coimrife "
                            insert
                              into coimrife
                                 ( cod_impianto
                                 , ruolo
                                 , data_fin_valid
                                 , cod_soggetto
                                 , data_ins
                                 )
                          values (:cod_impianto
                                 ,:ruolo
                                 ,:data_fin_valid
                                 ,:cod_soggetto
                                 , current_date
                                 )"
			}

			# Ora aggiorno il responsabile della coimaimp
			set cod_responsabile $cod_legale_rapp
			db_dml upd_coimaimp "
                        update coimaimp
                           set cod_responsabile = :cod_responsabile
                             , data_mod         = current_date
                             , utente           = :id_utente
                         where cod_impianto     = :cod_impianto"
		    }

		};#11/12/2013
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
        set last_cognome [list $cognome $cod_manutentore]
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_manutentore last_cognome nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimmanu-gest?funzione=V&$link_gest"}
        D {set return_url   "coimmanu-list?$link_list"}
        I {set return_url   "coimmanu-gest?funzione=V&$link_gest"}
        V {set return_url   "coimmanu-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
