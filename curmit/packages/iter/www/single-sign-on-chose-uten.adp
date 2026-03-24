<master   src="master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<br>
<br>

<formtemplate id="@form_name;noquote@">
  <formwidget   id="token_code">
  <formwidget id="id_utente">
  <formwidget id="codice_fiscale_uten">

  <table border=0 align="center" width=100% >
  <tr>
    <td align=center>
      <big style="font-family:verdana;"><b>Scegli l'utenza con cui vuoi effettuare il login:</b></big>
    </td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td>
      <table class="table-display" width=45% align=center border=0>
        <tr bgcolor=#f8f8f8 class=table-header style="background-color:#f8f8f8">
          <th align=center width=20%>Seleziona</th>
          <th align=center width=25%>Codice Iter</th>
          <th align=left nowrap> Denominazione</th>
        </tr>
        <!-- genero la tabella -->
        <multiple name=utenti>
          <tr @utenti.class_multiple;noquote@>
            <td valign=top align=center>@utenti.radio_butt;noquote@</td>
            <td valign=top align=center>@utenti.cod_manutentore;noquote@</td>
            <td valign=top align=left>@utenti.denominazione;noquote@</td>
          </tr>
        </multiple>
      </table>
    </td>
  </tr>
  <tr><td align=center>&nbsp;</td></tr>
  <tr><td align=center>@mex_error;noquote@</td></tr>
  <tr><td align=center>&nbsp;</td></tr>
  <tr>
    <td align=center>
       <formwidget id="submit">
    </td>
  </tr>
</table>
</formtemplate>
