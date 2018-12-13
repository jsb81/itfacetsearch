{literal}
<script>
    var siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    var class_identifier = "{/literal}{$classes}{literal}";
    var class_attributes = "{/literal}{$class_attributes}{literal}";
    var facet_attributes = "{/literal}{$facet_attributes}{literal}";
    var node_id = {/literal}{$node.node_id}{literal};

    $(document).ready(function(){

        $.ajax({
            "type": "GET",
            "url": "https://"+siteURL+"/facetsearch/search/" + class_identifier + "/" + class_attributes + "/" + facet_attributes + "/" + node_id,
            success: function(data) {
                showAccordion(data);
            }
        });
        
    });
    
</script>
{/literal}