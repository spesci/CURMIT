<!--
    USER   DATA       MODIFICHE
    ====== ========== =======================================================================
   
  -->
<master   src="../master-single-sign-on">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<html>
<title>Conferma bonifica Campagna</title>
<link rel="stylesheet" href="@css_url;noquote@/header.css" type="text/css">
</head>
<body>
  <center>
    <table>
      <tr><td>&nbsp;</td></tr>
      <tr><td valign=top align=center><font color=green><big><b>Bonifica effettuata<b></big></font></td></tr>
      <tr><td>&nbsp;</td></tr>
      <tr><td valign=top align=left><big>Per visualizzare correttamente la bonifica:</big>
            <ol type="number">
	      <li>Premere il pulsante Chiudi.</li>
	      <li>Rientrare sull'RCEE selezionandolo dalla lista degli RCEE.</li>
            </ol>
          </td>
      </tr>
      <tr><td>&nbsp;</td></tr>
    </table>
  </center>
  <div align=center><input type=button onClick="javascript:window.close();" value ="Chiudi"></input></div>
  </body>
<html>
