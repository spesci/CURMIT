ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Giulio Laurenzi / Katia Coazzoli
    @creation-date   05/04/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimaimp-sogg.tcl

    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid.
    rom04 22/05/2023 Gestito con if il mittente della mail per la Provincia di Fermo.

    rom03 09/11/2022 Per Palermo riportati i controlli sul soggetto responsabile gia' fatti
    rom03            Regione Marche in coimaimp-bis-gest.

    rom02 10/08/2018 Solo per le Marche se un Manutenore apporta delle modifiche a questa Scheda
    rom02            viene inviata una mail all'autorità competente.

    rom01 12/07/2018 Aggiunto link link_scheda3.

    gac01 29/06/2018 Modificato label

    sim01 25/10/2017 Ucit ha segnalato che se esiste un terzo responsabile associato come rappresentante
    sim01            a più ditte di manutenzione viene messo visualizzata in Ditta man. terzo resp la
    sim01            che trova e causa confusione.
    sim01            Ora faccio in modo che venga prima quella che è anche manutentore dell'impianto e 
    sim01            se non è presente resta il vecchio criterio.

} {
    {cod_impianto       ""}
    {last_cod_impianto  ""}
    {funzione          "V"}
    {caller        "index"}
    {nome_funz          ""}
    {nome_funz_caller   ""}
    {extra_par          ""}
    {url_aimp           ""}
    {url_list_aimp      ""}
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
set id_ruolo  [db_string query "select id_ruolo from coimuten where id_utente = :id_utente"];#Nicola 20/08/2014
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]
set link_scheda3 [export_url_vars cod_impianto last_cod_impianto];#rom01

iter_get_coimtgen;#Nicola 20/08/2014

#rom03 controllo se l'utente e' un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente];#rom03


if {$funzione eq "M"
&&  $id_ruolo ne "admin"
&& ($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
} {#Nicola 19/09/2014 (vedi richiesta di Rindi)
   iter_return_complaint "Spiacente. Utente non abilitato a questa funzione";#Nicola 19/09/2014
};#Nicola 19/09/2014

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina

set link_list_script {[export_url_vars last_cod_impianto caller nome_funz nome_funz_caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set titolo           "Soggetti interessati"
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
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
                          [list "javascript:window.close()" "Torna alla Gestione"] \
                          [list coimaimp-list?$link_list "Lista Impianti"] \
                          "$page_title"]
}

#preparo il link al programma Storico soggetti
set link_rife  [export_url_vars cod_impianto nome_funz_caller url_list_aimp url_aimp]&nome_funz=[iter_get_nomefunz coimrifs-list]

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimsoggaimp"
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

# imposto nulla la variabile contenente la ditta manutentrice del terzo responsabile
# se viene inserito il terzo responsabile come rappresentante legale questa viene impostata
set dittamanut ""

form create $form_name \
    -html    $onsubmit_cmd

#gac01 {Intestatario I}
element create $form_name flag_responsabile \
    -label   "responsabile" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Proprietario P} {Occupante O} {Amministratore A} {"Terzo responsabile" T}}

#intestatario
set readonly_inte $readonly_fld
if {$id_ruolo ne "admin"
&& ($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
} {#Nicola 20/08/2014
    set readonly_inte "readonly";#Nicola 20/08/2014
};#Nicola 20/08/2014

element create $form_name cognome_inte \
    -label   "Cognome intestatario" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_inte {} class form_element" \
    -optional

element create $form_name nome_inte \
    -label   "Nome intestatario" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_inte {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_inte \
        -label   "Cod.Fiscale intestatario" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#proprietario
element create $form_name cognome_prop \
    -label   "Cognome proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_prop \
    -label   "Nome proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_prop \
        -label   "Cod.Fiscale proprietario" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#occupante
element create $form_name cognome_occ \
    -label   "Cognome occupante" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_occ \
    -label   "Nome occupante" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_occ \
        -label   "Cod.Fiscale occupante" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#amministratore
element create $form_name cognome_amm \
    -label   "Cognome amministratore" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_amm \
    -label   "Nome amministratore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_amm \
        -label   "Cod.Fiscale amministratore" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#terzi
element create $form_name cognome_terzi \
    -label   "Cognome terzi" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_terzi \
    -label   "Nome terzi" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_terzi \
        -label   "Cod.Fiscale terzi" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}
#but01 Aggiunto la classe ah-jquery-date ai campi:data_variaz, data_ini_valid.

element create $form_name data_variaz \
    -label   "data_variaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_key {} class form_element $jq_date" \
    -optional

if {$funzione == "M" || $funzione == "D"} {
    element create $form_name data_ini_valid \
        -label   "data_ini_valid" \
        -widget   text \
        -datatype text \
        -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
        -optional
}

if {$funzione == "I" || $funzione == "M"} {
    set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
    set flag_ins_prop "S"

    set cerca_inte  [iter_search $form_name coimcitt-filter [list dummy cod_intestatario f_cognome cognome_inte f_nome nome_inte]]
    set ins_inte    [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_inte nome nome_inte nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_prop  [iter_search $form_name coimcitt-filter [list dummy cod_proprietario f_cognome cognome_prop f_nome nome_prop]]
    set ins_prop    [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_prop nome nome_prop nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_occ   [iter_search $form_name coimcitt-filter [list dummy cod_occupante f_cognome cognome_occ  f_nome nome_occ ]]
    set ins_occ     [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occ nome nome_occ nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_amm   [iter_search $form_name coimcitt-filter [list dummy cod_amministratore f_cognome cognome_amm  f_nome nome_amm ]]
    set ins_amm     [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_amm nome nome_amm nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_terzi [iter_search $form_name coimmanu-list   [list dummy cod_terzi dummy cognome_terzi dummy nome_terzi] [list f_ruolo "M"]]
    set ins_terzi   ""

    if {$id_ruolo ne "admin"
    && ($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
    } {#Nicola 20/08/2014
	set cerca_inte "";#Nicola 20/08/2014
	set ins_inte   "";#Nicola 20/08/2014
	set ins_prop   "";#Nicola 20/08/2014
	set ins_occ    "";#Nicola 20/08/2014
	set ins_amm    "";#Nicola 20/08/2014
	set ins_terzi  "";#Nicola 20/08/2014
    };#Nicola 20/08/2014
} else {
    set cerca_inte  ""
    set ins_inte    ""
    set cerca_prop  ""
    set ins_prop    ""
    set cerca_occ   ""
    set ins_occ     ""
    set cerca_amm   ""
    set ins_amm     ""
    set cerca_terzi ""
    set ins_terzi   ""
}

element create $form_name dummy              -widget hidden -datatype text -optional
element create $form_name cod_manutentore    -widget hidden -datatype text -optional
element create $form_name nome_funz_new      -widget hidden -datatype text -optional
element create $form_name cod_impianto       -widget hidden -datatype text -optional
element create $form_name cod_intestatario   -widget hidden -datatype text -optional
element create $form_name cod_proprietario   -widget hidden -datatype text -optional
element create $form_name cod_occupante      -widget hidden -datatype text -optional
element create $form_name cod_amministratore -widget hidden -datatype text -optional
element create $form_name cod_terzi          -widget hidden -datatype text -optional
element create $form_name url_list_aimp      -widget hidden -datatype text -optional
element create $form_name url_aimp           -widget hidden -datatype text -optional
element create $form_name funzione           -widget hidden -datatype text -optional
element create $form_name caller             -widget hidden -datatype text -optional
element create $form_name nome_funz          -widget hidden -datatype text -optional
element create $form_name nome_funz_caller   -widget hidden -datatype text -optional
element create $form_name extra_par          -widget hidden -datatype text -optional
element create $form_name data_fin_valid     -widget hidden -datatype text -optional
element create $form_name submit             -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_impianto  -widget hidden -datatype text -optional

if {$funzione != "M" && $funzione != "D"} {
    element create $form_name data_ini_valid -widget hidden -datatype text -optional
}

set label_proprietario   "Proprietario"
set label_occupante      "Occupante"
set label_amministratore "Amministratore"
set label_intestatario   "Intestatario contratto"
set label_terzi          "Terzo responsabile"

if {[form is_request $form_name]} {

    set nome_funz_new [iter_get_nomefunz coimcitt-isrt]

    element set_properties $form_name nome_funz_new   -value $nome_funz_new
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    element set_properties $form_name cod_impianto      -value $cod_impianto
    if {![db_0or1row recup_date {}] == 0} {
        element set_properties $form_name data_ini_valid  -value $data_ini_valid
        element set_properties $form_name data_fin_valid  -value $data_fin_valid
    }

    if {$funzione == "I"} {
    } else {
        # leggo riga
        if {[db_0or1row sel_rif_sogg {}] == 0} {
            iter_return_complaint "Record non trovato"
        }

        if {$flag_responsabile == "T"} {

	    if {[db_0or1row sel_dittamanut "select coalesce(m.cognome,'') || ' ' || coalesce(m.nome,'') as dittamanut
               from coimmanu m
                  , coimaimp i
              where m.cod_legale_rapp = :cod_responsabile
                and m.cod_manutentore = i.cod_manutentore
                and i.cod_impianto    = :cod_impianto
              limit 1"] == 0} {#sim01

		if {[db_0or1row sel_dittamanut "select coalesce(cognome,'') || ' ' || coalesce(nome,'') as dittamanut
               from coimmanu
              where cod_legale_rapp = :cod_responsabile
              limit 1"] == 0} {
		    set dittamanut "non esistente"
		}
	    };#sim01
        }

        if {$funzione == "V" || $funzione == "D"} {
            if {![string equal $cod_proprietario ""]} {
                set label_proprietario "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_proprietario&flag_java=t\" target=proprietario>Proprietario</a>"
            }

            if {![string equal $cod_occupante ""]} {
                set label_occupante "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_occupante&flag_java=t\" target=occupante>Occupante</a>"
            }

            if {![string equal $cod_amministratore ""]} {
                set label_amministratore "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_amministratore&flag_java=t\" target=amministratore>Amministratore</a>"
            }

            if {![string equal $cod_intestatario ""]} {
                set label_intestatario "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_intestatario&flag_java=t\" target=intestatario>Intestatario contratto energia</a>"
            }

            if {$flag_responsabile == "T"} {
                set label_terzi "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_responsabile&flag_java=t\" target=te\
rzo responsabile>Terzo responsabile</a>"
            }
        }

	if {($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])} {#Nicola 20/08/2014
	    #forzatura per publies
	    set flag_responsabile "I";#NIcola 20/08/2014
	};#Nicola 20/08/2014

        switch $flag_responsabile {
            T  {element set_properties $form_name cognome_terzi  -value $cognome_terzo
                element set_properties $form_name nome_terzi     -value $nome_terzo
                element set_properties $form_name cod_terzi      -value $cod_responsabile
                if {$funzione == "V"} {
                    element set_properties $form_name cod_fiscale_terzi -value $cod_fiscale_terzo
                }
            }
        }

        element set_properties $form_name cod_proprietario       -value $cod_proprietario

        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_prop   -value $cod_fiscale_prop
        }
        element set_properties $form_name cod_occupante      -value $cod_occupante
        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_occ   -value $cod_fiscale_occ
        }
        element set_properties $form_name cod_amministratore -value $cod_amministratore
        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_amm    -value $cod_fiscale_amm
        }
        element set_properties $form_name cod_intestatario   -value $cod_intestatario
        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_inte   -value $cod_fiscale_inte
        }
        element set_properties $form_name cognome_prop      -value $cognome_prop
        element set_properties $form_name nome_prop         -value $nome_prop
        element set_properties $form_name cognome_inte      -value $cognome_inte
        element set_properties $form_name nome_inte         -value $nome_inte
        element set_properties $form_name cognome_occ       -value $cognome_occ
        element set_properties $form_name nome_occ          -value $nome_occ
        element set_properties $form_name cognome_amm       -value $cognome_amm
        element set_properties $form_name nome_amm          -value $nome_amm
        element set_properties $form_name flag_responsabile -value $flag_responsabile
        #data_installazione
        element set_properties $form_name data_variaz       -value $data_variaz

        #recupero ultima variazione effettuata
        db_1row ultima_mod ""
        if {![string equal $data_variaz ""]} {
            element set_properties $form_name data_variaz  -value $data_variaz
        }
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    set flag_responsabile  [element::get_value $form_name flag_responsabile]
    set cod_intestatario   [element::get_value $form_name cod_intestatario]
    if {$funzione == "V"} {
        set cod_fiscale_inte   [element::get_value $form_name cod_fiscale_inte]
    }
    set cognome_inte       [element::get_value $form_name cognome_inte]
    set nome_inte          [element::get_value $form_name nome_inte]
    set cod_proprietario   [element::get_value $form_name cod_proprietario]
    if {$funzione == "V"} {
        set cod_fiscale_prop   [element::get_value $form_name cod_fiscale_prop]
    }
    set cognome_prop       [element::get_value $form_name cognome_prop]
    set nome_prop          [element::get_value $form_name nome_prop]
    set cod_occupante      [element::get_value $form_name cod_occupante]
    if {$funzione == "V"} {
        set cod_fiscale_occ    [element::get_value $form_name cod_fiscale_occ]
    }
    set cognome_occ        [element::get_value $form_name cognome_occ]
    set nome_occ           [element::get_value $form_name nome_occ]
    set cod_amministratore [element::get_value $form_name cod_amministratore]
    if {$funzione == "V"} {
        set cod_fiscale_amm    [element::get_value $form_name cod_fiscale_amm]
    }
    set cognome_amm        [element::get_value $form_name cognome_amm]
    set nome_amm           [element::get_value $form_name nome_amm]
    set cod_terzi          [element::get_value $form_name cod_terzi]
    if {$funzione == "V"} {
        set cod_fiscale_terzi  [element::get_value $form_name cod_fiscale_terzi]
    }
    set cognome_terzi      [element::get_value $form_name cognome_terzi]
    set nome_terzi         [element::get_value $form_name nome_terzi]
    set url_list_aimp      [element::get_value $form_name url_list_aimp]
    set url_aimp           [element::get_value $form_name url_aimp]
    set data_ini_valid     [element::get_value $form_name data_ini_valid]
    set data_fin_valid     [element::get_value $form_name data_fin_valid]
    set data_variaz        [element::get_value $form_name data_variaz]

    if {[db_0or1row sel_aimp ""] == 0} {
        set flag_dichiarato "S"
    }

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {$funzione == "I" || $funzione == "M"} {
        #routine generica per controllo codice soggetto
        set check_cod_citt {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_citt ""
            set ctr_citt         0
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
            db_foreach sel_citt "" {
                incr ctr_citt
                if {$cod_cittadino == $chk_inp_cod_citt} {
                    set chk_out_cod_citt $cod_cittadino
                    set chk_out_rc       1
                }
            }
            switch $ctr_citt {
                0 { set chk_out_msg "Soggetto non trovato"}
                1 { set chk_out_cod_citt $cod_cittadino
                    set chk_out_rc       1 }
                default {
                    if {$chk_out_rc == 0} {
                        set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
                    }
                }
            }
        }

        if {[string equal $cognome_inte ""] && [string equal $nome_inte    ""]} {
            set cod_intestatario ""
        } else {
            set chk_inp_cod_citt $cod_intestatario
            set chk_inp_cognome  $cognome_inte
            set chk_inp_nome     $nome_inte
            eval $check_cod_citt
            set cod_intestatario $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_inte $chk_out_msg
                incr error_num
            }
        }

        if {[string equal $cognome_prop ""] && [string equal $nome_prop    ""]} {
            set cod_proprietario ""
        } else {
            set chk_inp_cod_citt $cod_proprietario
            set chk_inp_cognome  $cognome_prop
            set chk_inp_nome     $nome_prop
            eval $check_cod_citt
            set cod_proprietario $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_prop $chk_out_msg
                incr error_num
            }
        }

        if {[string equal $cognome_occ ""] && [string equal $nome_occ ""]} {
            set cod_occupante ""
        } else {
            set chk_inp_cod_citt $cod_occupante
            set chk_inp_cognome  $cognome_occ
            set chk_inp_nome     $nome_occ
            eval $check_cod_citt
            set cod_occupante    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_occ $chk_out_msg
                incr error_num
            }
        }
        if {[string equal $cognome_amm ""] && [string equal $nome_amm ""]} {
            set cod_amministratore ""
        } else {
            set chk_inp_cod_citt   $cod_amministratore
            set chk_inp_cognome    $cognome_amm
            set chk_inp_nome       $nome_amm
            eval $check_cod_citt
            set cod_amministratore $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_amm $chk_out_msg
                incr error_num
            }
        }

        if {[string equal $cognome_terzi ""] && [string equal $nome_terzi ""]} {
            set cod_terzi ""
        } else {
            if {![string equal $flag_responsabile "T"]} {
                element::set_error $form_name cognome_terzi "non inserire terzo responsabile: non &egrave; il responsabile"
                incr error_num
            } else {
                if {[string range $cod_terzi 0 1] == "MA"} {
                    set cod_manutentore $cod_terzi

                    element set_properties $form_name cod_manutentore   -value $cod_manutentore
                    if {[db_0or1row sel_cod_legale ""] == 0} {
                        set link_ins_rapp [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_terzi nome nome_terzi nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "crea automaticamente legale rappresentante"]
                        element::set_error $form_name cognome_terzi "aggiornare il manutentore con i dati del legale rappresentante <br>o $link_ins_rapp"
                        incr error_num
                    } else {
                        set chk_inp_cod_citt $cod_terzi
                        set chk_inp_cognome  $cognome_terzi
                        set chk_inp_nome     $nome_terzi
                        eval $check_cod_citt
                        set cod_terzi        $chk_out_cod_citt
                        if {$chk_out_rc == 0} {
                            element::set_error $form_name cognome_terzi $chk_out_msg
                            incr error_num
                        }
                    }
                }
            }
        }

        #congruenza cod_resp con rispettivo codice
        switch $flag_responsabile {
            "T" {
                if {[string equal $cognome_terzi ""] && [string equal $nome_terzi ""]} {
                    element::set_error $form_name cognome_terzi "inserire terzo responsabile: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_terzi
                }
            }
            "P" {
                if {[string equal $cognome_prop ""] && [string equal $nome_prop ""]} {
                    element::set_error $form_name cognome_prop "inserire proprietario: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_proprietario
                }
            }
            "O" {
                if {[string equal $cognome_occ ""] &&  [string equal $nome_occ ""]} {
                    element::set_error $form_name cognome_occ "inserire occupante: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_occupante
                }
            }
            "A" {
                if {[string equal $cognome_amm ""] && [string equal $nome_amm ""]} {
                    element::set_error $form_name cognome_amm "inserire amministratore: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_amministratore
                }
            }
            "I" {
                if {[string equal $cognome_inte ""] && [string equal $nome_inte ""]} {
                    element::set_error $form_name cognome_inte "inserire intestatario: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_intestatario
                }
            }
            default {
                if {$flag_dichiarato == "S"} {
                    element::set_error $form_name flag_responsabile "Indicare responsabile"
                    incr error_num
                }
            }
        }
    }

    if {$funzione == "M" ||  $funzione == "D"} {
        if {[string equal $data_ini_valid ""]} {
            element::set_error $form_name data_ini_valid "Inserire data"
            incr error_num
        } else {
            set data_ini_valid [iter_check_date $data_ini_valid]
            if {$data_ini_valid == 0} {
                element::set_error $form_name data_ini_valid "data inizio validit&agrave; deve essere una data"
                incr error_num
            }
        }

        #non è possibile storicizzare modifiche con data_validità inferiore
        # a modifiche già storicizzate
        if {![string equal $data_ini_valid ""]} {
            db_1row sel_max_data ""
            if {$data_ini_valid <= $data_max_valid} {
                if {![db_0or1row aggiungi_data {$data_max_valid}] == 0} {
                    element::set_error $form_name data_ini_valid "data validit&agrave; non accettata: situazione attuale valida dal $data_max_valid"
                    incr error_num
                }
            } else {
                if {![db_0or1row sottrai_data {$data_ini_valid}] == 0} {
                    element set_properties $form_name data_fin_valid  -value $data_fin_valid
                    set data_fin_valid   [element::get_value $form_name data_fin_valid]
                }
            }
        }
    }

    if {$coimtgen(ente) eq "PPA"} {#rom03 Aggiunta if e sil suo contenuto
    	set indirizzo ""
	set comune    ""
	set provincia ""
	set cap       ""
	set telefono  ""
	set cellulare ""
	set fax       ""
	set email     ""
	set pec       ""

	db_0or1row q "select * from coimcitt where cod_cittadino = :cod_responsabile"
	set msg_error ""
	
	if {$indirizzo == ""} {
	    append msg_error "Compilare campo Indirizzo nell'anagrafica del soggetto<br>"
        }

	if {$comune == ""} {
            append msg_error "Compilare campo Comune nell'anagrafica del soggetto<br>"
        }

	if {$provincia == ""} {
            append msg_error "Compilare campo Provincia nell'anagrafica del soggetto<br>"
        }

	if {$cap == ""} {
            append msg_error "Compilare campo C.A.P. nell'anagrafica del soggetto<br>"
        }
	
	if {$telefono == "" && $cellulare == "" && $fax == "" && $email == "" && $pec == ""} {

            append msg_error "Compilare almeno un campo dei  seguenti campi:  Telefono, Cellulare, Fax, Email, Pec nell'anagrafica del soggetto responsabile<br>"
        }

	if {![string is space $msg_error] && !([string equal $cod_manutentore ""])} {
	    element::set_error $form_name flag_responsabile $msg_error
	    incr error_num
	}

#	if {$error_num > 0  && !($stato ne "A" && [string equal $cod_manutentore ""])} {
#	    element::set_error $form_name cognome $msg_error
	    #[template::form::get_errors $form_name]
#	    ad_return_template
	    
#	    return
#	}


    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    set sw_query "N"
    set dml_sql_sogg ""

    if {$funzione == "M" || $funzione == "D"} {
        #leggo il record originale(prima delle modifiche)dalla tabella coimaimp
        if {![db_0or1row sel_aimp_db {}] == 0} {
            # per ogni campo del soggetto che è stato modificato rispetto al
            # record originale (tranne il caso in cui l'originale fosse = ""),
            # viene storicizzato il record pre-modifica.
            set indice 1

            while {$indice <= 5} {
                switch $indice {
                    1 {
                        if {![string equal $db_cod_responsabile ""] &&  $db_cod_responsabile  != $cod_responsabile} {
                            set ruolo "R"
                            set db_cod_soggetto $db_cod_responsabile
                            if {[db_0or1row  sel_sogg_check ""] ==0} { 
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    2 {
			if {(![string equal $db_cod_intestatario ""] && $db_cod_intestatario  != $cod_intestatario)} {
			    set ruolo "T"
			    set db_cod_soggetto $db_cod_intestatario
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    3 {
			if {(![string equal $db_cod_proprietario ""] && $db_cod_proprietario  != $cod_proprietario)} {
			    set ruolo "P"
			    set db_cod_soggetto $db_cod_proprietario
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    4 {
			if {(![string equal $db_cod_occupante ""] && $db_cod_occupante != $cod_occupante)} {
			    set ruolo "O"
			    set db_cod_soggetto $db_cod_occupante
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    5 {
			if {(![string equal $db_cod_amministratore ""] && $db_cod_amministratore != $cod_amministratore)} {
			    set ruolo "A"
			    set db_cod_soggetto $db_cod_amministratore
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		}
		
		# Lancio la query di manipolazione dati contenute in dml_sql
		if {[info exists dml_sql_sogg]} {
		    with_catch error_msg {
			db_transaction {
			    if {$sw_query == "S"} {
				db_dml dml_coimaimp $dml_sql_sogg
			    }
			}
		    } {
			iter_return_complaint "Spiacente, ma il DBMS ha restituito il seguente messaggio di errore <br><b>$error_msg</b><br> Contattare amministratore di sistema e comunicare il messaggio d'errore. Grazie."
		    }
		}
		set sw_query "N"
		set indice [expr $indice + 1]
	    }
	}
    }

    switch $funzione {
	M { 
            if {$coimtgen(regione) eq "MARCHE"} {#rom02 if e contenuto

                set cod_manutentore [iter_check_uten_manu $id_utente]
                if {$cod_manutentore ne ""} {
		    set cod_propr_new         $cod_proprietario
		    set cod_occu_new          $cod_occupante
		    set cod_ammi_new          $cod_amministratore
		    set cod_resp_new          $cod_responsabile
		    set cod_inte_new          $cod_intestatario 
		    set cognome_prop_new      $cognome_prop      
		    set nome_prop_new         $nome_prop         
		    set cognome_occ_new       $cognome_occ       
		    set nome_occ_new          $nome_occ          
		    set cognome_amm_new       $cognome_amm       
		    set nome_amm_new          $nome_amm          
		    set cognome_terzo_new     $cognome_terzi     
		    set nome_terzo_new        $nome_terzi     
		    set cognome_inte_new      $cognome_inte      
		    set nome_inte_new         $nome_inte         
		    set flag_resp_new         $flag_responsabile

                    db_1row q "select m.cognome                         as cognome_manutentore
                                    , m.nome                            as nome_manutentore
                                    , iter_edit_data(current_date)      as data_modifica
                                    , a.cod_impianto_est                as codice_impianto
                                    , coalesce(a.cod_proprietario,'')   as cod_propr_old
                                    , coalesce(a.cod_occupante,'')      as cod_occu_old
                                    , coalesce(a.cod_amministratore,'') as cod_ammi_old
                                    , coalesce(a.cod_responsabile,'')   as cod_resp_old
                                    , coalesce(a.cod_intestatario,'')   as cod_inte_old
                                    , coalesce(a.flag_resp,'')          as flag_resp_old
                                    , coalesce(b.cognome,'')            as cognome_prop_old
                                    , coalesce(b.nome,'')               as nome_prop_old
                                    , coalesce(c.cognome,'')            as cognome_occ_old 
                                    , coalesce(c.nome,'')               as nome_occ_old 
                                    , coalesce(d.cognome,'')            as cognome_amm_old
                                    , coalesce(d.nome,'')               as nome_amm_old
                                    , coalesce(e.cognome,'')            as cognome_terzo_old
                                    , coalesce(e.nome,'')               as nome_terzo_old
                                    , coalesce(f.cognome,'')            as cognome_inte_old
                                    , coalesce(f.nome,'')               as nome_inte_old
                                    , case a.flag_resp
                                      when 'P' then 'il Proprietario'
                                      when 'T' then 'il Terzo Responsabile'  
                                      when 'O' then 'l''Occupante'
                                      when 'A' then 'l''Amministratore'
                               --     when 'I' then 'l''Intestatario'
                                      else ''
                                       end as edit_flag_resp_old  
                                 from coimaimp a
                                 left outer join coimcitt b on b.cod_cittadino   = a.cod_proprietario
                                 left outer join coimcitt c on c.cod_cittadino   = a.cod_occupante
                                 left outer join coimcitt d on d.cod_cittadino   = a.cod_amministratore
                                 left outer join coimcitt e on e.cod_cittadino   = a.cod_responsabile
                                 left outer join coimcitt f on f.cod_cittadino   = a.cod_intestatario
                                 left outer join coimmanu m on m.cod_manutentore = a.cod_manutentore
                                where a.cod_manutentore = :cod_manutentore
                                  and a.cod_impianto    = :cod_impianto
                                  and a.cod_manutentore = m.cod_manutentore"
		    set testo_mail ""
		    if {$cod_inte_old     eq $cod_inte_new
			&& $cod_propr_old eq $cod_propr_new
			&& $cod_occu_old  eq $cod_occu_new
			&& $cod_ammi_old  eq $cod_ammi_new
			&& $cod_resp_old  eq $cod_resp_new 
			&& $flag_resp_old eq $flag_resp_new
		    } {
			set invio_mail "N"
		    } else {
			set invio_mail "S"

			append testo_mail "ATTENZIONE: il Manutentore  $cognome_manutentore $nome_manutentore con codice $cod_manutentore ha modificato la \"Scheda 1.6: Soggetti che operano sull'impianto\" dell'impianto con codice $codice_impianto.
"
			if {($flag_resp_old eq "") && ($flag_resp_new ne "")} {
			    switch $flag_resp_new {
				"P" { append testo_mail "E' stato messo come Responsabile il Proprietario $cognome_prop_new $nome_prop_new.
"
				}
				"T" { append testo_mail "E' stato messo come Responsabile il Terzo responsabile $cognome_terzo_new $nome_terzo_new.
"
				}
				"O" { append testo_mail "E' stato messo come Responsabile l'Occupante $cognome_occ_new $nome_occ_new.
"
				}
				"A" { append testo_mail "E' stato messo come Responsabile l'Amministratore $cognome_amm_new $nome_amm_new.
"
				}
				"I" {#Intestatario è stato tolto dalle options del responsabile; non aggiungo niente al messaggio della mail 
				    append testo_mail ""
				}
			    }
			}
			if {($cod_inte_old eq "") && ($cod_inte_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Intestatario $cognome_inte_new $nome_inte_new.
"
			}
			if {($cod_propr_old eq "") && ($cod_propr_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Proprietario $cognome_prop_new $nome_prop_new.
"
			}
			if {($cod_occu_old eq "") && ($cod_occu_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Occupante $cognome_occ_new $nome_occ_new.
"
			}
			if {($cod_ammi_old eq "") && ($cod_ammi_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Amministratore $cognome_amm_new $nome_amm_new.
"
			}
			if {$flag_resp_new eq "T" && $cod_resp_new ne "" && $flag_resp_old ne "T"} {
			    append testo_mail "E' stato aggiunto un nuovo Terzo Responsabile $cognome_terzo_new $nome_terzo_new.
"
			}

			if {($flag_resp_old ne "") && ($flag_resp_old ne $flag_resp_new)} {
                            switch $flag_resp_new {
                                "P" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma il Proprietario $cognome_prop_new $nome_prop_new.
"
                                }
                                "T" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma il Terzo responsabile $cognome_terzo_new $nome_terzo_new.
"
                                }
                                "O" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Occupante $cognome_occ_new $nome_occ_new.
"
                                }
                                "A" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Amministratore $cognome_amm_new $nome_amm_new.
"
                                }
                                "I" {#Intestatario è stato tolto dalle options del responsabile; non aggiungo niente al messaggio della mail
                                    append testo_mail ""
                                }
                            }
                        }
			if {($cod_inte_old ne "") && ($cod_inte_old ne $cod_inte_new)} {
			    if {$cod_inte_new eq ""} {
				append testo_mail "L'Intestatario contratto $cognome_inte_old $nome_inte_old è stato rimosso.
"
			    } else {
				append testo_mail "Il vecchio Intestatario contratto $cognome_inte_old $nome_inte_old è stato cambiato con $cognome_inte_new $nome_inte_new.
"
			    }
			}
			if {($cod_propr_old ne "") && ($cod_propr_old ne $cod_propr_new)} {
			    
			    if {$cod_propr_new eq ""} {

				append testo_mail "Il Proprietario $cognome_prop_old $nome_prop_old è stato rimosso.
"
			    } else {
				append testo_mail "Il vecchio Proprietario $cognome_prop_old $nome_prop_old è stato cambiato con $cognome_prop_new $nome_prop_new.
"
			    }
			}
			if {($cod_occu_old ne "") && ($cod_occu_old ne $cod_occu_new)} {
			    if {$cod_occu_new eq ""} {
				append testo_mail "L'Occupante $cognome_occ_old $nome_occ_old è stato rimosso.
"
                            } else {
				append testo_mail "Il vecchio Occupante $cognome_occ_old $nome_occ_old è stato cambiato con $cognome_occ_new $nome_occ_new.
"
			    }
			}
			if {($cod_ammi_old ne "") && ($cod_ammi_old ne $cod_ammi_new)} {
			    if {$cod_ammi_new eq ""} {
				append testo_mail "L'Amministratore $cognome_amm_old $nome_amm_old è stato rimosso.
"
                            } else {
				append testo_mail "Il vecchio Amministratore $cognome_amm_old $nome_amm_old è stato cambiato con $cognome_amm_new $nome_amm_new.
"
			    }
			}
			if {($flag_resp_old ne $flag_resp_new) && $flag_resp_old eq "T"} {
			    append testo_mail "Il Terzo responsabile $cognome_terzo_old $nome_terzo_old è stato rimosso.
"
			}
			if {($flag_resp_old eq $flag_resp_new) &&  
			    ($cod_resp_old ne "") && ($cod_resp_old ne $cod_resp_new) && $flag_resp_old eq "T"} {
			    append testo_mail "Il vecchio Terzo responsabile $cognome_terzo_old $nome_terzo_old è stato cambiato con $cognome_terzo_new $nome_terzo_new.
"
			}
			
		    };#fine else
                    #proc per invio mail
		    if {$invio_mail eq "S"} {
			iter_get_coimdesc
			if {$coimtgen(ente) eq "PFM"} {#rom04 Aggiunte if, else e loro contenuto
			    set mail_ente "impiantitermici@regione.marche.it"
			} else {
			    set mail_ente $coimdesc(email)
			}
			acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "$mail_ente" -subject "Modifica soggetto ITER"  -body $testo_mail
		    }
                }
            };#rom02
	    
	    set dml_sql [db_map upd_aimp]
	}
	D {set dml_sql [db_map del_aimp]}
    }
    
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
	with_catch error_msg {
	    db_transaction {
		db_dml dml_coimaimp $dml_sql
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
	set last_cod_impianto $cod_impianto
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto last_cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
	M {set return_url   "coimaimp-sogg?funzione=V&$link_gest"}
	D {set return_url   "coimaimp-sogg?funzione=V&$link_gest"}
	I {set return_url   "coimaimp-sogg?funzione=V&$link_gest"}
	V {set return_url   "coimaimp-gest?&url_list_aimp&url_aimp"}
    }
    
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
