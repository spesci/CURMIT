<master   src="../master">
<property name="title">@page_title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>


<center>

<button class="form_submit" onclick="javascript:window.open('@file_pdf_url;noquote@', 'stampa', 'scrollbars=yes, resizable=yes')">Stampa</button>

<br>
<br>
    A sistema sono presenti @tot_dimp_edit;noquote@ modelli della campagna @campagna;noquote@
    <if @da_data_edit@ ne "">
        tra il @da_data_edit;noquote@ ed il @a_data_edit;noquote@
    </if>
    <else>
        fino al @a_data_edit;noquote@
    </else>
    <p>



    @table;noquote@

</center>

