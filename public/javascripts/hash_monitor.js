var curHash='';

var hashCheckInterval = setInterval("checkHash()", 1000);

function checkHash() {
  if(document.location.hash != curHash) {
    curHash = document.location.hash;
    if(window.onHashChange) {
      onHashChange(curHash.substr(1));
    } else {
      // If there isn't a onHashChange on the page, don't waste time
      // looking for hash changes.
      hashCheckInterval.cancelInterval();
    }
  }
}
