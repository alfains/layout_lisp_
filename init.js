function run() {
    // Create a palette named "Sample Palette" and load the capture.html file
<<<<<<< Updated upstream
    Acad.Application.addPalette("TOOL LAYOUTING - NTB", "https://alfains.github.io/layout_lisp_/ui/palette.html").then(success,error);
=======
    Acad.Application.addPalette("TOOL LAYOUTING - NTB", "https://alfains.github.io/layout_lisp_/ui/palette.html");
    localStorage.setItem("lpal", 1);
>>>>>>> Stashed changes
}

window.addEventListener('beforeunload', (event) => {
    event.preventDefault();
    event.returnValue = '';
    alert("aaaa");
  });

if(localStorage.getItem("lpal") == 1) {
    run();
}
