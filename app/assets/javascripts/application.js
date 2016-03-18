// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require turbolinks
//= require jquery
//= require motion-ui
//= require foundation-sites
//= require_tree .
    
var ready = function(){
                        $(document).foundation();
                        //checkTopElementPosition();
                        footerControl();
                        $('img').load(function(){footerControl();});
                        $(window).resize(function(){footerControl();});
                       // setTimeout(function(){footerControl();}, 450);
                      };

$(document).ready(ready);
$(document).on('page:load', ready);

//to delete-----------------------------------------------------------------
function checkTopElementPosition()
{
    if ($("#top").offset().top == 0)
    {
        $("#top").css('top', $('.top-bar').outerHeight(true) + 'px');
    }
    //if ($("#top").offset().top > $('.top-bar').height() + $('.top-bar').height()/2) { $("#top").css('top', '0px'}
}
function footerControl()
{
    var tbHeight = $("#top_bar").outerHeight(true);
    var tHeight = $("#top").outerHeight(true);
    var wHeight = $("#wrapper").outerHeight(true);
    var fHeight = $("#footer").outerHeight(true);
    var windHeight = $(window).height();
    var sumHeight = tbHeight + tHeight + wHeight + fHeight;
    if (sumHeight > windHeight)
    {
        $("#footer").addClass('rel-footer');
        $("#footer").removeClass('fix-footer');
    }else
    {
        $("#footer").addClass('fix-footer');
        $("#footer").removeClass('rel-footer');
    }
    console.log(sumHeight + ' ' + windHeight)
}

