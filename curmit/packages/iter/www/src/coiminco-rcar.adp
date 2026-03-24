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
<tr>
   <td width="25%" class=func-menu>&nbsp;</td>
   <td width="50%" class=func-menu align=center>Campagna: <b>@desc_camp;noquote@</b></td>
   <td width="25%" class=func-menu>&nbsp;</td>
</tr>
</table>

<br>

<%=[iter_form_iniz]%>

<if @flag@ eq S>
    <tr><td valign=top class=form_title align=center colspan=4>
            <b>ELABORAZIONE TERMINATA</b>
        </td>
    </tr>

    <tr><td valign=top class=form_title align=right>Letti Appuntamenti:</td>
        <td valign=top class=form_title align=right>@ctr_inp;noquote@</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>

    <tr><td colspan=4>&nbsp;</td>

    <tr><td valign=top class=form_title align=right width="50%">Caricati Appuntamenti:</td>
        <td valign=top class=form_title align=right  width="5%">@ctr_out;noquote@</td>
        <td width="5%">&nbsp;</td>
        <td valign=top class=form_title width="40%"><a target="Valori caricati" href="@file_out_url;noquote@">Scarica CSV degli appuntamenti caricati</a></td>
    </tr>

    <tr><td valign=top class=form_title align=right>Scartati Appuntamenti:</td>
        <td valign=top class=form_title align=right>@ctr_err;noquote@</td>
        <td>&nbsp;</td>
        <td valign=top class=form_title><a target="Valori scartati" href="@file_err_url;noquote@">Scarica CSV degli appuntamenti scartati</a></td>
    </tr>

    <multiple name=multiple_scarti>
    <tr>
        <td valign=top class=form_title colspan=1 align=right>&nbsp;&nbsp;&nbsp;Per @multiple_scarti.motivo_scarto;noquote@:</td>
        <td valign=top class=form_title align=right >@multiple_scarti.ctr_scarto;noquote@</td>
        <td colspan=2>&nbsp;</td>
    </tr>
    </multiple>
</if>
<else>

    <tr><td valign=top align=right class=form_title>File da importare</td>
        <td valign=top nowrap><formwidget id="file_name">
            <formerror  id="file_name"><br>
            <span class="errori">@formerror.file_name;noquote@</span>
            </formerror>
        </td>
    </tr>

    <tr><td colspan=2>&nbsp;</td></tr>

    <tr><td colspan=2 align=center><formwidget id="submit_2"></td></tr>

</else>
<%=[iter_form_fine]%>
<!-- Fine della form colorata -->
</formtemplate>
<p>
</center>

