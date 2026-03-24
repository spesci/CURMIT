ad_page_contract {
    Add/Edit/Delete  form per la gestione della regolazione e contabilizzazione del calore
    @author          Simone Pesci
    @creation-date   05/01/2014

    @param funzione  M=edit V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param extra_par Variabili extra da restituire alla lista

    @cvs-id          coimaimp-regol-contab-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==================================================================================
   but01 22/06/2023 Aggiunto la classe ah-jquery-date ai campi:regol_curva_ind_iniz_data_inst
                    , regol_curva_ind_iniz_data_dism, regol_data_sost_sistema, data_ini_valid
                    , regol_valv_ind_iniz_data_inst, regol_valv_ind_iniz_data_dism.
    mic01 13/05/2022 Modificata lunghezza massima dei campi regol_curva_ind_iniz_n_punti_reg ,
    mic01            regol_curva_ind_iniz_n_liv_temp, regol_valv_ind_iniz_n_vie e regol_valv_ind_iniz_servo_motore
    mic01            da 30 a 20 caratteri perche' sul db i campi sono varchar(20) e il programma poteva
    mic01            andare in errore.

    rom05 30/03/2022 MEV Regione Marche per sistemi ibridi. Se sono un impianto ibrido associato ad un
    rom05            altro impianto ibrido "principale" e il flag is_regolazione_primaria_unica e' stato
    rom05            messo a N nella scheda 1 allora non devo poter inserire i dati relativi alla 
    rom05            scheda 5.1 ma vedo un messaggio che spiega che i dati relativi alla scheda 5.1 vanno
    rom05            visualizzati dall'impianto ibrido principale.

    rom04 03/02/2021 Corretto errore su modifica rom03

    rom03 03/12/2020 Corretto errore sulla modifica: Le Marche possono avere piu' sistemi di regolazione
    rom03            e valvole di regolazione e gestiscono il tutto con delle liste apposite.
    rom03            Guardare il postgresql.xql
    
    rom02 30/11/2018 Aggiunte le voci "RISC./RAFFRESCAMENTO", "RISC./RAFFRESC./ACQUA CALDA SANIT." e
    rom02            "RAFFRESC./ACQUA CALDA SANIT." al campo contab_tipo_contabiliz.

    rom01 12/11/2018 Aggiunte liste "Sistema reg.ne" e "Valvola reg.ne"

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

iter_get_coimtgen;#rom01

# Controlla lo user
switch $funzione {
    "V" {set lvl 1}
    "M" {set lvl 3}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars cod_impianto url_list_aimp url_aimp last_cod_impianto nome_funz nome_funz_caller extra_par caller]

set visualizza_scheda5_1            "t";#rom05
set cod_impianto_princ               "";#rom05
set cod_impianto_est_ibrido_princ    "";#rom05
set export_vars_ibrido               "";#rom05 

if {$coimtgen(regione) eq "MARCHE"} {#rom01 if e contenuto

    set url_vars_per_coimaimp_gest_e_list [export_url_vars cod_impianto nome_funz nome_funz_caller caller cod_impianto_url_aimp url_list_aimp]
    set funzione_caller $funzione
    set sel_sist_circ_aimp [db_map sel_sist_circ_aimp]
    set sel_valv_rego_aimp [db_map sel_valv_rego_aimp]
    set gest_prog_1 "coimsist-reg-gest"
    set gest_prog_2 "coimvalv-reg-gest"
    set link_aggiungi_1 "<a href=\"$gest_prog_1?funzione=I&funzione_caller=$funzione_caller&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
    set link_aggiungi_2 "<a href=\"$gest_prog_2?funzione=I&funzione_caller=$funzione_caller&$url_vars_per_coimaimp_gest_e_list\">Aggiungi</a>"
    set link_1 "\[export_url_vars  num_sr\]&$url_vars_per_coimaimp_gest_e_list"
    set link_2 "\[export_url_vars  num_vr\]&$url_vars_per_coimaimp_gest_e_list"
    set actions_1 "<td nowrap><a href=\"$gest_prog_1?funzione=V&funzione_caller=$funzione_caller&$link_1\">Selez.</a>"
    set actions_2 "<td nowrap><a href=\"$gest_prog_2?funzione=V&funzione_caller=$funzione_caller&$link_2\">Selez.</a>"
    
    set table_def_1 [list \
			 [list actions_1                   "Azioni"             no_sort $actions_1] \
			 [list num_sr                      "SR n."              no_sort {c}] \
			 [list data_installazione_sr_edit  "Data Inst."         no_sort {c}] \
			 [list data_dismissione_sr_edit    "Data Dism."         no_sort {c}] \
			 [list flag_sostituito_sr_edit     "Sostituito?"        no_sort {c}] \
			 [list fabbricante_sr              "Fabbricante"        no_sort {c}] \
			 [list modello_sr                  "Modello"            no_sort {c}] \
			 [list num_punti_regolaz_sr        "N° punti regolaz."  no_sort {c}] \
			 [list num_lvl_temp_sr             "N° livelli temp."   no_sort {c}] \
			]
    set table_def_2 [list \
			 [list actions_2                   "Azioni"             no_sort $actions_2 ]\
			 [list num_vr                      "VR n."              no_sort {c}] \
                         [list data_installazione_vr_edit  "Data Inst."         no_sort {c}] \
			 [list data_dismissione_vr_edit    "Data Dism."         no_sort {c}] \
			 [list flag_sostituito_vr_edit     "Sostituito?"        no_sort {c}] \
			 [list fabbricante_vr              "Fabbricante"        no_sort {c}] \
			 [list modello_vr                  "Modello"            no_sort {c}] \
			 [list num_vie_vr                  "N° vie"             no_sort {c}] \
			 [list servomotore_vr              "Servomotore"        no_sort {c}] \
		    ]
			      
    set table_result_1 [ad_table -Tmissing_text "Non &egrave; presente nessun Sistema di Regolazione." -Textra_vars {cod_sistema_regolazione_aimp num_sr cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_sist_circ_aimp $table_def_1]

    set table_result_2 [ad_table -Tmissing_text "Non &egrave; presente nessuna Valvola di Regolazione." -Textra_vars {cod_valvola_regolazione_aimp num_vr cod_impianto caller nome_funz nome_funz_caller url_list_aimp url_aimp } go $sel_valv_rego_aimp $table_def_2]

    if {[db_0or1row q "select a.cod_impianto_est   as cod_impianto_est_ibrido_princ
                            , a.cod_impianto       as cod_impianto_princ
                         from coimaimp_ibrido i
                         left join coimaimp   a
                           on a.cod_impianto                  = i.cod_impianto_princ
                        where i.cod_impianto_ibrido           = :cod_impianto
                          and i.is_regolazione_primaria_unica = 'S'" ]} {#rom05 Aggiunta if e il suo contenuto
	set visualizza_scheda5_1 "f"
	set export_vars_ibrido [export_vars -url {{funzione V} {cod_impianto $cod_impianto_princ} nome_funz caller}]
    }

};#rom01

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
set titolo           "Regolazione e contabilizzazione del calore"
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
set jq_date "";#but01
if {$funzione in "M I S"} {#but01 Aggiunta if e contenuto
    set jq_date "class ah-jquery-date"
}


form create $form_name \
-html    $onsubmit_cmd

element create $form_name regol_on_off \
    -label   "Sistema di regolazione ON - OFF" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name regol_curva_integrata \
    -label   "Sistema di regolazione con impostazione della curva climatica integrata nel generatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name regol_curva_indipendente \
    -label   "Sistema di regolazione con impostazione della curva climatica indipendente" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}
#but01 
element create $form_name regol_curva_ind_iniz_data_inst \
    -label   "Data di installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
#but01
element create $form_name regol_curva_ind_iniz_data_dism \
    -label   "Data di dismissione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name regol_curva_ind_iniz_fabbricante \
    -label   "Fabbricante" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 30 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_curva_ind_iniz_modello \
    -label   "Modello" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 30 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_curva_ind_iniz_n_punti_reg \
    -label   "Numero punti di regolazione" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_curva_ind_iniz_n_liv_temp \
    -label   "Numero livelli di temperatura" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_valv_regolazione \
    -label   "Valvole di regolazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}
#but01
element create $form_name regol_valv_ind_iniz_data_inst \
    -label   "Data di installazione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
#but01
element create $form_name regol_valv_ind_iniz_data_dism \
    -label   "Data di dismissione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name regol_valv_ind_iniz_fabbricante \
    -label   "Fabbricante" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 30 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_valv_ind_iniz_modello \
    -label   "Modello" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 30 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_valv_ind_iniz_n_vie \
    -label   "Numero di vie" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_valv_ind_iniz_servo_motore \
    -label   "Servomotore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_sist_multigradino \
    -label   "Sistema di regolazione multigradino" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name regol_sist_inverter \
    -label   "Sistema di regolazione a Inverter del generatore" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name regol_altri_flag \
    -label   "Altri sistemi di regolazione primaria" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S}}

element create $form_name regol_altri_desc_sistema \
    -label   "Descrizione del sistema" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_cod_tprg \
    -label   "Tipo regolazione" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table coimtprg cod_tprg descrizione ordinamento]

element create $form_name regol_valv_termostatiche \
    -label   "VALVOLE TERMOSTATICHE (rif. UNI EN 21)" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Presenti P} {Assenti A}}

element create $form_name regol_valv_due_vie \
    -label   "VALVOLE A DUE VIE" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Presenti P} {Assenti A}}

element create $form_name regol_valv_tre_vie \
    -label   "VALVOLE A TRE VIE" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Presenti P} {Assenti A}}

element create $form_name regol_valv_note \
    -label   "Note" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name regol_telettura \
    -label   "TELELETTURA" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Presenti P} {Assenti A}}

element create $form_name regol_telegestione \
    -label   "TELEGESTIONE" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Presenti P} {Assenti A}}

element create $form_name regol_desc_sistema_iniz \
    -label   "Descrizione del sistema" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional
#but01
element create $form_name regol_data_sost_sistema \
    -label   "Data di sostituzione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name regol_desc_sistema_sost \
    -label   "Descrizione del sistema" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name contab_si_no \
    -label   "UNITA' IMMOBILIARI CONTABILIZZATE" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Si S} {No N}}
#rom02 aggiunte le options {{RISC./ACQUA CALDA SAN.} E} {{RISC./RAFFRESCAMENTO} I}
#rom02 {{RISC./RAFFRES./ACQUA CALDA SANIT.} O} {{RAFFRES./ACQUA CALDA SANIT.} U}
element create $form_name contab_tipo_contabiliz \
    -label   "Se contabilizzate" \
    -widget   select \
    -options  {{{} {}} {RISCALDAMENTO R} {RAFFRESCAMENTO F}  {{ACQUA CALDA SANITARIA} A} {{RISC./ACQUA CALDA SAN.} E} {{RISC./RAFFRESCAMENTO} I} {{RISC./RAFFRES./ACQUA CALDA SANIT.} O} {{RAFFRES./ACQUA CALDA SANIT.} U} }\
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name contab_tipo_sistema \
    -label   "Tipologia sistema" \
    -widget   select \
    -options  {{{} {}} {Diretto D} {Indiretto I}} \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional

element create $form_name contab_desc_sistema_iniz \
    -label   "Descrizione del sistema" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional

element create $form_name contab_data_sost_sistema \
    -label   "Data di sostituzione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional

element create $form_name contab_desc_sistema_sost \
    -label   "Descrizione del sistema (sostituzione del sistema)" \
    -widget   textarea \
    -datatype text \
    -html    "cols 60 rows 2 $readonly_fld {} class form_element" \
    -optional
#but01
if {$funzione == "M"} {
    element create $form_name data_ini_valid \
    -label   "data_ini_valid" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element $jq_date" \
    -optional
}


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

    if {[db_0or1row sel_rego {}] == 0} {
            iter_return_complaint "Record non trovato"
    }

    element set_properties $form_name cod_impianto                      -value $cod_impianto
    element set_properties $form_name regol_on_off                      -value $regol_on_off                     
    element set_properties $form_name regol_curva_integrata             -value $regol_curva_integrata            
    element set_properties $form_name regol_curva_indipendente          -value $regol_curva_indipendente         
    element set_properties $form_name regol_curva_ind_iniz_data_inst    -value $regol_curva_ind_iniz_data_inst   
    element set_properties $form_name regol_curva_ind_iniz_data_dism    -value $regol_curva_ind_iniz_data_dism   
    element set_properties $form_name regol_curva_ind_iniz_fabbricante  -value $regol_curva_ind_iniz_fabbricante 
    element set_properties $form_name regol_curva_ind_iniz_modello      -value $regol_curva_ind_iniz_modello     
    element set_properties $form_name regol_curva_ind_iniz_n_punti_reg  -value $regol_curva_ind_iniz_n_punti_reg 
    element set_properties $form_name regol_curva_ind_iniz_n_liv_temp   -value $regol_curva_ind_iniz_n_liv_temp  
    element set_properties $form_name regol_valv_regolazione            -value $regol_valv_regolazione           
    element set_properties $form_name regol_valv_ind_iniz_data_inst     -value $regol_valv_ind_iniz_data_inst    
    element set_properties $form_name regol_valv_ind_iniz_data_dism     -value $regol_valv_ind_iniz_data_dism    
    element set_properties $form_name regol_valv_ind_iniz_fabbricante   -value $regol_valv_ind_iniz_fabbricante  
    element set_properties $form_name regol_valv_ind_iniz_modello       -value $regol_valv_ind_iniz_modello      
    element set_properties $form_name regol_valv_ind_iniz_n_vie         -value $regol_valv_ind_iniz_n_vie        
    element set_properties $form_name regol_valv_ind_iniz_servo_motore  -value $regol_valv_ind_iniz_servo_motore 
    element set_properties $form_name regol_sist_multigradino           -value $regol_sist_multigradino          
    element set_properties $form_name regol_sist_inverter               -value $regol_sist_inverter              
    element set_properties $form_name regol_altri_flag                  -value $regol_altri_flag                 
    element set_properties $form_name regol_altri_desc_sistema          -value $regol_altri_desc_sistema      
    element set_properties $form_name regol_cod_tprg                    -value $regol_cod_tprg                   
    element set_properties $form_name regol_valv_termostatiche          -value $regol_valv_termostatiche         
    element set_properties $form_name regol_valv_due_vie                -value $regol_valv_due_vie               
    element set_properties $form_name regol_valv_tre_vie                -value $regol_valv_tre_vie               
    element set_properties $form_name regol_valv_note                   -value $regol_valv_note                  
    element set_properties $form_name regol_telettura                   -value $regol_telettura                  
    element set_properties $form_name regol_telegestione                -value $regol_telegestione               
    element set_properties $form_name regol_desc_sistema_iniz           -value $regol_desc_sistema_iniz          
    element set_properties $form_name regol_data_sost_sistema           -value $regol_data_sost_sistema          
    element set_properties $form_name regol_desc_sistema_sost           -value $regol_desc_sistema_sost          
    element set_properties $form_name contab_si_no                      -value $contab_si_no                     
    element set_properties $form_name contab_tipo_contabiliz            -value $contab_tipo_contabiliz           
    element set_properties $form_name contab_tipo_sistema               -value $contab_tipo_sistema              
    element set_properties $form_name contab_desc_sistema_iniz          -value $contab_desc_sistema_iniz         
    element set_properties $form_name contab_data_sost_sistema          -value $contab_data_sost_sistema         
    element set_properties $form_name contab_desc_sistema_sost          -value $contab_desc_sistema_sost 
}

if {[form is_valid $form_name]} {
  # form valido dal punto di vista del templating system

    set url_list_aimp                           [element::get_value $form_name url_list_aimp]
    set url_aimp                                [element::get_value $form_name url_aimp]
    set data_fin_valid                          [element::get_value $form_name data_fin_valid]
    set data_ini_valid                          [element::get_value $form_name data_ini_valid]

    set cod_impianto                            [element::get_value $form_name cod_impianto]
    set regol_on_off                            [element::get_value $form_name regol_on_off]                    
    set regol_curva_integrata                   [element::get_value $form_name regol_curva_integrata]           
    set regol_curva_indipendente                [element::get_value $form_name regol_curva_indipendente]        
    set regol_curva_ind_iniz_data_inst          [element::get_value $form_name regol_curva_ind_iniz_data_inst]  
    set regol_curva_ind_iniz_data_dism          [element::get_value $form_name regol_curva_ind_iniz_data_dism]  
    set regol_curva_ind_iniz_fabbricante        [element::get_value $form_name regol_curva_ind_iniz_fabbricante]
    set regol_curva_ind_iniz_modello            [element::get_value $form_name regol_curva_ind_iniz_modello]    
    set regol_curva_ind_iniz_n_punti_reg        [element::get_value $form_name regol_curva_ind_iniz_n_punti_reg]
    set regol_curva_ind_iniz_n_liv_temp         [element::get_value $form_name regol_curva_ind_iniz_n_liv_temp] 
    set regol_valv_regolazione                  [element::get_value $form_name regol_valv_regolazione]          
    set regol_valv_ind_iniz_data_inst           [element::get_value $form_name regol_valv_ind_iniz_data_inst]   
    set regol_valv_ind_iniz_data_dism           [element::get_value $form_name regol_valv_ind_iniz_data_dism]   
    set regol_valv_ind_iniz_fabbricante         [element::get_value $form_name regol_valv_ind_iniz_fabbricante] 
    set regol_valv_ind_iniz_modello             [element::get_value $form_name regol_valv_ind_iniz_modello]     
    set regol_valv_ind_iniz_n_vie               [element::get_value $form_name regol_valv_ind_iniz_n_vie]       
    set regol_valv_ind_iniz_servo_motore        [element::get_value $form_name regol_valv_ind_iniz_servo_motore]
    set regol_sist_multigradino                 [element::get_value $form_name regol_sist_multigradino]         
    set regol_sist_inverter                     [element::get_value $form_name regol_sist_inverter]             
    set regol_altri_flag                        [element::get_value $form_name regol_altri_flag]                
    set regol_altri_desc_sistema                [element::get_value $form_name regol_altri_desc_sistema]      
    set regol_cod_tprg                          [element::get_value $form_name regol_cod_tprg]                  
    set regol_valv_termostatiche                [element::get_value $form_name regol_valv_termostatiche]        
    set regol_valv_due_vie                      [element::get_value $form_name regol_valv_due_vie]              
    set regol_valv_tre_vie                      [element::get_value $form_name regol_valv_tre_vie]              
    set regol_valv_note                         [element::get_value $form_name regol_valv_note]                 
    set regol_telettura                         [element::get_value $form_name regol_telettura]                 
    set regol_telegestione                      [element::get_value $form_name regol_telegestione]              
    set regol_desc_sistema_iniz                 [element::get_value $form_name regol_desc_sistema_iniz]         
    set regol_data_sost_sistema                 [element::get_value $form_name regol_data_sost_sistema]         
    set regol_desc_sistema_sost                 [element::get_value $form_name regol_desc_sistema_sost]         
    set contab_si_no                            [element::get_value $form_name contab_si_no]                    
    set contab_tipo_contabiliz                  [element::get_value $form_name contab_tipo_contabiliz]          
    set contab_tipo_sistema                     [element::get_value $form_name contab_tipo_sistema]             
    set contab_desc_sistema_iniz                [element::get_value $form_name contab_desc_sistema_iniz]        
    set contab_data_sost_sistema                [element::get_value $form_name contab_data_sost_sistema]        
    set contab_desc_sistema_sost                [element::get_value $form_name contab_desc_sistema_sost] 

  # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0

    if {![string equal $regol_curva_ind_iniz_data_inst ""]} {
	set regol_curva_ind_iniz_data_inst [iter_check_date $regol_curva_ind_iniz_data_inst]
	if {$regol_curva_ind_iniz_data_inst == 0} {
	    element::set_error $form_name regol_curva_ind_iniz_data_inst "Data installazione deve essere una data"
            incr error_num
	}
    }

    if {![string equal $regol_curva_ind_iniz_data_dism ""]} {
        set regol_curva_ind_iniz_data_dism [iter_check_date $regol_curva_ind_iniz_data_dism]
        if {$regol_curva_ind_iniz_data_dism == 0} {
            element::set_error $form_name regol_curva_ind_iniz_data_dism "Data dismissione deve essere una data"
            incr error_num
        }
    }

    if {![string equal $regol_valv_ind_iniz_data_inst ""]} {
        set regol_valv_ind_iniz_data_inst [iter_check_date $regol_valv_ind_iniz_data_inst]
        if {$regol_valv_ind_iniz_data_inst == 0} {
            element::set_error $form_name regol_valv_ind_iniz_data_inst "Data installazione deve essere una data"
            incr error_num
        }
    }

    if {![string equal $regol_valv_ind_iniz_data_dism ""]} {
        set regol_valv_ind_iniz_data_dism [iter_check_date $regol_valv_ind_iniz_data_dism]
        if {$regol_valv_ind_iniz_data_dism == 0} {
            element::set_error $form_name regol_valv_ind_iniz_data_dism "Data dismissione deve essere una data"
            incr error_num
        }
    }

    if {![string equal $regol_data_sost_sistema ""]} {
        set regol_data_sost_sistema [iter_check_date $regol_data_sost_sistema]
        if {$regol_data_sost_sistema == 0} {
            element::set_error $form_name regol_data_sost_sistema "Data sostituzione deve essere una data"
            incr error_num
        }
    }

    if {![string equal $contab_data_sost_sistema ""]} {
        set contab_data_sost_sistema [iter_check_date $contab_data_sost_sistema]
        if {$contab_data_sost_sistema == 0} {
            element::set_error $form_name contab_data_sost_sistema "Data sostituzione deve essere una data"
            incr error_num
        }
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }

    if {$coimtgen(regione) eq "MARCHE"} {#rom03 aggiunta if, else e loro contenuto
	set upd_sis_e_val_reg ""
	
    } else {
	#rom04 corretto rom03 indicando le variabili con i due punti e non con il dollaro
	set upd_sis_e_val_reg "
                     , regol_curva_ind_iniz_data_inst    = :regol_curva_ind_iniz_data_inst
		     , regol_curva_ind_iniz_data_dism    = :regol_curva_ind_iniz_data_dism
		     , regol_curva_ind_iniz_fabbricante  = :regol_curva_ind_iniz_fabbricante
		     , regol_curva_ind_iniz_modello      = :regol_curva_ind_iniz_modello
		     , regol_curva_ind_iniz_n_punti_reg  = :regol_curva_ind_iniz_n_punti_reg
		     , regol_curva_ind_iniz_n_liv_temp   = :regol_curva_ind_iniz_n_liv_temp
		     , regol_valv_ind_iniz_data_inst     = :regol_valv_ind_iniz_data_inst
		     , regol_valv_ind_iniz_data_dism     = :regol_valv_ind_iniz_data_dism
		     , regol_valv_ind_iniz_fabbricante   = :regol_valv_ind_iniz_fabbricante
		     , regol_valv_ind_iniz_modello       = :regol_valv_ind_iniz_modello
		     , regol_valv_ind_iniz_n_vie         = :regol_valv_ind_iniz_n_vie
		     , regol_valv_ind_iniz_servo_motore  = :regol_valv_ind_iniz_servo_motore"
    }
	
    switch $funzione {
        M {set dml_sql [db_map upd_rego]}
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
        M {set return_url   "coimaimp-regol-contab-gest?funzione=V&$link_gest"}
        V {set return_url   "coimaimp-regol-contab-gest?&url_list_aimp&url_aimp"}
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
