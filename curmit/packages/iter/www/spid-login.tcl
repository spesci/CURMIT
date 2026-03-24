ad_page_contract {

    Pagina di spiegazione per effettuare il login tramite SPID

    @author Simone Pesci

    @date   
    @cvs_id spid-login.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==============================================================================
    rom01 26/05/2022 Ucit ha modificato l'url verso il Service Provider per il login tramite SPID.

} {
}

ns_log Notice    "spid-login;inizio"

iter_get_coimtgen

if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {    

    set service_name [iter::get_service_name_spid]
    
    # come end_point tengo sempre l'ambiente di produzione perchè Luca Svetina mi ha detto che lo SPID non ha un ambiente di 
    # test quindi tanto vale chiamare sempre l'indirizzo di produzione
    #rom01set return_url "https://loginfvg.regione.fvg.it/loginfvg/fvgaccountIdp/ServiceProviderSpid2.jsp?ServiceName=$service_name"
    set return_url "https://loginfvg.regione.fvg.it/loginfvg/fvgaccountIdp/ServiceProviderSpid.jsp?ServiceName=$service_name";#rom01
}

#set return_url "spid-login2";#solo per test
    
ad_returnredirect -allow_complete_url $return_url
ad_script_abort

