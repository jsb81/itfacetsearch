{literal}
<script>
    let siteURL = '{/literal}{ezini( 'SiteSettings', 'SiteURL'  )}{literal}';
    let class_identifiers = "{/literal}{$classes}{literal}";
    let class_attributes = "{/literal}{$class_attributes}{literal}";
    let facet_attributes = "{/literal}{$facet_attributes}{literal}";
    let node_id = {/literal}{$node.node_id}{literal};

    let start = moment();
    let end = moment().add(30, 'days');

    let limit = 12;

    const HTML_PANEL_START = '<div class="Grid-cell {/literal}{$columns}{literal}">';
    const HTML_PANEL_END = '</div>';

    const MAX_PAGEINDEX = 5;


    $(document).ready(function(){
        function getSelectedClassIdentifiers() {
            let _class_identifiers = '';
            $('.select_class').each(function(index){
                if($(this).hasClass('selected')){

                    if(index>0){
                        _class_identifiers += '|';
                    }

                    _class_identifiers += $(this).data('classidentifier');
                }
            });

            if(_class_identifiers === ''){
                _class_identifiers = class_identifiers;
            }

            return _class_identifiers;
        }

        function searchSelectedIndex(data) {
            let selectedIndex = undefined;

            $.each(data.paging, function (key, value) {
                if(value.status === 'selected'){
                    selectedIndex = value.label;
                }
            });

            return selectedIndex;
        }

        function showPaging(data) {
            console.log(data.paging.length);
            if(data.paging != null && data.paging.length > 3) {
                let pageIndex = 1;

                let selectedIndex = searchSelectedIndex(data);

                let invertedCicle = false;
                if (data.paging.length > MAX_PAGEINDEX && selectedIndex >= data.paging.length / 2) {
                    invertedCicle = true;
                    pageIndex = MAX_PAGEINDEX;
                }

                for (let key = 0; key < data.paging.length; key++) {
                    // skip
                    if (invertedCicle && key === 1) {
                        for (; data.paging.length - (key + 2) > selectedIndex; key++) ;
                    }
                    else if (key === 1) {
                        for (; key + 2 < selectedIndex; key++) ;
                    }

                    let _key = invertedCicle ? data.paging.length - key - 1 : key;

                    let value = data.paging[_key];
                    console.log(_key);
                    console.log(value);


                    let link_selector = '';

                    if (value.label === 'Previous') {
                        link_selector = '#prevPage';

                    }
                    else if (value.label === 'Next') {
                        link_selector = '#nextPage';
                    }
                    else {
                        if (invertedCicle) {
                            link_selector = '#page' + Math.max(pageIndex, 1);
                        }
                        else {
                            link_selector = '#page' + Math.min(pageIndex, MAX_PAGEINDEX);
                        }

                        if (value.status === 'selected') {
                            $(link_selector).parent().removeClass('u-hidden u-md-inlineBlock u-lg-inlineBlock');
                            $(link_selector).removeClass('u-color-50');
                            $(link_selector).addClass('u-background-50 u-color-white');
                            $(link_selector + ' span').html('<span class="u-md-hidden u-lg-hidden">Pagina</span>' + value.label);
                        }
                        else {
                            $(link_selector).parent().addClass('u-hidden u-md-inlineBlock u-lg-inlineBlock');
                            $(link_selector).addClass('u-color-50');
                            $(link_selector).removeClass('u-background-50 u-color-white');
                            $(link_selector + ' span').html(value.label);
                        }

                        if (invertedCicle) {
                            pageIndex--;
                        }
                        else {
                            pageIndex++;
                        }
                    }

                    // imposto offset del link
                    $(link_selector).data('offset', value.offset);

                    // disabilito il link se su offset non valido
                    if (value.status === 'disabled') {
                        $(link_selector).addClass('disabled');
                    }
                    else {
                        $(link_selector).removeClass('disabled');
                    }
                    $(link_selector).parent().show();
                }

                if (data.paging.length > MAX_PAGEINDEX + 2) {
                    if (invertedCicle) {
                        $('#page2 span').html('...');
                        $('#page2').addClass('disabled');
                    }
                    else {
                        $('#page4 span').html('...');
                        $('#page4').addClass('disabled');
                    }
                }
                else if (data.paging.length < MAX_PAGEINDEX + 2) {
                    // Nascondo pagine che non servono
                    for (; pageIndex <= MAX_PAGEINDEX; pageIndex++) {
                        link_selector = '#page' + pageIndex;
                        $(link_selector).parent().attr('style', 'display:none !important');
                    }
                }

                $('#resultPagingList').show();
            }
            else{
                $('#resultPagingList').hide();
            }
        }

        function showResult(data){
            var html_panels = '';
            $.each(data.data, function (key, value) {
                html_panels += HTML_PANEL_START + value + HTML_PANEL_END;
            });

            showPaging(data);

            $("#recordsTotal").html(data.recordsTotal);

            $('#resultPanels').html(html_panels);

            $('#resultPanels').show();
            $('#resultPaging').show();
            $('#loading').hide();

            // Mi sposto incima alla pagina
            $("html, body").animate({scrollTop: 0}, "slow");
        }

        function doSearch(_offset = 0){
            $('#resultPanels').hide();
            $('#resultPaging').hide();
            $('#loading').show();

            let _class_identifiers = getSelectedClassIdentifiers();

            let data = {};

            // Select Options
            $('#search_form option:selected').each(function(){
                var parent = $(this).parent();

                data[ parent.attr('name') ] = $(this).val();
            });

            // Inputs
            $('#search_form :input').each(function(){
                data[ $(this).attr('name') ] = $(this).val();
            });

            $.ajax({
                "type": "GET",
                "url": "https://"+siteURL+"/facetsearch/search/" +
                        _class_identifiers + "/" +
                        class_attributes + "/" +
                        facet_attributes + "/"  +
                        node_id + "/" +
                        _offset + "/" +
                        limit,
                "data": data,
                success: function(result_data) {
                    showResult(result_data);
                }
            });
        }

        // Su primo caricamento
        {/literal}{if $search_by_date|not()}{literal}
        doSearch();
        {/literal}{/if}{literal}

        // Su form submit
        $('#search_form').submit(function (e){
            e.preventDefault();
            doSearch();
        });

        // Selezione classe di contenuto
        $('.select_class').click(function (e) {

            if($(this).hasClass('selected')){
                $(this).removeClass('selected');
            }
            else {
                $(this).addClass('selected');
            }

            doSearch();
        });

        $('.page_link').click(function (e) {
            e.preventDefault();

            if( !$(this).hasClass('disabled') ) {
                doSearch( $(this).data('offset') );
            }

        });

        // Daterange
        $(function() {
            var days = 'Dom_Lun_Mar_Mer_Gio_Ven_Sab'.split('_');
            var months = 'Gen_Feb_Mar_Apr_Mag_Giu_Lug_Ago_Set_Ott_Nov_Dic'.split('_');

            function cb(start, end) {
                $('#reportrange span').html(start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
                $('#daterange').val( start.format('YYYY-MM-DD') + ' - ' + end.format('YYYY-MM-DD') );

                doSearch();
            }

            $('#reportrange').daterangepicker({
                startDate: start,
                endDate: end,
                format: 'DD/MM/YYYY',
                locale: {
                    opens: 'center',
                    firstDay: 1,
                    daysOfWeek: days,
                    monthNames: months,
                    applyLabel: 'Applica',
                    cancelLabel: 'Annulla',
                    fromLabel: 'Dal',
                    toLabel: 'Al',
                    weekLabel: 'W',
                    customRangeLabel: 'Seleziona date',
                    format: 'DD/MM/YYYY'
                }
            }, cb);

            {/literal}{if $search_by_date}{literal}
            cb(start, end);
            {/literal}{/if}{literal}
        });

    });

</script>
{/literal}