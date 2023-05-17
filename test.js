// Define the callback function for the custom command
function zoomEntity() {
    try {
  
       // Set the options and prompt to use
       var peo = new Acad.PromptEntityOptions();
       peo.setMessageAndKeywords("\nSelect an object: ", "");
       peo.allowObjectOnLockedLayer = true;
  
       // Prompt the user to select an object
       Acad.Editor.getEntity(peo).then(onComplete, onError);
    }
    catch(e) {
       console.log(e.message);
    }
  }
  
  // If the getEntity function was successful, not necessarily that they selected an object
  function onComplete(jsonPromptResult) {
    try {
  
       // Parse the JSON string containing the prompt result
       var resultObj = JSON.parse(jsonPromptResult);
       if (resultObj && resultObj.status == 5100) {
  
          // If an object was successful selected, get the selected entity...
          var entity = new Acad.DBEntity(resultObj.objectId);
  
          // Get the extents of the entity
          var ext = entity.getExtents();
  
          // Zoom to the extents of the entity, choosing to animate the
          // view transition (if possible to do so)
          Acad.Editor.CurrentViewport.zoomExtents(ext.minPoint3d, ext.maxPoint3d, true);
       }
    }
    catch(e) {
       console.log(e.message);
    }
  }
  
  // General message to display if an error occurred during object selection
  function onError(jsonPromptResult) {
    console.log("\nProblem encountered.");
  }
  
  // Register the custom command, as transparent
  Acad.Editor.addCommand(
    "ZOOM_CMDS",
    "ZEN",
    "ZEN",
    Acad.CommandFlag.TRANSPARENT,
    zoomEntity
  );
  
  // Display a message in the AutoCAD Command line window
  console.log("\nRegistered ZEN command.\n");