# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require bsa
#= require twitter/bootstrap
#= require turbolinks
#= require_tree .

$(document).on 'page:change ready', ->

  $('a[data-modal]').on 'ajax:success', (evt,data, status, xhr) ->
    $('#master-modal').remove()
    $('body').append(data)
    $('#master-modal').on 'shown.bs.modal', ->
      $('a[data-submit]').on('click', ->
        link = $(this)
        $("form##{link.data('submit')}").submit()
      )
    $('#master-modal').modal({})

  $ ->
    controller = gon.controller_path.replace(/\//g, "_")
    action = gon.action_name
    activeController = Bsa[controller]
    if activeController isnt `undefined`
      activeController.init()  if $.isFunction(activeController.init)
      activeController[action]()  if $.isFunction(activeController[action])
