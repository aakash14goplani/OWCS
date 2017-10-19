//include jquery
var jq = document.createElement("script");
jq.addEventListener("load", proceed);
jq.src = "../../styles/bootstrap/js/jquery-3.2.1.min.js";
document.querySelector("head").appendChild(jq);
function proceed () {
    $("a > img").unwrap();
}
// hide meta-data
var divsToHide = document.getElementsByClassName("gist-meta");
for(var i = 0; i < divsToHide.length; i++)
    divsToHide[i].style.display = "none";
// hide border
var bordersToHide = document.getElementsByClassName("gist-file");
for(var i = 0; i < bordersToHide.length; i++)
    bordersToHide[i].style.border = "none";