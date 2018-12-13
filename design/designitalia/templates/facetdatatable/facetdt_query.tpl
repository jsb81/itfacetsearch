{if $cell|ne('hide')}
<div class="{$cell}">
    <div class="Form-field Form-field--withPlaceholder Grid" role="search">
        <input class="Form-input Grid-cell u-sizeFill u-text-r-s u-border-none" 
               type="text"
               id="query" 
               name="query"
               placeholder="{$query_label}">

        <button class="Grid-cell u-sizeFit u-background-60 u-color-white u-padding-all-xs u-textWeight-700 mdi mdi-magnify mdi-24px" 
                title="Start searching" aria-label="Start searching" id="buttonquerysearch">
        </button>
    </div>
</div>
{/if}