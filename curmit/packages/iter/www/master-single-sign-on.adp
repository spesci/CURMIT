<!--
    rom01 14/10/2018 Aggiuno link "Torna al portale"

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
<style>
  /* Stile base per i link nell'header */
  .link-header {
  color: #ffffff; /* Colore bianco */
  text-decoration: underline;
  font-weight: bold;
  transition: text-shadow 0.3s ease, opacity 0.3s ease;
  }

  /* Hover: aggiunge un leggero bagliore */
  .link-header:hover {
  text-shadow: 0 0 8px rgba(255, 255, 255, 0.6);
  opacity: 0.9; /* Leggera riduzione di opacità per effetto visivo */
  }

  /* Stato attivo: leggermente meno luminoso */
  .link-header:active {
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.4);
  opacity: 0.8;
  }

  /* Stato visitato: rimane bianco */
  .link-header:visited {
  color: #ffffff;
  text-shadow: none;
  }
  
  </style>

<!-- ale01 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<!-- powderblue -->
<!-- lavender -->
<!-- lightcyan -->
<!-- gainsboro -->
<!-- lightblue -->
<body text="black" class="yui-skin-sam" id="yahoo-com">

<center>
<div class=cage>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="15%" class=doppiobordo>
    <tr>
      <td width="100%" align="center" style="background-color: #EFEFEF; padding:5px;"><img src="@logo_url;noquote@/@master_logo_dx_nome;noquote@" height="100%"></td>
    </tr>
    <tr>
      <td width="100%" rowspan=1 class=bordi>
        <table cellspacing ="0" cellpadding="1" border ="0" width="100%" height="100%">
          <tr>
            <td class="context" width="30%">@context_bar;noquote@</td>
	    <td class="titoli" style="color:#FFF;" align="center"><big>@title;noquote@</bog></td>
	    <td align="right" class="context" width="30%" style="padding-right: 10px;">@url_ss;noquote@</td><!--rom01 aggiunto il link -->
	  </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
<div align=right class=cage>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="doppiobordo" height="75%" style="border-bottom:unset;">
    <br>
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

</body>
</html>
