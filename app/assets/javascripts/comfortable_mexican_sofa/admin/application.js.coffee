# Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js

#= require ckeditor/init
#= require ckeditor-jquery

window.CMS.wysiwyg = ->
  $('textarea[data-rich-text]').ckeditor();
