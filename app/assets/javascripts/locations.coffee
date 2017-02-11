(($) ->
  $ ->
    $('.js-year-select').on 'change', ->
      base_url = window.location.href.split('?')[0]
      window.location.href = base_url + "?year=" + $(this).val()
) jQuery