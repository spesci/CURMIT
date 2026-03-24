<!--
    USER  DATA       MODIFICHE
    ===== ========== ==========================================================================
    rom03 15/10/2024 Modifiche per recupero password operatori delle ditte di manutenzione.

    rom02 29/03/2024 Rifatta pagina di login come su viae e idrae.

    rom01 19/03/2021 Allinemanto cvs enti di UCIT: Gestita pagina di login in base al paramentro login_spid_p
-->
<master src="master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>
<formtemplate id="login">

<center>
<h2 class="form-signin-heading">@systemname;noquote@ Login</h2>
<blockquote style=border-left:5px solid white>
<if @coimtgen.login_spid_p@ ><!--rom01-->
<br>
<br>
<b>Utilizza il vecchio login</b>
</if><!--rom01-->
<!-- disegna una tabella azzurra e grigia -->
<%=[iter_form_iniz]%>
<tr><td align="center">
<div class="g-input">
  <input type="text" id="utn_cde" name="utn_cde" placeholder=" ">
  <label for="utn_cde">Codice Utente</label>
  <formerror  id="utn_cde"><br>
    <span class="errori">@formerror.utn_cde@</span>
  </formerror>
</div>
</td></tr>
 <tr><td align="center">
<div class="g-input">
  <input type="password" id="utn_psw" name="utn_psw" placeholder=" ">
  <label for="utn_psw">Password</label>
  <formerror  id="utn_psw"><br>
    <span class="errori">@formerror.utn_psw;noquote@</span>
  </formerror>
</div>
 </td></tr>
 <if @url_portale@ ne ""> <!-- rom03 Aggiunta if per link recupero password -->
   <tr>
     <td align="center" style="font-size: 18px;font-family: arial;"><a href="@url_portale;noquote@/register/pre_recover_password">Hai dimenticato la tua password?</a>
       <br><small>Solo per operatori ditte di manutenzione.</small>
     </td>
   </tr>
 </if>
 <tr><td align="center"><br>
<formwidget id=submit class="submit-login">
</td></tr>


<if 1 eq 0><!-- rom02 -->
<!-- Ricordare di posizionare gli eventuali link ai pgm di zoom -->
<br>
<br>
<tr><td align=right><b>Codice Utente</b></td>
    <td><formwidget id="utn_cde">
        <formerror  id="utn_cde"><br>
        <font color="red"><b>@formerror.utn_cde;noquote@</b></font></formerror>
    </td>
</tr>
<tr><td align=right><b>Password</b></td>
    <td><formwidget id="utn_psw">
        <formerror  id="utn_psw"><br>
        <font color="red"><b>@formerror.utn_psw;noquote@</b></font></formerror>
    </td>
</tr>
<br>
<br>
<tr><td colspan=2 align=center><formwidget id="submit"></td></tr>
<tr><td colspan=2>&nbsp;</td></tr>
</if><!--rom02-->

<!-- chiusura della tabella azzurra e grigia -->
<%=[iter_form_fine]%>
<if @coimtgen.login_spid_p@ ><!--rom01 Aggiunta if e suo contenuto-->
<b>Oppure</b>
<br><br>
<a style="font-weight: 400; font-size: 16px;" href="spid-login.tcl" spid-idp-button="#spid-idp-button-medium-post" aria-haspopup="true" aria-expanded="false" class="italia-it-button italia-it-button-size-m button-spid">
                                <span class="italia-it-button-icon"><img src="./logo/spid-ico-circle-bb.png" onerror="this.src='./logo/spid-ico-circle-bb.png'; this.onerror=null;" alt=""></span>
                                <span class="italia-it-button-text">Entra con SPID</span>
                            </a>
<link rel="stylesheet" href="./resources/spid-sp-access-button.min.css" type="text/css">
</if><!--rom01-->
</center>


</formtemplate>

