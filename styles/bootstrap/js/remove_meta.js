//include jquery to remove link around images
var jq = document.createElement("script");
jq.addEventListener("load", proceed);
jq.src = "../../styles/bootstrap/js/jquery-3.2.1.min.js";
document.querySelector("head").appendChild(jq);
function proceed () {
    $("a > img").unwrap();
    // include disclaimer
    $(".disclaimer").load("../../html/disclaimer.html");
}
// hide meta-data and display filename at meta section
var divsToHide = document.getElementsByClassName("gist-meta");
var fileName = "";
for(var i = 0; i < divsToHide.length; i++){
    divsToHide[i].style.display = "none";
    divsToHide[i].style.display = "none";
    fileName = document.getElementsByClassName("gist-meta")[i].children[1];
    var meta = document.createElement('meta');
    meta.name = "gist-file-" + i;
    meta.content = fileName;
    document.getElementsByTagName('head')[0].appendChild(meta);
}
// hide border
var bordersToHide = document.getElementsByClassName("gist-file");
for(var i = 0; i < bordersToHide.length; i++)
    bordersToHide[i].style.border = "none";