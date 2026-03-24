ad_page_contract {
    Uscita dal programma.

    @author Nicola Mortoni
    @date   31/10/2002

    USER  DATA       MODIFICHE
    ===== ========== ======================================================================================
    rom03 11/06/2024 Modifiche per permettere di richiamare il programma direttamente da menu.

    rom02 28/07/2022 Allineamnto Ucit a nuovo cvs, riportate modifiche fatte sul vecchio cvs per  lo SPID:
    rom02            Durante il logout vado a sbiancare anche il cookie di sessione dello spid.

    rom01 28/07/2022 Per Regione Marche il logout deve reindirizzare al portale, la modifica e' piu' vecchia
    rom01            rispetto alla data del commento, ma per qualche motivo non avevo commentato in testa al programma.

} {
 nome_funz
}

if {1 == 0} {
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
}

};#rom03
set headers [ns_conn outputheaders]

# faccio spirare i cookies
ns_set put $headers Set-Cookie "iter_login_[ns_conn location]=irrelevant; path=/; expires=Mon, 01-Jan-1990 01:00:00 GMT"
ns_set put $headers Set-Cookie "iter_rows_[ns_conn location]=irrelevant; path=/; expires=Mon, 01-Jan-1990 01:00:00 GMT"
ns_set put $headers Set-Cookie "iter_login_spid_cf_[ns_conn location]=irrelevant; path=/; expires=Mon, 01-Jan-1990 01:00:00 GMT";#rom02

iter_get_coimtgen;#rom01

if {$coimtgen(regione) eq "MARCHE"} {#rom01 aggiunta if e suo contenuto
    set url_portale [parameter::get_from_package_key -package_key iter -parameter url_portale -default ""]
    append url_portale "/register";#reindirizzo gli utenti alla pagina di log-in del portale
    ad_returnredirect -allow_complete_url $url_portale
} else {
ad_returnredirect index
}
