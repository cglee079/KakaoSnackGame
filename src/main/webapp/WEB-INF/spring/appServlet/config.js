/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
    // Define changes to default configuration here. For example:
    // config.language = 'fr';
    // config.uiColor = '#AADC6E';
	
    config.toolbar_Full =
        [
            { name: 'document', items : [ 'Source', 'Maximize', 'ShowBlocks']},
            { name: 'links', items : [ 'Link','Unlink',] },
            { name: 'insert', items : [ 'Image','Youtube','CodeSnippet','Table', 'SpecialChar'] },
            { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent'] },
            '/',
            { name: 'styles', items : [ 'Format','FontSize' ] },
            { name: 'colors', items : [ 'TextColor','BGColor' ] },
            { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','RemoveFormat' ] },
            
        ];

    config.toolbar_Basic =
        [
        	[ 'Bold','Italic','Underline','Strike','-','RemoveFormat' ]
        ];
    
    config.extraPlugins = 'youtube,prism';
};
