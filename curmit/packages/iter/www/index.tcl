ad_page_contract {
    Login utente
    @author        Nicola Mortoni
    @creation_date 30/10/2002

    @cvs-id index.tcl

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    rom03 15/10/2024 Modifiche per cambio password univoco da portale per operatori ditte di manutenzione.

    rom02 08/07/2024 Corretto errore per il comando ns_md, nelle vecchie versioni di naviserver
    rom02            bisogna passare il default digest "sha256".

    rom01 28/07/2022 Allinemanto enti UCIT a nuovo cvs, riportata modifica fata su vecchio cvs per
    rom01            login tramite SPID: Verifico se ho i cookie di sessione e se li trovo faccio
    rom01            il redirect al /main.

    nic01 04/06/2014 Aggiunto utilizzo dei parametri password_gg_durata e password_gg_preavviso
    nic01            per evitare di modificare questo sorgente sulle varie istanze

} -properties {
    page_title:onevalue
    context_bar:onevalue
}

set  systemname [parameter::get_from_package_key -package_key acs-kernel -parameter SystemName];#rom02
set db_name     [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""];#rom03
set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale -default ""]   ;#rom03

set id_utente_sessione [ad_get_client_property iter logged_user_id] ;#rom01
set id_utente_cookie   [ad_get_cookie iter_login_[ns_conn location]];#rom01

if {![string equal $id_utente_cookie ""] &&
    $id_utente_cookie eq $id_utente_sessione} {#rom01 aggiunta if e contenuto
    ad_returnredirect main
}

set page_title   "$systemname Login"
set context_bar  "&nbsp;"
set form_name    "login"

set current_date [db_string query "select to_char(current_date,'YYYY-MM-DD')"]
iter_get_coimtgen
set flag_ente $coimtgen(flag_ente)

form create $form_name

element create $form_name utn_cde \
    -label "Codice Utente" \
    -widget text \
    -datatype text \
    -html {size 30 maxlength 10}

element create $form_name utn_psw \
    -label "Password" \
    -widget password \
    -datatype text \
    -html {size 30 maxlength 10}

element create $form_name submit \
    -label "Entra" \
    -widget submit \
    -datatype text


if {[form is_valid $form_name]} {

  # form valido dal punto di vista del templating system

    set utn_cde      [element::get_value $form_name utn_cde]
    set form_utn_psw [element::get_value $form_name utn_psw]

    set error_num 0
    set data "2050-01-01"
    if {[db_0or1row sel_user_login ""] == 0} {
        incr error_num
        element::set_error $form_name utn_cde "Codice utente non valido"
    } else {

	set salt [db_string q "select salt from coimuten where id_utente = :utn_cde"];#ric01

	#rom02set check_psw [ns_md string $form_utn_psw$salt];#ric01
        set check_psw [ns_md string -digest "sha256" $form_utn_psw$salt];#rom02

	#ric01 if {$password != $form_utn_psw} {}
	if {$password != $check_psw} {#ric01 if ma non suo contenuto
            incr error_num
            element::set_error $form_name utn_psw "Password errata"
        }
    }

    set password_gg_durata    [parameter::get_from_package_key -package_key iter -parameter password_gg_durata    -default 91];#nic01
    set password_gg_preavviso [parameter::get_from_package_key -package_key iter -parameter password_gg_preavviso -default 81];#nic01
    
    set datascadpsw [db_string query "select to_char(to_date(:data,'YYYY-MM-DD') + $password_gg_durata   ,'YYYY-MM-DD')"]
    set dataprescad [db_string query "select to_char(to_date(:data,'YYYY-MM-DD') + $password_gg_preavviso,'YYYY-MM-DD')"]

    if {$current_date > $dataprescad} {
	set messaggioscad "Password in scadenza il $datascadpsw" 
    } else {
	set messaggioscad ""
    }

    if {$current_date > $datascadpsw} {
	incr error_num
	if {$url_portale ne "" && ![string equal [iter_check_uten_manu $utn_cde] ""]} {#rom03 if e contenuto
	    db_1row -dbn $db_name q "
            select user_id 
                 , password as hash_user
              from users
             where username = :utn_cde"
		
	    element::set_error $form_name utn_psw "<a href=$url_portale/user/password-reset?password_hash=$hash_user&user_id=$user_id> Cambia Password </a>"

	} else {#rom03 else ma non il contenuto
	    element::set_error $form_name utn_psw "<a href=/iter/utenti/coimcpwd-gest?funzione=M&nome-funz=main&id_utente=$id_utente> Cambia Password </a>"
	}
    }

    if {$error_num == 0 } {#ric01 if e suo contenuto
	set is_first_login_p [db_string q "select is_first_login_p 
                                             from coimuten 
                                            where id_utente = :utn_cde"]
	if {$is_first_login_p} {
	    incr error_num
	    if {$url_portale ne "" && ![string equal [iter_check_uten_manu $utn_cde] ""]} {#rom03 if e contenuto
		db_1row -dbn $db_name q "
                select user_id
                     , password as hash_user
                  from users
                 where username = :utn_cde"

		element::set_error $form_name utn_psw "<a href=$url_portale/user/password-reset?password_hash=$hash_user&user_id=$user_id> Prima di effettuare il login, premi QUI per impostare la tua password personale</a>"
	    } else {#rom03 else ma non contenuto
		element::set_error $form_name utn_psw "<a href=/iter/utenti/coimcpwd-gest?funzione=M&nome-funz=main&id_utente=$id_utente&caller=login> Prima di effettuare il login, premi QUI per impostare la tua password personale</a>"
	    }
	}
    }

    if {$error_num > 0} {
        ad_return_template
        return
    }
 
    # ad_set_client_property -persistent t iter rows_per_page $utn_rgh
    # questo sopra non funziona per tutta la durata della sessione!!!

    # occorerebbe mettere in una sorta di var di sessione lo user che effettua la login
    # per confrontarlo con quello messo nel cookie
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
    
    ad_returnredirect -message $messaggioscad main   
    #    ad_script_abort
}

ad_return_template
