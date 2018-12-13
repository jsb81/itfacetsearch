{* TODO: Realizzare design per Bootstrap *}

{def $configured_facet_search = itfacet_search($class_id)
     $facet_search_attributes = itfacet_search_attribute($configured_facet_search.id)}
     
{*$configured_facet_search.id*}
{*$facet_search_attributes|attribute('show')*}


<div class="u-facet-side">
    {def $has_search_attributes = false()}
    {foreach $facet_search_attributes as $search_attribute}
        {if $search_attribute.type|eq(4)}
            {set $has_search_attributes = true()}
            {break}
        {/if}
    {/foreach}
    
    
    {if $has_search_attributes|not}
        <div class="Prose Alert Alert--error Alert--withIcon u-layout-prose u-padding-r-bottom u-padding-r-right u-margin-r-bottom" role="alert">
            <h2>
                {'Error'|i18n('facetconfig')}
            </h2>

            <p>
                {'No search attributes configured for this class'|i18n('facetconfig')}
            </p>
        </div>
    {else}
        <div class="u-facet-title">
            <div class="u-facet-heading">
                <h1>
                    {'Import remote objects'|i18n('facetconfig')}
                </h1>
                <h3>
                    {'Class'|i18n('facetconfig')}: {$class_identifier}
                </h3>
            </div>
            <p class="u-margin-bottom-m">
                {'Search objects and import'|i18n('facetconfig')}
            </p>

        </div>
        <div class="u-facet-form">
            <form id="search_form" class="Form">
                {foreach $facet_search_attributes as $search_attribute}
                    {if $search_attribute.type|eq(4)}
                        {if $search_attribute.attribute_datatype|eq(2)}
                            {include uri='design:facetdatatable/facetdt_side_select.tpl' attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {elseif $search_attribute.attribute_datatype|eq(3)}
                            {include uri='design:facetdatatable/facetdt_side_daterange.tpl' attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {else}
                            {include uri='design:facetdatatable/facetdt_side_input.tpl' attr_id=$search_attribute.attribute_identifier attr_name=$search_attribute.attribute_label}
                        {/if}
                    {/if}
                {/foreach}
                
                <div class="u-facet-form-cell">
                    <div class="Form-field u-textRight">
                        <button id="search_button" type="button" class="Button Button--default u-text-xs">
                            <i class="mdi mdi-magnify"></i>
                            {'Search'|i18n('facetconfig')}
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="u-facet-table">
            <table id="result_table" class="Table Table--striped Table--responsive dataTable no-footer">
                <thead>
                    <tr>
                        <td>
                            {'Name'|i18n('facetconfig')}
                        </td>
                        <td>
                            {'Action'|i18n('facetconfig')}
                        </td>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    {/if}
</div>
    
{include uri="design:facetsearch/import_script.tpl"}