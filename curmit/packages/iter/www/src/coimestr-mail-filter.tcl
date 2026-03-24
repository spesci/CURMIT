ad_page_contract {
    @author          Romitti Luca
    @creation-date   26/03/2018

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimestr-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    but01 10/07/2023  Aggiunto la classe ah-jquery-date al campo data_scad
    rom03 30/07/2018 Su richiesta di Sandro faccio puntare il programma di lista al nuovo 
    rom03            programma coimestr-mail-list.

    rom02 16/07/2018 Tolta obbligatorietà del filtro sul manutentore su richiesta di Sandro.

    rom01 12/07/2018 Aggiunto Codice Manutentore come campo obbligatorio del filtro.

} {
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {cod_combustibile ""}
    {cod_cind         ""}
    {cod_cinc         ""}
    {tipo_estrazione  ""}
    {anno_inst_da     ""}
    {anno_inst_a      ""}
    {data_scad        ""}
    {cod_comune       ""}
    {descr_topo       ""}
    {descr_via        ""}
    {num_max          "10"}
    {f_cod_via        ""}
    {flag_racc        ""}
    {flag_pres        ""}
    {flag_tipo_impianto ""}
    {flag_scaduto       ""}
    {f_manu_cogn        ""}
    {f_manu_nome        ""}
    {f_invio_comune     ""}
    {f_cod_manu         ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {[db_0or1row sel_cinc_count ""] == 0} {
    set conta 0
}
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


iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente $coimtgen(flag_ente)
set sigla_prov $coimtgen(sigla_prov)
if {$flag_ente == "C"} {
    set cod_comune $coimtgen(cod_comu)
}
set flag_cind [db_string query "select flag_cind from coimtgen"]

# Personalizzo la pagina
set link_list_script {[export_url_vars caller nome_funz]}
set link_list        [subst $link_list_script]
set titolo       "Spedizione lettere per Raccomandazione e Prescrizione"
set button_label "Seleziona" 
set page_title   "$titolo"

set context_bar [iter_context_bar -nome_funz $nome_funz]
db_1row sel_tgen ""

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimestr"
set onsubmit_cmd ""
set readonly_key \{\}
set readonly_fld \{\}
set disabled_fld \{\}
set jq_date "";#but01
if {$funzione in "V M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd

# inizio dpr74
element create $form_name flag_tipo_impianto \
    -label   "f_flag_tipo_impianto" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element tabindex 57" \
    -optional \
    -options { {{} {}} {Riscaldamento R} {Raffreddamento F} {Cogenerazione C} {Teleriscaldamento T}}

# fine dpr74

element create $form_name tipo_estrazione \
    -label   "Tipo estrazione" \
    -widget   select \
    -options  [db_list_of_lists sel_tpes ""] \
    -datatype text \
#-html    {onChange "document.coimestr.__refreshing_p.value='1';document.coimestr.submit()"} \
    -html "class form_element" \
    -optional

element create $form_name flag_scaduto \
-label   "Flag mod. h scaduto" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options { {{} {}} {S&igrave; S} {No N}}
#but01
element create $form_name data_scad \
-label   "Data Scadenza" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element $jq_date" \
-optional


element create $form_name cod_combustibile \
-label   "Combustibile" \
-widget   select \
-options  [iter_selbox_from_table coimcomb cod_combustibile descr_comb] \
-datatype text \
-html    "class form_element" \
-optional


element create $form_name cod_cind \
-label   "Campagna esclusa" \
-widget   select \
-options  [iter_selbox_from_table coimcind cod_cind descrizione] \
-datatype text \
-html    "class form_element" \
-optional

element create $form_name anno_inst_da \
-label   "Anno installazione" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 class form_element" \
-optional

element create $form_name anno_inst_a \
-label   "Anno installazione" \
-widget   text \
-datatype text \
-html    "size 4 maxlength 4 class form_element" \
-optional

element create $form_name area \
-label   "Area" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 class form_element" \
-optional

if {$flag_ente == "P"} {
    element create $form_name cod_comune \
	-label   "Comune" \
	-widget   select \
	-options  [iter_selbox_from_comu] \
	-datatype text \
	-html    "class form_element" \
	-optional
} else {
    element create $form_name cod_comune -widget hidden -datatype text -optional
}

element create $form_name descr_topo \
-label   "Toponimo" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options [iter_selbox_from_table coimtopo descr_topo descr_topo]

element create $form_name descr_via \
-label   "Via" \
-widget   text \
-datatype text \
-html    "size 35 maxlength 100 class form_element" \
-optional

element create $form_name num_max \
-label   "Numero max di imp. da estr." \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element" \
-optional

element create $form_name flag_racc \
-label   "flag_racc" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N}}

element create $form_name flag_pres \
-label   "flag_pres" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N}}

set sw_manu "f";#rom01
set readonly_fld2 \{\};#rom01
set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]];#rom01

#rom01
element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 10" \
    -optional
#rom01
element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld2 {} class form_element tabindex 11"\
    -optional
#rom01
element create $form_name f_invio_comune \
    -label   "invio_comune" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options {{S&igrave; S} {No N}}

if {$flag_viario == "T"} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy descr_via dummy descr_topo cod_comune cod_comune dummy dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}


element create $form_name f_cod_via -widget hidden -datatype text -optional
element create $form_name f_cod_manu        -widget hidden -datatype text -optional;#rom01
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name cod_cinc  -widget hidden -datatype text -optional
element create $form_name dummy     -widget hidden -datatype text -optional
element create $form_name submitbut -widget submit -datatype text -label "$button_label" -html "class form_submit"

if {[form is_request $form_name]} {
   
    element set_properties $form_name cod_combustibile -value $cod_combustibile
    element set_properties $form_name cod_cind         -value $cod_cind
    element set_properties $form_name tipo_estrazione  -value $tipo_estrazione
    element set_properties $form_name anno_inst_da     -value $anno_inst_da   
    element set_properties $form_name anno_inst_a      -value $anno_inst_a    
    element set_properties $form_name descr_topo       -value $descr_topo
    element set_properties $form_name descr_via        -value $descr_via
    element set_properties $form_name num_max          -value $num_max
    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name cod_cinc         -value $cod_cinc
    element set_properties $form_name cod_comune       -value $cod_comune
    element set_properties $form_name f_cod_via        -value $f_cod_via
    element set_properties $form_name flag_scaduto     -value $flag_scaduto
    element set_properties $form_name data_scad        -value $data_scad
#dpr74
    element set_properties $form_name flag_tipo_impianto -value $flag_tipo_impianto
#dpr74
    element set_properties $form_name flag_racc        -value $flag_racc
    element set_properties $form_name flag_pres        -value $flag_pres
    element set_properties $form_name f_cod_manu       -value $f_cod_manu;#rom01
    element set_properties $form_name f_manu_cogn      -value $f_manu_cogn    ;#rom01
    element set_properties $form_name f_manu_nome      -value $f_manu_nome    ;#rom01
    element set_properties $form_name f_invio_comune   -value $f_invio_comune ;#romo1  

}

if {[form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    set tipo_estrazione    [element::get_value $form_name tipo_estrazione]
    set cod_combustibile   [element::get_value $form_name cod_combustibile]
    set cod_cind           [element::get_value $form_name cod_cind]
    set anno_inst_da       [element::get_value $form_name anno_inst_da]
    set anno_inst_a        [element::get_value $form_name anno_inst_a]

    if {$flag_ente == "P"} {
	set cod_comune     [element::get_value $form_name cod_comune]
    }

    set descr_topo         [element::get_value $form_name descr_topo]
    set descr_via          [element::get_value $form_name descr_via]
    set num_max            [element::get_value $form_name num_max]
    set cod_cinc           [element::get_value $form_name cod_cinc]
    set f_cod_via          [element::get_value $form_name f_cod_via]
    set flag_scaduto       [element::get_value $form_name flag_scaduto]
    set data_scad          [element::get_value $form_name data_scad]

    set flag_racc          [element::get_value $form_name flag_racc]
    set flag_pres          [element::get_value $form_name flag_pres]
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]

    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]]    ;#rom01
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]]   ;#rom01
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]]   ;#rom01
    set f_invio_comune     [string trim [element::get_value $form_name f_invio_comune]];#rom01

    set error_num 0

    if {[string equal $tipo_estrazione ""]} {
	element::set_error $form_name tipo_estrazione "Inserire tipo estrazione"
	incr error_num
    }

    if {[string equal $cod_comune ""]} {
	element::set_error $form_name cod_comune "Inserire comune"
	incr error_num
    }
    if {![string equal $data_scad ""]} {
	set data_scad_chk [iter_check_date $data_scad]
	if {$data_scad_chk == 0} {
	    element::set_error $form_name data_scad "Fino a data scadenza deve essere una data"
	    incr error_num
	}
    }

    if {![string equal $anno_inst_da ""]} {
	set anno_inst_da [iter_check_num $anno_inst_da]
	if {$anno_inst_da == "Error"} {
	    element::set_error $form_name anno_inst_da "Anno non numerico"
	    incr error_num
	} else {
	    set lung [string length $anno_inst_da]
	    if {$lung < 4} {
		element::set_error $form_name anno_inst_da "Anno deve essere lungo 4"
		incr error_num
	    }
	}
    }

    if {![string equal $anno_inst_a ""]} {
	set anno_inst_a [iter_check_num $anno_inst_a]
	if {$anno_inst_a == "Error"} {
	    element::set_error $form_name anno_inst_a "Anno non numerico"
	    incr error_num
	} else {
	    set lung [string length $anno_inst_a]
	    if {$lung < 4} {
		element::set_error $form_name anno_inst_a "Anno deve essere lungo 4"
		incr error_num
	    }
	}
    }

#   if {$tipo_estrazione != "1"} {
#       if {![string equal $anno_inst_da ""]
#       ||  ![string equal $anno_inst_a ""]
#	} {
#	    element::set_error $form_name anno_inst_da "Non inserire anno installazione"
#	    incr error_num
#	}
#   }

    # si controlla la via solo se il primo test e' andato bene.
    # in questo modo si e' sicuri che comune e' stato valorizzato.

    if {[string equal $descr_via  ""]
    &&  [string equal $descr_topo ""]
    } {
	set f_cod_via ""
    } else {

	if {[string equal $cod_comune ""]} {
	    element::set_error $form_name cod_comune "Inserire il comune"
	    incr error_num
	} else {

	    # controllo codice via
	    set chk_out_rc      0
	    set chk_out_msg     ""
	    set chk_out_cod_via ""
	    set ctr_viae        0
	    if {[string equal $descr_topo ""]} {
		set eq_descr_topo  "is null"
	    } else {
		set eq_descr_topo  "= upper(:descr_topo)"
	    }
	    if {[string equal $descr_via ""]} {
		set eq_descrizione "is null"
	    } else {
		set eq_descrizione "= upper(:descr_via)"
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
                element::set_error $form_name descr_via $chk_out_msg
                incr error_num
	    }
	}
    }

 
    if {[string equal $num_max ""]} {
	element::set_error $form_name num_max "Inserire numero di impianti da estrarre"
	incr error_num
    } else {
	set num_max [iter_check_num $num_max]
	if {$num_max == "Error"} {
	    element::set_error $form_name num_max "Deve essere un numero intero"
	    incr error_num
	} else {
	    if {![string is integer $num_max]} {
		element::set_error $form_name num_max "Deve essere un numero intero"
		incr error_num
	    } else {
		if {$num_max > 2000} {
		    element::set_error $form_name num_max "Il numero max di impianti estraibili &egrave; 2000"
		    incr error_num
		}
	    }
	}
    }

    switch $tipo_estrazione {
	"1" {set flag_tpes "D"}
	"3" {set flag_tpes "D"}
        "12" {set flag_tpes "D"}
        "13" {set flag_tpes "D"}
        "14" {set flag_tpes "D"}
        "15" {set flag_tpes "D"}
        "16" {set flag_tpes "D"}
        "17" {set flag_tpes "D"}
	default {set flag_tpes "N"}
    }

    if {![string equal $flag_racc ""]
	&& [string equal $flag_tpes "N"]} {
	element::set_error $form_name flag_racc "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	incr error_num
    }
    if {![string equal $flag_pres ""]
	&& [string equal $flag_tpes "N"]} {
	element::set_error $form_name flag_pres "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	incr error_num
    }
    if {[string equal $flag_pres "S"] && [string equal $f_invio_comune "N"]} {#rom01 if e suo contenuto
	element::set_error $form_name f_invio_comune "Se il flag \"Prescrizioni\" &egrave; \"S&igrave;\" la mail va mandata anche al Comune"
	incr error_num
    };#rom01
    
    #rom01 aggiunta routine generica per controllo codice manutentore
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
    
    if {[string equal $f_manu_cogn ""] && [string equal $f_manu_nome ""]} {#rom01 aggiunta if, else e loro contenuto
	set cod_manutentore ""
#rom02	element::set_error $form_name f_manu_cogn "Inserire il Manutentore"
#rom02	incr error_num
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
    };#rom01
    
    if {$error_num > 0} {
        ad_return_template
        return
    }
#dpr74

    #per non aver problemi con i permessi nel redirect setto nome_funz_caller con il nuovo nome_funz inserito 
    #e subito dopo setto nome_funz con il suo valore originale 
    set nome_funz_caller $nome_funz
    #rom03 set nome_funz "estr"
    set nome_funz "estr-mail";#rom03
    #rom01 set return_url "coimestr-list?funzione=V&[export_url_vars nome_funz nome_funz_caller tipo_estrazione cod_combustibile cod_cind anno_inst_da anno_inst_a cod_comune cod_via descr_topo descr_via num_max cod_cinc flag_racc flag_pres data_scad_chk flag_tipo_impianto]"

#rom03set return_url "coimestr-list?funzione=V&[export_url_vars nome_funz nome_funz_caller tipo_estrazione cod_combustibile cod_cind anno_inst_da anno_inst_a cod_comune cod_via descr_topo descr_via num_max cod_cinc flag_racc flag_pres data_scad_chk flag_tipo_impianto f_cod_manu f_invio_comune]";#rom01

    set return_url "coimestr-mail-list?funzione=V&[export_url_vars nome_funz nome_funz_caller tipo_estrazione cod_combustibile cod_cind anno_inst_da anno_inst_a cod_comune cod_via descr_topo descr_via num_max cod_cinc flag_racc flag_pres data_scad_chk flag_tipo_impianto f_cod_manu f_invio_comune]";#rom03

#fine dimestrpr74

    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template
