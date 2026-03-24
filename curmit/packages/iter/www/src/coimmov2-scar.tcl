#www/caldaie/src/
ad_page_contract {
    lista per scarico movimenti

    @author         Giulio Laurenzi
    @creation-date  09/06/2004

    @cvs-id coiminco-scar.tcl

    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
    rom02  13/02/2023 Aggiunti nuovi campi data e numero accertamento su richiesta di Palermo.
    rom02             Estraggo anche il tipo soggetto della sanzione.
    rom02             Sandro ha detto che vanno bene per tutti.

    rom01  09/02/2023 Aggiunti nuovo campi nell'estrazione csv su richiesta di Sandro per Palermo.

    sim01  18/03/2020 Gestito i parametri f_data_compet_da e f_data_compet_a

    san01  30/08/2017 Gestito il nuovo campo data_incasso

} {
    {f_data_pag_da     ""}
    {f_data_pag_a      ""}
    {f_importo_da      ""}
    {f_importo_a       ""}
    {f_data_scad_da    ""}
    {f_data_scad_a     ""}
    {f_data_compet_da  ""}
    {f_data_compet_a   ""}
    {f_data_incasso_da    ""}
    {f_data_incasso_a     ""}
    {f_id_caus         ""}
    {f_tipo_pag        ""}
    {search_word       ""}
    {nome_funz         ""}
}

# Imposto variabili tipiche di ogni funzione
set lvl 1
set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

if {[string equal $search_word ""]} {
    set where_word ""
} else {
    set search_word_1 [iter_search_word $search_word]
    set where_word  " and upper(cod_movi) like upper(:search_word_1)"
}

# imposto filtro per data pagamento
if {![string equal $f_data_pag_da ""] ||  ![string equal $f_data_pag_a ""]} {
    if {[string equal $f_data_pag_da ""]} {
	set f_data_pag_da "18000101"
    }
    if {[string equal $f_data_pag_a ""]} {
	set f_data_pag_a "21001231"
    }
    set where_data_pag "and a.data_pag between :f_data_pag_da and :f_data_pag_a"
} else {
    set where_data_pag ""
}

# imposto filtro per data scadenza
if {![string equal $f_data_scad_da ""] || ![string equal $f_data_scad_a ""]} {
    if {[string equal $f_data_scad_da ""]} {
	set f_data_scad_da "18000101"
    }
    if {[string equal $f_data_scad_a ""]} {
	set f_data_scad_a "21001231"
    }
    set where_data_scad "and a.data_scad between :f_data_scad_da and :f_data_scad_a"
} else {
    set where_data_scad ""
}

# imposto filtro per data incasso
if {![string equal $f_data_incasso_da ""]
    ||  ![string equal $f_data_incasso_a ""]
} {#san01 if else e loro contenuto
    if {[string equal $f_data_incasso_da ""]} {
	set f_data_compet_da "18000101"
    }
    if {[string equal $f_data_incasso_a ""]} {
	set f_data_incasso_a "21001231"
    }
    set where_data_incasso "and a.data_incasso between :f_data_incasso_da and :f_data_incasso_a"
} else {
    set where_data_incasso ""
}

#sim01 imposto il filtro sulla data competenza
if {![string equal $f_data_compet_da ""]
    ||  ![string equal $f_data_compet_a ""]
} {#sim01 if else e loro contenuto
    if {[string equal $f_data_compet_da ""]} {
	set f_data_compet_da "18000101"
    }
    if {[string equal $f_data_compet_a ""]} {
	set f_data_compet_a "21001231"
    }
    set where_data_compet "and a.data_compet between :f_data_compet_da and :f_data_compet_a"
} else {
    set where_data_compet ""
}


# imposto filtro per importo
if {![string equal $f_importo_da ""] || ![string equal $f_importo_a ""]} {
    if {[string equal $f_importo_da ""]} {
	set f_importo_da "0"
    }
    if {[string equal $f_importo_a ""]} {
	set f_importo_a "9999999999"
    }
    set where_importo "and a.importo between :f_importo_da and :f_importo_a"
} else {
    set where_importo ""
}

if {![string equal $f_tipo_pag ""]} {
    set where_tipo_pag "and a.tipo_pag = :f_tipo_pag"
} else {
    set where_tipo_pag ""
}

if {![string equal $f_id_caus ""]} {
    set where_id_caus "and a.id_caus = :f_id_caus"
} else {
    set where_id_caus ""
}

set filout [open [iter_set_spool_dir]/estrazione-movimenti.csv w]

#san01 puts $filout "Cod. Movimento;Causale Pagamento;Codice Impianto;Import;Importo Pagato;Data;Data Scadenza;Data Pagamento;Tipo Pagamento;Note;Pagato;Cognome;Nome;Indirizzo;Cap;Comune"

#rom01puts $filout "Cod. Movimento;Causale Pagamento;Codice Impianto;Import;Importo Pagato;Data;Data Scadenza;Data Pagamento;Data Incasso;Tipo Pagamento;Note;Pagato;Cognome;Nome;Indirizzo;Cap;Comune";#san01
#rom02puts $filout "Cod. Movimento;Causale Pagamento;Codice Impianto;Import;Importo Pagato;Data;Data Scadenza;Data Pagamento;Data Incasso;Tipo Pagamento;Note;Pagato;Sanzione;Importo minimo;Importo massimo;Cognome responsabile;Nome responsabile;Indirizzo responsabile;Cap responsabile;Comune responsabile;Cod.fisc. responsabile;Cognome manutentore;Nome manutentore;Indirizzo manutentore;Cap manutentore;Comune manutentore;P.IVA manutentore;Data ispezione;Num. verbale";#rom01
puts $filout "Cod. Movimento;Causale Pagamento;Codice Impianto;Import;Importo Pagato;Data;Data Scadenza;Data Pagamento;Data Incasso;Tipo Pagamento;Note;Pagato;Sanzione;Soggetto;Importo minimo;Importo massimo;Cognome responsabile;Nome responsabile;Indirizzo responsabile;Cap responsabile;Comune responsabile;Cod.fisc. responsabile;Cognome manutentore;Nome manutentore;Indirizzo manutentore;Cap manutentore;Comune manutentore;P.IVA manutentore;Data ispezione;Num. verbale;Data accertamento;Numero accertamento";#rom02

set lista_cod ""
db_foreach sel_movi "" {

    regsub -all \n $nota " " nota
    regsub -all \r $nota " " nota

    #san01 puts $filout "$cod_movi;$desc_movi;$cod_impianto_est;$importo_edit;$importo_pag_edit;$data_compet;$data_scad;$data_pag;$desc_pag;$nota;$flag_pagato;$cognome;$nome;$indirizzo;$cap;$comune"

    #rom01puts $filout "$cod_movi;$desc_movi;$cod_impianto_est;$importo_edit;$importo_pag_edit;$data_compet;$data_scad;$data_pag;$data_incasso;$desc_pag;$nota;$flag_pagato;$cognome;$nome;$indirizzo;$cap;$comune";#san01
    #rom02puts $filout "$cod_movi;$desc_movi;$cod_impianto_est;$importo_edit;$importo_pag_edit;$data_compet;$data_scad;$data_pag;$data_incasso;$desc_pag;$nota;$flag_pagato;$sanzione;$importo_min;$importo_max;$cognome;$nome;$indirizzo;$cap;$comune;$codice_fiscale;$cognome_manu;$nome_manu;$indirizzo_manu;$cap_manu;$comune_manu;$codice_piva_manu;$last_data_controllo_ispe;$last_verb_n_ispe";#rom01
    puts $filout "$cod_movi;$desc_movi;$cod_impianto_est;$importo_edit;$importo_pag_edit;$data_compet;$data_scad;$data_pag;$data_incasso;$desc_pag;$nota;$flag_pagato;$sanzione;$tipo_soggetto_edit;$importo_min;$importo_max;$cognome;$nome;$indirizzo;$cap;$comune;$codice_fiscale;$cognome_manu;$nome_manu;$indirizzo_manu;$cap_manu;$comune_manu;$codice_piva_manu;$last_data_controllo_ispe;$last_verb_n_ispe;$data_accertamento;$numero_accertamento";#rom02
    
}

close $filout
ad_returnredirect [iter_set_spool_dir_url]/estrazione-movimenti.csv
ad_script_abort
