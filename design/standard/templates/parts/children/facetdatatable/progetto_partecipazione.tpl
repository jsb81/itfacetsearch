{ezscript_require( array( 'leaflet.js') )}
{ezcss_require( array( 'leaflet.css' ) )}
{ezscript_require( array( 'ezjsc::jquery', 'leaflet.markercluster.js', 'Leaflet.MakiMarkers.js' ) )}
{ezcss_require( array( 'plugins/leaflet/map.css', 'MarkerCluster.css', 'MarkerCluster.Default.css' ) )}

{def $currentUser = fetch( 'user', 'current_user' )}

<div class="content-view-full class-{$node.class_identifier} row">
    
    <div id="loading" class="col_md-12 text-center">
        <i class="fa fa-spinner fa-spin fa-3x"></i>
    </div>
    
    <div id="numRows" class="pull-right">

    </div>
    
    <div class="row">
        
        <div id='search' class="col-md-12" style="display: none;">
            
            <form id="search_form">
                <div class="searchform" style="padding-top: 20px;">
                    <div class="row">
                        {include uri='design:facetdatatable/facetdt_query.tpl' cols=6 query_label='Ricerca libera'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=6 attr_id='ambito' attr_name='Ambito'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=6 attr_id='modalita' attr_name='Modalità'}
                        
                        {include uri='design:facetdatatable/facetdt_select.tpl' cols=6 attr_id='ente' attr_name='Ente'}
                        
                        <div class="form_group col-md-12">
                            <button type="button" id="reset_button" class="btn btn-success pull-right" style="display: none;">
                                Azzera Filtri
                            </button>
                        </div>
                        
                    </div> {* row *}
                </div>
                
            </form><!-- form -->
            
        </div> <!-- .col-md-12 -->
        
    </div> <!-- .row -->
    
    
    
    <div class="row">
        <div id='datatable' class="col-md-12" style="display: none;">
            <button id="export_list" class="btn btn-primary pull-right" role="button">
                Esporta Risultati
                <i class="fa fa-table"></i>
            </button>
            
            {* TABELLA *}
            <table class="table table-striped" id="datatable_content" width="100%">
                <thead>
                    <tr>
                        <th>Iniziativa di partecipazione</th>
                        <th>Numero Progetti</th>
                        <th>Mappa</th>
                    </tr>
                </thead>
            </table>
            
            {* MAPPA *}
            <div id="searchMap_loading" class="text-center">
                <p>
                    Caricamento mappa
                    <i class="fa fa-spinner fa-spin fa-2x"></i>
                </p>
            </div>
            <div class="u-margin-top-m u-margin-bottom-m" id="searchMap" style="width: 100%; height: 700px" style="display:none;"></div>
        </div>
    </div> <!-- .row -->
    
</div> <!-- .content-view-full -->

<!-- Modal della Mappa -->
<div class="modal fade" id="mapModal" tabindex="-1" role="dialog" aria-labelledby="mapModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="mapModalLabel"></h4>
      </div>
      <div class="modal-body">
        <div id="map" style="width: 100%; height: 400px;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
      </div>
    </div>
  </div>
</div>

{include uri='design:facetdatatable/facetdt_map_script.tpl' 
         classes='progetto_partecipazione'
         class_attributes='titolo|$CHILDS_COUNT$|geo'
         facet_attributes='ambito|modalita|ente'
         single_result_count_name='iniziativa trovata'
         multiple_result_count_name='iniziative trovate'
         export_attributes='titolo|ambito|modalita|ente|sede'}
