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

function showBucketForm() {
  $$('.cancel_button').invoke('show');
  $$('.new_button').invoke('hide');
  if(!$('popup_bucket').visible()) {
    try {
      new Effect.SlideDown("popup_bucket",{duration:0.33});
    } catch (e) {
      alert('RJS error:\n\n' + e.toString()); alert('new Effect.SlideDown(\"popup_bucket\",{duration:0.33});');
      throw e;
    }
  }
}

function hideBucketForm() {
  $$('.cancel_button').invoke('hide');
  $$('.new_button').invoke('show');
  if($('popup_bucket').visible()) {
    try {
      new Effect.SlideUp("popup_bucket",{duration:0.33});
    } catch (e) {
      alert('RJS error:\n\n' + e.toString()); alert('new Effect.SlideDown(\"popup_bucket\",{duration:0.33});');
      throw e;
    }
  }
}

function editBucketForm(id, tag, desc, milestone_id, state, boilerplate) {
  var form = $('new_bucket');
  form.reset();
  form['bucket_tag'].value = tag;
  form['bucket_description'].value = desc;
  form['bucket_state'].value = state;
  form['bucket_milestone_id'].value = milestone_id;
  form['bucket_boilerplate'].value = boilerplate;
  form['bucket_id'].value = id;
  form['bucket_submit'].value = 'Save';

  showBucketForm();
}

function newBucketForm() {
  var form = $('new_bucket');
  form.reset();
  form['bucket_id'].value = '';
  form['bucket_submit'].value = 'Create';

  showBucketForm();
}
