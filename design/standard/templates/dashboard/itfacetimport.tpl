<header>
    <h2>
        <i class="mdi mdi-cloud-download"></i>
        {'Import remote objects'|i18n('facetconfig')}
    </h2>
</header>
<hr>

<div>
    <table id="importObjectsTable" class="Table Table--striped Table--responsive" width="100%"></table>
</div>

{def $repositories = itfacet_search_repositories()}

{include uri="design:dashboard/itfacetimport_script.tpl"}

{undef $repositories}