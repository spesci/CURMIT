ad_page_contract {
    @author          Paolo Formizzi Adhoc
    @creation-date   23/04/2004

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @cvs-id          coimestr-filter.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 29/09/2025 Aggiunto filtro presenza/assenza ditta di manutenzione. (Punto 33 MEV regione Marche 2025).
    ric01            Corretto mat02 per gestire il refresh a seconda della versione di openacs.

    mat02 25/03/2025 Corretto il controllo sul refresh per fare il redirect corretto 

    mat01 27/01/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.

    but01 28/11/2024 Aggiunto il filtro della ditta di manutenzione.
    
    rom02 18/03/2019 Aggiunti i filtri tipo_generatore, sistema_areazione e tipo_locale.
    rom02            I filtri sono stati voluti dalla Regione Marche ma Sandro ha detto che
    rom02            possono andare bene per tutti gli enti.

    rom01 11/03/2019 Modificato filtro tipo_estrazione per la Regione Marche: loro devono
    rom01            devono aveere la possibilita' di atrarre gli impianti senza DAM

    san01 19/07/2016 Aggiunto filtro per cod_zona.
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
    {cod_area         ""}
    {flag_scaduto     ""}
    {flag_oss         ""}
    {flag_racc        ""}
    {flag_pres        ""}
    {flag_status      ""}
    {cod_raggruppamento ""}
    {peso_min         ""}
    {n_anomalie       ""}
    {bacharach        ""}
    {co               ""}
    {rend_combust     ""}
    {tiraggio         ""}
    {cod_anom         ""}
    {cod_noin         ""}
    {flag_tipo_impianto ""}
    {cod_zona         ""}
    {tipo_generatore   ""}
    {sistema_areazione ""}
    {tipo_locale       ""}
    {f_manu_cogn          ""}
    {f_manu_nome          ""}
    {f_cod_manu           ""}
    {__refreshing_p   0}
    {f_manu_present_p            ""}
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
set titolo       "Estrazione impianti per controlli"
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
#rom01 modificata options, non uso piu' la db_list_of_lists ma uso la proc iter_selbox_from_table_wherec
#rom01 -options  [db_list_of_lists sel_tpes ""]
#rom01 La regione Marche deve poter filtrare anche per impianti senza DAM, gli altri enti no
if {$coimtgen(regione) ne "MARCHE"} {#rom01 aggiunte if, else e loro contenuto
    set coimtpes_wherec "where cod_tpes !='19'"
} else {
    set coimtpes_wherec "where 1=1"
};#rom01

element create $form_name tipo_estrazione \
-label   "Tipo estrazione" \
-widget   select \
    -options  [iter_selbox_from_table_wherec coimtpes cod_tpes descr_tpes cod_tpes $coimtpes_wherec] \
-datatype text \
-html    {onChange "document.coimestr.__refreshing_p.value='1';document.coimestr.submit()"} \
-optional

element create $form_name flag_scaduto \
-label   "Flag mod. h scaduto" \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options { {{} {}} {S&igrave; S} {No N}}

element create $form_name data_scad \
-label   "Data Scadenza" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element" \
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

element create $form_name cod_zona \
    -label   "Zona" \
    -widget   text \
    -datatype text \
    html    "size 10 maxlength 8 class form_element" \
    -optional ;#san01


if {$flag_ente == "P" && $sigla_prov != "TN"} {
    element create $form_name cod_area \
    -label   "Toponimo" \
    -widget   select \
    -datatype text \
    -html    "class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimarea cod_area descrizione "" "where tipo_01 = 'C'"]
}

element create $form_name flag_oss \
-label   "flag_oss" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N}}
    
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

element create $form_name flag_status \
-label   "flag_status" \
-widget   select \
-datatype text \
-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
-optional \
-options {{{} {}} {S&igrave; S} {No N}}

element create $form_name cod_raggruppamento \
-label   "codice ragg." \
-widget   select \
-datatype text \
-html    "class form_element" \
-optional \
-options [iter_selbox_from_table coimragr cod_raggruppamento descrizione]

element create $form_name peso_min \
-label   "MInimo peso" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element" \
-optional

element create $form_name n_anomalie \
-label   "Numero anomalie" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 class form_element" \
-optional

element create $form_name bacharach \
-label   "Bacharach" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 8 $readonly_fld {} class form_element" \
-optional

element create $form_name co \
-label   "co" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 14 $readonly_fld {} class form_element" \
-optional

element create $form_name rend_combust \
-label   "Rendimento combustibile" \
-widget   text \
-datatype text \
-html    "size 8 maxlength 6 $readonly_fld {} class form_element" \
-optional

element create $form_name tiraggio \
-label   "Tiraggio minimo" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
-optional


element create $form_name cod_anom \
-label    "anomalia" \
-widget   select \
-datatype text \
-html     "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table_wherec coimtano cod_tano "cod_tano||' - '||descr_breve" "" "where (flag_modello = 'S'
                                                                                                   or flag_modello is null)
                                                                                         and (data_fine_valid > current_date
                                                                                          or data_fine_valid is null)"]
element create $form_name cod_noin \
-label    "annullamento" \
-widget   select \
-datatype text \
-html     "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_table_wherec coimnoin cod_noin "cod_noin||' - '||descr_noin" "" "where 1=1"]


set cerca_manu [iter_search $form_name coimmanu-list [list dummy f_cod_manu dummy f_manu_cogn dummy f_manu_nome]];#but01
#but01
element create $form_name f_manu_cogn \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 23 maxlength 100 readonly {} class form_element tabindex 10" \
    -optional
#but01
element create $form_name f_manu_nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 23 maxlength 100 readonly {} class form_element tabindex 11"\
    -optional

if {$coimtgen(regione) eq "MARCHE"} {#ric01 aggiunta if, else e loro contenuto
    element create $form_name f_manu_present_p \
	-label   "Ditta di manutenzione presente" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {Presente t} {Assente f}}

} else {
    element create $form_name f_manu_present_p -widget hidden -datatype text -optional
}

if {$flag_viario == "T"} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy descr_via dummy descr_topo cod_comune cod_comune dummy dummy dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

#rom02
element create $form_name tipo_generatore \
    -label    "Tipo Generatore" \
    -widget   select \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Aperta A} {Stagna S}}

#rom02 
element create $form_name sistema_areazione \
    -label "Sistema di areazione" \
    -widget   select \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Forzato F} {Naturale N}}
    
#rom02
element create $form_name tipo_locale \
    -label "Tipo Locale" \
    -widget   select \
    -datatype text \
    -html "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {{Locale ad uso esclusivo} T} {Interno I} {Esterno E}}


element create $form_name __refreshing_p -widget hidden -datatype text -optional
#mat00 13/10/2025
#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
#element set_properties $form_name __refreshing_p -values 0;#mat01
element create $form_name f_cod_via -widget hidden -datatype text -optional
element create $form_name funzione  -widget hidden -datatype text -optional
element create $form_name caller    -widget hidden -datatype text -optional
element create $form_name nome_funz -widget hidden -datatype text -optional
element create $form_name cod_cinc  -widget hidden -datatype text -optional
element create $form_name dummy     -widget hidden -datatype text -optional
element create $form_name submitbut -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name f_cod_manu -widget hidden -datatype text -optional;#but01

if {[form is_request $form_name]} {
   
    element set_properties $form_name cod_combustibile -value $cod_combustibile
    element set_properties $form_name cod_cind         -value $cod_cind
    element set_properties $form_name tipo_estrazione  -value $tipo_estrazione
    element set_properties $form_name anno_inst_da     -value $anno_inst_da   
    element set_properties $form_name anno_inst_a      -value $anno_inst_a    
    element set_properties $form_name descr_topo       -value $descr_topo
    element set_properties $form_name descr_via        -value $descr_via
    element set_properties $form_name num_max          -value $num_max
    element set_properties $form_name cod_zona         -value $cod_zona;#san01
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
    if {$flag_ente == "P" && $sigla_prov != "TN"} {
	element set_properties $form_name cod_area     -value $cod_area 
    }
    element set_properties $form_name flag_oss         -value $flag_oss
    element set_properties $form_name flag_racc        -value $flag_racc
    element set_properties $form_name flag_pres        -value $flag_pres
    element set_properties $form_name flag_status      -value $flag_status
    element set_properties $form_name cod_raggruppamento -value $cod_raggruppamento
    element set_properties $form_name peso_min           -value $peso_min
    element set_properties $form_name n_anomalie         -value $n_anomalie
    element set_properties $form_name bacharach        -value $bacharach
    element set_properties $form_name co               -value $co
    element set_properties $form_name rend_combust     -value $rend_combust
    element set_properties $form_name tiraggio         -value $tiraggio
    element set_properties $form_name cod_anom         -value $cod_anom
    element set_properties $form_name cod_noin         -value $cod_noin
    element set_properties $form_name tipo_generatore   -value $tipo_generatore;#rom02
    element set_properties $form_name sistema_areazione -value $sistema_areazione;#rom02
    element set_properties $form_name tipo_locale       -value $tipo_locale;#rom02

    element set_properties $form_name f_cod_manu        -value $f_cod_manu ;#but01
    element set_properties $form_name f_manu_cogn       -value $f_manu_cogn;#but01
    element set_properties $form_name f_manu_nome       -value $f_manu_nome;#but01
    element set_properties $form_name f_manu_present_p  -value $f_manu_present_p;#ric01
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
    set cod_zona           [element::get_value $form_name cod_zona];#san01
    set flag_scaduto       [element::get_value $form_name flag_scaduto]
    set data_scad          [element::get_value $form_name data_scad]

    if {$flag_ente == "P" && $sigla_prov != "TN"} {
	set cod_area       [element::get_value $form_name cod_area]
    }

    set flag_oss           [element::get_value $form_name flag_oss]
    set flag_racc          [element::get_value $form_name flag_racc]
    set flag_pres          [element::get_value $form_name flag_pres]
    set flag_status        [element::get_value $form_name flag_status]
    set cod_raggruppamento [element::get_value $form_name cod_raggruppamento]
    set peso_min           [element::get_value $form_name peso_min]
    set n_anomalie         [element::get_value $form_name n_anomalie]
    set bacharach          [element::get_value $form_name bacharach]
    set co                 [element::get_value $form_name co]
    set rend_combust       [element::get_value $form_name rend_combust]
    set tiraggio           [element::get_value $form_name tiraggio]
    set cod_anom           [element::get_value $form_name cod_anom]
    set cod_noin           [element::get_value $form_name cod_noin]
    set flag_tipo_impianto [element::get_value $form_name flag_tipo_impianto]
    set tipo_generatore    [element::get_value $form_name tipo_generatore];#rom02
    set sistema_areazione  [element::get_value $form_name sistema_areazione];#rom02
    set tipo_locale        [element::get_value $form_name tipo_locale];#rom02
 
    set f_cod_manu         [string trim [element::get_value $form_name f_cod_manu]];#but01
    set f_manu_cogn        [string trim [element::get_value $form_name f_manu_cogn]];#but01
    set f_manu_nome        [string trim [element::get_value $form_name f_manu_nome]];#but01
    set f_manu_present_p   [string trim [element::get_value $form_name f_manu_present_p]];#ric01

    set error_num 0

    if {[string equal $tipo_estrazione ""]} {
	element::set_error $form_name tipo_estrazione "Inserire tipo estrazione"
	incr error_num
    }

    if {[string equal $cod_comune ""]} {
	element::set_error $form_name cod_comune "Inserire comune"
	incr error_num

    } else {#san01: aggiunta else e suo contenuto
	set cod_zona [string trim $cod_zona]

	if {$cod_zona ne ""
	&& ![db_0or1row query "
            select 1
              from coimviae
             where cod_comune = :cod_comune
               and cod_zona   = upper(:cod_zona)
             limit 1
           "]
	} {
	    element::set_error $form_name cod_zona "Non esiste la zona indicata nel viario del comune"
	    incr error_num
	};#san01
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

    if {![string equal $cod_area ""] 
   &&   (   ![string equal $cod_comune ""]
	 || ![string equal $f_cod_via ""]
	 || ![string equal $descr_topo ""]
         || ![string equal $descr_via ""])
    } {
	element::set_error $form_name cod_area "Parametro incompatibile con la selezione per comune o indirizzo"
	incr error_num
    }

    #but01 Inizio routine generica per controllo codice manutentore
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
    
    if {[string equal $f_manu_cogn ""] && [string equal $f_manu_nome ""]} {
	set cod_manutentore ""
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
    };#finebut01
#$f_cod_manu
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

    if {![string equal $flag_oss ""]
	&& [string equal $flag_tpes "N"]} {
	element::set_error $form_name flag_oss "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	incr error_num
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

    if {![string equal $flag_status ""]
	&& [string equal $flag_tpes "N"]} {
	element::set_error $form_name flag_status "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	incr error_num
    }

    if {![string equal $bacharach ""]} {
	if { [string equal $flag_tpes "N"]} {
	    element::set_error $form_name flag_status "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	    incr error_num
	} else {
	    set bacharach [iter_check_num $bacharach 2]
	    if {$bacharach == "Error"} {
		element::set_error $form_name bacharach "Bacharach deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $bacharach] >=  [expr pow(10,4)]
		    ||  [iter_set_double $bacharach] <= -[expr pow(10,4)]} {
		    element::set_error $form_name bacharach "Bacharach deve essere inferiore di 10.000"
		    incr error_num
		}
	    }
	    if {[string equal $cod_combustibile ""]} {
		element::set_error $form_name cod_combustibile "Questo valore &egrave; obbligatorio nel caso di ricerca con Bacharach"
		incr error_num
	    }
	}
    }
	
    if {![string equal $co ""]} {
	if { [string equal $flag_tpes "N"]} {
	    element::set_error $form_name flag_status "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	    incr error_num
	} else {
	    set co [iter_check_num $co 4]
	    if {$co == "Error"} {
		element::set_error $form_name co "co deve essere numerico e pu&ograve; avere al massimo 4 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $co] >=  [expr pow(10,7)]
		||  [iter_set_double $co] <= -[expr pow(10,7)]} {
		    element::set_error $form_name co "co deve essere inferiore di 1.000.000"
		    incr error_num
		} else {
		    if {$co < 1} {
			set co [expr $co * 10000]
			set flag_co_perc "t"
		    }
		}
	    }
	}
    }
	
    if {![string equal $rend_combust ""]} {
	if { [string equal $flag_tpes "N"]} {
	    element::set_error $form_name flag_status "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	    incr error_num
	} else {
	    set rend_combust [iter_check_num $rend_combust 2]
	    if {$rend_combust == "Error"} {
		element::set_error $form_name rend_combust "Rendimento combustibile deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    } else {
		if {[iter_set_double $rend_combust] >  [expr pow(10,2)]
		    ||  [iter_set_double $rend_combust] < -[expr pow(10,2)]} {
		    element::set_error $form_name rend_combust "Rendimento combustibile deve essere inferiore di 100"
		    incr error_num
		}
	    }
	}
    }

    if {![string equal $tiraggio ""]} {
	if { [string equal $flag_tpes "N"]} {
	    element::set_error $form_name flag_status "Questo valore pu&ograve; essere inserito solo per l'estrazione di impianti dichiarati"
	    incr error_num
	} else {
	    set tiraggio [iter_check_num $tiraggio 2]
	    if {$tiraggio == "Error"} {
		element::set_error $form_name tiraggio "Tiraggio deve essere numerico e pu&ograve; avere al massimo 2 decimali"
		incr error_num
	    }
	}
    }

    if {![string equal $cod_raggruppamento ""]
	&& ![string equal $tipo_estrazione "7"]} {
	element::set_error $form_name cod_raggruppamento "Questo valore pu&ograve; essere inserito solo per l'estrazione 'Pesi da modelli'"
	incr error_num
    }
    if {![string equal $peso_min ""]
	&& ![string equal $tipo_estrazione "7"]} {
	element::set_error $form_name peso_min "Questo valore pu&ograve; essere inserito solo per l'estrazione 'Pesi da modelli'"
	incr error_num
    }
    if {![string equal $n_anomalie ""]
	&& ![string equal $tipo_estrazione "7"]} {
	element::set_error $form_name n_anomalie "Questo valore pu&ograve; essere inserito solo per l'estrazione 'Pesi da modelli'"
	incr error_num
    }
    
    if {$error_num > 0} {
        ad_return_template
        return
    }
    #dpr74

    set var_contr_refr "";#ric01
    if {[apm_package_version_installed_p "acs-subsite" "5.10.1"]} {#ric01 aggiunta if e contenuto
	set var_contr_refr 0
    }

    #ric01 if {![string equal $__refreshing_p "0"]} { #mat02 sostituito "" con "0" a seguito dell'aggiornamento di openacs}
    if {![string equal $__refreshing_p $var_contr_refr]} {#ric01 modificata if
	#ric01 aggiunto f_manu_present_p
	#rom02 aggiunti tipo_generatore, sistema_areazione e tipo_locale
	#but01 aggiunto f_manu_cogn f_manu_nome f_cod_manu
	ad_returnredirect "coimestr-filter?funzione=V&[export_url_vars nome_funz nome_funz_caller tipo_estrazione cod_combustibile cod_cind anno_inst_da anno_inst_a cod_comune cod_via descr_topo descr_via f_manu_cogn f_manu_nome f_cod_manu num_max cod_cinc cod_area flag_scaduto flag_oss flag_racc flag_pres flag_status cod_raggruppamento peso_min n_anomalie bacharach co rend_combust tiraggio cod_noin cod_anom data_scad flag_tipo_impianto tipo_generatore sistema_areazione tipo_locale cod_zona __refreshing_p f_manu_present_p]"
    }
    #ric01 aggiunto f_manu_present_p
    #rom02 aggiunti tipo_generatore, sistema_areazione e tipo_locale
    #but01 aggiunto f_manu_cogn f_manu_nome f_cod_manu
    set return_url "coimestr-list?funzione=V&[export_url_vars nome_funz nome_funz_caller tipo_estrazione cod_combustibile cod_cind anno_inst_da anno_inst_a cod_comune cod_via descr_topo descr_via f_manu_cogn f_manu_nome f_cod_manu num_max cod_cinc cod_area flag_scaduto flag_oss flag_racc flag_pres flag_status cod_raggruppamento peso_min n_anomalie bacharach co rend_combust cod_anom cod_noin tiraggio data_scad_chk flag_tipo_impianto cod_zona tipo_generatore sistema_areazione tipo_locale f_manu_present_p]"
#fine dpr74

    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template
