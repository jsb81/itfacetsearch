
{def $class_attributes=''
     $facet_attributes=''}

{if $show_only_childs|not}
<div class="u-content class-{$node.class_identifier}">
    <div class="u-content-main">
        <div class="u-content-title">
            
            <h1>{$node.name|wash()}</h1>

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

            <div class="u-content-date">
                {include uri='design:openpa/parts/full/node_date.tpl'}
            </div>
        </div>

        {def $show_image=false()}
        {if $node|has_attribute( 'show_image' )}
            {if $node.data_map.show_image.content|eq(1) }
                {set $show_image=true()}
            {/if}
        {/if}
        {if and($node|has_attribute( 'image' ), $show_image)}
            {include uri='design:atoms/image.tpl' item=$node image_class=appini( 'ContentViewFull', 'DefaultImageClass', 'wide' ) css_classes="image-main"}
        {/if}

        {undef $show_image}

        {if $node|has_attribute( 'description' )}
            <div class="description Prose">
                {attribute_view_gui attribute=$node|attribute( 'description' )}
            </div>
        {/if}
{/if}
        <!-- ACCORDION -->
        <div class="Accordion Accordion--default fr-accordion js-fr-accordion" id="accordion-1">

            {foreach $node.children as $index =>$child}
                <h2 class="Accordion-header js-fr-accordion__header fr-accordion__header" id="accordion-header-{$index}">
                    <span class="Accordion-link">

                        {foreach $facet_search_attributes as $accordion_attribute}
                            {if $accordion_attribute.type|eq(1)}
                                {if $child|has_attribute($accordion_attribute.attribute_identifier)}
                                    {attribute_view_gui attribute=$child|attribute( $accordion_attribute.attribute_identifier )}
                                {else}
                                    {$child.name|wash}
                                {/if}
                                {break}
                            {/if}
                        {/foreach}
                    </span>
                </h2>

                <div id="accordion-panel-{$index}" class="Accordion-panel fr-accordion__panel js-fr-accordion__panel">
                    <div class="u-color-grey-90 u-text-p u-padding-left-s u-padding-bottom-m">
                            {if $child.can_edit}                                 
                                <a href={$child.url_alias|ezurl} title="Edit {$child.name|wash()}"
                                ><i class="mdi mdi-pencil mdi-12px"></i></a>
                            {/if} 
                        {foreach $facet_search_attributes as $accordion_attribute}
                            
                            {if $accordion_attribute.type|eq(2)}
                                
                                {if $class_attributes|eq('')}
                                    {set $class_attributes=$accordion_attribute.attribute_identifier}
                                {else}
                                    {set $class_attributes=concat($class_attributes, '|', $accordion_attribute.attribute_identifier)}
                                {/if}

                                {if $child|has_attribute($accordion_attribute.attribute_identifier)}
                                    {attribute_view_gui attribute=$child|attribute( $accordion_attribute.attribute_identifier )}
                                {/if}
                            {/if}
                        {/foreach}
                    </div>
                    <div class="u-content-title">
                        <div class="u-content-date u-color-grey-90">
                            {include uri='design:openpa/parts/full/node_date.tpl' node=$child}
                        </div>
                    </div>
                </div>
            {/foreach}

        </div>


{if $show_only_childs|not}
    </div>
        
</div>
{/if}

{* Caricato via template *}
{*include uri='design:facetdatatable/facetdt_accordion_script.tpl'
         classes=$content_class
         class_attributes=$class_attributes
         facet_attributes=''
         single_result_count_name=$configured_facet_search.single_res
         multiple_result_count_name=$configured_facet_search.multiple_res*}