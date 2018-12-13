<div class="{$cell}">
    <div class="Form-field Form-field--withPlaceholder Grid">
        <select class="Form-input Grid-cell u-sizeFill u-text-r-s u-border-none" 
                id="{$attr_id}" 
                name="{$attr_id}" 
                data-placeholder="{$attr_name}">
            <option value="" selected>{$attr_name}</option>
        </select>

        <div class="Form-input Grid-cell u-sizeFill u-text-r-s u-border-none chosen-container chosen-container-single" 
             style="width: 100%; display: none;" 
             id="{$attr_id}_choosen">
            <a class="chosen-single chosen-single-with-deselect"
               style="background-image: none; border: none; box-shadow: none; padding: 0 0 0 4px;">
                <span id="{$attr_id}_value"></span>
                <abbr id="{$attr_id}_reset" class="search-choice-close"></abbr>
            </a>
        </div>

    </div>
</div>


