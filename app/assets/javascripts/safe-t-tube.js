$(document).ready(function () {

   // Chrome won't submit form if button is disabled directly
   $('body').on('submit','form',function() {
       $('form#clear-submit').prop('disabled', true);
   }); 

   $('body').on('click','#search-submit',function() {
       $('#clear-submit').prop('disabled', false);
   }); 
});