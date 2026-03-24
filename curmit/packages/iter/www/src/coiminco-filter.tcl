ad_page_contract {
    @author          Mortoni Nicola Adhoc
    @creation-date   18/08/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coiminco-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    rom02 13/03/2024 Su richiesta di Sandro aggiunto filtro f_con_data_app per poter estrarre
    rom02            solo gli appuntamenti che hanno o che non hanno una data appuntamento valorizzata.
    
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi Da Data e A Data.

    rom01 21/10/2020 Su segnalazione di Salerno modificato page_title per renderlo
    rom01            uguale al nome del menu', Sandro ha detto che va bene per tutti.

    nic01 22/06/2015 Sandro vuole che tutti gli utenti abbiano il filtro campagna, che venga
    nic01            prevalorizzato con la campagna aperta e che siano obbligati a sceglierne
    nic01            una.

} {
    
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}

    {f_tipo_data       ""}
    {f_da_data         ""}
    {f_a_data          ""}
    {f_cod_impianto    ""}
    {f_tipo_estrazione ""}
    {f_anno_inst_da    ""}
    {f_anno_inst_a     ""}
    {f_cod_comb        ""}
    {f_cod_enve        ""}
    {f_cod_tecn        ""}
    {f_cod_comune      ""}
    {f_descr_topo      ""}
    {f_descr_via       ""}
    {f_stato           ""}
    {f_cod_via         ""}
    {f_cod_area        ""}
    {f_tipo_lettera    ""}
    {f_campagna        ""}
    {f_resp_cogn       ""}
    {f_resp_nome       ""}
    {f_civico_da       ""}
    {f_civico_a        ""}
    {f_cod_noin        ""}
    {flag_tipo_impianto   ""}
    {f_con_data_app    ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]


# controllo il parametro di "propagazione" per la navigation bar
if {[string equal $nome_funz_caller ""]} {
    set nome_funz_caller $nome_funz
}

set cod_tecn   [iter_check_uten_opve $id_utente]
set cod_enve   [iter_check_uten_enve $id_utente]


if {![string equal $cod_tecn ""]} {
    set f_cod_tecn $cod_tecn
    if {[db_0or1row sel_cod_enve ""] == 1} {
	set f_cod_enve $cod_enve
    }
    set flag_cod_tecn "t"
} else {
    set flag_cod_tecn "f"
}

if {![string equal $cod_enve ""]} {
    set f_cod_enve $cod_enve
    set flag_cod_enve "t"
} else {
    set flag_cod_enve "f"
}

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente   $coimtgen(flag_ente)
set sigla_prov  $coimtgen(sigla_prov)
if {$flag_ente == "C"} {
    set f_cod_comune $coimtgen(cod_comu)
}

# Personalizzo la pagina
switch $nome_funz {
    "inco-asse" {set evento "assegnazione"}
    "inco-stam" {set evento "stampa avviso"}
    "inco-conf" {set evento "conferma"}
    "inco-effe" {set evento "effettuazione"}
    "inco-annu" {set evento "annullamento"}
    "inco-cimp" {set evento "registr. rapp. di ispezione"}
    default     {set evento "gestione"}
}
set button_label "Seleziona" 
#rom01set page_title   "Selezione appuntamenti per $evento"
set page_title   "Gestione appuntamenti per $evento";#rom01
set context_bar  [iter_context_bar -nome_funz $nome_funz] 

#nic01 if {$flag_cod_tecn != "t"} {
    set conta [db_string sel_cinc_count ""]
    if {$conta == 0} {
	iter_return_complaint "Non ci sono campagne aperte"
    }
    if {$conta > 1} {
	iter_return_complaint "C'&egrave; pi&ugrave; di una campagna aperta"
    }
    if {$conta == 1} {
	if {[db_0or1row sel_cinc ""] == 0} {
	    iter_return_complaint "Campagna non trovata"
	}
    }
#nic01 }

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coiminco"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
if {$flag_cod_tecn == "t"} {
    set readonly_tecn "readonly"
} else {
    set readonly_tecn  \{\}
}
set jq_date "";#but01
if {$funzione in "V M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
    -html    $onsubmit_cmd

# inizio dpr74
element create $form_name flag_tipo_impianto \
    -label   "flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html   "class form_element" \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}

# fine dpr74

element create $form_name f_tipo_data \
    -widget   select \
    -options  {{Estrazione E} {Assegnazione A} {Appuntamento I}} \
    -datatype text \
    -html    "class form_element" \
    -optional
#but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campi Da Data e A Data.
element create $form_name f_da_data \
    -label   "Da Data " \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element $jq_date" \
    -optional

element create $form_name f_a_data \
    -label   "A Data " \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 class form_element $jq_date" \
    -optional

element create $form_name f_cod_impianto \
    -label   "Codice impianto" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 class form_element" \
    -optional

element create $form_name f_tipo_estrazione \
    -label   "Tipo estrazione" \
    -widget   select \
    -options  [iter_selbox_from_table coimtpes cod_tpes descr_tpes] \
    -datatype text \
    -html    "class form_element" \
    -optional

element create $form_name f_anno_inst_da \
    -label   "Da anno installazione " \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 class form_element" \
    -optional

element create $form_name f_anno_inst_a \
    -label   "A anno installazione " \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 class form_element" \
    -optional

element create $form_name f_cod_comb \
    -label   "Combustibile" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcomb cod_combustibile descr_comb]

element create $form_name f_cod_noin \
    -label   "Motivo annullamento" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimnoin cod_noin descr_noin]



if {$flag_cod_tecn == "f"
    &&  $flag_cod_enve == "f"
} {    
    element create $form_name f_cod_enve \
	-label   "Codice ente" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options [iter_selbox_from_table coimenve cod_enve ragione_01]
} else {
    element create $form_name f_cod_enve -widget hidden -datatype text -optional
    element set_properties $form_name f_cod_enve   -value $f_cod_enve

    element create $form_name desc_enve \
	-label   "Desc_enve" \
	-widget   text \
	-datatype text \
	-html    "size 30 readonly {} class form_element" \
	-optional 

    if {[db_0or1row sel_ragione_enve ""] == 0} {
        set ragione_01 ""
    }

    element set_properties $form_name desc_enve   -value $ragione_01
}

element create $form_name f_cog_tecn \
    -label   "Cognome tecnico" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 40 $readonly_tecn {} class form_element" \
    -optional 

element create $form_name f_nom_tecn \
    -label   "Nome tecnico" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 40 $readonly_tecn {} class form_element" \
    -optional 


if {$flag_cod_tecn == "f"} {
    set cerca_opve [iter_search $form_name coimopve-list [list cod_enve f_cod_enve dummy f_cod_tecn dummy f_nom_tecn dummy f_cog_tecn]]
} else {
    set cerca_opve ""
}
if {$flag_ente == "P"} {
    element create $form_name f_cod_comune \
	-label   "Comune" \
	-widget   select \
	-options  [iter_selbox_from_comu] \
	-datatype text \
	-html    "class form_element" \
	-optional
} else {
    element create $form_name f_cod_comune -widget hidden -datatype text -optional
}

element create $form_name f_descr_topo \
    -label   "Tipo toponimo" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name f_descr_via \
    -label   "Via" \
    -widget   text \
    -datatype text \
    -html    "size 33 maxlength 40 class form_element" \
    -optional

element create $form_name f_resp_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 class form_element" \
    -optional

element create $form_name f_resp_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 class form_element" \
    -optional

element create $form_name f_civico_da \
    -label   "Civico da" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 class form_element " \
    -optional

element create $form_name f_civico_a \
    -label   "Civico a" \
    -widget   text \
    -datatype text \
    -html    "size 4 maxlength 4 class form_element" \
    -optional




#nic01 if {$flag_cod_tecn == "t"} {
    element create $form_name f_campagna \
	-label   "data inizio" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options [iter_selbox_from_table coimcinc cod_cinc descrizione]
#nic01}

if {$flag_ente == "P"} {
    element create $form_name f_cod_area \
	-label   "Toponimo" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options [iter_selbox_from_table_wherec coimarea cod_area descrizione "" "where tipo_01 = 'C'"]
}

#rom02
element create $form_name f_con_data_app \
    -label   "Con data appuntamento" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}


if {$flag_viario == "T"} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_descr_via dummy f_descr_topo cod_comune f_cod_comune dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

# se sono provincia di mantova o Padova e sono il verificatore, permetto di selezionare
# solo gli incontri con lo stato superiore a quello spedito.

set options_stato [iter_selbox_from_table coiminst cod_inst descr_inst cod_inst]
if {$flag_ente == "P" && ( $sigla_prov == "MN" || $sigla_prov == "PD") && ![string equal $cod_tecn ""]} {
    set options_stato [iter_selbox_from_table_wherec coiminst cod_inst descr_inst cod_inst "where cod_inst >= 3"]
} 

element create $form_name f_stato \
    -label   "Stato appuntamento" \
    -widget   select \
    -options $options_stato \
    -datatype text \
    -html    "class form_element" \
    -optional

if {$flag_ente  == "P" && $sigla_prov == "LI"} {
    element create $form_name f_tipo_lettera \
	-label   "Stato appuntamento" \
	-widget   select \
	-datatype text \
	-html    "class form_element" \
	-optional \
	-options { {Tutti {}} {{Lettera Chiusa} C} {{Lettera aperta} A}} 
}

element create $form_name f_cod_via     -widget hidden -datatype text -optional
#dpr74
    element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
#dpr74
element create $form_name flag_cod_enve -widget hidden -datatype text -optional
element create $form_name flag_cod_tecn -widget hidden -datatype text -optional
element create $form_name f_cod_tecn    -widget hidden -datatype text -optional
element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy         -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name f_cod_via        -value $f_cod_via
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

    element set_properties $form_name f_tipo_data      -value $f_tipo_data
    element set_properties $form_name f_da_data        -value [iter_edit_date $f_da_data]
    element set_properties $form_name f_a_data         -value [iter_edit_date $f_a_data]
    element set_properties $form_name f_cod_impianto   -value $f_cod_impianto
    element set_properties $form_name f_tipo_estrazione -value $f_tipo_estrazione

    element set_properties $form_name f_anno_inst_da   -value $f_anno_inst_da
    element set_properties $form_name f_anno_inst_a    -value $f_anno_inst_a
    element set_properties $form_name f_cod_comb       -value $f_cod_comb
    element set_properties $form_name f_cod_noin       -value $f_cod_noin
    element set_properties $form_name f_cod_enve       -value $f_cod_enve
    element set_properties $form_name f_cod_tecn       -value $f_cod_tecn
    if {[db_0or1row sel_tecn ""] == 0} {
	set f_cog_tecn ""
	set f_nom_tecn ""
    }
    element set_properties $form_name f_cog_tecn       -value $f_cog_tecn
    element set_properties $form_name f_nom_tecn       -value $f_nom_tecn

    element set_properties $form_name f_cod_comune     -value $f_cod_comune
    element set_properties $form_name f_descr_topo     -value $f_descr_topo
    element set_properties $form_name f_descr_via      -value $f_descr_via
    element set_properties $form_name f_resp_cogn        -value $f_resp_cogn
    element set_properties $form_name f_resp_nome        -value $f_resp_nome
    element set_properties $form_name f_civico_da        -value $f_civico_da
    element set_properties $form_name f_civico_a         -value $f_civico_a

    element set_properties $form_name f_stato          -value $f_stato
    element set_properties $form_name flag_cod_enve    -value $flag_cod_enve
    element set_properties $form_name flag_cod_tecn    -value $flag_cod_tecn

    #nic01 if {$flag_cod_tecn == "t"} {
	if {[db_0or1row sel_cinc ""]} {
	    element set_properties $form_name f_campagna       -value $cod_cinc
	} else {
	    element set_properties $form_name f_campagna       -value $f_campagna
	}
    #nic01 }

    if {$flag_ente == "P"} {
	element set_properties $form_name f_cod_area       -value $f_cod_area
    }
    if {$flag_ente  == "P" && $sigla_prov == "LI"} {
	element set_properties $form_name f_tipo_lettera   -value $f_tipo_lettera
    }

    element set_properties $form_name f_con_data_app -value $f_con_data_app;#rom02
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_tipo_data       [element::get_value $form_name f_tipo_data]
    #dpr74
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    #dpr74 
    set f_da_data         [element::get_value $form_name f_da_data]
    set f_a_data          [element::get_value $form_name f_a_data]
    set f_cod_impianto    [element::get_value $form_name f_cod_impianto]
    set f_tipo_estrazione [element::get_value $form_name f_tipo_estrazione]
    set f_anno_inst_da    [element::get_value $form_name f_anno_inst_da]
    set f_anno_inst_a     [element::get_value $form_name f_anno_inst_a]
    set f_cod_comb        [element::get_value $form_name f_cod_comb]
    set f_cod_noin        [element::get_value $form_name f_cod_noin]
    set f_cod_enve        [element::get_value $form_name f_cod_enve]
    set f_cod_tecn        [element::get_value $form_name f_cod_tecn]
    set f_cog_tecn        [element::get_value $form_name f_cog_tecn]
    set f_nom_tecn        [element::get_value $form_name f_nom_tecn]
    set f_cod_comune      [element::get_value $form_name f_cod_comune]
    set f_descr_topo      [element::get_value $form_name f_descr_topo]
    set f_descr_via       [element::get_value $form_name f_descr_via]  
    set f_civico_da       [string trim [element::get_value $form_name f_civico_da]]
    set f_civico_a        [string trim [element::get_value $form_name f_civico_a]]
    set f_resp_cogn       [string trim [element::get_value $form_name f_resp_cogn]]
    set f_resp_nome       [string trim [element::get_value $form_name f_resp_nome]]
    set f_stato           [element::get_value $form_name f_stato]
    set f_cod_via         [element::get_value $form_name f_cod_via]
    #nic01 if {$flag_cod_tecn == "t"} {
	set f_campagna        [element::get_value $form_name f_campagna]
    #nic01 }
    if {$flag_ente == "P"} {
	set f_cod_area        [element::get_value $form_name f_cod_area]
    }
    if {$flag_ente  == "P" && $sigla_prov == "LI"} {
	set f_tipo_lettera    [element::get_value $form_name f_tipo_lettera]
    }

    set f_con_data_app   [string trim [element::get_value $form_name f_con_data_app]];#rom02
    
    set error_num 0
    if {$flag_cod_enve == "t"} {
	set f_cod_enve [iter_check_uten_enve $id_utente]
    }
    if {$flag_cod_tecn == "t"} {
	set cod_tecn   [iter_check_uten_opve $id_utente]
	if {[db_0or1row sel_cod_enve ""] == 1} {
	    set f_cod_enve $cod_enve
	}
    }

    if {![string equal $f_da_data ""]} {
	set f_da_data [iter_check_date $f_da_data]
	if {$f_da_data == 0} {
	    element::set_error $form_name f_da_data "deve essere una data valida"
	    incr error_num
	}
    }
    if {![string equal $f_a_data ""]} {
	set f_a_data [iter_check_date $f_a_data]
	if {$f_a_data == 0} {
	    element::set_error $form_name f_a_data "deve essere una data valida"
	    incr error_num
	}
    }

    set flag_anno_inst_da "f"
    if {![string equal $f_anno_inst_da ""]} {
	if {![string is integer $f_anno_inst_da]} {
	    element::set_error $form_name f_anno_inst_da "Anno non valido"
	    incr error_num
	} else {
	    set flag_anno_inst_da "t"
	}
    }

    set flag_anno_inst_a "f"
    if {![string equal $f_anno_inst_a ""]} {
	if {![string is integer $f_anno_inst_a]} {
	    element::set_error $form_name f_anno_inst_a "Anno non valido"
	    incr error_num
	} else {
	    set flag_anno_inst_a "t"
	}
    }

    if {$flag_anno_inst_da  == "t"
	&&  $flag_anno_inst_a   == "t"
	&&  $f_anno_inst_da > $f_anno_inst_a
    } {
	element::set_error $form_name f_anno_inst_a "L'anno di fine deve essere maggiore dell'anno inizio"
	incr error_num
    }

    #routine generica per controllo codice tecnico
    set check_cod_tecn {
	set chk_out_rc       0
	set chk_out_msg      ""
	set chk_out_cod_tecn ""
	set ctr_tecn         0
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
	db_foreach sel_tecn_nom "" {
	    incr ctr_tecn
	    if {$cod_tecn_db == $chk_inp_cod_tecn} {
		set chk_out_cod_tecn $cod_tecn_db
		set chk_out_rc       1
	    }
	}
	switch $ctr_tecn {
	    0 { set chk_out_msg "Tecnico non trovato"}
	    1 { set chk_out_cod_tecn $cod_tecn_db
		set chk_out_rc       1 }
	    default {
		if {$chk_out_rc == 0} {
		    set chk_out_msg "Trovati pi&ugrave; tecnici: usa il link cerca"
		}
	    }
	}
    }

    if {[string equal $f_cog_tecn ""]
	&&  [string equal $f_nom_tecn    ""]
    } {
	set f_cod_tecn ""
    } else {
	set chk_inp_cod_tecn $f_cod_tecn
	set chk_inp_cognome  $f_cog_tecn
	set chk_inp_nome     $f_nom_tecn
	eval $check_cod_tecn
	set f_cod_tecn  $chk_out_cod_tecn
	if {$chk_out_rc == 0} {
	    element::set_error $form_name f_cog_tecn $chk_out_msg
	    incr error_num
	}
    }
    
    if {![string equal $f_cod_area ""] 
	&&  (   ![string equal $f_cod_comune ""]
		|| ![string equal $f_cod_via    ""]
		|| ![string equal $f_descr_topo ""]
		|| ![string equal $f_descr_via  ""])
    } {
	element::set_error $form_name f_cod_area "Parametro incompatibile con la selezione per comune o indirizzo"
	incr error_num
    }

    if {[string equal $f_descr_via  ""]
	&&  [string equal $f_descr_topo ""]
    } {
	set f_cod_via ""
    } else {

	if {[string equal $f_cod_comune ""]} {
	    element::set_error $form_name f_cod_comune "Inserire il comune"
	    incr error_num
	} else {

	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $f_descr_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:f_descr_topo)"
	    }
	    if {[string equal $f_descr_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:f_descr_via)"
	    }
	    db_foreach sel_via "" {
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
            if {$chk_out_rc == 0} {
                element::set_error $form_name f_descr_via $chk_out_msg
                incr error_num
	    }
	}
    }

    if {( [string equal $f_cod_via   ""])
	&&  (   ![string equal $f_civico_da ""]
		|| ![string equal $f_civico_a  ""])
    } {
	element::set_error $form_name f_desc_via "La selezione per numero civico viene effettuata solo insieme alla selezione per via"
	incr error_num
    }
    
    set err_civico ""
    set check_civico_da "f"
    if {![string equal $f_civico_da ""]} {
	if {![string is integer $f_civico_da]} {
	    append err_civico "Civico di Inizio deve essere un numero intero"
	    element::set_error $form_name f_civico_da $err_civico
	    incr error_num
	} else {
	    set check_civico_da "t"
	}
    }
    
    set check_civico_a  "f"
    if {![string equal $f_civico_a ""]} {
	if {![string is integer $f_civico_a]} {
	    if {![string equal $err_civico ""]} {
		append err_civico "<br>"
	    }
	    append err_civico "Civico di Fine deve essere un numero intero"
	    element::set_error $form_name f_civico_da $err_civico
	    incr error_num
	} else {
	    set check_civico_a  "t"
	}
    }
    
    if {$check_civico_a  == "t"
	&&  $check_civico_da == "t"
	&&  $f_civico_a < $f_civico_da
    } {
	if {![string equal $err_civico ""]} {
	    append err_civico "<br>"
	}
	append err_civico "Civico iniziale deve essere minore del civico finale"
	element::set_error $form_name f_civico_da $err_civico
	incr error_num
    }

    #nic01 if {$flag_cod_tecn == "t"} {
	if {[string equal $f_campagna ""]} {
	    element::set_error $form_name f_campagna "Inserire la campagna"
	    incr error_num
	}
    #nic01 }

    if {$error_num > 0} {
	ad_return_template
	return
    }
#dpr74
    set flag_scar "N"
    #rom02 Aggiunto f_con_data_app
    set link_list [export_url_vars caller funzione nome_funz nome_funz_caller f_campagna f_tipo_data f_da_data f_a_data f_cod_impianto f_tipo_estrazione f_anno_inst_da f_anno_inst_a f_cod_comb f_cod_enve f_cod_tecn f_cod_comune f_cod_via f_resp_cogn f_resp_nome f_civico_da f_civico_a f_cod_noin f_descr_topo f_descr_via f_stato f_cod_area f_tipo_lettera flag_scar cod_cinc flag_tipo_impianto f_con_data_app]
    set return_url "coiminco-list?$link_list"

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
