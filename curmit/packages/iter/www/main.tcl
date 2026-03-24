# /www/caldaie/main.tcl
ad_page_contract {
    Menu principale.
    
    @author Giulio Laurenzi
    @date   13/12/2002

    @cvs_id main.tcl

    USER  DATA       MODIFICHE
    ===== ========== =====================================================================================
    mat03 21/01/2026 Aggiornato rom05. Non metto un commento perchè su Latina è in merge, quindi non aggiungendolo
    mat03            non dovrebbero esserci problemi. Aggiunta una condizione all'if (copiata da latina che
    mat03            attualmente è indietro di versione). Soluzione concordata con Simone.

    rom06 01/09/2025 Modificato intervento di rom04: Regione Friuli ha dei casi di operatori che non sono
    rom06            presenti sulla tabella users lato portale, per quei casi faccio il redirect sul cambio password
    rom06            dell'ente.

    rom05 25/06/2025 Se sono loggato come ispettore non devo vedere i pulsanti del cruscotto.

    mat02 25/03/2025 Aggiunto f_cod_manu come variabile di export se si accede come tale

    mat01 20/03/2025 Modificato la variabile di export f_data_mod_da per gli impianti da validare

    ric01 21/01/2025 Aggiunto conteggio strumenti scaduti.

    rom04 12/12/2024 Modificato intervento di rom03: se un operatore usa il cambio password va reindirizzato
    rom04            al password-update e non al password-reset. Aggiunta riga_utente e riga_ditta per MEV Marche.

    rom03 15/10/2024 Modifiche per cambio password univoco da portale per operatori ditte di manutenzione.

    but01 08/05/2024 Aggiunto impianti RESPINTI.
    
    rom02 07/05/2024 Modifiche per cruscotto iniziale.

    sim01 12/03/2019 Per ragioni di sicurezza in caso di single-sign-on è meglio non passare l'id_utente
    sim01            nell'url quindi farò l'autenticazione solo attraverso il token_code

    rom01 29/06/2018 Cambiato il titolo in "Menù gestione Impianti"

    gab01 13/04/2018 Gestione del Multiportafoglio: al web-service che restituisce il saldo
    gab01            del portafoglio passo il nome dell'ente portafoglio

    nic01 27/05/2013 Aggiunto avviso presenza di messaggi non letti

} {
    {livello  "1"}
    {scelta_1 ""} 
    {scelta_2 ""}
    {scelta_3 ""}
    {scelta_4 ""}
    {id_utente ""}
    {messaggioscad ""}
    {nome_funz "main"}
    {flag_saldo ""}
    {id_utente ""}
    {token_code ""}
}

set db_name [parameter::get_from_package_key -package_key iter -parameter dbname_portale -default ""]
set logo_url [iter_set_logo_dir_url];#rom02
iter_get_coimtgen;#rom02
set master_logo_sx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default "oasi.gif"];#rom02
set master_logo_sx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"];#rom02
set master_logo_sx_titolo_sopra [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sopra];#rom02
set master_logo_sx_titolo_sotto [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_titolo_sotto];#rom02

set master_logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome   -default "oasi.gif"];#rom02
set master_logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_height -default "32"];#rom02
set master_logo_dx_titolo_sopra [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_titolo_sopra];#rom02
set master_logo_dx_titolo_sotto [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_titolo_sotto];#rom02

set master_ind_email            [parameter::get_from_package_key -package_key iter -parameter master_ind_email];#nic02
set master_sito_web             [parameter::get_from_package_key -package_key iter -parameter master_sito_web];#nic02
set url_portale                 [parameter::get_from_package_key -package_key iter -parameter url_portale];#rom03

set ente_portafoglio [db_get_database];#gab01

db_0or1row q "select flag_single_sign_on
                     from coimtgen"

#sim01 tolto $id_utente ne ""
if {$token_code ne "" && $flag_single_sign_on eq "t" && [db_0or1row -dbn $db_name q "
                                                                          select data_last_login
                                                                               , utente as id_utente --sim01
                                                                            from iter_login
                                                                           where --sim01 utente     = :id_utente and 
                                                                                 token_code = :token_code
                                                                             and data_last_login + (interval '30 minute') > current_timestamp"]} {


    db_1row q "select rows_per_page
                 from coimuten 
                where id_utente=:id_utente "

    ad_set_client_property iter logged_user_id $id_utente
    set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
    set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
    set session_id [ad_conn session_id]
    set adsession [ad_get_cookie "ad_session_id"]
    
    # crea cookie utenti e permessi
    ad_set_cookie -replace t -path / iter_login_[ns_conn location] $id_utente
    ad_set_cookie -replace t -path / iter_rows_[ns_conn location] $rows_per_page
    
}


# : RECUPERO LO USER - INTRUSIONE
set id_utente [ad_get_cookie iter_login_[ns_conn location]]
set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
set session_id [ad_conn session_id]
set adsession [ad_get_cookie "ad_session_id"]
set referrer [ns_set get [ad_conn headers] Referer]
set hostx [ns_set get [ad_conn headers] Host]
set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]
#ns_log notice "$id_utente $id_utente_loggato_vero"

#if {[string equal $id_utente_loggato_vero "xxzzy"]} {
  if {$id_utente != $id_utente_loggato_vero} {
	set login [ad_conn package_url]
	ns_log Notice "********AUTH-CHECK-MAIN-KO-USER;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
   } else {
	ns_log Notice "********AUTH-CHECK-MAIN-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
   }
#}

# mail alert
#if {![string equal $id_utente_loggato_vero $id_utente]} {
#    ns_log Notice "********B80-AUTH-CHECK-MAIN-KO-USER-COOKIE;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$nome_funz;$adsession;"
#    if {$id_utente != ""} {
#	ns_sendmail "sferrari@oasisoftware.it" "Accesso illegale utenti via cookie $id_utente_loggato_vero $id_utente - $clientip - $hostx" "Accesso illegale utenti via cookie $id_utente_loggato_vero $id_utente - $clientip - $hostx"
	# questa ns_sendmail va in abend su oasi64-dev perchè manca il mittente...
#    }
#}

if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
}

if {[db_0or1row sel_menu ""] == 0} {
    iter_return_complaint  "Il Vs. profilo non ha men&ugrave;."
    return
}

set main_directory [ad_conn package_url]
if {[db_0or1row get_titolo ""] == 1} {
    set context_bar  [iter_context_bar \
		     [list ${main_directory}main "Home"] \
                     "$titolo"]
} else {
    set titolo ""
    #ric01 set context_bar  [iter_context_bar [list "Home"]]
    set context_bar "";#ric01
}

#if {$livello != 1} {
#    set livello_inf [expr $livello - 1]
#    switch $livello_inf {
#	"2" {append context_bar " : <a href=main?livello=$livello_inf&scelta_1=$scelta_1&scelta_2=0&scelta_3=0&scelta_4=0&nome_funz=main>Men&ugrave; precedente</a>" 
#	}
#	"3" {append context_bar " : <a href=main?livello=$livello_inf&scelta_1=$scelta_1&scelta_2=$scelta_2&scelta_3=0&scelta_4=0&nome_funz=main>Men&ugrave; precedente</a>" 
#	}
#	"4" {append context_bar " : <a href=main?livello=$livello_inf&scelta_1=$scelta_1&scelta_2=$scelta_2&scelta_3=$scelta_3&scelta_4=0&nome_funz=main>Men&ugrave; precedente</a>" 
#	}
#    }
#}

#switch $livello {
#    "1" {set where_scelte_a ""}
#    "2" {set where_scelte_a "and a.scelta_1 = :scelta_1"}
#    "3" {set where_scelte_a "and a.scelta_1 = :scelta_1
#                          and a.scelta_2 = :scelta_2"}
#    "4" {set where_scelte_a "and a.scelta_1 = :scelta_1
#                          and a.scelta_2 = :scelta_2
#                          and a.scelta_3 = :scelta_3"}
#}

#set indice ""
#db_foreach sel_menu_join_ogge "" {
#    if {$tipo == "menu"}  {
#	set liv [expr $livello + 1]
#	append indice "<li><a href=main?livello=$liv&scelta_1=$uno&scelta_2=$due&scelta_3=$tre&scelta_4=$quattro&nome_funz=main>$descrizione</a>"
#    } 
#    if {$tipo == "funzione"} {
#	if {[db_0or1row sel_funz ""] == 0} {
#	} else {
#	    set link "$azione$det?nome_funz=$nome_funz"
#	    if {![string equal $parametri ""]} {
#		set list_par [split $parametri "\&"]
#		foreach coppia $list_par {
#		    set list_elem [split $coppia "="]
#		    set key [lindex $list_elem 0]
#		    set val [lindex $list_elem 1]
#		    append link "&$key=[ns_urlencode $val]"
#		}
#	    }
#	    append indice "<li><a href=$link>$descrizione</a>" 
#	}

#    }
#}

#append indice "</li>"


# leggo nome e cognome dell'utente
if {![db_0or1row sel_user ""]
} {
    iter_return_complaint  "Codice utente non valido." 
    return
} 

set yui_menu_p $flag_menu_yui

#messaggio Password
#set current_date [db_string query "select to_char(current_date,'YYYY-MM-DD')"]
#set datascadpsw [db_string query "select to_char(:data::date + 91,'YYYY-MM-DD')"]
#set dataprescad [db_string query "select to_char(:data::date + 81,'YYYY-MM-DD')"]
#set datascadpsw  [db_string query "select to_char(:datascadpsw::date,'DD-MM-YYYY')"]
   
#if {$current_date > $dataprescad} {
#    set messaggioscad " Attenzione!! Password in scadenza il $datascadpsw" 
#} else {
#    set messaggioscad ""
#}

# leggo titolo
#switch $livello {
#    2 {set scelta_2 0}
#    3 {set scelta_3 0}
#}
#if {[db_0or1row sel_ogge_titolo ""] == 0
#} {
#rom01    set titolo "Men&ugrave; principale"
#ric01 set titolo "Men&ugrave; gestione impianti";#rom01
#}

set cod_manu [iter_check_uten_manu $id_utente];#rom04

if {![string equal $cod_manu ""]} {#rom04 Aggiunte if, else e il loro contenuto
    db_1row q "select m.cognome as denominazione
                 from coimopma o
                    , coimmanu m
                where o.cod_manutentore = m.cod_manutentore
                  and o.cod_opma        = :id_utente"
    set riga_utente "<p><big><big>Codice utente: $cod_manu.</big></big></p>"
    set riga_ditta  "<p><big><big>Ditta di Manutenzione: $denominazione.</big></big></p>"
} else {
    set riga_utente "<p><big><big>Codice utente: $id_utente.</big></big></p>"
    set riga_ditta ""
}
    

db_1row sel_tgen "select flag_portafoglio from coimtgen"

set riga_portafoglio ""

if {$flag_portafoglio ==  "T"} {

    set link_saldo ""
    set saldo ""
    set conto_manu ""

    #rom04set cod_manu [iter_check_uten_manu $id_utente]   
    if {![string equal $cod_manu ""]} {
	if {$flag_saldo ne "T"} {
	    set riga_portafoglio "<a href=main?flag_saldo=T>Visualizza il saldo residuo</a>"
	} else {
	    set url  "lotto/balance?iter_code=$cod_manu&ente_portafoglio=$ente_portafoglio";#gab01 passo al web-service anche ente_portafoglio
	    set data [iter_httpget_wallet $url]
	    array set result $data
	    
	    set risultato [string range $result(page) 0 [expr [string first " " $result(page)] - 1]]
	    set parte_2   [string range $result(page) [expr [string first " " $result(page)] + 1] end]
	    set saldo     [iter_edit_num [string range $parte_2 0 [expr [string first " " $parte_2] - 1]] 2]
	    set codice_portafoglio [string range $parte_2 [expr [string first " " $parte_2] + 1] end]

	    set riga_portafoglio "Saldo: $saldo &#8364;; Codice portafoglio: $codice_portafoglio"
	}
    }
}

set page_title $titolo

db_1row query "
select count(*) as ctr_msg_non_letti
  from coimdmsg
 where utente_dest = :id_utente -- solo i messaggi ricevuti dallo user corrente
   and flag_letto  = 'f'
";#nic01

#rom02 Inizio parte per cruscotto

set is_widgtes_home_to_view t;#rom05

if {![string equal [iter_check_uten_opve $id_utente] ""] || ![string equal [iter_check_uten_enve $id_utente] ""]} {#rom05 Aggiunta if e il suo contenuto
    set is_widgtes_home_to_view f
}
    
if {$ctr_msg_non_letti > 0} {
    set href_url_msg [export_vars -base "src/coimdmsg-list" {{nome_funz "dmsg"}}]
    set wid_home_msg_cursor ""
} else {
    set href_url_msg "#"
    set ctr_msg_non_letti "0"
    set wid_home_msg_cursor "cursor:not-allowed;"
}
		      
set where_manu ""
set f_cod_manu ""
if {![string equal $cod_manu ""]} {
    set where_manu "and cod_manutentore = :cod_manu"
    set f_cod_manu $cod_manu
}

db_1row q "select to_date(current_date - interval '1 day', 'YYYY-MM-DD')                  as yesterday_date
                , iter_edit_data(to_date(current_date - interval '1 day', 'YYYY-MM-DD'))  as yesterday_date_pretty
                , to_date(current_date - interval '1 year', 'YYYY-MM-DD')                 as last_year_date
                , iter_edit_data(to_date(current_date - interval '1 year', 'YYYY-MM-DD')) as last_year_date_pretty
                , to_date(current_date , 'YYYY-01-01')                                    as current_year_beg_date
                , iter_edit_data(to_date(current_date, 'YYYY-01-01'))                     as current_year_beg_date_pretty
                , to_char(current_date                    , 'YYYY')                       as current_year_pretty
                , to_char(current_date - interval '1 year', 'YYYY')                       as last_year_pretty
                , current_date                                                            as cur_date
                , current_date                                                            as cur_date_pretty"

# impianti con rcee scaduto
if {[db_0or1row q "select count(*) as num_imp_scad
                     from coimaimp
                    where stato='A'
                      and data_scad_dich is not null
                --    and data_scad_dich between :last_year_date and current_date
                --    and data_scad_dich between :current_year_beg_date and current_date
                      and data_scad_dich < :cur_date
                      $where_manu
                   having count(*) > 0"]} {
    set num_imp_scad_pretty [iter_edit_num $num_imp_scad 0]
    set href_url_imp_scad [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_stato_aimp "A"} {f_mod_h "2"} {f_cod_manu $f_cod_manu}}]
    set wid_home_imp_scad_cursor ""
} else {
    set href_url_imp_scad "#"
    set num_imp_scad  "0"
    set num_imp_scad_pretty "0"
    set wid_home_imp_scad_cursor "cursor:not-allowed;"
}

# impianti da validare
if {[db_0or1row q "select count(*) as num_imp_da_valid
                     from coimaimp
                    where stato = 'F'
                      and data_ins between :current_year_beg_date and current_date
                     --    or data_mod between :last_year_date and current_date
                      $where_manu
                   having count(*) > 0"]} {
    set num_imp_da_valid_pretty [iter_edit_num $num_imp_da_valid 0]
    set f_data_mod_da [iter_check_date $last_year_date_pretty]
    set href_url_imp_da_valid [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_stato_aimp "F"} {f_impianto_inserito "S"} {f_data_mod_da $current_year_beg_date} {f_cod_manu $f_cod_manu}}] ;#mat01 sostituito {f_data_mod_da $f_data_mod_da} con {f_data_mod_da $current_year_beg_date}
    set wid_home_imp_da_valid_cursor ""
} else {
    set num_imp_da_valid_pretty "0"
    set href_url_imp_da_valid "#"
    set num_imp_da_valid "0"
    set wid_home_imp_da_valid_cursor "cursor:not-allowed;"
}

#but01 impianti RESPINTI
if {[db_0or1row q "select count(*) as num_imp_da_resp
                     from coimaimp
                    where stato = 'E'
                      and data_ins between :current_year_beg_date and current_date
                     --    or data_mod between :last_year_date and current_date
                      $where_manu
                   having count(*) > 0"]} {#but01
    
    set num_imp_da_resp_pretty [iter_edit_num $num_imp_da_resp 0]
    set f_data_mod_da [iter_check_date $last_year_date_pretty]
    set href_url_imp_da_resp [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_stato_aimp "E"} {f_impianto_inserito "S"} {f_data_mod_da $f_data_mod_da} {f_cod_manu  $f_cod_manu}}]
    set wid_home_imp_da_resp_cursor ""
} else {
    set num_imp_da_resp_pretty "0"
    set href_url_imp_da_resp "#"
    set num_imp_da_resp "0"
    set wid_home_imp_da_resp_cursor "cursor:not-allowed;"
}
#impianti con rcee con prescrizioni o non possono funzionare in stato attivo
if {[db_0or1row q "select count(*) as num_imp_peric
                     from coimaimp a
                    where a.stato='A'
                      $where_manu     
                      and exists (
                          select 1
                            from coimdimp d
                           where d.cod_impianto     = a.cod_impianto
                             and d.data_ins between :current_year_beg_date and current_date
                             and ( d.prescrizioni is not null
                                 or d.flag_status      = 'N')
                          )
                     having count(*) > 0"]} {
    set num_imp_peric_pretty [iter_edit_num $num_imp_peric 0]
    set href_url_imp_peric [export_vars -base "src/coimaimp-list" {{nome_funz "impianti"} {f_stato_aimp "A"} {f_dimp_peric "t"} {f_dimp_da_dt_ins $current_year_beg_date} {f_dimp_a_dt_ins $cur_date} {f_cod_manu $f_cod_manu}}]
    set wid_home_imp_peric_cursor ""   
} else {
    set num_imp_peric_pretty "0"
    set href_url_imp_peric "#"
    set num_imp_peric "0"
    set wid_home_imp_peric_cursor "cursor:not-allowed;"

}

#Conteggio degli strumenti scaduti
if {[db_0or1row q "select count(*) as num_strum_scad
                     from coimstru_manu a
                    where a.is_active_p = 't'
                      $where_manu     
           	      and marca_strum is not null
		      and modello_strum is not null
		      and dt_tar_strum + (interval '1 year') < current_date
                     having count(*) > 0
"]} {#ric01
    set num_strum_scad_pretty [iter_edit_num $num_strum_scad 0]
    set href_url_strum_scad [export_vars -base "src/coimstru-manu-scad" {{nome_funz "coimstru-manu"} {f_scaduto "t"} {f_cod_manu $f_cod_manu}}] ;#mat02 aggiunto {f_cod_manu $f_cod_manu}
    set wid_home_strum_scad ""   
} else {
    set num_strum_scad_pretty "0"
    set href_url_strum_scad "#"
    set num_strum_scad "0"
    set wid_home_strum_scad "cursor:not-allowed;"

}

#rom02 Fine parte per cruscotto

set funz_pwd     [iter_get_nomefunz coimcpwd-gest];#rom03
set funz_log_out [iter_get_nomefunz logout];#rom03

set riga_cambio_password "<p>Puoi anche cambiare la tua <a class=main href=utenti/coimcpwd-gest?funzione=M&nome_funz=$funz_pwd>password</a> o <a class=main href=\"logout?nome_funz=$funz_log_out\">uscire</a> dal programma.</p>";#rom06
if {![string equal [iter_check_uten_manu $id_utente] ""]} {#rom03 Aggiunte if, else e il loro contenuto
    if {[db_0or1row -dbn $db_name q "
      select user_id
   --rom04 , password as hash_user
        from users
       where username = :id_utente"]} {
    
    #rom04set riga_cambio_password "<p>Puoi anche cambiare la tua <a class=main href=$url_portale/user/password-reset?password_hash=$hash_user&user_id=$user_id>password</a> o <a class=main href=\"logout?nome_funz=$funz_log_out\">uscire</a> dal programma.</p>"
	   set riga_cambio_password "<p>Puoi anche cambiare la tua <a class=main href=$url_portale/user/password-update?user_id=$user_id target=password-update>password</a> o <a class=main href=\"logout?nome_funz=$funz_log_out\">uscire</a> dal programma.</p>";#rom04
       }
} else {
    #rom06set riga_cambio_password "<p>Puoi anche cambiare la tua <a class=main href=utenti/coimcpwd-gest?funzione=M&nome_funz=$funz_pwd>password</a> o <a class=main href=\"logout?nome_funz=$funz_log_out\">uscire</a> dal programma.</p>"
}


ad_return_template
