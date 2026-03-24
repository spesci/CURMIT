<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    gac01 20/12/2018 Aggiunto javascript_sel

--><master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<if @flag_portafoglio@ eq T>
<if @flag_valor_cod@ eq t>

<script type="text/javascript">
function sel() {
 window.opener.document.coimdimp.cod_manutentore.value = '@cod_manutentore;noquote@';
 window.opener.document.coimdimp.cognome_manu.value = '@cognome;noquote@';
 window.opener.document.coimdimp.nome_manu.value = '@nome;noquote@';
 window.opener.document.coimdimp.saldo_manu.value = '@saldo;noquote@';
 window.opener.document.coimdimp.cod_portafoglio.value = '@conto_manu;noquote@';
 @javascript_sel;noquote@ <!--gac01-->
 window.close();
 } 

setTimeout('sel()',0);
</script>

</if>
</if>

<table width="100%" cellspacing=0 class=func-menu>
   <tr>
   <td width="25%" nowrap class=func-menu>
       <a href=coimmanu-filter?@link_filter;noquote@  class=func-menu>Ritorna</a>
   </td>
   <td width="25%" nowrap class=func-menu>
       <a href=coimmanu-list-csv?@link_scar;noquote@  class=func-menu>Scarica CSV</a>
   </td>
   <td width="75%" class=func-menu>&nbsp;</td>
</tr>
</table>

<if @flag_valor_cod@ ne t>
<if @flag_portafoglio ne T>
@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>
</if>
</if>

