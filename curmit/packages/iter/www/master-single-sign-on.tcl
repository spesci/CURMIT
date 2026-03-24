ad_page_contract {
    Pagina di sfondo.

    @author Nicola Mortoni
    @date   01/10/2003

    @cvs_id master.tcl

    USER  DATA       MODIFICHE
    ===== ========== ========================================================================
    nic02 07/06/2016 Aggiunti nuovi parametri master_ind_email e master_sito_web

    nic01 20/03/2014 Aggiunto utilizzo dei parametri master_ per evitare di modificare questo
    nic01            sorgente sulle varie istanze
} {
}

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

iter_get_coimtgen

set url_chiamante [ns_conn url]
if {$url_chiamante eq "/iter/"
||  $url_chiamante eq "/iter/index"
||  $url_chiamante eq "/iter/utenti/coimcpwd-gest"
||  $url_chiamante eq "/iter/standard-error"
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

db_0or1row q "select flag_single_sign_on
                     from coimtgen";#rom01 

if {$flag_single_sign_on eq "t"} {#rom01 aggiunta if, else e loro contenuto
    set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale -default ""]
    append url_portale "/register";#Sandro ha detto che tutti gli utenti vanno indirizzati alla pagina di log-in del portale
    
    set url_ss "<a href=$url_portale class=\"link-header\"><b><big>Torna al Portale</big></b></a>"
} else {
    set url_ss ""
};#rom01
