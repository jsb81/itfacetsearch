
<script>
    {literal}
    $(document).ready(function () {
    {/literal}

        var siteURL = '{ezini( 'SiteSettings', 'SiteURL'  )}';

        {foreach $node.children as $child}
            var object_id = '{$child.contentobject_id}';
            {literal}
            $.ajax({
                url: 'https://'+siteURL+'/index/object/' + object_id,
                success: function(result){

                }
            });
            {/literal}
        {/foreach}

    {literal}
    })
    {/literal}


</script>