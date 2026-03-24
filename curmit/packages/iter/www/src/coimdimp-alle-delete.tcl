ad_page_contract {
    cancella allegato

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 19/12/2023 Sistemato redirect con relativo messaggio.

} {
    tabella
    cod_dimp:integer
}


set dir      "[iter_set_spool_dir]/allegati"
set dir_canc "[iter_set_spool_dir]/allegaticancellati"
set link         [export_ns_set_vars "url"];#rom01

if {[db_0or1row sel_allv "select * from coimallegati where codice = :cod_dimp and tabella = :tabella"] == 0} {
    iter_return_complaint "Non risulta alcun documento scansionato allegato."
} else {
    set file_name $dir/$tabella$cod_dimp
    set file_name_canc $dir_canc/$tabella$cod_dimp

    db_dml query "delete from coimallegati where codice = :cod_dimp and tabella = :tabella"
#    file rename  $file_name $file_name_canc
    ns_rename  $file_name $file_name_canc
    #rom01ns_return 200 text/html "Allegato cancellato"
     set return_url "coimdimp-list?$link";#rom01
    ad_returnredirect -message "Allegato cancellato correttamente" $return_url;#rom01
}

ad_return_template


