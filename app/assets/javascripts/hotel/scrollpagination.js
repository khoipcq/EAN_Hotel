/*
**  Anderson Ferminiano
**  contato@andersonferminiano.com -- feel free to contact me for bugs or new implementations.
**  jQuery ScrollPagination
**  28th/March/2011
**  http://andersonferminiano.com/jqueryscrollpagination/
**  You may use this script for free, but keep my credits.
**  Thank you.
*/

(function( $ ){


 $.fn.scrollPagination = function(options) {

    var opts = $.extend($.fn.scrollPagination.defaults, options);
    var target = opts.scrollTarget;
    if (target == null){
      target = obj;
    }
    opts.scrollTarget = target;

    return this.each(function() {
      $.fn.scrollPagination.init($(this), opts);
    });

  };

  $.fn.stopScrollPagination = function(){
    return this.each(function() {
    $(this).attr('scrollPagination', 'disabled');
    });

  };

  $.fn.scrollPagination.loadContent = function(obj, opts){
   var target = opts.scrollTarget;
   var mayLoadContent = $(target).scrollTop()+opts.heightOffset >= $(document).height() - $(target).height();
   if (mayLoadContent){
     if (opts.beforeLoad != null){
      opts.beforeLoad();
     }
     $(obj).children().attr('rel', 'loaded');
     if(g_allow_ajax_loading == true && g_is_more_results == "true")
      {
        if(g_cache_key){
          opts.contentData["cacheKey"] = g_cache_key || '' ;
        }
        if(g_cache_location){
          opts.contentData["cacheLocation"] = g_cache_location || '';
        }
        opts.contentData["sort"] = $("#sort-by").val();
        opts.contentData["number_of_results"] = 100;
        g_allow_ajax_loading =false;
         $.ajax({
            type: 'GET',
            url: opts.contentPage,
            data: opts.contentData,
            success: function(data){
            
            g_allow_ajax_loading = true;
            
            var objectsRendered = $(obj).children('[rel!=loaded]');
            
            if (opts.afterLoad != null){
              opts.afterLoad(objectsRendered);
            }
            if(data.length < 130 && data.indexOf("No result was found") > 0){
              g_allow_ajax_loading = false;
              $("#loading").css("display","none");
              return;
            }
            $(obj).append(data);
            init_href_click_event();            
            },
            dataType: 'html'
         });
      }else
      {
        if(g_is_more_results == "false"){
          $("#loading").css("display","none");
        }
      }
   }

  };

  $.fn.scrollPagination.init = function(obj, opts){
   var target = opts.scrollTarget;
   $(obj).attr('scrollPagination', 'enabled');

   $(target).scroll(function(event){
    if ($(obj).attr('scrollPagination') == 'enabled'){
      $.fn.scrollPagination.loadContent(obj, opts);
    }
    else {
      event.stopPropagation();
    }
   });

   $.fn.scrollPagination.loadContent(obj, opts);

 };

 $.fn.scrollPagination.defaults = {
         'contentPage' : null,
       'contentData' : {},
     'beforeLoad': null,
     'afterLoad': null  ,
     'scrollTarget': null,
     'heightOffset': 0
 };
})( jQuery );