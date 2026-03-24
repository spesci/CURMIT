<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<table width="100%" cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href="coimmov2-filter?@link_filter;noquote@" class=func-menu>Ritorna</a>
   </td>
   <td width="25%" nowrap class=func-menu>
       <a href="coimmov2-scar?@link_scar;noquote@" class=func-menu>Scarica CSV</a>
   </td>
   <td width="25%" nowrap class=func-menu>
       <a target="Stampa movimenti" href="coimmov2-layout?@link_stp;noquote@" class=func-menu>Stampa PDF</a>
   </td>
   <td width="25%" nowrap class=func-menu>
    &nbsp;
   </td>

</tr>
</table>
@js_function;noquote@

<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>
<!-- genero la tabella -->
@table_result;noquote@

</center>

