{set_defaults( hash(
    'columns', false(),
    'class_attributes', '',
    'facet_attributes', '',
    'classes', '',
    'search_by_date', false()
))}

{if $columns}
    {* NOTHING TO DO *}
{elseif $site_columns|eq('3')}
    {set $columns = 'u-sm-size1of2 u-md-size1of3 u-lg-size1of3'}
{elseif $site_columns|eq('4')}
    {set $columns = 'u-sm-size1of2 u-md-size1of3 u-lg-size1of4'}
{/if}

<div class="u-content
            class-{$node.class_identifier}
            {if $grey_background}u-content-background-grey {elseif $primary_background}u-content-background-primary{/if}">
    <div class="u-content-main {if $layout_wide}u-layoutCenter u-layout-wide{/if}">
        <div class="u-content-title">
            <h1>{$node.name|wash()}</h1>

            {* TODO: sottotitolo/abstract *}
        </div>

        <form id="search_form" class="u-content-search">
            <div class="u-content-search-label">
                <span>Ricerca:</span>
            </div>

            <div class="u-content-search-class">
                {def $content_class_object = false()
                     $class_icon = ezini('ClassIcon', 'Icon', 'class_icon.ini')
                     $icon = $class_icon['default']}
                {foreach $children_classes as $class_identifier}
                    {set $content_class_object = class_by_identifier($class_identifier)}

                    {if $children_classes|count()|gt(1)}
                        <button class="select_class" data-classidentifier="{$class_identifier}" type="button">
                            {if is_set($class_icon[$class_identifier])}
                                {set $icon = $class_icon[$class_identifier]}
                            {/if}

                            <i class="fa fa-{$icon}"></i>
                            {$content_class_object.name}
                        </button>
                    {/if}

                    {if $classes|eq('')}
                        {set $classes = $class_identifier}
                    {else}
                        {set $classes = concat($classes, '|', $class_identifier)}
                    {/if}
                {/foreach}
                {undef $content_class_object}
            </div>
            <div class="u-content-search-date">
                <button id="reportrange"  style="cursor: pointer;" type="button">
                    <i class="fa fa-calendar-alt"></i>
                    <span id="date-range">Cerca data</span>
                    <i class="fa fa-chevron-down"></i>
                </button>

                <input type="hidden" id="daterange" name="daterange_published"/>
            </div>
            <div class="u-content-search-string">
                <input id="query" name="query" class="Form-input" placeholder="Cerca..." style="color:black;">
            </div>
        </form>

        <div id="loading" class="Grid-cell u-textCenter u-margin-top-l">
            <i class="fa fa-spin fa-spinner fa-3x"></i>
        </div>

        <div id="resultPanels" class="u-content-panels u-margin-top-l Grid Grid--withGutter" style="display: none;">
            Caricamento...
        </div>

        <div id="resultPaging" class="Grid" style="display: none;">
            <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
                <nav role="navigation" aria-label="Navigazione paginata" class="u-layout-prose">
                    <ul id="resultPagingList" class="Grid Grid--fit Grid--alignMiddle u-text-r-xxs">

                        <li class="Grid-cell u-textCenter">
                            <a href="#" id="prevPage" class="page_link u-color-50 u-textClean u-block" title="Pagina precedente">
                                <span class="Icon-chevron-left u-text-r-s" role="presentation"></span>
                            </a>
                        </li>

                        <li class="Grid-cell u-textCenter u-hidden u-md-inlineBlock u-lg-inlineBlock">
                            <a href="#" id="page1" class="page_link u-padding-r-all u-textClean u-block u-color-50">
                                <span class="u-text-r-m">?</span>
                            </a>
                        </li>
                        <li class="Grid-cell u-textCenter u-hidden u-md-inlineBlock u-lg-inlineBlock">
                            <a href="#" id="page2" class="page_link u-padding-r-all u-textClean u-block u-color-50">
                                <span class="u-text-r-s">?</span>
                            </a>
                        </li>
                        <li class="Grid-cell u-textCenter u-hidden u-md-inlineBlock u-lg-inlineBlock">
                            <a href="#" id="page3" class="page_link u-padding-r-all u-textClean u-block u-color-50">
                                <span class="u-text-r-m">?</span>
                            </a>
                        </li>
                        <li class="Grid-cell u-textCenter u-hidden u-md-inlineBlock u-lg-inlineBlock">
                            <a href="#" id="page4" class="page_link u-padding-r-all u-textClean u-block u-color-50">
                                <span class="u-text-r-s">?</span>
                            </a>
                        </li>
                        <li class="Grid-cell u-textCenter u-hidden u-md-inlineBlock u-lg-inlineBlock">
                            <a href="#" id="page5" class="page_link u-padding-r-all u-textClean u-block u-color-50">
                                <span class="u-text-r-s">?</span>
                            </a>
                        </li>

                        <li class="Grid-cell u-textCenter">
                            <a href="#" id="nextPage" class="page_link u-padding-r-all u-color-50 u-textClean u-block" title="Pagina successiva">
                                <span class="Icon-chevron-right u-text-r-s" role="presentation"></span>
                            </a>
                        </li>

                    </ul>
                </nav>
            </div>
            <div class="Grid-cell u-md-size1of2 u-lg-size1of2 u-textRight">
                <h3 class="u-records-found"><span id="recordsTotal">?</span> risultati trovati</h3>
            </div>
        </div>
    </div>
</div>

{include uri='design:facetdatatable/facetdt_panel_script.tpl'
         classes=$classes
         class_attributes=''
         facet_attributes=''
         single_result_count_name=''
         multiple_result_count_name=''
         search_by_date=$search_by_date}


{undef $columns}
