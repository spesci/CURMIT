ad_page_contract {
    Stampa modulo A e B impianto
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coimnoveb-layout.tcl

    @param cod_noveb

    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    ric01 21/03/2023 Commentato i flag relativi all'art. 11 perchè abrogati (non per regione Marche)

    rom01 02/03/2023 Settati alcuni campi di default per evitare errori nella stampa.

    gac01 22/11/2018 Modificato modello A della stampa con aggiunta di vari campi solo per
    gac01            regione marche
    
} {
    {cod_noveb            ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {cod_impianto         ""}
} -properties {
    page_title:onevalue
    context_bar:onevalue
    form_name:onevalue
}

# Controlla lo user
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

set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]

set link_tab      [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab      [iter_tab_form $cod_impianto]
set logo_dir      [iter_set_logo_dir]
#set logo_dir "/www/logo"

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_dimp caller nome_funz_caller nome_funz cod_impianto  url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set page_title       "Stampa Allegato art. 284"

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

set checked "<img src=$logo_dir/check-in.gif height=12>"
set not_checked "<img src=$logo_dir/check-out.gif height=12>"

iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)

if {$flag_viario == "T"} {
    set sel_aimp_2 "sel_aimp_si_viae"
} else {
    set sel_aimp_2 "sel_aimp_no_viae"
}

if {[db_0or1row $sel_aimp_2 ""] == 0} {
    iter_return_complaint "Impianto non trovato"
} else {
    if {[db_0or1row sel_noveb ""] == 0} {
	iter_return_complaint "Allegato non trovato"
    } else {
	#rom01 Settati i default dei campi.
	set flag_a ""
	set flag_c ""
	set flag_e ""
	set reg_imprese ""
	set localita_reg ""
	set cod_legale_rapp ""
	set cognome_manu ""
	set nome_manu ""
	set piva ""
	set indirizzo_manu ""
	set provincia_manu ""
	set comune_manu ""
	set telefono ""
	set fax ""
	set email ""

	if {[string range $cod_manutentore 0 1] == "MA"} {
	    db_0or1row sel_dati_manu ""
	} else {
	    db_0or1row sel_dati_citt ""
	}

	if {$flag_art_3 == "t"} {
	    set flag_art_3 $checked
	} else {
	    set flag_art_3 $not_checked
	}
	if {$flag_art_11 == "t"} {
	    set flag_art_11 $checked
	} else {
	    set flag_art_11 $not_checked
	}
        if {$flag_patente_abil == "t"} {
            set flag_patente_abil $checked
        } else {
            set flag_patente_abil $not_checked
        }
        if {$flag_art_11_comma_3 == "t"} {
            set flag_art_11_comma_3 $checked
        } else {
            set flag_art_11_comma_3 $not_checked
        }
	if {$flag_installatore == "t"} {
	    set flag_installatore $checked
	} else {
	    set flag_installatore $not_checked
	}
	if {$flag_responsabile == "t"} {
	    set flag_responsabile $checked
	} else {
	    set flag_responsabile $not_checked
	}
	if {$flag_manutentore == "t"} {
	    set flag_manutentore $checked
	} else {
	    set flag_manutentore $not_checked
	}
        if {$flag_rispetta_val_min == "t"} {
	    set flag_rispetta_val_min $checked
	} else {
	    set flag_rispetta_val_min $not_checked
	}
	if {[string equal $n_generatori ""]} {
	    set n_generatori "&nbsp;"
	}
        if {[string equal $dich_conformita_nr ""]} {
            set dich_conformita_nr "&nbsp;"
            set flag_dich_conform $not_checked
        } else {
	    set flag_dich_conform $checked
        } 	
	if {[string equal $data_dich_conform ""]} {
	    set data_dich_conform "&nbsp;"
	}
        if {$flag_libretto_centr == "t"} {
            set flag_libretto_centr $checked
        } else {
            set flag_libretto_centr $not_checked
        }
        if {[string equal $firma_dichiarante ""]} {
            set firma_dichiarante "&nbsp;"
        }
	if {[string equal $data_dichiarazione ""]} {
	    set data_dichiarazione "&nbsp;"
	}
	if {[string equal $firma_responsabile ""]} {
	    set firma_responsabile "&nbsp;"
	}
	if {[string equal $data_ricevuta ""]} {
	    set data_ricevuta "&nbsp;"
	}
	if {[string equal $regolamenti_locali ""]} {
	    set regolamenti_locali "&nbsp;"
	}
        if {$flag_verif_emis_286 == "S"} {
            set verif_emis_286_si $checked
            set verif_emis_286_no $not_checked
        } else {
            set verif_emis_286_si $not_checked
            set verif_emis_286_no $checked
        }
	if {[string equal $data_verif_emiss ""]} {
	    set data_verif_emiss "&nbsp;"
	}
	if {[string equal $risultato_mg_nmc_h ""]} {
            set risultato_mg_nmc_h "&nbsp;"
        }
	if {[string equal $data_alleg_libretto ""]} {
            set data_alleg_libretto "&nbsp;"
        }
	if {[string equal $combustibili ""]} {
            set combustibili "&nbsp;"
        }
        if {$flag_risult_conforme == "S"} {
            set risultato_conforme_si $checked
            set risultato_conforme_no $not_checked
        } else {
            set risultato_conforme_si $not_checked
            set risultato_conforme_no $checked
	}
        if {[string equal $pot_term_tot_mw ""]} {
            set pot_term_tot_mw "&nbsp;"
        }

	db_1row q "select cod_utgi from coimgend where cod_impianto = :cod_impianto limit 1";#gac01
	if {$cod_utgi eq "RA"} {#gac01 aggiunta if e suo contenuto
	    set riscaldamento_ambienti $checked
	} else {
	    set riscaldamento_ambienti $not_checked
	}
	if {$cod_utgi eq "D"} {#gac01 aggiunta if e suo contenuto
	    set produzione_acs $checked
	} else {
	    set produzione_acs $not_checked
	}

	if {$flag_dichiarante eq "L"} {#gac01 aggiunto if, elseif e else e loro contenuto
	    set legale_rapp $checked
	    set resp_tecnico $not_checked
	    set tecnico_spec $not_checked
	} elseif {$flag_dichiarante eq "R"} {
	    set legale_rapp $not_checked
	    set resp_tecnico $checked
	    set tecnico_spec $not_checked
	} elseif {$flag_dichiarante eq "T"} {
	    set legale_rapp $not_checked
	    set resp_tecnico $not_checked
	    set tecnico_spec $checked
	} else {
	    set legale_rapp $not_checked
	    set resp_tecnico $not_checked
	    set tecnico_spec $not_checked
	}

	if {$flag_a eq "t"} {
	    set flag_a_c $checked
	} else {
	    set flag_a_c $not_checked
	}
        if {$flag_c eq "t"} {
	    set flag_c_c $checked
	} else {
	    set flag_c_c $not_checked
	}
	if {$flag_e eq "t"} {
	    set flag_e_c $checked
	} else {
	    set flag_e_c $not_checked
	}

	if {$coimtgen(regione) eq "MARCHE"} {
	    #allegato IX B
	    set stampa2 "
    <font size = 2>
    <table width=100%>
        <tr><td align=center><b></b></td></tr>
        <tr><td align=right><b>modulo A</b></td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=center>DICHIARAZIONE PER IMPIANTI TERMICI CIVILI DI POTENZA TERMICA NOMINALE AL FOCOLARE > 35 kW</td></tr>
        <tr><td align=center>(D.Lgs. 152/06 art. 284)</td></tr>
        <tr><td align=center><i>Da allegare alla dichiarazione di conformità per nuova installazione o modifica (art. 284 c.1); e da allegare al Libretto d'impianto</td></tr>
        <tr><td align=center>per gli impinati in esercizio (art.284 c.2);</td></tr>
        <tr><td>Data $data_consegna &nbsp;&nbsp; Luogo $luogo_consegna</td>
        </tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>Relativamente all'impianto rtermico adibito a: riscaldameto abienti $riscaldamento_ambienti &nbsp;&nbsp; produzione di acqua calda sanitaria $produzione_acs
        <tr><td align=left>Catasto impianti/codice: $cod_impianto_est sito in via $indir</td></tr>
        <tr><td align=left>di potenza termica nominale utile complessiva pari a $potenza_utile kW n° gruppi termici $n_generatori_marche Combustibile: $combustibile</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Il sottoscritto $cognome_dichiarante $nome_dichiarante</td></tr>
        <tr><td align=left>in qualità di: Legale rappresentante $legale_rapp &nbsp;&nbsp; Responsabile tecnico $resp_tecnico &nbsp;&nbsp; Tecnico specializzato $tecnico_spec</td></tr>
        <tr><td align=left>della ditta $cognome_manu $nome_manu</td></tr>
        <tr><td align=left>con sede in via $indirizzo_manu Comune $comune_manu</td></tr>
        <tr><td align=left>Provincia $provincia_manu</td></tr>
        <tr><td align=left>Telefono $telefono  &nbsp;&nbsp; Fax $fax  &nbsp;&nbsp; Email $email</td></tr>
        <tr><td align=left>Iscritta alla CCIAA di $localita_reg al numero $reg_imprese</td></tr>
        <tr><td align=left>abilitata ad operare per gli impianti di cui alle lettere a)$flag_a_c c)$flag_c_c e)$flag_e_c &nbsp;&nbsp; dell'articolo 1 del D.M. 37/08,</td></tr>
        <tr><td align=left>$flag_installatore <i>(per gli impianti di nuova installazione)</i> in qualita di <b>installatore</b> dell'impianto di cui sopra, dichiara che lo stesso  è dotato dell'attestazione del costruttore prevista all'articolo 282, comma 2-bis del D. Lgs 152/2006        </td></tr>
        <tr><td align=left>$flag_rispetta_val_min <i>(solo per impianti alimentati a legna, carbone, biomasse combustibili, biogas) rispetta i valori limite di emissione prevista dall'articolo 286 del D. Lgs. 152/2006.</td></tr>
        <tr><td align=left>$flag_manutentore  <i>(per gli impianti già in esercizio)</i> in qualita di <b>manutentore/terzo responsabile</b> dell'impianto di cui sopra, dichiara che lo stesso  è conforme alle caratteristiche tecninche di cui all'art. 285 ed è idoneo a rispettare ivalori di cui all'art. 286 del D.Lgs. 152/06.</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>In possesso dei requisiti di cui: $flag_art_3 al D.M. 22/01/2008 n. 37 art. 3 &nbsp;&nbsp; $flag_art_11 al DPR 412/93 art. 11</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Ed in possesso inoltre dei seguenti ulteriori requisiti:</td></tr>
        <tr><td align=left>$flag_patente_abil patentino di abilitazione per la conduzione di impianti termici (obbligatorio per Portata Termica Nominale > 0,232 MW previsto dal DL 152/2006 e ss.mm.ii.(art. 287))</td></tr>
        <tr><td align=left>$flag_art_11_comma_3 requisiti di cui al DPR 412/93 art. 11 comma 3</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Dichiara, ai sensi di quanto previsto dal D.Lgs. 152/06 art. 284 e ss.mm.ii.</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>che l'impianto e' conforme alle caratteristiche tecniche di cui all'art. 285 del D.Lgs. 152/06, come specificate nella parte II dell'allegato IX alla parte V del Decreto citato.</td></tr>
        <tr><td align=left>che l'impianto e' idoneo a rispettare i valori di cui all'art. 286 del D.Lgs. 152/06, come specificate nella parte III dell'allegato IX alla parte V del Decreto citato.</td></tr>
        <tr><td>&nbsp;</td></tr>
     
   <tr><td align=left>Il presente documento viene allegato a:</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$flag_dich_conform Dichiarazione di conformit&agrave; nr. $dich_conformita_nr del $data_dich_conform</td></tr>
        <tr><td align=left>$flag_libretto_centr Libretto di centrale</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Il Dichiarante</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>$firma_dichiarante &nbsp; Data, $data_dichiarazione</td></tr>
        <tr><td>&nbsp;</td></tr>
         <tr><td align=left>Per ricevuta e presa visione</td></tr>
         <tr><td align=left>Il responsabile dell'impianto</td></tr>
        <tr><td>$firma_responsabile &nbsp; Data, $data_ricevuta</td></tr>
       "
	} else {
	    set stampa2 "
    <font size = 2>
    <table width=100%>
        <tr><td align=center><b></b></td></tr>
        <tr><td align=right><b>modulo A prot. $n_prot  del $dat_prot</b></td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=center><b>ATTO DI DICHIARAZIONE PER IMPIANTI TERMICI CIVILI DI POTENZA TERMICA NOMINALE > 0,035 MW</b></td></tr>
        <tr><td align=center><b>(D.Lgs. 152/06 art. 284 come modificato dal D.Lgs. 128/10 art. 3 comma 7)</b></td></tr>
        <tr><td align=center>Da allegare alla dichiarazione di conformità per nuova installazione modifica (art. 284, co.1)</td></tr>
        <tr><td align=center>e per gli impianti in esercizio da inserire nel Libretto di Centrale (art. 284, co.2)</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=center><b>Cod. Impianto: $cod_impianto_est</b></td></tr>
        <tr><td align=left>Io sottoscritto $cognome_manu $nome_manu</td></tr>
        <tr><td align=left>In possesso dei requisiti di cui</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$flag_art_3 al D.M. 22/01/2008 n. 37 art. 3</td></tr>
        <!-- ric01 tr><td align=left>$flag_art_11 al DPR 412/93 art. 11</td></tr -->
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Ed in possesso inoltre degli eventuali ulteriori requisiti:</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$flag_patente_abil patentino di abilitazione per la conduzione di impianti termici (obbligatorio per Portata Termica Nominale > 0,232 MW previsto dal DL 152/2006 e ss.mm.ii.(art. 287))</td></tr>
        <!-- ric01 tr><td align=left>$flag_art_11_comma_3 requisiti di cui al DPR 412/93 art. 11 comma 3</td></tr -->
        <tr><td>&nbsp;</td></tr>
  <tr><td align=left>Nella sua qualita di:</td></tr>
        <tr><td align=left>$flag_installatore installatore</td></tr>
        <tr><td align=left>$flag_responsabile terzo responsabile</td></tr>
        <tr><td align=left>$flag_manutentore  manutentore</td></tr>
        <tr><td>&nbsp;</td></tr>
  <tr><td align=left>dell'impianto sito in &nbsp; $indir</td></tr>
        <tr><td>&nbsp;</td></tr>
  <tr><td align=left>Avente le seguenti caratteristiche:</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Combustibile utilizzato: &nbsp; $combustibili</td></tr>
        <tr><td align=left>Nr. generatori: &nbsp; $n_generatori</td></tr>
        <tr><td align=left>Potenza Termica Nominale Complessiva (MW) &nbsp; $pot_term_tot_mw</td></tr>
        <tr><td>&nbsp;</td></tr>
       
       
        <tr><td align=left>Dichiara, ai sensi di quanto previsto dal D.Lgs. 152/06 art. 284 e ss.mm.ii.</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>che l'impianto e' conforme alle caratteristiche tecniche di cui all'art. 285 del D.Lgs. 152/06, come specificate nella parte II dell'allegato IX alla parte V del Decreto citato.</td></tr>
        <tr><td align=left>che l'impianto e' idoneo a rispettare i valori di cui all'art. 286 del D.Lgs. 152/06, come specificate nella parte III dell'allegato IX alla parte V del Decreto citato.</td></tr>
        <tr><td>&nbsp;</td></tr>
     
   <tr><td align=left>Il presente documento viene allegato a:</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$flag_dich_conform Dichiarazione di conformit&agrave; nr. $dich_conformita_nr del $data_dich_conform</td></tr>
        <tr><td align=left>$flag_libretto_centr Libretto di centrale</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Il Dichiarante</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>$firma_dichiarante &nbsp; Data, $data_dichiarazione</td></tr>
        <tr><td>&nbsp;</td></tr>
         <tr><td align=left>Per ricevuta e presa visione</td></tr>
         <tr><td align=left>Il responsabile dell'impianto</td></tr>
        <tr><td>$firma_responsabile &nbsp; Data, $data_ricevuta</td></tr>
       "
	    
	}
	append stampa2 "
    <!-- PAGE BREAK -->
  <tr><td align=right><b>modulo B</b></td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=center><b>ISTRUZIONI PER LE MANUTENZIONI ORDINARIE E STRAORDINARIE DA EFFETTUARSI AL FINE DI ASSICURARE IL RISPETTO DEI VALORI LIMITI DI EMISSIONI DI CUI AL D.LGS. 152/06 ART. 286</b></td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=center><b>(D.Lgs. 152/06 art. 284 come modificato dal D.Lgs. 128/10 art. 3 comma 7) - da inserire nel Libretto di Centrale (art. 284)</b></td></tr>

  <tr><td align=left>Visti:</td></tr>
        <tr><td align=left>Il Libretto di Uso e Manutenzione relativo all'impianto rilasciato dall'installatore</td></tr>
        <tr><td align=left>I Libretti di Uso e Manutenzione degli apparecchi e componenti dell'impianto</td></tr>
        <tr><td align=left>Il Libretto di Centrale</td></tr>
        <tr><td align=left>Il D.Lgs. 192/05 e s.m.i.</td></tr>
        <tr><td align=left>I regolamenti locali ($regolamenti_locali)</td></tr>
        <tr><td align=left>La norma UNI 8364-1-2-3:2007 - Impianti di riscaldamento</td></tr>
        <tr><td align=left>La norma UNI 10435:1995 - Impianti di combustione alimentati a gas con bruciatori ad aria soffiata di portata termica nominale maggiore di 35 Kw. Controllo e manutenzione</td></tr>
        <tr><td align=left>La norma UNI 10389-1:2009 - Generatori di calore - Analisi dei prodotti della combustione e misurazione in opera del rendimento di combustione</td></tr>
        <tr><td>&nbsp;</td></tr>
       
       <tr><td align=left>Elenco di seguito le opere di manutenzione ordinaria e straordinaria per assicurare il rispetto dei valori limite di emissioni di polveri di cui al D.Lgs. 152/06 art. 286 ss.mm.ii:</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>MANUTENZIONE ORDINARIA</td></tr>

   </table>
   <table width=100% border>
        <tr><td align=left width=60%>Operazione</td>
            <td align=left width=40%>Periodicita</td></tr>

        <tr><td align=left width=60%>$manu_ord_1</td><td align=left width=40%>$manu_flag_1</td></tr>
        <tr><td align=left width=60%>$manu_ord_2</td><td align=left width=40%>$manu_flag_2</td></tr>
        <tr><td align=left width=60%>$manu_ord_3</td><td align=left width=40%>$manu_flag_3</td></tr>
        <tr><td align=left width=60%>$manu_ord_4</td><td align=left width=40%>$manu_flag_4</td></tr>
        <tr><td align=left width=60%>$manu_ord_5</td><td align=left width=40%>$manu_flag_5</td></tr>
        <tr><td align=left width=60%>$manu_ord_6</td><td align=left width=40%>$manu_flag_6</td></tr>
        <tr><td align=left width=60%>$manu_ord_7</td><td align=left width=40%>$manu_flag_7</td></tr>

   </table>

   <table width=100%>
        <tr><td align=left>MANUTENZIONE STRAORDINARIA</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$manu_stra_1<td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>VERIFICA STRUMENTALE EMISSIONI</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>La verifica del rispetto dei valori limite di emissione previsti dal D.Lgs. 152/06 art. 286 e ss.mm.ii:</td>\
</tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$verif_emis_286_no non e' stata effettuata trattandosi di impianto  che rientra nei casi previsti dalla parte III sez. 1 dell'allegato IX alla parte V del D.Lgs 152/2006 s ss.mm.ii</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>$verif_emis_286_si e' stata effettuata in data $data_verif_emiss con il seguente risultato: $risultato_mg_nmc_h Mg/Nmc all'ora</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Tale risultato e' $risultato_conforme_si conforme &nbsp; &nbsp; $risultato_conforme_no non conforme</td></tr>
        <tr><td align=left colspan=2><b>(N.B. Il limite massimo di polveri totali è pari a 50  mg/Nmc)</b></td></tr>
        <tr><td>&nbsp;</td></tr>

        <tr><td align=left>Il presente documento viene allegato al Libretto di Centrale in data $data_alleg_libretto</td>
        </tr>
      
    </table>
    </font>
    <font size = 2>
    <table width=100%>
        <tr><td>&nbsp;</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Il Dichiarante</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td>$firma_dichiarante &nbsp; Data, $data_dichiarazione</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Per ricevuta e presa visione</td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td align=left>Il responsabile dell'impianto</td></tr>
        <tr><td>$firma_responsabile &nbsp; Data, $data_ricevuta</td></tr>
    </table>
</font>
"
	if {$coimtgen(regione) eq "MARCHE"} {
	    set nome_file2        "Dichiarazione art. 284 D. Lg. 152 2006"
	} else {
	    set nome_file2        "ALLEGATO IX B"
	}
	set nome_file2        [iter_temp_file_name $nome_file2]
	set file_html2        "$spool_dir/$nome_file2.html"
	set file_pdf2         "$spool_dir/$nome_file2.pdf"
	set file_pdf_url2     "$spool_dir_url/$nome_file2.pdf"

	set file_id2   [open $file_html2 w]
	fconfigure $file_id2 -encoding iso8859-1
	
	puts $file_id2 $stampa2
	close $file_id2
	
	# lo trasformo in PDF
	iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 1cm --bottom 0.2cm -f $file_pdf2 $file_html2]
	
	ns_unlink $file_html2
	ad_returnredirect $file_pdf_url2
    }
}

ad_script_abort

