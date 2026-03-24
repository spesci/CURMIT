ad_page_contract {
    Bonifica impianti

    @author                  Giulio Laurenzi
    @creation-date           23/08/2005

    @param search_word       parola da ricercare con una query

    @param rows_per_page     una delle dimensioni della tabella  

    @param caller            se diverso da index rappresenta il nome del form da cui è partita
    @                        la ricerca ed in questo caso imposta solo azione "sel"

    @param nome_funz         identifica l'entrata di menu, serve per le autorizzazioni

    @param receiving_element nomi dei campi di form che riceveranno gli argomenti restituiti
    @                        dallo script di zoom, separati da '|' ed impostarli come segue:

    @cvs-id coimbimp-gest.tcl 

    USER  DATA       MODIFICHE
    ===== ========== ======================================================================================================
    ric01 08/09/2025 Punto 16 MEV regione Marche: aggiungo sulle note del nuovo impianto i codici degli impianti di provenienza.
    ric01            Modifica valida per tutti gli enti.

    sim03 22/05/2017 Personaliz. per Comune di Jesi: ricodificare gli impianti come da Legge Reg. Marche CMJE.
    sim03            Per Comune di Senigalli: CMSE

    gab03 12/04/2017 Personaliz. per Provincia di Ancona: ricodificare gli impianti come da Legge Reg. Marche PRAN.

    gab02 08/02/2017 Personaliz. per Comune di Ancona: ricodificare gli impianti come da Legge Reg. Marche CMAN.

    gab01 31/10/2016 Aggiunta bonifica dei dati delle sezioni: 4.3, 4.7, 4.8, 6, 7, 8.1, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 10.1
    gab01            del libretto.

    sim02 28/09/2016 Taranto ha il codice impianto composto dalle ultime 3 cifre del codice
    sim02            istat + un progressivo

    nic02 04/02/2016 Gestito coimtgen.lun_num_cod_impianto_est per regione MARCHE

    sim01 28/09/2015 Da ottobre 2015 gli enti della regione marche devono costruire il codice
    sim01            impianto con una sigla imposta dalla regione (es: CMPS) + un progressivo
    sim01            di 6 cifre.

    nic01 19/02/2014 Su richiesta di UCIT, vanno copiati anche i record della tab. coimnoveb.
    nic01            Inoltre, Sandro vuole aggiungere alle note degli impianti bonificati
    nic01            questa dicitura: "Bonificato il dd/mm/yyyy; codice dell'impianto di destinazione: cod_impianto_est"

} { 
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {search_word          ""}
    {cod_impianto_est_new ""}
    {f_resp_cogn          ""} 
    {f_resp_nome          ""} 
    {f_comune             ""}
    {f_cod_via            ""}
    {f_cod_manu           ""}
    {f_manu_cogn          ""}
    {f_manu_nome          ""}
    {f_desc_via           ""}
    {f_desc_topo          ""}
    {destinazione         ""}
    {compatta_list        ""}
}  -properties {
    page_title:onevalue
    context_bar:onevalue
    list_head:onevalue
    table_result:onevalue
}

# Controlla lo user
if {![string is space $nome_funz]} {
    set lvl        1
    set id_utente [lindex [iter_check_login $lvl $nome_funz] 1]
} else {
    # se la lista viene chiamata da un cerca, allora nome_funz non viene passato
    # e bisogna reperire id_utente dai cookie
    #set id_utente [ad_get_cookie   iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
    if {$id_utente  == ""} {
	set login [ad_conn package_url]
        iter_return_complaint "Per accedere a questo programma devi prima eseguire la procedura di <a href=$login>Login.</a>"
        return 0
    }
}

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# acquisisco i parametri generali
iter_get_coimtgen
set flag_ente           $coimtgen(flag_ente)
set sigla_prov          $coimtgen(sigla_prov)
set flag_viario         $coimtgen(flag_viario)
set flag_codifica_reg   $coimtgen(flag_codifica_reg)
set lun_num_cod_imp_est $coimtgen(lun_num_cod_imp_est);#nic02

set page_title  "Inserimento Autocertificazione - Bonifica Impianti"
set context_bar [iter_context_bar -nome_funz $nome_funz_caller]
set mex_error ""

# preparo link per ritorna al filtro:
set link_list [export_url_vars caller nome_funz nome_funz_caller cod_comune search_word cod_impianto_est_new f_resp_cogn f_resp_nome f_comune f_cod_via f_desc_via f_desc_topo f_manu_cogn f_manu_nome f_cod_manu]


# sproteggo la chiave solo in inserimento e gli attributi in inserimento e mod.
set form_name    "coimbimp"
set readonly_key "readonly"
set readonly_fld "readonly"
set disabled_fld "disabled"
set onsubmit_cmd ""
set button_label "Conferma"

form create $form_name \
    -html    $onsubmit_cmd

element create $form_name nome_funz            -widget hidden -datatype text -optional
element create $form_name nome_funz_caller     -widget hidden -datatype text -optional
element create $form_name search_word          -widget hidden -datatype text -optional
element create $form_name caller               -widget hidden -datatype text -optional
element create $form_name submit               -widget submit -datatype text -label "$button_label" -html "class form_submit"
element create $form_name destinazione         -widget hidden -datatype text -optional
element create $form_name compatta_list        -widget hidden -datatype text -optional
element create $form_name cod_impianto_est_new -widget hidden -datatype text -optional
element create $form_name f_resp_cogn          -widget hidden -datatype text -optional
element create $form_name f_resp_nome          -widget hidden -datatype text -optional
element create $form_name f_comune             -widget hidden -datatype text -optional
element create $form_name f_cod_via            -widget hidden -datatype text -optional
element create $form_name f_desc_via           -widget hidden -datatype text -optional
element create $form_name f_desc_topo          -widget hidden -datatype text -optional
element create $form_name f_manu_cogn          -widget hidden -datatype text -optional
element create $form_name f_manu_nome          -widget hidden -datatype text -optional
element create $form_name f_cod_manu           -widget hidden -datatype text -optional

# stabilisco l'ordinamento ed uso una inner join al posto di una outer join
# sulle tabelle dove uso un filtro (Ottimizzazione solo per postgres)
set citt_join_pos "left outer join"
set citt_join_ora "(+)"

if {![string equal $f_resp_cogn ""]
||  ![string equal $f_resp_nome ""]
|| (   [string equal $f_cod_via   ""]
    && [string equal $f_desc_topo ""]
    && [string equal $f_desc_via  ""])
} {
    set ordine        "nome"
    set citt_join_pos "inner join"
    set citt_join_ora ""
} else {
    set ordine "via"
}

if {[db_0or1row sel_aimp_stato_cod_est ""] == 0} {
    set stato_aimp_destinazione ""
    set cod_impianto_est_destinazione ""
}

if {$flag_ente == "P"
&&  $sigla_prov == "LI"
&&  $stato_aimp_destinazione != "A"
&&  [db_0or1row sel_aimp_check_cod_est ""] == 1
} {
    set error_msg "<font color=red><b>Il nuovo codice impianto $cod_impianto_est_new &egrave; gi&agrave; presente sul data base</b></font>"
} else {
    set error_msg ""
}


# imposto l'ordinamento della query e la condizione per la prossima pagina
#set col_numero "to_number(a.numero,'99999999')"
set col_numero "lpad(a.numero, 8, '0')"

switch $ordine {
    "via" {
	switch $flag_viario {
	    "T" {set col_via "d.descrizione"}
	    "F" {set col_via "a.indirizzo" }
	}
        set ordinamento "order by $col_via, $col_numero, a.cod_impianto_est"
    }
    "nome"   {
	set ordinamento "order by b.cognome, b.nome, a.cod_impianto_est"
    }
    default {
	set ordinamento ""
    }
}


set form_request {
    element set_properties $form_name search_word          -value $search_word
    element set_properties $form_name nome_funz            -value $nome_funz
    element set_properties $form_name nome_funz_caller     -value $nome_funz_caller
    element set_properties $form_name destinazione         -value $destinazione
    element set_properties $form_name compatta_list        -value $compatta_list
    element set_properties $form_name cod_impianto_est_new -value $cod_impianto_est_new    
    element set_properties $form_name f_resp_cogn          -value $f_resp_cogn
    element set_properties $form_name f_resp_nome          -value $f_resp_nome
    element set_properties $form_name f_comune             -value $f_comune 
    element set_properties $form_name f_cod_via            -value $f_cod_via
    element set_properties $form_name f_desc_via           -value $f_desc_via
    element set_properties $form_name f_desc_topo          -value $f_desc_topo
    element set_properties $form_name f_manu_cogn          -value $f_manu_cogn
    element set_properties $form_name f_manu_nome          -value $f_manu_nome
    element set_properties $form_name f_cod_manu           -value $f_cod_manu

    set aimp_da_compattare "<table border=1  class=table_s>
                           <tr>
                              <th>Responsabile</th>
                              <th>Comune</th>
                              <th>Indirizzo</th>
                           </tr>
                           "
    if {$flag_viario == "T"} {
	set sql_impianto sel_aimp_vie
    } else {
	set sql_impianto sel_aimp_no_vie
    }

    foreach cod_impianto $compatta_list {
	if {[db_0or1row $sql_impianto ""] == 1} {
	    append aimp_da_compattare "<tr>
                                         <td>$resp</td>
                                         <td>$comune</td>
                                         <td>$indir</td>
                                      </tr>"
	}
    }
    append aimp_da_compattare "</table>"
    set cod_impianto $destinazione 
    if {[db_0or1row  $sql_impianto ""] == 0} {
	#	set descr_topo ""
	#	set descr_estesa ""
    }
    if {![string equal $cod_impianto_est_new ""]} {
	set codice_tab1 "<th>Codice</th>"
	set codice_tab2 "<td>$cod_impianto_est_new</td>"
    } else {
	set codice_tab1 ""
	set codice_tab2 ""
    }

    set aimp_destinazione "<table border=1 class=table_s>
                          <tr>
                              $codice_tab1
                              <th>Responsabile</th>
                              <th>Comune</th>
                              <th>Indirizzo</th>
                          </tr>
                          <tr>
                              $codice_tab2
                              <td>$resp</td>
                              <td>$comune</td>
                              <td>$indir</td>
                          </tr>
                          </table>"
}

set form_valid {
    # estraggo il nuovo codice
    if {$flag_codifica_reg == "T"} {
        #gab03 aggiunto alle condizioni la provincia di Ancona
        #gab02 aggiunto alle condizioni il comune di Ancona
	if {$coimtgen(ente) eq "CPESARO" || $coimtgen(ente) eq "PPU" || $coimtgen(ente) eq "CFANO" || $coimtgen(ente) eq "CANCONA" || $coimtgen(ente) eq "PAN" || $coimtgen(ente) eq "CJESI" || $coimtgen(ente) eq "CSENIGALLIA"} {#sim01: aggiunta if ed il suo contenuto
	    if {$coimtgen(ente) eq "CPESARO"} {
		set sigla_est "CMPS"
	    } elseif {$coimtgen(ente) eq "CFANO"} {
		set sigla_est "CMFA"
	    } elseif {$coimtgen(ente) eq "CANCONA"} {;#gab02
		set sigla_est "CMAN"
	    } elseif {$coimtgen(ente) eq "PAN"} {;#gab03
		set sigla_est "PRAN"
	    } elseif {$coimtgen(ente) eq "CJESI"} {;#sim03
		set sigla_est "CMJE"
	    } elseif {$coimtgen(ente) eq "CSENIGALLIA"} {;#sim03
		set sigla_est "CMSE"
	    } else {
		set sigla_est "PRPU"
	    }
	    
	    set progressivo_est [db_string sel "select nextval('coimaimp_est_s')"]
	    
	    # devo fare l'lpad con una seconda query altrimenti mi va in errore
	    #nic02 set progressivo_est [db_string sel "select lpad(:progressivo_est,6,'0')"]
	    set progressivo_est [db_string sel "select lpad(:progressivo_est,:lun_num_cod_imp_est,'0')"];#nic02

	    set cod_impianto_est_new "$sigla_est$progressivo_est"

	} else {#sim01
	    # caso standard
	    db_1row sel_dati_codifica ""

	    if {$coimtgen(ente) eq "PMS"} {#sim02: Riportato modifiche fatte per Massa in data 03/12/2015 per gli altri programmi dove e' presente la codifica dell'impianto 
		set progressivo [db_string query "select lpad(:progressivo, 5, '0')"]
		set cod_istat  "[string range $cod_istat 5 6]/"
	    } elseif {$coimtgen(ente) eq "PTA"} {#sim02: aggiunta if e suo contenuto
		set progressivo [db_string query "select lpad(:progressivo, 7, '0')"]
		set fine_istat  [string length $cod_istat]
		set iniz_ist    [expr $fine_istat -3]
		set cod_istat  "[string range $cod_istat $iniz_ist $fine_istat]"
	    } else {
		#sim02: la sel_dati_comu andava in errore sul lpad di progressivo.Quindi faccio lpad dopo la query
		set progressivo [db_string query "select lpad(:progressivo, 7, '0')"];#sim02
	    }

	    if {![string equal $potenza "0.00"]} {
		if {$potenza < 35} {
		    set tipologia "IN"
		} else {
		    set tipologia "CT"
		}
		set cod_impianto_est_new "$cod_istat$progressivo"
		set dml_comu [db_map upd_prog_comu]
	    } else {
		if {![string equal $cod_potenza "0"]
		    &&  ![string equal $cod_potenza ""]} { 
		    switch $cod_potenza {
			"B"  {set tipologia "IN"}
			"A"  {set tipologia "CT"}
			"MA" {set tipologia "CT"}
			"MB" {set tipologia "CT"}
		    }
		    
		    set cod_impianto_est_new "$cod_istat$progressivo"
		    set dml_comu [db_map upd_prog_comu]
		} else {
		    set cod_impianto_est_new ""
		}
	    }
	};#sim01
    } else {
	db_1row get_cod_impianto_est ""
    }

    set dml_ins_cimp [db_map ins_cimp]
    set dml_ins_coma [db_map ins_coma]
    set dml_ins_dimp [db_map ins_dimp]
    set dml_ins_noveb [db_map ins_noveb];#nic01
    set dml_ins_docu [db_map ins_docu]
    set dml_upd_gage [db_map upd_gage]
    set dml_ins_gend [db_map ins_gend]
    set dml_upd_inco [db_map upd_inco]
    set dml_ins_inco [db_map ins_inco]
    set dml_ins_movi [db_map ins_movi]
    set dml_ins_prvv [db_map ins_prvv]
    set dml_ins_rife [db_map ins_rife]
    set dml_ins_stub [db_map ins_stub]
    set dml_ins_todo [db_map ins_todo]
    set dml_ins_recu_cond [db_map ins_recu_cond];#gab01
    set dml_ins_camp_sola [db_map ins_camp_sola];#gab01
    set dml_ins_altr_gend [db_map ins_altr_gend];#gab01
    set dml_ins_accu [db_map ins_accu];#gab01
    set dml_ins_torr_evap [db_map ins_torr_evap];#gab01
    set dml_ins_raff [db_map ins_raff];#gab01
    set dml_ins_scam_calo [db_map ins_scam_calo];#gab01
    set dml_ins_circ_inte [db_map ins_circ_inte];#gab01
    set dml_ins_trat_aria [db_map ins_trat_aria];#gab01
    set dml_ins_recu_calo [db_map ins_recu_calo];#gab01
    set dml_ins_vent [db_map ins_vent];#gab01
    set dml_ins_vasi_espa [db_map ins_vasi_espa];#gab01
    set dml_ins_pomp_circ [db_map ins_pomp_circ];#gab01     

    set dml_upd_aimp [db_map upd_aimp] 
    set dml_ins_aimp [db_map ins_aimp] 
    set dml_ins_anom [db_map ins_anom]

    foreach cod_impianto $compatta_list {
	set list_dimp($cod_impianto)  [list]
	set list_noveb($cod_impianto) [list];#nic01
	set list_cimp($cod_impianto)  [list]
        set list_recu_cond($cod_impianto) [list];#gab01
        set list_camp_sola($cod_impianto) [list];#gab01
        set list_altr_gend($cod_impianto) [list];#gab01
	set list_accu($cod_impianto) [list];#gab01
        set list_torr_evap($cod_impianto) [list];#gab01
        set list_raff($cod_impianto) [list];#gab01
        set list_scam_calo($cod_impianto) [list];#gab01
        set list_circ_inte($cod_impianto) [list];#gab01
        set list_trat_aria($cod_impianto) [list];#gab01
        set list_recu_calo($cod_impianto) [list];#gab01
        set list_vent($cod_impianto) [list];#gab01
        set list_vasi_espa($cod_impianto) [list];#gab01
        set list_pomp_circ($cod_impianto) [list];#gab01

	db_foreach sel_dimp_cod "" {
	    lappend list_dimp($cod_impianto) $cod_dimp
	}
	db_foreach sel_noveb_cod "" {;#nic01
	    lappend list_noveb($cod_impianto) $cod_noveb;#nic01
	};#nic01
	db_foreach sel_cimp_cod "" {
	    lappend list_cimp($cod_impianto) $cod_cimp
	}
        db_foreach sel_recu_cond_cod "" {;#gab01
            lappend list_recu_cond($cod_impianto) $cod_recu_cond_aimp;#gab01
        };#gab01
        db_foreach sel_camp_sola_cod "" {;#gab01
            lappend list_camp_sola($cod_impianto) $cod_camp_sola_aimp;#gab01
        };#gab01
        db_foreach sel_altr_gend_cod "" {;#gab01
            lappend list_altr_gend($cod_impianto) $cod_altr_gend_aimp;#gab01
        };#gab01
        db_foreach sel_accu_cod "" {;#gab01
            lappend list_accu($cod_impianto) $cod_accu_aimp;#gab01
        };#gab01
        db_foreach sel_torr_evap_cod "" {;#gab01
            lappend list_torr_evap($cod_impianto) $cod_torr_evap_aimp;#gab01
        };#gab01
        db_foreach sel_raff_cod "" {;#gab01
            lappend list_raff($cod_impianto) $cod_raff_aimp;#gab01
        };#gab01
	db_foreach sel_scam_calo_cod "" {;#gab01
            lappend list_scam_calo($cod_impianto) $cod_scam_calo_aimp;#gab01
        };#gab01
        db_foreach sel_circ_inte_cod "" {;#gab01
            lappend list_circ_inte($cod_impianto) $cod_circ_inte_aimp;#gab01
        };#gab01
        db_foreach sel_trat_aria_cod "" {;#gab01
            lappend list_trat_aria($cod_impianto) $cod_trat_aria_aimp;#gab01
        };#gab01
        db_foreach sel_recu_calo_cod "" {;#gab01
            lappend list_recu_calo($cod_impianto) $cod_recu_calo_aimp;#gab01
        };#gab01
	db_foreach sel_vent_cod "" {;#gab01
            lappend list_vent($cod_impianto) $cod_vent_aimp;#gab01
        };#gab01
	db_foreach sel_vasi_espa_cod "" {;#gab01
            lappend list_vasi_espa($cod_impianto) $cod_vasi_espa_aimp;#gab01
        };#gab01
        db_foreach sel_pomp_circ_cod "" {;#gab01
            lappend list_pomp_circ($cod_impianto) $cod_pomp_circ_aimp;#gab01
        };#gab01
    }

    with_catch error_msg {

   	db_transaction {
            if {[info exists dml_comu]} {
                db_dml dml_coimcomu $dml_comu
            }

	    if {$stato_aimp_destinazione != "A"} {
		db_1row sel_aimp_cod ""
		db_dml dml_ins_aimp $dml_ins_aimp
		db_dml dml_gend     $dml_ins_gend
		db_dml dml_rife     $dml_ins_rife
		db_dml dml_stub     $dml_ins_stub
		db_dml dml_movi     $dml_ins_movi
		db_dml dml_gage     $dml_upd_gage
		db_dml dml_prvv     $dml_ins_prvv
	    } else {
		set cod_impianto_new $destinazione
	    }

	    db_1row query "select cod_impianto_est as cod_impianto_est_destinazione
                             from coimaimp
                            where cod_impianto = :cod_impianto_new";#nic01

	    if {$stato_aimp_destinazione != "A"} {
		db_dml dml_ins_inco $dml_ins_inco
	    }

	    foreach cod_impianto $compatta_list {

		db_1row cod_imp_est_old "select cod_impianto_est as cod_impianto_est_old
                                           from coimaimp
                                          where cod_impianto = :cod_impianto";#ric01
		lappend ls_cod_imp_est_old $cod_impianto_est_old;#ric01

		db_1row query "select note
                                 from coimaimp
                                where cod_impianto = :cod_impianto";#nic01

		set testo_da_aggiungere_alle_note "Bonificato il [iter_edit_date [iter_set_sysdate]]; codice dell'impianto di destinazione: $cod_impianto_est_destinazione."

		if {[string is space $note]} {;#nic01
		    set note $testo_da_aggiungere_alle_note;#nic01
		} else {;#nic01
		    append note "\n$testo_da_aggiungere_alle_note";#nic01
		    set note [string range $note 0 3999];#nic01: non posso superare i 4000 byte altrimenti l'update va in errore
		};#nic01

		db_dml dml_aimp $dml_upd_aimp
		db_dml dml_coma $dml_ins_coma	
		db_dml dml_docu $dml_ins_docu

		if {$flag_ente == "P" && $sigla_prov == "LI"} {
		    set destinazione_save $destinazione
		    set destinazione $cod_impianto
		    db_dml dml_inco $dml_ins_inco
		    set destinazione $destinazione_save
		} else {
		    db_dml dml_inco $dml_upd_inco
		}

		db_dml dml_todo $dml_ins_todo

		foreach cod_cimp $list_cimp($cod_impianto) {
		    db_1row sel_cimp_cod_new ""
		    db_dml dml_cimp $dml_ins_cimp
		    set cod_cimp_dimp_new $cod_cimp_new
		    set cod_cimp_dimp $cod_cimp
		    db_dml dml_anom $dml_ins_anom
		}

                foreach cod_dimp $list_dimp($cod_impianto) {
		    db_1row sel_dimp_cod_new ""
		    db_dml dml_dimp $dml_ins_dimp
		    set cod_cimp_dimp_new $cod_dimp_new
		    set cod_cimp_dimp $cod_dimp
		    db_dml dml_anom $dml_ins_anom
		}
		
                foreach cod_noveb $list_noveb($cod_impianto) {;#nic01
		    db_1row sel_noveb_cod_new "";#nic01
		    db_dml dml_noveb $dml_ins_noveb;#nic01
		}
		
                foreach cod_recu_cond_aimp $list_recu_cond($cod_impianto) {;#gab01
                    db_1row sel_recu_cond_cod_new "";#gab01
                    db_1row sel_recu_cond_rc_new "";#gab01
                    db_dml dml_recu_cond $dml_ins_recu_cond;#gab01
                }
              
		foreach cod_camp_sola_aimp $list_camp_sola($cod_impianto) {;#gab01
                    db_1row sel_camp_sola_cod_new "";#gab01
                    db_1row sel_camp_sola_cs_new "";#gab01
                    db_dml dml_camp_sola $dml_ins_camp_sola;#gab01
                }

                foreach cod_altr_gend_aimp $list_altr_gend($cod_impianto) {;#gab01
                    db_1row sel_altr_gend_cod_new "";#gab01
                    db_1row sel_altr_gend_ag_new "";#gab01
                    db_dml dml_altr_gend $dml_ins_altr_gend;#gab01
                }
    
		foreach cod_accu_aimp $list_accu($cod_impianto) {;#gab01
                    db_1row sel_accu_cod_new "";#gab01
                    db_1row sel_accu_ac_new "";#gab01
                    db_dml dml_accu $dml_ins_accu;#gab01
                }
                
                foreach cod_torr_evap_aimp $list_torr_evap($cod_impianto) {;#gab01
                    db_1row sel_torr_evap_cod_new "";#gab01
                    db_1row sel_torr_evap_te_new "";#gab01
                    db_dml dml_torr_evap $dml_ins_torr_evap;#gab01
                }
        
                foreach cod_raff_aimp $list_raff($cod_impianto) {;#gab01
                    db_1row sel_raff_cod_new "";#gab01
                    db_1row sel_raff_rv_new "";#gab01
                    db_dml dml_raff $dml_ins_raff;#gab01
                }

                foreach cod_scam_calo_aimp $list_scam_calo($cod_impianto) {;#gab01
                    db_1row sel_scam_calo_cod_new "";#gab01
                    db_1row sel_scam_calo_sc_new "";#gab01
                    db_dml dml_scam_calo $dml_ins_scam_calo;#gab01
                }
       
                foreach cod_circ_inte_aimp $list_circ_inte($cod_impianto) {;#gab01
                    db_1row sel_circ_inte_cod_new "";#gab01
                    db_1row sel_circ_inte_ci_new "";#gab01
                    db_dml dml_circ_inte $dml_ins_circ_inte;#gab01
                }

                foreach cod_trat_aria_aimp $list_trat_aria($cod_impianto) {;#gab01
                    db_1row sel_trat_aria_cod_new "";#gab01
                    db_1row sel_trat_aria_ut_new "";#gab01
                    db_dml dml_trat_aria $dml_ins_trat_aria;#gab01
                }

                foreach cod_recu_calo_aimp $list_recu_calo($cod_impianto) {;#gab01
                    db_1row sel_recu_calo_cod_new "";#gab01
                    db_1row sel_recu_calo_rc_new "";#gab01
                    db_dml dml_recu_calo $dml_ins_recu_calo;#gab01
                }
   
                foreach cod_vent_aimp $list_vent($cod_impianto) {;#gab01
                    db_1row sel_vent_cod_new "";#gab01
		    db_1row sel_vent_vm_new "";#gab01
                    db_dml dml_vent $dml_ins_vent;#gab01
                }
  
		foreach cod_vasi_espa_aimp $list_vasi_espa($cod_impianto) {;#gab01
                    db_1row sel_vasi_espa_cod_new "";#gab01
                    db_1row sel_vasi_espa_vx_new "";#gab01
                    db_dml dml_vasi_espa $dml_ins_vasi_espa;#gab01
                }

                foreach cod_pomp_circ_aimp $list_pomp_circ($cod_impianto) {;#gab01
                    db_1row sel_pomp_circ_cod_new "";#gab01
                    db_1row sel_pomp_circ_po_new "";#gab01
                    db_dml dml_pomp_circ $dml_ins_pomp_circ;#gab01
                }
	    
	    }

	    db_1row query "select note as note_destinazione
                             from coimaimp
                            where cod_impianto = :destinazione";#ric01

	    set label_destinazione "codice dell'impianto";#ric01
	    if {[llength $ls_cod_imp_est_old] > 1} {#ric01 aggiunta if e contenuto
		set label_destinazione "codici degli impianti"
		set ls_cod_imp_est_old [join $ls_cod_imp_est_old ", "]
	    }
	    
	    set testo_da_aggiungere_alle_note_di_destinazione "Da bonifica del [iter_edit_date [iter_set_sysdate]]; $label_destinazione di provenienza: $ls_cod_imp_est_old.";#ric01

	    if {[string is space $note_destinazione]} {#ric01 aggiunta if,else e contenuto
		set note_destinazione $testo_da_aggiungere_alle_note_di_destinazione
	    } else {
		append note_destinazione "\n$testo_da_aggiungere_alle_note_di_destinazione"
		set note_destinazione [string range $note_destinazione 0 3999]
	    }

	    set dml_upd_aimp_destinazione [db_map upd_aimp_destinazione];#ric01
	    db_dml dml_aimp_destinazione $dml_upd_aimp_destinazione;#ric01
	    
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

    set return_url   "coimaimp-gest?funzione=V&[export_url_vars nome_funz_caller search_word cod_impianto_est_new]&nome_funz=[iter_get_nomefunz coimaimp-list]&cod_impianto=$cod_impianto_new"    

    ad_returnredirect -message "Bonifica avvenuta correttamente" $return_url
    ad_script_abort
}

if {[string equal $compatta_list ""]} {
    eval $form_valid
} else {
    if {[form is_request $form_name]} {    
	eval $form_request            
    }
    if {[form is_valid $form_name]} {
	eval $form_valid
    }
}

db_release_unused_handles
ad_return_template 
