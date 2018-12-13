<div class="form-group col-md-{$cols}">
    <label for="published">{$attr_name}</label>
    <div id="{$attr_id}" style="background: #fff; cursor: pointer; padding: 5px 10px;">
        <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>&nbsp;
        <span></span> <b class="caret"></b>
    </div>
    <input type="hidden" id="daterange_{$attr_id}" name="daterange_{$attr_id}"/>
</div>


{literal}
<script>
    $(function() {
        $("#{/literal}{$attr_id}{literal}").daterangepicker(
            {
                "locale":{
                    "format": "DD/MM/YYYY",
                    "applyLabel": "Applica",
                    "cancelLabel": "Annulla"
                },
                // "singleDatePicker": true,
                "showDropdowns": true,
                "opens": "left"
            }
            , 
            function(start, end, label) {
                $('#{/literal}{$attr_id}{literal} span').html(start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
                $('#daterange_{/literal}{$attr_id}{literal}').val( start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD') );

                search(null);
            }
        );
    });
</script>
{/literal}