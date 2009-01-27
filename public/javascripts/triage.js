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

var toggle=0;

function makeEditable() {
  $$('.edit_button').invoke('toggle');
  $$('.delete_button').invoke('toggle');
  $$('.operational').invoke('toggle');
  toggle = 1-toggle;
  if(toggle == 1) {
    $$('.actual_button').invoke('disable');
  } else {
    $$('.actual_button').invoke('enable');
  }
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
