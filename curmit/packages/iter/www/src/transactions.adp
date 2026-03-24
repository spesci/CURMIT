<master src="../master">
<property name="context">@context;noquote@</property> 
  <property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<table width="100%" cellspacing=0 class=func-menu>
   <tr>
   <td width="25%" nowrap class=func-menu>
       <a href=transactions-filter?@link_filter;noquote@  class=func-menu>Ritorna</a>
   </td>
   <td width="25%" nowrap class=func-menu>
       <a href=transactions?format=csv&@link_scar;noquote@  class=func-menu>Scarica CSV</a>
   </td>
   <td width="75%" class=func-menu>&nbsp;</td>
</tr>
</table>
<if @messaggio;noquote@ ne "">
<div><font color=red>@messaggio;noquote@</font></div>
</if>
<if @messaggio_ok;noquote@ ne "">
<div><font color=green>@messaggio_ok;noquote@</font></div>
</if>
@list_head;noquote@

<table cellpadding="2" cellspacing="2">

  <tr>

    <td class="list-list-pane" valign="top">
      <listtemplate name="transactions"></listtemplate>
    <p>

    <table border="1" width="100%">
      <tr>
        <th>Totali</th>
        <th>crediti caricati<br>(B)</th>
        <th>riaccrediti <br>da Regione (storni) (C)</th>
        <th>riaccrediti da altri enti (storni)<br>(D)</th>
        <th>debiti Vs Regione<br>(E)</th>
        <th>debiti Vs altri enti<br>(F)</th>
        <th>SALDO Vs Regione<br>(E-C)</th>
        <th>SALDO Vs altri enti<br>(F-D)</th>
        <th>crediti residui<br>(B+C+D)-(E+F)</th>
      </tr>
      <tr>
        <th>Nel periodo <br>@from_date@ - @to_date@</th>
	<td align="right">@carico_portafoglio_periodo@</td>
	<td align="right">@storno_regione_periodo@</td>
	<td align="right">@storno_enti_periodo@</td>
	<td align="right">@debito_regione_periodo@</td>
	<td align="right">@debito_enti_periodo@</td>
	<td align="right">@saldo_regione_periodo@</td>
	<td align="right">@saldo_enti_periodo@</td>
	<td align="right">@credito_residuo_periodo@</td>
      </tr>
      <tr>
        <th>Complessivo</th>
	<td align="right">@carico_portafoglio_gen@</td>
	<td align="right">@storno_regione_gen@</td>
	<td align="right">@storno_enti_gen@</td>
	<td align="right">@debito_regione_gen@</td>
	<td align="right">@debito_enti_gen@</td>
	<td align="right">@saldo_regione_gen@</td>
	<td align="right">@saldo_enti_gen@</td>
	<td align="right">@credito_residuo_gen@</td>
      </tr>
    </table>

    </td>

  </tr>

</table>

