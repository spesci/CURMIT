<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================================================
    mat01 17/03/2026 Aggiunta la gestione delle deleghe e il tecnico.
    
    gia01 05/11/2021 Rimosso dalla stampa la dicitura "allegato ... (articolo 4, comma 1, L.R. 19/2015)." Perchè Sandro ha
    gia01            richiesto non apparisse.

    rom03 06/07/2020 Corretto il nome di alcune variabili che facevano andare in errore la stampa se non si era su
    rom03            Regione Marche.

    rom02 17/01/2019 Fatte modifiche per impianti del freddo richiesti dalle Marche.

    rom01 16/11/2018 Fatte diverse modifiche alla stampa su richiesta della Regione Marche.
-->
<table width="100%">
    <tr>
        <td align="right" valign="top">
          <small>Pagina @pagina_corrente@ di @tot_pagine@</small>
        </td>
    </tr>
</table>
<br>
<if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if-->
<table border="0">
    <tr>
        <td align="center" width="35%">
        <b>
            @ente@<br>
            @ufficio@
        </b>
        </td>
        <td width="65%">
        <table width="100%" border="1" cellspacing="3" cellpadding="3">
            <tr>
            <td rowspan="2" valign="top">
                <b>Luogo di emissione</b><br>
                <br>
                @denom_comune@
            </td>
            <td>
                <b>Numero</b>
            </td>
            <td rowspan="2" valign="top">
                <b>Pagine</b><br>
                <br>
                @tot_pagine@
            </td>
            </tr>
            <tr>
            <td valign="top">
                <b>Data</b> @data_dich@
            </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
</if>
<if @coimtgen.regione@ eq "MARCHE"><!--rom01 aggiunta if -->
  <table width=100% border=0>
    <tr>
      <td width=100% align=center>
	<table width=100% border=0>
	  <tr>
	    <td width=20%>@logo;noquote@</td>
            <td width=60% align=center>
	      <table>
		<tr><td align=center><b>@ente@</b></td></tr>
		<tr><td align=center><b>@ufficio@</b></td></tr>
		<tr><td align=center>@assessorato@</td></tr>
		<tr><td align=center>@indirizzo_ufficio@</td></tr>
		<tr><td align=center>@telefono_ufficio@</td></tr>
	      </table>
	    </td>
	    <td align=center width=20%>@logo_dx;noquote@</td>
	  </tr>
	</table>
      </td>
    </tr>
  </table>
</if>

<!--rom01 aggiunta condizione su rgione "MARCHE"-->
<if @pagina_corrente@ eq "1" and @coimtgen.regione@ ne "MARCHE">
<!--gia01
    <table width="100%">
        <tr>
            <td align="right">
                <b>Allegato <if @flag_tipo_impianto@ eq "R">4</if><else>5</else> (articolo 4, comma 1, L.R. 19/2015)</b>
            </td>
        </tr>
    </table>    
 -->
</if>
<br>
<!--rom01 spostata ad inizio pagina
<table width="100%">
    <tr>
        <td align="right">
        Pag. @pagina_corrente@ di @tot_pagine@
        </td>
    </tr>
</table>
-->
<if @pagina_corrente@ eq "1">
  <if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if-->
    <center>
      <h2>DICHIARAZIONE</h2>
      <h4>
        FREQUENZA ED ELENCO DELLE OPERAZIONI DI CONTROLLO E MANUTENZIONE AL FINE DI GARANTIRE LA 
        SICUREZZA DELLE PERSONE E DELLE COSE PER IMPIANTI TERMICI CON 
        <if @flag_tipo_impianto@ eq "R">GENERATORI DI CALORE A FIAMMA</if>
        <else>MACCHINE FRIGO / POMPE DI CALORE</else>
      </h4>
      (Articolo 7, D.Lgs. 192/2005 e s.m.i. e articolo 7, D.P.R. 74/2013 e s.m.i.)
    </center>
  </if>
  <if @coimtgen.regione@ eq "MARCHE"><!--rom01 aggiunta if e contenuto-->
    <center>
      <h2>DICHIARAZIONE</h2>
      <h4>
	<if @flag_tipo_impianto@ ne "F">
          FREQUENZA ED ELENCO DELLE OPERAZIONI DI CONTROLLO E MANUTENZIONE AL FINE DI GARANTIRE LA SICUREZZA
	  <br>DELLE PERSONE E DELLE E ASSICURARE IL RISPETTO DEI VALORI LIMITE DI EMISSIONI,
	<br>PER IMPIANTI TERMICI CON GENERATORI DI CALORE A FIAMMA
      </h4>
      (Articolo 7, D.Lgs. 192/2005 e s.m.i. e articolo 7, D.P.R. 74/2013 e s.m.i.; art. 284 D.Lgs. 152/2006 e s.m.i.)
      </if>
      <if @flag_tipo_impianto@ eq "F">
	FREQUENZA ED ELENCO DELLE OPERAZIONI DI CONTROLLO E MANUTENZIONE AL FINE DI GARANTIRE
	<br>LA SICUREZZA DELLE PERSONE, PER IMPIANTI TERMICI CON MACCHINE FRIGO / POMPE DI CALORE
</h4>
(Articolo 7, D.Lgs. 192/2005 e s.m.i. e articolo 7, D.P.R. 74/2013 e s.m.i.)
</if>
</center>
</if>  
      <p>
        <b>Il/La Sottoscritto/a:</b> @nome_dichiarante@ @cognome_dichiarante@
        <b>In qualità di </b> 
        <if @flag_dichiarante@ eq "L">
            Legale Rappresentante 
        </if>
        <if @flag_dichiarante@ eq "R">
            Responsabile Tecnico 
        </if>
        <if @flag_dichiarante@ eq "T">
            Tecnico specializzato 
        </if>
    </p>
    <p><b>della ditta</b> @nome_manu@ @cognome_manu@ <b>Partita IVA</b> @cod_piva@</p>
    <p><b>con sede sita in</b> @indirizzo_manu@</p>
    <p><b>Comune</b> @comune_manu@ <b>Provincia</b> @provincia_manu@</p>
    <p>
        <if @telefono@ ne "">
            <b>Telefono</b> @telefono@ 
        </if>
        <if @fax@ ne "">
            <b>FAX</b> @fax@
        </if>
        <if @email@ ne "">
            <b>E-mail</b> @email@
        </if>
    </p>
    <if @nome_op@ ne "" or @cognome_op@ ne ""><p><b>Tecnico</b> @nome_op@ @cognome_op@</p></if><!--mat01 aggiunto if e contenuto-->
    <if @nome_manu_dele@ ne "" or @cognome_manu_dele@ ne ""><p><b>Ditta delegante</b> @nome_manu_dele@ @cognome_manu_dele@</p></if><!--mat01 aggiunto if e contenuto-->
    <if @cognome_op_dele@ ne "" or @nome_op_dele@ ne ""><p><b>Tecnico che ha effettuato il controllo su delega</b> @nome_op_dele@ @cognome_op_dele@</p></if><!--mat01 aggiunto if e contenuto-->

    <p><b>Iscritta alla CCIAA di</b> @localita_reg@ <b>al numero</b> @reg_imprese@</p>
    <p>
        <b>Abilitata ad operare per gli impianti di cui alle lettere:</b><br>
        <table width="100%">
	  <if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if -->
            <tr>
              <td>
                <if @flag_a@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                </else> a
              </td>
              <td>
                <if @flag_b@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                        <img src="@img_unchecked@" height="12" width="12">
                </else> b
              </td>
              <td>
                <if @flag_c@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                </else> c
              </td>
              <td>
                <if @flag_d@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                </else> d
              </td>
              <td>
                <if @flag_e@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                </else> e
              </td>
              <td>
                <if @flag_f@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                    </else> f
              </td>
              <td>
                <if @flag_g@ true>
                  <img src="@img_checked@" height="12" width="12">
                </if>
                <else>
                  <img src="@img_unchecked@" height="12" width="12">
                </else> g
              </td>
            </tr>
	  </if>
	  <if @coimtgen.regione@ eq "MARCHE"><!--rom01 aggiunta if e contenuto-->
            <tr>
	      <td width="5%">
		<if @flag_a@ true>
		  <img src="@img_checked@" height="12" width="12">
		</if>
		<else>
		  <img src="@img_unchecked@" height="12" width="12">
		</else> a
	      </td>
	      <td width="5%">
		<if @flag_c@ true>
		  <img src="@img_checked@" height="12" width="12">
		</if>
		<else>
		  <img src="@img_unchecked@" height="12" width="12">
		</else> c
	      </td>
	      <td width="5%">
		<if @flag_e@ true>
		  <img src="@img_checked@" height="12" width="12">
		</if>
		<else>
		  <img src="@img_unchecked@" height="12" width="12">
		</else> e
	      </td>
	      <td> dell'articolo 1 del D.M. 37/08
	      </td>
	    </tr>
	  </if>
        </table>
    </p>
  <p>
        <b>In qualità di </b> 
        <if @flag_tipo_tecnico@ eq "I">
            Installatore 
        </if> 
        <if @flag_tipo_tecnico@ eq "M">
            Manutentore 
        </if>
    </p>
    <p><b>Dell'impianto adibito a</b> @utilizzo@</p><!--rom01 modificata dicitura-->
    <p><b>Catasto Impianti / Codice</b> @cod_impianto_est@</p>
    <p><b>sito in via/strada/piazza </b> @indirizzo_imp@ @numero_imp@ @esponente_imp@ @scala_imp@ @piano_imp@ @interno_imp@</p>
    <p><b>Comune</b> @comune_imp@ <b>Provincia</b> @provincia_imp@</p>
    <if @flag_tipo_impianto@ eq "F">
        <p><b>Della potenza frigorifera nominale complessiva in raffrescamento pari a </b>@pot_nom_raff@ kW</p>
        <p><b>Della potenza termica nominale complessiva in riscaldamento pari a </b>@pot_nom_risc@ kW</p>
        <p><b>N° Gruppi frigo / PDC presenti </b>@num_generatori@</p>
    </if>
    <else>
        <p><b>Di potenza termica nominale utile complessiva pari a </b> @pot_nom_risc@ kW <b>N° Gruppi termici presenti </b>@num_generatori@</p><!--rom01 cambiata dicitura-->
	<if @coimtgen.regione@ ne "MARCHE"><!--rom01-->
        <p><b>Combustibile:</b> @combustibile@</p>
	</if>
    </else>        
    <if @coimtgen.regione@ ne "MARCHE"><!--rom01-->
      <p><b>Nominativo del fornitore di energia:</b> @fornitore_energia@</p>
      </if>
    <p><b>Responsabile dell'impianto:</b> cognome @cognome_resp@ nome @nome_resp@</p>
    <p>
        <b>In qualità di </b> 
        <if @flag_resp@ eq "O">
            Occupante 
        </if>
        <if @flag_resp@ eq "P">
            Proprietario 
        </if>
        <if @flag_resp@ eq "A">
            Amministratore 
        </if>
        <if @flag_resp@ eq "T">
            Terzo Responsabile 
        </if>
    </p>
    <center>
        <h4>VISTI</h4>
    </center>
    
    <p>
        <table width="100%">
            <tr>
                <td>
                    <if @flag_doc_tecnica@ true>
                        <img src="@img_checked@" width="12" height="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" width="12" height="12">
                    </else> La documentazione tecnica rilasciata dal progettista dell'impianto
                </td>
            </tr>
            <tr>
                <td>
                    <if @flag_istr_tecniche@ true>
                        <img src="@img_checked@" width="12" height="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" width="12" height="12">
                    </else> Le istruzioni tecniche per l'uso e la manutenzione rese disponibili dall'impresa installatrice
                </td>
            </tr>
            <tr>
                <td>
                    <if @flag_man_tecnici@ true>
                        <img src="@img_checked@" width="12" height="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" width="12" height="12">
                    </else> I manuali tecnici di uso e manutenzione elaborati dal costruttore degli apparecchi e componenti
                </td>
            </tr>
            <tr>
                <td>
                    <if @flag_reg_locali@ true>
                        <img src="@img_checked@" width="12" height="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" width="12" height="12">
                    </else> I regolamenti locali
                </td>
            </tr>
            <tr>
                <td>
                    <if @flag_norme_uni_cei@ true>
                        <img src="@img_checked@" width="12" height="12">
                    </if>
                    <else>
                        <img src="@img_unchecked@" width="12" height="12">
                    </else> Le norme UNI e CEI applicabili per lo specifico elemento o tipo di apparecchio/dispositivo
                </td>
            </tr>
            <tr>
                <td>
                    Altro: @altri_doc@
                </td>
            </tr>
        </table>
    </p>
    
    <p>
        <br>
        In conformit&agrave; con quanto stabilito dall'articolo 7, del D.Lgs. 192/2005 s s.m.i. e del comma 
        4 articolo 7, del D.P.R. 74/2103 e s.m.i.<if @flag_tipo_impianto@ ne "F">, nonch&egrave; dall'articolo 284 del D. Lgs. 152/2006</if>,
	nell'ambito della propria responsabilità
    </p>
    <center>
        <h4>DICHIARA</h4>
    </center>
    <p>
      Al fine di garantire la sicurezza delle persone e delle cose<if @flag_tipo_impianto@ ne "F"> e assicurare il rispetto dei valori
      limite di emissioni,</if> devono essere necessariamente effettuate le operazioni di controllo e
      manutenzione specificate nell'elenco riportato nella presente dichiarazione con la frequenza all'uopo indicata.
    </p>
    <p>
        La presente dichiarazione, completa dell'elenco delle operazioni di controllo e manutenzione
        e delle frequenze con cui queste ultime debbono essere effettuate, viene consegnata al
        Responsabile di Impianto ed allegata al Libretto d'Impianto, del quale diviene parte integrante.
    </p>
</if>
<else>
    <center>
        <h4><u>ELENCO E FREQUENZA DELLE OPERAZIONI DI CONTROLLO E MANUTENZIONE</u></h4>
    </center>

    <multiple name="operazioni">
        <table width="100%" border="1">
            <tr>
                <td colspan="2">
                    <table border="0" width="100%">
                        <if @flag_tipo_impianto@ eq "R">
                            <tr>
                                <td><b>Gruppo termico:</b>              @operazioni.gen_prog@</td>
                                <td><b>Data Installazione:</b>          @operazioni.data_installaz@</td>
				<td><b>Combustibile:</b>                @combustibile_gen@</td><!--rom01-->
                                <td><b>Pot. termica nominale utile:</b> @operazioni.pot_utile_nom@ kW</td>
                            </tr>
                            <tr>
                                <td><b>Fabbricante:</b> @operazioni.fabbricante@</td>
                                <td><b>Modello:</b>     @operazioni.modello@</td>
                                <td><b>Matricola:</b>   @operazioni.matricola@</td>
                            </tr>
                        </if>
                        <elseif @flag_tipo_impianto@ eq "F">
                            <tr>
                                <td>
                                    <table border="0" width="100%">
                                        <tr>
                                            <td width="33%"><b>Gruppo Frigo/PDC: GF</b>         @operazioni.gen_prog@</td>
                                            <td width="33%"><b>Data Installazione:</b>          @operazioni.data_installaz@</td>
                                            <td width="33%"><b>Fluido frigorigeno:</b>          @operazioni.fluido_refrigerante@</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table border="0" width="100%">
                                        <tr>
                                            <td width="33%"><b>Fabbricante:</b> @operazioni.fabbricante@</td>
                                            <td width="33%"><b>Modello:</b>     @operazioni.modello@</td>
                                            <td width="33%"><b>Matricola:</b>   @operazioni.matricola@</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
			    <if @coimtgen.regione@ ne "MARCHE"><!--rom02 aggiunta if, aggiunta else e contenuto-->
			    <tr>
                                <td>
                                    <b>Ad assorbimento: </b>
                                    <img src="@img_unchecked@" width="12" height="12"> recupero di calore
                                    <img src="@img_unchecked@" width="12" height="12"> fiamma diretta combust.
                                    <img src="@img_unchecked@" width="12" height="12"> a compressione motore elettrico/endotermico
                                </td>
			    </tr>
			    </if> <else>
			      <tr>
				<td><b>Sistema di azionamento:</b></td>
			      </tr>
			      <tr>
				<td>
				  @img_compr_mot_elet;noquote@ A ciclo di compressione con motore elettrico
				  @img_compr_mot_endo;noquote@ A ciclo di compressione con motore endotermico
				  @img_assor_rec_calo;noquote@ Ad assorbimento per recupero di calore
				 <br> @img_assor_fia_dire;noquote@ Ad assorbimento a fiamma diretta @label_combustibile;noquote@
				</td>
			      </tr>
			      </else><!--rom02-->
                            <tr>
                                <td>
                                    <table border="0" width="100%">
                                        <tr>
                                            <td width="50%"><b>Potenza frigorifera nominale in raffrescamento:</b> @operazioni.pot_nom_raff@ kW</td>
                                            <td width="50%"><b>Potenza termica nominale in riscaldamento:</b> @operazioni.pot_nom_risc@ kW</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </elseif>
                    </table>
                </td>
            </tr>
            <tr>
                <td><b>OPERAZIONE</b></td><td><b>FREQUENZA IN MESI</b></td><!--rom01 modificata label frequenza-->
            </tr>
            <group column="gen_prog">
                <tr>
                    <td>@operazioni.operazione@</td><td>@operazioni.frequenza@</td>
                </tr>
            </group>
        </table>
        <small>
            Nota: le operazioni di manutenzione e la loro frequenza devono essere riferite anche a tutte le apparecchiature collegate al gruppo<if @flag_tipo_impianto@ ne "F"> termico</if><else>frigo/PDC</else>
        </small>
        <br><br>
    </multiple>

    <table>
    <tr>
        <td colspan="2">
            <br>
            <small><b>Data</b></small> @data_dich@
            <br><br><br>
        </td>
    </tr>
    <tr>
        <td align="center">
            <h6>Firma del Legale Rappresentante o del Responsabile Tecnico o del Tecnico Specializzato e timbro della ditta</h6><br>
            ..............................................................................
        </td>
     <!--   <td align="center">
            <h6>Firma del Legale Rappresentante o del Responsabile Tecnico e timbro della ditta</h6><br>
            ..............................................................................
        </td> -->
    </tr>
    <tr>
        <td colspan="2">
            <br>
        </td>
    </tr>
    <tr>
        <td>
            <br><br>
            <table border="1" width="100%">
                <tr>
                <td><br><br><br><br><br></td>
                </tr>
            </table>
        </td>
      <tr>
          <tr></tr>
              <td align="center">
            <h6>Firma del responsabile dell'impianto (per presa visione)</h6><br><!--rom01 modificata label-->
            ..............................................................................
        </td> 
      </tr>

    </tr>
    </table>
</else>
