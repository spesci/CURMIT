<!--
    USER  DATA       MODIFICHE
    ===== ========== =================================================================================
    mat01 09/09/2025 Aggiunto un if per cambiare il link del modifica nel caso di regione Marche.

    ric01 21/01/2025 Centrato link "Aggiungi" e tabella bruciatori, aggiunta riga vuota.

    rom27 16/03/2023 Belluzzo ha chiesto che non venisse piu' mostrata la dicitura in alto alla pagina in fase di
    rom27            inserimento di un nuovo generatore.

    rom26 15/03/2023 Modificato intervento di rom25, il cmapo fluido lato utenze per il freddo va mostrato anche
    rom26            per Palermo e regione Campania.

    rom25 13/03/2023 Ucit deve vedere il campo fluido lato utenze per il freddo.

    rom24 30/01/2023 Belluzzo ha richiesto con mail "Richiesta informativa normativa Dpr 660/96" del 20/01/2023 di rendere
    rom24            il campo Marcatura efficienza energetica (marc_effic_energ) non obbligatorio.

    rom23 04/08/2022 Modifiche per allineamento enti di Ucit al nuovo cvs. Ucit per il freddo non deve vedere
    rom23            il campo potenza frigorifera utile pot_utile_nom_freddo.

    rom22 08/04/2022 Su segnalazione del Comune di Potenza e indicazione di Sandro il campo note per il
    rom22            fluido termovettore da compilare se si sceglie Altro si deve vedere per tutte le
    rom22            di impianto, prima veniva visualizzato solo per le Marche.

    rom21 02/03/2022 Regione Marche tramite mail di Giuliodori "sostituzione bruciatore" del 20/01/2022
    rom21            ha richiesto che per ogni generatore sia possibile sostituire il bruciatore.
    rom21            Con Sandro si e' deciso di dare la possibilita' di avere piu' bruciatori attivi
    rom21            per lo stesso generatore. Quando un generatore viene sostituito i bruciatori attivi
    rom21            collegati al generatore vanno disattivati. Il nuovo generatore attivo all'inizio non
    rom21            ha nessun bruciatore collegato.

    rom20 08/11/2021 Aggiunto warning in fase di modifica per il combustibile per Regione Marche.

    rom19 08/11/2021 Corretto errore sulla visualizzazione di alcuni campi obbligatori che non erano 
    rom19            visibili per regione Basilicata.

    rom18 20/04/2021 Modificato messaggio "Se non esiste la Potenza termica nominale mettere 0" per il
    rom18            freddo in "Lasciare vuoti i campi relativi alla funzione non presente."    	  

    gac05 07/'6/2019 Aggiunta condizione sull'impianto del freddo che non deve vedere il link Vedi nota

    rom17 05/03/2019 Aggiunto campo tel_alimentazione, e' visibile per tutti gli enti se l'impianto e'
    rom17            teleriscaldamento. Rifaccio vedere il campo mod_funz per le Marche se l'impianto 
    rom17            e' di teleriscaldamento.

    rom16 26/02/2019 Inserita nota sotto il campo pot_focolare_lib per le Marche. Richiesta fatta 
    rom16            durante la call del 25/02.

    rom15 19/02/2019 Per gli impianti della Regione Marche non faccio più visualizzare
    rom15            i campi flag_altro e funzione_grup_ter_note_altro. 
    rom15            Richiesta fatta dalla Regione dopo call del 18/02/2019

    rom14 23/01/2019 Aggiunto warning richiesto dalle Marche sulla sostituzione: se si sostituisce
    rom14            un generatore e la Tipologia Intervento della Scheda1 è diversa da
    rom14            "Sostituzione del generatore" mostro un messaggio in rosso non bloccante.
    rom14            Modifiche grafiche per la cogenerazione e teleriscaldamento

    rom13 08/01/2019 Modifiche grafiche per le marche sul freddo, teleriscaldamento e cogenerazione.

    rom12 30/11/2018 Aggiunti i campi flag_clima_invernale, flag_clim_est, flag_prod_acqua_calda e flag_altro.
    rom12            I nuovi campi prendono il posto di funzione_grup_ter.  Solo in visualizzazione riporto
    rom12            a fianco dei nuovi campi la potenza_utile dell'impainto se sono flaggati con "Si".

    rom11 05/11/2018 Tolto il campo cod_utgi per le Marche.

    rom10 25/10/2018 Aggiunti i campi cognome_inst e nome_inst per la Regione Marche. messo nella 4.1/4.4bis

    rom09 28/08/2018 Modifiche sulle label per ulteriori richieste della Regione Marche.
    rom09            Aggiunta dicitura prima del campo "Funzione del GT".
    rom09            Rimpaginata tutta la sezione 4.2 e cambiate le label.
    rom09.bis        Aggiunto bottone "Sostituzione generatore esistente", spostato campo funzione_grup_ter_note_altro
    rom09.bis        sulla stessa riga  del campo funzione_grup_ter e reso invisibile il campo data_costruz_bruc
    rom09.bis        solo per le Marche su richiesta di Sandro.
    rom09.bis        Su richiesta di Sandro faccio vedere gli asterischi rossi solo se sono in modifica
    rom09.bis        o inserimento per i campi cod_emissione, pot_utile_nom e marc_effic_energ.

    rom08 09/08/2018 Modifiche sulle label su richiesta della Regione Marche.

    gac04 16/07/2018 Aggiunto info su marcatura efficienza energetica e classif. dpr 660/96

    rom07 02/07/2018 Aggiunto link per aggiungere altri genratori che servono lo stesso ambiente,
    rom07            al momento lo faccio vedere solo per le Marche.

    gac03 02/07/2018 Modificate label

    rom06 19/06/2018 Aggiunto link link_coimgend_pote per inserire le potenze sui singoli moduli delle
    rom06            prove fumi

    rom05 07/06/2018 Su richiesta della rEGIONE Marche, per il freddo, non faccio vedere i campi
    rom05            dpr_660_96, flag_caldaia_comb_liquid, funzione_grup_ter, funzione_grup_ter_note_altro

    gac02 08/05/2018 Aggiunto campi rif_uni_10389 e altro_rif

    rom02M 11/04/2018Rinominata la sezione "Altri campi obbligatori non presenti sul libretto ma richiesti dalla legge regionale:"
    rom02M           con "Scheda 4.1bis: Dati Specifici Gruppi Termici" per la Regione Marche  
    rom02M           e modificata l'impaginazione con l'aggiunta dei nuovi campi delle Marche. 

    rom03 26/10/2018 Sui generatori di un impianto del freddo non faccio più vedere il campo cod_emissione (Scarico fumi).

    rom02 16/10/2018 Sui generatori di un impianto del freddo non faccio più vedere il campo dpr_660_96.

    gac01 12/02/2018 Aggiunti campi relativi al cogeneratore

    sim09 08/02/2018 Rivisitato completamente l'adp per fare in modo che assomigli il più possibile
    sim09            alla stampa del libretto

    sim08 24/01/2018 Aggiunto i nuovi campi per e cop sul generatore del freddo

    rom01 23/01/2018 Gestito il nuovo campo num_prove_fumi sul generatore del caldo.

    sim05 19/10/2017 Gestito il nuovo campo num_circuiti sul generatore del freddo.
    sim05            Richiesto per la DAM delle Marche ma va bene per tutti gli enti e di default è 1

    sim04 01/08/2017 Aggiunto la potenza utile del freddo che in un primo momento non era stata
    sim04            prevista.
    sim04            Dato che si era deciso di riusare il campo pot_utile_nom per la potenza di
    sim04            assorbimento ho dovuto usare il nuovo campo pot_utile_nom_freddo

    gab02 07/04/2017 Modifiche per gestire il generatore nel caso di un impianto con Teleriscaldamento 

    sim02 23/01/2017 Aggiunto asterischi su Destinazione d'uso e scarico fumi

    gab01 07/10/2016 Aggiunti asterischi (*) davanti ai campi obbligatori

    sim01 09/05/2016 Aggiunto sul generatore del freddo la Potenza Nominale in riscaldamento e
    sim01            Potenza Utile in riscaldamento (richiesto >da ASPES).

    nic01 17/03/2014 Comune di Rimini: se è attivo il parametro flag_gest_coimmode, deve
    nic01            comparire un menù a tendina con l'elenco dei modelli relativi al
    nic01            costruttore selezionato (tale menù a tendina deve essere rigenerato
    nic01            quando si cambia la scelta del costruttore).
-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
<property name="focus_field">@focus_field;noquote@</property><!-- nic01 -->

<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_gen_prog">
<formwidget   id="cod_impianto">
<formwidget   id="url_list_aimp">
<formwidget   id="gen_prog_old">
<formwidget   id="__refreshing_p"><!-- nic01 -->
<formwidget   id="changed_field"> <!-- nic01 -->
<formwidget   id="gen_prog">

@link_tab;noquote@
@dett_tab;noquote@
<table width="100%" cellspacing=0 class=func-menu>
<tr>
	<td width="20%" nowrap class=@func_i;noquote@>
	    <!--rom07  <a href="coimgend-gest?funzione=I&@link_gest;noquote@" class=@func_i;noquote@>Inserimento Ulteriori generatori</a>-->
	    <a href="coimgend-gest?funzione=I&@link_gest;noquote@" class=@func_i;noquote@>Inserimento ulteriori generatori dello stesso impianto</a><!--rom07-->
	</td>

	<if @funzione@ ne I >
  	    <if @link_sost_gen@ eq "S">
	    	<td width="20%" nowrap class=@func_s;noquote@><!--rom09.bis-->
	    	    <a href="coimgend-gest?funzione=S&@link_gest;noquote@" class=@func_s;noquote@>Sostituzione generatore esistente</a>
	    	</td>
            </if>
            <else>
                <td width="20%" nowrap class=func-menu>Sostituzione generatore esistente</td>
            </else>
            <td width="20%" nowrap class=@func_v;noquote@>
	    	    <a href="coimgend-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
	    </td>  
	    <if @coimtgen.regione@ ne "MARCHE"> <!--mat01 aggiunta if-else e contenuto else-->
    	       <td width="20%" nowrap class=@func_m;noquote@>
                   <a href="coimgend-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
               </td>
	     </if><else>
		<td width="20%" nowrap class=@func_m;noquote@>
        	    <a href="coimgend-gest-modifica-intermedio?@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
    		</td>
	     </else>
             <td width="20%" nowrap class=@func_d;noquote@>
  		    <a href="coimgend-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
	    </td>
	</if>
       <else>
	<td width="20%" nowrap class=func-menu>Sostituzione generatore esistente</td><!--rom09.bis-->
       	<td width="20%" nowrap class=func-menu>Visualizza</td>
       	<td width="20%" nowrap class=func-menu>Modifica</td>
       	<td width="20%" nowrap class=func-menu>Cancella</td>
       </else>
</tr>
</table>

<if @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA"><!-- rom27 Aggiunta if ma non il suo contenuto. -->
<if @funzione@ eq I>
<!--rom08<b><u>Per una nuova Installazione aggiornare i dati relativi alla scheda su Dati tecnici e stampare la scheda E1/E2 da Scheda Imp.</u></b>-->
<table ><!--rom08 aggiunta table e contenuto-->
  <tr>
    <td>
      <table width="100%">
	<tr>
	  <td><big><b>ATTENZIONE</b>:inserire un ulteriore generatore solo se fa parte dello stesso impianto del/dei generatore/i gi&agrave; inserito/i.<br>Le potenze nominali utili saranno sommate in un unico Rapporto di controllo dell'efficienza energetica (<a href="#" onclick="javascript:window.open('coimgend-ins-help?flag_tipo_impianto=@flag_tipo_impianto@', 'help', 'scrollbars=yes, esizable=yes, width=580, height=320').moveTo(110,140)"><u>clicca qui per maggiori dettagli</u></a>).<br>Se il nuovo generatore non fa perte dello stesso impianto, vai al men&ugrave; "Inserisci nuovo impianto".</big></td>
	</tr>
      </table>
    </td>
  </tr>
</table>
</if>
</if><!-- rom27 -->

<table border=0>

<if @coimtgen.regione@ ne "MARCHE"><!--rom11 Aggiunta if-->
  <tr><td colspan=6 class=func-menu-yellow2><b>Scheda 1.3: Generatore destinato a soddisfare i seguenti servizi</b></td></tr> 
  <tr><td colspan=6>&nbsp;</td></tr>
  <tr><td valign=top align=right class=form_title>Destinazione d'uso <font color=red>@cod_utgi_asterisco@</font></td><!-- gab01 -->
    <td valign=top colspan=3><formwidget id="cod_utgi">
        <formerror  id="cod_utgi"><br>
          <span class="errori">@formerror.cod_utgi;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title></td>
    <td valign=top>
    </td>
  </tr>
</if><!--rom11-->
<if @coimtgen.regione@ eq "MARCHE"><!--rom14 aggiunta if e suo contenuto-->
  <tr><td colspan=6 align=center>@warning_sostituzione;noquote@</td></tr>
</if>
<tr><td colspan=6>&nbsp;</td></tr>
<if @flag_tipo_impianto@ eq "R">
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.1: Dati del gruppo termico/ generatore</b></td></tr> <!--gac03-->
</if>
<if @flag_tipo_impianto@ eq "F">
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.4: Dati della macchina frigorifera / pompa di calore</b></td></tr>
</if>
<if @flag_tipo_impianto@ eq "T">
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.5: Dati dello scambiatore di calore</b></td></tr>
</if>
<if @flag_tipo_impianto@ eq "C"> <!--gac01-->
<tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.6: Dati del cogeneratore / trigeneratore</b></td></tr>
</if>
<tr><td colspan=6>&nbsp;</td></tr>
<tr>
      <if @flag_tipo_impianto@ eq "R">
	<td valign=baseline align=right class=form_title>Gruppo termico numero</td><!--gac03-->
      </if>
      <if @flag_tipo_impianto@ eq "F">
	<td valign=baseline align=right class=form_title>Gruppo Frigo/pompa di calore numero</td>
      </if>
      <if @flag_tipo_impianto@ eq "C"><!--rom14-->
	<td valign=baseline align=right class=form_title>Cogeneratore numero</td>
      </if>
      <if @flag_tipo_impianto@ eq "T"><!--rom14-->
	<td valign=baseline align=right class=form_title>Scambiatore di calore numero</td>
      </if>
      <td valign=baseline><formwidget id="gen_prog_est">
          <formerror  id="gen_prog_est"><br>
            <span class="errori">@formerror.gen_prog_est;noquote@</span>
        </formerror>
      </td>
    <td valign=top align=right class=form_title>Descrizione</td>
    <td valign=top colspan=3><formwidget id="descrizione">
	<formerror  id="descrizione"><br>
        <span class="errori">@formerror.descrizione;noquote@</span>
        </formerror>
        <br><i>Ulteriori informazioni per identificare il generatore</i>
    </td>
</tr>
<tr>
<if @coimtgen.regione@ ne "MARCHE" and @flag_tipo_impianto@ ne "C"> <!-- rom02M aggiunta if --> 
    <td valign=top align=right class=form_title>Data costruzione <font color=red>@data_costruz_gen_asterisco@</font></td><!--gab01-->
    <td valign=top><formwidget id="data_costruz_gen">
        <formerror  id="data_costruz_gen"><br>
        <span class="errori">@formerror.data_costruz_gen;noquote@</span>
        </formerror>
    </td>
</if>
    <td valign=top align=right class=form_title>Data installazione<font color=red>@data_installaz_asterisco;noquote@</font></td><!--gab01-->
    <td valign=top><formwidget id="data_installaz">
        <formerror  id="data_installaz"><br>
        <span class="errori">@formerror.data_installaz;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Data dismissione/disattivazione</td>
    <td valign=top><formwidget id="data_rottamaz">
        <formerror  id="data_rottamaz"><br>
        <span class="errori">@formerror.data_rottamaz;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><if @coimtgen.regione@ ne "MARCHE">
    <td valign=top align=right class=form_title>Attivo</td>
    <td valign=top><formwidget id="flag_attivo">
        <formerror  id="flag_attivo"><br>
        <span class="errori">@formerror.flag_attivo;noquote@</span>
        </formerror>
    </td>
  </if>
  <if @flag_tipo_impianto@ eq "R"><!-- dpr74 --> <!-- gab02 aggiunta condizione and @flag_tipo_impianto@ ne "T" alla if-->
        <td valign=top align=right class=form_title>Tipo gruppo termico</td>
    	<td valign=top colspan=3><formwidget id="cod_grup_term">
	   <formerror  id="cod_grup_term"><br>
           <span class="errori">@formerror.cod_grup_term;noquote@</span>
	   </formerror>	</td>
    </if><else><!--gac01 else e contenuto-->
      <td colspan=2></td>
      <td colspan=2></td>      
    </else>
</tr>
<tr>
<!--rom08    <td valign=top align=right class=form_title>Costruttore <font color=red>@cod_cost_asterisco@</font></td><!-- gab01 ->-->
<td valign=top align=right class=form_title>Fabbricante<font color=red>@cod_cost_asterisco;noquote@</font></td><!--rom08-->
    <td valign=top><formwidget id="cod_cost">
        <formerror  id="cod_cost"><br>
        <span class="errori">@formerror.cod_cost;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Modello<font color=red>*</font></td><!-- gab01 -->

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
</tr>
<tr>
    <td valign=top align=right class=form_title>Matricola<font color=red>*</font></td><!-- gab01 -->
    <td valign=top><formwidget id="matricola">
        <formerror  id="matricola"><br>
        <span class="errori">@formerror.matricola;noquote@</span>
        </formerror>
    </td>
    <if @flag_tipo_impianto@ eq "F"><!--rom013 if e contenuto-->
      <td valign=top align=right class=form_title>Sorgente lato esterno:@sorgente_lato_esterno_asterisco;noquote@</td>
      <td valign=top><formwidget id="sorgente_lato_esterno">
	  <formerror id="sorgente_lato_esterno"><br>
	    <span class="errori">@formerror.sorgente_lato_esterno;noquote@</span>
	  </formerror>
      </td>
      <if @coimtgen.regione@ eq "FRIULI-VENEZIA GIULIA" or @coimtgen.regione@ eq "CAMPANIA" or @coimtgen.ente@ eq "PPA" or @coimtgen.ente@ eq "PRI"><!-- rom25 Aggiunta if e il suo contenuto -->
        <td valign="top" align="right" class="form_title">Fluido lato utenze</td>
        <td valign="top"><formwidget id="fluido_lato_utenze">
          <formerror id="fluido_lato_utenze"><br>
            <span class="errori">@formerror.fluido_lato_utenze;noquote@</span>
          </formerror> 
        </td>
      </if><!-- rom25 -->
    </if>
    <if @flag_tipo_impianto@ eq "T"><!--rom14-->
      <td valign=top nowrap align=right class=form_title>Potenza termica nominale totale<font color=red>*</font></td>
      <td valign=top><formwidget id="pot_focolare_nom">
	  <formerror  id="pot_focolare_nom"><br>
	    <span class="errori">@formerror.pot_focolare_nom;noquote@</span>
	  </formerror>
      </td>
    </if>
</tr>
<if @flag_tipo_impianto@ eq "T"><!--rom17 aggiunta if e suo contenuto-->
  <tr>
    <td valign=top align=right class=form_title>Alimentazione<font color=red>*</font></td>
    <td valign=top><formwidget id="tel_alimentazione">
	<formerror id="tel_alimentazione"><br>
	  <span class="errori">@formerror.tel_alimentazione;noquote@</span>
	</formerror>
    </td>
      <td valign=top align=right class=form_title>Fluido Termovettore<font color=red>*</font></td>
      <td valign=top><formwidget id="mod_funz">
	  <formerror id="mod_funz"><br>
	    <span class="errori">@formerror.mod_funz;noquote@</span>
	  </formerror>
      </td>
    <td valign=top align=right class=form_title>Se Altro specificare</td><!--rom22-->
    <td valign=top><formwidget id="altro_funz">
	<formerror  id="altro_funz"><br>
          <span class="errori">@formerror.altro_funz;noquote@</span>
	</formerror>
    </td>
    
  </tr>
</if>
<if @flag_tipo_impianto@ eq "C"> <!--gac01 aggiunto if e suo contenuto-->
  <td valign=top align=right class=form_title>Tipologia</td>
  <td valign=top><formwidget id="tipologia_cogenerazione">
      <formerror  id="tipologia_cogenerazione"><br>
	<span class="errori">@formerror.tipologia_cogenerazione;noquote@</span>
  </formerror> </td>
  <td valign=top align=right class=form_title>Alimentazione <font color=red>@cod_combustibile_asterisco;noquote@</font></td>
  <td valign=top><formwidget id="cod_combustibile">
      <formerror  id="cod_combustibile"><br>
	<span class="errori">@formerror.cod_combustibile;noquote@</span>
      </formerror>
  </td>
</if>
  <if @flag_tipo_impianto@ ne "F" and @flag_tipo_impianto@ ne "C" and @flag_tipo_impianto@ ne "T"><!--rom14-->
  <tr><td valign=top align=right class=form_title>Combustibile <font color=red>@cod_combustibile_asterisco;noquote@</font></td><!-- gab01 -->
    <td valign=top><formwidget id="cod_combustibile">
        <formerror  id="cod_combustibile"><br>
          <span class="errori">@formerror.cod_combustibile;noquote@</span>
        </formerror>
	<a href="#" onclick="javascript:window.open('coimgend-ins-help?caller=combustibile', 'help', 'scrollbars=yes, esizable=yes, width=580, height=320').moveTo(110,140)">vedi nota</a>
    </td>
    <if @flag_tipo_impianto@ eq "R">
      <!--rom08    <td valign=top align=right class=form_title>Numero prove fumi<font color=red>*</font></td>-->
      <td valign=top align=right class=form_title>Numero analisi prove fumi previste<font color=red>*</font></td><!--rom08-->
      <td valign=top colspan=3><formwidget id="num_prove_fumi">
          <formerror  id="num_prove_fumi"><br>
            <span class="errori">@formerror.num_prove_fumi;noquote@</span>
          </formerror>
          @link_coimgend_pote;noquote@
      </td>
    </if> 
  </tr>
  <if @coimtgen.regione@ eq "MARCHE" and @funzione@ eq "M"><!--rom20 Aggiunta if e suo contenuto-->
    <tr>
      <td>&nbsp;</td>
      <td colspan="3"><font color="red">Se si cambia il combustibile, occorre verificare la correttezza della potenza nominale utile e del rendimento termico utile preesistenti.</font></td>
    </tr>
  </if>
  <tr>
<td></td>
<td colspan=3>
<font color=blue>@msg_cod_combustibile;noquote@</font><!--gac06-->
</td>
</tr>
  <if @flag_tipo_impianto@ eq "T">
</tr>
</if>
</if>
<if @coimtgen.regione@ eq "MARCHE" or @coimtgen.regione@ eq "BASILICATA"><!--rom19 Aggiunta if ma non il contenuto-->
  <if @flag_tipo_impianto@ eq "F"><!--rom013 if e contenuto-->
    <tr>
      <td valign="top" align="right" class="form_title">Fluido frigorigeno@cod_flre_asterisco;noquote@</td>
      <td valign="top">
        <formwidget id="cod_flre">
          <formerror  id="cod_flre"><br>
            <span class="errori">@formerror.cod_flre;noquote@</span>
          </formerror>
      </td>
      <td valign="top" align="right" class="form_title">Fluido lato utenze@fluido_lato_utenze_asterisco;noquote@</td>
      <td valign="top"><formwidget id="fluido_lato_utenze">
        <formerror id="fluido_lato_utenze"><br>
	  <span class="errori">@formerror.fluido_lato_utenze;noquote@</span>
	</formerror> 
      </td>
    </tr>
  </if>
</if><!--rom19-->
<!-- gac01 aggiunta if e suo contenuto --><!--rom14 aggiunta condizione x teleriscaldamento-->
<if @flag_tipo_impianto@ ne "C" and  @flag_tipo_impianto@ ne "F" and @flag_tipo_impianto@ ne "T">
  <td valign=top align=right class=form_title>Fluido termovettore <font color=red>@mod_funz_asterisco@</font></td><!-- gab01 -->
  <td valign=top><formwidget id="mod_funz">
      <formerror  id="mod_funz"><br>
        <span class="errori">@formerror.mod_funz;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right class=form_title>Se Altro specificare</td><!--gac03-->
  <td valign=top><formwidget id="altro_funz">
      <formerror  id="altro_funz"><br>
        <span class="errori">@formerror.altro_funz;noquote@</span>
      </formerror>
  </td>
</tr>
</if>
    <else>
      <td colspan=2></td>
    </else>
<!-- fine gac01-->


    <tr>
      <if @coimtgen.regione@ eq "MARCHE">
	<if @flag_tipo_impianto@ ne "F" and @flag_tipo_impianto@ ne "C" and @flag_tipo_impianto@ ne "T"><!--rom13-->
	  <!--rom09.bis    <td valign=top align=right class=form_title>Potenza termica utile nomiale<font color=red>*</font></td>--><!--gac03-->
	  <td valign=top align=right class=form_title>Potenza termica utile nominale<font color=red>@pot_utile_nom_asterisco@</font></td><!--gac03-->
	  <td valign=top><formwidget id="pot_utile_nom">
              <formerror  id="pot_utile_nom"><br>
		<span class="errori">@formerror.pot_utile_nom;noquote@</span>
        </formerror>
	  </td>
	  <td valign=top nowrap align=right class=form_title>Potenza termica al focolare nominale<font color=red>*</font></td><!--gac03-->
	  <td valign=top><formwidget id="pot_focolare_nom">
              <formerror  id="pot_focolare_nom"><br>
		<span class="errori">@formerror.pot_focolare_nom;noquote@</span>
              </formerror>
	  </td>
	</if><!--rom13-->
      </if>
	<if @flag_tipo_impianto@ eq "C"><!--rom14-->
	  <tr>
	    <td valign=top align=right class=form_title>Fluido Termovettore<font color=red>*</font></td>
	    <td valign=top><formwidget id="mod_funz">
		<formerror id="mod_funz"><br>
		  <span class="errori">@formerror.mod_funz;noquote@</span>
		</formerror>
	    </td>
	    <td valign=top align=right class=form_title>Se Altro specificare</td><!--rom22-->
	    <td valign=top><formwidget id="altro_funz">
		<formerror  id="altro_funz"><br>
		  <span class="errori">@formerror.altro_funz;noquote@</span>
		</formerror>
	    </td>
	  </tr>
	  <td valign=top align=right class=form_title>Potenza termica nominale <small>(massimo recupero)</small><font color=red>@pot_utile_nom_asterisco@</font></td>
	  <td valign=top><formwidget id="pot_utile_nom">
	      <formerror  id="pot_utile_nom"><br>
		<span class="errori">@formerror.pot_utile_nom;noquote@</span>
	      </formerror>
	  </td>
    </tr>
<tr>
  <td valign=top align=right class=form_title>Potenza elettrica nominale <small>ai morsetti del generatore</small><font color=red>*</font></td>
  <td valign=top><formwidget id="pot_focolare_nom">
      <formerror  id="pot_focolare_nom"><br>
	<span class="errori">@formerror.pot_focolare_nom;noquote@</span>
      </formerror>
  </td>
</tr>
    </if>
<else>
<if @flag_tipo_impianto@ eq "R" and @coimtgen.regione@ ne "MARCHE">
 <tr><td valign=top  nowrap align=right class=form_title>Potenza a libretto: &nbsp; focolare (kW)</td>
         <td valign=top><formwidget id="pot_focolare_lib">
          <formerror  id="pot_focolare_lib"><br>
          <span class="errori">@formerror.pot_focolare_lib;noquote@</span>
          </formerror>
         </td>
  
         <td valign=top align=right class=form_title>utile (kW)</td>
         <td valign=top><formwidget id="pot_utile_lib">
           <formerror  id="pot_utile_lib"><br>
           <span class="errori">@formerror.pot_utile_lib;noquote@</span>
           </formerror>
         </td>
    </tr>
    <tr>
    <td valign=top nowrap align=right class=form_title>Potenza nominale: &nbsp; focolare (kW)<font color=red>*</font>
    </td>
    <td valign=top><formwidget id="pot_focolare_nom">
        <formerror  id="pot_focolare_nom"><br>
        <span class="errori">@formerror.pot_focolare_nom;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>utile (kW)<font color=red>*</font></td> 
    <td valign=top><formwidget id="pot_utile_nom">
        <formerror  id="pot_utile_nom"><br>
        <span class="errori">@formerror.pot_utile_nom;noquote@</span>
        </formerror>
    </td>
    </tr>
</if>
    </else>
<if @flag_tipo_impianto@ eq "R">
  <if @evidenzia_rend_ter@ eq "t"> <!-- rom03 aggiunta if e suo contenuto , aggiunta else-->
    <td valign=top align=right class=form_title colspan=2>
        <table width="100%" cellspacing=0 cellpadding=0>
                <tr>
                        
                        <td>
                        <table width="100%" style="border-width:2px; border-style:solid;" bordercolor="red" cellspacing="0" cellpadding="2">
                        <tr>
			   <td valign=top align=right class=form_title>Rendimento termico utile a Pn max (%)<font color=red>*</font></td>
                           <td colspan=2 valign=top><formwidget id="rend_ter_max">
                              <formerror  id="rend_ter_max"><br>
                              <span class="errori">@formerror.rend_ter_max;noquote@</span>
                              </formerror>
                           </td>
                        </tr>
                        </table>
                        </td>
                        <td width="30%">&nbsp;</td>
                </tr>
        </table>
    </td>
  </if>
  <else>
    <td valign=top align=right class=form_title>Rendimento termico utile a Pn max (%)<font color=red>*</font></td>
        <td colspan=2 valign=top><formwidget id="rend_ter_max">
            <formerror  id="rend_ter_max"><br>
            <span class="errori">@formerror.rend_ter_max;noquote@</span>
            </formerror>
        </td>
  </else>
 </tr>
</if> 
<if @flag_tipo_impianto@ eq "F">
  <tr>
    <if @coimtgen.regione@ ne "MARCHE"><!--rom13-->
      <td valign=top align=right class=form_title>Fluido termovettore <font color=red>@mod_funz_asterisco@</font></td><!-- gab01 -->
      <td valign=top><formwidget id="mod_funz">
          <formerror  id="mod_funz">
            <span class="errori">@formerror.mod_funz;noquote@</span>
          </formerror>
      </td>
      <td valign=top align=right class=form_title>Se Altro specificare</td><!--rom22-->
      <td valign=top><formwidget id="altro_funz">
	  <formerror  id="altro_funz"><br>
	    <span class="errori">@formerror.altro_funz;noquote@</span>
	  </formerror>
      </td>
    </if><else><!--rom13 else e contenuto-->
      <td valign="top" align="right" class="form_title">Sistema di azionamento@cod_tpco_asterisco;noquote@</td>
      <td valign="top" colspan=4><formwidget id="cod_tpco">
          <formerror  id="cod_tpco"><br>
	    <span class="errori">@formerror.cod_tpco;noquote@</span>
          </formerror>
	  @label_combustibile;noquote@
      </td>
    </else>
  </tr>
  <tr>
      <td valign=top align=right class=form_title>Circuiti n°<font color=red>*</font></td>
      <td valign=top><formwidget id="num_circuiti">
          <formerror  id="num_circuiti"><br>
	    <span class="errori">@formerror.num_circuiti;noquote@</span>
        </formerror>
  </td>
  <td colspan=2></td>
  </tr>
</if>
<if @flag_tipo_impianto@ eq "F">
  <if @coimtgen.regione@ eq "MARCHE"><!--rom13-->
    <tr>
      <td colspan=4>
	<table>
	  <tr>
	    <td valign=top align=left>Raffrescamento:</td>
	    <td valign=top align=right class=form_title>EER (o GUE) @ast_MARCHE;noquote@</td>
	    <td valign=top><formwidget id="per">
		<formerror  id="per"><br>
		  <span class="errori">@formerror.per;noquote@</span>
		</formerror>&nbsp;
	    </td>
	    <td valign=top align=right class=form_title>Potenza frigorifera nominale<font color=red>*</font></td>
	    <td valign=top><formwidget id="pot_focolare_nom">&nbsp;(kW)&nbsp;
		<formerror  id="pot_focolare_nom"><br>
		  <span class="errori">@formerror.pot_focolare_nom;noquote@</span>
		</formerror>
	    </td>
	    <td valign=top align=right class=form_title>Potenza assorbita nominale<font color=red>*</font></td>
	    <td valign=top><formwidget id="pot_utile_nom_freddo">&nbsp;(kW)
		<formerror  id="pot_utile_nom_freddo"><br>
		  <span class="errori">@formerror.pot_utile_nom_freddo;noquote@</span>
		</formerror>
	    </td>
	  </tr>
	  <tr>
	    <td valign=top align=left>Riscaldamento:</td>
	    <td valign=top align=right class=form_title>COP (o &#951;) @ast_MARCHE;noquote@</td>
	    <td valign=top><formwidget id="cop">
		<formerror id="cop"><br>
		  <span class="errori">@formerror.cop;noquote@</span>
		</formerror>
	    </td>
	    <td valign=top align=right class=form_title>Potenza termica nominale<font color=red>*</font></td>
	    <td valign=top><formwidget id="pot_focolare_lib">&nbsp;(kW)&nbsp;
		<formerror id="pot_focolare_lib"><br>
		  <span class="errori">@formerror.pot_focolare_lib;noquote@</span>
		</formerror>
	    </td>
	    <td valign=top align=right class=form_title>Potenza assorbita nominale<font color=red>*</font></td>
	    <td valign=top><formwidget id="pot_utile_lib">&nbsp;(kW)
		<formerror id="pot_utile_lib"><br>
		  <span class="errori">@formerror.pot_utile_lib;noquote@</span>
		</formerror>
	    </td>
	  </tr>
	  <tr><!--rom16 aggiunta tr e contenuto per la nota sotto al campo "pot_focolare_lib"-->
	    <td colspan=3 valign=top>&nbsp;</td>
	    <td valign=top align=left colspan=2 class=form_title><i>Lasciare vuoti i campi relativi alla funzione non presente.</i></td>
  <!--rom18 <td valign=top align=left colspan=2 class=form_title><i>Se non esiste la Potenza termica nominale mettere 0</i></td>-->
	  </tr>
	</table>
      </td>
    </tr>
  </if><else>
    <tr>
      <td valign=top align=right class=form_title>Raffrescamento: EER (o GUE) @ast_freddo;noquote@</td>
      <td valign=top><formwidget id="per">
          <formerror  id="per"><br>
            <span class="errori">@formerror.per;noquote@</span>
          </formerror>
      </td>
      <td valign=top align=right class=form_title>Riscaldamento: COP  @ast_freddo;noquote@</td>
      <td valign=top><formwidget id="cop">
          <formerror  id="cop"><br>
            <span class="errori">@formerror.cop;noquote@</span>
          </formerror>
      </td>
  </else>

  <if @coimtgen.regione@ ne "MARCHE"><!--rom13 le marche visualizzano solo alcuni dei campi ed in un altro punto-->
  <tr>
  <td colspan=6>
     <table>
       <tr>
        <td valign=top nowrap align=left class=form_title>
           <!-- dpr74 Potenza nominale: &nbsp; focolare (kW)-->
         <% if {$flag_tipo_impianto eq "F"} {
               set label_pot_focolare_nom "Potenza frigorifera nominale (kW)"
           } elseif {$flag_tipo_impianto eq "T"} {
               set label_pot_focolare_nom "Potenza nominale: &nbsp; focolare (kW)"
           } elseif {$flag_tipo_impianto eq "C"} {
	      set label_pot_focolare_nom "Potenza nominale: &nbsp; termica (kW)"
	   }
        %><!-- dpr74 -->
        @label_pot_focolare_nom;noquote@<font color=red>*</font><!-- dpr74 -->
        </td>
        <td valign=top><formwidget id="pot_focolare_nom">
        <formerror  id="pot_focolare_nom"><br>
        <span class="errori">@formerror.pot_focolare_nom;noquote@</span>
        </formerror>
        </td>
        <if @flag_tipo_impianto@ eq "F" and @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA"> <!--sim04 if e suo contenuto -->
          <td valign=top align=right class=form_title>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </td>
          <td valign=top align=right class=form_title>utile (kW)<font color=red>*</font></td>
          <td valign=top><formwidget id="pot_utile_nom_freddo">
          <formerror  id="pot_utile_nom_freddo"><br>
          <span class="errori">@formerror.pot_utile_nom_freddo;noquote@</span>
          </formerror>
          </td>
        </if>
        <td valign=top align=right class=form_title>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </td>
   
        <if @flag_tipo_impianto@ eq "T" >
          <td valign=top align=right class=form_title>utile (kW)<font color=red>*</font></td>
        </if>
	<if @flag_tipo_impianto@ eq "C" >
          <td valign=top align=right class=form_title>elettrica (kW)<font color=red>*</font></td>
        </if>
        <if @flag_tipo_impianto@ eq "F" > 
          <td valign=top align=right class=form_title>assorb.(kW)<font color=red>*</font></td>
        </if>
        <td valign=top><formwidget id="pot_utile_nom">
        <formerror  id="pot_utile_nom"><br>
        <span class="errori">@formerror.pot_utile_nom;noquote@</span>
        </formerror>
        </td>
       </tr>
      <!--inizio sim01 -->
      <if @flag_tipo_impianto@ eq "F">
      <tr>
        <td valign=top nowrap align=left class=form_title>
          Potenza riscaldamento:</td> <td valign=top nowrap align=left class=form_title>nominale (kW)@ast_freddo;noquote@
        </td>
        <td valign=top><formwidget id="pot_focolare_lib">
         <formerror  id="pot_focolare_lib"><br>
         <span class="errori">@formerror.pot_focolare_lib;noquote@</span>
         </formerror>
        </td>
        <td valign=top align=right class=form_title>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </td>
        <td valign=top align=right class=form_title>assorb.(kW)@ast_freddo;noquote@</td>
        <td valign=top><formwidget id="pot_utile_lib">
         <formerror  id="pot_utile_lib"><br>
         <span class="errori">@formerror.pot_utile_lib;noquote@</span>
         </formerror>
        </td>
     </tr>
     </if>
<!--fine sim01 -->
   </table>
  </td>
</tr>
</if><!-- chiusura if su freddo e teleriscaldamento-->
</if><!--chiusa if di rom13-->
<if @flag_tipo_impianto@ eq "C">
<!-- gac01 dati cogenerazione -->
<tr><td>&nbsp;</td></tr>
<tr>
  <td colspan=6>
   <table align=center>
   <tr>
     <td align=center><b>Dati di targa:</b></td>
     <td align=center><b>min</b></td>
     <td align=center><b>max</b></td>
     <td align=center></td>
     <td align=center><b>min</b></td>
     <td align=center><b>max</b></td>
   </tr>
   <tr>
     <td valign=top align=right class=form_title>Temperatura acqua in uscita (°C):
     <formerror  id="temp_h2o_uscita"><br>
     <span class="errori">@formerror.temp_h2o_uscita;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_uscita_min">
     <formerror  id="temp_h2o_uscita_min"><br>
     <span class="errori">@formerror.temp_h2o_uscita_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_uscita_max">
     <formerror  id="temp_h2o_uscita_max"><br>
     <span class="errori">@formerror.temp_h2o_uscita_max;noquote@</span>
     </formerror>
     </td>
     <td valign=top nowrap align=right class=form_title>Temperatura fumi a valle dello scambiatore (°C): 
     <formerror  id="temp_fumi_valle"><br>
     <span class="errori">@formerror.temp_fumi_valle;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_fumi_valle_min">
     <formerror  id="temp_fumi_valle_min"><br>
     <span class="errori">@formerror.temp_fumi_valle_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_fumi_valle_max">
     <formerror  id="temp_fumi_valle_max"><br>
     <span class="errori">@formerror.temp_fumi_valle_max;noquote@</span>
     </formerror>
     </td>
  </tr>
   <tr>
     <td valign=top nowrap align=right class=form_title>Temperatura acqua in ingresso (°C):
     <formerror  id="temp_h2o_ingresso"><br>
     <span class="errori">@formerror.temp_h2o_ingresso;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_ingresso_min">
     <formerror  id="temp_h2o_ingresso_min"><br>
     <span class="errori">@formerror.temp_h2o_ingresso_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_ingresso_max">
     <formerror  id="temp_h2o_ingresso_max"><br>
     <span class="errori">@formerror.temp_h2o_ingresso_max;noquote@</span>
     </formerror>
     </td>
     <td valign=top nowrap align=right class=form_title>Temperatura fumi a monte dello scambiatore (°C): 
     <formerror  id="temp_fumi_monte"><br>
     <span class="errori">@formerror.temp_fumi_monte;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_fumi_monte_min">
     <formerror  id="temp_fumi_monte_min"><br>
     <span class="errori">@formerror.temp_fumi_monte_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_fumi_monte_max">
     <formerror  id="temp_fumi_monte_max"><br>
     <span class="errori">@formerror.temp_fumi_monte_max;noquote@</span>
     </formerror>
     </td>
  </tr>
   <tr>
     <td valign=top align=right class=form_title>Temperatura acqua motore <small>(solo m.c.i.)</small> (°C):
     <formerror  id="temp_h2o_motore"><br>
     <span class="errori">@formerror.temp_h2o_motore;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_motore_min">
     <formerror  id="temp_h2o_motore_min"><br>
     <span class="errori">@formerror.temp_h2o_motore_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="temp_h2o_motore_max">
     <formerror  id="temp_h2o_motore_max"><br>
     <span class="errori">@formerror.temp_h2o_motore_max;noquote@</span>
     </formerror>
     </td>
     <td valign=top align=right class=form_title>Emissioni di monossido di carbonio CO:<br>(mg/Nm<small><sup>3</sup></small> riportati al 5% di O<small><sub>2</sub></small> nei fumi )
     <formerror  id="emissioni_monossido_co"><br>
     <span class="errori">@formerror.emissioni_monossido_co;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="emissioni_monossido_co_min">
     <formerror  id="emissioni_monossido_co_min"><br>
     <span class="errori">@formerror.emissioni_monossido_co_min;noquote@</span>
     </formerror>
     </td>
     <td valign=top><formwidget id="emissioni_monossido_co_max">
     <formerror  id="emissioni_monossido_co_max"><br>
     <span class="errori">@formerror.emissioni_monossido_co_max;noquote@</span>
     </formerror>
     </td>
  </tr>
  </table>
</td>
</tr>
<tr><td>&nbsp;</td></tr>
</if>
<!--fine gac01-->
<!-- gac03 spostato scheda 4.1bis prima della scheda 4.2-->
<tr><td colspan=6>&nbsp;</td></tr>
<if @coimtgen.regione@ eq "MARCHE" > <!-- rom02M aggiunte if ed else  -->
  <if @flag_tipo_impianto@ eq "R">
    <tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.1bis: Dati Specifici Gruppi Termici</b></td></tr>
  </if>
  <if @flag_tipo_impianto@ eq "F">
    <tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.4bis: Dati Specifici Gruppo Frigo/Pompa di calore</b></td></tr>
  </if>
  <if @flag_tipo_impianto@ eq "T">
    <tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.5bis: Dati Specifici Scambiatori di calore</b></td></tr><!--rom14-->
  </if>
  <if @flag_tipo_impianto@ eq "C">
    <tr><td colspan=6 class=func-menu-yellow2><b>Scheda 4.6bis: Dati Specifici Cogeneratori / Trigeneratori</b></td></tr><!--rom14-->
  </if>
</if>
<else>
<tr><td colspan=6 class=func-menu-yellow2><b>Dati specifici richiesti:</b></ td></tr>   
</else>
<tr><td colspan=6>&nbsp;</td></tr>
<if @flag_tipo_impianto@ ne "T" and @flag_tipo_impianto@ ne "C"> <!-- gab02 aggiunta if-->
<tr>
  <!--rom09.bis    <td valign=top align=right class=form_title nowrap>Marcatura efficienza energetica @ast_MARCHE;noquote@</td>-->
  <if @flag_tipo_impianto@ ne "F"><!--rom13 aggiunta condizione per il freddo-->
    <td valign=top align=right class=form_title nowrap>Marcatura efficienza energetica <font color=red>@marc_effic_energ_asterisco@</font></td>
    <td valign=top><formwidget id="marc_effic_energ">
        <formerror  id="marc_effic_energ"><br>
          <span class="errori">@formerror.marc_effic_energ;noquote@</span>
        </formerror><br><if @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA"><font color=blue><small>Obbligatoria per impianti installati dal 2015</small></font></if><!--gac04-->
    </td>
  </if>
    <if @coimtgen.regione@ ne "MARCHE"> <!-- rom02M aggiunta if -->
    <td valign=top align=right class=form_title nowrap>Campo di funzionam. <small>(kW)</small>: da</td>
    <td valign=top class=form_title nowrap colspan=3>
        <formwidget id="campo_funzion_min">
      a <formwidget id="campo_funzion_max">
        <formerror  id="campo_funzion_max"><br>
        <span class="errori">@formerror.campo_funzion_max;noquote@</span>
        </formerror>
        <formerror  id="campo_funzion_min"><br>
        <span class="errori">@formerror.campo_funzion_min;noquote@</span>
        </formerror>
    </td>
    </if>
    <if @coimtgen.regione@ eq "MARCHE" > <!-- rom02M aggiunta if -->
    	 <td valign=top align=right class=form_title>Data costruzione <font color=red>@data_costruz_gen_asterisco@</font></td><!--gab01-->
         <td valign=top><formwidget id="data_costruz_gen">
             <formerror  id="data_costruz_gen"><br>
             <span class="errori">@formerror.data_costruz_gen;noquote@</span>
             </formerror><br>@data_costruz_gen_messaggio;noquote@
             </formerror>
         </td>
    </if>
</tr>
</if>
<if @flag_tipo_impianto@ eq "F" or @flag_tipo_impianto@ eq "T"><!--rom14 aggiunta condizione x teleriscaldamento-->
<tr><td valign=top align=right class=form_title>Combustibile<font color=red>@cod_combustibile_asterisco;noquote@</font></td><!-- gab01 -->
    <td valign=top><formwidget id="cod_combustibile">
        <formerror  id="cod_combustibile"><br>
        <span class="errori">@formerror.cod_combustibile;noquote@</span>
        </formerror>
	<if @flag_tipo_impianto@ ne "F"><!--gac05 aggiunta condizione sul freddo che non deve vedere il Vedi nota-->
	    <a href="#" onclick="javascript:window.open('coimgend-ins-help?caller=combustibile', 'help', 'scrollbars=yes, esizable=yes, width=580, height=320').moveTo(110,140)">vedi nota</a>
	</if>
    </td>
    <td colspan=4></td>
</tr>
</if>
<if @flag_tipo_impianto@ eq "T"  and @coimtgen.regione@ eq "MARCHE" or @flag_tipo_impianto@ eq "C" >
<tr>
<td valign=top align=right class=form_title>Data costruzione <font color=red>@data_costruz_gen_asterisco@</font></td><!--gab01-->
         <td valign=top><formwidget id="data_costruz_gen">
             <formerror  id="data_costruz_gen"><br>
             <span class="errori">@formerror.data_costruz_gen;noquote@</span>
             </formerror>
         </td>
</tr>
</if> 
<if @coimtgen.regione@ eq "MARCHE">
  <tr>
    <td valign=top align=right class=form_title>Attivo</td>
    <td valign=top><formwidget id="flag_attivo">
        <formerror  id="flag_attivo"><br>
          <span class="errori">@formerror.flag_attivo;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>@label_motivazione_disattivo;noquote@</td>
    <td valign=top><formwidget id="motivazione_disattivo">
	<formerror  id="motivazione_disattivo"><br>
	  <span class="errori">@formerror.motivazione_disattivo;noquote@</span>
	</formerror>
    </td>
  </tr>
  <if @gen_attivo@ eq "N"><!--rom13 if e contenuto-->
    <tr>
      <td colspan=3>&nbsp;</td>
      <td valign=top><b>@msg_dismesso;noquote@</b></td>
    </tr>
  </if>
</if>
<if @flag_tipo_impianto@ ne "T" and @flag_tipo_impianto@ ne "C" and @flag_tipo_impianto@ ne "F">
  <if @flag_tipo_impianto@ ne "F"><!--rom03 aggiunta if -->
<!--rom09.bis    <td valign=top align=right class=form_title>Scarico fumi <font color=red>*</font></td>-->
    <td valign=top align=right class=form_title>Scarico fumi<font color=red>@cod_emissione_asterisco@</font></td>
    <td valign=top><formwidget id="cod_emissione">
        <formerror  id="cod_emissione"><br>
        <span class="errori">@formerror.cod_emissione;noquote@</span>
        </formerror>
    </td>
    </if><!--rom03-->
    </if>
    <if @flag_tipo_impianto@ ne "T" and @flag_tipo_impianto@ ne "C" >
    <td valign=top align=right nowrap class=form_title>Tipo locale<font color=red>@locale_asterisco;noquote@</font></td><!-- gab01 -->
    <td valign=top><formwidget id="locale">
        <formerror  id="locale"><br>
        <span class="errori">@formerror.locale;noquote@</span>
        </formerror>
    </td>
</if>
<if @flag_tipo_impianto@ eq "F">
<tr>
  <td colspan=6>
    <table>
      <if @coimtgen.regione@ ne "MARCHE"><!--rom13 le marche visualizzano i campi da un'altra parte-->
	<tr>
	  <td valign="top" align="right" class="form_title">Sistema di azionamento@cod_tpco_asterisco;noquote@</td>
	  <td valign="top" colspan="1">
            <formwidget id="cod_tpco">
              <formerror  id="cod_tpco"><br>
		<span class="errori">@formerror.cod_tpco;noquote@</span>
              </formerror>
	  </td>
	  <td valign="top" align="right" class="form_title">Fluido refrigerante</td>
	  <td valign="top">
            <formwidget id="cod_flre">
              <formerror  id="cod_flre"><br>
		<span class="errori">@formerror.cod_flre;noquote@</span>
              </formerror>
	  </td>
      </if>
    </tr>
    <tr>
    <td valign="top" align="right" class="form_title">Carica refrigerante (Kg)</td>
    <td valign="top" colspan="1">
        <formwidget id="carica_refrigerante">
        <formerror  id="carica_refrigerante"><br>
        <span class="errori">@formerror.carica_refrigerante;noquote@</span>
        </formerror>
    </td>
    <td valign="top" colspan="1" align="right" class="form_title">Carica ermeticamente sigillata</td>
    <td valign="top">
        <formwidget id="sigillatura_carica">
        <formerror  id="sigillatura_carica"><br>
        <span class="errori">@formerror.sigillatura_carica;noquote@</span>
        </formerror>
    </td>
    </tr>
    </table>
  </td>
</tr>
</if>
<if @flag_tipo_impianto@ eq "R">
<tr>
    <td valign=top align=right nowrap class=form_title>@label_tipo_foco@<font color=red>@tipo_foco_asterisco@</font></td>
    <td valign=top><formwidget id="tipo_foco">
        <formerror  id="tipo_foco"><br>
        <span class="errori">@formerror.tipo_foco;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>@label_tiraggio@<font color=red>@tiraggio_asterisco@</font></td>
    <td valign=top><formwidget id="tiraggio">
        <formerror  id="tiraggio"><br>
        <span class="errori">@formerror.tiraggio;noquote@</span>
        </formerror>
    </td>
</tr>
</if>
<if @flag_tipo_impianto@ eq "R" > <!-- rom02 aggiunta if rom13 messo visibile solo per il caldo-->
  <tr>
    <td valign=top align=right class=form_title>Classif. DPR 660/96<font color=red>@dpr_660_96_asterisco@</font></td>
    <td valign=top><formwidget id="dpr_660_96">
        <formerror  id="dpr_660_96"><br>
          <span class="errori">@formerror.dpr_660_96;noquote@</span>
        </formerror><br><font color=blue><small>Obbligatoria per combustibile diverso da Solido</small></font> <!--gac04-->
    </td>
    <if @coimtgen.regione@ eq "MARCHE" > <!-- rom02M aggiunta if -->
      <td valign=top align=right nowrap class=form_title colspan=2>Caldaia a condensazioni che utilizza combustibile liquido</td>
      <td valign=top colspan=2><formwidget id="flag_caldaia_comb_liquid">
          <formerror  id="flag_caldaia_comb_liquid"><br>
            <span class="errori">@formerror.flag_caldaia_comb_liquid;noquote@</span>
          </formerror>
      </td>
    </if>
  </tr>
</if><!--rom02-->
<!--gac02 aggiunti campi rif_uni_10389 e altro_rif -->
<tr>
  <td valign=top align=right class=form_title>Riferimento</td>
  <td valign=top><formwidget id="rif_uni_10389">
      <formerror  id="rif_uni_10389"><br>
        <span class="errori">@formerror.rif_uni_10389;noquote@</span>
      </formerror>
      <td valign=top align=right class=form_title>Altro</td>
      <td valign=top colspan=3><formwidget id="altro_rif">
          <formerror  id="altro_rif"><br>
            <span class="errori">@formerror.altro_rif;noquote@</span>
          </formerror>
      </td>
</tr>
<if @coimtgen.regione@ eq "MARCHE"><!--rom10 aggiunta if e contenuto-->
  <tr>
    <td valign=top align=right class=form_title>Installatore</td>
    <td valign=top colspan=3><formwidget id="cognome_inst"><formwidget id="nome_inst">@cerca_inst;noquote@
	  <formerror  id="cognome_inst"><br>
	    <span class="errori">@formerror.cognome_inst;noquote@</span>
	  </formerror>
    </td>
  </tr>
</if><!--rom10-->

  <tr><td colspan=6 class=form_title><b>Generatore destinato a soddisfare i seguenti servizi:</b></td></tr><!--rom09 aggiunta tr-->
  <!--rom12 tolto campo "funzione_grup_ter" -->
  <tr><td colspan=6><formerror  id="flag_prod_acqua_calda">
	<span class="errori">@formerror.flag_prod_acqua_calda;noquote@</span>
      </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Produzione acqua calda sanitaria</td><!--rom12-->
    <td valign=top colspan=5><formwidget id="flag_prod_acqua_calda">
	@pot_utile_acq;noquote@
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Climatizzazione invernale</td><!--rom12-->
    <td valign=top colspan=5><formwidget id="flag_clima_invernale">
	<formerror  id="flag_clima_invernale"><br>
	  <span class="errori">@formerror.flag_clima_invernale;noquote@</span>
	</formerror>
	@pot_utile_inv;noquote@
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Climatizzazione estiva</td><!--rom12-->
    <td valign=top colspan=5><formwidget id="flag_clim_est">
	<formerror  id="flag_clim_est"><br>
	  <span class="errori">@formerror.flag_clim_est;noquote@</span>
	</formerror>
	@pot_utile_est;noquote@
    </td>
  </tr>
<!--rom15
    <tr>
      <td valign=top align=right class=form_title>Altro</td>
      <td valign=top class=form_title><formwidget id="flag_altro">
	  <formerror  id="flag_altro"><br>
	    <span class="errori">@formerror.flag_altro;noquote@</span>
	  </formerror><table align=right><tr><td>Note Altro</td></tr></table>
      </td>
      <td valign=top class=form_title colspan=4><formwidget id="funzione_grup_ter_note_altro">
	  <formerror  id="funzione_grup_ter_note_altro">
	    <span class="errori">@formerror.funzione_grup_ter_note_altro;noquote@</span>
	  </formerror>
      </td>
    </tr>
    rom15-->
</if>
<tr><td valign=top align=right class=form_title>Note</td>
  <td valign=top colspan=5><formwidget id="note">
      <formerror  id="note"><br>
        <span class="errori">@formerror.note;noquote@</span>
      </formerror>
  </td>
</tr>
<!--gac03 spostato scheda 4.1bis prima della scheda 4.2 -->
<if @flag_tipo_impianto@ eq "R" and @funzione@ ne "S">
<tr><td colspan=6>&nbsp;</td></tr>
<tr>
<!--rom09 Rimpaginata tutta la sezione 4.2 e cambiate le label su richiesta della Regione Marche.
          Per ogni label che cambio riporto di fianco al td la vecchia dicitura commentata.-->
<td valign=top colspan=6 class=func-menu-yellow2><b>Scheda 4.2: Dati bruciatore</b></td>
</tr>
<tr><td colspan=6 align=center>&nbsp;</td></tr>
<center>
<tr>
    <td>&nbsp;</td>
    <!--ric01 td colspan=5 align=left>@link_aggiungi_1;noquote@</td -->
    <td colspan=3 align=center>@link_aggiungi_1;noquote@</td>
</tr>
<tr><td colspan=6 align=center>&nbsp;</td></tr> <!--ric01 aggiunta riga-->
<tr>
  <td>&nbsp;</td>
  <!--ric01 td colspan=5 align=left>@@table_result_1;noquote@</td -->
  <td colspan=3 align=center>@table_result_1;noquote@</td>
</tr>
</center>
</if>  
<if 1 eq 0 > <!--rom21 aggiunta if ma non il suo contenuto-->
<tr>
<if @coimtgen.regione@ ne "MARCHE"><!--rom09.bis-->
<td valign=top align=right class=form_title>Data costruzione bruciatore</td>
    <td valign=top><formwidget id="data_costruz_bruc">
        <formerror  id="data_costruz_bruc"><br>
        <span class="errori">@formerror.data_costruz_bruc;noquote@</span>
        </formerror>
    </td>
</if>
    <td valign=top align=right class=form_title>Data di installazione</td><!--rom09 Data installazione bruciatore-->
    <td valign=top><formwidget id="data_installaz_bruc">
        <formerror  id="data_installaz_bruc"><br>
        <span class="errori">@formerror.data_installaz_bruc;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Data di dismissione</td><!--rom09 Data rottamazione bruciatore-->
    <td valign=top><formwidget id="data_rottamaz_bruc">
        <formerror  id="data_rottamaz_bruc"><br>
        <span class="errori">@formerror.data_rottamaz_bruc;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Fabbricante</td><!--rom09 Costruttore bruciatore-->
  <td valign=top><formwidget id="cod_cost_bruc">
      <formerror  id="cod_cost_bruc"><br>
        <span class="errori">@formerror.cod_cost_bruc;noquote@</span>
        </formerror>
    </td>

    <td valign=top align=right class=form_title>Modello</td><!--rom09 Modello bruciatore -->
    <if @coimtgen.flag_gest_coimmode@ eq "F"><!-- nic01 -->
        <td valign=top><formwidget id="modello_bruc">
    	    <formerror  id="modello_bruc"><br>
            <span class="errori">@formerror.modello_bruc;noquote@</span>
	    </formerror>
	</td>
        <formwidget id="cod_mode_bruc"><!-- nic01 -->
    </if>
    <else><!-- nic01 -->
        <td valign=top><formwidget id="cod_mode_bruc"><!-- nic01 -->
    	    <formerror  id="cod_mode_bruc"><br><!-- nic01 -->
            <span class="errori">@formerror.cod_mode_bruc;noquote@</span><!-- nic01 -->
	    </formerror><!-- nic01 -->
	</td><!-- nic01 -->
        <formwidget id="modello_bruc"><!-- nic01 -->
    </else>
    <td valign=top align=right class=form_title>Matricola</td><!--rom09 Matricola bruciatore-->
    <td valign=top><formwidget id="matricola_bruc">
        <formerror  id="matricola_bruc"><br>
        <span class="errori">@formerror.matricola_bruc;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td valign=top align=right nowrap class=form_title>Tipologia</td><!--rom09 Bruciatore-->
    <td valign=top><formwidget id="tipo_bruciatore">
        <formerror  id="tipo_bruciatore"><br>
          <span class="errori">@formerror.tipo_bruciatore;noquote@</span>
        </formerror>
    </td>
    <if @coimtgen.regione@ eq "MARCHE"> <!-- rom02M aggiunta if -->
      <!--rom09    <td valign=top align=right class=form_title nowrap>Campo di funzionam. <small>(kW)</small>: da</td> -->
      <!--rom09    <td valign=top class=form_title nowrap colspan=3>                                                   -->
      <!--rom09        <formwidget id="campo_funzion_min">                                                             -->
      <!--rom09      a <formwidget id="campo_funzion_max">                                                             -->
      <!--rom09        <formerror  id="campo_funzion_max"><br>                                                         -->
      <!--rom09        <span class="errori">@formerror.campo_funzion_max;noquote@</span>                               -->
      <!--rom09        </formerror>                                                                                    -->
      <!--rom09        <formerror  id="campo_funzion_min"><br>                                                         -->
      <!--rom09        <span class="errori">@formerror.campo_funzion_min;noquote@</span>                               -->
      <!--rom09        </formerror>                                                                                    -->
      <!--rom09    </td>                                                                                               -->
      <td valign=top align=right class=form_title nowrap>Portata termica max nominale</td><!--rom09-->
      <td valign=top><formwidget id="campo_funzion_max">(kW)
	  <formerror  id="campo_funzion_max"><br>
	    <span class="errori">@formerror.campo_funzion_max;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right class=form_title nowrap>Portata termica min nominale</td><!--rom09-->
      <td valign=top><formwidget id="campo_funzion_min">(kW)
	  <formerror  id="campo_funzion_min"><br>
	    <span class="errori">@formerror.campo_funzion_min;noquote@</span>
	  </formerror>
      </td>
    </if>
</tr>
<tr>
  <td colspan=6>
    <table>
<!-- rom02M Tolta su indicazione di Sandro 
     <tr><td valign=top  nowrap align=left class=form_title>Potenza a libretto: &nbsp; focolare (kW)</td>
         <td valign=top><formwidget id="pot_focolare_lib">
          <formerror  id="pot_focolare_lib"><br>
          <span class="errori">@formerror.pot_focolare_lib;noquote@</span>
          </formerror>
         </td>
         <td valign=top align=right class=form_title>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</td>
         <td valign=top align=right class=form_title>utile (kW)</td>
         <td valign=top><formwidget id="pot_utile_lib">
           <formerror  id="pot_utile_lib"><br>
           <span class="errori">@formerror.pot_utile_lib;noquote@</span>
           </formerror>
         </td>
    </tr>     -->

    </table>
  </td>
</tr>
</if> <!--fine if su dati bruciatore del caldo-->
</if><!--rom21-->

<if @funzione@ ne "V">
    <tr><td colspan=7 align=center><formwidget id="submit"></td></tr>
</if>
<tr>	
   <td colspan=7  align=right class=form_title><font color=red><small>I campi con il segno * sono obbligatori</small></font></td><!-- rom01 --> 	
</tr>
</table>
</formtemplate>
<p>
</center>

