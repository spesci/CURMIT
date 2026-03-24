ad_page_contract {
    Login utente
    @author        Luca Romitti
    @creation_date 21/02/2018

    @cvs-id index.tcl
    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    sim01 12/03/2019 Per ragioni di sicurezza è meglio non passare l'id_utente nell'url quindi farò l'autenticazione
    sim01            solo attraverso il token_code
    
    rom01 26/06/2018 Faccio loggare anche l'utente cait che arriva dal portale.
} {
    {id_utente ""}   
    {token_code ""}
    {caller "index"}
} -properties {
    page_title:onevalue
    context_bar:onevalue
}

set db_name [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""]

if {$caller eq "index"} {#il programma è chiamato dalla sua istanza quindi l'utente deve essere già loggato

    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
#sim01	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di"
	return 0
    }

} else {# l'utente è chiamato da un istanza esterna e per il signle-sign-on non deve ricollegarsi

    if {![db_0or1row -dbn $db_name q "select data_last_login
                                           , utente as id_utente --sim01
                                        from iter_login
                                       where --sim01 utente     = id_utente and --sim tolto il due punti se no da errore
                                            token_code = :token_code
                                         and data_last_login + (interval '30 minute') > current_timestamp 
"]} {	

	set login [ad_conn package_url]

	#sim01	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di";#sim01
    }
    if {$caller eq "cait"} {#rom01 aggiunta if e contenuto, aggiunta else
	db_1row q "select rows_per_page
                        , id_utente
                     from coimuten
                    where id_utente like 'cait%'"
    } else {
    db_1row q "select rows_per_page
                 from coimuten 
                where id_utente=:id_utente "
    };#rom01    
    
    ad_set_client_property iter logged_user_id $id_utente
    set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
    set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
    set session_id [ad_conn session_id]
    set adsession [ad_get_cookie "ad_session_id"]

    # crea cookie utenti e permessi
    ad_set_cookie -replace t -path / iter_login_[ns_conn location] $id_utente
    ad_set_cookie -replace t -path / iter_rows_[ns_conn location] $rows_per_page
        
}

set page_title   "Login"
set context_bar  "&nbsp;"
set form_name    "login"

set link_enti_coll [db_list_of_lists -dbn $db_name q "
    select g.group_name as descrizione, 
           i.instance_name as ente
--           i.instance_name
    from acs_rels r, groups g, parties p, iter_instances i
    where r.rel_type='composition_rel' and
          r.object_id_one = -2 and
          r.object_id_two = g.group_id and
          g.group_id      = p.party_id and
          g.group_id      = i.instance_id
    order by group_name
"]

set url_redirect ""
ad_form -name form_login \
    -export {id_utente token_code} \
    -edit_buttons [list [list "Vai" new -html {class "form_submit"}]] \
    -has_edit 1 \
    -html {class ""} \
    -form {
	{-section "sec1" {legendtext "Selezionare l'ente su cui collegarsi:"} {fieldset {class legend}}}
	{ente:text(radio),optional
	    {label ""}
	    {options $link_enti_coll}
	    {html {class "form-field-radio"}}
	}
	
    }
ad_form -extend -name form_login -form {
    # Reset section
    {-section ""}
}

ad_form -extend -name form_login -on_submit {

#	set id_utente [ad_get_client_property iter logged_user_id]
	
	if {$ente eq ""} {
	    element::set_error form_login ente "<font color=red>Si prega di selezionare un ente.</font><br><br>"
	    break
	}
	
	set token_code_new $id_utente[randomRange 99999999] 
	
	db_dml -dbn $db_name q "update iter_login 
                                   set token_code      = :token_code_new
                                     , data_last_login = current_timestamp 
                                where utente           = :id_utente"                      


	set url [db_string -dbn $db_name q "
    select  p.url
    from acs_rels r, groups g, parties p, iter_instances i
    where r.rel_type='composition_rel' and
          r.object_id_one = -2 and
          r.object_id_two = g.group_id and
          g.group_id      = p.party_id and
          g.group_id      = i.instance_id
      and i.instance_name= :ente
    order by group_name
"]

	
    } -after_submit {

	#sim01 set url_redirect "$url/iter/main?id_utente=$id_utente&token_code=$token_code_new"
	set url_redirect "$url/iter/main?token_code=$token_code_new"
	ns_returnredirect $url_redirect

    }

