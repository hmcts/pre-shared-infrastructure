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
  // Support both old and new B2C element IDs
  const verifyButton = document.getElementById('EmailVerification_but_verify_code') || document.getElementById('email_ver_but_verify');
  const verificationInput = document.getElementById('EmailVerification_ver_input') || document.getElementById('email_ver_input');

  if (verifyButton && verificationInput) {
    // Intercept the verify button click
    verifyButton.addEventListener('click', function(e) {
      // Wait for the AJAX call to complete and check for errors
      setTimeout(function() {
        checkAndDisplayVerificationError();
      }, 500);

      // Also check again after a longer delay in case the request is slow
      setTimeout(function() {
        checkAndDisplayVerificationError();
      }, 1500);
    });
  }
}

function checkAndDisplayVerificationError() {
  // Try both old and new element ID patterns
  const emailFailRetry = document.getElementById('EmailVerification_error_message') ||
    document.getElementById('email_fail_retry');
  const emailFailNoRetry = document.getElementById('email_fail_no_retry');
  const emailFailCodeExpired = document.getElementById('email_fail_code_expired');
  const claimVerificationError = document.getElementById('claimVerificationServerError');
  const fieldIncorrectError = document.getElementById('fieldIncorrect');
  const verificationInput = document.getElementById('EmailVerification_ver_input') ||
    document.getElementById('email_ver_input');
  const emailSuccess = document.getElementById('EmailVerification_success_message') ||
    document.getElementById('email_success');

  // If success is not showing and we have a 6-digit code, there might be an error
  const hasEnteredCode = verificationInput && verificationInput.value.trim().length === 6;
  const successShowing = emailSuccess && (emailSuccess.style.display === 'block' ||
    emailSuccess.style.display === 'inline' ||
    emailSuccess.style.display === '');

  if (hasEnteredCode && !successShowing) {
    // Force the retry error message to show
    if (emailFailRetry) {
      emailFailRetry.style.display = 'block';
      emailFailRetry.setAttribute('aria-hidden', 'false');
      emailFailRetry.setAttribute('role', 'alert');

      // Also show it at the page level if not already showing
      if (fieldIncorrectError && fieldIncorrectError.style.display === 'none') {
        fieldIncorrectError.style.display = 'block';
        fieldIncorrectError.setAttribute('aria-hidden', 'false');
      }
    }

    // Check for server error message
    if (claimVerificationError && claimVerificationError.textContent.trim() !== '') {
      claimVerificationError.style.display = 'block';
      claimVerificationError.setAttribute('aria-hidden', 'false');
    }
  }
}

// Also intercept XHR requests to catch the error response directly
function interceptVerificationRequests() {
  // Store the original XMLHttpRequest
  const originalXHR = window.XMLHttpRequest;

  window.XMLHttpRequest = function() {
    const xhr = new originalXHR();

    // Store original open and send
    const originalOpen = xhr.open;
    const originalSend = xhr.send;

    let isVerifyCodeRequest = false;

    xhr.open = function(method, url) {
      // Check if this is a verification request
      if (url && url.includes('/VerifyCode')) {
        isVerifyCodeRequest = true;
      }
      return originalOpen.apply(xhr, arguments);
    };

    xhr.send = function() {
      if (isVerifyCodeRequest) {
        // Add event listener for when the request completes
        xhr.addEventListener('load', function() {
          // B2C returns 200 with error in the body, not 400 status
          if (xhr.status === 200 || xhr.status === 400) {
            try {
              const response = JSON.parse(xhr.responseText);

              // Check if the response contains an error (status 400 in the body)
              if (response.status === "400" && response.errorCode) {
                // Force the error to display after a short delay to let B2C process
                setTimeout(function() {
                  // Find the verification code input
                  const verificationCodeInput = document.getElementById('EmailVerification_ver_input') ||
                    document.getElementById('verificationCode');

                  if (verificationCodeInput) {
                    // Find the error div that's immediately before the verification code input
                    const errorDiv = verificationCodeInput.previousElementSibling;

                    if (errorDiv && errorDiv.classList.contains('error') && errorDiv.classList.contains('itemLevel')) {
                      // Set the error message
                      errorDiv.textContent = response.message;
                      errorDiv.style.display = 'block';
                      errorDiv.setAttribute('aria-hidden', 'false');
                      errorDiv.setAttribute('role', 'alert');
                      errorDiv.setAttribute('aria-label', response.message);
                    }
                  }

                  // Also update the page-level error
                  const fieldIncorrectError = document.getElementById('fieldIncorrect');
                  if (fieldIncorrectError) {
                    fieldIncorrectError.style.display = 'block';
                    fieldIncorrectError.setAttribute('aria-hidden', 'false');
                  }
                }, 100);
              } else if (response.status === "200" || !response.status) {
                // Successful verification - clear any errors
                setTimeout(function() {
                  // Clear the field-level error
                  const verificationCodeInput = document.getElementById('EmailVerification_ver_input') ||
                    document.getElementById('verificationCode');

                  if (verificationCodeInput) {
                    const errorDiv = verificationCodeInput.previousElementSibling;
                    if (errorDiv && errorDiv.classList.contains('error') && errorDiv.classList.contains('itemLevel')) {
                      errorDiv.textContent = '';
                      errorDiv.style.display = 'none';
                      errorDiv.setAttribute('aria-hidden', 'true');
                    }
                  }

                  // Clear the page-level error
                  const fieldIncorrectError = document.getElementById('fieldIncorrect');
                  if (fieldIncorrectError) {
                    fieldIncorrectError.style.display = 'none';
                    fieldIncorrectError.setAttribute('aria-hidden', 'true');
                  }
                }, 100);
              }
            } catch (e) {
              // Silently handle parsing errors
            }
          }
        });
      }

      return originalSend.apply(xhr, arguments);
    };

    return xhr;
  };
}

// Initialize when DOM is ready
function initialize() {
  moveForgotPassword();
  moveRetryCode();
  addTsAndCsLink();
  addPasswordCriteria();
  lowerCaseEmailAddresses();
  removeAutofocus();
  addDescriptiveErrors();
  monitorVerificationErrors();
  interceptVerificationRequests();
  handleVerifyCodeClick();
}

// Initialize on DOM ready or immediately if DOM is already loaded
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initialize);
} else {
  initialize();
}

window.addEventListener('pageshow', removeAutofocus);
