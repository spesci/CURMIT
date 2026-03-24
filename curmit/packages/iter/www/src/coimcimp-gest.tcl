ad_page_contract {
    Add/Edit/Delete  form per la tabella "coimcimp"
    @author          Adhoc
    @creation-date   03/05/2004

    @param funzione  I=insert M=edit D=delete V=view
    @param caller    caller della lista da restituire alla lista:
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
                     serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
                     navigazione con navigation bar
    @param extra_par Variabili extra da restituire alla lista
    @cvs-id          coimcimp-gest.tcl

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    mic01 18/05/2022 Aggiunte condizioni e redirect per il tracciato AC
    
    rom01 03/02/2022 Gestito il nuovo rapporto di ispezione FR per gli impianti del freddo
    rom01            richiesto da Regione Marche.

    san01 12/08/2016 Gestito il nuovo rapporto di ispezione RE usato solo da A.F.E.

    sim01 15/04/2015 Gestito il nuovo rapporto di ispezione RI

} {
    
   {cod_cimp         ""}
   {last_cod_cimp    ""}
   {funzione        "V"}
   {caller      "index"}
   {nome_funz        ""}
   {nome_funz_caller ""}
   {extra_par        ""}
   {cod_impianto     ""}
   {url_aimp         ""} 
   {url_list_aimp    ""}
   {gen_prog         ""}
   {flag_cimp        ""}
   {extra_par_inco   ""}
   {cod_inco         ""}
   {flag_inco        ""}
   {flag_tracciato   ""}

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


iter_get_coimtgen
set flag_ente    $coimtgen(flag_ente)
set denom_comune $coimtgen(denom_comune)
set sigla_prov   $coimtgen(sigla_prov)
set link         [export_ns_set_vars "url"]

set pack_key [iter_package_key]
set pack_dir [apm_package_url_from_key $pack_key]

switch $flag_ente {
    "P" {set directory "$flag_ente$sigla_prov"}
    "C" {
	regsub -all " " $denom_comune "" denom_comune
	set directory "$flag_ente$denom_comune"
    }
    default {set directory "standard"}
}

if {$funzione == "I"} {
    if {$flag_tracciato == "AC"} {#mic01 aggiunta if per il tracciato AC e suo contenuto
	append pack_dir "src"
	set directory   ""
    } else {#mic01 Aggiunta else ma non il contenuto
	if {$flag_tracciato != "MA"} {
	    append pack_dir "srcpers"
	} else {
	    append pack_dir "src"
	    set directory   ""
	}
    };#mic01

    #rom01 Aggiunta condizione flag_tracciato != "FR"
    #mic01 aggiunta if per il tracciato AC
    if {$flag_tracciato != "MA" && $flag_tracciato != "RI" && $flag_tracciato != "RE" && $flag_tracciato != "FR" && $flag_tracciato != "AC"} {#sim01
	db_1row sel_aimp_pote ""
	if {$potenza >=  35} {
	    # Allegato B
	    set flag_tracciato "AB"
	} else {
	    # Allegato A
	    set flag_tracciato "AA"
	}
    }

    set link         [export_ns_set_vars "url" "flag_tracciato"]
    append link "&flag_tracciato=$flag_tracciato"
    #sim01 aggiunto redirect per il tracciato RI
    #rom01 aggiunto redirect per il tracciato FR
    #mic01 aggiunto redirect per il tracciato AC
    switch $flag_tracciato {
	"MA" {set return_url $pack_dir/$directory/coimcimp-manc-gest?$link}
        "AA" {set return_url $pack_dir/$directory/coimcimp-a-gest?$link}
	"AB" {set return_url $pack_dir/$directory/coimcimp-b-gest?$link}
	"RI" {set return_url $pack_dir/$directory/coimcimp-ri-gest?$link}
        "RE" {set return_url $pack_dir/$directory/coimcimp-re-gest?$link}
	"FR" {set return_url $pack_dir/$directory/coimcimp-fr-gest?$link}
	"AC" {set return_url $pack_dir/$directory/coimcimp-ac-gest?$link} 
	default {set return_url $pack_dir/$directory/coimcimp-a-gest?$link}
    }

} else {

    if {[db_0or1row sel_cimp_flag_tracciato ""] == 0} {
	iter_return_complaint "Rapporto di ispezione non trovato"
        return
    }
    if {$flag_tracciato == "AC"} {#mic01 aggiunta if per il tracciato AC e suo contenuto

	append pack_dir "src"
	set directory   ""
    } else {#mic01 Aggiunta else ma non il suo contenuto
	if {$flag_tracciato != "MA"} {
	    append pack_dir "srcpers"
	} else {
	    append pack_dir "src"
	    set directory   ""
	}
    };#mic01

    #sim01 aggiunto redirect per il tracciato RI
    #rom01 aggiunto redirect per il tracciato FR
    #mic01 aggiunto redirect per il tracciato AC
    switch $flag_tracciato {
	"AA" {set return_url $pack_dir/$directory/coimcimp-a-gest?$link}
	"AB" {set return_url $pack_dir/$directory/coimcimp-b-gest?$link}
	"MA" {set return_url $pack_dir/$directory/coimcimp-manc-gest?$link}
	"RI" {set return_url $pack_dir/$directory/coimcimp-ri-gest?$link}
        "RE" {set return_url $pack_dir/$directory/coimcimp-re-gest?$link}
	"FR" {set return_url $pack_dir/$directory/coimcimp-fr-gest?$link}
	"AC" {set return_url $pack_dir/$directory/coimcimp-ac-gest?$link}
     default {set return_url $pack_dir/$directory/coimcimp-a-gest?$link}
    }
}

ad_returnredirect $return_url
ad_script_abort
