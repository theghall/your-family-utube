**This app is a WIP.**

## **Safe-T-Tube allows:**
 1) A parent to create a list of videos to vet and approve or delete them as desired.
 2) A parent or child to view videos that were approved for viewing.
 
 You try out what's working so far at: [Safe-T-Tube](https://vast-dawn-24320.herokuapp.com/)
 
## **Using the app:**
  * After creating your account and are logged in, you must create at least one profile to
 save videos under.
 
  * To add videos click 'Add Video'.  You will be prompted for your parent pin.
 
  * Before adding a video you must select a profile by clicking on one.

  * When you tab off the YouTube URL field or move focus to the tag field you will see the
 video in the viewer so you can see what you are entering tags for.
 
  * Each user has their own tag namespace, so other users' tags won't pollute yours. 
 
  * As you add videos the last video added is loaded into the video player.
 
  * You can change the current loaded video by clicking on the video thumbnails.
 
  * To approve a video click 'Approve'.  It will now be available for viewing under the
 profile you selected.
 
  * To delete a video click 'Delete'.  That video is no longer available.
 
  * You can search for videos by tag in either parent or viewing mode
 (Currently working on autocomplete for tags)

  * To exit the parent mode click 'Exit Parent Mode'.  You will be returned to the Home 
 screen.  As with the parent mode, clicking on a thumbnail loads the corresponding
 video into the player.
 
 
## **Notes** 

 Prior to 8/31 you had to add a video by the ID, now you can use the Share URL or
 link address of the video; the ID by itself will produce an error.
 
 Also, if prior to 9/6 you entered a valid URL you should see the proper thumbnail.  If you
 you see a gray film strip looking thumbnail, either there was an error retrieving
 it or that is the thumbnail.  You can try refreshing your browser.  When the videos
 are loaded for a profile an attempt is made to refresh those thumbnails.
