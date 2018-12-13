{set_defaults( hash('nodename', $node.name) )}

{ezscript_require( array( 'leaflet.js') )}
{ezcss_require( array( 'leaflet.css' ) )}
{ezscript_require( array( 'ezjsc::jquery', 'leaflet.markercluster.js', 'Leaflet.MakiMarkers.js' ) )}
{ezcss_require( array( 'plugins/leaflet/map.css', 'MarkerCluster.css', 'MarkerCluster.Default.css' ) )}

{def $class_attributes=''
     $facet_attributes=''
     $export_attributes=''}

<div class="u-facet">
    
    <div class="u-facet-title">
        <div class="Grid">
            <div class="u-facet-heading">
                <h1>{$nodename|wash()}</h1>
            </div>
            <div id="numRows" class="u-facet-result-count">
                
            </div>
        </div>
        {if $node|has_attribute('short_name')}
            <div class="u-margin-bottom-l u-textItalic" style="text-align: justify; font-size: 2rem!important;">
                {attribute_view_gui attribute=$node|attribute('short_name')}
            </div>
        {/if}

        {if $node|has_attribute( 'short_description' )}
            <div class="u-content-abstract">
                {attribute_view_gui attribute=$node|attribute( 'short_description' )}
            </div>
        {/if}
         
        {if $node|has_attribute( 'description' )}
            <div class="description Prose">
                {attribute_view_gui attribute=$node|attribute( 'description' )}
            </div>
        {/if}
    </div>
            
    <div id="loading" class="Grid-cell u-textCenter">
        <i class="fa fa-spin fa-circle-o-notch fa-3x"></i>
    </div>
            
     <div id="search" class="u-facet-form" style="display: none;">
        {include uri=concat('design:parts/children/filter_for.tpl')}
        <form id="search_form" class="Form">

            <div class="Grid">
                
                {def $search_cols = 'u-facet-form-cell'}
                        
                {switch match=$configured_facet_search.search_cols}
                    {case match=1}
                        {set $search_cols = 'u-facet-form-cell'}
                    {/case}
                    {case match=2}
                        {set $search_cols = 'u-facet-form-cell-half'}
                    {/case}
                    {case match=4}
                        {set $search_cols = 'u-facet-form-cell-wide'}
                    {/case}
                    {case match=100}
                        {set $search_cols = 'hide'}
                    {/case}
                {/switch}
                
                {include uri='design:facetdatatable/facetdt_query_xs.tpl' cell=$search_cols query_label=concat('Search'|i18n('designitalia'),'...')}
                
                {undef $search_cols}
                
                {foreach $facet_search_attributes as $search_attribute}
                    {if $search_attribute.type|eq(1)}
                        {def $attribute_cols = 'u-facet-form-cell'}
                        
                        {switch match=$search_attribute.attribute_cols}
                            {case match=1}
                                {set $attribute_cols = 'u-facet-form-cell'}
                            {/case}
                            {case match=2}
                                {set $attribute_cols = 'u-facet-form-cell-half'}
                            {/case}
                            {case match=4}
                                {set $attribute_cols = 'u-facet-form-cell-wide'}
                            {/case}
                        {/switch}
                        
                        {if $search_attribute.attribute_datatype|eq(1)}
                            {* INPUT *}
                        {elseif $search_attribute.attribute_datatype|eq(2)}
                            {* SELECT *}
                            {include uri='design:facetdatatable/facetdt_select.tpl' cell=$attribute_cols attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {elseif $search_attribute.attribute_datatype|eq(3)}
                            {* DATE *}
                            {include uri='design:facetdatatable/facetdt_daterange.tpl' cell=$attribute_cols attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {elseif $search_attribute.attribute_datatype|eq(4)}
                            {* TAGS *}
                            {include uri='design:facetdatatable/facetdt_tags.tpl' cell=$attribute_cols attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label content_class=$content_class}
                        {elseif $search_attribute.attribute_datatype|eq(5)}
                            {* Radio Button *}    
                            {include uri='design:facetdatatable/facetdt_radiobutton.tpl' cell=$attribute_cols attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label content_class=$content_class}
                        {elseif $search_attribute.attribute_datatype|eq(6)}
                            {* Checkbox *}
                            {include uri='design:facetdatatable/facetdt_checkbox.tpl' cell=$attribute_cols attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label content_class=$content_class}
                        {/if}
                        
                        {if $facet_attributes|eq('')}
                            {set $facet_attributes=$search_attribute.attribute_identifier}
                        {else}
                            {set $facet_attributes=concat($facet_attributes, '|', $search_attribute.attribute_identifier)}
                        {/if}
                        
                        {undef $attribute_cols}
                    {/if}
                {/foreach}
                {*
                Spostato sotto
                <div class="u-facet-form-cell">
                    <label for="show">{'Show'|i18n('designitalia/full')}</label>
                    
                    <select class="Form-input Form-input-inline u-text-r-s u-border-none" 
                            id="show" 
                            name="show">
                        <option value="10" selected>10</option>
                        <option value="25">25</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                </div>
                *}
                    
                <div class="u-facet-form-cell-wide">
                    <a id="reset_button" class="pull-right" style="cursor: pointer;">
                        {'Reset Filters'|i18n('designitalia/full')}
                    </a>
                </div>
            </div> <!-- .Grid -->
            
        </form> <!-- .Form -->
                            
    </div> <!-- .u-facet-form -->
    
    
    <div class="u-facet-table" id="datatable" style="display: none;">
        
        {if $configured_facet_search.export|eq('t')}
        <!-- bottone esporta -->
        <button id="export_list" class="Button Button--default pull-right" role="button">
            Esporta Risultati
            <i class="mdi mdi-table"></i>
        </button>
        {/if}
        
        <!-- TABELLA -->
        <table class="Table Table--striped Table--responsive" id="datatable_content" width="100%">
            <thead>
                <tr>
                {foreach $facet_search_attributes as $table_attribute}
                    {if $table_attribute.type|eq(2)}
                        <th>{$table_attribute.attribute_label}</th>
                        
                        {if $class_attributes|eq('')}
                            {set $class_attributes=$table_attribute.attribute_identifier}
                        {else}
                            {set $class_attributes=concat($class_attributes, '|', $table_attribute.attribute_identifier)}
                        {/if}
                    {/if}
                {/foreach}
                </tr>
            </thead>
        </table>
                
        <!-- MAPPA -->
        <div id="searchMap_loading" class="text-center">
            <p>
                Caricamento mappa
                <i class="fa fa-spinner fa-spin fa-2x"></i>
            </p>
        </div>
        <div id="searchMap" style="width: 100%; height: 700px" style="display:none;" class="u-margin-top-s"></div>
    </div>
        
   
    
</div> <!-- .u-facet -->

<!-- Modal della Mappa usata per il campo $MODAL_MAP$ -->
<div class="modal fade" id="mapModal" tabindex="-1" role="dialog" aria-labelledby="mapModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="mapModalLabel"></h4>
      </div>
      <div class="modal-body">
        <div id="MyCurrentMap" style="width: 100%; height: 400px;"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
      </div>
    </div>
  </div>
</div>


{* Attributi per l'export *}
{foreach $facet_search_attributes as $table_attribute}
    {if $table_attribute.type|eq(3)}
        {if $export_attributes|eq('')}
            {set $export_attributes=$table_attribute.attribute_identifier}
        {else}
            {set $export_attributes=concat($export_attributes, '|', $table_attribute.attribute_identifier)}
        {/if}
    {/if}
{/foreach}
                    
{include uri='design:facetdatatable/facetdt_map_script.tpl' 
         classes=$content_class
         class_attributes=$class_attributes
         facet_attributes=$facet_attributes
         single_result_count_name=$configured_facet_search.single_res
         multiple_result_count_name=$configured_facet_search.multiple_res
         export_attributes=$export_attributes}
         