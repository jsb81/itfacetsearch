<div class="form-group col-md-{$cols}">
    <label for="anno">{$attr_name}</label>
    <select class="form-control" id="{$attr_id}" name="{$attr_id}">
        <option value="" selected>(Tutti)</option>
        {*da caricare asincroni*}
    </select>

    <div class="form-control chosen-container chosen-container-single" 
         style="width: 100%; display: none;" 
         id="{$attr_id}_choosen">
        <a class="chosen-single chosen-single-with-deselect"
           style="background-image: none; border: none; box-shadow: none; padding: 0 0 0 4px;">
            <span id="{$attr_id}_value"></span>
            <abbr id="{$attr_id}_reset" class="search-choice-close"></abbr>
        </a>
    </div>
</div>