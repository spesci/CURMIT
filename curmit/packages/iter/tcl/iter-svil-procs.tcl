ad_library {
    Provides various functions for the package.

    @author Nicola Mortoni
    @cvs-id iter-utility-procs.tcl

    USER    DATA       MODIFICHE
    ======= ========== ======================================================================
    ric01   12/09/2025 Modificata proc iter_check_uten_manu per bloccare l'utente che non abbia
    ric01              un abilitazione giuridica attiva. ("Nuova richiesta 2025") MEV regione Marche.

    rom21   21/03/2025 Aggiuntao alla iter_get_coimtgen il campo protocollo_automatico_ente.

    rom20   23/05/2024 Aggiunto alla iter_get_coimtgen il campo flag_cind.
    
    rom19   19/09/2023 Modificata proc iter_delete_permanenti, anche Napoli non cancella gli allegati.

    rom18   18/09/2023 Aggiunto alla iter_get_coimtgen il campo flag_asse_data.

    but01 19/07/2023   Aggiunta class"link-button-2" nel actions"Selez

    rom17   05/07/2023 Modificata proc iter_check_mandatory_fields, i campi cod_tpim e unita_immobiliari_servite
    rom17              sono obbligatori anche per il freddo.

    rom16   08/05/2023 Modificata proc iter_delete_permanenti, anche Palermo non cancella gli allegati.
    
    rom15   12/04/2023 Aggiunto alla iter_get_coimtgen i campi flag_firma_ispe_stampa_cimp e flag_firma_resp_stampa_cimp.

    rom14   23/11/2022 Aggiunto alla iter_get_coimtgen i campi flag_firma_manu_stampa_rcee e flag_firma_resp_stampa_rcee.

    sim09   01/02/2023 Corretto sim06S che non funzionava correttamente se nel formname erano presenti
    sim09              più di un "_"

    rom13   19/03/2021 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(login_spid_p).
    rom13              Copiato da vecchio cvs per allineamento enti di Ucit.

    rom12   30/11/2020 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(flag_controllo_abilitazioni).
    rom12              Copiato da vecchio cvs per allineamento enti di Ucit.

    rom11   06/07/2022 Modificata proc iter_search: aggiunto parametro per il nome del link o bottone.

    mic01   30/05/2022 Modificata proc iter_check_mandatory_fields, Il dpr 660 96 deve essere
    mic01              obbligatorio solo se il combustibile non e' solido per il caldo.

    rom10   20/05/2022 Corretta modifica di rom09, il campo flag_ibrido in realta' era stato
    rom10              indicato obbligatorio per tutte le tipologie di impianto, deve esserlo
    rom10              solo per caldo e freddo.

    rom09   27/04/2022 Modificata proc iter_check_mandatory_fields per MEV Sistemi Ibridi delle Marche.
    rom09              Il campo flag_ibrido e' diventato sempre obbligatorio per il caldo e per il freddo
    rom09              quindi, quando manca, mostro la X rossa per la Scheda 1.

    rom08   31/03/2022 Su richiesta di Giuliodori con mail "MEV rilasciata in produzione." del 28/03/2022
    rom08              vado a modificare la proc iter_check_mandatory_fields per la MEV
    rom08              Stato impianto "Rottamato". La X rossa per i generatori va mostrata solo in caso
    rom08              in cui non ci siano generatori attivi in un impianto in stato attivo.

    rom07   13/01/2022 Modificata proc iter_check_mandatory_fields, aggiunto controllo su pod se
    rom07              il combustibile e' GPL o GNL, su segnalazione di Regione Marche o Sandro

    rom06   03/12/2020 Modificata proc iter_check_mandatory_fields, aggiunti dei controlli
    rom06              su pod e pdr.

    rom05              Modificata proc iter_check_mandatory_fields, aggiunto il ritorno di
    rom05              una croce gialla in mancanza di alcuni dati non obbligatori.

    sim08   23/10/2020 commitata vecchia modifica su iter_delete_permanenti per fare in modo
    sim08              che sulla Regione Marche non vengano cancellati gli allegati.
    
    sim07   20/01/2020 Aggiunto alla iter_get_coimtgen il campo flag_obbligo_dati_catastali

    rom04   23/04/2019 Nuova proc iter_check_mandatory_fields che controlla che tutti i dati
    rom04              obbligatori delle varie schermate siano compilati. Se sono compilati
    rom04              restituisce un'immagine con una crocetta verde, al contrario, se manca
    rom04              qualche campo restituisce un'immagine con una croce rossa.

    sim06S  15/03/2019 Modificato le proc iter_selected e iter_search per questioni di sicurezza.
    sim06S             Va impedito che venga innnestato del javascript esterno nei link Sel. delle ricerche.

    sim06   08/03/2019 Nuova proc iter_permanenti_file_salva che ricevuto in input un file lo salva
    sim06              nella cartella dei permanenti e restituisce il suo path completo

    rom03   10/10/2018 Modificata proc iter_get_coimdesc per aggiungere il nuovo campo email.

    rom02   04/07/2018 Aggiunta nuova poc iter_valid_impianti che mette in automatico la 
    rom02              validazione di un impianto dopo un certo numero di giorni.

    rom01   19/10/2018 Aggiunto nuova proc iter_httpget_call_portale che richiama il portale
    rom01              all'url che arriva in input (utilizzata nel batch di caricamento degli rcee)

    sim05   23/11/2017 Gestisco in maniera differente la chiamata per poter usare il wallet anche con https

    gab02   30/06/2017 Modificata proc iter_get_coimtgen per nuova variabile
    gab02              coimtgen(flag_verifica_impianti)

    gab01   20/02/2017 Modificata proc iter_get_coimtgen per nuova variabile
    gab01              coimtgen(flag_gest_rcee_legna)

    sim04   06/09/2016 Modificata proc iter_get_coimtgen per nuova variabile
    sim04              coimtgen(flag_gest_targa)

    sim03   10/03/2016 Aggiunta nuova proc iter_check_login_portafoglio che verifica se 
    sim03              l'utente ha un portafoglio associato e se sia possibile visualizzarlo

    sim02   07/03/2016 Modificata proc iter_get_coimtgen per nuova variabile
    sim02              coimtgen(flag_portafoglio).

    nic08   12/02/2016 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(flag_potenza).

    nic07   04/02/2016 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(lun_num_cod_imp_est).

    nic06   14/01/2016 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(regione).

    ant01   16/09/2015 Modificata proc iter_selected per aggiungere il nuovo parametro
    ant01              facoltativo callback che serve per chiamare una function javascript
    ant01              eventualmente definita nel caller (vedere coimdope-aimp-gest).

    sim01   17/12/2014 Modificata proc iter_get_coimdesc per nuovo switch -dbn che serve per
    sim01              il portale

    nic05   15/12/2014 Modificata proc iter_get_coimtgen per nuovo switch -dbn che serve per
    nic05              il portale

    nic04   30/05/2014 Modificata proc iter_get_coimtgen per nuova variabile coimtgen(ente)
    nic04              data dall'unione di coimtgen(flag_ente) e coimtgen(sigla_prov) o
    nic04              coimtgen(denom_comune)

    nic03   04/03/2014 Modificata proc iter_get_coimtgen per nuova colonna flag_gest_coimmode

    nic02   07/01/2014 Modificata proc iter_check_login per fare sempre il controllo da doppio
    nic02              click (richama la proc iter_blocca_doppio_click).

    nic01   07/01/2014 Modificata proc iter_blocca_doppio_click perchè con OpenAcs 5.7.0
    nic01              l'ad_conn peeraddr restituiva l'ip pubblico e non l'ip interno dove
    nic01              gira AOLServer mentre ns_server active restutuiva l'ip interno dove
    nic01              gira AOLServer: ora uso solo proc di AOLServer.
    nic01              Modificata anche per usare ns_server all al posto di ns_server active
    nic01              (include anche le connessioni che sono "waiting").
}


ad_proc iter_radio_from_table {table_name table_key key_description {key_orderby ""}} {} {
    if {[string is space $key_orderby]} {
        set key_ordeby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol ""]

    return $l_of_l
}

ad_proc iter_selbox_from_table {table_name table_key key_description {key_orderby ""}} {} {
    if {[string is space $key_orderby]} {
        set key_orderby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol_2 ""]
    set l_of_l [linsert $l_of_l 0 [list "" ""]]

    return $l_of_l
}

ad_proc iter_selbox_from_table_obblig {table_name table_key key_description {key_orderby ""}} {} {
    if {[string is space $key_orderby]} {
        set key_orderby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol_2_ob ""]

    return $l_of_l
}

ad_proc iter_selbox_from_2table {table_name table_key key_description table_name2 table_key2 key_description2 {key_orderby ""}} {} {
    if {[string is space $key_orderby]} {
        set key_orderby  "b.$key_description2, a.$key_description"
    }

    set l_of_l [db_list_of_lists sel_2lol_2 ""]
    set l_of_l [linsert $l_of_l 0 [list "" "" ""]]

    return $l_of_l
}

ad_proc iter_DoubleApos args {} { 
    set params "" 
    set ctr    0
    foreach value $args { 
	# sostituisco apice       '   con slash apice       \'
	# sostituisco apice (url) %27 con slash apice (url) \%27'
	# sostituisco doppioapice "   con &quote;
        regsub -all '     $value  \\'     value1
	regsub -all "%27" $value1 "\\%27" value2
	# regsub -all \"    $value1 \\\"    value2
	# regsub -all \"    $value1 "\\\&quote;" value2
        regsub -all \"    $value2 "%22" value3

        append params "'$value3'"
        incr ctr
        if {$ctr != [llength $args]} {
	    append params ", "
	} 
    }  
    return $params  
} 

ad_proc iter_search {
    -button:boolean
    form_name
    script_name
    what_list
    {lista_par ""}
    {label "Cerca"}
} {
} {

    # Da utilizzare nella pagina ADP del programma di gestione 

    # Argomenti: 1. nome del form che contiene i campi di ricerca
    #            2. nome dello script che propone la lista
    #            3. lista parametri attesi da script_name alternata ai 
    #               corrispondenti campi di form_name   
    #            4. nome del link o bottone.
    
    # genera un link al programma script_name, i cui url parameter vengono popolati
    # dai campi del form in base alla lista what_list. Quest'ultima contiene una o
    # piu' coppie di nomi, in cui il primo rappresenta il nome del parametro atteso
    # da script_name e il secondo il nome del corrispondente campo di form. Il nome
    # del campo di form puo' essere nullo ed in questo casi viene assunto uguale al
    # nome del parametro.


    # per questioni di sicurezza verifico che form_name contenga solo numeri o lettere. In questo modo impedisco
    # che venganno innestati dei javascript.
    #sim09 aggiunto -all
    if {[regexp {[^A-Za-z0-9]} [regsub -all "_" $form_name ""] ""]} {#sim06 if e suo contenuto
	return ""
    }
    
    
    if {![string is space $lista_par]} {
        set extra_par "&[iter_set_url_vars $lista_par]"
    } else {
        set extra_par ""
    }

    # costruisco nomi campi di form riceventi
    foreach {p1 p2} $what_list {
	if {$p2 == ""} {
	    set p2 $p1
	}
	append receiving_element ${p2}|
    }
    set receiving_element [string trimright $receiving_element |]

    if {$button_p} {
        #rom11set tag_iniz {<input type=button value="Cerca"}
        set tag_iniz {<input type=button value="$label"};#rom11
        set tag_fine {</input>}
    } else {
        set tag_iniz {<a href="#"}
	#rom11set tag_fine {Cerca</a>}	
        set tag_fine "$label</a>";#rom11
    }
    set link_to " $tag_iniz onclick=\"javascript:window.open('$script_name?caller=$form_name$extra_par&receiving_element=$receiving_element'" 

    foreach {p1 p2} $what_list {
	if {$p2 == ""} {
	    set p2 $p1
	}
	append link_to " + '&$p1=' + urlencode(document.$form_name.$p2.value)"
    }

    regsub -all -- {-} $script_name {} window_name
    regsub -all -- {/} $window_name {} window_name

    append link_to ", '$window_name', 'scrollbars=yes, resizable=yes, width=760, height=500').moveTo(12,1)\">$tag_fine"

    set urlencode "
    <script language=JavaScript>
    function urlencode(inString){
        inString=escape(inString);
        for(i=0;i<inString.length;i++){
             if(inString.charAt(i)=='+'){
                  inString=inString.substring(0,i) + \"%2B\" + inString.substring(i+1);
             }
        }
        return(inString);
    }
    </script>"

    append link_to $urlencode
    return $link_to
}

ad_proc iter_select {what_list} {} {
    # Da utilizzare nel programma che propone la lista da selezionare.

    # Restituisce un frammento html che deve essere associato all'azione di
    # selezione. Attiva una funzione JavaScript che restituisce al form chiamante 
    # una lista (what_list) di colonne ottenute dalla query che andranno 
    # a popolare i suoi campi.

    set action "<td><a href=\\\"javascript:sel(\[iter_DoubleApos "

    foreach p1 $what_list {
	append action "\$$p1 "
    }

    append action "])\\\" class=\"link-button-2\">Selez.</a>"

    return $action

}

# ant01: aggiunto parametro facoltativo callback
ad_proc iter_selected {form_name what_list {callback "onSearchClose()"}} {} {

    # Da utilizzare nella pagina ADP del programma di lista da selezionare     

    # genera una funzione JavaScript che popola i campi del form form_name
    # in base alla lista what_list. Quest'ultima contiene una o
    # piu' coppie di nomi, in cui il secondo rappresenta il nome della colonna 
    # restituita dalla query e il primo il nome del corrispondente campo di form.
    # Il nome della colonna della query puo' essere nullo ed in questo caso
    # viene assunto uguale al nome del form.

    # Antonio Pisano 2015-09-15: aggiunta la possibilita' di specificare una
    # callback nella pagina chiamante, che sara' eseguita prima che questa
    # finestrella si chiuda. Un esempio e' quando serve refreshare la pagina
    # chiamante per farle recuperare ulteriori informazioni in base al record
    # selezionato.

    # per questioni di sicurezza verifico che form_name contenga solo numeri o lettere. In questo modo impedisco
    # che venganno innestati dei javascript.
    #sim09 aggiunto -all
    if {[regexp {[^A-Za-z0-9]} [regsub -all "_" $form_name ""] ""]} {#sim06 if e suo contenuto
	return ""
    }

    
    set parms        [list]
    set instructions [list]
    
    foreach {p1 p2} $what_list {
	if {$p2 eq ""} {
	    set p2 $p1
	}
	# isolo le colonne della query in parms
	lappend parms        $p2
	lappend instructions "window.opener.document.$form_name.$p1.value = $p2;"
    }

    set parms        [join $parms         ,]
    set instructions [join $instructions \n]
    set function "
        <!-- java script per selezione -->
        <script language='JavaScript'>
            function sel($parms) {
                $instructions
                try {//ant01
                    window.opener.$callback;//ant01
                } catch (errore) {}//ant01
                window.close();
            }
        </script>"

    return $function
}

ad_proc iter_search_word {search_word} {
    manipola la parola di ricerca delle liste
    sostituisce gli * con % in modo da poter fare la like
} {
    regsub -all {\*} $search_word {%} search_word_1
    #  set search_word_1 [string trim $search_word_1]
    return $search_word_1
}

ad_proc iter_check_login {
    lvl
    nome
} {
    controllo se l'utente ha accesso al nome
    (che identifica una funzione di menu').
    Nel caso lo abbia, controllo se il suo livello gli permette di eseguire
    la funzione richiesta
} {
    iter_blocca_doppio_click;#nic02

    # la variabile login serve solo per la url da visualizzare nel messaggio
    # d'errore.
    set login [ad_conn package_url]

    # leggo il cookie dove e' memorizzato l'utente.
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    ns_log notice "simone location=[ns_conn location] id_utente=$id_utente login=$login"
    # se non ho trovato il cookie, id_utente e' vuoto e significa che
    # l'utente non ha effettuato il login
    if {[string equal $id_utente ""]} {
	#sim06S       iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di";#sim06S
        return 0
    }

    # nuovo
    # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente_loggato_vero [ad_get_client_property iter logged_user_id]
    set session_id [ad_conn session_id]
    set adsession [ad_get_cookie "ad_session_id"]
    set referrer [ns_set get [ad_conn headers] Referer]
    set clientip [lindex [ns_set iget [ns_conn headers] x-forwarded-for] end]

    # if {$id_utente_loggato_vero !=""} {
    if {$id_utente != $id_utente_loggato_vero} {
	set login [ad_conn package_url]
	ns_log Notice "*-*-*-*-*-*-*-* Login-KO-USER;$nome;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$adsession;"
	#sim06Siter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
	iter_return_complaint "Accesso non consentito! Per accedere a questo programma devi prima eseguire la procedura di";#sim06S
	return 0
    } else {
	# lo commento per non intasare i log-file error*
	# ns_log Notice "*-*-*-*-*-*-*-* Login-OK;ip-$clientip;$id_utente;$id_utente_loggato_vero;$session_id;$adsession;"
    }
    # }
    # ***

    # verifico se livello acceso al programma e' valido per l'utente   
    set provenienza [ns_conn url]
    set prog [file tail $provenienza]
    if {[db_0or1row sel_uten_join ""] == 0
    } {
	iter_return_complaint "
	        Spiacente, non &egrave; permesso l'accesso a questo programma."
	return
    } else {
	set lvl_idutente ""
	if {$lvl2 <= $lvl1} {
	    if {$lvl2 < $lvl} {
		iter_return_complaint "
		                Spiacente, utente non abilitato per questa funzione."
		return
	    }
	    lappend lvl_idutente $lvl2
	} else {
	    if {$lvl2 > $lvl1} {
		if {$lvl1 < $lvl} {
		    iter_return_complaint "
		                    Spiacente, utente non abilitato per questa funzione."
		    return
		} 
		lappend lvl_idutente $lvl1
	    } 
	}
    }    
    lappend lvl_idutente $id_utente
    return $lvl_idutente 
}

ad_proc -public iter_check_login_con_autorizzazioni_di_openacs_non_usata {
    {autlvl ""}
    {name   ""}
} { 
    Questa procedura rimpiazza la vecchia omonima con una gestione standard.
    Il parametro name viene dichiarato per compatibilità, ma non usato.
    Il parametro autlvl viene confrontato con la terza parola dell'unità organizzativa dell'utente per mantenere
    la compatibilità con la vecchia gestione delle autorizzazioni 
} {
    ad_maybe_redirect_for_registration

    set user_id  [ad_conn user_id]
    set username [db_string -cache_key $user_id username "select username from users where user_id = :user_id"]

    # ottengo automaticamente il nome del programma
    set script_name [ad_conn url]

    # sulla tabella scripts il nome comincia senza barra per cui la elimino
    regsub {/} $script_name {} script_name

    # se il nome termina con una barra, il server assume il pgm 'index' per cui
    # lo devo aggiungere
    if {[string range $script_name end end] eq "/"} {
	append script_name index
    }

    if {$script_name ne "iter/main"} {
	if {$autlvl eq "0"} {
	    ah::script_init -script_name $script_name -privilege read
	} else {
	    set user_group_id [db_string query "select distinct object_id_one from acs_rels r, persons pe where rel_type = 'membership_rel' and object_id_two = :user_id and object_id_one > 0" -default ""]
	    set group_name [db_string query "select group_name from groups where group_id = :user_group_id" -default ""]
	    set livello [lindex $group_name 2]
	    if {$livello eq "" || $livello < $autlvl} {
		iter_return_complaint "
		                Spiacente, utente non abilitato per questa funzione."
		return
	    } else {
		ah::script_init -script_name $script_name -privilege exec
	    }
	}
    } else {
	set autlvl "0"
    }
	    
    return [list $autlvl $username]
}

ad_proc -public iter_get_id_utente {
} { 
    Restituisce l'id_utente collegato (chiave della tabella coimuten).
} {
    # leggo il cookie dove e' memorizzato l'utente.
    set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    return $id_utente
}


ad_proc -public iter_get_id_utente_con_nuove_autorizzazioni_non_usato {
} { 
    Restituisce l'id_utente collegato (chiave della tabella/view coimuten).
    Ora va usata l'ad_conn user_id e non si puo' piu' leggere dai cookie.
    Dallo user_id di openacs ricavo l'id_utente di I.Ter.
} {
    set user_id  [ad_conn user_id]

    if {$user_id ne 0} {
	set username [db_string -cache_key $user_id username "select username from users where user_id = :user_id"]
    } else {
	set username ""
    }

    return $username
}


ad_proc iter_check_uten_manu {id_utente} {
    Verifica se l'utente e' un manutentore controllando che il settore e il ruolo corrispondano al menu' manutentore
} {
    set cod_manut ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "manutentore"
	    ||  $nome_menu == "resp-manutentore"
	    ||  $nome_menu == "ente-manutentore"
	} {
	    set lung_cod_uten [string length $id_utente]
	    set lung_cod_uten [expr $lung_cod_uten - 3]
	    set cod_manut [string range $id_utente 0 $lung_cod_uten ]
	}
    }
    iter_get_coimtgen
    if {$coimtgen(regione) eq "MARCHE"} {#ric01 aggiunta if e contenuto
	if {[db_0or1row q "select (coalesce(o.cognome, '') || ' ' || coalesce(o.nome, '')) as nome_opma
                                , (coalesce(m.cognome, '') || ' ' || coalesce(m.nome, '')) as nome_manu
                            from coimopma o
                               , coimmanu m
                           where cod_opma = :id_utente
                             and o.cod_manutentore = m.cod_manutentore
                             and (abilitazione_giuridica_p is null 
                                  or abilitazione_giuridica_p = 'f')"]} {

	    set logout_url "<center><a href=logout?nome_funz=logout>Logout</a></center>"
	    iter_return_complaint "$nome_opma, per poter operare sul gestionale è necessario avere un titolo giuridico VALIDO.<br>Rivolgersi alla ditta $nome_manu che deve dichiarare sul portale che puo' operare per suo conto.<br><br> Si ricorda che la modifica avrà effetto dopo 48 ore dopo l'inserimento.<br><br><br> $logout_url"
	}
    }
    return $cod_manut
}

ad_proc iter_check_uten_comu {id_utente} {
    Verifica se l'utente sia un comune controllando che il settore e il ruolo corrispondano al menu' comune
} {
    set cod_comu ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "ente-comune"} {
	    db_1row sel_cod_comune ""
	    set cod_comu $cod_comune
	}
    } 
    return $cod_comu
}

ad_proc iter_check_uten_opve {id_utente} {
    Verifica se l'utente e' un verificatore controllando che il settore e il ruolo corrispondano al menu' verificatore
} {
    set cod_opve ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "verificatore"
	    || $nome_menu == "ente-verificatore"} {
	    set cod_opve $id_utente
	}
    } 
    return $cod_opve
}

ad_proc iter_check_uten_coop_resp {id_utente} {
    Verifica se l'utente e' un responsabile cooperativa controllando che il settore e il ruolo corrispondano al menu' coop-resp
} {
    set cod_coop_resp ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "coop-resp"} {
	    set cod_coop_resp $id_utente
	}
    } 
    return $cod_coop_resp
}

ad_proc iter_check_uten_coop_modh {id_utente} {
    Verifica se l'utente e' un addetto all'inserimento mod.h della cooperativa controllando che il settore e il ruolo corrispondano al menu' coop-modh
} {
    set cod_coop_modh ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "coop-modh"} {
	    set cod_coop_modh $id_utente
	}
    } 
    return $cod_coop_modh
}

ad_proc iter_check_uten_coop_rappv {id_utente} {
    Verifica se l'utente e' un addetto all'inserimento rapp-ver della cooperativa controllando che il settore e il ruolo corrispondano al menu' coop-rappv
} {
    set cod_coop_rappv ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "coop-rappv"} {
	    set cod_coop_rappv $id_utente
	}
    } 
    return $cod_coop_rappv
}

ad_proc iter_check_uten_modh {id_utente} {
    Verifica se l'utente e' un addetto all'inserimento mod.h  controllando che il settore e il ruolo corrispondano al menu' Modelli H
} {
    set cod_uten_modh ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "Modelli H"} {
	    set cod_uten_modh $id_utente
	}
    } 
    return $cod_uten_modh
}

ad_proc iter_check_uten_enve {id_utente} {
    Verifica se l'utente e' un responsabile ente verificatore controllando che il settore e il ruolo corrispondano al menu' verificatore
} {
    set cod_enve ""
    if {[db_0or1row check_uten ""] == 1} {
	if {$nome_menu == "resp-verificatore"} {
	    set cod_enve $id_utente
	}
    } 
    return $cod_enve
}


ad_proc iter_set_double {number} {
    Tcl non fa bene i calcoli se un numero non contiene il . dei decimali.
    (si fuma tutti i decimali).
    Tcl non fa bene i confronti (if) se un numero non contiene il . dei 
    decimali e supera il valore dell'integer: supera le 9 cifre intere.
    Superata questa soglia considera la variabile come stringa.
} {
    set number [string trimleft $number 0]
    set ctr [string first {.} $number]
    if {$ctr < 0} {
        append number .0
        set ctr [expr [string length $number] - 2]
    }
    if {$ctr == 0} {
        set    out_number 0
        append out_number $number
    } else {
        set out_number $number
    }
    return $out_number
}

ad_proc iter_set_url_vars {param_list} {
    Trasformo in formato url le variabili passate da parametro.
    Usato nei gest per le extra_vars in modo da non sporcare le variabili
    del programma con quelle che servono alla lista.
} {
    set name_list ""
    foreach {name value} $param_list {
        set $name $value
        lappend name_list $name
    }

    set link [subst "\[export_url_vars $name_list\]"]

    return $link
}

ad_proc iter_set_sysdate {} {
    Restituisce la sysdate in formato data interna
} {
    set sysdate [clock format [clock seconds] -f %Y%m%d]
    return $sysdate
}

ad_proc iter_set_systime {
    -second:boolean
} {
    Restituisce il systime in formato hh24:mi
} {
    if {$second_p} {
	set systime [clock format [clock seconds] -f %H:%M:%S]
    } else {
	set systime [clock format [clock seconds] -f %H:%M]
    }
    return $systime
}

ad_proc iter_set_firstdate {} {
    Restituisce la minima data valida
} {
    return "00010101"
}

ad_proc iter_clean_href {href} {
    Toglie il link di un href restituisce solo il commento
} {
    regsub "<a(.*?)>" $href "" href
    regsub "</a>"     $href "" href
    return $href
}
###########
ad_proc iter_package_key {} {
    Restituisce la directory del package, che e' anche la package_key
} {
    return "iter"
}

ad_proc iter_set_package_www_dir {} {
    Restituisce la directory da usare prima di ad_return_template per
    il master 
} {
    set pack_dir [iter_package_key]
    set package_www_dir /packages/[iter_package_key]/www
    return $package_www_dir
}

ad_proc iter_set_spool_dir {} {
    Restituisce la directory in cui scrivere gli output delle stampe
} {
    set pack_dir [iter_package_key]
    set root_dir [acs_package_root_dir $pack_dir]
    set spool_dir ${root_dir}/www/spool
    return $spool_dir
}

ad_proc iter_set_spool_dir_url {} {
    Restituisce il link alla directory in cui sono scritti gli output
    delle stampe
} {
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    set spool_dir_url ${pack_dir}spool
    return $spool_dir_url
}

ad_proc iter_set_logo_dir {} {
    Restituisce la directory in cui sono localizzati i loghi
} {
    set pack_dir [iter_package_key]
    set root_dir [acs_package_root_dir $pack_dir]
    set logo_dir ${root_dir}/www/logo
    return $logo_dir
}

ad_proc iter_set_logo_dir_url {} {
    Restituisce l'url in cui sono localizzati i loghi
} {
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    set logo_dir ${pack_dir}/logo
    return $logo_dir
}

ad_proc iter_set_css_dir_url {} {
    Restituisce l'url in cui sono localizzati i css
} {
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    set css_dir ${pack_dir}
    return $css_dir
}
##########

ad_proc iter_set_permanenti_dir {} {
    Restituisce la directory in cui salvare file permanenti
} {
    set pack_dir [iter_package_key]
    set root_dir [acs_package_root_dir $pack_dir]
    set permanenti_dir $root_dir/www/permanenti
    return $permanenti_dir
}

ad_proc iter_set_permanenti_dir_url {} {
    Restituisce il link alla directory in cui sono scritti gli output
    delle stampe
} {
    set pack_key [iter_package_key]
    set pack_dir [apm_package_url_from_key $pack_key]
    set permanenti_dir_url ${pack_dir}permanenti
    return $permanenti_dir_url
}

ad_proc iter_del_conf {} {
    Restituisce il codice html/javascript per chiedere la conferma della canc.
} {
    set cmd_conf {{javascript:return(confirm('Confermi la cancellazione?'))}}
    return $cmd_conf
}

proc_doc iter_custom_form_selbox { nome_var lista_valori lista_descrizioni {valore_attributo ""} {flag_disabled ""} } {genera un selection box. Accetta in input:
    1. nome variabile 2.lista valori 3.lista descrizioni (puo' essere nulla e in 
							  questo caso si assumono come descrizione gli stessi valori) 4.valore attributo  5. flag disabled se valorizzato con "t" rendo la selbox disabled
    (si puo' omettere e viene usato per impostare l'opzione selected)} {
	# se lista descrizioni vuota la imposto come lista valori
	if {[llength $lista_descrizioni] == 0} {
	    set lista_descrizioni $lista_valori
	}

	if {$flag_disabled == "t"} {
	    set html "<select name=\"$nome_var\" disabled > \n"
	} else {
	    set html "<select name=\"$nome_var\"> \n"
	}
	foreach i $lista_valori j $lista_descrizioni {
	    if {$i == $valore_attributo} {
		append html "<option value=\"$i\" selected>$j \n"
	    } else {
		append html "<option value=\"$i\">$j \n"
	    }
	}
	append html "</select>"

	return $html
    }


ad_proc iter_selbox_from_comu {
    {key_orderby ""}
} {
    genera una list of list della tabella coimcomu; automaticamente, tramite la proc iter_get_coimtgen restituisce la lista dei comuni appartenenti alla provincia inserita nella tabella coimtgen; accetta in input  key_orderby
} {
    set table_name "coimcomu"
    set table_key  "cod_comune"
    set key_description "denominazione"

    iter_get_coimtgen
    set cod_provincia $coimtgen(cod_provincia)
    set where_condition "where cod_provincia = :cod_provincia and flag_val = 'T'"
    
    if {[string is space $key_orderby]} {
        set key_orderby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol_comu ""]
    set l_of_l [linsert $l_of_l   0 [list "" ""]]

    return $l_of_l
}

ad_proc iter_selbox_from_cqua {{key_orderby ""}} {genera una list of list della tabella coimcqua; automaticamente, tramite la proc iter_get_coimtgen restituisce la lista dei quartieri appartenenti al comune inserito nella tabella coimtgen; accetta in input  key_orderby } {
    
    iter_get_coimtgen
    set flag_ente $coimtgen(flag_ente)
    set cod_comune $coimtgen(cod_comu)
    if {$flag_ente == "P"} {
	set table_name "coimcqua a, coimcomu b"
	set table_key  "a.cod_qua"
	set key_description "b.denominazione||' '||a.descrizione"
	set where_condition "where b.cod_comune = a.cod_comune"
    } else {
	set table_name "coimcqua"
	set table_key  "cod_qua"
	set key_description "descrizione"
	set where_condition "where cod_comune = :cod_comune"
    }

    if {[string is space $key_orderby]} {
        set key_orderby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol_cqua ""]
    set l_of_l [linsert $l_of_l 0 [list "" ""]]

    return $l_of_l
}

ad_proc iter_selbox_from_curb {{key_orderby ""}} {genera una list of list della tabella coimcurb; automaticamente, tramite la proc iter_get_coimtgen restituisce la lista dei unita' urbane appartenenti al comune inserito nella tabella coimtgen; accetta in input  key_orderby } {
    
    set table_name "coimcqua"
    set table_key  "cod_qua"
    set key_description "descrizione"

    iter_get_coimtgen
    set flag_ente $coimtgen(flag_ente)
    set cod_comune $coimtgen(cod_comu)
    if {$flag_ente == "P"} {
	set table_name "coimcurb a, coimcomu b"
	set table_key  "a.cod_urb"
	set key_description "b.denominazione||' '||a.descrizione"
	set where_condition "where b.cod_comune = a.cod_comune"
    } else {
	set table_name "coimcurb"
	set table_key  "cod_urb"
	set key_description "descrizione"
	set where_condition "where cod_comune = :cod_comune"
    }

    if {[string is space $key_orderby]} {
        set key_orderby   $key_description
    }

    set l_of_l [db_list_of_lists sel_lol_curb ""]
    set l_of_l [linsert $l_of_l 0 [list "" ""]]

    return $l_of_l
}

ad_proc iter_get_nomefunz {nome_prog} {} {
    #Restituisce il nome_funz corrispondente al nome del programma inserito
    db_1row count_nome_funz ""
    if {$conta_nome_funz > 1} {
	ns_log  Error "iter_get_nomefunz Esistono piu' record con il nome programma inserito $nome_prog"
	iter_return_complaint "Spiacente, non vi � permesso l'accesso a questo programma."
    }
    if {$conta_nome_funz <= 0} {
	ns_log  Error "iter_get_nomefunz Non esistono record con il nome programma inserito $nome_prog"
	iter_return_complaint "Spiacente, non vi � permesso l'accesso a questo programma."
    }
    if {$conta_nome_funz == 1} {
	if {[db_0or1row get_nome_funz ""] == 0} {
	    set nome_funz ""
	}
    }
    return $nome_funz
}

ad_proc iter_get_pgm {nome_funz} {
} {
    # Restituisce il pgm corrispondente al nome della funzione
    set link ""
    if {[db_0or1row sel_funz ""] == 1} {
	set pack_key [iter_package_key]
	set pack_dir [apm_package_url_from_key $pack_key]
	set link "${pack_dir}${azione}${det}?nome_funz=$nome_funz"
	if {![string equal $parametri ""]} {
	    append link "&$parametri"
	}
    }
    return $link
}

ad_proc iter_get_coimtgen {
    {-dbn ""}
} {
    genera una lista con i dati generali dell'aplicazione: valid_mod_h= mesi validita mod h, gg_comunic_mod_h= max giorni comunicazione mod h; flag_ente= tipologia ente C = comune P = Provincia; cod_prov = cod provicnia; sigla_prov= sigla provincia; cod_comu= codice comune; denom_comune= denominazione comune; flag_viario = S con utilizzo del viario N senza viario; flag_mod_h_b utilizzo del modello h bis ; valid_mod_h_b; gg_comunic_mod_h_b; gg_conferma_inco = giordi di conferma per l'incontro; gg_scad_pag_mh= giorni scadenza pagamento_modelli h;gg_scad_pag_rv = giorni scadenza pagamento rapporti di verifica; mesi_evidenza_mod = mesi per evidenza modifiche; flag_agg_sogg = aggiornamento dei soggetti come conseguenza della modifica di questi ultimi sul modello H; flag_dt_scad = inserimento obligatorio della data di scadenza del pagamento sui modelli h, verifiche e tutte le gestioni dei pagamenti; flag_agg_da_verif = aggiornamento dei dati dell'impianto derivati dall'inserimento di un rapp. di verifica; flag_cod_aimp_auto= flag per la creazione automatica del codice impianto; flag_gg_modif_mh= giorni disponibili(da data inserimento) per modificare il modello h ; flag_gg_modif_rv= giorni disponibili(da data inserimento) per modificare il rapporti di verifica; gg_adat_anom_obblig = obligatorieta' della data scadenza per l'adattamento delle anomalie riscontrate nei mod H e rapporti di verifica; gg_adat_anom_autom = automazione del calcolo della data scadenza per l'adattamento delle anomalie riscontrate nei mod H e rapporti di verifica; popolaz_citt_tgen = numero dei cittadini dell'ente; popolaz_aimp_tgen = numero impianti dell'ente; flag_aimp_citt_estr= flag per calcolare la percentuale per il calcolo della statistica estrazioni basandosi sulla popolazione di abitanti o popolazione di impianti; flag_stat_estr_calc = flag per aggiungere nella statistica estrazione i calcoli;flag_cod_via_auto= flag per la creazione automatica del codice via; link_cap = link per il sito di ricerca del cap (di standard deve essere quello delle poste italiane); flag_enti_compet = flag per utilizzo enti competenti nella stampa esiti; flag_master_ente = Se N, il master non usa l'adp dell'ente ma quello generico col logo di Vestasoft per le demo;
    flag_stp_presso_terzo_resp; T/F; stampa l'indirizzo della ditta di manutenzione per il terzo responsabile;
    flag_portale (T/F): indica se l'istanza è collegata o meno ad iter-portal (per ora serve per inibile o meno la modifica del rappresentante legale di una ditta di manutenzione)
    flag_gest_coimmode (T/F): indica se gestire o meno i modelli di generatore sull'apposita anagrafica (coimmode) (se attivo, nelle form comparirà anche un'apposita tendina)
    ente: concatenazione di flag_ente e sigla_prov o denom_comune
    regione: denominazione della regione
    lun_num_cod_imp_est: Lungh. del progressivo nel codice impianto
    flag_potenza: Potenza da considerare per la fascia di potenza (pot_focolare_nom, pot_utile_nom).
    flag_portafoglio: Indica se gestire o meno il portafoglio dall'istanza di iter
    flag_obbligo_dati_catastali: Indica se i dati catastali sono obbligatori 
    flag_firma_manu_stampa_rcee - flag_firma_resp_stampa_rcee: Indicano se e' attiva la firma grafometrica nelle stampe rcee. 
    flag_firma_ispe_stampa_cimp - flag_firma_resp_stampa_cimp: Indicano se e' attiva la firma grafometrica nelle stampe dei rapporti di ispezione.
    flag_asse_data: Indica se e' attiva la gestione dell'agenda degli ispettori.
    
    -dbn: se lasciato vuoto, usa il dbn di default, altrimenti usa quello indicato.
} {
    if {[db_0or1row -dbn $dbn sel_tgen ""] == 1} {

        uplevel [list set coimtgen(valid_mod_h)        $valid_mod_h]
        uplevel [list set coimtgen(gg_comunic_mod_h)   $gg_comunic_mod_h]
        uplevel [list set coimtgen(cod_provincia)      $cod_prov]
        uplevel [list set coimtgen(cod_comu)           $cod_comu]
        uplevel [list set coimtgen(flag_ente)          $flag_ente]
        uplevel [list set coimtgen(flag_viario)        $flag_viario]
        uplevel [list set coimtgen(flag_mod_h_b)       $flag_mod_h_b]
        uplevel [list set coimtgen(valid_mod_h_b)      $valid_mod_h_b]
        uplevel [list set coimtgen(gg_comunic_mod_h_b) $gg_comunic_mod_h_b]
        uplevel [list set coimtgen(gg_conferma_inco)   $gg_conferma_inco]
        uplevel [list set coimtgen(gg_scad_pag_mh)     $gg_scad_pag_mh]
        uplevel [list set coimtgen(gg_scad_pag_rv)     $gg_scad_pag_rv]
        uplevel [list set coimtgen(mesi_evidenza_mod)  $mesi_evidenza_mod]
	uplevel [list set coimtgen(flag_agg_sogg)      $flag_agg_sogg]
	uplevel [list set coimtgen(flag_dt_scad)       $flag_dt_scad]
	uplevel [list set coimtgen(flag_agg_da_verif)  $flag_agg_da_verif]
	uplevel [list set coimtgen(flag_cod_aimp_auto) $flag_cod_aimp_auto]
        uplevel [list set coimtgen(flag_gg_modif_mh)   $flag_gg_modif_mh]
	uplevel [list set coimtgen(flag_gg_modif_rv)   $flag_gg_modif_rv]
	uplevel [list set coimtgen(gg_adat_anom_oblig) $gg_adat_anom_oblig]
	uplevel [list set coimtgen(gg_adat_anom_autom) $gg_adat_anom_autom]
        uplevel [list set coimtgen(popolaz_citt_tgen)  $popolaz_citt_tgen]
        uplevel [list set coimtgen(popolaz_aimp_tgen)  $popolaz_aimp_tgen]
        uplevel [list set coimtgen(flag_aimp_citt_estr) $flag_aimp_citt_estr]
        uplevel [list set coimtgen(flag_stat_estr_calc) $flag_stat_estr_calc]
        uplevel [list set coimtgen(flag_cod_via_auto)  $flag_cod_via_auto]
        uplevel [list set coimtgen(link_cap)           "<a target=cap href=$link_cap>Ricerca CAP</a>"]
	uplevel [list set coimtgen(flag_enti_compet)   $flag_enti_compet]
	uplevel [list set coimtgen(flag_master_ente)   $flag_master_ente]
        uplevel [list set coimtgen(gb_x)               $gb_x]
        uplevel [list set coimtgen(gb_y)               $gb_y]
        uplevel [list set coimtgen(delta)              $delta]
        uplevel [list set coimtgen(google_key)         $google_key]
        uplevel [list set coimtgen(flag_codifica_reg)  $flag_codifica_reg]
        uplevel [list set coimtgen(flag_pesi)          $flag_pesi]
        uplevel [list set coimtgen(flag_sanzioni)      $flag_sanzioni]
        uplevel [list set coimtgen(flag_avvisi)        $flag_avvisi]
	uplevel [list set coimtgen(cod_imst_annu_manu) $cod_imst_annu_manu]
	uplevel [list set coimtgen(max_gg_modimp)      $max_gg_modimp]
        uplevel [list set coimtgen(flag_stp_presso_terzo_resp) $flag_stp_presso_terzo_resp]
        uplevel [list set coimtgen(flag_portale)               $flag_portale];#11/12/2013
        uplevel [list set coimtgen(flag_gest_coimmode)         $flag_gest_coimmode];#nic03
        uplevel [list set coimtgen(lun_num_cod_imp_est)        $lun_num_cod_imp_est];#nic07
        uplevel [list set coimtgen(flag_potenza)               $flag_potenza];#nic08
	uplevel [list set coimtgen(flag_portafoglio)           $flag_portafoglio];#sim02
	uplevel [list set coimtgen(flag_gest_targa)            $flag_gest_targa];#sim04
	uplevel [list set coimtgen(flag_gest_rcee_legna)       $flag_gest_rcee_legna];#gab01
	uplevel [list set coimtgen(flag_verifica_impianti)     $flag_verifica_impianti];#gab02
        uplevel [list set coimtgen(flag_controllo_abilitazioni) $flag_controllo_abilitazioni];#rom12
        uplevel [list set coimtgen(login_spid_p)               $login_spid_p];#rom13
	uplevel [list set coimtgen(flag_firma_manu_stampa_rcee) $flag_firma_manu_stampa_rcee];#rom14
	uplevel [list set coimtgen(flag_firma_resp_stampa_rcee) $flag_firma_resp_stampa_rcee];#rom14
	uplevel [list set coimtgen(flag_firma_ispe_stampa_cimp) $flag_firma_ispe_stampa_cimp];#rom15
	uplevel [list set coimtgen(flag_firma_resp_stampa_cimp) $flag_firma_resp_stampa_cimp];#rom15
	uplevel [list set coimtgen(flag_asse_data)              $flag_asse_data]             ;#rom18
	uplevel [list set coimtgen(flag_cind)                   $flag_cind]                  ;#rom20
	uplevel [list set coimtgen(protocollo_automatico_ente)  $protocollo_automatico_ente] ;#rom21
	
	set regione    "";#nic06
	if {[db_0or1row -dbn $dbn sel_tgen_prov ""] == 1} {
	    uplevel [list set coimtgen(sigla_prov) $sigla_prov]
	    db_0or1row -dbn $dbn query "
            select denominazione as regione
              from coimregi
             where cod_regione = :cod_regione";#nic06
	} else {
	    uplevel [list set coimtgen(sigla_prov) "" ]
	    set sigla_prov "";#nic04
	}
	uplevel [list set coimtgen(regione) $regione];#nic06

	if {![string equal $cod_comu ""]
	&&  [db_0or1row -dbn $dbn sel_tgen_comu ""] == 1
	} {
	    uplevel [list set coimtgen(denom_comune) $denom_comu]
	} else {
	    uplevel [list set coimtgen(denom_comune) "" ]
	    set denom_comu "";#nic04
	}

	if {$flag_ente eq "P"} {#nic04: aggiunta questa if ed il suo contenuto
	    set ente "$flag_ente$sigla_prov"
	} else {
	    set ente "$flag_ente$denom_comu"
	}
	uplevel [list set coimtgen(ente) $ente];#nic04
	uplevel [list set coimtgen(flag_obbligo_dati_catastali) $flag_obbligo_dati_catastali];#sim07


    } else {
	return ""
    }
}

ad_proc iter_get_parameter {
    par_name
} {
    Restituisce il valore del parametro della procedura indicato
} {
    switch $par_name {
	"database" {
            db_with_handle db {
		set dbtype [ns_db dbtype $db]
		set dbtype [string range [string tolower $dbtype] 0 5]
            }
	    switch $dbtype {
		"postgr" {
		    set par_value "postgres"
		}
		"oracle" {
		    set par_value "oracle"
		}
		default {
		    set par_value ""
		}
	    }
	}
	default {
	    set par_value ""
	}
    }
    return $par_value
}

ad_proc iter_get_coimdesc {
    {-dbn ""}
} {genera una lista con i dati dell'ente competente: nome_ente, tipo ufficio, assessorato, indirizzo, telefono, responsabile, ufficio informazioni, dirigente

    -dbn: se lasciato vuoto, usa il dbn di default, altrimenti usa quello indicato.
} {
    if {[db_0or1row -dbn $dbn sel_desc ""] == 1} {
        uplevel [list set coimdesc(nome_ente)    $nome_ente]
        uplevel [list set coimdesc(tipo_ufficio) $tipo_ufficio]
        uplevel [list set coimdesc(assessorato)  $assessorato]
        uplevel [list set coimdesc(indirizzo)    $indirizzo]
        uplevel [list set coimdesc(telefono)     $telefono]
        uplevel [list set coimdesc(resp_uff)     $resp_uff]
        uplevel [list set coimdesc(uff_info)     $uff_info]
        uplevel [list set coimdesc(dirigente)    $dirigente]
	uplevel [list set coimdesc(email)        $email];#rom03
    } else {
	return ""
    }
}

########
ad_proc -public iter_temp_file_name {
    -permanenti:boolean
    file_name_inp
} {
    Accetta in input il nome di un file.
    Restituisce una variabile composta da
    1) la sottodirectory temporanea (odierna) alla directory spool
2) il nome del file accettato in input
3) data ed ora correnti
4) eventuale numero di due cifre per rendere il nome del file univoco

Il programma chiamante dovra' solo aggiungere l'estensione
del file e le directory spool_dir e spool_dir_url.

Se viene valorizzato lo switch -permanenti, allora al posto di spool
viene usato permenanti
} {
    set current_date [clock format [clock seconds] -f "%Y-%m-%d"]
    # metto il - nell'ora perche' i : danno problemi con Macintosh
    set current_time [clock format [clock seconds] -f "%H-%M-%S"]

    if {$permanenti_p} {
	set spool_dir [iter_set_permanenti_dir]
    } else {
	set spool_dir [iter_set_spool_dir]
    }
    set dir       "$spool_dir/$current_date"
    if {![file exists $dir]} {
        file mkdir $dir
    }
    
    set file_name_ws  "$current_date/$file_name_inp-$current_date-$current_time"
    set file_name_out "$file_name_ws"
    set ind 1
    while {[llength [glob -nocomplain -- $spool_dir/${file_name_out}*.*]] > 0
&&  $ind <= 99
} {
	set file_num ""
	if {$ind <= 9} {
	    append file_num "0"
	}
	append file_num $ind
	
	set file_name_out "$file_name_ws $file_num"
	incr ind
    }

if {$ind > 99} {
    iter_return_complaint "Il file che viene creato da questo processo esiste gi&agrave; sul file system. Attendere qualche secondo e riprovare."
    # succede solo se vi sono 100 processi dello stesso programma partiti
    # nello stesso secondo: impossibile
}
return $file_name_out
}

ad_proc -public iter_delete_tmp { } {
    Elimina le directory dove sono memorizzati i file temporanei.
    Sono le directory \[iter_set_spool_dir_url\]/date passate.
    Elimina solo le directory con data inferiore ad oggi.
} {
    ns_log notice "iter_delete_tmp: start ..."

    set current_date [clock format [clock seconds] -f "%Y-%m-%d"]

    set sub_dir           [iter_set_spool_dir]
    set lista_dir_date    [exec ls $sub_dir]
    set lista_dir_deleted ""
    foreach dir_date $lista_dir_date {
        set dir_to_del "$sub_dir/$dir_date"
        if {[file isdirectory $dir_to_del]
	    &&  $dir_date < $current_date
        } {
            file delete -force $dir_to_del
            lappend lista_dir_deleted $dir_to_del
        }
    }

    ns_log notice "iter_delete_tmp: stop: deleted [llength $lista_dir_deleted] directory: $lista_dir_deleted"
}

ad_proc -public iter_delete_permanenti { } {
    Elimina le directory dove sono memorizzati i file permanenti.
    Sono le directory \[iter_set_permanenti_dir_url\]/date passate.
    Elimina solo le directory con data inferiore ad una settimana fa.
    Elimina anche i batc terminati da oltre una settimana.
} {
    ns_log notice "iter_delete_permanenti: start ..."

    set dat_fine [clock format [clock scan "[clock format [clock seconds] -format "%D"] -1 week"] -f "%Y-%m-%d"]

    set esit_list ""
    db_foreach sel_esit {} {
	lappend esit_list $cod_batc $ctr $pat
    }

    # Lancio la query di cancellazione coimesit e coimbatc
    with_catch error_msg {
	db_transaction {
	    foreach {cod_batc ctr pat} $esit_list {
		file delete -force $pat
		db_dml del_esit {}
	    }
	    db_dml del_batc {}
	}
    } {
	ns_log Error "iter_delete_permanenti: errore cancellazione... $error_msg"
	return
    }

    # cancello le sottodirectory
    set sub_dir           [iter_set_permanenti_dir]
    set lista_dir_date    [exec ls $sub_dir]
    set lista_dir_deleted ""
    foreach dir_date $lista_dir_date {
        set dir_to_del "$sub_dir/$dir_date"
	ns_log Notice  "iter_delete_permanenti: test dir_date < dat_fine: $dir_date < $dat_fine"
        if {[file isdirectory $dir_to_del]
	    &&  $dir_date < $dat_fine
        } {
	    iter_get_coimtgen;#sim08
	    #sim08 su Marche non li cancello perchè li uso per gli allegati
	    #rom16 Aggiunta condizione di Palermo
	    #rom19 Aggiunta condizione di Napoli
	    if {$coimtgen(regione) ne "MARCHE" && !($coimtgen(ente) in [list "PPA" "PNA"]} {#sim08
		file delete -force $dir_to_del
		lappend lista_dir_deleted $dir_to_del
	    };#sim08
        }
    }

    ns_log notice "iter_delete_permanenti: stop: deleted [llength $lista_dir_deleted] directory: $lista_dir_deleted"
}

ad_proc -public iter_put_csv {
    file_id
    nome_variabile
    {separatore ";"}
} {
    Scrive un record di un file delimitato dal separatore di elenco indicato.
    
    Di default scrive i file csv con ;
    Le colonne dei file csv seguono queste regole:
    Se contiene punti e virgole o newline o carriage return deve essere contenuta tra doppi apici.
    In tale caso, se a sua volta contiene gia' dei doppi apici, questi devono essere raddoppiati.

    Legge i valori da scrivere dalla lista contenuta nella variabile di nome 'nome_variabile'.

    Scrive sempre il file csv con crlf.
} {
    set col_out_list ""

    upvar $nome_variabile col_list
    # se nome_variaibile non esiste non esistera' nemmeno col_list
    # ed il tutto verra' gestito con un normale abend tcl
    # esattamente come se il caller avesse utilizzato $nome_variabile

    foreach col_elem $col_list {
	if {[string first $separatore $col_elem] >= 0
	    ||  [string first \n          $col_elem] >= 0
	    ||  [string first \r          $col_elem] >= 0
	} {
	    # raddoppio gli eventuali doppi apici
	    regsub -all \" $col_elem \"\" col_elem
	    # includo l'elemento in due doppi apici
	    set col_elem \"$col_elem\"

	    # se la stringa contiene un 0d0a, all'interno di una colonna,
	    # grazie ai doppi apici il file e' scritto correttamente.
	    # peccato che excel pretenda di trovare solo degli 0a.
	    # in aggiunta anche il nostro ns_get_csv legge un file con
	    # fconfigure crlf e cambierebbe riga se trova uno 0d0a.
	    # trasformo quindi gli 0d0a in 0a in modo che tutto funzioni bene.
	    regsub -all \r\n $col_elem \n col_elem
	}
	lappend col_out_list $col_elem
    }

    set file_rec [join $col_out_list $separatore]
    append file_rec "\r\n"

    puts -nonewline $file_id $file_rec

    return
}

ad_proc -public iter_get_csv {
    file_id
    nome_variabile
    {separatore ";"}
} {
    Legge un record di un file delimitato dal separatore di elenco indicato.

    Di default legge i file csv con ;
    Le colonne dei file csv seguono queste regole:
    Se contiene punti e virgole o newline o carriage return deve essere contenuta tra doppi apici.
    Se a sua volta contiene gia' dei doppi apici, questi devono essere raddoppiati.

    Valorizza la variabile di nome 'nome_variabile' con la lista dei valori delimitati dal separatore di elenco.
    Restituisce -1 se si e' raggiunta la fine del file.
    In caso contrario restituisce il numero di elementi della lista.
} {
    # associo la variabile indicata alla variabile col_list
    upvar $nome_variabile col_list
    set col_list ""

    # leggo il record del file, restituisco -1 se si e' raggiunto il fine file
    gets $file_id file_rec
    if {[eof $file_id]} {
	return -1
    }

    # faccio un ciclo per leggere tutti i caratteri della riga letta
    set rec_length [string length $file_rec]
    set ind 0
    while {$ind < $rec_length} {
	set col_elem     ""
	set sw_primo_car "t"
	set sw_quote     "f"
	set sw_fine_col  "f"
	# dal ciclo interno esco con un break
	while {$ind < $rec_length &&  $sw_fine_col == "f"} {
	    # leggo il carattere nella posizione di $ind
	    set car [string range $file_rec $ind $ind] 

	    if {$sw_primo_car == "t"} {
		if {$car == "\""} {
		    set sw_quote "t"
 		}
	    }

	    if {$sw_quote == "f"} {
		# se trovo il separatore di elenco, la colonna e' finita
		# altrimenti aggiungo il carattere corrente alla colonna
		if {$car == $separatore} {
		    set sw_fine_col "t"
		} else {
		    append col_elem $car
		}
	    } else {
		# se l'elemento e' racchiuso da doppi apici,
		#  se il carattere contiene un doppio apice,
		#   se e' doppio, lo faccio diventare singolo.
		#   se e' singolo, significa che e' finito l'elemento.
		#   potrei far saltare addiritura il separatore seguente,
		#   ma mi limito a disinnescare sw_quote ed il ciclo sulla
		#   colonna dovrebbe disinnescarsi grazie al successivo
		#   separatore o grazie al termine della riga
		#  se il carattere non contiene un doppio apice, lo aggiungo
		#  alla colonna
		if {$sw_primo_car == "f"} {
		    if {$car == "\""} {
			set ind_succ [expr $ind + 1]
			set car_succ [string range $file_rec $ind_succ $ind_succ]
			if {$car_succ == "\""} {
			    # scrivo il primo doppio apice
			    # e salto il secondo
			    append col_elem $car
			    incr ind
			} else {
			    # e' finito il doppio apice
			    set sw_quote "f"
			}
		    } else {
			append col_elem $car
		    }
		} else {
		    # il primo doppio apice non lo scrivo
		}
	    }

	    # disinnesco lo sw_primo_car
	    set sw_primo_car "f"

	    # leggo il carattere successivo
	    incr ind

	};#fine ciclo sui caratteri della colonna
	
	lappend col_list $col_elem
    }

    # se l'ultimo carattere e' un ";", aggiungo un campo vuoto
    # perche' nel ciclo e' impossibile rilevarlo
    incr rec_length -1
    set car [string range $file_rec $rec_length $rec_length] 
    if {$car == $separatore} {
	lappend col_list ""
    }

    # restituisco la lunghezza di col_list
    return [llength $col_list]
}

ad_proc iter_lancia_batch {} {
    lancia i batch schedulati
} {
    ns_log  Notice  "Running  scheduled proc iter_lancia_batch"
    set current_date [iter_set_sysdate]
    set current_time [iter_set_systime -second]
    set lista_nom_prog ""

    db_foreach sel_batc "" {
	db_1row sel_count_batc ""
	if {$conta_batc == 0
	    && [lsearch $lista_nom_prog $nom_prog] < 0
	} {

	    lappend lista_nom_prog $nom_prog
	    set cmd [list ad_schedule_proc -once t 1 $nom_prog]

            lappend cmd "-cod_batc"
            lappend cmd  $cod_batc
            foreach {key value} $par {
		lappend cmd "-$key"
		lappend cmd   $value
	    }
	    eval $cmd
	    lappend lista_nom $nom_prog
	}
    }
    ns_log  Notice  "Finished scheduled proc iter_lancia_batch"
    return 
}

ad_proc iter_batch_upd_flg_sta {
    -iniz:boolean
    -fine:boolean
    -abend:boolean
    cod_batc
    {esit_list ""}
} {
    aggiorna lo stato della tabella coimbatc
} {
    set current_date [iter_set_sysdate]
    set current_time [iter_set_systime]

    if {$iniz_p} {
	set dml_sql  [db_map upd_iniz]
    }

    if {$fine_p} {
	set dml_sql  [db_map upd_fine]
    }

    if {$abend_p} {
	set dml_sql  [db_map upd_abend]
    }

    # Lancio la query di manipolazione dati contenute in dml_sql
    if {[info exists dml_sql]} {
	# non metto la with catch, dato che e' richiamato da una proc batch
	# e' corretto che l'errore venga lasciato sul log.
	db_transaction {
	    db_dml dml_coimbatc $dml_sql
	    set ctr 0
	    foreach esit_riga $esit_list {
		incr ctr
		set nom [lindex $esit_riga 0]
		set url [lindex $esit_riga 1]
		set pat [lindex $esit_riga 2]
		db_dml ins_esit ""
	    }
	}
    }
    return
}

ad_proc iter_httpget_wallet {
    url
} {
    esegue una chiamata http-get a wallet impostando dinamicamente l'indirizzo web
} {
    #set database [db_get_database]
    #if {$database eq "iterrl-dev"} {
	#set dyn_url "http://192.168.123.72/$url"
    #} elseif {$database eq "iterrl-sta"} {
	#set dyn_url "http://192.168.123.73/$url"
    #} else {
	#	set dyn_url "http://wallet.curit.it/$url"
    #}

    set url_portafoglio [parameter::get_from_package_key -package_key iter -parameter url_portafoglio]
    set dyn_url "$url_portafoglio/$url"

    set spool_dir     [iter_set_spool_dir];#sim05
    set nome_file_tmp "httpget_wallet";#sim05
    set nome_file_tmp [iter_temp_file_name $nome_file_tmp];#sim05

    set path_file_response "$spool_dir/${nome_file_tmp}-response.txt";#sim05
    set path_file_trace    "$spool_dir/${nome_file_tmp}-trace.txt";#sim05

    #sim05 aggiunto with_catch
    with_catch msg_err_curl {
	exec curl \
	    -vs \
	    -k \
	    -X GET \
	    --connect-timeout 100 \
	    --trace-ascii $path_file_trace \
	    $dyn_url > $path_file_response
    } {
        #Non e' un errmsg ma un debug
        ns_log Notice "iter_httpget_wallet;msg_err_curl:$msg_err_curl"
    }


    ns_log Notice "iter_httpget_wallet; ad_httpget -url $dyn_url -timeout 100"

    set file_id   [open $path_file_response r];#sim05
    fconfigure    $file_id -encoding utf-8;#sim05
    set response  [read $file_id];#sim05
    #restitusico la risposta come facva già prima la ad_httpget
    set response [list page $response  status ""  modified ""];#sim05
    return $response
#sim05    return [ad_httpget -url $dyn_url -timeout 100]
}

ad_proc iter_httpget_call_portale {
    url
} {
    esegue una chiamata https a un programma del portale
} {
    #set database [db_get_database]
    #if {$database eq "iterrl-dev"} {
	#set dyn_url "http://192.168.123.72/$url"
    #} elseif {$database eq "iterrl-sta"} {
	#set dyn_url "http://192.168.123.73/$url"
    #} else {
	#	set dyn_url "http://wallet.curit.it/$url"
    #}

    set dyn_url $url

    set spool_dir     [iter_set_spool_dir];#sim05
    set nome_file_tmp "httpget_call_portale";#sim05
    set nome_file_tmp [iter_temp_file_name $nome_file_tmp];#sim05

    set path_file_response "$spool_dir/${nome_file_tmp}-response.txt";#sim05
    set path_file_trace    "$spool_dir/${nome_file_tmp}-trace.txt";#sim05

    #sim05 aggiunto with_catch
    with_catch msg_err_curl {
	exec curl \
	    -vs \
	    -k \
	    -X GET \
	    --connect-timeout 100 \
	    --trace-ascii $path_file_trace \
	    $dyn_url > $path_file_response
    } {
        #Non e' un errmsg ma un debug
        ns_log Notice "iter_httpget_call_portale;msg_err_curl:$msg_err_curl"
    }


    ns_log Notice "iter_httpget_call_portale; ad_httpget -url $dyn_url -timeout 100"

    set file_id   [open $path_file_response r];#sim05
    fconfigure    $file_id -encoding utf-8;#sim05
    set response  [read $file_id];#sim05
    #restitusico la risposta come facva già prima la ad_httpget
    set response [list page $response  status ""  modified ""];#sim05
    return $response
#sim05    return [ad_httpget -url $dyn_url -timeout 100]
}


ad_proc -public iter_upd_stato_impianto {
} {
    Variazione automatica dello stato dell'impianto
} {
    ns_log notice "iter_upd_stato_impianto: start ..."
    
    db_dml query "update coimaimp set stato = 'A'  where stato ='D' and cod_impianto in (select cod_impianto from coimcimp)"
    db_dml query "update coimaimp set stato = 'A'  where stato ='D' and cod_impianto in (select cod_impianto from coimdimp)"
    
    ns_log notice "iter_upd_stato_impianto: stop"
}


ad_proc -public iter_blocca_doppio_click {
} {
    Verifica se è stato eseguito un doppio click e blocca il processo
} {
    # istruzioni copiate da alter-dev, ho cambiato solo il testo del messaggio

    # double click protection
#nic01 set my_url      [ad_conn url]
#nic01 set my_ip       [ad_conn peeraddr]
    set my_url      [ns_conn url];#nic01
    set my_ip       [ns_conn peeraddr];#nic01
#nic01 set connections [ns_server active]
    set connections [ns_server active];#nic01

    ns_log notice "LUCA1 connections $connections"

    #nic02: commento i Notice perchè ora è usata anche da iter_check_login
    #nic02 ns_log Notice "iter_blocca_doppio_click2;my_url     :$my_url"
    #nic02 ns_log Notice "iter_blocca_doppio_click;my_ip      :$my_ip"
    #nic02 ns_log Notice "iter_blocca_doppio_click:connections:$connections"
    set i 0
    foreach connection $connections {
        set ip  [lindex $connection 1]
        set url [lindex $connection 4]
	#nic02 ns_log Notice "iter_blocca_doppio_click;url     :$url"
	#nic02 ns_log Notice "iter_blocca_doppio_click;ip      :$ip"
	ns_log notice "LUCA ip $ip my_ip $my_ip    url $url my_url $my_url"
	
        if {$ip eq "$my_ip" && $url eq "$my_url"} {
            incr i
 	    #nic02 ns_log Notice "iter_blocca_doppio_click:incr i:$i"
        }
    }
    if {$i > 1} {
        #double click
	ns_log Notice "iter_blocca_doppio_click:bloccato"
        iter_return_complaint "Protezione da doppio click: l'operazione dovrebbe essere gi&agrave; stata eseguita (se non si sono verificati errori).
                              Torna indietro e verifica se l'operazione &egrave; stata veramente eseguita."
    }

}

ad_proc -public iter_subsite_group_list  {
    -url:required 
} { 
    Returns the list of groups belonging to the given subsite
    @param url The url of the subsite e.g. /intranet
} {
    # trovo il subsite 
    array set arr [site_node::get_from_url -url ${url}/]
    set context_id $arr(package_id)

    # ottengo il gruppo a cui appartengono, con relazione di
    # composizione, tutti gli altri gruppi 
    set subsite_group_id [application_group::group_id_from_package_id -package_id $context_id]

    return [db_list query "
    select object_id_two
    from acs_rels
    where rel_type      = 'composition_rel' and
          object_id_one = :subsite_group_id"]
}

ad_proc iter_check_login_portafoglio {
    lvl
    nome
} {
    sim03: Controllo se l'utente ha un portafoglio associato e se può acedervi
} {

    set id_utente [lindex [iter_check_login $lvl $nome] 1]

    #da aggiungere flag sull'operatore   
    if {![db_0or1row query "
        select m.cod_manutentore
             , m.wallet_id
             , o.flag_portafoglio_admin
          from coimopma o 
             , coimmanu m
         where o.matricola       = :id_utente
           and m.cod_manutentore = o.cod_manutentore
         "]
    } {
	iter_return_complaint "Spiacente: operatore manutentore non trovato"
	return 0
    }

    if {$wallet_id eq ""} {
	iter_return_complaint "Spiacente: alla ditta manutentrice non &egrave; associato un codice portafoglio"
	return 0
    }

    if {$flag_portafoglio_admin ne "T"} {
	iter_return_complaint "Spiacente: l'operatore della ditta di manutenzione non ha il flag \"Amministratore portafoglio\" valorizzato con S&igrave;."
	return 0
    }

    return $cod_manutentore
}

ad_proc iter_valid_impianti {

} {
    rom02 Validazione automatica degli impianti dopo n giorni che sono stati inseriti
} {
        ns_log notice "\n Inizio iter_valid_impianti"

    set oggi [ah::today_ansi]
    set gg_per_validazione "5"
 

    #Leggo gli impianti da validare, devono essere in stato 'F'
    db_foreach query "
           select data_ins as data_inserimento
                , cod_impianto
             from coimaimp 
            where stato ='F'
              and cod_impianto ='' --da togliere dopo i test.
    " {
	set gg  [db_string query "select :oggi::date - :data_inserimento::date"] 

	if {$gg >= $gg_per_validazione} {
	    db_dml q "update coimaimp set stato='A' where cod_impianto = :cod_impianto "
	    ns_log notice "validato impianto $cod_impianto"
	}
    }

    ns_log notice "\n Fine iter_valid_impianti"
}

   
ad_proc iter_permanenti_file_salva {
    file_da_salvare_tmpfile
    nome_file_originale
} {
    La proc ricevuto in input un file lo salva nella cartella dei permanenti e restituisce il suo path completo
} {

    
    set spool_dir_perm       [iter_set_permanenti_dir]
    
    set current_date [clock format [clock seconds] -f "%Y-%m-%d"]
    set current_time [clock format [clock seconds] -f "%H-%M-%S"]
    
    set nome_file  "$current_date-$current_time-$nome_file_originale"

    set dir "$spool_dir_perm/$current_date"
    
    if {![file exists $dir]} {
	file mkdir $dir
    }
    
    set path_file "$dir/$nome_file"   

    exec mv $file_da_salvare_tmpfile $path_file		

    return $path_file
}

ad_proc iter_check_mandatory_fields {
    cod_impianto
} {

} {

    set img_croce_rossa "<img src=\"/iter/logo/croce-rossa.png\" height=32>"
    set img_croce_verde "<img src=\"/iter/logo/spunta-verde.png\" height=32>"
    set img_croce_gialla "<img src=\"/iter/logo/spunta-gialla.png\" height=32>";#rom05
    
    set conta_imp      0
    set conta_imp_bis  0
    set conta_imp_bis_warning 0;#rom5
    set conta_imp_ubic 0
    set conta_imp_resp 0
    set conta_imp_gen  0
    set conta_imp_cimp 0

    db_1row sel_aimp "select data_libretto
          --  case when data_libretto = null then 'f' else 't' end  as data_libretto
            , coalesce(tipologia_intervento, 'f')                   as tipologia_intervento
            , coalesce(tipologia_generatore, 'f')                   as tipologia_generatore
            , coalesce(flag_ibrido, 'f')                            as flag_ibrido --rom09
            , coalesce(cod_proprietario, 'f')                       as cod_proprietario
            , coalesce(cod_occupante, 'f')                          as cod_occupante
            , coalesce(cod_amministratore, 'f')                     as cod_amministratore
            , coalesce(cod_responsabile, 'f')                       as cod_responsabile
            , coalesce(pod, 'f')                                    as pod
            , coalesce(pdr, 'f')                                    as pdr
            , coalesce(cod_tpim, 'f')                               as cod_tpim
            , coalesce (unita_immobiliari_servite, 'f')             as unita_immobiliari_servite
            , case when data_installaz = null then 'f' else 't' end as data_installaz
            , coalesce(toponimo, 'f')                               as toponimo
            , coalesce(indirizzo, 'f')                              as indirizzo
            , coalesce(cod_cted, 'f')                               as cod_cted
            , cod_combustibile                                      as db_cod_combustibile
            , flag_resp
	    , flag_tipo_impianto
            , data_installaz
         from coimaimp
        where cod_impianto = :cod_impianto
"
    #Controlli scheda 1 Dati Generali
    #rom09 Aggiunta condizione || flag_ibrido eq "f"
    #rom10 Tolta condizione di rom09
    if {$data_libretto eq "" || $tipologia_intervento eq "f" || $tipologia_generatore eq "f"} {#controlli su scheda 1
	incr conta_imp 
    }

    if {$flag_tipo_impianto in [list "R" "F"]} {#rom10 Aggiunta if e il suo contenuto
	if {$flag_ibrido eq "f"} {
	    incr conta_imp
	}
    }
    
    #Controlli scheda 1_bis
    #rom17if {$flag_tipo_impianto ne "F"} {
	if {$cod_tpim eq "f" || $unita_immobiliari_servite eq "f"} {
	    incr conta_imp_bis
	}
    #rom17}
    
    if {$pdr ne "f"} {
	if {[db_0or1row query "select 1
                                 from coimaimp
                                where pdr = :pdr
                                  and cod_impianto != :cod_impianto --deve essere un pdr diverso da se stesso
                                limit 1"] == 1} {
	    #rom05incr conta_imp_bis
	    incr conta_imp_bis_warning;#rom05
	    if {$pod eq "f"} {
		if {[db_0or1row q "select 1
                                     from coimcomb
                                    where tipo = 'G'
                                      and cod_combustibile = :db_cod_combustibile"] == 1} {
		    incr conta_imp_bis
		}		    
		if {$flag_tipo_impianto eq "F"} {
		    incr conta_imp_bis
		}
	    }
	}
    }
    if {$pdr eq "f"} {#rom06 aggiunta if e contenuto
	if {[string equal $db_cod_combustibile "5"]} {
	    incr conta_imp_bis
	}
    }	

    #rom06 devo controllare se esiste un pod uguale solo se è valorizzato if {$pod eq "f"} {}
    if {$pod ne "f"} {
	if {[db_0or1row query "select 1
                                 from coimaimp
                                where pod = :pod
                                  and cod_impianto != :cod_impianto --deve essere un pod diverso da se stesso
                                limit 1"] == 1} {
	    #rom05incr conta_imp_bis
	    incr conta_imp_bis_warning;#rom05
	}
    } else {#rom06 else e suo contenuto

	#il pod è obbligatorio su tutti gli impianti esclusi i gassosi
	if {![db_0or1row q "select 1
                             from coimcomb
                            where tipo = 'G'
                              and cod_combustibile = :db_cod_combustibile"]} {
	    incr conta_imp_bis
	}

	if {$db_cod_combustibile in [list "4" "21"]} {#rom07 Aggiunta if e suo contenuto
	    incr conta_imp_bis
	}

	#il pod è obbligatorio su tutti gli impianti del freddo
	if {$flag_tipo_impianto eq "F"} {
	    incr conta_imp_bis
	}
    }
    
    if {$data_installaz eq ""} {
	incr conta_imp_bis
    }
    switch $flag_resp {
	P {
	    if {$cod_proprietario eq "f"} {
		incr conta_imp_bis
	    }
	}
	O {
	    if {$cod_occupante eq "f"} {
		incr conta_imp_bis
	    }
	}
	A {
	    if {$cod_amministratore eq "f"} {
		incr conta_imp_bis
	    }
	}
	T {
	    if {$cod_responsabile eq "f"} {
		incr conta_imp_bis
	    }
	}
	    
    }
    
    if {$cod_proprietario eq "f"} {
	incr conta_imp_bis
    }

	
    #Controlli scheda 1.2 Ubicazione
    if {$toponimo eq "f" || $indirizzo eq "f" || $cod_cted eq "f"} {
	incr conta_imp_ubic
    }
    
    if {![db_0or1row sel_as_resp "select 1 
                                    from coim_as_resp
                                   where cod_impianto = :cod_impianto limit 1"]} {
	incr conta_imp_resp
    }

    #rom08 La x rossa va mostrata nel caso in cui non ci siano generatori attivi in un impianto attivo.
    if {![db_0or1row aimp_gend "select 1 
                                  from coimgend
                                 where cod_impianto = :cod_impianto
                                   and flag_attivo  = 'S'
                                 limit 1"] &&
	![db_0or1row aimp "select 1 
                             from coimaimp
                            where cod_impianto = :cod_impianto
                              and stato       != 'A'"]} {

	incr conta_imp_gen
    }
    db_foreach sel_gend "select data_installaz                                            as gen_data_installaz
           -- case when data_installaz = null then 'f' else 't' end                       as data_installaz
            , coalesce(cod_cost, 'f')                                                     as cod_cost
            , coalesce(modello, 'f')                                                      as modello 
            , coalesce(matricola, 'f')                                                    as matricola 
            , coalesce(cod_combustibile, 'f')                                             as cod_combustibile 
            , case when num_prove_fumi = null or num_prove_fumi = 0 then 'f' else 't' end as num_prove_fumi
            , case when num_circuiti   = null or num_circuiti   = 0 then 'f' else 't' end as num_circuiti 
            , coalesce(mod_funz, 'f')                                                     as mod_funz
            , case when pot_focolare_nom     = null then 'f' else 't' end                 as pot_focolare_nom
            , case when pot_utile_nom        = null then 'f' else 't' end                 as pot_utile_nom
            , case when pot_focolare_lib     = null then 'f' else 't' end                 as pot_focolare_lib 
            , case when pot_utile_lib        = null then 'f' else 't' end                 as pot_utile_lib     
            , case when pot_utile_nom_freddo = null then 'f' else 't' end                 as pot_utile_nom_freddo
            , case when rend_ter_max = null then 'f' else 't' end                         as rend_ter_max 
            , coalesce(marc_effic_energ, 'f')                                             as marc_effic_energ 
            , case when data_costruz_gen = null then 'f' else 't' end                     as data_costruz_gen 
            , coalesce(locale, 'f')                                                       as locale
            , coalesce(tipo_foco, 'f')                                                    as tipo_foco 
            , coalesce(dpr_660_96, 'f')                                                   as dpr_660_96 
            , coalesce(tiraggio, 'f')                                                     as tiraggio 
            , coalesce(tipologia_cogenerazione, 'f')                                      as tipologia_cogenerazione
            , coalesce(flag_prod_acqua_calda, 'f')                                        as flag_prod_acqua_calda 
            , coalesce(flag_clima_invernale, 'f')                                         as flag_clima_invernale
            , coalesce(flag_clim_est, 'f')                                                as flag_clim_est
            , coalesce(tel_alimentazione, 'f')                                            as tel_alimentazione
            , coalesce(cod_flre, 'f')                                                     as cod_flre
            , coalesce(sorgente_lato_esterno, 'f')                                        as sorgente_lato_esterno
            , coalesce(fluido_lato_utenze, 'f')                                           as fluido_lato_utenze
            , coalesce(cod_tpco, 'f')                                                     as cod_tpco
            , case when per = null then 'f' else 't' end                                  as per
            , case when cop = null then 'f' else 't' end                                  as cop
         from coimgend
        where cod_impianto = :cod_impianto
          and flag_attivo = 'S'" {
	
	if {$gen_data_installaz eq "" ||
	    $modello eq "f" ||
	    $matricola eq "f" ||
	    ($locale eq "f" && $flag_tipo_impianto ne "C" && $flag_tipo_impianto ne "T") ||
	    $cod_cost eq "f" ||
	    $cod_combustibile eq "f" } {
	    incr conta_imp_gen

	}

	if {$flag_clima_invernale ne "S" && $flag_clim_est ne "S" && $flag_prod_acqua_calda ne "S"} {
	    incr conta_imp_gen
	}
	if {$flag_prod_acqua_calda eq " " ||
	    $flag_clima_invernale  eq " " ||
	    $flag_clim_est         eq " " ||
	    $flag_prod_acqua_calda eq "f" ||
	    $flag_clima_invernale  eq "f" ||
	    $flag_clim_est         eq "f" } {
	    incr conta_imp_gen
	}
	
	switch $flag_tipo_impianto {
	    R {
		if {[db_0or1row q "select 1
                                     from coimcomb
                                    where upper(tipo) != 'S'
                                      and cod_combustibile=:cod_combustibile"]
		    && $dpr_660_96 eq "f"} {#mic01 Aggiunta if e il suo contenuto
		    # Il dpr 660 96 deve essere obbligatorio solo se il combustibile non è solido
		    incr conta_imp_gen
		}
		#mic01 Tolta condizione || $dpr_660_96 eq "f"
		if {$mod_funz eq "f" ||
		    $num_prove_fumi eq "f" ||
		    $pot_focolare_nom eq "f" ||
		    $pot_utile_nom eq "f" ||
		    $rend_ter_max eq "f" ||
		    $data_costruz_gen eq "f" ||
		    $tipo_foco eq "f" ||
		    $tiraggio eq "f" 
		} {
		    incr conta_imp_gen
		}
		if {$marc_effic_energ eq "f" && $gen_data_installaz > "2015-01-01"} {
		    incr conta_imp_gen
		}
	    }
	    F {
		if {$cod_flre eq "f" ||
		    $sorgente_lato_esterno eq "f" ||
		    $fluido_lato_utenze eq "f" ||
		    $cod_tpco eq "f" ||
		    $num_circuiti eq "f" ||
		    $per eq "f" ||
		    $cop eq "f" ||
		    $pot_focolare_nom eq "f" ||
		    $pot_utile_nom_freddo eq "f" ||
		    $pot_focolare_lib eq "f" ||
		    $pot_utile_lib eq "f"
		} {
		    incr conta_imp_gen
		}
	    }		
	    T {
		if {$mod_funz eq "f" ||
		    $tel_alimentazione eq "f" ||
		    $pot_focolare_nom eq "f"
		} {
		    incr conta_imp_gen
		}
	    }
	    C {
		if {$tipologia_cogenerazione eq "f" ||
		    $mod_funz eq "f" ||
		    $pot_utile_nom eq "f" ||
		    $pot_focolare_nom eq "f"
		} {
		    incr conta_imp_gen
		}
	    }
	}
    }

    if {![db_0or1row sel_cimp "select 1 from coimcimp where cod_impianto = :cod_impianto limit 1"]} {
	incr conta_imp_cimp
   }



    set telefono ""
    set cellulare ""
    set fax ""
    set email ""
    set pec ""
    #responsabile
    db_0or1row q "select b.cod_tpim
                           , b.unita_immobiliari_servite
                           , b.pdr
                           , b.pod 
                           , a.nome
                           , a.cognome
                           , a.natura_giuridica
                           , flag_resp
                           , a.indirizzo 
                           , a.comune
                           , a.provincia
                           , a.cap
                           , a.telefono
                           , a.cellulare
                           , a.fax
                           , a.email
                           , a.pec
                           , b.data_libretto
                           , b.cod_proprietario --rom04
	                from coimcitt a
                           , coimaimp b
                       where a.cod_cittadino = b.cod_responsabile
                         and b.cod_impianto = :cod_impianto"

    	if {[string is space $telefono] && [string is space $cellulare] && [string is space $fax] && [string is space $email] && [string is space $pec]} {

	    incr conta_imp_bis
	}
    
    if {$conta_imp > 0} {
	uplevel [list set img_imp $img_croce_rossa]
    } else {
	uplevel [list set img_imp $img_croce_verde]
    }
    if {$conta_imp_bis > 0} {
	uplevel [list set img_imp_1bis $img_croce_rossa]
    } else {
	uplevel [list set img_imp_1bis $img_croce_verde]
	if {$conta_imp_bis_warning > 0} {#rom05 aggiunta if e suo contenuto
	    uplevel [list set img_imp_1bis $img_croce_gialla]
	};#rom05
    }
    if {$conta_imp_ubic > 0} {
	uplevel [list set img_ubic $img_croce_rossa]
    } else {
	uplevel [list set img_ubic $img_croce_verde]
    }

    if {$conta_imp_resp > 0} {
	#rom05uplevel [list set img_resp $img_croce_rossa]
	uplevel [list set img_resp $img_croce_gialla];#rom05
    } else {
	uplevel [list set img_resp $img_croce_verde]
    }
    if {$conta_imp_gen > 0} {
	uplevel [list set img_gen    $img_croce_rossa]
    } else {
	uplevel [list set img_gen    $img_croce_verde]
    }
    if {$conta_imp_cimp > 0} {
	#rom05uplevel [list set img_cimp $img_croce_rossa]
	uplevel [list set img_cimp $img_croce_gialla];#rom05
    } else {
	uplevel [list set img_cimp $img_croce_verde]
    }


}
