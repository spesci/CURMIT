<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom16 29/08/2022 Su richiesta di Pavaran di Ucit la label per il campo targa varia per
    rom16            Friulia rispetto allo standard, usata la nuova variabile label_targa.

    mic01 08/07/2022 Aggiunto link per bonifica targa

    rom15 04/05/2022 Su richiesta di Giuliodori fatta per mail "nuova nota campo ibrido e testo label" il 29/04
    rom15            modificata la label dal campo flag_ibrido per le Marche.

    rom14 22/03/2022 MEV Regione Marche per sistemi ibridi.

    rom13 21/12/2020 Aggiunto inserisci_targa visibile solo per le Marche per gli utenti che
    rom13            non sono manutentori.    	 

    rom12 24/11/2020 Aggiunto asterisco al campo tipologia_generatore per segnalazione
    rom12            di Giuliodori di Regione Marche.

    gac06 26/11/2019 Aggiunto msg_cod_combustibile

    gac05 25/11/2019 Aggiunto cerca targa

    rom11 07/03/2019 Aggiunta didictura a fianco del link stampa targa su richiesta degli Ispettori
    rom11            e delle Autorita' competenti di Regione MArche

    rom10 07/01/2019 Per gli impainti del freddo non faccio più vedere il campo altra_tipologia_generatore
    rom10            Per gli impianti del teleriscaldamento delle marche non faccio piu' vedere il campo
    rom10            potenza_utile

    gac04 17/12/2018 Apportato modifiche alla grafica, spostato campi.

    rom09 18/10/2018 Su richiesta delle Marche portati tutti i campi della scheda 1.2 
    rom09            Per ora li metto solo in visualizzazione e li faccio vedere solo alle Marche.
    rom09            Sandro ha detto che devono visualizzare i campi dalla riga del "Comune"
    rom09            alla riga dell'"Indirizzo", commento quelli successivi.

    rom08 15/10/2018 Alla Regione Marche non faccio vedere il campo "Imp. provenienza".
    rom08            Rinominato il campo "Data di installazione/sostituzione del generatore" 
    rom08            in "Data di installazione dell'Impianto".
    rom08            Aggiunto asterisco rosso al campo data_libretto e pop-up di fianco al
    rom08            campo tipologia_intervento

    rom07 04/10/2018 Aggiunto campo flag_ibrido, per il momento lo faccio vedere solo 
    rom07            alle Marche e solo per gi impianti del caldo.
    rom07.bis        Aggiunto pop-up per sistemi inìbridi su richiesta delle Marche.
    
    rom06 06/08/2018 La Regione Marche non vede più qui i campi pres_certificazione e certificazione.
    rom06            Per loro i campi vengono messi nella scheda 1.bis

    rom05 07/08/2018 Modificate label su richiesta della regione Marche

    rom04 11/07/2018 Aggiunto bottone in alto "Passa a Scheda 1Bis: Dati Generali" solo per
    rom04            la Regione Marche.

    gac03 29/06/2018 Modificate label

    gac02 28/06/2018 Aggiunto campi integrazione, superficie_integrazione, nota_altra_integrazione
    gac02            e pot_utile_integrazione 

    rom03 18/06/2018 Aggiunto titolo "Dati scadenza dell'impianto/Informazioni dell'impianto".
    rom03            Aggiunto nuovo campo tipologia_intervento.
    rom03            Rimpaginata la schermata per renderla simile alla stampa del Libretto.

    gac01 07/06/2018  Aggiunto campi tipologia_generatore e integrazione_per

    rom02 24/05/2018 Solo per le Marche messo il campo cod_cted 'Cat. edificio' obbligatorio.
    rom02            Cambiata la dicitura 'Targa' in 'Codice Catasto/Targa'.

    rom01 08/05/2018 Aggiunto il campo data_libretto e reso invisibile il campo flag_dpr412
    rom01            solo per la Regione Marche. 
    rom01            Su richiesta di Sandro tolto link_ricodifica; tolto anche il campo 
    rom01            cod_tpim su richiesta della Regione Marche.

    sim13 05/02/2018 Tolto i link  Trattamento acqua,Regolazione e contabilizzazione
    sim13            ,Sistemi di Distribuz. e Sistema di Emiss. che sono stati spostati nel menù altre schede.
    sim13            Altre schede è stato messo a livello del menù dell'impianto

    sim06 06/09/2016 Se il parmetro flag_gest_targa e' attivo,
    sim06            visualizzo il campo targa e non il cod impianto princ.

    gab03 17/08/2016 Aggiunto riquadro "Sistema di Emissione"

    gab02 11/07/2016 Aggiunto riquadro "Sistemi di Distribuzione"

    gab01 04/07/2016 Aggiunto riquadro "Altre schede"

    sim02 09/05/2016 Modificato la label della Pot. frig. utile e Pot. frig. nom. per i dati
    sim02            generali del freddo.

    sim01 10/09/2014 Aggiunto nuovo campo cod_impianto_princ
-->

<script type="text/javascript" src="../javascript/conferma_copia_impianto.js"></script>
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
<property name="focus_field">@focus_field;noquote@</property><!--rom14-->

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="extra_par">
<formwidget   id="last_cod_impianto">
<formwidget   id="url_aimp">
<formwidget   id="url_list_aimp">
<formwidget   id="dummy"><!-- sim01 -->
<formwidget   id="scaduto">
<formwidget   id="desc_conf">
<formwidget   id="conferma_inco">
<if @funzione@ ne M>
    <formwidget   id="cod_potenza">
</if>
 
<if @flag_assegnazione@ ne t>
@link_tab;noquote@
</if>
@dett_tab;noquote@
<table width="100%" cellspacing=0  class=func-menu>
<tr>
   <if @flag_assegnazione@ ne t>
       <if @funzione@ eq "I">
          <td width="100%" nowrap class=func-menu>&nbsp;</td>
       </if>
       <else>
<!--rom01       <td width="12.5%" nowrap class=@classe;noquote@> 
             <!-- <a href="coimaimp-gest?funzione=C&@link_gest;noquote@" class=@classe;noquote@>Copia Impianto</a> -->
<!--rom01       <a href="coimaimp-tratt-acqua-gest?@link_coim_tratt_acqua;noquote@" class=func-menu>Trattamento acqua</a><!-- sim02 --> 
<!--rom01	  </td> -->
<!--rom01       <td width="25.0%" nowrap class=@classe;noquote@>
	     <a href="coimaimp-regol-contab-gest?@link_coim_tratt_acqua;noquote@" class=func-menu>Regolazione e contabilizzazione</a>
<!--rom01	  </td> -->
<!--rom01       <td width="12.5%" nowrap class=@classe;noquote@>
             <a href="coimaimp-sist-distribuz-gest?@link_gest;noquote@" class=func-menu>Sistemi di Distribuz.</a><!-- gab02 -->
<!--rom01          </td> -->
<!--rom01       <td width="12.5%" nowrap class=@classe;noquote@>
             <a href="coimaimp-sist-emissione-gest?@link_gest;noquote@" class=func-menu>Sistema di Emiss.</a><!-- gab03 -->
<!--rom01          </td> -->
<!--sim13          <td width="12.5%" nowrap class=@classe;noquote@>
             <a href="coimaimp-altre-schede-list?@link_gest;noquote@" class=func-menu>Altre schede</a><!-- gab01 -->
<!--sim13          </td> -->
          <td width="8.33%" nowrap class=@func_v;noquote@>
             <a href="coimaimp-gest?funzione=V&@link_gest;noquote@" class=@func_v;noquote@>Visualizza</a>
          </td>
          <td width="8.34%" nowrap class=@func_m;noquote@>
             <a href="coimaimp-gest?funzione=M&@link_gest;noquote@" class=@func_m;noquote@>Modifica</a>
          </td>
          <td width="8.33%" nowrap class=@func_d;noquote@>
             <a href="coimaimp-gest?funzione=D&@link_gest;noquote@" class=@func_d;noquote@>Cancella</a>
          </td>
        <if @coimtgen.regione@ eq "MARCHE"> <!--rom04 aggiunta if e contenuto -->
	  <td width="7.34%" nowrap class=@func_d;noquote@>
             <a href="coimaimp-bis-gest?funzione=V&@link_gest;noquote@" class=@func_d;noquote@>Passa a Scheda 1Bis: Dati Generali</a>
          </td>
        </if><!--rom04-->
       </else>
    </tr>
</if>
<else>
          <td width="25%" nowrap class=func-menu>
              <a href="coimmai2-filter?&@link_mai2;noquote@" class=func-menu>Ritorna</a>
          </td>
          <td width="25%" nowrap class=func-menu>
             <a href="coimaimp-tecn?funzione=A&@link_gest;noquote@" class=func-menu>Conferma Acquisizione</a>
          </td>
          <td width="50%" class=func-menu>&nbsp;</td>
</else>
</tr>
</table><table border=0 width="100%">
  <tr><td colspan=6 class=func-menu-yellow2><b>1.1 Tipologia intervento</b></td></tr><!-- rom03 -->
  <tr><td colspan=6>&nbsp;</td></tr>
  <tr><!--gac03 scambiato di posto data con tipologia--><!--rom05 rimesso vecchio ordine su richiesta della regione marche -->
    <td valign=top align=right class=form_title colspan=1>In data<font color=red>*</font></td><!--rom08 agg. *-->
    <td valign=top nowrap > <formwidget id="data_libretto">
        <formerror  id="data_libretto"><br>
          <span class="errori">@formerror.data_libretto;noquote@</span>
        </formerror>
    </td> 
    <td valign=top align=right class=form_title>Tipologia intervento</td><!-- rom03 -->
    <td valign=top  colspan=3><formwidget id="tipologia_intervento">
	<formerror  id="tipologia_intervento"><br>
          <span class="errori">@formerror.tipologia_intervento;noquote@</span>
	</formerror>
 	<if @coimtgen.regione@ eq "MARCHE">
	<a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=tipo_int', 'help', 'scrollbars=yes, esizable=yes, width=580, height=320').moveTo(110,140)"><b>per la Tipologia intervento, vedi nota</b></a> <!--rom08 aggiunto pop-up su richiesta delle Marche-->
	</if>
    </td>
</tr>
<if @coimtgen.regione@ eq "MARCHE"><!--rom09 aggiunta if e contenuto-->
  <tr><td colspan=6>&nbsp;</td></tr>
<tr><td colspan=6 class=func-menu-yellow2><b>1.2 Ubicazione e destinazione dell'edificio</b><br>
  Informazioni prelevate automaticamente dalla scheda 1.2 </td></tr><!-- rom03 -->
  <tr><td colspan=6>&nbsp;</td></tr>
  <tr>
    <td valign=top align=right class=form_title>Comune</td>
    <if @flag_ente@ eq P>
      <td valign=top colspan=5><formwidget id="cod_comune_display">
	  <formerror  id="cod_comune_display"><br>
	    <span class="errori">@formerror.cod_comune_display;noquote@</span>
          </formerror>
      </td>
    </if>
    <else>
      <td valign=top colspan=5><formwidget id="descr_comune"></td>
    </else>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Localit&agrave;</td>
    <td colspan=1 valign=top><formwidget id="localita">
        <formerror  id="localita"><br>
	  <span class="errori">@formerror.localita;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>CAP</td>
    <td colspan=3 valign=top><formwidget id="cap">
        <formerror  id="cap"><br>
	  <span class="errori">@formerror.cap;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Unit&agrave; urbana</td>
    <td colspan=1 valign=top><formwidget id="cod_urb">
        <formerror  id="cod_urb"><br>
	  <span class="errori">@formerror.cod_urb;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Quartiere</td>
    <td colspan=3 valign=top><formwidget id="cod_qua">
        <formerror  id="cod_qua"><br>
	  <span class="errori">@formerror.cod_qua;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=left colspan=6>
      <table width="65%" border=0>
	<tr>
	  <td valign=top align=right width="20%"class=form_title>Indirizzo</td>
	  <td valign=top nowrap colspan=2><formwidget id="descr_topo">
	      <formwidget id="descr_via">
		<formerror  id="descr_via"><br>
		  <span class="errori">@formerror.descr_via;noquote@</span>
		</formerror>
		<formerror  id="descr_topo"><br>
		  <span class="errori">@formerror.descr_topo;noquote@</span>
		</formerror>
	  </td>
	  <td valign=top align=right class=form_title>N&deg; Civ.</td>
	  <td valign=top><formwidget id="numero">/<formwidget id="esponente">
		<formerror  id="numero"><br>
		  <span class="errori">@formerror.numero;noquote@</span>
		</formerror>
	  </td>
	  <td valign=top align=right class=form_title>Scala</td>
	  <td valign=top><formwidget id="scala">
	      <formerror  id="scala"><br>
		<span class="errori">@formerror.scala;noquote@</span>
	      </formerror>
	  </td>
	  <td valign=top align=right class=form_title>Piano</td>
	  <td valign=top><formwidget id="piano">
	      <formerror  id="piano"><br>
		<span class="errori">@formerror.piano;noquote@</span>
	      </formerror>
	  </td>
	  <td valign=top align=right class=form_title>Int.</td>
	  <td valign=top><formwidget id="interno">
	      <formerror  id="interno"><br>
		<span class="errori">@formerror.interno;noquote@</span>
	      </formerror>
	  </td>
	</tr>
      </table>
    </td>
<!--rom09 Sandro ha detto che devono visualizzare i campi solo fino a questa riga
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Destinaz d'uso:</td>
    <td valign=bottom colspan=5><formwidget id="cod_tpdu">
        <formerror  id="cod_tpdu"><br>
	  <span class="errori">@formerror.cod_tpdu;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Ultima variazione</td>
    <td valign=top colspan=5><formwidget id="data_variaz">
        <formerror  id="data_variaz"><br>
	  <span class="errori">@formerror.data_variaz;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title><b>Dati non Obbligatori:</b></td>
    <td colspan=5>&nbsp;</td>
  </tr>
  <tr>
    <if @funzione@ ne V>
      <if @funzione@ ne I>
        <td valign=top align=right class=form_title>Data validit&agrave;</td>
        <td valign=top colspan=5><formwidget id="data_ini_valid">
	    <formerror  id="data_ini_valid"><br>
              <span class="errori">@formerror.data_ini_valid;noquote@</span>
	    </formerror>
        </td>
      </if>
    </if>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Coordinate geografiche GB X</td>
    <td valign=top  colspan=5><formwidget id="gb_x">
        <formerror  id="gb_x"><br>
	  <span class="errori">@formerror.gb_x;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Coordinate geografiche GB Y</td>
    <td valign=top  colspan=5><formwidget id="gb_y">
        <formerror  id="gb_y"><br>
	  <span class="errori">@formerror.gb_y;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Tipo Catasto</td>
    <td valign=top  colspan=5><formwidget id="cat_catastale">
        <formerror  id="cat_catastale"><br>
	  <span class="errori">@formerror.cat_catastale;noquote@</span>
        </formerror>
    </td>
  </tr>
  <tr>
    <td valign=top align=right class=form_title>Sezione</td>
    <td valign=top  colspan=5><formwidget id="sezione">
	<formerror  id="sezione"><br>
	  <span class="errori">@formerror.sezione;noquote@</span>
	</formerror>
    </td>
  </tr>
  <tr>
  <tr>
    <td valign=top   align=right class=form_title>Foglio</td>
    <td valign=top  colspan=1><formwidget id="foglio">
	<formerror  id="foglio"><br>
	  <span class="errori">@formerror.foglio;noquote@</span>
	</formerror>
    </td>
    <td valign=top align=right class=form_title>Mappale</td>
    <td valign=top  ><formwidget id="mappale">
	<formerror  id="mappale"><br>
	  <span class="errori">@formerror.mappale;noquote@</span>
	</formerror>
    </td>
    <td valign=top align=right class=form_title>Subalterno</td>
    <td valign=top><formwidget id="subalterno">
	<formerror  id="subalterno"><br>
	  <span class="errori">@formerror.subalterno;noquote@</span>
	</formerror>
    </td>
  </tr>
  </tr>
  rom09-->
  </tr>
  <tr>
    <td valign=top align=right nowrap class=form_title>Cat. edificio</td>
    <td valign=top  colspan=5><formwidget id="cod_cted">
        <formerror  id="cod_cted"><br>
        <span class="errori">@formerror.cod_cted;noquote@</span>
        </formerror>
    </td>
</tr>

  <tr><td colspan=6>&nbsp;</td></tr>
  <tr><td colspan=6 class=func-menu-yellow2><b>1.3 Impianto destinato a soddisfare i seguenti servizi<br>1.4 Tipologia Fluido Vettore</b><br>Informazioni prelevate automaticamente dalle schede 4.1 e 4.1bis per i Generatori di calore a fiamma, dalle schede 4.4 e 4.4bis per i GF/Pompe di calore, e dalle schede 4.n e 4.nbis per i generatori di altro tipo.</td></tr>
  <tr><td valign=top align=center nowrap class=form_title colspan=6>&nbsp;</td></tr><!--gac03 aggiunta riga vuota-->
</if><!--rom09-->
    
  <tr><td colspan=6>&nbsp;</td></tr>
  <tr><td colspan=6 class=func-menu-yellow2><b>1.5 Individuazione della Tipologia dei Generatori</b></td></tr><!-- rom03 -->
  <tr><td colspan=6>&nbsp;</td></tr>
  <!-- gac01 aggiunti nuovi campi 07/06/2018 -->
  <!-- rom12 Aggiunto * sulla label del campo tipologia_generatore -->
<tr>
    <td valign=top align=right class=form_title>Tipologia generatore<font color=red>*</font></td>
    <td valign=top><formwidget id="tipologia_generatore">
        <formerror  id="tipologia_generatore"><br>
        <span class="errori">@formerror.tipologia_generatore;noquote@</span>
        </formerror>
    </td>
    <if @flag_tipo_impianto@ ne "F"><!--rom10 Per gli impianti del freddo non faccio più vedere il campo-->
    <td valign=top align=right class=form_title>se Altro: specificare il tipo</td><!--rom05 modificata label -->
    <td colspan=2 valign=top ><formwidget id="altra_tipologia_generatore">
        <formerror  id="altra_tipologia_generatore"><br>
	<span class="errori">@formerror.altra_tipologia_generatore;noquote@</span>
        </formerror>
    </td>
    </if>
</tr>
<if @coimtgen.regione@ eq "MARCHE"><!--rom07 inserita if e contenuto-->
  <tr>
    <if @flag_tipo_impianto@ eq "R" or @flag_tipo_impianto@ eq "F">
      <!--rom15 <td valign=top align=right nowrap class=form_title>@label_ibrido@ <font color="red">*</font></td>-->
      <td valign=top align=right nowrap class=form_title>@label_ibrido;noquote@</td><!--rom15-->
      <td valign=top colspan=1><formwidget id="flag_ibrido">
          <formerror  id="flag_ibrido"><br>
            <span class="errori">@formerror.flag_ibrido;noquote@</span>
          </formerror> <a href="#" onclick="javascript:window.open('coimaimp-gest-help?caller=ibrido', 'help', 'scrollbars=yes, esizable=yes, width=650, height=320').moveTo(110,140)"><b> vedi nota</b></a><!--rom07.bis aggiunto pop-up su richiesta delle Marche-->
      </td>
      <if @label_cod_impianto_ibrido@ ne "">
	<td valign=baseline align=right nowrap class=form_title>@label_cod_impianto_ibrido;noquote@</td>
	<td valign=baseline><formwidget id="cod_impianto_ibrido">
	    <formerror  id="cod_impianto_ibrido"><br>
	      <span class="errori">@formerror.cod_impianto_ibrido;noquote@</span>
	    </formerror>
	</td>
      </if>
      <if @label_cod_impianto_princ_ibrido@ ne "">  
	<td valign=top align=right nowrap class=form_title>@label_cod_impianto_princ_ibrido;noquote@</td>
	<td valign=top><formwidget id="cod_impianto_princ_ibrido">
	    <formerror  id="cod_impianto_princ_ibrido"><br>
	      <span class="errori">@formerror.cod_impianto_princ_ibrido;noquote@</span>
	    </formerror>
	</td>
	</if>
    </if>
  </tr>
  <if @cod_impianto_princ_ibrido@ ne ""><!--rom14 Aggiunta if e il suo contenuto -->
    <tr>
      <td valign=top align=center class=form_title colspan=2><b>Indicare quali dei seguenti sistemi sono eventualmente unici per gli impianti collegati:</b></td>
      <td colspan=2>&nbsp;</td>
    </tr>
    <tr>
      <td valign=top align=right nowrap class=form_title>Regolazione primaria (scheda 5.1)</td>
      <td valign=top><formwidget id="is_regolazione_primaria_unica">
	  <formerror  id="is_regolazione_primaria_unica"><br>
	    <span class="errori">@formerror.is_regolazione_primaria_unica;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right nowrap class=form_title>Sistemi di accumulo (scheda 8)</td>
      <td valign=top><formwidget id="is_coimaccu_aimp_unici">
	  <formerror  id="is_coimaccu_aimp_unici"><br>
	    <span class="errori">@formerror.is_coimaccu_aimp_unici;noquote@</span>
	  </formerror>
      </td>
    </tr>
    <tr>
      <td valign=top align=right nowrap class=form_title>Scambiatori di calore intermedi (scheda 9.3)</td>
      <td valign=top><formwidget id="is_coimscam_calo_aimp_unici">
	  <formerror  id="is_coimscam_calo_aimp_unici"><br>
	    <span class="errori">@formerror.is_coimscam_calo_aimp_unici;noquote@</span>
	  </formerror>
      </td>
      <td valign=top align=right nowrap class=form_title>Recuperatori di calore (scheda 9.6)</td>
      <td valign=top><formwidget id="is_coimrecu_calo_aimp_unici">
	  <formerror  id="is_coimrecu_calo_aimp_unici"><br>
	    <span class="errori">@formerror.is_coimrecu_calo_aimp_unici;noquote@</span>
	  </formerror>
      </td>
    </tr>
  </if>
</if>

<tr>
  <td colspan="6" align="center">
    <table border="0" width="90%">
      <tr>
	<td align="center"><hr size="1" color="silver" noshade>
	</td>
      </tr>
    </table>
  </td>
</tr>
<!-- gac02 aggiunto campi integrazione -->
<tr>
  <td valign=top align=right class=form_title>Eventuale integrazione con</td>
  <td valign=top><formwidget id="integrazione">
      <formerror  id="integrazione"><br>
        <span class="errori">@formerror.integrazione;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right class=form_title>(m2)</td>
  <td valign=top><formwidget id="superficie_integrazione">
      <formerror  id="superficie_integrazione"><br>
        <span class="errori">@formerror.superficie_integrazione;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right class=form_title>Altro</td>
  <td valign=top><formwidget id="nota_altra_integrazione">
      <formerror  id="nota_altra_integrazione"><br>
        <span class="errori">@formerror.nota_altra_integrazione;noquote@</span>
      </formerror>
  </td>
  <td valign=top align=right nowrap class=form_title>Potenza utile (kW)</td>
  <td valign=top><formwidget id="pot_utile_integrazione">
      <formerror  id="pot_utile_integrazione"><br>
        <span class="errori">@formerror.pot_utile_integrazione;noquote@</span>
      </formerror>
  </td>
</tr>
<tr>
  <td valign=top align=right nowrap class=form_title>Per</td>
  <td valign=top colspan=5><formwidget id="integrazione_per">
      <formerror  id="integrazione_per"><br>
        <span class="errori">@formerror.integrazione_per;noquote@</span>
      </formerror>
  </td>
</tr>
<!--rom05<tr><td colspan=6 class=func-menu-yellow2><b>Dati Tecnici Impianto</b></td></tr><!-- rom03 --> 
  <tr><td colspan=6>&nbsp;</td></tr>
  <tr><td colspan=6 class=func-menu-yellow2><b>Stampa targa / Dati riepilogativi dell'impianto</b></td></tr><!-- rom05 -->
  <tr><td colspan=6>&nbsp;</td></tr>

<tr>
  <td valign=top width="1%" align=right class=form_title>Cod. impianto</td>
  <td valign=top width="1%"><formwidget id="cod_impianto_est"> <!-- rom01   @link_ricodifica;noquote@ -->
      <formerror  id="cod_impianto_est"><br>
        <span class="errori">@formerror.cod_impianto_est;noquote@</span>
      </formerror>
  </td>
    <td valign=top width="1%" align=right nowrap class=form_title>N&deg; generatori</td>
    <td valign=top width="1%"><formwidget id="n_generatori">
        <formerror  id="n_generatori"><br>       
        <span class="errori">@formerror.n_generatori;noquote@</span>
        </formerror>
    </td>
</tr>
  <if @coimtgen.regione;noquote@ ne "MARCHE"><!--rom08 aggiunta if -->
   <tr>
    <td valign=top width="1%" align=right class=form_title>@imp_provenienza;noquote@</td>
    <td valign=top width="1%"><formwidget id="cod_impianto_est_prov">
	<formerror  id="cod_impianto_est_prov"><br>
          <span class="errori">@formerror.cod_impianto_est_prov;noquote@</span>
        </formerror>
    </td>
   </tr>
  </if>

<tr><!-- sim01 -->
<!-- sim06 aggiunto if, else e contenuto dell'else -->
<if @flag_gest_targa@ eq "F">
    <td valign=top width="1%" align=right class=form_title>Cod. impianto principale</td><!-- sim01 -->
    <td valign=top width="1%" colspan="5"><formwidget id="cod_impianto_princ"><if @funzione@ eq I or @funzione@ eq M>@cerca_cod_impianto_princ;noquote@</if><!-- sim01 -->
        <formerror  id="cod_impianto_princ"><br><!-- sim01 -->
        <span class="errori">@formerror.cod_impianto_princ;noquote@</span><!-- sim01 -->
        </formerror><!-- sim01 -->
    </td><!-- sim01 -->
</if>
<else>
  <td valign=top width="1%" align=right class=form_title>@label_targa@ </td><!-- sim06 --><!--rom16 usata variabile label_targa -->
  <td valign=top width="1%" colspan="5"><formwidget id="targa"> @inserisci_targa;noquote@ @cerca_targa;noquote@ @bon_targa;noquote@ @link_stampa_targa;noquote@ <br> Attenzione: la targa va obbligatoriamente apposta sul mantello dei generatori<!-- sim06--><!--rom11 aggiunta dicitura dopo link_stampa_targa--><!--gac05 aggiunto cerca targa-->
      <formerror  id="targa"><br><!-- sim06 -->
        <span class="errori">@formerror.targa;noquote@</span><!-- sim06 -->
      </formerror><!-- sim06 -->
  </td><!-- sim06 -->
</else>
</tr><!-- sim01 -->

  <tr>
<if (@cod_combustibile@ eq @cod_tele@ or @cod_combustibile@ eq @cod_pomp@) and @coimtgen.regione@ ne "MARCHE" >
    <td valign=top align=right class=form_title colspan=2>
    	<table width="100%" cellspacing=0 cellpadding=0>
    		<tr>
    			<td width="12%">&nbsp;</td>
    			<td>
    			<table width="100%" style="border-width:2px; border-style:solid;" bordercolor="red" cellspacing="0" cellpadding="2">
    			<tr> <!--rom10 messo label_combustibile-->
    				<td valign=top align=right class=form_title>@label_combustibile;noquote@</td>
    				<td valign=top>
    					<formwidget id="cod_combustibile">
        				<formerror  id="cod_combustibile"><br>
        					<span class="errori">@formerror.cod_combustibile;noquote@</span>
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
  <!--rom05    <td valign=top align=right class=form_title>Combustibile</td> -->
  <if @flag_tipo_impianto@ ne "F">
    <td valign=top align=right class=form_title>Combustibile generatore principale</td><!--rom05-->
  </if>
  <if @flag_tipo_impianto@ eq "F">
    <td valign=top align=right class=form_title>Alimentazione</td>
    </if>
  <td valign=top><formwidget id="cod_combustibile">
      <formerror  id="cod_combustibile"><br>
        <span class="errori">@formerror.cod_combustibile;noquote@</span>
      </formerror>
  </td>
</else>
<!--rom05    <td valign=top align=right class=form_title>Proven. dati</td>-->
<td valign=top align=right class=form_title>Provenienza dati dell'impianto</td><!--rom05-->
<td valign=top><formwidget id="provenienza_dati">
    <formerror  id="provenienza_dati"><br>
      <span class="errori">@formerror.provenienza_dati;noquote@</span>
    </formerror>
</td>

</tr>
<tr>
<td></td>
<td colspan=3>
<font color=blue>@msg_cod_combustibile;noquote@</font><!--gac06-->
</td>
</tr>
<if @coimtgen.regione@ ne "MARCHE">
    <tr>
    <td valign=top align=right nowrap class=form_title>Cons. annuo(m<sup><small>3</small></sup>/kg)</small></td>
    <td valign=top><formwidget id="consumo_annuo">
        <formerror  id="consumo_annuo"><br>
        <span class="errori">@formerror.consumo_annuo;noquote@</span>
        </formerror>
    </td>
    </tr>
</if>


<tr>
    <td valign=top align=right class=form_title nowrap>
        <!-- dpr74 Pot. foc. nom.-->
        <% if {$flag_tipo_impianto eq "F"} {
           #sim02 set label_potenza "Pot. frig. nom."
	   #rom07 set label_potenza "Pot. frig./risc. nom.";#sim02
	   set label_potenza "Potenza frigorifera nominale totale dell'impianto";#rom07
	   } else {
	   #rom05 set label_potenza "Pot. foc. nom."
	       set label_potenza "Potenza al focolare<br>nominale totale dell'impianto";#rom05
	   }
        %><!-- dpr74 -->
	@label_potenza;noquote@<!-- dpr74 -->
    </td>
    <td valign=top><formwidget id="potenza">(kW)
        <formerror  id="potenza"><br>
        <span class="errori">@formerror.potenza;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Fascia (per il contributo)</td>
    <if @funzione@ ne M>
       <td valign=top width="1%" colspan=3><formwidget id="descr_potenza">
    </if>
    <else>
       <td valign=top width="1%" colspan=3><formwidget id="cod_potenza">
    </else>
</tr>
<tr>
  <if @coimtgen.regione@ eq "MARCHE" and @flag_tipo_impianto@ eq "T"><!--rom10 aggiunta if-->
  </if>
  <else>  
    <td valign=top align=right class=form_title nowrap>
        <!-- dpr74 Pot. utile nom.-->
        <% if {$flag_tipo_impianto eq "F"} {
           #sim02 set label_potenza_utile "Pot. frig. utile"
	   #rom07 set label_potenza_utile "Pot. frig./risc. utile"
	   set label_potenza_utile "Potenza termica nominale totale dell’impianto";#rom07
	   } else {
	       #rom05 set label_potenza_utile "Pot. utile nom."
	       set label_potenza_utile "Potenza utile nominale<br>totale dell'impianto";#rom05
	   }
        %><!-- dpr74 -->
	@label_potenza_utile;noquote@<!-- dpr74 -->
    </td>
    <td valign=top><formwidget id="potenza_utile">(kW)
        <formerror  id="potenza_utile"><br>
        <span class="errori">@formerror.potenza_utile;noquote@</span>
        </formerror>
    </td>
  </else>
</tr>

<if @coimtgen.regione@ ne "MARCHE"> <!-- rom01 if e suo contenuto -->
<tr>
    <td valign=top nowrap align=right class=form_title>@dpr412;noquote@</td>
    <td valign=top width="1%"><formwidget id="flag_dpr412">
        <formerror  id="flag_dpr412"><br>
        <span class="errori">@formerror.flag_dpr412;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title nowrap>Portata</td>
    <td valign=top><formwidget id="portata">(m<small><sup>3</sup></small>/h)/(kg/h)
        <formerror  id="portata"><br>
        <span class="errori">@formerror.portata;noquote@</span>
        </formerror>
    </td>
</tr>
</if> <!-- rom01 -->

<if @coimtgen.regione@ ne "MARCHE"> <!-- rom01 if, e suo contenuto -->
<tr>
    <td valign=top align=right nowrap class=form_title>Tipologia</td>
    <td valign=top><formwidget id="cod_tpim">
        <formerror  id="cod_tpim"><br>
        <span class="errori">@formerror.cod_tpim;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right nowrap class=form_title>Tariffa</td>
    <td valign=top width="1%" colspan=3><formwidget id="tariffa">
        <formerror  id="tariffa"><br>
        <span class="errori">@formerror.tariffa;noquote@</span>
        </formerror>
    </td>
</tr>
</if> <!-- rom01 -->
<if @coimtgen.regione@ ne "MARCHE"><!--per le marche è nella scheda 1.2-->
<tr> 
     <td valign=top align=right class=form_title>Volume lordo <if @flag_tipo_impianto@ ne "F">riscaldato</if><else>raffrescato</else></td><!--gac03-->
    <td valign=top><formwidget id="volimetria_risc">
        <formerror  id="volimetria_risc"><br>
        <span class="errori">@formerror.volimetria_risc;noquote@</span>
        </formerror>
    </td>
</tr>
</if>
<if @coimtgen.regione@ ne "MARCHE"><!--rom06 aggiunta if-->
  <tr>
    <td valign=top align=right nowrap class=form_title><b>Presenza dell'attestato APE<b></td><!--gac03 -->
    <td valign=top><formwidget id="pres_certificazione">
        <formerror  id="pres_certificazione"><br>
          <span class="errori">@formerror.pres_certificazione;noquote@</span>
        </formerror>
    </td>
    
    <td valign=top align=right nowrap class=form_title><b>Cod. identificativo<br>dell'APE</b></td>
    <td valign=top><formwidget id="certificazione">
        <formerror  id="certificazione"><br>
          <span class="errori">@formerror.certificazione;noquote@</span>
        </formerror>
    </td>
  </tr>
</if><!--rom06-->
  <tr><td colspan=6>&nbsp;</td></tr>
<tr><td colspan=6 class=func-menu-yellow2><b>Dati scadenza dell'Impianto / Informazioni dell'Impianto</b></td></tr><!-- rom03 -->
  <tr><td colspan=6>&nbsp;</td></tr>
<tr>
<if @coimtgen.regione@ ne "MARCHE"> <!-- rom01 aggiunta if -->
    <td valign=top align=right class=form_title>Data di costruzione dell'impianto</td><!--gac03-->
    <td valign=top><formwidget id="anno_costruzione">
        <formerror  id="anno_costruzione"><br>
        <span class="errori">@formerror.anno_costruzione;noquote@</span>
        </formerror>
    </td>
    <td valign=top align=right class=form_title>Marcatura efficienza energetica</td>
    <td valign=top><formwidget id="marc_effic_energ">
        <formerror  id="marc_effic_energ"><br>
        <span class="errori">@formerror.marc_effic_energ;noquote@</span>
        </formerror>
    </td>
</if> <!-- rom01 -->
</tr>

 <if @coimtgen.regione@ ne "MARCHE">
<tr>
    <td valign=top align=right class=form_title>Data di installazione dell'Impianto</td>
    <td valign=top><formwidget id="data_installaz">
        <formerror  id="data_installaz"><br>
        <span class="errori">@formerror.data_installaz;noquote@</span>
        </formerror>
    </td>
  <td valign=top align=right class=form_title>Data dismissione /Disattivazione</td>
    <td valign=top><formwidget id="data_rottamaz">
        <formerror  id="data_rottamaz"><br>
        <span class="errori">@formerror.data_rottamaz;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
<td valign=top nowrap align=right class=form_title>Data dell'eventuale<br> riattivazione</td><!--gac03-->
    <td valign=top><formwidget id="data_attivaz">
        <formerror  id="data_attivaz"><br>
        <span class="errori">@formerror.data_attivaz;noquote@</span>
        </formerror>
    </td>
</tr>
  </if>

<tr>
<!-- gac03     <td valign=top align=right class=form_title>Dichiarato</td>
     <td valign=top nowrap><formwidget id="flag_dichiarato">@scaduto;noquote@
        <formerror  id="flag_dichiarato"><br>
        <span class="errori">@formerror.flag_dichiarato;noquote@</span>
        </formerror>
     </td>
     
     <td valign=top align=right class=form_title>Data primo RCEE</td>
     <td valign=top nowrap><formwidget id="data_prima_dich">
        <formerror  id="data_prima_dich"><br>
        <span class="errori">@formerror.data_prima_dich;noquote@</span>
        </formerror>
     </td> -->
     <td valign=top align=right class=form_title>Data ultimo RCEE</td>
     <td valign=top nowrap><formwidget id="data_ultim_dich">
        <formerror  id="data_ultim_dich"><br>
        <span class="errori">@formerror.data_ultim_dich;noquote@</span>
        </formerror>
     </td>
</tr>
  <tr>
<if @coimtgen.regione@ ne "MARCHE">
    <td valign=top align=right class=form_title>Stato</td>
    <td valign=top>
         <table width=100%>
             <tr>
               <td valign=top width=14% bgcolor=@color;noquote@ bordercolor=000000>&nbsp;</td>
               <td valign=top width=80%><formwidget id="stato">
               <formerror  id="stato"><br>
               <span class="errori">@formerror.stato;noquote@</span>
               </formerror>
               </td>
            </tr>
        </table>
    </td>
</if>
<!--gac03    <td valign=top align=right nowrap class=form_title>@desc_conf;noquote@</td>
    <td valign=top><formwidget id="stato_conformita">
        <formerror  id="stato_conformita"><br>
        <span class="errori">@formerror.stato_conformita;noquote@</span>
        </formerror>
    </td>-->

    <td valign=top align=right class=form_title>Data scad. RCCE.</td>
     <td valign=top nowrap><formwidget id="data_scad_dich">
        <formerror  id="data_scad_dich"><br>
        <span class="errori">@formerror.data_scad_dich;noquote@</span>
        </formerror>
     </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Note</td>
    <td valign=top width="1%" colspan=5 rowspan=1><formwidget id="note">
        <formerror  id="note"><br>
        <span class="errori">@formerror.note;noquote@</span>
        </formerror>
    </td>
</tr>
<tr>
    <td valign="top" align="right" class="form_title">Etichetta Stampa</td>
    <td valign="top"><formwidget id="flag_targa_stampata">
    </td>
</tr>
<!--  <tr>
    <td valign=top>&nbsp;</td>
    <td valign=top align=right class=form_title><b>Dati Ins. da Scheda Ident.</b></td>
    <td valign=top align=left><formwidget id="dati_scheda">
        <formerror  id="dati_scheda"><br>
        <span class="errori">@formerror.dati_scheda;noquote@</span>
        </formerror>
    </td> 
</tr> 
    <tr>
    <td valign=top>&nbsp;</td>
    <td valign=top align=right class=form_title><b>Data Scheda Ident.</b></td>
    <td valign=top align=left><formwidget id="data_scheda">
        <formerror  id="data_scheda"><br>
        <span class="errori">@formerror.data_scheda;noquote@</span>
        </formerror>
    </td> 
</tr> --> <!-- rom01 -->





<if @funzione@ ne "V">
<tr>
    <td colspan=6 align=center><formwidget id="submit" ></td>
</tr>
</if>

<!-- Fine della form colorata -->
</table>

</formtemplate>
<p>
</center>

