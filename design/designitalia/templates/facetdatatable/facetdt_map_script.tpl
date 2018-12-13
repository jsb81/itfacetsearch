{set_defaults( hash(
    'export_attributes', '',
))}

{literal}
<script>
    let PROTOCOL = window.location.protocol;
   
    var mapGlobal = null;
    var searchMapGlobal = null;
    var geojsonLayer = null;
    var markers = null;
    var markerMap = {};

    var previousMapSearch = null;

    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    var class_identifier = "{/literal}{$classes}{literal}";
    var class_attributes = "{/literal}{$class_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = {/literal}{$node.node_id}{literal};
    var show_datatable = false;
    var like_query = '{/literal}{ezini( 'FacetSearch', 'LikeQuery', 'facetsearch.ini'  )}{literal}';

    // function showModal(id){
    
    // function setSelectFacet( facet, item, selected_item_value )

    // function setToggleButtonFacet( facet, item, selected_item_value ){

    var dataTable = $("#datatable_content").DataTable({
            "processing": true,
            "serverSide": true,
            "bFilter": false,
            "ajax": {
                "type": "GET",
                "url": PROTOCOL + "//"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id,
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



    // Imposta le faccette per i radio buttons
    function setRadioButtonFacet( facet, item, selected_item_value ){
        // nothing to do
    }

    function showHideDependentFields(){
        {/literal}
        {*
            {foreach $facet_search_attributes as $search_attribute}
                {if and($search_attribute.type|eq(1), $search_attribute.attribute_datatype|eq(2))}
                    {if $search_attribute.attribute_dependency|ne('')}
                        var attr = '{$search_attribute.attribute_identifier}';
                        var attr_dependency = '{$search_attribute.attribute_dependency}';
                        var hide = true;

                        {literal}
                        if($("#"+attr_dependency).val() !== '' && $("#"+attr_dependency).val() !== '0'){
                            // @TODO: di violenza!! da sistemare!!
                            if($("#"+attr_dependency).val() === 'Secondaria di secondo grado'){
                                hide = false;
                            }
                            //
                        }

                        if(hide){
                            $("#"+attr).hide();
                        }
                        else{
                            if($("#"+attr).val()===''){
                                $("#"+attr).show();
                            }
                        }
                        {/literal}
                    {/if}
                {/if}
            {/foreach}
            *}
        {literal}
    }

    // MAPPA
    // Rigenera la mappa in base alla ricerca //
    function searchMapReload(){
        $("#searchMap_loading").show();
        $("#searchMap").hide();

        if(previousMapSearch !== null){
            previousMapSearch.abort();
        }

        previousMapSearch = $.ajax({
            "type": "GET",
            "url": PROTOCOL + "//"+siteURL+"/facetsearch/geo_search/" + class_identifier + "/" + facet_attributes +"/" + node_id,
            "data": $('#search_form').serialize(),
            "success": function( result ){
                if(result.features.length === 0){
                    $("#searchMap_loading").hide();
                }
                else{
                    if(searchMapGlobal !== null){
                        searchMapGlobal.remove();
                    }

                    var searchMap = L.map('searchMap');
                    var customIconRed = L.MakiMarkers.icon({icon: "circle-stroked", color: "#000000", size: "l"});

                    L.tileLayer(
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        {maxZoom: 18,attribution: '&copy; <a href="https://openstreetmap.org/copyright">OpenStreetMap</a> contributors'}).addTo(searchMap);

                    // Scale
                    L.control.scale().addTo(searchMap);

                    markers = L.markerClusterGroup();
                    $.each(result.features, function(i,v){
                        var markerListItem = $("<li data-id='"+v.properties.id+"'><a href=/content/view/full/'"+v.properties.id+"'>"+v.properties.name+"</a></li>");
                        markerListItem.bind('click',markerListClick);
                        $('#map-128').parents('.row').find('.list-markers-text').append(markerListItem);
                    });

                    geoJsonLayer = L.geoJson(result, {
                        pointToLayer: function (feature, latlng) {
                            var icon = customIconRed;
                            return L.marker(latlng, {
                                icon: icon
                            });
                        },
                        onEachFeature: function (feature, layer) {
                            layer.bindPopup('<a href="https://'+siteURL+'/content/view/full/'+feature.properties.id+'">'+feature.properties.name+'</a>');
                        }
                    });
                    markers.addLayer(geoJsonLayer);
                    searchMap.addLayer(markers);
                    searchMap.fitBounds(markers.getBounds());

                    searchMapGlobal = searchMap;

                    setTimeout(function() {
                        searchMapGlobal.invalidateSize();
                        searchMapGlobal.fitBounds(markers.getBounds());
                    }, 500);

                    $("#searchMap_loading").hide();
                    $("#searchMap").show();
                }
            }
        });

    }
    // /MAPPA


    // Aggiorna la ricerca //
    function search(event){
        let query = $("#query").val();

        if(like_query === 'enabled') {
            $("#query").val(query + '*');
        }

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
        searchMapReload();

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

        if(like_query === 'enabled') {
            $("#query").val(query);
        }
    }
    
    $(document).ready(function(){
        // MAPPA

        // Imposta dimensione della mappa
        $('#mapModal').on('show.bs.modal', function(){
            setTimeout(function() {
                mapGlobal.invalidateSize();
            }, 500);
        });

        // Imposta dimensione della mappa
        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            if(searchMapGlobal !== null){
                setTimeout(function() {
                    searchMapGlobal.invalidateSize();
                    searchMapGlobal.fitBounds(markers.getBounds());
                }, 500);
            }
        });

        markerListClick = function(e){
            var id = $(e.currentTarget).data('id');
            var m = markerMap[id];
            markers.zoomToShowLayer(m, function() { m.fire('click');});
            e.preventDefault();
        };
        // /MAPPA

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
            
            showHideDependentFields();
            
            // Visualizzo i dati caricati //
            $("#loading").hide();
            $("#search").show();
            
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
            
            // search( null );
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
        
        // Ricarica lanciata su radio button //
        $(".fct_radio_btn").click(function(event){
            var radio_input = $(this).attr('name');
            radio_input = radio_input.replace('_radio_btn', '');
            
            $("#"+radio_input).val( $(this).val() );
            
            search(event);
        });
        
        // Ricarica lanciata su checkbox //
        $(".fct_checkbox").click(function(event){
            var input_field = $(this).data('input-field');
            
            if($(this).prop('checked')){
                $("#"+input_field).val( $(this).val() );
            }
            else{
                $("#"+input_field).val( '' );
            }
            
            console.log($("#"+input_field).val());
            
            search(event);
        });

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
                $("#{$fct}").val("");
                $("#{$fct}").show();
                $("#{$fct}_choosen").hide("");
            {/foreach}
            {literal}
            
            search(event);

            // ricarico la pagina
            //location.reload();
        });
        
        search( null );
        
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