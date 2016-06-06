# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require motion-ui
#= require foundation-sites
#= require_tree .


footerControl = ()->
    mQuery = Foundation.MediaQuery.current
    tbHeight = if mQuery is 'small' then $(".title-bar").outerHeight(true) else $("#top_bar").outerHeight(true)
    tHeight = if mQuery is 'small' then 0 else $("#top").outerHeight(true)
    wHeight = $("#wrapper").outerHeight(true)
    fHeight = $("#footer").outerHeight(true)
    windHeight = $(window).height()
    sumHeight = tbHeight + tHeight + wHeight + fHeight
    if sumHeight > windHeight
        $("#footer").addClass('rel-footer')
        $("#footer").removeClass('fix-footer')
    else
        $("#footer").addClass('fix-footer')
        $("#footer").removeClass('rel-footer')
            
    
r = ()->
    $(document).foundation()
    footerControl()
    $('img').load ()-> footerControl()
    $(window).resize ()-> footerControl()
    

$(document).ready r
$(document).on 'page:load', r
