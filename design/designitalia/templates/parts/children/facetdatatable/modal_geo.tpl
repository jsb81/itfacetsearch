
{* gestione del campo geo*}
{if $geo_item_attr.content.latitude}
    <i  id="map{$geo_item_attr.id}" 
        class="mdi mdi-map-marker mdi-36px 
        u-color-compl" 
        style="cursor: pointer;" 
        onclick="showModal({$geo_item_attr.id})" 
        data-latitude="{$geo_item_attr.content.latitude}" 
        data-longitude="{$geo_item_attr.content.longitude}" 
        data-title="{$geo_item_attr.name}">
    </i>
{/if}