<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<property name="riga_vuota">f</property>

<table width=100% cellspacing=0 class=func-menu>
<tr>
   <td width="25%" nowrap class=func-menu>
       <a href=coimbimp-list?@link_list;noquote@ class=func-menu>Ritorna</a>
   </td>
   <td class=func-menu>&nbsp;</td>
</tr>
</table>

<center>
<formtemplate id="@form_name@">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="destinazione">
<formwidget   id="compatta_list">
<formwidget   id="cod_impianto_est_new">
<formwidget   id="f_resp_cogn"> 
<formwidget   id="f_resp_nome"> 
<formwidget   id="f_comune">
<formwidget   id="f_cod_via">
<formwidget   id="f_desc_via">
<formwidget   id="f_desc_topo">
<formwidget   id="f_manu_cogn"> 
<formwidget   id="f_manu_nome"> 
<formwidget   id="f_cod_manu"> 

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr>
    <td align=center><b>Confermi la bonifica dei seguenti impianti:</b></td>
</tr>
<tr><td align=center>&nbsp;</td></tr>
<tr><td align=center>@aimp_da_compattare;noquote@</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align=center><b>con destinazione</b></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td>@error_msg;noquote@</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align=center>@aimp_destinazione;noquote@</tr></td>
<tr><td>&nbsp;</td></tr>
<if @error_msg@ eq "">
    <tr><td colspan=4 align=center><formwidget id="submit"></td></tr>
</if>
<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>

