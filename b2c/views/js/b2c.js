function moveForgotPassword() {
  const forgotPasswordId = 'forgotPassword'
  const forgotPassword = document.getElementById(forgotPasswordId);

  if (forgotPassword) {
    const text = forgotPassword.innerHTML;
    forgotPassword.remove();

    const newForgotPassword = document.createElement('a');
    newForgotPassword.id = forgotPasswordId;
    newForgotPassword.innerHTML = text;
    newForgotPassword.href = forgotPassword.href;

    const div = document.createElement('div');
    div.appendChild(newForgotPassword);

    const passwordInput = document.getElementById('password');
    passwordInput.parentNode.insertBefore(div, passwordInput.nextSibling);
  }
}
function moveRetryCode() {
  const retryCode = document.getElementById('retryCode');

  if (retryCode) {
    const text = retryCode.innerHTML;
    retryCode.remove();

    const newRetryCode = document.createElement('a');
    newRetryCode.id = 'retryCode';
    newRetryCode.innerHTML = text;

    const div = document.createElement('div');
    div.appendChild(newRetryCode);

    const verificationCodeInput = document.getElementById('verificationCode');
    verificationCodeInput.parentNode.insertBefore(div, verificationCodeInput.nextSibling);
  }
}

function addTsAndCsLink() {
  const tsAndCsBlock = document.getElementsByClassName('CheckboxMultiSelect')[0];
  if (tsAndCsBlock) {
    const tsAndCsLabel = tsAndCsBlock.getElementsByTagName('label')[0];
    const tsAndCsText = tsAndCsBlock.getElementsByTagName('label')[1];
    // fix the wrong for attribute supplied by B2C
    tsAndCsLabel.setAttribute('for', tsAndCsText.getAttribute('for'));
    if (tsAndCsText) {
      tsAndCsText.innerHTML = tsAndCsText.innerHTML = 'I agree to the <a href="https://{hostname}/terms-and-conditions" target="_blank">Terms &amp; Conditions</a> (including Acceptable Use) for the Section 28 Video on Demand Portal.'
    }
  }
}

function addPasswordCriteria() {
  const passwordAttrEntry = document.querySelector('#attributeList li.Password .attrEntry');
  if (passwordAttrEntry) {
    // passwordAttrEntry.setAttribute('style', 'margin-bottom: 2px;');
    const passwordDetails = document.createElement('details');
    passwordDetails.setAttribute('class', 'govuk-details');
    passwordDetails.setAttribute('data-module', 'govuk-details');
    passwordDetails.setAttribute('style', 'margin-top: 2px;');
    passwordDetails.innerHTML = '<summary class="govuk-details__summary">\n' +
      '                          <span class="govuk-details__summary-text">Password criteria</span>\n' +
      '                        </summary>\n' +
      '                        <div class="govuk-details__text">\n' +
      '                          Passwords must have at least 8 characters. <br />\n' +
      '                          Passwords must contain characters from at least three of the\n' +
      '                          following four classes: uppercase, lowercase, digit, and\n' +
      '                          non-alphanumeric (special).\n' +
      '                        </div>';
    passwordAttrEntry.appendChild(passwordDetails);
  }
}

function lowerCaseEmailAddresses() {
  // for our TLD email validation policy to work, we need the tld to be in lowercase...
  const emailInput = document.getElementById('email');
  if (emailInput) {
    emailInput.onblur = function () {
      emailInput.value = emailInput.value.toLowerCase();
    }
  }
  const signInName = document.getElementById('signInName');
  if (signInName) {
    signInName.onblur = function () {
      signInName.value = signInName.value.toLowerCase();
    }
  }
}

function removeAutofocus(){
  const inputFields = document.getElementsByTagName('input');
  for(let i=0; i<inputFields.length; i++){
    inputFields[i].removeAttribute('autofocus');
    inputFields[i].blur();
   }
}

$(function() {
  moveForgotPassword();
  moveRetryCode();
  addTsAndCsLink();
  addPasswordCriteria();
  lowerCaseEmailAddresses();
  removeAutofocus();
  $(window).on('pageshow', removeAutofocus);
});
