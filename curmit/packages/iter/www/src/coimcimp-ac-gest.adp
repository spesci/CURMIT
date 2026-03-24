
<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    mat01 25(03/2025 Aggiunto un if per non dare la possibilità ai manutentori di stampare e
    mat01            inserire i rapporti

    mic00 19/05/2022 Programma copiato e adattato da coimcimp-ri-gest.adp
    
-->

<master   src="../master">
  <property name="title">@page_title;noquote@</property>
  <property name="context_bar">@context_bar;noquote@</property>
  <property name="riga_vuota">f</property>

  @link_inc;noquote@
  @link_tab;noquote@
  @dett_tab;noquote@
  <table width="100%" cellspacing=0 class=func-menu>
    <tr>
      <if  @flag_cimp@ ne "S"
	   and @flag_inco@ ne "S">
	<td width="12.50%" nowrap class=func-menu>
	  <a href="@pack_dir;noquote@/coimcimp-list?@link_list;noquote@" class=func-menu>Ritorna</a>
	</td>
       <if @flag_cod_manu@ eq "f"><!-- rom01 aggiunta if -->
	<td width="12.50%" nowrap class=func-menu>Aggiungi</td>
       </if><!-- rom01-->
     </if>
      <else>
	<if @flag_cod_manu@ eq "f"><!-- rom01 aggiunta if -->
	<td width="12.50%" nowrap class=@func_i;noquote@>
	Aggiungi
	</td>
        </if><!-- rom01-->
      </else>
      <if @funzione@ ne "I">
	<td width="12.50%" nowrap class=@func_v;noquote@>
          <a href="@pack_dir;noquote@/coimcimp-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
	</td>
	<if @flag_modifica@ eq T>
	  <if @flag_cod_manu@ eq "f"><!-- rom01 aggiunta if -->
          <td width="12.50%" nowrap class=@func_m;noquote@>
            <a href="@pack_dir;noquote@/coimcimp-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
          </td>
	  </if><!-- rom01-->
	</if>
	<else>
	  <if @flag_cod_manu@ eq "f"><!-- rom01 aggiunta if -->
          <td width="14.29%" nowrap class=func-menu>Modifica</td>
          </if><!-- rom01-->
	</else>
       <if @flag_cod_manu@ eq "f"><!-- rom01 aggiunta if -->
        <td width="12.50%" nowrap class=@func_d;noquote@>
          <a href="@pack_dir;noquote@/coimcimp-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
        </td>
          </if><!-- rom01-->
	<if @flag_modifica@ eq T>
          <td width="12.50%" nowrap class=func-menu>
            <a href="@pack_dir;noquote@/coimanom-list?@link_anom;noquote@" class=func-menu>Anomalie</a>
          </td>
	</if>
	<else>
          <td width="14.29%" nowrap class=func-menu>Anomalie</td>
	</else>
	<if @check_perm_print_ins@ eq "t" > <!--mat01 aggiunto if ma non contenuto-->
	<td width="12.50%" nowrap class=func-menu>
          <a href="@pack_dir;noquote@/coimcimp-layout?@link_prnt;noquote@&flag_ins=N" class=func-menu target="Stampa verifica">Stampa</a>
	</td>
	<td width="12.50%" nowrap class=func-menu>
          <a href="@pack_dir;noquote@/coimcimp-layout?@link_prn2;noquote@&flag_ins=S" class=func-menu target="Stampa verifica">Ins. doc.</a>
	</td>
	</if> <!--mat01 -->
      </if>
      <else>
	<td width="12.50%" nowrap class=func-menu>Visualizza</td>
	<td width="12.50%" nowrap class=func-menu>Modifica</td>
	<td width="12.50%" nowrap class=func-menu>Cancella</td>
	<td width="12.50%" nowrap class=func-menu>Anomalie</td>
	<td width="12.50%" nowrap class=func-menu>Stampa</td>
	<td width="12.50%" nowrap class=func-menu>Ins. doc.</td>
      </else>
    </tr>
  </table>

  <center>
    <formtemplate id="@form_name@">
      <formwidget   id="funzione">
	<formwidget   id="caller">
	  <formwidget   id="nome_funz">
	    <formwidget   id="extra_par">
	      <formwidget   id="last_cod_cimp">
		<formwidget   id="cod_impianto">
		  <formwidget   id="gen_prog">
		    <formwidget   id="url_aimp">
		      <formwidget   id="url_list_aimp">
			<formwidget   id="flag_cimp">
			  <formwidget   id="extra_par_inco">
			    <formwidget   id="flag_inco">
			      <formwidget   id="cod_inco_old">
				<formwidget   id="cod_responsabile">
				  <formwidget   id="list_anom_old">
				    <formwidget   id="flag_modifica">
				      <formwidget   id="cod_cimp">

					<if @vis_desc_ver@ eq t>
					  <formwidget id="esito_verifica">
					</if>

					<!-- Inizio della form colorata -->
					<%=[iter_form_iniz]%>

					@errore;noquote@					
					<tr>
					  <td>
					    <table width ="100%" border=0>
					      <tr>
						<td colspan=6 align=center valign=top class=func-menu><b>1. DATI GENERALI</b></td>
					      </tr>
					      <tr>
						<td valign=top  align=left class=form_title>Data controllo <font color=red>*</font></td>
						<td valign=top><formwidget id="data_controllo">
						    <formerror  id="data_controllo"><br>
						      <span class="errori">@formerror.data_controllo;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title>Ora</td>
                                                <td valign=top><formwidget id="ora_inizio">     
                                                <formerror  id="ora_inizio"><br>
                                                      <span class="errori">@formerror.ora_inizio;noquote@</span>
                                                    </formerror>
                                                </td>
						<td valign=top align=left class=form_title>Aggiorna appuntamento</td>
						<td valign=top><formwidget id="cod_inco">@link_inco;noquote@
						    <formerror  id="cod_inco"><br>
						      <span class="errori">@formerror.cod_inco;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					      <tr>
						<td valign=top align=left class=form_title>N. verbale</td>
						<td valign=top><formwidget id="verb_n">
						    <formerror  id="verb_n"><br>
						      <span class="errori">@formerror.verb_n;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title>Data verbale</td>
						<td colspan=3 valign=top><formwidget id="data_verb">
						    <formerror  id="data_verb"><br>
						      <span class="errori">@formerror.data_verb;noquote@</span>
						    </formerror>
						</td>
					      </tr>

					      <tr>
						<td valign=top align=left class=form_title>Verificatore <font color=red>*</font></td>
						<td valign=top colspan=5><formwidget id="cod_opve">
						    <if @disabled_opve@ eq "disabled">
						      <formwidget id="des_opve">
						    </if>
						    <formerror  id="cod_opve"><br>
						      <span class="errori">@formerror.cod_opve;noquote@</span>
						    </formerror>
						</td>
					      </tr>

					      <if @funzione@ eq "K" >
						<tr>
						  <td valign=top  align=left class=form_title>Dichiarato</td>
						  <td valign=top><formwidget id="dichiarato">
						      <formerror  id="dichiarato"><br>
							<span class="errori">@formerror.dichiarato;noquote@</span>
						      </formerror>
						  </td>

						  <td valign=top  align=left class=form_title>Data allegato G/F</td>
						  <td valign=top><formwidget id="new1_data_dimp">
						      <formerror  id="new1_data_dimp"><br>
							<span class="errori">@formerror.new1_data_dimp;noquote@</span>
						      </formerror>
						  </td>
						</tr>
						<tr>
						  <td valign=top align=left class=form_title>Data versamento C.C.P.</td>
						  <td valign=top><formwidget id="new1_data_paga_dimp">
						      <formerror  id="new1_data_paga_dimp"><br>
							<span class="errori">@formerror.new1_data_paga_dimp;noquote@</span>
						      </formerror>
						  </td>
						  <td valign=top align=left class=form_title>Bollino N.</td>
						  <td valign=top><formwidget id="riferimento_pag_bollini">
						      <formerror  id="riferimento_pag_bollini"><br>
							<span class="errori">@formerror.riferimento_pag_bollini;noquote@</span>
						      </formerror>
						  </td>
						  <td valign=top align=left class=form_title>Importo versato</td>
						  <td valign=top><formwidget id="imp_boll_ver">
						      <formerror  id="imp_boll_ver"><br>
							<span class="errori">@formerror.imp_boll_ver;noquote@</span>
						      </formerror>
						  </td>
						</tr>
						<tr>
						  <td valign=top align=left class=form_title>Bollino ACEA</td>
						  <td valign=top><formwidget id="n_prot">
						      <formerror  id="n_prot"><br>
							<span class="errori">@formerror.n_prot;noquote@</span>
						      </formerror>
						  </td>
						  <td valign=top align=left class=form_title>Data Bollino ACEA</td>
						  <td valign=top><formwidget id="data_prot">
						      <formerror  id="data_prot"><br>
							<span class="errori">@formerror.data_prot;noquote@</span>
						      </formerror>
						  </td>
						</tr>
					      </if>
					      
					      <if @funzione@ eq "V" or @funzione@ eq "D">
						<tr>
						  <td colspan=2>Il responsabile dell'impianto &egrave; @aimp_flag_resp_desc;noquote@
						  </td>
						</tr>
					      </if>
					      <tr>
						<td valign=top align=left class=form_title >Responsabile</td>
						<td valign=top colspan=5><formwidget id="cogn_responsabile">    
						    <formwidget id="nome_responsabile">@cerca_resp;noquote@
						      <formerror  id="cogn_responsabile"><br>
							<span class="errori">@formerror.cogn_responsabile;noquote@</span>
						      </formerror>
						      <br/>@link_ins_resp;noquote@ 
						</td>
					      </tr>
					      <tr><td valign=top align=left class=form_title>Eventuale delegato</td>
						<td valign=top colspan=3><formwidget id="nominativo_pres">
						    <formerror  id="nominativo_pres"><br>
						      <span class="errori">@formerror.nominativo_pres;noquote@</span>
						    </formerror>
						</td>
                                                <td valign=top align=left class=form_title>Delega pres./ ass.</td>
						<td valign=top><formwidget id="delega_pres">
						    <formerror  id="delega_pres"><br>
						      <span class="errori">@formerror.delega_pres;noquote@</span>
						    </formerror>
						</td>

					      </tr>


					      <tr>
						<td valign=top align=left class=form_title>Potenze termiche al focolare</td>
						<td valign=top><formwidget id="potenza_nom_tot_foc">(kw)
						    <formerror  id="potenza_nom_tot_foc"><br>
						      <span class="errori">@formerror.potenza_nom_tot_foc;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title>Utile</td>
						<td valign=top colspan=3><formwidget id="potenza_nom_tot_util">(kw)
						    <formerror  id="potenza_nom_tot_util"><br>
						      <span class="errori">@formerror.potenza_nom_tot_util;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					      
					      
					      <tr>
						<td valign=top align=left class=form_title>Volumetria riscaldata (m<sup><small>3</small></sup>)</td>
						<td valign=top><formwidget id="volumetria">
						    <formerror  id="volumetria"><br>
						      <span class="errori">@formerror.volumetria;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title>Consumi ultima stagione di riscaldamento (m<sup><small>3</small></sup>/kg)</td>
						<td valign=top colspan=3><formwidget id="comsumi_ultima_stag">
						    <formerror  id="comsumi_ultima_stag"><br>
						      <span class="errori">@formerror.comsumi_ultima_stag;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					    </table>
					  <td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
					  <td><table border=0 width="100%">
					      <tr>
						<td colspan=4 align=center valign=top class=func-menu><b>2. DESTINAZIONE</b></td>
					      </tr>
					      <tr>
                                                <td class=form_title>Cat. edificio</td>
						<td class=form_title>Dest.prevalente dell'immobile</td>
						<td class=form_title>Impianto a servizio di:</td>
						<td class=form_title>Destinazione d'uso dell'impianto</td>
						</tr>
					      <tr>
                                                <td valign=top><formwidget id="cod_cted">
						    <formerror  id="cod_cted"><br>
						      <span class="errori">@formerror.cod_cted;noquote@</span>
						    </formerror>
						</td>
						<td valign=top><formwidget id="cod_tpdu">
						    <formerror  id="cod_tpdu"><br>
						      <span class="errori">@formerror.cod_tpdu;noquote@</span>
						    </formerror>
						</td>
						<td valign=top><formwidget id="cod_tpim">
						    <formerror  id="cod_tpim"><br>
						      <span class="errori">@formerror.cod_tpim;noquote@</span>
						    </formerror>
						</td>
						<td valign=top><formwidget id="cod_utgi">
						    <formerror  id="cod_utgi"><br>
						      <span class="errori">@formerror.cod_utgi;noquote@</span>
						    </formerror>
						</td>
						</tr>
					    </table>
					  </td>
					</tr>


                                          <tr>
					  <td><table border=0 width="100%">
					      <tr>
                                               <td class=form_title>Combustibile</td>
					      </tr>
					      <tr>
                                               	<td valign=top><formwidget id="cod_combustibile">
						    <formerror  id="cod_combustibile"><br>
						      <span class="errori">@formerror.cod_combustibile;noquote@</span>
						    </formerror>
						</td>
					      </tr>
                                             </tr>

					    </table>
					  </td>
					  <tr>
					  <td>
                                            <table border=0 width="100%">
                                              <tr>
                                               <td class=form_title>Trattamento in riscaldamento
					       <formwidget id="tratt_in_risc">
                                                    <formerror  id="tratt_in_risc"><br>
                                                      <span class="errori">@formerror.tratt_in_risc;noquote@</span>
                                                    </formerror>
                                                </td>
                                                                                           
                                                <td class=form_title>Trattamento in acs
                                                <formwidget id="tratt_in_acs">
                                                    <formerror  id="tratt_in_acs"><br>
                                                      <span class="errori">@formerror.tratt_in_acs;noquote@</span>
                                                    </formerror>
                                                </td>
                                              </tr>
                                             </tr>

                                            </table>
                                          </td>
					  
					</tr>

					<tr>
					  <td>
					    <table border=0 width="100%">
					      <tr>
						<td colspan=4 align=center valign=top class=func-menu><b>3. STATO DELLA DOCUMENTAZIONE MANUTENZIONE ED ANALISI</b></td>
					      </tr>
					      <tr>
						<td valign=top width="35%" align=left class=form_title>Libretto impianto o centrale presente</td>
						<td valign=top width="15%"align=right width="10%">
						  <formwidget id="presenza_libretto">
						    <formerror  id="presenza_libretto"><br>
						      <span class="errori">@formerror.presenza_libretto;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title>Compilazione libretto impianto o centrale completa</td>
						<td valign=top align=right><formwidget id="libretto_corretto">
						    <formerror  id="libretto_corretto"><br>
						      <span class="errori">@formerror.libretto_corretto;noquote@</span>
						    </formerror>
						</td>
				              </tr> 
					      <tr>
						<td valign=top width="35%" align=left class=form_title>Dichiarazione conformit&agrave;</td>
						<td valign=top width="15%" align=right>
						  <formwidget id="dich_conformita">
						    <formerror  id="dich_conformita"><br>
						      <span class="errori">@formerror.dich_conformita;noquote@</span>
						    </formerror>
						</td>
						<td valign=top width="35%" align=left class=form_title>Libretto/i di uso e manutenzione presente/i</td>
						<td valign=top width="15%" align=right>
						  <formwidget id="libretto_manutenz">
						    <formerror  id="libretto_manutenz"><br>
						      <span class="errori">@formerror.libretto_manutenz;noquote@</span>
						    </formerror>
						</td>
					      <tr>
                                                <td valign=top width="35%" align=left class=form_title>Dichiarazione D.Lgs. 152 presente</td>
                                                <td valign=top width="15%" align=right>
                                                  <formwidget id="dich_152_presente">
                                                    <formerror  id="dich_152_presente"><br>
                                                      <span class="errori">@formerror.dich_152_presente;noquote@</span>
                                                    </formerror>
                                                </td>
						<td colspan=2></td>
					      </tr>
                                              <tr> 
						<td valign=top width=35% align=left class=form_title>
						         Certificato prevenzione incendi per impianti mag.116,3 kW
					        </td>
						<td valign=top width="15%" align=right>
						  <formwidget id="doc_prev_incendi">
						    <formerror  id="doc_prev_incendi"><br>
						      <span class="errori">@formerror.doc_prev_incendi;noquote@</span>
						    </formerror>
						</td>
						<td valign=top width="35%" align=left class=form_title>Pratica INAIL (ex ISPESL) per generatori in pressione</td>
						<td valign=top width="15%" align=right>
						  <formwidget id="doc_ispesl">
						    <formerror  id="doc_ispesl"><br>
						      <span class="errori">@formerror.doc_ispesl;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					     </table>
					  </td>
					</tr>
					<tr>
					  <td><table border=0 width="100%">
                                                  <tr>
                                                <td colspan=6 align=center valign=top class=func-menu><b>4. MANUTENZIONI</b></td>
                                              </tr>
						    <tr>
						      <td valign=top align=left>Anno in corso<font color=red>*</font>
							<formwidget id="manutenzione_8a">
							  <formerror  id="manutenzione_8a"><br>
							    <span class="errori">@formerror.manutenzione_8a;noquote@</span>
							  </formerror>
						      </td>
						      <td valign=top width=13% align=left>Anni precedenti<font color=red>*</font>
						       </td><td align=left>
							<formwidget id="new1_manu_prec_8a">
							  <formerror  id="new1_manu_prec_8a"><br>
							    <span class="errori">@formerror.new1_manu_prec_8a;noquote@</span>
							  </formerror>
						      </td>
                                                       <td valign=top align=left>Frequenza
							<formwidget id="frequenza_manut">
							  <formerror  id="frequenza_manut"><br>
							    <span class="errori">@formerror.frequenza_manut;noquote@</span>
							  </formerror>
						      </td>
                                                     <td valign=top align=left>Altra freq.
							<formwidget id="frequenza_manut_altro">
							  <formerror  id="frequenza_manut_altro"><br>
							    <span class="errori">@formerror.frequenza_manut_altro;noquote@</span>
							  </formerror>
						      </td>

						    </tr>
					          <tr>
						<td valign=top align=left>Data ultima manutenzione<font color=red>*</font>
						 <formwidget id="new1_data_ultima_manu">
						    <formerror  id="new1_data_ultima_manu"><br>
						      <span class="errori">@formerror.new1_data_ultima_manu;noquote@</span>
						    </formerror>
						</td>
						<td valign=top colspan=4 align=left >Data ultima prova eff. energetica<font color=red>*</font>
						 <formwidget id="new1_data_ultima_anal">
						    <formerror  id="new1_data_ultima_anal"><br>
						      <span class="errori">@formerror.new1_data_ultima_anal;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					      <tr>
						<td  align=center rowspan=4 class=form_title>Rapporto di eff. energetica:
                                                </td>
						<td valign=top  align=left>Presente
						</td><td align=left>
						  <formwidget id="new1_dimp_pres">
						    <formerror  id="new1_dimp_pres"><br>
						      <span class="errori">@formerror.new1_dimp_pres;noquote@</span>
						    </formerror>
						</td>
						<td valign=top align=left class=form_title colspan=2 rowspan=4>
						  Note prescrizioni &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						  @link_note_view;noquote@<br>
						  <formwidget id="new1_note_manu">
						    <formerror  id="new1_note_manu"><br>
						      <span class="errori">@formerror.new1_note_manu;noquote@</span>
						    </formerror>
						</td>
					      </tr> 
					      <tr>
						<td valign=top align=left>Con prescrizioni
						</td><td align=left>
						  <formwidget id="new1_dimp_prescriz">
						    <formerror  id="new1_dimp_prescriz"><br>
						      <span class="errori">@formerror.new1_dimp_prescriz;noquote@</span>
						    </formerror>
						</td>
					       </tr>
					       <tr>
                                               <td valign=top align=left>Con osservazioni
					       </td><td align=left>
						  <formwidget id="rcee_osservazioni">
						    <formerror  id="rcee_osservazioni"><br>
						      <span class="errori">@formerror.rcee_osservazioni;noquote@</span>
						    </formerror>
						</td>
						</tr>
						<tr>
                                                <td valign=top align=left>Con Raccomandazioni
						</td><td align=left>
						  <formwidget id="rcee_raccomandazioni">
						    <formerror  id="rcee_raccomandazioni"><br>
						      <span class="errori">@formerrorrcee_raccomandazioni;noquote@</span>
						    </formerror>
						</td>
						</tr>
					      </tr>

                                                <tr>
                                                <!--    <td valign=top  align=left class=form_title>RCEE inviato
						  <formwidget id="rcee_inviato">
						      <formerror  id="rcee_inviato"><br>
							<span class="errori">@formerror.rcee_inviato;noquote@</span>
						      </formerror>
						  </td>--> 
                                              <!--  <td valign=top  align=left class=form_title>Rispetto della periodicità prev. per norma di legge app. bollino e trasm. all'ente
						</td><td align=left>
						      <formwidget id="dichiarato">
						      <formerror  id="dichiarato"><br>
							<span class="errori">@formerror.dichiarato;noquote@</span>
						      </formerror>
						  </td>

                                                <td valign=top colspan=2 align=left class=form_title>Bollino N.
						  <formwidget id="riferimento_pag_bollini">
						      <formerror  id="riferimento_pag_bollini"><br>
							<span class="errori">@formerror.riferimento_pag_bollini;noquote@</span>
						      </formerror>
						  </td> -->
                                            </tr>
					    </table>
					  </td>
					</tr>
					<tr>
					  <td colspan=5><table border=0 width="100%">
					      <tr>
						<td colspan=2 align=center valign=top class=func-menu><b>5. OSSERVAZIONI DEL VERIFICATORE</b></td>
					      </tr>
				    <!--rom02   <td valign=top align=right class=form_title>Note non conformit&agrave;</td>-->
					      <tr><!--rom01 sostituito "Note non conformit&agrave;" con "Note"-->
					      <if @coimtgen.regione@ ne "MARCHE">
						<td valign=top align=right class=form_title>Note</td>
					      </if>
					      <else>
					        <td valign=top align=right class=form_title>Osservazioni</td>
					      </else>	
						<td valign=top ><formwidget id="note_conf">
						    <formerror  id="note_conf"><br>
						      <span class="errori">@formerror.note_conf;noquote@</span>
						    </formerror>
						</td>
                                              

					      </tr>
					    </table>
					  </td>
					</tr>
                                        <tr>
                                          <td colspan=5>
					      <table border=0 width=100%>
                                              <tr>
					      <td colspan=2 align=center valign=top class=func-menu><b>6. PRESCRIZIONI</b></td>
                                              </tr>
                                              <tr>
                                                <td valign=top align=right class=form_title>Prescrizioni&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td><formwidget id="note_verificatore">
                                                          <formerror  id="note_verificatore"><br>
                                                            <span class="errori">@formerror.note_verificatore;noquote@</span>
                                                          </formerror>
                                                </td>
                                              </tr>
                                              </table>
                                                                                
                                          </td>
                                        </tr>
					<tr>
					  <td colspan=5>
                                              <table border=0 width="100%">
					      <tr>
						<td colspan=2 align=center valign=top class=func-menu><b>7. DICHIARAZIONI DEL RESPONSABILE IMPIANTO</b></td>
					      </tr>
					      <tr>
				    <!--rom02	<td valign=top align=right class=form_title>Note responsabile</td>-->
				    <!--rom02--><td valign=top align=right class=form_title>Dichiarazioni</td>
				                <td valign=top ><formwidget id="note_resp">
						    <formerror  id="note_resp"><br>
						      <span class="errori">@formerror.note_resp;noquote@</span>
						    </formerror>
						</td>
					      </tr>
					    </table>
					  </td>
					</tr>
					<tr>
					 <td>
					  <table border=0 width=50%>
					  <tr>
					    <!-- <td>Rilasciata dichiarazione:</td>
					     <td valign=top align=left class=form_title>Mod. Verde
                                                <formwidget id="mod_verde">
                                                    <formerror  id="mod_verde"><br>
                                                      <span class="errori">@formerror.mod_verde;noquote@</span>
                                                    </formerror>
                                                </td> -->
						<!-- <td valign=top align=left class=form_title>Mod. Rosa
                                                <formwidget id="mod_rosa">
                                                    <formerror  id="mod_rosa"><br>
                                                      <span class="errori">@formerror.mod_rosa;noquote@</span>
                                                    </formerror>
                                                </td> -->	
					  </tr>
					  <tr>
                                          <td></td>
                                              <!-- <td colspan=4 valign=top align=left class=form_title>Autocertificazione adeguamento D.Lgs 152/2006
                                                <formwidget id="auto_adeg_152">
                                                    <formerror  id="auto_adeg_152"><br>
                                                      <span class="errori">@formerror.auto_adeg_152;noquote@</span>
                                                    </formerror>
                                                </td> -->
                                          </tr>      
					  </table>
					  </td>
					  </tr> 

					<tr>
					  <td colspan=5 align=right><table width="100%">
					      <tr>
						 <td valign=top align=right class=form_title>Data utile interv.</td>
                                           <td valign=top class=form_title>Anomalia</td>
                                           <td valign=top class=form_title>Princ.</td>
					      </tr> 
					      <formwidget id="prog_anom_max">
						<multiple name=multiple_form>
						  <tr>
						    <formwidget id="prog_anom.@multiple_form.conta@">
						      <td valign=top align=right><formwidget id="data_ut_int.@multiple_form.conta@">
							  <formerror  id="data_ut_int.@multiple_form.conta@"><br>
							    <span class="errori"><%= $formerror(data_ut_int.@multiple_form.conta@) %></span>
							  </formerror>
						      </td>
						      <td valign=top><formwidget id="cod_anom.@multiple_form.conta@">
							  <formerror  id="cod_anom.@multiple_form.conta@"><br>
							    <span class="errori"><%= $formerror(cod_anom.@multiple_form.conta@) %></span>
							  </formerror>
						      </td>
                                                 <td valign=top><formwidget id="princip.@multiple_form.conta@">
                                                  <formerror  id="princip.@multiple_form.conta@"><br>
                                                <span class="errori"><%= $formerror(princip.@multiple_form.conta@) %></span>
                                                 </formerror>
        </td>

						  </tr>
						</multiple>
					  </table></td>
					</tr>

					<if @flag_cod_tecn@ ne S>
					  <if @flag_sanzioni@ eq S>
					    <tr>
					      <td><table border=0 width="100%">
						  @mess_err_sanz;noquote@
						  <tr>
						    <td valign=top align=right class=form_title>tipo sanzione 1</td>
						    <td valign=top colspan=3><formwidget id="cod_sanzione_1">@mess_err_sanz1;noquote@
							<formerror  id="cod_sanzione_1"><br>
							  <span class="errori">@formerror.cod_sanzione_1;noquote@</span>
							</formerror>
						    </td>
						  </tr>
						  <tr>
						    <td valign=top align=right class=form_title>tipo sanzione 2</td>
						    <td valign=top><formwidget id="cod_sanzione_2">@mess_err_sanz2;noquote@
							<formerror  id="cod_sanzione_2"><br>
							  <span class="errori">@formerror.cod_sanzione_2;noquote@</span>
							</formerror>
						    </td>
						  </tr>
					      </table></td>
					    </tr>
					  </if>
					  <else>
					    <tr>
					      <td colspan=5><table border=0 width="100%">
						  <tr>
						   <!-- <td valign=top align=right class=form_title>Numero fattura</td>
						    <td valign=top ><formwidget id="numfatt">
							<formerror  id="numfatt"><br>
							  <span class="errori">@formerror.numfatt;noquote@</span>
							</formerror>
						    </td>
						    <td valign=top align=right class=form_title>Data fattura</td>
						    <td valign=top ><formwidget id="data_fatt">
							<formerror  id="data_fatt"><br>
							  <span class="errori">@formerror.data_fatt;noquote@</span>
							</formerror>
						    </td> -->
						  </tr>
						  <tr>
						<!--    <td valign=top align=right class=form_title>Presenza firma Tecnico</td>
						    <td valign=top ><formwidget id="fl_firma_tecnico">
							<formerror id="fl_firma_tecnico"><br>
							  <span class="errori">@formerror.fl_firma_tecnico;noquote@</span>
							</formerror>
						    </td>
						    <td valign=top align=right class=form_title>Presenza firma responsabile</td>
						    <td><formwidget id="fl_firma_resp">
							<formerror id="fl_firma_resp"><br>
							  <span class="errori">@formerror.fl_firma_resp;noquote@</span>
							</formerror>
						    </td>
						    <td> Rifiuto firma</td>
						    <td>
						      <formwidget id="fl_rifiuto_firma">
							<formerror id="fl_rifiuto_firma"><br>
							  <span class="errori">@formerror.fl_rifiuto_firma;noquote@</span>
							</formerror>
						    </td> -->
						  </tr>
						  <tr><td colspan="4">&nbsp;</td></tr>
						</table>
					      </td>
					    </tr>
					  </else>
					</if>
                                        <tr>
					  <td colspan=5>
                                              <table border=0 width="100%">
					      <tr>
						<td colspan=4 align=center valign=top class=func-menu><b>DATI FINALI</b></td>
					      </tr>
					      <tr>
						<td width="32%" valign=top align=right class=form_title>Deve presentare modulo rimessa a norma</td>
						<td width="08%" valign=top><formwidget id="deve_non_messa_norma">
						    <formerror  id="deve_non_messa_norma"><br>
						      <span class="errori">@formerror.deve_non_messa_norma;noquote@</span>
						    </formerror>
						</td>
                                                <td width="34%" valign=top align=right class=form_title>Deve presentare nuovo RCEE tipo 1</td>
						<td width="26%" valign=top ><formwidget id="deve_non_rcee">
						    <formerror  id="deve_non_rcee"><br>
						      <span class="errori">@formerror.deve_non_rcee;noquote@</span>
						    </formerror>
						</td>
                                              </tr>
                                              <tr>
                                                <td valign=top align=right class=form_title>L'impianto pu&ograve; rimanere in funzione</td>
						<td valign=top ><formwidget id="rimanere_funzione">
						    <formerror  id="rimanere_funzione"><br>
						      <span class="errori">@formerror.rimanere_funzione;noquote@</span>
						    </formerror>
						</td>
					      </tr>
                                              <tr><td colspan="4">&nbsp;</td></tr>
					    </table>
					  </td>
					</tr>
					<tr>
					<td colspan=5>
					<table width=100% border=0>
					  <tr>
						    <td valign=top align=left class=form_title>
					                <b>Esito positivo: rientra</b><small> nei termini di legge<br></small><b>Esito negativo: non rientra</b><small><small> le non conformità vanno sanate entro 60 gg pena una sanzione</small></small>
							 <if @vis_desc_ver@ eq f>
							 <formwidget id="esito_verifica">
							     <formerror  id="esito_verifica"><br>
							     		 &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<span class="errori">@formerror.esito_verifica;noquote@</span>
							     </formerror>
							 
							 </if>
							 <else>
							 <formwidget id="text_esito_verifica">
							            <formerror  id="text_esito_verifica"><br>
								    		&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<span class="errori">@formerror.esito_verifica;noquote@</span>
								    </formerror> >
						         
							 </else>
						</td></tr>
					  </table>
					  </td>
					  </tr>     

					<if @funzione@ ne "V">
					  <tr><td colspan=5 align=center><formwidget id="submitbut"></td></tr>
					</if>

					<!-- Fine della form colorata -->
					<%=[iter_form_fine]%>

    </formtemplate>
    <p>
  </center>
