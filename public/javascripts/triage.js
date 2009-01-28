function hackery(response) {
  alert(response.responseText);
  if(response.responseText != null) {
    addNewBucket(response.responseXML);
  }
}

function addNewBucket(xml) {
  tag = xml.getElementsByTagName('tag')[0].childNodes[0].nodeValue;
  desc = xml.getElementsByTagName('description')[0].childNodes[0].nodeValue;

  alert("Got tag '" + tag + "', with description '" + desc + "'.");
}

var editable=false;

function makeEditable() {
  editable = !editable;
  if(editable) {
    $$('.actual_button').invoke('disable');
  } else {
    $$('.actual_button').invoke('enable');
    hideBucketForm();
  }
  $$('.edit_button').invoke('toggle');
  $$('.delete_button').invoke('toggle');
  $$('.new_button').invoke('toggle');
  $$('.skip_button').invoke('toggle');
}

function nuke(elem) {
  $(elem).remove();
}

function editBucketForm(tag, desc, milestone_id, state, boilerplate) {
  var form = $('new_bucket');
  form['bucket_tag'].value = tag;
  form['bucket_description'].value = desc;
  form['bucket_state'].value = state;
  form['bucket_milestone_id'].value = milestone_id;
  form['bucket_boilerplate'].value = boilerplate;

  toggleBucketForm();
}
