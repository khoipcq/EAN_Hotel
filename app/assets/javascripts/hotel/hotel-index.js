//= require_self
var destination_item_count = -1;
//var g_city_flag = false;
//var is_selected = false;

$(document).ready(function(){
  searchHotels(false);
  $('#hotels-list').scrollPagination({
                    'contentPage': g_urlToList, // the url you are fetching the results
                    'contentData': g_hashParams, // these are the variables you can pass to the request, for example: children().size() to know which page you are
                    'scrollTarget': $(window), // who gonna scroll? in this example, the full window
                    'heightOffset': 50, // it gonna request when scroll is 10 pixels before the page ends
                    'beforeLoad': function(){ // before load function, you can display a preloader div
                        if(g_is_more_results == "true" && g_allow_ajax_loading){
                          $('#loading').fadeIn();  
                        }
                    },
                    'afterLoad': function(elementsLoaded){ // after loading content, you can use this function to animate your new elements
                         $('#loading').fadeOut();
                         var i = 0;
                         $(elementsLoaded).fadeInWithDelay();
                         if ($('#content').children().size() > 100){ // if more than 100 results already loaded, then stop pagination (only for testing)
                            $('#nomoreresults').fadeIn();
                            $('#content').stopScrollPagination();
                         }
                    }
                });

                // code for fade in element by element
                $.fn.fadeInWithDelay = function(){
                    var delay = 0;
                    return this.each(function(){
                        $(this).delay(delay).animate({opacity:1}, 200);
                        delay += 100;
                    });
                };

  $("#sort-by").change(processSortBy);
  $("#star-filter").change(processStarFilter);
  $("#rate-filter").change(processRateFilter);
  var dateToday = new Date();
  var checkin_inline_dates = $("#search_checkin_inline").datepicker({
        defaultDate: dateToday,
        numberOfMonths: 1,
        minDate: dateToday,
        onSelect: function(selectedDate) {
        var option = this.id == "search_checkin_inline" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        checkin_inline_dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      onClose: resetEndDate_inline
      });
  var checkout_inline_dates = $("#search_checkout_inline").datepicker({
        defaultDate: "+1w",
        numberOfMonths: 1,
        minDate: dateToday,
        maxDate: "+28D",
        onSelect: function(selectedDate) {
        var option = this.id == "checkin_1" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        checkout_inline_dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      beforeShow: setRange_inline
      });
  // allow delete date fields by Backspace key and Delete key
    $("#search_checkin_inline").keydown(function(event) {
      if (event.which === 8 || event.which === 46) {
        $(this).val("");
      }
      //return false;
    });
    $("#search_checkout_inline").keydown(function(event) {
      if (event.which === 8 || event.which === 46) {
        $(this).val("");
      }
      //return false;
    });
    
  $("#search_checkin_inline").attr('readonly', true);
  $("#search_checkout_inline").attr('readonly', true);
  
  $("#h_search_checkout_inline").val($("#search_checkout_inline").val());
  $("#currency-filter").change(function(){

    searchHotels(true);
  });
	
});

/*
* Search hotels with input conditions
* Author: NamTV
*/
function searchHotels(is_currency_filter){
  g_hashParams["number_of_results"] = 100;
  g_hashParams["minStarRating"] = $("#star-filter").val();
  g_hashParams["sort"] = $("#sort-by").val();
  g_hashParams["currencyCode"] = $("#currency-filter").val();
  $("#hotels-list").mask("Loading...");
  $.ajax({
    url: g_urlToList,
    type: "GET",
    data: g_hashParams,
    success: function(result){
      $("#hotels-list").html(result);
      init_href_click_event();
      if(is_currency_filter){
        $("#rate-filter").empty();
        $.each(rate_filters, function(index, ele){
          $("#rate-filter").append("<option value=" +  ele.value + " " + ele.selected + ">" + ele.name + "</option>");
        });
      }
      if(g_hashParams["minRate"]!=""){
        $("#rate-filter").val(g_hashParams["minRate"] + "-" + g_hashParams["maxRate"]);
      }
      $("#hotels-list").unmask();

      g_allow_ajax_loading = true
      $("#loading").css("display","inline");  
      if(g_is_more_results != "true"){
        $('#loading').fadeOut();  
      }
    }
  });
}

/*
* Get value of a param in URL
* Author: NamTV
*/
function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}

/*
* Process onChange event for "Sort By"
* Author: NamTV
*/
function processSortBy () {
  g_hashParams["sort"] = $("#sort-by").val();
  delete g_hashParams.cacheKey;
  delete g_hashParams.cacheLocation;
  searchHotels(false);
}

/*
* Process onChange event for star rating filter
* Author: NamTV
*/
function processStarFilter () {
  g_hashParams["minStarRating"] = $("#star-filter").val();
  g_hashParams["sort"] = $("#sort-by").val();
  searchHotels(false);
}

/*
* Process onChange event for rate filter
* Author: NamTV
*/
function processRateFilter () {
  var filterValue = $("#rate-filter").val();
  var filterValues = [];
  if(filterValue != "-1"){
    filterValues = filterValue.split("-");
    g_hashParams["minRate"] = filterValues[0];
    g_hashParams["maxRate"] = filterValues[1];
  }
  else{
    g_hashParams["minRate"] = null;
    g_hashParams["maxRate"] = null;
  }
  g_hashParams["sort"] = $("#sort-by").val();
  searchHotels(false);
}

//Show change search
function show_change_search(){
  var box_content  =  $("#search_light_box_content");

  if(g_first_open_fancy == true)
  {
    $.fancybox({
          'content' : $("#box_text").clone().html(),
          //'autoScale': true
        });

    $.fancybox.resize();
    $("#fancybox-content #room-group-0").attr('style','display:block');
    $("#fancybox-content #search-room").val(g_rooms.length);
    
  
  }
  else
  {
    $.fancybox({
          'content' : g_fancy_html,
          //'autoScale': true
        });

    $.fancybox.resize();
    $("#fancybox-content #search-room").val(g_old_select_room);
    set_room_info();
  }
  $("#fancybox-content #popup_destination").val(g_hashParams["destination_string"]);
  
  //--------Add Date Time picker to Checkin and Check Out Text box
  var dateToday = new Date();
  $("#fancybox-content #popup_checkin_date").attr("id","checkin_1");
  var dateToday = new Date();
  $("#checkin_1").attr("class", "search-field-text")
  var check_in_dates = $("#checkin_1").datepicker({
          defaultDate: dateToday,
          numberOfMonths: 1,
          minDate: dateToday,
          onSelect: function(selectedDate) {
        var option = this.id == "checkin_1" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        check_in_dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      onClose: resetEndDate
  });
  $("#fancybox-content #popup_checkout_date").attr("id","checkout_1");

  $("#checkout_1").attr("class", "search-field-text")
  var check_out_dates = $("#checkout_1").datepicker({
        defaultDate: "+1w",
        numberOfMonths: 1,
        minDate: dateToday,
        maxDate: "+28D",
        onSelect: function(selectedDate) {
        var option = this.id == "checkin_1" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        check_out_dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      beforeShow: setRange
  });
  
  $("#checkin_1").attr('readonly', true);
  $("#checkout_1").attr('readonly', true);
    
  //---End Add Date Time Picker
  $("#checkin_1").val($("#h_search_checkin_inline").val());
  $("#checkout_1").val($("#h_search_checkout_inline").val());

  //---Add Auto Complete to Destination Text Box
  $( "#fancybox-content #popup_destination" ).catcomplete({
      delay: 0,
      minLength: 3,
      source:  function (request, response) {
        var term = request.term.replace(/^\s+|\s+$/g, '');
        g_is_selected = false;
        if (term in cache){
          destination_item_count = cache[term].length;
          g_city_flag = cache[term + "_city_flag"];
          response(cache[term]);
          return;
        }
        $.ajax({
          data: {'s': term},
          url: "/home/search.json",
          dataType: "json",
          type: "GET",
          success: function (data) {
            var new_data = $.map(data[0], function(item) {
              return {
                category: item.category,
                label: item.label,
                value: item.value,
                id: item.id
              };
            });

            cache[term] = new_data;
            cache[term + "_city_flag"] = data[1]["city_flag"];
            g_city_flag = data[1]["city_flag"];
            destination_item_count = new_data.length;
            response(new_data);
            g_is_selected = false;
          },
          error: function (result) {
            //alert("Error:" + result.statusText);
            g_is_selected = false;
          }
        });
        $("#no_result").hide();
      },
      select : function(event, ui) {
              ui.item.value = ui.item.label.replace(/<(?:.|\n)*?>/gm, '');
              g_is_selected = true;
              $("#fancybox-content #item-id").val(ui.item.id);
              $("#fancybox-content #item-category").val(ui.item.category);
          }
      }).bind("keyup", function(e) {
        // hide error messages when typing
        $("#fancybox-content #no_result").hide();
        $("#fancybox-content #blank_destination").hide();
        // submit form when pressing Enter key (aka Return key)
        var keycode;
        if (window.event){
          keycode = window.event.keyCode;
        }
        else if (e){
          keycode = (e.keyCode ? e.keyCode : e.which);
        }
        else{
          return true;
        }
        if (keycode == 13) {
          if (window.previousKeyCode) {
            if (window.previousKeyCode == 33 || // Pageup key
                window.previousKeyCode == 34 || // Pagedown key
                window.previousKeyCode == 38 || // Up arrow key
                window.previousKeyCode == 40) { // Down arrow key
                window.previousKeyCode = keycode;
                return true;
            }
            else if (window.previousKeyCode == 13){
              //do nothing if user select by Enter key
            }
            else{
              // reset to destination search if user types
              $("#fancybox-content #item-category").val("Destination");
            }
          }
          $("#fancybox-content #search-all-btn").click();
          return false;
        }
        else {
          window.previousKeyCode = keycode;
          return true;
        }
      }).bind("focus", function(e) {
        $("#fancybox-content #popup_destination").catcomplete("search");
      });
  //-- End Auto Complete

  //--- Room Change
  $("#fancybox-content #search-room").change(function(){
    var number_of_room = $(this).val();
    //hide all room group
    $(".room-group").hide();

    if (number_of_room <= 1){
      $("#fancybox-content #room-field-first").attr('style','visibility:hidden');

    }
    else{
      $("#fancybox-content #room-field-first").attr('style','visibility:visible');
    }

    for (var i=0; i<number_of_room; i++){
      //if this room HTML is already in DOM, keep it as it is
      var room_group_div = $("#fancybox-content #room-group-" + i);

      if (room_group_div.length > 0){
        room_group_div.show();
        continue;
      }else{
        //create new room group
        var room_group_div = $("#fancybox-content #room-group-template").clone();
        room_group_div.attr("id", "room-group-" + i);
        room_group_div.addClass("room-group");
        var room_field = room_group_div.find(".room-field");
        room_field.html('Room ' + (i+1) + ':');
        $("#fancybox-content #room-group-container").append(room_group_div);
      }
    }
  });
  //--- End Room Change
  if(g_first_open_fancy == true)
  {
    $("#fancybox-content #search-room").trigger("change");
    set_room_info();
    $("#fancybox-content .child-box").trigger("change");
  }
};

function set_room_info(){
  var room_groups = $("#fancybox-content .room-group:visible");
  $.each(room_groups, function(index, ele){
    var adults = $(ele).find("#adult-1");
    if (adults){
      adults.val(g_rooms[index].adults);
    }
    var children = $(ele).find("#children-1");
    if (children){
      children.val(g_rooms[index].children);
      var ages = [];
      for (var i=0; i < g_rooms[index].children; i++){
        var age = $(ele).find("#age-" + i);
        if (age){
          age.val(g_rooms[index].ages[i]);
        }
      }
    }
  });
}

//--- Request for search function
function search_submit()
{
  var room_groups = $("#fancybox-content .room-group:visible");
  var rooms = [];
  var number_of_adults = 0;
  var number_of_children = 0;
  $.each(room_groups, function(index, ele){
      var room = {};
      var adults = $(ele).find("#adult-1");
      if (adults){
        room["adults"] = adults.val();
        number_of_adults += parseInt(adults.val());
      }
      else{
        room["adults"] = 0;
      }
      var children = $(ele).find("#children-1");
      if (children){
        room["children"] = children.val();
        number_of_children += parseInt(children.val());
        var ages = [];
        for (var i=0; i < room["children"]; i++){
          var age = $(ele).find("#age-" + i);
          if (age){
            ages.push(age.val());
          }
        }
        room["ages"] = ages;
      }
      else{
        room["children"] = 0;
      }
      rooms.push(room);
    });
    g_rooms = rooms;
    var roomInfos = rooms.length + " room(s), " + number_of_adults + " adult(s), " + number_of_children + " children";
  
  $("#rooms-info").html(roomInfos);

    g_hashParam_tmp["rooms"] = JSON.stringify(rooms);
    g_fancy_html_tmp = $("#fancybox-content").html();
  var valid_search = poup_validate_search();
  if(valid_search == true){
    g_old_select_room = $("#fancybox-content #search-room").val();;
    var arrival_date = $("#checkin_1").val();
    var departure_date = $("#checkout_1").val();
    var destination_string = $("#fancybox-content #popup_destination").val();
    $("#search_checkin_inline").val(arrival_date);
    $("#search_checkout_inline").val(departure_date);
    $("#h_search_checkin_inline").val(arrival_date);
    $("#h_search_checkout_inline").val(departure_date);
    g_hashParam_tmp["arrival_date"] = arrival_date;
    g_hashParam_tmp["departure_date"] = departure_date;
    g_hashParam_tmp["destination_string"] = destination_string;
    g_hashParam_tmp["item_category"] = $("#fancybox-content #item-category").val();
    g_hashParam_tmp["item_id"] = $("#fancybox-content #item-id").val();

    g_hashParam_tmp["search_room"] = $("#fancybox-content #search-room").val();

    check_multiple_location(destination_string, arrival_date, departure_date, rooms);
    //


  }
}
//---End Request for search function
//--- Client Validation Search
function poup_validate_search(){
  var arrival_date = $("#checkin_1").val();
  var departure_date = $("#checkout_1").val();
  var destination_string = $("#fancybox-content #popup_destination").val();
  $("#fancybox-content #no_result").hide();
  if((destination_item_count == 0 && destination_string != "" && destination_string != default_destination_input) || destination_string.length <3){
    $("#fancybox-content #no_result").show();
    return false;
  }

  if(!g_city_flag && g_city_flag != undefined && !g_is_selected && (destination_item_count > 0 && destination_string != "" && destination_string != default_destination_input) || destination_string.length <3){
    var cache_data = cache[destination_string.replace(/^\s+|\s+$/g, '')];
    var box_content  =  $("#multiple_location_content");
    box_content.empty();
    $.each(cache_data, function(index, ele){
      if (index != 0){
        $('<input />').attr('type', 'radio')
          .attr('name', 'light_box_location')
          .attr('value', ele.id + "_" + ele.category).attr('style', 'margin:0')
          .appendTo(box_content);
      }
      else{
        $('<input />').attr('type', 'radio')
          .attr('name', 'light_box_location')
          .attr('checked', 'checked')
          .attr('value', ele.id + "_" + ele.category).attr('style', 'margin:0')
          .appendTo(box_content);
      }
      $('<span>').text(" " + ele.value).appendTo(box_content);
      $('<br/>').appendTo(box_content);
    });
    $.fancybox({
      'content' : $("#multiple_location_div").html(),
    });
    show_light_box(cache, destination_string);
    return false;
  }

  if (destination_string == "" || destination_string == default_destination_input){
    $("#fancybox-content #blank_destination").show();
    return false;
  }
  return true;
}
//-- End Client Validation Search
// EVENT HANDLER for "Change search" button
$("#change_search_btn").bind("click", function(){
  show_change_search();
});
//---Bind event to inline search
  $("#btn-change-date").bind('click', function(){
    var arrival_date = $("#search_checkin_inline").val();
    var departure_date = $("#search_checkout_inline").val();

    g_hashParams["arrival_date"] = arrival_date;
    g_hashParams["departure_date"] = departure_date;
    $("#h_search_checkin_inline").val(arrival_date);
    $("#h_search_checkout_inline").val(departure_date);
    searchHotels(false);
  });
//---End bind event

//-- function show multiple location
function show_light_box(cache, destination_string){
      var cache_data = cache[destination_string.replace(/^\s+|\s+$/g, '')];
      var box_content  =  $("#multiple_location_content");
      box_content.empty();
      $.each(cache_data, function(index, ele){
        $('<input />').attr('type', 'radio')
                .attr('name', 'light_box_location')
                .attr('value', ele.id + "_" + ele.category).attr('style', 'margin:0')
                .appendTo(box_content);
        $('<span>').text(" " + ele.value).appendTo(box_content);
        $('<br/>').appendTo(box_content);
      });
      $.fancybox({
        'content' : $("#multiple_location_div").html(),
      });

    }
//-- end function show multiple location

//-- Check multiple location function
function check_multiple_location(destination_string, arrival_date, departure_date, rooms){
   $("#fancybox-content #popup_destination").blur();
   $("#fancybox-content").mask("Loading...");
      if(!g_is_selected && (destination_item_count > 0 && destination_string != "" && destination_string != default_destination_input) || destination_string.length <3){
        $.ajax({
          data: {
            'destination_string': destination_string,
            'arrival_date': arrival_date,
            'departure_date': departure_date,
            'rooms': JSON.stringify(rooms)
          },
          url: "/hotels/validate_hotel_list_result",
          dataType: "json",
          type: "GET",
          success: function (data) {
            $("#fancybox-content").unmask();
            if(data.status =="light_box"){
              show_light_box(cache, destination_string);

            }else{
              g_hashParams = g_hashParam_tmp;
              g_fancy_html = g_fancy_html_tmp;
              g_first_open_fancy =false;
              $.fancybox.close();
              //---Apply info to inline text
              $("#hotel_location").text("Hotels in "+destination_string);
              $("#search_checkin_inline").val(arrival_date);
              $("#search_checkout_inline").val(departure_date);
              //--End apply
              searchHotels(false);
            //  form.submit();
            }

          },
          error: function (err_result) {
          }
         });
      }else{
        if($("#fancybox-content #item-category").val() == "Hotels")
          {
            //calculation room info text
            var item_id = $("#item-id").val();
            var total_adults= 0;
            var total_rooms =0;
            var total_children = 0;
            var arrival_date = $("#checkin_1").val();
            var departure_date = $("#checkout_1").val();
            var rooms = [];
            var room_groups = $("#fancybox-content .room-group:visible");
              $.each(room_groups, function(index, ele){
                var room = {};
                total_rooms +=1;
                  var adults = $(ele).find("#adult-1");
                  if (adults){
                    total_adults += parseInt(adults.val());
                    room["adults"] = adults.val();
                  }else{
                    room["adults"] = 0;
                  }
                  var children = $(ele).find("#children-1");
                  if (children){
                    total_children += parseInt(children.val());
                    room["children"] = children.val();
                    var ages = [];
                    for (var i=0; i < room["children"]; i++){
                      var age = $(ele).find("#age-" + i);
                      if (age){
                        ages.push(age.val());
                      }
                    }
                    room["ages"] = ages;
                  }
                  else{
                    room["children"] = 0;
                  }
                  rooms.push(room);
                });
            window.location = g_urlshow.replace("/2","/"+$("#fancybox-content #item-id").val())+"?is_index=true&roomInfos="+encodeURIComponent(total_rooms+" room(s), "+total_adults+" adult(s), "+ total_children+" children")+"&item_id="+item_id+"&arrival_date="+arrival_date+"&departure_date="+departure_date+"&rooms="+encodeURIComponent(JSON.stringify(rooms));
          }
          else
          {
            g_hashParams = g_hashParam_tmp;
            g_fancy_html = g_fancy_html_tmp;
            g_first_open_fancy =false;
            $.fancybox.close();
            //---Apply info to inline text
            $("#hotel_location").text("Hotels in "+destination_string);
            $("#search_checkin_inline").val(arrival_date);
            $("#search_checkout_inline").val(departure_date);
            //--End apply
            searchHotels(false);
          }
        //form.submit();
      }
    }
//-- End check multiple location function

//---Handle multiple location popup search
$("#fancybox-content #light_box_search_all_btn").live('click', function(){
  var light_box_value = $("[name$=light_box_location]:checked").val();
  if($("[name$=light_box_location]:checked").length == 0){
    alert("Please select a destination to search");
    return false;
  }
  var location_label = $("[name$=light_box_location]:checked").next('span').text().trim();

  if(light_box_value){
    g_hashParams = g_hashParam_tmp;
    var arrival_date = $("#checkin_1").val();
    var departure_date = $("#checkout_1").val();
    $("#item-id").val(light_box_value.split("_")[0].trim());
    $("#item-category").val(light_box_value.split("_")[1].trim());
    $("#popup_destination").val(location_label);
    g_city_flag = true;
    g_hashParams["item_category"] = light_box_value.split("_")[1].trim();
    g_hashParams["item_id"] = light_box_value.split("_")[0].trim();
    g_hashParams["destination_string"] = location_label;
    g_fancy_html = $("#fancybox-content").html();
    g_first_open_fancy = false;
    g_fancy_html = g_fancy_html_tmp;
    $("#hotel_location").text("Hotels in "+location_label);
    $.fancybox.close();
    searchHotels(false);
    //search_submit(true);
  }
});
//-- End Handle
//--- Handle Search button on modal popup
    $("#fancybox-content #search-all-btn").live('click', function(){
      //var light_box_value = $("[name$=light_box_location]:checked").val();
      if($("#fancybox-content #popup_destination").length == 0){
        alert("Please select a destination to search");
        return false;
      }
      var location_label = $("#fancybox-content #popup_destination").val().trim();

      //if(light_box_value){
        //$("#fancybox-content #item-id").val(light_box_value.split("_")[0].trim());
        //$("#fancybox-content #item-category").val(light_box_value.split("_")[1].trim());
        //$("#fancybox-content #search-destination").val(location_label);
        //city_flag = true;
        search_submit();
      //}
    });
  //--- End Handle Search button

  //Reset the end date textbox
    function resetEndDate(dateText, inst) {
        if ($('#checkin_1').val() != default_check_in_input){
          var minDate = $('#checkin_1').datepicker('getDate');
          var maxDate = new Date(minDate);
          maxDate.setDate(maxDate.getDate() + 2);
          $('#checkout_1').val($.datepicker.formatDate('mm/dd/yy', maxDate));
        }
    }
  //-- Set Range function
  function setRange() {
        if ($('#checkin_1').val() != default_check_in_input){
          var minDate = $('#checkin_1').datepicker('getDate');
        }
        else{
          var minDate = dateToday;
        }
        var maxDate = new Date(minDate);
        minDate.setDate(minDate.getDate() + 1);
        maxDate.setDate(maxDate.getDate() + 28);
        return {
            minDate: minDate,
            maxDate: maxDate
        }
    }

    function resetEndDate_inline(dateText, inst) {
        if ($('#search_checkin_inline').val() != default_check_in_input){
          var minDate = $('#search_checkin_inline').datepicker('getDate');
          var maxDate = new Date(minDate);
          maxDate.setDate(maxDate.getDate() + 2);
          $('#search_checkout_inline').val($.datepicker.formatDate('mm/dd/yy', maxDate));
        }
    }
  //-- Set Range function
  function setRange_inline() {
        if ($('#search_checkin_inline').val() != default_check_in_input){
          var minDate = $('#search_checkin_inline').datepicker('getDate');
        }
        else{
          var minDate = dateToday;
        }
        var maxDate = new Date(minDate);
        minDate.setDate(minDate.getDate() + 1);
        maxDate.setDate(maxDate.getDate() + 28);
        return {
            minDate: minDate,
            maxDate: maxDate
        }
    }
    
	// Init href click event to alert some 
	function init_href_click_event(){
		$('.hotel-detail-href').unbind('click');
		$('.hotel-detail-href').click(function(){
			$.ajax({
				url: this.href.replace(/hotels\/[0-9]*\?/,"hotels/check_show?")
			})
			return false;	
		});
	}
