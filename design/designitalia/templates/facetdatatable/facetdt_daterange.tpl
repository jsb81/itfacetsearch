<div class="{$cell}">
    
    {*<label for="{$attr_id}">{$attr_name}</label>*}
    <div class="Form-field Form-field--withPlaceholder Grid">
        <div id="{$attr_id}_date"
             class="Form-input Grid-cell u-sizeFill u-text-r-s u-border-none" 
             style="cursor: pointer;">
            <span>01/01/1970 - 02/01/1970</span> 
            <i class="mdi mdi-chevron-down mdi-24px u-color-60 pull-right"></i>
        </div>
            
        <button id="{$attr_id}_datebtn" 
                class="Grid-cell u-sizeFit u-background-60 u-color-white u-padding-all-s u-textWeight-700 mdi mdi-calendar mdi-24px" 
                title="Date range" 
                aria-label="Date range">
        </button>   
    </div>
    
            
    <input type="hidden" id="{$attr_id}" name="{$attr_id}" value="[DateRange]2015-01-02 - 2018-02-21">
</div>
    
{literal}
<script>
    $(function() {
        // var days = 'Dom_Lun_Mar_Mer_Gio_Ven_Sab'.split('_');
        // var months = 'Gen_Feb_Mar_Apr_Mag_Giu_Lug_Ago_Set_Ott_Nov_Dic'.split('_');
        
        var end = moment();
        var start = moment().add(-30, 'days');
        
        function daterange_callback(start, end, label) {
            $('#{/literal}{$attr_id}_date{literal} span').html(start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
            $('#{/literal}{$attr_id}{literal}').val( '[DateRange]' + start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD') );

            search(null);
        }
        
        $("#{/literal}{$attr_id}_date{literal}").daterangepicker({
            startDate: start,
            endDate: end,
            "locale":{
                "format": "DD/MM/YYYY",
                "applyLabel": "Applica",
                "cancelLabel": "Annulla"
            },
            "showDropdowns": true,
            "opens": "right"
        }, daterange_callback);
        
        daterange_callback(start, end);
        
        $('#{/literal}{$attr_id}_datebtn{literal}').click(function( event ){
            $('#{/literal}{$attr_id}_date{literal}').trigger("click");
            event.preventDefault();
        });
    });
</script>    
{/literal}