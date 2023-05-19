function run() {
    // Create a palette named "Sample Palette" and load the capture.html file
    const palette = Acad.Application.addPalette("TOOL LAYOUTING - NTB", "C:/App/layout_lisp_/ui/palette.html");

    console.log("\nRegistered ZEN command.\n");
}

run();