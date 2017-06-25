// hide meta-data
var divsToHide = document.getElementsByClassName("gist-meta");
for(var i = 0; i < divsToHide.length; i++)
    divsToHide[i].style.display = "none";
// hide border
var bordersToHide = document.getElementsByClassName("gist-file");
for(var i = 0; i < bordersToHide.length; i++)
    bordersToHide[i].style.border = "none";