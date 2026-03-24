ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Giulio Laurenzi / Katia Coazzoli
    @creation-date   01/04/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimaimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==================================================================================
    mat01 06/03/2026 Aggiunto e gestito il campo note_ubic. Solo per le Marche

    but01 21/06/2023 Aggiunto la classe ah-jquery-date ai campi:data_ini_valid, data_variaz.
    rom06 28/04/2023 Aggiunto il campo unita_immobiliari_servite su segnalazione di Belluzzo, reso visibile per
    rom06            tutti tranne che le Marche perche' lo gestiscono in coimaimp-bis-gest.

    rom05 07/02/2023 Modifica per regione Friuli sulla valorizzazione del campo cod_tpdu in base a cod_cted.

    sim01 20/01/2020 In base all'apposito parametro rendo obbligatori i dati catastali

    rom04 19/01/2019 Per la Regione Marche mostro il campo volimetria_risc e volumetria_raff
    
    gac01 10/12/2018 Aggiunto link_scheda3 per passare alla Scheda 3: Nomina Terzo Responsabile
    
    rom03 29/11/2018 Aggiunto campo cod_cted

    rom02 06/09/2018 Su richiesta della Regione Marche il campo cod_tpdu viene precompilato in base al
    rom02            valore del campo cod_cted del programma coimaimp-gest. Se cod_cted vale E11a, E11b,
    rom02            E12, E13 allora qui si deve vedere "Abitativo"; altrimenti si deve vedere "Altro".

    rom01 02/08/2018 Su richiesta di Sandro aggiunto il campo sezione per tutti.
} {
    
   {cod_impianto      ""}
   {last_cod_impianto ""}
   {funzione         "V"}
   {caller       "index"}
   {nome_funz         ""}
   {nome_funz_caller  ""}
   {extra_par         ""}
   {url_list_aimp     ""}
   {url_aimp          ""}
   {f_cod_via         ""}
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
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]
set link_scheda3 [export_url_vars cod_impianto last_cod_impianto];#gac01

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

db_1row sel_flag_multivie "select flag_multivie from coimtgen"
iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_ente $coimtgen(flag_ente)
set cod_provincia $coimtgen(cod_provincia)
set provincia $coimtgen(sigla_prov)
set cod_comune $coimtgen(cod_comu)
set flag_obbligo_dati_catastali $coimtgen(flag_obbligo_dati_catastali);#sim01

if {$flag_ente == "P"} {
	set cod_ente "P$cod_provincia"
} else {
	set cod_ente "C$cod_comune"
}

set location [ad_conn location]

db_1row q "select flag_tipo_impianto from coimaimp where cod_impianto = :cod_impianto";#rom04

# Personalizzo la pagina

set link_list_script {[export_url_vars last_cod_impianto caller nome_funz nome_funz_caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set link_return $url_list_aimp 
set titolo           "ubicazione"
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

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
                     [list "javascript:window.close()" "Torna alla Gestione"] \
                     [list coimaimp-list?$link_list "Lista Impianti"] \
                     "$page_title"]
}

#preparo il link al programma Storico ubicazioni
set link_stub  [export_url_vars cod_impianto nome_funz_caller url_aimp url_list_aimp]&nome_funz=[iter_get_nomefunz coimstub-list]

set cod_dest_uso    "";#rom02
set descr_dest_uso  "";#rom02
db_1row q "select cod_cted
             from coimaimp
            where cod_impianto = :cod_impianto";#rom02
#rom05 Aggiunte condizione $cod_cted eq "E1" e $cod_cted eq "E11" serve per Regione Friuli
if {$cod_cted eq "E11a" ||
    $cod_cted eq "E11b" ||
    $cod_cted eq "E12"  ||
    $cod_cted eq "E13"  ||
    $cod_cted eq "E1"   ||
    $cod_cted eq "E11"} {#rom02 aggiunta if, else e loro contenuto
    set cod_dest_uso "A"
    set descr_dest_uso "Abitativo"
} else {
    set cod_dest_uso "X"
    set descr_dest_uso "Altro"
};#rom02

set where_cod_tpdu "{{$descr_dest_uso} $cod_dest_uso}";#rom02

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimubic"
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

set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}

form create $form_name \
-html    $onsubmit_cmd


if {$flag_ente == "P"} {
    element create $form_name cod_comune \
    -label   "Comune" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
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

element create $form_name cod_qua \
-label   "Quartiere" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element tabindex 4" \
-optional \
-options [iter_selbox_from_table coimcqua cod_qua descrizione]

element create $form_name cod_urb \
-label   "Unita urbana" \
-widget   select \
-datatype text \
-html    "$disabled_fld {} class form_element" \
-optional \
-options [iter_selbox_from_curb]


#rom02element create $form_name cod_tpdu 
#rom02    -label   "Destinazione d'uso" 
#rom02    -widget   select 
#rom02    -datatype text 
#rom02    -html    "$disabled_fld {} class form_element" 
#rom02    -optional 
#rom02    -options [iter_selbox_from_table coimtpdu cod_tpdu descr_tpdu]

#rom02
element create $form_name cod_tpdu \
    -label   "Destinazione d'uso" \
    -widget   select \
    -datatype text \
    -html    "readonly {} class form_element" \
    -optional \
    -options $where_cod_tpdu

element create $form_name cap \
-label   "cap" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 5 $readonly_fld {} class form_element" \
-optional

element create $form_name provincia \
-label   "Prvincia" \
-widget   text \
-datatype text \
-html    "size 2  2 $readonly_key {} class form_element" \
-optional

element create $form_name numero \
-label   "numero" \
-widget   text \
-datatype text \
-html    "size 3 maxlength 8 $readonly_fld {} class form_element" \
-optional

element create $form_name esponente \
-label   "esopnente" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 3 $readonly_fld {} class form_element" \
-optional

element create $form_name scala \
-label   "scala" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 5 $readonly_fld {} class form_element" \
-optional

element create $form_name piano \
-label   "paino"\
-widget   text \
-datatype text \
-html    "size 2 maxlength 5 $readonly_fld {} class form_element" \
-optional 

element create $form_name interno \
-label   "interno" \
-widget   text \
-datatype text \
-html    "size 2 maxlength 3 $readonly_fld {} class form_element" \
-optional

element create $form_name descr_topo \
-label   "toponimo" \
-widget   text \
-datatype text \
-html    "size 5 maxlength 10 $readonly_fld {} class form_element" \
-optional

element create $form_name descr_via \
-label   "via" \
-widget   text \
-datatype text \
-html    "size 27 maxlength 80 $readonly_fld {} class form_element" \
-optional \
#but01 Aggiunto la classe ah-jquery-date ai campi data_ini_valid, data_variaz.
element create $form_name data_variaz \
-label   "data_variaz" \
-widget   text \
-datatype text \
-html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
-optional

if {$funzione == "M"
 || $funzione == "D"} {
    element create $form_name data_ini_valid \
    -label   "data_ini_valid" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
}


element create $form_name denominatore \
-label   "denominatore" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name gb_x \
-label   "coordinate longitudine" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
-optional

element create $form_name gb_y \
-label   "coordinate latitudine" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 50 $readonly_fld {} class form_element" \
-optional

if {$flag_obbligo_dati_catastali eq "F"} {#sim01

element create $form_name foglio \
-label   "foglio" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name mappale \
-label   "mappale" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional

element create $form_name subalterno \
-label   "subalterno" \
-widget   text \
-datatype text \
-html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
-optional


#rom03 modificato il campo cat_catastale da testo a uno a tendina 
#rom03 widget   text 
    element create $form_name cat_catastale \
    -label   "Cat.Catastale" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -options { { } {{Catasto Terreni} CT} {{Catasto Fabbricati} CF} } \
    -optional

#rom01
element create $form_name sezione \
    -label    "Sezione" \
    -widget    text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

} else {#sim01 else e suo contenuto
	
    element create $form_name foglio \
	-label   "Foglio" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element" 
	
    element create $form_name mappale \
	-label   "Mappale" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element" 
	
    element create $form_name subalterno \
	-label   "Subalterno" \
	-widget   text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element" 
	
    element create $form_name cat_catastale \
	-label   "Tipo Catasto" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-options { { } {{Catasto Terreni} CT} {{Catasto Fabbricati} CF} } 

    element create $form_name sezione \
	-label    "Sezione" \
	-widget    text \
	-datatype text \
	-html    "size 20 maxlength 20 $readonly_fld {} class form_element" 
	
}

if {$flag_viario == "T"
&& ($funzione == "I"
||  $funzione == "M")
} {
    set cerca_viae [iter_search $form_name [ad_conn package_url]/tabgen/coimviae-filter [list dummy f_cod_via dummy descr_via dummy descr_topo cod_comune cod_comune dummy dummy dummy dummy]]
} else {
    set cerca_viae ""
}

element create $form_name localita \
-label   "localita" \
-widget   text \
-datatype text \
-html    "size 40 maxlength 40 $readonly_fld {} class form_element" \
-optional

#rom03
element create $form_name cod_cted \
    -label   "cod_cted" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimcted cod_cted "cod_cted||' '||descr_cted"] \

if {$coimtgen(regione) eq "MARCHE"} {#rom04 aggiunte if, else e loro contenuto
    element create $form_name volimetria_risc \
	-label   "Volimetria riscaldata" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional
    element create $form_name volimetria_raff \
	-label   "Volimetria raffrescata" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional

    #mat01
    element create $form_name note_ubic \
	-label   "Note" \
	-widget   textarea \
	-datatype text \
	-html    "cols 60 rows 3 $readonly_fld {} class form_element" \
	-optional
    
    element create $form_name unita_immobiliari_servite -widget hidden -datatype text -optional;#rom06
} else {
    element create $form_name volimetria_risc -widget hidden -datatype text -optional
    element create $form_name volimetria_raff -widget hidden -datatype text -optional
    element create $form_name note_ubic -widget hidden -datatype text -optional;#mat01
    
    #rom06
    element create $form_name unita_immobiliari_servite \
	-label   "Unità immobiliari servite" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{{} {}} {Unica U} {"Più unità" "P"}}

};#rom04
    
element create $form_name f_cod_via     -widget hidden -datatype text -optional
element create $form_name cod_impianto  -widget hidden -datatype text -optional
element create $form_name url_list_aimp -widget hidden -datatype text -optional
element create $form_name url_aimp      -widget hidden -datatype text -optional
element create $form_name funzione      -widget hidden -datatype text -optional
element create $form_name caller        -widget hidden -datatype text -optional
element create $form_name nome_funz     -widget hidden -datatype text -optional
element create $form_name nome_funz_caller -widget hidden -datatype text -optional
element create $form_name extra_par     -widget hidden -datatype text -optional
element create $form_name data_fin_valid -widget hidden -datatype text -optional
element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_impianto -widget hidden -datatype text -optional
element create $form_name dummy         -widget hidden -datatype text -optional
if {$funzione != "M"
 && $funzione != "D"} {
    element create $form_name data_ini_valid -widget hidden -datatype text -optional
}

if {[form is_request $form_name]} {
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    element set_properties $form_name f_cod_via         -value $f_cod_via
    element set_properties $form_name provincia         -value $provincia 

    if {![db_0or1row recup_date {}] == 0} {
        element set_properties $form_name data_ini_valid  -value $data_ini_valid
        element set_properties $form_name data_fin_valid  -value $data_fin_valid
    }
   
    if {$funzione == "I"} {
      # TODO: settare eventuali default!!
        
    } else {

      # leggo riga
	if {$flag_viario == "T"} {
	    set indirizzo   [db_map sel_aimp_coimviae3]
	    set coimviae    [db_map sel_aimp_coimviae1]
	    set where_viae  [db_map sel_aimp_coimviae2]
	} else {
	    set indirizzo ", a.indirizzo as descr_via
                           , a.toponimo  as descr_topo"
            set coimviae   ""
	    set where_viae ""
	}

        if {[db_0or1row sel_aimp {}] == 0} {
            iter_return_complaint "Record non trovato"
	}
   
        element set_properties $form_name cod_impianto     -value $cod_impianto
        element set_properties $form_name localita         -value $localita   
        element set_properties $form_name descr_via        -value $descr_via
	element set_properties $form_name descr_topo       -value $descr_topo
        element set_properties $form_name numero           -value $numero
        element set_properties $form_name esponente        -value $esponente
        element set_properties $form_name scala            -value $scala  
        element set_properties $form_name piano            -value $piano
        element set_properties $form_name interno          -value $interno
        element set_properties $form_name cod_comune       -value $cod_comune
        element set_properties $form_name cod_qua          -value $cod_qua
        element set_properties $form_name cod_urb          -value $cod_urb
        element set_properties $form_name cap              -value $cap
        element set_properties $form_name cod_tpdu         -value $cod_tpdu
        #data_installazione
        element set_properties $form_name data_variaz      -value $data_variaz
        element set_properties $form_name f_cod_via        -value $cod_via
	element set_properties $form_name gb_x             -value $gb_x
	element set_properties $form_name gb_y             -value $gb_y
	element set_properties $form_name foglio           -value $foglio
	element set_properties $form_name mappale          -value $mappale
        element set_properties $form_name subalterno       -value $subalterno
        element set_properties $form_name denominatore     -value $denominatore
        element set_properties $form_name cat_catastale    -value $cat_catastale
	element set_properties $form_name sezione          -value $sezione;#rom01
	element set_properties $form_name cod_cted         -value $cod_cted;#rom03
	element set_properties $form_name volimetria_risc  -value $volimetria_risc;#rom04
        element set_properties $form_name volimetria_raff  -value $volimetria_raff;#rom04
	element set_properties $form_name unita_immobiliari_servite -value $unita_immobiliari_servite;#rom06
	element set_properties $form_name note_ubic -value $note_ubic;#mat01
        #recupero ultima variazione effettuata
        db_1row ultima_mod ""
        if {![string equal $data_variaz ""]} {
            element set_properties $form_name data_variaz  -value $data_variaz
	}
    }

}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set localita         [element::get_value $form_name localita]
    set descr_topo       [element::get_value $form_name descr_topo]
    set descr_via        [element::get_value $form_name descr_via]
    set numero           [element::get_value $form_name numero]
    set esponente        [element::get_value $form_name esponente]
    set scala            [element::get_value $form_name scala]
    set piano            [element::get_value $form_name piano]
    set interno          [element::get_value $form_name interno]
    set cod_comune       [element::get_value $form_name cod_comune]
    set cod_qua          [element::get_value $form_name cod_qua]
    set cod_urb          [element::get_value $form_name cod_urb]
    set cap              [element::get_value $form_name cap]
    set cod_tpdu         [element::get_value $form_name cod_tpdu]
    set url_list_aimp    [element::get_value $form_name url_list_aimp]
    set url_aimp         [element::get_value $form_name url_aimp]
    set data_ini_valid   [element::get_value $form_name data_ini_valid]
    set data_fin_valid   [element::get_value $form_name data_fin_valid]
    set data_variaz      [element::get_value $form_name data_variaz]
    set f_cod_via        [element::get_value $form_name f_cod_via]
    set cod_via          ""
    set gb_x             [string trim [element::get_value $form_name gb_x]]
    set gb_y             [string trim [element::get_value $form_name gb_y]]
    set foglio           [string trim [element::get_value $form_name foglio]]
    set mappale          [string trim [element::get_value $form_name mappale]]
    set subalterno       [string trim [element::get_value $form_name subalterno]]
    set denominatore     [string trim [element::get_value $form_name denominatore]]
    set cat_catastale    [string trim [element::get_value $form_name cat_catastale]]
    set sezione          [string trim [element::get_value $form_name sezione]];#rom01
    set cod_cted         [string trim [element::get_value $form_name cod_cted]];#rom03
    set volimetria_risc  [string trim [element::get_value $form_name volimetria_risc]];#rom04
    set volimetria_raff  [string trim [element::get_value $form_name volimetria_raff]];#rom04
    set unita_immobiliari_servite  [string trim [element::get_value $form_name unita_immobiliari_servite]];#rom06
    set note_ubic             [element::get_value $form_name note_ubic];#mat01
  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    if {$funzione == "I"
    ||  $funzione == "M"
    } {

	if {$coimtgen(regione) ne "MARCHE"} {#rom06 Aggiunta if e il suo contenuto
	    if {$unita_immobiliari_servite == ""} {
		element::set_error $form_name unita_immobiliari_servite "Inserire Unità Immobiliari Servite"
		incr error_num
	    }
	}
	
	if {$coimtgen(regione) eq "MARCHE" && [string equal $cod_cted ""]} {#rom03 aggiunta if e suo contenuto
	    element::set_error $form_name cod_cted "Inserire Categoria edificio"
	    incr error_num
	};#rom03
	    if {[string equal $volimetria_risc ""]} {#rom04 if, else e contenuto
		set volimetria_risc 0
	    } else {
		set volimetria_risc [iter_check_num $volimetria_risc 2]
		if {$volimetria_risc == "Error"} {
		    element::set_error $form_name volimetria_risc "numerico con al massimo 2 decimali"
		    incr error_num
		} else {
		    if {[iter_set_double $volimetria_risc] >=  [expr pow(10,7)]
			||  [iter_set_double $volimetria_risc] <= -[expr pow(10,7)]} {
			element::set_error $form_name volimetria_risc "deve essere < di 10.000.000"
			incr error_num
		    }
		}
	    };#rom04
	    if {[string equal $volimetria_raff ""]} {#rom04 if, else e contenuto
		set volimetria_raff 0
	    } else {
		set volimetria_raff [iter_check_num $volimetria_raff 2]
		if {$volimetria_raff == "Error"} {
		    element::set_error $form_name volimetria_raff "numerico con al massimo 2 decimali"
		    incr error_num
		} else {
		    if {[iter_set_double $volimetria_raff] >=  [expr pow(10,7)]
			||  [iter_set_double $volimetria_raff] <= -[expr pow(10,7)]} {
			element::set_error $form_name volimetria_raff "deve essere < di 10.000.000"
			incr error_num
		    }
		}
	    };#rom04
	
	# se la via � valorizzata, ma manca il comune: errore
        if {![string equal $descr_via  ""]
	||  ![string equal $descr_topo ""]
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
	    if {[string equal $descr_via  ""]
	    &&  [string equal $descr_topo ""]
	    } {
		if {($localita ne "") && ([string length $localita] > 3)} {
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
		element::set_error $form_name descr_via $chk_out_msg
		incr error_num
	    }
	}
        #se il quartiere � valorizzato, ma manca il comune: errore
        if {![string equal $cod_qua ""]
          && [string equal $cod_comune ""]} {
              element::set_error $form_name cod_comune "valorizzare il Comune"
              incr error_num
        } 

        #se il quartiere ha un comune diverso da quello selezionato: errore
        if {![string equal $cod_qua ""]
         && ![string equal $cod_comune ""]} {
         if {[db_0or1row  recup_comune_qua ""] ==0} {
              element::set_error $form_name cod_qua "quartiere estraneo al Comune"
              incr error_num
	    }
        }

        #se l'area urbana � valorizzata, ma manca il comune: errore
        if {![string equal $cod_urb ""]
          && [string equal $cod_comune ""]} {
              element::set_error $form_name cod_comune "valorizzare il Comune"
              incr error_num
        } 

        #se l'area urbana ha un comune diverso da quello selezionato: errore
        if {![string equal $cod_urb ""]
         && ![string equal $cod_comune ""]} {
         if {[db_0or1row  recup_comune_urb ""] ==0} {
              element::set_error $form_name cod_urb "area urbana estranea al Comune"
              incr error_num
	    }
        }


	if {![string equal $numero ""]} {
            set numero [iter_check_num $numero 0]
            if {$numero == "Error"} {
                element::set_error $form_name numero "il civico deve essere numerico"
                incr error_num
	    }
	}

	if {![string equal $cap ""]
        &&  ![string is integer $cap] 
        } {
            incr error_num
	    element::set_error $form_name cap "Il Cap deve essere numerico"
	}
       
        if {![string equal $gb_x ""]} {
            set gb_x [iter_check_num $gb_x 10]
            if {$gb_x == "Error"} {
                element::set_error $form_name gb_x "numerico con al massimo 17 decimali"
                incr error_num
            } else {
                if {[iter_set_double $gb_x] >=  [expr pow(10,2)]
                ||  [iter_set_double $gb_x] <= -[expr pow(10,2)]} {
                    element::set_error $form_name gb_x "deve essere < di 100"
                    incr error_num
		}
            }
        }

        if {![string equal $gb_y ""]} {
            set gb_y [iter_check_num $gb_y 10]
            if {$gb_y == "Error"} {
                element::set_error $form_name gb_y "numerico con al massimo 17 decimali"
                incr error_num
            } else {
                if {[iter_set_double $gb_y] >=  [expr pow(10,2)]
                ||  [iter_set_double $gb_y] <= -[expr pow(10,2)]} {
                    element::set_error $form_name gb_y "deve essere < di 100"
                    incr error_num
		}
            }
        }

    }

    if {$funzione == "M"
    ||  $funzione == "D"} {
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

        #non � possibile storicizzare modifiche con data_validit� inferiore a mod         ifiche gi� storicizzate 
 
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
    
    
    if {$error_num > 0} {
        ad_return_template
        return
    }
  
    set sw_query "N"
    set dml_sql_stub ""

    if {$funzione == "M"
    ||  $funzione == "D"} {
        #leggo il record originale(prima delle modifiche)dalla tabella coimaimp
        if {![db_0or1row sel_aimp_db {}] == 0} {
            #se almeno un campo dell'ubicazioni � stato modificato rispetto al r             ecord originale (tranne il caso in cui l'originale fosse = ""),viene             storicizzato il record pre-modifica.
	    if {(![string equal $db_localita ""] &&
                 $db_localita       != $localita) 
             || (![string equal $db_cod_via ""] &&
                 $db_cod_via        != $cod_via)
             || (![string equal $db_numero ""] &&
                 $db_numero         != $numero)
             || (![string equal $db_esponente ""] &&
                 $db_esponente      != $esponente)
             || (![string equal $db_scala ""] &&
                 $db_scala          != $scala)
             || (![string equal $db_piano ""] &&
                 $db_piano          != $piano)
             || (![string equal $db_interno ""] &&
                 $db_interno        != $interno)
             || (![string equal $db_cod_comune ""] &&
                 $db_cod_comune     != $cod_comune)
             || (![string equal $db_cap ""] &&
                 $db_cap            != $cap) 
             || (![string equal $db_cod_provincia ""] &&
                 $db_cod_provincia  != $cod_provincia)     
             || (![string equal $db_cod_tpdu ""] &&
                 $db_cod_tpdu       != $cod_tpdu)
             || (![string equal $db_descr_topo ""] &&
                 $db_descr_topo     != $descr_topo)
             || (![string equal $db_descr_via ""] &&
                 $db_descr_via      != $descr_via)
	    } {
                if {[db_0or1row  sel_stub_check ""] ==0} {
                    set dml_sql_stub [db_map ins_stub]
                    set sw_query "S"
		}
	    }
	}
    }

    switch $funzione {
        M {set dml_sql [db_map upd_aimp]}
        D {set dml_sql [db_map del_aimp]}
    }

  # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]
     && [info exists dml_sql_stub]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimaimp $dml_sql
                if {$sw_query == "S"} {
                    db_dml dml_coimaimp $dml_sql_stub
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
    if {$funzione == "I"} {
        set last_cod_impianto $cod_impianto
    }
    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto last_cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimaimp-ubic?funzione=V&$link_gest"}
        D {set return_url   "coimaimp-ubic?funzione=V&$link_gest"}
        I {set return_url   "coimaimp-ubic?funzione=V&$link_gest"}
        V {set return_url   "coimaimp-gest?&url_list_aimp&url_aimp"}
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
