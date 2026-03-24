ad_page_contract {
    Stampa modello RCEE impianto
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coimdimp-layout.tcl

    USER  DATA       MODIFICHE
    ===== ========== =========================================================================
    mat01 18/03/2025 Cambiamento della label targa e codice catasto per comune di ancona

    rom15 25/11/2024 Sandro ha chiesto di riportare la modifica di rom09 fatta per Caserta anche per
    rom15            Frosinone: il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom14 23/05/2024 Se è attivo l'apposito parametro riporto la campagna di riferimento.

    rom13 11/04/2024 Sandro ha chiesto di riportare la modifica di rom12 fatta per Rieti anche per Caserta:
    rom13            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom12 04/12/2023 Sandro ha chiesto di riportare la modifica di rom11 fatta per Napoli anche per Rieti:
    rom12            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    rom11 13/11/2023 Sandro ha chiesto di riportare la modifica di rom09 fatta per Palermo anche per Napoli:
    rom11            il codice bollino sara' valorizzato con il valore dell'id cod_dimp.

    ric01 17/02/2023 Per evitare che la stampa andasse su due pagine ho modifica l'intestazione
    ric01            del responsabile ed allargato le colonne nella sezione E.

    rom10 28/11/2022 Aggiunta possibilita' di stampare gli rcee con la firma grafometrica in base
    rom10            ai parametri flag_firma_manu_stampa_rcee e flag_firma_resp_stampa_rcee.

    rom09 07/12/2022 Implementazione per Palermo richiesta con mail "Implementazioni" di Sandro del 01/12/2022, riporto testo:
    rom09            Inserimento di un codice bollino nell'apposito campo del Rapporto di controllo. Tale codice sarà uguale a
    rom09            quello del  campo  progressivo inserimento. Per gli impianti con piu' generatori il codice bollino sarà
    rom09            rilasciato solo sul primo generatore dove è presente il contributo.
    rom09            Tale implementazionzione riguarda tutte le tipologie di RCEE e le stampe. Il numero di bollino potrà essere
    rom09            rilasciato solo al momento dell'inserimento. L'implementazione sara' visibile solo per Palermo.

    rom08 02/11/2022 Palermo deve salvare gli allegati su file system.

    rom07 23/03/2022 Su richiesta di Giuliodori rivisti alcune modifiche di rom06. 

    rom06 16/03/2022 MEV Regione Marche punto 6. Stampa RCEE precompilato senza dati del
    rom06            Controllo del rendimento di combustione. 

    rom05 01/02/2022 Su segnalazione di Regione Marche corretto errore sul responsabile stampato:
    rom05            bisogna stampare il responsabile salvato sull'RCEE e, in caso non fosse indicato,
    rom05            vado a prendere il responsabile dell'impianto. Fino ad adesso viene stampato
    rom05            sempre il responsabile dell'impianto.

    rom04 05/11/2021 Regione Marche deve vedere il combustibile salvato sul dimp e non quello del generatore.

    rom03 12/04/2021 Corretta sezione C.TRATTAMENTO DELL'ACQUA per Regione Marche.

    sim07 14/09/2020 Corretto errore su visualizzazione della camera di combustione.

    rom02 10/03/2020 Corretta anomalia per campo flag_status per Regione Marche.

    sim06 20/11/2019 Corretto visualizzazione del campo pot_ter_nom_tot_max. Ora visualizza la somma della potenza
    sim06            utile dei generatori attivi
    
    sim05 08/04/2019 Gestito il salvataggio degli allegati sul file system

    gac06 14/01/2018 Su richiesta della regione marche tolto il campo volumetria riscaldata

    gac05 17/12/2018 Aggiunta targa
    
    gac04 07/12/2018 Sandro mi ha detto che il modulo termico non deve essere il numero
    gac04            progressivo della prova fumi, ma il numero del generatore preso in
    gac04            considerazione

    gac03 15/11/2018 Modificata stampa per regione marche, quasi ogni modifica è riportata in
    gac03            una if solo per regione marche
    
    gac02 07/06/2018 Aggiunti campi elettricità

    rom01 07/06/2018 Aggiunto campo co_fumi_secchi_ppm nelle prove fumi.

    sim04 29/01/2018 Gestito nella stampa le prove fumo multiple

    ale01 07/03/2017 Fatto in modo che se la matricola contiene > o < l'html venga scritto
    ale01            correttamente.

    sim03 23/11/2016 Per Reggio Calabria aggiungo un secondo logo nella stampa

    sim02 17/10/2016 In caso di bollino virtuale visualizzo il prezzo.

    sim01 21/06/2016 Aggiunta del logo alla stampa utilizzando i parametri stampe_logo_nome
    sim01            e stampe_logo_in_tutte_le_stampe.

} {
    {cod_dimp             ""}
    {last_cod_dimp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {cod_manutentore_old  ""}
    {cod_responsabile_old ""}
    {cognome_manu_old     ""}
    {nome_manu_old        ""}
    {cognome_resp_old     ""}
    {nome_resp_old        ""}
    {flag_ins             ""}
    {is_only_print_p     "f"}
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

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_dimp caller nome_funz_caller nome_funz cod_impianto  url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set page_title       "Stampa RCEE"

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

#set data_contr $data_controllo

# Ricerca i parametri della testata
if {[db_0or1row sel_cod_gend ""] == 0} {
    set cod_gendd 0
}
iter_get_coimtgen
set flag_viario $coimtgen(flag_viario)
set flag_cind   $coimtgen(flag_cind);#rom14

if {$is_only_print_p} {#rom06 Aggiunta if e sil suo contenuto

    set sel_dimp "sel_gend_only_print"

    set sel_aimp "sel_aimp_only_print"

    set tr_da_agg "<tr><td><small><small>&nbsp;</small></small></td></tr>";#rom07
    
} else {#rom06 Aggiunta else ma non il suo contenuto

    if {$flag_viario == "T"} {
	set sel_dimp "sel_dimp_si_vie"
    } else {
	set sel_dimp "sel_dimp_no_vie"
    }

    set sel_aimp "sel_aimp";#rom06
    set tr_da_agg "";#rom07
    
};#rom06

#rom06if {[db_0or1row $sel_dimp ""] == 0} {
    # codice non trovato
#rom06    iter_return_complaint  "Dati Impianto non trovati</li>"
#rom06    return
#rom06 }

set img_firma_manuten $spool_dir/$cod_dimp-M-immagine.png;#rom10
set img_firma_respons $spool_dir/$cod_dimp-C-immagine.png;#rom10

if {[file exists $img_firma_manuten] == 0} {#rom10 Aggiunta if e il suo contenuto
    set img_firma_manuten ""
}

if {[file exists $img_firma_respons] == 0} {#rom10 Aggiunta if e il suo contenuto
    set img_firma_respons ""
}

set n_page 0;#rom06
db_foreach $sel_dimp "" {#rom06 Aggiunta foreach ma non il suo contenuto

    set stampa "";#rom06
    
# dati impianto
if {[db_0or1row $sel_aimp ""] == 0} {
    # codice non trovato
    #   iter_return_complaint  "Impianto non trovato"
    #   return
    set modello          ""
    set descrizione      ""
    set tipo_gen_foco    ""
    set tiraggio         ""
}

incr n_page;#rom06

if {$n_page > 1} {#rom06 Aggiunta if e suo contenuto
    set testata2 "<!-- PAGE BREAK -->"
} else {
    set testata2 ""
}

switch $flag_resp {
    "P" {set check_prop "<img src=$logo_dir/check-in.gif height=10>"
	set check_occu "<img src=$logo_dir/check-out.gif height=10>"
	set check_terz "<img src=$logo_dir/check-out.gif height=10>"
	set check_ammi "<img src=$logo_dir/check-out.gif height=10>"
	set check_inst "<img src=$logo_dir/check-out.gif height=10>"
    }
    "O" {set check_prop "<img src=$logo_dir/check-out.gif height=10>"
	set check_occu "<img src=$logo_dir/check-in.gif height=10>"
	set check_terz "<img src=$logo_dir/check-out.gif height=10>"
	set check_ammi "<img src=$logo_dir/check-out.gif height=10>"
	set check_inst "<img src=$logo_dir/check-out.gif height=10>"
    }
    "T" {set check_prop "<img src=$logo_dir/check-out.gif height=10>"
	set check_occu "<img src=$logo_dir/check-out.gif height=10>"
	set check_terz "<img src=$logo_dir/check-in.gif height=10>"
	set check_ammi "<img src=$logo_dir/check-out.gif height=10>"
	set check_inst "<img src=$logo_dir/check-out.gif height=10>"
    }
    "A" {set check_prop "<img src=$logo_dir/check-out.gif height=10>"
	set check_occu "<img src=$logo_dir/check-out.gif height=10>"
	set check_terz "<img src=$logo_dir/check-out.gif height=10>"
	set check_ammi "<img src=$logo_dir/check-in.gif height=10>"
	set check_inst "<img src=$logo_dir/check-out.gif height=10>"
    }
    "I" {set check_prop "<img src=$logo_dir/check-out.gif height=10>"
	set check_occu "<img src=$logo_dir/check-out.gif height=10>"
	set check_terz "<img src=$logo_dir/check-out.gif height=10>"
	set check_ammi "<img src=$logo_dir/check-out.gif height=10>"
	set check_inst "<img src=$logo_dir/check-in.gif height=10>"
    }
}

set img_checked "<img src=\"$logo_dir/check-in.gif\" height=10 width=10>";#gac03
set img_unchecked "<img src=\"$logo_dir/check-out.gif\" height=10 width=10>";#gac03

#gac04 Sandro mi ha detto che il modulo termico non deve essere il progressivo della
#gac04 prova fumi, ma il numero del generatore preso in considerazione
db_0or1row q "select gen_prog_est from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_progg";#gac04


switch $tipo_gen_foco {
    "A" {set des_tipo_foc "Aperto"
	set tipo_gen_foco "B"}
    "C" {set des_tipo_foc "Chiuso"}
    default {set des_tipo_foc "&nbsp;"}
}

switch $tiraggio {
    "F" {set des_tiraggio "Forzato"}
    "N" {set des_tiraggio "Naturale"}
    default {set des_tiraggio "&nbsp;"}
}

#rom06set stampa "<table width=100% border=0>"

append stampa "<table width=100% border=0>";#rom06

set root [ns_info pageroot]
# Titolo della stampa
iter_get_coimdesc
set ente              $coimdesc(nome_ente)
set ufficio           $coimdesc(tipo_ufficio)
set indirizzo_ufficio $coimdesc(indirizzo)
set telefono_ufficio  $coimdesc(telefono)
set assessorato       $coimdesc(assessorato)

# combustibile
if {[db_0or1row sel_comb ""] == 0} {
    # codice non trovato
    #   iter_return_complaint  "Combustibile non trovato"
    #   return
    set descr_comb ""
}


if {$flag_co_perc == "t"} {
    set misura_co "(%)"
} else {
    set misura_co "(ppm)"
}

if {[db_0or1row sel_manu ""] == 1} {
    set manuten "$nome $cognome"
    if {$coimtgen(regione) eq "MARCHE"} {#gac00 if else e contenuto di if
	set indir_man "$indirizzo $localita" 
    } else {
	set indir_man "$indirizzo $localita $provincia $telefono" 
    }	
} else {
    # codice non trovato
    set manuten "" 
    set indir_man ""
}

if {[db_0or1row sel_opma ""] == 1} {
    set operatore "$nome_op $cognome_op"
} else {
    # codice non trovato
    set operatore "_______________________________________";#rom07
}
if {$coimtgen(regione) ne "MARCHE"} {#gac03 if else e contenuto
    if {$tipologia_costo eq "BO"} {
	set bollino_applicato "Bollino applicato: $riferimento_pag"
    } else {
	set bollino_applicato ""
    }
    
    if {$tipologia_costo eq "LM"} {;#sim02 if e else e loro contenuto
	set costo_bollino "Bollino virtuale: $costo_pretty euro"
    } else {
	set costo_bollino ""
    }

    #rom11 Aggiunto ente di PNA
    #rom12 Aggiunto ente di PRI
    #rom13 Aggiunto ente di PCE
    #rom15 Aggiunto ente di PFR
    if {$coimtgen(ente) in [list "PPA" "PNA" "PRI" "PCE" "PFR"] && $riferimento_pag ne ""} {#rom09 Aggiunta if e il suo contenuto
	append costo_bollino "    Codice bollino: $riferimento_pag"
    }

} else {#gac03
    if {$tipologia_costo eq "BO"} {
	set bollino_applicato "Bollino applicato: $riferimento_pag"
    } else {
	set bollino_applicato ""
    }
    
    if {$tipologia_costo eq "LM"} {;#sim02 if e else e loro contenuto
	set costo_bollino "segno identificativo assolto -  &euro; $costo_pretty"
    } else {
	set costo_bollino ""
    }
};#gac03

set stampe_logo_in_tutte_le_stampe [parameter::get_from_package_key -package_key iter -parameter stampe_logo_in_tutte_le_stampe -default "0"];#sim01
set stampe_logo_nome               [parameter::get_from_package_key -package_key iter -parameter stampe_logo_nome];#sim01
set stampe_logo_height             [parameter::get_from_package_key -package_key iter -parameter stampe_logo_height];#sim01

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: Aggiunta if e suo contenuto
    if {$stampe_logo_height ne ""} {
	if {$coimtgen(regione) eq "MARCHE"} {#parte per regione marche
	    set height_logo "height=28"
	} else {#parte standard
	    set height_logo "height=$stampe_logo_height"
	}
    } else {
        set height_logo ""
    }
    set logo "<img src=$logo_dir/$stampe_logo_nome $height_logo>"

    if {$coimtgen(regione) eq "MARCHE"} {#gac03 aggiunta if, else e contenuto di if (parte per regione marche)
	if {$coimtgen(ente) ne "CANCONA"} {
	    set logo_dx_nome         [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_nome   -default ""]
	    set logo_dx_height       [parameter::get_from_package_key -package_key iter -parameter master_logo_sx_height -default "32"]
	    set logo_dx "<img src=$logo_dir/logo_dx_nome.png height=15>"

	} else {
	    set logo_dx "<img src=$logo_dir/logo-comune-ancona.png width=28 height=28>"
	}
    } else {#parte standard
	set logo_dx "";#sim03
    }

	if {$coimtgen(ente) eq "PRC"} {;#sim03 if e suo contenuto
	
	set master_logo_dx_nome [parameter::get_from_package_key -package_key iter -parameter master_logo_dx_nome]
	set logo_dx "<img src=$logo_dir/$master_logo_dx_nome $height_logo align=right>"
	
    }
} else {
    set logo_dx "";#sim03
    set logo ""
}

append testata2 "
<table width=100% border=0>
  <tr>
    <td width=100% align=center>"

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
    append testata2 "
      <table width=100% border=0>
        <tr> 
          <td width=25%>$logo</td>
          <td width=50% align=center>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto (parte standard)
#rom10append testata2 "
#            <table>
#              <tr><td align=center><b><small>$ente</small></b></td></tr>
#              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
#              <tr><td align=center><small>$assessorato</small></td></tr>
#              <tr><td align=center><small>$indirizzo_ufficio</small></td></tr>
#              <tr><td align=center><small>$telefono_ufficio</small></td></tr>
#rom10       </table>"
    append testata2 "
            <table>
              <tr><td align=center><b><small>$ente</small></b></td></tr>
              <tr><td align=center><b><small>$ufficio</small></b></td></tr>
              <tr><td align=center><small>$assessorato $indirizzo_ufficio $telefono_ufficio </small></td></tr>
       </table>";#rom10

} else {#parte per regione marche
    append testata2 "
            <table>
              <tr><td align=center><b><small><small>$ente</small></small></b></td></tr>
              <tr><td align=center><b><small><small>$ufficio</small></small></b></td></tr>
            </table>"
}
if {$coimtgen(regione) ne "MARCHE"} {#gac03 parte standard
    if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
	#sim03 aggiunto logo_dx
	append testata2 "
          </td>
          <td align=center width=25%>$logo_dx</td>
      </table>"
    }
} else {#parte per regione marche
    if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01: aggiunta if e suo contenuto
	#sim03 aggiunto logo_dx
	append testata2 "
          </td>
          <td align=center width=25%>$logo_dx</td>
             <tr>
                <td colspan=2 align=left><small><small>Motivo compilazione REE: $descr_tprc</small></small></td><!-- gac03-->
                <td colspan=1 align=right><small><small>$costo_bollino</small></small></td></tr><!-- sim02 -->
             </tr>
      </table>"
    }
}

set um "";#gac01
set um [db_string q "select um from coimcomb where cod_combustibile = :cod_combustibile" -default ""];#gac01
if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto
    append testata2 "
      <table width=100% border>
        <tr>
          <td colspan=2 align=center>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 1 (GRUPPI TERMICI)</td>
        </tr>
      </table>"
} else {
    append testata2 "
      <table width=100% border=1>
        <tr>
          <td colspan=2 align=center><small>RAPPORTO DI CONTROLLO DI EFFICIENZA ENERGETICA TIPO 1 (GRUPPI TERMICI)</small></td>
        </tr>
      </table>"
}

set testata ""


regsub -all {<} $matricola {\&lt;} matricola; #ale01
regsub -all {>} $matricola {\&gt;} matricola; #ale01

if {1==0} { #mat01 aggiunta if ma non contenuto
    if {$coimtgen(regione) ne "MARCHE"} {#gac03 if else e contenuto
	append stampa "
               <tr>
                  <td align=left><b><small><small>A. IDENTIFICAZIONE DELL'IMPIANTO</small></small></b></td>
                  <td><small><small>codice catasto $cod_impianto_est</small></small></td>
                  <td><small><small>$bollino_applicato</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
	
    } else {
	append stampa "
               <tr>
                  <td width=33% align=left><b><small><small>A. DATI IDENTIFICATIVI</small></small></b></td>
                  <td><small><small>codice catasto $cod_impianto_est</small></small></td>
                  <td><small><small>$bollino_applicato</small></small></td>
                  <td width=33%><small><small>Targa: $targa</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
    }
}

if {[string match "*itercman*" [db_get_database]]} { #mat01 aggiunto if e trasformato il contenuto di if {1==0} {...} qui sopra da if-else a elseif-else
append stampa "
               <tr>
                  <td width=33% align=left><b><small><small>A. DATI IDENTIFICATIVI</small></small></b></td>
                  <td><small><small>Codice impianto: $cod_impianto_est</small></small></td>
                  <td><small><small>$bollino_applicato</small></small></td>
                  <td width=33%><small><small>Codice catasto(targa): $targa</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
    
} elseif {$coimtgen(regione) ne "MARCHE"} {
    append stampa "
               <tr>
                  <td align=left><b><small><small>A. IDENTIFICAZIONE DELL'IMPIANTO</small></small></b></td>
                  <td><small><small>codice catasto $cod_impianto_est</small></small></td>
                  <td><small><small>$bollino_applicato</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
} else {
     append stampa "
               <tr>
                  <td width=33% align=left><b><small><small>A. DATI IDENTIFICATIVI</small></small></b></td>
                  <td><small><small>codice catasto $cod_impianto_est</small></small></td>
                  <td><small><small>$bollino_applicato</small></small></td>
                  <td width=33%><small><small>Targa: $targa</small></small></td>
               </tr>
               <table align=center width=100% border=0 cellpadding=2 cellspacing=0>"
}




if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if e suo contenuto
    append stampa "
               <tr>
                  <td width=33%><small>Rapporto di controllo N&deg; $num_autocert</small></td>
                  <td width=33%><small><b>Data $data_controllo</b></small></td>
                  <td width=34%><small>Protocollo $n_prot</small></td>
               </tr>"


}

if {$flag_cind eq "S"} {#rom14 Aggiunta if e il suo contenuto

    db_1row q "select c.descrizione as descr_cind
                 from coimcind c
                    , coimdimp d
                where c.cod_cind     = d.cod_cind
                  and d.cod_impianto = :cod_impianto
                  and d.cod_dimp     = :cod_dimp"
    
    append stampa "<tr><td colspan=3 align=left><small>Campagna: $descr_cind</small></td></tr>"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto (parte standard), #ric01 spostato sulla stessa riga l'indirizzo dell'impianto e del responsabile
    append stampa "
                  <tr>
                  <td colspan=3><small><small>Impianto termico sito nel comune di: $comune_ubic $prov_ubic &nbsp;&nbsp;&nbsp;&nbsp; in via/piazza: $indirizzo_ubic Cap: $cap_ubic
                  <br>Responsabile : $cognome_resp $nome_resp $indirizzo_resp  tel.: $telefono_resp &nbsp;&nbsp;&nbsp; Indirizzo $indirizzo_resp $numero_resp $cap_resp $comune_resp $provincia_resp
               <br>in qualit&agrave; di $check_prop Proprietario $check_occu Occupante 
                      $check_terz Terzo responsabile $check_ammi Amministratore $check_inst Intestatario
                  </small></small></td>
                  </tr>
               </table>

               <tr><td><table width=100% border=0>
               <tr>
               <td><b><small>Impresa di Manutenzione :</small></b></td>
               <td><small>$manuten  -  $indir_man</small></td>
               </tr>
 
               </table>
"
} else {#parte per regione marche

    set pot_ter_nom_tot_max [db_string q "select iter_edit_num(sum(pot_utile_nom),2) from coimgend where cod_impianto = :cod_impianto and flag_attivo  = 'S'" -default ""];#sim06

    append stampa "
                  <tr>
                  <td><small><small><b>Impianto:</b> di Potenza termica nominale max $pot_ter_nom_tot_max (kW) </small></small></td>
                  <td><small><small>sito nel Comune $comune_ubic Prov. $prov_ubic</small></small></td>
                  </tr>
                  <tr>                  
                  <td><small><small>Indirizzo $indirizzo_ubic</small></small></td>
                  <td><small><small>Scala $scala  Interno $interno</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small><b>Responsabile dell'impianto:</b> Cognome $cognome_resp</small></small></td>
                  <td><small><small>Nome $nome_resp </small></small></td>
                  <td><small><small>C.F. $cod_fiscale_resp</small></small></td> <!--rom05 Messo cod_fiscale_resp al posto di cod_fiscale -->
                  </tr>
                  <tr>
                  <td><small><small>Indirizzo $indirizzo_resp</small></small></td>
                  <td><small><small>Comune $comune_resp</small></small></td>
                  <td><small><small>Provincia $provincia_resp</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Ragione Sociale </small></small></td>
                  <td><small><small>P.IVA</small></small></td>
                  </tr>
                  <td colspan=3><small><small>Titolo di responsabilità: $check_prop Proprietario $check_occu Occupante
                      $check_terz Terzo responsabile $check_ammi Amministratore $check_inst Intestatario</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small><b>Impresa manutentrice: </b>Ragione Sociale $manuten</small></small></td>
                  <td><small><small>P.IVA $cod_piva</small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Indirizzo $indir_man</small></small></td>
                  <td><small><small>Comune $comune</small></small></td> 
                  <td><small><small>Prov. $provincia</small></small></td>
                  </tr>
"
}

if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto (parte standard)
    append stampa "

              </table><table align=center width=100% border=0  cellpadding=2 cellspacing=\"0\">
              <tr><td colspan=2 size=3><small><small><b>B. DOCUMENTAZIONE TECNICA A CORREDO</b></small></small></td>
                 </tr>
                  <tr><td size=3 width=48%><small><small>Dichiarazione di conformit&agrave; dell'impianto</small></small></td>
                  <td width=2%><small><small>[iter_edit_flag_mh $conformita]</small></small></td>
                  <td size=3 width=48%><small><small>Libretti uso/manutenzione generatore presenti<small/></td>
                  <td width=2%><small><small>[iter_edit_flag_mh $lib_uso_man]</small></td>
              </tr>
              <tr><td><small><small>Libretto d'impianto</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $lib_impianto]</small></small></td>
                  <td><small><small>Libretto compilato in tutte le sue parti</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_lib_uso_man_comp]</small></small></td>
              </tr>
              <tr><td colspan=2 size=2><small><small><b>C.TRATTAMENTO DELL'ACQUA</b></small></small></td>
               </tr>
                  <tr>
                  <td><small><small>Durezza °fr</small></small></td>
                  <td><small><small>$rct_dur_acqua</small></small></small></td>
                  <td><small><small>Trattamento in riscaldamento -Non(R)ichiesto-(A)ssente-(F)iltrazione-A(D)dolcimento-Cond.(C)himico</small></small></td>
                  <td><small><small>$rct_tratt_in_risc</small></small></td>
                  </tr>
                  <tr><td><small><small>Trattamento in ACS  -Non(R)ichiesto-(A)ssente-(F)iltrazione-A(D)dolcimento-Cond.(C)himico</small></small></td>
                  <td><small><small>$rct_tratt_in_acs</small></small></td>
              </tr>
              </table><table align=center width=100% border=1  cellpadding=2 cellspacing=\"0\">
              <tr><td colspan=2 size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO</b></small></small></td>
                  </tr>
                  <tr>
                  <td><small><small>Per Installazione interna : locale idoneo:</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $idoneita_locale]</small></small></td>
                  <td><small><small>Canale da fumo o prodotti di scarico idonei (es.vis.)</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_canale_fumo_idoneo]</small></small></td>
              </tr>
              <tr><td><small><small>Per installazione esterna generatori idonei</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_install_interna]</small></small></td>
                  <td><small><small>Sistema di regolazione temp.ambiente funzionante</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_sistema_reg_temp_amb]</small></small></td>
              </tr>
              <tr><td><small><small>Aperture di ventilazione/areazione libere da ostruzione</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $ap_vent_ostruz]</small></small></td>
                  <td><small><small>Assenza di perdite di combustibili liquidi</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_assenza_per_comb]</small></small></td>
              </tr>
              <tr><td><small><small>Adeguate dimensioni apertura ventilazione/aerazione</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $ap_ventilaz]</small></small></td>
                  <td><small><small>Idonea tenuta dell'impianto interno e raccordi con il generatore</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_idonea_tenuta]</small></small></td>
              </tr>
              </table>
"
} else {#parte per regione marche

    if {$conformita eq "S"} {
	set img_conf_s $img_checked
    } else {
	set img_conf_s $img_unchecked
    }
    if {$conformita eq "N"} {
	set img_conf_n $img_checked
    } else {
	set img_conf_n $img_unchecked
    }
    if {$conformita eq "C"} {
	set img_conf_nc $img_checked
    } else {
	set img_conf_nc $img_unchecked
    }

    if {$lib_uso_man eq "S"} {
	set img_lib_uso_s $img_checked
    } else {
	set img_lib_uso_s $img_unchecked
    }
    if {$lib_uso_man eq "N"} {
	set img_lib_uso_n $img_checked
    } else {
	set img_lib_uso_n $img_unchecked
    }
    if {$lib_uso_man eq "C"} {
	set img_lib_uso_nc $img_checked
    } else {
	set img_lib_uso_nc $img_unchecked
    }
    
    if {$lib_impianto eq "S"} {
	set img_lib_impianto_s $img_checked
    } else {
	set img_lib_impianto_s $img_unchecked
    }
    if {$lib_impianto eq "N"} {
	set img_lib_impianto_n $img_checked
    } else {
	set img_lib_impianto_n $img_unchecked
    }
    if {$lib_impianto eq "C"} {
	set img_lib_impianto_nc $img_checked
    } else {
	set img_lib_impianto_nc $img_unchecked
    }
    
    if {$rct_lib_uso_man_comp eq "S"} {
	set img_lib_uso_man_s $img_checked
    } else {
	set img_lib_uso_man_s $img_unchecked
    }
    if {$rct_lib_uso_man_comp eq "N"} {
	set img_lib_uso_man_n $img_checked
    } else {
	set img_lib_uso_man_n $img_unchecked
    }
    if {$rct_lib_uso_man_comp eq "C"} {
	set img_lib_uso_man_nc $img_checked
    } else {
	set img_lib_uso_man_nc $img_unchecked
    }

    #rom03 Aggiunti switch per i valori:
    #rom03 K: Filtr. + Addolc.
    #rom03 J: Filtr. + Cond.Ch.
    #rom03 W: Cond.Ch. + Addolc.
    #rom03 T: Filt. + Cond.Ch. + Addolc.
    switch $rct_tratt_in_risc {
	"R" {
	    set check_r "<img src=$logo_dir/check-in.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-out.gif height=10>" 
	}
	"A" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-in.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-out.gif height=10>"
	}
	"F" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-out.gif height=10>"
	}
	"D" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-out.gif height=10>"
	}
	"C" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-out.gif height=10>"
	}
	"K" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	}
	"J" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	"W" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	"T" {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c "<img src=$logo_dir/check-in.gif height=10>"
	}
	default {
	    set check_r "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro "<img src=$logo_dir/check-in.gif height=10>"
	}
    }

    #rom03 Aggiunti switch per i valori:
    #rom03 K: Filtr. + Addolc.
    #rom03 J: Filtr. + Cond.Ch.
    #rom03 W: Cond.Ch. + Addolc.
    #rom03 T: Filt. + Cond.Ch. + Addolc.
    switch $rct_tratt_in_acs {
	"R" {
	    set check_r1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"A" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"F" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"D" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"C" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"K" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	}
	"J" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"W" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	"T" {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-in.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-in.gif height=10>"
	}
	default {
	    set check_r1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_a1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_f1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_d1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_c1 "<img src=$logo_dir/check-out.gif height=10>"
	    set check_altro1 "<img src=$logo_dir/check-in.gif height=10>"
	}
    }
    if {$idoneita_locale eq "S"} {
	set img_idoneita_s $img_checked
    } else {
	set img_idoneita_s $img_unchecked
    }
    if {$idoneita_locale eq "N"} {
	set img_idoneita_n $img_checked
    } else {
	set img_idoneita_n $img_unchecked
    }
    if {$idoneita_locale eq "E"} {
	set img_idoneita_nc $img_checked
    } else {
	set img_idoneita_nc $img_unchecked
    }

    if {$rct_canale_fumo_idoneo eq "S"} {
	set img_canale_s $img_checked
    } else {
	set img_canale_s $img_unchecked
    }
    if {$rct_canale_fumo_idoneo eq "N"} {
	set img_canale_n $img_checked
    } else {
	set img_canale_n $img_unchecked
    }
    if {$rct_canale_fumo_idoneo eq "C"} {
	set img_canale_nc $img_checked
    } else {
	set img_canale_nc $img_unchecked
    }

    if {$rct_install_interna eq "S"} {
        set img_install_s $img_checked
    } else {
	set img_install_s $img_unchecked
    }
    if {$rct_install_interna eq "N"} {
	set img_install_n $img_checked
    } else {
	set img_install_n $img_unchecked
    }
    if {$rct_install_interna eq "C"} {
	set img_install_nc $img_checked
    } else {
	set img_install_nc $img_unchecked
    }

    if {$rct_sistema_reg_temp_amb eq "S"} {
        set img_sistema_s $img_checked
    } else {
	set img_sistema_s $img_unchecked
    }
    if {$rct_sistema_reg_temp_amb eq "N"} {
	set img_sistema_n $img_checked
    } else {
	set img_sistema_n $img_unchecked
    }
    if {$rct_sistema_reg_temp_amb eq "C"} {
	set img_sistema_nc $img_checked
    } else {
	set img_sistema_nc $img_unchecked
    }

    if {$ap_vent_ostruz eq "S"} {
	set img_vent_s $img_checked
    } else {
	set img_vent_s $img_unchecked
    }
    if {$ap_vent_ostruz eq "N"} {
	set img_vent_n $img_checked
    } else {
	set img_vent_n $img_unchecked
    }
    if {$ap_vent_ostruz eq "C"} {
	set img_vent_nc $img_checked
    } else {
	set img_vent_nc $img_unchecked
    }

    if {$rct_assenza_per_comb eq "S"} {
	set img_assenza_s $img_checked
    } else {
	set img_assenza_s $img_unchecked
    }
    if {$rct_assenza_per_comb eq "N"} {
	set img_assenza_n $img_checked
    } else {
	set img_assenza_n $img_unchecked
    }
    if {$rct_assenza_per_comb eq "C"} {
	set img_assenza_nc $img_checked
    } else {
	set img_assenza_nc $img_unchecked
    }

    if {$ap_ventilaz eq "S"} {
	set img_ap_vent_s $img_checked
    } else {
	set img_ap_vent_s $img_unchecked
    }
    if {$ap_ventilaz eq "N"} {
	set img_ap_vent_n $img_checked
    } else {
	set img_ap_vent_n $img_unchecked
    }
    if {$ap_ventilaz eq "C"} {
	set img_ap_vent_nc $img_checked
    } else {
	set img_ap_vent_nc $img_unchecked
    }

    if {$rct_idonea_tenuta eq "S"} {
	set img_idonea_s $img_checked
    } else {
	set img_idonea_s $img_unchecked
    }
    if {$rct_idonea_tenuta eq "N"} {
	set img_idonea_n $img_checked
    } else {
	set img_idonea_n $img_unchecked
    }
    if {$rct_idonea_tenuta eq "C"} {
	set img_idonea_nc $img_checked
    } else {
	set img_idonea_nc $img_unchecked
    }

    set check_gts "<img src=$logo_dir/check-out.gif height=10>"
    set check_gtm1 "<img src=$logo_dir/check-out.gif height=10>"
    set check_tnr "<img src=$logo_dir/check-out.gif height=10>"
    set check_gac "<img src=$logo_dir/check-out.gif height=10>"
    
    switch $cod_grup_term {
	"GTS"  {set check_gts "<img src=$logo_dir/check-in.gif height=10>"}
	"GTM1" {set check_gtm1 "<img src=$logo_dir/check-in.gif height=10>"}
	"TNR"  {set check_tnr "<img src=$logo_dir/check-in.gif height=10>"}
	"GAC"  {set check_gac "<img src=$logo_dir/check-in.gif height=10>"}
    }

    if {$flag_clima_invernale eq "S"} {
	set img_clima_inv $img_checked
    } else {
	set img_clima_inv $img_unchecked
    }
    if {$flag_prod_acqua_calda eq "S"} {
	set img_prod_acqua $img_checked
    } else {
	set img_prod_acqua $img_unchecked
    }

    if {$disp_comando eq "S"} {
	set img_disp_com_s $img_checked
    } else {
	set img_disp_com_s $img_unchecked
    }
    if {$disp_comando eq "N"} {
	set img_disp_com_n $img_checked
    } else {
	set img_disp_com_n $img_unchecked
    }
    if {$disp_comando eq "C"} {
	set img_disp_com_nc $img_checked
    } else {
	set img_disp_com_nc $img_unchecked
    }
    
    if {$disp_sic_manom eq "S"} {
	set img_disp_sic_man_s $img_checked
    } else {
	set img_disp_sic_man_s $img_unchecked
    }
    if {$disp_sic_manom eq "N"} {
	set img_disp_sic_man_n $img_checked
    } else {
	set img_disp_sic_man_n $img_unchecked
    }
    if {$disp_sic_manom eq "C"} {
	set img_disp_sic_man_nc $img_checked
    } else {
	set img_disp_sic_man_nc $img_unchecked
    }

    if {$rct_valv_sicurezza eq "S"} {
	set img_valv_sic_s $img_checked
    } else {
	set img_valv_sic_s $img_unchecked
    }
    if {$rct_valv_sicurezza eq "N"} {
	set img_valv_sic_n $img_checked
    } else {
	set img_valv_sic_n $img_unchecked
    }
    if {$rct_valv_sicurezza eq "C"} {
	set img_valv_sic_nc $img_checked
    } else {
	set img_valv_sic_nc $img_unchecked
    }
    if {$rct_scambiatore_lato_fumi eq "S"} {
	set img_scamb_s $img_checked
    } else {
	set img_scamb_s $img_unchecked
    }
    if {$rct_scambiatore_lato_fumi eq "N"} {
	set img_scamb_n $img_checked
    } else {
	set img_scamb_n $img_unchecked
    }
    if {$rct_scambiatore_lato_fumi eq "C"} {
	set img_scamb_nc $img_checked
    } else {
	set img_scamb_nc $img_unchecked
    }
    
    if {$rct_riflussi_comb eq "S"} {
	set img_rif_comb_s $img_checked
    } else {
	set img_rif_comb_s $img_unchecked
    }
    if {$rct_riflussi_comb eq "N"} {
	set img_rif_comb_n $img_checked
    } else {
	set img_rif_comb_n $img_unchecked
    }
    if {$rct_riflussi_comb eq "C"} {
	set img_rif_comb_nc $img_checked
    } else {
	set img_rif_comb_nc $img_unchecked
    }
    
    if {$rct_uni_10389 eq "S"} {
	set img_rct_uni_s $img_checked
    } else {
	set img_rct_uni_s $img_unchecked
    }
    if {$rct_uni_10389 eq "N"} {
	set img_rct_uni_n $img_checked
    } else {
	set img_rct_uni_n $img_unchecked
    }
    if {$rct_uni_10389 eq "C"} {
	set img_rct_uni_nc $img_checked
    } else {
	set img_rct_uni_nc $img_unchecked
    }

    set check_gpl     "<img src=$logo_dir/check-out.gif height=10>"
    set check_metano  "<img src=$logo_dir/check-out.gif height=10>"
    set check_gasolio "<img src=$logo_dir/check-out.gif height=10>"
    set check_altro2   "<img src=$logo_dir/check-out.gif height=10>"
    
    switch $descr_comb {
	"GPL"     {set check_gpl "<img src=$logo_dir/check-in.gif height=10>"}
	"METANO"  {set check_metano "<img src=$logo_dir/check-in.gif height=10>"}
	"GASOLIO" {set check_gasolio "<img src=$logo_dir/check-in.gif height=10>"}
	default   {set check_altro2   "<img src=$logo_dir/check-in.gif height=10> Altro $descr_comb"}
    }

    set check_naturale "<img src=$logo_dir/check-out.gif height=10>"
    set check_forzato  "<img src=$logo_dir/check-out.gif height=10>"

    switch $tiraggio {
	"N" {set check_naturale "<img src=$logo_dir/check-in.gif height=10>"}
	"F" {set check_forzato  "<img src=$logo_dir/check-in.gif height=10>"}
    }

    set check_aperta "<img src=$logo_dir/check-out.gif height=10>"
    set check_stagna  "<img src=$logo_dir/check-out.gif height=10>"

    #sim07 visto che precedentemente tipo_gen_foco (se uguale a A) è settato a B, ho modificato lo switch cambiando la
    #sim07 opzione da A a B
    switch $tipo_gen_foco {
	"B" {set check_aperta "<img src=$logo_dir/check-in.gif height=10>"}
	"C" {set check_stagna  "<img src=$logo_dir/check-in.gif height=10>"}
    }
    
    #rom03 Tolti i flag Altro per i campi della sezione C.TRATTAMENTO DELL'ACQUA
    append stampa "
              </table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
              <tr><td width=40% size=3><small><small><b>B. DOCUMENTAZIONE TECNICA A CORREDO</b></small></small></td>
                  <td width=10%><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  <td width=40%>&nbsp;</td>
                  <td width=10%><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                 </tr>
                  <tr><td size=3 ><small><small>Dichiarazione di Conformit&agrave; presente</small></small></td>
                  <td><small><small>$img_conf_s $img_conf_n $img_conf_nc</small></small></td>
                  <td size=3><small><small>Libretti uso/manutenzione generatore presenti<small/></td>
                  <td><small><small>$img_lib_uso_s $img_lib_uso_n $img_lib_uso_nc</small></td>
              </tr>
              <tr><td><small><small>Libretto impianto presente</small></small></td>
                  <td><small><small>$img_lib_impianto_s $img_lib_impianto_n $img_lib_impianto_nc</small></small></td>
                  <td><small><small>Libretto compilato in tutte le sue parti</small></small></td>
                  <td><small><small>$img_lib_uso_man_s $img_lib_uso_man_n $img_lib_uso_man_nc</small></small></td>
              </tr>
</table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
              <tr><td size=2><small><small><b>C.TRATTAMENTO DELL'ACQUA</b></small></small></td>
               </tr>
                  <tr>
                  <td width=20%><small><small>Durezza totale dell'acqua: $rct_dur_acqua (°fr)</small></small></td>
                  <td><small><small>Trattamento in riscaldamento: </small></small></td>
                  <td><small><small>$check_r Non richiesto $check_a Assente $check_f Filtrazione $check_d Addolcimento $check_c 
                  Condiz.chimico</small></small></td>
                  </tr>
                  <tr>
                  <td>&nbsp;</td>
                  <td><small><small>Trattamento in ACS:</small></small></td>
                  <td><small><small>$check_r1 Non richiesto $check_a1 Assente $check_f1 Filtrazione $check_d1 Addolcimento $check_c1 
                  Condiz.chimico</small></small></td>
              </tr>
              </table><table align=center width=100% border=0  cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td size=2><small><small><b>D. CONTROLLO DELL'IMPIANTO</b></small></small></td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  <td>&nbsp;</td>
                  <td><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
                  </tr>
                  <tr>
                  <td width=40%><small><small>Per Installazione interna : in locale idoneo</small></small></td>
                  <td width=10%><small><small>$img_idoneita_s $img_idoneita_n $img_idoneita_nc </small></small></td>
                  <td width=40%><small><small>Canale da fumo o condotti di scarico idonei (esame visivo)</small></small></td>
                  <td width=10%><small><small>$img_canale_s $img_canale_n $img_canale_nc</small></small></td>
              </tr>
              <tr><td><small><small>Per installazione esterna: generatori idonei</small></small></td>
                  <td><small><small>$img_install_s $img_install_n $img_install_nc</small></small></td>
                  <td><small><small>Sistema di regolazione temperatura ambiente funzionante</small></small></td>
                  <td><small><small>$img_sistema_s $img_sistema_n $img_sistema_nc</small></small></td>
              </tr>
              <tr><td><small><small>Aperture di ventilazione/aerazione libere da ostruzioni</small></small></td>
                  <td><small><small>$img_vent_s $img_vent_n $img_vent_nc</small></small></td>
                  <td><small><small>Assenza di perdite di combustibile liquido</small></small></td>
                  <td><small><small>$img_assenza_s $img_assenza_n $img_assenza_nc</small></small></td>
              </tr>
              <tr><td><small><small>Adeguate dimensioni aperture di ventilazione/aerazione</small></small></td>
                  <td><small><small>$img_ap_vent_s $img_ap_vent_n $img_ap_vent_nc</small></small></td>
                  <td><small><small>Idonea tenuta dell'impianto interno e raccordi con il generatore</small></small></td>
                  <td><small><small>$img_idonea_s $img_idonea_n $img_idonea_nc</small></small></td>
              </tr>
              </table>
              <table  width=100% border=0> <!-- gac01 aggiunti nuovi campi scheda 11-->
              <tr><td colspan=2><small><small><b>D.bis. CONSUMI</b></small></small></td></tr>
              <tr>
                  <td valign=top align=center  colspan=10 class=form_title><small><small><b>Consumi di combustibile ($um)</b></small></small></td>
              </tr>
<!--gac06              <tr>
                  <td valign=top align=left class=form_title><small><small>Volumetria riscaldata (m<sup><small><small>3</small></small></sup>): $volimetria_risc</small></small></td>
              </tr>-->
              <tr>    
                  <td valign=top align=left  class=form_title><small><small>Stagione di riscaldamento attuale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$stagione_risc</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Acquisti</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$acquisti</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. iniziale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_iniz</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. finale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_fin</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Consumi stagione</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$consumo_annuo</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left  class=form_title><small><small>Stagione di riscaldamento precedente</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$stagione_risc2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Acquisti</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$acquisti2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. iniziale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_iniz2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Scorta o lett. finale</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$scorta_o_lett_fin2</small></small></td>
                  <td valign=top align=left  class=form_title><small><small>Consumi stagione</small></small></td>
                  <td valign=top align=right  class=form_title><small><small>$consumo_annuo2</small></small></td>
               </tr>
               </table>
               <table width=100% border=0>
               <tr>
                   <td valign=top align=center colspan=4 class=form_title><small><small><b>Consumi elettrici</b></small></small></td></tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>Esercizio</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Lettura iniziale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Lettura finale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>Consumo annuo</small></small></td>
               </tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>$elet_esercizio_1 / $elet_esercizio_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_iniziale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_finale</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_consumo_totale</small></small></td>
               </tr>
               <tr>
                   <td valign=top align=left  class=form_title><small><small>$elet_esercizio_3 / $elet_esercizio_4</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_iniziale_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_lettura_finale_2</small></small></td>
                   <td valign=top align=left  class=form_title><small><small>$elet_consumo_totale_2</small></small></td>
               </tr>
               </table>
              <table width=100%>
              <tr><td colspan=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DEL GRUPPO TERMICO GT $gen_prog_est DATA INSTALLAZIONE: $data_installaz</b></small></small></td>
              </tr>
              <tr>
                  <td width=50% valign=top align=left class=form_title><small><small>Fabbricante: $descr_cost</small></small></td>
                  <td width=25% valign=top align=left class=form_title><small><small>$check_gts Gruppo termico singolo</small></small></td>
                  <td width=25% valign=top align=left class=form_title><small><small>$check_gtm1 Gruppo termico modulare</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Modello: $modello</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$check_tnr Tubo / Nastro radiale</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$check_gac Generatore d'aria calda</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Matricola: $matricola</small></small></td>
                  <td valign=top align=left class=form_title><small><small>Pot.term.nominale max al focolare $pot_focolare_nom (kW)</small></small></td>
                  <td valign=top align=left class=form_title><small><small>Pot.term.nominale utile $potenza (kW)</small></small></td>       
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>Marcatura efficienza energetica:(DPR 660/96): $marc_effic_energ</small></small></td>
                  <td valign=top align=left class=form_title><small><small>Data installazione: $data_installaz</small></small></td>
                  <td valign=top align=left class=form_title><small><small>Anno di costruzione: $data_costruz_gen</small></small></td>
              </tr>
              </table>
              <table width=100% border=0>
              <tr>
                  <td width=20% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=30% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=40% valign=top align=left class=form_title><small><small>&nbsp;</small></small></td>
                  <td width=10% valign=top align=left><small><small>Sì &nbsp; No &nbsp; Nc</small></small></td>
              </tr>
              <tr>
                  <td valign=top align=left class=form_title><small><small>$img_clima_inv Climatizzazione invernale</small></small></td>
                  <td valign=top align=left class=form_title><small><small>$img_prod_acqua Produzione ACS</small></small></td>
                  <td><small><small>Dispositivi di comando e regolazione funzionanti</small></small></td>
                  <td><small><small>$img_disp_com_s $img_disp_com_n $img_disp_com_nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>Combustibile:</small></small></td>
                  <td><small><small>$check_gpl GPL $check_metano Gas naturale</small></small></td>
                  <td><small><small>Dispositivi di sicurezza non manomessi o cortocircuitati</small></small></td>
                  <td><small><small>$img_disp_sic_man_s $img_disp_sic_man_n $img_disp_sic_man_nc</small></small></td>
              </tr>
              <tr>
                  <td><small><small>&nbsp;</small></small></td>
                  <td><small><small>$check_gasolio Gasolio $check_altro2</small></small></td>
                  <td><small><small>Valvola di sicurezza alla sovrapressione a scarico libero</small></small></td>
                  <td><small><small>$img_valv_sic_s $img_valv_sic_n $img_valv_sic_nc</small></small></td>
              </tr>        
              <tr>
                  <td><small><small>&nbsp;</small></small></td>
                  <td><small><small>&nbsp;</small></small></td>
                  <td><small><small>Controllato e pulito lo scambiatore lato fumi</small></small></td>
                  <td><small><small>$img_scamb_s $img_scamb_n $img_scamb_nc</small></small></td>
              </tr>
              <tr>
                  <td colspan=2 valign=top align=left class=form_title><small><small>Modalità evacuazione fumi: $check_naturale Naturale 
                  $check_forzato Forzata</small></small></td>
                  <td><small><small>Presenza riflusso dei prodotti della combustione</small></small></td>
                  <td><small><small>$img_rif_comb_s $img_rif_comb_n $img_rif_comb_nc</small></small></td>
              </tr>
              <tr>
                  <td colspan=2 valign=top align=left class=form_title><small><small>Camera di combustione: $check_aperta Aperta $check_stagna Stagna</small></small></td>
                  <td><small><small>Risultati controllo, secondo UNI 10389-1, conformi alla legge</small></small></td>
                  <td><small><small>$img_rct_uni_s $img_rct_uni_n $img_rct_uni_nc</small></small></td>
              </tr>
</table>
"
}

if {$coimtgen(regione) ne "MARCHE"} {#gac03 if else e contenuto (parte standard), ric01 aggiunto width=33% per allargare colonne
    append stampa "
              <table>
              <tr><td colspan=2 size=2><small><small><b>E. CONTROLLO E VERIFICA ENERGETICA DEL GRUPPO TERMICO GT </b></small></small></td>
              </tr>
              <tr>
        <td valign=top align=left class=form_title width=33%><small>Costruttore: $descr_cost</small></td>
        <td valign=top align=left class=form_title width=33%><small>Modello: $modello</small></td>
        <td valign=top align=left class=form_title width=33%><small>Matricola: $matricola</small></td>
    </tr>
    <tr>
        <td valign=top align=left class=form_title><small>Pot. term. nom. utile (kW) $potenza</small></td>
        <td valign=top align=left class=form_title><small>Pot. term. nom al focolare (kW) $pot_focolare_nom</small></td>
        <td valign=top align=left class=form_title><small>Anno di costruzione: $data_costruz_gen</small></td>
    </tr>
    <tr>
         <td valign=top align=left class=form_title><small>Marcatura efficienza energetica:(DPR 660/96): $marc_effic_energ</small></td>
         <td valign=top align=left class=form_title><small>Uso: $destinazione</small></td>
        <td valign=top align=left class=form_title><small>Data installazione: $data_installaz</small></td>       
    </tr>
    <tr>
        <td valign=top align=left class=form_title><small>Caldaia tipo: $tipo_gen_foco</small></td>
        <td ><small>Combustibile: $descr_comb</small></td>
        <td valign=top align=left class=form_title><small>Volimetria riscaldata (m<sup><small>3</small></sup>): $volimetria_risc</small></td>
    </tr>
   <tr>
         <td valign=top align=left  class=form_title><small>Tiraggio: $tiraggio</small></td>
         <td valign=top align=left  class=form_title><small>Locale installazione: $locale</small></td>
    </tr>        
              <tr><td><small><small>Dispositivi di comando e regolazione funzionanti</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $disp_comando]</small></small></td>
                  <td><small><small>Dispositivi di sicurezza non manomessi o cortocircuitati</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $disp_sic_manom]</small></small></td>
              </tr>
              <tr>
                  <td><small><small>Valvola di sicurezza alla sovrapressione a scarico libero</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_valv_sicurezza]</small></small></td>
                  <td><small><small>Controllato e pulito lo scambiatore lato fumi</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_scambiatore_lato_fumi]</small></small></td>
              </tr>
              <tr><td><small><small>Presenza riflusso prodotti combustione</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_riflussi_comb]</small></small></td>
                  <td><small><small>Risultati controllo secondo UNI 10389-1, conformi alla legge</small></small></td>
                  <td><small><small>[iter_edit_flag_mh $rct_uni_10389]</small></small></td>
              </tr>
</table>
<table  width=100% border=0> <!-- gac01 aggiunti nuovi campi scheda 11-->
<tr>    
    <td valign=top align=left  class=form_title><small>Stagione di riscaldamento attuale</small></td>
    <td valign=top align=right  class=form_title><small>$stagione_risc</small></td>
    <td valign=top align=left  class=form_title><small>Acquisti</small></td>
    <td valign=top align=right  class=form_title><small>$acquisti</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. iniziale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_iniz</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. finale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_fin</small></td>
    <td valign=top align=left  class=form_title><small>Consumi stagione</small></td>
    <td valign=top align=right  class=form_title><small>$consumo_annuo</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>Stagione di riscaldamento precedente</small></td>
    <td valign=top align=right  class=form_title><small>$stagione_risc2</small></td>
    <td valign=top align=left  class=form_title><small>Acquisti</small></td>
    <td valign=top align=right  class=form_title><small>$acquisti2</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. iniziale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_iniz2</small></td>
    <td valign=top align=left  class=form_title><small>Scorta o lett. finale</small></td>
    <td valign=top align=right  class=form_title><small>$scorta_o_lett_fin2</small></td>
    <td valign=top align=left  class=form_title><small>Consumi stagione</small></td>
    <td valign=top align=right  class=form_title><small>$consumo_annuo2</small></td>

</tr>
</table>
<table width=100% border=0>
<tr>
    <td valign=top align=center colspan=4 class=form_title><small><b>Elettricità</b></small></td></tr>
<tr>
    <td valign=top align=left  class=form_title><small>Esercizio</small></td>
    <td valign=top align=left  class=form_title><small>Lettura iniziale</small></td>
    <td valign=top align=left  class=form_title><small>Lettura finale</small></td>
    <td valign=top align=left  class=form_title><small>Consumo annuo</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>$elet_esercizio_1 / $elet_esercizio_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_iniziale</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_finale</small></td>
    <td valign=top align=left  class=form_title><small>$elet_consumo_totale</small></td>
</tr>
<tr>
    <td valign=top align=left  class=form_title><small>$elet_esercizio_3 / $elet_esercizio_4</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_iniziale_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_lettura_finale_2</small></td>
    <td valign=top align=left  class=form_title><small>$elet_consumo_totale_2</small></td>
</tr>

</table>
"
}

if {$coimtgen(regione) ne "MARCHE"} {#gac03 if else e contenuto (parte standard)
    #gac04 Sandro mi ha detto che il modulo termico non deve essere il progressivo della
    #gac04 prova fumi, ma il numero del generatore preso in considerazione
    db_0or1row q "select gen_prog_est from coimgend where cod_impianto = :cod_impianto and gen_prog = :gen_progg";#gac04

    append stampa "
<table>      
              <tr><td><small><small>Depressione nel canale da fumo (Pa) </small></small></td>
                  <td><small><small>$tiraggio_fumi</small></small></td>
                </table>
                 <table align=center width=100% border=1 cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td><small>Num modulo</small></td><!--sim04-->
                  <td><small>Temperatura fumi(&deg;C)</small></td>
                  <td><small>Temperatura aria comb.(&deg;C)</small></td>
                  <td><small>O<sub><small>2</small></sub>(%)</small></td>
                  <td><small>CO<sub><small>2</small></sub>(%)</small></td>
                  <td><small>Bacharach(n&deg;)</small></td>
                  <td><small>CO fumi secchi (ppm)</small></td>
                  <td><small>CO $misura_co</small></td>
                  <td><small>Portata combustibile<br>\(m<small><sup>3</sup></small>/h o kg/h\)</small></td>
                  <td><small>Rend.to Combustione</small></td>
                  <td><small>Rend.to Min.legge</small></td>
                  <td><small>Modulo termico</small></td>
              </tr>
              <tr>
                  <td align=right><small>1</small></td><!--sim04-->
                  <td align=right><small>$temp_fumi</small></td>
                  <td align=right><small>$temp_ambi</small></td>
                  <td align=right><small>$o2</small></td>
                  <td align=right><small>$co2</small></td>
                  <td align=center><small>$bacharach/$bacharach2/$bacharach3</small></td>
                  <td align=center><small>$co_fumi_secchi_ppm</small></td>
                  <td align=right><small>$co</small></td>
                  <td align=right><small>$portata_comb</small></td>
                  <td align=right><small>$rend_combust</small></td>
                  <td align=right><small>$rct_rend_min_legge</small></td>
                  <td align=right><small>$gen_prog_est</small></td>
              </tr>"

db_foreach q "select progressivo_prova_fumi
                   , temp_fumi as temp_fumi_prfumi
                   , temp_ambi as temp_ambi_prfumi
                   , o2        as o2_prfumi
                   , co2       as co2_prfumi
                   , iter_edit_num(bacharach,0) as bacharach_prfumi
                   , co        as co_prfumi
                   , rend_combust as rend_combust_prfumi
                   , rct_rend_min_legge as rct_rend_min_legge_prfumi
                   , rct_modulo_termico as rct_modulo_termico_prfumi
                   , iter_edit_num(bacharach2,0) as bacharach2_prfumi     --gac01
                   , iter_edit_num(bacharach3,0) as bacharach3_prfumi     --gac01
                   , iter_edit_num(portata_comb,2) as portata_comb_prfumi --gac01
                   , iter_edit_num(co_fumi_secchi_ppm,2) as co_fumi_secchi_ppm_prfumi --rom01
                from coimdimp_prfumi
               where cod_dimp = :cod_dimp" {#sim04

		   append stampa "
                  <tr>
                  <td align=right><small>$progressivo_prova_fumi</small></td>
                  <td align=right><small>$temp_fumi_prfumi</small></td>
                  <td align=right><small>$temp_ambi_prfumi</small></td>
                  <td align=right><small>$o2_prfumi</small></td>
                  <td align=right><small>$co2_prfumi</small></td>
                  <td align=center><small>$bacharach_prfumi/$bacharach2_prfumi/$bacharach3_prfumi</small></td>
                  <td align=right><small>$co_fumi_secchi_ppm_prfumi</small></td>
                  <td align=right><small>$co_prfumi</small></td>
                  <td align=right><small>$portata_comb_prfumi</small></td> 
                  <td align=right><small>$rend_combust_prfumi</small></td>
                  <td align=right><small>$rct_rend_min_legge_prfumi</small></td>
                  <td align=right><small>$gen_prog_est</small></td>
              </tr>
</table>
<table width=100%>
<tr>
    <td align=left><small><small>Rispetta l'indice di Bacharach?</small></small></td>
    <td align=left><small><small>$rispetta_indice_bacharach</small></small></td>
    <td align=right><small><small>CO fumi secchi e senz'aria <=1.000 ppm v/v</small></small></td>
    <td align=left><small><small>$co_fumi_secchi</small></small></td>
    <td align=right><small><small>Rendimento >= rendimento minimo</small></small></td>
    <td align=right><small><small>$rend_magg_o_ugua_rend_min</small></small></td>
</tr>
</table>
"

	       }  
} else {#parte per regione marche
    set img_bacha_s "<img src=$logo_dir/check-out.gif height=10>"
    set img_bacha_n "<img src=$logo_dir/check-out.gif height=10>"
    set img_co_fum_s "<img src=$logo_dir/check-out.gif height=10>"
    set img_co_fum_n "<img src=$logo_dir/check-out.gif height=10>"
    set img_rend_s "<img src=$logo_dir/check-out.gif height=10>"
    set img_rend_n "<img src=$logo_dir/check-out.gif height=10>"

    switch $rispetta_indice_bacharach {
	"SI" {set img_bacha_s "<img src=$logo_dir/check-in.gif height=10>"}
	"NO" {set img_bacha_n "<img src=$logo_dir/check-in.gif height=10>"}
    }
    switch $co_fumi_secchi {
	"SI" {set img_co_fum_s "<img src=$logo_dir/check-in.gif height=10>"}
	"NO" {set img_co_fum_n "<img src=$logo_dir/check-in.gif height=10>"}
    }
    switch $rend_magg_o_ugua_rend_min {
	"SI" {set img_rend_s "<img src=$logo_dir/check-in.gif height=10>"}
	"NO" {set img_rend_n "<img src=$logo_dir/check-in.gif height=10>"}
    }


    if {$is_only_print_p} {#rom06 Aggiunta if e il suo contenuto

	set num_prove_fumi_printed 0

	for {set num_prove_fumi_printed 0} {$num_prove_fumi_printed < $num_prove_fumi} {incr num_prove_fumi_printed} {
	    
	    append stampa "
            <table>      
              <tr><td><small><small>Depressione nel canale da fumo </small></small></td>
                  <td><small><small>$tiraggio_fumi (Pa)</small></small></td>
                </table>
                 <table align=center width=100% border=1 cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td><small><small>Temperatura Fumi (&deg;C)</small></small></td>
                  <td><small><small>Temp. Aria comburente (&deg;C)</small></small></td>
                  <td><small><small>O<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>CO<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>Bacharach</small></small></td>
                  <td><small><small>CO fumi secchi (ppm)</small></small></td>
                  <td><small><small>CO corretto (ppm)</small></small></td>
                  <td><small><small>Portata combustione<br>\(m<small><small><sup>3</sup></small></small>/h o kg/h\)</small></small></td>
                  <td><small><small>Rendimento di combustione</small></small></td>
                  <td><small><small>Rendimento minimo di legge</small></small></td>
                  <td><small><small>Modulo termico</small></small></td>
              </tr>
              <tr>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=center>&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;</td>
                  <td align=center>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
                  <td align=right>&nbsp;</td>
              </tr>
            </table>"

	}
	
    } else {#rom06 Aggiunta else ma non il suo contenuto
    
    append stampa "
<table>      
              <tr><td><small><small>Depressione nel canale da fumo </small></small></td>
                  <td><small><small>$tiraggio_fumi (Pa)</small></small></td>
                </table>
                 <table align=center width=100% border=1 cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td><small><small>Temperatura Fumi (&deg;C)</small></small></td>
                  <td><small><small>Temp. Aria comburente (&deg;C)</small></small></td>
                  <td><small><small>O<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>CO<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>Bacharach</small></small></td>
                  <td><small><small>CO fumi secchi (ppm)</small></small></td>
                  <td><small><small>CO corretto (ppm)</small></small></td>
                  <td><small><small>Portata combustione<br>\(m<small><small><sup>3</sup></small></small>/h o kg/h\)</small></small></td>
                  <td><small><small>Rendimento di combustione</small></small></td>
                  <td><small><small>Rendimento minimo di legge</small></small></td>
                  <td><small><small>Modulo termico</small></small></td>
              </tr>
              <tr>
                  <td align=right><small><small>$temp_fumi</small></small></td>
                  <td align=right><small><small>$temp_ambi</small></small></td>
                  <td align=right><small><small>$o2</small></small></td>
                  <td align=right><small><small>$co2</small></small></td>
                  <td align=center><small><small>$bacharach/$bacharach2/$bacharach3</small></small></td>
                  <td align=center><small><small>$co_fumi_secchi_ppm</small></small></td>
                  <td align=right><small><small>$co</small></small></td>
                  <td align=right><small><small>$portata_comb</small></small></td>
                  <td align=right><small><small>$rend_combust</small></small></td>
                  <td align=right><small><small>$rct_rend_min_legge</small></small></td>
                  <td align=right><small><small>$gen_prog_est</small></small></td>
              </tr>"

db_foreach q "select progressivo_prova_fumi
                   , temp_fumi as temp_fumi_prfumi
                   , temp_ambi as temp_ambi_prfumi
                   , o2        as o2_prfumi
                   , co2       as co2_prfumi
                   , iter_edit_num(bacharach,0) as bacharach_prfumi
                   , co        as co_prfumi
                   , rend_combust as rend_combust_prfumi
                   , rct_rend_min_legge as rct_rend_min_legge_prfumi
                   , rct_modulo_termico as rct_modulo_termico_prfumi
                   , iter_edit_num(bacharach2,0) as bacharach2_prfumi     --gac01
                   , iter_edit_num(bacharach3,0) as bacharach3_prfumi     --gac01
                   , iter_edit_num(portata_comb,2) as portata_comb_prfumi --gac01
                   , iter_edit_num(co_fumi_secchi_ppm,2) as co_fumi_secchi_ppm_prfumi --rom01
                   , iter_edit_num(tiraggio,2) as tiraggio_fumi_prfumi
                from coimdimp_prfumi
               where cod_dimp = :cod_dimp" {#sim04

		   append stampa "
              </table>
              <table>      
              <tr><td><small><small>Depressione nel canale da fumo </small></small></td>
                  <td><small><small>$tiraggio_fumi_prfumi (Pa)</small></small></td>
                </table>
                 <table align=center width=100% border=1 cellpadding=1 cellspacing=\"0\">
              <tr>
                  <td><small><small>Temperatura Fumi (&deg;C)</small></small></td>
                  <td><small><small>Temp. Aria comburente (&deg;C)</small></small></td>
                  <td><small><small>O<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>CO<sub><small><small>2</small></small></sub>(%)</small></small></td>
                  <td><small><small>Bacharach</small></small></td>
                  <td><small><small>CO fumi secchi (ppm)</small></small></td>
                  <td><small><small>CO corretto (ppm)</small></small></td>
                  <td><small><small>Portata combustione<br>\(m<small><small><sup>3</sup></small></small>/h o kg/h\)</small></small></td>
                  <td><small><small>Rendimento di combustione</small></small></td>
                  <td><small><small>Rendimento minimo di legge</small></small></td>
                  <td><small><small>Modulo termico</small></small></td>
              </tr>
                  <tr>
                  <td align=right><small><small>$temp_fumi_prfumi</small></small></td>
                  <td align=right><small><small>$temp_ambi_prfumi</small></small></td>
                  <td align=right><small><small>$o2_prfumi</small></small></td>
                  <td align=right><small><small>$co2_prfumi</small></small></td>
                  <td align=center><small><small>$bacharach_prfumi/$bacharach2_prfumi/$bacharach3_prfumi</small></small></td>
                  <td align=right><small><small>$co_fumi_secchi_ppm_prfumi</small></small></td>
                  <td align=right><small><small>$co_prfumi</small></small></td>
                  <td align=right><small><small>$portata_comb_prfumi</small></small></td> 
                  <td align=right><small><small>$rend_combust_prfumi</small></small></td>
                  <td align=right><small><small>$rct_rend_min_legge_prfumi</small></small></td>
                  <td align=right><small><small>$gen_prog_est</small></small></td>
              </tr>
</table>
"		   
	       }
};#rom06
append stampa "
<table width=100%>
<tr>
    <td align=left><small><small>Rispetta l'indice di Bacharach?</small></small></td>
    <td align=left><small><small>$img_bacha_s Sì $img_bacha_n No</small></small></td>
    <td align=right><small><small>CO fumi secchi e senz'aria <=1.000 ppm v/v</small></small></td>
    <td align=left><small><small>$img_co_fum_s Sì $img_co_fum_n No</small></small></td>
    <td align=right><small><small>Rendimento >= rendimento minimo</small></small></td>
    <td align=right><small><small>$img_rend_s Sì $img_rend_n No</small></small></td>
</tr>
</table>"

}
append stampa "
"

if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto (parte standard)
        append stampa "
              <table width=100%>
                   <tr><td colspan=2 size=2><small><small><b>F. CHECK LIST</b></small></small></td> </tr>
                   <tr><td  valign=top align=left class=form_title><small><small>Elenco di possibili interventi, dei quali va valuta la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica</small></small></td></tr>
                   <tr><td><small><small>$rct_check_list_1  -Adozione di valvole termostatiche</small></small></td></tr>
                   <tr><td><small><small>$rct_check_list_2   -L'isolamento della rete di distribuzione nei locali non riscaldati</small></small></td></tr>
                   <tr><td><small><small>$rct_check_list_3   -Introduzione di un trattamento dell'acqua sanitaria e per riscaldamento ove assente</small></small></td></tr>
                   <tr><td><small><small>$rct_check_list_4   -La sostituzione di un sistema on/off con un sistema programmabile su più livelli di temperatura</small></small></td></tr>
              </table>

              <table width=100% border=0 cellpadding=1 cellspacing=0>
              <tr>
                <td><small><b>OSSERVAZIONI</b>: $osservazioni</small>
                </td>
              </tr>
              <tr>
                <td><small><b>RACCOMANDAZIONI</b> (in attesa di questi interventi l'impianto pu&ograve; essere messo in funzione): $raccomandazioni</small>
                </td>
              </tr>
              <tr>
                <td><small><b>PRESCRIZIONI</b> (in attesa di questi interventi l'impianto non pu&ograve; essere messo in funzione): $prescrizioni</small>
              </tr>
              </table>"
} else {#parte per regione marche

    if {$rct_check_list_1 eq "S"} {
	set img_list_1 $img_checked
    } else {
	set img_list_1 $img_unchecked
    }
    if {$rct_check_list_2 eq "S"} {
	set img_list_2 $img_checked
    } else {
	set img_list_2 $img_unchecked
    }
    if {$rct_check_list_3 eq "S"} {
	set img_list_3 $img_checked
    } else {
	set img_list_3 $img_unchecked
    }
    if {$rct_check_list_4 eq "S"} {
	set img_list_4 $img_checked
    } else {
	set img_list_4 $img_unchecked
    }

    append stampa "
              <table>
                   <tr><td size=2 colspan=2 nowrap><small><small><b>F. CHECK LIST</b> Elenco di possibili interventi, dei quali va valuta la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica:</small></small></td>
                   </tr>
                   <tr><td nowrap><small><small>$img_list_1 Adozione di valvole termostatiche sui corpi scaldanti</small></small></td>
                       <td nowrap><small><small>$img_list_3 Introduzione di un sistema di trattamento dell'acqua sanitaria e per riscaldamento, ove assente</small></small></td>
                   </tr>
                   <tr><td nowrap><small><small>$img_list_2 Isolamento della rete di distribuzione nei locali non riscaldati</small></small></td>
                       <td nowrap><small><small>$img_list_4 Sostituzione di un sistema di regolazione on/off con un sistema programmabile su più livelli di temperatura</small></small></td>
                   </tr>
              </table>

              <table width=100% border=0 cellpadding=0 cellspacing=1>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>OSSERVAZIONI</b>:<small><small></td>
                <td width=90%><small><small>$osservazioni</small></small></td>
              </tr>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>RACCOMANDAZIONI</b>:<small><small></td>
                <td width=90%><small><small>$raccomandazioni</small></small></td>
              </tr>
              $tr_da_agg
              <tr>
                <td width=10%><small><small><b>PRESCRIZIONI</b>:<small><small></td>
                <td width=90%><small><small>$prescrizioni</small></small></td>
              </tr>
              </table>"
}
set lista_anom ""
db_foreach sel_anom "" {
    lappend lista_anom $cod_tanom
}

if {![string equal $lista_anom ""]} {
    append stampa "<table width=100% border=0 cellpadding=0 cellspacing=0>
                     <tr>
                       <td width=10%><small><small>Anomalie presenti:</small></small></td>
                       <td align=left><small><small>"
    foreach anom $lista_anom {
	append stampa " $anom "
    }
    append stampa "    </small></small></td>
                     </tr>
                   </table>"
}

#append stampa "</b>
#               </td>
#               </tr>
#               </table>"

if {[string is space $firma_manut]} {
    set firma_manut $manuten
}

if {[string is space $firma_resp]} {
    set firma_resp "$cognome_resp $nome_resp"
}

if {$coimtgen(flag_firma_manu_stampa_rcee) eq "t"} {#rom10 Aggiunta if e il suo contenuto
    set firma_manut "<img src=$img_firma_manuten height=50>"
}
if {$coimtgen(flag_firma_resp_stampa_rcee) eq "t"} {#rom10 Aggiunta if e il suo contenuto
    set firma_resp "<img src=$img_firma_respons height=50>"
}
    
if {$coimtgen(regione)  ne "MARCHE"} {#gac03 if else e contenuto (parte standard)
append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=1><tr>
                <tr>
                  <td  valign=top align=left class=form_title><small>il tecnico dichiara, in riferimento ai punti A,B,C,D,E (sopra menzionati)  che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.<b>L'impianto pu&ograve; funzionare</b> [iter_edit_flag_mh $flag_status]</small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr><td align=center><table width=100% ><tr>
            <td  valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissione dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo a provvedere alla loro risoluzione dandone notizia all'operatore incaricato. Si raccomanda un intervento manutentivo entro il $data_prox_manut</small></small></td>
          </tr>
          </table>
        </td>
      </tr>
             <table width=100% border=0 cellpadding=1 cellspacing=0>
               <tr>
                    <td colspan=2><small><b>TECNICO CHE HA EFFETTUATO IL CONTROLLO:</b></small></td>
               </tr>
               <tr>
                  <td colspan=1 valign=top><small>Nome e cognome: $operatore </small></td>
    <!--       </tr>
               <tr> -->
                  <td colspan=1 valign=top><small>Indirizzo <small>$indir_man</small></small></td>
               </tr>
               <tr>
                  <td valign=top><small><u>Orario di arrivo presso l'impianto $ora_inizio</u></small></td>
                  <td valign=top><small><u>Orario di partenza dall'impianto $ora_fine</u></small></td>
               </tr>
               <tr>
                  <td colspan=2><small>$costo_bollino<small></td><!-- sim02 -->
               </tr>
               <tr>
                  <td width=50%><small>Firma manutentore <br> $firma_manut</small></td>
                  <td width=50%><small>Firma responsabile <br> $firma_resp</small></td>
               </tr>
     <!--rom10 <tr>
                  <td><small>$firma_manut</small></td>
                  <td><small>$firma_resp</small></td>
               </tr> -->
             </table>"
} else {#parte per regione marche
    if {$flag_status eq "P"} {
	#rom02set img_funz $img_checked
	set img_funz_si $img_checked;#rom02
	set img_funz_no $img_unchecked;#rom02
    } elseif {$flag_status eq "O_P"} {#rom06 Aggiunta elseif e suo contenuto
	#Se sto stampando la dichiarazione precompilata non devo avere nessuna casella checkata
	set img_funz_no $img_unchecked
	set img_funz_si $img_unchecked
    } else {
	#rom02set img_funz $img_unchecked
	set img_funz_no $img_checked;#rom02
	set img_funz_si $img_unchecked;#rom02
    }
    append stampa "</table></td></tr>
          <tr>
            <td align=center>
              <table width=100% border=0>
                <tr>
                  <td valign=top align=left class=form_title><small><small><b>il tecnico dichiara, in riferimento ai punti A,B,C,D,E (sopra menzionati), che l'apparecchio pu&ograve; essere messo in servizio ed usato normalmente ai fini dell'efficenza energetica senza compromettere la sicurezza delle persone, degli animali e dei beni.</b></small></small></td>
                </tr>
                <tr>
                  <td valign=top align=left class=form_title><small><small><b>L'impianto pu&ograve; funzionare $img_funz_si Sì $img_funz_no No</b></small></small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align=center>
              <table width=100%>
                <tr>
                  <td valign=top align=left class=form_title><small><small>Il tecnico declina altresi ogni responsabilit&agrave; per sinistri a persone, animali o cose derivanti da manomissione dell'impianto o dell'apparecchio da parte di terzi, ovvero da carenze di manutenzione successiva. In presenza di carenza riscontrate e non eliminate, il responsabile dell'impianto si impegna, entro breve tempo, a provvedere alla loro risoluzione dandone notizia all'operatore incaricato.
                  </td>
                </tr>
                <tr>
                  <td valign=top align=left class=form_title><small><small>Si raccomanda un intervento manutentivo entro il $data_prox_manut</small></small></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align=center>
             <table width=100% border=0 cellpadding=1 cellspacing=1>
               <tr>               
                 <td width=33%><small><small>Data del presente controllo $data_controllo</small></small></td>
                 <td><small><small>Orario di arrivo/partenza presso l'impianto $ora_inizio / $ora_fine</small></small></td>
               </tr>
               <tr>
                 <td colspan=2 valign=top><small><small>Tecnico che ha effettato il controllo: Nome e cognome: $operatore </small></small></td>
               </tr>
               <tr>
                 <td width=50% valign=bottom><small><small>Firma leggibile del tecnico</small></small></td>
                 <td width=50% valign=bottom><small><small>Firma leggibile, per presa visione, del responsabile dell'impianto</small></small></td>
               </tr>
               <tr>
                 <td><small>$firma_manut</small></td>
                 <td><small>$firma_resp</small></td>
               </tr>
             </table>
            </td>
          </tr>
        </table>"
}

# creo file temporaneo html
set stampa1 $testata
append stampa1 $stampa
append stampa2 $testata2
append stampa2 $stampa

};#rom06

set stampa2 "<!-- HEADER RIGHT  \"Pagina \$PAGE(1) di \$PAGES(1)\" -->$stampa2";#rom06

# imposto il nome dei file
set nome_file        "stampa RCEE"
set nome_file_originale  "$nome_file.pdf";#sim05
set nome_file        [iter_temp_file_name $nome_file]
set file_html        "$spool_dir/$nome_file.html"
set file_pdf         "$spool_dir/$nome_file.pdf"
set file_pdf_url     "$spool_dir_url/$nome_file.pdf"

set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa2
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm --headfootsize size 2 -f $file_pdf $file_html]

# Controllo se il Database e' Oracle o Postgres
set id_db     [iter_get_parameter database]

set sql_contenuto  "lo_import(:file_html)"
set tipo_contenuto [ns_guesstype $file_pdf]

set contenuto_tmpfile  $file_pdf

if {[db_0or1row sel_docu ""] == 0} {
    set flag_docu "N"
} else {
    set flag_docu "S"
}

if {$flag_ins == "S"} {
    with_catch error_msg {
	db_transaction {
	    if {[string equal $cod_documento ""]
		|| $flag_docu == "N"
	    } {
		db_1row sel_docu_next ""
		set tipo_documento "MH"
		db_dml dml_sql_docu [db_map ins_docu]
		db_dml dml_sql_dimp [db_map upd_dimp]
	    } else {
		db_dml dml_sql_docu [db_map upd_docu]
	    }
	    
	    if {$id_db == "postgres"} {
		if {[db_0or1row sel_docu_contenuto ""] == 1} {
		    if {![string equal $docu_contenuto_check ""]} {
			db_dml dml_sql2 [db_map upd_docu_2]
		    }
		}

		#rom08 Aggiunta condizione su Palermo
		if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim05 if e suo contenuto	    
		    
		    set path_file [iter_permanenti_file_salva $contenuto_tmpfile $nome_file_originale]
		    
		    db_dml q "update coimdocu
		  	             set tipo_contenuto = :tipo_contenuto
			               , path_file      = :path_file
			           where cod_documento  = :cod_documento"
		     
		} else {#sim05
		    db_dml dml_sql3 [db_map upd_docu_3]
		};#sim05
	    } else {
		db_dml dml_sql2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
	    }
	    
	}
    } {
	iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
    }

} else {#sim05 else e suo contenuto
    set path_file $file_pdf
}
ns_unlink $file_html

if {$img_firma_manuten ne ""} {#rom10 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_manuten
}

if {$img_firma_respons ne ""} {#rom10 Aggiunta if e il suo contenuto
    ns_unlink $img_firma_respons
}

#rom08 Aggiunta condizione su Palermo
if {$coimtgen(regione) eq "MARCHE" || $coimtgen(ente) eq "PPA"} {#sim05 if e suo contenuto	    
    ns_returnfile 200 $tipo_contenuto $path_file
    return
} else {#sim05    
    ad_returnredirect $file_pdf_url
    ad_script_abort
};#sim05
