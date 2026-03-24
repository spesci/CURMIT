ad_page_contract {
    Login utente
    @author        Luca Romitti
    @creation_date 17/03/2021

    @cvs-id spid-login-chose-uten.tcl

    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================

} {
    radio_button:multiple,optional
} -properties {
    page_title:onevalue
    context_bar:onevalue
}

set codice_fiscale_uten [ad_get_cookie iter_login_spid_cf_[ns_conn location]]

if {$codice_fiscale_uten eq ""} {

    ad_returnredirect "/"
    ad_script_abort

}

set page_title   "Login con SPID"
set context_bar  "&nbsp;"
set mex_error    "&nbsp;"


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "spid_login"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set button_label "Continua"

form create $form_name \
-html    $onsubmit_cmd

element create $form_name submit -widget submit -datatype text -label "$button_label" -html "class form_submit"

# creo i vari elementi per ogni riga ed una struttura multirow
# da utilizzare nell'adp
multirow create utenti radio_butt cod_manutentore denominazione class_multiple

set num_riga 0

db_foreach manu "select coalesce(m.cognome, '')||' '||coalesce(m.nome, '') as denominazione
                      , m.cod_manutentore
                      , o.cod_opma as cod_utente_da_loggare
                      , coalesce(u.cognome, '')||' '||coalesce(u.nome, '') as denominazione_utente
                      , u.id_utente as username
                   from coimuten u
              left join coimopma o
                     on o.cod_opma        = u.id_utente
              left join coimmanu m
                     on o.cod_manutentore = m.cod_manutentore
                  where coalesce(o.codice_fiscale,u.codice_fiscale)  = :codice_fiscale_uten
                    and (m.flag_attivo != 'N' -- La ditta deve essere attiva
                     or  o.stato       != '1' -- L'operatore non deve essere stato disabilitato dalla ditta
                     or  u.livello     != '0' -- L'utente ndeve avere i permessi
                        )
 " {

     if {$cod_manutentore eq ""} {
	 #sono un utente amministratore
	 set cod_manutentore $username
	 set denominazione $denominazione_utente
	 set cod_utente_da_loggare $username
     }

     incr num_riga
     if {$num_riga % 2} {
	 set class_multiple "class=\"odd\" style=\"background-color:#ececec;\""
     } else {
	 set class_multiple "class=\"even\""

     }
     set radio_butt "<input type=radio name=radio_button value=$cod_utente_da_loggare>"
     multirow append utenti $radio_butt $cod_manutentore $denominazione $class_multiple
 }




if {[form is_request $form_name]} {

}

if {[form is_valid $form_name]} {
    set error_num 0

    if {![info exists radio_button]} {
	set mex_error "<font color=red>Si prega di selezionare un utente.</font>"
	incr error_num
    } else {
	
	db_1row q "select u.id_utente
                        , u.rows_per_page
                     from coimuten u
                     left join coimopma o
                      on o.cod_opma       = u.id_utente
                   where coalesce(o.cod_opma,u.id_utente) = :radio_button"
    }
    
    if {$error_num > 0} {
	ad_return_template
        return
    } else {

	ad_set_client_property iter logged_user_id $id_utente
	set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
	set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
	set session_id [ad_conn session_id]
	set adsession [ad_get_cookie "ad_session_id"]
	
	# crea cookie utenti e permessi
	ad_set_cookie -replace t -path / iter_login_[ns_conn location] $id_utente
	ad_set_cookie -replace t -path / iter_rows_[ns_conn location] $rows_per_page
	
	# Creo un log degli utenti che si sono loggati
	ns_log Notice "********spid-login-chose-manu        ;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;loggato nel sistema;$adsession;"
    }
    ad_returnredirect main
    ad_script_abort
}
db_release_unused_handles
ad_return_template



