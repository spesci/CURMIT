ad_page_contract {
    Pagina di spiegazione per effettuare il login su Regione Friuli Venezia Giulia tramite SPID

    @author Simone Pesci

    @date   
    @cvs_id spid-login2.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================

} {
    {COD_ERRORE   ""}
    {USERNAME     ""}
    {COD_DOMINIO  ""}
    {COD_APPLICAZIONE ""}
    {PERMIT       ""}
    {SAMLResponse ""}
    {TOKEN        ""}
}


set ls_token [list $USERNAME $COD_DOMINIO $COD_APPLICAZIONE $SAMLResponse]

ns_log notice "spid-login2.tcl $USERNAME $COD_DOMINIO $COD_APPLICAZIONE"

#richiamo la decodifica per verificare che il token ricevuto sia corretto

set verifica_response [iter::call_decodifica_asserzioni_spid $ls_token]

util_unlist $verifica_response esito codice_fiscale error_message

if {$esito == false} {
    
    ns_log notice "spid-login2.tcl login non effettuato in quanto abbiamo ricevuto dal ws di verifica i seguenti dati: esito=$esito cf=$codice_fiscale errore=$error_message"

    set url           [export_vars -base "/iter/index"]
    ad_returnredirect $url
    ad_script_abort

} else {
    
    ns_log Notice    "spid-login;inizio"
    
    #ISTRUZIONI PER TESTARE spid-login-2.tcl DA TOGLIERE
    #set token "FRRSDR56M12E897Q";#test Luca R.
    #set token "BZODVD89D28L483N";#caso di CF con più operatori cod_opma MA00001006 MA00006808 MA00011606 MA00054209 MA00022610
    #set token "BZODVD89D28L483N---";#caso di CF inesistente
    #set token "VRCSFN74A16L483T";#caso di CF con un singolo operatore cod_opma MA00012001
    #set token "RMTLCU98P10E897X";#caso di CF amministratore
    
    #salvo il cf passato dallo spid nelle mie variabili di sessione
    ad_set_cookie -replace t -path / iter_login_spid_cf_[ns_conn location] $codice_fiscale
    
    #verifico quanti utenti ho con quel codice fiscale

    set ls_opma [db_list_of_lists q "select u.id_utente 
                                          , u.rows_per_page 
                                       from coimuten u
                                  left join coimopma o
                                         on o.cod_opma = u.id_utente
                                      where coalesce(o.codice_fiscale,u.codice_fiscale) = :codice_fiscale"]

    if {[llength $ls_opma] == 0} {
	
	iter_return_complaint "Non è stato trovato nessun utente associato al tuo codice fiscale. Contattare l'assistenza"
	
    }
    
    if {[llength $ls_opma] >1} {
	
	set return_url "spid-login-chose-uten"
	
	ad_returnredirect $return_url
    }

    if {[llength $ls_opma] == 1} {
	
	foreach opma $ls_opma {
	    util_unlist $opma id_utente rows_per_page
	}
	
	ad_set_client_property iter logged_user_id $id_utente
	set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
	set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
	set session_id [ad_conn session_id]
	set adsession [ad_get_cookie "ad_session_id"]
	
	# crea cookie utenti e permessi
	ad_set_cookie -replace t -path / iter_login_[ns_conn location] $id_utente
	ad_set_cookie -replace t -path / iter_rows_[ns_conn location] $rows_per_page
	
	# Creo un log degli utenti che si sono loggati
	ns_log Notice "********-AUTH-CHECK-LOGIN-ENTER        ;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;loggato nel sistema;$adsession;"
	ad_returnredirect main   
	
    }
    
    ad_script_abort
    
}
