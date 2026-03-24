<!--
    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
   
  -->
<master   src="../master-single-sign-on">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<html>
<head>
<link rel="stylesheet" href="@css_url;noquote@/header.css" type="text/css">
</head>
<body>
<formtemplate id="@form_name;noquote@">
<!-- Inizio della form colorata -->
<%=[iter_form_iniz]%>
  <tr>
    <td>
      <table border=0>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td valign=top align=left class=form_title width=13% nowrap>Campagna vecchia</td>
          <td valign=top width=25%><formwidget id="cod_cind">
            <formerror  id="cod_cind"><br>
              <span class="errori">@formerror.cod_cind;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr>
          <td valign=top align=left class=form_title width=13%>Campagna nuova</td>
          <td valign=top width=25%><formwidget id="cod_cind_n">
            <formerror id="cod_cind_n"><br>
              <span class="errori">@formerror.cod_cind_n;noquote@</span>
            </formerror>
          </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
	<tr>
          <td  align=center colspan=2><formwidget id="submit"></td>
        </tr>
      </table>
    </td>
   </tr><!--rom02-->  
<!-- Fine della form colorata -->
<%=[iter_form_fine]%>
</formtemplate>
  </body>
<html>
