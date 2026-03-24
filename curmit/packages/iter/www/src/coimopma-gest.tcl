ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimopma"
    @author          Adhoc
    @creation-date   29/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimopma-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 11/04/2025 Aggiunta la funzione, per gli utenti amministratori, di reset password per gli operatori.

    but01 01/10/2024 A ggiunto il campo email_operator.
    
    gac01 19/02/2018 Gestiti nuovi campi patentino e patentino_fgas

    sim02 25/09/2017 Per Trieste il codice operatore deve avere un progressivo di due decimali (01) 
    sim02            e non di tre (001) così come avviene col portale di Ucit

    sim01 11/03/2016 Aggiunto la gestione del portafoglio

} {
    
   {cod_opma         ""}
   {last_cod_opma    ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
   {cod_manutentore  ""}
   {url_manu         ""}

} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_opma last_cod_opma nome_funz nome_funz_caller extra_par caller cod_manutentore url_manu]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_opma caller nome_funz_caller nome_funz cod_manutentore url_manu]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set titolo           "operatore"
switch $funzione {
    M {set button_label "Conferma modifica" 
       set page_title   "Modifica $titolo"}
    D {set button_label "Conferma cancellazione"
       set page_title   "Cancella $titolo"}
    I {set button_label "Conferma inserimento"
       set page_title   "Inserisci $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizza $titolo"}
}

#if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
#} else {
#    set context_bar  [iter_context_bar \
#                     [list "javascript:window.close()" "Torna alla Gestione"] \
#                     [list coimopma-list?$link_list "Lista Operatori verificatori"] \
#                     "$page_title"]
#}

iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)
set sigla_prov       $coimtgen(sigla_prov)
set flag_portafoglio $coimtgen(flag_portafoglio);#sim01

if {[db_0or1row sel_manu ""] == 0} {
    iter_return_complaint "Ditta manutentrice non trovata"
}

set db_name [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""];#rom01
set url_portale                 [parameter::get_from_package_key -package_key iter -parameter url_portale];#rom01
if {[string equal [iter_check_uten_manu $id_utente] ""]} {#rom01 Aggiunta if e contenuto
        db_1row -dbn $db_name q "
      select user_id
           , password as hash_user
        from users
       where username = :cod_opma"
    
    set riga_reset_password "<a class=main href=$url_portale/user/password-reset?password_hash=$hash_user&user_id=$user_id&caller_admin=t target=reset>Reset password</a>"
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimopma"
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

element create $form_name cognome \
-label   "Cognome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name nome \
-label   "Nome" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name matricola \
-label   "Matricola" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name telefono \
-label   "Telefono" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name cellulare \
-label   "Cellulare" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name recapito \
-label   "recapito" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name stato \
-label   "Stato" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {Attivo 0} {"Non attivo" 1}}

element create $form_name codice_fiscale \
-label   "Codice fiscale" \
-widget   text \
-datatype text \
-html    "size 18 maxlength 16 $readonly_fld {} class form_element" \
-optional

#gac01 aggiunti patentino e patentino_fgas
element create $form_name patentino \
    -label   "Patentino" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{Si t} {No f}}

element create $form_name patentino_fgas \
    -label   "Patentino Fgas"\
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{Si t} {No f}}

element create $form_name note \
-label   "recapito" \
-widget   textarea \
-datatype text \
-html    "cols 80 rows 3 $readonly_fld {} class form_element" \
-optional

#but01 aggiunto il campo email_operator.
element create $form_name email_operator \
    -label   "Email" \
    -widget   text  \
    -datatype email  \
    -html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
    -optional

if {$flag_portafoglio eq "T"} {#sim01: aggiunta if e suo contenuto
    element create $form_name flag_portafoglio_admin \
	-label   "Portafoglio" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{S&igrave; T} {No F}}
} else {
    element create $form_name flag_portafoglio_admin -widget hidden -datatype text -optional
}

element create $form_name cod_opma  -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name extra_par -widget hidden -datatype text -optional
element create $form_name cod_manutentore  -widget hidden -datatype text -optional
element create $form_name url_manu  -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit    -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_opma -widget hidden -datatype text -optional

if {[form is_request $form_name]} {

    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_cod_opma -value $last_cod_opma
    element set_properties $form_name cod_manutentore      -value $cod_manutentore
    element set_properties $form_name url_manu      -value $url_manu
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

    if {$funzione == "I"} {
        
    } else {
      # leggo riga
        if {[db_0or1row sel_opma {}] == 0} {
            iter_return_complaint "Record non trovato"
	}

        element set_properties $form_name cod_opma       -value $cod_opma
        element set_properties $form_name cognome        -value $cognome
        element set_properties $form_name nome           -value $nome
        element set_properties $form_name matricola      -value $matricola
        element set_properties $form_name stato          -value $stato
        element set_properties $form_name recapito       -value $recapito
        element set_properties $form_name telefono       -value $telefono
        element set_properties $form_name cellulare      -value $cellulare
        element set_properties $form_name codice_fiscale -value $codice_fiscale
	element set_properties $form_name patentino      -value $patentino;#gac01
	element set_properties $form_name patentino_fgas -value $patentino_fgas ;#gac01
        element set_properties $form_name note           -value $note
	element set_properties $form_name flag_portafoglio_admin -value $flag_portafoglio_admin;#sim01
	element set_properties $form_name email_operator -value $email_operator ;#but01
    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system
    set cognome        [string trim [element::get_value $form_name cognome]]
    set nome           [string trim [element::get_value $form_name nome]]
    set matricola      [string trim [element::get_value $form_name matricola]]
    set stato          [string trim [element::get_value $form_name stato]]
    set telefono       [string trim [element::get_value $form_name telefono]]
    set cellulare      [string trim [element::get_value $form_name cellulare]]
    set recapito       [string trim [element::get_value $form_name recapito]]
    set codice_fiscale [string trim [element::get_value $form_name codice_fiscale]]
    set patentino      [string trim [element::get_value $form_name patentino]];#gac01
    set patentino_fgas [string trim [element::get_value $form_name patentino_fgas]];#gac01
    set note           [string trim [element::get_value $form_name note]]
    set flag_portafoglio_admin [string trim [element::get_value $form_name flag_portafoglio_admin]];#sim01
    set email_operator [string trim [element::get_value $form_name email_operator]];#but01
    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	if {$flag_portafoglio_admin eq "T"
	&&  [db_0or1row query "
            select cod_opma as cod_opma_porta
              from coimopma
             where cod_manutentore         = :cod_manutentore
               and flag_portafoglio_admin  = 'T'
               and cod_opma               <> coalesce(:cod_opma,'')
             limit 1
            "]
	} {#sim01: aggiunta if ed il suo contenuto
	    element::set_error $form_name flag_portafoglio_admin "E' gi&agrave; presente un amministratore di portafoglio per questo manutentore. E' l'operatore con matricola $cod_opma_porta. Valorizzare questo flag con No."
	    incr error_num
	}

        if {[string equal $cognome ""]} {
            element::set_error $form_name cognome "Inserire Cognome"
            incr error_num
        }

        if {[string equal $nome ""]} {
            element::set_error $form_name nome "Inserire Nome"
            incr error_num
        }

        if {[string equal $matricola ""]} {
            element::set_error $form_name matricola "Inserire Matricola"
            incr error_num
        }

        if {[string equal $stato ""]} {
            element::set_error $form_name stato "Stato"
            incr error_num
        }
	if {[string equal $email_operator ""]} {;#but01 aggiunto if e suo contenuto
	    element::set_error $form_name email_operator "Inserire Email"
	    incr error_num
	} 
    }

    if {$funzione == "I"
    &&  $error_num == 0
    &&  [db_0or1row sel_opma_check {}] == 1
    } {
         # controllo univocita'/protezione da double_click
        element::set_error $form_name cognome "Il nominativo che stai tentando di inserire &egrave; gi&agrave; esistente nel Data Base sul codice manutentore: $manu"
        incr error_num
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    switch $funzione {
        I {

	    if {$coimtgen(ente)    eq "CTRIESTE"} {#sim02
		db_1row sel_opma_2dec_s "";#sim02
	    } else {#sim02 
		db_1row sel_opma_s ""
	    };#sim02

	    set dml_sql [db_map ins_opma]}
        M {set dml_sql [db_map upd_opma]}
        D {set dml_sql [db_map del_opma]
	}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimopma $dml_sql
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
        set last_cod_opma $cod_opma
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_opma last_cod_opma nome_funz nome_funz_caller extra_par caller cod_manutentore url_manu]
    switch $funzione {
        M {set return_url   "coimopma-gest?funzione=V&$link_gest"}
        D {set return_url   "coimopma-list?$link_list"}
        I {set return_url   "coimopma-gest?funzione=V&$link_gest"}
        V {set return_url   "coimopma-list?$link_list"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
