ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimaimp"
    @author          Gacalin Lufi
    @creation-date   13/04/2018
    
    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
    @                serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    @                serve se lista e' uno zoom che permetti aggiungi.
    @param extra_par Variabili extra da restituire alla lista
    
    @cvs-id          coimaimp-bis-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    mat02 23/09/2025 Impostato readonly il campo stato per i manutentori

    mat01 08/04/2025 Corretto problema sul refresh della pagina riscontrato dopo aggiornamento a
    mat01            OpenACS 5.10.1

    rom19 07/06/2023 MEV "Impianti condominiali con pompa di calore": Resi visibili i campi Unita'
    rom19            immobiliari servite e Tipologia impianto.

    rom18 19/05/2023 Gestito con if il mittente della mail per la Provincia di Fermo.

    rom17 25/05/2022 Modificato messaggio per i terzi responsabili per problemi con il patentino.

    rom16 31/03/2022 Su richiesta di Giuliodori con mail "MEV rilasciata in produzione." del 28/03/2022
    rom16            vado a modificare/implementare l'intervento di rom15 per la MEV Stato impianto "Rottamato".
    rom16            Se sto riattvando l'impianto il campo data_rottamaz va lasciato vuoto anche se non
    rom16            sono un manutentore.
    
    rom15 18/03/2022 Manutenzione evolutiva richiesta da regione Marche.
    rom15            25.  Stato impianto "Rottamato" in scheda 1.bis:
    rom15            Se l'impianto Attivo viene messo in uno stato diverso tutti i generatori attivi
    rom15            vanno disattivati (Non sono compresi i stati Da Validare e Da Accatastare).
    rom15            Se l'impianto Non Attivo viene riattivato anche i generatori disattivi vanno
    rom15            riattivati (vanno esclusi quelli sostituiti).

    rom14 10/03/2022 Manutenzione evolutiva richiesta da regione Marche.
    rom14            Punto 4. Allineamento responsabile su impianti con la stessa targa.
    rom14            4.1 - la modifica di un responsabile dell'impianto sara' effettuata anche su
    rom14            tutti gli impianti collegati.
    rom14            4.2 - Contestualmente sarà inviata un’email all’ente e ai manutentori interessati.

    rom13 13/01/2021 Su segnalazione di Sandro e Regione Marche il pod e' sempre obbligatorio
    rom13            se il combustibile e' GPL o GNL.

    rom12 21/06/2021 Corretto errore nella query che tira su i campi per l'invio mail in caso di
    rom12            modifiche al responsabile per Regione Marche: se sull'impianto c'era solo
    rom12            un installatore andava in errore.

    rom11 26/02/2021 Fatto in modi che in caso di cambio stato da non attivo ad attivo da parte
    rom11            dell'ente, non vengano richiesti i campi obbligatori.

    rom10 04/12/2020 Aggiunti controlli su pod e pdr che vengono fatti in fase di inserimento ma
    rom10            non erano stati portati qua

    rom09 04/06/2020 Gestito invio delle mail per la Provincia di Fermo: siccome hanno dei problemi
    rom09            con la ricezione delle mail ho messo come mittente impiantitermici@regione.marche.it

    rom08 03/06/2020 Corretto errore sull'invio mail per modifica dei soggetti: la query andava
    rom08            in errore perche' non prevedeva che un installatore modificasse i soggetti.

    sim05 26/03/2020 Aggiunto nota sulla modifica dl terzo responsabile

    sim04 30/01/2020 Permesso di sbiancare l'intestatario. Prima si poteva solo modificare.

    sim03 26/11/2019 Corretto controlli sul soggetto responsabile.

    sim02 18/11/2019 Fatto in modo che in caso di cambio stato non attivo da parte dell'ente, non vengano
    sim02            richiesti i campi obbligatori.
    
    sim01 11/11/2019 In data 06/11/2019 attraverso una email, la Regione ha richiesto di togliere
    sim01            il controllo relativo al conduttore sugli impianti di potenza maggiore a 232 KW

    rom07 25/02/2019 Corretto errore sul controllo del POD. Messi i campi data_variaz e data_ini_valid
    rom07            in grigio. In caso di un impianto con potenza maggiore di 282kw il terzo 
    rom07            responsabile puo' essere inserito solo se ha il patentino.
    rom07            Le richieste sono state fatte durante la call del 25/02.
    
    rom06 20/02/2019 La regione Marche con la call del 18/02/2019 ha richiesto che il proprietario
    rom06            sia sempre obbligatorio.

    rom05 11/01/2019 Messi i stessi controlli su POD e PDR che si fanno all'inserimento dell'impianto
    rom05            Tolta obbligatorietà sul campo Tipologia impianto per il freddo.
    
    gac02 18/12/2018 Aggiunto campi data_installaz e anno_costruzione

    rom04 17/12/2018 Aggiunti in sola visualizzazione i campi cognome_inst e nome_inst 
    rom04            dell'installatore.
    rom04            Aggiunti i campi data_rottamaz, data_attivaz e stato su richiesta della Regione
    
    rom03 01/12/2018 Aggiunti i campi pres_certificazione e certificazione.

    rom02 07/08/2018 Modificato link_generatori su richiesta della Regione marche.

    gac01 29/06/2018 Modificata label

    rom01 28/05/2018 Nella combo 'Tipologia impianto' su richiesta di Sandro do la possibilità di 
    rom01            scegliere solo 'autonomo' e 'centralizzato'

} {
    {cod_impianto      ""}
    {last_cod_impianto ""}
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {extra_par         ""}
    {url_list_aimp2    ""}
    {url_list_aimp     ""}
    {url_aimp          ""}
    {flag_assegnazione ""}
    {conferma_inco     ""}
    {cod_cittadino     ""}
    {is_warning_p      "f"}
    {is_resp_da_agg    "f"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# funzione = C --> copy
# funzione = A --> Assegnazione
switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
    "C" {set lvl 2}
    "M" {set lvl 3}
    "D" {set lvl 4}
}\

# B80: RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

set my_url "coimaimp-bis-gest"


# Controlla lo user
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

# controllo se l'utente e' un manutentore
set cod_manutentore [iter_check_uten_manu $id_utente]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

if {[string equal $url_aimp ""]} {
    set url_aimp [list [ad_conn url]?[export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2"]]
}

if {![string equal $url_list_aimp2 ""]} {
    set url_list_aimp $url_list_aimp2
}

if {$nome_funz_caller == [iter_get_nomefunz coimmai2-filter] && $url_list_aimp == ""} {
    set url_list_aimp  [list coimmai2-filter?[export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2 nome_funz"]&nome_funz=[iter_get_nomefunz coimmai2-filter]]
}


db_1row sel_cod_comb "select cod_combustibile as cod_tele from coimcomb where descr_comb = 'TELERISCALDAMENTO'"
db_1row sel_cod_comb "select cod_combustibile as cod_pomp from coimcomb where descr_comb = 'POMPA DI CALORE'"
set cod_combustibile [db_string q "select cod_combustibile from coimaimp where cod_impianto = :cod_impianto"];#rom07 

set link_gest [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp caller]

set link_mai2 [export_ns_set_vars url "url_list_aimp url_aimp url_list_aimp2 nome_funz"]&nome_funz=mai2

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp $extra_par]
set dett_tab [iter_tab_form $cod_impianto]

set current_date      [iter_set_sysdate]

# imposta le class css della barra delle funzioni
iter_set_func_class $funzione

# Personalizzo la pagina
set link_dimp ""
set link_cimp ""
set link_resp ""
set link_ubic ""
set link_resp ""
set link_util ""
set link_ricodifica ""

set coimgend "coimgend-1bis-list?"
set link_gend [export_url_vars cod_impianto url_list_aimp last_cod_impianto nome_funz_caller url_aimp]&nome_funz=[iter_get_nomefunz coimgend-1bis-list]

#rom02set link_generatori "<a href=\"$coimgend$link_gend\">Visualizza Generatori</a>"
set link_generatori "<a href=\"$coimgend$link_gend\">Visualizza periodicit&agrave; per l'invio del RCEE</a>";#rom02

if {[db_0or1row q "select 1 
                     from coimgend g
                        , coimcomb c  
                    where c.cod_combustibile = g.cod_combustibile 
                      and g.cod_impianto     = :cod_impianto
                      and c.tipo = 'G'
                    limit 1
"]} {
    set label_intestatario "Intestatario del contratto fornitura del gas"
} else {
    set label_intestatario "Intestatario del contratto fornitura energia eletterica"
}


set classe           "func-menu"
set titolo           "dati generali"
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
			  [list $url_list_aimp               "Lista Impianti"] \
			  "$page_title"]
}

iter_get_coimtgen
set flag_cod_aimp_auto  $coimtgen(flag_cod_aimp_auto)
set max_gg_modimp       $coimtgen(max_gg_modimp)
set cod_imst_annu_manu  $coimtgen(cod_imst_annu_manu)
set ast_pdr "";#rom05
set flag_tipo_impianto [db_string q "select flag_tipo_impianto from coimaimp
                                     where cod_impianto = :cod_impianto"];#rom05
if {$flag_tipo_impianto ne "F"} {#rom05 aggiunta if e contenuto
    set ast_pdr "<font color=red>*</font>"
}

# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimaimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set readonly_cod "readonly"
set disabled_fld "disabled"
set disabled_imp "disabled";#rom04
set onsubmit_cmd ""
switch $funzione {
    "I" {
	set readonly_key "readonly"
        set readonly_fld \{\}
        set disabled_fld \{\}
	set disabled_imp \{\}
        if {$flag_cod_aimp_auto == "F"
	    ||  $coimtgen(ente) eq "PLI"
	} {
	    set readonly_cod \{\}
        }
    }
    "M" {
	set disabled_key "disabled"
	set readonly_fld \{\}
        set disabled_fld \{\}
	set disabled_imp \{\}
        if {$coimtgen(ente) eq "PLI"} {
	    set readonly_cod \{\}
        }
    }
    "C" {
	set readonly_fld \{\}
	set disabled_fld \{\}
	if {$flag_cod_aimp_auto == "F"} {
	    set readonly_cod \{\}
	}
    }
}
if {![string equal $cod_impianto ""]} {#rom04 if e contenuto
    set disabled_imp "disabled"
}

if {$coimtgen(regione) eq "CALABRIA" && $coimtgen(ente) ne "PRC" && ![string equal $cod_manutentore ""]} {
    set readonly_dt_instal "readonly"
} else {
    set readonly_dt_instal $readonly_fld
}

form create $form_name \
    -html    $onsubmit_cmd


######inizio element 1.6 ####
set dittamanut ""
set id_ruolo  [db_string query "select id_ruolo from coimuten where id_utente = :id_utente"];#Nicola 20/08/2014
set link_rife  [export_url_vars cod_impianto nome_funz_caller url_list_aimp url_aimp]&nome_funz=[iter_get_nomefunz coimrifs-list]
set link_scheda3 [export_url_vars cod_impianto last_cod_impianto];#rom01

#gac01 {Intestatario I}
element create $form_name flag_responsabile \
    -label   "responsabile" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Proprietario P} {Occupante O} {Amministratore A} {"Terzo responsabile" T}}

#intestatario
set readonly_inte $readonly_fld
if {$id_ruolo ne "admin"
&& ($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
} {#Nicola 20/08/2014
    set readonly_inte_1_6 "readonly";#Nicola 20/08/2014
};#Nicola 20/08/2014

#proprietario
element create $form_name cognome_prop \
    -label   "Cognome proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_prop \
    -label   "Nome proprietario" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_prop \
        -label   "Cod.Fiscale proprietario" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#occupante
element create $form_name cognome_occ \
    -label   "Cognome occupante" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_occ \
    -label   "Nome occupante" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_occ \
        -label   "Cod.Fiscale occupante" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#amministratore
element create $form_name cognome_amm \
    -label   "Cognome amministratore" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_amm \
    -label   "Nome amministratore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_amm \
        -label   "Cod.Fiscale amministratore" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}

#terzi
element create $form_name cognome_terzi \
    -label   "Cognome terzi" \
    -widget   text \
    -datatype text \
    -html    "size 35 maxlength 100 $readonly_fld {} class form_element" \
    -optional

element create $form_name nome_terzi \
    -label   "Nome terzi" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $readonly_fld {} class form_element" \
    -optional

if {$funzione == "V"} {
    element create $form_name cod_fiscale_terzi \
        -label   "Cod.Fiscale terzi" \
        -widget   text \
        -datatype text \
        -html    "size 16 maxlength 16 $readonly_key {} class form_element" \
        -optional
}
#rom07 cambiato html da $readonly_key a disabled
element create $form_name data_variaz \
    -label   "data_variaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 disabled {} class form_element" \
    -optional

if {$funzione == "M" || $funzione == "D"} {
    #rom07 cambiato html da $readonly_fld a disabled
    element create $form_name data_ini_valid \
        -label   "data_ini_valid" \
        -widget   text \
        -datatype text \
        -html    "size 10 maxlength 10 disabled {} class form_element" \
        -optional
}

if {$funzione == "I" || $funzione == "M"} {
    set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
    set flag_ins_prop "S"

    set cerca_inte  [iter_search $form_name coimcitt-filter [list dummy cod_intestatario f_cognome cognome_inte f_nome nome_inte]]
    set ins_inte    [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_inte nome nome_inte nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_prop  [iter_search $form_name coimcitt-filter [list dummy cod_proprietario f_cognome cognome_prop f_nome nome_prop]]
    set ins_prop    [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_prop nome nome_prop nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_occ   [iter_search $form_name coimcitt-filter [list dummy cod_occupante f_cognome cognome_occ  f_nome nome_occ ]]
    set ins_occ     [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_occ nome nome_occ nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_amm   [iter_search $form_name coimcitt-filter [list dummy cod_amministratore f_cognome cognome_amm  f_nome nome_amm ]]
    set ins_amm     [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_amm nome nome_amm nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "Inserisci Soggetto"]

    set cerca_terzi [iter_search $form_name coimmanu-list   [list dummy cod_terzi dummy cognome_terzi dummy nome_terzi] [list f_ruolo "M"]]
    set ins_terzi   ""


    set mod_terzi [iter_link_ins $form_name coimcitt-gest [list cod_cittadino cod_terzi] "Modifica soggetto"]

    if {$coimtgen(regione) eq "MARCHE"} {#sim05
	append mod_terzi " <a href=\"#\" onclick=\"javascript:window.open('coimaimp-terzo-resp-help', 'help', 'scrollbars=yes, esizable=yes, width=620, height=380').moveTo(110,140)\"><b>Importante! Vedi nota</b></a>"
    }
    
    if {$id_ruolo ne "admin"
    && ($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])
    } {#Nicola 20/08/2014
	set cerca_inte "";#Nicola 20/08/2014
	set ins_inte   "";#Nicola 20/08/2014
	set ins_prop   "";#Nicola 20/08/2014
	set ins_occ    "";#Nicola 20/08/2014
	set ins_amm    "";#Nicola 20/08/2014
	set ins_terzi  "";#Nicola 20/08/2014
    };#Nicola 20/08/2014
} else {
    set cerca_inte  ""
    set ins_inte    ""
    set cerca_prop  ""
    set ins_prop    ""
    set cerca_occ   ""
    set ins_occ     ""
    set cerca_amm   ""
    set ins_amm     ""
    set cerca_terzi ""
    set ins_terzi   ""
}

element create $form_name dummy              -widget hidden -datatype text -optional
element create $form_name cod_manutentore    -widget hidden -datatype text -optional
element create $form_name nome_funz_new      -widget hidden -datatype text -optional
element create $form_name cod_impianto       -widget hidden -datatype text -optional
element create $form_name cod_intestatario   -widget hidden -datatype text -optional
element create $form_name cod_proprietario   -widget hidden -datatype text -optional
element create $form_name cod_occupante      -widget hidden -datatype text -optional
element create $form_name cod_amministratore -widget hidden -datatype text -optional
element create $form_name cod_terzi          -widget hidden -datatype text -optional
element create $form_name url_list_aimp      -widget hidden -datatype text -optional
element create $form_name url_aimp           -widget hidden -datatype text -optional
element create $form_name funzione           -widget hidden -datatype text -optional
element create $form_name caller             -widget hidden -datatype text -optional
element create $form_name nome_funz          -widget hidden -datatype text -optional
element create $form_name nome_funz_caller   -widget hidden -datatype text -optional
element create $form_name extra_par          -widget hidden -datatype text -optional
element create $form_name data_fin_valid     -widget hidden -datatype text -optional
element create $form_name submit             -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name last_cod_impianto  -widget hidden -datatype text -optional
element create $form_name is_warning_p       -widget hidden -datatype text -optional;#rom14
element set_properties $form_name is_warning_p -value $is_warning_p;#rom14
element create $form_name is_resp_da_agg     -widget hidden -datatype text -optional;#rom14
element set_properties $form_name is_resp_da_agg -value $is_resp_da_agg;#rom14

if {$funzione != "M" && $funzione != "D"} {
    element create $form_name data_ini_valid -widget hidden -datatype text -optional
}

set label_proprietario   "Proprietario"
set label_occupante      "Occupante"
set label_amministratore "Amministratore"
#rom05set label_intestatario   "Intestatario contratto"
set label_intestatario   "Intestatario del contratto fornitura combustibile";#rom05
set label_terzi          "Terzo responsabile"


#####fine element 1.6 ####

element create $form_name pdr \
    -label   "PDR" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name pod \
    -label   "POD" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 20 $readonly_fld {} class form_element" \
    -optional

element create $form_name volimetria_risc \
    -label   "Volimetria riscaldata" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name volimetria_raff \
    -label   "Volimetria raffreddamento" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

if {$flag_tipo_impianto eq "R"} {
    set nota_volimetria_risc "riscaldato"
} elseif {$flag_tipo_impianto eq "F"} {
    set nota_volimetria_risc "raffrescato"
} else {
    set nota_volimetria_risc ""
}

element create $form_name natura_giuridica \
    -label   "Natura giuridica" \
    -widget   select \
    -datatype text \
    -html    "readonly {} class form_element" \
    -mode    display \
    -optional \
    -options {{{} {}} {Fisica F} {Giuridica G}}
#gac01 tolto {Intestatario I}
element create $form_name flag_resp \
    -label   "Ruolo" \
    -widget   select \
    -datatype text \
    -html    "readonly {} class form_element" \
    -mode    display \
    -optional \
    -options {{{} {}} {Proprietario P} {Occupante O} {Amministratore A} {"Terzo responsabile" T}}

element create $form_name nome \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional 
    
element create $form_name cognome \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 readonly {} class form_element" \
    -optional 

#sim04 messo $readonly_fld al posto di readonly 
element create $form_name nome_inte \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional 

#sim04 messo $readonly_fld al posto di readonly
element create $form_name cognome_inte \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional 


element create $form_name cod_tpim \
    -label   "tipologia" \
    -widget   select \
    -datatype text \
    -html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
    -optional \
    -options [iter_selbox_from_table_wherec coimtpim cod_tpim  descr_tpim  "cod_tpim" "where cod_tpim in ('A','C')"]

element create $form_name unita_immobiliari_servite \
    -label   "Unità immobiliari servite" \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Unica U} {"Più unità" "P"}}

element create $form_name nome_condu \
    -label   "Nome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional 
    
element create $form_name cognome_condu \
    -label   "Cognome" \
    -widget   text \
    -datatype text \
    -html    "size 30 maxlength 100 $readonly_fld {} class form_element" \
    -optional 

#rom03 
element create $form_name pres_certificazione \
    -label   "Pres. certificaz." \
    -widget   select \
    -datatype text \
    -html    "$disabled_fld {} class form_element" \
    -optional \
    -options {{{} {}} {Sì S} {No N}}
#rom03
element create $form_name certificazione \
    -label   "Certificazione" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 40 $readonly_fld {} class form_element" \
    -optional

#link inserimento occupante
#element create $form_name nome_funz_new        -widget hidden -datatype text -optional    
set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
element set_properties $form_name nome_funz_new   -value $nome_funz_new

if {$funzione == "M" || $funzione == "I"} {
    set cerca_cod_condu [iter_search $form_name coimcondu-filter [list cod_conduttore cod_conduttore f_cognome cognome_condu f_nome nome_condu]]
    set ins_cod_condu    [iter_link_ins $form_name coimcondu-isrt [list cognome cognome_condu nome nome_condu cod_conduttore cod_conduttore nome_funz nome_funz] "Inserisci Soggetto"]
    
    set mod_prop [iter_link_ins $form_name coimcitt-gest [list cod_cittadino] "Gestione dati mancanti responsabile"]

    set mod_inte [iter_link_ins $form_name coimcitt-gest [list cod_cittadino cod_intestatario] "Gestione dati mancanti intestatario"]

} else {
    set cerca_cod_condu ""
    set ins_cod_condu ""
    set mod_prop ""
    set mod_inte ""
}

db_1row q "select i.cognome as cognome_inst
                    , i.nome    as nome_inst    
                 from coimaimp a
                 left outer join coimmanu i on i.cod_manutentore = a.cod_installatore 
                where a.cod_impianto = :cod_impianto"
element create $form_name cognome_inst \
    -label   "Cognome installatore" \
    -widget   text \
    -datatype text \
    -html    "size 40 maxlength 100 $disabled_imp {} class form_element" \
    -optional \
    -value $cognome_inst
    
element create $form_name nome_inst \
    -label   "Nome installatore" \
    -widget   text \
    -datatype text \
    -html    "size 20 maxlength 100 $disabled_imp {} class form_element" \
    -optional \
    -value $nome_inst

element create $form_name data_rottamaz \
    -label   "data_rottamaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_attivaz \
    -label   "data_attivaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name data_installaz \
    -label   "data_installaz" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional

element create $form_name anno_costruzione \
    -label   "anno costruzione" \
    -widget   text \
    -datatype text \
    -html    "size 10 maxlength 10 $readonly_fld {} class form_element" \
    -optional
# inizializzo valore dropdown
if {[db_0or1row sel_aimp {}] == 0} {
    iter_return_complaint "Record non trovato"
}

if {[string equal $cod_manutentore ""] && $coimtgen(flag_verifica_impianti) eq "t"} {
    set where_stat ""
} else {
    set where_stat "where cod_imst != 'F' and cod_imst != 'E'"
}

set stato_options [iter_selbox_from_table_wherec coimimst cod_imst descr_imst cod_imst $where_stat]

#calcolo la data entro cui posso annullare un impianto	
set max_hh_modimp [expr $max_gg_modimp * 24 ]
ns_log notice "Ore massime: $max_hh_modimp"
#andava in errore perche' si aspettava di trovare la data valorizzata: ho messo una costante
if {[string equal $data_ins ""]} {
    set data_ins "27/03/2008"
}
set data_ins_check [iter_check_date $data_ins]
ns_log notice "Installazione impianto: $data_ins_check"
ns_log notice "Data installazione: $data_installaz"
set expireddate [clock scan "$max_hh_modimp hours" -base [clock scan [iter_check_date $data_ins]]]
set currentscandate [clock scan [iter_check_date $current_date]]
ns_log notice "Manutentore: $cod_manutentore"
ns_log notice "Data corrente: $currentscandate"
ns_log notice "Data scadenza: $expireddate"
if { ![string equal $cod_manutentore ""] && ($currentscandate > $expireddate) } {
    if {$coimtgen(flag_verifica_impianti) eq "f"} {
	set index 0
	set indextoremove 0
	foreach element $stato_options {
	    incr index
	    foreach elementinner $element {
		if [string equal $elementinner $cod_imst_annu_manu] { 
		    set indextoremove $index
		} 
	    }
	}

	if {$coimtgen(ente) eq "PUD" || $coimtgen(ente) eq "PGO"} {
	    # Richiesta di Ucit del 07/03/2013
	    set stato_options1 {{Attivo A} {Rottamato R} {Nonattivo N} }
	    set newList $stato_options1
	} elseif {$coimtgen(regione) eq "CALABRIA" && $coimtgen(ente) ne "PRC"} {
	    # I manutentori dei 4 enti della Regione Calabria (esclusa la Provincia di Reggio
	    # Calabria) non possono modificare lo stato dell'impianto.
	    if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	    } {
		set descr_imst ""
	    }
	    set newList [list [list $descr_imst $stato]]
	} else {
	    # Caso Standard
	    set newList [lreplace $stato_options [expr $indextoremove - 1] [expr $indextoremove - 1] ]
	}
	
    } else {
	#faccio vedere solo Annullato o solo Respinto o lo stato attuale (diverso da Annullato e Respinto) e Annullato
	if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	} {
	    set descr_imst ""
	}
	if {$stato eq "L" || $stato eq "E"} {
	    set newList [list [list $descr_imst $stato]]
	} else {
	    set newList [list [list $descr_imst $stato] [list "Annullato" "L"]]
	}
    }

} else { 
    if {$coimtgen(flag_verifica_impianti) eq "f"} {
	set newList $stato_options
    } else {
	
	if {![string equal $cod_manutentore ""]} {
	    # faccio vedere solo Annullato o solo Respinto o lo stato attuale (diverso da Annullato e Respinto) e Annullato
	    if {![db_0or1row query "
            select descr_imst
              from coimimst
             where cod_imst = :stato"]
	    } {
		set descr_imst ""
	    }
	    if {$stato eq "L" || $stato eq "E"} {
		set newList [list [list $descr_imst $stato]]
	    } else {
		set newList [list [list $descr_imst $stato] [list "Annullato" "L"]]
	    }
	    
	} else {
	    set newList $stato_options
	}
	
    }
}

element create $form_name stato_db -widget hidden -datatype text -optional;#rom16

set disabled_fld_stato $disabled_fld ;#mat02
if {$cod_manutentore ne ""} { #mat02 aggiunta if e contenuto
    set disabled_fld_stato "disabled"
}

if {[iter_check_uten_manu $id_utente] ne ""} {#mat02 Aggiunta if e contenuto
    element create $form_name stato_edit \
	-label   "stato" \
	-widget   text \
	-datatype text \
	-html    "size 30 maxlength 100 disabled {} class form_element" \
	-optional \

    element create $form_name stato -widget hidden -datatype text -optional
} else {#mat 02 Aggiunta else ma non il contenuto
    element create $form_name stato \
	-label   "stato" \
	-widget   select \
	-datatype text \
	-html    "size 1 maxlength 1 $disabled_fld {} class form_element" \
	-optional \
	-options $newList
    
    element create $form_name stato_edit -widget hidden -datatype text -optional
}
    

# fine inizializzazione drop down
element create $form_name flag_conferma        -widget hidden -datatype text -optional;#rom05
element create $form_name cod_conduttore   -widget hidden -datatype text -optional
element create $form_name cod_cittadino    -widget hidden -datatype text -optional
#element create $form_name cod_intestatario -widget hidden -datatype text -optional
element create $form_name potenza_utile    -widget hidden -datatype text -optional
#element create $form_name dummy            -widget hidden -datatype tex -optional
#element create $form_name cod_impianto     -widget hidden -datatype text -optional
#element create $form_name funzione         -widget hidden -datatype text -optional
#element create $form_name caller           -widget hidden -datatype text -optional
#element create $form_name nome_funz        -widget hidden -datatype text -optional
#element create $form_name nome_funz_caller -widget hidden -datatype text -optional
#element create $form_name extra_par        -widget hidden -datatype text -optional

#element create $form_name submit        -widget submit -datatype text -label "$button_label" -html "class form_submit"

#element create $form_name last_cod_impianto -widget hidden -datatype text -optional
#element create $form_name url_aimp      -widget hidden -datatype text -optional
#element create $form_name url_list_aimp -widget hidden -datatype text -optional
if {$funzione != "I"} {
    if {[db_0or1row sel_aimp_stato "select stato
                                      from coimaimp
                                     where cod_impianto = :cod_impianto"] == 0} {
	set stato ""
    }
    #gab03 aggiunto colore al nuovo stato E
    switch $stato {
	"A"     {set color "green"}
	"D"     {set color "yellow"}
	"L"     {set color "red"}
	"N"     {set color "black"}
	"R"     {set color "black"}
        "U"     {set color "black"}
        "E"     {set color "red"}
	default {set color "gainsboro"}
    }
} else {
    set color "gainsboro"
}

if {[form is_request $form_name]} {

    ###########inizio 1.6 #######################
    
    set nome_funz_new [iter_get_nomefunz coimcitt-isrt]
    element set_properties $form_name nome_funz_new   -value $nome_funz_new
    
        if {![db_0or1row recup_date {}] == 0} {
        element set_properties $form_name data_ini_valid  -value $data_ini_valid
        element set_properties $form_name data_fin_valid  -value $data_fin_valid
	}
    
    if {$funzione == "I"} {
    } else {
        # leggo riga
        if {[db_0or1row sel_rif_sogg {}] == 0} {
            iter_return_complaint "Record non trovato"
        }

        if {$flag_responsabile == "T"} {

	    if {[db_0or1row sel_dittamanut "select coalesce(m.cognome,'') || ' ' || coalesce(m.nome,'') as dittamanut
               from coimmanu m
                  , coimaimp i
              where m.cod_legale_rapp = :cod_responsabile
                and m.cod_manutentore = i.cod_manutentore
                and i.cod_impianto    = :cod_impianto
              limit 1"] == 0} {

		if {[db_0or1row sel_dittamanut "select coalesce(cognome,'') || ' ' || coalesce(nome,'') as dittamanut
               from coimmanu
              where cod_legale_rapp = :cod_responsabile
              limit 1"] == 0} {
		    set dittamanut "non esistente"
		}
	    }
        }

        if {$funzione == "V" || $funzione == "D"} {
            if {![string equal $cod_proprietario ""]} {
                set label_proprietario "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_proprietario&flag_java=t\" target=proprietario>Proprietario</a>"
            }

            if {![string equal $cod_occupante ""]} {
                set label_occupante "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_occupante&flag_java=t\" target=occupante>Occupante</a>"
            }

            if {![string equal $cod_amministratore ""]} {
                set label_amministratore "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_amministratore&flag_java=t\" target=amministratore>Amministratore</a>"
            }

            if {![string equal $cod_intestatario ""]} {
                set label_intestatario "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_intestatario&flag_java=t\" target=intestatario>Intestatario del contratto fornitura combustibile</a>"
            }

            if {$flag_responsabile == "T"} {
                set label_terzi "<a href=\"coimcitt-gest?funzione=V&nome_funz=[iter_get_nomefunz coimcitt-gest]&cod_cittadino=$cod_responsabile&flag_java=t\" target=te\
rzo responsabile>Terzo responsabile</a>"
            }
        }

	if {($coimtgen(ente) eq "PPO" || [string match "*iterprfi_pu*" [db_get_database]])} {#Nicola 20/08/2014
	    #forzatura per publies
	    set flag_responsabile "I";#NIcola 20/08/2014
	};#Nicola 20/08/2014

        switch $flag_responsabile {
            T  {element set_properties $form_name cognome_terzi  -value $cognome_terzo
                element set_properties $form_name nome_terzi     -value $nome_terzo
                element set_properties $form_name cod_terzi      -value $cod_responsabile
                if {$funzione == "V"} {
                    element set_properties $form_name cod_fiscale_terzi -value $cod_fiscale_terzo
                }
            }
        }

        element set_properties $form_name cod_proprietario       -value $cod_proprietario

        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_prop   -value $cod_fiscale_prop
        }
        element set_properties $form_name cod_occupante      -value $cod_occupante
        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_occ   -value $cod_fiscale_occ
        }
        element set_properties $form_name cod_amministratore -value $cod_amministratore
        if {$funzione == "V"} {
            element set_properties $form_name cod_fiscale_amm    -value $cod_fiscale_amm
        }
        element set_properties $form_name cognome_prop      -value $cognome_prop
        element set_properties $form_name nome_prop         -value $nome_prop
        element set_properties $form_name cognome_occ       -value $cognome_occ
        element set_properties $form_name nome_occ          -value $nome_occ
        element set_properties $form_name cognome_amm       -value $cognome_amm
        element set_properties $form_name nome_amm          -value $nome_amm
        element set_properties $form_name flag_responsabile -value $flag_responsabile
	
        #data_installazione
        element set_properties $form_name data_variaz       -value $data_variaz

        #recupero ultima variazione effettuata
        db_1row ultima_mod ""
        if {![string equal $data_variaz ""]} {
            element set_properties $form_name data_variaz  -value $data_variaz
        }
    }

    ##############fine 1.6 ################
    
    element set_properties $form_name cod_impianto      -value $cod_impianto
    element set_properties $form_name funzione          -value $funzione
    element set_properties $form_name caller            -value $caller
    element set_properties $form_name nome_funz         -value $nome_funz
    element set_properties $form_name nome_funz_caller  -value $nome_funz_caller
    element set_properties $form_name extra_par         -value $extra_par
    element set_properties $form_name last_cod_impianto -value $last_cod_impianto
    element set_properties $form_name url_aimp          -value $url_aimp
    element set_properties $form_name url_list_aimp     -value $url_list_aimp
    element set_properties $form_name flag_conferma    -value "s";#rom05
    
    if {$funzione == "I"} {
	# TODO: settare eventuali default!!

    } else {
	# leggo riga
        if {[db_0or1row sel_aimp {}] == 0} {
            iter_return_complaint "Record non trovato"
	}
	if {[db_0or1row sel_condu {}] == 0} {
	    set cod_conduttore "" 
	    set nome_condu ""
	    set cognome_condu ""
	}
	if {[db_0or1row sel_citt {}] == 0} {
	    set cod_cittadino ""
	    set nome ""
	    set cognome ""
	}

	if {[db_0or1row sel_inte {}] == 0} {
	    set cod_intestatario ""
	    set nome_inte ""
	    set cognome_inte ""
	}

	# reperisco il numero dei generatori, la somma della potenza focolare
        # nominale e la somma della potenza utile nominale dai generatori e se 
        # non corrispondono a quelle inseriti visualizzo un messaggio di errore
	db_1row sel_count_generatori ""

        element set_properties $form_name pdr                       -value $pdr        
	element set_properties $form_name pod                       -value $pod
	element set_properties $form_name volimetria_risc           -value $volimetria_risc
	element set_properties $form_name volimetria_raff           -value $volimetria_raff
	element set_properties $form_name natura_giuridica          -value $natura_giuridica
	element set_properties $form_name flag_resp                 -value $flag_resp
	element set_properties $form_name cod_tpim                  -value $cod_tpim         
	element set_properties $form_name unita_immobiliari_servite -value $unita_immobiliari_servite        
	element set_properties $form_name nome_condu                -value $nome_condu     
	element set_properties $form_name cognome_condu             -value $cognome_condu
	element set_properties $form_name nome                      -value $nome
        element set_properties $form_name cognome                   -value $cognome
	element set_properties $form_name nome_inte                 -value $nome_inte
        element set_properties $form_name cognome_inte              -value $cognome_inte
	element set_properties $form_name cod_conduttore            -value $cod_conduttore
	element set_properties $form_name cod_cittadino             -value $cod_cittadino
	element set_properties $form_name cod_intestatario          -value $cod_intestatario
	element set_properties $form_name potenza_utile             -value $potenza_utile
	element set_properties $form_name pres_certificazione       -value $pres_certificazione;#rom03
        element set_properties $form_name certificazione            -value $certificazione;#rom03
	element set_properties $form_name cognome_inst          -value $cognome_inst
	element set_properties $form_name nome_inst             -value $nome_inst
	element set_properties $form_name data_installaz        -value $data_installaz;#gac02
	element set_properties $form_name anno_costruzione      -value $anno_costruzione;#gac02
		if {$funzione == "C"} {
	    if {$flag_cod_aimp_auto == "F"} {
		db_1row sel_cod_aimp_est ""
	    } else {
		set cod_impianto_est ""
	    }
	    set stato "A"
	    if {![string equal $data_rottamaz ""]} {
		set data_installaz $data_rottamaz
	    }
	    set data_rottamaz ""
	}
	element set_properties $form_name data_rottamaz    -value $data_rottamaz
	element set_properties $form_name stato            -value $stato
	set stato_edit_db [db_string q "select descr_imst from coimimst where cod_imst=:stato" -default ""];#mat02
	element set_properties $form_name stato_edit       -value $stato_edit_db;#mat02
	element set_properties $form_name stato_db         -value $stato_db;#rom16
        element set_properties $form_name data_attivaz     -value $data_attivaz
	
    }
}
if {![db_0or1row recup_date {}] == 0} {#rom07 if e suo contenuto
    element set_properties $form_name data_ini_valid  -value $data_ini_valid
    element set_properties $form_name data_fin_valid  -value $data_fin_valid
}
#rom07recupero ultima variazione effettuata
db_1row ultima_mod "";#rom07
if {![string equal $data_variaz ""]} {#rom07 aggiunta if e suo contenuto
    element set_properties $form_name data_variaz  -value $data_variaz
};#rom07

if {[form is_valid $form_name]} {
    
    #################inizio 1.6 ###############################

        # form valido dal punto di vista del templating system
    set flag_responsabile  [element::get_value $form_name flag_responsabile]
    set cod_intestatario   [element::get_value $form_name cod_intestatario]
    set cod_proprietario   [element::get_value $form_name cod_proprietario]
    if {$funzione == "V"} {
        set cod_fiscale_prop   [element::get_value $form_name cod_fiscale_prop]
    }
    set cognome_prop       [element::get_value $form_name cognome_prop]
    set nome_prop          [element::get_value $form_name nome_prop]
    set cod_occupante      [element::get_value $form_name cod_occupante]
    if {$funzione == "V"} {
        set cod_fiscale_occ    [element::get_value $form_name cod_fiscale_occ]
    }
    set cognome_occ        [element::get_value $form_name cognome_occ]
    set nome_occ           [element::get_value $form_name nome_occ]
    set cod_amministratore [element::get_value $form_name cod_amministratore]
    if {$funzione == "V"} {
        set cod_fiscale_amm    [element::get_value $form_name cod_fiscale_amm]
    }
    set cognome_amm        [element::get_value $form_name cognome_amm]
    set nome_amm           [element::get_value $form_name nome_amm]
    set cod_terzi          [element::get_value $form_name cod_terzi]
    if {$funzione == "V"} {
        set cod_fiscale_terzi  [element::get_value $form_name cod_fiscale_terzi]
    }
    set cognome_terzi      [element::get_value $form_name cognome_terzi]
    set nome_terzi         [element::get_value $form_name nome_terzi]
    set url_list_aimp      [element::get_value $form_name url_list_aimp]
    set url_aimp           [element::get_value $form_name url_aimp]
    element set_properties $form_name data_ini_valid  -value $data_ini_valid;#rom07
    element set_properties $form_name data_fin_valid  -value $data_fin_valid;#rom07
    set data_ini_valid     [element::get_value $form_name data_ini_valid]
    set data_fin_valid     [element::get_value $form_name data_fin_valid]
    element set_properties $form_name data_variaz       -value $data_variaz;#rom07
    set data_variaz        [element::get_value $form_name data_variaz]
    set data_installaz     [element::get_value $form_name data_installaz];#gac02
    set anno_costruzione   [element::get_value $form_name anno_costruzione];#gac02
    set is_warning_p     [string trim [element::get_value $form_name is_warning_p]];#rom14
    set is_resp_da_agg   [string trim [element::get_value $form_name is_resp_da_agg]];#rom14
    if {[db_0or1row sel_aimp_1_6 ""] == 0} {
        set flag_dichiarato "S"
    }

    # controlli standard su numeri e date, per Ins ed Upd
    set error_num 0
    
    if {$funzione == "I" || $funzione == "M"} {
        #routine generica per controllo codice soggetto
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
            db_foreach sel_citt_1_6 "" {
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

        if {[string equal $cognome_prop ""] && [string equal $nome_prop    ""]} {
            set cod_proprietario ""
        } else {
            set chk_inp_cod_citt $cod_proprietario
            set chk_inp_cognome  $cognome_prop
            set chk_inp_nome     $nome_prop
            eval $check_cod_citt
            set cod_proprietario $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_prop $chk_out_msg
                incr error_num
            }
        }

        if {[string equal $cognome_occ ""] && [string equal $nome_occ ""]} {
            set cod_occupante ""
        } else {
            set chk_inp_cod_citt $cod_occupante
            set chk_inp_cognome  $cognome_occ
            set chk_inp_nome     $nome_occ
            eval $check_cod_citt
            set cod_occupante    $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_occ $chk_out_msg
                incr error_num
            }
        }
        if {[string equal $cognome_amm ""] && [string equal $nome_amm ""]} {
            set cod_amministratore ""
        } else {
            set chk_inp_cod_citt   $cod_amministratore
            set chk_inp_cognome    $cognome_amm
            set chk_inp_nome       $nome_amm
            eval $check_cod_citt
            set cod_amministratore $chk_out_cod_citt
            if {$chk_out_rc == 0} {
                element::set_error $form_name cognome_amm $chk_out_msg
                incr error_num
            }
        }

        if {[string equal $cognome_terzi ""] && [string equal $nome_terzi ""]} {
            set cod_terzi ""
        } else {
            if {![string equal $flag_responsabile "T"]} {
                element::set_error $form_name cognome_terzi "non inserire terzo responsabile: non &egrave; il responsabile"
                incr error_num
            } else {
                if {[string range $cod_terzi 0 1] == "MA"} {
                    set cod_manutentore $cod_terzi

                    element set_properties $form_name cod_manutentore   -value $cod_manutentore
                    if {[db_0or1row sel_cod_legale ""] == 0} {
                        set link_ins_rapp [iter_link_ins $form_name coimcitt-isrt [list cognome cognome_terzi nome nome_terzi nome_funz nome_funz_new dummy dummy dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy  dummy dummy cod_manutentore cod_manutentore dummy dummy] "crea automaticamente legale rappresentante"]
                        element::set_error $form_name cognome_terzi "aggiornare il manutentore con i dati del legale rappresentante <br>o $link_ins_rapp"
                        incr error_num
                    } else {
                        set chk_inp_cod_citt $cod_terzi
                        set chk_inp_cognome  $cognome_terzi
                        set chk_inp_nome     $nome_terzi
                        eval $check_cod_citt
                        set cod_terzi        $chk_out_cod_citt
                        if {$chk_out_rc == 0} {
                            element::set_error $form_name cognome_terzi $chk_out_msg
                            incr error_num
                        }
                    }
                }
            }
        }

	if {[string equal $cognome_prop ""] && [string equal $nome_prop ""]} {#rom06 aggiunta if e suo contenuto
	    element::set_error $form_name cognome_prop "Inserire proprietario"
	    incr error_num
	}

	#sim02 devo settarlo a vuoto perchè in caso di annullamento il programma salta i controlli ed andava in errore
	set cod_responsabile "";#sim02

        #congruenza cod_resp con rispettivo codice
        switch $flag_responsabile {
            "T" {
                if {[string equal $cognome_terzi ""] && [string equal $nome_terzi ""]} {
                    element::set_error $form_name cognome_terzi "inserire terzo responsabile: &egrave; il responsabile"
                    incr error_num
                } else {

		    if {[db_0or1row q "select 1
                                         from coimmanu
                                        where cod_manutentore = :cod_manutentore
                                          and patentino != 't'"]
		    && 	$potenza_utile > 232} {#rom07 aggiunta if e contenuto, aggiunta else ma non contenuto
			#rom17element::set_error $form_name cognome_terzi "Impossibile inserire come terzo responsabile un manutentore senza patentino se l'impianto ha potenza nominale utile > 232 kW $potenza_utile"
			element::set_error $form_name cognome_terzi "Impossibile inserire come terzo responsabile un manutentore senza patentino<br>se l'impianto ha potenza nominale utile > 232 kW [iter_edit_num $potenza_utile 2].<br>Per informazioni, risoluzioni di problemi contattare l'ente/soggetto esecutore.";#rom17
			incr error_num
		    } else {
			set cod_responsabile $cod_terzi
		    };#rom07
                }
            }
            "P" {
                if {[string equal $cognome_prop ""] && [string equal $nome_prop ""]} {
                    element::set_error $form_name cognome_prop "inserire proprietario: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_proprietario
                }
            }
            "O" {
                if {[string equal $cognome_occ ""] &&  [string equal $nome_occ ""]} {
                    element::set_error $form_name cognome_occ "inserire occupante: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_occupante
                }
            }
            "A" {
                if {[string equal $cognome_amm ""] && [string equal $nome_amm ""]} {
                    element::set_error $form_name cognome_amm "inserire amministratore: &egrave; il responsabile"
                    incr error_num
                } else {
                    set cod_responsabile $cod_amministratore
                }
            }
            default {
                if {$flag_dichiarato == "S"} {
                    element::set_error $form_name flag_responsabile "Indicare responsabile"
                    incr error_num
                }
            }
        }

	if {[string equal $data_installaz ""]} {#gac02 aggiunta if, else e loro contenuto
	    element::set_error $form_name data_installaz "Inserire Data inst."
	    incr error_num
	} else {
	    set data_installaz [iter_check_date $data_installaz]
	    if {$data_installaz == 0} {
		element::set_error $form_name data_installaz "Data installazione deve essere una data"
		incr error_num
	    } else {
		if {$data_installaz > $current_date} {
		    element::set_error $form_name data_installaz "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	};#gac02 
	
	if {![string equal $anno_costruzione ""]} {#gac02 aggiunta if, else e loro contenuto
	    if {[string length $anno_costruzione] == 4} {
		set anno_costruzione "01/01/$anno_costruzione"
	    }
	    set anno_costruzione [iter_check_date $anno_costruzione]
	    if {$anno_costruzione == 0} {
		element::set_error $form_name anno_costruzione "Data non corretta"
		incr error_num
	    } else {
		if {$anno_costruzione > $current_date} {
		    element::set_error $form_name anno_costruzione "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
	}
	
	if {$anno_costruzione ne "" && $data_installaz ne ""} {#gac02 aggiunto if e suo contenuto
	    if {$anno_costruzione > $data_installaz} {
		element::set_error $form_name data_installaz "Data installazione deve essere maggiore alla data di costruzione"
		incr error_num
	    }
	}
	
    }

    if {$funzione == "M" ||  $funzione == "D"} {
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

        #non è possibile storicizzare modifiche con data_validità inferiore
        # a modifiche già storicizzate
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
    set stato            [string trim [element::get_value $form_name stato]];#sim02
    set stato_db         [string trim [element::get_value $form_name stato_db]];#rom16
    set stato_edit_db [db_string q "select descr_imst from coimimst where cod_imst=:stato_db" -default ""];#mat02
    element set_properties $form_name stato_edit       -value $stato_edit_db                              ;#mat02
    set stato_edit       [string trim [element::get_value $form_name stato_edit]]                         ;#mat02
    if {[db_0or1row q "select 1
                         from coimaimp
                        where cod_impianto = :cod_impianto
                          and stato != :stato
                          and :stato = 'A'"] && [string equal $cod_manutentore ""]} {#rom11 aggiunta if e suo contenuto
	#Se sto riattivando l'impianto e sono l'ente devo evitare i controlli.
	set error_num 0
    }

    if {$error_num == 0 &&
	[db_0or1row q "select 1
                         from coimaimp
                        where cod_impianto      = :cod_impianto
                          and (flag_resp       != :flag_responsabile
                           or cod_responsabile != :cod_responsabile)
                        limit 1"]} {#rom14 Aggiunta if e suo contenuto

	if {$is_warning_p eq "f" &&
	    [db_0or1row q "select count(*)
                             from coimaimp
                            where upper(targa)  = upper(:targa)
                           having count(*) > 1"]} {
	    if {$flag_responsabile eq "T" ||
		[db_0or1row q "select 1
                                 from coimaimp
                                where upper(targa)  = upper(:targa)
                                  and cod_impianto != :cod_impianto
                                  and upper(stato)  = 'A'
                                  and flag_resp     = 'T'
                                limit 1"]} {
		
		# Se sto modificando il responsabile dell'impianto mettendo un terzo responsabile non devo allineare automaticamente
		# i responsabili degli altri impianti con la stessa targa ma faccio uscire un warning di avvertimento.
		element::set_error $form_name flag_responsabile "ATTENZIONE: il responsabile d'impianto non coincide con quello degli impianti gi&agrave; a catasto con il medesimo codice targa: prima di confermare il dato, controlla se il responsabile da te indicato per questo impianto &egrave; corretto."
		incr error_num
		set is_resp_da_agg "f"

	    } else {
		
		# Faccio uscire un warning anche quando devo allineare i responsabili degli altri impianti con la stessa.
		element::set_error $form_name flag_responsabile "ATTENZIONE: il responsabile d'impianto non coincide con quello degli impianti gi&agrave; a catasto con il medesimo codice targa: sei sicuro del dato inserito? Se confermi l'inserimento, questo responsabile verr&agrave; associato anche agli impianti con lo stesso codice targa."
		incr error_num
		set is_resp_da_agg "t"
		
	    }
	
	    set is_warning_p "t"	
	} else {
	    set is_warning_p "f"
	}
    }
    element set_properties $form_name is_warning_p   -value $is_warning_p
    element set_properties $form_name is_resp_da_agg -value $is_resp_da_agg 
    
    #sim02 aggiunto condizione su stato impianto
    if {$error_num > 0 && !($stato ne "A" && [string equal $cod_manutentore ""])} {
#	[template::form::get_errors $form_name]
        ad_return_template
        return
    }

    set sw_query "N"
    set dml_sql_sogg ""

    if {$funzione == "M" || $funzione == "D"} {
        #leggo il record originale(prima delle modifiche)dalla tabella coimaimp
        if {![db_0or1row sel_aimp_db {}] == 0} {
            # per ogni campo del soggetto che è stato modificato rispetto al
            # record originale (tranne il caso in cui l'originale fosse = ""),
            # viene storicizzato il record pre-modifica.
            set indice 1

            while {$indice <= 5} {
                switch $indice {
                    1 {
                        if {![string equal $db_cod_responsabile ""] &&  $db_cod_responsabile  != $cod_responsabile} {
                            set ruolo "R"
                            set db_cod_soggetto $db_cod_responsabile
                            if {[db_0or1row  sel_sogg_check ""] ==0} { 
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    2 {
			if {(![string equal $db_cod_intestatario ""] && $db_cod_intestatario  != $cod_intestatario)} {
			    set ruolo "T"
			    set db_cod_soggetto $db_cod_intestatario
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    3 {
			if {(![string equal $db_cod_proprietario ""] && $db_cod_proprietario  != $cod_proprietario)} {
			    set ruolo "P"
			    set db_cod_soggetto $db_cod_proprietario
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    4 {
			if {(![string equal $db_cod_occupante ""] && $db_cod_occupante != $cod_occupante)} {
			    set ruolo "O"
			    set db_cod_soggetto $db_cod_occupante
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		    5 {
			if {(![string equal $db_cod_amministratore ""] && $db_cod_amministratore != $cod_amministratore)} {
			    set ruolo "A"
			    set db_cod_soggetto $db_cod_amministratore
			    if {[db_0or1row  sel_sogg_check ""] ==0} {
				set dml_sql_sogg [db_map ins_sogg]
				set sw_query "S"
			    }
			}
		    }
		}
		
		# Lancio la query di manipolazione dati contenute in dml_sql
		if {[info exists dml_sql_sogg]} {
		    with_catch error_msg {
			db_transaction {
			    if {$sw_query == "S"} {
				db_dml dml_coimaimp $dml_sql_sogg
			    }
			}
		    } {
			iter_return_complaint "Spiacente, ma il DBMS ha restituito il seguente messaggio di errore <br><b>$error_msg</b><br> Contattare amministratore di sistema e comunicare il messaggio d'errore. Grazie."
		    }
		}
		set sw_query "N"
		set indice [expr $indice + 1]
	    }
	}
    }

    switch $funzione {
	M { 
            if {$coimtgen(regione) eq "MARCHE"} {#rom02 if e contenuto

                set cod_manutentore [iter_check_uten_manu $id_utente]
                #rom14if {$cod_manutentore ne ""} {}
		    set cod_propr_new         $cod_proprietario
		    set cod_occu_new          $cod_occupante
		    set cod_ammi_new          $cod_amministratore
		    set cod_resp_new          $cod_responsabile
		    set cod_inte_new          $cod_intestatario 
		    set cognome_prop_new      $cognome_prop      
		    set nome_prop_new         $nome_prop         
		    set cognome_occ_new       $cognome_occ       
		    set nome_occ_new          $nome_occ          
		    set cognome_amm_new       $cognome_amm       
		    set nome_amm_new          $nome_amm          
		    set cognome_terzo_new     $cognome_terzi     
		    set nome_terzo_new        $nome_terzi     
		    #set cognome_inte_new      $cognome_inte      
		    #set nome_inte_new         $nome_inte         
		    set flag_resp_new         $flag_responsabile

                    db_1row q "select m.cognome                         as cognome_manutentore
                                    , m.nome                            as nome_manutentore
                                    , iter_edit_data(current_date)      as data_modifica
                                    , a.cod_impianto_est                as codice_impianto
                                    , coalesce(a.cod_proprietario,'')   as cod_propr_old
                                    , coalesce(a.cod_occupante,'')      as cod_occu_old
                                    , coalesce(a.cod_amministratore,'') as cod_ammi_old
                                    , coalesce(a.cod_responsabile,'')   as cod_resp_old
                                    , coalesce(a.cod_intestatario,'')   as cod_inte_old
                                    , coalesce(a.flag_resp,'')          as flag_resp_old
                                    , coalesce(b.cognome,'')            as cognome_prop_old
                                    , coalesce(b.nome,'')               as nome_prop_old
                                    , coalesce(c.cognome,'')            as cognome_occ_old 
                                    , coalesce(c.nome,'')               as nome_occ_old 
                                    , coalesce(d.cognome,'')            as cognome_amm_old
                                    , coalesce(d.nome,'')               as nome_amm_old
                                    , coalesce(e.cognome,'')            as cognome_terzo_old
                                    , coalesce(e.nome,'')               as nome_terzo_old
                               --   , coalesce(f.cognome,'')            as cognome_inte_old
                                    , coalesce(f.nome,'')               as nome_inte_old
                                    , case a.flag_resp
                                      when 'P' then 'il Proprietario'
                                      when 'T' then 'il Terzo Responsabile'  
                                      when 'O' then 'l''Occupante'
                                      when 'A' then 'l''Amministratore'
                               --     when 'I' then 'l''Intestatario'
                                      else ''
                                       end as edit_flag_resp_old  
                                 from coimaimp a
                                 left outer join coimcitt b on b.cod_cittadino   = a.cod_proprietario
                                 left outer join coimcitt c on c.cod_cittadino   = a.cod_occupante
                                 left outer join coimcitt d on d.cod_cittadino   = a.cod_amministratore
                                 left outer join coimcitt e on e.cod_cittadino   = a.cod_responsabile
                                 left outer join coimcitt f on f.cod_cittadino   = a.cod_intestatario
                                 left outer join coimmanu m on (m.cod_manutentore = a.cod_manutentore
                                                           and m.cod_manutentore = :cod_manutentore)
                                                            or (m.cod_manutentore = a.cod_installatore
                                                            and a.cod_installatore = :cod_manutentore) --rom12
                                where a.cod_impianto    = :cod_impianto
                                --rom12  and a.cod_manutentore = m.cod_manutentore"
		if {$cod_manutentore ne ""} {#rom14 Aggiunta if ma non il suo contenuto
		    set testo_mail ""
		    if {$cod_inte_old     eq $cod_inte_new
			&& $cod_propr_old eq $cod_propr_new
			&& $cod_occu_old  eq $cod_occu_new
			&& $cod_ammi_old  eq $cod_ammi_new
			&& $cod_resp_old  eq $cod_resp_new 
			&& $flag_resp_old eq $flag_resp_new
		    } {
			set invio_mail "N"
		    } else {
			set invio_mail "S"
			
			if {(($flag_resp_old eq "" && $flag_resp_new ne "") ||
			     ($flag_resp_old ne "" && $flag_resp_old ne $flag_resp_new))
			    && $flag_resp_new ne "T"} {#rom14 Aggiunta if e suo contenuto:

			    set ls_cod_imp_est [db_list q "select cod_impianto_est
                                                             from coimaimp
                                                            where upper(targa)  = upper(:targa)
                                                              and upper(stato)  = 'A'"]
			    
			    append testo_mail "ATTENZIONE: il Manutentore  $cognome_manutentore $nome_manutentore con codice $cod_manutentore ha modificato il responsabile delle \"Scheda 1.6: Soggetti che operano sull'impianto\" degli impianti $ls_cod_imp_est associati alla Targa $targa
"
			} else {#rom14 Aggiunta else ma non il suo contenuto

			    append testo_mail "ATTENZIONE: il Manutentore  $cognome_manutentore $nome_manutentore con codice $cod_manutentore ha modificato la \"Scheda 1.6: Soggetti che operano sull'impianto\" dell'impianto con codice $codice_impianto.
"
			};#rom14

			if {($flag_resp_old eq "") && ($flag_resp_new ne "")} {
			    switch $flag_resp_new {
				"P" { append testo_mail "E' stato messo come Responsabile il Proprietario $cognome_prop_new $nome_prop_new.
"
				}
				"T" { append testo_mail "E' stato messo come Responsabile il Terzo responsabile $cognome_terzo_new $nome_terzo_new.
"
				}
				"O" { append testo_mail "E' stato messo come Responsabile l'Occupante $cognome_occ_new $nome_occ_new.
"
				}
				"A" { append testo_mail "E' stato messo come Responsabile l'Amministratore $cognome_amm_new $nome_amm_new.
"
				}
				"I" {#Intestatario è stato tolto dalle options del responsabile; non aggiungo niente al messaggio della mail 
				    append testo_mail ""
				}
			    }
			}
#			if {($cod_inte_old eq "") && ($cod_inte_new ne "")} {
#			    append testo_mail "E' stato aggiunto un nuovo Intestatario $cognome_inte_new $nome_inte_new.
#"
#			}
			if {($cod_propr_old eq "") && ($cod_propr_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Proprietario $cognome_prop_new $nome_prop_new.
"
			}
			if {($cod_occu_old eq "") && ($cod_occu_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Occupante $cognome_occ_new $nome_occ_new.
"
			}
			if {($cod_ammi_old eq "") && ($cod_ammi_new ne "")} {
			    append testo_mail "E' stato aggiunto un nuovo Amministratore $cognome_amm_new $nome_amm_new.
"
			}
			if {$flag_resp_new eq "T" && $cod_resp_new ne "" && $flag_resp_old ne "T"} {
			    append testo_mail "E' stato aggiunto un nuovo Terzo Responsabile $cognome_terzo_new $nome_terzo_new.
"
			}

			if {($flag_resp_old ne "") && ($flag_resp_old ne $flag_resp_new)} {
                            switch $flag_resp_new {
                                "P" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma il Proprietario $cognome_prop_new $nome_prop_new.
"
                                }
                                "T" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma il Terzo responsabile $cognome_terzo_new $nome_terzo_new.
"
                                }
                                "O" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Occupante $cognome_occ_new $nome_occ_new.
"
                                }
                                "A" { append testo_mail "Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Amministratore $cognome_amm_new $nome_amm_new.
"
                                }
                                "I" {#Intestatario è stato tolto dalle options del responsabile; non aggiungo niente al messaggio della mail
                                    append testo_mail ""
                                }
                            }
                        }
#			if {($cod_inte_old ne "") && ($cod_inte_old ne $cod_inte_new)} {
#			    if {$cod_inte_new eq ""} {
#				append testo_mail "L'Intestatario contratto $cognome_inte_old $nome_inte_old è stato rimosso.
#"
#			    } else {
#				append testo_mail "Il vecchio Intestatario contratto $cognome_inte_old $nome_inte_old è stato cambiato con $cognome_inte_new $nome_inte_new.
#"
#			    }
#			}
			if {($cod_propr_old ne "") && ($cod_propr_old ne $cod_propr_new)} {
			    
			    if {$cod_propr_new eq ""} {

				append testo_mail "Il Proprietario $cognome_prop_old $nome_prop_old è stato rimosso.
"
			    } else {
				append testo_mail "Il vecchio Proprietario $cognome_prop_old $nome_prop_old è stato cambiato con $cognome_prop_new $nome_prop_new.
"
			    }
			}
			if {($cod_occu_old ne "") && ($cod_occu_old ne $cod_occu_new)} {
			    if {$cod_occu_new eq ""} {
				append testo_mail "L'Occupante $cognome_occ_old $nome_occ_old è stato rimosso.
"
                            } else {
				append testo_mail "Il vecchio Occupante $cognome_occ_old $nome_occ_old è stato cambiato con $cognome_occ_new $nome_occ_new.
"
			    }
			}
			if {($cod_ammi_old ne "") && ($cod_ammi_old ne $cod_ammi_new)} {
			    if {$cod_ammi_new eq ""} {
				append testo_mail "L'Amministratore $cognome_amm_old $nome_amm_old è stato rimosso.
"
                            } else {
				append testo_mail "Il vecchio Amministratore $cognome_amm_old $nome_amm_old è stato cambiato con $cognome_amm_new $nome_amm_new.
"
			    }
			}
			if {($flag_resp_old ne $flag_resp_new) && $flag_resp_old eq "T"} {
			    append testo_mail "Il Terzo responsabile $cognome_terzo_old $nome_terzo_old è stato rimosso.
"
			}
			if {($flag_resp_old eq $flag_resp_new) &&  
			    ($cod_resp_old ne "") && ($cod_resp_old ne $cod_resp_new) && $flag_resp_old eq "T"} {
			    append testo_mail "Il vecchio Terzo responsabile $cognome_terzo_old $nome_terzo_old è stato cambiato con $cognome_terzo_new $nome_terzo_new.
"
			}
			
		    };#fine else
                    #proc per invio mail
		    if {$invio_mail eq "S"} {
			iter_get_coimdesc
			if {$coimtgen(ente) eq "PFM"} {#rom09 aggiunta if e suo contenuto
			    #rom09 La Prov. di Fermo ha problemi di ricezione delle mail quindi
			    #rom09 metto come mittente la mail di regione Marche

			    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "impiantitermici@regione.marche.it" -subject "Modifica soggetto ITER"  -body $testo_mail
			    
			} else {#rom09 aggiunta else ma non suo contenuto
			    
			    acs_mail_lite::send -send_immediately -to_addr "$coimdesc(email)" -from_addr "$coimdesc(email)" -subject "Modifica soggetto ITER"  -body $testo_mail
			    
			}
		    }
                }
            };#rom02

	    set dml_sql [db_map upd_aimp_1_6]

	    if {$cod_resp_old ne $cod_resp_new && $is_resp_da_agg eq "t"} {#rom14 Aggiunta if e suo contenuto
		
		set testo_mail_imp_coll_manu ""

		switch $flag_resp_new {
		    "P" {
			set resp_da_agg "  cod_proprietario = :cod_resp_new
                                         , cod_responsabile = :cod_resp_new"
			append testo_mail_imp_coll_manu "\n Il responsabile dell'Impianto non è più $edit_flag_resp_old ma il Proprietario $cognome_prop_new $nome_prop_new."
		    }
		    "T" {
			# Giuliodori e Basili hanno detto per mail che i terzi responsabili
			# possono essere diversi per ogni singolo impianto anche se hanno la
			# stessa targa, quindi non devo fare niente.
			
			#set resp_da_agg "  cod_responsabile = :cod_resp_new"
			append testo_mail_imp_coll_manu ""
		    }
		    "O" {
			set resp_da_agg "  cod_occupante    = :cod_resp_new
                                         , cod_responsabile = :cod_resp_new"
			append testo_mail_imp_coll_manu "\n Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Occupante $cognome_occ_new $nome_occ_new."
		    }
		    "A" {
			set resp_da_agg "  cod_amministratore = :cod_resp_new
                                         , cod_responsabile   = :cod_resp_new"
			append testo_mail_imp_coll_manu "\n Il responsabile dell'Impianto non è più $edit_flag_resp_old ma l'Amministratore $cognome_amm_new $nome_amm_new."
		    }
		    "I" {#Intestatario è stato tolto dalle options del responsabile; non aggiungo niente al messaggio della mail
			set resp_da_agg ""
			append testo_mail_imp_coll_manu ""
		    }
		}

	
		# Estraggo gli altri impianti collegati alla stessa targa dove andro' a modificare il responsabile.
		set lst_cod_imp_coll [db_list_of_lists q "select cod_impianto
                                                               , cod_impianto_est
                                                            from coimaimp
                                                           where upper(targa)  = upper(:targa)
                                                             and cod_impianto != :cod_impianto
                                                             and upper(stato)  = 'A'"]	       
		
		foreach aimp_coll $lst_cod_imp_coll {

		    util_unlist $aimp_coll cod_imp_coll cod_imp_est_coll
		    
		    db_dml q "update coimaimp
                                 set flag_resp     = :flag_responsabile
                                   , $resp_da_agg
                                   , data_mod      = current_date
                                   , utente        = :id_utente
                               where cod_impianto  = :cod_imp_coll"		    
		}

		set ls_cod_manu_coll [db_list q "select coalesce(cod_manutentore, 'null')
                                                    from coimaimp
                                                   where upper(targa)  = upper(:targa)
                                                     and cod_impianto != :cod_impianto
                                                     and upper(stato)  = 'A'
                                                   group by cod_manutentore"]

		foreach cod_manu_coll $ls_cod_manu_coll {
		
		    if {![string equal $cod_manutentore ""] &&
			![string equal $cod_manu_coll "null"] &&
			![string equal $cod_manu_coll $cod_manutentore]} {
			# Faccio un invio mail ai manutentori degli impianti associati alla targa in questo modo:
			#  1- Escludo da questo foreach il manutentore che ha fatto la modifica.
			#  2- La modifica / inserimento del Responsabile deve essere fatta da un'altro manutentore, altrimenti non invio mail.
			#  3- Se un manutentore ha piu' impianti faccio un'unica mail con l'elenco dei suoi impianti modificati.
			#  4- Per mandare una mail devo trovare la mail del manutentore
			
			set ls_cod_imp_est_manu_coll [db_list q "select cod_impianto_est
                                                                   from coimaimp
                                                                  where upper(targa)    = upper(:targa)
                                                                    and cod_manutentore = :cod_manu_coll"]
			if {[db_0or1row q "select email as mail_manu
                                             from coimmanu
                                            where cod_manutentore = :cod_manu_coll"]} {
			    if {[llength $ls_cod_imp_est_manu_coll] == "1"} {  
				set testo_mail_imp_coll_manu "ATTENZIONE: è stato modificato il soggetto responsabile per l'Impianto con codice $ls_cod_imp_est_manu_coll associato alla targa $targa: $testo_mail_imp_coll_manu"				
			    } else {
				set testo_mail_imp_coll_manu "ATTENZIONE: è stato modificato il soggetto responsabile per gli Impianti con codice $ls_cod_imp_est_manu_coll associati alla targa $targa: $testo_mail_imp_coll_manu"
			    }

			    if {$coimtgen(ente) eq "PFM"} {#rom18 Aggiunte if, else e loro contenuto
				set mail_ente "impiantitermici@regione.marche.it"
			    } else {
				set mail_ente $coimdesc(email)
			    }
				
			    acs_mail_lite::send \
				-send_immediately \
				-to_addr "$mail_manu" \
				-from_addr "$mail_ente" \
				-subject "Modifica soggetto ITER $targa"\
				-body $testo_mail_imp_coll_manu
			}
		    }
		}
	    }
	    
	}
	D {set dml_sql [db_map del_aimp_1_6]}
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

    #################fine 1.6 ###########################

    # form valido dal punto di vista del templating system
    set flag_conferma    [element::get_value $form_name flag_conferma       ];#rom05
    set pdr                        [string trim [element::get_value $form_name pdr                      ]]
    set pod                        [string trim [element::get_value $form_name pod                      ]]
    set volimetria_risc            [string trim [element::get_value $form_name volimetria_risc]]
    set volimetria_raff            [string trim [element::get_value $form_name volimetria_raff]]
    set natura_giuridica           [string trim [element::get_value $form_name natura_giuridica         ]]
    set flag_resp                  [string trim [element::get_value $form_name flag_resp                ]]
    set cod_tpim                   [string trim [element::get_value $form_name cod_tpim                 ]]
    set unita_immobiliari_servite  [string trim [element::get_value $form_name unita_immobiliari_servite]]
    set nome_condu                 [string trim [element::get_value $form_name nome_condu               ]]
    set cognome_condu              [string trim [element::get_value $form_name cognome_condu            ]]
    set nome                       [string trim [element::get_value $form_name nome                     ]]
    set cognome                    [string trim [element::get_value $form_name cognome                  ]]
    set nome_inte                  [string trim [element::get_value $form_name nome_inte                ]]
    set cognome_inte               [string trim [element::get_value $form_name cognome_inte             ]]
    set cod_conduttore             [string trim [element::get_value $form_name cod_conduttore           ]]
    set cod_cittadino              [string trim [element::get_value $form_name cod_cittadino            ]]
    set cod_intestatario           [string trim [element::get_value $form_name cod_intestatario         ]]
    set potenza_utile              [string trim [element::get_value $form_name potenza_utile            ]]
    set pres_certificazione        [string trim [element::get_value $form_name pres_certificazione      ]];#rom03
    set certificazione             [string trim [element::get_value $form_name certificazione           ]];#rom03
    element set_properties $form_name cognome_inst          -value $cognome_inst;#rom04
    element set_properties $form_name nome_inst             -value $nome_inst;#rom04
    set stato            [string trim [element::get_value $form_name stato]]
    set data_rottamaz    [string trim [element::get_value $form_name data_rottamaz]]
    set data_attivaz     [string trim [element::get_value $form_name data_attivaz]]
    
    set error_num 0

    if {$funzione == "I" ||  $funzione == "M"} {

	if {$nome_inte eq "" && $cognome_inte eq ""} {#sim04 if e suo contenuto
	    set cod_intestatario ""
	}
	
	if {$flag_conferma == "s"} {#rom05 aggiunta if e contenuto
	    if {![string equal $pdr ""]} {
		if {[db_0or1row query "select 1
                                         from coimaimp
                                        where pdr = :pdr
                                          and cod_impianto != :cod_impianto --deve essere un pdr diverso da se stesso
                                        limit 1"] == 1} {
		    element::set_error $form_name pdr "Attenzione esiste a catasto un impianto con lo stesso PDR.<br>Confermi la modifica?"
		    if {$error_num == 0} {
			#mat00 13/10/2025
			#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
			#element set_properties $form_name flag_conferma -values "n" ;#mat01 cambiato da -value a -values
			element set_properties $form_name flag_conferma -value "n";#mat00
		    }
		    incr error_num
		    if {[string equal $pod ""]} {
			if {[db_0or1row q "select 1
                                             from coimcomb
                                            where tipo = 'G'
                                              and cod_combustibile = :cod_combustibile"] == 1} {
			    element::set_error $form_name pod "Inserire POD"
			    incr error_num
			    #mat00 13/10/2025
			    #modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
			    #element set_properties $form_name flag_conferma -values "s" ;#mat01 cambiato da -value a -values
			    element set_properties $form_name flag_conferma -value "s";#mat00
			}		    
			if {$flag_tipo_impianto eq "F"} {
			    element::set_error $form_name pod "Inserire POD"
			    incr error_num
			}
		    }
		}
	    }
	    if {![string equal $pod ""]} {
		if {[db_0or1row query "select 1
                                 from coimaimp
                                where pod = :pod
                                  and cod_impianto != :cod_impianto --deve essere un pod diverso da se stesso
                                limit 1"] == 1} {
		    element::set_error $form_name pod "Attenzione esiste a catasto un impianto con lo stesso POD.<br>Confermi la modifica?"
		    if {$error_num == 0} {
			#mat00 13/10/2025
			#modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
			#element set_properties $form_name flag_conferma -values "n" ;#mat01 cambiato da -value a -values
			element set_properties $form_name flag_conferma -value "n";#mat00
		    }
		    incr error_num
		}
	    }
   
	};#rom05

	if {[string equal $pdr ""]} {#rom10 aggiunta if e suo contenuto
	    if {[string equal $cod_combustibile "5"]} {
		element::set_error $form_name pdr "Inserire PDR"
		incr error_num
	    }
	}
	if {[string equal $pod ""]} {#rom10 aggiunta if e suo contenuto
	    if {![db_0or1row q "select 1
                              from coimcomb
                             where tipo = 'G'
                               and cod_combustibile = :cod_combustibile"]} {
		element::set_error $form_name pod "Inserire POD"
		incr error_num
	    }
	    if {$cod_combustibile in [list "4" "21"]} {#rom13 Aggiunta if e suo contenuto
		element::set_error $form_name pod "Inserire POD"
		incr error_num
	    }
	    if {$flag_tipo_impianto eq "F"} {
		element::set_error $form_name pod "Inserire POD"
		incr error_num
	    }
	}
	if {![string equal $pdr ""]} {#rom10 aggiunta if e suo contenuto
	    set pdr [string trim $pdr]
	    if {[string length $pdr] != 14} {
		element::set_error $form_name pdr "PDR deve essere di 14 caratteri"
		incr error_num
	    }
	}
	if {![string equal $pod ""]} {#rom10 aggiunta if e suo contenuto
	    set pod [string trim $pod]
	    if {[string length $pod] < 14 || [string length $pod] > 15 } {
		element::set_error $form_name pod "POD deve essere di 14 o 15 caratteri"
		incr error_num
	    }
	}

	
	if {[string equal $volimetria_risc ""]} {
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
        }

	if {[string equal $volimetria_raff ""]} {
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
        }

	#rom19 Tolta condizione && $flag_tipo_impianto ne "F"
	if {$cod_tpim == ""} {#rom05 aggiunta condizione sul tipo impianto
	    element::set_error $form_name cod_tpim "Inserire tipologia impianto"
	    #mat00 13/10/2025
	    #modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
	    #element set_properties $form_name flag_conferma -values "s" ;#mat01 cambiato da -value a -values
	    element set_properties $form_name flag_conferma -value "s";#mat00
	    incr error_num
	} else {#rom19 Aggiunta else e il suo contenuto
	    if {[db_0or1row q "select 1
                                 from coimaimp
                                where targa         = :targa
                                  and cod_impianto != :cod_impianto
                                  and cod_tpim     != :cod_tpim
                                  and stato         = 'A'
                                limit 1"]
	    && $flag_conferma == "s"} {
		element::set_error $form_name cod_tpim "La scelta fatta non &egrave; coerente con quanto indicati negli altri impianti collegati.<br>Confermi la scelta?"
		if {$error_num == 0} {
		    #mat00 13/10/2025
		    #modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
		    #element set_properties $form_name flag_conferma -values "n" ;#mat01 cambiato da -value a -values
		    element set_properties $form_name flag_conferma -value "n";#mat00
		}
		incr error_num
	    }
	}

	#rom19 Tolta condizione && $flag_tipo_impianto ne "F"
	if {$unita_immobiliari_servite == ""} {#rom05 aggiunta condizione sul tipo impianto
	    element::set_error $form_name unita_immobiliari_servite "Inserire Unità Immobiliari Servite"
	    #mat00 13/10/2025
	    #modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
	    #element set_properties $form_name flag_conferma -values "s" ;#mat01 cambiato da -value a -values
	    element set_properties $form_name flag_conferma -value "s";#mat00
	    incr error_num
        } else {#rom19 Aggiunta else e il suo contenuto
	    if {[db_0or1row q "select 1
                                 from coimaimp
                                where targa                      = :targa
                                  and cod_impianto              != :cod_impianto
                                  and unita_immobiliari_servite != :unita_immobiliari_servite
                                  and stato                      = 'A'
                                limit 1"]
	    && $flag_conferma == "s"} {
		element::set_error $form_name unita_immobiliari_servite "La scelta fatta non &egrave; coerente con quanto indicati negli altri impianti collegati.<br>Confermi la scelta?"
		if {$error_num == 0} {
		    #mat00 13/10/2025
		    #modifiche fatte perchè il curmit ha la vecchia versione di openacs. Il programma non sarà committato ma portato su a mano.
		    #element set_properties $form_name flag_conferma -values "n" ;#mat01 cambiato da -value a -values
		    element set_properties $form_name flag_conferma -value "n"
		}
		incr error_num
	    }	    
	}

	set indirizzo "";#sim02
	set comune    "";#sim02
	set provincia "";#sim02
	set cap       "";#sim02
	set telefono  "";#sim02
	set cellulare "";#sim02
	set fax       "";#sim02
	set email     "";#sim02
	set pec       "";#sim02
#sim03	db_0or1row q "select * from coimcitt where cod_cittadino = :cod_cittadino"
	db_0or1row q "select * from coimcitt where cod_cittadino = :cod_responsabile";#sim03
	set msg_error ""
	
	if {$indirizzo == ""} {
	    append msg_error "Compilare campo Indirizzo nell'anagrafica del soggetto<br>"
	    incr error_num
        }

	if {$comune == ""} {
            append msg_error "Compilare campo Comune nell'anagrafica del soggetto<br>"
            incr error_num
        }

	if {$provincia == ""} {
            append msg_error "Compilare campo Provincia nell'anagrafica del soggetto<br>"
            incr error_num
        }

	if {$cap == ""} {
            append msg_error "Compilare campo C.A.P. nell'anagrafica del soggetto<br>"
            incr error_num
        }
	
	if {$telefono == "" && $cellulare == "" && $fax == "" && $email == "" && $pec == ""} {

            append msg_error "Compilare almeno un campo dei  seguenti campi:  Telefono, Cellulare, Fax, Email, Pec nell'anagrafica del soggetto responsabile<br>"
            incr error_num
        }
	
	#sim01 if {$potenza_utile > 232  && $nome_condu == "" && $cognome_condu == ""} {
	#sim01     element::set_error $form_name cognome_condu "Inserire dati Conduttore: l'impianto ha potenza nominale utile > 232 kW $potenza_utile"
	#sim01     incr error_num
        #sim01 }

        if {![string equal $data_rottamaz ""]} {
            set data_rottamaz [iter_check_date $data_rottamaz]
            if {$data_rottamaz == 0} {
                element::set_error $form_name data_rottamaz "Data rottamazione deve essere una data"
                incr error_num
            } else {
		if {$data_rottamaz > $current_date} {
		    element::set_error $form_name data_rottamaz "Data deve essere anteriore alla data odierna"
		    incr error_num 
		}

		if {[string equal $stato "A"]} {#rom16 Aggiunte if, elseif, else e il loro conteunto
		    element::set_error $form_name data_rottamaz "Non &egrave; possibile riattivare l'impianto se non si cancella la data di dismissione/disattivazione."
		    incr error_num
		} elseif {![string equal $stato "N"]} {		    
		    set stato "R"
		} else {
		    
		}
	    }
	    #rom16set stato "R"
        }
	
        if {![string equal $data_attivaz ""]} {
            set data_attivaz [iter_check_date $data_attivaz]
            if {$data_attivaz == 0} {
                element::set_error $form_name data_attivaz "Data attivazione deve essere una data"
                incr error_num
            } else {
		if {$data_attivaz > $current_date} {
		    element::set_error $form_name data_attivaz "Data deve essere anteriore alla data odierna"
		    incr error_num
		}
	    }
        }


    }

    # se sono in assegnazione dell'impianto (funzione per manutentori) 
    # aggiorno il manutentore e aggiorno lo storico dei soggetti
    #sim02 aggiunto condizione su stato impianto
    #rom16 Se sto riattivando l'impianto non posso avere la data_rottamaz valorizzata.
    
    if {[db_0or1row q "select 1
                         from coimaimp
                        where cod_impianto = :cod_impianto
                          and stato != :stato
                          and :stato = 'A'"] && [string equal $cod_manutentore ""]
	&& [string equal $data_rottamaz ""]} {#rom11 aggiunta if e suo contenuto
	#Se sto riattivando l'impianto e sono l'ente devo evitare i controlli.
	set error_num 0
    }

    if {$error_num > 0  && !($stato ne "A" && [string equal $cod_manutentore ""])} {
	element::set_error $form_name cognome $msg_error
	#[template::form::get_errors $form_name]
	ad_return_template
	
	return
    }

    if {$flag_tipo_impianto eq "F"} {
	set volimetria_upd "volimetria_raff   = $volimetria_raff"
    } else {
	set volimetria_upd "volimetria_risc   = $volimetria_risc"
    }
    
    switch $funzione {
	M {
	    set dml_sql  [db_map upd_aimp]
	    set dml_sql1 [db_map upd_citt]

	    #rom16 Ora uso gia' la variabile stato_db come campo hidden della form
	    #rom16 quindi e' inutile rileggerselo anche qua.
	    #rom16db_1row q "select stato as stato_db
            #rom16      from coimaimp 
            #rom16      where cod_impianto = :cod_impianto";#rom15
	    
	    if {$stato_db eq "A" && !($stato in [list "A" "F" "D"]) } {#rom15 Aggiunta if e il suo contenuto
		# Se l'impianto va in uno stato diverso da attivo, tutti i generatori vengono
		# resi non attivi (tranne lo stato "Da Validare" e "Da Accatastare").

		if {![string is space $data_rottamaz]} {#rom16 Aggiunte if, else e loro contenuto
		    # Se sto disattivando l'impianto e indico la data anche il/i generatore/i
		    # da disattivare deve/devono avere la medesima data di disattivazione.
		    set data_rottamaz_gen $data_rottamaz
		} else {
		    # Altrimenti metto la data di oggi come data di disattivazione dei generatori.1
		    set data_rottamaz_gen $current_date
		}
		
		set dml_gend [db_map dis_gen]
	    }

	    if {$stato_db eq "N" && $stato eq "A"} {#rom15 Aggiunta if e il suo contenuto
		# Se l'impianto da Non Attivo viene riattivato, tutti
		# i generatori vengono riattivati (esclusi quelli sostituiti).
		set dml_gend [db_map att_gen]
	    }
	}
        D {set dml_sql  [db_map del_aimp]}
    }
    
    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
        with_catch error_msg {
            db_transaction {
                db_dml dml_coimaimp $dml_sql
		db_dml dml_coimaimp $dml_sql1
                if {[info exists dml_gend]} {
		    #rom15db_dml dml_coimaimp $dml_gend

		    db_dml dml_coimgend $dml_gend;#rom15
		}
                if {[info exists dml_comu]} {
		    db_dml dml_coimcomu $dml_comu
		}
                if {[info exists dml_inco]} {
		    db_dml dml_coiminco $dml_inco
		}
            }
        } {
            iter_return_complaint "Spiacente, ma il DBMS ha restituito il
            seguente messaggio di errore <br><b>$error_msg</b><br>
            Contattare amministratore di sistema e comunicare il messaggio
            d'errore. Grazie."
 	}
    }
    
    set link_gest [export_url_vars cod_impianto last_cod_impianto nome_funz nome_funz_caller extra_par url_list_aimp url_aimp caller]
    
    if {$nome_funz_caller != [iter_get_nomefunz coimaimp-isrt-veloce]} {
	set link_del $url_list_aimp
    } else {
        set link_del "coimaimp-isrt-veloce?nome_funz=$nome_funz_caller"
    }
    
    switch $funzione {
        M {set return_url   "coimaimp-bis-gest?funzione=V&$link_gest"}
        D {set return_url   $link_del}
        I {set return_url   "coimaimp-bis-gest?funzione=V&$link_gest"}
        V {set return_url   $url_list_aimp}
    }
    ad_returnredirect $return_url
    ad_script_abort
}
    set return_url_richiamata "coimaimp-bis-gest"

ad_return_template
