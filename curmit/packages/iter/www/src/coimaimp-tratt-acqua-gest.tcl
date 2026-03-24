ad_page_contract {
    Add/Edit/Delete  form per la gestione del trattamento acqua
    @author          Simone Pesci
    @creation-date   12/11/2014

    @param funzione  M=edit V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimaimp-tratt-acqua-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================================
    rom02 01/12/2021 Manutenzione evolutiva CURMIT-2021-11: Integrate le voci del campo tratt_acqua_calda_sanit_tipo
    rom02            indicando le stesse voci del campo tratt_acqua_clima_tipo. Sandro ha detto che va bene per tutti.

    rom01 07/11/2018 Inserito controllo su tratt_acqua_raff_assente.
    rom01            Aggiunti i campi: tratt_acqua_raff_filtraz_note_altro, tratt_acqua_raff_tratt_note_altro,
    rom01            tratt_acqua_raff_cond_note_altro.
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
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "M" {set lvl 3}
}
 
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]

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
set link_return $url_list_aimp 
set titolo           "Trattamento acqua"
switch $funzione {
    M {set button_label "Conferma Modifica" 
       set page_title   "Modifica $titolo"}
    V {set button_label "Torna alla lista"
       set page_title   "Visualizzazione $titolo"}
}

if {$caller == "index"} {
    set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]
} else {
    set context_bar  [iter_context_bar \
                     [list "javascript:window.close()" "Torna alla Gestione"] \
                     [list coimaimp-list?$link_list "Lista Impianti"] \
                     "$page_title"]
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
switch $funzione {
   "M" {set readonly_fld \{\}
        set disabled_fld \{\}
       }
}

form create $form_name \
-html    $onsubmit_cmd

element create $form_name tratt_acqua_contenuto \
    -label   "Contenuto d'acqua" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $readonly_fld {} class form_element"  \
    -optional 

element create $form_name tratt_acqua_durezza \
    -label   "Durezza totale" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_clima_tipo \
    -label   "Climatizzazione" \
    -widget   select \
    -options  {{{} {}} {NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {Filtr.+Addolc. K} {Filtr.+Cond.Ch. J} {Cond.Ch.+Addolc. W} {Filt.+Cond.Ch.+Addolc. T}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tratt_acqua_clima_addolc \
    -label   "Addolcimento" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_clima_prot_gelo \
    -label   "Protezione del gelo" \
    -widget   select \
    -options  {{{} {}} {Assente A} {{Glicole etilenico} E}  {{Glicole propilenico} P} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tratt_acqua_clima_prot_gelo_eti_perc \
    -label   "% etilenico" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_clima_prot_gelo_eti \
    -label   "pH etilenico" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_clima_prot_gelo_pro_perc \
    -label   "% propilenico" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_clima_prot_gelo_pro \
    -label   "pH propilenico" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

#rom02 modificate le options  {{{} {}} {Assente A} {Filtrazione F}  {Addolcimento D} {{Condizionamento chimico} C} {{} {}}} 
element create $form_name tratt_acqua_calda_sanit_tipo \
    -label   "Acqua calda sanitaria" \
    -widget   select \
    -options  {{{} {}} {NonRichiesto R} {Assente A} {Filtrazione F}  {Addolcimento D} {Cond.Chimico C} {Filtr.+Addolc. K} {Filtr.+Cond.Ch. J} {Cond.Ch.+Addolc. W} {Filt.+Cond.Ch.+Addolc. T}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tratt_acqua_calda_sanit_addolc \
    -label   "Addolcimento" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_raff_assente \
    -label   "Climatizzazione Estiva assente" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tipo_circuito \
    -label   "Tipo circuito di raffreddamento" \
    -widget   select \
    -options  {{{} {}} {{senza recupero termico} S} {{a recupero termico parziale} P} {{a recupero termico totale} T} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tratt_acqua_raff_origine \
    -label   "Origine acqua di alimento" \
    -widget   select \
    -options  {{{} {}} {Acquedotto A} {Pozzo P}  {{Acqua superficiale} S} {{} {}}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name tratt_acqua_raff_filtraz_flag \
    -label   "Filtrazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_filtraz_1 \
    -label   "Filtrazione di sicurezza" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_filtraz_2 \
    -label   "Filtrazione a masse" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_filtraz_3 \
    -label   "Altro" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_filtraz_4 \
    -label   "Nessun trattamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_flag \
    -label   "Trattamento acqua" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_1 \
    -label   "Addolcimento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_2 \
    -label   "Osmosi inversa" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_3 \
    -label   "Demineralizzazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_4 \
    -label   "Altro" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_tratt_5 \
    -label   "Nessun trattamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_flag \
    -label   "Condizionamento chimico" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_1 \
    -label   "Azione antincrostante" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_2 \
    -label   "Azione anticorrosiva" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_3 \
    -label   "Azione antincrostante e anticorrosiva" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_4 \
    -label   "Biocida" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_5 \
    -label   "Altro" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_cond_6 \
    -label   "Nessun trattamento" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_spurgo_flag\
    -label   "Spurgo automatico" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name tratt_acqua_raff_spurgo_cond_ing \
    -label   "Conducibilità acqua" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

element create $form_name tratt_acqua_raff_spurgo_tara_cond \
    -label   "Taratura conducibilità" \
    -widget   text \
    -datatype text \
    -html    "size 9 maxlength 11 $readonly_fld {} class form_element"  \
    -optional

if {$funzione == "M"} {
    element create $form_name data_ini_valid \
    -label   "data_ini_valid" \
    -widget   text \
    -datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional
}

#rom01
element create $form_name tratt_acqua_raff_filtraz_note_altro \
    -label "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 2 $readonly_fld {} class form_element" \
    -optional
#rom01
element create $form_name tratt_acqua_raff_tratt_note_altro   \
    -label "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 2 $readonly_fld {} class form_element" \
    -optional
#rom01
element create $form_name tratt_acqua_raff_cond_note_altro    \
    -label "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 30 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name cod_impianto         -widget hidden -datatype text -optional
element create $form_name url_list_aimp        -widget hidden -datatype text -optional
element create $form_name url_aimp             -widget hidden -datatype text -optional
element create $form_name funzione             -widget hidden -datatype text -optional
element create $form_name caller               -widget hidden -datatype text -optional
element create $form_name nome_funz            -widget hidden -datatype text -optional
element create $form_name nome_funz_caller     -widget hidden -datatype text -optional
element create $form_name extra_par            -widget hidden -datatype text -optional
element create $form_name data_fin_valid       -widget hidden -datatype text -optional
element create $form_name submit               -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_impianto    -widget hidden -datatype text -optional
element create $form_name dummy                -widget hidden -datatype text -optional
if {$funzione != "M"
    && $funzione != "D"} {
    element create $form_name data_ini_valid   -widget hidden -datatype text -optional
}

if {[form is_request $form_name]} {
    element set_properties $form_name funzione             -value $funzione
    element set_properties $form_name url_list_aimp        -value $url_list_aimp
    element set_properties $form_name url_aimp             -value $url_aimp
    element set_properties $form_name caller               -value $caller
    element set_properties $form_name nome_funz            -value $nome_funz
    element set_properties $form_name nome_funz_caller     -value $nome_funz_caller
    element set_properties $form_name extra_par            -value $extra_par
    element set_properties $form_name last_cod_impianto    -value $last_cod_impianto

    if {[db_0or1row sel_tratt_acqua {}] == 0} {
            iter_return_complaint "Record non trovato"
    }
   
    element set_properties $form_name cod_impianto                         -value $cod_impianto
    element set_properties $form_name tratt_acqua_contenuto                -value $tratt_acqua_contenuto
    element set_properties $form_name tratt_acqua_durezza                  -value $tratt_acqua_durezza
    element set_properties $form_name tratt_acqua_clima_tipo               -value $tratt_acqua_clima_tipo
    element set_properties $form_name tratt_acqua_clima_addolc             -value $tratt_acqua_clima_addolc
    element set_properties $form_name tratt_acqua_clima_prot_gelo          -value $tratt_acqua_clima_prot_gelo
    element set_properties $form_name tratt_acqua_clima_prot_gelo_eti      -value $tratt_acqua_clima_prot_gelo_eti
    element set_properties $form_name tratt_acqua_clima_prot_gelo_eti_perc -value $tratt_acqua_clima_prot_gelo_eti_perc
    element set_properties $form_name tratt_acqua_clima_prot_gelo_pro      -value $tratt_acqua_clima_prot_gelo_pro
    element set_properties $form_name tratt_acqua_clima_prot_gelo_pro_perc -value $tratt_acqua_clima_prot_gelo_pro_perc
    element set_properties $form_name tratt_acqua_calda_sanit_tipo         -value $tratt_acqua_calda_sanit_tipo
    element set_properties $form_name tratt_acqua_calda_sanit_addolc       -value $tratt_acqua_calda_sanit_addolc
    element set_properties $form_name tratt_acqua_raff_assente             -value $tratt_acqua_raff_assente
    element set_properties $form_name tratt_acqua_raff_tipo_circuito       -value $tratt_acqua_raff_tipo_circuito
    element set_properties $form_name tratt_acqua_raff_origine             -value $tratt_acqua_raff_origine
    element set_properties $form_name tratt_acqua_raff_filtraz_flag        -value $tratt_acqua_raff_filtraz_flag
    element set_properties $form_name tratt_acqua_raff_filtraz_1           -value $tratt_acqua_raff_filtraz_1
    element set_properties $form_name tratt_acqua_raff_filtraz_2           -value $tratt_acqua_raff_filtraz_2
    element set_properties $form_name tratt_acqua_raff_filtraz_3           -value $tratt_acqua_raff_filtraz_3
    element set_properties $form_name tratt_acqua_raff_filtraz_4           -value $tratt_acqua_raff_filtraz_4
    element set_properties $form_name tratt_acqua_raff_tratt_flag          -value $tratt_acqua_raff_tratt_flag
    element set_properties $form_name tratt_acqua_raff_tratt_1             -value $tratt_acqua_raff_tratt_1
    element set_properties $form_name tratt_acqua_raff_tratt_2             -value $tratt_acqua_raff_tratt_2
    element set_properties $form_name tratt_acqua_raff_tratt_3             -value $tratt_acqua_raff_tratt_3
    element set_properties $form_name tratt_acqua_raff_tratt_4             -value $tratt_acqua_raff_tratt_4
    element set_properties $form_name tratt_acqua_raff_tratt_5             -value $tratt_acqua_raff_tratt_5
    element set_properties $form_name tratt_acqua_raff_cond_flag           -value $tratt_acqua_raff_cond_flag
    element set_properties $form_name tratt_acqua_raff_cond_1              -value $tratt_acqua_raff_cond_1
    element set_properties $form_name tratt_acqua_raff_cond_2              -value $tratt_acqua_raff_cond_2
    element set_properties $form_name tratt_acqua_raff_cond_3              -value $tratt_acqua_raff_cond_3
    element set_properties $form_name tratt_acqua_raff_cond_4              -value $tratt_acqua_raff_cond_4
    element set_properties $form_name tratt_acqua_raff_cond_5              -value $tratt_acqua_raff_cond_5
    element set_properties $form_name tratt_acqua_raff_cond_6              -value $tratt_acqua_raff_cond_6
    element set_properties $form_name tratt_acqua_raff_spurgo_flag         -value $tratt_acqua_raff_spurgo_flag
    element set_properties $form_name tratt_acqua_raff_spurgo_cond_ing     -value $tratt_acqua_raff_spurgo_cond_ing
    element set_properties $form_name tratt_acqua_raff_spurgo_tara_cond    -value $tratt_acqua_raff_spurgo_tara_cond
    element set_properties $form_name tratt_acqua_raff_filtraz_note_altro  -value $tratt_acqua_raff_filtraz_note_altro;#rom01
    element set_properties $form_name tratt_acqua_raff_tratt_note_altro    -value $tratt_acqua_raff_tratt_note_altro  ;#rom01
    element set_properties $form_name tratt_acqua_raff_cond_note_altro     -value $tratt_acqua_raff_cond_note_altro   ;#rom01
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set url_list_aimp                           [element::get_value $form_name url_list_aimp]
    set url_aimp                                [element::get_value $form_name url_aimp]
    set data_fin_valid                          [element::get_value $form_name data_fin_valid]
    set data_ini_valid                          [element::get_value $form_name data_ini_valid]

    set cod_impianto                            [element::get_value $form_name cod_impianto]
    set tratt_acqua_contenuto                   [element::get_value $form_name tratt_acqua_contenuto]
    set tratt_acqua_durezza                     [element::get_value $form_name tratt_acqua_durezza]
    set tratt_acqua_clima_tipo                  [element::get_value $form_name tratt_acqua_clima_tipo]
    set tratt_acqua_clima_addolc                [element::get_value $form_name tratt_acqua_clima_addolc]
    set tratt_acqua_clima_prot_gelo             [element::get_value $form_name tratt_acqua_clima_prot_gelo]
    set tratt_acqua_clima_prot_gelo_eti         [element::get_value $form_name tratt_acqua_clima_prot_gelo_eti]
    set tratt_acqua_clima_prot_gelo_eti_perc    [element::get_value $form_name tratt_acqua_clima_prot_gelo_eti_perc]
    set tratt_acqua_clima_prot_gelo_pro         [element::get_value $form_name tratt_acqua_clima_prot_gelo_pro]
    set tratt_acqua_clima_prot_gelo_pro_perc    [element::get_value $form_name tratt_acqua_clima_prot_gelo_pro_perc]
    set tratt_acqua_calda_sanit_tipo            [element::get_value $form_name tratt_acqua_calda_sanit_tipo]
    set tratt_acqua_calda_sanit_addolc          [element::get_value $form_name tratt_acqua_calda_sanit_addolc]
    set tratt_acqua_raff_assente                [element::get_value $form_name tratt_acqua_raff_assente]
    set tratt_acqua_raff_tipo_circuito          [element::get_value $form_name tratt_acqua_raff_tipo_circuito]
    set tratt_acqua_raff_origine                [element::get_value $form_name tratt_acqua_raff_origine]
    set tratt_acqua_raff_filtraz_flag           [element::get_value $form_name tratt_acqua_raff_filtraz_flag]
    set tratt_acqua_raff_filtraz_1              [element::get_value $form_name tratt_acqua_raff_filtraz_1]
    set tratt_acqua_raff_filtraz_2              [element::get_value $form_name tratt_acqua_raff_filtraz_2]
    set tratt_acqua_raff_filtraz_3              [element::get_value $form_name tratt_acqua_raff_filtraz_3]
    set tratt_acqua_raff_filtraz_4              [element::get_value $form_name tratt_acqua_raff_filtraz_4]
    set tratt_acqua_raff_tratt_flag             [element::get_value $form_name tratt_acqua_raff_tratt_flag]
    set tratt_acqua_raff_tratt_1                [element::get_value $form_name tratt_acqua_raff_tratt_1]
    set tratt_acqua_raff_tratt_2                [element::get_value $form_name tratt_acqua_raff_tratt_2]
    set tratt_acqua_raff_tratt_3                [element::get_value $form_name tratt_acqua_raff_tratt_3]
    set tratt_acqua_raff_tratt_4                [element::get_value $form_name tratt_acqua_raff_tratt_4]
    set tratt_acqua_raff_tratt_5                [element::get_value $form_name tratt_acqua_raff_tratt_5]
    set tratt_acqua_raff_cond_flag              [element::get_value $form_name tratt_acqua_raff_cond_flag]
    set tratt_acqua_raff_cond_1                 [element::get_value $form_name tratt_acqua_raff_cond_1]
    set tratt_acqua_raff_cond_2                 [element::get_value $form_name tratt_acqua_raff_cond_2]
    set tratt_acqua_raff_cond_3                 [element::get_value $form_name tratt_acqua_raff_cond_3]
    set tratt_acqua_raff_cond_4                 [element::get_value $form_name tratt_acqua_raff_cond_4]
    set tratt_acqua_raff_cond_5                 [element::get_value $form_name tratt_acqua_raff_cond_5]
    set tratt_acqua_raff_cond_6                 [element::get_value $form_name tratt_acqua_raff_cond_6]
    set tratt_acqua_raff_spurgo_flag            [element::get_value $form_name tratt_acqua_raff_spurgo_flag]
    set tratt_acqua_raff_spurgo_cond_ing        [element::get_value $form_name tratt_acqua_raff_spurgo_cond_ing]
    set tratt_acqua_raff_spurgo_tara_cond       [element::get_value $form_name tratt_acqua_raff_spurgo_tara_cond]
    set tratt_acqua_raff_filtraz_note_altro     [element::get_value $form_name tratt_acqua_raff_filtraz_note_altro];#rom01
    set tratt_acqua_raff_tratt_note_altro       [element::get_value $form_name tratt_acqua_raff_tratt_note_altro]  ;#rom01
    set tratt_acqua_raff_cond_note_altro        [element::get_value $form_name tratt_acqua_raff_cond_note_altro]   ;#rom01
    
    
  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {![string equal $tratt_acqua_contenuto ""]} {
	set tratt_acqua_contenuto [iter_check_num $tratt_acqua_contenuto 2]
	if {$tratt_acqua_contenuto == "Error"} {
	    element::set_error $form_name tratt_acqua_contenuto "Inserire un valore numerico"
	    incr error_num
	}
    }

    if {![string equal $tratt_acqua_durezza ""]} {
        set tratt_acqua_durezza [iter_check_num $tratt_acqua_durezza 2]
        if {$tratt_acqua_durezza == "Error"} {
            element::set_error $form_name tratt_acqua_durezza "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_clima_addolc ""]} {
        set tratt_acqua_clima_addolc [iter_check_num $tratt_acqua_clima_addolc 2]
        if {$tratt_acqua_clima_addolc == "Error"} {
            element::set_error $form_name tratt_acqua_clima_addolc "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_clima_prot_gelo_eti ""]} {
        set tratt_acqua_clima_prot_gelo_eti [iter_check_num $tratt_acqua_clima_prot_gelo_eti 2]
        if {$tratt_acqua_clima_prot_gelo_eti == "Error"} {
            element::set_error $form_name tratt_acqua_clima_prot_gelo_eti "Inserire un valore numerico"
            incr error_num
        }
    }
    
    if {![string equal $tratt_acqua_clima_prot_gelo_eti_perc ""]} {
        set tratt_acqua_clima_prot_gelo_eti_perc [iter_check_num $tratt_acqua_clima_prot_gelo_eti_perc 2]
        if {$tratt_acqua_clima_prot_gelo_eti_perc == "Error"} {
            element::set_error $form_name tratt_acqua_clima_prot_gelo_eti_perc "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_clima_prot_gelo_pro ""]} {
        set tratt_acqua_clima_prot_gelo_pro [iter_check_num $tratt_acqua_clima_prot_gelo_pro 2]
        if {$tratt_acqua_clima_prot_gelo_pro == "Error"} {
            element::set_error $form_name tratt_acqua_clima_prot_gelo_pro "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_clima_prot_gelo_pro_perc ""]} {
        set tratt_acqua_clima_prot_gelo_pro_perc [iter_check_num $tratt_acqua_clima_prot_gelo_pro_perc 2]
        if {$tratt_acqua_clima_prot_gelo_pro_perc == "Error"} {
            element::set_error $form_name tratt_acqua_clima_prot_gelo_pro_perc "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_calda_sanit_addolc ""]} {
        set tratt_acqua_calda_sanit_addolc [iter_check_num $tratt_acqua_calda_sanit_addolc 2]
        if {$tratt_acqua_calda_sanit_addolc == "Error"} {
            element::set_error $form_name tratt_acqua_calda_sanit_addolc "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_raff_spurgo_cond_ing ""]} {
        set tratt_acqua_raff_spurgo_cond_ing [iter_check_num $tratt_acqua_raff_spurgo_cond_ing 2]
        if {$tratt_acqua_raff_spurgo_cond_ing == "Error"} {
            element::set_error $form_name tratt_acqua_raff_spurgo_cond_ing "Inserire un valore numerico"
            incr error_num
        }
    }

    if {![string equal $tratt_acqua_raff_spurgo_tara_cond ""]} {
        set tratt_acqua_raff_spurgo_tara_cond [iter_check_num $tratt_acqua_raff_spurgo_tara_cond 2]
        if {$tratt_acqua_raff_spurgo_tara_cond == "Error"} {
            element::set_error $form_name tratt_acqua_raff_spurgo_tara_cond "Inserire un valore numerico"
            incr error_num
        }
    }

    if {[string equal $tratt_acqua_raff_assente "S"] &&
	([string equal $tratt_acqua_raff_filtraz_flag "S"] ||
	 [string equal $tratt_acqua_raff_filtraz_1 "S"]      ||
	 [string equal $tratt_acqua_raff_tratt_flag "S"]   ||
	 [string equal $tratt_acqua_raff_cond_flag "S"]    )
    } {#rom01 aggiunta if e contenuto
	element::set_error $form_name tratt_acqua_raff_assente "Errore: incongruenza nelle scelte"
	incr error_num
    }	
    
    if {[string equal $tratt_acqua_raff_filtraz_3 ""] &&
	![string equal $tratt_acqua_raff_filtraz_note_altro ""]} {#rom01 if, elseif e contenuto
	element::set_error $form_name tratt_acqua_raff_filtraz_note_altro "Compilare solo se \"Altro\" &egrave; \"S&igrave;\""
	incr error_num
    } elseif {![string equal $tratt_acqua_raff_filtraz_3 ""] && [string equal $tratt_acqua_raff_filtraz_note_altro ""]} {
	element::set_error $form_name tratt_acqua_raff_filtraz_note_altro "Compilare il campo note"
	incr error_num
    };#rom01

    if {[string equal $tratt_acqua_raff_tratt_4 ""] &&
	![string equal $tratt_acqua_raff_tratt_note_altro ""]} {#rom01 if, elseif e contenuto
	element::set_error $form_name tratt_acqua_raff_tratt_note_altro "Compilare solo se \"Altro\" &egrave; \"S&igrave;\""
	incr error_num
    } elseif {![string equal $tratt_acqua_raff_tratt_4 ""] && [string equal $tratt_acqua_raff_tratt_note_altro ""]} {
	element::set_error $form_name tratt_acqua_raff_tratt_note_altro "Compilare il campo note"
	incr error_num
    };#rom01
    
    if {[string equal $tratt_acqua_raff_cond_5 ""] &&
	![string equal $tratt_acqua_raff_cond_note_altro ""]} {#rom01 if, elseif e contenuto
	element::set_error $form_name tratt_acqua_raff_cond_note_altro "Compilare solo se \"Altro\" &egrave; \"S&igrave;\""
	incr error_num
    } elseif {![string equal $tratt_acqua_raff_cond_5 ""] && [string equal $tratt_acqua_raff_cond_note_altro ""]} {
	element::set_error $form_name tratt_acqua_raff_cond_note_altro "Compilare il campo note"
	incr error_num
    };#rom01

    if {![string equal $tratt_acqua_raff_filtraz_flag "S"] && 
	([string equal $tratt_acqua_raff_filtraz_1    "S"] ||
	 [string equal $tratt_acqua_raff_filtraz_2    "S"] )
    } {#rom01 if e contenuto
	element::set_error $form_name tratt_acqua_raff_filtraz_flag "Errore: incongruenza nelle scelte"
	incr error_num
    }
    
    if {![string equal $tratt_acqua_raff_tratt_flag "S"] &&
	([string equal $tratt_acqua_raff_tratt_1    "S"] ||
	 [string equal $tratt_acqua_raff_tratt_2    "S"] ||
	 [string equal $tratt_acqua_raff_tratt_3    "S"] )
    } {#rom01 if e contenuto
	element::set_error $form_name tratt_acqua_raff_tratt_flag "Errore: incongruenza nelle scelte"
	incr error_num
    }
    
    if {![string equal $tratt_acqua_raff_cond_flag "S"] &&
	([string equal $tratt_acqua_raff_cond_1    "S"] ||
	 [string equal $tratt_acqua_raff_cond_2    "S"] ||
	 [string equal $tratt_acqua_raff_cond_3    "S"] ||
	 [string equal $tratt_acqua_raff_cond_4    "S"] )
    } {#rom01 if e contenuto
	element::set_error $form_name tratt_acqua_raff_cond_flag "Errore: incongruenza nelle scelte"
	incr error_num
    }
	 
    if {$error_num > 0} {
        ad_return_template
        return
    }
  
    switch $funzione {
        M {set dml_sql [db_map upd_tratt_acqua]}
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

    set link_list      [subst $link_list_script]
    set link_gest      [export_url_vars cod_impianto last_cod_impianto url_list_aimp url_aimp nome_funz nome_funz_caller extra_par caller]
    switch $funzione {
        M {set return_url   "coimaimp-tratt-acqua-gest?funzione=V&$link_gest"}
        V {set return_url   "coimaimp-tratt-acqua-gest?&url_list_aimp&url_aimp"}
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
