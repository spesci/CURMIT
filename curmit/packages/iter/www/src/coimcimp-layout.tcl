ad_page_contract {
    Stampa Rapporto di verifica
    
    @author        Paolo Formizzi Adhoc
    @creation-date 05/05/2004

    @cvs-id coimcimp-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mic01 20/05/2022 Aggiunta if e redirect per il tracciato AC
    
    rom02 18/02/2022 Gestito il nuovo rapporto di ispezione FR per gli impianti del freddo
    rom02            richiesto da Regione Marche.

    rom01 04/02/2021 Corretto errore presente quando si settava la directory presonalizzata
    rom01            per la stampa dei Comuni con lo spazio nel nome Es: CIVITANOVA MARCHE.

    san01 12/08/2016 Gestito il nuovo rapporto di ispezione RE usato solo da A.F.E.

    sim01 15/04/2015 Gestito il nuovo rapporto di ispezione RI

} {
    {cod_cimp         ""}
    {funzione        "V"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {flag_ins        "S"}
    {flag_tracciato   ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]

set pack_key [iter_package_key]
set pack_dir [apm_package_url_from_key $pack_key]

switch $flag_ente {
    "P" {set directory "srcpers/$flag_ente$sigla_prov"}
    "C" {
	regsub -all " " $denom_comune "" denom_comune;#rom01
	set directory "srcpers/$flag_ente$denom_comune"}
    default {set "standard"}
}

if {[db_0or1row sel_flag_tracciato_cimp ""] == 0} {
    iter_return_complaint "Rapporto di ispezione non trovato"
    return
}

if {$flag_tracciato == "AC"} {#mic01 aggiunta if e suo contenuto
    set directory "src"
}

#sim01 Aggiunto RI
#rom01 aggiunto redirect per il tracciato FR
#mic01 aggiunto redirect per il tracciato AC
switch $flag_tracciato {
    "AA" {set return_url $pack_dir/$directory/coimcimp-a-layout?$link}
    "AB" {set return_url $pack_dir/$directory/coimcimp-b-layout?$link}
    "RI" {set return_url $pack_dir/$directory/coimcimp-ri-layout?$link}
    "RE" {set return_url $pack_dir/$directory/coimcimp-re-layout?$link}
    "FR" {set return_url $pack_dir/$directory/coimcimp-fr-layout?$link}
    "AC" {set return_url $pack_dir/$directory/coimcimp-ac-layout?$link}
 default {set return_url $pack_dir/$directory/coimcimp-a-layout?$link}
}



ad_returnredirect $return_url


