<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">

<table width=100% cellspacing=0 class=func-menu>
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr><td valign=top align=right class=form_title>Ente Verificatore</td>
    <td valign=top colspan=3><formwidget id="f_cod_enve">
        <formerror  id="f_cod_enve"><br>
        <span class="errori">@formerror.f_cod_enve;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
    <td valign=top align=right class=form_title>Tecnico assegnato</td>
    <td valign=top colspan=3><formwidget id="f_cog_tecn">
                             <formwidget id="f_nom_tecn">@cerca_opve;noquote@
        <formerror  id="f_cog_tecn"><br>
        <span class="errori">@formerror.f_cog_tecn;noquote@</span>
        </formerror>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<!-- <a href="coimscar-file?nome_funz=scar-file">Scarico complessivo di tutte le tabelle coimaimp, coimcimp, coimdimp</a> -->
<br>
</center>
<if @return@ eq 1>
<table border="1" width="30%" align="center">
<tr align="center">
<td colspan="2">
Dati relativi a <b>@dir;noquote@</b>
</td>
</tr>
<tr align="center">
<td width="50%">
Impianti
</td>
<td width="50%">
<a href="../spool/@dir;noquote@/@nome_file_1;noquote@.csv">Scarica CSV</a>
</td>
</tr>
<tr align="center">
<td>
Rapporti
</td>
<td>
<a href="../spool/@dir;noquote@/@nome_file_2;noquote@.csv">Scarica CSV</a>
</td>
</tr>
<tr align="center">
<td>
Autocertificazioni
</td>
<td>
<a href="../spool/@dir;noquote@/@nome_file_3;noquote@.csv">Scarica CSV</a>
</td>
</tr>
<tr align="center">
<td>
Incontri
</td>
<td>
<a href="../spool/@dir;noquote@/@nome_file_4;noquote@.csv">Scarica CSV</a>
</td>
</tr>
<tr align="center">
<td>
Parametri
</td>
<td>
<a href="../spool/@dir;noquote@/@nome_file_5;noquote@.csv">Scarica CSV</a>
</td>
</tr>
</table>
</if>

