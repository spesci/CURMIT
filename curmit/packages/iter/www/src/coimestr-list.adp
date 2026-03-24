<!--
    USER  DATA       MODIFICHE
    ===== ========== =======================================================================
    rom01 13/07/2018 Ricevo e passo il filtro f_invio_comune.

-->

<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<script language=JavaScript>
function checkall() {
    for (var i=0; i < document.@form_name@.elements.length;i++) {
         var e=document.@form_name@.elements[i];
         if (e.name == 'conferma') {
             e.checked = document.@form_name@.checkall_input.checked;
         }
    }
}
</script>

<if @caller@ eq "index">
    <table width="100%" cellspacing=0 class=func-menu>
    <tr>
       <td width="25%" nowrap class=func-menu>
           <a href="coimestr-filter?@link_filter;noquote@" class=func-menu>Ritorna</a>
       </td>
       <td width="50%" nowrap class=func-menu>
            Campagna: <b>@desc_camp;noquote@</b>
       </td>
       <td width="25%" nowrap class=func-menu>&nbsp;</td>
    </tr>
    </table>
</if>

@js_function;noquote@
<!-- barra con il cerca, link di aggiungi e righe per pagina -->
@list_head;noquote@

<center>

<table width=100% border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td align=center>
      <form name=@form_name@ method=post action="coimestr-gest">
        <input type=hidden name=caller           value="@value_caller;noquote@">
        <input type=hidden name=nome_funz        value="@value_nome_funz;noquote@">
        <input type=hidden name=nome_funz_caller value="@value_nome_funz_caller;noquote@">
        <input type=hidden name=tipo_estrazione  value="@value_tipo_estrazione;noquote@">
        <input type=hidden name=cod_cinc         value="@value_cod_cinc;noquote@">
        <input type=hidden name=extra_par        value="@value_extra_par;noquote@">
	<input type=hidden name=flag_racc        value="@value_flag_racc;noquote@">
	<input type=hidden name=flag_pres        value="@value_flag_pres;noquote@">
	<input type=hidden name=f_invio_comune   value="@value_invio_comune;noquote@"><!--rom01-->
        <input type=submit value="Conferma estrazione">
      </td>
   </tr>
</table>

<table border=0>
<tr>
    <td>@link_sel;noquote@</td>
</tr>
<tr>
    <td>@table_result;noquote@</td>
</tr>
</table>

<p>
<input type=submit value="Conferma estrazione">
</form>

</center>

