function run() {
    // Create a palette named "Sample Palette" and load the capture.html file
    Acad.Application.addPalette("TOOL LAYOUTING - NTB", "C:/App/layout_lisp_/ui/palette.html");
    localStorage.setItem("lpal", 1);
}

if(localStorage.getItem("lpal") == 1) {
    run();
}