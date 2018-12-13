<div class="{$cell}">
    <input id="{$attr_id}" name="{$attr_id}" type="hidden" class="fct_toggle_input">
    
    <ul class="facet-tags">
        {def $tags = fetch('ezfind', 'search', hash( 'query', ''
                                                    , 'facet', array(hash( 'field', concat($content_class, '/', $attr_id)
                                                                         , 'limit', 1000
                                                                         , 'sort', 'alpha'
                                                                         , 'mincount', 0
                                                                         )
                                                                    )
                                                    , 'class_id', array($content_class) 
                                                    , 'subtree_array', array($node.node_id)
                                                    ) 
                                )
             $active_extensions = ezini('ExtensionSettings','ActiveAccessExtensions')
             $do_sort = $active_extensions|contains('ittagsnewsletter')
             $tags_nameList = $tags.SearchExtras.facet_fields[0].nameList}
             
             
        
        {foreach $tags_nameList as $index => $tag}
            
            {if $tag|ne('')}
                
                {def $tags = false()
                     $sort_order = 0}
                
                {if $do_sort}
                    {set $tags = fetch( 'tags', 'tags_by_keyword', hash( 'keyword', $index ) )}
                    {if $tags|not}
                        {set $tags = fetch( 'tags', 'tags_by_keyword', hash( 'keyword', $index|upfirst() ) )}
                    {/if}

                    {if $tags}
                        {set $sort_order = get_tag_sort_order($tags.0.id).sort_order}
                    {/if}
                {/if}
                
                <li class="u-inlineBlock" data-position="{$sort_order}">
                    <button id="tag_opt_{$index|explode(' ')|implode('_')}"
                            type="button" 
                            class="Button Button--default Button--s fct_toggle_button" 
                            data-value="{$tag}">
                        <i class="mdi mdi-checkbox-blank-outline"></i>
                        {$tag}
                    </button>
                </li>
            {/if}
            
        {/foreach}
        
        {* Se ittagsnewsletter è attiva posso usare la funzione di ordinamento tags *}
        {if $do_sort}
            {literal}
                <script>
                    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
                    
                    // callback per ordinamento
                    function sort_li(a, b){
                        console.log($(b).attr('id') + " - " +  $(b).data('position') + " -- " + $(a).data('position'));
                        
                        return ($(b).data('position')) < ($(a).data('position')) ? 1 : -1;    
                    }
                    
                    $(".facet-tags li").sort( sort_li ).appendTo('.facet-tags');
                </script>
            {/literal}
        {/if}
        
        {undef $tags}
    </ul>
</div>
    
