{def $content_class=$node|attribute('classe').data_text
     $is_remote_class=true()
     $hide_query=true()
     $remote_attr_identifiers=array()
     $remote_attr_filters=array()}

{if $node|has_attribute('query')}
    {foreach $node|attribute('query').content.rows.sequential as $row}
        {set $remote_attr_identifiers =$remote_attr_identifiers|append($row.columns[0])}
        {set $remote_attr_filters =$remote_attr_filters|append($row.columns[1])}
    {/foreach}
{/if}

{include uri=concat('design:parts/children/facetdatatable.tpl')}



