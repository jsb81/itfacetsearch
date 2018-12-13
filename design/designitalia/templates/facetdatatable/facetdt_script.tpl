{set_defaults( hash(
    'export_attributes', '',
    'hide_query', false()
))}

{literal}
<script>
    let PROTOCOL = window.location.protocol;

    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    var class_identifier = "{/literal}{$classes}{literal}";
    var class_attributes = "{/literal}{$class_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = {/literal}{$node.node_id}{literal};
    var show_datatable = false;
    var is_remote = false;

    // Se vero esegue una ricerca iniziale
    var do_search = true;

    {/literal}
    {if $is_remote_class}
        // Ricerca su sito remoto
        is_remote = true;

        siteURL = '{$configured_facet_search.remote_site_import_url}';
        node_id = 2; // Cerco su tutto il sito remoto

        // Preimposta la ricerca selezionata
        {if $is_remote_class}
            {foreach $remote_attr_identifiers as $key => $rem_attr_id}
                sessionStorage.setItem('{$rem_attr_id}' + class_identifier, '{$remote_attr_filters[$key]}');
            {/foreach}
        {/if}
    {/if}
    {literal}

    // function setSelectFacet( facet, item, selected_item_value ){

    // function setToggleButtonFacet( facet, item, selected_item_value ){
    
    var dataTable = $("#datatable_content").DataTable({
            "processing": true,
            "serverSide": true,
            "bFilter": false,
            "ajax": {
                "type": "GET",
                "url": PROTOCOL + "//" + siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id + "//" + is_remote,
                "data": function( d ) {
                    // Select Options
                    $('#search_form option:selected').each(function(){
                        var parent = $(this).parent();

                        d[ parent.attr('name') ] = $(this).val();
                    });
                    // Inputs
                    $('#search_form :input').each(function(){
                        d[ $(this).attr('name') ] = $(this).val();
                    });
                }
            },
            /*"order": [[ 0, "asc" ],[ 1, "asc" ]], // Barbatrucco per ordinare per rilevanza*/
            "language": {
                sEmptyTable: "Nessun dato presente nella tabella",
                sInfo: "Vista da _START_ a _END_ di _TOTAL_ elementi",
                sInfoEmpty: "Vista da 0 a 0 di 0 elementi",
                sInfoFiltered: "(filtrati da _MAX_ elementi totali)",
                sInfoPostFix: "",
                sInfoThousands: ".",
                sLengthMenu: "Visualizza _MENU_ elementi",
                sLoadingRecords: "Caricamento...",
                sProcessing: "Elaborazione...",
                sSearch: "Cerca:",
                sZeroRecords: "La ricerca non ha portato alcun risultato.",
                oPaginate: {
                    sFirst: "Inizio",
                    sPrevious: "<<",
                    sNext: ">>",
                    sLast: "Fine"
                },
                oAria: {
                    sSortAscending: ": attiva per ordinare la colonna in ordine crescente",
                    sSortDescending: ": attiva per ordinare la colonna in ordine decrescente"
                },
                buttons: {
                    print: "Stampa",
                    copy: "Copia"
                }
            }, 
            "bInfo" : false, // Nasconde il numero di righe visualizzate
             {/literal}
                {include uri='design:facetdatatable/datatable_sort.tpl'}
             {literal},
            {/literal}
               {include uri='design:facetdatatable/datatable_length.tpl'}
            {literal}
       });
    
    // Aggiorna la ricerca //
    function search(event){
        do_search = false;

        // Aggiorna numero elementi per pagina
        if(event !== null && event.target.id === 'show'){
            dataTable.page.len( $(event.target).val() );
        }

        // Sistema per togliere impostazione di una faccetta
        if(event !== null && $(event.target).attr("class") === "search-choice-close"){
            var id_reset = event.target.id;
            var parent_id = id_reset.replace('_reset', '');

            $("#"+parent_id).val( '' );
            $("#"+parent_id).show();

            $("#"+parent_id+"_value").html( '' );
            $("#"+parent_id+"_choosen").hide();
        }

        // console.log("https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id);

        dataTable.ajax.reload();

        // Imposta il sistema per rimuovere la faccetta se è selezionato un valore
        if(event !== null){
            var value = $(event.target).val();
            var source_id = event.target.id;
            if(value !== '' && source_id !== 'query'){
                $(event.target).hide();

                $("#"+source_id+"_value").html( value );
                $("#"+source_id+"_choosen").show();
            }
        }

    }
    
    $(document).ready(function(){
        
        // Aggiorno le Faccette //
        $("#datatable_content").on('xhr.dt', function(e, settings, result, xhr){
            
            {/literal}
                {foreach $facet_attributes|explode('|') as $index => $fct}
                    {set $fct = $fct|explode(';')[0]}
                    
                    if($("#{$fct}").hasClass("fct_toggle_input")){ldelim} 
                        setToggleButtonFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
                    {rdelim}
                    else if($("#{$fct}_radio_fieldset").hasClass("fct_radio_fieldset")){ldelim}
                        setRadioButtonFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
                        {rdelim}
                    else{ldelim}
                        setSelectFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
                    {rdelim}
                {/foreach}
            {literal}

            // Lettura variabili persistenti
            if(sessionStorage.getItem('query' + class_identifier) !== null){
                $("#query").val( sessionStorage.getItem('query' + class_identifier) );
            }

            // Imposta le selezioni da variabili di sessione
            {/literal}
                {foreach $facet_attributes|explode('|') as $index => $fct}
                    if(sessionStorage.getItem('{$fct}' + class_identifier) !== null){ldelim}
                        $("#{$fct}").val( sessionStorage.getItem('{$fct}' + class_identifier) );
                        $("#{$fct}").hide();

                        $("#{$fct}_value").html( sessionStorage.getItem('{$fct}' + class_identifier) );
                        $("#{$fct}_choosen").show();
                    {rdelim}
                {/foreach}
            {literal}

            // Visualizzo i dati caricati //
            $("#loading").hide();
            {/literal}
                {if $hide_query|not}
                    $("#search").show();
                {/if}
            {literal}

            $("#datatable").show();
            $('#datatable_content').DataTable()
                .columns.adjust()
                .responsive.recalc();

            if(result.recordsTotal === 1){
                $("#numRows").html( '<b>' + result.recordsTotal + ' {/literal}{$single_result_count_name}{literal}</b>' );
            }
            else{
                $("#numRows").html( '<b>' + result.recordsTotal + ' {/literal}{$multiple_result_count_name}{literal}</b>' );
            }

            // Se ci sono variabili preimpostate esegue la ricerca
            if(do_search){
                search( null );
            }
        });
        
        
        
        // Ricarica lanciata su invio //
        $("#query").keypress(function(event) {
            if (event.which === 13) {
                event.preventDefault();
                search(event);
            }
        });
        
        // Ricarica lanciata su mouse click //
        $("#query_click").click(function(event) {
            search(event);
        });
        
        
        // Ricarica lanciata su select //
        $("#search_form select").change(function(event){
            search(event);
        });
        
       // Reset di una faccetta //
       $(".search-choice-close").click(function(event){
            search(event);
       });
        
        // Ricarica lanciata su bottone lente //
        if($('#buttonquerysearch').length){
                $( "#buttonquerysearch" ).click(function(event) {
                event.preventDefault();
                search(event);
            });
        }
        
        // Ricerca tramite toggle buttons
        $(".fct_toggle_button").click( function(event) {
            if( !$(this).hasClass("is-disabled") ){
                if( $(this).hasClass("active") ){
                    // !!implica un solo gruppo di toggle buttons per ricerca !!
                    var selected_tags = $(".fct_toggle_input").val();
                    selected_tags = selected_tags.replace($(this).data('value'),  '');
                    if(selected_tags.endsWith('|')){
                        selected_tags = selected_tags.substring(0, selected_tags.length - 1);
                    }
                    $(".fct_toggle_input").val(selected_tags);
                    //

                    $(this).html($(this).html().replace('<i class="mdi mdi-checkbox-marked-outline"></i>', '<i class="mdi mdi-checkbox-blank-outline"></i>'));
                    $(this).removeClass("active");
                }
                else{
                    if($(".fct_toggle_input").val() === '' ){
                        $(".fct_toggle_input").val( $(this).data('value') );
                    }
                    else{
                        $(".fct_toggle_input").val( $(".fct_toggle_input").val() + '|' + $(this).data('value') );
                    }

                    $(this).html($(this).html().replace('<i class="mdi mdi-checkbox-blank-outline"></i>', '<i class="mdi mdi-checkbox-marked-outline"></i>'));
                    $(this).addClass("active");
                }
            
                search(event);
            }
        });
        
        // Azzera la ricerca //
        $("#reset_button").click(function(event){
            $("#query").val("");
            
            {/literal}
            {foreach $facet_attributes|explode('|') as $index => $fct}
                {set $fct = $fct|explode(';')[0]}
                
                $("#{$fct}").val("");
                $("#{$fct}").show();
                $("#{$fct}_choosen").hide("");
            {/foreach}
            {literal}
            $(".fct_toggle_button").each(function(key, value){
                $(this).removeClass("active");
                $(this).html($(this).html().replace('<i class="mdi mdi-checkbox-marked-outline"></i>', '<i class="mdi mdi-checkbox-blank-outline"></i>'));
            });
            
            search(event);
        });
        
        //search( null );
        
        // Esporta i risultati su CSV
        $("#export_list").click(function(event){
            var spinner = '<i class="fa fa-spinner fa-spin"></i>';
            var original_html = $(this).html();
            $(this).html( $(this).html() +  spinner );
             class_attributes = "{/literal}{$export_attributes}{literal}";

            var csv_download = PROTOCOL + "//"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id + "/CSV";
            csv_download        += '?' + $('#search_form').serialize();

            document.location.href = csv_download;

            $(this).html( original_html );
        });
    });
    
</script>
{/literal}