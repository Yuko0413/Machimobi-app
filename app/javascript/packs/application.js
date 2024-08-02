// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener('turbolinks:load', () => {
    const showModalButton = document.getElementById('showQrModal');
    const showModalLink = document.getElementById('showQrModalLink');
    const modal = document.getElementById('qrModal');
    const closeModal = document.getElementsByClassName('close')[0];
  
    if (showModalButton) {
      showModalButton.onclick = function() {
        modal.style.display = 'block';
      };
    }
  
    if (showModalLink) {
      showModalLink.onclick = function(event) {
        event.preventDefault();
        modal.style.display = 'block';
      };
    }
  
    if (closeModal) {
      closeModal.onclick = function() {
        modal.style.display = 'none';
      };
    }
  
    window.onclick = function(event) {
      if (event.target === modal) {
        modal.style.display = 'none';
      }
    };
  });
  
