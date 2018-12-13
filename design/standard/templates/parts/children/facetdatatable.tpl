{set_defaults( hash(
    'content_class', false(),
    'is_remote_class', false(),
    'show_only_childs', false(),
    'has_facet_search', false(),
    'grey_background', false(),
    'primary_background', false(),
    'force_filter_panels', false()
))}

{if or($node.children|count()|gt(0), $node.object.class_identifier|eq('remote_content'))}
    {def $children_classes=children_classes($node.node_id)}

    {if $children_classes|count()|eq(1)}
        {set $content_class = $children_classes[0]}
    {/if}

    {if or($children_classes|count()|eq(1), $is_remote_class)}
        {def $content_class_object = class_by_identifier($content_class)
             $contentclass_id = $content_class_object.id
             $configured_facet_search = itfacet_search($contentclass_id)}
    {/if}

    {if $node|has_attribute('gray_background')}
        {set $grey_background = true()}
    {/if}

    {if is_set($configured_facet_search.id)}
        {def $facet_search_attributes = itfacet_search_attribute($configured_facet_search.id)}

        {foreach $facet_search_attributes as $attribute}
            {if $attribute.type|eq(1)}
                {set $has_facet_search = true()}
            {/if}
        {/foreach}
    {/if}

    {if $has_facet_search}
        {if $configured_facet_search.type|eq(1)}
            {include uri=concat('design:parts/children/configured_datatable.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {elseif $configured_facet_search.type|eq(2)}
            {include uri=concat('design:parts/children/configured_map_datatable.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {elseif $configured_facet_search.type|eq(3)}
            {include uri=concat('design:parts/children/configured_side_map_datatable.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {elseif $configured_facet_search.type|eq(4)}
            {include uri=concat('design:parts/children/configured_side_map_multi_datatable.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {elseif $configured_facet_search.type|eq(5)}
            {include uri=concat('design:parts/children/configured_filter_panels.tpl') content_class=$content_class configured_facet_search=$configured_facet_search no_search=true()}
        {elseif $configured_facet_search.type|eq(6)}
            {include uri=concat('design:parts/children/configured_filter_panels.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {elseif $configured_facet_search.type|eq(7)}
            {include uri=concat('design:parts/children/configured_accordion.tpl') content_class=$content_class configured_facet_search=$configured_facet_search}
        {/if}
    {elseif or($children_classes|count()|gt(1), $force_filter_panels)}
        {include uri=concat('design:parts/children/configured_filter_panels.tpl')}
    {else}
        {* OLD METHOD *}
        {include uri=concat('design:parts/children/facetdatatable/', $content_class, '.tpl')}
    {/if}
{/if}
