ad_page_contract {
    Add/Edit/Delete  form per la tabella "coim_as_resp"
    @author          Adhoc
    @creation-date   06/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimdimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but02 21/10/2024 Aggiunto controllo per impedire di aggiungere più di una comunizazione di cessazione
    but02            di terzo responsabile per la stessa data.

    but01 07/07/2023 Aggiunto la classe ah-jquery-date ai campi:data_inizio, data_fine

    sim03 20/06/2023 Il controllo sim01 non vale per gli impianti del freddo

    rom01 17/10/2018 Aggiunto campo flag_as_resp, Sandro ha detto che possono vederlo tutti 
    rom01            gli enti.

    sim02 11/06/2018 Corretto visualizzazione dei flag certificazione

    gac01 11/06/2018 Aggiunto opzione Scadenza incarico alla combo del campo causale_fine

    sim01 29/06/2016 Se il manutentore non ha il patentino non puo' inserire impianti con
    sim01            potenza maggiore di 232 KW.
    sim01            Il controllo va fatto sulla potenza gestita dal parametro
    sim01            coimtgen(flag_potenza).

} {
   {cod_as_resp             ""}
   {last_cod_as_resp        ""}
   {funzione            "V"}
   {caller          "index"}
   {nome_funz            ""}
   {nome_funz_caller     ""}
   {extra_par            ""}
   {cod_impianto         ""}
   {url_aimp             ""} 
   {url_list_aimp        ""}
   {flag_tracciato       ""}
   {flag_ins_prop        ""}
	{errori				""}
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
#set id_utente [ad_get_cookie iter_login_[ns_conn location]]

set link_gest [export_url_vars cod_as_resp last_cod_as_resp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp]

# valorizzo pack_dir che sara' utilizzata sull'adp per fare i link.
set pack_key  [iter_package_key]
set pack_dir  [apm_package_url_from_key $pack_key]
append pack_dir "src"

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto la proc per i link e per il dettaglio impianto
if {![string equal $cod_impianto ""]} {
    set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp {} $flag_tracciato]
    set dett_tab [iter_tab_form $cod_impianto]
} else {
    set link_tab ""
    set dett_tab ""
}

# Personalizzo la pagina
set link_list_script {[export_url_vars nome_funz_caller nome_funz cod_impianto url_list_aimp url_aimp last_cod_as_resp caller]&[iter_set_url_vars $extra_par]}
set link_list_script_admin {[export_url_vars nome_funz_caller cod_impianto url_list_aimp url_aimp last_cod_as_resp caller]&[iter_set_url_vars $extra_par]&nome_funz=[iter_get_nomefunz coim_as_resp_admin-list]}
set link_list        [subst $link_list_script]
set link_list_admin  [subst $link_list_script_admin]

db_1row sel_mod_gend "select flag_mod_gend from coimtgen"

set titolo           "Assunzione di responsabilit&agrave;"
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



iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set cod_comu         $coimtgen(cod_comu)
set flag_viario      $coimtgen(flag_viario)

if {$coimtgen(flag_potenza) eq "pot_utile_nom"} {#sim01 Aggiunta if ed else ed il loro contenuto
    set nome_col_aimp_potenza potenza_utile
    set error_nome_col_potenza "potenza"
} else {
    set nome_col_aimp_potenza potenza
    set error_nome_col_potenza "pot_focolare_nom"
}

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
set cod_manutentore [iter_check_uten_manu $id_utente]
set cod_legale_rapp ""

set flag_modifica 	"T"
set cod_legale_rapp ""
#ricava il cod_legale_rappresentante
if {![string equal $cod_manutentore ""]} {
	set cod_legale_rapp [db_string sel_leg "select cod_legale_rapp from coimmanu where cod_manutentore = :cod_manutentore"]
    if {![string equal $cod_impianto ""]} {
		set flag_modifica "N"
    }
} 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coim_as_resp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set readonly_imp "readonly"
set disabled_imp "disabled"
set disabled_cb  "disabled"
set onsubmit_cmd ""
switch $funzione {
   "I" {set readonly_key \{\}
        set readonly_fld \{\}
        set readonly_imp \{\}
        set disabled_imp \{\}
        set disabled_fld \{\}
		set disabled_cb  \{\}
       }
   "M" {set readonly_fld \{\}
        set readonly_imp \{\}
        set disabled_imp \{\}
        set disabled_fld \{\}
       }
}

if {![string equal $cod_impianto ""]} {
    set readonly_imp "readonly"
    set disabled_imp "disabled"
}
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd

element create $form_name cognome_manu \
-label   "Cognome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 readonly {} class form_element" \
-optional

element create $form_name nome_manu \
-label   "Nome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 readonly {} class form_element" \
-optional

element create $form_name cognome_legale \
-label   "Cognome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 readonly {} class form_element" \
-optional

element create $form_name nome_legale \
-label   "Nome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 readonly {} class form_element" \
-optional

element create $form_name cognome_resp \
-label   "Cognome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name nome_resp \
-label   "Nome manutentore" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name toponimo \
-label   "toponimo" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 20 $readonly_imp {} class form_element" \
-optional

element create $form_name indirizzo \
-label   "via" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 80 $readonly_imp {} class form_element" \
-optional

element create $form_name localita \
-label   "localita" \
-widget   text \
-datatype text \
-html    "size 29 maxlength 40 $readonly_imp {} class form_element" \
-optional

element create $form_name numero \
-label   "numero" \
-widget   text \
-datatype text \
-html    "size 3 maxlength 8 $readonly_imp {} class form_element" \
-optional

element create $form_name esponente \
-label   "esopnente" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 3 $readonly_imp {} class form_element" \
-optional

element create $form_name scala \
-label   "scala" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 5 $readonly_imp {} class form_element" \
-optional

element create $form_name piano \
-label   "paino"\
-widget   text \
-datatype text \
-html    "size 2 maxlength 5 $readonly_imp {} class form_element" \
-optional 

element create $form_name interno \
-label   "interno" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 3 $readonly_imp {} class form_element" \
-optional

element create $form_name potenza \
-label   "potenza" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 12 $readonly_fld {} class form_element" \
-optional

element create $form_name cod_utgi \
-label   "cod_utgi" \
-widget   select \
-datatype text \
-html    "$disabled_imp {} class form_element" \
-optional \
-options [iter_selbox_from_table_obblig coimutgi cod_utgi descr_utgi cod_utgi] 

if {$flag_ente == "P"} {
    element create $form_name cod_comune \
    -label   "Comune" \
    -widget   select \
    -datatype text \
    -html    "$disabled_imp {} class form_element" \
    -optional \
    -options [iter_selbox_from_comu]
} else {
    element create $form_name cod_comune  -widget hidden -datatype text -optional  
    element create $form_name descr_comune \
    -label   "Comune" \
    -widget   text \
    -datatype text \
    -html    "size 20 readonly {} class form_element" \
    -optional
    element set_properties $form_name cod_comune       -value $coimtgen(cod_comu)
    element set_properties $form_name descr_comune     -value $coimtgen(denom_comune)
}

element create $form_name reg_imprese \
-label   "Reg. Imprese" \
-widget   text \
-datatype text \
-html    "size 15 maxlength 15 $readonly_fld {} class form_element" \
-optional

element create $form_name localita_reg \
-label   "localit&agrave;  reg imp." \
-widget   text \
-datatype text \
-html    "size 31 maxlength 40 $readonly_fld {} class form_element" \
-optional

element create $form_name flag_a \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_b \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_c \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_d \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_e \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_f \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_g \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_certif \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name flag_altro \
-label   "check" \
-widget   checkbox \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options  {{Si t}}

element create $form_name cert_uni_iso \
-label   "cert_uni_iso" \
-widget   text \
-datatype text \
-html    "size 25 maxlength 100 $readonly_fld {} class form_element" \
-optional

element create $form_name cert_altro \
-label   "cert_altro" \
-widget   textarea \
-datatype text \
-html    "cols 75 rows 1 $readonly_fld {} class form_element" \
-optional

set options ""
lappend options [list "di aver assunto l'incarico di terzo responsabile" "inizio"]
lappend options [list "di non essere pi&ugrave; terzo responsabile."  "fine"]

element create $form_name swc_inizio_fine \
-label   "Formato" \
-widget   radio \
-datatype text \
-options $options \
-html    "$readonly_fld {} class form_element" \
-optional
#but01 Aggiunto la classe ah-jquery-date ai campi:data_inizio, data_fine.
 
element create $form_name data_inizio \
-label   "Data installazione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $$readonly_fld {} class form_element $jq_date" \
-optional

element create $form_name data_fine \
-label   "Data installazione" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $$readonly_fld {} class form_element $jq_date" \
-optional

#gac01 aggiunto Scadenza incarico
element create $form_name causale_fine \
-label   "causale fine" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {{Revoca dell'incarico} R} {Dimissioni D} {{Scadenza incarico} I}}

element create $form_name cod_impianto_est \
-label   "cod_impianto_est" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 readonly {} class form_element" \
-optional

element create $form_name fornitore_energia \
-label   "fornitore_energia" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table coimdist cod_distr ragione_01]

element create $form_name fornitore_energia_p \
-label   "check" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options {{"" ""} {"di essere fornitore di energia dell'impianto con contratto di servizio" t} {"di non essere fornitore di energia dell'impianto con contratto di servizio energia" f} }
#rom01-options  {{"" ""} {"di essere fornitore di energia" t} {"di non essere fornitore di energia" f} }

element create $form_name committente \
-label   "committente" \
-widget   text \
-datatype text \
-html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
-optional

#rom01
element create $form_name flag_as_resp \
    -label   "flag_as_resp" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{Proprietario P} {Amministratore A} {Occupante O}}

if {$flag_viario == "T"
&& ($funzione == "I"
||  $funzione == "M")
&& [string equal $cod_impianto ""]
} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy indirizzo dummy toponimo cod_comune cod_comune dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

if {$funzione == "I"
    ||  $funzione == "M"} {
    set cerca_prop  [iter_search $form_name coimcitt-filter [list dummy cod_responsabile   f_cognome cognome_resp f_nome nome_resp]]
} else {
    set cerca_prop ""
}

if {($funzione == "I"
    ||  $funzione == "M")
    && [string equal $cod_manutentore ""]
} {
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]
} else {
    set cerca_manu ""
}

element create $form_name f_cod_via        -widget hidden -datatype text -optional
element create $form_name cod_impianto     -widget hidden -datatype text -optional
element create $form_name cod_as_resp      -widget hidden -datatype text -optional
element create $form_name cod_legale_rapp  -widget hidden -datatype text -optional
element create $form_name cod_manutentore  -widget hidden -datatype text -optional
element create $form_name cod_responsabile -widget hidden -datatype text -optional
element create $form_name funzione          -widget hidden -datatype text -optional
element create $form_name caller            -widget hidden -datatype text -optional
element create $form_name nome_funz         -widget hidden -datatype text -optional
element create $form_name nome_funz_caller  -widget hidden -datatype text -optional
element create $form_name extra_par         -widget hidden -datatype text -optional
element create $form_name submit            -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_as_resp  -widget hidden -datatype text -optional
element create $form_name flag_tracciato    -widget hidden -datatype text -optional
element create $form_name url_list_aimp     -widget hidden -datatype text -optional
element create $form_name url_aimp          -widget hidden -datatype text -optional
element create $form_name dummy             -widget hidden -datatype text -optional
element create $form_name nome_funz_new -widget hidden -datatype text -optional
element create $form_name flag_ins_prop -widget hidden -datatype text -optional

set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new
set flag_ins_prop "S"

set link_ins_prop [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_resp nome nome_resp nome_funz nome_funz_new dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy cod_responsabile dummy dummy flag_ins_prop dummy] "Inserisci Sogg."]

set current_date [iter_set_sysdate]

if {[form is_request $form_name]} {
    element set_properties $form_name cod_impianto  -value $cod_impianto
    element set_properties $form_name url_list_aimp -value $url_list_aimp
    element set_properties $form_name url_aimp      -value $url_aimp    
    element set_properties $form_name funzione      -value $funzione
    element set_properties $form_name caller        -value $caller
    element set_properties $form_name nome_funz     -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par     -value $extra_par
    element set_properties $form_name last_cod_as_resp -value $last_cod_as_resp
    element set_properties $form_name flag_tracciato -value $flag_tracciato
    element set_properties $form_name flag_ins_prop    -value $flag_ins_prop

    if {$funzione == "I"} {
		# valorizzo alcuni default
		if {![string equal $cod_manutentore ""]} {
		    db_1row sel_man ""
		    element set_properties $form_name cod_manutentore  -value $cod_manutentore
		    element set_properties $form_name cognome_manu     -value $cognome_manu
		    element set_properties $form_name nome_manu        -value $nome_manu
		    element set_properties $form_name reg_imprese      -value $reg_imprese_old
		    element set_properties $form_name localita_reg     -value $localita_reg_old
		    element set_properties $form_name flag_a           -value $flag_a_old
		    element set_properties $form_name flag_b           -value $flag_b_old
		    element set_properties $form_name flag_c           -value $flag_c_old
		    element set_properties $form_name flag_d           -value $flag_d_old
		    element set_properties $form_name flag_e           -value $flag_e_old
		    element set_properties $form_name flag_f           -value $flag_f_old
		    element set_properties $form_name flag_g           -value $flag_g_old
                    element set_properties $form_name flag_g           -value $flag_g_old
		    element set_properties $form_name cert_uni_iso     -value $cert_uni_iso_old
		    if {![string equal $cert_uni_iso_old ""]} {
				element set_properties $form_name flag_certif	-value "Si"
		    }
		    element set_properties $form_name cert_altro       -value $cert_altro_old
		    if {![string equal $cert_altro_old ""]} {
				element set_properties $form_name flag_altro	-value "Si"
		    }
		    
		}
		if {![string equal $cod_legale_rapp ""]} {
		    db_1row sel_legale ""
		    element set_properties $form_name cod_legale_rapp  -value $cod_legale_rapp
		    element set_properties $form_name cognome_legale   -value $cognome_legale
		    element set_properties $form_name nome_legale      -value $nome_legale
		}
		if {![string equal $cod_impianto ""]} {
		    if {$flag_viario == "F"} {
			db_1row sel_aimp_ins_no_vie ""
		    } else {
			db_1row sel_aimp_ins_vie ""
		    }
		    element set_properties $form_name cod_utgi         -value $cod_utgi
		    element set_properties $form_name cod_impianto_est -value $cod_impianto_est
		    element set_properties $form_name indirizzo        -value $indirizzo
		    element set_properties $form_name toponimo         -value $toponimo
		    element set_properties $form_name localita         -value $localita
		    element set_properties $form_name numero           -value $numero
		    element set_properties $form_name esponente        -value $esponente
		    element set_properties $form_name scala            -value $scala
		    element set_properties $form_name piano            -value $piano
		    element set_properties $form_name interno          -value $interno
		    element set_properties $form_name cod_comune       -value $cod_comune
		    element set_properties $form_name potenza          -value $potenza
		    element set_properties $form_name cod_responsabile -value $cod_proprietario
		    element set_properties $form_name cognome_resp     -value $cognome_resp_old
		    element set_properties $form_name nome_resp        -value $nome_resp_old
                    element set_properties $form_name fornitore_energia	-value $forn_energia
		}
		
		element set_properties $form_name swc_inizio_fine   -value "inizio"
		
    } else {
	# leggo riga


		if {[db_0or1row sel_as_resp ""] == 0} {
		    iter_return_complaint "Record non trovato"
		}
	
		element set_properties $form_name cod_as_resp      -value $cod_as_resp
		element set_properties $form_name cognome_manu     -value $cognome_manu
		element set_properties $form_name nome_manu        -value $nome_manu
		element set_properties $form_name cognome_legale   -value $cognome_legale
		element set_properties $form_name nome_legale      -value $nome_legale
		element set_properties $form_name cod_impianto     -value $cod_impianto
		element set_properties $form_name cod_manutentore  -value $cod_manutentore
		element set_properties $form_name cod_legale_rapp  -value $cod_legale_rapp
		element set_properties $form_name data_inizio      -value $data_inizio
		element set_properties $form_name data_fine        -value $data_fine
		element set_properties $form_name causale_fine     -value $causale_fine
		element set_properties $form_name toponimo         -value $toponimo
		element set_properties $form_name indirizzo        -value $indirizzo
		element set_properties $form_name f_cod_via        -value $f_cod_via
		element set_properties $form_name localita         -value $localita
		element set_properties $form_name numero           -value $numero
		element set_properties $form_name esponente        -value $esponente
		element set_properties $form_name scala            -value $scala
		element set_properties $form_name piano            -value $piano
		element set_properties $form_name interno          -value $interno
		element set_properties $form_name cod_comune       -value $cod_comune
		element set_properties $form_name cod_responsabile -value $cod_responsabile
		element set_properties $form_name cognome_resp     -value $cognome_resp
		element set_properties $form_name nome_resp        -value $nome_resp
		element set_properties $form_name potenza          -value $potenza
		element set_properties $form_name cod_utgi         -value $cod_utgi
		element set_properties $form_name reg_imprese      -value $reg_imprese
		element set_properties $form_name localita_reg     -value $localita_reg
		element set_properties $form_name flag_a           -value $flag_a
		element set_properties $form_name flag_b           -value $flag_b
		element set_properties $form_name flag_c           -value $flag_c
		element set_properties $form_name flag_d           -value $flag_d
		element set_properties $form_name flag_e           -value $flag_e
		element set_properties $form_name flag_f           -value $flag_f
		element set_properties $form_name flag_g           -value $flag_g
		element set_properties $form_name cert_uni_iso     -value $cert_uni_iso
		if {![string equal $cert_uni_iso ""]} {
 			#sim02 element set_properties $form_name flag_certif	-value "Si"
		    element set_properties $form_name flag_certif    -value "t";#sim02
		}
		element set_properties $form_name cert_altro       -value $cert_altro
		if {![string equal $cert_altro ""]} {
			#sim02 element set_properties $form_name flag_certif	-value "Si"
		    element set_properties $form_name flag_altro -value "t";#sim02
		}
		if {![string equal $data_inizio ""]} {
			element set_properties $form_name swc_inizio_fine  	-value "inizio"
			element set_properties $form_name data_fine  		-html "size 10 maxlength 10 readonly {} class form_element"
			element set_properties $form_name causale_fine		-html "disabled {} class form_element"
		} elseif {![string equal $data_fine ""]} {
			element set_properties $form_name swc_inizio_fine	-value "fine"
			element set_properties $form_name data_inizio 		-html "size 10 maxlength 10 readonly {} class form_element"
		}		
		element set_properties $form_name cod_impianto_est  -value $cod_impianto_est
		element set_properties $form_name committente  		-value $committente
		element set_properties $form_name fornitore_energia_p	-value $fornitore_energia_p
		element set_properties $form_name flag_as_resp          -value $flag_as_resp;#rom01

    }
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    if {![string equal $cod_impianto ""]} {
	db_1row sel_aimp_select "select a.cod_utgi,
                                         b.cod_comune
                                      , b.cod_proprietario as aimp_cod_proprietario_orig
                                    from coimgend a,
                                         coimaimp b
                                   where a.cod_impianto = :cod_impianto
                                     and a.cod_impianto = b.cod_impianto
                                     limit 1"

	element set_properties $form_name cod_utgi         -value $cod_utgi
	element set_properties $form_name cod_comune       -value $cod_comune
    }

    set cod_as_resp      	[element::get_value $form_name cod_as_resp]
    set cod_impianto     	[element::get_value $form_name cod_impianto]
    set cod_manutentore  	[element::get_value $form_name cod_manutentore]
    set cognome_manu     	[element::get_value $form_name cognome_manu]
    set nome_manu        	[element::get_value $form_name nome_manu]
    set cod_legale_rapp  	[element::get_value $form_name cod_legale_rapp]
    set cognome_legale   	[element::get_value $form_name cognome_legale]
    set nome_legale      	[element::get_value $form_name nome_legale]
    set data_inizio      	[element::get_value $form_name data_inizio]
    set data_fine        	[element::get_value $form_name data_fine]
    set causale_fine     	[element::get_value $form_name causale_fine]
    set toponimo         	[element::get_value $form_name toponimo]
    set indirizzo        	[element::get_value $form_name indirizzo]
    set f_cod_via        	[element::get_value $form_name f_cod_via]
    set localita         	[element::get_value $form_name localita]
    set numero           	[element::get_value $form_name numero]
    set esponente        	[element::get_value $form_name esponente]
    set scala            	[element::get_value $form_name scala]
    set piano            	[element::get_value $form_name piano]
    set interno          	[element::get_value $form_name interno]
    set cod_comune       	[element::get_value $form_name cod_comune]
    set cod_responsabile 	[element::get_value $form_name cod_responsabile]
    set cognome_resp     	[element::get_value $form_name cognome_resp]
    set nome_resp        	[element::get_value $form_name nome_resp]
    set potenza          	[element::get_value $form_name potenza]
    set cod_utgi         	[element::get_value $form_name cod_utgi]
    set reg_imprese      	[element::get_value $form_name reg_imprese]
    set localita_reg     	[element::get_value $form_name localita_reg]
    set flag_a           	[element::get_value $form_name flag_a]
    set flag_b           	[element::get_value $form_name flag_b]
    set flag_c           	[element::get_value $form_name flag_c]
    set flag_d           	[element::get_value $form_name flag_d]
    set flag_e           	[element::get_value $form_name flag_e]
    set flag_f           	[element::get_value $form_name flag_f]
    set flag_g           	[element::get_value $form_name flag_g]
	set flag_certif		 	[element::get_value $form_name flag_certif]
	set flag_altro       	[element::get_value $form_name flag_altro]
    set cert_uni_iso     	[element::get_value $form_name cert_uni_iso]
    set cert_altro       	[element::get_value $form_name cert_altro]
    set swc_inizio_fine  	[element::get_value $form_name swc_inizio_fine]
    set committente  	 	[string trim [element::get_value $form_name committente]]
    set fornitore_energia  	[element::get_value $form_name fornitore_energia]
    set fornitore_energia_p  	[element::get_value $form_name fornitore_energia_p]
    set flag_as_resp            [element::get_value $form_name flag_as_resp];#rom01

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {$funzione == "I"
    ||  $funzione == "M"
    } {

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
                if {$cod_manutentore == $chk_inp_cod_manu} {
		    set chk_out_cod_manu $cod_manutentore
                    set chk_out_rc       1
		}
	    }
            switch $ctr_manu {
 		0 { set chk_out_msg "Soggetto non trovato"}
	 	1 { set chk_out_cod_manu $cod_manutentore
		    set chk_out_rc       1 }
	  default {
                    if {$chk_out_rc == 0} {
			set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		    }
 		}
	    }
 	}

	if {[string equal $cognome_manu ""]
	    &&  [string equal $nome_manu    ""]
	} {
	    element::set_error $form_name cognome_manu "Inserire il manutentore"
	    incr error_num
	} else {
	    if {[string equal $cognome_manu ""]
		&&  [string equal $nome_manu    ""]
	    } {
		set cod_manutentore ""
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
	}

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
	
	if 	{$flag_certif == "t" && [string equal $cert_uni_iso ""]} { 
		element::set_error $form_name cert_uni_iso "valorizzare la certificazione"
	    incr error_num
	}
	if 	{$flag_certif != "t" && ![string equal $cert_uni_iso ""]} { 
		element::set_error $form_name cert_uni_iso "valorizzare la certificazione"
	    incr error_num
	}
	if 	{$flag_altro == "t" && [string equal $cert_altro ""]} { 
		element::set_error $form_name cert_altro "valorizzare Altro"
	    incr error_num
	}
	if 	{$flag_altro != "t" && ![string equal $cert_altro ""]} { 
		element::set_error $form_name cert_altro "valorizzare Altro"
	    incr error_num
	}
		
        if {[string equal $cognome_resp ""]
	&&  [string equal $nome_resp    ""]
	} {
            set cod_responsabile ""
	    element::set_error $form_name cognome_resp "valorizzare il responsabile"
	    incr error_num
	} else {
	    set chk_inp_cod_citt $cod_responsabile
	    set chk_inp_cognome  $cognome_resp
	    set chk_inp_nome     $nome_resp
	    eval $check_cod_citt
            set cod_responsabile $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_resp $chk_out_msg
                incr error_num
	    }
	}

        if {![string equal $indirizzo  ""]
	    ||  ![string equal $toponimo ""]
	} {
	    if {[string equal $cod_comune ""]} {
		if {$coimtgen(flag_ente) == "P"} {
		    element::set_error $form_name cod_comune "valorizzare il Comune" 
		} else {
		    element::set_error $form_name descr_comu "valorizzare il Comune"
		} 
		incr error_num
	    } 
	}
	# si controlla la via solo se il primo test e' andato bene.
	# in questo modo si e' sicuri che f_comune e' stato valorizzato.
	if {$flag_viario == "T"} {
	    if {[string equal $indirizzo  ""]
	    &&  [string equal $toponimo ""]
	    } {
		if {($localita ne "")} {
		    set f_cod_via ""
		} else {
		    set chk_out_msg "Compilare la localit&agrave se non si conosce la via"
		    set chk_out_rc 0
		}
	    } else {
		# controllo codice via
		set chk_out_rc      0
		set chk_out_msg     ""
		set chk_out_cod_via ""
		set ctr_viae        0
		if {[string equal $toponimo ""]} {
		    set eq_toponimo  "is null"
		} else {
		    set eq_toponimo  "= upper(:toponimo)"
		}
		if {[string equal $indirizzo ""]} {
		    set eq_descrizione "is null"
		} else {
		    set eq_descrizione "= upper(:indirizzo)"
		}
		db_foreach sel_viae "" {
		    incr ctr_viae
		    if {$cod_via == $f_cod_via} {
				set chk_out_cod_via $cod_via
				set chk_out_rc       1
		    }
		}

		switch $ctr_viae {
		    0 { set chk_out_msg "Via non trovata"}
		    1 { set chk_out_cod_via $cod_via
				set chk_out_rc       1 }
		    default {
				if {$chk_out_rc == 0} {
				    set chk_out_msg "Trovate pi&ugrave; vie: usa il link cerca"
				}
		    }
		}
		set f_cod_via $chk_out_cod_via
		set cod_via   $chk_out_cod_via
	    }
    
	    if {[info exists chk_out_rc] && $chk_out_rc == 0} {
			element::set_error $form_name indirizzo $chk_out_msg
			incr error_num
	    }
	}

	if {$swc_inizio_fine == "inizio"} {
	    if {![string equal $data_inizio ""]} {
		set data_inizio [iter_check_date $data_inizio]
		if {$data_inizio == 0} {
		    element::set_error $form_name data_inizio "Data non corretta"
		    incr error_num
		}
	    } else {
		element::set_error $form_name data_inizio "inserire data inizio"
		incr error_num
	    }
	} elseif {$swc_inizio_fine == "fine"} {
	    if {![string equal $data_fine ""]} {
		set data_fine [iter_check_date $data_fine]
		if {$data_fine == 0} {
		    element::set_error $form_name data_fine "Data non corretta"
		    incr error_num
		} else {
		    if {[string equal $causale_fine ""]} {
			element::set_error $form_name causale_fine "Inserire la causale"
			incr error_num
		    }

		    if {[db_0or1row q "select 1
                                         from coimrife
                                        where cod_impianto   = :cod_impianto
                                          and data_fin_valid = :data_fine"]} {#but02 Aggiunta if e contenuto
			element::set_error $form_name data_fine "&Egrave; già presente una comunicazione di cessazione nella data indicata."
			incr error_num
		    }
		}
	    } else {
		element::set_error $form_name data_fine "inserire data fine"
		incr error_num
	    }
	}

    if {[string equal $potenza ""]} {
	    element::set_error $form_name potenza "inserire potenza"
	    incr error_num
	} else {
	    set potenza [iter_check_num $potenza 2]
            if {$potenza == "Error"} {
                element::set_error $form_name potenza "numerico, max 2 dec"
                incr error_num
            } else {
		if {$flag_tracciato == "HMANU"} {
		    if {$potenza >=  "35.00"} {
			element::set_error $form_name potenza "Deve essere < di 35 kW"
			incr error_num
		    }
		}
		if {$flag_tracciato == "IMANU"} {
		    if {$potenza <  "35.00"} {
			element::set_error $form_name potenza "Deve essere >= di 35 kW"
			incr error_num
		    }
		}
	    }
	}
    }

    db_1row query "select $nome_col_aimp_potenza as potenza_impianto
                        , flag_tipo_impianto --sim03
                     from coimaimp
                    where cod_impianto = :cod_impianto";#sim01

    if {![db_0or1row query "
        select patentino 
          from coimmanu 
         where cod_manutentore = :cod_manutentore"]
    } {#sim01: Aggiunta if e suo contenuto
	set patentino "f"
    }

    #sim03 aggiunto condizionone su flag_tipo_impianto
    if {$potenza_impianto > 232 && $patentino eq "f" && $flag_tipo_impianto ne "F"} {#sim01: Aggiunta if e suo contenuto

	set error_potenza "<br>Manutentore non fornito di patentino. Impossibile inserire impianti con potenza maggiore di 232 Kw"
	incr error_num
    } else {
	set error_potenza ""
    }
	
    if {$error_num > 0} {
	set errori "ATTENZIONE sono presenti degli errori nella pagina"
	append errori $error_potenza;#sim01
        ad_return_template
        return
    }	
#ns_return 200 text/html $fornitore_energia;return


    switch $funzione {
        I { db_1row sel_dual_cod_as_resp ""
	    if {[string equal $cod_legale_rapp ""]} {
		set cod_legale_rapp [db_string sel_leg "select cod_legale_rapp from coimmanu where cod_manutentore = :cod_manutentore"]
	    }
	    set dml_sql [db_map ins_as_resp]
	    set dml_sql_manu [db_map upd_manu]
	    if {![string equal $cod_impianto ""]} {
		set dml_sql_aimp [db_map upd_aimp]
		if {$swc_inizio_fine == "fine"} {
		    set dml_sql_aimp1 "update coimaimp 
                                          set cod_responsabile = case 
                                                   when cod_amministratore is not null then cod_amministratore 
                                                   when cod_proprietario is not null then cod_proprietario 
                                                   when cod_occupante is not null then cod_occupante 
                                                   else cod_responsabile end 
                                            , flag_resp = case 
                                                   when cod_amministratore is not null then 'A' 
                                                   when cod_proprietario is not null then 'P' 
                                                   when cod_occupante is not null then 'O' 
                                                   else 'T' end 
                                      where cod_impianto = :cod_impianto"

		    set dml_sql_aimp2 "insert into coimrife (
                                        cod_impianto
                                       ,ruolo
                                       ,data_fin_valid
                                       ,cod_soggetto
                                       ,data_ins
                                       ,data_mod
                                       ,utente 
                                        ) values (
                                       :cod_impianto
                                       ,'T'
                                       ,:data_fine
                                       ,:cod_legale_rapp
                                       ,current_date
                                       ,null
                                       ,null)"

		}
	    }
	}
	M { set dml_sql [db_map upd_as_resp]
	    set dml_sql_manu [db_map upd_manu]
	    if {![string equal $cod_impianto ""]} {
		set dml_sql_aimp [db_map upd_aimp]
	    }
	}
	D { set dml_sql  [db_map del_as_resp]
	}
    }

  # 21/03/2013
  # devo aggiornare il proprietario dell'impianto ed inserire il relativo storico;
  # vedi coimdimp-g-gest;
  # non si vuole inserire la coimtodo 
  # e nemmeno verificare che la data della dichiarazione sia più recente;
    if {($funzione   == "I"  || $funzione   == "M")
    && ![string equal $cod_impianto ""]
    &&   $flag_ente  == "P"
    &&  ($sigla_prov == "UD" || $sigla_prov == "GO")
    &&   $cod_responsabile   != $aimp_cod_proprietario_orig
    } {
        set dml_sql_upd_aimp_cod_proprietario "update coimaimp
                                                  set cod_proprietario = :cod_responsabile
                                                where cod_impianto     = :cod_impianto"

      # memorizzo il vecchio proprietario nello storico
        set ruolo "P"
	if {![string equal $aimp_cod_proprietario_orig ""]
        &&   [db_0or1row sel_rife_check ""] == 0
	} {
            set cod_soggetto_old      $aimp_cod_proprietario_orig
	    set dml_sql_ins_rife_prop [db_map ins_rife]
	}
    }

   
  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
#        with_catch error_msg {
	db_transaction {
	    db_dml dml_coimas_resp $dml_sql
	    if {[info exists dml_sql_manu]} {
		db_dml dml_coimmanu $dml_sql_manu
	    }
	    if {[info exists dml_sql_aimp]} {
		db_dml dml_coimaimp $dml_sql_aimp
	    }
            if {[info exists dml_sql_upd_aimp_cod_proprietario]} {
                db_dml dml_coimaimpx $dml_sql_upd_aimp_cod_proprietario;#21/03/2013
	    }
            if {[info exists dml_sql_ins_rife_prop]} {
                db_dml dml_coimrife1 $dml_sql_ins_rife_prop;#21/03/2013
	    }
 	    if {[info exists dml_sql_aimp1]} {
		db_dml dml_coimaimp1 $dml_sql_aimp1
	    }
	    if {[info exists dml_sql_aimp2]} {
		db_dml dml_coimaimp2 $dml_sql_aimp2
	    }
	}
#        } {
#            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
#            seguente messaggio di errore <br><b>$error_msg</b><br>
#            Contattare amministratore di sistema e comunicare il messaggio
#            d'errore. Grazie."
# 	}
    }

  # dopo l'inserimento posiziono la lista sul record inserito
    if {$funzione == "I"} {
        set last_cod_as_resp [list $cod_as_resp]
    }

    set link_list       [subst $link_list_script]
    set link_list_admin [subst $link_list_script_admin]
    set link_gest      [export_url_vars cod_as_resp last_cod_as_resp nome_funz nome_funz_caller extra_par caller cod_impianto url_list_aimp url_aimp cod_opma data_ins]
    if {$nome_funz_caller == "impianti"} {
		switch $funzione {
	        M {set return_url   "coim_as_resp-gest?funzione=V&$link_gest"}
	        D {set return_url  	"$pack_dir/coim_as_resp-list?$link_list"}
	        I {set return_url   "$pack_dir/coim_as_resp-list?$link_list"}
	        V {set return_url   "coim_as_resp-gest?funzione=V&$link_gest"}
	    }
    } else {
		switch $funzione {
	        M {set return_url   "coim_as_resp-gest?funzione=V&$link_gest"}
	        D {set return_url  "$pack_dir/coim_as_resp_admin-list?$link_list_admin"}
	        I {set return_url   "$pack_dir/coimdimp-ins-filter?&nome_funz=insmodh-manu&[export_url_vars flag_tracciato]&cod_impianto_old=$cod_impianto&cod_as_resp_old=$cod_as_resp"}
	        V {set return_url   "$pack_dir/coimdimp-list?$link_list"}
	    }
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
