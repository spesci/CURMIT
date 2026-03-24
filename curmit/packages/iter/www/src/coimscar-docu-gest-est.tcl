ad_page_contract {
    Add/Edit/Delete  statistiche per la tabella "coimaimp"
    @author          Giulio Laurenzi
    @creation-date   31/08/2004

    @param funzione  V=view
    @param caller    caller della lista da restituire alla lista:
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz identifica l'entrata di menu, server per le autorizzazioni
    serve se lista e' uno zoom che permetti aggiungi.
    @param nome_funz_caller identifica l'entrata di menu, serve per la 
    navigazione con navigation bar
    @cvs-id          coimscar-docu-gest-est.tcl

    USER  DATA       MODIFICHE
    ===== ========== ===========================================================================
    rom02 10/10/2024 Aggiunte colonne cod_fiscale e data_nas del soggetto responsabile su richiesta
    rom02            di Palermo Energia.

    rom01 28/09/2022 Aggiunta colonna pec del soggetto responsabile su richiesta di Paravan di Ucit.

} {
    {funzione        "I"}
    {caller      "index"}
    {nome_funz        ""}
    {nome_funz_caller ""}
    {f_data_stampa    ""}
    {f_tipo_documento ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

switch $funzione {
    "V" {set lvl 1}
    "I" {set lvl 2}
}

set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
set link_gest [export_url_vars nome_funz nome_funz_caller f_data_stampa f_tipo_documento caller]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# imposto variabili usate nel programma:
set sysdate_edit [iter_edit_date [iter_set_sysdate]]

# imposto la directory degli permanenti ed il loro nome.
set permanenti_dir     [iter_set_permanenti_dir]
set permanenti_dir_url [iter_set_permanenti_dir_url]

# imposto il nome dei file
set nome_file     "Scarica responsabili documenti"
set nome_file     [iter_temp_file_name -permanenti $nome_file]
set file_csv      "$permanenti_dir/$nome_file.csv"
set file_csv_url  "$permanenti_dir_url/$nome_file.csv"

set file_id       [open $file_csv w]
fconfigure $file_id -encoding iso8859-1

# imposto la prima riga del file csv
set     head_cols ""
lappend head_cols "DENOMINAZIONE"
lappend head_cols "COMPLEMENTO_ALLA_DENOMINAZIONE"
lappend head_cols "DATA NAS";#rom02
lappend head_cols "CODFIS"  ;#rom02
lappend head_cols "INDIRIZZO"
lappend head_cols "CIVICO"
lappend head_cols "INDIRIZZO2"
lappend head_cols "CAP"
lappend head_cols "CITTA"
lappend head_cols "PROVINCIA"
lappend head_cols "PEC";#rom01
lappend head_cols "CONTRID"
lappend head_cols "DTPIAN"
lappend head_cols "ORAPIAN"
lappend head_cols "CONTRTIPO"
lappend head_cols "IMPCOD"
lappend head_cols "IMPCOM"
lappend head_cols "IMPIND"
lappend head_cols "VERCOD"
lappend head_cols "VERNOM"
lappend head_cols "DATA STAMPA"
lappend head_cols "PROTOCOLLO"

# imposto il tracciato record del file csv
set     file_cols ""
lappend file_cols "nom_resp"
lappend file_cols "campo"
lappend file_cols "data_nas_resp";#rom02
lappend file_cols "cod_fiscale_resp";#rom02
lappend file_cols "indiresp"
lappend file_cols "campo"
lappend file_cols "campo"
lappend file_cols "capresp"
lappend file_cols "locaresp"
lappend file_cols "provresp"
lappend file_cols "pec_resp";#rom01
lappend file_cols "cod_inco"
lappend file_cols "data_verifica"
lappend file_cols "ora_verifica"
lappend file_cols "tipo_estrazione"
lappend file_cols "cod_impianto_est"
lappend file_cols "locaimp"
lappend file_cols "indirimp"
lappend file_cols "cod_opve"
lappend file_cols "nome_opve"
lappend file_cols "data_stampa"
lappend file_cols "protocollo_01"

iter_get_coimtgen
set flag_viario      $coimtgen(flag_viario)

if {$flag_viario == "T"} {
    set sel_docu [db_map sel_docu_si_viae]
} else {
    set sel_docu [db_map sel_docu_no_viae]
}

set causale "Verifica impianto termico"
set importo ""
set campo ""

set sw_primo_rec "t"
db_foreach sel_docu $sel_docu {
    # metto l'apice prima del cod impianto in modo che non vengano persi gli 0 con l'excel
    set cod_impianto_est "\'$cod_impianto_est"

    if {$coimtgen(flag_stp_presso_terzo_resp) eq "T"
    &&  $flag_resp                            eq "T"
    } {;#13/11/2013
	# se è attivo l'apposito parametro ed il responsabile è un terzo, devo stampare
	# C/O l'indirizzo del terzo responsabile.
	# Con questa query leggo indirizzo as indiresp, cap as capresp, etc...
	# di coimmanu con cod_legale_rapp = :cod_responsabile
	db_0or1row sel_manu_resp "";#13/11/2013
    };#13/11/2013

    set locaresp [string trim $locaresp]

    set file_col_list ""

    if {$sw_primo_rec == "t"} {
	set sw_primo_rec "f"
	iter_put_csv $file_id head_cols
    }
    set file_col_list ""
    foreach column_name $file_cols {
	lappend file_col_list [set $column_name]
    }
    iter_put_csv $file_id file_col_list

} if_no_rows {
    set msg_err      "Nessun impianto attivo presente in archivio"
    set msg_err_list [list $msg_err]
    iter_put_csv $file_id msg_err_list
}

ad_returnredirect $file_csv_url
ad_script_abort
