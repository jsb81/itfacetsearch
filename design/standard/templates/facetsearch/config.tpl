{* TODO: Realizzare design per Bootstrap *}

<div class="u-facet-side">
    <div class="u-facet-title">
        <div class="u-facet-heading">
            <h1>
                {'Facetsearch Config'|i18n('facetconfig')}
            </h1>
        </div>
        <p class="u-margin-bottom-m">
            In questa pagina può essere configurata la visualizzazione "FacetSearch" per una
            determinata classe di contenuto.
        </p>
        
    </div>
    <div class="u-facet-form">
        <form id="class_config" class="Form">
            
            <legend class="Form-legend">{'Content class'|i18n('facetconfig')}</legend>
            
            <div class="Grid">
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="content_classes"
                                name="content_classes" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Select content class'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>
            </div>
                        
            <legend class="Form-legend content-class-properties">{'Main options'|i18n('facetconfig')}</legend>
            
            <div class="Grid content-class-properties">
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="view_type"
                                name="view_type" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'View Type'|i18n('facetconfig')}</option>
                            <option value="1" >DataTable</option>
                            <option value="2" >MapDataTable</option>
                            <option value="3" >SideMapDataTable</option>
                            <option value="4" >SideMapMultiDataTable</option>
                            
                            <option value="5" >Panels</option>
                            <option value="6" >FilterPanels</option>
                            <option value="7" >Accordion</option>
                        </select>
                    </div>
                </div>
                
                <div class="u-facet-form-cell">
                    <fieldset class="Form-field Form-field--choose Grid-cell">
                        <label class="Form-label Form-label--block" for="export">
                            <input type="checkbox" 
                                   class="Form-input" 
                                   id="export"
                                   name="export"
                                   aria-required="true">
                            <span class="Form-fieldIcon" role="presentation"></span> {'Export Button'|i18n('facetconfig')}
                        </label>
                    </fieldset>
                </div>

                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <input id="single_res"
                               name="single_res"
                               class="Form-input Grid-cell u-sizeFill"
                               placeholder="{'One item found label'|i18n('facetconfig')}">
                    </div>
                </div>
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <input id="multiple_res"
                               name="multiple_res"
                               class="Form-input Grid-cell u-sizeFill"
                               placeholder="{'Multiple items found label'|i18n('facetconfig')}">
                    </div>
                </div>
                    
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="search_cols"
                                name="search_cols" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Search field columns'|i18n('facetconfig')}</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="4">4</option>
                            <option value="100">{'Hide'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>
                        
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <input id="remote_site_import_url"
                               name="remote_site_import_url"
                               class="Form-input Grid-cell u-sizeFill"
                               placeholder="{'Import site URL'|i18n('facetconfig')}">
                    </div>
                </div>
                    
                <div class="u-facet-form-cell">
                    <div class="Form-field u-textRight">
                        <button id="save_class_properties" type="button" class="Button Button--default u-text-xs">
                            <i class="mdi mdi-content-save"></i>
                            {'Save'|i18n('facetconfig')}
                        </button>
                        <button id="delete_class_properties" type="button" class="Button Button--danger u-text-xs">
                            <i class="mdi mdi-delete"></i>
                            {'Delete'|i18n('facetconfig')}
                        </button>
                    </div>
                </div>
            </div>
            
            <legend class="Form-legend content-class-attributes">{'Attributes'|i18n('facetconfig')}</legend>
            
            <div class="Grid content-class-attributes">
                 
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_identifier"
                                name="attribute_identifier" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Attribute Identifier'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>
                
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <input id="attribute_label"
                               name="attribute_label"
                               class="Form-input Grid-cell u-sizeFill"
                               placeholder="{'Attribute label'|i18n('facetconfig')}">
                    </div>
                </div>
                    
                
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_type"
                                name="attribute_type" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Attribute Type'|i18n('facetconfig')}</option>
                            <option value="1" >{'Search'|i18n('facetconfig')}</option>
                            <option value="2" >{'Table'|i18n('facetconfig')}</option>
                            <option value="3" >{'Export'|i18n('facetconfig')}</option>
                            <option value="4" >{'Import'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>
                            
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_datatype"
                                name="attribute_datatype" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Attribute DataType'|i18n('facetconfig')}</option>
                            <option value="1" >Input</option>
                            <option value="2" >Select</option>
                            <option value="3" >Date</option>
                            <option value="4" >Tags</option>
                            <option value="5" >Radio Button</option>
                            <option value="6" >Checkbox</option>
                        </select>
                    </div>
                </div>
                            
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_cols"
                                name="attribute_cols" 
                                class="Form-input Grid-cell u-sizeFill u-text-r-s u-border-none">
                            <option value="0" selected>{'Attribute columns'|i18n('facetconfig')}</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="4">4</option>
                        </select>
                    </div>
                </div>
                            
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_dependency"
                                name="attribute_dependency" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Dependency'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>  
                        
                <div class="u-facet-form-cell">
                    <div class="Form-field Form-field--withPlaceholder Grid">
                        <select id="attribute_full_link"
                                name="attribute_full_link" 
                                class="Form-input Grid-cell u-sizeFill">
                            <option value="0" selected>{'Full link'|i18n('facetconfig')}</option>
                            <option value="1" >{'Yes'|i18n('facetconfig')}</option>
                            <option value="2" >{'No'|i18n('facetconfig')}</option>
                        </select>
                    </div>
                </div>
                             
                <div class="u-facet-form-cell">
                    <div class="Form-field u-textRight">
                        <button id="add_attribute" type="button" class="Button Button--default u-text-xs">
                            <i class="mdi mdi-plus"></i>
                            {'Add'|i18n('facetconfig')}
                        </button>
                    </div>
                </div>
            </div>
            
        </form>
    </div>
    <div class="u-facet-table">
        <table id="attributes_table" class="Table Table--striped Table--responsive dataTable no-footer">
            <thead>
                <tr>
                    <td>
                        {'Order'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Attribute identifier'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Dependency'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Label'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Type'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'DataType'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Columns'|i18n('facetconfig')}
                    </td>
                    <td>
                        {'Action'|i18n('facetconfig')}
                    </td>
                </tr>
            </thead>
            <tbody>
                
            </tbody>
        </table>
    </div>
</div>
                        
{include uri="design:facetsearch/config_script.tpl"}