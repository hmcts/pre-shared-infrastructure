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

function removeAutofocus() {
  const inputFields = document.getElementsByTagName('input');
  for (let i = 0; i < inputFields.length; i++) {
    inputFields[i].removeAttribute('autofocus');
    inputFields[i].blur();
  }
}

function addDescriptiveErrors() {
  const verifyButton = document.getElementById('email_ver_but_send');
  const continueButton = document.getElementById('continue');
  const emailButton = document.getElementById('email');

  if (continueButton) {
    continueButton.addEventListener('click', validateErrors);
  }

  if (verifyButton) {
    verifyButton.addEventListener('click', validateErrors);
  }

  if (emailButton) {
    emailButton.addEventListener('click', validateErrors);
  }
}

function validateErrors() {
  const errorDivs = document.getElementsByClassName('error itemLevel');
  const pageLevelErrorDiv = document.getElementById('requiredFieldMissing');
  const errorFields = []

  if (errorDivs) {
    for (let i = 0; i < errorDivs.length; i++) {
      const input = errorDivs[i].nextElementSibling;

      if (input && input.tagName.toLowerCase() === 'input' && input.value.trim() === '') {
        const placeholderText = input.getAttribute('placeholder');
        const inputId = input.getAttribute('id');

        errorFields.push({
          placeholderText: placeholderText,
          inputId: inputId
        });
        errorDivs[i].textContent = `This field is required: ${placeholderText.toLowerCase()}`;

        pageLevelErrorDiv.className = "govuk-error-summary";

      } else {
        errorDivs[i].textContent = ''
      }

    }

  }

  if (errorFields) {
    pageLevelErrorDiv.innerHTML = `
            <p class="govuk-error-summary__title">The following required field(s) are missing:</p>
            <div class="govuk-error-summary__body">
            <ul class="govuk-list govuk-error-summary__list">
                 ${errorFields
      .map(field => `<li><a href="#${field.inputId}" style="color:rgb(212,53,19);">${field.placeholderText}</a></li>`)
      .join("")}
            </ul>
            </div>
    `;
  } else {
    pageLevelErrorDiv.textContent = "";
  }
}

function monitorVerificationErrors() {
  // Monitor for verification errors and make them visible
  const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
      // Check if any error divs became visible
      const emailFailRetry = document.getElementById('email_fail_retry');
      const emailFailNoRetry = document.getElementById('email_fail_no_retry');
      const emailFailCodeExpired = document.getElementById('email_fail_code_expired');
      const claimVerificationError = document.getElementById('claimVerificationServerError');

      // If any verification error is shown, make sure it's visible
      if (emailFailRetry && emailFailRetry.style.display !== 'none') {
        emailFailRetry.setAttribute('aria-hidden', 'false');
      }
      if (emailFailNoRetry && emailFailNoRetry.style.display !== 'none') {
        emailFailNoRetry.setAttribute('aria-hidden', 'false');
      }
      if (emailFailCodeExpired && emailFailCodeExpired.style.display !== 'none') {
        emailFailCodeExpired.setAttribute('aria-hidden', 'false');
      }
    });
  });

  // Observe the entire form for changes
  const form = document.getElementById('attributeVerification');
  if (form) {
    observer.observe(form, {
      attributes: true,
      attributeFilter: ['style', 'aria-hidden'],
      subtree: true,
      childList: true
    });
  }
}

function handleVerifyCodeClick() {
  const verifyButton = document.getElementById('email_ver_but_verify');
  const verificationInput = document.getElementById('email_ver_input');

  if (verifyButton && verificationInput) {
    verifyButton.addEventListener('click', function() {
      // After clicking verify, wait a moment and check if an error occurred
      setTimeout(function() {
        // Check if verification failed by looking at the page-level error
        const claimVerificationError = document.getElementById('claimVerificationServerError');
        const fieldIncorrectError = document.getElementById('fieldIncorrect');
        const emailFailRetry = document.getElementById('email_fail_retry');

        // If there's a hidden error, make it visible
        if (claimVerificationError && claimVerificationError.textContent.trim() !== '' &&
            claimVerificationError.style.display === 'none') {
          claimVerificationError.style.display = 'block';
          claimVerificationError.setAttribute('aria-hidden', 'false');
        }

        if (fieldIncorrectError && fieldIncorrectError.style.display === 'none' &&
            verificationInput.value.trim().length === 6) {
          // If the code is 6 digits but verification failed, show the retry error
          if (emailFailRetry) {
            emailFailRetry.style.display = 'block';
            emailFailRetry.setAttribute('aria-hidden', 'false');
          }
        }
      }, 500);
    });
  }
}

$(function () {
  moveForgotPassword();
  moveRetryCode();
  addTsAndCsLink();
  addPasswordCriteria();
  lowerCaseEmailAddresses();
  removeAutofocus();
  $(window).on('pageshow', removeAutofocus);
  addDescriptiveErrors();
  monitorVerificationErrors();
  handleVerifyCodeClick();
});
