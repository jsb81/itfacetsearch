<div class="{$cell}">
    {def $facet_attribute = concat($content_class, '/', $attr_id)}
    {if $attr_id|begins_with('extra')}
       {set $facet_attribute = concat( $attr_id )} 
    {/if}
    
    {def $radio_buttons = fetch('ezfind', 'search', hash( 'query', ''
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
        $radio_buttonsList = $radio_buttons.SearchExtras.facet_fields[0].nameList}
        
    <fieldset class="Form-field Form-field--choose Grid-cell fct_radio_fieldset" id="{$attr_id}_radio_fieldset">
        
        {foreach $radio_buttonsList as $index => $radio_button}
            
            {if $radio_button|ne('')}
                <label class="Form-label Form-label--block">
                    <input type="radio" class="Form-input fct_radio_btn" name="{$attr_id}_radio_btn" aria-required="true" value="{$radio_button}" required>
                    <span class="Form-fieldIcon" role="presentation"></span> {$radio_button}
                </label>
            {/if}
            
        {/foreach}
        
        <input type="hidden" id="{$attr_id}" name="{$attr_id}" />
    </fieldset>
    
    {undef $facet_attribute
           $radio_buttons
           $radio_buttonsList}
</div>