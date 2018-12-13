
// Imposta le faccette per i toggle buttons
function setToggleButtonFacet( facet, item, selected_item_value ){
    if( facet !== null ){
        $.each(facet.countList, function( _label, _count ){
            var _disabled = false;
            if(_count === 0){
                _disabled = true;
            }

            if(_label !== ''){
                $(".fct_toggle_button").each(function(key, value){
                    if( $(this).data('value') === _label ){
                        if(_disabled){
                            $(this).addClass("is-disabled");
                        }
                        else{
                            $(this).removeClass("is-disabled");
                        }
                    }
                });
            }
        });
    }
}

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

// Apertura del modal per la visualizzazione della mappa //
function showModal(id){
    $("#mapModalLabel").html( $("#map" + id).data('title') );


    if(mapGlobal !== null){
        mapGlobal.remove();
    }

    var latlng=[$("#map" + id).data('latitude'), $("#map" + id).data('longitude')];
    var map = new L.Map('MyCurrentMap');
    // map.scrollWheelZoom.disable();
    var customIcon = L.MakiMarkers.icon({icon: "circle-stroked", color: "#83b81a", size: "l"});
    var postMarker = new L.marker(latlng,{icon:customIcon});

    postMarker.addTo(map);
    map.setView(latlng, 18);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {maxZoom: 18,attribution: '&copy; <a href="https://openstreetmap.org/copyright">OpenStreetMap</a> contributors'}).addTo(map);

    $("#mapModal").modal();

    mapGlobal = map;


}

// Imposta i dati contenuti in un accordion
function showAccordion( data ){
    var accordion_data = '';
    $.each(data.data, function (index, value) {
        let row = '';
        row += '<h2 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-' + index + '">' + '\n';
        row += '    <span class="Accordion-link">' + value.name + '</span>' + '\n';
        row += '</h2>' + '\n';

        row += '<div id="accordion-panel-' + index + '" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">' + '\n';

        row += '    <p class="u-layout-prose u-color-grey-90 u-text-p u-padding-r-all">' + '\n';

        row += 'value';
        // $.each(value.attributes, function (attribute_index, attribute_value) {
        //      row += attribute_value + '\n';
        // });

        row += '    </p>' + '\n';

        row += '</div>' + '\n';

        accordion_data += row + '\n';
    });

    $("#accordion-1").html(accordion_data);

    $("#loading").hide();
    $("#accordion-1").show();
}