<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom03 14/11/2022 Aggiunti i link per schede 14.1 e 14.2 per la gestione dei consumi dei
    rom03            combustibili e di elettricita'.

    rom02 16/11/2021 Per regione Marche aggiunti link per schede 14.3 e 14.4, Sandro ha detto
    rom02            che possono essere visti da tutti.

    rom01 06/11/2018 Su richiesta delle Marche rinominati diversi titoli.

    gab01 17/08/2016 Gestite nuove pagine del libretto (8.1, 9.1, 9.2, 9.3, 9.4 ).
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
@link_tab;noquote@
@dett_tab;noquote@

<br>
<center>


<table border=0>
  <tr>
     <td>
	<b>Scheda 2: Trattamento acqua</b>
     	<br>@link_modifica;noquote@
     </td>
  </tr>
  <tr>
  <!--    <td>@table_result;noquote@</td> -->
  </tr>
  <tr><td>&nbsp;</td></tr>

<!-- genero la prima tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 4.3: Lista Recuperatori/condensatori</b>-->
       <b>Scheda 4.3: Recuperatori/condensatori lato fumi</b><!--rom01-->
       <br>@link_aggiungi;noquote@
     </td>
  </tr>
  <tr>
    <td>@table_result;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  
  <!-- genero la seconda tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 4.7: Lista Campi Solari</b>-->
       <b>Scheda 4.7: Campi Solari termici</b><!--rom01-->
	 <br>@link_aggiungi_2;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_2;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- genero la terza tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 4.8: Lista Altri Generatori</b>-->
       <b>Scheda 4.8: Altri Generatori</b><!--rom01-->
	<br>@link_aggiungi_3;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_3;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
     <td>
       <!--rom01<b>Scheda 5: Regolazione e contabilizzazione</b>-->
       <b>Scheda 5: Sistemi di regolazione e contabilizzazione</b><!--rom01-->
	<br>@link_modifica_2;noquote@
     </td>
  </tr>
  <tr>
   <!--  <td>@table_result_3;noquote@</td> -->
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
     <td>
       <!--rom01<b>Scheda 6: Sistemi di Distribuz.</b>-->
       <b>Scheda 6: Sistemi di Distribuzione</b><!--rom01-->
	<br>@link_modifica_3;noquote@
     </td>
  </tr>
  <tr>
  <!--    <td>@table_result_3;noquote@</td> -->
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
     <td>
       <!--rom01<b>Scheda 7: Sistema di Emiss.</b>-->
       <b>Scheda 7: Sistema di Emissione</b><!--rom01-->
	<br>@link_modifica_4;noquote@
     </td>
  </tr>
  <tr>
  <!--   <td>@table_result_3;noquote@</td> -->
  </tr>
  <tr><td>&nbsp;</td></tr>

<!-- rom01 fine -->
  <!-- gab01: genero la quarta tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 8: Lista Accumuli</b>-->
       <b>Scheda 8: Sistema di accumulo</b><!--rom01-->
        <br>@link_aggiungi_4;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_4;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero la quinta tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.1: Lista Torri Evaporative</b>-->
       <b>Scheda 9.1: Torri Evaporative</b><!--rom01-->
        <br>@link_aggiungi_5;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_5;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>  

  <!-- gab01: genero la sesta tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.2: Lista Raffreddatori di Liquido</b>-->
       <b>Scheda 9.2: Raffreddatori di Liquido</b><!--rom01-->
        <br>@link_aggiungi_6;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_6;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero la settima tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.3: Lista Scambiatori di Calore Intermedi</b>-->
       <b>Scheda 9.3: Scambiatori di Calore Intermedi</b><!--rom01-->
        <br>@link_aggiungi_7;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_7;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero l'ottava tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.4: Lista Circuiti Interrati a Condensazione/Espansione Diretta</b>-->
       <b>Scheda 9.4: Circuiti Interrati a Condensazione/Espansione Diretta</b><!--rom01-->
        <br>@link_aggiungi_8;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_8;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero la nona tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.5: Lista Unità di Trattamento Aria</b>-->
       <b>Scheda 9.5: Unità di Trattamento Aria</b><!--rom01-->
      <br>@link_aggiungi_9;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_9;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero la decima tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 9.6: Lista Recuperatori di Calore</b>-->
       <b>Scheda 9.6: Recuperatori di Calore</b><!--rom01-->
       <br>@link_aggiungi_10;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_10;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!-- gab01: genero la undicesima tabella -->
  <tr>
     <td>
       <!--rom01<b>Scheda 10.1: Lista Impianti di Ventilazione Meccanica Controllata</b>-->
       <b>Scheda 10.1: Impianti di Ventilazione Meccanica Controllata</b><!--rom01-->
      <br>@link_aggiungi_11;noquote@
     </td>
  </tr>
  <tr>
     <td>@table_result_11;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>

  <!--rom03 Aggiunti link per schede 14.1 e 14.2-->
    <tr>
    <td>
      <b>Scheda 14.1: Consumo di combustibile</b>
      <br>@link_aggiungi_14;noquote@
       </td>
  </tr>
  <tr>
    <td>@table_result_14;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>
      <b>Scheda 14.2: Consumo di elettricit&agrave;</b>
      <br>@link_aggiungi_15;noquote@
    </td>
  </tr>
    <tr>
      <td>@table_result_15;noquote@</td>
    </tr>
  <tr><td>&nbsp;</td></tr>

  <!--rom02 Aggiunti link per schede 14.3 e 14.4-->
  <tr>
    <td>
      <b>Scheda 14.3: Consumo di acqua di reintegro nel circuito dell'impianto termico</b>
      <br>@link_aggiungi_12;noquote@
       </td>
  </tr>
  <tr>
    <td>@table_result_12;noquote@</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>
      <b>Scheda 14.4: Consumo di prodotti chimici per il trattamento acqua del circuito dell'impianto termico</b>
      <br>@link_aggiungi_13;noquote@
    </td>
  </tr>
    <tr>
      <td>@table_result_13;noquote@</td>
    </tr>
  <tr><td>&nbsp;</td></tr>


</table>













