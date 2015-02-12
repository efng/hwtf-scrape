var myPageRefresh;


var disableAutoRefresh = function(){
  clearTimeout(myPageRefresh);
  $('#stopAutoRefresh').prop("disabled",true).prop("value","Auto Refresh Off");
}

var updatePageRefresh = function(delay){
  clearTimeout(myPageRefresh);
  setPageRefresh(delay);
  $('#stopAutoRefresh').prop("disabled",false);
  $('#stopAutoRefresh').prop("value","Stop Auto Refresh");
};

var setPageRefresh = function(delay){
  var currentPage = window.location.href
  myPageRefresh = setTimeout(function(){ window.location.href = currentPage;}, delay );
  
}

$(document).ready(function(){
setPageRefresh(90000);
});