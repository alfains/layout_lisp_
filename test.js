var doc = Acad.Application.activedocument;
var center = new Acad.Point3d(0, 0, 0);
var ucsCenter;
var radius = 0;
var jig;

function pointToString(pt) {
  var ret =
    pt.x.toString() + "," +
    pt.y.toString() + "," +
    pt.z.toString();
  return ret;
}

function distanceBetween(pt1, pt2) {
  var dist =
    Math.sqrt(
      (pt2.x - pt1.x) * (pt2.x - pt1.x) +
      (pt2.y - pt1.y) * (pt2.y - pt1.y) +
      (pt2.z - pt1.z) * (pt2.z - pt1.z)
    );
  return dist;
}

function createCircle(cen, rad, first) {

  // Build an XML string containing data to create
  // an AcGiTransient that represents the circle

  var cursor = '';
  
  var drawable =
    '<?xml version="1.0" encoding="utf-8"?>' +
    '<drawable ' +
    'xmlns="http://www.autodesk.com/AutoCAD/drawstream.xsd" ' +
    'xmlns:t="http://www.autodesk.com/AutoCAD/transient.xsd" '+
      't:onmouseover="onmouseover"' + cursor + '>' +
      '<graphics id="id1"><circle center ="' + pointToString(cen) +
          '" radius ="' + rad.toString() + '"/>' +
      '</graphics></drawable>';

  return drawable;
}

function circleJig() {

  function onJigUpdate(args) {

    var res = JSON.parse(args);
    if (res) {

      // We calculate the distance in the WCS
      // (using distance input we'd just do this:
      //  radius = res.distance; )

      var point =
        new Acad.Point3d(res.point.x, res.point.y, res.point.z);
      radius = distanceBetween(center, point);

      // Use it to create the XML for a transient
      // circle and ask for it to be displayed

      //var x = createCircle(center, radius);
      //jig.update(x, onJigContinue, onJigError);
      drawCircle(center, radius);
    }

    return true;
  }

  function onJigComplete(args) {

    clearCircle();

    var res = JSON.parse(args);
    if (res && res.dragStatus == Acad.DragStatus.kNormal) {

      Acad.Editor.executeCommandAsync(
        '_.CIRCLE ' + pointToString(ucsCenter) + ' ' + radius
      );
    }
  }

  function onJigContinue(args) {
  }

  function onJigError(args) {
    clearCircle();
    write('\nUnable to create circle: ' + args);
  }

  function onPointSelected(args) {

    try {
      var res = JSON.parse(args);
      if (res) {

        // Extract and transform our circle's center

        ucsCenter =
          new Acad.Point3d(
            res.value.x,
            res.value.y,
            res.value.z
          );
        center = Acad.Editor.CurrentViewport.ucsToWorld(ucsCenter);

        // Draw the circle with an initial 0 radius

        drawCircle(center, 0);

        // Set up our jig options

        var opts =
          new Acad.JigPromptPointOptions('Point on radius');
        opts.userInputControls =
          Acad.UserInputControls.kAccept3dCoordinates;

        // Run the jig to select the distance

        jig = new Acad.DrawJig(onJigUpdate, opts);
        Acad.Editor.drag(jig).then(onJigComplete, onJigError);
      }
    }
    catch (ex) {
      write('\nException: ' + ex + '\n');
    }
  }

  function onPointError(args) {
    write('\nUnable to select point: ' + args);
  }

  // Ask the user to select the center point before we
  // start the jig

  var opts = new Acad.PromptPointOptions('Select center');
  Acad.Editor.getPoint(opts).then(
    onPointSelected, onPointError
  );
}

// Our extensions to the AutoCAD Shaping Layer

function drawCircle(cen, rad) {
  execAsync(
    JSON.stringify({
      functionName: 'NetDrawCircle',
      invokeAsCommand: false,
      functionParams: {
        center: cen,
        radius: rad
      }
    }),
    onInvokeSuccess,
    onInvokeError
  );
}

function clearCircle() {
  execAsync(
    JSON.stringify({
      functionName: 'NetClearCircle',
      invokeAsCommand: false,
      functionParams: undefined
    }),
    onInvokeSuccess,
    onInvokeError
  );
}

function onInvokeSuccess(result) {
  write("\n");
}

function onInvokeError(result) {
  write("\nOnInvokeError: " + result);
}

Acad.Editor.addCommand(
  "JIG_CMDS",
  "CJ",
  "CJ",
  Acad.CommandFlag.MODAL,
  circleJig
);