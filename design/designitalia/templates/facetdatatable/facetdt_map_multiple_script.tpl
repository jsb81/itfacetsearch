{set_defaults( hash(
    'export_attributes', '',
))}

{literal}
<script>
    var mapGlobal = null;
    var searchMapGlobal = null;
    var geojsonLayer = null;
    var markers = null;
    var markerMap = {};
    
    // Apertura del modal per la visualizzazione della mappa //
    function showModal(id){
        $("#mapModalLabel").html( $("#map" + id).data('title') );
        
        if(mapGlobal !== null){
            mapGlobal.remove();
        }
        
        var latlng=[$("#map" + id).data('latitude'), $("#map" + id).data('longitude')];
        var map = new L.Map('map');
        // map.scrollWheelZoom.disable();
        var customIcon = L.MakiMarkers.icon({icon: "circle-stroked", color: "#000000", size: "l"});
        var postMarker = new L.marker(latlng,{icon:customIcon});
        postMarker.addTo(map);
        map.setView(latlng, 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="https://openstreetmap.org/copyright">OpenStreetMap</a> contributors'}).addTo(map);
        
        // Scale
        L.control.scale().addTo(map);
        
        // North arrow
        var north = L.control({position: "topright"});
        north.onAdd = function(map) {
            var div = L.DomUtil.create("div", "info legend");
            div.innerHTML = '<img src="/extension/itfacetsearch/design/standard/images/north-arrow.png" width=50 height=72 />';
            return div;
        };
        north.addTo(map);
        
        mapGlobal = map;
        
        $("#mapModal").modal();
    }
    
    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    var class_identifier = "{/literal}{$classes}{literal}";
    var class_attributes = "{/literal}{$class_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = {/literal}{$node.node_id}{literal};
    var locations_attribute = "{/literal}{$locations_attribute}{literal}";
    var show_datatable = false;
    
    
    // Imposta le faccette per le select options
    function setSelectFacet( facet, item, selected_item_value ){
        
        item.html('<option value="">'+item.data("placeholder")+'</option>');

        if( facet !== null ){
            $.each(facet.countList, function( _label, _count ){
                var _disabled = false;
                if(_count === 0){
                    _disabled = true;
                }

                if(_label !== ''){
                    if(selected_item_value === _label){
                       item.append($('<option>', { 
                            value: _label,
                            text : _label + ' (' +  _count +  ')',
                            disabled: _disabled,
                            selected: ''
                        })); 
                    }
                    else{
                        item.append($('<option>', { 
                            value: _label,
                            text : _label + ' (' +  _count +  ')',
                            disabled: _disabled
                        }));
                    }
                }

            });
        }
    }
    
    $(document).ready(function(){
        // <MAPPA>
        var previousMapSearch = null;
        
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
        
        // Rigenera la mappa in base alla ricerca //
        function searchMapReload(){
            $("#searchMap_loading").show();
            $("#searchMap").hide();
            
            if(previousMapSearch !== null){
                previousMapSearch.abort();
            }
            
            previousMapSearch = $.ajax({
                 "type": "GET",
                 "url": "https://"+siteURL+"/facetsearch/geo_search/" + class_identifier + "/" + facet_attributes +"/" + node_id  + "/" + locations_attribute,
                 "data": $('#search_form').serialize(),
                 "success": function( result ){
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
            });
            
        }
        
        // </MAPPA>
        
        var dataTable = $("#datatable_content").DataTable({
             "processing": true,
             "serverSide": true,
             "bFilter": false,
             "ajax": {
                 "type": "GET",
                 "url": "https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id,
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
             "bLengthChange": false,
             "bInfo" : false // Nasconde il numero di righe visualizzate
        });
        
        
        // Aggiorno le Faccette //
        $("#datatable_content").on('xhr.dt', function(e, settings, result, xhr){
            
            {/literal}
                {foreach $facet_attributes|explode('|') as $index => $fct}
                    setSelectFacet( (result.FacetFields !== null?result.FacetFields[{$index}]:null), $("#{$fct}"), result.GET['{$fct}'] );
                {/foreach}
            {literal}
            
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
        
        // Aggiorna la ricerca //
        function search(event){
            
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
            
            console.log("https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id);
            
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
            
        }
        
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
        });
        
        search( null );
        
        // Esporta i risultati su CSV
        $("#export_list").click(function(event){
            var spinner = '<i class="fa fa-spinner fa-spin"></i>';
            var original_html = $(this).html();
            $(this).html( $(this).html() +  spinner );
             class_attributes = "{/literal}{$export_attributes}{literal}";

            var csv_download = "https://"+siteURL+"/facetsearch/datatable_search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id + "/CSV";
            csv_download        += '?' + $('#search_form').serialize();

            document.location.href = csv_download;

            $(this).html( original_html );
        });
        
        // Daterange
        $(function() {
            var days = 'Dom_Lun_Mar_Mer_Gio_Ven_Sab'.split('_');
            var months = 'Gen_Feb_Mar_Apr_Mag_Giu_Lug_Ago_Set_Ott_Nov_Dic'.split('_');

            var start = moment().startOf('year');
            var end = moment().endOf('year');

            function cb(start, end) {
                $('#reportrange span').html( start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY') );
                $('#daterange').val( start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD') );
                
                search( null );
            }

            $('#reportrange').daterangepicker({
                startDate: start,
                endDate: end,
                format: 'DD/MM/YYYY',
                locale: {     
                    opens: 'center',            
                    firstDay: 1,
                    daysOfWeek: days,
                    monthNames: months,
                    applyLabel: 'Applica',
                    cancelLabel: 'Annulla',
                    fromLabel: 'Dal',
                    toLabel: 'Al',
                    weekLabel: 'W',
                    customRangeLabel: 'Seleziona date',
                    format: 'DD/MM/YYYY'
                },
                ranges: {
                   'Oggi': [moment(), moment()],
                   'Domani': [moment().add(1, 'days'), moment().add(1, 'days')],
                   'Prossimi 7 Giorni': [moment(), moment().add(7, 'days')],
                   'Prossimi 30 Giorni': [moment(), moment().add(30, 'days')]
                }
            }, cb);

            cb(start, end);

            $('#reportrange_btn').click(function( event ){
                $('#reportrange').trigger("click");
                event.preventDefault();
            });
        });
        
    });
    
</script>
{/literal}