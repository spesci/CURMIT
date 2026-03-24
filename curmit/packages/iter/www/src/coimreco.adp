<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<formtemplate id="parameters">
  <formwidget   id="caller">
  <formwidget   id="nome_funz">

  <table cellpadding="3" cellspacing="3">
    <tr>
      <th align="right">Anno e mese</th>
      <td><formwidget   id="year_and_month"><small>Digitare nel formato AAAA-MM</small>
        <formerror  id="year_and_month"><br>
        <span class="errori">@formerror.year_and_month;noquote@</span>
        </formerror>
      </td>
    </tr>
    <tr><th valign="top" align="right">Tipo corrispettivo</th>
        <td align="left"><formgroup id="flag_pag">@formgroup.widget;noquote@ @formgroup.label;noquote@
        </formgroup>
        <formerror  id="flag_pag"><br>
        <span class="errori">@formerror.flag_pag;noquote@</span>
        </formerror>
    </td>
    </tr>
    <tr>
      <td span="2" align="center"><formwidget   id="submit"></td>
    </tr>
  </table>
</formtemplate>

<if @stampa@ not nil>
<center>

<button class="form_submit" onclick="javascript:window.open('@file_pdf_url;noquote@', 'stampa', 'scrollbars=yes, resizable=yes')">Stampa</button>

<br><br>
@stampa;noquote@

</center>
</if>


