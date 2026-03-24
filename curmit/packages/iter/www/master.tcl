ad_page_contract {
    Pagina di sfondo.

    @author Nicola Mortoni
    @date   01/10/2003

    @cvs_id master.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================
    rom04 15/11/2023 Aggiunta proc per mostrare gli alert-messagge

    gac01 15/02/2023 Palermo non deve vedere il cambia ente ma solo il link per tornare al portale.

    rom03 18/03/2021 Se la url_chiamante e' spid-login-chose-uten allora non devo far vedere
    rom03            il menu' e devo saltare il cotrollo del login. Leggo i dati della coimtgen
    rom03            per vedere o meno il link per cambiare l'utente del login.
    rom03            In base al parametro dello spid vado a settarmi l'url per il logout che
    rom03            richiamo nell'adp. Modifica copiata da vecchio cvs per allineamento ucit al nuovo.
    
    rom02 15/10/2018 Aggiunto link "Torna al Portale" su richiesta della Regione Marche.
    rom02            Sandro ha detto di metterlo di fianco al link "Cambia Ente".

    rom01 14/09/2018 Aggiunta proc iter_get_coimtgen; Aggiunto link "Cambia Ente"

    nic02 07/06/2016 Aggiunti nuovi parametri master_ind_email e master_sito_web

    nic01 20/03/2014 Aggiunto utilizzo dei parametri master_ per evitare di modificare questo
    nic01            sorgente sulle varie istanze
} {
}

iter_get_coimtgen;#rom01
set db_name    [db_get_database];#gac01

# posso valorizzare eventuali variabili tcl a disposizione del master
set logo_url [iter_set_logo_dir_url]
set css_url  [iter_set_css_dir_url]
set funz_pwd [iter_get_nomefunz coimcpwd-gest]
set funz_log_out [iter_get_nomefunz logout]
if {![info exists htmlarea]} {
    set htmlarea "f"
}

set master_logo_sx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default "oasi.gif"];#nic01
set master_logo_sx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"];#nic01
set master_logo_sx_titolo_sopra [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sopra];#nic01
set master_logo_sx_titolo_sotto [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sotto];#nic01

set master_logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome   -default "oasi.gif"];#nic01
set master_logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_height -default "32"];#nic01
set master_logo_dx_titolo_sopra [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_titolo_sopra];#nic01
set master_logo_dx_titolo_sotto [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_titolo_sotto];#nic01

set master_ind_email            [parameter::get_from_package_key -package_key iter -parameter master_ind_email];#nic02
set master_sito_web             [parameter::get_from_package_key -package_key iter -parameter master_sito_web];#nic02

#
#rom04 Aggiunto User messages
#
util_get_user_messages -multirow user_messages


set url_chiamante [ns_conn url]

#rom03 Aggiunta condizione su /iter/spid-login-chose-uten
if {$url_chiamante eq "/iter/"
||  $url_chiamante eq "/iter/index"
||  $url_chiamante eq "/iter/utenti/coimcpwd-gest"
||  $url_chiamante eq "/iter/standard-error"
||  $url_chiamante eq "/iter/spid-login-chose-uten"
} {
    #in questo caso non posso trovare l'utente e non devo far vedere i menu
    set yui_menu_p          ""
    set flag_alto_contrasto ""
} else {
    set id_utente [iter_get_id_utente]
    if {$id_utente == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
    }

    if {![db_0or1row query "select flag_menu_yui as yui_menu_p
                                 , flag_alto_contrasto
                              from coimuten
                             where id_utente = :id_utente"]
    } {
	set login [ad_conn package_url]
        iter_return_complaint "Utente $id_utente non trovato. Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
    }
}

# imposto menu YUI
set company_menu dynamic-menu

set body(id)    yahoo-com
set body(class) yui-skin-sam

#rom01 
db_0or1row q "select flag_single_sign_on
                     from coimtgen"

if {$flag_single_sign_on eq "t"} {#rom01 aggiunta if, else e loro contenuto
    set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale -default ""];#rom02
    append url_portale "/register";#rom02 Sandro ha detto che tutti gli utenti vanno indirizzati alla pagina di log-in del portale
#rom02    set url_ss "<a href=$css_url/single-sign-on?caller=index><b><big>Cambia ente</big></b></a>"
    if {$db_name eq "iterprpa"} {#gac01 Aggiunta if e il suo contenuto
        set url_ss "<a href=$url_portale><b><big>Torna al Portale</big></b></a><b><big>"
    } else {#gac01 Aggiunta else ma non il suo contenuto
	set url_ss "<a href=$url_portale><b><big>Torna al Portale</big></b></a><b><big> / </big></b><a href=$css_url/single-sign-on?caller=index><b><big>Cambia ente</big></b></a>";#rom02
    }

} else {
    set url_ss ""
};#rom01


set logout_url "$css_url/logout?nome_funz=$funz_log_out";#rom03

set url_spid "";#rom03
set visualizza_cambio_psw 1;#rom03
if {$coimtgen(login_spid_p)} {#rom03 aggiunta if e contenuto 
    
    if {!($url_chiamante in [list "/iter/" \
				 "/iter/index" \
				 "/iter/utenti/coimcpwd-gest" \
				 "/iter/standard-error" \
				 "/iter/spid-login-chose-uten"])} {
	
	set codice_fiscale [ad_get_cookie iter_login_spid_cf_[ns_conn location]]
	if {[db_0or1row q "select count(*) 
                             from coimuten u
                        left join coimopma o on  o.cod_opma                   = u.id_utente
                            where coalesce(o.codice_fiscale,u.codice_fiscale) = :codice_fiscale
                           having count(*) > 1"]} {
	    
	    #il cambia utente si vede solo se ho più utenti con lo stesso codice fiscale.
	    set url_spid "<b><big> / </big></b><a href=/iter/spid-login-chose-uten><b><big>Cambia Utente</big></b></a>"
	}
    }
    
    if {$coimtgen(regione) eq "FRIULI-VENEZIA GIULIA"} {
	
	set service_name [iter::get_service_name_spid]
	
	if {![string equal [ad_get_cookie iter_login_spid_cf_[ns_conn location]] ""]} {
	    set visualizza_cambio_psw 0;#rom03
	    set logout_url "https://loginfvg.regione.fvg.it/loginfvg/fvgaccountIdp/ServiceProviderLogoutSpid.jsp?ServiceName=$service_name&RESET_IDP_CALLBACK"

	}
    }

};#rom03

