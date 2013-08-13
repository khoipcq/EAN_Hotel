$(document).ready(function(){

    // re-position autocomplete listbox if resizing browser window
    var resizeTimer;
    $(window).bind('resize', function(e){
      if ($(".ui-autocomplete").css('display') == 'block'){
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function(){
          $("#search-destination").focus();
          //$("#search-destination").catcomplete("search");
        }, 0);
      }
    });

  // some regexes for validations
  var dob_regex = /^([0-9]){2}(\/){1}([0-9]){2}(\/)([0-9]){4}$/;   // DD/MM/YYYY
  var email_regex = /^[a-zA-Z0-9._-]+@([a-zA-Z0-9.-]+\.)+[a-zA-Z0-9.-]{2,4}$/;  // email address
  var username_regex = /^[\w.-]+$/;  // allowed characters: any word . -, ( \w ) represents any word character (letters, digits, and the underscore _ ), equivalent to [a-zA-Z0-9_]
  var num_regex = /^\d+$/; // numeric digits only
  var search_regex = "/hello/";
  var password_regex = /^[A-Za-z\d]{6,8}$/;  // any upper/lowercase characters and digits, between 6 to 8 characters in total
  var phone_regex = /^\(\d{3]\) \d{3}-\d{4}$/;  // (xxx) xxx-xxxx
  var question_regex = /\?$/; // ends with a question mark
  var destination_item_count = -1;
  var city_flag = false;
  var is_selected = false;

  // end regexes for validations

  //reset text on search text box
  $(".search-field-text").blur(function(){
    reset_to_default($(this)[0]);
  })
  $(".search-field-text").focus(function(){
    focus_input($(this)[0]);
  })

  function focus_input(e){
    if(e.value == default_destination_input
      || e.value == default_check_in_input
      || e.value == default_check_out_input)
      e.value = "";

    e.style.color = "black";
  }

  function reset_to_default(e){

    if(e.value != ""){
      e.style.color = "black";
      return;
    }
    e.style.color = "#b0b0b0";

    if(e.id == "search-destination"){
      e.value = default_destination_input;
    }
    else if(e.id == "search-checkin"){
      e.value = default_check_in_input;
    }
    else if(e.id == "search-checkout"){
      e.value = default_check_out_input;
      //setRange();
    }
    e.style.color = "#b0b0b0";
    return;
  }

  function show_error(){
    /*
    var error = JSON.parse('<%= raw (@error.to_json) %>');
    if (error){
      var type = error["type"];
      var category = error["category"];
      var content = "There is an error with your request. Please try again!";
      if (error.error_code == "Multiple Locations"){
        content = error.user_message;
        <% if @error %>
          <% @error["other_info"].each_with_index do |location, index| %>
            <% if index != 0 %>
              content += ' - <%= location["city"] %>';
              <% unless location["stateName"].nil? %>
                content += ', <%= location["stateName"] %>';
              <% end %>
              content += ', <%= location["countryName"] %>';
            <% else %>
              content += '<%= location["city"] %>';
              <% unless location["stateName"].nil? %>
                content += ', <%= location["stateName"] %>';
              <% end %>
              content += ', <%= location["countryName"] %>';
            <% end %>
          <% end %>
        <% end %>
        console.log(error);
        alert(content);
      }
    }
    else{
      return;
    }
    */
  }

  show_error();

  // set autofocus on search box
  $("#search-destination").val(default_destination_input);
  $("#search-destination").focus();

  var txtStartDate = $("#search-checkin");
  var txtEndDate = $("#search-checkout");
  var dateToday = new Date();

  // set default value of dates: today and today + 2
  var checkoutDate = new Date(dateToday);
  checkoutDate.setDate(dateToday.getDate() + 2);
  $('#search-checkin').val($.datepicker.formatDate('mm/dd/yy', dateToday));
  $('#search-checkout').val($.datepicker.formatDate('mm/dd/yy', checkoutDate));

  // functions for Datepicker
  $(function() {

   // add datepicker of jQuery UI
    var dates = $("#search-checkin").datepicker({
      defaultDate: dateToday,
      numberOfMonths: 1,
      minDate: dateToday,
      onSelect: function(selectedDate) {
        var option = this.id == "search-checkin" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      onClose: resetEndDate
    });

    var dates = $("#search-checkout").datepicker({
      defaultDate: "+1w",
      numberOfMonths: 1,
      minDate: dateToday,
      maxDate: "+28D",
      onSelect: function(selectedDate) {
        var option = this.id == "search-checkin" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        dates.not(this).datepicker("option", option, date);
        this.style.color = "black";
      },
      beforeShow: setRange,
      onClose: setNight
    });

    function setRange() {
        if ($('#search-checkin').val() != default_check_in_input){
          var minDate = txtStartDate.datepicker('getDate');
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
    function setNight(){
      var nights = ($.datepicker.parseDate("mm/dd/yy",$('#search-checkout').val()) - $.datepicker.parseDate("mm/dd/yy",$('#search-checkin').val()))/86400000;
      $('#nights').val(nights);
    }
    //Reset the end date textbox
    function resetEndDate(dateText, inst) {
        if ($('#search-checkin').val() != default_check_in_input){
          var minDate = txtStartDate.datepicker('getDate');
          var maxDate = new Date(minDate);
          maxDate.setDate(maxDate.getDate() + 2);
          $('#search-checkout').val($.datepicker.formatDate('mm/dd/yy', maxDate));
          $('#nights').val(2);
        }
    }

    // allow delete date fields by Backspace key and Delete key
    $("#search-checkin").keydown(function(event) {
      if (event.which === 8 || event.which === 46) {
        $(this).val("");
      }
      //return false;
    });
    $("#search-checkout").keydown(function(event) {
      if (event.which === 8 || event.which === 46) {
        $(this).val("");
      }
      //return false;
    });

    $("#search-checkin").attr('readonly', true);
    $("#search-checkout").attr('readonly', true);
 });

  // functions for Auto-complete
  $(function(){

    //highlight words in sentence
    //now handle by server-side
    function emphasize_keywords(keywords, sentence){
      $.each(keywords, function(index, keyword){
        var string = "\\b" + keyword;
        var regex = new RegExp(string, "g");
        sentence = sentence.replace(regex, "<emp>" + keyword + "</emp>");
      });
      return sentence;
    }

    // BEGIN New autocomplete with categories
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
      _renderMenu: function( ul, items ) {
        var that = this;
        currentCategory = "";
        $.each( items, function( index, item ) {
          if ( item.category != currentCategory ) {
            ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
            currentCategory = item.category;
          }
          that._renderItemData( ul, item );
        });
      },
      _renderItemData: function(ul, item){
        //emphasize search words => now handle by server-side
        //item.label = emphasize_keywords(words, item.value);

        return $("<li></li>")
            .data("item.autocomplete", item)
            .append("<a class='ui-corner-all'>" + item.label + "</a>")
            .appendTo(ul);
      }
    });

    //Caching here
    cache = [];
    $( "#search-destination" ).catcomplete({
      delay: 0,
      minLength: 3,
      source:  function (request, response) {
        var term = request.term.replace(/^\s+|\s+$/g, '');
        is_selected = false;
        if (term in cache){
          destination_item_count = cache[term].length;
          city_flag = cache[term + "_city_flag"];
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
            city_flag = data[1]["city_flag"];
            destination_item_count = new_data.length;
            response(new_data);
            is_selected = false;
          },
          error: function (result) {
            //alert("Error:" + result.statusText);
            is_selected = false;
          }
        });
        $("#no_result").hide();
      },
      select : function(event, ui) {
              ui.item.value = ui.item.label.replace(/<(?:.|\n)*?>/gm, '');
              is_selected = true;
              $("#item-id").val(ui.item.id);
              $("#item-category").val(ui.item.category);
          }
      }).bind("keyup", function(e) {
        // hide error messages when typing
        $("#no_result").hide();
        $("#blank_destination").hide();
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
              $("#item-category").val("Destination");
            }
          }
          $("#search-all-btn").click();
          return false;
        }
        else {
          window.previousKeyCode = keycode;
          return true;
        }
      }).bind("focus", function(e) {
        $("#search-destination").catcomplete("search");
      });
    // END New autocomplete with categories

    //Show light box
    function show_light_box(cache, destination_string, form){
      
      var cache_data = cache[destination_string.replace(/^\s+|\s+$/g, '')];
      var box_content  =  $("#light_box_content");
      box_content.empty();
      if(!cache_data){
        $.ajax({
          data: {'s': destination_string.replace(/^\s+|\s+$/g, '')},
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

            cache_data = new_data;
            city_flag = data[1]["city_flag"];
            if(cache_data.length > 0 && !city_flag && city_flag != undefined){
              if(cache_data.length == 1){
                $("#search-destination").val(cache_data[0].value);
                $("#item-id").val(cache_data[0].id);
                $("#item-category").val(cache_data[0].category);
                form.submit();
                return true;
              }
              console.log("shit");
              fill_light_box_data(cache_data, box_content);
              $.fancybox({
                'content' : $("#box_text").html()
              });
            }else{
              $("#no_result").show();
              return false;
            }

          },
          error: function (result) {
            is_selected = false;
            $("#no_result").show();
            return false;
          }
        });
      }else{
        if(cache_data.length > 0){
          if(cache_data.length == 1){
            $("#search-destination").val(cache_data[0].value);
            $("#item-id").val(cache_data[0].id);
            $("#item-category").val(cache_data[0].category);
            if($("#item-category").val() == "Hotels")
            {
              search_one_item();
            }
            else
            {
              form.submit();
            }
            return true;
          }
          fill_light_box_data(cache_data, box_content);
          $.fancybox({
            'content' : $("#box_text").html(),
          });
        }else{
          $("#no_result").show();
          return false;
        }
      }
    }

    function fill_light_box_data(cache_data, box_content){
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
    }

    // submit search form
    function validate_search(){
      var arrival_date = $("#search-checkin").val();
      var departure_date = $("#search-checkout").val();
      var destination_string = $("#search-destination").val();
      $("#no_result").hide();
      if (destination_string == "" || destination_string == default_destination_input){
        $("#blank_destination").show();
        return false;
      }
      return true;
    }

    //Check Multiple Location
    function check_multiple_location(destination_string, arrival_date, departure_date, rooms, form){
      if(!is_selected && (destination_string != "" && destination_string != default_destination_input)){
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

            if(data.status == "light_box"){

              show_light_box(cache, destination_string, form);
            }else if(data.status == "nok"){
              if(!city_flag && city_flag != undefined){
                console.log("rtttttttttttttt");
                show_light_box(cache, destination_string, form);
              }else{
                $("#no_result").show();
                return false;
              }
            }else{
              form.submit();
            }

          },
          error: function (err_result) {
            $("#no_result").show();
            return false;
          }
         });
      }

      else{
          if($("#item-category").val() == "Hotels")
          {
            search_one_item();
          }
          else
          {
            form.submit();
          }
      }
    }

    function search_one_item(){
            var item_id = $("#item-id").val();
            var total_adults= 0;
            var total_rooms =0;
            var total_children = 0;
            var arrival_date = $("#search-checkin").val();
            var departure_date = $("#search-checkout").val();
            var destination_string = $("#search-destination").val();
            var rooms = [];
            var room_groups = $(".room-group:visible");
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
            window.location = g_urlshow.replace("/2","/"+$("#item-id").val())+"?is_index=true&roomInfos="+encodeURIComponent(total_rooms+" room(s), "+total_adults+" adult(s), "+ total_children+" children")+"&item_id="+item_id+"&arrival_date="+arrival_date+"&departure_date="+departure_date+"&rooms="+encodeURIComponent(JSON.stringify(rooms))+"&destination_string="+destination_string;
    }

    function search_submit(is_from_light_box){
      if (validate_search()){
        var item_id = $("#item-id").val();
        var arrival_date = $("#search-checkin").val();
        var departure_date = $("#search-checkout").val();
        var destination_string = $("#search-destination").val();
        //get form tag
        var form  = $("#search-all-btn").closest("form");
        var values = {};
        $.each(form.serializeArray(), function(i, field){
            values[field.name] = field.value;
        });
        var total_adults= 0;
        var total_rooms =0;
        var total_children = 0;
        var room_groups = $(".room-group:visible");
        var rooms = [];
        $.each(room_groups, function(index, ele){
          var room = {};
          total_rooms +=1;
          var adults = $(ele).find("#adult-1");
          if (adults){
            total_adults += parseInt(adults.val());
            room["adults"] = adults.val();
          }
          else{
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
        })

          $.each(values, function(i,param){
              $('<input />').attr('type', 'hidden')
                  .attr('name', param.name)
                  .attr('value', param.value)
                  .appendTo(form);
          });
           $('<input />').attr('type', 'hidden')
                   .attr('name', "rooms")
                   .attr('value', JSON.stringify(rooms))
                   .appendTo(form);
        form.serialize();
        if(!is_from_light_box){

          check_multiple_location(destination_string, arrival_date, departure_date, rooms, form)
        }else{
          if($("#item-category").val() == "Hotels")
          {
            window.location = g_urlshow.replace("/2","/"+$("#item-id").val())+"?is_index=true&roomInfos="+encodeURIComponent(total_rooms+" room(s), "+total_adults+" adult(s), "+ total_children+" children")+"&item_id="+item_id+"&arrival_date="+arrival_date+"&departure_date="+departure_date+"&rooms="+encodeURIComponent(JSON.stringify(rooms))+"&destination_string="+destination_string;
          }
          else{
            form.submit();
          }
        }
      }
    }

    $("#search-all-btn").bind('click', function(){
      if(!is_selected){
        $("#item-category").val("Destination");
      }
      search_submit(false);
    });

    $("#light_box_search_all_btn").live('click', function(){
      var light_box_value = $("[name$=light_box_location]:checked").val();
      if($("[name$=light_box_location]:checked").length == 0){
        alert("Please select a destination to search");
        return false;
      }
      var location_label = $("[name$=light_box_location]:checked").next('span').text().trim();

      if(light_box_value){
        $("#item-id").val(light_box_value.split("_")[0].trim());
        $("#item-category").val(light_box_value.split("_")[1].trim());
        $("#search-destination").val(location_label);
        city_flag = true;
        search_submit(true);
      }
    });
  });


  // show more adults comboboxes
  $("#search-room").change(function(){
    var number_of_room = $(this).val();
    //hide all room group
    $(".room-group").hide();

    if (number_of_room <= 1){
      $("#room-field-first").attr('style','visibility:hidden');
    }
    else{
      $("#room-field-first").attr('style','visibility:visible');
    }

    for (var i=0; i<number_of_room; i++){
      //if this room HTML is already in DOM, keep it as it is
      var room_group_div = $("#room-group-" + i);

      if (room_group_div.length > 0){
        room_group_div.show();
        continue;
      }else{
        //create new room group
        var room_group_div = $("#room-group-template").clone();
        room_group_div.attr("id", "room-group-" + i);
        room_group_div.addClass("room-group");
        var room_field = room_group_div.find(".room-field");
        room_field.html('Room ' + (i+1) + ':');
        $("#room-group-container").append(room_group_div);
      }
    }
  });

  // show more ages box
  // show more adults comboboxes
  $(".child-box").live('change', function(e){
    var number_of_children = parseInt($(this).val());
    var parent = $(this).parent();
    //hide all children node with class .search-age
    parent.find(".age-block").hide();

    //display children nodes that corresponding with number of children
    for(var i=0; i<number_of_children; i++){
      parent.find("#age-block-" + i).show();
    }
  });
  $("#search-room").trigger("change");
  $(".child-box").trigger("change");
})