ad_page_contract {
    @author          Katia Coazzoli Adhoc
    @creation-date   23/03/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @cvs-id          coimstav-filter.tcl
    USER  DATA       MODIFICHE
    ===== ========== =============================================================================
    but01 19/06/2023 Aggiunto la classe ah-jquery-date ai campo Data.

} {
    
   {funzione         "V"}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""}

   {f_tipo_data       ""}
   {f_data            ""}
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
   {f_cod_via         ""}
   {f_num_max         ""}
   {f_cod_area        ""}

   {id_stampa         ""}
   {flag_tipo_impianto   ""}
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
set flag_avvisi $coimtgen(flag_avvisi)
if {$flag_ente == "C"} {
    set f_cod_comune $coimtgen(cod_comu)
}



# Personalizzo la pagina
set button_label "Visualizza elenco avvisi" 
set page_title   "Selezione appuntamenti estratti per richiesta documentazione"
set context_bar  [iter_context_bar -nome_funz $nome_funz] 

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

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimstav"
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
#but01 Aggiunto la classe ah-jquery-date ai campo Data".
element create $form_name f_data \
-label   "Data " \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional

element create $form_name f_cod_impianto \
-label   "Codice impianto" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element" \
-optional

#set tipest_options ""
#if {$flag_ente  == "P"
#&&  $sigla_prov == "TN"
#} {
#    lappend tipest_options [list "" ""]
#    lappend tipest_options [list "Impianti &lt; 35kW con contratto (5%)"       "1"]
#    lappend tipest_options [list "Impianti &gt; 35kW con contratto"            "2"]
#    lappend tipest_options [list "Impianti senza contratto"                    "3"]
#    lappend tipest_options [list "Impianti da definire"                        "4"]
#} else {
#    lappend tipest_options [list "" ""]
#    lappend tipest_options [list "Impianti &lt; 35kW dichiarati (5%)"          "1"]
#    lappend tipest_options [list "Impianti &lt; 35kW dichiarati (mod.H scad.)" "2"]
#    lappend tipest_options [list "Impianti &gt; 35kW dichiarati"               "3"]
#    lappend tipest_options [list "Impianti non dichiarati"                     "4"]
#    lappend tipest_options [list "Singolo impianto"                            "6"]
#}

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

if {$flag_cod_enve == "f"
||   ($flag_cod_tecn == "f"
   && $flag_cod_enve == "f")
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
    element set_properties $form_name f_cod_enve        -value $f_cod_enve
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

element create $form_name f_num_max \
-label   "Numero stampe" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 $readonly_tecn {} class form_element" \
-optional 

if {$flag_ente == "P"} {
   element create $form_name f_cod_area \
   -label   "Toponimo" \
   -widget   select \
   -datatype text \
   -html    "class form_element" \
   -optional \
   -options [iter_selbox_from_table_wherec coimarea cod_area descrizione "" "where tipo_01 = 'C'"]
}

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

if {$flag_avvisi == "S"} {
    element create $form_name id_stampa \
    -label   "Denominazione stampa" \
    -widget   select \
    -options  [iter_selbox_from_table coimstpm id_stampa descrizione] \
    -datatype text \
    -html    "class form_element" \
    -optional
}

if {$flag_viario == "T"} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy f_descr_via dummy f_descr_topo cod_comune f_cod_comune dummy dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

element create $form_name f_cod_via    -widget hidden -datatype text -optional
element create $form_name flag_cod_enve -widget hidden -datatype text -optional
element create $form_name flag_cod_tecn -widget hidden -datatype text -optional
element create $form_name f_cod_tecn  -widget hidden -datatype text -optional
element create $form_name funzione    -widget hidden -datatype text -optional
element create $form_name caller      -widget hidden -datatype text -optional
element create $form_name nome_funz   -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name submit      -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name dummy       -widget hidden -datatype text -optional

if {[form is_request $form_name]} {
    element set_properties $form_name f_cod_via        -value $f_cod_via
    #dpr74
    element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
    #dpr74
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller

    element set_properties $form_name f_tipo_data      -value $f_tipo_data
    element set_properties $form_name f_data           -value [iter_edit_date $f_data]
    element set_properties $form_name f_cod_impianto   -value $f_cod_impianto
    element set_properties $form_name f_tipo_estrazione -value $f_tipo_estrazione

    element set_properties $form_name f_anno_inst_da   -value $f_anno_inst_da
    element set_properties $form_name f_anno_inst_a    -value $f_anno_inst_a
    element set_properties $form_name f_cod_comb       -value $f_cod_comb
    element set_properties $form_name f_cod_enve       -value $f_cod_enve
    element set_properties $form_name f_cod_tecn       -value $f_cod_tecn
    element set_properties $form_name f_num_max        -value $f_num_max
    if {$flag_avvisi == "S"} {
	element set_properties $form_name id_stampa        -value $id_stampa
    }
    if {[db_0or1row sel_tecn ""] == 0} {
	set f_cog_tecn ""
	set f_nom_tecn ""
    }
    element set_properties $form_name f_cog_tecn       -value $f_cog_tecn
    element set_properties $form_name f_nom_tecn       -value $f_nom_tecn

    element set_properties $form_name f_cod_comune     -value $f_cod_comune
    element set_properties $form_name f_descr_topo     -value $f_descr_topo
    element set_properties $form_name f_descr_via      -value $f_descr_via
    element set_properties $form_name flag_cod_enve    -value $flag_cod_enve
    element set_properties $form_name flag_cod_tecn    -value $flag_cod_tecn
    if {$flag_ente == "P"} {
	element set_properties $form_name f_cod_area       -value $f_cod_area
    }
}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system
    
    set f_tipo_data       [element::get_value $form_name f_tipo_data]
    set f_data            [element::get_value $form_name f_data]
    set f_cod_impianto    [element::get_value $form_name f_cod_impianto]
    set f_tipo_estrazione [element::get_value $form_name f_tipo_estrazione]
    set f_anno_inst_da    [element::get_value $form_name f_anno_inst_da]
    set f_anno_inst_a     [element::get_value $form_name f_anno_inst_a]
    set f_cod_comb        [element::get_value $form_name f_cod_comb]
    set f_cod_enve        [element::get_value $form_name f_cod_enve]
    set f_cod_tecn        [element::get_value $form_name f_cod_tecn]
    set f_cog_tecn        [element::get_value $form_name f_cog_tecn]
    set f_nom_tecn        [element::get_value $form_name f_nom_tecn]
    set f_cod_comune      [element::get_value $form_name f_cod_comune]
    set f_descr_topo      [element::get_value $form_name f_descr_topo]
    set f_descr_via       [element::get_value $form_name f_descr_via] 
    set f_cod_via         [element::get_value $form_name f_cod_via]   
    set f_num_max         [element::get_value $form_name f_num_max]  
    #dpr74
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    #dpr74  
    if {$flag_avvisi == "S"} {
	set id_stampa         [element::get_value $form_name id_stampa]
    }
    if {$flag_ente == "P"} {
	set f_cod_area        [element::get_value $form_name f_cod_area]
    }

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

    if {$flag_avvisi == "S"} {
	if {[string is space $id_stampa]} {
	    element::set_error $form_name id_stampa "Inserire la stampa desiderata"
	    incr error_num
	}
    }

    if {![string equal $f_data ""]} {
          set f_data [iter_check_date $f_data]
          if {$f_data == 0} {
              element::set_error $form_name f_data "deve essere una data valida"
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

    if {![string equal $f_num_max ""]} {
	if {![string is integer $f_num_max]} {
	    element::set_error $form_name f_num_max "Numero non valido"
	    incr error_num
	}
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

    # si controlla la via solo se il primo test e' andato bene.
    # in questo modo si e' sicuri che f_comune e' stato valorizzato.

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
            if {$chk_out_rc == 0} {
                element::set_error $form_name f_descr_via $chk_out_msg
                incr error_num
	    }
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

    if {$error_num > 0} {
       ad_return_template
       return
    }
#dpr74
    set link_list [export_url_vars caller funzione nome_funz nome_funz_caller cod_cinc f_tipo_data f_data f_cod_impianto f_tipo_estrazione f_anno_inst_da f_anno_inst_a f_cod_comb f_cod_enve f_cod_tecn f_cod_comune f_cod_via f_descr_topo f_descr_via f_num_max f_cod_area id_stampa flag_tipo_impianto]

    set return_url "coimstrd-list?$link_list&flag_richiesta=S"

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
