<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric02 25/11/2024 MEV Regione Marche ordine 00061/2022 riga 3.

    ric01 09/06/2023 Aggiunti nuovi criteri aggiuntivi per estrazione impianti solo per regione Marche.

    rom05 13/01/2023 Aggiunto nuovo campo di ricerca Per Soggetto presente nello storico RCEE solo per Palermo.

    rom04 10/01/2022 Aggiunto nuovo campo di ricerca POD su segnealazione di Regione Marche.

    rom03 08/03/2019 La Regione Marche ha richiesto la modifica dei filtri di ricerca di un Impianto.

    rom02 19/07/2018 Su richiesta di Sandro aggiunto botton per sbiancare i filtri inseriti.

    rom01 26/10/2016 Tolto /G/F da Situazione RCEE

    sim02 06/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim02            visualizzo il campo targa e non il cod impianto princ.

    sim01 10/09/2014 Aggiunto nuovo campo cod_impianto_princ
-->

<master   src="../master">
  <property name="title">@page_title;noquote@</property>
  <property name="context_bar">@context_bar;noquote@</property>

  <center>
    <formtemplate id="@form_name;noquote@">
      <formwidget   id="funzione">
	<formwidget   id="caller">
	  <formwidget   id="nome_funz">
	  <formwidget   id="receiving_element"><!-- sim01 -->
	    <formwidget   id="f_cod_via">
	      <formwidget   id="f_cod_manu">
		<formwidget   id="dummy">
		  <if @flag_ente@ eq "C">
		    <formwidget id="f_comune">
		  </if>
		  <!-- Inizio della form colorata -->

		  <%=[iter_form_iniz]%>
		  <tr>
		    <td>
		      <table border=0>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=left class=form_title colspan=1 nowrap>
			    <b>CRITERI PRINCIPALI</b>
			  </td>
			  <td>&nbsp;</td>
			  <td valign=top nowrap    align=center class=form_title>
			    <b>CRITERI AGGIUNTIVI</b>
			  </td>
			  <td align=right>
			    <a href="#" onclick="javascript:window.open('coimaimp-help', 'help', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)"><b>Help</b></a>
			  </td>
			</tr>

			<tr>
			  <td valign=top nowrap align=right class=form_title width=10%>
			    <b>Ricerca per Codice</b>
			  </td>
			  <td valign=top align=right class=form_title width=13% nowrap>Codice Impianto</td>
			  <td valign=top width=25%><formwidget id="f_cod_impianto_est">
			      <formerror  id="f_cod_impianto_est"><br>
				<span class="errori">@formerror.f_cod_impianto_est;noquote@</span>
			      </formerror>
			  </td>

			  <td valign=top align=right class=form_title width=17%>Da Potenza (kW)</td>
			  <td valign=top><formwidget id="f_potenza_da">
			      <formerror id="f_potenza_da"><br>
				<span class="errori">@formerror.f_potenza_da;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title nowrap>Cod. Imp. vecchio</td>
			  <td valign=top><formwidget id="f_cod_impianto_old">
			      <formerror  id="f_cod_impianto_old"><br>
				<span class="errori">@formerror.f_cod_impianto_old;noquote@</span>
			      </formerror>
			  </td>

			  <td valign=top align=right class=form_title>A Potenza (kW)</td>
			  <td valign=top><formwidget id="f_potenza_a">
			      <formerror  id="f_potenza_a"><br>
				<span class="errori">@formerror.f_potenza_a;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>PDR</td>
			  <td valign=top><formwidget id="f_cod_utenza">
			      <formerror  id="f_cod_utenza"><br>
				<span class="errori">@formerror.f_cod_utenza;noquote@</span>
			      </formerror>
			  </td>

			  <td valign=top align=right class=form_title>Sott. DPR 412</td>
			  <td valign=top><formwidget id="f_dpr_412">
			      <formerror  id="f_dpr_412"><br>
				<span class="errori">@formerror.f_dpr_412;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<tr><!-- rom04 -->
			<td>&nbsp;</td>
			<td valign=top align=right class=form_title>POD</td>
                        <td valign=top><formwidget id="f_pod">
			  <formerror  id="f_pod"><br>
			    <span class="errori">@formerror.f_pod;noquote@</span>
			  </formerror>
			</td>
			</tr>
			<tr><!-- sim01 -->
			<!-- sim02 aggiunto if, else e contenuto dell'else -->
			<if @flag_gest_targa@ eq "F">                          
                            <td>&nbsp;</td><!-- sim01 -->
			    <td valign=top align=right class=form_title>Cod. Impianto principale</td><!-- sim01 -->
                            <td colspan=3 valign=top><formwidget id="f_cod_impianto_princ"><!-- sim01 -->
				<formerror  id="f_cod_impianto_princ"><br><!-- sim01 -->
                                  <span class="errori">@formerror.f_cod_impianto_princ;noquote@</span><!-- sim01 -->
				</formerror><!-- sim01 -->
                            </td><!-- sim01 -->
			</if>
			<else>
                            <td>&nbsp;</td><!-- sim02 -->
                            <td valign=top align=right class=form_title>Targa</td><!-- sim02-->
                            <td colspan=3 valign=top><formwidget id="f_targa"><!-- sim02-->
				<formerror  id="f_targa"><br><!-- sim02 -->
                                <span class="errori">@formerror.f_targa;noquote@</span><!-- sim02 -->
				</formerror><!-- sim02 -->
                            </td><!-- sim02 -->
                        </else>
					
			  </tr><!-- sim01 -->			  

			<tr><td>&nbsp;</td></tr>

			<tr>
			  <td valign=top align=right nowrap class=form_title>
			    <b>Ricerca per Resp.</b>
			  </td>
			  <td valign=top align=right class=form_title>Cognome</td>
			  <td valign=top><formwidget id="f_resp_cogn">
			      <formerror  id="f_resp_cogn"><br>
				<span class="errori">@formerror.f_resp_cogn;noquote@</span>
			      </formerror>
			  </td>
			  <td valign=top align=right class=form_title>Da Data Installazione</td>
			  <td valign=top><formwidget id="f_data_installaz_da">
			      <formerror id="f_data_installaz_da"><br>
				<span class="errori">@formerror.f_data_installaz_da;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Nome</td>
			  <td valign=top><formwidget id="f_resp_nome">
			      <formerror  id="f_resp_nome"><br>
				<span class="errori">@formerror.f_resp_nome;noquote@</span>
			      </formerror>
			  </td>

			  <td valign=top align=right class=form_title>A Data Installazione</td>
			  <td valign=top><formwidget id="f_data_installaz_a">
			      <formerror  id="f_data_installaz_a"><br>
				<span class="errori">@formerror.f_data_installaz_a;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<if @coimtgen.ente@ eq "PPA" and @cod_manutentore@ eq ""><!-- rom05 Aggiunta if e contenuto  -->
                          <tr>
                            <td valign=top align=left class=form_title colspan=5><b>Ricerca per soggetto presente nello storico RCEE</b></td>
			  </tr>
			  <tr>
			    <td>&nbsp;</td>
                            <td valign=top align=right class=form_title>Cognome</td>
                            <td valign=top><formwidget id="f_resp_cogn_rcee">
                              <formerror  id="f_resp_cogn_rcee"><br>
                                <span class="errori">@formerror.f_resp_cogn_rcee;noquote@</span>
                              </formerror>
                            </td>   
                          </tr>
			  <tr>
			    <td>&nbsp;</td>
                            <td valign=top align=right class=form_title>Nome</td>
                            <td valign=top><formwidget id="f_resp_nome_rcee">
                              <formerror  id="f_resp_nome_rcee"><br>
                                <span class="errori">@formerror.f_resp_nome_rcee;noquote@</span>
                              </formerror>
                            </td>   
                          </tr>

			</if>
			<tr><td>&nbsp;</td></tr>
			<tr>
			  <td valign=top nowrap align=right class=form_title>
			    <b>Ricerca per Indirizzo</b>
			  </td>

			  <if @flag_ente@ eq "P">
			    <td valign=top align=right class=form_title>Comune</td>
			    <td valign=top><formwidget id="f_comune">
				<formerror  id="f_comune"><br>
				  <span class="errori">@formerror.f_comune;noquote@</span>
				</formerror>
			    </td>
			  </if>
			  <else>
			    <td valign=top align=right class=form_title>Quartiere</td>
			    <td valign=top><formwidget id="f_quartiere">
				<formerror  id="f_quartiere"><br>
				  <span class="errori">@formerror.f_quartiere;noquote@</span>
				</formerror>
			    </td>
			  </else>

			  <td valign=top align=right class=form_title>Stato dichiarazione</td>
			  <td valign=top><formwidget id="f_flag_dichiarato">
			      <formerror  id="f_flag_dichiarato"><br>
				<span class="errori">@formerror.f_flag_dichiarato;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td valign=top nowrap align=right class=form_title>Indirizzo</td>
			  <td valign=top nowrap><formwidget id="f_desc_topo">
			      <formwidget id="f_desc_via">@cerca_viae;noquote@
				<formerror  id="f_desc_via"><br>
				  <span class="errori">@formerror.f_desc_via;noquote@</span>
				</formerror>
			  </td>

			  <td valign=top align=right class=form_title> 
			    Stato conformit&agrave;
			  </td>
			  <td valign=top><formwidget id="f_stato_conformita">
			      <formerror  id="f_stato_conformita"><br>
				<span class="errori">@formerror.f_stato_conformita;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Da Civico</td>
			  <td valign=top><formwidget id="f_civico_da"> A
			      <formwidget id="f_civico_a">
				<formerror  id="f_civico_da"><br>
				  <span class="errori">@formerror.f_civico_da;noquote@</span>
				</formerror>
			  </td>

			  <td valign=top align=right class=form_title>Combustibile</td>
			  <td valign=top><formwidget id="f_cod_combustibile">
			      <formerror  id="f_cod_combustibile"><br>
				<span class="errori">@formerror.f_cod_combustibile;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<if @flag_multivie@ eq "T">
			  <tr>
			    <td>&nbsp;</td>
			    <td align=right><formgroup id="cerca_multivie">@formgroup.widget;noquote@</formgroup>
			      <formerror  id="cerca_multivie"><br>
				<span class="errori">@formerror.cerca_multivie;noquote@</span>
			      </formerror>
			    </td>
			    <td valign=top align=left class=form_title>Cerca anche nelle vie associate</td>
			    <td valign=top align=right class=form_title>Da data Verifica</td>
			    <td valign=top><formwidget id="f_da_data_verifica">
				<formerror  id="f_da_data_verifica"><br>
				  <span class="errori">@formerror.f_da_data_verifica;noquote@</span>
				</formerror>
			    </td>
			  </tr>
			</if>
			<else>
			  <tr>
			    <td valign=top align=right class=form_title>&nbsp;</td>
			    <td valign=top align=right class=form_title>&nbsp;</td>
			    <td valign=top align=right class=form_title>&nbsp;</td>
			    <td valign=top align=right class=form_title>Da data Verifica</td>
			    <td valign=top><formwidget id="f_da_data_verifica">
				<formerror  id="f_da_data_verifica"><br>
				  <span class="errori">@formerror.f_da_data_verifica;noquote@</span>
				</formerror>
			    </td>
			  </tr>
			</else>
			<tr>
			  <td valign=top align=right class=form_title>&nbsp;</td>
			  <td valign=top align=right class=form_title>&nbsp;</td>
			  <td valign=top align=right class=form_title>&nbsp;</td>
			  <td valign=top align=right class=form_title>A data Verifica</td>
			  <td valign=top><formwidget id="f_a_data_verifica">
			      <formerror  id="f_a_data_verifica"><br>
				<span class="errori">@formerror.f_a_data_verifica;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr><td>&nbsp;</td></tr>
			<tr>
			  <td valign=top nowrap align=right class=form_title>
			    <b>Ricerca per Manut.</b>
			  </td>         
			  <td valign=top align=right class=form_title>Cognome</td>
			  <td valign=top><formwidget id="f_manu_cogn">
			      <formerror  id="f_manu_cogn"><br>
				<span class="errori">@formerror.f_manu_cogn;noquote@</span>
			      </formerror>
			  </td>   

			  <td valign=top align=right class=form_title>Tipologia</td>
			  <td valign=top><formwidget id="f_cod_tpim">
			      <formerror  id="f_cod_tpim"><br>
				<span class="errori">@formerror.f_cod_tpim;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Nome</td>
			  <td valign=top><formwidget id="f_manu_nome">@cerca_manu;noquote@
			      <formerror  id="f_manu_nome"><br>
				<span class="errori">@formerror.f_manu_nome;noquote@</span>
			      </formerror>
			  </td>   

			  <td valign=top align=right class=form_title>Dest. uso edificio</td>
			  <td valign=top><formwidget id="f_cod_tpdu">
			      <formerror  id="f_cod_tpdu"><br>
				<span class="errori">@formerror.f_cod_tpdu;noquote@</span>
			      </formerror>
			  </td>
			</tr>

		<if @coimtgen.regione@ eq "MARCHE"> <!-- ric02 aggiunta if e suo contenuto -->
			<if @sw_manu@> <!-- ric02 aggiunta if e suo contenuto -->
			    <tr>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>			    
			   	<td valign=top align=right class=form_title>DFM presente</td>
                             	<td valign=top><formwidget id="f_dfm_manu">
                                    <formerror  id="f_dfm_manu"><br>
                                     <span class="errori">@formerror.f_dfm_manu;noquote@</span>
                                    </formerror>
                             	</td>
			    </tr>

			    <tr>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>
			       	<td valign=top align=right class=form_title>DFM presente per cambio Responsabile</td>
                             	<td valign=top><formwidget id="f_dfm_resp_mod">
                                    <formerror  id="f_dfm_resp_mod"><br>
                                     <span class="errori">@formerror.f_dfm_resp_mod;noquote@</span>
                                    </formerror>
                             	</td>

			    </tr>
		      </if>
		</if>
			<tr><td>&nbsp;</td></tr>
			<tr>
			  <td valign=top align=lfet class=form_title colspan=5>
			    <b>Ricerca per Impianti inseriti o modificati, Soggetti modificati e Generatori sostituiti:</b></td><!--rom03-->
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Da data</td>
			  <td>
			    <table cellspacing=0 cellpadding=0>
			      <tr>
				<td valign=top><formwidget id="f_data_mod_da">
				    <formerror  id="f_data_mod_da"><br>
				      <span class="errori">@formerror.f_data_mod_da;noquote@</span>
				    </formerror>
				</td>
				<td valign=top align=right class=form_title nowrap>&nbsp;A data&nbsp;</td>
				<td valign=top><formwidget id="f_data_mod_a">
				    <formerror  id="f_data_mod_a"><br>
				      <span class="errori">@formerror.f_data_mod_a;noquote@</span>
				    </formerror>
				</td>
			      </tr>
			    </table>
			  </td>

			  <td valign=top align=right class=form_title>Situazione RCEE</td>  <!--rom01--> <!--Tolto /G/F da Situazione RCEE-->
			  <td valign=top><formwidget id="f_mod_h">
			      <formerror  id="f_mod_h"><br>
				<span class="errori">@formerror.f_mod_h;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<!--rom03 aggiunti i campi f_impianto_inserito, f_impianto_modificato, f_soggetto_modificato e f_generatore_sostituito-->
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Impianti inseriti</td>
			  <td valign=top><formwidget id="f_impianto_inserito">
			      <formerror id="f_impianto_inserito"><br>
				<span class="errori">@formerror.f_impianto_inserito;noquote@</span>
			      </formerror>
			  </td>
			  
	<if @coimtgen.regione@ eq "MARCHE"> <!-- ric01 aggiunta if e suo contenuto -->
			  <td valign=top align=right class=form_title>Impianti collegati</td>
			  <td valign=top><formwidget id="f_ibrido">
			      <formerror  id="f_ibrido"><br>
			      	<span class="errori">@formerror.f_ibrido;noquote@</span>
			      </formerror>
			  </td>				
	</if>	
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Impianti modificati</td>
			  <td valign=top><formwidget id="f_impianto_modificato">
			      <formerror id="f_impianto_modificato"><br>
				<span class="errori">@formerror.f_impianto_modificato;noquote@</span>
			      </formerror>
			  </td>
			  
	<if @coimtgen.regione@ eq "MARCHE"> <!-- ric01 aggiunta if e suo contenuto -->
		           <td valign=top align=right class=form_title>Segno identificativo pagato</td>
			   <td valign=top><formwidget id="f_pagato">
			        <formerror  id="f_pagato"><br>
				   <span class="errori">@formerror.f_pagato;noquote@</span>
				</formerror>				     
		           </td>
	</if>
			  </tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Soggetti modificati</td>
			  <td valigna=top><formwidget id="f_soggetto_modificato">
			      <formerror id="f_soggetto_modificato"><br>
				<span class="errori">@f_soggetto_modificato;noquote@</span>
			      </formerror>
			  </td>

	<if @coimtgen.regione@ eq "MARCHE"> <!-- ric02 aggiunta if e suo contenuto -->
                         <td valign=top align=right class=form_title>Dichiarazione conformità</td>
	                 <td valign=top><formwidget id="f_dich_conformita">
	                     <formerror  id="f_dich_conformita"><br>
		                   <span class="errori">@formerror.f_dich_conformita;noquote@</span>
		             </formerror>
		         </td>
	</if>

			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td valign=top align=right class=form_title>Generatori sostituiti</td>
			  <td valigna=top><formwidget id="f_generatore_sostituito">
			      <formerror id="f_generatore_sostituito"><br>
				<span class="errori">@f_generatore_sostituito;noquote@</span>
			      </formerror>
			  </td>
	  	<if @coimtgen.regione@ eq "MARCHE"> <!-- ric01 aggiunta if e suo contenuto -->
                         <td valign=top align=right class=form_title>Motivo compilazione RCEE</td>
	                 <td valign=top><formwidget id="f_tprc">
	                     <formerror  id="f_tprc"><br>
		                   <span class="errori">@formerror.f_tprc;noquote@</span>
		             </formerror>
		         </td>
		 </if>
			</tr>
			<tr>
			  <if @id_ruolo@ eq admin or @id_ruolo@ eq cait>
			    <td>&nbsp;</td>
			    <td valign=top align=right class=form_title>Dall'utente</td>
			    <td valign=top><formwidget id="f_utente">
				<formerror  id="f_utente"><br>
				  <span class="errori">@formerror.f_utente;noquote@</span>
				</formerror>
			    </td>   
			  </if>
			  <else>	 
			    <td colspan=3>&nbsp;</td>
			  </else>
			  <td valign=top align=right class=form_title>Stato impianto</td>
			  <td valign=top><formwidget id="f_stato_aimp">
			      <formerror  id="f_stato_aimp"><br>
				<span class="errori">@formerror.f_stato_aimp;noquote@</span>
			      </formerror>
			  </td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
			  <td valign=top align=right class=form_title>
			    <b>Ricerca per generatore</b>
			  </td>
			  <td valign=top align=right class=form_title>Matricola</td>
			  <td valign=top><formwidget id="f_matricola">
			      <formerror  id="f_matricola"><br>
				<span class="errori">@formerror.f_matricola;noquote@</span>
			      </formerror>
			  </td>
			  <td valign=top align=right class=form_title>Costruttore</td>
			  <td valign=top><formwidget id="f_cod_cost">
			      <formerror  id="f_cod_cost"><br>
				<span class="errori">@formerror.f_cod_cost;noquote@</span>
			      </formerror>
			  </td>
			</tr>

			<tr>
			  <td valign=top align=right class=form_title>
			    <b>Ricerca Bollino</b>
			  </td>
                       <td valign=top align=right class=form_title>Numero bollino</td>
                        <td valign=top><formwidget id="f_bollino">
                       <formerror  id="f_bollino"><br>
                       <span class="errori">@formerror.f_bollino;noquote@</span>
                      </formerror>
                     </td>
			<td valign=top align=right class=form_title>Prov.Dati</td>
			  <td valign=top><formwidget id="f_prov_dati">
			      <formerror  id="f_prov_dati"><br>
				<span class="errori">@formerror.f_prov_dati;noquote@</span>
			      </formerror>
			  </td>
			</tr>
                     <!-- inizio dpr74 -->
                     <tr>
			  <td valign=top align=right class=form_title>
			    <b>Ricerca Tipologia impianto</b>
			  </td>
			 <td valign=top align=right class=form_title>&nbsp;</td>
			 <td valign=top align=right class=form_title>&nbsp;</td>
			  <td valign=top align=right class=form_title>Tipologia</td>
			  <td valign=top><formwidget id="f_flag_tipo_impianto">
			      <formerror  id="f_flag_tipo_impianto"><br>
				<span class="errori">@formerror.f_flag_tipo_impianto;noquote@</span>
			      </formerror>
			  </td>
			</tr>
                    <!-- fine dpr74 -->
                     <tr>   
		       <td colspan=5><!--rom02 aggiunto td e table-->
			 <table width="100%" border=0>
			   <tr>
			     <td width="50%"align=right colspan=1><formwidget id="submit"></td>
			     <td align=left colspan=1><formwidget id="submit_sbianca"></td><!--rom02--> 
			   </tr> 
			 </table>
		       </td>
		     </tr><!--rom02-->  
		      </table>
		    </td>
		  </tr>
		  <!-- Fine della form colorata -->
		  <%=[iter_form_fine]%>
  </center>
  </formtemplate>
  <p>


				   
