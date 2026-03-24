<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    rom05 05/06/2024 Tolta sezione per Chiudi sessione e Cambio password.

    rom04 15/11/2023 Aggiunto div per alert-message.

    rom03 06/06/2023 Richiamati script per datepicker.

    rom02 28/07/2022 Modifiche riportate dal vecchio cvs per allinemanto enti di Ucit al nuovo cvs:
    rom02            Aggiunto link per cambiare l'utente del login. Richiamo la url di logout settata nel programma tcl.

    sim02 27/03/2019 Aggiunto Content-Security-Policy per la sicurezza

    rom01 14/09/2018 Cablate le righe che escono in fondo alla pagina per la Regione Marche.

    gac01 17/07/2018 iniziato sviluppo jquery per campo editable-select

    ale01 27/03/2017 Aggiunto tag per migliorare l'impaginazione sui dispositivi mobili

    nic02 07/06/2016 Aggiunto utilizzo parametri master_ind_email e master_sito_web

    sim01 11/03/2016 Modifiche per programmi di gestione del portafoglio
-->
<html>
<head>
<title>@title;noquote@</title>


<link rel="stylesheet" href="@css_url;noquote@/header.css" type="text/css">

<if @flag_alto_contrasto@ eq "t">
    <link rel="stylesheet" href="/resources/iter/highContrast.css" type="text/css" media="all">
</if>
<!-- gac01 script per jquery -->
<script language="javascript" type="text/javascript" src="@css_url@javascript/ext-all.js"></script>
<script language="javascript" type="text/javascript" src="/ah-util/javascript/ah-util.js"></script>
<script language="javascript" type="text/javascript" src="@css_url@javascript/jquery-ui-1.8.17.custom.min.js"></script>
<link rel="stylesheet" href="@css_url@javascript/ext-all.css" type="text/css" media="all">
<if @htmlarea@ eq "t">
    <script type="text/javascript" src="/htmlarea/htmlarea.js"></script>
    <script type="text/javascript" src="/htmlarea/lang/en.js"></script>
    <script type="text/javascript" src="/htmlarea/dialog.js"></script>

    <style type="text/css">
    @import url(htmlarea.css);
    </style>
</if>

<!-- Standard reset, fonts and grids -->
<!-- Questo non va bene perchè fa perdere le dimensioni dei font delle liste e fa debordare le righe del menù <link rel="stylesheet" type="text/css" href="/resources/iter/yui/reset-fonts-grids/reset-fonts-grids.css">-->

<!-- CSS for Menu -->
<link rel="stylesheet" type="text/css" href="/resources/iter/yui/menu/assets/skins/sam/menu.css">
 
<!-- Dependency source files -->
<script type="text/javascript" src="/resources/iter/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="/resources/iter/yui/animation/animation.js"></script>
<script type="text/javascript" src="/resources/iter/yui/container/container_core.js"></script>

<!-- Menu source file -->
<script type="text/javascript" src="/resources/iter/yui/menu/menu.js"></script>

<!-- Page-specific script -->
<script type="text/javascript" src="/resources/iter/iter.js"></script>

<!-- js per bulk_actions-->
<script type="text/javascript" src="/resources/acs-subsite/core.js"></script><!-- sim01 -->

<!-- end menu stuff -->   


<!-- ale01 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- sim02 -->
<meta http-equiv="Content-Security-Policy" content="default-src 'self' https: data: 'unsafe-inline' 'unsafe-eval';">

</head>
<!-- powderblue -->
<!-- lavender -->
<!-- lightcyan -->
<!-- gainsboro -->
<!-- lightblue -->
<body text="black" class="yui-skin-sam" id="yahoo-com">


<center>
<div class=cage>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="20" class=doppiobordo>  
    <tr>
        <td width="11%" rowspan=2 class=bordi-r>
            <table width="100%" height="100%">
                <tr><td align=center class=sottotitoli><b>@master_logo_sx_titolo_sopra@</b></td></tr>
                <tr><td align=center><img src="@logo_url;noquote@/@master_logo_sx_nome;noquote@" height=@master_logo_sx_height@></td></tr>
                <tr><td align=center class=sottotitoli>
                        <if @master_logo_sx_titolo_sotto@ eq "">
                            &nbsp;
                        </if>
                        <else>
                            <b>@master_logo_sx_titolo_sotto@</b>
                        </else>
                    </td>
                </tr>
            </table> 
        </td>
        <td width="78%" rowspan=2 class=bordi>
            <table cellspacing ="0" cellpadding="3" border ="0" width="100%" height="100%">
                <tr><td colspan=2 class=titoli align="center">@title;noquote@</td></tr>
		<if @yui_menu_p@ true>
		    <tr><td colspan=2 class=td_menu_yui><include src="/packages/iter/www/dynamic-menu"></td></tr>
		</if>
                <tr><td class=context>@context_bar;noquote@</td>
		<td align=right class=context>@url_ss;noquote@ @url_spid;noquote@</td><!--rom01 aggiunto il link --><!--rom02 Aggiunto link spid-->
		</tr>
            </table>
        </td>
        <td width="11%" rowspan=2 class=bordi-l>
            <table width="100%" height="100%">
                <tr><td align=center class=sottotitoli><b>@master_logo_dx_titolo_sopra@</b></td></tr>
                <tr><td align=center><img src="@logo_url;noquote@/@master_logo_dx_nome;noquote@" height=@master_logo_dx_height@></td></tr>
                <tr><td align=center class=sottotitoli>
                        <if @master_logo_dx_titolo_sotto@ eq "">
                            &nbsp;
                        </if>
                        <else>
                            <b>@master_logo_dx_titolo_sotto@</b>
                        </else>
                    </td>
                </tr>
            </table> 
        </td>
	
    </tr>
  </table>
</div>
<!-- rom04  Aggiunta if e il suo contenuto-->
    <if @user_messages:rowcount@ gt 0>
      <div id="alert-message">
        <multiple name="user_messages">
          <div class="alert">
            <strong>@user_messages.message;noquote@</strong>
          </div>
         </multiple>
       </div>
     </if>

<div align=right class=cage >
    <table width="100%" height="350" border="0" cellspacing="0" cellpadding="0" class="doppiobordo" style="border-bottom:unset;">
    <tr>
        <td valign=top>
            <slave>
        </td>
    </tr>
    <tr height=10><td>&nbsp</td></tr>
    </table>
</div>
<!-- <br clear="all"> -->
<div class=cage>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="15" class=doppiobordo>   
<!-- rom05 <tr>
      <td width="33%" align=left class=footer1><a class=footer_link href=@css_url;noquote@logout?nome_funz=@funz_log_out;noquote@>&laquo; Chiudi sessione</a></td>
      <td width="34%" class=footer1>&nbsp;</td> 
      <td width="33%" align=right class=footer1><a class=footer_link href=@css_url;noquote@utenti/coimcpwd-gest?funzione=M&nome_funz=@funz_pwd;noquote@>Cambia password &raquo;</a></td>

    </tr> -->
    </table>
<if @coimtgen.regione@ ne "MARCHE"><!--rom01 aggiunta if-->    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="15"
	    class=doppiobordo>
      <tr class=footer2>
        <td align=left><a href="mailto:@master_ind_email;noquote@"
			  class="footer_link">&laquo;
	    @master_ind_email;noquote@</a></td>
        <td align=center><a href="https://@master_sito_web;noquote@"
			    class="footer_link">@master_sito_web;noquote@</a></td>
        <td align=right><a href="https://www.oasisoftware.com"
			   class="footer_link">Powered by OASI software S.r.l. 
	    &raquo;</a></td>
      </tr>
    </table>
</if>
<if @coimtgen.regione@ eq "MARCHE"><!--rom01 aggiunta if e contenuto-->
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="15"
         class=doppiobordo>
    <tr class=footer2>
      <td width="40%" align=left><a href="mailto:impianti-termici@regione-marche.it"
                        class="footer_link">&laquo;
          impianti-termici@regione-marche.it</a></td>
      <td width="20%" align=center class="footer1">@master_sito_web;noquote@</td>
      <td width="40%" align=right class="footer1" >Powered by OASI software S.r.l.  &nbsp;&nbsp</td>
    </tr>
  </table>
</if><!--rom01-->
</div>
</center>

<script type="text/javascript">
    <if	@focus_field@ not nil>
        document.@focus_field@.focus();

        if (document.@focus_field@.type == "text"
        ||  document.@focus_field@.type == "textarea") {
	    document.@focus_field@.select();
        }
    </if>
</script>

<!-- rom03 Inizio -->
<script language="javascript" type="text/javascript" src="/iter/resources/jquery/jquery-min.js"></script>
<link rel="stylesheet" href="/iter/resources/jquery-ui/jquery-ui.min.css" type="text/css" media="all">
<script language="javascript" type="text/javascript" src="/iter/resources/jquery-ui/jquery-ui.min.js"></script>
<script language="javascript" type="text/javascript" src="/iter/resources/jquery-ui/i18n/datepicker-it.js"></script>
<script type="text/javascript">
  $(function() {
      $( ".ah-jquery-date" ).datepicker({
	  changeYear: true,
	  showOn: "button",
	  buttonImage: "/resources/acs-templating/calendar.gif",
	  buttonImageOnly: true,
	  buttonText: "Apri calendario"
      });
  });
</script>

<!-- rom03 fine -->

</body>
</html>
