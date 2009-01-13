var curHash='';

setInterval("checkHash()", 1000);

function checkHash() {
  if(document.location.hash != curHash) {
    curHash = document.location.hash;
    if(window.onHashChange) {
      onHashChange(curHash.substr(1));
    }
  }
}
