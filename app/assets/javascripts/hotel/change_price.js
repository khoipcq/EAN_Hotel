jQuery(document).ready(function($) {
  money_sign = {
      "USD": "$",
      "EUR": "€",
      "AUD": "A$",
      "GBP": "£"
    };
  $("#price-display").change(function(){  
    searchHotels();
  });
  function searchHotels(){
  	g_hashParams["currencyCode"] = $("#price-display").val();
	  $.ajax({
	    url: "/hotels/get_price",
	    type: "GET",
	    data: g_hashParams,
	    success: function(result){
	    	//$('#booking_form input[name=money_sign]').val(money_sign[$("#price-display").val()]);
	    	$.each(result.result, function(index, ele){	    		
	    		if(ele.RateInfo.ConvertedRateInfo == undefined){
		    		$("#averageRate_" + ele.rateCode).text(money_sign[ele.RateInfo.ChargeableRateInfo["@currencyCode"]] + parseFloat(ele.RateInfo.ChargeableRateInfo["@averageRate"]).toFixed(2));
		    		$("#ChargeableRateInfo_" + ele.rateCode).text(money_sign[ele.RateInfo.ChargeableRateInfo["@currencyCode"]] + parseFloat(ele.RateInfo.ChargeableRateInfo["@total"]).toFixed(2));
	    		}else{
	    			$("#averageRate_" + ele.rateCode).text(money_sign[ele.RateInfo.ConvertedRateInfo["@currencyCode"]] + parseFloat(ele.RateInfo.ConvertedRateInfo["@averageRate"]).toFixed(2));
		    		$("#ChargeableRateInfo_" + ele.rateCode).text(money_sign[ele.RateInfo.ConvertedRateInfo["@currencyCode"]] + parseFloat(ele.RateInfo.ConvertedRateInfo["@total"]).toFixed(2));
	    		}
	    	});
	    }
	  });
	}
});
function getURLParameter(name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
}