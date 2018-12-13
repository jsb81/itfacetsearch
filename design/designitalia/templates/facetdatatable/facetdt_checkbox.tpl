
{* 
    Una vera MERDA FRACCATA! da usare solo su Vivoscuola per cerca scuole
*}

<div class="{$cell}">
    {def $facet_attribute = concat($content_class, '/', $attr_id)}
    {if $attr_id|begins_with('extra')}
       {set $facet_attribute = concat( $attr_id )} 
    {/if}
    
    {def $check_boxes = fetch('ezfind', 'search', hash( 'query', ''
                                                        , 'facet', array(hash( 'field', concat($facet_attribute)
                                                                             , 'limit', 1000
                                                                             , 'sort', 'alpha'
                                                                             , 'mincount', 0
                                                                             )
                                                                        )
                                                        , 'class_id', array($content_class) 
                                                        , 'subtree_array', array($node.node_id)
                                                        ) 
                                )
        $check_boxesList = $check_boxes.SearchExtras.facet_fields[0].nameList}
    
    <fieldset class="Form-field Form-field--choose Grid-cell fct_checkbox_fieldset">
        
        {foreach $check_boxesList as $index => $checkbox}
            
            {if $checkbox|eq('Serale')}
                <label class="Form-label Form-label--block" for="{$attr_id}_{$index}">
                    <input type="checkbox" class="Form-input fct_checkbox" id="{$attr_id}_{$index}" aria-required="true" value="{$checkbox}" data-input-field="{$attr_id}" required>
                    <span class="Form-fieldIcon" role="presentation"></span> Formazione per adulti
                </label>
            {/if}
            
        {/foreach}
        
        <input type="hidden" id="{$attr_id}" name="{$attr_id}" />
    </fieldset>
        
    
    {undef $facet_attribute
           $radio_buttons
           $radio_buttonsList}
</div>