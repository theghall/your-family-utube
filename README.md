This app is a WIP.

 Safe-T-Tube allows:
 1) A parent to create a list of vetted videos
 2) A parent or child to add to a viewing list from the vetted videos
 
 Both features above are working.  Tagging has been modeled, but it is not yet implemented.
 
 You try out what's working so far at: [Safe-T-Tube](https://vast-dawn-24320.herokuapp.com/)
 
 NOTE: When entering a youtube video id it is not the entire URL as in https://www.youtube.com/watch?v=FfYm_bOO50M, but rather
 FfYm_bOO50M is all that you need enter. Validation of that field will be added in the future.
 
 A future modification will be to use the developer API so that the thumbnails can be downloaded and be turned into clickable images that will 
 bring up a viewer.  This will enhance performance and keep more than one video from being played at a time.
 
 Also, since YouTube videos can have embedded links, for this to truly prevent kids from going to YouTube a parent would have to install a
 web filter; One that lets them easily disable it so they can get to YouTube when adding videos.  Or I could implement one that interacts with
 the parent mode of this app.  For now by disabling controls I can at least make a nod in that direction as it removes the YouTube branding 
 image, but it does take away a visible pause button.