<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    gac03 10/12/2018 Modificato gac02 per passare alla scheda 1.2

    gac02 13/07/2018 Aggiunto bottone in alto "Torna a Scheda 1.6: Soggetti che operano 
    gac02            sull'impianto" solo per la Regione Marche.

    rom01 12/07/2018 Aggiunto bottone in alto "Passa a Scheda 4 / 4.1 bis Generatori" solo per 
    rom01            la Regione Marche.

    gac01 02/07/2018 Modificate label
-->
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>
@link_tab;noquote@
@dett_tab;noquote@

@js_function;noquote@
<!--gac01 aggiunto table e suo contenuto-->
<table width=100% border=0>
<if @coimtgen.regione@ eq "MARCHE"> <!--rom04 aggiunta if e contenuto -->
  <tr>
<td width="25%" nowrap class=func-menu align=left>
  <!--gac02      <a href="coimaimp-sogg?funzione=V&@link_scheda4;noquote@&nome_funz=impianti&nome_funz_caller=impianti" class=func-menu>Torna a Scheda 1.6: Soggetti che operano sull'impianto</a>--><!--gac02-->
  <a href="coimaimp-ubic?funzione=V&@link_gest;noquote@&nome_funz=impianti&nome_funz_caller=impianti">Torna a Scheda 1.2: Ubicazione</a><!--gac03-->
    </td>
    <td width="25%" nowrap class=func-menu align=left>
      <a href="coimgend-list?@link_scheda4;noquote@&nome_funz=datigen&nome_funz_caller=impianti" class=func-menu>Passa a Scheda 4 / 4.1 bis Generatori</a>
    </td>
    <td width="75%">&nbsp;</td>
  </tr>
</if><!--rom01-->
<tr><td colspan=3>&nbsp;</td></tr>
  <tr><td colspan=3 class=func-menu-yellow2><b>Scheda 3: Nomina Terzo Responsabile</b></td></tr>
<tr><td colspan=3>&nbsp;</td></tr>
</table><!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<br>
<center>
<!-- genero la tabella -->

<b>Lista Modelli</b>
<br><br>
@table_result;noquote@


</center>

