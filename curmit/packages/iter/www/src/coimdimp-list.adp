<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    gac02 13/07/2018 Aggiunto link "Torna a Scheda 4 / 4.1 bis Generatori" solo per la
    gac02            Regione Marche

    rom01 12/07/2018 

    gac01 02/07/2018 Modificate label

    ant01 16/09/2015 Aggiunta lista e link per gestione "dich. di freq. ed elenco oper. di
    ant01            contr. e manut." usata solo nella regione Marche.
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
@link_tab;noquote@
@dett_tab;noquote@

@js_function;noquote@

<table width=100%><!--gac01 aggiunto table e suo contenuto-->
<if @coimtgen.regione@ eq "MARCHE"><!--rom01 aggiuta if e contenuto-->
  <tr>
    <td width="25%" class=func-menu>
      <a href="coimgend-list?@link_scheda4;noquote@&nome_funz=datigen&nome_funz_caller=impianti">Torna a Scheda 4 / 4.1 bis Generatori</a>
    </td>
    <td width="25%" class=func-menu>
      <a href="coimcimp-list?@link_scheda13;noquote@&nome_funz_caller=impianti">Passa a Scheda 13: Rapp. Ispezione</a>
    </td>
    <td colspan=5>&nbsp;</td>
  </tr>
</if><!--rom01-->
<tr><td class=func-menu-yellow2><b>RCEE e moduli regionali</b></td></tr>
<tr><td>&nbsp;</td></tr>
<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<table width=50% align=center class="styled-table">
<tr>
<td>@link_aggiungi;noquote@</td>
</tr>
</table>
<br>
<center>
<!-- genero la tabella -->

<b>Lista Modelli</b>
<br><br>
@table_result;noquote@

<if @sw_dichiarazioni_frequenza@ eq "t"><!-- ant01: aggiunta if ed il suo contenuto -->
  <br><br><b>Lista Dichiarazioni di Frequenza ed Elenco Operazioni di Controllo e Manutenzione</b>
  <br><br>
  @table_result4;noquote@
</if>

<if @flag_sup@ eq S>
<!--gac01 
<br><br><b>Lista Allegati IX</b>
  <br><br>
  @table_result2;noquote@
-->
  <if @coimtgen.regione@ ne "MARCHE">
  <br><br><b>Lista Allegati 284</b>
  <br><br>
  @table_result3;noquote@
  </if>
  <else>
    <br><br><b>Lista Allegati 284</b>
    <br><br>
    @table_result_284;noquote@
    <br><br><b>Lista Allegati 286</b>
    <br><br>
    @table_result_286;noquote@
    <br><br><b>Lista Allegati 284 vecchio formato</b>
    <br><br>
    @table_result3;noquote@
  </else>
</if>

</center>

