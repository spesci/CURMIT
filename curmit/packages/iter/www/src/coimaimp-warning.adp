<!--
    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
    sim01  10/09/2014 Aggiunto nuovo campo cod_impianto_princ
-->

<if @caller@ eq "dimp" or @caller@ eq "cimp" or @caller@ eq "dope">
<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@	</property>
<property name="riga_vuota">f</property>

@link_tab;noquote@
@dett_tab;noquote@
</if>
<else>
<head>
<link rel="stylesheet" href="@css_url;noquote@/header.css" type="text/css">
<title>Guida compilazione campi</title>
</head>
</else>
<html>
<body>

<table>
  @messaggio_iniziale;noquote@  <!-- rom01 -->
  @elenco_anomalie;noquote@
<tr>
<td>

<br></br>
<p>
<p>
<br>
<if @caller@ eq "warning">
<div align=center><input type=button class="form_submit" onClick="javascript:window.close();" value ="Chiudi"></input></div>
</if>
</br>

</td></tr></table>
</body>
<html>

