
{def $class_attributes=''
     $facet_attributes=''}
     
<div class="u-facet">
    
    <div class="u-facet-title">
        <div class="Grid">
            <div class="u-facet-heading">
                <h1>{$node.name|wash()}</h1>
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
                        
                {include uri='design:facetdatatable/facetdt_query.tpl' cell=$search_cols query_label=concat('Search'|i18n('designitalia'),'...')}
                
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
                        {/if}
                        
                        {if $facet_attributes|eq('')}
                            {set $facet_attributes=$search_attribute.attribute_identifier}
                        {else}
                            {set $facet_attributes=concat($facet_attributes, '|', $search_attribute.attribute_identifier)}
                        {/if}
                        
                        {if $search_attribute.attribute_datatype|eq(4)}
                            {set $facet_attributes = concat($facet_attributes, ';-1')}
                        {/if}
                        
                        {undef $attribute_cols}
                    {/if}
                {/foreach}

                {*
                Spostato sotto
                <div class="u-facet-form-cell-half">
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


{include uri='design:facetdatatable/facetdt_script.tpl' 
         classes=$content_class
         class_attributes=$class_attributes
         facet_attributes=$facet_attributes
         single_result_count_name=$configured_facet_search.single_res
         multiple_result_count_name=$configured_facet_search.multiple_res}