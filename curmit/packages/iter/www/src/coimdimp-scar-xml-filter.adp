<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="funzione">
<formwidget   id="caller">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="receiving_element">
<formwidget   id="f_cod_manu">
<formwidget   id="dummy">

<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
<tr><td colspan=2>&nbsp;</td></tr>

<tr><td valign=top align=right class=form_title>Manutentore</td>
    <td valign=top><formwidget id="f_manu_cogn">
        <formerror  id="f_manu_cogn"><br>
        <span class="errori">@formerror.f_manu_cogn;noquote@</span>
        </formerror>
    </td>   
</tr>

<tr><td valign=top align=right class=form_title>&nbsp;</td>
    <td valign=top><formwidget id="f_manu_nome">@cerca_manu;noquote@
        <formerror  id="f_manu_nome"><br>
        <span class="errori">@formerror.f_manu_nome;noquote@</span>
        </formerror>
    </td>   
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td valign=top align=right class=form_title>Da data inserimento</td>
    <td valign=top><formwidget id="f_data_ins_iniz">
        <formerror  id="f_data_ins_iniz"><br>
        <span class="errori">@formerror.f_data_ins_iniz;noquote@</span>
        </formerror>
    </td>   
</tr>

<tr><td valign=top align=right class=form_title>A data inserimento</td>
    <td valign=top><formwidget id="f_data_ins_fine">
        <formerror  id="f_data_ins_fine"><br>
        <span class="errori">@formerror.f_data_ins_fine;noquote@</span>
        </formerror>
    </td>   
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td valign=top align=right class=form_title>Da data controllo</td>
    <td valign=top><formwidget id="f_data_controllo_iniz">
        <formerror  id="f_data_controllo_iniz"><br>
        <span class="errori">@formerror.f_data_controllo_iniz;noquote@</span>
        </formerror>
    </td>   
</tr>

<tr><td valign=top align=right class=form_title>A data controllo</td>
    <td valign=top><formwidget id="f_data_controllo_fine">
        <formerror  id="f_data_controllo_fine"><br>
        <span class="errori">@formerror.f_data_controllo_fine;noquote@</span>
        </formerror>
    </td>   
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan=2>&nbsp;</td></tr>

<if @funzione@ ne "V">
    <tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
</if>
<else>
    <tr><td colspan=2 align=center><span class="errori">@page_title;noquote@</span></td></tr>
</else>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>
</formtemplate>
<p>
</center>

