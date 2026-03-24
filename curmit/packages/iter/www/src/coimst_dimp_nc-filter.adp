<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<center>
<formtemplate id="@form_name;noquote@">
<formwidget   id="nome_funz">
<formwidget   id="nome_funz_caller">
<formwidget   id="f_cod_manu">
<formwidget   id="dummy">
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>

<!-- dpr74 -->
<tr><td valign=top align=right class=form_title>Tipologia impianti</td>
    <td valign=top colspan=2 nowrap><formwidget id="flag_tipo_impianto">
        <formerror id="flag_tipo_impianto"><br>
        <span class="errori">@formerror.flag_tipo_impianto;noquote@</span>
        </formerror>
    </td>
</tr>
<!-- dpr74 -->

<tr>
    <td valign=top align=right class=form_title>Da data inserimento</td>
    <td valign=top nowrap><formwidget id="da_data_ins">
        <formerror  id="da_data_ins"><br>
        <span class="errori">@formerror.da_data_ins;noquote@</span>
        </formerror>
    </td>
</tr>

<tr><td valign=top align=right class=form_title>A data inserimento</td>
    <td valign=top nowrap><formwidget id="a_data_ins">
        <formerror  id="a_data_ins"><br>
        <span class="errori">@formerror.a_data_ins;noquote@</span>
        </formerror>
    </td>
</tr>

<tr>
   <td valign=top align=right class=form_title>Comune</td>
   <td valign=top><formwidget id="f_comune">
       <formerror  id="f_comune"><br>
       <span class="errori">@formerror.f_comune;noquote@</span>
       </formerror>
   </td>
</tr>

<tr>
   <td valign=top align=right class=form_title>Manutentore</td>
   <td valign=top><formwidget id="f_manu_cogn">
       <formwidget id="f_manu_nome">@cerca_manu;noquote@
       <formerror  id="f_manu_cogn"><br>
       <span class="errori">@formerror.f_manu_cogn;noquote@</span>
       </formerror>
   </td>
</tr>

<tr><td colspan=2>&nbsp;</td></tr>

<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>

<!-- Fine della form colorata -->
<%=[iter_form_fine]%>

</formtemplate>
<p>
</center>


