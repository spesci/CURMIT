<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    ric01 14/09/2023 Rimosso riferimento legislativo obsoleto.
    
    rom02 17/10/2018 Aggiunto nuovo campo flag_as_resp; Sandro ha detto che va bene per tutti
    rom02            gli enti.

    rom01 09/08/2018 Aggiunte e cambiate alcune label su richiesta della Regione Marche.
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

@link_tab;noquote@
@dett_tab;noquote@

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <if @funzione@ ne I>
       <if @cod_impianto@ not nil>
       <td width="14.29%">
            <a href="coim_as_resp-list?funzione=V&@link_list;noquote@">Ritorna</a>
       </td>
       </if>
       <else>
       <td width="14.29%">
            <a href="coim_as_resp_admin-list?funzione=V&@link_list_admin;noquote@">Ritorna</a>
       </td>
       </else>
       <td width="14.29%" nowrap class=@func_v;noquote@>
            <a href="coim_as_resp-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
       </td>
       <if @flag_modifica@ eq T>
           <td width="14.29%" nowrap class=@func_m;noquote@>
               <a href="coim_as_resp-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
           </td>
           <td width="14.29%" nowrap class=@func_d;noquote@>
               <a href="coim_as_resp-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
           </td>
       </if>
       <else>
            <td width="14.29%" nowrap class=func-menu>Modifica</td>
            <td width="14.29%" nowrap class=func-menu>Cancella</td>
       </else>
       <td width="14.29%" nowrap class=func-menu>
           <a href="coim_as_resp-layout?@link_gest;noquote@" class=func-menu target="Stampa">Stampa</a>
       </td>
       <td width="42.84%" nowrap class=func-menu>&nbsp;</td>
   </if>
   <else>
       <td width="14.29%" nowrap class=func-menu>Visualizza</td>
       <td width="14.29%" nowrap class=func-menu>Modifica</td>
       <td width="14.29%" nowrap class=func-menu>Cancella</td>
       <td width="14.29%" nowrap class=func-menu>Stampa</td>
       <td width="42.84%" nowrap class=func-menu>&nbsp;</td>
   </else>
</tr>
</table>


<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_as_resp">
<formwidget   id="cod_impianto">
<formwidget   id="f_cod_via">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_as_resp">
<formwidget   id="cod_responsabile">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">
<formwidget   id="cod_legale_rapp">
<formwidget   id="flag_tracciato">
<formwidget   id="dummy">
<!-- Inizio della form colorata -->
<br><br>
<table width=90% border=1 cellspacing=0 cellpadding=20 align=center>
	<tr>
		<td>
			<table width=100% align=center border=0>
				<tr><td colspan=2 align="center" class="errori">@errori;noquote@</td></tr>
				<tr>
				   <td align=right class=form_title width=20%>Il sottoscritto</td>
				   <td align=left><formwidget id="cognome_legale"><formwidget id="nome_legale">
		       			<formerror  id="cognome_legale"><br>
		       				<span class="errori">@formerror.cognome_legale;noquote@</span>
		       			</formerror>
				   </td>
				</tr>
				<tr>
				   <td align=right nowrap class=form_title>Legale rappr. della Ditta</td>
				   <td align=left><formwidget id="cognome_manu"><formwidget id="nome_manu">@cerca_manu;noquote@
		   				<formerror  id="cognome_manu"><br>
		       				<span class="errori">@formerror.cognome_manu;noquote@</span>
		       			</formerror>
				   </td>
				</tr>
				<tr>
				   <td width=100% colspan=2>
					   <table width=100%>
						    <tr>
						       <td align=right class=form_title width=21% nowrap>iscritta alla CCIAA di</td>
						       <td width=20%><formwidget id="localita_reg">
						           <formerror  id="localita_reg"><br>
						           		<span class="errori">@formerror.localita_reg;noquote@</span>
						           </formerror>
						       </td>
						       <td align=right width=10% nowrap>, al numero</td>
						       <td><formwidget id="reg_imprese">
						           	<formerror  id="reg_imprese"><br>
						       			<span class="errori">@formerror.reg_imprese;noquote@</span>
						           	</formerror>
						       </td>
						       <td align=left colspan=4>, abilitata ad operare per gli impianti di cui alle lettere:</td>
						    </tr>
					   </table>
					</td>
				</tr>
				<tr>
				   	<td width=100% colspan=2>
					   	<table width=80%>
							<tr>
							   <td  width=15%>&nbsp;</td>
							   <td  >a)<formgroup id="flag_a">@formgroup.widget;noquote@</formgroup></td>
							   <td  >b)<formgroup id="flag_b">@formgroup.widget;noquote@</formgroup></td>
							   <td  >c)<formgroup id="flag_c">@formgroup.widget;noquote@</formgroup></td>
							   <td  >d)<formgroup id="flag_d">@formgroup.widget;noquote@</formgroup></td>
							   <td  >e)<formgroup id="flag_e">@formgroup.widget;noquote@</formgroup></td>
							   <td  >f)<formgroup id="flag_f">@formgroup.widget;noquote@</formgroup></td>
							   <td  >g)<formgroup id="flag_g">@formgroup.widget;noquote@</formgroup></td>
							</tr>
					  	</table>
					</td>
				</tr>
				
				<tr><td colspan=2>&nbsp;</td></tr>
				
				<tr>
				   <td width=100% colspan=2 align=left>In possesso dell'ulteriore requisito di:</td> <!-- ric01 dell'articolo 1 della legge 46/90, ed -->
				</tr>
				
				<tr>
					<td colspan=2>
						<table>
							<tr>
								<td><formgroup id="flag_certif">@formgroup.widget;noquote@</formgroup></td>
							    <td align=left nowrap>certificazione del Sistema Qualit&agrave; ai sensi della norma UNI ISO EN
							       <formwidget id="cert_uni_iso">
							       <formerror  id="cert_uni_iso"><br>
							           	<span class="errori">@formerror.cert_uni_iso;noquote@</span>
							       </formerror>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan=2>
						<table>
							<tr>
								<td><formgroup id="flag_altro">@formgroup.widget;noquote@</formgroup></td>
						       	<td align=left align=left valign=center>Altro</td>
						       	<td><formwidget id="cert_altro">
						           	<formerror  id="cert_altro"><br>
					        		   <span class="errori">@formerror.cert_altro;noquote@</span>
						           	</formerror>
						       	</td>
						    </tr>
						</table>
					</td>
			    </tr>   
							
				<tr><td width=100% colspan=2 align=center><b>Comunica</b></td></tr>
				
				<tr>
				   <td width=100% colspan=2>
					   <table width=100%>
					      <tr>
					         <td>
					         	<table width=100%>
							        <formgroup id="swc_inizio_fine">
							           <tr><td nowrap>@formgroup.widget;noquote@ @formgroup.label;noquote@</td></tr>
							        </formgroup>
						    	</table>
					         </td>
					         <td>
						         <table width=100%>
							     	<tr><td >dalla data del</td>
						            	<td colspan=2><formwidget id="data_inizio">
					                		<formerror  id="data_inizio"><br>
						                   		<span class="errori">@formerror.data_inizio;noquote@</span>
						                	</formerror>
						                </td>
						            </tr>
							     	<tr><td >dal</td>
						            	<td><formwidget id="data_fine">
						                	<formerror  id="data_fine"><br>
						                  		<span class="errori">@formerror.data_fine;noquote@</span>
						                   	</formerror>
						                 </td>
                                                                 <td>per</td><!--rom01 aggiunto td e contenuto-->
						                 <td><formwidget id="causale_fine">
						                   	<formerror id="causale_fine"><br>
						                   		<span class="errori">@formerror.causale_fine;noquote@</span>
						                   	</formerror>
						                 </td>
						             </tr>
					             </table>
					         </td>
					      </tr>
					   </table>
					</td>
				</tr>
				<tr><td colspan=2>&nbsp;</td></tr>
				<tr>
				  <!--rom01<td  align=right class=form_title valign=top>dell'impianto di </td>-->
				  <td  align=right class=form_title valign=top>dell'impianto destinato a </td><!--rom01-->
				   <td  align=left><formwidget id="cod_utgi">
				       <formerror  id="cod_utgi"><br>
				       <span class="errori">@formerror.cod_utgi;noquote@</span>
				       </formerror>
				   </td>
				</tr>
				<tr>
				   <td  align=right class=form_title valign=top>catasto impianti/codice </td>
				   <td  align=left><formwidget id="cod_impianto_est">
				       <formerror  id="cod_impianto_est"><br>
				       <span class="errori">@formerror.cod_impianto_est;noquote@</span>
				       </formerror>
				   </td>
				</tr>
				<tr>
				   <td width=100% colspan=2>
				   <table width=100%>
				     <tr>
				       <td valign=top align=right class=form_title width=21%>Indirizzo</td>
				       <td valign=top width=28%><formwidget id="toponimo">
					    <formwidget id="indirizzo">@cerca_viae;noquote@
				            <formerror  id="indirizzo"><br>
				            <span class="errori">@formerror.indirizzo;noquote@</span>
				            </formerror>
				            <formerror  id="toponimo"><br>
				            <span class="errori">@formerror.toponimo;noquote@</span>
				            </formerror>
				       </td>
				       <td valign=top align=right class=form_title width=7%>N&deg; Civ.</td>
				       <td valign=top width=6% nowrap><formwidget id="numero">/<formwidget id="esponente">
				            <formerror  id="numero"><br>
				            <span class="errori">@formerror.numero;noquote@</span>
				            </formerror>
				       </td>
				       <td valign=top align=right class=form_title width=4%>Scala</td>
				       <td valign=top width=3%><formwidget id="scala">
				            <formerror  id="scala"><br>
				            <span class="errori">@formerror.scala;noquote@</span>
				            </formerror>
				       </td>
				       <td valign=top align=right class=form_title width=4%>Piano</td>
				       <td valign=top width=3%><formwidget id="piano">
				            <formerror  id="piano"><br>
				            <span class="errori">@formerror.piano;noquote@</span>
				            </formerror>
				       </td>
				       <td valign=top align=right class=form_title width=3%>Int.</td>
				       <td valign=top><formwidget id="interno">
				            <formerror  id="interno"><br>
				            <span class="errori">@formerror.interno;noquote@</span>
				            </formerror>
				       </td>
				     </tr>
				   </table>
				</td></tr>
				<tr>
				   <td valign=top align=right class=form_title>Comune</td>
				   <if @flag_ente@ eq P>
				       <td valign=top><formwidget id="cod_comune">
				            <formerror  id="cod_comune"><br>
				            <span class="errori">@formerror.cod_comune;noquote@</span>
				            </formerror>
				       </td>
				   </if>
				   <else>
				       <td valign=top><formwidget id="descr_comune"></td>
				   </else>
				</tr>
				<!-- <tr>
				   <td valign=top align=right class=form_title>Localit&agrave;</td>
				   <td valign=top><formwidget id="localita">
				       <formerror  id="localita"><br>
				       <span class="errori">@formerror.localita;noquote@</span>
				       </formerror>
				   </td>
				</tr> -->
				<tr>
				  <!--rom02 <td  align=right class=form_title width=20%>di propriet&agrave; di </td>-->
				  <td align=left class=form_title width=20%> in qualit&agrave; di
				    <formwidget id="flag_as_resp">
				      <formerror  id="flag_as_resp"><br>
                                        <span class="errori">@formerror.flag_as_resp;noquote@</span>
				      </formerror>
				  </td><!--rom02 aggiunto td e contenuto-->
				  <td  align=left><formwidget id="cognome_resp">
				      <formwidget id="nome_resp">@cerca_prop;noquote@|@link_ins_prop;noquote@
					<formerror  id="cognome_resp"><br>
					  <span class="errori">@formerror.cognome_resp;noquote@</span>
					</formerror>
				  </td>
				  <!--rom02 aggiunto td e campo flag_as_resp
				      <td align=left class=form_title width=7%>in qualit&agrave; di </td>
				   <td  align=left><formwidget id="flag_as_resp">
                                       <formerror  id="flag_as_resp"><br>
					 <span class="errori">@formerror.flag_as_resp;noquote@</span>
                                       </formerror>
                                   </td>-->
				</tr>
				<tr>
				   <td valign=top align=left class=form_title nowrap colspan=2>di potenza termica del focolare complessiva nominale di 
				       <formwidget id="potenza">kW
				       <formerror  id="potenza"><br>
				       <span class="errori">@formerror.potenza;noquote@</span>
				       </formerror>
				   </td>
				</tr>
				<tr><td colspan=2>&nbsp;</td></tr>
				<tr>
				   <td colspan=2 align=left><table width=90%>
				<tr><td width=10%>&nbsp;</td>
					<td>
					<b> 
					Consapevole che la dichiarazione mendace e la falsit&agrave; in atti costituiscono reati ai sensi dell'art. 76 del D.P.R. 445/00
					e comportano l'applicazione della
					sanzione penale, Ai fini
					dell'assunzione dell'incarico di terzo
					responsabile
					</b></td></tr></table>
					</td>
				</tr>
				<tr><td colspan=2>&nbsp;</td></tr>
				<tr>
                                  <td align=right class=form_title>il
				    sottoscritto dichiara</td>
				  <td><formwidget id="fornitore_energia_p">
	                   	    <formerror id="fornitore_energia_p"><br>
	                   	    <span class="errori">@formerror.fornitore_energia_p;noquote@</span>
	                   	    </formerror>
	            	          </td>
				</tr>
				<tr>
				   <td align=right class=form_title>Nome e cognome/ Ragione sociale del committente</td>
				   <td align=left><formwidget id="committente">
		       			<formerror  id="committente"><br>
		       				<span class="errori">@formerror.committente;noquote@</span>
		       			</formerror>
				   </td>
				</tr>
				
				
				<tr><td colspan=2 align=center>&nbsp;</td></tr>
				<if @funzione@ ne "V">
				    <tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
				</if>
				
				<!-- Fine della form colorata -->
			</table>
		</td>
	</tr>
</table>

</formtemplate>

