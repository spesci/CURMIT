<master   src="master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<!--
    USER    DATA       MODIFICHE
    ======= ========== =======================================================================
    rom03   25/06/2025 Se sono loggato come ispettore non devo vedere i pulsanti del cruscotto.

    rom02   04/02/2025 Tolta possibilita di usare stile grafico ad alto contrasto.

    ric01   21/01/2025 Aggiunto conteggio strumenti scaduti.

    rom01   18/10/2024 Modifiche per cambio password univoco da portale per operatori ditte di manutenzione.

    but01   08/05/2024 aggiunto impianti RESPINTI  e modificato i label su richiesta di Sandro.
    
    sim01   18/03/2016 Visualizzo il saldo del portafoglio

    nic02   02/04/2014 Aggiunto link al documento delle FAQ 

    nic01   27/03/2014 Aggiunto avviso presenza di messaggi non letti
-->
<if 1 eq 0><!-- rom01 Aggiunta if ma non il contenuto -->
<center>
<if @yui_menu_p@ true>
  <big>
  <h2>Benvenuto, @nome@ @cognome@</h2>
  <p> </p>
  <p>Per iniziare a lavorare scegli una funzione cliccando su una qualsiasi voce del menu.</p>
  <p>Se preferisci, puoi usare la normale pagina di menu <a class=main href="toggle-menu">HTML</a>.
  <p>Puoi anche cambiare la tua <a class=main href=utenti/coimcpwd-gest?funzione=M&nome_funz=@funz_pwd;noquote@>password</a> o <a class=main href="logout?nome_funz=@funz_log_out;noquote@">uscire</a> dal programma.</p>
  <p>Se preferisci, puoi usare uno stile grafico <a class=main href="toggle-contrasto">
     <if @flag_alto_contrasto@ eq "f">
         ad alto contrasto.
     </if>
     <else>
         Standard.
     </else>
     </a>
  </p>

  <p> </p>
  <p>Leggi le <a class=main href="doc/FAQ.pdf">F.A.Q.</a></p>
  <p> </p>

  <if @ctr_msg_non_letti@ gt 0><!-- nic01 (ho aggiunto questa if ed il suo contenuto -->
      <p><b><font color=red>Attenzione, hai @ctr_msg_non_letti@ messaggi non letti. Per consultarli, clicca <a class=main href="src/coimdmsg-list?nome_funz=dmsg">qui</a></font></b></p>
  </if>

  @riga_portafoglio;noquote@<!-- sim01 -->
  </big>
</if>
</if><!-- rom01 -->
<!-- rom01 Inizio -->
<h1 style="margin-top: 20px; margin-left:3%; color:#cf8a00; font-size:36px;font-weight: 500;" width=90% align=left>I.Ter. Web</h1>
<center>
<if @yui_menu_p@ true>
<p style="margin-top: 15px; margin-left:3%;" width=90% align=left>
<img src="@logo_url;noquote@/@master_logo_sx_nome;noquote@" alt="Logo Cliente" border="1" height="100px"/>
</p>
<table width=100% class= "jumbotron">
   <tr>
    <td>
    <div>
      <p><big><big>Benvenuto, @nome@ @cognome@.</big></big></p>
      @riga_utente;noquote@
      @riga_ditta;noquote@
      <p>Per iniziare a lavorare scegli una funzione cliccando su una qualsiasi voce del menu.</p>
  	<p>Se preferisci, puoi usare la normale pagina di menu <a class=main href="toggle-menu">HTML</a>.</p>
<!--rom02<p>Se preferisci, puoi usare uno stile grafico <a class=main href="toggle-contrasto"><if @flag_alto_contrasto@ eq "f">ad alto contrasto. </if><else>Standard. </else></a></p> -->
  	<!--rom01 <p>Puoi anche cambiare la tua <a class=main href=utenti/coimcpwd-gest?funzione=M&nome_funz=@funz_pwd;noquote@>password</a> o <a class=main href="logout?nome_funz=@funz_log_out;noquote@">uscire</a> dal programma.</p> -->
	@riga_cambio_password;noquote@ <!-- rom01 -->
  	<p>Leggi le <a class=main href="doc/FAQ.pdf">F.A.Q.</a></p>
	
  <if @is_widgtes_home_to_view@ eq "t"><!--rom03 -->
    <p><b>@riga_portafoglio;noquote@</b></p><!-- sim01 -->
    </td>
    <td rowspan=2 valign=top>
    <div>
      <include src="iter-alerts"
       id_utente="@id_utente@"
       cod_manu="@cod_manu@"
       where_manu="@where_manu@"
      />
    </div>
    </td>
    </tr>
   <tr>
     <td>
       <a href=@href_url_msg;noquote@>
	 <div class="widget-home" style="@wid_home_msg_cursor@" align="center">
           <font color="black">MESSAGGI NON LETTI</font><br><br><br><b><font size=5 color="red">@ctr_msg_non_letti@</font></b>
	 </div>
       </a>
       <a href=@href_url_imp_scad;noquote@>
	 <div class="widget-home" style="@wid_home_imp_scad_cursor@" align="center">
           <font color="black">IMPIANTI ATTIVI CON<br>RCEE SCADUTI</font><br><br><b><font size=5 color="red">@num_imp_scad_pretty@</font></b>
	 </div>
       </a>
       <if @coimtgen.flag_verifica_impianti;noquote@ eq "t">
	 <a href=@href_url_imp_da_valid;noquote@>
           <div class="widget-home" style="@wid_home_imp_da_valid_cursor@" align="center">
             <font color="black">IMPIANTI DA VALIDARE<br>DEL @current_year_pretty@</font><br><br><b><font size=5 color="red">@num_imp_da_valid_pretty@</font></b>
           </div>
	 </a>
       </if>
       <!-- but01 aggiunto if ed il suo contenuto -->
       <if @coimtgen.flag_verifica_impianti;noquote@ eq "t">
	 <a href=@href_url_imp_da_resp;noquote@>
           <div class="widget-home" style="@wid_home_imp_da_resp_cursor@" align="center">
             <font color="black">IMPIANTI RESPINTI<br>DEL @current_year_pretty@</font><br><br><b><font size=5 color="red">@num_imp_da_resp_pretty@</font></b>
           </div>
	 </a>
       </if>
       
       <a href=@href_url_imp_peric;noquote@> <!-- but01 modificato il label -->
	 <div class="widget-home" style="@wid_home_imp_peric_cursor@" align="center">
           <font color="black">IMPIANTI CON RCEE<br>CON PRESCRIZIONI DEL @current_year_pretty@</font><br><br><b><font size=5 color="red">@num_imp_peric_pretty@</font></b>
	 </div>
       </a>
       
       <a href=@href_url_strum_scad;noquote@> <!-- ric01 aggiunto conteggio -->
	 <div class="widget-home" style="@wid_home_strum_scad@" align="center">
	   <font color="black">STRUMENTI SCADUTI</font><br><br><b><font size=5 color="red">@num_strum_scad_pretty@</font></b>
	 </div>
       </a>
</if><!-- rom03 -->
     </td>
   </tr>
</table>

</if>
<else>
    Benvenuto, @nome@ @cognome@.

    &nbsp;

    Se preferisci, puoi usare <a class=main href="toggle-menu">l'interfaccia grafica per i menù</a>.

    &nbsp;
<!--rom02
    Se preferisci, puoi usare uno stile grafico <a class=main href="toggle-contrasto">
    <if @flag_alto_contrasto@ eq "f">
        ad Alto Contrasto.
    </if>
    <else>
        Standard.
    </else>
    </a>

    &nbsp; -->

    Leggi le <a class=main href="doc/FAQ.pdf">F.A.Q.</a>

    <if @ctr_msg_non_letti@ gt 0><!-- nic01 (ho aggiunto questa if ed il suo contenuto -->
        <p><b><font color=red>Attenzione, hai @ctr_msg_non_letti@ messaggi non letti. Per consultarli, clicca <a class=main href="src/coimdmsg-list?nome_funz=dmsg">qui</a></font></b></p>
    </if>

    @riga_portafoglio;noquote@<!-- sim01 -->

    <include src="dynamic-menu">
</else>


</center>
