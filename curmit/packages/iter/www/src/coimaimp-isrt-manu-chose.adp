<!DOCTYPE html>
<!-- 
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    ric01 18/11/2025 Aggiunto link "Vedi nota" con pdf mandato da regione Marche per il regupero della targa.

    rom09 06/02/2023 Per Regione Friuli non mostro piu' label messa da gac01 come deciso con call del 06/02/2023.

    rom08 29/12/2022 Giuliodori ha richiesto di cambiare la dicitura sopra al campo della tipologia di
    rom08            impianto eliminando "impianti Ibridi".

    rom07 09/09/2021 Aggiunto pop-up richiesto da Giuliodori di Regione Marche per dare indicazioni
    rom07            sulla procedura da seguire per l'accatastamento di caminetti autocostruiti e simili. 

    rom06 08/04/2019 I campi pod e pdr sono resi visibili solo per le MARCHE

    rom05 07/03/2019 Ricambiato il titolo iniziale su richiesta delle Autorita' competenti e
    rom05            ispettori di Regione Marche
    
    rom04 07/08/2018 Aggiunto pop-up "Per capire quando sommare le potenze dei gruppi termici/
    rom04            gruppi frigo, clicca qui" su richiesta della Regione Marche.

    rom03 31/07/2018 Aggiunto titolo iniziale su richiesta della Regione Marche.
    rom03            Spostata dicitura di rom01 dal fondo all'inizio della pagina su richiesta
    rom03            di Regione Marche.
    
    rom02 30/07/2018 Aggiunta if per regione marche per il campo targa
    
    rom01 29/09/2019 Aggiunta dicitura per spiegazione su cosa si intende per impianto 
    rom01            su richiesta della Regione Marche.
    
    gac01 02/07/2018 Aggiunto possibilità di fare refresh e aggiunta label
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>


<center>
<formtemplate id="@form_name@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="__refreshing_p"><!-- gac01 -->
<formwidget   id="changed_field"> <!-- gac01 -->

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td colspan=2>&nbsp;</td></tr>
<if @coimtgen.regione@ eq "MARCHE">
  <table border="0" width="70%" align="center">
    <tr>
      <!--rom05 Modificata la dicitura-->
      <!--rom03         <td class="func-menu-yellow2"><b>Vengono richiesti l'inserimento di questi dati per controllo su eventuali impianti già esistenti<br>o per permettere la validazione all'ente dell'impianto stesso</b></td> -->
      <td class="func-menu-yellow2"><b>In questa scheda vengono richiesti i dati necessari per controllare<br>se l’impianto &egrave; gi&agrave; nel catasto e, nel caso non ci sia, per inserirlo in CURMIT.</b>
	<br>Attenzione: in caso di sola sostituzione del generatore, occorre tornare al meu&grave; Impianti,
	<br>ricercare o acquisire il relativo impianto e compilare  la sostituzione dalla scheda 4.</td><!--rom03 cambiata label -->
    </tr>
    <tr><td colspan=2>&nbsp;</td></tr>
    <tr><!--rom03 aggiunta tr e contenuto-->
      <td valign="top" colspan=2>
	<table border="0" width="70%" align="center">
	  <tr> 
            <td><i>ATTENZIONE: ai soli fini di una corretta archiviazione dei dati sul catasto si precisa che per “impianto” si intende un impianto termico dotato di uno o più  gruppi termici o, gruppi frigo/pompe di calore, le cui potenze nominali utili devono essere sommate per formare un unico RCEE composto da tante sezioni “E” quanti sono i gruppi termici o le pompe di calore che lo costituiscono.</i>
            </td>
	  </tr>
	  <tr><!--rom04 aggiunta tr e cotnenuto-->
	    <td>
	      <!--rom07 Nella url passo il parametro link_caller-->
	      <a href="#" onclick="javascript:window.open('coimaimp-isrt-help?link_caller=somma_potenze', 'help', 'scrollbars=yes, resizable=yes, width=580, height=320').moveTo(110,140)"><b>Per capire quando sommare le potenze dei gruppi termici/gruppi frigo, clicca qui</b></a>
	    </td>
	  </tr>
	</table>
      </td>
    </tr>
    <tr><td colspan=2>&nbsp;</td></tr>
  </table>
</if>
<!-- dpr74 -->
  <if @coimtgen.regione@ eq "MARCHE"><!--rom06 aggiunta if  ma non il suo contenuto-->
<table border="0" width="80%" align="center">
<tr><td valign=top width="50%" align=right class=form_title>POD</td>
    <td valign=top align=left nowrap><formwidget id="pod">
        <formerror id="pod"><br>
        <span class="errori">@formerror.pod;noquote@</span>
        </formerror><i>Il campo &egrave; obbligatorio solo se il generatore principale non &egrave; collegato ad una rete di distribuzione del gas e quindi non esiste il PDR.</i><!--rom03 aggiunta frase-->
        <br>
<i>Il POD (Point of Delivery) è il codice alfanumerico nazionale di 14 caratteri che identifica univocamente il punto fisico in cui l'energia elettrica<br> viene consegnata al cliente finale.<br> Il codice non cambia anche se cambia il fornitore ed è riportato sempre sul contratto, nella prima pagina della bolletta e sul display del contatore</i>
    </td>
</tr>
<tr><td colspan=2>&nbsp;</td></tr>
<tr>    <td valign=top width="50%" align=right class=form_title>PDR</td>
    <td valign=top align=left nowrap><formwidget id="pdr">
        <formerror id="pdr"><br>
        <span class="errori">@formerror.pdr;noquote@</span>
        </formerror><br>
<i>Il PDR (Punto di Riconsegna) è il codice numerico nazionale di 14 cifre che identifica univocamente il punto fisico in cui il gas<br> viene consegnato al cliente finale. <br>Il codice non cambia anche se cambia il fornitore ed è riportato sempre sul contratto e nella prima pagina della bolletta</i>
    </td>
</tr>
<tr>
  <td valign=top width="50%" align=right class=form_title>Codice Contatore:</td>
  <td><i>Appena disponibile verrà inserito il Codice contatore, sar&agrave; possibile fornire il dato in alternativa al PDR</i></td>
</tr>
  </if>
  <else><!--rom06 aggiunta else e suo contenuto-->
    <table width="100%" align="center">
      <tr>
	<td align=center colspan=2><b>Scheda iniziale per l'inserimento di un nuovo impianto</td>
	</tr>
  </else>
<if @coimtgen.regione@ ne "FRIULI-VENEZIA GIULIA"><!-- rom09 Aggiunta if ma non il contenuto -->
<tr><!--gac01 aggiunto tr e suo contenuto-->
<td>
  &nbsp;
</td>
    <td align=left><br>Dati relativi al generatore principale (con potenza nominale più elevata)<br></td></tr>
</if>
<else> <!-- rom09 Aggiunta else e il suo contenuto -->
  <tr>
    <td colspan=2>&nbsp;</td>
  </tr>
</else>
<tr>
<td valign=top width="50%" align=right class=form_title>Costruttore</td>
    <td valign=top align=left nowrap><formwidget id="cod_cost">
        <formerror id="cod_cost"><br>
        <span class="errori">@formerror.cod_cost;noquote@</span>
        </formerror>
    </td>
</tr>

<if @coimtgen.regione@ eq "MARCHE"><!--rom07 Aggiunta if e suo contenuto-->
  <tr>
    <td>&nbsp;</td>
    <td>
      <a href="#" onclick="javascript:window.open('coimaimp-isrt-help?link_caller=procedura_accatastamento', 'help', 'scrollbars=yes, esizable=yes, width=580, height=320').moveTo(110,140)"><b>Per sapere come accatastare caminetti, stufe, ecc., <u>senza costruttore, modello e matricola</u> (es.: caminetto autocostruito), clicca qui.</b></a>    
    </td>
  </tr>
</if>

<tr><td colspan=2>&nbsp;</td></tr>
<tr><td valign=top width="50%"colspan=1 align=right class=form_title>Modello</td>
    <td valign=top align=left nowrap><formwidget id="modello">
        <formerror id="modello"><br>
        <span class="errori">@formerror.modello;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td valign=top width="50%"colspan=1 align=right class=form_title>Matricola</td>
    <td valign=top align=left nowrap><formwidget id="matricola">
        <formerror id="matricola"><br>
        <span class="errori">@formerror.matricola;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td colspan=2>&nbsp;</td></tr>
<if @coimtgen.regione@ eq "MARCHE"> <!-- rom02 aggiunta if e suo contenuto-->
    <tr>
        <td valign="top" width=50% align="right" nowrap class="form_title">Codice catasto(targa)</td>
        <td valign="top" align="left"><formwidget id="targa">
        <formerror  id="targa"><br>
        <span class="errori">@formerror.targa;noquote@</span>
        </formerror>
        </td>
    </tr>
<tr><td>&nbsp;</td>
<!--rom03        <td valign="top" align=left colspan=1><i>Compilare il campo targa solo se si vuole collegare<br>il nuovo impianto ad  un impianto già esistente (stesso sistema edificio/impianto)</i></td> -->
  <td valign="top" align=left colspan=1><i>Compilare il campo "Codice catasto(targa)" solo se si vuole inserire <br>il nuovo impianto in un libretto gi&agrave; esistente (stesso sistema edificio/impianto)<a href="recupero_targa.pdf" target="_blank"> <b>Vedi nota</b></a></i></td><!--rom03--> <!--ric01 -->
</tr>
</if>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td>&nbsp;</td>
  <td><i>Per campi solari termici e altre tipologie generatore selezionare "Generatore a combustione"</i></td> <!-- rom08  tolta parte "impianti Ibridi," a inizio frase-->
</tr>
<tr>   <td valign=top width="50%" align=right class=form_title>Tipologia impianto</td>
    <td valign=top align=left nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td colspan=2>&nbsp;</td></tr>
<tr><td>&nbsp;</td>
  <td><i>Per le miscele di combustibili a gas di petrolio liquefatti (non presenti in elenco), selezionare la voce "GPL"</i></td>
</tr>
<tr><td valign=top width="50%" align=right class=form_title>Combustibile</td>
    <td valign=top align=left nowrap><formwidget id="cod_combustibile">
        <formerror id="cod_combustibile"><br>
        <span class="errori">@formerror.cod_combustibile;noquote@</span>
        </formerror>
    </td>
</tr>
<tr><td colspan=2>&nbsp;</td></tr>
<!--rom03 spostata tr e conenuto in alto su richiesta della Regione Marche 
<tr><!--rom01 aggiunta tr e contenuto
    <td valign="top" colspan=2>
      <table border="0" width="70%" align="center">
       <tr> 
        <td><i>ATTENZIONE: ai soli fini di una corretta archiviazione dei dati sul catasto si precisa che per “impianto” si intende un impianto termico dotato di uno o più  gruppi termici o, gruppi frigo/pompe di calore, le cui potenze nominali utili devono essere sommate per formare un unico RCEE composto da tante sezioni “E” quanti sono i gruppi termici o le pompe di calore che lo costituiscono.</i>
        </td>
       </tr>
      </table>
    </td>
</tr>
 rom03 -->

</table>
<!-- dpr74 -->

<table border="0" width="80%" align="center">
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>


<tr><td align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>
</table>
</formtemplate>
<p>
</center>

