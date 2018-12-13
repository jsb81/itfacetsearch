{literal}
<script>
    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    
    var numClasses = 0;
    var remoteClasses = [];
       
    function getActionButton(content_class_id, content_class_identifier){
        var action = '<a href="../facetsearch/import/'+content_class_id+'/'+content_class_identifier+'" class="Button Button--danger Button--s"><i class="mdi mdi-briefcase-download"></i></a>';
        
        // if(content_class_identifier === 'comunicato'){
            let object_sync_client = '../itobjectsync/client/' + content_class_identifier;
            action += ' <a href="' + object_sync_client + '" class="Button Button--compl Button--s"><i class="mdi mdi-tag-multiple"></i></a>';
        // }
        
        return action;
    }
    
    $(document).ready(function(){
       
        {/literal}
            {foreach $repositories as $repository}
                {def $class = fetch( 'content', 'class', hash( 'class_id', $repository.contentclass_id ) )}
                
                remoteClasses.push( 
                    [
                        '{$class.identifier}',
                        '{$repository.remote_site_import_url}',
                        getActionButton({$repository.contentclass_id}, '{$class.identifier}')
                    ] 
                );
        
                {undef $class}
            {/foreach}
        {literal}
        
        $("#importObjectsTable").DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.10.16/i18n/Italian.json'
            },
            bFilter: false,
            paging: false,
            lengthChange: false,
            data: remoteClasses,
            columns: [
                {title: "{/literal}{'Class'|i18n('facetconfig')}{literal}"},
                {title: "{/literal}{'Source'|i18n('facetconfig')}{literal}"},
                {title: "{/literal}{'Action'|i18n('facetconfig')}{literal}"}
            ]
        });
        
    });
</script>
{/literal}