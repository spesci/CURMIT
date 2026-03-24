<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<table width="100%" cellspacing=0 class=func-menu>
   <tr>
   <td width="25%" nowrap class=func-menu>
       <a href=coimdimp-scar-filter?@link_filter;noquote@ class=func-menu>Ritorna</a>
   </td>
   <td width="75%" class=func-menu>&nbsp;</td>
</tr>
</table>

@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
    <td width="30%">&nbsp;</td>
    <td width="40%" align="center">
Scarica <!-- ric01  "in formato" rimosso per uniformare tutte le diciture 'Scarica CSV' -->
<a href="coimdimp-scar?swc_formato=csv&@link_export;noquote@" target="Esportazione Modelli H in formato csv"><img border=0 src=@logo_dir_url;noquote@/csv.gif>CSV</a>
<!-- per ora non scarichiamo in formato xml
o
<a href="coimdimp-scar?swc_formato=xml&@link_export;noquote@" target="Esportazione Modelli H in formato xml"><img border=0 src=@logo_dir_url;noquote@/xml.gif></a>
-->
    </td>
    <td width="30%" align="right">&nbsp;
    </td>
</tr>
</table>

<p>
<center>

<!-- genero la tabella -->
@table_result;noquote@

</center>

