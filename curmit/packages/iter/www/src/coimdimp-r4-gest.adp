<!DOCTYPE html>
<!--
    USER  DATA       MODIFICHE
    ===== ========== ============================================================================================
    but01 04/12/2024 Modificato intervento di rom06: in caso di stampa con firma non viene più
    but01            aperto un pop-up ma viene aperta una nuova schermata.
	
    rom07 05/07/2023 Giuliodori ha chiesto di non visualizzare piu' la nota ipertestuale del campo cont_rend.

    rom06 28/11/2022 Aggiunta possibilita' di stampare gli rcee con la firma grafometrica in base
    rom06            ai parametri flag_firma_manu_stampa_rcee e flag_firma_resp_stampa_rcee.

    mic01 05/08/2022 Invertiti campi potenza e pot_focolare_nom

    gia01 05/11/2021 Commentata l'inserzione delle anomalie perchè non venga mostrata

    rom05 12/01/2021 Le particolarita' della Provincia di Salerno ora sono sostituite dalla condizione
    rom05            su tutta la Regione Campania.

    rom04 04/03/2019 Aggiunto campo cont_rend per la Regione Marche.

    rom03 19/02/2019 Su richiesta della regione marche ho rinominato il bottone
    rom03            "Ins. Doc." in "Storicizza stampa RCEE".

    gac01 24/01/2019 Su richiesta di Sandro del 24/01/2019 faccio vedere il campo flag_pagato
    gac01            anche in Visualizzazione.

    gac02 16/01/2019 Varie modifiche alle label e spostamento campi

    gac01M16/11/2018 Modificata parte finale del rcee tipo 4 per regione marche

    rom02 03/10/2018 La regione Marche ha richiesto che non fosse più possibile inserire
    rom02            Proprietario e Occupante dalla schermata degli RCEE quindi gli oscuro i link.

    rom01 02/02/2018 Corretto l'inserimento Nuovo allegato modificando flag_tracciato=R1 con flag_tracciato=R3 .
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
<property name="focus_field">@focus_field;noquote@</property><!-- nic01 -->

<if @flag_no_link@ ne T>
    @link_tab;noquote@
</if>
<else>
    <if @nome_funz_caller@ ne insmodh and @nome_funz_caller@ ne insmodg and @nome_funz_caller@ ne imsmodf and @nome_funz_caller@ ne insmodhbis>
        <table width="100%" cellspacing=0 class=func-menu>
        <tr>
           <td width="25%" nowrap class=func-menu>
           <a href="@pack_dir;noquote@/coimgage-gest?@url_gage;noquote@" class=func-menu>Ritorna ad Agenda</a>
           </td>
           <td width="75%" colspan=3 class=func-menu>&nbsp</td>
        </tr>
        </table>
    </if>
</else>
@dett_tab;noquote@
<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <if @menu@ eq 0>
       <td width="12.5%" nowrap class=func-menu>Nuovo Allegato</td>
   </if>
   <else>
   <td width="12.5%" nowrap class=@func_i;noquote@>
       <a href="coimdimp-gest?funzione=I&flag_tracciato=R4&@link_gest;noquote@" class=@func_i;noquote@>Nuovo Allegato</a>
   </td>
   </else>
   <if @funzione@ ne I and @menu@ eq 1>
       <td width="12.5%" nowrap class=@func_v;noquote@>
            <a href="coimdimp-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
       </td>
       <if @flag_modifica@ eq T>
           <td width="12.5%" nowrap class=@func_m;noquote@>
               <a href="coimdimp-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
           </td>
       </if>
       <else>
            <td width="12.5%" nowrap class=func-menu>Modifica</td>
       </else>
       <td width="12.5%" nowrap class=@func_d;noquote@>
           <a href="coimdimp-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
       </td>
       <if @coimtgen.regione@ ne "MARCHE"><!--gac02 aggiunta if--> 
	 <if @flag_modifica@ eq T>
           <td width="12.5%" nowrap class=func-menu>
               <a href="@pack_dir;noquote@/coimanom-list?@link_anom;noquote@" class=func-menu>Anomalie</a>
           </td> 
	 </if>
	 <else>
           <td width="12.5%" nowrap class=func-menu>Anomalie</td>
	 </else>
       </if>

       <td width="12.5%" nowrap class=func-menu>
           <a href="@pack_dir;noquote@/coim_d_anom-list?@link_d_anom;noquote@" class=func-menu>Anomalie Dich.</a>
       </td>

       <if @coimtgen.flag_firma_manu_stampa_rcee@ eq "t" or @coimtgen.flag_firma_resp_stampa_rcee@ eq "t"><!--rom06 Aggiunta if e il suo contenuto-->
        <!--but01
               <td width="12.5%" nowrap class=func-menu>
   	        <a href="#" onclick="javascript:window.open('@pack_dir;noquote@/coimdimp-firma-layout?@link_gest;noquote@&flag_ins=N&flag_traccaito=@flag_tracciato;noquote@' , 'help', 'scrollbars=yes, resizable=yes, width=840, height=520').moveTo(110,140)">Stampa RCEE (Tipo 4) e firma</a>
              </td>
       	      <td width="12.5%" nowrap class=func-menu>
	        <a href="#" onclick="javascript:window.open('@pack_dir;noquote@/coimdimp-firma-layout?@link_gest;noquote@&flag_ins=S' , 'help', 'scrollbars=yes, resizable=yes, width=840, height=520').moveTo(110,140)">Storicizza stampa RCEE (Tipo 4) e firma</a>
	      </td>
	      -->
	      <td width="12.5%" nowrap class=func-menu>
             <a href="@pack_dir;noquote@/coimdimp-firma-layout?@link_gest;noquote@&flag_ins=N&flag_traccaito=@flag_tracciato;noquote@" class=func-menu target="Stampa ">Stampa RCEE (Tipo 4) e firma</a>
	    </td>
	   <td width="12.5%" nowrap class=func-menu>
	  <a href="@pack_dir;noquote@/coimdimp-firma-layout?@link_gest;noquote@&flag_ins=S" class=func-menu target="Stampa RCCEE (Tipo 4)">Storicizza stampa RCEE (Tipo 4) e firma</a>
	 </td>
       </if>
       <else><!--rom06 Aggiunta else ma non il suo contenuto-->
       <td width="12.5%" nowrap class=func-menu>
           <a href="@pack_dir;noquote@/coimdimp-r4-layout?@link_gest;noquote@&flag_ins=N" class=func-menu target="Stampa ">Stampa RCEE (Tipo 4)</a>
       </td>
       <td width="12.5%" nowrap class=func-menu>
           <a href="@pack_dir;noquote@/coimdimp-rct-layout?@link_gest;noquote@&flag_ins=S" class=func-menu target="Stampa RCEE (Tipo 4)">Storicizza stampa RCEE</a><!--rom03 sostituita dicitura bottone-->
       </td>
       </else><!-- rom06 -->
   </if>
   <else>
       <td width="12.5%" nowrap class=func-menu>Visualizza</td>
       <td width="12.5%" nowrap class=func-menu>Modifica</td>
       <td width="12.5%" nowrap class=func-menu>Cancella</td>
       <if @coimtgen.regione@ ne "MARCHE"><!--gac02 aggiunta if-->
	 <td width="12.5%" nowrap class=func-menu>Anomalie</td>
       </if>
       <td width="12.5%" nowrap class=func-menu>Anomalie Dich.</td>
       <td width="12.5%" nowrap class=func-menu>Stampa</td>
       <td width="12.5%" nowrap class=func-menu>Storicizza stampa RCEE</td><!--rom03 sostituita dicitura bottone-->
   </else>
</tr>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_dimp">
<formwidget   id="cod_opma">
<formwidget   id="cod_impianto">
<formwidget   id="data_ins">
<formwidget   id="cod_manutentore">
<formwidget   id="cod_opmanu_new">
<formwidget   id="cod_dimp">
<formwidget   id="cod_responsabile">
<formwidget   id="url_list_aimp">
<formwidget   id="url_aimp">
<formwidget   id="url_gage">
<formwidget   id="flag_no_link">
<formwidget   id="cod_occupante">
<formwidget   id="cod_proprietario">
<formwidget   id="list_anom_old">
<formwidget   id="flag_modifica">
<formwidget   id="gen_prog">
<formwidget   id="flag_ins_occu">
<formwidget   id="flag_ins_prop">
<formwidget   id="flag_modello_h">
<formwidget   id="nome_funz_new">
<formwidget   id="nome_funz_gest">
<formwidget   id="flag_tracciato">
<formwidget   id="locale">
<formwidget   id="esente">
<if @vis_desc_contr@ eq t>
    <formwidget id="flag_status"
</if>
<formwidget   id="__refreshing_p"><!-- nic01 -->
<formwidget   id="changed_field"> <!-- nic01 -->
  <if @coimtgen.regione@ eq "MARCHE">
    <formwidget   id="data_insta">
  </if>
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr><td><table width="100%"><tr>
<td align="left" width="50%">@esito;noquote@</td>
<if @funzione@ eq "V">
<td align="right" width="50%">Inserito da: @nome_utente_ins;noquote@</td></tr>
<tr><td align="left" width="50%">&nbsp;</td>
<td align="right" width="50%">In data: @data_ins_edit;noquote@</td></tr>
</if>
<else>
<td width="50%">&nbsp;</td></tr>
</else>
<if @flag_portafoglio@ eq T>
<tr>
<td align="center" colspan=2><b><font color=red>@report;noquote@</font></b></td></tr>
<!-- <tr><td align="center" colspan=2><b><font color=red><small>@report1;noquote@</small></font></b></td></tr -->
<tr>
<td align="center" colspan=2><b><font color=red>@msg_limite;noquote@</font></b></td></tr>
<tr>
<td align="right" colspan=2><b>Saldo attuale del portafoglio N. <formwidget id="cod_portafoglio">: &#8364;<formwidget id="saldo_manu"></b></td></tr>
<if @coimtgen.regione@ eq "MARCHE">
  <tr>
    <td colspan=2 align=center>
      <formerror  id="err_rcee"><br><!--gac01-->
	<span class="errori">@formerror.err_rcee;noquote@</span>
    </formerror></td>
</td></tr>
</if>
<tr>
  <td colspan=2>&nbsp;</td>
</tr>
</table></td></tr>
</if>
<else>
</table></td></tr>
</else>
@warning_scansione_mancante;noquote@
<tr><td><table width="100%" border=0><tr>
      <if @coimtgen.regione@ eq "MARCHE"><!--gac02 if e suo contenuto-->
	<tr>
	  <th valign=top colspan=4 align=left class=form_title>A.DATI IDENTIFICATIVI</th>
	</tr>
	<tr>
	  <td width=25% align=right>Impianto: di Potenza termica nominale totale max (kW)</td>
	  <td valign=top><formwidget id="pot_ter_nom_tot_max">
	      <formerror  id="pot_ter_nom_tot_max"><br>
		<span class="errori">@formerror.pot_ter_nom_tot_max;noquote@</span>
	      </formerror>
	  </td>
	</tr>
	<tr>
	  <td valign=top align=right class=form_title>Rapporto di controllo N&deg;</td>
	  <td valign=top><formwidget id="num_autocert">
              <formerror  id="num_autocert"><br>
		<span class="errori">@formerror.num_autocert;noquote@</span>
              </formerror>
	  </td>
        </tr>
      </if>
      <else>
	<td valign=top align=right class=form_title>Rapporto di controllo N&deg;</td>
	<td valign=top><formwidget id="num_autocert">
	    <formerror  id="num_autocert"><br>
	      <span class="errori">@formerror.num_autocert;noquote@</span>
	    </formerror>
	</td>
      </else>	
      <if @coimtgen.regione@ ne "MARCHE">
	<td valign=top align=right class=form_title nowrap>Data del controllo <font color=red>*</font></td><!--gac01-->
	<td  valign=top><formwidget id="data_controllo">
            <formerror  id="data_controllo"><br>
              <span class="errori">@formerror.data_controllo;noquote@</span>
            </formerror>
	</td>

    <td valign=top align=right class=form_title>Orario di arrivo presso l'impianto</td><!--gac01-->
    <td  valign=top><formwidget id="ora_inizio">
        <formerror  id="ora_inizio"><br>
        <span class="errori">@formerror.ora_inizio;noquote@</span>
        </formerror>
    </td>

    <td valign=top align=right class=form_title>Orario di partenza dall'impianto</td><!--gac01-->
    <td  valign=top><formwidget id="ora_fine">
        <formerror  id="ora_fine"><br>
        <span class="errori">@formerror.ora_fine;noquote@</span>
        </formerror>
    </td>
</if>
</tr>

<if @coimtgen.regione@ eq "MARCHE"><!--gac02 if else e loro contenuto-->
<tr>
    <td valign=top align=right class=form_title>Numero Rif. interno</td>
    <td valign=top><formwidget id="n_prot">
        <formerror  id="n_prot"><br>
        <span class="errori">@formerror.n_prot;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data di arrivo all'ente</td>
    <td valign=top><formwidget id="data_arrivo_ente">
        <formerror  id="data_arrivo_ente"><br>
        <span class="errori">@formerror.data_arrivo_ente;noquote@</span>
        </formerror>
    </td>
  
</if>
<else>
<tr>
    <td valign=top align=right class=form_title>Num. protocollo</td>
    <td valign=top><formwidget id="n_prot">
        <formerror  id="n_prot"><br>
        <span class="errori">@formerror.n_prot;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data protocollo</td>
    <td valign=top><formwidget id="data_prot">
        <formerror  id="data_prot"><br>
        <span class="errori">@formerror.data_prot;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data di arrivo all'ente</td>
    <td valign=top><formwidget id="data_arrivo_ente">
        <formerror  id="data_arrivo_ente"><br>
        <span class="errori">@formerror.data_arrivo_ente;noquote@</span>
        </formerror>
    </td>
</else>

    <if @flag_cind@ eq "S">
       <td valign=top align=right class=form_title>Campagna<if @funzione@ eq "I">@ast;noquote@</if></td><!-- mis01 -->
       <td valign=top><formwidget id="cod_cind">
         <formerror  id="cod_cind"><br>
         <span class="errori">@formerror.cod_cind;noquote@</span>
         </formerror>
       </td>
    </if>

    </tr></table></td>
</tr>
<tr><td><table border=0 width="100%">
    <tr>
        <td width="17%" valign=top align=left class=form_title>Responsabile</td>
        <td width="16%" valign=top align=left class=form_title>Impresa manutentrice<font color=red>*</font></td>
	<!--rom05 Sostiuito @coimtgen.ente@ ne "PSA" con condizione su Regione CAMPANIA-->
        <td width="17%" valign=top align=left class=form_title>Tecnico che ha effettuato il controllo<if @coimtgen.ente@ ne "PLI"
                                                                               and @coimtgen.ente@ ne "PVE"
                                                                               and @coimtgen.ente@ ne "PCE"
                                                                               and @coimtgen.ente@ ne "PPO"
                                                                               and @coimtgen.ente@ ne "PPD"
                                                                               and @coimtgen.ente@ ne "PBT"
                                                                               and @coimtgen.regione@ ne "CAMPANIA"
                                                                               and @sw_iterprfi@ ne "1">@ast;noquote@</if>
	  <!--rom05 Sostiuito @coimtgen.ente@ eq "PSA" con condizione su Regione CAMPANIA-->
	  <if @coimtgen.regione@ eq "CAMPANIA" and @id_utente_ma;noquote@ eq "MA">
            @ast;noquote@</if>
	  
	</td><!-- mis01 -->
	
	<if @coimtgen.regione@ ne "MARCHE"><!--gac02 aggiunta if-->
          <td width="17%" valign=top align=left class=form_title>Proprietario</td>
          <td width="17%" valign=top align=left class=form_title>Occupante</td>
          <td width="16%" valign=top align=left class=form_title>Intestatario Contratto</td>
	</if>
    </tr>
    <tr>
    <td valign=top><formwidget id="cognome_resp">@link_gest_resp;noquote@<br>
        <formwidget id="nome_resp">@cerca_resp;noquote@<br>
        <formwidget id="cod_fiscale_resp">(CF)<br>
        <formerror  id="cognome_resp"><br>
        <span class="errori">@formerror.cognome_resp;noquote@</span>
        </formerror>
    </td>
    <td valign=top><formwidget id="cognome_manu"><br>
        <formwidget id="nome_manu">@cerca_manu;noquote@
        <formerror  id="cognome_manu"><br>
        <span class="errori">@formerror.cognome_manu;noquote@</span>
        </formerror>
    </td>
        <td valign=top><formwidget id="cognome_opma"><br>
            <formwidget id="nome_opma">@cerca_opma;noquote@
            <formerror  id="cognome_opma"><br>
            <span class="errori">@formerror.cognome_opma;noquote@</span>
            </formerror>
        </td>
    <if @coimtgen.regione@ ne "MARCHE"><!--gac02 aggiunta if-->
    <td valign=top><formwidget id="cognome_prop"><br>
        <formwidget id="nome_prop">@cerca_prop;noquote@
        <formerror  id="cognome_prop"><br>
        <span class="errori">@formerror.cognome_prop;noquote@</span>
        </formerror>
       <br><if @coimtgen.regione@ ne "MARCHE">@link_ins_prop;noquote@</if><!--rom02 la regione marche ha richiesto che non fosse 
									      più possibile inserire Proprietario e Occupante dalla 
									      schermata degli RCEE quindi gli oscuro i link.-->
    </td>
    <td valign=top><formwidget id="cognome_occu"><br>
        <formwidget id="nome_occu">@cerca_occu;noquote@
        <formerror  id="cognome_occu"><br>
        <span class="errori">@formerror.cognome_occu;noquote@</span>
        </formerror>
        <br><if @coimtgen.regione@ ne "MARCHE">@link_ins_occu;noquote@</if><!--rom02 la regione marche ha richiesto che non fosse
                                                                              più possibile inserire Proprietario e Occupante dalla
                                                                              schermata degli RCEE quindi gli oscuro i link.-->
    </td>
    <td valign=top><formwidget id="cognome_contr"><br>
        <formwidget id="nome_contr">@cerca_contr;noquote@
        <formerror  id="cognome_contr"><br>
        <span class="errori">@formerror.cognome_contr;noquote@</span>
        </formerror>
    </td>
    </if>
    </tr></table></td>
</tr>

<tr><td>
<table border=0 width=100%><tr>
    <td width=50% valign=top>
 <table border=0 width=100%><tr>
    <th valign=top colspan=4 align=left class=form_title>B.DOCUMENTAZIONE TECNICA DI CORREDO</th>
    </tr>

    <tr>
    <td valign=top align=right class=form_title>Dichiarazione di Conformit&agrave; presente</td>
    <td valign=top><formwidget id="conformita">
        <formerror  id="conformita"><br>
        <span class="errori">@formerror.conformita;noquote@</span>
        </formerror>
    </td>
  
    <td valign=top align=right class=form_title>Libretto uso/manutenzione generatore presenti</td>
    <td valign=top><formwidget id="lib_uso_man">
        <formerror  id="lib_uso_man"><br>
        <span class="errori">@formerror.lib_uso_man;noquote@</span>
        </formerror>
    </td>
    </tr>

    <tr>
    <td valign=top align=right class=form_title>Libretto impianto presente</td>
    <td valign=top><formwidget id="lib_impianto">
        <formerror  id="lib_impianto"><br>
        <span class="errori">@formerror.lib_impianto;noquote@</span>
        </formerror>
    </td>
   
    <td valign=top align=right class=form_title>Libretto compilato in tutte le sue parti</td>
    <td valign=top><formwidget id="rct_lib_uso_man_comp">
        <formerror  id="lib_uso_man"><br>
        <span class="errori">@formerror.rct_lib_uso_man_comp;noquote@</span>
        </formerror>
    </td>
    </tr>

    <tr>
    <th valign=top colspan=2 align=left class=form_title>C.TRATTAMENTO DELL'ACQUA</th>
    </tr><tr>
    <td valign=top align=right class=form_title>Durezza totale dell'acqua</td>
    <td valign=top><formwidget id="rct_dur_acqua">
        <formerror  id="rct_dur_acqua"><br>
        <span class="errori">@formerror.rct_dur_acqua;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Trattamento in riscaldamento:</td>
    <td valign=top><formwidget id="rct_tratt_in_risc">
        <formerror  id="rct_tratt_in_risc"><br>
        <span class="errori">@formerror.rct_tratt_in_risc;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Trattamento in ACS:</td>
    <td valign=top><formwidget id="rct_tratt_in_acs">
        <formerror  id="rct_tratt_in_acs"><br>
        <span class="errori">@formerror.rct_tratt_in_acs;noquote@</span>
        </formerror>
    </td>
    </tr>
   <tr>

    <th valign=top align=left colspan=4 class=form_title>D. CONTROLLO DELL'IMPIANTO</th>
    </tr><tr> 
    <td valign=top align=right class=form_title>Luogo di installazione idoneo (esame visivo)</td>
    <td valign=top><formwidget id="idoneita_locale">
        <formerror  id="idoneita_locale"><br>
        <span class="errori">@formerror.idoneita_locale;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Tenuta circuito idraulico idonea</td>
    <td valign=top><formwidget id="cog_tenuta_circ_idraulico">
        <formerror  id="cog_tenuta_circ_idraulico"><br>
        <span class="errori">@formerror.cog_tenuta_circ_idraulico;noquote@</span>
        </formerror>
    </td>
   </tr><tr>
    <td valign=top align=right class=form_title>Adeguate dimensioni aperture di ventilazione (esame visivo)</td>
    <td valign=top><formwidget id="ap_ventilaz"
        <formerror  id="ap_ventilaz"><br>
        <span class="errori">@formerror.ap_ventilaz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Tenuta circuito olio idonea</td>
    <td valign=top><formwidget id="cog_tenuta_circ_olio">
        <formerror  id="cog_tenuta_circ_olio"><br>
    	<span class="errori">@formerror.cog_tenuta_circ_olio;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Aperture di ventilazione libere da ostruzioni (esame visivo)</td>
    <td valign=top><formwidget id="ap_vent_ostruz"
        <formerror  id="ap_vent_ostruz"><br>
        <span class="errori">@formerror.ap_vent_ostruz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Tenuta circuito alimentazione combustibile idonea</td>
    <td valign=top><formwidget id="cog_tenuta_circ_alim_combustibile">
        <formerror  id="cog_tenuta_circ_alim_combustibile"><br>
        <span class="errori">@formerror.cog_tenuta_circ_alim_combustibile;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Linee elettriche e cablaggi idonei (esame visivo)</td>
    <td valign=top><formwidget id="tel_linee_eletr_idonee">
        <formerror  id="tel_linee_eletr_idonee"><br>
        <span class="errori">@formerror.tel_linee_eletr_idonee;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Funzionalit&agrave; dello scambiatore di calore di separazione tra unit&agrave; <br>cogenerativa e impianto edificio <small>(se presente)</small> idonea</td>
	<td valign=top><formwidget id="cog_funzionalita_scambiatore">
        <formerror  id="cog_funzionalita_scambiatore"><br>
        <span class="errori">@formerror.cog_funzionalita_scambiatore;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Camino e canale da fumo idonei (esame visivo)</td>
    <td valign=top><formwidget id="rct_canale_fumo_idoneo"
        <formerror  id="rct_canale_fumo_idoneo"><br>
        <span class="errori">@formerror.rct_canale_fumo_idoneo;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=right class=form_title>Capsula insonorizzante idonea (esame visivo)</td>
    <td valign=top><formwidget id="cog_capsula_insonorizzata">
        <formerror  id="cog_capsula_insonorizzata"><br>
        <span class="errori">@formerror.cog_capsula_insonorizzata;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
	
</tr>
</table>
</td>
</tr>
<tr><td><table border=0 width=100%><tr><!--gac02 aggiunta sezione D.bis-->
<tr><td colspan=6><b>D.bis. CONSUMI</b></td></tr>
<tr>   
    <td valign=top align=center colspan=6 class=form_title><b>Consumi di combustibile <if @um;noquote@ ne "">(@um;noquote@)</if></b>
</tr>
<tr>
    <td width=21% valign=top align=center class=form_title>Stagione di riscaldamento attuale</td>
    <td width=15% valign=top align=center class=form_title>Acquisti</td>
    <td width=15% valign=top align=center class=form_title>Scorta o lettura iniziale</td>
    <td width=15% valign=top align=center class=form_title>Scorta o lettura finale</td>
    <td width=34% valign=top align=center class=form_title>Consumi stagione</if></td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="stagione_risc">
        <formerror  id="stagione_risc"><br>
        <span class="errori">@formerror.stagione_risc;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="acquisti">
        <formerror  id="acquisti"><br>
        <span class="errori">@formerror.acquisti;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_iniz">
        <formerror id="scorta_o_lett_iniz"><br>
        <span class="errori">@formerror.scorta_o_lett_iniz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_fin">
        <formerror id="scorta_o_lett_fin"><br>
        <span class="errori">@formerror.scorta_o_lett_fin;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="consumo_annuo">
        <formerror  id="consumo_annuo"><br>
        <span class="errori">@formerror.consumo_annuo;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>@cons_annuo;noquote@</td>
</tr>
<tr>
    <td valign=top align=center class=form_title>Stagione di riscaldamento precedente</td>
    <td valign=top align=center class=form_title>Acquisti</td>
    <td valign=top align=center class=form_title>Scorta o lett. iniziale</td>
    <td valign=top align=center class=form_title>Scorta o lett. finale</td>
    <td valign=top align=center class=form_title>Consumi stagione</if></td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="stagione_risc2">
        <formerror  id="stagione_risc2"><br>
        <span class="errori">@formerror.stagione_risc2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="acquisti2">
        <formerror  id="acquisti2"><br>
        <span class="errori">@formerror.acquisti2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_iniz2">
        <formerror id="scorta_o_lett_iniz2"><br>
        <span class="errori">@formerror.scorta_o_lett_iniz2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="scorta_o_lett_fin2">
        <formerror id="scorta_o_lett_fin2"><br>
        <span class="errori">@formerror.scorta_o_lett_fin2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="consumo_annuo2">
        <formerror  id="consumo_annuo2"><br>
        <span class="errori">@formerror.consumo_annuo2;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>@cons_annuo;noquote@</td>
</tr>
</table></td></tr>
<tr><td><table border=0 width=100%><!--gac02 aggiunto campi elettricità -->
<tr>   
    <td valign=top align=center colspan=4 class=form_title><b>Consumi elettrici</b>
</tr>
<tr>
    <td valign=top align=center class=form_title>Esercizio</td>
    <td valign=top align=center class=form_title>Lettura iniziale (kWh)</td>
    <td valign=top align=center class=form_title>Lettura finale (kWh)</td>
    <td valign=top align=center class=form_title>Consumo totale (kWh)</td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="elet_esercizio_1">
        <formerror  id="elet_esercizio_1"><br>
        <span class="errori">@formerror.elet_esercizio_1;noquote@</span>
        </formerror>
    / <formwidget id="elet_esercizio_2">
        <formerror  id="elet_esercizio_2"><br>
        <span class="errori">@formerror.elet_esercizio_2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_lettura_iniziale">
        <formerror  id="elet_lettura_iniziale"><br>
        <span class="errori">@formerror.elet_lettura_iniziale;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_lettura_finale">
        <formerror  id="elet_lettura_finale"><br>
        <span class="errori">@formerror.elet_lettura_finale;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_consumo_totale">
        <formerror  id="elet_consumo_totale"><br>
        <span class="errori">@formerror.elet_consumo_totale;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=center><formwidget id="elet_esercizio_3">
        <formerror  id="elet_esercizio_3"><br>
        <span class="errori">@formerror.elet_esercizio_3;noquote@</span>
        </formerror>
    / <formwidget id="elet_esercizio_4">
        <formerror  id="elet_esercizio_4"><br>
        <span class="errori">@formerror.elet_esercizio_4;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_lettura_iniziale_2">
        <formerror  id="elet_lettura_iniziale_2"><br>
        <span class="errori">@formerror.elet_lettura_iniziale_2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_lettura_finale_2">
        <formerror  id="elet_lettura_finale_2"><br>
        <span class="errori">@formerror.elet_lettura_finale_2;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="elet_consumo_totale_2">
        <formerror  id="elet_consumo_totale_2"><br>
        <span class="errori">@formerror.elet_consumo_totale_2;noquote@</span>
        </formerror>
    </td>
</tr>

</table></td></tr>
<tr><td><table border=0 width=100%>
    <tr><td colspan=6><b>E. CONTROLLO E VERIFICA ENERGETICA DEL COGENERATORE CG @gen_prog@</b></td></tr>
    <tr>
      <if @coimtgen.regione@ eq "MARCHE"><!--gac02 aggiunta if else e contenuto di if-->
	<td valign=top align=right class=form_title>Fabbricante <if @flag_mod_gend@ eq "S">@ast;noquote@</if></td><!-- mis01 -->
	<td valign=top><formwidget id="descr_cost">
	    <formerror  id="descr_cost"><br>
              <span class="errori">@formerror.descr_cost;noquote@</span>
        </formerror>
	</td>
      </if>
      <else>
	<td valign=top align=right class=form_title>Costruttore <if @flag_mod_gend@ eq "S">@ast;noquote@</if></td><!-- mis01 -->
	<td valign=top><formwidget id="costruttore">
	    <formerror  id="costruttore"><br>
              <span class="errori">@formerror.costruttore;noquote@</span>
        </formerror>
	</td>
      </else>

    <td valign=top align=right class=form_title>Modello <if @flag_mod_gend@ eq "S">@ast;noquote@</if></td><!-- mis01 -->
    <if @coimtgen.flag_gest_coimmode@ eq "F"><!-- nic01 -->
        <td valign=top><formwidget id="modello">
            <formerror  id="modello"><br>
            <span class="errori">@formerror.modello;noquote@</span>
            </formerror>
        </td>
        <formwidget id="cod_mode"><!-- nic01 -->
    </if>
    <else><!-- nic01 -->
        <td valign=top><formwidget id="cod_mode"><!-- nic01 -->
            <formerror  id="cod_mode"><br><!-- nic01 -->
            <span class="errori">@formerror.cod_mode;noquote@</span><!-- nic01 -->
            </formerror><!-- nic01 -->
        </td><!-- nic01 -->
        <formwidget id="modello"><!-- nic01 -->
    </else>

    <td valign=top align=right class=form_title>Matricola <if @flag_mod_gend@ eq "S">@ast;noquote@</if></td><!-- mis01 -->
    <td valign=top><formwidget id="matricola">
        <formerror  id="matricola"><br>
        <span class="errori">@formerror.matricola;noquote@</span>
        </formerror>
    </td>
</tr>
    <if @coimtgen.regione@ ne "MARCHE"><!--gac02 aggiunta if else e contenuto di if-->
      <tr>
      <td valign=top align=right class=form_title>Destinazione @ast;noquote@</td>
      <td valign=top><formwidget id="destinazione">
        <formerror  id="destinazione"><br>
        <span class="errori">@formerror.destinazione;noquote@</span>
        </formerror>
      </td>

      <td valign=top align=right class=form_title>Data installazione @ast;noquote@</td>
      <td valign=top colspan=3><formwidget id="data_insta">
        <formerror  id="data_insta"><br>
        <span class="errori">@formerror.data_insta;noquote@</span>
        </formerror>
	<br><br>
      </td>
      </tr>
    </if>
<tr>
    <td valign=top align=right class=form_title>Tipologia</td>
    <td valign=top><formwidget id="tipologia_cogenerazione">
        <formerror  id="tipologia_cogenerazione"><br>
	<span class="errori">@formerror.tipologia_cogenerazione;noquote@</span>
	</formerror>
    </td>
    <td valign=top align=right class=form_title colspan=2>Potenza elettrica  nominale ai morsetti (kW) @ast;noquote@</td>
    <td valign=top colspan=2><formwidget id="pot_focolare_nom"> <!-- mic01 campo cambiato da potenza a pot_focolare_nom -->
        <formerror  id="pot_focolare_nom"><br>
        <span class="errori">@formerror.pot_focolare_nom;noquote@</span>
        </formerror>
    </td>
</tr>
    <tr>
      <if @coimtgen.regione@ eq "MARCHE"><!--gac02-->
	<td valign=top align=right class=form_title>Alimentazione<if @flag_mod_gend@ eq "S">@ast;noquote@</if></td>
	<td valign=top><formwidget id="descr_comb">
            <formerror  id="descr_comb"><br>
              <span class="errori">@formerror.descr_comb;noquote@</span>
            </formerror>
	</td>
      </if>
      <else>
	<td valign=top align=right class=form_title>Combustibile<if @flag_mod_gend@ eq "S">@ast;noquote@</if></td>
	<td valign=top><formwidget id="combustibile">
            <formerror  id="combustibile"><br>
              <span class="errori">@formerror.combustibile;noquote@</span>
            </formerror>
	</td>
      </else>
    <td valign=top align=right class=form_title colspan=2>Potenza assorbita con il combustibile (kW)</td>
    <td valign=top colspan=2><formwidget id="cog_potenza_assorbita_comb">
        <formerror  id="cog_potenza_assorbita_comb"><br>
        <span class="errori">@formerror.cog_potenza_assorbita_comb;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title>Fluido vettore termico in uscita: @ast;noquote@</font></td>
    <td valign=top><formwidget id="tel_fluido_vett_term_uscita">
	<formerror  id="tel_fluido_vett_term_uscita"><br>
	<span class="errori">@formerror.tel_fluido_vett_term_uscita;noquote@</span>
	</formerror>
    </td>
    <td valign=top align=right class=form_title colspan=2>Potenza termica nominale (massimo recupero) (kW) @ast;noquote@</td>
    <td valign=top colspan=2><formwidget id="potenza"> <!-- mic01 campo cambiato da pot_focolare_nom a potenza -->
        <formerror  id="potenza"><br>
        <span class="errori">@formerror.potenza;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title rowspan=2>Note altro</td>
    <td valign=top rowspan=2><formwidget id="tel_fluido_altro">
        <formerror  id="tel_fluido_altro"><br>
        <span class="errori">@formerror.tel_fluido_altro;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title colspan=2>Potenza termica a piena potenza con by-pass fumi aperto (se presente) (kW)</td>
    <td valign=top colspan=2><formwidget id="cog_potenza_termica_piena_pot">
        <formerror  id="cog_potenza_termica_piena_pot"><br>
        <span class="errori">@formerror.cog_potenza_termica_piena_pot;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign=top align=right class=form_title colspan=2>Emissioni di monossido di carbonio CO riportati al 5% di O</td>
    <td valign=top colspan=2><formwidget id="cog_emissioni_monossido_co">
        <formerror  id="cog_emissioni_monossido_co"><br>
        <span class="errori">@formerror.cog_emissioni_monossido_co;noquote@</span>
        </formerror>
    </td>
</tr>
</table>
</tr>
<table border=0 width=100%>
<if @coimtgen.regione@ eq "MARCHE"><!--rom04aggiunta if e suo contenuto-->
  <tr>
    <td><b>Controllo efficienza energetica</b></td>
    <td valign=top align=left colspan=1><formwidget id="cont_rend">
	<!-- rom07<a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=cont_rend', 'help', 'scrollbars=yes, esizable=yes, width=520, height=280').moveTo(110,140)"><b>Vedi nota</b></a> -->
	<formerror id="cont_rend"><br>
	  <span class="errori">@formerror.cont_rend;noquote@</span>
	</formerror>
    </td>
  </tr>
</if><!--rom04-->
<% if {$coimtgen(regione) eq "MARCHE"}  {
   set ast_cog ""
   } else {
   set ast_cog "<font color=red>*</font>"
   }
   %><!--rom01-->
<tr>
<td>
<tr>
    <td valign=top align=center class=form_title>Temperatura aria comburente (°C) @ast_cog;noquote@</td>
    <td valign=top align=center class=form_title>Temperatura acqua in uscita (°C) @ast_cog;noquote@</td>
    <td valign=top align=center class=form_title>Temperatura acqua in ingresso (°C) @ast_cog;noquote@</td>
    <td valign=top align=center class=form_title>Potenza ai morsetti del generatore (kW) @ast_cog;noquote@</td>
</tr>
<tr>   
    <td valign=top align=center><formwidget id="cog_temp_aria_comburente">
        <formerror  id="cog_temp_aria_comburente"><br>
        <span class="errori">@formerror.cog_temp_aria_comburente;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_temp_h2o_uscita">
        <formerror  id="cog_temp_h2o_uscita"><br>
        <span class="errori">@formerror.cog_temp_h2o_uscita;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_temp_h2o_ingresso">
        <formerror  id="cog_temp_h2o_ingresso"><br>
        <span class="errori">@formerror.cog_temp_h2o_ingresso;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_potenza_morsetti_gen">
        <formerror  id="cog_potenza_morsetti_gen"><br>
        <span class="errori">@formerror.cog_potenza_morsetti_gen;noquote@</span>
        </formerror>
  </tr>
<tr>
    <td valign=top align=center class=form_title>Temperatura acqua motore <small>(solo m.c.i.)</small> @ast_cog;noquote@</td>
    <td valign=top align=center class=form_title>Temperatura fumi a valle dello scambiatore fumi (°C) @ast_cog;noquote@</td>
    <td valign=top align=center class=form_title>Temperatura fumi a monte dello scambiatore fumi (°C) @ast_cog;noquote@</td>
    </td>
        <td>
    </td>
  </tr>
<tr>

    <td valign=top align=center><formwidget id="cog_temp_h2o_motore">
        <formerror  id="cog_temp_h2o_motore"><br>
        <span class="errori">@formerror.cog_temp_h2o_motore;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_temp_fumi_valle">
        <formerror  id="cog_temp_fumi_valle"><br>
        <span class="errori">@formerror.cog_temp_fumi_valle;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_temp_fumi_monte">
        <formerror  id="cog_temp_fumi_monte"><br>
        <span class="errori">@formerror.cog_temp_fumi_monte;noquote@</span>
        </formerror>
    </td>
    <td>
    </td>
  </tr>

<if @coimtgen.regione@ ne "MARCHE"><!--gac02-->
  <tr>
    <td valign=top align=center class=form_title>Sovrafrequenza: soglia di intervento (Hz)</td>
    <td valign=top align=center class=form_title>Sovrafrequenza: tempo di intervento (s)</td>
    <td valign=top align=center class=form_title>Sottofrequenza: soglia di intervento (Hz)</td>
    <td valign=top align=center class=form_title>Sottofrequenza: tempo di intervento (s)</td>
  </tr>
  <tr>
    <td valign=top align=center><formwidget id="cog_sovrafreq_soglia1">/
        <formwidget id="cog_sovrafreq_soglia2">/
        <formwidget id="cog_sovrafreq_soglia3">
        <formerror  id="cog_sovrafreq_soglia1"><br>
        <span class="errori">@formerror.cog_sovrafreq_soglia1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sovrafreq_tempo1">/
        <formwidget id="cog_sovrafreq_tempo2">/
        <formwidget id="cog_sovrafreq_tempo3">
        <formerror  id="cog_sovrafreq_tempo1"><br>
        <span class="errori">@formerror.cog_sovrafreq_tempo1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sottofreq_soglia1">/
        <formwidget id="cog_sottofreq_soglia2">/
        <formwidget id="cog_sottofreq_soglia3">
        <formerror  id="cog_sottofreq_soglia1"><br>
        <span class="errori">@formerror.cog_sottofreq_soglia1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sottofreq_tempo1">/
        <formwidget id="cog_sottofreq_tempo2">/
        <formwidget id="cog_sottofreq_tempo3">
        <formerror  id="cog_sottofreq_tempo1"><br>
        <span class="errori">@formerror.cog_sottofreq_tempo1;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=center class=form_title>Sovratensione: soglia di intervento (V)</td>
    <td valign=top align=center class=form_title>Sovratensione: tempo di intervento (s)</td>
    <td valign=top align=center class=form_title>Sottotensione: soglia di intervento (V)</td>
    <td valign=top align=center class=form_title>Sottotensione: tempo di intervento (s)</td>
  </tr>
  <tr>
    <td valign=top align=center><formwidget id="cog_sovraten_soglia1">/
        <formwidget id="cog_sovraten_soglia2">/
        <formwidget id="cog_sovraten_soglia3">
        <formerror  id="cog_sovraten_soglia1"><br>
        <span class="errori">@formerror.cog_sovraten_soglia1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sovraten_tempo1">/
        <formwidget id="cog_sovraten_tempo2">/
        <formwidget id="cog_sovraten_tempo3">
        <formerror  id="cog_sovraten_tempo1"><br>
        <span class="errori">@formerror.cog_sovraten_tempo1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sottoten_soglia1">/
        <formwidget id="cog_sottoten_soglia2">/
        <formwidget id="cog_sottoten_soglia3">
        <formerror  id="cog_sottoten_soglia1"><br>
        <span class="errori">@formerror.cog_sottoten_soglia1;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=center><formwidget id="cog_sottoten_tempo1">/
        <formwidget id="cog_sottoten_tempo2">/
        <formwidget id="cog_sottoten_tempo3">
        <formerror  id="cog_sottoten_tempo1"><br>
        <span class="errori">@formerror.cog_sottoten_tempo1;noquote@</span>
        </formerror>
    </td>
  </tr>
  </if>
</table>
</td>
</tr>
<tr>
  <td>
   <table border=0 width=100%>
       <tr>
	 <if @coimtgen.regione@ eq "MARCHE"><!--gac02-->
	   <td valign=top class=form_title>Motivo compilazione REE</td><!--sim43 aggiuno campo cod_tprc-->
	 </if>
	 <else>
	   <td valign=top class=form_title>Tipo controllo</td><!--sim43 aggiuno campo cod_tprc-->
	 </else>
     <td valign=top align=left><formwidget id="cod_tprc">
        <formerror  id="cod_tprc"><br>
        <span class="errori">@formerror.cod_tprc;noquote@</span>
        </formerror>
    </td>
    </tr>
   </table>
  </td>
</tr>
<tr>
 <th valign=top align=left class=form_title>F.CHECK-LIST</th>
</tr>
 <tr> 
  <td valign=top align=left class=form_title>Elenco di possibili interventi, dei quali va valutata la convenienza economica, che qualora applicabili all'impianto, potrebbero comportare un miglioramento della prestazione energetica:</td>
 </tr>
 <tr><td colspan=2 align=left><table cellspacing=0 cellpadding=0 border=0>
    <tr>
    <td valign=top align=left class=form_title>L'adozione di valvole termostatiche sui corpi scaldanti</td>
    <td valign=top><formwidget id="rct_check_list_1">
        <formerror  id="rct_check_list_1"><br>
        <span class="errori">@formerror.rct_check_list_1;noquote@</span>
        </formerror>
    </td> 
    </tr><tr>
    <td valign=top align=left class=form_title>L'isolamento della rete di distribuzione nei locali non riscaldati</td>
    <td valign=top><formwidget id="rct_check_list_2">
        <formerror  id="rct_check_list_2"><br>
        <span class="errori">@formerror.rct_check_list_2;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=left class=form_title>L'introduzione di un sistema di trattamento dell'acqua sanitaria e per riscaldamento, ove assente</td>
    <td valign=top><formwidget id="rct_check_list_3">
        <formerror  id="rct_check_list_3"><br>
        <span class="errori">@formerror.rct_check_list_3;noquote@</span>
        </formerror>
    </td>
    </tr><tr>
    <td valign=top align=left class=form_title>La sostituzione di un sistema di regolazione on/off con un sistema programmabile su piu' livelli di temperatura</td>
    <td valign=top><formwidget id="rct_check_list_4">
        <formerror  id="rct_check_list_4"><br>
        <span class="errori">@formerror.rct_check_list_4;noquote@</span>
        </formerror>
    </td>
    </tr>
</table></td>

<tr>
    <td><table border=0><tr>
	  <if @coimtgen.regione@ eq "MARCHE"><!--gac02 aggiunta if else e contenuto di if-->
            <td valign=bottom align=left class=form_title><b>Osservazioni</b><br><a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=osservaz', 'help', 'scrollbars=yes, esizable=yes, width=580, height=380').moveTo(110,140)"><b>Vedi nota</b></a> <!--gac02 aggiunto pop-up su richiesta delle Marche--></td>
	  </if>
          <else>
            <td valign=bottom align=left class=form_title><b>Osservazioni</b></td>
	  </else>
	</tr>
         <tr>
           <td valign=top><formwidget id="osservazioni">
               <formerror  id="osservazioni"><br>
               <span class="errori">@formerror.osservazioni;noquote@</span>
               </formerror>

           </td>
         </tr>
         <tr>
	   <if @coimtgen.regione@ eq "MARCHE"><!--gac02 aggiunta if else e contenuto di if-->
             <td valign=bottom align=left class=form_title><b>Raccomandazioni</b><br><a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=raccomandaz', 'help', 'scrollbars=yes, esizable=yes, width=580, height=380').moveTo(110,140)"><b>Vedi nota</b></a> <!--gac02 aggiunto pop-up su richiesta delle Marche--></td>
	   </if>
	   <else>
	     <td valign=bottom align=left class=form_title><b>Raccomandazioni</b><br> (in attesa di questi interventi l'impianto pu&ograve; essere messo in funzione)</td>
	   </else>
         </tr>
         <tr>
            <td valign=top><formwidget id="raccomandazioni">
                <formerror  id="raccomandazioni"><br>
                <span class="errori">@formerror.raccomandazioni;noquote@</span>
                </formerror>
            </td>
         </tr>
         <tr>
	   <if @coimtgen.regione@ eq "MARCHE"><!--gac02 aggiunta if else e contenuto di if-->
             <td valign=top align=left class=form_title><b>Prescrizioni</b><br><a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=prescriz', 'help', 'scrollbars=yes, esizable=yes, width=580, height=380').moveTo(110,140)"><b>Vedi nota</b></a> <!--gac02 aggiunto pop-up su richiesta delle Marche--></td>
         </tr>
	 </if>
         <else>
	   <td valign=top align=left class=form_title><b>Prescrizioni</b><br> (in attesa di questi interventi l'impianto <b>non</b> pu&ograve; essere messo in funzione)</td>
	 </else>
         </tr>
         <tr>
            <td valign=top><formwidget id="prescrizioni">
               <formerror  id="prescrizioni"><br>
               <span class="errori">@formerror.prescrizioni;noquote@</span>
               </formerror>
            </td>  
         </tr>
    </tr></table></td>
</tr>
<if @coimtgen.regione@ ne "MARCHE"><!--gac02-->
<tr>
    <td><table border=0><tr>
    <td valign=top align=right class=form_title>Data limite intervento</td>
    <td valign=top><formwidget id="data_utile_inter">
        <formerror  id="data_utile_inter"><br>
        <span class="errori">@formerror.data_utile_inter;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Delega responsabile</td>
    <td valign=top><formwidget id="delega_resp">
        <formerror  id="delega_resp"><br>
        <span class="errori">@formerror.delega_resp;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Delega manutentore</td>
    <td valign=top><formwidget id="delega_manut">
        <formerror  id="delega_manut"><br>
        <span class="errori">@formerror.delega_manut;noquote@</span>
        </formerror>
    </td>
    </tr></table></td>
</tr>
<!--gia01
<tr><td align=right><table border=0 width="100%">
    <tr>
        <td valign=top align=right class=form_title>Data utile interv.</td>
        <td valign=top class=form_title>Anomalia</td>
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
    </tr>
    </multiple>
-->
</table></td></tr>
</if>
<tr><td><table border=0 width="100%"><tr>
<tr>
    <td width="40%" valign=top align=right class=form_title><b>L'impianto pu&ograve; funzionare
    <td width="10%" valign=top>  
        <if @vis_desc_contr@ eq f>
                <formwidget id="flag_status">
                <formerror  id="flag_status"><br>
                <span class="errori">@formerror.flag_status;noquote@</span>
                </formerror>
        </if>
        <else>
                <formwidget id="flag_stat">
                <formerror  id="flag_stat"><br>
                <span class="errori">@formerror.flag_stat;noquote@</span>
                </formerror>
        </else>
    </td>
    <if @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA">
    <td width="30%" valign=top align=right class=form_title>Data scadenza RCEE con segno identificativo</td>
    </if>
    <else>
        <td width="30%" valign=top align=right class=form_title>Data scadenza dichiarazione</td>
    </else>
    <td width="20%" valign=top><formwidget id="data_scadenza_autocert">
        <formerror  id="data_scadenza_autocert"><br>
        <span class="errori">@formerror.data_scadenza_autocert;noquote@</span>
        </formerror>
    </td>
</tr>
</table></td></tr>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td><table border=0>
<if @coimtgen.regione@ ne "MARCHE"><!--gac01-->
<if @flag_portafoglio@ eq T>
<tr>
    <td valign=top align=right class=form_title width=13%>Tariffa</td>
    <td valign=top width=10%><formwidget id="tariffa_reg">
        <formerror  id="tariffa_reg"><br>
        <span class="errori">@formerror.tariffa_reg;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title width=9%>Importo</td>
    <td valign=top width=10% nowrap><formwidget id="importo_tariffa">&#8364;
        <formerror  id="importo_tariffa"><br>
        <span class="errori">@formerror.importo_tariffa;noquote@</span>
        </formerror>
    </td>
    <if @funzione@ eq V>
     @message;noquote@
    </if>
    <else>
     <td>&nbsp;</td>
    </else>
</tr>
</if>
</if>
</table></td></tr>
<tr><td><table border=0>
<tr>
  <if @coimtgen.regione@ ne "MARCHE"><!--gac01-->
    <td valign=top align=right class=form_title>Tipologia Costo</td>
    <td valign=top><formwidget id="tipologia_costo">
        <formerror  id="tipologia_costo"><br>
        <span class="errori">@formerror.tipologia_costo;noquote@</span>
        </formerror>
    </td>
  </if>
  <else>
    <formwidget   id="tipologia_costo">
  </else>
  <if @coimtgen.regione@ ne "MARCHE"><!--gac01-->
      <td valign=top align=right class=form_title width=21%>Costo <if @esente@ eq "f">
                                                                  <if @tipologia_costo@ ne "" or @flag_pagato@ eq "S">
                                                                    @ast;noquote@</if></if></td><!-- mis01 -->
    </if>
    <else><!--gac01-->
      <td valign=top align=right class=form_title width=21%>Costo del segno identificativo</td>
    </else>
    <td valign=top><formwidget id="costo">&#8364;
        <formerror  id="costo"><br>
        <span class="errori">@formerror.costo;noquote@</span>
        </formerror>
    </td>
</tr>
<if @coimtgen.regione@ ne "MARCHE"><!--gac02-->
  <tr>
    <td valign=top align=right class=form_title>Rif./Numero bollino</td>
    <td valign=top><formwidget id="riferimento_pag">
        <formerror  id="riferimento_pag"><br>
        <span class="errori">@formerror.riferimento_pag;noquote@</span>
        </formerror>
    </td>
  </tr>
</if>
<tr>
  <if @coimtgen.regione@ ne "MARCHE"><!--gac01-->
    <td valign=top align=right class=form_title>Pagato</td>
    <td valign=top><formwidget id="flag_pagato">
        <formerror  id="flag_pagato"><br>
          <span class="errori">@formerror.flag_pagato;noquote@</span>
        </formerror>
    </td>
  </if>
  <else>
    <td valign=top align=right class=form_title>Segno identificativo pagato <font color=red>*</font></td><!--gac01-->
    <td valign=top colspan=3><formwidget id="flag_pagato">
	<a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=flag-pag', 'help', 'scrollbars=yes, esizable=yes, width=580, height=380').moveTo(110,140)"><b>Vedi nota</b></a> <!--gac01 aggiunto pop-up su richiesta delle Marche-->
        <formerror  id="flag_pagato"><br>
          <span class="errori">@formerror.flag_pagato;noquote@</span>
        </formerror>
    </td>
  </else>
</tr>
<!--gac01 sandro mi ha detto di toglierlo su tutti gli enti <tr>
  <td valign=top align=right class=form_title>Data scad. pagamento</td>
  <td valign=top><formwidget id="data_scad_pagamento">
      <formerror  id="data_scad_pagamento"><br>
            <span class="errori">@formerror.data_scad_pagamento;noquote@</span>
      </formerror>
  </td>
</tr> -->
<if @coimtgen.regione@ eq "MARCHE"><!--gac01-->
  <tr>
    <td valign=top align=right class=form_title nowrap>Data del controllo <font color=red>*</font></td><!--gac01-->
    <td  valign=top><formwidget id="data_controllo">
        <formerror  id="data_controllo"><br>
          <span class="errori">@formerror.data_controllo;noquote@</span>
        </formerror>
    </td>
    
    <td valign=top align=right class=form_title>Orario di arrivo presso l'impianto</td><!--gac01-->
    <td  valign=top><formwidget id="ora_inizio">
        <formerror  id="ora_inizio"><br>
          <span class="errori">@formerror.ora_inizio;noquote@</span>
        </formerror>
    </td>
    
    <td valign=top align=right class=form_title>Orario di partenza dall'impianto</td><!--gac01-->
    <td  valign=top><formwidget id="ora_fine">
        <formerror  id="ora_fine"><br>
          <span class="errori">@formerror.ora_fine;noquote@</span>
        </formerror>
    </td>
  </tr>
</if>
<tr>
  <if @coimtgen.regione@ eq "MARCHE"><!--gac01-->
    <td valign=top align=right class=form_title nowrap>Data ultima manutenzione ordinaria effettuata @ast_CANCONA;noquote@</td>
    <td><formwidget id="data_ultima_manu"><a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=data_ultima_manu', 'help', 'scrollbars=yes, esizable=yes, width=580, height=380').moveTo(110,140)"><b>Vedi nota</b></a>
	<formerror  id="data_ultima_manu"><br>
	  <span class="errori">@formerror.data_ultima_manu;noquote@</span>
	</formerror>
    </td>
  </if>
  <td valign=top align=right class=form_title>Si raccomanda un intervento manutentivo entro il @ast_CANCONA;noquote@</td><!--gac01 modificata label-->
  <td valign=top><formwidget id="data_prox_manut">
            <formerror  id="data_prox_manut"><br>
            <span class="errori">@formerror.data_prox_manut;noquote@</span>
            </formerror>
        </td>
    </tr></table></td>
</tr>
<tr>
  <td valign=top colspan=2 align=center><formwidget id="msg_rcee"><!--gac01-->
      <formerror  id="msg_rcee"><br>
	<span class="errori">@formerror.msg_rcee;noquote@</span>
      </formerror>
  </td>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=1 align=center><formwidget id="submit"></td></tr>
</if>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

