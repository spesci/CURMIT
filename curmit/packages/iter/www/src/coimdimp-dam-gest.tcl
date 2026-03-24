ad_page_contract {
    Add/Edit/Delete  form per le tabelle "coimdope_aimp" e "coimdope_gend"
    
    @author          Antonio Pisano, clonato da coim_as_manu-gest
    @creation-date   2015-09-07

    @param funzione  I=insert M=edit D=delete V=view

    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.

    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    @                navigazione con navigation bar

    @param extra_par Variabili extra da restituire alla lista

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    ric01 03/10/2025 Punto 4 MEV Marche: leggo storico ditta di manutenzione.

    mat01 27/01/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.

    sim01 27/07/2021 Inserito il controllo in modo che non sia possibile inserire dichiarazioni con
    sim01            data successiva a oggi.

    gac04 22/11/2019 Se non ho inserito tutti  i campi obbligatori posso entrare in sola visualizzazione
    
    rom01 14/03/2019 Gestita la modifica delle DAM in maniera simile a quella degli RCEE. 

    gac03 16/11/2018 Le voci flag_a, flag_b, flag_c, flag_d, flag_e, flag_f, flag_g non devono
    gac03            piu essere modificabili ma devono essere prese quelle inserite in fase di
    gac03            registrazione.

    gac02 16/07/2018 Gestito la cancellazione con un flag diverso da quello della modifica.
    gac02            La modifica può essere fatta solo dal manutentore se non presente la distinta
    gac02            associata. La cancellazione può essere fatta solo dall'utente amministratore.
    
    gac01 08/05/2018 Aggiunti campi acquisti, scorta o lettura iniziale scorta o lettura finale
    gac01            e consumo annuo per la stagine di risc attuale e per quella precedente

    nic01 11/11/2015 Come chiesto dala provincia di pesaro ed urbino, bisogna aggiornare
    nic01            automaticamente i flag della ditta di manutenzione

} {
    {cod_impianto         ""}
    {cod_dimp             ""}

    {last_cod_dimp        ""}

    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}

    {url_aimp             ""}
    {url_list_aimp        ""}
    {is_only_view         "f"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

if {$is_only_view} {#gac04 aggiunta if e suo contenuto
    set menu 0
    set funzione V
} else {
    set menu 1
}



set questa_pagina [ad_conn url]

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
#set id_utente [ad_get_cookie iter_login_[ns_conn location]]

set cod_manutentore_da_id_utente [iter_check_uten_manu $id_utente]

# gli utenti manutentori non possono modificare una dichiarazione

#rom01 spostato in alto la proc
iter_get_coimtgen
set flag_ente        $coimtgen(flag_ente)         
set sigla_prov       $coimtgen(sigla_prov)
set cod_comu         $coimtgen(cod_comu)
set flag_viario      $coimtgen(flag_viario)

#modifica di sf del 19 12 2016
#simone: Corretto controllo di Sandro. Il manutentore può modificare la Dam solo se non ha una distinta associata
if {$cod_manutentore_da_id_utente ne "" && $funzione ne "I"} {

    set flag_gg_modif_mh $coimtgen(flag_gg_modif_mh);#rom01
    set data_ins [db_string q "select data_ins from coimdimp where cod_dimp = :cod_dimp"];#rom01
    set data_scad_mod [clock format [clock scan "$data_ins $flag_gg_modif_mh day"] -f %Y%m%d];#rom01
    set current_date [iter_set_sysdate];#rom01

    #rom01 aggiunte condizione $data_scad_mod < $current_date
    if {[db_0or1row q "select cod_docu_distinta
                         from coimdimp
                        where cod_dimp = :cod_dimp
                          and cod_docu_distinta is not null"] || $data_scad_mod < $current_date} {
	set flag_modifica "f"
    } else {
	set flag_modifica "t"
    }    
} else {
    set flag_modifica "f"
}

if {$cod_manutentore_da_id_utente eq "" && $funzione ne "I"} {#gac02 if e else e loro contenuto
    set flag_cancella "t"
} else {
    set flag_cancella "f"
}

#if {$cod_manutentore_da_id_utente ne ""} {
#    set flag_modifica "f"
#} else {
#    set flag_modifica "t"
#}


if {$funzione eq "I"} {
    if {$cod_impianto eq ""} {
        iter_return_complaint "E' necessario specificare il codice impianto."
    }
} else {
    if {$cod_dimp eq ""} {
        iter_return_complaint "E' necessario specificare il codice dichiarazione."
    }
}

set titolo "dichiarazione di avvenuta manutenzione"

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

set link_gest [export_url_vars cod_impianto cod_dimp last_cod_dimp caller nome_funz nome_funz_caller extra_par url_aimp url_list_aimp]

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
set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# Personalizzo la pagina
set link_list_script {[export_url_vars nome_funz_caller nome_funz cod_impianto url_list_aimp url_aimp last_cod_dimp caller]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]

set context_bar      [iter_context_bar -nome_funz $nome_funz_caller] 

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "addedit"
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

# Identifico se questa richiesta e' dovuta ad un refresh
element create $form_name __refreshing_p -widget hidden -datatype text -optional
#mat00 13/10/2025
#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
#element set_properties $form_name __refreshing_p -values 0;#mat01
set is_refresh_p [expr {[element::get_value $form_name __refreshing_p] == 1}]

# Se vengo da una refresh, potrei avere il codice manutentore gia' popolato...
element create $form_name cod_manutentore             -widget hidden -datatype text -optional
element create $form_name cod_manutentore_pre_refresh -widget hidden -datatype text -optional;#nic01
set cod_manutentore             [element::get_value $form_name cod_manutentore]
set cod_manutentore_pre_refresh [element::get_value $form_name cod_manutentore_pre_refresh];#nic01
# ...altrimenti cerco di recuperarlo dall'utente.
if {$cod_manutentore eq ""} {
    set cod_manutentore $cod_manutentore_da_id_utente
}

element create $form_name cod_responsabile -widget hidden -datatype text -optional
set cod_responsabile [element::get_value $form_name cod_responsabile]

element create $form_name dam_cognome_dichiarante \
    -label   "Cognome dichiarante" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name dam_nome_dichiarante \
    -label   "Nome dichiarante" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name cognome_manu \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional

element create $form_name nome_manu \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional
    
element create $form_name cognome_opma \
    -label   "Cognome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 200 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_opma \
    -label   "Nome manutentore" \
    -widget   text \
    -datatype text \
    -html    "size 15 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name flag_impianto \
    -label   "Tipo impianto" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"Gruppo termico (GT)" "R"} {"Gruppo frigo/pompa di calore (GF)" "F"}}

element create $form_name dam_tipo_tecnico \
    -label   "In qualita' di" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"" ""} {"Affidatario della manutenzione" "A"} {"Terzo responsabile" "T"}}
    
element create $form_name dam_tipo_manutenzione \
    -label   "Il controllo &egrave; stato effettuato in seguto a..." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"" ""} {"Manutenzione programmata" "M"} {"Nuova installazione/ristrutturazione" "N"} {"Riattivazione impianto/generatore" "R"}}
    
element create $form_name dam_flag_osservazioni \
    -label   "sono presenti osservazioni..." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"No" "f"} {"S&igrave;" "t"}}
    
element create $form_name dam_flag_raccomandazioni \
    -label   "sono presenti raccomandazioni..." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"No" "f"} {"S&igrave;" "t"}}
    
element create $form_name dam_flag_prescrizioni \
    -label   "sono presenti prescrizioni..." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{"No" "f"} {"S&igrave;" "t"}}

element create $form_name cognome_resp \
    -label   "Cognome responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_resp \
    -label   "Nome responsabile" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name toponimo \
    -label   "toponimo" \
    -widget   text \
    -datatype text \
    -html    "size 5 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name indirizzo \
    -label   "via" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 80 readonly {} class form_element" \
    -optional

element create $form_name localita \
    -label   "localita" \
    -widget   text \
    -datatype text \
    -html    "size 29 maxlength 40 readonly {} class form_element" \
    -optional

element create $form_name numero \
    -label   "numero" \
    -widget   text \
    -datatype text \
    -html    "size 3 maxlength 8 readonly {} class form_element" \
    -optional

element create $form_name esponente \
    -label   "esopnente" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 3 readonly {} class form_element" \
    -optional

element create $form_name scala \
    -label   "scala" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 5 readonly {} class form_element" \
    -optional

element create $form_name piano \
    -label   "piano"\
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 5 readonly {} class form_element" \
    -optional 

element create $form_name interno \
    -label   "interno" \
    -widget   text \
    -datatype text \
    -html    "size 2 maxlength 3 readonly {} class form_element" \
    -optional

element create $form_name cod_comune -widget hidden -datatype text -optional
    
element create $form_name descr_comu \
    -label   "Comune" \
    -widget   text \
    -datatype text \
    -html    "size 20 readonly {} class form_element" \
    -optional

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
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_b \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_c \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_d \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_e \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_f \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name flag_g \
    -label   "check" \
    -widget   checkbox \
    -datatype text \
    -html    "disabled {} class form_element" \
    -optional \
    -options  {{Si t}}

element create $form_name cod_impianto_est \
    -label   "cod_impianto_est" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 readonly {} class form_element" \
    -optional

element create $form_name data_dich \
    -label   "Data dichiarazione" \
    -widget   text \
    -datatype text \
    -html    "size 11 maxlength 10 $readonly_fld {} class form_element" \
    -optional 

#gac01 aggiunto campi consumo_annuo, consumo_annuo2, stagione_risc, stagione_risc2, acquisti, acquisti2, scorta_o_lett_iniz, scorta_o_lett_iniz2, scorta_o_lett_fin e scorta_o_lett_fin2
set ast "<font color=red>*</font>";#--- gac01
set cons_annuo ""
set cons_annuo "<font color=blue><small>Se vuoto verrà calcolata la diff. tra Scorta o lettura finale - Scorta o lettura iniziale</small></font>"
element create $form_name consumo_annuo \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 12 $readonly_fld {} class form_element " \
    -optional 

element create $form_name consumo_annuo2 \
    -label   "Consumo annuo" \
    -widget   text \
    -datatype text \
    -html    "size 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name stagione_risc \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

element create $form_name stagione_risc2 \
    -label   "stagione_risc" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

element create $form_name acquisti \
    -label   "Acquisti" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name scorta_o_lett_iniz \
    -label   "Scorta o lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name scorta_o_lett_fin \
    -label   "Scorta o lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name acquisti2 \
    -label   "Acquisti" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name scorta_o_lett_iniz2 \
    -label   "Scorta o lettura iniziale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

element create $form_name scorta_o_lett_fin2 \
    -label   "Scorta o lettura finale" \
    -widget   text \
    -datatype text \
    -html    "size 12 maxlength 12 $readonly_fld {} class form_element" \
    -optional

# Generatori ed operazioni su di essi
set max_righe_generatori 12

# In base al numero di generatori, creo i campi per le operazioni
multirow create campi_manutenzioni \
    gen_prog \
    data_installaz \
    flag_attivo \
    modello \
    matricola \
    fabbricante \
    installatore \
    campo_riguarda_p \
    data_ult_man_o_disatt \
    campo_data_ult_manu \
    attivo_p

# In inserimento, devo esporre solo i generatori attivi.
# In modifica, sia quelli attivi che quelli disattivi con coimdope_gend
# In visualizzazione e cancellazione, solo quelli con coimdope_gend
if {$funzione eq "I"} {
    set and_condizioni "and     g.flag_attivo = 'S'"
} elseif {$funzione eq "M"} {
    set and_condizioni "and (   g.flag_attivo = 'S'
                             or exists (select 1
                                          from coimdimp_gend
                                         where cod_dimp = :cod_dimp
                                           and gen_prog      = g.gen_prog)
                            )"
} else {
    set and_condizioni "and (   exists (select 1
                                          from coimdimp_gend
                                         where cod_dimp = :cod_dimp
                                           and gen_prog      = g.gen_prog)
                            )"
}

db_1row query "
  select i.data_ultim_dich,
         trim(m.cognome || ' ' || m.nome) as installatore
    from coimaimp i
         left join coimmanu m on i.cod_installatore = m.cod_manutentore
where i.cod_impianto = :cod_impianto"

db_foreach query "
    select gen_prog, 
           iter_edit_data(data_installaz) as data_installaz, 
           flag_attivo,
           iter_edit_num(pot_utile_nom,2) as pot_utile_nom,
           modello,
           matricola,
           data_rottamaz_bruc,
          (select descr_cost 
             from coimcost 
            where cod_cost = g.cod_cost) as fabbricante
      from coimgend g
     where cod_impianto = :cod_impianto
      $and_condizioni
  order by gen_prog asc
" {
    set attivo_p [expr {$flag_attivo eq "S"}]
    
    if {$data_rottamaz_bruc ne ""} {
	set data_ult_man_o_disatt $data_rottamaz_bruc
    } else {
	set data_ult_man_o_disatt $data_ultim_dich
    }
    
    set data_ult_man_o_disatt [db_string query "select iter_edit_data(:data_ult_man_o_disatt)"]
    
    set campo_riguarda_p "riguarda_generatore_${gen_prog}_p"
    element create $form_name $campo_riguarda_p \
	-label   "Ha riguardato il generatore" \
	-widget   select \
	-datatype text \
	-html    "$disabled_fld {} class form_element" \
	-optional \
	-options {{"Si" "t"} {"No" "f"}}
	
    set campo_data_ult_manu "data_ult_man_o_disatt_${gen_prog}"
    element create $form_name $campo_data_ult_manu \
	-label   "Data ultima manutenzione/disattivazione" \
	-widget   text \
	-datatype text \
	-html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
	-optional
	
    template::multirow append campi_manutenzioni \
	$gen_prog \
	$data_installaz \
	$flag_attivo \
	$modello \
	$matricola \
	$fabbricante \
	$installatore \
	$campo_riguarda_p \
	$data_ult_man_o_disatt \
	$campo_data_ult_manu \
	$attivo_p
}

element create $form_name num_generatori \
    -label    "Num. generatori" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 12 $readonly_fld {} class form_element" \
    -optional
    
###


element create $form_name cod_impianto       -widget hidden -datatype text -optional
element create $form_name cod_opmanu_new     -widget hidden -datatype text -optional
element create $form_name cod_dimp           -widget hidden -datatype text -optional

element create $form_name last_cod_dimp      -widget hidden -datatype text -optional

element create $form_name funzione           -widget hidden -datatype text -optional
element create $form_name caller             -widget hidden -datatype text -optional
element create $form_name nome_funz          -widget hidden -datatype text -optional
element create $form_name nome_funz_caller   -widget hidden -datatype text -optional
element create $form_name extra_par          -widget hidden -datatype text -optional

element create $form_name url_aimp           -widget hidden -datatype text -optional
element create $form_name url_list_aimp      -widget hidden -datatype text -optional

element create $form_name cod_legale_rapp    -widget hidden -datatype text -optional
element create $form_name f_cod_via          -widget hidden -datatype text -optional

element create $form_name nome_funz_new      -widget hidden -datatype text -optional
element create $form_name flag_ins_prop      -widget hidden -datatype text -optional

element create $form_name submit_btn         -widget submit -datatype text -label "$button_label" -html "class form_submit"

set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new
set flag_ins_prop "S"

set link_ins_prop [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_resp nome nome_resp nome_funz nome_funz_new dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy dummy cod_responsabile dummy dummy flag_ins_prop dummy] "Inserisci Sogg."]

set current_date [iter_set_sysdate]

if {$funzione eq "I" || $funzione eq "M"} {
    set cerca_prop  [iter_search $form_name coimcitt-filter [list dummy cod_responsabile f_cognome cognome_resp f_nome nome_resp]]
} else {
    set cerca_prop ""
}

if {($funzione eq "I" || $funzione eq "M")
    && $cod_manutentore_da_id_utente eq ""
} {
    set cerca_manu [iter_search $form_name coimmanu-list [list dummy cod_manutentore dummy cognome_manu dummy nome_manu] [list f_ruolo "M"]]
} else {
    set cerca_manu ""
}

if {$funzione eq "I" || $funzione eq "M"} { 
    set cerca_opma [iter_search $form_name [ad_conn package_url]/src/coimopma-list [list cod_manutentore cod_manutentore cod_opmanu_new cod_opmanu_new f_cognome nome_opma f_nome cognome_opma]]
} else {
    set cerca_opma ""
}

if {$is_refresh_p || [form is_request $form_name]} {
    element set_properties $form_name cod_impianto -value $cod_impianto
    element set_properties $form_name cod_dimp     -value $cod_dimp

    element set_properties $form_name last_cod_dimp    -value $last_cod_dimp

    element set_properties $form_name funzione         -value $funzione
    element set_properties $form_name caller           -value $caller
    element set_properties $form_name nome_funz        -value $nome_funz
    element set_properties $form_name nome_funz_caller -value $nome_funz_caller
    element set_properties $form_name extra_par        -value $extra_par
    element set_properties $form_name url_aimp         -value $url_aimp    
    element set_properties $form_name url_list_aimp    -value $url_list_aimp
    element set_properties $form_name flag_ins_prop    -value $flag_ins_prop

    # Preparo questi default per l'inserimento:
    set dam_flag_osservazioni    "f"
    set dam_flag_raccomandazioni "f"
    set dam_flag_prescrizioni    "f"
    set data_dich_st "";#ric01

    
    # Non rileggo la riga se siamo in un refresh,
    # altrimenti tutte le modifiche fatte al record
    # verrebbero eliminate
    if {!$is_refresh_p && $funzione ne "I"} {
        # leggo riga
        if {![db_0or1row query "
            select 
              cod_impianto,
              flag_tracciato,
              dam_cognome_dichiarante,
              dam_nome_dichiarante,
              cod_manutentore,
              dam_tipo_tecnico,
              cod_opmanu_new,
              data_controllo as data_dich_st,   --ric01
              data_controllo as data_dich,
              cod_responsabile,
              dam_tipo_manutenzione,
              dam_flag_osservazioni,
              dam_flag_raccomandazioni,
              dam_flag_prescrizioni,
              iter_edit_num(consumo_annuo, 2) as consumo_annuo,            --gac01 
              iter_edit_num(consumo_annuo2, 2) as consumo_annuo2,          --gac01
              stagione_risc,                                               --gac01
              stagione_risc2,                                              --gac01
              iter_edit_num(acquisti, 2) as acquisti,                      --gac01
              iter_edit_num(acquisti2, 2) as acquisti2,                    --gac01
              iter_edit_num(scorta_o_lett_iniz, 2) as scorta_o_lett_iniz,  --gac01
              iter_edit_num(scorta_o_lett_iniz2, 2) as scorta_o_lett_iniz2,--gac01
              iter_edit_num(scorta_o_lett_fin, 2) as scorta_o_lett_fin,    --gac01
              iter_edit_num(scorta_o_lett_fin2, 2) as scorta_o_lett_fin2   --gac01
         from coimdimp
        where cod_dimp = :cod_dimp
        "]} {
            iter_return_complaint "Dichiarazione di codice '$cod_dimp' non trovata"
        }
        
	set data_dich [db_string query "select iter_edit_data(:data_dich)"]
        set cod_manutentore_pre_refresh $cod_manutentore;#nic01
        
        foreach nome_campo {
            cod_impianto
	    dam_cognome_dichiarante
	    dam_nome_dichiarante
	    cod_manutentore
	    cod_manutentore_pre_refresh
	    dam_tipo_tecnico
	    cod_opmanu_new
	    data_dich
	    cod_responsabile
	    dam_tipo_manutenzione
	    dam_flag_osservazioni
	    dam_flag_raccomandazioni
	    dam_flag_prescrizioni
	    consumo_annuo 
	    consumo_annuo2 
	    stagione_risc 
	    stagione_risc2 
	    acquisti 
	    acquisti2
	    scorta_o_lett_iniz 
	    scorta_o_lett_iniz2 
	    scorta_o_lett_fin
	    scorta_o_lett_fin2
        } {
            element set_properties $form_name $nome_campo -value [set $nome_campo]
        }
                
    };#fine if {!$is_refresh_p && $funzione ne "I"}
    
    if {!$is_refresh_p} {
	template::multirow foreach campi_manutenzioni {
	    if {$funzione ne "I"} {
		set riguarda_p "f"
		db_0or1row query "
		select 't' as riguarda_p,
		        iter_edit_data(data_ult_man_o_disatt) as data_manu
		  from coimdimp_gend
		where cod_dimp = :cod_dimp
		  and gen_prog = :gen_prog"
		if {$riguarda_p} {
		    set data_ult_man_o_disatt $data_manu
		}
		element set_properties $form_name $campo_riguarda_p -value $riguarda_p
		element set_properties $form_name $campo_data_ult_manu -value $data_ult_man_o_disatt
	    } else {
		element set_properties $form_name $campo_riguarda_p -value "t"
	    }
	}
    }
    
    if {[exists_and_not_null cod_responsabile]} {
        db_1row query "
          select cognome as cognome_resp,
                 nome    as nome_resp
            from coimcitt
           where cod_cittadino = :cod_responsabile"
        element set_properties $form_name cod_responsabile -value $cod_responsabile
        element set_properties $form_name cognome_resp     -value $cognome_resp
        element set_properties $form_name nome_resp        -value $nome_resp
    }
    
    # valorizzo alcuni default
    if {[exists_and_not_null cod_manutentore]} {

        #testxx ns_return 200 text/html "cod_manutentore=$cod_manutentore;cod_manutentore_pre_refresh:$cod_manutentore_pre_refresh";#testxx
	#testxx ad_script_abort;#testxx

        if {[form is_request $form_name] || ($is_refresh_p && $cod_manutentore ne $cod_manutentore_pre_refresh)} {#nic01 (aggiunta questa if altrimenti c'erano problemi)
	    
		db_1row sel_man "
            select * 
              from (select cognome as cognome_manu,
                           nome as nome_manu,
                           reg_imprese,
                           localita_reg,
                           flag_a,
                           flag_b,
                           flag_c,
                           flag_d,
                           flag_e,
                           flag_f,
                           flag_g,
                           cod_legale_rapp,
                           current_date as data_validita --ric01
                      from coimmanu 
                     where cod_manutentore = :cod_manutentore
 
                  union --ric01 aggiunta union

                     select cognome as cognome_manu,
                           nome as nome_manu,
                           reg_imprese,
                           localita_reg,
                           flag_a,
                           flag_b,
                           flag_c,
                           flag_d,
                           flag_e,
                           flag_f,
                           flag_g,
                           cod_legale_rapp,
                           st_data_validita as data_validita 
                      from coimmanu_st 
                     where cod_manutentore = :cod_manutentore
                  ) as st
             where st.data_validita >= coalesce(:data_dich_st, current_date)
           order by st.data_validita
              limit 1"
            set cod_manutentore_pre_refresh $cod_manutentore;#nic01

	    foreach nome_campo {
		cod_manutentore
		cod_manutentore_pre_refresh
		cognome_manu
		nome_manu
		reg_imprese
		localita_reg
		flag_a
		flag_b
		flag_c
		flag_d
		flag_e
		flag_f
		flag_g
	    } {
		element set_properties $form_name $nome_campo -value [set $nome_campo]
	    }
	};#nic01
    }
    
    if {[exists_and_not_null cod_legale_rapp] && [db_0or1row sel_legale "
      select cognome as cognome_legale,
	     nome as nome_legale
	from coimcitt
      where cod_cittadino = :cod_legale_rapp"]} {
	set dam_nome_dichiarante    [string trim [element::get_value $form_name dam_nome_dichiarante]]
	if {$dam_nome_dichiarante eq ""} {
	    element set_properties $form_name dam_nome_dichiarante -value $nome_legale
	}
	set dam_cognome_dichiarante [string trim [element::get_value $form_name dam_cognome_dichiarante]]
	if {$dam_cognome_dichiarante eq ""} {
	    element set_properties $form_name dam_cognome_dichiarante -value $cognome_legale
	}
	element set_properties $form_name cod_legale_rapp -value $cod_legale_rapp
    }

    if {$flag_viario eq "F"} {
	db_1row sel_aimp_ins_no_vie "
               select b.cod_impianto_est,
                      b.indirizzo,
                      b.toponimo,
                      b.cod_comune,
                      b.numero,
                      b.esponente,
                      b.piano,
                      b.scala,
                      b.localita,
                      b.interno,
                      iter_edit_num(b.potenza, 2) as potenza_old,
                      b.cod_combustibile          as cod_combustibile_old,
                      b.cod_responsabile          as cod_responsabile_old,
                      b.flag_resp                 as flag_resp_old,
                      d.nome                      as nome_resp_old,
                      d.cognome                   as cognome_resp_old,
                      b.cod_distributore          as forn_energia,
                      b.flag_tipo_impianto as flag_impianto
                  from coimgend a
                     , coimaimp b
       left outer join coimcitt d on d.cod_cittadino = b.cod_responsabile
                 where a.cod_impianto = :cod_impianto
                   and b.cod_impianto = a.cod_impianto
              order by a.flag_attivo desc
                     , a.gen_prog    desc
                 limit 1"
    } else {
	db_1row sel_aimp_ins_vie "
               select b.cod_impianto_est,
                      c.descrizione as indirizzo,
                      c.descr_topo as toponimo,
                      b.cod_comune,
                      b.numero,
                      b.esponente,
                      b.piano,
                      b.scala,
                      b.localita,
                      b.interno,
                      iter_edit_num(b.potenza, 2) as potenza_old,
                      b.cod_combustibile          as cod_combustibile_old,
                      b.cod_responsabile          as cod_responsabile_old,
                      b.flag_resp                 as flag_resp_old,
                      d.nome                      as nome_resp_old,
                      d.cognome                   as cognome_resp_old,
                      b.cod_distributore as forn_energia,
                      b.flag_tipo_impianto as flag_impianto
                 from coimgend a
                    , coimaimp b
      left outer join coimcitt d on d.cod_cittadino = b.cod_responsabile
      left outer join coimviae c on c.cod_via       = b.cod_via
                                and c.cod_comune    = b.cod_comune
                where a.cod_impianto = :cod_impianto
                  and b.cod_impianto = a.cod_impianto
             order by a.flag_attivo desc
                    , a.gen_prog    desc
                limit 1"
    }
    
    
    if {[exists_and_not_null cod_opmanu_new]} {
	ns_log notice "simone cod_opmanu_new = $cod_opmanu_new"
	set nome_opma ""
	set cognome_opma ""
	db_0or1row query "
	select nome as nome_opma,
	       cognome as cognome_opma
	from coimopma
	where cod_opma = :cod_opmanu_new"
	
	element set_properties $form_name nome_opma    -value $nome_opma
	element set_properties $form_name cognome_opma -value $cognome_opma
    }
        
    if {$funzione eq "I"} {
	if {$is_refresh_p} {
	    if {[exists_and_not_null dam_tipo_tecnico]
	     && $flag_resp_old    eq "T" 
	     && [info exists cod_legale_rapp]
	     && $cod_legale_rapp  eq $cod_responsabile_old} {
		element set_properties $form_name dam_tipo_tecnico -value "T"
	    }
	} else {
	    element set_properties $form_name cod_responsabile -value $cod_responsabile_old
	    element set_properties $form_name cognome_resp     -value $cognome_resp_old
	    element set_properties $form_name nome_resp        -value $nome_resp_old

	    db_1row query "
	    select count(*) as num_generatori_attivi
	      from coimgend
	    where cod_impianto = :cod_impianto
	      and flag_attivo  = 'S'"

	    element set_properties $form_name num_generatori   -value $num_generatori_attivi
	} 
    }

    element set_properties $form_name descr_comu -value [db_string query "
      select denominazione from coimcomu where cod_comune = :cod_comune"]
    
    element set_properties $form_name flag_impianto     -value $flag_impianto
    element set_properties $form_name cod_impianto_est  -value $cod_impianto_est
    element set_properties $form_name indirizzo         -value $indirizzo
    element set_properties $form_name toponimo          -value $toponimo
    element set_properties $form_name localita          -value $localita
    element set_properties $form_name numero            -value $numero
    element set_properties $form_name esponente         -value $esponente
    element set_properties $form_name scala             -value $scala
    element set_properties $form_name piano             -value $piano
    element set_properties $form_name interno           -value $interno
    element set_properties $form_name cod_comune        -value $cod_comune
    
    element set_properties $form_name cod_impianto      -value $cod_impianto
        
    # Se eventualmente eravamo in un refresh, la prossima richiesta non lo sara'
    element set_properties $form_name __refreshing_p -value 0
}

#gac01 aggiunta variabile unità di misura che viene valorrazza a seconda del tipo di combustibile
set cod_combustibile ""
set cod_combustibile [db_string q "select cod_combustibile from coimaimp where cod_impianto = :cod_impianto" -default ""]
set um ""
set um [db_string q "select um from coimcomb where cod_combustibile = :cod_combustibile" -default ""]

set errori ""

# "test [form is_valid $form_name]"
# "test [template::form::get_errors $form_name]"

if {!$is_refresh_p && [form is_valid $form_name]} {
    # form valido dal punto di vista del templating system

    # Per ogni campo form qua sotto, la variabile
    # sara' popolata con il valore corrispondente
    foreach nome_campo {
        cod_dimp
        cod_impianto
        cod_opmanu_new
        data_dich
        flag_impianto
        dam_nome_dichiarante
	dam_cognome_dichiarante
	dam_tipo_manutenzione
	dam_flag_osservazioni
	dam_flag_raccomandazioni
	dam_flag_prescrizioni
	consumo_annuo  
	consumo_annuo2  
	stagione_risc  
	stagione_risc2  
	acquisti  
	acquisti2  
	scorta_o_lett_iniz  
	scorta_o_lett_iniz2  
	scorta_o_lett_fin
	scorta_o_lett_fin2
        nome_opma
        cognome_opma
        num_generatori
        cod_manutentore
        cognome_manu
        nome_manu
        cod_legale_rapp
        toponimo
        indirizzo
        f_cod_via
        localita
        numero
        esponente
        scala
        piano
        interno
        cod_comune
        cod_responsabile
        cognome_resp
        nome_resp
        reg_imprese
        localita_reg
        flag_a
        flag_b
        flag_c
        flag_d
        flag_e
        flag_f
        flag_g
        dam_tipo_tecnico
    } {
        set $nome_campo [element::get_value $form_name $nome_campo]
    }
    
    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    
    set check_cod_opma {
	set chk_out_rc       0
	set chk_out_msg      ""
	set chk_out_cod_opma ""
	set ctr_opma         0
	if {$chk_inp_cognome eq ""} {
	    set eq_cognome "is null"
	} else {
	    set eq_cognome "= upper(:chk_inp_cognome)"
	}
	if {$chk_inp_nome eq ""} {
	    set eq_nome    "is null"
	} else {
	    set eq_nome    "= upper(:chk_inp_nome)"
	}
	db_foreach sel_opma "
	  select cod_opma
               from coimopma
              where upper(cognome)   $eq_cognome
                and upper(nome)      $eq_nome
                and cod_manutentore = :cod_manutentore" {
	    incr ctr_opma
	    if {$cod_opma eq $chk_inp_cod_opma} {
		set chk_out_cod_opma $cod_opma
		set chk_out_rc       1
	    }
	}
	switch $ctr_opma {
	    0 { set chk_out_msg "Soggetto non trovato"}
	    1 { set chk_out_cod_opma $cod_opma
		set chk_out_rc       1 }
	    default {
		if {$chk_out_rc == 0} {
		    set chk_out_msg "Trovati pi&ugrave; soggetti: usa il link cerca"
		}
	    }
	}
    }
    
    #cod_opma obbligatorio
    if {$cod_opmanu_new eq ""} {
	# La provincia di Livorno ha chiesto il 23/07/2014 che l'operatore non sia obblig.
	# La provincia di Venezia l'ha chiesto il 04/08/2014
	# La provincia di Caserta l'ha chiesto il 04/08/2014
	# Publies (PPO e iterprfi_pu) l'ha chiesto il 01/09/2014
	if {$coimtgen(ente) ne "PLI"
	&&  $coimtgen(ente) ne "PVE"
	&&  $coimtgen(ente) ne "PCE"
	&&  $coimtgen(ente) ne "PPO"
	&&  ![string match "*iterprfi_pu*" [db_get_database]]
	&&  $coimtgen(ente) ne "PPD"
	} {
	    element::set_error $form_name cognome_opma "Devi utilizzare il Cerca"
	    incr error_num
	}
	#![string equal $cognome_opma ""] && ![string equal $nome_opma ""]
	# set cod_opma ""
    } else {
	set chk_inp_cod_opma $cod_opmanu_new
	set chk_inp_cognome  $cognome_opma
	set chk_inp_nome     $nome_opma
	eval $check_cod_opma
	set cod_opma  $chk_out_cod_opma
	if {$chk_out_rc == 0} {
	    element::set_error $form_name cognome_opma $chk_out_msg
	    incr error_num
	}
    }

    if {$funzione eq "I" || $funzione eq "M"} {
        #routine generica per controllo codice manutentore
        set check_cod_manu {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_manu ""
            set ctr_manu         0
            if {$chk_inp_cognome eq ""} {
                set eq_cognome "is null"
	    } else {
                set eq_cognome "= upper(:chk_inp_cognome)"
	    }
            if {$chk_inp_nome eq ""} {
                set eq_nome "is null"
	    } else {
                set eq_nome "= upper(:chk_inp_nome)"
	    }
            db_foreach sel_manu "
            select cod_manutentore
              from coimmanu
             where upper(cognome) $eq_cognome
               and upper(nome)    $eq_nome
            " {
                incr ctr_manu
                if {$cod_manutentore eq $chk_inp_cod_manu} {
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
	
	if {$cognome_manu eq "" && $nome_manu eq ""} {
	    element::set_error $form_name cognome_manu "Inserire il manutentore"
	    incr error_num
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
	
        set check_cod_citt {
            set chk_out_rc       0
            set chk_out_msg      ""
            set chk_out_cod_citt ""
            set ctr_citt         0
            if {$chk_inp_cognome eq ""} {
                set eq_cognome "is null"
	    } else {
                set eq_cognome "= upper(:chk_inp_cognome)"
	    }
            if {$chk_inp_nome eq ""} {
                set eq_nome "is null"
	    } else {
                set eq_nome "= upper(:chk_inp_nome)"
	    }
            db_foreach sel_citt "
              select cod_cittadino
                from coimcitt
               where upper(cognome) $eq_cognome
                 and upper(nome)    $eq_nome" {
                incr ctr_citt
                if {$cod_cittadino eq $chk_inp_cod_citt} {
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
	
        if {$cognome_resp eq "" && $nome_resp eq ""} {
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
	
        if {$indirizzo ne "" || $toponimo ne ""} {
	    if {$cod_comune eq ""} {
		if {$coimtgen(flag_ente) eq "P"} {
		    element::set_error $form_name cod_comune "valorizzare il Comune" 
		} else {
		    element::set_error $form_name descr_comu "valorizzare il Comune"
		} 
		incr error_num
	    } 
	}
	
	# si controlla la via solo se il primo test e' andato bene.
	# in questo modo si e' sicuri che f_comune e' stato valorizzato.
	if {$flag_viario eq "T"} {
	    if {$indirizzo eq "" && $toponimo eq ""} {
		if {$localita ne ""} {
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
		if {$toponimo eq ""} {
		    set eq_toponimo  "is null"
		} else {
		    set eq_toponimo  "= upper(:toponimo)"
		}
		if {$indirizzo eq ""} {
		    set eq_descrizione "is null"
		} else {
		    set eq_descrizione "= upper(:indirizzo)"
		}
		db_foreach sel_viae "
                select cod_via
                  from coimviae
                 where cod_comune  = :cod_comune
                   and descrizione = upper(:indirizzo)
                   and descr_topo  = upper(:toponimo)
                   and cod_via_new is null
                " {
	 	    incr ctr_viae
		    if {$cod_via eq $f_cod_via} {
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
	
    }
    
    if {![string is integer $num_generatori]} {
        element::set_error $form_name num_generatori "Numero errato"
        incr error_num
    }
    
    # Scorro i campi creati dinamicamente ed eseguo i controlli.
    # I record controllati li travaso in un'altra multirow.
    if {$funzione ne "D"} {
      template::multirow create manutenzioni gen_prog riguarda_p data_ult_man_o_disatt
      template::multirow foreach campi_manutenzioni {
	  set riguarda_p    [string trim [element::get_value $form_name $campo_riguarda_p]]
	  set data_ult_manu [string trim [element::get_value $form_name $campo_data_ult_manu]]
# 	  if {$gen_prog == 3} {"test $campo_data_ult_manu $data_ult_manu [element::get_value $form_name data_ult_man_o_disatt_3]"}
	  
	  # Salto i generatori ignorati dalla dichiarazione
	  if {!$riguarda_p} continue
	  
	  if {$data_ult_manu eq ""} {
	      element::set_error $form_name $campo_data_ult_manu "Inserire data"
	      incr error_num
	  } else {
	      set data_ult_manu [iter_check_date $data_ult_manu]
	      if {$data_ult_manu == 0} {
		  element::set_error $form_name $campo_data_ult_manu "Data errata"
		  incr error_num
	      }
	  }
	  
	  template::multirow append manutenzioni $gen_prog $riguarda_p $data_ult_manu
      }
    }
            
    if {$data_dich eq ""} {
        element::set_error $form_name data_dich "Inserire data"
        incr error_num
    } else {
        set data_dich [iter_check_date $data_dich]
        if {$data_dich == 0} {
            element::set_error $form_name data_dich "Data non corretta"
            incr error_num
        } else {#sim01 aggiunto else e suo contenuto
	    set oggi         [iter_set_sysdate]
	    if {$data_dich > $oggi} {
		element::set_error $form_name data_dich "Non è possibile inserire una data successiva ad oggi"
		incr error_num
	    }
	}
    }
    
    if {![string equal $consumo_annuo ""]} {
	set consumo_annuo [iter_check_num $consumo_annuo 2]
	if {$consumo_annuo == "Error"} {
	    element::set_error $form_name consumo_annuo "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num	    
	}
    }
    
    if {![string equal $consumo_annuo2 ""]} {
	set consumo_annuo2 [iter_check_num $consumo_annuo2 2]
	if {$consumo_annuo2 == "Error"} {
	    element::set_error $form_name consumo_annuo2 "Consumo annuo deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num	    
	}
    }
    #gac01 aggiunti controlli su stagione_risc, stagione_risc2, consumo_annuo, consumo_annuo2
    #Sandro il 13/06/2018 ha detto di togliere i controlli
#    if {[string is space $stagione_risc]} {
#	element::set_error $form_name stagione_risc "Inserire Stagione di riscaldamento attuale"
#        incr error_num
#    }
#    if {[string is space $stagione_risc2]} {
#        element::set_error $form_name stagione_risc2 "Inserire Stagione di riscaldamento precedente"
#        incr error_num
#    }
    if {![string equal $acquisti ""]} {
	set acquisti [iter_check_num $acquisti 2]
	if {$acquisti == "Error"} {
	    element::set_error $form_name acquisti "Acquisti deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $acquisti2 ""]} {
	set acquisti2 [iter_check_num $acquisti2 2]
	if {$acquisti2 == "Error"} {
	    element::set_error $form_name acquisti2 "Acquisti deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_iniz ""]} {
	set scorta_o_lett_iniz [iter_check_num $scorta_o_lett_iniz 2]
	if {$scorta_o_lett_iniz == "Error"} {
	    element::set_error $form_name scorta_o_lett_iniz "Scorta o lettura iniziale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_iniz2 ""]} {
	set scorta_o_lett_iniz2 [iter_check_num $scorta_o_lett_iniz2 2]
	if {$scorta_o_lett_iniz2 == "Error"} {
	    element::set_error $form_name scorta_o_lett_iniz2 "Scorta o lettura iniziale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_fin ""]} {
	set scorta_o_lett_fin [iter_check_num $scorta_o_lett_fin 2]
	if {$scorta_o_lett_fin == "Error"} {
	    element::set_error $form_name scorta_o_lett_fin "Scorta o lettura finale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    if {![string equal $scorta_o_lett_fin2 ""]} {
	set scorta_o_lett_fin2 [iter_check_num $scorta_o_lett_fin2 2]
	if {$scorta_o_lett_fin2 == "Error"} {
	    element::set_error $form_name scorta_o_lett_fin2 "Scorta o lettura finale deve essere numerico e pu&ograve; avere al massimo 2 decimali"
	    incr error_num
	}
    }
    
    #gac01 aggiunti controlli e calcolo consumo anno automatico nel caso in cui consumo_annuo o consumo_annuo2 siano vuoti
    if {[string is space $consumo_annuo] && [string is space $scorta_o_lett_iniz] &&  [string is space $scorta_o_lett_fin]} {
        #Sandro il 13/06/2018 ha detto di togliere i controlli
	#element::set_error $form_name consumo_annuo "Inserire Consumi stagione"
        #incr error_num
    } elseif {[string is space $consumo_annuo] && [string is space $scorta_o_lett_iniz]} {
	set scorta_o_lett_iniz "0.00"
	set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    } elseif {[string is space $consumo_annuo] && [string is space $scorta_o_lett_fin]} {
        set scorta_o_lett_fin "0.00"
        set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    } elseif {[string is space $consumo_annuo]} {
        set consumo_annuo [expr $scorta_o_lett_fin - $scorta_o_lett_iniz]
    }

    if {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_iniz2] &&  [string is space $scorta_o_lett_fin2]} { 
        #Sandro il 13/06/2018 ha detto di togliere i controlli
	#element::set_error $form_name consumo_annuo2 "Inserire Consumi stagione"
        #incr error_num
    } elseif {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_iniz2]} {
        set scorta_o_lett_iniz2 "0.00"
        set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    } elseif {[string is space $consumo_annuo2] && [string is space $scorta_o_lett_fin2]} {
        set scorta_o_lett_fin2 "0.00"
        set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    } elseif {[string is space $consumo_annuo2]} {
	set consumo_annuo2 [expr $scorta_o_lett_fin2 - $scorta_o_lett_iniz2]
    }

    if {$error_num > 0} {
        set errori "ATTENZIONE sono presenti degli errori nella pagina"
        ad_return_template
        return
    }
    

    with_catch error_msg {
	db_transaction {
	
	    if {$funzione eq "M" || $funzione eq "D"} {
		# Elimino tutte le operazioni precedenti
		db_dml query "
                delete
                  from coimdimp_gend 
                 where cod_dimp = :cod_dimp"
	    }
	    
	    switch $funzione {
		I {
		    set cod_dimp [db_nextval coimdimp_s]
		    
		    if {$cod_legale_rapp eq ""} {
			set cod_legale_rapp [db_string sel_leg "
                        select cod_legale_rapp
                          from coimmanu 
                         where cod_manutentore = :cod_manutentore"]
		    }
		    
		    db_dml query "
                    insert
                      into coimdimp (
                      cod_dimp,
                      cod_impianto,
                      flag_tracciato,
                      dam_cognome_dichiarante,
                      dam_nome_dichiarante,
                      cod_manutentore,
                      dam_tipo_tecnico,
                      cod_opmanu_new,
                      data_controllo,
                      cod_responsabile,
                      dam_tipo_manutenzione,
                      dam_flag_osservazioni,
                      dam_flag_prescrizioni,
                      dam_flag_raccomandazioni,
                      data_ins,
                      utente_ins,
                      consumo_annuo,          --gac01 
                      consumo_annuo2,         --gac01
                      stagione_risc,          --gac01
                      stagione_risc2,         --gac01
                      acquisti,               --gac01
                      acquisti2,              --gac01
                      scorta_o_lett_iniz,     --gac01
                      scorta_o_lett_iniz2,    --gac01 
                      scorta_o_lett_fin,      --gac01
                      scorta_o_lett_fin2      --gac01
                    ) values (
                      :cod_dimp,
                      :cod_impianto,
                      'DA',
                      :dam_cognome_dichiarante,
                      :dam_nome_dichiarante,
                      :cod_manutentore,
                      :dam_tipo_tecnico,
                      :cod_opmanu_new,
                      :data_dich,
                      :cod_responsabile,
                      :dam_tipo_manutenzione,
                      :dam_flag_osservazioni,
                      :dam_flag_prescrizioni,
                      :dam_flag_raccomandazioni,
                      current_date,
                      :id_utente,
                      :consumo_annuo,         --gac01  
                      :consumo_annuo2,        --gac01
                      :stagione_risc,         --gac01
                      :stagione_risc2,        --gac01
                      :acquisti,              --gac01
                      :acquisti2,             --gac01
                      :scorta_o_lett_iniz,    --gac01
                      :scorta_o_lett_iniz2,   --gac01
                      :scorta_o_lett_fin,     --gac01
                      :scorta_o_lett_fin2     --gac01

                    )"
		}
		M {
		    db_dml query "
                     update coimdimp set 
                      cod_impianto             = :cod_impianto,
                      dam_cognome_dichiarante  = :dam_cognome_dichiarante,
                      dam_nome_dichiarante     = :dam_nome_dichiarante,
                      cod_manutentore          = :cod_manutentore,
                      dam_tipo_tecnico         = :dam_tipo_tecnico,
                      cod_opmanu_new           = :cod_opmanu_new,
                      data_controllo           = :data_dich,
                      cod_responsabile         = :cod_responsabile,
                      dam_tipo_manutenzione    = :dam_tipo_manutenzione,
                      dam_flag_osservazioni    = :dam_flag_osservazioni,
                      dam_flag_prescrizioni    = :dam_flag_prescrizioni,
                      dam_flag_raccomandazioni = :dam_flag_raccomandazioni,
                      data_mod                 = current_date,
                      utente                   = :id_utente
                    , consumo_annuo            = :consumo_annuo        --gac01 
                    , consumo_annuo2           = :consumo_annuo2       --gac01
                    , stagione_risc            = :stagione_risc        --gac01
                    , stagione_risc2           = :stagione_risc2       --gac01
                    , acquisti                 = :acquisti             --gac01
                    , acquisti2                = :acquisti2            --gac01
                    , scorta_o_lett_iniz       = :scorta_o_lett_iniz   --gac01
                    , scorta_o_lett_iniz2      = :scorta_o_lett_iniz2  --gac01
                    , scorta_o_lett_fin        = :scorta_o_lett_fin    --gac01
                    , scorta_o_lett_fin2       = :scorta_o_lett_fin2   --gac01
                      where cod_dimp = :cod_dimp"
		}
		D {
		    db_dml query "
                    delete
                      from coimdimp
                     where cod_dimp = :cod_dimp"
		}
	    }
	    
	    # Siamo in inserimento o modifica. Salvo le operazioni inserite
	    if {$funzione eq "M" || $funzione eq "I"} {
		# Scorro le operazioni gia' controllate
		# e per ciascuna inserisco un record
		template::multirow foreach manutenzioni {
		    if {$riguarda_p} {
			db_dml query "
                        insert into coimdimp_gend (
                        cod_dimp,
                        gen_prog,
                        data_ult_man_o_disatt,
                        data_ins,
                        utente_ins,
                        data_mod,
                        utente_mod
                      ) values (
                        :cod_dimp,
                        :gen_prog,
                        :data_ult_man_o_disatt,
                        current_date,
                        :id_utente,
                        current_date,
                        :id_utente
                      )"
		    }
		}
	    }
	    # gac03 su richiesta di regione marche i flag non devono essere modificati per che devono essere tenuti
	    # gac03 quelli inseriti in fase di reistrazione
	    # Siamo in inserimento o modifica. Aggiorno i dati del manutentore
	    if {$funzione eq "M" || $funzione eq "I"} {#nic01
		db_dml query "
                update coimmanu
                   set localita_reg = upper(:localita_reg)
                     , reg_imprese  = upper(:reg_imprese)
--gac03                     , flag_a       = :flag_a
--gac03                     , flag_b       = :flag_b
--gac03                     , flag_c       = :flag_c
--gac03                     , flag_d       = :flag_d
--gac03                     , flag_e       = :flag_e
--gac03                     , flag_f       = :flag_f
--gac03                     , flag_g       = :flag_g
                 where cod_manutentore = :cod_manutentore"
	    }
	}
    } {
        iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

    set link_list [subst $link_list_script]
    set link_gest [export_url_vars cod_impianto cod_dimp last_cod_dimp caller nome_funz nome_funz_caller extra_par url_aimp url_list_aimp]
    
    switch $funzione {
        I {set return_url "$questa_pagina?funzione=V&$link_gest"}
        M {set return_url "$questa_pagina?funzione=V&$link_gest"}
        V {set return_url "coimdimp-list?$link_list"}
        D {set return_url "coimdimp-list?$link_list"}
    }
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template
