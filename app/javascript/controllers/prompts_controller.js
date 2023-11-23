import { Controller } from "@hotwired/stimulus"
import Rails from '@rails/ujs';

export default class extends Controller {
  static targets = ["suggestions", "vectorSuggestions"]

  update(e) {
    this.#searchSuggestions(e.target.value, this.suggestionsTarget)
    this.#searchSuggestions(e.target.value, this.vectorSuggestionsTarget, 'vector')
  }

  #searchSuggestions(query, target, vector = false) {
    if (query.length >= 3) {
      Rails.ajax({
        type: 'GET',
        url: '/prompts/search',
        data: new URLSearchParams({
          query: query,
          type: vector ? 'vector' : ''
        }).toString(),
        success: (data) => {
          target.innerHTML = data.length > 0 ? data.map(suggestion =>
            `<li>${suggestion.text} <span class="font-bold">${suggestion.score}</span></li>`
          ).join("") : "No suggestions found."
        },
        error: function(err) {
          console.log(err);
        }
      });
    } else {
      target.innerHTML = "No suggestions found."
    }
  }

}
