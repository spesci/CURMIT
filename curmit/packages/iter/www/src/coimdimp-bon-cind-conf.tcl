ad_page_contract {
    Pagina di sfondo.

    @author Giulio Laurenzi
    @date   18/03/2004

    @cvs_id coiminco-help.tcl
} {
    {funzione         "V"}
    {caller       "index"}
    {nome_funz         ""}
    {nome_funz_caller  ""}
    {extra_par         ""}
 } -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}


set page_title      "Conferma bonifica Campagna"
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
  # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
  # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	return 0
    }
}
if {$caller == "index"} {
   set context_bar [iter_context_bar \
                    [list "javascript:window.close()" "Torna alla Gestione"] \
                    "$page_title"]
}
set logo_url [iter_set_logo_dir_url]
set css_url  [iter_set_css_dir_url]
