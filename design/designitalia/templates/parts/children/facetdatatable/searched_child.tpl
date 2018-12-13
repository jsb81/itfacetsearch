{*
Nel caso l'elemento trovato contenga un solo figlio oppure la query di ricerca
contenga una stringa contenuta nel nome di un figlio questo viene visualizzato.
*}


{def $searched_child = false()}

{if $children|count|eq(1)}
    {set $searched_child=$children[0]}
{else}
    {foreach $children as $child}
        {if $child.name|upcase()|contains( $query|upcase() )}
            {set $searched_child=$child}
        {/if}
    {/foreach}
{/if}

{if $searched_child}
    {* Word is Reech One*}
    {if or($searched_child.class_identifier|eq('istituto'), $searched_child.class_identifier|eq('scuola'))}
    <a href="https://{ezini('SEI', 'Url', 'vivoscuola.ini')}/sei/#/soggetto/{$searched_child|attribute('codiceprovinciale').data_text}/scuola/chi-siamo">
    {else}
    <a href={concat('content/view/full/',$searched_child.node_id)|ezurl}>
    {/if}
    {* /Word is Reech One*}
        <nobr>{$searched_child.name}</nobr>
    </a>
{/if}