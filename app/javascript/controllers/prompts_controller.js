import { Controller } from "@hotwired/stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = ["suggestions", "vectorSuggestions"]

  update(e) {
    if (e.target.value.length >= 3) {
      Rails.ajax({
        type: 'GET',
        url: '/prompts/search',
        data: new URLSearchParams({
          query: e.target.value
        }).toString(),
        success: (data) => {
          this.suggestionsTarget.innerHTML = data.length > 0 ? data.map(suggestion =>
            `<li>${suggestion.text} <span class="font-bold">${suggestion.score}</span></li>`
          ).join("") : 'No suggestions found.'
        },
        error: function(err) {
          console.log(err);
        }
      });

      Rails.ajax({
        type: 'GET',
        url: '/prompts/search',
        data: new URLSearchParams({
          query: e.target.value,
          type: 'vector'
        }).toString(),
        success: (data) => {
          console.log(this)
          this.vectorSuggestionsTarget.innerHTML = data.length > 0 ? data.map(suggestion =>
            `<li>${suggestion.text} <span class="font-bold">${suggestion.score}</span></li>`
          ).join("") : 'No suggestions found.'
        },
        error: function(err) {
          console.log(err);
        }
      });
    }
  }
}
