{if $node|has_attribute('allegato')}
    {*attribute-view-gui $node|attribute('link')*}
    
    {def $file = $node|attribute( 'allegato' )
         $url = concat("content/download/",$file.contentobject_id,"/",$file.id,"/file/",$file.content.original_filename)|ezurl(no)}
    
    <a class="Button Button--default" href="{$url}">
        <i class="mdi mdi-download"></i>
        Scarica
    </a>
         
    {undef $url
           $file}
    
{elseif $node|has_attribute('link')}
    {def $url = $node|attribute('link').content}
    
    <a class="Button Button--info" href="{$url}">
        <i class="mdi mdi-link"></i>
        Visita
    </a>
        
    {undef $url}
{/if}