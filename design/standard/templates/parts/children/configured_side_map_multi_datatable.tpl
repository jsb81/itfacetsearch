{ezscript_require( array( 'leaflet.js') )}
{ezcss_require( array( 'leaflet.css' ) )}
{ezscript_require( array( 'ezjsc::jquery', 'leaflet.markercluster.js', 'Leaflet.MakiMarkers.js' ) )}
{ezcss_require( array( 'plugins/leaflet/map.css', 'MarkerCluster.css', 'MarkerCluster.Default.css' ) )}

{def $class_attributes=''
     $facet_attributes=''}

<div class="u-facet-side">
    
    <div class="u-facet-title">
        <div class="Grid">
            <div class="u-facet-heading">
                <h1>{$node.name|wash()}</h1>
            </div>
            <div id="numRows" class="u-facet-result-count">
                
            </div>
        </div>
    </div>
            
    <div id="loading" class="Grid-cell u-textCenter">
        <i class="fa fa-spin fa-circle-o-notch fa-3x"></i>
    </div>
            
     <div id="search" class="u-facet-form" style="display: none;">

        <form id="search_form" class="Form">

            <div class="Grid">
                        
                {include uri='design:facetdatatable/facetdt_query_xs.tpl' cell='u-facet-form-cell' query_label=concat('Search'|i18n('designitalia'),'...')}
                
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
                
                {foreach $facet_search_attributes as $search_attribute}
                    {if $search_attribute.type|eq(1)}
                        {if $search_attribute.attribute_datatype|eq(1)}
                            {* INPUT *}
                        {elseif $search_attribute.attribute_datatype|eq(2)}
                            {* SELECT *}
                            {include uri='design:facetdatatable/facetdt_select.tpl' cell='u-facet-form-cell' attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {elseif $search_attribute.attribute_datatype|eq(3)}
                            {* DATE *}
                            {include uri='design:facetdatatable/facetdt_daterange.tpl' cell='u-facet-form-cell' attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {/if}
                        
                        {if $facet_attributes|eq('')}
                            {set $facet_attributes=$search_attribute.attribute_identifier}
                        {else}
                            {set $facet_attributes=concat($facet_attributes, '|', $search_attribute.attribute_identifier)}
                        {/if}
                    {/if}
                {/foreach}
                
                <div class="u-facet-form-cell">
                    <a id="reset_button" class="pull-right" style="cursor: pointer;">
                        {'Reset Filters'|i18n('designitalia/full')}
                    </a>
                </div>
                        
            </div> <!-- .Grid -->
            
        </form> <!-- .Form -->
                            
    </div> <!-- .u-facet-form -->
    
    
    <div class="u-facet-table" id="datatable" style="display: none;">
        <!-- MAPPA -->
        <div id="searchMap_loading" class="text-center">
            <p>
                Caricamento mappa
                <i class="fa fa-spinner fa-spin fa-2x"></i>
            </p>
        </div>
        <div id="searchMap" style="width: 100%; height: 700px" style="display:none;"></div>
        
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
    </div>
        
   
    
</div> <!-- .u-facet -->
                    
{include uri='design:facetdatatable/facetdt_map_multiple_script.tpl' 
         classes=$content_class
         class_attributes=$class_attributes
         facet_attributes=$facet_attributes
         locations_attribute='dove'
         single_result_count_name=$configured_facet_search.single_res
         multiple_result_count_name=$configured_facet_search.multiple_res}
         