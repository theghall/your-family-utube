$(document).ready(function () {

   // Chrome won't submit form if button is disabled directly
   $('body').on('submit','form',function() {

       var formId = $(this).attr('id');

       switch (formId) {
       case 'tag-search-form':
          $('#clear-submit').prop('disabled', false);
	  break;
       case 'clear-submit-form':
         $('form#clear-submit').prop('disabled', true);
	 break;
       case 'new_video':
	 $('#error_explanation').remove();
	 break;
       }
   }); 
});
