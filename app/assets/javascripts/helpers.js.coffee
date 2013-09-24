window.Helpers ?=

# --- colorbox ----------------------------------------------------------------------------------

  closeColorbox: ->
    window.parent.$.colorbox.close()

$('a[data-submit]').on('click', ->
  link = $(this)
  $("form##{link.data('submit')}").submit()
)

$('a[data-cb-close]').on('click', ->
  Helpers.closeColorbox()
)
