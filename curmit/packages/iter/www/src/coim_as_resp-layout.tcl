ad_page_contract {
    Stampa modello H impianto
    
    @author Giulio Laurenzi
    @creation-date 13/04/2004

    @cvs-id coim_as_resp-layout.tcl

    @param codice_as_resp

    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 31/08/2023 Ticket 9261 aggiornati i riferimenti a normative obsolete e aggiunto 
    ric01            diciture richieste. Sandro ha detto che va bene per tutti.

    rom01 12/10/2020 Sandro ha detto che va mostrato sempre il nome e cognome del proprietario
    rom01            e non del responsabile. Vale per tutti gli enti.

    sim02 18/09/2019 Corretto salvataggio del file sul file system e non sul db per la regione marche 

    nic01 22/06/2016 Per la Regione Calabria, abbiamo aggiunto "Area di" prima della denom
    nic01            comune ma solo se il flag_ente e' P (Provincia).

    sim01 21/06/2016 Aggiunta del logo alla stampa utilizzando i parametri stampe_logo_nome 
    sim01            e stampe_logo_in_tutte_le_stampe.
    
} {
    {cod_as_resp             ""}
    {last_cod_as_resp        ""}
    {funzione            "V"}
    {caller          "index"}
    {nome_funz            ""}
    {nome_funz_caller     ""}
    {extra_par            ""}
    {cod_impianto         ""}
    {url_aimp             ""} 
    {url_list_aimp        ""}
    {flag_tracciato       ""}
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
  # set id_utente [ad_get_cookie iter_login_[ns_conn location]]
    set id_utente [iter_get_id_utente]
}

set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]

set link_tab [iter_links_form $cod_impianto $nome_funz_caller $url_list_aimp $url_aimp]
set dett_tab [iter_tab_form $cod_impianto]

# controllo il parametro di "propagazione" per la navigation bar
if {[string is space $nome_funz_caller]} {
    set nome_funz_caller $nome_funz
}

# Personalizzo la pagina
set link_list_script {[export_url_vars last_cod_as_resp caller nome_funz_caller nome_funz cod_impianto  url_list_aimp url_aimp]&[iter_set_url_vars $extra_par]}
set link_list        [subst $link_list_script]
set page_title       "Stampa Modello H"

set context_bar  [iter_context_bar -nome_funz $nome_funz_caller]

iter_get_coimtgen
set flag_viario  $coimtgen(flag_viario)
set flag_ente    $coimtgen(flag_ente)
set cod_prov     $coimtgen(cod_provincia)
set sigla_prov   $coimtgen(sigla_prov)
set denom_comune $coimtgen(denom_comune)

if {$flag_ente eq "P"} {#nic01: aggiunta if e suo contenuto
    set denom_comune "Area di $denom_comune"
}

set stampe_logo_in_tutte_le_stampe [parameter::get_from_package_key -package_key iter -parameter stampe_logo_in_tutte_le_stampe -default "0"];#sim01
set stampe_logo_nome                        [parameter::get_from_package_key -package_key iter -parameter stampe_logo_nome];#sim01
set stampe_logo_height                      [parameter::get_from_package_key -package_key iter -parameter stampe_logo_height];#sim01

if {$stampe_logo_in_tutte_le_stampe eq "1" && $stampe_logo_nome ne ""} {#sim01 aggiunta if e suo contenuto
    set logo_dir [iter_set_logo_dir]

    if {$stampe_logo_height ne ""} {
        set height_logo "height=$stampe_logo_height"
    } else {
        set height_logo ""
    }

    set logo     "<tr><td ><img src=$logo_dir/$stampe_logo_nome $height_logo></td></tr>"
} else {
    set logo ""
}


db_1row sel_desc "select nome_ente, indirizzo as indirizzo_ente, tipo_ufficio as tipo_ufficio_ente from coimdesc"

if {[db_0or1row sel_as_resp ""] == 0} {
    iter_return_complaint  "Dati Scheda non trovati</li>"
    return
}

db_1row query "select case when fornitore_energia_p = 't' then 'di essere fornitore di energia'
                           when fornitore_energia_p = 'f' then 'di non essere fornitore di energia'
                           else '***** manca dichiarazione fornitura energia *****'
                      end as fornitore_energia from coim_as_resp where cod_as_resp = :cod_as_resp"


if {$flag_ente == "P"} {
	set ente "Alla c.a. $nome_ente"
} elseif {$flag_ente == "C"} {
	set ente "Alla c.a. $nome_ente"
}


if {$flag_tracciato == "LMANU"} {
    append stampa "
		<table width=100% align=center>
			<!-- <tr><td >Regione Friuli</td></tr>
			<tr><td >&nbsp;</td></tr>
			<tr><td >&nbsp;</td></tr> -->
			<tr><td >&nbsp;</td></tr>
			<tr><td >&nbsp;</td></tr> 
			<tr><td ><i>Allegato L - Modello per Amministratori di condominio</i></td></tr> 
			<tr><td ><table>
	                       <tr><td width=60%>&nbsp;</td>
	                           <td width=40%><b>$ente
	                                     <br>Ente locale responsabile dei controlli D.lgs 192/05 e s.m.i.
	                                     <br>$tipo_ufficio_ente
	                                     <br>$indirizzo_ente
	                                     <br>$denom_comune $sigla_prov</b>
	                           </td>
	                       </tr>
	                 </table>
				</td>
			</tr>
			<tr><td >&nbsp;</td></tr>
			<tr><td ><b>Oggetto: comunicazione di assunzione del ruolo di responsabile per l'esercizio e la comunicazione degli impianti termici 
								in qualità di amministratore di condominio (art.7 D-lgs 192/05 e s.m.i.)</b></td></tr>
			<tr><td >&nbsp;</td></tr>		
			<tr>
			   <td  align=left class=form_title width=20%>Il sottoscritto $cognome_legale $nome_legale</td>
			</tr>
			<tr>
			   <td  align=left class=form_title width=20%>In qualità Amministratore
			   </td>
			</tr>
			<tr><td >&nbsp;</td></tr>	
			<tr>
			   <td width=100%  align=center><b>Comunica</b></td>
			</tr>		
			<tr>
				<td width=100%>
			   		<table>"
						

	if {$swc_inizio_fine == "inizio"} {
		set nome_condominio_1 	$nome_condominio
		set ind_condominio_1 	"$toponimo $indirizzo, $numero $esponente - $descr_comune"
		append stampa "	
						<tr>
							<td align=left valign=top width=3%>X</td>
		    				<td align=left >di aver assunto l'incarico di Amministratore del Condominio $nome_condominio_1 sito in 
											 $ind_condominio_1 dalla data del $data_inizio</td>
						</tr>"   
	}
	
	if {$swc_inizio_fine == "fine"} {
		set nome_condominio_2	$nome_condominio
		set ind_condominio_2 	"$toponimo $indirizzo, $numero $esponente - $descr_comune"
		append stampa "	<tr>
							<td align=left valign=top width=3%>X</td>
							<td align=left >di non essere pi&ugrave; Amministratore del Condominio $nome_condominio_2 sito in 
														$ind_condominio_2 dalla data del $data_fine</td>
						</tr>"
	}
	
	append stampa "
				</table>
			</td>
		</tr>
		<tr><td >&nbsp;</td></tr>
		<tr>
		   <td align=center class=form_title valign=top><b>e pertanto responsabile per l'esercizio e la manutenzione dell'impianto di</b></td>
		</tr>
		<tr><td>$cod_utgi</td></tr>
		<tr>
		   <td align=left class=form_title valign=top>catasto impianti/codice $cod_impianto_est</td>
		</tr>
		<tr>
		   <td width=100% >
		   <table width=100%>
		     <tr nowrap>
		       	<td valign=top align=left class=form_title >Indirizzo $toponimo $indirizzo</td>
		       	<td valign=top align=left class=form_title >N&deg; Civ. $numero $esponente</td>
	 			<td valign=top align=left class=form_title>Comune $descr_comune</td>
		     </tr>
		   </table>
		</td></tr>
		<!-- <tr>
		   <td valign=top align=left class=form_title>Localit&agrave; $localita
		   </td>
		</tr> -->		
		<tr>
		   <td  align=left class=form_title width=20%>di propriet&agrave; di $cognome_resp $nome_resp
		   </td>
		</tr>
		<tr>
		   <td  align=left class=form_title width=20%>composto dai seguenti generatori di calore:
		   </td>
		</tr>
		"
	
	append stampa "<tr><td><table>"
	
	db_foreach sel_gen_aimp2 "select gen_prog , iter_edit_num(potenza, 2) as potenza , b.descr_comb as cod_combustibile
	                            from coimgend_as_resp a
	                 			left outer join coimcomb b on b.cod_combustibile = a.cod_combustibile
	                           	where cod_as_resp = :cod_as_resp
	                           	order by gen_prog" {
		append stampa "
		    			<tr>
					        <td valign=top align=left width=10%>G$gen_prog</td>
					        <td valign=top align=left width=60% nowrap>potenza termica del focolare nominale di $potenza kW</td>
					        <td valign=top align=left width=30% nopwrap>Combustibile $cod_combustibile</td>
						</tr>"					
	}
	append stampa "
		</table></td></tr>
		<tr><td >&nbsp;</td></tr>
		<tr><td valign=top align=left class=form_title>Firma ..........................................................................................................</td></tr>
		<tr><td valign=top align=left class=form_title>Ragione sociale della Ditta $cognome_manu $nome_manu</td></tr>
		<tr><td valign=top align=left class=form_title>Nome e cognome del legale rappresentante $cognome_legale $nome_legale</td></tr>
		<tr><td valign=top align=left class=form_title>Indirizzo $ind_legale</td></tr>
		<tr><td valign=top align=left class=form_title>Telefono $tel_legale  Cellulare $cell_legale  Fax $fax_legale</td></tr>
		<tr><td valign=top align=left class=form_title>E-mail $email_legale</td></tr>
		<tr><td >&nbsp;</td></tr>
		<tr><td valign=top align=left class=form_title>Nominativo del fornitore di energia: $forn_energia</td></tr>"
} else {
	
	if {$flag_tracciato == "HMANU"} {
	    set inf_sup "inferiori"
	    set alleg "H"
	} else {
	    set inf_sup "superiori o uguali"
	    set alleg "I"
	}
	
    append stampa "
		<table width=100% align=center>
		<!-- <tr><td >Regione Friuli</td></tr> 
		<tr><td >&nbsp;</td></tr>
		<tr><td >&nbsp;</td></tr> -->
		<tr><td >&nbsp;</td></tr>
		$logo<!-- sim01 -->
                <tr><td >&nbsp;</td></tr>
    <!-- ric01  <tr><td ><i>Allegato $alleg - Modello per impianti $inf_sup a 35 kW</i></td></tr> -->
                <tr><td align=center><font size=\"4\"><b>Comunicazione di nomina/cessazione del terzo responsabile</b></font></td></tr><!-- ric01 -->
		<tr><td ><table>
                       <tr><td width=60%>&nbsp;</td>
                           <td nowrap width=40%><b>$ente
     							<br>Ente locale responsabile dei controlli D.lgs 192/05 e s.m.i.
                                <br>$tipo_ufficio_ente
                                <br>$indirizzo_ente
				<br>$denom_comune $sigla_prov</b>
                           </td>
                       </tr>
                 </table>
		</td></tr>
		<tr><td >&nbsp;</td></tr>
     <!-- ric01	<tr><td ><b>Oggetto: comunicazione ai sensi dell'art.11, comma 6, del DPR 412/93.</b></td></tr> -->
                <tr><td ><b>Oggetto: Comunicazione di responsabilità dell'impianto termico</b></td></tr> <!-- ric01 -->
		<tr>
		   <td  align=left class=form_title width=20%>Il sottoscritto $cognome_legale $nome_legale
		   </td>
		</tr>
		<tr>
		   <td  align=left nowrap>Legale rappresentante della Ditta $cognome_manu $nome_manu</td>
		</tr>
		<tr>
		   <td  align=left class=form_title width=21% nowrap>iscritta alla CCIAA di $localita_reg, al numero $reg_imprese, 
															abilitata ad operare per gli impianti di cui alle lettere:</td>
		</tr>
		<tr>
		   <td width=100% >
		   <table width=80%>
		    <tr>
		       <td  width=15%>&nbsp;</td>
		       <td>$flag_a a)</td>
		       <td>$flag_b b)</td>
		       <td>$flag_c c)</td>
		       <td>$flag_d d)</td>
		       <td>$flag_e e)</td>
		       <td>$flag_f f)</td>
		       <td>$flag_g g)</td>
		   </table>
		</td></tr>
		</tr>
	<!-- ric01 <tr><td >&nbsp;</td></tr> -->
		<tr>
	<!-- ric01   <td width=100% align=left>dell'articolo 1 della legge 46/90, ed in possesso dell'ulteriore requisito di:</td> -->
                 <td width=100% align=left>dell'articolo 1 del D.M. 37/08.<br>In possesso dell'ulteriore requisito di:</td> <!--ric01-->
		</tr>
		<tr>
			<td width=100%>
		   		<table>"
					
	if {![string equal $cert_uni_iso ""]} {
		append stampa "	
					<tr>
						<td align=left valign=center width=3%>X</td>
		    			<td align=left valign=center nowrap>certificazione del Sistema Qualit&agrave; ai sensi della norma UNI ISO EN $cert_uni_iso</td>
					</tr>"
	}
	
	
	
	if {![string equal $cert_altro ""]} {
		append stampa "	
					<tr>
						<td align=left width=3% valign=center>X	</td>
						<td align=left valign=center>Altro $cert_altro</td>
					</tr>"
	}
	
	append stampa "	
				</table>
			</td>
		</tr>
		<tr>
		 <!--ric01 <td width=100% align=center><b>Comunica</b></td> -->
                           <td width=100% align=center><b><u>COMUNICA</u></b></td> <!--ric01-->
		</tr>
		<tr>
			<td width=100%>
		   		<table>"
		
	if {$swc_inizio_fine == "inizio"} {
		append stampa "
					<tr>
						<td align=left width=3% valign=top>X</td>
						<td valign=top valign=center nowrap>di aver assunto l'incarico di terzo responsabile dalla data $data_inizio</td>
					</tr>"
					
	}
				
	if {$swc_inizio_fine == "fine"} {
		append stampa "
					<tr>
						<td align=left width=3% valign=center>X</td>
						<td valign=top valign=center nowrap>di non essere pi&ugrave; terzo responsabile dalla data $data_fine $causale_fine</td>
					</tr>"
	}
	
	append stampa "		
				</table>
			</td>
		</tr>
		<tr>
		   <td  align=left class=form_title valign=top>dell'impianto di $cod_utgi
		   </td>
		</tr>
		<tr>
		   <td  align=left class=form_title valign=top>catasto impianti/codice $cod_impianto_est
		   </td>
		</tr>
		<tr>
		   <td width=100% >
			   <table width=100%>
			     <tr nowrap>
			       <td valign=top align=left class=form_title >sito in $toponimo $indirizzo
			       </td>
			       <td valign=top align=left class=form_title >N&deg; Civ. $numero $esponente
			       </td>
			       <td valign=top align=left class=form_title >Scala $scala
			       </td>
			       <td valign=top align=left class=form_title >Piano $piano
			       </td>
			       <td valign=top align=left class=form_title >Int. $interno
			       </td>
			     </tr>
			   </table>
			</td>
		</tr>
		<tr>
		   <td valign=top align=left class=form_title>Comune di $descr_comune</td>
		</tr>
		<!-- <tr>
		   <td valign=top align=left class=form_title>Localit&agrave; $localita
		   </td>
		</tr> -->
		<tr>
<!--rom01	   <td valign=top align=left class=form_title>di propriet&agrave; di $cognome_resp $nome_resp -->
                   <td valign=top align=left class=form_title>di propriet&agrave; di $cognome_prop $nome_prop <!--rom01-->
		   </td>
		</tr>
		<tr>
		   <td valign=top align=left class=form_title nowrap>di potenza termica del focolare complessiva nominale di $potenza kW
		   </td>
		</tr>
		<tr><td >&nbsp;</td></tr>
		<tr>
		   <td><b>Consapevole che la dichiarazione mendace e la falsit&agrave; in atti costituiscono reati ai sensi dell'art. 76 del D.P.R. 445/00 e comportano l'applicazione della sanzione penale, ai fini dell'assunzione dell'incarico di Terzo Responsabile il sottoscritto dichiara: <u>$fornitore_energia </u></b></td>
		</tr>
                <tr><td><i>Dichiara altresì di essere informato, ai sensi e per gli effetti di cui all'articolo 10 della Legge 675/96, che i dati personali raccolti saranno trattati, anche con strumenti informatici, esclusivamente nell'ambito del procedimento per il quale la presente dichiarazione viene resa.</i> </td></tr><!--ric01-->
		<tr><td valign=top align=left class=form_title>Firma ..........................................................................................................</td></tr>
		<tr><td >&nbsp;</td></tr>
		<tr><td valign=top align=left class=form_title>Ragione sociale della Ditta $cognome_manu $nome_manu</td></tr>
		<tr><td valign=top align=left class=form_title>Nome e cognome del legale rappresentante $cognome_legale $nome_legale</td></tr>
		<tr><td valign=top align=left class=form_title>Indirizzo $ind_legale</td></tr>
		<tr><td valign=top align=left class=form_title>Telefono $tel_legale  Cellulare $cell_legale  Fax $fax_legale</td></tr>
		<tr><td valign=top align=left class=form_title>E-mail $email_legale</td></tr>
		<tr><td valign=top align=left class=form_title>A cura del committente dell'incarico di terzo responsabile:</td></tr>
		<tr><td valign=top align=left class=form_title>Nominativo del fornitore di energia: $forn_energia</td></tr>
		<tr><td valign=top align=left class=form_title>Nome e cognome/ Ragione sociale del committente $committente</td></tr>
		<tr><td valign=top align=left class=form_title>Firma del committente* ..................................................................................</td></tr>
                <tr><td valign=top align=left class=form_title>* Nelle comunicazioni di fine responsabilità la firma del committente è obbligatoria solo in caso di revoca o decadenza, mentre è facoltativa in caso di scadenza naturale o dismissioni.</td></tr> <!--ric01-->
	
	
		</table>"
}

# imposto la directory degli spool ed il loro nome.
set spool_dir     [iter_set_spool_dir]
set spool_dir_url [iter_set_spool_dir_url]
set logo_dir      [iter_set_logo_dir]

# imposto il nome dei file
set nome_file        "stampa modello h"
if {$coimtgen(regione) eq "MARCHE"} {#sim01 if e suo contenuto
    set spool_dir_perm     [iter_set_permanenti_dir]
    set spool_dir_url_perm [iter_set_permanenti_dir_url]
    set nome_file         [iter_temp_file_name -permanenti $nome_file]
    set file_html        "$spool_dir_perm/$nome_file.html"
    set file_pdf         "$spool_dir_perm/$nome_file.pdf"
    set file_pdf_url     "$spool_dir_url_perm/$nome_file.pdf"
} else {#sim02 
    set nome_file        [iter_temp_file_name $nome_file]
    set file_html        "$spool_dir/$nome_file.html"
    set file_pdf         "$spool_dir/$nome_file.pdf"
    set file_pdf_url     "$spool_dir_url/$nome_file.pdf"
};#sim02


set   file_id  [open $file_html w]
fconfigure $file_id -encoding iso8859-1
puts  $file_id $stampa
close $file_id

# lo trasformo in PDF
iter_crea_pdf [list exec htmldoc --webpage --header ... --footer ... --quiet --bodyfont arial --left 1cm --right 1cm --top 0cm --bottom 0cm -f $file_pdf $file_html]

# Controllo se il Database e' Oracle o Postgres
set id_db     [iter_get_parameter database]

set sql_contenuto  "lo_import(:file_html)"
set tipo_contenuto [ns_guesstype $file_pdf]

set contenuto_tmpfile  $file_pdf

with_catch error_msg {
    db_transaction {
	db_1row sel_docu_next ""
	set tipo_documento "MH"
	db_dml dml_sql_docu [db_map ins_docu]

	if {$coimtgen(regione) eq "MARCHE"} {#sim02 if e suo contenuto

	                            db_dml q "update coimdocu
                                     set tipo_contenuto = 'application/pdf'
                                       , path_file      = :file_pdf
                                   where cod_documento  = :cod_documento"

	} else {#sim02
	    	
	    if {$id_db == "postgres"} {
		if {[db_0or1row sel_docu_contenuto ""] == 1} {
		    if {![string equal $docu_contenuto_check ""]} {
			db_dml dml_sql2 [db_map upd_docu_2]
		    }
		}
		db_dml dml_sql3 [db_map upd_docu_3]
	    } else {
		db_dml dml_sql2 [db_map upd_docu_2] -blob_files [list $contenuto_tmpfile]
	    }
	    
	};#sim02
    }
} {
    iter_return_complaint "Spiacente, ma il DBMS ha restituito il
        seguente messaggio di errore <br><b>$error_msg</b><br>
        Contattare amministratore di sistema e comunicare il messaggio
        d'errore. Grazie."
}


ns_unlink $file_html
ad_returnredirect $file_pdf_url
ad_script_abort
